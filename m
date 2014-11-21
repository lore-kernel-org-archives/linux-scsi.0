From: Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH] uas: Add no-uas quirk for Hitachi usb-3 enclosures 4971:1012
Date: Fri, 21 Nov 2014 13:28:03 +0100
Message-ID: <1416572883-16465-1-git-send-email-hdegoede@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751596AbaKUM2H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 07:28:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>, stable@vger.kernel.org.#.3.16

These disks have a broken uas implementation, the tag field of the status
iu-s is not set properly, so we need to fall-back to usb-storage for these.

Cc: stable@vger.kernel.org # 3.16
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/storage/unusual_uas.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
index 2fefaf9..18a283d 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -103,3 +103,10 @@ UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
 		"VL711",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_ATA_1X),
+
+/* Reported-by: Hans de Goede <hdegoede@redhat.com> */
+UNUSUAL_DEV(0x4971, 0x1012, 0x0000, 0x9999,
+		"Hitachi",
+		"External HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
-- 
2.1.0

