From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 4/7] block: Avoid that request_fn is invoked on a dead queue
Date: Fri, 26 Oct 2012 14:03:45 +0200
Message-ID: <508A7C21.90505@acm.org>
References: <508A7B63.60608@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from georges.telenet-ops.be ([195.130.137.68]:37594 "EHLO
	georges.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500Ab2JZMDq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Oct 2012 08:03:46 -0400
In-Reply-To: <508A7B63.60608@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

A block driver may start cleaning up resources needed by its
request_fn as soon as blk_cleanup_queue() finished, so request_fn
must not be invoked after draining finished.

Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>
Cc: Chanho Min <chanho.min@lge.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 block/blk-core.c       |   26 +++++++++++++++++++++++---
 block/blk-exec.c       |    2 +-
 block/blk.h            |    2 ++
 include/linux/blkdev.h |    2 ++
 4 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 986e38e..2f1be7a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -293,6 +293,25 @@ void blk_sync_queue(struct request_queue *q)
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
+void inline __blk_run_queue_uncond(struct request_queue *q)
+{
+	if (unlikely(blk_queue_dead(q)))
+		return;
+
+	q->request_fn(q);
+}
+
+/**
  * __blk_run_queue - run a single device queue
  * @q:	The queue to run
  *
@@ -305,7 +324,7 @@ void __blk_run_queue(struct request_queue *q)
 	if (unlikely(blk_queue_stopped(q)))
 		return;
 
-	q->request_fn(q);
+	__blk_run_queue_uncond(q);
 }
 EXPORT_SYMBOL(__blk_run_queue);
 
@@ -477,8 +496,8 @@ EXPORT_SYMBOL_GPL(blk_queue_bypass_end);
  * blk_cleanup_queue - shutdown a request queue
  * @q: request queue to shutdown
  *
- * Mark @q DYING, drain all pending requests, destroy and put it.  All
- * future requests will be failed immediately with -ENODEV.
+ * Mark @q DYING, drain all pending requests, mark @q DEAD, destroy and
+ * put it.  All future requests will be failed immediately with -ENODEV.
  */
 void blk_cleanup_queue(struct request_queue *q)
 {
@@ -510,6 +529,7 @@ void blk_cleanup_queue(struct request_queue *q)
 	/* drain all requests queued before DYING marking */
 	spin_lock_irq(lock);
 	__blk_drain_queue(q, true);
+	queue_flag_set(QUEUE_FLAG_DEAD, q);
 	spin_unlock_irq(lock);
 
 	/* @q won't process any more request, flush async actions */
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
index 2218a8a..47fdfdd 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -145,6 +145,8 @@ int blk_try_merge(struct request *rq, struct bio *bio);
 
 void blk_queue_congestion_threshold(struct request_queue *q);
 
+void __blk_run_queue_uncond(struct request_queue *q);
+
 int blk_dev_init(void);
 
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index aba8246..8bc46c2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -452,6 +452,7 @@ struct request_queue {
 #define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
+#define QUEUE_FLAG_DEAD        19	/* queue tear-down finished */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -522,6 +523,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_dying(q)	test_bit(QUEUE_FLAG_DYING, &(q)->queue_flags)
+#define blk_queue_dead(q)	test_bit(QUEUE_FLAG_DEAD, &(q)->queue_flags)
 #define blk_queue_bypass(q)	test_bit(QUEUE_FLAG_BYPASS, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_noxmerges(q)	\
-- 
1.7.10.4

