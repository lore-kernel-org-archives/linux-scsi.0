From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] rationalize scsi_queue_next & friends
Date: Wed, 30 Apr 2003 23:55:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030430235524.A8264@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:23312 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S262473AbTD3VnG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Apr 2003 17:43:06 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

(1)  second arg to scsi_queue_next_request() is only ever non-NULL
     inside scsi_lib.c and only used in the first conditional inside
     that function - ripped out of scsi_queue_next_request() and
     put into a new helper scsi_requeue_command().
(2)  Most remaining callers of are in the form 
	scsi_put_command(cmd);
	scsi_queue_next_request(q, NULL);
     add a new helper, scsi_next_command() for them.
(2b) many callers of that still contain a repeated codepath, namely
     everything from scsi_release_request except the final kfree.
     New helper __scsi_release_request() for those.
(3)  All remaining callers loop over the devices of a host and call
     scsi_queue_next_request() on them - new helper
     scsi_run_host_queues().
(4)  scsi_queue_next_request() renamed to scsi_run_queue(), second
     arg is gone and it's static to scsi_lib.c now.


--- 1.109/drivers/scsi/scsi.c	Tue Apr 29 13:40:45 2003
+++ edited/drivers/scsi/scsi.c	Wed Apr 30 22:09:21 2003
@@ -176,6 +176,16 @@
 	return sreq;
 }
 
+void __scsi_release_request(struct scsi_request *sreq)
+{
+	if (likely(sreq->sr_command != NULL)) {
+		struct scsi_cmnd *cmd = sreq->sr_command;
+
+		sreq->sr_command = NULL;
+		scsi_next_command(cmd);
+	}
+}
+
 /*
  * Function:    scsi_release_request
  *
@@ -187,14 +197,7 @@
  */
 void scsi_release_request(struct scsi_request *sreq)
 {
-	if (likely(sreq->sr_command != NULL)) {
-    		struct request_queue *q = sreq->sr_device->request_queue;
-
-		scsi_put_command(sreq->sr_command);
-		sreq->sr_command = NULL;
-		scsi_queue_next_request(q, NULL);
-	}
-
+	__scsi_release_request(sreq);
 	kfree(sreq);
 }
 
--- 1.51/drivers/scsi/scsi_error.c	Sun Apr 27 06:46:14 2003
+++ edited/drivers/scsi/scsi_error.c	Wed Apr 30 22:09:21 2003
@@ -1412,8 +1412,7 @@
 	 * now that error recovery is done, we will need to ensure that these
 	 * requests are started.
 	 */
-	list_for_each_entry(sdev, &shost->my_devices, siblings)
-		blk_run_queue(sdev->request_queue);
+	scsi_run_host_queues(shost);
 }
 
 /**
@@ -1649,7 +1648,6 @@
 	struct scsi_cmnd *scmd = scsi_get_command(dev, GFP_KERNEL);
 	struct request req;
 	int rtn;
-	struct request_queue *q;
 
 	scmd->request = &req;
 	memset(&scmd->eh_timeout, 0, sizeof(scmd->eh_timeout));
@@ -1701,8 +1699,6 @@
 	}
 
 	scsi_delete_timer(scmd);
-	q = scmd->device->request_queue;
-	scsi_put_command(scmd);
-	scsi_queue_next_request(q, NULL);
+	scsi_next_command(scmd);
 	return rtn;
 }
--- 1.88/drivers/scsi/scsi_lib.c	Sun Apr 27 10:19:35 2003
+++ edited/drivers/scsi/scsi_lib.c	Wed Apr 30 22:09:21 2003
@@ -181,19 +181,12 @@
 		 void (*done)(struct scsi_cmnd *),
 		 int timeout, int retries)
 {
-	struct request_queue *q;
-
 	/*
 	 * If the upper level driver is reusing these things, then
 	 * we should release the low-level block now.  Another one will
 	 * be allocated later when this request is getting queued.
 	 */
-	if (sreq->sr_command) {
-		q = sreq->sr_command->device->request_queue;
-		scsi_put_command(sreq->sr_command);
-		sreq->sr_command = NULL;
-		scsi_queue_next_request(q, NULL);
-	}
+	__scsi_release_request(sreq);
 
 	/*
 	 * Our own function scsi_done (which marks the host as not busy,
@@ -239,7 +232,6 @@
 void scsi_wait_req(struct scsi_request *sreq, const void *cmnd, void *buffer,
 		   unsigned bufflen, int timeout, int retries)
 {
-	struct request_queue *q;
 	DECLARE_COMPLETION(wait);
 	
 	sreq->sr_request->waiting = &wait;
@@ -250,12 +242,7 @@
 	wait_for_completion(&wait);
 	sreq->sr_request->waiting = NULL;
 
-	if (sreq->sr_command) {
-		q = sreq->sr_command->device->request_queue;
-		scsi_put_command(sreq->sr_command);
-		scsi_queue_next_request(q, NULL);
-		sreq->sr_command = NULL;
-	}
+	__scsi_release_request(sreq);
 }
 
 /*
@@ -370,77 +357,26 @@
 }
 
 /*
- * Function:    scsi_queue_next_request()
+ * Function:	scsi_run_queue()
  *
- * Purpose:     Handle post-processing of completed commands.
+ * Purpose:	Select a proper request queue to serve next
  *
- * Arguments:   cmd	- command that may need to be requeued.
+ * Arguments:	q	- last request's queue
  *
  * Returns:     Nothing
  *
- * Notes:       After command completion, there may be blocks left
- *              over which weren't finished by the previous command
- *              this can be for a number of reasons - the main one is
- *              that a medium error occurred, and the sectors after
- *              the bad block need to be re-read.
- *
- *              If cmd is NULL, it means that the previous command
- *              was completely finished, and we should simply start
- *              a new command, if possible.
- *
- *		This is where a lot of special case code has begun to
- *		accumulate.  It doesn't really affect readability or
- *		anything, but it might be considered architecturally
- *		inelegant.  If more of these special cases start to
- *		accumulate, I am thinking along the lines of implementing
- *		an atexit() like technology that gets run when commands
- *		complete.  I am not convinced that it is worth the
- *		added overhead, however.  Right now as things stand,
- *		there are simple conditional checks, and most hosts
- *		would skip past.
- *
- *		Another possible solution would be to tailor different
- *		handler functions, sort of like what we did in scsi_merge.c.
- *		This is probably a better solution, but the number of different
- *		permutations grows as 2**N, and if too many more special cases
- *		get added, we start to get screwed.
+ * Notes:	The previous command was completely finished, start
+ *		a new one if possible.
  */
-void scsi_queue_next_request(request_queue_t *q, struct scsi_cmnd *cmd)
+static void scsi_run_queue(struct request_queue *q)
 {
-	struct scsi_device *sdev;
-	struct Scsi_Host *shost;
+	struct scsi_device *sdev = q->queuedata;
+	struct Scsi_Host *shost = sdev->host;
 	unsigned long flags;
 
-	if (cmd != NULL) {
-
-		/*
-		 * For some reason, we are not done with this request.
-		 * This happens for I/O errors in the middle of the request,
-		 * in which case we need to request the blocks that come after
-		 * the bad sector.
-		 */
-		spin_lock_irqsave(q->queue_lock, flags);
-		cmd->request->special = cmd;
-		if (blk_rq_tagged(cmd->request))
-			blk_queue_end_tag(q, cmd->request);
-
-		/*
-		 * set REQ_SPECIAL - we have a command
-		 * clear REQ_DONTPREP - we assume the sg table has been 
-		 *	nuked so we need to set it up again.
-		 */
-		cmd->request->flags |= REQ_SPECIAL;
-		cmd->request->flags &= ~REQ_DONTPREP;
-		__elv_add_request(q, cmd->request, 0, 0);
-		spin_unlock_irqrestore(q->queue_lock, flags);
-	}
-
-	sdev = q->queuedata;
-
 	if (sdev->single_lun)
 		scsi_single_lun_run(sdev);
 
-	shost = sdev->host;
 	spin_lock_irqsave(shost->host_lock, flags);
 	while (!list_empty(&shost->starved_list) &&
 	       !shost->host_blocked && !shost->host_self_blocked &&
@@ -478,6 +414,61 @@
 }
 
 /*
+ * Function:	scsi_requeue_command()
+ *
+ * Purpose:	Handle post-processing of completed commands.
+ *
+ * Arguments:	q	- queue to operate on
+ *		cmd	- command that may need to be requeued.
+ *
+ * Returns:	Nothing
+ *
+ * Notes:	After command completion, there may be blocks left
+ *		over which weren't finished by the previous command
+ *		this can be for a number of reasons - the main one is
+ *		I/O errors in the middle of the request, in which case
+ *		we need to request the blocks that come after the bad
+ *		sector.
+ */
+static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(q->queue_lock, flags);
+	cmd->request->special = cmd;
+	if (blk_rq_tagged(cmd->request))
+		blk_queue_end_tag(q, cmd->request);
+
+	/*
+	 * set REQ_SPECIAL - we have a command
+	 * clear REQ_DONTPREP - we assume the sg table has been 
+	 *	nuked so we need to set it up again.
+	 */
+	cmd->request->flags |= REQ_SPECIAL;
+	cmd->request->flags &= ~REQ_DONTPREP;
+	__elv_add_request(q, cmd->request, 0, 0);
+	spin_unlock_irqrestore(q->queue_lock, flags);
+
+	scsi_run_queue(q);
+}
+
+void scsi_next_command(struct scsi_cmnd *cmd)
+{
+	struct request_queue *q = cmd->device->request_queue;
+
+	scsi_put_command(cmd);
+	scsi_run_queue(q);
+}
+
+void scsi_run_host_queues(struct Scsi_Host *shost)
+{
+	struct scsi_device *sdev;
+
+	list_for_each_entry(sdev, &shost->my_devices, siblings)
+		scsi_run_queue(sdev->request_queue);
+}
+
+/*
  * Function:    scsi_end_request()
  *
  * Purpose:     Post-processing of completed commands called from interrupt
@@ -517,7 +506,7 @@
 			 * Bleah.  Leftovers again.  Stick the leftovers in
 			 * the front of the queue, and goose the queue again.
 			 */
-			scsi_queue_next_request(q, cmd);
+			scsi_requeue_command(q, cmd);
 		}
 		return cmd;
 	}
@@ -534,8 +523,7 @@
 	 * This will goose the queue request function at the end, so we don't
 	 * need to worry about launching another command.
 	 */
-	scsi_put_command(cmd);
-	scsi_queue_next_request(q, NULL);
+	scsi_next_command(cmd);
 	return NULL;
 }
 
@@ -661,6 +649,18 @@
  *              In other words, if there are no bounce buffers
  *              (the normal case for most drivers), we don't need
  *              the logic to deal with cleaning up afterwards.
+ *
+ *		We must do one of several things here:
+ *
+ *		a) Call scsi_end_request.  This will finish off the
+ *		   specified number of sectors.  If we are done, the
+ *		   command block will be released, and the queue
+ *		   function will be goosed.  If we are not done, then
+ *		   scsi_end_request will directly goose the queue.
+ *
+ *		b) We can just use scsi_requeue_command() here.  This would
+ *		   be used if we just wanted to retry, for example.
+ *
  */
 void scsi_io_completion(struct scsi_cmnd *cmd, int good_sectors,
 			int block_sectors)
@@ -672,19 +672,6 @@
 	int clear_errors = 1;
 
 	/*
-	 * We must do one of several things here:
-	 *
-	 *	Call scsi_end_request.  This will finish off the specified
-	 *	number of sectors.  If we are done, the command block will
-	 *	be released, and the queue function will be goosed.  If we
-	 *	are not done, then scsi_end_request will directly goose
-	 *	the queue.
-	 *
-	 *	We can just use scsi_queue_next_request() here.  This
-	 *	would be used if we just wanted to retry, for example.
-	 *
-	 */
-	/*
 	 * Free up any indirection buffers we allocated for DMA purposes. 
 	 * For the case of a READ, we need to copy the data out of the
 	 * bounce buffer and into the real buffer.
@@ -783,7 +770,7 @@
 			 */
 			if (cmd->sense_buffer[12] == 0x04 &&
 			    cmd->sense_buffer[13] == 0x01) {
-				scsi_queue_next_request(q, cmd);
+				scsi_requeue_command(q, cmd);
 				return;
 			}
 			if ((cmd->sense_buffer[2] & 0xf) == UNIT_ATTENTION) {
@@ -802,7 +789,7 @@
 				 	* media change, so we just retry the
 				 	* request and see what happens.  
 				 	*/
-					scsi_queue_next_request(q, cmd);
+					scsi_requeue_command(q, cmd);
 					return;
 				}
 			}
@@ -822,7 +809,7 @@
 				 * This will cause a retry with a 6-byte
 				 * command.
 				 */
-				scsi_queue_next_request(q, cmd);
+				scsi_requeue_command(q, cmd);
 				result = 0;
 			} else {
 				cmd = scsi_end_request(cmd, 0, this_count, 1);
@@ -854,7 +841,7 @@
 		 * recovery reasons.  Just retry the request
 		 * and see what happens.  
 		 */
-		scsi_queue_next_request(q, cmd);
+		scsi_requeue_command(q, cmd);
 		return;
 	}
 	if (result) {
@@ -1320,15 +1307,8 @@
  */
 void scsi_unblock_requests(struct Scsi_Host *shost)
 {
-	struct scsi_device *sdev;
-
 	shost->host_self_blocked = 0;
-
-	/*
-	 * Now that we are unblocked, try to start the queues.
-	 */
-	list_for_each_entry(sdev, &shost->my_devices, siblings)
-		scsi_queue_next_request(sdev->request_queue, NULL);
+	scsi_run_host_queues(shost);
 }
 
 /*
--- 1.1/drivers/scsi/scsi_priv.h	Sat Apr 26 20:40:32 2003
+++ edited/drivers/scsi/scsi_priv.h	Wed Apr 30 22:09:21 2003
@@ -73,6 +73,7 @@
 extern int scsi_insert_special_req(struct scsi_request *sreq, int);
 extern void scsi_init_cmd_from_req(struct scsi_cmnd *cmd,
 		struct scsi_request *sreq);
+extern void __scsi_release_request(struct scsi_request *sreq);
 
 /* scsi_error.c */
 extern void scsi_times_out(struct scsi_cmnd *cmd);
@@ -84,8 +85,8 @@
 extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
 extern void scsi_setup_cmd_retry(struct scsi_cmnd *cmd);
 extern int scsi_queue_insert(struct scsi_cmnd *cmd, int reason);
-extern void scsi_queue_next_request(struct request_queue *q,
-			struct scsi_cmnd *cmd);
+extern void scsi_next_command(struct scsi_cmnd *cmd);
+extern void scsi_run_host_queues(struct Scsi_Host *shost);
 extern struct request_queue *scsi_alloc_queue(struct scsi_device *sdev);
 extern void scsi_free_queue(struct request_queue *q);
 extern int scsi_init_queue(void);
