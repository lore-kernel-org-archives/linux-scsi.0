From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] Fix a use-after-free triggered by device removal
Date: Mon, 03 Sep 2012 14:12:34 +0000
Message-ID: <5044BAD2.7060901@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:60792 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756431Ab2ICOMh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Sep 2012 10:12:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

If the put_device() call in scsi_request_fn() drops the sdev refcount
to zero then the spin_lock() call after the put_device() call triggers
a use-after-free. Avoid that by making sure that blk_cleanup_queue()
can only finish after all active scsi_request_fn() calls have returned.

Reported-by: Chanho Min <chanho.min@lge.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-core.c        |   21 ++++++++++++++++++++-
 block/blk-exec.c        |    2 +-
 block/blk.h             |    2 ++
 drivers/scsi/scsi_lib.c |   10 +---------
 include/linux/blkdev.h  |    5 +++++
 5 files changed, 29 insertions(+), 11 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b4dbdf..a668b71 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -293,6 +293,24 @@ void blk_sync_queue(struct request_queue *q)
 EXPORT_SYMBOL(blk_sync_queue);
 
 /**
+ * __blk_run_queue_uncond - run a single device queue independent of its state
+ * @q:	The queue to run
+ *
+ * Description:
+ *    Invoke request handling on a queue if there are any pending requests.
+ *    May be used to restart request handling after a request has completed.
+ *    This variant runs the queue whether or not the queue has been
+ *    stopped. Must be called with the queue lock held and interrupts
+ *    disabled. See also @blk_run_queue.
+ */
+void __blk_run_queue_uncond(struct request_queue *q)
+{
+	q->request_fn_active++;
+	q->request_fn(q);
+	q->request_fn_active--;
+}
+
+/**
  * __blk_run_queue - run a single device queue
  * @q:	The queue to run
  *
@@ -305,7 +323,7 @@ void __blk_run_queue(struct request_queue *q)
 	if (unlikely(blk_queue_stopped(q)))
 		return;
 
-	q->request_fn(q);
+	__blk_run_queue_uncond(q);
 }
 EXPORT_SYMBOL(__blk_run_queue);
 
@@ -388,6 +406,7 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 			__blk_run_queue(q);
 
 		drain |= q->nr_rqs_elvpriv;
+		drain |= q->request_fn_active;
 
 		/*
 		 * Unfortunately, requests are queued at and tracked from
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 8b6dc5b..f4f6f4d 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -72,7 +72,7 @@ void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
 	__blk_run_queue(q);
 	/* the queue is stopped so it won't be run */
 	if (rq->cmd_type == REQ_TYPE_PM_RESUME)
-		q->request_fn(q);
+		__blk_run_queue_uncond(q);
 	spin_unlock_irq(q->queue_lock);
 }
 EXPORT_SYMBOL_GPL(blk_execute_rq_nowait);
diff --git a/block/blk.h b/block/blk.h
index 2a0ea32..0b11e22 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -145,6 +145,8 @@ int blk_try_merge(struct request *rq, struct bio *bio);
 
 void blk_queue_congestion_threshold(struct request_queue *q);
 
+void __blk_run_queue_uncond(struct request_queue *q);
+
 int blk_dev_init(void);
 
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index ffd7773..9211e80 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1514,10 +1514,6 @@ static void scsi_request_fn(struct request_queue *q)
 	struct scsi_cmnd *cmd;
 	struct request *req;
 
-	if(!get_device(&sdev->sdev_gendev))
-		/* We must be tearing the block queue down already */
-		return;
-
 	/*
 	 * To start with, we keep looping until the queue is empty, or until
 	 * the host is no longer able to accept any more requests.
@@ -1626,11 +1622,7 @@ out_delay:
 	if (sdev->device_busy == 0)
 		blk_delay_queue(q, SCSI_QUEUE_DELAY);
 out:
-	/* must be careful here...if we trigger the ->remove() function
-	 * we cannot be holding the q lock */
-	spin_unlock_irq(q->queue_lock);
-	put_device(&sdev->sdev_gendev);
-	spin_lock_irq(q->queue_lock);
+	;
 }
 
 u64 scsi_calculate_bounce_limit(struct Scsi_Host *shost)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4a2ab7c..132334e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -377,6 +377,11 @@ struct request_queue {
 
 	unsigned int		nr_sorted;
 	unsigned int		in_flight[2];
+	/*
+	 * Number of active request_fn() calls for those request_fn()
+	 * implementations that unlock the queue_lock, e.g. scsi_request_fn().
+	 */
+	unsigned int		request_fn_active;
 
 	unsigned int		rq_timeout;
 	struct timer_list	timeout;
-- 
1.7.7

