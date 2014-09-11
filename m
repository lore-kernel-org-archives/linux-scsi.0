From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] uas: Add missing le16_to_cpu calls to asm1051 / asm1053 usb-id check
Date: Thu, 11 Sep 2014 11:06:12 +0200
Message-ID: <1410426372-10151-1-git-send-email-hdegoede@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Cc: stable@vger.kernel.org # 3.16
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas-detect.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
index 1e298ec..8a6f371 100644
--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -73,8 +73,8 @@ static int uas_use_uas_driver(struct usb_interface *intf,
 	 * broken on the ASM1051, use the number of streams to differentiate.
 	 * New ASM1053-s also support 32 streams, but have a different prod-id.
 	 */
-	if (udev->descriptor.idVendor == 0x174c &&
-			udev->descriptor.idProduct == 0x55aa) {
+	if (le16_to_cpu(udev->descriptor.idVendor) == 0x174c &&
+			le16_to_cpu(udev->descriptor.idProduct) == 0x55aa) {
 		if (udev->speed < USB_SPEED_SUPER) {
 			/* No streams info, assume ASM1051 */
 			flags |= US_FL_IGNORE_UAS;
-- 
2.1.0
