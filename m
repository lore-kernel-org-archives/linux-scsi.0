From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] Recognize missing LUNs for non-standard devices
Date: Mon, 6 Feb 2006 16:59:36 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0602061649070.17052-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:25012 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S932162AbWBFV7i
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Feb 2006 16:59:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Some protocols (like USB UFI) or devices that don't adhere to the SCSI
standard may indicate a nonexistent LUN by returning INQUIRY information
with Peripheral Device Type set to 0x1f (unknown or none) and Peripheral
Qualifier set to 0 instead of 3 as the spec requires.  This patch (as650)
causes PDT = 0x1f to be recognized as no LUN present regardless of the
qualifier value, if the SCSI level is equal to 0.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---
James:

Since nobody objected when I proposed this last week, I'm now submitting 
it as a real patch.

Alan Stern


Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -873,6 +873,19 @@ static int scsi_probe_and_add_lun(struct
 		goto out_free_result;
 	}
 
+	/*
+	 * Non-standard SCSI devices may set the PDT to 0x1f (unknown or
+	 * no device type) instead of using the peripheral qualifier to
+	 * indicate that no LUN is present.  For example, USB UFI does this.
+	 */
+	if (sdev->scsi_level == 0 && (result[0] & 0x1f) == 0x1f) {
+		SCSI_LOG_SCAN_BUS(3, printk(KERN_INFO
+					"scsi scan: peripheral device type"
+					" of 31, no device added\n"));
+		res = SCSI_SCAN_TARGET_PRESENT;
+		goto out_free_result;
+	}
+
 	res = scsi_add_lun(sdev, result, &bflags);
 	if (res == SCSI_SCAN_LUN_PRESENT) {
 		if (bflags & BLIST_KEY) {

