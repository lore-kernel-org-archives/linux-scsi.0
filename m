From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH] SCSI: make use of the residue value
Date: Wed, 20 Feb 2008 16:26:51 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802201625230.9464-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42957 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754611AbYBTV0x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Feb 2008 16:26:53 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

This patch (as1036) causes the SCSI midlayer to take into account the
residue value provided by some low-level drivers.  There's at least
one situation (USB mass storage with the Bulk-only transport) where
the specification states that it is permissible for a device to
indicate some of the data was not transferred correctly merely by
setting the residue value, without issuing a Check Condition.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Boaz Harrosh <bharrosh@panasas.com>

---

Index: usb-2.6/drivers/scsi/scsi.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi.c
+++ usb-2.6/drivers/scsi/scsi.c
@@ -732,6 +732,7 @@ void scsi_finish_command(struct scsi_cmn
 	struct Scsi_Host *shost = sdev->host;
 	struct scsi_driver *drv;
 	unsigned int good_bytes;
+	unsigned int non_residue_bytes;
 
 	scsi_device_unbusy(sdev);
 
@@ -758,11 +759,16 @@ void scsi_finish_command(struct scsi_cmn
 				"(result %x)\n", cmd->result));
 
 	good_bytes = scsi_bufflen(cmd);
+	non_residue_bytes = good_bytes - scsi_get_resid(cmd);
         if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
 		drv = scsi_cmd_to_driver(cmd);
 		if (drv->done)
 			good_bytes = drv->done(cmd);
 	}
+
+	/* If the device sent a meaningful residue, accept it. */
+	if (unlikely(non_residue_bytes < good_bytes))
+		good_bytes = non_residue_bytes;
 	scsi_io_completion(cmd, good_bytes);
 }
 EXPORT_SYMBOL(scsi_finish_command);

