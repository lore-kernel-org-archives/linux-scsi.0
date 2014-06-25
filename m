From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 05/14] scsi: push host_lock down into scsi_{host,target}_queue_ready
Date: Wed, 25 Jun 2014 18:51:52 +0200
Message-ID: <1403715121-1201-6-git-send-email-hch@lst.de>
References: <1403715121-1201-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1403715121-1201-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Prepare for not taking a host-wide lock in the dispatch path by pushing
the lock down into the places that actually need it.  Note that this
patch is just a preparation step, as it will actually increase lock
roundtrips and thus decrease performance on its own.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_lib.c |   75 ++++++++++++++++++++++++-----------------------
 1 file changed, 39 insertions(+), 36 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6989b6f..18e6449 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1300,18 +1300,18 @@ static inline int scsi_dev_queue_ready(struct request_queue *q,
 /*
  * scsi_target_queue_ready: checks if there we can send commands to target
  * @sdev: scsi device on starget to check.
- *
- * Called with the host lock held.
  */
 static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 					   struct scsi_device *sdev)
 {
 	struct scsi_target *starget = scsi_target(sdev);
+	int ret = 0;
 
+	spin_lock_irq(shost->host_lock);
 	if (starget->single_lun) {
 		if (starget->starget_sdev_user &&
 		    starget->starget_sdev_user != sdev)
-			return 0;
+			goto out;
 		starget->starget_sdev_user = sdev;
 	}
 
@@ -1319,57 +1319,66 @@ static inline int scsi_target_queue_ready(struct Scsi_Host *shost,
 		/*
 		 * unblock after target_blocked iterates to zero
 		 */
-		if (--starget->target_blocked == 0) {
-			SCSI_LOG_MLQUEUE(3, starget_printk(KERN_INFO, starget,
-					 "unblocking target at zero depth\n"));
-		} else
-			return 0;
+		if (--starget->target_blocked != 0)
+			goto out;
+
+		SCSI_LOG_MLQUEUE(3, starget_printk(KERN_INFO, starget,
+				 "unblocking target at zero depth\n"));
 	}
 
 	if (scsi_target_is_busy(starget)) {
 		list_move_tail(&sdev->starved_entry, &shost->starved_list);
-		return 0;
+		goto out;
 	}
 
-	return 1;
+	scsi_target(sdev)->target_busy++;
+	ret = 1;
+out:
+	spin_unlock_irq(shost->host_lock);
+	return ret;
 }
 
 /*
  * scsi_host_queue_ready: if we can send requests to shost, return 1 else
  * return 0. We must end up running the queue again whenever 0 is
  * returned, else IO can hang.
- *
- * Called with host_lock held.
  */
 static inline int scsi_host_queue_ready(struct request_queue *q,
 				   struct Scsi_Host *shost,
 				   struct scsi_device *sdev)
 {
+	int ret = 0;
+
+	spin_lock_irq(shost->host_lock);
+
 	if (scsi_host_in_recovery(shost))
-		return 0;
+		goto out;
 	if (shost->host_busy == 0 && shost->host_blocked) {
 		/*
 		 * unblock after host_blocked iterates to zero
 		 */
-		if (--shost->host_blocked == 0) {
-			SCSI_LOG_MLQUEUE(3,
-				shost_printk(KERN_INFO, shost,
-					     "unblocking host at zero depth\n"));
-		} else {
-			return 0;
-		}
+		if (--shost->host_blocked != 0)
+			goto out;
+
+		SCSI_LOG_MLQUEUE(3,
+			shost_printk(KERN_INFO, shost,
+				     "unblocking host at zero depth\n"));
 	}
 	if (scsi_host_is_busy(shost)) {
 		if (list_empty(&sdev->starved_entry))
 			list_add_tail(&sdev->starved_entry, &shost->starved_list);
-		return 0;
+		goto out;
 	}
 
 	/* We're OK to process the command, so we can't be starved */
 	if (!list_empty(&sdev->starved_entry))
 		list_del_init(&sdev->starved_entry);
 
-	return 1;
+	shost->host_busy++;
+	ret = 1;
+out:
+	spin_unlock_irq(shost->host_lock);
+	return ret;
 }
 
 /*
@@ -1550,7 +1559,7 @@ static void scsi_request_fn(struct request_queue *q)
 			blk_start_request(req);
 		sdev->device_busy++;
 
-		spin_unlock(q->queue_lock);
+		spin_unlock_irq(q->queue_lock);
 		cmd = req->special;
 		if (unlikely(cmd == NULL)) {
 			printk(KERN_CRIT "impossible request in %s.\n"
@@ -1560,7 +1569,6 @@ static void scsi_request_fn(struct request_queue *q)
 			blk_dump_rq_flags(req, "foo");
 			BUG();
 		}
-		spin_lock(shost->host_lock);
 
 		/*
 		 * We hit this when the driver is using a host wide
@@ -1571,9 +1579,11 @@ static void scsi_request_fn(struct request_queue *q)
 		 * a run when a tag is freed.
 		 */
 		if (blk_queue_tagged(q) && !blk_rq_tagged(req)) {
+			spin_lock_irq(shost->host_lock);
 			if (list_empty(&sdev->starved_entry))
 				list_add_tail(&sdev->starved_entry,
 					      &shost->starved_list);
+			spin_unlock_irq(shost->host_lock);
 			goto not_ready;
 		}
 
@@ -1581,16 +1591,7 @@ static void scsi_request_fn(struct request_queue *q)
 			goto not_ready;
 
 		if (!scsi_host_queue_ready(q, shost, sdev))
-			goto not_ready;
-
-		scsi_target(sdev)->target_busy++;
-		shost->host_busy++;
-
-		/*
-		 * XXX(hch): This is rather suboptimal, scsi_dispatch_cmd will
-		 *		take the lock again.
-		 */
-		spin_unlock_irq(shost->host_lock);
+			goto host_not_ready;
 
 		/*
 		 * Finally, initialize any error handling parameters, and set up
@@ -1613,9 +1614,11 @@ static void scsi_request_fn(struct request_queue *q)
 
 	return;
 
- not_ready:
+ host_not_ready:
+	spin_lock_irq(shost->host_lock);
+	scsi_target(sdev)->target_busy--;
 	spin_unlock_irq(shost->host_lock);
-
+ not_ready:
 	/*
 	 * lock q, handle tag, requeue req, and decrement device_busy. We
 	 * must return with queue_lock held.
-- 
1.7.10.4
