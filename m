From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi_requeuest_fn
Date: Sun, 27 Apr 2003 20:53:03 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030427205303.A31125@lst.de>
References: <20030427170440.A29493@lst.de> <20030427110711.A21878@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:25358 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S261474AbTD0SlB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 14:41:01 -0400
Content-Disposition: inline
In-Reply-To: <20030427110711.A21878@beaverton.ibm.com>; from patmans@us.ibm.com on Sun, Apr 27, 2003 at 11:07:11AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Sun, Apr 27, 2003 at 11:07:11AM -0700, Patrick Mansfield wrote:
> You might as well remove all or most of the comments, none of them add
> much information, the comments might as well say "we are about to
> loop" or "we are about to call scsi_dispatch_cmd".

> The scsi_init_cmd_errh(cmd) will oops anyway if cmd == NULL, so just remove
> the check.
>
Okay, updated patch below.

> Also - do you have a patch rollup somewhere (in case these recent
> patches aren't applied soon)?

Currently I don't have.  I'll merge everything together if this isn't
applied until tomorrow.


--- 1.84/drivers/scsi/scsi_lib.c	Mon Apr 21 10:17:33 2003
+++ edited/drivers/scsi/scsi_lib.c	Sun Apr 27 18:54:46 2003
@@ -1140,89 +1128,56 @@
  *
  * Lock status: IO request lock assumed to be held when called.
  */
-static void scsi_request_fn(request_queue_t *q)
+static void scsi_request_fn(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
 	struct scsi_cmnd *cmd;
 	struct request *req;
-	unsigned long flags;
-
-	/*
-	 * To start with, we keep looping until the queue is empty, or until
-	 * the host is no longer able to accept any more requests.
-	 */
-	for (;;) {
-		if (blk_queue_plugged(q))
-			goto completed;
 
+	while (!blk_queue_plugged(q)) {
 		/*
 		 * get next queueable request.  We do this early to make sure
 		 * that the request is fully prepared even if we cannot 
 		 * accept it.
 		 */
 		req = elv_next_request(q);
-
-		if (!req)
-			goto completed;
-
-		if (!scsi_dev_queue_ready(q, sdev))
-			goto completed;
-
-		/*
-		 * Remove the request from the request list.
-		 */
-		if (!(blk_queue_tagged(q) && (blk_queue_start_tag(q, req) == 0)))
+		if (!req || !scsi_dev_queue_ready(q, sdev))
+			break;
+		if (!(blk_queue_tagged(q) && !blk_queue_start_tag(q, req)))
 			blkdev_dequeue_request(req);
-
 		sdev->device_busy++;
-		spin_unlock_irq(q->queue_lock);
 
-		spin_lock_irqsave(shost->host_lock, flags);
-		if (!scsi_host_queue_ready(q, shost, sdev))
-			goto host_lock_held;
+		spin_unlock(q->queue_lock);
+		spin_lock(shost->host_lock);
 
+		if (!scsi_host_queue_ready(q, shost, sdev))
+			goto not_ready;
 		if (sdev->single_lun) {
 			if (sdev->sdev_target->starget_sdev_user &&
-			    (sdev->sdev_target->starget_sdev_user != sdev))
-				goto host_lock_held;
-			else
-				sdev->sdev_target->starget_sdev_user = sdev;
+			    sdev->sdev_target->starget_sdev_user != sdev)
+				goto not_ready;
+			sdev->sdev_target->starget_sdev_user = sdev;
 		}
 
 		shost->host_busy++;
-		spin_unlock_irqrestore(shost->host_lock, flags);
-
-		cmd = req->special;
 
 		/*
-		 * Should be impossible for a correctly prepared request
-		 * please mail the stack trace to linux-scsi@vger.kernel.org
-		 */
-		BUG_ON(!cmd);
-
-		/*
-		 * Finally, initialize any error handling parameters, and set up
-		 * the timers for timeouts.
+		 * XXX(hch): This is rather suboptimal, scsi_dispatch_cmd will
+		 *		take the lock again.
 		 */
+		spin_unlock_irq(shost->host_lock);
+		cmd = req->special;
 		scsi_init_cmd_errh(cmd);
-
-		/*
-		 * Dispatch the command to the low-level driver.
-		 */
 		scsi_dispatch_cmd(cmd);
-
-		/*
-		 * Now we need to grab the lock again.  We are about to mess
-		 * with the request queue and try to find another command.
-		 */
 		spin_lock_irq(q->queue_lock);
 	}
-completed:
+
 	return;
 
-host_lock_held:
-	spin_unlock_irqrestore(shost->host_lock, flags);
+ not_ready:
+	spin_unlock_irq(shost->host_lock);
+
 	/*
 	 * lock q, handle tag, requeue req, and decrement device_busy. We
 	 * must return with queue_lock held.
