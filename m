From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] megaraid_sas: fix extended timeout handling
Date: Mon, 6 Feb 2006 15:14:52 +0100
Message-ID: <20060206141452.GA2681@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:64220 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S932120AbWBFOO7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2006 09:14:59 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreenivas.Bagalkote@lsil.com, Sumant.Patro@lsil.com
Cc: linux-scsi@vger.kernel.org

Replace the eh_timed_out method usage with setting sdev->timeout in
slave_configure.  Also only use the extended timeout for raid volumes,
physical devices shouldn't need it.

Applies ontop of the previous physical device attachment fix which
introduces megasas_slave_configure.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: linux-2.6/drivers/scsi/megaraid/megaraid_sas.c
===================================================================
--- linux-2.6.orig/drivers/scsi/megaraid/megaraid_sas.c	2006-02-06 14:59:13.000000000 +0100
+++ linux-2.6/drivers/scsi/megaraid/megaraid_sas.c	2006-02-06 15:11:43.000000000 +0100
@@ -686,8 +686,6 @@
 		goto out_return_cmd;
 
 	cmd->scmd = scmd;
-	scmd->SCp.ptr = (char *)cmd;
-	scmd->SCp.sent_command = jiffies;
 
 	/*
 	 * Issue the command to the FW
@@ -714,6 +712,12 @@
 	 */
 	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS && sdev->type == TYPE_DISK)
 		sdev->no_uld_attach = 1;
+
+	/*
+	 * The RAID firmware may require extended timeouts.
+	 */
+	if (sdev->channel >= MEGASAS_MAX_PD_CHANNELS)
+		sdev->timeout = 90 * HZ;
 	return 0;
 }
 
@@ -785,23 +789,6 @@
 	return ret_val;
 }
 
-static enum scsi_eh_timer_return megasas_reset_timer(struct scsi_cmnd *scmd)
-{
-	unsigned long seconds;
-
-	if (scmd->SCp.ptr) {
-		seconds = (jiffies - scmd->SCp.sent_command) / HZ;
-
-		if (seconds < 90) {
-			return EH_RESET_TIMER;
-		} else {
-			return EH_NOT_HANDLED;
-		}
-	}
-
-	return EH_HANDLED;
-}
-
 /**
  * megasas_reset_device -	Device reset handler entry point
  */
@@ -872,7 +859,6 @@
 	.eh_device_reset_handler = megasas_reset_device,
 	.eh_bus_reset_handler = megasas_reset_bus_host,
 	.eh_host_reset_handler = megasas_reset_bus_host,
-	.eh_timed_out = megasas_reset_timer,
 	.use_clustering = ENABLE_CLUSTERING,
 };
 
@@ -976,10 +962,6 @@
 	struct megasas_header *hdr = &cmd->frame->hdr;
 	unsigned long flags;
 
-	if (cmd->scmd) {
-		cmd->scmd->SCp.ptr = (char *)0;
-	}
-
 	switch (hdr->cmd) {
 
 	case MFI_CMD_PD_SCSI_IO:
