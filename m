From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 12/24][RFC] 53c700: Use scsi_eh API for REQUEST_SENSE invocation
Date: Mon,  4 Feb 2008 19:05:26 +0200
Message-ID: <1202144726-4988-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:58731 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148AbYBDRLO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 12:11:14 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  - Use scsi_eh_prep/restor_cmnd() for synchronous
    REQUEST_SENSE invocation.
  - Refactor some code that is now commonly used in 2
    places.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
---
 drivers/scsi/53c700.c |  134 +++++++++++++++++--------------------------------
 drivers/scsi/53c700.h |   20 +++-----
 2 files changed, 54 insertions(+), 100 deletions(-)

diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index f5a9add..9b5c8d1 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -336,6 +336,8 @@ NCR_700_detect(struct scsi_host_template *tpnt,
 	if(tpnt->proc_name == NULL)
 		tpnt->proc_name = "53c700";
 
+	tpnt->sense_buffsize = SCSI_SENSE_BUFFERSIZE;
+
 	host = scsi_host_alloc(tpnt, 4);
 	if (!host)
 		return NULL;
@@ -578,6 +580,34 @@ save_for_reselection(struct NCR_700_Host_Parameters *hostdata,
 	hostdata->cmd = NULL;
 }
 
+STATIC void
+NCR_700_map(struct NCR_700_Host_Parameters *hostdata, struct scsi_cmnd *SCp,
+	      struct NCR_700_command_slot *slot, int move_ins)
+{
+	int i;
+	int sg_count;
+	struct scatterlist *sg;
+
+	sg_count = scsi_dma_map(SCp);
+	BUG_ON(sg_count < 0);
+
+	scsi_for_each_sg(SCp, sg, sg_count, i) {
+		dma_addr_t vPtr = sg_dma_address(sg);
+		__u32 count = sg_dma_len(sg);
+
+		slot->SG[i].ins = bS_to_host(move_ins | count);
+		DEBUG((" scatter block %d: move %d[%08x] from 0x%lx\n",
+		       i, count, slot->SG[i].ins, (unsigned long)vPtr));
+		slot->SG[i].pAddr = bS_to_host(vPtr);
+	}
+	slot->SG[i].ins = bS_to_host(SCRIPT_RETURN);
+	slot->SG[i].pAddr = 0;
+	dma_cache_sync(hostdata->dev, slot->SG, sizeof(slot->SG), DMA_TO_DEVICE);
+	DEBUG((" SETTING %08lx to %x\n",
+	       (&slot->pSG[i].ins),
+	       slot->SG[i].ins));
+}
+
 STATIC inline void
 NCR_700_unmap(struct NCR_700_Host_Parameters *hostdata, struct scsi_cmnd *SCp,
 	      struct NCR_700_command_slot *slot)
@@ -598,26 +628,18 @@ NCR_700_scsi_done(struct NCR_700_Host_Parameters *hostdata,
 		struct NCR_700_command_slot *slot = 
 			(struct NCR_700_command_slot *)SCp->host_scribble;
 		
-		dma_unmap_single(hostdata->dev, slot->pCmd,
-				 MAX_COMMAND_SIZE, DMA_TO_DEVICE);
+		NCR_700_unmap(hostdata, SCp, slot);
 		if (slot->flags == NCR_700_FLAG_AUTOSENSE) {
-			char *cmnd = NCR_700_get_sense_cmnd(SCp->device);
+			struct NCR_700_Device_Parameters *ndp =
+					NCR_700_Device_Parameters(SCp->device);
 #ifdef NCR_700_DEBUG
 			printk(" ORIGINAL CMD %p RETURNED %d, new return is %d sense is\n",
 			       SCp, SCp->cmnd[7], result);
 			scsi_print_sense("53c700", SCp);
 
 #endif
-			dma_unmap_single(hostdata->dev, slot->dma_handle,
-					 SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
-			/* restore the old result if the request sense was
-			 * successful */
-			if (result == 0)
-				result = cmnd[7];
-			/* restore the original length */
-			SCp->cmd_len = cmnd[8];
-		} else
-			NCR_700_unmap(hostdata, SCp, slot);
+			scsi_eh_restore_cmnd(SCp, &ndp->ses);
+		}
 
 		free_slot(slot, hostdata);
 #ifdef NCR_700_DEBUG
@@ -988,8 +1010,8 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 					"broken device is looping in contingent allegiance: ignoring\n");
 				NCR_700_scsi_done(hostdata, SCp, hostdata->status[0]);
 			} else {
-				char *cmnd =
-					NCR_700_get_sense_cmnd(SCp->device);
+				struct NCR_700_Device_Parameters *ndp =
+					NCR_700_Device_Parameters(SCp->device);
 #ifdef NCR_DEBUG
 				scsi_print_command(SCp);
 				printk("  cmd %p has status %d, requesting sense\n",
@@ -1007,32 +1029,14 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 						 MAX_COMMAND_SIZE,
 						 DMA_TO_DEVICE);
 
-				cmnd[0] = REQUEST_SENSE;
-				cmnd[1] = (SCp->device->lun & 0x7) << 5;
-				cmnd[2] = 0;
-				cmnd[3] = 0;
-				cmnd[4] = SCSI_SENSE_BUFFERSIZE;
-				cmnd[5] = 0;
-				/* Here's a quiet hack: the
-				 * REQUEST_SENSE command is six bytes,
-				 * so store a flag indicating that
-				 * this was an internal sense request
-				 * and the original status at the end
-				 * of the command */
-				cmnd[6] = NCR_700_INTERNAL_SENSE_MAGIC;
-				cmnd[7] = hostdata->status[0];
-				cmnd[8] = SCp->cmd_len;
-				SCp->cmd_len = 6; /* command length for
-						   * REQUEST_SENSE */
-				slot->pCmd = dma_map_single(hostdata->dev, cmnd, MAX_COMMAND_SIZE, DMA_TO_DEVICE);
-				slot->dma_handle = dma_map_single(hostdata->dev, SCp->sense_buffer, SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
-				slot->SG[0].ins = bS_to_host(SCRIPT_MOVE_DATA_IN | SCSI_SENSE_BUFFERSIZE);
-				slot->SG[0].pAddr = bS_to_host(slot->dma_handle);
-				slot->SG[1].ins = bS_to_host(SCRIPT_RETURN);
-				slot->SG[1].pAddr = 0;
+				scsi_eh_prep_cmnd(SCp, &ndp->ses, NULL, 0, ~0);
+				NCR_700_map(hostdata, SCp, slot,
+							SCRIPT_MOVE_DATA_IN);
+				slot->pCmd = dma_map_single(
+					       hostdata->dev, SCp->cmnd,
+					       MAX_COMMAND_SIZE, DMA_TO_DEVICE);
+
 				slot->resume_offset = hostdata->pScript;
-				dma_cache_sync(hostdata->dev, slot->SG, sizeof(slot->SG[0])*2, DMA_TO_DEVICE);
-				dma_cache_sync(hostdata->dev, SCp->sense_buffer, SCSI_SENSE_BUFFERSIZE, DMA_FROM_DEVICE);
 
 				/* queue the command for reissue */
 				slot->state = NCR_700_SLOT_QUEUED;
@@ -1041,27 +1045,6 @@ process_script_interrupt(__u32 dsps, __u32 dsp, struct scsi_cmnd *SCp,
 				hostdata->cmd = NULL;
 			}
 		} else {
-			// Currently rely on the mid layer evaluation
-			// of the tag queuing capability
-			//
-			//if(status_byte(hostdata->status[0]) == GOOD &&
-			//   SCp->cmnd[0] == INQUIRY && SCp->use_sg == 0) {
-			//	/* Piggy back the tag queueing support
-			//	 * on this command */
-			//	dma_sync_single_for_cpu(hostdata->dev,
-			//			    slot->dma_handle,
-			//			    SCp->request_bufflen,
-			//			    DMA_FROM_DEVICE);
-			//	if(((char *)SCp->request_buffer)[7] & 0x02) {
-			//		scmd_printk(KERN_INFO, SCp,
-			//		     "Enabling Tag Command Queuing\n");
-			//		hostdata->tag_negotiated |= (1<<scmd_id(SCp));
-			//		NCR_700_set_flag(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING);
-			//	} else {
-			//		NCR_700_clear_flag(SCp->device, NCR_700_DEV_BEGIN_TAG_QUEUEING);
-			//		hostdata->tag_negotiated &= ~(1<<scmd_id(SCp));
-			//	}
-			//}
 			NCR_700_scsi_done(hostdata, SCp, hostdata->status[0]);
 		}
 	} else if((dsps & 0xfffff0f0) == A_UNEXPECTED_PHASE) {
@@ -1873,32 +1856,9 @@ NCR_700_queuecommand(struct scsi_cmnd *SCp, void (*done)(struct scsi_cmnd *))
 
 	/* now build the scatter gather list */
 	direction = SCp->sc_data_direction;
-	if(move_ins != 0) {
-		int i;
-		int sg_count;
-		dma_addr_t vPtr = 0;
-		struct scatterlist *sg;
-		__u32 count = 0;
-
-		sg_count = scsi_dma_map(SCp);
-		BUG_ON(sg_count < 0);
-
-		scsi_for_each_sg(SCp, sg, sg_count, i) {
-			vPtr = sg_dma_address(sg);
-			count = sg_dma_len(sg);
-
-			slot->SG[i].ins = bS_to_host(move_ins | count);
-			DEBUG((" scatter block %d: move %d[%08x] from 0x%lx\n",
-			       i, count, slot->SG[i].ins, (unsigned long)vPtr));
-			slot->SG[i].pAddr = bS_to_host(vPtr);
-		}
-		slot->SG[i].ins = bS_to_host(SCRIPT_RETURN);
-		slot->SG[i].pAddr = 0;
-		dma_cache_sync(hostdata->dev, slot->SG, sizeof(slot->SG), DMA_TO_DEVICE);
-		DEBUG((" SETTING %08lx to %x\n",
-		       (&slot->pSG[i].ins),
-		       slot->SG[i].ins));
-	}
+	if (move_ins != 0)
+		NCR_700_map(hostdata, SCp, slot, move_ins);
+
 	slot->resume_offset = 0;
 	slot->pCmd = dma_map_single(hostdata->dev, SCp->cmnd,
 				    MAX_COMMAND_SIZE, DMA_TO_DEVICE);
diff --git a/drivers/scsi/53c700.h b/drivers/scsi/53c700.h
index e06bdfe..568105b 100644
--- a/drivers/scsi/53c700.h
+++ b/drivers/scsi/53c700.h
@@ -13,6 +13,7 @@
 
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_eh.h>
 
 /* Turn on for general debugging---too verbose for normal use */
 #undef	NCR_700_DEBUG
@@ -77,14 +78,10 @@ struct NCR_700_SG_List {
 };
 
 struct NCR_700_Device_Parameters {
-	/* space for creating a request sense command. Really, except
-	 * for the annoying SCSI-2 requirement for LUN information in
-	 * cmnd[1], this could be in static storage */
-	unsigned char cmnd[MAX_COMMAND_SIZE];
+	struct scsi_eh_save ses;
 	__u8	depth;
 };
 
-
 /* The SYNC negotiation sequence looks like:
  * 
  * If DEV_NEGOTIATED_SYNC not set, tack and SDTR message on to the
@@ -103,26 +100,23 @@ struct NCR_700_Device_Parameters {
 #define NCR_700_DEV_BEGIN_SYNC_NEGOTIATION	(1<<17)
 #define NCR_700_DEV_PRINT_SYNC_NEGOTIATION (1<<19)
 
-static inline char *NCR_700_get_sense_cmnd(struct scsi_device *SDp)
+static inline struct NCR_700_Device_Parameters *
+NCR_700_Device_Parameters(struct scsi_device *SDp)
 {
 	struct NCR_700_Device_Parameters *hostdata = SDp->hostdata;
 
-	return hostdata->cmnd;
+	return hostdata;
 }
 
 static inline void
 NCR_700_set_depth(struct scsi_device *SDp, __u8 depth)
 {
-	struct NCR_700_Device_Parameters *hostdata = SDp->hostdata;
-
-	hostdata->depth = depth;
+	NCR_700_Device_Parameters(SDp)->depth = depth;
 }
 static inline __u8
 NCR_700_get_depth(struct scsi_device *SDp)
 {
-	struct NCR_700_Device_Parameters *hostdata = SDp->hostdata;
-
-	return hostdata->depth;
+	return NCR_700_Device_Parameters(SDp)->depth;
 }
 static inline int
 NCR_700_is_flag_set(struct scsi_device *SDp, __u32 flag)
-- 
1.5.3.3

