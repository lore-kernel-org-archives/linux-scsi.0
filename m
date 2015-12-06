From: Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH v2 15/72] ncr5380: Always escalate bad target time-out in NCR5380_select()
Date: Sun, 06 Dec 2015 12:31:41 +1100
Message-ID: <20151206013130.685522961@telegraphics.com.au>
References: <20151206013126.995379403@telegraphics.com.au>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:53118 "EHLO
	kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754165AbbLFDn7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Dec 2015 22:43:59 -0500
Content-Disposition: inline; filename=ncr5380-escalate-selection-timeout
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Remove the restart_select and targets_present variables introduced in
Linux v1.1.38. The former was used only for a questionable debug printk
and the latter "so we can call a select failure a retryable condition".
Well, retrying select failure in general is a different problem to a
target that doesn't assert BSY. We need to handle these two cases
differently; the latter case can be left to the SCSI ML.

Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Reviewed-by: Hannes Reinecke <hare@suse.com>

---
 drivers/scsi/NCR5380.c       |   13 -------------
 drivers/scsi/NCR5380.h       |    6 ------
 drivers/scsi/atari_NCR5380.c |   13 -------------
 3 files changed, 32 deletions(-)

Index: linux/drivers/scsi/NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/NCR5380.c	2015-12-06 12:29:42.000000000 +1100
+++ linux/drivers/scsi/NCR5380.c	2015-12-06 12:29:44.000000000 +1100
@@ -790,7 +790,6 @@ static int NCR5380_init(struct Scsi_Host
 #ifdef REAL_DMA
 	hostdata->dmalen = 0;
 #endif
-	hostdata->targets_present = 0;
 	hostdata->connected = NULL;
 	hostdata->issue_queue = NULL;
 	hostdata->disconnected_queue = NULL;
@@ -1186,8 +1185,6 @@ static int NCR5380_select(struct Scsi_Ho
 	if (hostdata->selecting)
 		goto part2;
 
-	hostdata->restart_select = 0;
-
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dprintk(NDEBUG_ARBITRATION, "scsi%d : starting arbitration, id = %d\n", instance->host_no, instance->this_id);
 
@@ -1363,21 +1360,12 @@ part2:
 
 	if (!(NCR5380_read(STATUS_REG) & SR_BSY)) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		if (hostdata->targets_present & (1 << scmd_id(cmd))) {
-			printk(KERN_DEBUG "scsi%d : weirdness\n", instance->host_no);
-			if (hostdata->restart_select)
-				printk(KERN_DEBUG "\trestart select\n");
-			NCR5380_dprint(NDEBUG_SELECTION, instance);
-			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-			return -1;
-		}
 		cmd->result = DID_BAD_TARGET << 16;
 		cmd->scsi_done(cmd);
 		NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
 		dprintk(NDEBUG_SELECTION, "scsi%d : target did not respond within 250ms\n", instance->host_no);
 		return 0;
 	}
-	hostdata->targets_present |= (1 << scmd_id(cmd));
 
 	/*
 	 * Since we followed the SCSI spec, and raised ATN while SEL 
@@ -2382,7 +2370,6 @@ static void NCR5380_reselect(struct Scsi
 	 */
 
 	NCR5380_write(MODE_REG, MR_BASE);
-	hostdata->restart_select = 1;
 
 	target_mask = NCR5380_read(CURRENT_SCSI_DATA_REG) & ~(hostdata->id_mask);
 	dprintk(NDEBUG_SELECTION, "scsi%d : reselect\n", instance->host_no);
Index: linux/drivers/scsi/atari_NCR5380.c
===================================================================
--- linux.orig/drivers/scsi/atari_NCR5380.c	2015-12-06 12:29:42.000000000 +1100
+++ linux/drivers/scsi/atari_NCR5380.c	2015-12-06 12:29:44.000000000 +1100
@@ -826,7 +826,6 @@ static int __init NCR5380_init(struct Sc
 #if defined (REAL_DMA)
 	hostdata->dma_len = 0;
 #endif
-	hostdata->targets_present = 0;
 	hostdata->connected = NULL;
 	hostdata->issue_queue = NULL;
 	hostdata->disconnected_queue = NULL;
@@ -1409,7 +1408,6 @@ static int NCR5380_select(struct Scsi_Ho
 	unsigned long timeout;
 	unsigned long flags;
 
-	hostdata->restart_select = 0;
 	NCR5380_dprint(NDEBUG_ARBITRATION, instance);
 	dprintk(NDEBUG_ARBITRATION, "scsi%d: starting arbitration, id = %d\n", HOSTNO,
 		   instance->this_id);
@@ -1625,14 +1623,6 @@ static int NCR5380_select(struct Scsi_Ho
 
 	if (!(NCR5380_read(STATUS_REG) & SR_BSY)) {
 		NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		if (hostdata->targets_present & (1 << cmd->device->id)) {
-			printk(KERN_ERR "scsi%d: weirdness\n", HOSTNO);
-			if (hostdata->restart_select)
-				printk(KERN_NOTICE "\trestart select\n");
-			NCR5380_dprint(NDEBUG_ANY, instance);
-			NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-			return -1;
-		}
 		cmd->result = DID_BAD_TARGET << 16;
 #ifdef SUPPORT_TAGS
 		cmd_free_tag(cmd);
@@ -1643,8 +1633,6 @@ static int NCR5380_select(struct Scsi_Ho
 		return 0;
 	}
 
-	hostdata->targets_present |= (1 << cmd->device->id);
-
 	/*
 	 * Since we followed the SCSI spec, and raised ATN while SEL
 	 * was true but before BSY was false during selection, the information
@@ -2605,7 +2593,6 @@ static void NCR5380_reselect(struct Scsi
 	 */
 
 	NCR5380_write(MODE_REG, MR_BASE);
-	hostdata->restart_select = 1;
 
 	target_mask = NCR5380_read(CURRENT_SCSI_DATA_REG) & ~(hostdata->id_mask);
 
Index: linux/drivers/scsi/NCR5380.h
===================================================================
--- linux.orig/drivers/scsi/NCR5380.h	2015-12-06 12:29:39.000000000 +1100
+++ linux/drivers/scsi/NCR5380.h	2015-12-06 12:29:44.000000000 +1100
@@ -257,9 +257,6 @@ struct NCR5380_hostdata {
 	NCR5380_implementation_fields;		/* implementation specific */
 	struct Scsi_Host *host;			/* Host backpointer */
 	unsigned char id_mask, id_higher_mask;	/* 1 << id, all bits greater */
-	unsigned char targets_present;		/* targets we have connected
-						   to, so we can call a select
-						   failure a retryable condition */
 	volatile unsigned char busy[8];		/* index = target, bit = lun */
 #if defined(REAL_DMA) || defined(REAL_DMA_POLL)
 	volatile int dma_len;			/* requested length of DMA */
@@ -268,9 +265,6 @@ struct NCR5380_hostdata {
 	volatile struct scsi_cmnd *connected;	/* currently connected command */
 	volatile struct scsi_cmnd *issue_queue;	/* waiting to be issued */
 	volatile struct scsi_cmnd *disconnected_queue;	/* waiting for reconnect */
-	volatile int restart_select;		/* we have disconnected,
-						   used to restart 
-						   NCR5380_select() */
 	int flags;
 	unsigned long time_expires;		/* in jiffies, set prior to sleeping */
 	int select_time;			/* timer in select for target response */


