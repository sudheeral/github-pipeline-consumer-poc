#!/usr/bin/env bash
set -euo pipefail

# Build script expected by the PDP pipeline framework.
# Must export APP_VERSION after a successful build.

echo "=== Installing dependencies ==="
npm ci

echo "=== Building Next.js app ==="
npm run build

# Version: package.json version + short git SHA
PKG_VERSION=$(node -p "require('./package.json').version")
GIT_SHA=$(git rev-parse --short HEAD 2>/dev/null || echo "local")
export APP_VERSION="${PKG_VERSION}-${GIT_SHA}"

echo "APP_VERSION=${APP_VERSION}"

# Write to GITHUB_ENV so the calling workflow step can read it
if [ -n "${GITHUB_ENV:-}" ]; then
  echo "APP_VERSION=${APP_VERSION}" >> "$GITHUB_ENV"
fi
