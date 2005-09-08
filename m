From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI core: fix leakage of scsi_cmnd's
Date: Thu, 8 Sep 2005 16:49:20 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509081640260.4545-100000@iolanthe.rowland.org>
References: <1126199581.4845.49.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:9364 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1751391AbVIHUtV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 8 Sep 2005 16:49:21 -0400
In-Reply-To: <1126199581.4845.49.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: "Dailey, Nate" <Nate.Dailey@stratus.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 8 Sep 2005, James Bottomley wrote:

> Sigh, I might have guessed we'd have a leak somewhere ...
> 
> Is not a better way to fix this actually to have the
> scsi_requeue_command put the command and reset req->special to NULL?
> That way the command gets reprepared as well and the prep fn assumptions
> should be fully valid.  This would also correct what looks like a bug in
> the command transformation routines (The ones that convert ten byte
> commands to six byte ones if we get an illegal request response) ...
> they look to be assuming that scsi_requeue_command() will actually
> reissue the correct command instead of simply reusing the existing one.

This patch (as559b) does what you suggest.  It adds a new routine,
scsi_unprep_request, which gets called every place a request is requeued.  
(That includes scsi_queue_insert as well as scsi_requeue_command.)  It
also changes scsi_kill_requests to make it call __scsi_done with result
equal to DID_NO_CONNECT << 16.  (I'm not sure if it's necessary to call
scsi_init_cmd_errh here; maybe you can check on that.)  Finally, the
patch changes the return value from scsi_end_request, to avoid returning a
stale pointer in the case where the request was requeued.  Fortunately the
return value is used in only place, and the change actually simplified it.

This hasn't been tested very thoroughly, so please look through it 
carefully.

Alan Stern



Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

Index: 2613mm1/drivers/scsi/scsi_lib.c
===================================================================
--- 2613mm1.orig/drivers/scsi/scsi_lib.c
+++ 2613mm1/drivers/scsi/scsi_lib.c
@@ -97,6 +97,30 @@ int scsi_insert_special_req(struct scsi_
 }
 
 static void scsi_run_queue(struct request_queue *q);
+static void scsi_release_buffers(struct scsi_cmnd *cmd);
+
+/*
+ * Function:	scsi_unprep_request()
+ *
+ * Purpose:	Remove all preparation done for a request, including its
+ *		associated scsi_cmnd, so that it can be requeued.
+ *
+ * Arguments:	req	- request to unprepare
+ *
+ * Lock status:	Assumed that no locks are held upon entry.
+ *
+ * Returns:	Nothing.
+ */
+static void scsi_unprep_request(struct request *req)
+{
+	struct scsi_cmnd *cmd = req->special;
+
+	req->flags &= ~REQ_DONTPREP;
+	req->special = (req->flags & REQ_SPECIAL) ? cmd->sc_request : NULL;
+
+	scsi_release_buffers(cmd);
+	scsi_put_command(cmd);
+}
 
 /*
  * Function:    scsi_queue_insert()
@@ -116,12 +140,14 @@ static void scsi_run_queue(struct reques
  *              commands.
  * Notes:       This could be called either from an interrupt context or a
  *              normal process context.
+ * Notes:	Upon return, cmd is a stale pointer.
  */
 int scsi_queue_insert(struct scsi_cmnd *cmd, int reason)
 {
 	struct Scsi_Host *host = cmd->device->host;
 	struct scsi_device *device = cmd->device;
 	struct request_queue *q = device->request_queue;
+	struct request *req = cmd->request;
 	unsigned long flags;
 
 	SCSI_LOG_MLQUEUE(1,
@@ -162,8 +188,9 @@ int scsi_queue_insert(struct scsi_cmnd *
 	 * function.  The SCSI request function detects the blocked condition
 	 * and plugs the queue appropriately.
          */
+	scsi_unprep_request(req);
 	spin_lock_irqsave(q->queue_lock, flags);
-	blk_requeue_request(q, cmd->request);
+	blk_requeue_request(q, req);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	scsi_run_queue(q);
@@ -552,15 +579,16 @@ static void scsi_run_queue(struct reques
  *		I/O errors in the middle of the request, in which case
  *		we need to request the blocks that come after the bad
  *		sector.
+ * Notes:	Upon return, cmd is a stale pointer.
  */
 static void scsi_requeue_command(struct request_queue *q, struct scsi_cmnd *cmd)
 {
+	struct request *req = cmd->request;
 	unsigned long flags;
 
-	cmd->request->flags &= ~REQ_DONTPREP;
-
+	scsi_unprep_request(req);
 	spin_lock_irqsave(q->queue_lock, flags);
-	blk_requeue_request(q, cmd->request);
+	blk_requeue_request(q, req);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	scsi_run_queue(q);
@@ -595,13 +623,14 @@ void scsi_run_host_queues(struct Scsi_Ho
  *
  * Lock status: Assumed that lock is not held upon entry.
  *
- * Returns:     cmd if requeue done or required, NULL otherwise
+ * Returns:     cmd if requeue required, NULL otherwise.
  *
  * Notes:       This is called for block device requests in order to
  *              mark some number of sectors as complete.
  * 
  *		We are guaranteeing that the request queue will be goosed
  *		at some point during this call.
+ * Notes:	If cmd was requeued, upon return it will be a stale pointer.
  */
 static struct scsi_cmnd *scsi_end_request(struct scsi_cmnd *cmd, int uptodate,
 					  int bytes, int requeue)
@@ -624,14 +653,15 @@ static struct scsi_cmnd *scsi_end_reques
 		if (!uptodate && blk_noretry_request(req))
 			end_that_request_chunk(req, 0, leftover);
 		else {
-			if (requeue)
+			if (requeue) {
 				/*
 				 * Bleah.  Leftovers again.  Stick the
 				 * leftovers in the front of the
 				 * queue, and goose the queue again.
 				 */
 				scsi_requeue_command(q, cmd);
-
+				cmd = NULL;
+			}
 			return cmd;
 		}
 	}
@@ -857,15 +887,13 @@ void scsi_io_completion(struct scsi_cmnd
 		 * requeueing right here - we will requeue down below
 		 * when we handle the bad sectors.
 		 */
-		cmd = scsi_end_request(cmd, 1, good_bytes, result == 0);
 
 		/*
-		 * If the command completed without error, then either finish off the
-		 * rest of the command, or start a new one.
+		 * If the command completed without error, then either
+		 * finish off the rest of the command, or start a new one.
 		 */
-		if (result == 0 || cmd == NULL ) {
+		if (scsi_end_request(cmd, 1, good_bytes, result == 0) == NULL)
 			return;
-		}
 	}
 	/*
 	 * Now, if we were good little boys and girls, Santa left us a request
@@ -880,7 +908,7 @@ void scsi_io_completion(struct scsi_cmnd
 				 * and quietly refuse further access.
 				 */
 				cmd->device->changed = 1;
-				cmd = scsi_end_request(cmd, 0,
+				scsi_end_request(cmd, 0,
 						this_count, 1);
 				return;
 			} else {
@@ -914,7 +942,7 @@ void scsi_io_completion(struct scsi_cmnd
 				scsi_requeue_command(q, cmd);
 				result = 0;
 			} else {
-				cmd = scsi_end_request(cmd, 0, this_count, 1);
+				scsi_end_request(cmd, 0, this_count, 1);
 				return;
 			}
 			break;
@@ -929,7 +957,7 @@ void scsi_io_completion(struct scsi_cmnd
 			}
 			printk(KERN_INFO "Device %s not ready.\n",
 			       req->rq_disk ? req->rq_disk->disk_name : "");
-			cmd = scsi_end_request(cmd, 0, this_count, 1);
+			scsi_end_request(cmd, 0, this_count, 1);
 			return;
 		case VOLUME_OVERFLOW:
 			printk(KERN_INFO "Volume overflow <%d %d %d %d> CDB: ",
@@ -938,7 +966,7 @@ void scsi_io_completion(struct scsi_cmnd
 			       (int)cmd->device->id, (int)cmd->device->lun);
 			__scsi_print_command(cmd->data_cmnd);
 			scsi_print_sense("", cmd);
-			cmd = scsi_end_request(cmd, 0, block_bytes, 1);
+			scsi_end_request(cmd, 0, block_bytes, 1);
 			return;
 		default:
 			break;
@@ -971,7 +999,7 @@ void scsi_io_completion(struct scsi_cmnd
 		block_bytes = req->hard_cur_sectors << 9;
 		if (!block_bytes)
 			block_bytes = req->data_len;
-		cmd = scsi_end_request(cmd, 0, block_bytes, 1);
+		scsi_end_request(cmd, 0, block_bytes, 1);
 	}
 }
 EXPORT_SYMBOL(scsi_io_completion);
@@ -1335,19 +1363,24 @@ static inline int scsi_host_queue_ready(
 }
 
 /*
- * Kill requests for a dead device
+ * Kill a request for a dead device
  */
-static void scsi_kill_requests(request_queue_t *q)
+static void scsi_kill_request(struct request *req, request_queue_t *q)
 {
-	struct request *req;
+	struct scsi_cmnd *cmd = req->special;
 
-	while ((req = elv_next_request(q)) != NULL) {
-		blkdev_dequeue_request(req);
-		req->flags |= REQ_QUIET;
-		while (end_that_request_first(req, 0, req->nr_sectors))
-			;
-		end_that_request_last(req);
-	}
+	spin_unlock(q->queue_lock);
+	if (unlikely(cmd == NULL)) {
+		printk(KERN_CRIT "impossible request in %s.\n",
+				 __FUNCTION__);
+		BUG();
+	}
+
+	scsi_init_cmd_errh(cmd);
+	cmd->result = DID_NO_CONNECT << 16;
+	atomic_inc(&cmd->device->iorequest_cnt);
+	__scsi_done(cmd);
+	spin_lock(q->queue_lock);
 }
 
 /*
@@ -1370,7 +1403,8 @@ static void scsi_request_fn(struct reque
 
 	if (!sdev) {
 		printk("scsi: killing requests for dead queue\n");
-		scsi_kill_requests(q);
+		while ((req = elv_next_request(q)) != NULL)
+			scsi_kill_request(req, q);
 		return;
 	}
 
@@ -1398,10 +1432,7 @@ static void scsi_request_fn(struct reque
 			printk(KERN_ERR "scsi%d (%d:%d): rejecting I/O to offline device\n",
 			       sdev->host->host_no, sdev->id, sdev->lun);
 			blkdev_dequeue_request(req);
-			req->flags |= REQ_QUIET;
-			while (end_that_request_first(req, 0, req->nr_sectors))
-				;
-			end_that_request_last(req);
+			scsi_kill_request(req, q);
 			continue;
 		}
 
@@ -1414,6 +1445,14 @@ static void scsi_request_fn(struct reque
 		sdev->device_busy++;
 
 		spin_unlock(q->queue_lock);
+		cmd = req->special;
+		if (unlikely(cmd == NULL)) {
+			printk(KERN_CRIT "impossible request in %s.\n"
+					 "please mail a stack trace to "
+					 "linux-scsi@vger.kernel.org",
+					 __FUNCTION__);
+			BUG();
+		}
 		spin_lock(shost->host_lock);
 
 		if (!scsi_host_queue_ready(q, shost, sdev))
@@ -1432,15 +1471,6 @@ static void scsi_request_fn(struct reque
 		 */
 		spin_unlock_irq(shost->host_lock);
 
-		cmd = req->special;
-		if (unlikely(cmd == NULL)) {
-			printk(KERN_CRIT "impossible request in %s.\n"
-					 "please mail a stack trace to "
-					 "linux-scsi@vger.kernel.org",
-					 __FUNCTION__);
-			BUG();
-		}
-
 		/*
 		 * Finally, initialize any error handling parameters, and set up
 		 * the timers for timeouts.
@@ -1476,6 +1506,7 @@ static void scsi_request_fn(struct reque
 	 * cases (host limits or settings) should run the queue at some
 	 * later time.
 	 */
+	scsi_unprep_request(req);
 	spin_lock_irq(q->queue_lock);
 	blk_requeue_request(q, req);
 	sdev->device_busy--;

