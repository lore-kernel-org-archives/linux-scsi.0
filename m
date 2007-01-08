From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI core: display sdev->scsi_level correctly
Date: Mon, 8 Jan 2007 11:07:41 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0701081106540.4249-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:60254 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1161335AbXAHQOX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jan 2007 11:14:23 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

This patch (as833) fixes the "SCSI revision" output for
/proc/scsi/scsi.  If the scsi_level value is 0 (UNKNOWN), we want it
to show up as "0", not "ffffffff".

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

Index: usb-2.6/drivers/scsi/scsi_proc.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_proc.c
+++ usb-2.6/drivers/scsi/scsi_proc.c
@@ -179,9 +179,8 @@ static int proc_print_scsidevice(struct 
 	seq_printf(s, "\n");
 
 	seq_printf(s, "  Type:   %s ", scsi_device_type(sdev->type));
-	seq_printf(s, "               ANSI"
-		     " SCSI revision: %02x", (sdev->scsi_level - 1) ?
-		     sdev->scsi_level - 1 : 1);
+	seq_printf(s, "               ANSI  SCSI revision: %02x",
+			sdev->scsi_level - (sdev->scsi_level > 1));
 	if (sdev->scsi_level == 2)
 		seq_printf(s, " CCS\n");
 	else

