From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/2] Make blk_cleanup_queue() wait until request_fn finished
Date: Sun, 23 Sep 2012 18:20:13 +0200
Message-ID: <505F36BD.9020006@acm.org>
References: <505F35C9.6070509@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [178.239.52.149] ([178.239.52.149]:46513 "EHLO wimaserver10.be"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754095Ab2IWQU0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Sep 2012 12:20:26 -0400
In-Reply-To: <505F35C9.6070509@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Chanho Min <chanho.min@lge.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, James Bottomley <jbottomley@parallels.com>

Some request_fn implementations, e.g. scsi_request_fn(), unlock
the queue lock. Make sure that blk_cleanup_queue() waits until all
active request_fn invocations have finished. This fixes a potential
use-after-free at the end of scsi_request_fn(). Also, make sure that
the block layer doesn't invoke request_fn after blk_cleanup_queue()
finished.

Reported-by: Chanho Min <chanho.min@lge.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-core.c        |   32 +++++++++++++++++++++++++++++---
 block/blk-exec.c        |    2 +-
 block/blk.h             |    2 ++
 drivers/scsi/scsi_lib.c |   10 +---------
 include/linux/blkdev.h  |    7 +++++++
 5 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b37ac03..e41b291 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -293,6 +293,27 @@ void blk_sync_queue(struct request_queue *q)
 EXPORT_SYMBOL(blk_sync_queue);
 
 /**
+ * __blk_run_queue_uncond - run a queue whether or not it has been stopped
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
+	if (unlikely(blk_queue_dead(q)))
+		return;
+
+	q->request_fn_active++;
+	q->request_fn(q);
+	q->request_fn_active--;
+}
+
+/**
  * __blk_run_queue - run a single device queue
  * @q:	The queue to run
  *
@@ -305,7 +326,7 @@ void __blk_run_queue(struct request_queue *q)
 	if (unlikely(blk_queue_stopped(q)))
 		return;
 
-	q->request_fn(q);
+	__blk_run_queue_uncond(q);
 }
 EXPORT_SYMBOL(__blk_run_queue);
 
@@ -388,6 +409,7 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 			__blk_run_queue(q);
 
 		drain |= q->nr_rqs_elvpriv;
+		drain |= q->request_fn_active;
 
 		/*
 		 * Unfortunately, requests are queued at and tracked from
@@ -475,8 +497,8 @@ EXPORT_SYMBOL_GPL(blk_queue_bypass_end);
  * blk_cleanup_queue - shutdown a request queue
  * @q: request queue to shutdown
  *
- * Mark @q DEAD, drain all pending requests, destroy and put it.  All
- * future requests will be failed immediately with -ENODEV.
+ * Mark @q as dying, drain all pending requests, mark @q as dead, destroy and
+ * put it.  All future requests will be failed immediately with -ENODEV.
  */
 void blk_cleanup_queue(struct request_queue *q)
 {
@@ -508,6 +530,10 @@ void blk_cleanup_queue(struct request_queue *q)
 	/* drain all requests queued before DEAD marking */
 	blk_drain_queue(q, true);
 
+	spin_lock_irq(lock);
+	queue_flag_set(QUEUE_FLAG_DEAD, q);
+	spin_unlock_irq(lock);
+
 	/* @q won't process any more request, flush async actions */
 	del_timer_sync(&q->backing_dev_info.laptop_mode_wb_timer);
 	blk_sync_queue(q);
diff --git a/block/blk-exec.c b/block/blk-exec.c
index 4aec98d..1320e74 100644
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
index a066ceb..3e94c14 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -145,6 +145,8 @@ int blk_try_merge(struct request *rq, struct bio *bio);
 
 void blk_queue_congestion_threshold(struct request_queue *q);
 
+void __blk_run_queue_uncond(struct request_queue *q);
+
 int blk_dev_init(void);
 
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 593fc71..03571a3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1517,10 +1517,6 @@ static void scsi_request_fn(struct request_queue *q)
 	struct scsi_cmnd *cmd;
 	struct request *req;
 
-	if(!get_device(&sdev->sdev_gendev))
-		/* We must be tearing the block queue down already */
-		return;
-
 	/*
 	 * To start with, we keep looping until the queue is empty, or until
 	 * the host is no longer able to accept any more requests.
@@ -1629,11 +1625,7 @@ out_delay:
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
index c6ab0db..ef5b80a 100644
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
@@ -451,6 +456,7 @@ struct request_queue {
 #define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
+#define QUEUE_FLAG_DEAD        19	/* queue tear-down finished */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -521,6 +527,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_dying(q)	test_bit(QUEUE_FLAG_DYING, &(q)->queue_flags)
+#define blk_queue_dead(q)	test_bit(QUEUE_FLAG_DEAD, &(q)->queue_flags)
 #define blk_queue_bypass(q)	test_bit(QUEUE_FLAG_BYPASS, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_noxmerges(q)	\
-- 
1.7.10.4

