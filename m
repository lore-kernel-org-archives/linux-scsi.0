From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] coding style updates for scsi_lib.c
Date: Thu, 6 Feb 2003 15:31:54 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030206153154.A16630@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

I just couldn't see the mess anymore..  Nuke the ifdefs and use sane
variable names.  Some more small nitpicks but no behaviour changes at
all.


--- 1.67/drivers/scsi/scsi_lib.c	Wed Feb  5 18:44:10 2003
+++ edited/drivers/scsi/scsi_lib.c	Thu Feb  6 14:58:07 2003
@@ -41,8 +41,8 @@
  *
  * Purpose:     Insert pre-formed command into request queue.
  *
- * Arguments:   SCpnt   - command that is ready to be queued.
- *              at_head - boolean.  True if we should insert at head
+ * Arguments:   cmd	- command that is ready to be queued.
+ *              at_head	- boolean.  True if we should insert at head
  *                        of queue, false if we should insert at tail.
  *
  * Lock status: Assumed that lock is not held upon entry.
@@ -56,10 +56,10 @@
  *              for now), and then call the queue request function to actually
  *              process it.
  */
-int scsi_insert_special_cmd(Scsi_Cmnd * SCpnt, int at_head)
+int scsi_insert_special_cmd(struct scsi_cmnd *cmd, int at_head)
 {
-	blk_insert_request(SCpnt->device->request_queue, SCpnt->request,
-		       	   at_head, SCpnt);
+	blk_insert_request(cmd->device->request_queue, cmd->request,
+		       	   at_head, cmd);
 	return 0;
 }
 
@@ -68,8 +68,8 @@
  *
  * Purpose:     Insert pre-formed request into request queue.
  *
- * Arguments:   SRpnt   - request that is ready to be queued.
- *              at_head - boolean.  True if we should insert at head
+ * Arguments:   sreq	- request that is ready to be queued.
+ *              at_head	- boolean.  True if we should insert at head
  *                        of queue, false if we should insert at tail.
  *
  * Lock status: Assumed that lock is not held upon entry.
@@ -83,24 +83,24 @@
  *              for now), and then call the queue request function to actually
  *              process it.
  */
-int scsi_insert_special_req(Scsi_Request * SRpnt, int at_head)
+int scsi_insert_special_req(struct scsi_request *sreq, int at_head)
 {
-	/* This is used to insert SRpnt specials.  Because users of
-	 * this function are apt to reuse requests with no modification,
-	 * we have to sanitise the request flags here
-	 */
-	SRpnt->sr_request->flags &= ~REQ_DONTPREP;
-	blk_insert_request(SRpnt->sr_device->request_queue, SRpnt->sr_request,
-		       	   at_head, SRpnt);
+	/*
+	 * Because users of this function are apt to reuse requests with no
+	 * modification, we have to sanitise the request flags here
+	 */
+	sreq->sr_request->flags &= ~REQ_DONTPREP;
+	blk_insert_request(sreq->sr_device->request_queue, sreq->sr_request,
+		       	   at_head, sreq);
 	return 0;
 }
 
 /*
  * Function:    scsi_init_cmd_errh()
  *
- * Purpose:     Initialize SCpnt fields related to error handling.
+ * Purpose:     Initialize cmd fields related to error handling.
  *
- * Arguments:   SCpnt   - command that is ready to be queued.
+ * Arguments:   cmd	- command that is ready to be queued.
  *
  * Returns:     Nothing
  *
@@ -108,21 +108,20 @@
  *              fields related to error handling.   Typically this will
  *              be called once for each command, as required.
  */
-static int scsi_init_cmd_errh(Scsi_Cmnd * SCpnt)
+static int scsi_init_cmd_errh(struct scsi_cmnd *cmd)
 {
-	SCpnt->owner = SCSI_OWNER_MIDLEVEL;
-	SCpnt->reset_chain = NULL;
-	SCpnt->serial_number = 0;
-	SCpnt->serial_number_at_timeout = 0;
-	SCpnt->flags = 0;
-	SCpnt->retries = 0;
-
-	SCpnt->abort_reason = 0;
+	cmd->owner = SCSI_OWNER_MIDLEVEL;
+	cmd->reset_chain = NULL;
+	cmd->serial_number = 0;
+	cmd->serial_number_at_timeout = 0;
+	cmd->flags = 0;
+	cmd->retries = 0;
+	cmd->abort_reason = 0;
 
-	memset((void *) SCpnt->sense_buffer, 0, sizeof SCpnt->sense_buffer);
+	memset(cmd->sense_buffer, 0, sizeof cmd->sense_buffer);
 
-	if (SCpnt->cmd_len == 0)
-		SCpnt->cmd_len = COMMAND_SIZE(SCpnt->cmnd[0]);
+	if (cmd->cmd_len == 0)
+		cmd->cmd_len = COMMAND_SIZE(cmd->cmnd[0]);
 
 	/*
 	 * We need saved copies of a number of fields - this is because
@@ -131,19 +130,16 @@
 	 * we will need to restore these values prior to running the actual
 	 * command.
 	 */
-	SCpnt->old_use_sg = SCpnt->use_sg;
-	SCpnt->old_cmd_len = SCpnt->cmd_len;
-	SCpnt->sc_old_data_direction = SCpnt->sc_data_direction;
-	SCpnt->old_underflow = SCpnt->underflow;
-	memcpy((void *) SCpnt->data_cmnd,
-	       (const void *) SCpnt->cmnd, sizeof(SCpnt->cmnd));
-	SCpnt->buffer = SCpnt->request_buffer;
-	SCpnt->bufflen = SCpnt->request_bufflen;
-
-	SCpnt->reset_chain = NULL;
-
-	SCpnt->internal_timeout = NORMAL_TIMEOUT;
-	SCpnt->abort_reason = 0;
+	cmd->old_use_sg = cmd->use_sg;
+	cmd->old_cmd_len = cmd->cmd_len;
+	cmd->sc_old_data_direction = cmd->sc_data_direction;
+	cmd->old_underflow = cmd->underflow;
+	memcpy(cmd->data_cmnd, cmd->cmnd, sizeof(cmd->cmnd));
+	cmd->buffer = cmd->request_buffer;
+	cmd->bufflen = cmd->request_bufflen;
+	cmd->reset_chain = NULL;
+	cmd->internal_timeout = NORMAL_TIMEOUT;
+	cmd->abort_reason = 0;
 
 	return 1;
 }
@@ -153,23 +149,22 @@
  *
  * Purpose:    Restore the command state for a retry
  *
- * Arguments:  SCpnt   - command to be restored
+ * Arguments:  cmd	- command to be restored
  *
  * Returns:    Nothing
  *
  * Notes:      Immediately prior to retrying a command, we need
  *             to restore certain fields that we saved above.
  */
-void scsi_setup_cmd_retry(Scsi_Cmnd *SCpnt)
+void scsi_setup_cmd_retry(struct scsi_cmnd *cmd)
 {
-	memcpy((void *) SCpnt->cmnd, (void *) SCpnt->data_cmnd,
-		sizeof(SCpnt->data_cmnd));
-	SCpnt->request_buffer = SCpnt->buffer;
-	SCpnt->request_bufflen = SCpnt->bufflen;
-	SCpnt->use_sg = SCpnt->old_use_sg;
-	SCpnt->cmd_len = SCpnt->old_cmd_len;
-	SCpnt->sc_data_direction = SCpnt->sc_old_data_direction;
-	SCpnt->underflow = SCpnt->old_underflow;
+	memcpy(cmd->cmnd, cmd->data_cmnd, sizeof(cmd->data_cmnd));
+	cmd->request_buffer = cmd->buffer;
+	cmd->request_bufflen = cmd->bufflen;
+	cmd->use_sg = cmd->old_use_sg;
+	cmd->cmd_len = cmd->old_cmd_len;
+	cmd->sc_data_direction = cmd->sc_old_data_direction;
+	cmd->underflow = cmd->old_underflow;
 }
 
 /*
@@ -177,7 +172,7 @@
  *
  * Purpose:     Handle post-processing of completed commands.
  *
- * Arguments:   SCpnt   - command that may need to be requeued.
+ * Arguments:   cmd	- command that may need to be requeued.
  *
  * Returns:     Nothing
  *
@@ -187,7 +182,7 @@
  *              that a medium error occurred, and the sectors after
  *              the bad block need to be re-read.
  *
- *              If SCpnt is NULL, it means that the previous command
+ *              If cmd is NULL, it means that the previous command
  *              was completely finished, and we should simply start
  *              a new command, if possible.
  *
@@ -208,17 +203,17 @@
  *		permutations grows as 2**N, and if too many more special cases
  *		get added, we start to get screwed.
  */
-void scsi_queue_next_request(request_queue_t * q, Scsi_Cmnd * SCpnt)
+void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd)
 {
-	int all_clear;
+	struct scsi_device *sdev, *sdev2;
+	struct Scsi_Host *shost;
 	unsigned long flags;
-	Scsi_Device *SDpnt, *SDpnt2;
-	struct Scsi_Host *SHpnt;
+	int all_clear;
 
 	ASSERT_LOCK(q->queue_lock, 0);
 
 	spin_lock_irqsave(q->queue_lock, flags);
-	if (SCpnt != NULL) {
+	if (cmd != NULL) {
 
 		/*
 		 * For some reason, we are not done with this request.
@@ -226,16 +221,18 @@
 		 * in which case we need to request the blocks that come after
 		 * the bad sector.
 		 */
-		SCpnt->request->special = (void *) SCpnt;
-		if(blk_rq_tagged(SCpnt->request))
-			blk_queue_end_tag(q, SCpnt->request);
-		/* set REQ_SPECIAL - we have a command
+		cmd->request->special = cmd;
+		if (blk_rq_tagged(cmd->request))
+			blk_queue_end_tag(q, cmd->request);
+
+		/*
+		 * set REQ_SPECIAL - we have a command
 		 * clear REQ_DONTPREP - we assume the sg table has been 
 		 *	nuked so we need to set it up again.
 		 */
-		SCpnt->request->flags |= REQ_SPECIAL;
-		SCpnt->request->flags &= ~REQ_DONTPREP;
-		__elv_add_request(q, SCpnt->request, 0, 0);
+		cmd->request->flags |= REQ_SPECIAL;
+		cmd->request->flags &= ~REQ_DONTPREP;
+		__elv_add_request(q, cmd->request, 0, 0);
 	}
 
 	/*
@@ -243,8 +240,8 @@
 	 */
 	__blk_run_queue(q);
 
-	SDpnt = (Scsi_Device *) q->queuedata;
-	SHpnt = SDpnt->host;
+	sdev = q->queuedata;
+	shost = sdev->host;
 
 	/*
 	 * If this is a single-lun device, and we are currently finished
@@ -253,15 +250,15 @@
 	 * with special case code, then spin off separate versions and
 	 * use function pointers to pick the right one.
 	 */
-	if (SDpnt->single_lun && blk_queue_empty(q) && SDpnt->device_busy ==0 &&
-			!SHpnt->host_blocked && !SHpnt->host_self_blocked &&
-			!((SHpnt->can_queue > 0) && (SHpnt->host_busy >=
-				       		     SHpnt->can_queue))) {
-		list_for_each_entry(SDpnt2, &SDpnt->same_target_siblings,
+	if (sdev->single_lun && blk_queue_empty(q) && sdev->device_busy ==0 &&
+			!shost->host_blocked && !shost->host_self_blocked &&
+			!((shost->can_queue > 0) && (shost->host_busy >=
+				       		     shost->can_queue))) {
+		list_for_each_entry(sdev2, &sdev->same_target_siblings,
 			       same_target_siblings) {
-			if (!SDpnt2->device_blocked &&
-			    !blk_queue_empty(SDpnt2->request_queue)) {
-				__blk_run_queue(SDpnt2->request_queue);
+			if (!sdev2->device_blocked &&
+			    !blk_queue_empty(sdev2->request_queue)) {
+				__blk_run_queue(sdev2->request_queue);
 				break;
 			}
 		}
@@ -276,22 +273,21 @@
 	 * other device might have become starved along the way.
 	 */
 	all_clear = 1;
-	if (SHpnt->some_device_starved) {
-		list_for_each_entry(SDpnt, &SHpnt->my_devices, siblings) {
-			if ((SHpnt->can_queue > 0 && (SHpnt->host_busy >= SHpnt->can_queue))
-			    || (SHpnt->host_blocked) 
-			    || (SHpnt->host_self_blocked)) {
+	if (shost->some_device_starved) {
+		list_for_each_entry(sdev, &shost->my_devices, siblings) {
+			if (shost->can_queue > 0 &&
+			    shost->host_busy >= shost->can_queue)
 				break;
-			}
-			if (SDpnt->device_blocked || !SDpnt->starved) {
+			if (shost->host_blocked || shost->host_self_blocked)
+				break;
+			if (sdev->device_blocked || !sdev->starved)
 				continue;
-			}
-			__blk_run_queue(SDpnt->request_queue);
+			__blk_run_queue(sdev->request_queue);
 			all_clear = 0;
 		}
-		if (SDpnt == NULL && all_clear) {
-			SHpnt->some_device_starved = 0;
-		}
+
+		if (sdev == NULL && all_clear)
+			shost->some_device_starved = 0;
 	}
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
@@ -302,7 +298,7 @@
  * Purpose:     Post-processing of completed commands called from interrupt
  *              handler or a bottom-half handler.
  *
- * Arguments:   SCpnt    - command that is complete.
+ * Arguments:   cmd	 - command that is complete.
  *              uptodate - 1 if I/O indicates success, 0 for I/O error.
  *              sectors  - number of sectors we want to mark.
  *		requeue  - indicates whether we should requeue leftovers.
@@ -319,13 +315,11 @@
  *		We are guaranteeing that the request queue will be goosed
  *		at some point during this call.
  */
-static Scsi_Cmnd *scsi_end_request(Scsi_Cmnd * SCpnt, 
-				     int uptodate, 
-				     int sectors,
-				     int requeue)
+static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
+					  int sectors, int requeue)
 {
-	request_queue_t *q = SCpnt->device->request_queue;
-	struct request *req = SCpnt->request;
+	request_queue_t *q = cmd->device->request_queue;
+	struct request *req = cmd->request;
 	unsigned long flags;
 
 	ASSERT_LOCK(q->queue_lock, 0);
@@ -335,15 +329,14 @@
 	 * to queue the remainder of them.
 	 */
 	if (end_that_request_first(req, uptodate, sectors)) {
-		if (!requeue)
-			return SCpnt;
-
-		/*
-		 * Bleah.  Leftovers again.  Stick the leftovers in
-		 * the front of the queue, and goose the queue again.
-		 */
-		scsi_queue_next_request(q, SCpnt);
-		return SCpnt;
+		if (requeue) {
+			/*
+			 * Bleah.  Leftovers again.  Stick the leftovers in
+			 * the front of the queue, and goose the queue again.
+			 */
+			scsi_queue_next_request(q, cmd);
+		}
+		return cmd;
 	}
 
 	add_disk_randomness(req->rq_disk);
@@ -358,39 +351,39 @@
 	 * This will goose the queue request function at the end, so we don't
 	 * need to worry about launching another command.
 	 */
-	scsi_put_command(SCpnt);
+	scsi_put_command(cmd);
 	scsi_queue_next_request(q, NULL);
 	return NULL;
 }
 
-static struct scatterlist *scsi_alloc_sgtable(Scsi_Cmnd *SCpnt, int gfp_mask)
+static struct scatterlist *scsi_alloc_sgtable(struct scsi_cmnd *cmd, int gfp_mask)
 {
 	struct scsi_host_sg_pool *sgp;
 	struct scatterlist *sgl;
 
-	BUG_ON(!SCpnt->use_sg);
+	BUG_ON(!cmd->use_sg);
 
-	switch (SCpnt->use_sg) {
+	switch (cmd->use_sg) {
 	case 1 ... 8:
-		SCpnt->sglist_len = 0;
+		cmd->sglist_len = 0;
 		break;
 	case 9 ... 16:
-		SCpnt->sglist_len = 1;
+		cmd->sglist_len = 1;
 		break;
 	case 17 ... 32:
-		SCpnt->sglist_len = 2;
+		cmd->sglist_len = 2;
 		break;
 	case 33 ... 64:
-		SCpnt->sglist_len = 3;
+		cmd->sglist_len = 3;
 		break;
 	case 65 ... MAX_PHYS_SEGMENTS:
-		SCpnt->sglist_len = 4;
+		cmd->sglist_len = 4;
 		break;
 	default:
 		return NULL;
 	}
 
-	sgp = scsi_sg_pools + SCpnt->sglist_len;
+	sgp = scsi_sg_pools + cmd->sglist_len;
 	sgl = mempool_alloc(sgp->pool, gfp_mask);
 	if (sgl)
 		memset(sgl, 0, sgp->size);
@@ -407,13 +400,12 @@
 	mempool_free(sgl, sgp->pool);
 }
 
-
 /*
  * Function:    scsi_release_buffers()
  *
  * Purpose:     Completion processing for block device I/O requests.
  *
- * Arguments:   SCpnt   - command that we are bailing.
+ * Arguments:   cmd	- command that we are bailing.
  *
  * Lock status: Assumed that no lock is held upon entry.
  *
@@ -425,28 +417,28 @@
  *		the scatter-gather table, and potentially any bounce
  *		buffers.
  */
-static void scsi_release_buffers(Scsi_Cmnd * SCpnt)
+static void scsi_release_buffers(struct scsi_cmnd *cmd)
 {
-	struct request *req = SCpnt->request;
+	struct request *req = cmd->request;
 
-	ASSERT_LOCK(SCpnt->device->host->host_lock, 0);
+	ASSERT_LOCK(cmd->device->host->host_lock, 0);
 
 	/*
 	 * Free up any indirection buffers we allocated for DMA purposes. 
 	 */
-	if (SCpnt->use_sg)
-		scsi_free_sgtable(SCpnt->request_buffer, SCpnt->sglist_len);
-	else if (SCpnt->request_buffer != req->buffer)
-		kfree(SCpnt->request_buffer);
+	if (cmd->use_sg)
+		scsi_free_sgtable(cmd->request_buffer, cmd->sglist_len);
+	else if (cmd->request_buffer != req->buffer)
+		kfree(cmd->request_buffer);
 
 	/*
 	 * Zero these out.  They now point to freed memory, and it is
 	 * dangerous to hang onto the pointers.
 	 */
-	SCpnt->buffer  = NULL;
-	SCpnt->bufflen = 0;
-	SCpnt->request_buffer = NULL;
-	SCpnt->request_bufflen = 0;
+	cmd->buffer  = NULL;
+	cmd->bufflen = 0;
+	cmd->request_buffer = NULL;
+	cmd->request_bufflen = 0;
 }
 
 /*
@@ -477,7 +469,7 @@
  *
  * Purpose:     Completion processing for block device I/O requests.
  *
- * Arguments:   SCpnt   - command that is finished.
+ * Arguments:   cmd   - command that is finished.
  *
  * Lock status: Assumed that no lock is held upon entry.
  *
@@ -489,13 +481,13 @@
  *              (the normal case for most drivers), we don't need
  *              the logic to deal with cleaning up afterwards.
  */
-void scsi_io_completion(Scsi_Cmnd * SCpnt, int good_sectors,
+void scsi_io_completion(struct scsi_cmnd *cmd, int good_sectors,
 			int block_sectors)
 {
-	int result = SCpnt->result;
-	int this_count = SCpnt->bufflen >> 9;
-	request_queue_t *q = SCpnt->device->request_queue;
-	struct request *req = SCpnt->request;
+	int result = cmd->result;
+	int this_count = cmd->bufflen >> 9;
+	request_queue_t *q = cmd->device->request_queue;
+	struct request *req = cmd->request;
 	int clear_errors = 1;
 
 	/*
@@ -518,44 +510,43 @@
 	 * For the case of a READ, we need to copy the data out of the
 	 * bounce buffer and into the real buffer.
 	 */
-	if (SCpnt->use_sg)
-		scsi_free_sgtable(SCpnt->buffer, SCpnt->sglist_len);
-	else if (SCpnt->buffer != req->buffer) {
+	if (cmd->use_sg)
+		scsi_free_sgtable(cmd->buffer, cmd->sglist_len);
+	else if (cmd->buffer != req->buffer) {
 		if (rq_data_dir(req) == READ) {
 			unsigned long flags;
 			char *to = bio_kmap_irq(req->bio, &flags);
-			memcpy(to, SCpnt->buffer, SCpnt->bufflen);
+			memcpy(to, cmd->buffer, cmd->bufflen);
 			bio_kunmap_irq(to, &flags);
 		}
-		kfree(SCpnt->buffer);
+		kfree(cmd->buffer);
 	}
 
 	if (blk_pc_request(req)) { /* SG_IO ioctl from block level */
 		req->errors = (driver_byte(result) & DRIVER_SENSE) ?
 			      (CHECK_CONDITION << 1) : (result & 0xff);
-		if (!result) 
-			req->data_len -= SCpnt->bufflen;
-		else {
+		if (result) {
 			clear_errors = 0;
-			if (SCpnt->sense_buffer[0] & 0x70) {
-				int len = 8 + SCpnt->sense_buffer[7];
+			if (cmd->sense_buffer[0] & 0x70) {
+				int len = 8 + cmd->sense_buffer[7];
 
 				if (len > SCSI_SENSE_BUFFERSIZE)
 					len = SCSI_SENSE_BUFFERSIZE;
-				memcpy(req->sense, SCpnt->sense_buffer,  len);
+				memcpy(req->sense, cmd->sense_buffer,  len);
 				req->sense_len = len;
 			}
-		}
+		} else
+			req->data_len -= cmd->bufflen;
 	}
 
 	/*
 	 * Zero these out.  They now point to freed memory, and it is
 	 * dangerous to hang onto the pointers.
 	 */
-	SCpnt->buffer  = NULL;
-	SCpnt->bufflen = 0;
-	SCpnt->request_buffer = NULL;
-	SCpnt->request_bufflen = 0;
+	cmd->buffer  = NULL;
+	cmd->bufflen = 0;
+	cmd->request_buffer = NULL;
+	cmd->request_bufflen = 0;
 
 	/*
 	 * Next deal with any sectors which we were able to correctly
@@ -564,7 +555,7 @@
 	if (good_sectors >= 0) {
 		SCSI_LOG_HLCOMPLETE(1, printk("%ld sectors total, %d sectors done.\n",
 					      req->nr_sectors, good_sectors));
-		SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n ", SCpnt->use_sg));
+		SCSI_LOG_HLCOMPLETE(1, printk("use_sg is %d\n ", cmd->use_sg));
 
 		if (clear_errors)
 			req->errors = 0;
@@ -579,13 +570,13 @@
 		 * requeueing right here - we will requeue down below
 		 * when we handle the bad sectors.
 		 */
-		SCpnt = scsi_end_request(SCpnt, 1, good_sectors, result == 0);
+		cmd = scsi_end_request(cmd, 1, good_sectors, result == 0);
 
 		/*
 		 * If the command completed without error, then either finish off the
 		 * rest of the command, or start a new one.
 		 */
-		if (result == 0 || SCpnt == NULL ) {
+		if (result == 0 || cmd == NULL ) {
 			return;
 		}
 	}
@@ -601,28 +592,28 @@
 			 * Not yet implemented.  A read will fail after being remapped,
 			 * a write will call the strategy routine again.
 			 */
-			if (SCpnt->device->remap) {
+			if (cmd->device->remap) {
 				result = 0;
 			}
 #endif
 		}
-		if ((SCpnt->sense_buffer[0] & 0x7f) == 0x70) {
+		if ((cmd->sense_buffer[0] & 0x7f) == 0x70) {
 			/*
 			 * If the device is in the process of becoming ready,
 			 * retry.
 			 */
-			if (SCpnt->sense_buffer[12] == 0x04 &&
-			    SCpnt->sense_buffer[13] == 0x01) {
-				scsi_queue_next_request(q, SCpnt);
+			if (cmd->sense_buffer[12] == 0x04 &&
+			    cmd->sense_buffer[13] == 0x01) {
+				scsi_queue_next_request(q, cmd);
 				return;
 			}
-			if ((SCpnt->sense_buffer[2] & 0xf) == UNIT_ATTENTION) {
-				if (SCpnt->device->removable) {
+			if ((cmd->sense_buffer[2] & 0xf) == UNIT_ATTENTION) {
+				if (cmd->device->removable) {
 					/* detected disc change.  set a bit 
 					 * and quietly refuse further access.
 		 			 */
-					SCpnt->device->changed = 1;
-					SCpnt = scsi_end_request(SCpnt, 0,
+					cmd->device->changed = 1;
+					cmd = scsi_end_request(cmd, 0,
 							this_count, 1);
 					return;
 				} else {
@@ -632,7 +623,7 @@
 				 	* media change, so we just retry the
 				 	* request and see what happens.  
 				 	*/
-					scsi_queue_next_request(q, SCpnt);
+					scsi_queue_next_request(q, cmd);
 					return;
 				}
 			}
@@ -644,35 +635,35 @@
 		 * past the end of the disk.
 		 */
 
-		switch (SCpnt->sense_buffer[2]) {
+		switch (cmd->sense_buffer[2]) {
 		case ILLEGAL_REQUEST:
-			if (SCpnt->device->ten) {
-				SCpnt->device->ten = 0;
+			if (cmd->device->ten) {
+				cmd->device->ten = 0;
 				/*
 				 * This will cause a retry with a 6-byte
 				 * command.
 				 */
-				scsi_queue_next_request(q, SCpnt);
+				scsi_queue_next_request(q, cmd);
 				result = 0;
 			} else {
-				SCpnt = scsi_end_request(SCpnt, 0, this_count, 1);
+				cmd = scsi_end_request(cmd, 0, this_count, 1);
 				return;
 			}
 			break;
 		case NOT_READY:
 			printk(KERN_INFO "Device %s not ready.\n",
 			       req->rq_disk ? req->rq_disk->disk_name : "");
-			SCpnt = scsi_end_request(SCpnt, 0, this_count, 1);
+			cmd = scsi_end_request(cmd, 0, this_count, 1);
 			return;
 			break;
 		case MEDIUM_ERROR:
 		case VOLUME_OVERFLOW:
 			printk("scsi%d: ERROR on channel %d, id %d, lun %d, CDB: ",
-			       SCpnt->device->host->host_no, (int) SCpnt->device->channel,
-			       (int) SCpnt->device->id, (int) SCpnt->device->lun);
-			print_command(SCpnt->data_cmnd);
-			print_sense("sd", SCpnt);
-			SCpnt = scsi_end_request(SCpnt, 0, block_sectors, 1);
+			       cmd->device->host->host_no, (int) cmd->device->channel,
+			       (int) cmd->device->id, (int) cmd->device->lun);
+			print_command(cmd->data_cmnd);
+			print_sense("sd", cmd);
+			cmd = scsi_end_request(cmd, 0, block_sectors, 1);
 			return;
 		default:
 			break;
@@ -684,28 +675,28 @@
 		 * recovery reasons.  Just retry the request
 		 * and see what happens.  
 		 */
-		scsi_queue_next_request(q, SCpnt);
+		scsi_queue_next_request(q, cmd);
 		return;
 	}
 	if (result) {
-		struct Scsi_Device_Template *STpnt;
+		struct Scsi_Device_Template *sdt;
 
-		STpnt = scsi_get_request_dev(SCpnt->request);
+		sdt = scsi_get_request_dev(cmd->request);
 		printk("SCSI %s error : host %d channel %d id %d lun %d return code = %x\n",
-		       (STpnt ? STpnt->name : "device"),
-		       SCpnt->device->host->host_no,
-		       SCpnt->device->channel,
-		       SCpnt->device->id,
-		       SCpnt->device->lun, result);
+		       (sdt ? sdt->name : "device"),
+		       cmd->device->host->host_no,
+		       cmd->device->channel,
+		       cmd->device->id,
+		       cmd->device->lun, result);
 
 		if (driver_byte(result) & DRIVER_SENSE)
-			print_sense("sd", SCpnt);
+			print_sense("sd", cmd);
 		/*
 		 * Mark a single buffer as not uptodate.  Queue the remainder.
 		 * We sometimes get this cruft in the event that a medium error
 		 * isn't properly reported.
 		 */
-		SCpnt = scsi_end_request(SCpnt, 0, req->current_nr_sectors, 1);
+		cmd = scsi_end_request(cmd, 0, req->current_nr_sectors, 1);
 		return;
 	}
 }
@@ -715,26 +706,26 @@
  *
  * Purpose:     SCSI I/O initialize function.
  *
- * Arguments:   SCpnt   - Command descriptor we wish to initialize
+ * Arguments:   cmd   - Command descriptor we wish to initialize
  *
  * Returns:     0 on success
  *		BLKPREP_DEFER if the failure is retryable
  *		BLKPREP_KILL if the failure is fatal
  */
-static int scsi_init_io(Scsi_Cmnd *SCpnt)
+static int scsi_init_io(struct scsi_cmnd *cmd)
 {
-	struct request     *req = SCpnt->request;
+	struct request     *req = cmd->request;
 	struct scatterlist *sgpnt;
-	int count, ret = 0;
+	int		   count;
 
 	/*
 	 * if this is a rq->data based REQ_BLOCK_PC, setup for a non-sg xfer
 	 */
 	if ((req->flags & REQ_BLOCK_PC) && !req->bio) {
-		SCpnt->request_bufflen = req->data_len;
-		SCpnt->request_buffer = req->data;
+		cmd->request_bufflen = req->data_len;
+		cmd->request_buffer = req->data;
 		req->buffer = req->data;
-		SCpnt->use_sg = 0;
+		cmd->use_sg = 0;
 		return 0;
 	}
 
@@ -743,48 +734,45 @@
 	 * but now we do (it makes highmem I/O easier to support without
 	 * kmapping pages)
 	 */
-	SCpnt->use_sg = req->nr_phys_segments;
+	cmd->use_sg = req->nr_phys_segments;
 
 	/*
 	 * if sg table allocation fails, requeue request later.
 	 */
-	sgpnt = scsi_alloc_sgtable(SCpnt, GFP_ATOMIC);
+	sgpnt = scsi_alloc_sgtable(cmd, GFP_ATOMIC);
 	if (unlikely(!sgpnt)) {
 		req->flags |= REQ_SPECIAL;
-		ret = BLKPREP_DEFER;
-		goto out;
+		return BLKPREP_DEFER;
 	}
 
-	SCpnt->request_buffer = (char *) sgpnt;
-	SCpnt->request_bufflen = req->nr_sectors << 9;
+	cmd->request_buffer = (char *) sgpnt;
+	cmd->request_bufflen = req->nr_sectors << 9;
 	if (blk_pc_request(req))
-		SCpnt->request_bufflen = req->data_len;
+		cmd->request_bufflen = req->data_len;
 	req->buffer = NULL;
 
 	/* 
 	 * Next, walk the list, and fill in the addresses and sizes of
 	 * each segment.
 	 */
-	count = blk_rq_map_sg(req->q, req, SCpnt->request_buffer);
+	count = blk_rq_map_sg(req->q, req, cmd->request_buffer);
 
 	/*
 	 * mapped well, send it off
 	 */
-	if (count <= SCpnt->use_sg) {
-		SCpnt->use_sg = count;
+	if (likely(count <= cmd->use_sg)) {
+		cmd->use_sg = count;
 		return 0;
 	}
 
 	printk(KERN_ERR "Incorrect number of segments after building list\n");
-	printk(KERN_ERR "counted %d, received %d\n", count, SCpnt->use_sg);
+	printk(KERN_ERR "counted %d, received %d\n", count, cmd->use_sg);
 	printk(KERN_ERR "req nr_sec %lu, cur_nr_sec %u\n", req->nr_sectors,
 			req->current_nr_sectors);
 
 	/* release the command and kill it */
-	scsi_put_command(SCpnt);
-	ret = BLKPREP_KILL;
-out:
-	return ret;
+	scsi_put_command(cmd);
+	return BLKPREP_KILL;
 }
 
 /*
@@ -805,60 +793,53 @@
 
 int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
-	struct Scsi_Device_Template *STpnt;
-	Scsi_Cmnd *SCpnt;
-	Scsi_Device *SDpnt;
-
-	SDpnt = (Scsi_Device *) q->queuedata;
-	BUG_ON(!SDpnt);
+	struct Scsi_Device_Template *sdt;
+	struct scsi_device *sdev = q->queuedata;
+	struct scsi_cmnd *cmd;
 
 	/*
 	 * Find the actual device driver associated with this command.
 	 * The SPECIAL requests are things like character device or
 	 * ioctls, which did not originate from ll_rw_blk.  Note that
-	 * the special field is also used to indicate the SCpnt for
+	 * the special field is also used to indicate the cmd for
 	 * the remainder of a partially fulfilled request that can 
 	 * come up when there is a medium error.  We have to treat
 	 * these two cases differently.  We differentiate by looking
 	 * at request->cmd, as this tells us the real story.
 	 */
 	if (req->flags & REQ_SPECIAL) {
-		Scsi_Request *SRpnt;
+		struct scsi_request *sreq = req->special;
 
-		STpnt = NULL;
-		SCpnt = (Scsi_Cmnd *) req->special;
-		SRpnt = (Scsi_Request *) req->special;
-		
-		if (SRpnt->sr_magic == SCSI_REQ_MAGIC) {
-			SCpnt = scsi_get_command(SRpnt->sr_device, GFP_ATOMIC);
-			if (!SCpnt)
+		if (sreq->sr_magic == SCSI_REQ_MAGIC) {
+			cmd = scsi_get_command(sreq->sr_device, GFP_ATOMIC);
+			if (unlikely(!cmd))
 				return BLKPREP_DEFER;
-			scsi_init_cmd_from_req(SCpnt, SRpnt);
-		}
-		
+			scsi_init_cmd_from_req(cmd, sreq);
+		} else
+			cmd = req->special;
 	} else if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
 		/*
 		 * Now try and find a command block that we can use.
 		 */
 		if (!req->special) {
-			SCpnt = scsi_get_command(SDpnt, GFP_ATOMIC);
-			if (unlikely(!SCpnt))
+			cmd = scsi_get_command(sdev, GFP_ATOMIC);
+			if (unlikely(!cmd))
 				return BLKPREP_DEFER;
 		} else
-			SCpnt = req->special;
+			cmd = req->special;
 		
 		/* pull a tag out of the request if we have one */
-		SCpnt->tag = req->tag;
+		cmd->tag = req->tag;
 	} else {
 		blk_dump_rq_flags(req, "SCSI bad req");
 		return BLKPREP_KILL;
 	}
 	
 	/* note the overloading of req->special.  When the tag
-	 * is active it always means SCpnt.  If the tag goes
+	 * is active it always means cmd.  If the tag goes
 	 * back for re-queueing, it may be reset */
-	req->special = SCpnt;
-	SCpnt->request = req;
+	req->special = cmd;
+	cmd->request = req;
 	
 	/*
 	 * FIXME: drop the lock here because the functions below
@@ -867,7 +848,6 @@
 	 * lock.  We hope REQ_STARTED prevents anything untoward from
 	 * happening now.
 	 */
-
 	if (req->flags & (REQ_CMD | REQ_BLOCK_PC)) {
 		int ret;
 
@@ -883,27 +863,30 @@
 		 * some kinds of consistency checking may cause the	
 		 * request to be rejected immediately.
 		 */
-		STpnt = scsi_get_request_dev(req);
-		BUG_ON(!STpnt);
+		sdt = scsi_get_request_dev(req);
+		BUG_ON(!sdt);
 
 		/* 
 		 * This sets up the scatter-gather table (allocating if
 		 * required).
 		 */
-		if ((ret = scsi_init_io(SCpnt)))
-			/* BLKPREP_KILL return also releases the command */
+		ret = scsi_init_io(cmd);
+		if (ret)	/* BLKPREP_KILL return also releases the command */
 			return ret;
 		
 		/*
 		 * Initialize the actual SCSI command for this request.
 		 */
-		if (!STpnt->init_command(SCpnt)) {
-			scsi_release_buffers(SCpnt);
-			scsi_put_command(SCpnt);
+		if (unlikely(!sdt->init_command(cmd))) {
+			scsi_release_buffers(cmd);
+			scsi_put_command(cmd);
 			return BLKPREP_KILL;
 		}
 	}
-	/* The request is now prepped, no need to come back here */
+
+	/*
+	 * The request is now prepped, no need to come back here
+	 */
 	req->flags |= REQ_DONTPREP;
 	return BLKPREP_OK;
 }
@@ -911,48 +894,34 @@
 /*
  * Function:    scsi_request_fn()
  *
- * Purpose:     Generic version of request function for SCSI hosts.
+ * Purpose:     Main strategy routine for SCSI.
  *
  * Arguments:   q       - Pointer to actual queue.
  *
  * Returns:     Nothing
  *
  * Lock status: IO request lock assumed to be held when called.
- *
- * Notes:       The theory is that this function is something which individual
- *              drivers could also supply if they wished to.   The problem
- *              is that we have 30 some odd low-level drivers in the kernel
- *              tree already, and it would be most difficult to retrofit
- *              this crap into all of them.   Thus this function has the job
- *              of acting as a generic queue manager for all of those existing
- *              drivers.
  */
-void scsi_request_fn(request_queue_t * q)
+void scsi_request_fn(request_queue_t *q)
 {
+	struct scsi_device *sdev = q->queuedata;
+	struct Scsi_Host *shost = sdev->host;
+	struct scsi_cmnd *cmd;
 	struct request *req;
-	Scsi_Cmnd *SCpnt;
-	Scsi_Device *SDpnt;
-	struct Scsi_Host *SHpnt;
 
 	ASSERT_LOCK(q->queue_lock, 1);
 
-	SDpnt = (Scsi_Device *) q->queuedata;
-	if (!SDpnt) {
-		panic("Missing device");
-	}
-	SHpnt = SDpnt->host;
-
 	/*
 	 * To start with, we keep looping until the queue is empty, or until
 	 * the host is no longer able to accept any more requests.
 	 */
-	while (1 == 1) {
+	for (;;) {
 		/*
 		 * Check this again - each time we loop through we will have
 		 * released the lock and grabbed it again, so each time
 		 * we need to check to see if the queue is plugged or not.
 		 */
-		if (SHpnt->in_recovery || blk_queue_plugged(q))
+		if (shost->in_recovery || blk_queue_plugged(q))
 			return;
 
 		/*
@@ -963,39 +932,43 @@
 		 */
 		req = elv_next_request(q);
 
-		if (SDpnt->device_busy >= SDpnt->queue_depth)
+		if (sdev->device_busy >= sdev->queue_depth)
 			break;
 
-		if (SDpnt->single_lun && check_all_luns(SDpnt))
+		if (sdev->single_lun && check_all_luns(sdev))
 			break;
 
-		if(SHpnt->host_busy == 0 && SHpnt->host_blocked) {
+		if (shost->host_busy == 0 && shost->host_blocked) {
 			/* unblock after host_blocked iterates to zero */
-			if(--SHpnt->host_blocked == 0) {
-				SCSI_LOG_MLQUEUE(3, printk("scsi%d unblocking host at zero depth\n", SHpnt->host_no));
+			if (--shost->host_blocked == 0) {
+				SCSI_LOG_MLQUEUE(3,
+					printk("scsi%d unblocking host at zero depth\n",
+						shost->host_no));
 			} else {
 				blk_plug_device(q);
 				break;
 			}
 		}
-		if(SDpnt->device_busy == 0 && SDpnt->device_blocked) {
+
+		if (sdev->device_busy == 0 && sdev->device_blocked) {
 			/* unblock after device_blocked iterates to zero */
-			if(--SDpnt->device_blocked == 0) {
-				SCSI_LOG_MLQUEUE(3, printk("scsi%d (%d:%d) unblocking device at zero depth\n", SHpnt->host_no, SDpnt->id, SDpnt->lun));
+			if (--sdev->device_blocked == 0) {
+				SCSI_LOG_MLQUEUE(3,
+					printk("scsi%d (%d:%d) unblocking device at zero depth\n",
+						shost->host_no, sdev->id, sdev->lun));
 			} else {
 				blk_plug_device(q);
 				break;
 			}
 		}
+
 		/*
 		 * If the device cannot accept another request, then quit.
 		 */
-		if (SDpnt->device_blocked) {
+		if (sdev->device_blocked)
 			break;
-		}
-		if ((SHpnt->can_queue > 0 && (SHpnt->host_busy >= SHpnt->can_queue))
-		    || (SHpnt->host_blocked) 
-		    || (SHpnt->host_self_blocked)) {
+		if ((shost->can_queue > 0 && shost->host_busy >= shost->can_queue) ||
+		    shost->host_blocked || shost->host_self_blocked) {
 			/*
 			 * If we are unable to process any commands at all for
 			 * this device, then we consider it to be starved.
@@ -1004,14 +977,13 @@
 			 * little help getting it started again
 			 * once the host isn't quite so busy.
 			 */
-			if (SDpnt->device_busy == 0) {
-				SDpnt->starved = 1;
-				SHpnt->some_device_starved = 1;
+			if (sdev->device_busy == 0) {
+				sdev->starved = 1;
+				shost->some_device_starved = 1;
 			}
 			break;
-		} else {
-			SDpnt->starved = 0;
-		}
+		} else
+			sdev->starved = 0;
 
 		/*
 		 * If we couldn't find a request that could be queued, then we
@@ -1020,21 +992,22 @@
 		if (blk_queue_empty(q))
 			break;
 
-		if(!req) {
+		if (!req) {
 			/* If the device is busy, a returning I/O
 			 * will restart the queue.  Otherwise, we have
 			 * to plug the queue */
-			if(SDpnt->device_busy == 0)
+			if(sdev->device_busy == 0)
 				blk_plug_device(q);
 			break;
 		}
 
-		SCpnt = (struct scsi_cmnd *)req->special;
+		cmd = req->special;
 
-		/* Should be impossible for a correctly prepared request
+		/*
+		 * Should be impossible for a correctly prepared request
 		 * please mail the stack trace to linux-scsi@vger.kernel.org
 		 */
-		BUG_ON(!SCpnt);
+		BUG_ON(!cmd);
 
 		/*
 		 * Finally, before we release the lock, we copy the
@@ -1044,27 +1017,27 @@
 		 * reason to search the list, because all of the
 		 * commands in this queue are for the same device.
 		 */
-		if(!(blk_queue_tagged(q) && (blk_queue_start_tag(q, req) == 0)))
+		if (!(blk_queue_tagged(q) && (blk_queue_start_tag(q, req) == 0)))
 			blkdev_dequeue_request(req);
 	
 		/*
 		 * Now bump the usage count for both the host and the
 		 * device.
 		 */
-		SHpnt->host_busy++;
-		SDpnt->device_busy++;
+		shost->host_busy++;
+		sdev->device_busy++;
 		spin_unlock_irq(q->queue_lock);
 
 		/*
 		 * Finally, initialize any error handling parameters, and set up
 		 * the timers for timeouts.
 		 */
-		scsi_init_cmd_errh(SCpnt);
+		scsi_init_cmd_errh(cmd);
 
 		/*
 		 * Dispatch the command to the low-level driver.
 		 */
-		scsi_dispatch_cmd(SCpnt);
+		scsi_dispatch_cmd(cmd);
 
 		/*
 		 * Now we need to grab the lock again.  We are about to mess
@@ -1080,7 +1053,7 @@
  * Purpose:     Utility function used by low-level drivers to prevent further
  *		commands from being queued to the device.
  *
- * Arguments:   SHpnt       - Host in question
+ * Arguments:   shost       - Host in question
  *
  * Returns:     Nothing
  *
@@ -1090,9 +1063,9 @@
  *		get unblocked other than the low-level driver calling
  *		scsi_unblock_requests().
  */
-void scsi_block_requests(struct Scsi_Host * SHpnt)
+void scsi_block_requests(struct Scsi_Host *shost)
 {
-	SHpnt->host_self_blocked = 1;
+	shost->host_self_blocked = 1;
 }
 
 /*
@@ -1101,7 +1074,7 @@
  * Purpose:     Utility function used by low-level drivers to allow further
  *		commands from being queued to the device.
  *
- * Arguments:   SHpnt       - Host in question
+ * Arguments:   shost       - Host in question
  *
  * Returns:     Nothing
  *
@@ -1115,14 +1088,17 @@
  *		internals of the scsi mid-layer won't require wholesale
  *		changes to drivers that use this feature.
  */
-void scsi_unblock_requests(struct Scsi_Host * SHpnt)
+void scsi_unblock_requests(struct Scsi_Host *shost)
 {
-	Scsi_Device *SDloop;
+	struct scsi_device *sdev;
 
-	SHpnt->host_self_blocked = 0;
-	/* Now that we are unblocked, try to start the queues. */
-	list_for_each_entry(SDloop, &SHpnt->my_devices, siblings)
-		scsi_queue_next_request(SDloop->request_queue, NULL);
+	shost->host_self_blocked = 0;
+
+	/*
+	 * Now that we are unblocked, try to start the queues.
+	 */
+	list_for_each_entry(sdev, &shost->my_devices, siblings)
+		scsi_queue_next_request(sdev->request_queue, NULL);
 }
 
 /*
@@ -1131,7 +1107,7 @@
  * Purpose:     Utility function used by low-level drivers to report that
  *		they have observed a bus reset on the bus being handled.
  *
- * Arguments:   SHpnt       - Host in question
+ * Arguments:   shost       - Host in question
  *		channel     - channel on which reset was observed.
  *
  * Returns:     Nothing
@@ -1146,13 +1122,14 @@
  *		The main purpose of this is to make sure that a CHECK_CONDITION
  *		is properly treated.
  */
-void scsi_report_bus_reset(struct Scsi_Host * SHpnt, int channel)
+void scsi_report_bus_reset(struct Scsi_Host *shost, int channel)
 {
-	Scsi_Device *SDloop;
-	list_for_each_entry(SDloop, &SHpnt->my_devices, siblings) {
-		if (channel == SDloop->channel) {
-			SDloop->was_reset = 1;
-			SDloop->expecting_cc_ua = 1;
+	struct scsi_device *sdev;
+
+	list_for_each_entry(sdev, &shost->my_devices, siblings) {
+		if (channel == sdev->channel) {
+			sdev->was_reset = 1;
+			sdev->expecting_cc_ua = 1;
 		}
 	}
 }
@@ -1166,11 +1143,11 @@
  * The details of the implementation remain to be settled, however the
  * stubs are here now so that the actual drivers will properly compile.
  */
-void scsi_register_blocked_host(struct Scsi_Host * SHpnt)
+void scsi_register_blocked_host(struct Scsi_Host * shost)
 {
 }
 
-void scsi_deregister_blocked_host(struct Scsi_Host * SHpnt)
+void scsi_deregister_blocked_host(struct Scsi_Host * shost)
 {
 }
 
