From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] megaraid_sas: fix extended timeout handling
Date: Fri, 10 Mar 2006 17:08:57 +0100
Message-ID: <20060310160857.GA10856@lst.de>
References: <20060206141452.GA2681@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:20931 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1751681AbWCJQJR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Mar 2006 11:09:17 -0500
Content-Disposition: inline
In-Reply-To: <20060206141452.GA2681@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreenivas.Bagalkote@lsil.com, Sumant.Patro@lsil.com
Cc: linux-scsi@vger.kernel.org

On Mon, Feb 06, 2006 at 03:14:52PM +0100, Christoph Hellwig wrote:
> Replace the eh_timed_out method usage with setting sdev->timeout in
> slave_configure.  Also only use the extended timeout for raid volumes,
> physical devices shouldn't need it.
> 
> Applies ontop of the previous physical device attachment fix which
> introduces megasas_slave_configure.

Here's a resend against current mainline.  Note that scsi-misc is
missing the hidep physical disks patch so it needs another mainline
merge before this patch applies.


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.c
===================================================================
--- scsi-misc-2.6.orig/drivers/scsi/megaraid/megaraid_sas.c	2006-03-10 11:58:06.000000000 +0100
+++ scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.c	2006-03-10 11:59:35.000000000 +0100
@@ -772,8 +772,6 @@
 		goto out_return_cmd;
 
 	cmd->scmd = scmd;
-	scmd->SCp.ptr = (char *)cmd;
-	scmd->SCp.sent_command = jiffies;
 
 	/*
 	 * Issue the command to the FW
@@ -804,6 +802,12 @@
 	 */
 	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS && sdev->type == TYPE_DISK)
 		return -ENXIO;
+
+	/*
+	 * The RAID firmware may require extended timeouts.
+	 */
+	if (sdev->channel >= MEGASAS_MAX_PD_CHANNELS)
+		sdev->timeout = 90 * HZ;
 	return 0;
 }
 
@@ -875,23 +879,6 @@
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
@@ -962,7 +949,6 @@
 	.eh_device_reset_handler = megasas_reset_device,
 	.eh_bus_reset_handler = megasas_reset_bus_host,
 	.eh_host_reset_handler = megasas_reset_bus_host,
-	.eh_timed_out = megasas_reset_timer,
 	.use_clustering = ENABLE_CLUSTERING,
 };
 
