From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] Recognize missing LUNs for non-standard devices
Date: Thu, 9 Feb 2006 15:26:18 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0602091509340.6892-100000@iolanthe.rowland.org>
References: <43E8BF50.70800@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:6320 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1750768AbWBIU0U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 15:26:20 -0500
In-Reply-To: <43E8BF50.70800@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Brian King <brking@us.ibm.com>, David Wysochanski <davidw@netapp.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

Some non-standard SCSI targets or protocols, such as USB UFI, report "no
LUN present" by setting the Peripheral Device Type to 0x1f and the
Peripheral Qualifier to 0 (not 3 as the standard requires) in the INQUIRY
response.  This patch (as650b) adds a new target flag and code to
accomodate such targets.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

This is a revised version of an earlier patch.  By adding a new flag to
the target structure, this version can avoid any conflicts with devices
that use PDT = 0x1f to represent a legitimate LUN.

After this patch has been merged, I will add code to the usb-storage 
slave_alloc routine to set the pdt_1f_for_no_lun flag for all devices 
using the UFI protocol.

Alan Stern

Index: usb-2.6/drivers/scsi/scsi_scan.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_scan.c
+++ usb-2.6/drivers/scsi/scsi_scan.c
@@ -873,6 +873,19 @@ static int scsi_probe_and_add_lun(struct
 		goto out_free_result;
 	}
 
+	/*
+	 * Non-standard SCSI targets may set the PDT to 0x1f (unknown or
+	 * no device type) instead of using the Peripheral Qualifier to
+	 * indicate that no LUN is present.  For example, USB UFI does this.
+	 */
+	if (starget->pdt_1f_for_no_lun && (result[0] & 0x1f) == 0x1f) {
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
Index: usb-2.6/include/scsi/scsi_device.h
===================================================================
--- usb-2.6.orig/include/scsi/scsi_device.h
+++ usb-2.6/include/scsi/scsi_device.h
@@ -167,7 +167,10 @@ struct scsi_target {
 	unsigned int		channel;
 	unsigned int		id; /* target id ... replace
 				     * scsi_device.id eventually */
-	unsigned long		create:1; /* signal that it needs to be added */
+	unsigned int		create:1; /* signal that it needs to be added */
+	unsigned int		pdt_1f_for_no_lun;	/* PDT = 0x1f */
+						/* means no lun present */
+
 	char			scsi_level;
 	void 			*hostdata; /* available to low-level driver */
 	unsigned long		starget_data[0]; /* for the transport */

