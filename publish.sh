#!/bin/bash

npm update

VERSION=$(node --eval "console.log(require('./package.json').version);")

grunt build

npm test || exit 1

echo "Ready to publish plugin version $VERSION."
echo "Has the version number been bumped?"
read -n1 -r -p "Press Ctrl+C to cancel, or any other key to continue." key

git checkout -b build

export NODE_ENV=release

echo "Creating git tag v$VERSION..."

git add dist/leaflet-wfst.src.js dist/leaflet-wfst.min.js -f

git commit -m "v$VERSION"

git tag v$VERSION
git push --tags

echo "Publish to npm?"
read -n1 -r -p "Press Ctrl+C to cancel, or any other key to continue." key

npm publish

git checkout master
git branch -D build

echo "All done."