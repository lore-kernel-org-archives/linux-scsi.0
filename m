From: Alan Stern <stern@rowland.harvard.edu>
Subject: RFC: SCSI-0 test for no LUN
Date: Tue, 31 Jan 2006 16:53:59 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0601311650430.994-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:32233 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751550AbWAaVyI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2006 16:54:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>
Cc: USB Storage list <usb-storage@lists.one-eyed-alien.net>

Does anyone object to the patch below?  The only way it could cause
trouble would be if someone had a SCSI-0 device that reported a PDT of 31,
which normally would indicate no LUN present.

Alan Stern



Index: l2616/drivers/scsi/scsi_scan.c
===================================================================
--- l2616.orig/drivers/scsi/scsi_scan.c
+++ l2616/drivers/scsi/scsi_scan.c
@@ -877,6 +877,19 @@ static int scsi_probe_and_add_lun(struct
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

