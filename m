From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI core: always store >= 36 bytes of INQUIRY data
Date: Thu, 26 Oct 2006 17:11:27 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0610261709360.9684-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:24079 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1423670AbWJZVL2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Oct 2006 17:11:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as810) sets the length of the INQUIRY data to a minimum of
36 bytes, even if the device claims that not all of them are valid.
Using the data sent by the device is better than allocating a short
buffer and then reading beyond the end of it, which is what we do now.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -575,6 +575,19 @@ static int scsi_probe_lun(struct scsi_de
 	 * short INQUIRY), an abort here prevents any further use of the
 	 * device, including spin up.
 	 *
+	 * On the whole, the best approach seems to be to assume the first
+	 * 36 bytes are valid no matter what the device says.  That's
+	 * better than copying < 36 bytes to the inquiry-result buffer
+	 * and displaying garbage for the Vendor, Product, and Revision
+	 * strings.
+	 */
+	if (sdev->inquiry_len < 36) {
+		printk(KERN_INFO "scsi scan: INQUIRY result too short (%d),"
+				" using 36\n", sdev->inquiry_len);
+		sdev->inquiry_len = 36;
+	}
+
+	/*
 	 * Related to the above issue:
 	 *
 	 * XXX Devices (disk or all?) should be sent a TEST UNIT READY,

