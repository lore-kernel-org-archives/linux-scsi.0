From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 2/4] block: Avoid that request_fn is invoked on a dead queue
Date: Wed, 10 Oct 2012 17:08:01 +0200
Message-ID: <50758F51.3020601@acm.org>
References: <50758EBE.7050202@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:56947 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab2JJPIC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Oct 2012 11:08:02 -0400
In-Reply-To: <50758EBE.7050202@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <jbottomley@parallels.com>, Mike Christie <michaelc@cs.wisc.edu>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Chanho Min <chanho.min@lge.com>

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
 block/blk-core.c       |   24 +++++++++++++++++++++++-
 block/blk-exec.c       |    2 +-
 block/blk.h            |    2 ++
 include/linux/blkdev.h |    2 ++
 4 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index a319fbf..5e752ff 100644
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
+void __blk_run_queue_uncond(struct request_queue *q)
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
 
@@ -401,6 +420,9 @@ void blk_drain_queue(struct request_queue *q, bool drain_all)
 			}
 		}
 
+		if (!drain && blk_queue_dying(q))
+			queue_flag_set(QUEUE_FLAG_DEAD, q);
+
 		spin_unlock_irq(q->queue_lock);
 
 		if (!drain)
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
 
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c6ab0db..9b9855f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -451,6 +451,7 @@ struct request_queue {
 #define QUEUE_FLAG_ADD_RANDOM  16	/* Contributes to random pool */
 #define QUEUE_FLAG_SECDISCARD  17	/* supports SECDISCARD */
 #define QUEUE_FLAG_SAME_FORCE  18	/* force complete on same CPU */
+#define QUEUE_FLAG_DEAD        19	/* queue tear-down finished */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -521,6 +522,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_tagged(q)	test_bit(QUEUE_FLAG_QUEUED, &(q)->queue_flags)
 #define blk_queue_stopped(q)	test_bit(QUEUE_FLAG_STOPPED, &(q)->queue_flags)
 #define blk_queue_dying(q)	test_bit(QUEUE_FLAG_DYING, &(q)->queue_flags)
+#define blk_queue_dead(q)	test_bit(QUEUE_FLAG_DEAD, &(q)->queue_flags)
 #define blk_queue_bypass(q)	test_bit(QUEUE_FLAG_BYPASS, &(q)->queue_flags)
 #define blk_queue_nomerges(q)	test_bit(QUEUE_FLAG_NOMERGES, &(q)->queue_flags)
 #define blk_queue_noxmerges(q)	\
-- 
1.7.10.4

