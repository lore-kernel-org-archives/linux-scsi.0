From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] scsi_requeuest_fn
Date: Sun, 27 Apr 2003 17:04:40 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030427170440.A29493@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.181.86]:5901 "EHLO verein.lst.de")
	by vger.kernel.org with ESMTP id S264661AbTD0Ow2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Apr 2003 10:52:28 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org

Okay, when doing some other stuff I looked over this one, and it's
a bit confusing to read:

 - using a goto completed where a simple break would be sufficient
 - using for (;;) for a perfectly fine while loop
 - ...

but what's more interesting is that the spinlock handling in here,
when we switch from sdev_lock/queue_lock to host_lock we
do a spin_unlock_irq followed by a spin_lock_irqsave - but we
we just enabled interrupts so the save isn't nessecary at all, even
more we can just do spin_unlock/spin_lock when keeping them
disabled.  Also we drop host_lock in the middle of this function,
just to reacquire it a tad later in scsi_dispatch_cmd, but fixing
that need a bit more thinking as there's another caller for
scsi_dispatch_cmd.


--- 1.84/drivers/scsi/scsi_lib.c	Mon Apr 21 10:17:33 2003
+++ edited/drivers/scsi/scsi_lib.c	Sun Apr 27 14:19:35 2003
@@ -1140,66 +1128,61 @@
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
 
 	/*
 	 * To start with, we keep looping until the queue is empty, or until
 	 * the host is no longer able to accept any more requests.
 	 */
-	for (;;) {
-		if (blk_queue_plugged(q))
-			goto completed;
-
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
+		if (!req || !scsi_dev_queue_ready(q, sdev))
+			break;
 
 		/*
 		 * Remove the request from the request list.
 		 */
-		if (!(blk_queue_tagged(q) && (blk_queue_start_tag(q, req) == 0)))
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
-
 		shost->host_busy++;
-		spin_unlock_irqrestore(shost->host_lock, flags);
-
-		cmd = req->special;
 
 		/*
-		 * Should be impossible for a correctly prepared request
-		 * please mail the stack trace to linux-scsi@vger.kernel.org
+		 * XXX(hch): This is rather suboptimal, scsi_dispatch_cmd will
+		 *		take the lock again.
 		 */
-		BUG_ON(!cmd);
+		spin_unlock_irq(shost->host_lock);
+
+		cmd = req->special;
+		if (unlikely(cmd == NULL)) {
+			printk(KERN_CRIT "impossible request in %s.\n"
+					 "please mail a stack trace to "
+					 "linux-scsi@vger.kernel.org",
+					 __FUNCTION__);
+			BUG();
+		}
 
 		/*
 		 * Finally, initialize any error handling parameters, and set up
@@ -1211,18 +1194,14 @@
 		 * Dispatch the command to the low-level driver.
 		 */
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
