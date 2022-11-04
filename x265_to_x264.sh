#!/usr/bin/env bash

PROGNAME=$(basename "$0")

usage() {
echo "Script description"
echo
echo "Usage: $PROGNAME <video file>"
echo
echo "Options:"
echo
echo "  -h, --help"
echo "      This help text."
echo
}

VIDEO_FILE_PATH=$1

if [[ -z "$VIDEO_FILE_PATH" ]]; then
usage
exit 1
fi

while [ "$#" -gt 0 ]
do
    case "$1" in
    -h|--help)
        usage
        exit 0
        ;;
    --)
        break
        ;;
    -*)
        echo "Invalid option '$1'. Use --help to see the valid options" >&2
        exit 1
        ;;
    # an option argument, continue
    *)	;;
    esac
    shift
done

VIDEO_FILE_NAME=$(basename -- "$VIDEO_FILE_PATH")
VIDEO_FILE_EXTENSION="${VIDEO_FILE_NAME##*.}"
VIDEO_FILE_NO_EXTENSION="${VIDEO_FILE_NAME%.*}"
OUTPUT_FILE="${VIDEO_FILE_NO_EXTENSION}.x264.${VIDEO_FILE_EXTENSION}"

if grep -q BCM2835 /proc/cpuinfo
then # Raspberry Pi 4 Model B
    ENCODER_PARAMS="-c:v h264 -pix_fmt yuv420p"
else
    ENCODER_PARAMS="-c:v libx264"
fi

#echo PROGNAME=$PROGNAME
#echo VIDEO_FILE_PATH=$VIDEO_FILE_PATH
#echo VIDEO_FILE_NAME=$VIDEO_FILE_NAME
#echo VIDEO_FILE_EXTENSION=$VIDEO_FILE_EXTENSION
#echo VIDEO_FILE_NO_EXTENSION=$VIDEO_FILE_NO_EXTENSION
#echo OUTPUT_FILE=$OUTPUT_FILE

echo ""
echo "Converting ${VIDEO_FILE_PATH}"
echo "  - encoder: '$ENCODER_CODEC'"
echo "    Run 'ffmpeg -codecs' to get the list of codecs."
echo "  - output: '$OUTPUT_FILE' on current dir"
echo ""

ffmpeg -i "${VIDEO_FILE_PATH}" ${ENCODER_PARAMS} "${OUTPUT_FILE}"
