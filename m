From: Patrick Mansfield <patmans@us.ibm.com>
Subject: [patch] 2/5 scsi-locking-2.5 remove lock hierarchy
Date: Wed, 9 Apr 2003 16:47:01 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030409164701.B23701@beaverton.ibm.com>
References: <20030409164612.A23701@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e31.co.us.ibm.com ([32.97.110.129]:32218 "EHLO
	e31.co.us.ibm.com") by vger.kernel.org with ESMTP id S263952AbTDIXjI (for <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Apr 2003 19:39:08 -0400
Content-Disposition: inline
In-Reply-To: <20030409164612.A23701@beaverton.ibm.com>; from patmans@us.ibm.com on Wed, Apr 09, 2003 at 04:46:12PM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Get rid of the lock hierarchy for queue_lock and host_lock (even for the
single_lun case).

diff -purN -X /home/patman/dontdiff 01_slun_mod/drivers/scsi/scsi_lib.c 02_no_hier/drivers/scsi/scsi_lib.c
--- 01_slun_mod/drivers/scsi/scsi_lib.c	Wed Apr  9 12:39:15 2003
+++ 02_no_hier/drivers/scsi/scsi_lib.c	Wed Apr  9 12:39:20 2003
@@ -1088,9 +1088,10 @@ static inline int scsi_dev_queue_ready(s
 
 /*
  * scsi_host_queue_ready: if we can send requests to shost, return 1 else
- * return 0.
+ * return 0. We must end up running the queue again whenever 0 is
+ * returned, else IO can hang.
  *
- * Called with queue_lock and host_lock held.
+ * Called with host_lock held.
  */
 static inline int scsi_host_queue_ready(struct request_queue *q,
 				   struct Scsi_Host *shost,
@@ -1157,41 +1158,54 @@ static void scsi_request_fn(request_queu
 		if (blk_queue_plugged(q))
 			goto completed;
 
+		if (blk_queue_empty(q))
+			goto completed;
+
 		/*
 		 * get next queueable request.  We do this early to make sure
 		 * that the request is fully prepared even if we cannot 
-		 * accept it.  If there is no request, we'll detect this
-		 * lower down.
+		 * accept it.
 		 */
 		req = elv_next_request(q);
 
-		if (!scsi_dev_queue_ready(q, sdev))
+		if (!req) {
+			/*
+			 * If the device is busy, a returning I/O will
+			 * restart the queue. Otherwise, we have to plug
+			 * the queue
+			 */
+			if (sdev->device_busy == 0)
+				blk_plug_device(q);
 			goto completed;
+		}
 
-		spin_lock_irqsave(shost->host_lock, flags);
-		if (!scsi_host_queue_ready(q, shost, sdev))
-			goto after_host_lock;
-
-		if (sdev->single_lun && sdev->sdev_target->starget_sdev_user &&
-		    (sdev->sdev_target->starget_sdev_user != sdev))
-			goto after_host_lock;
+		if (!scsi_dev_queue_ready(q, sdev))
+			goto completed;
 
 		/*
-		 * If we couldn't find a request that could be queued, then we
-		 * can also quit.
+		 * Remove the request from the request list.
 		 */
-		if (blk_queue_empty(q))
-			goto after_host_lock;
+		if (!(blk_queue_tagged(q) && (blk_queue_start_tag(q, req) == 0)))
+			blkdev_dequeue_request(req);
 
-		if (!req) {
-			/* If the device is busy, a returning I/O
-			 * will restart the queue.  Otherwise, we have
-			 * to plug the queue */
-			if (sdev->device_busy == 1)
-				blk_plug_device(q);
-			goto after_host_lock;
+		sdev->device_busy++;
+		spin_unlock_irq(q->queue_lock);
+
+		spin_lock_irqsave(shost->host_lock, flags);
+		if (!scsi_host_queue_ready(q, shost, sdev))
+			goto host_lock_held;
+
+		if (sdev->single_lun) {
+			if (sdev->sdev_target->starget_sdev_user &&
+			    (sdev->sdev_target->starget_sdev_user != sdev))
+				goto host_lock_held;
+			else
+				sdev->sdev_target->starget_sdev_user = sdev;
 		}
 
+		shost->host_busy++;
+		spin_unlock_irqrestore(shost->host_lock, flags);
+
 		cmd = req->special;
 
 		/*
@@ -1201,26 +1215,6 @@ static void scsi_request_fn(request_queu
 		BUG_ON(!cmd);
 
 		/*
-		 * Finally, before we release the lock, we copy the
-		 * request to the command block, and remove the
-		 * request from the request list.  Note that we always
-		 * operate on the queue head - there is absolutely no
-		 * reason to search the list, because all of the
-		 * commands in this queue are for the same device.
-		 */
-		if (!(blk_queue_tagged(q) && (blk_queue_start_tag(q, req) == 0)))
-			blkdev_dequeue_request(req);
-	
-		if (sdev->single_lun)
-			sdev->sdev_target->starget_sdev_user = sdev;
-
-		shost->host_busy++;
-		spin_unlock_irqrestore(shost->host_lock, flags);
-
-		sdev->device_busy++;
-		spin_unlock_irq(q->queue_lock);
-
-		/*
 		 * Finally, initialize any error handling parameters, and set up
 		 * the timers for timeouts.
 		 */
@@ -1240,8 +1234,21 @@ static void scsi_request_fn(request_queu
 completed:
 	return;
 
-after_host_lock:
+host_lock_held:
 	spin_unlock_irqrestore(shost->host_lock, flags);
+	/*
+	 * lock q, handle tag, requeue req, and decrement device_busy. We
+	 * must return with queue_lock held.
+	 *
+	 * Decrementing device_busy without checking it is OK, as all such
+	 * cases (host limits or settings) should run the queue at some
+	 * later time.
+	 */
+	spin_lock_irq(q->queue_lock);
+	if (blk_rq_tagged(req))
+		blk_queue_end_tag(q, req);
+	__elv_add_request(q, req, 0, 0);
+	sdev->device_busy--;
 }
 
 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
