From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH, RFC] hide EH backup data outside the scsi_cmnd
Date: Tue, 13 Jun 2006 21:31:19 -0500
Message-ID: <1150252279.3441.95.camel@mulgrave.il.steeleye.com>
References: <20060603112610.GB17018@lst.de> <20060610160815.GA12034@lst.de>
	 <20060612191948.GA8926@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:63648 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964940AbWFNCbn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 22:31:43 -0400
In-Reply-To: <20060612191948.GA8926@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: fischer@norbit.de, linux-scsi@vger.kernel.org

On Mon, 2006-06-12 at 21:19 +0200, Christoph Hellwig wrote:
> Note that this breaks the aha152x and 53x700 drivers because they're
> plaing with those fields internally.

Well, this is what I think the changes for the 53c700 need to be ... I
haven't had time to check it with actual hardware yet (particularly as I
need to arrange to trip a check condition in the device to test it) but
it compiles.  Presumably the aha drivers also need something similar
doing to them.

James

Index: BUILD-2.6/drivers/scsi/53c700.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/53c700.c	2006-06-13 15:53:08.000000000 -0500
+++ BUILD-2.6/drivers/scsi/53c700.c	2006-06-13 15:53:14.000000000 -0500
@@ -183,6 +183,10 @@
 
 STATIC struct scsi_transport_template *NCR_700_transport_template = NULL;
 
+struct NCR_700_sense {
+	unsigned char cmnd[MAX_COMMAND_SIZE];
+};
+
 static char *NCR_700_phase[] = {
 	"",
 	"after selection",
@@ -537,6 +541,7 @@
 	 * finish routine.  If we cannot queue the command when it
 	 * is properly build, we then change to NCR_700_SLOT_QUEUED */
 	slot->state = NCR_700_SLOT_BUSY;
+	slot->flags = 0;
 	hostdata->command_slot_count++;
 	
 	return slot;
@@ -586,7 +591,7 @@
 	if(SCp->sc_data_direction != DMA_NONE &&
 	   SCp->sc_data_direction != DMA_BIDIRECTIONAL) {
 		if(SCp->use_sg) {
-			dma_unmap_sg(hostdata->dev, SCp->buffer,
+			dma_unmap_sg(hostdata->dev, SCp->request_buffer,
 				     SCp->use_sg, SCp->sc_data_direction);
 		} else {
 			dma_unmap_single(hostdata->dev, slot->dma_handle,
@@ -608,30 +613,23 @@
 			(struct NCR_700_command_slot *)SCp->host_scribble;
 		
 		NCR_700_unmap(hostdata, SCp, slot);
-		dma_unmap_single(hostdata->dev, slot->pCmd,
-				 sizeof(SCp->cmnd), DMA_TO_DEVICE);
-		if(SCp->cmnd[0] == REQUEST_SENSE && SCp->cmnd[6] == NCR_700_INTERNAL_SENSE_MAGIC) {
+		if (slot->flags == NCR_700_FLAG_AUTOSENSE) {
+			struct NCR_700_sense *sense = SCp->device->hostdata;
 #ifdef NCR_700_DEBUG
 			printk(" ORIGINAL CMD %p RETURNED %d, new return is %d sense is\n",
 			       SCp, SCp->cmnd[7], result);
 			scsi_print_sense("53c700", SCp);
 
 #endif
+			dma_unmap_single(hostdata->dev, slot->dma_handle, sizeof(SCp->sense_buffer), DMA_FROM_DEVICE);
 			/* restore the old result if the request sense was
 			 * successful */
 			if(result == 0)
-				result = SCp->cmnd[7];
-			/* now restore the original command */
-			memcpy((void *) SCp->cmnd, (void *) SCp->data_cmnd,
-			       sizeof(SCp->data_cmnd));
-			SCp->request_buffer = SCp->buffer;
-			SCp->request_bufflen = SCp->bufflen;
-			SCp->use_sg = SCp->old_use_sg;
-			SCp->cmd_len = SCp->old_cmd_len;
-			SCp->sc_data_direction = SCp->sc_old_data_direction;
-			SCp->underflow = SCp->old_underflow;
-			
-		}
+				result = sense->cmnd[7];
+		} else
+			dma_unmap_single(hostdata->dev, slot->pCmd,
+					 sizeof(SCp->cmnd), DMA_TO_DEVICE);
+
 		free_slot(slot, hostdata);
 #ifdef NCR_700_DEBUG
 		if(NCR_700_get_depth(SCp->device) == 0 ||
@@ -979,6 +977,7 @@
 					"broken device is looping in contingent allegiance: ignoring\n");
 				NCR_700_scsi_done(hostdata, SCp, hostdata->status[0]);
 			} else {
+				struct NCR_700_sense *sense = SCp->device->hostdata;
 #ifdef NCR_DEBUG
 				scsi_print_command(SCp);
 				printk("  cmd %p has status %d, requesting sense\n",
@@ -992,27 +991,25 @@
 				 * data associated with the command
 				 * here */
 				NCR_700_unmap(hostdata, SCp, slot);
-
-				SCp->cmnd[0] = REQUEST_SENSE;
-				SCp->cmnd[1] = (SCp->device->lun & 0x7) << 5;
-				SCp->cmnd[2] = 0;
-				SCp->cmnd[3] = 0;
-				SCp->cmnd[4] = sizeof(SCp->sense_buffer);
-				SCp->cmnd[5] = 0;
-				SCp->cmd_len = 6;
+				dma_unmap_single(hostdata->dev, slot->pCmd,
+						 sizeof(SCp->cmnd),
+						 DMA_TO_DEVICE);
+
+				sense->cmnd[0] = REQUEST_SENSE;
+				sense->cmnd[1] = (SCp->device->lun & 0x7) << 5;
+				sense->cmnd[2] = 0;
+				sense->cmnd[3] = 0;
+				sense->cmnd[4] = sizeof(SCp->sense_buffer);
+				sense->cmnd[5] = 0;
 				/* Here's a quiet hack: the
 				 * REQUEST_SENSE command is six bytes,
 				 * so store a flag indicating that
 				 * this was an internal sense request
 				 * and the original status at the end
 				 * of the command */
-				SCp->cmnd[6] = NCR_700_INTERNAL_SENSE_MAGIC;
-				SCp->cmnd[7] = hostdata->status[0];
-				SCp->use_sg = 0;
-				SCp->sc_data_direction = DMA_FROM_DEVICE;
-				dma_sync_single_for_device(hostdata->dev, slot->pCmd,
-							   SCp->cmd_len, DMA_TO_DEVICE);
-				SCp->request_bufflen = sizeof(SCp->sense_buffer);
+				sense->cmnd[6] = NCR_700_INTERNAL_SENSE_MAGIC;
+				sense->cmnd[7] = hostdata->status[0];
+				slot->pCmd = dma_map_single(hostdata->dev, sense->cmnd, sizeof(sense->cmnd), DMA_TO_DEVICE);
 				slot->dma_handle = dma_map_single(hostdata->dev, SCp->sense_buffer, sizeof(SCp->sense_buffer), DMA_FROM_DEVICE);
 				slot->SG[0].ins = bS_to_host(SCRIPT_MOVE_DATA_IN | sizeof(SCp->sense_buffer));
 				slot->SG[0].pAddr = bS_to_host(slot->dma_handle);
@@ -1024,6 +1021,7 @@
 				
 				/* queue the command for reissue */
 				slot->state = NCR_700_SLOT_QUEUED;
+				slot->flags = NCR_700_FLAG_AUTOSENSE;
 				hostdata->state = NCR_700_HOST_FREE;
 				hostdata->cmd = NULL;
 			}
@@ -1244,7 +1242,7 @@
 
 			if(SCp->use_sg) {
 				for(i = 0; i < SCp->use_sg + 1; i++) {
-					printk(KERN_INFO " SG[%d].length = %d, move_insn=%08x, addr %08x\n", i, ((struct scatterlist *)SCp->buffer)[i].length, ((struct NCR_700_command_slot *)SCp->host_scribble)->SG[i].ins, ((struct NCR_700_command_slot *)SCp->host_scribble)->SG[i].pAddr);
+					printk(KERN_INFO " SG[%d].length = %d, move_insn=%08x, addr %08x\n", i, ((struct scatterlist *)SCp->request_buffer)[i].length, ((struct NCR_700_command_slot *)SCp->host_scribble)->SG[i].ins, ((struct NCR_700_command_slot *)SCp->host_scribble)->SG[i].pAddr);
 				}
 			}
 		}	       
@@ -1403,12 +1401,14 @@
 	/* keep interrupts disabled until we have the command correctly
 	 * set up so we cannot take a selection interrupt */
 
-	hostdata->msgout[0] = NCR_700_identify(SCp->cmnd[0] != REQUEST_SENSE,
+	hostdata->msgout[0] = NCR_700_identify((SCp->cmnd[0] != REQUEST_SENSE &&
+						slot->flags != NCR_700_FLAG_AUTOSENSE),
 					       SCp->device->lun);
 	/* for INQUIRY or REQUEST_SENSE commands, we cannot be sure
 	 * if the negotiated transfer parameters still hold, so
 	 * always renegotiate them */
-	if(SCp->cmnd[0] == INQUIRY || SCp->cmnd[0] == REQUEST_SENSE) {
+	if(SCp->cmnd[0] == INQUIRY || SCp->cmnd[0] == REQUEST_SENSE ||
+	   slot->flags == NCR_700_FLAG_AUTOSENSE) {
 		NCR_700_clear_flag(SCp->device, NCR_700_DEV_NEGOTIATED_SYNC);
 	}
 
@@ -1417,7 +1417,8 @@
 	 * will refuse all tags, so send the request sense as untagged
 	 * */
 	if((hostdata->tag_negotiated & (1<<scmd_id(SCp)))
-	   && (slot->tag != SCSI_NO_TAG && SCp->cmnd[0] != REQUEST_SENSE)) {
+	   && (slot->tag != SCSI_NO_TAG && SCp->cmnd[0] != REQUEST_SENSE &&
+	       slot->flags != NCR_700_FLAG_AUTOSENSE)) {
 		count += scsi_populate_tag_msg(SCp, &hostdata->msgout[count]);
 	}
 
@@ -1863,8 +1864,9 @@
 		__u32 count = 0;
 
 		if(SCp->use_sg) {
-			sg_count = dma_map_sg(hostdata->dev, SCp->buffer,
-					      SCp->use_sg, direction);
+			sg_count = dma_map_sg(hostdata->dev,
+					      SCp->request_buffer, SCp->use_sg,
+					      direction);
 		} else {
 			vPtr = dma_map_single(hostdata->dev,
 					      SCp->request_buffer, 
@@ -1879,7 +1881,7 @@
 		for(i = 0; i < sg_count; i++) {
 
 			if(SCp->use_sg) {
-				struct scatterlist *sg = SCp->buffer;
+				struct scatterlist *sg = SCp->request_buffer;
 
 				vPtr = sg_dma_address(&sg[i]);
 				count = sg_dma_len(&sg[i]);
@@ -2042,6 +2044,11 @@
 	struct NCR_700_Host_Parameters *hostdata = 
 		(struct NCR_700_Host_Parameters *)SDp->host->hostdata[0];
 
+	SDp->hostdata = kmalloc(GFP_KERNEL, sizeof(struct NCR_700_sense));
+
+	if (!SDp->hostdata)
+		return -ENOMEM;
+
 	/* to do here: allocate memory; build a queue_full list */
 	if(SDp->tagged_supported) {
 		scsi_set_tag_type(SDp, MSG_ORDERED_TAG);
@@ -2065,7 +2072,8 @@
 STATIC void
 NCR_700_slave_destroy(struct scsi_device *SDp)
 {
-	/* to do here: deallocate memory */
+	kfree(SDp->hostdata);
+	SDp->hostdata = NULL;
 }
 
 static int
Index: BUILD-2.6/drivers/scsi/53c700.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/53c700.h	2006-06-13 15:53:10.000000000 -0500
+++ BUILD-2.6/drivers/scsi/53c700.h	2006-06-13 15:53:14.000000000 -0500
@@ -163,6 +163,8 @@
 	#define NCR_700_SLOT_BUSY (1|NCR_700_SLOT_MAGIC) /* slot has command active on HA */
 	#define NCR_700_SLOT_QUEUED (2|NCR_700_SLOT_MAGIC) /* slot has command to be made active on HA */
 	__u8	state;
+	#define NCR_700_FLAG_AUTOSENSE	0x01
+	__u8	flags;
 	int	tag;
 	__u32	resume_offset;
 	struct scsi_cmnd *cmnd;


