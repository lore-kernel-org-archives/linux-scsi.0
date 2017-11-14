From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] uas: Always apply US_FL_NO_ATA_1X quirk to Seagate devices
Date: Tue, 14 Nov 2017 19:27:22 +0100
Message-ID: <20171114182722.28104-1-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:27073 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754443AbdKNS1d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Nov 2017 13:27:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.com>, Alan Stern <stern@rowland.harvard.edu>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

We've been adding this as a quirk on a per device basis hoping that
newer disk enclosures would do better, but that has not happened,
so simply apply this quirk to all Seagate devices.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/uas-detect.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/storage/uas-detect.h b/drivers/usb/storage/uas-detect.h
index a155cd02bce2..ecc83c405a8b 100644
--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -111,6 +111,10 @@ static int uas_use_uas_driver(struct usb_interface *intf,
 		}
 	}
 
+	/* All Seagate disk enclosures have broken ATA pass-through support */
+	if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bc2)
+		flags |= US_FL_NO_ATA_1X;
+
 	usb_stor_adjust_quirks(udev, &flags);
 
 	if (flags & US_FL_IGNORE_UAS) {
-- 
2.14.3
