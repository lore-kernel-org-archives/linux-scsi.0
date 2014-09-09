From: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] uas: Disable uas on ASM1051 devices
Date: Tue,  9 Sep 2014 17:00:00 +0200
Message-ID: <1410274800-11578-3-git-send-email-hdegoede@redhat.com>
References: <1410274800-11578-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1410274800-11578-1-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Even with REPORT SUPPORTED OPERATION CODES blacklisted the ASM1051 chipset
still does not work when combined with some disks, e.g. a Crucial M500 ssd.

When used with a troublesome disk, the chipset throws all kinds of USB errors,
and eventually hangs, where as in BOT mode it works fine.

To make matters worse the ASM1051 chipset and older versions of the ASM1053
chipset use the same usb-id.

When connected over USB-3 the 2 can be told apart by the number of streams
they support. So this patch adds some less then pretty code to disable uas for
the ASM1051. When connected over USB-2, simply disable uas alltogether for
devices with the shared usb-id.

This ends up disabling uas in many cases where it actually works fine, which
is unfortunate, but better then leaving some users with completely non working
external disks. This patch adds a log level explaining how perfomance conscious
users can re-enable uas.

Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.16
Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/usb/storage/uas-detect.h | 34 ++++++++++++++++++++++++++++++----
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
index 503ac5c..3119f3f 100644
--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -59,10 +59,6 @@ static int uas_use_uas_driver(struct usb_interface *intf,
 	unsigned long flags = id->driver_info;
 	int r, alt;
 
-	usb_stor_adjust_quirks(udev, &flags);
-
-	if (flags & US_FL_IGNORE_UAS)
-		return 0;
 
 	alt = uas_find_uas_alt_setting(intf);
 	if (alt < 0)
@@ -72,6 +68,36 @@ static int uas_use_uas_driver(struct usb_interface *intf,
 	if (r < 0)
 		return 0;
 
+	/*
+	 * ASM1051 and older ASM1053 devices have the same usb-id, and UAS is
+	 * broken with some disks on the ASM1051, use the number of streams to
+	 * differentiate between the 2. Newer ASM1053 devices also support 32
+	 * streams, but have a different product-id.
+	 */
+	if (udev->descriptor.idVendor == 0x174c &&
+			udev->descriptor.idProduct == 0x55aa) {
+		if (udev->speed < USB_SPEED_SUPER) {
+			/* No streams info, assume ASM1051E */
+			dev_warn(&udev->dev, "Assuming ASM1051E chipset\n");
+			flags |= US_FL_IGNORE_UAS;
+		} else if (usb_ss_max_streams(&eps[1]->ss_ep_comp) == 32) {
+			dev_warn(&udev->dev, "Detected ASM1051E chipset\n");
+			flags |= US_FL_IGNORE_UAS;
+		}
+	}
+
+	usb_stor_adjust_quirks(udev, &flags);
+
+	if (flags & US_FL_IGNORE_UAS) {
+		dev_warn(&udev->dev,
+			"UAS does not work with this chipset with some disks, using usb-storage instead\n");
+		dev_warn(&udev->dev,
+			"Add 'usb-storage.quirks=%04x:%04x:' to the kernel commandline to try UAS anyways\n",
+			le16_to_cpu(udev->descriptor.idVendor),
+			le16_to_cpu(udev->descriptor.idProduct));
+		return 0;
+	}
+
 	if (udev->bus->sg_tablesize == 0) {
 		dev_warn(&udev->dev,
 			"The driver for the USB controller %s does not support scatter-gather which is\n",
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
