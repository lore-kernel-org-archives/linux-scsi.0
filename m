From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/5] scsi: Remove references to linked commands
Date: Thu,  2 Oct 2014 12:43:10 +0200
Message-ID: <1412246593-107001-3-git-send-email-hare@suse.de>
References: <1412246593-107001-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59426 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbaJBKnR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 2 Oct 2014 06:43:17 -0400
In-Reply-To: <1412246593-107001-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: James Bottomley <jbottomley@parallels.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>, Webb Scales <webbnh@hp.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Some NCR5380-based drivers implement support for linked commands
via a 'next_link' pointer in struct scsi_cmnd. This pointer has
long since removed, rendering the code pointless.
So remove it.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/NCR5380.c       | 40 -------------------------------
 drivers/scsi/atari_NCR5380.c | 57 --------------------------------------------
 drivers/scsi/sun3_NCR5380.c  | 57 --------------------------------------------
 3 files changed, 154 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index c8aa935..a0c8c5d 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -104,7 +104,6 @@
 #endif
 
 #ifndef notyet
-#undef LINKED
 #undef REAL_DMA
 #endif
 
@@ -216,8 +215,6 @@
  *      these transfers, we might need this to give reasonable interrupt
  *      service time if the transfer size gets too large.
  *
- * LINKED - if defined, linked commands are supported.
- *
  * PSEUDO_DMA - if defined, PSEUDO DMA is used during the data transfer phases.
  *
  * REAL_DMA - if defined, REAL DMA is used during the data transfer phases.
@@ -2210,43 +2207,6 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance) {
 				cmd->SCp.Message = tmp;
 
 				switch (tmp) {
-					/*
-					 * Linking lets us reduce the time required to get the
-					 * next command out to the device, hopefully this will
-					 * mean we don't waste another revolution due to the delays
-					 * required by ARBITRATION and another SELECTION.
-					 *
-					 * In the current implementation proposal, low level drivers
-					 * merely have to start the next command, pointed to by
-					 * next_link, done() is called as with unlinked commands.
-					 */
-#ifdef LINKED
-				case LINKED_CMD_COMPLETE:
-				case LINKED_FLG_CMD_COMPLETE:
-					/* Accept message by clearing ACK */
-					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %llu linked command complete.\n", instance->host_no, cmd->device->id, cmd->device->lun);
-					/*
-					 * Sanity check : A linked command should only terminate with
-					 * one of these messages if there are more linked commands
-					 * available.
-					 */
-					if (!cmd->next_link) {
-					    printk("scsi%d : target %d lun %llu linked command complete, no next_link\n" instance->host_no, cmd->device->id, cmd->device->lun);
-						sink = 1;
-						do_abort(instance);
-						return;
-					}
-					initialize_SCp(cmd->next_link);
-					/* The next command is still part of this process */
-					cmd->next_link->tag = cmd->tag;
-					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					dprintk(NDEBUG_LINKED, "scsi%d : target %d lun %llu linked request done, calling scsi_done().\n", instance->host_no, cmd->device->id, cmd->device->lun);
-					collect_stats(hostdata, cmd);
-					cmd->scsi_done(cmd);
-					cmd = hostdata->connected;
-					break;
-#endif				/* def LINKED */
 				case ABORT:
 				case COMMAND_COMPLETE:
 					/* Accept message by clearing ACK */
diff --git a/drivers/scsi/atari_NCR5380.c b/drivers/scsi/atari_NCR5380.c
index 79e6f04..d11c271 100644
--- a/drivers/scsi/atari_NCR5380.c
+++ b/drivers/scsi/atari_NCR5380.c
@@ -97,10 +97,6 @@
 #define REMOVE(w,x,y,z)
 #endif
 
-#ifndef notyet
-#undef LINKED
-#endif
-
 /*
  * Design
  * Issues :
@@ -211,8 +207,6 @@
  * AUTOSENSE - if defined, REQUEST SENSE will be performed automatically
  *	for commands that return with a CHECK CONDITION status.
  *
- * LINKED - if defined, linked commands are supported.
- *
  * REAL_DMA - if defined, REAL DMA is used during the data transfer phases.
  *
  * SUPPORT_TAGS - if defined, SCSI-2 tagged queuing is used where possible
@@ -2101,57 +2095,6 @@ static void NCR5380_information_transfer(struct Scsi_Host *instance)
 				cmd->SCp.Message = tmp;
 
 				switch (tmp) {
-				/*
-				 * Linking lets us reduce the time required to get the
-				 * next command out to the device, hopefully this will
-				 * mean we don't waste another revolution due to the delays
-				 * required by ARBITRATION and another SELECTION.
-				 *
-				 * In the current implementation proposal, low level drivers
-				 * merely have to start the next command, pointed to by
-				 * next_link, done() is called as with unlinked commands.
-				 */
-#ifdef LINKED
-				case LINKED_CMD_COMPLETE:
-				case LINKED_FLG_CMD_COMPLETE:
-					/* Accept message by clearing ACK */
-					NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-
-					dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %llu linked command "
-						   "complete.\n", HOSTNO, cmd->device->id, cmd->device->lun);
-
-					/* Enable reselect interrupts */
-					NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-					/*
-					 * Sanity check : A linked command should only terminate
-					 * with one of these messages if there are more linked
-					 * commands available.
-					 */
-
-					if (!cmd->next_link) {
-						 printk(KERN_NOTICE "scsi%d: target %d lun %llu "
-							"linked command complete, no next_link\n",
-							HOSTNO, cmd->device->id, cmd->device->lun);
-						sink = 1;
-						do_abort(instance);
-						return;
-					}
-
-					initialize_SCp(cmd->next_link);
-					/* The next command is still part of this process; copy it
-					 * and don't free it! */
-					cmd->next_link->tag = cmd->tag;
-					cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8);
-					dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %llu linked request "
-						   "done, calling scsi_done().\n",
-						   HOSTNO, cmd->device->id, cmd->device->lun);
-#ifdef NCR5380_STATS
-					collect_stats(hostdata, cmd);
-#endif
-					cmd->scsi_done(cmd);
-					cmd = hostdata->connected;
-					break;
-#endif /* def LINKED */
 				case ABORT:
 				case COMMAND_COMPLETE:
 					/* Accept message by clearing ACK */
diff --git a/drivers/scsi/sun3_NCR5380.c b/drivers/scsi/sun3_NCR5380.c
index 1a2367a..efdc555 100644
--- a/drivers/scsi/sun3_NCR5380.c
+++ b/drivers/scsi/sun3_NCR5380.c
@@ -84,10 +84,6 @@
 #define REMOVE(w,x,y,z)
 #endif
 
-#ifndef notyet
-#undef LINKED
-#endif
-
 /*
  * Design
  * Issues :
@@ -198,8 +194,6 @@
  * AUTOSENSE - if defined, REQUEST SENSE will be performed automatically
  *	for commands that return with a CHECK CONDITION status. 
  *
- * LINKED - if defined, linked commands are supported.
- *
  * REAL_DMA - if defined, REAL DMA is used during the data transfer phases.
  *
  * SUPPORT_TAGS - if defined, SCSI-2 tagged queuing is used where possible
@@ -2065,57 +2059,6 @@ static void NCR5380_information_transfer (struct Scsi_Host *instance)
 		cmd->SCp.Message = tmp;
 		
 		switch (tmp) {
-		/*
-		 * Linking lets us reduce the time required to get the 
-		 * next command out to the device, hopefully this will
-		 * mean we don't waste another revolution due to the delays
-		 * required by ARBITRATION and another SELECTION.
-		 *
-		 * In the current implementation proposal, low level drivers
-		 * merely have to start the next command, pointed to by 
-		 * next_link, done() is called as with unlinked commands.
-		 */
-#ifdef LINKED
-		case LINKED_CMD_COMPLETE:
-		case LINKED_FLG_CMD_COMPLETE:
-		    /* Accept message by clearing ACK */
-		    NCR5380_write(INITIATOR_COMMAND_REG, ICR_BASE);
-		    
-		    dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %llu linked command "
-			       "complete.\n", HOSTNO, cmd->device->id, cmd->device->lun);
-
-		    /* Enable reselect interrupts */
-		    NCR5380_write(SELECT_ENABLE_REG, hostdata->id_mask);
-		    /*
-		     * Sanity check : A linked command should only terminate
-		     * with one of these messages if there are more linked
-		     * commands available.
-		     */
-
-		    if (!cmd->next_link) {
-			 printk(KERN_NOTICE "scsi%d: target %d lun %llu "
-				"linked command complete, no next_link\n",
-				HOSTNO, cmd->device->id, cmd->device->lun);
-			    sink = 1;
-			    do_abort (instance);
-			    return;
-		    }
-
-		    initialize_SCp(cmd->next_link);
-		    /* The next command is still part of this process; copy it
-		     * and don't free it! */
-		    cmd->next_link->tag = cmd->tag;
-		    cmd->result = cmd->SCp.Status | (cmd->SCp.Message << 8); 
-		    dprintk(NDEBUG_LINKED, "scsi%d: target %d lun %llu linked request "
-			       "done, calling scsi_done().\n",
-			       HOSTNO, cmd->device->id, cmd->device->lun);
-#ifdef NCR5380_STATS
-		    collect_stats(hostdata, cmd);
-#endif
-		    cmd->scsi_done(cmd);
-		    cmd = hostdata->connected;
-		    break;
-#endif /* def LINKED */
 		case ABORT:
 		case COMMAND_COMPLETE: 
 		    /* Accept message by clearing ACK */
-- 
1.8.5.2

