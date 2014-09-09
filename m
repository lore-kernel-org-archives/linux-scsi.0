From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 5/8] block: introduce blk_flush_queue to drive flush machinery
Date: Tue,  9 Sep 2014 21:05:46 +0800
Message-ID: <1410267949-21904-6-git-send-email-ming.lei@canonical.com>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-scsi@vger.kernel.org

This patch introduces 'struct blk_flush_queue' and puts all
flush machinery related stuff into this strcuture, so that

	- flush implementation details aren't exposed to driver
	- it is easy to convert to per dispatch-queue flush machinery

This patch is basically a mechanical replacement.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-core.c       |    3 +-
 block/blk-flush.c      |  106 ++++++++++++++++++++++++++++++++----------------
 block/blk-mq.c         |   10 +++--
 block/blk.h            |   22 +++++++++-
 include/linux/blkdev.h |   10 +----
 5 files changed, 101 insertions(+), 50 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 222fe84..d278a30 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -390,11 +390,12 @@ static void __blk_drain_queue(struct request_queue *q, bool drain_all)
 		 * be drained.  Check all the queues and counters.
 		 */
 		if (drain_all) {
+			struct blk_flush_queue *fq = blk_get_flush_queue(q);
 			drain |= !list_empty(&q->queue_head);
 			for (i = 0; i < 2; i++) {
 				drain |= q->nr_rqs[i];
 				drain |= q->in_flight[i];
-				drain |= !list_empty(&q->flush_queue[i]);
+				drain |= !list_empty(&fq->flush_queue[i]);
 			}
 		}
 
diff --git a/block/blk-flush.c b/block/blk-flush.c
index a59dd1a..894a149 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -28,7 +28,7 @@
  *
  * The actual execution of flush is double buffered.  Whenever a request
  * needs to execute PRE or POSTFLUSH, it queues at
- * q->flush_queue[q->flush_pending_idx].  Once certain criteria are met, a
+ * fq->flush_queue[fq->flush_pending_idx].  Once certain criteria are met, a
  * flush is issued and the pending_idx is toggled.  When the flush
  * completes, all the requests which were pending are proceeded to the next
  * step.  This allows arbitrary merging of different types of FLUSH/FUA
@@ -157,7 +157,7 @@ static bool blk_flush_queue_rq(struct request *rq, bool add_front)
  * completion and trigger the next step.
  *
  * CONTEXT:
- * spin_lock_irq(q->queue_lock or q->mq_flush_lock)
+ * spin_lock_irq(q->queue_lock or fq->mq_flush_lock)
  *
  * RETURNS:
  * %true if requests were added to the dispatch queue, %false otherwise.
@@ -166,7 +166,8 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 				   int error)
 {
 	struct request_queue *q = rq->q;
-	struct list_head *pending = &q->flush_queue[q->flush_pending_idx];
+	struct blk_flush_queue *fq = blk_get_flush_queue(q);
+	struct list_head *pending = &fq->flush_queue[fq->flush_pending_idx];
 	bool queued = false, kicked;
 
 	BUG_ON(rq->flush.seq & seq);
@@ -182,12 +183,12 @@ static bool blk_flush_complete_seq(struct request *rq, unsigned int seq,
 	case REQ_FSEQ_POSTFLUSH:
 		/* queue for flush */
 		if (list_empty(pending))
-			q->flush_pending_since = jiffies;
+			fq->flush_pending_since = jiffies;
 		list_move_tail(&rq->flush.list, pending);
 		break;
 
 	case REQ_FSEQ_DATA:
-		list_move_tail(&rq->flush.list, &q->flush_data_in_flight);
+		list_move_tail(&rq->flush.list, &fq->flush_data_in_flight);
 		queued = blk_flush_queue_rq(rq, true);
 		break;
 
@@ -222,17 +223,18 @@ static void flush_end_io(struct request *flush_rq, int error)
 	bool queued = false;
 	struct request *rq, *n;
 	unsigned long flags = 0;
+	struct blk_flush_queue *fq = blk_get_flush_queue(q);
 
 	if (q->mq_ops) {
-		spin_lock_irqsave(&q->mq_flush_lock, flags);
+		spin_lock_irqsave(&fq->mq_flush_lock, flags);
 		flush_rq->tag = -1;
 	}
 
-	running = &q->flush_queue[q->flush_running_idx];
-	BUG_ON(q->flush_pending_idx == q->flush_running_idx);
+	running = &fq->flush_queue[fq->flush_running_idx];
+	BUG_ON(fq->flush_pending_idx == fq->flush_running_idx);
 
 	/* account completion of the flush request */
-	q->flush_running_idx ^= 1;
+	fq->flush_running_idx ^= 1;
 
 	if (!q->mq_ops)
 		elv_completed_request(q, flush_rq);
@@ -256,13 +258,13 @@ static void flush_end_io(struct request *flush_rq, int error)
 	 * directly into request_fn may confuse the driver.  Always use
 	 * kblockd.
 	 */
-	if (queued || q->flush_queue_delayed) {
+	if (queued || fq->flush_queue_delayed) {
 		WARN_ON(q->mq_ops);
 		blk_run_queue_async(q);
 	}
-	q->flush_queue_delayed = 0;
+	fq->flush_queue_delayed = 0;
 	if (q->mq_ops)
-		spin_unlock_irqrestore(&q->mq_flush_lock, flags);
+		spin_unlock_irqrestore(&fq->mq_flush_lock, flags);
 }
 
 /**
@@ -273,33 +275,34 @@ static void flush_end_io(struct request *flush_rq, int error)
  * Please read the comment at the top of this file for more info.
  *
  * CONTEXT:
- * spin_lock_irq(q->queue_lock or q->mq_flush_lock)
+ * spin_lock_irq(q->queue_lock or fq->mq_flush_lock)
  *
  * RETURNS:
  * %true if flush was issued, %false otherwise.
  */
 static bool blk_kick_flush(struct request_queue *q)
 {
-	struct list_head *pending = &q->flush_queue[q->flush_pending_idx];
+	struct blk_flush_queue *fq = blk_get_flush_queue(q);
+	struct list_head *pending = &fq->flush_queue[fq->flush_pending_idx];
 	struct request *first_rq =
 		list_first_entry(pending, struct request, flush.list);
-	struct request *flush_rq = q->flush_rq;
+	struct request *flush_rq = fq->flush_rq;
 
 	/* C1 described at the top of this file */
-	if (q->flush_pending_idx != q->flush_running_idx || list_empty(pending))
+	if (fq->flush_pending_idx != fq->flush_running_idx || list_empty(pending))
 		return false;
 
 	/* C2 and C3 */
-	if (!list_empty(&q->flush_data_in_flight) &&
+	if (!list_empty(&fq->flush_data_in_flight) &&
 	    time_before(jiffies,
-			q->flush_pending_since + FLUSH_PENDING_TIMEOUT))
+			fq->flush_pending_since + FLUSH_PENDING_TIMEOUT))
 		return false;
 
 	/*
 	 * Issue flush and toggle pending_idx.  This makes pending_idx
 	 * different from running_idx, which means flush is in flight.
 	 */
-	q->flush_pending_idx ^= 1;
+	fq->flush_pending_idx ^= 1;
 
 	blk_rq_init(q, flush_rq);
 	if (q->mq_ops)
@@ -331,6 +334,7 @@ static void mq_flush_data_end_io(struct request *rq, int error)
 	struct blk_mq_hw_ctx *hctx;
 	struct blk_mq_ctx *ctx;
 	unsigned long flags;
+	struct blk_flush_queue *fq = blk_get_flush_queue(q);
 
 	ctx = rq->mq_ctx;
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
@@ -339,10 +343,10 @@ static void mq_flush_data_end_io(struct request *rq, int error)
 	 * After populating an empty queue, kick it to avoid stall.  Read
 	 * the comment in flush_end_io().
 	 */
-	spin_lock_irqsave(&q->mq_flush_lock, flags);
+	spin_lock_irqsave(&fq->mq_flush_lock, flags);
 	if (blk_flush_complete_seq(rq, REQ_FSEQ_DATA, error))
 		blk_mq_run_hw_queue(hctx, true);
-	spin_unlock_irqrestore(&q->mq_flush_lock, flags);
+	spin_unlock_irqrestore(&fq->mq_flush_lock, flags);
 }
 
 /**
@@ -410,11 +414,13 @@ void blk_insert_flush(struct request *rq)
 	rq->cmd_flags |= REQ_FLUSH_SEQ;
 	rq->flush.saved_end_io = rq->end_io; /* Usually NULL */
 	if (q->mq_ops) {
+		struct blk_flush_queue *fq = blk_get_flush_queue(q);
+
 		rq->end_io = mq_flush_data_end_io;
 
-		spin_lock_irq(&q->mq_flush_lock);
+		spin_lock_irq(&fq->mq_flush_lock);
 		blk_flush_complete_seq(rq, REQ_FSEQ_ACTIONS & ~policy, 0);
-		spin_unlock_irq(&q->mq_flush_lock);
+		spin_unlock_irq(&fq->mq_flush_lock);
 		return;
 	}
 	rq->end_io = flush_data_end_io;
@@ -478,34 +484,64 @@ EXPORT_SYMBOL(blkdev_issue_flush);
 static int blk_mq_init_flush(struct request_queue *q)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
+	struct blk_flush_queue *fq = blk_get_flush_queue(q);
 
-	spin_lock_init(&q->mq_flush_lock);
+	spin_lock_init(&fq->mq_flush_lock);
 
-	q->flush_rq = kzalloc(round_up(sizeof(struct request) +
+	fq->flush_rq = kzalloc(round_up(sizeof(struct request) +
 				set->cmd_size, cache_line_size()),
 				GFP_KERNEL);
-	if (!q->flush_rq)
+	if (!fq->flush_rq)
 		return -ENOMEM;
 	return 0;
 }
 
-int blk_init_flush(struct request_queue *q)
+static void blk_mq_exit_flush(struct request_queue *q)
 {
-	INIT_LIST_HEAD(&q->flush_queue[0]);
-	INIT_LIST_HEAD(&q->flush_queue[1]);
-	INIT_LIST_HEAD(&q->flush_data_in_flight);
+	struct blk_flush_queue *fq = blk_get_flush_queue(q);
+	kfree(fq->flush_rq);
+	kfree(fq);
+}
 
-	if (q->mq_ops)
-		return blk_mq_init_flush(q);
+int blk_init_flush(struct request_queue *q)
+{
+	int ret;
+	struct blk_flush_queue *fq = kzalloc(sizeof(*fq), GFP_KERNEL);
 
-	q->flush_rq = kzalloc(sizeof(struct request), GFP_KERNEL);
-	if (!q->flush_rq)
+	if (!fq)
 		return -ENOMEM;
 
+	q->fq = fq;
+	INIT_LIST_HEAD(&fq->flush_queue[0]);
+	INIT_LIST_HEAD(&fq->flush_queue[1]);
+	INIT_LIST_HEAD(&fq->flush_data_in_flight);
+
+	if (q->mq_ops) {
+		ret = blk_mq_init_flush(q);
+		if (ret)
+			goto failed;
+	} else {
+		ret = -ENOMEM;
+		fq->flush_rq = kzalloc(sizeof(struct request), GFP_KERNEL);
+		if (!fq->flush_rq)
+			goto failed;
+	}
+
 	return 0;
+
+ failed:
+	kfree(fq);
+	q->fq = NULL;
+	return ret;
 }
 
 void blk_exit_flush(struct request_queue *q)
 {
-	kfree(q->flush_rq);
+	if (q->mq_ops)
+		blk_mq_exit_flush(q);
+	else {
+		struct blk_flush_queue *fq = blk_get_flush_queue(q);
+		kfree(fq->flush_rq);
+		kfree(fq);
+	}
 }
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 706181a..7782d14 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -508,20 +508,22 @@ void blk_mq_kick_requeue_list(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_mq_kick_requeue_list);
 
-static inline bool is_flush_request(struct request *rq, unsigned int tag)
+static inline bool is_flush_request(struct request *rq,
+		struct blk_flush_queue *fq, unsigned int tag)
 {
 	return ((rq->cmd_flags & REQ_FLUSH_SEQ) &&
-			rq->q->flush_rq->tag == tag);
+			fq->flush_rq->tag == tag);
 }
 
 struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
 {
 	struct request *rq = tags->rqs[tag];
+	struct blk_flush_queue *fq = blk_get_flush_queue(rq->q);
 
-	if (!is_flush_request(rq, tag))
+	if (!is_flush_request(rq, fq, tag))
 		return rq;
 
-	return rq->q->flush_rq;
+	return fq->flush_rq;
 }
 EXPORT_SYMBOL(blk_mq_tag_to_rq);
 
diff --git a/block/blk.h b/block/blk.h
index 261f734..2637349 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -12,11 +12,28 @@
 /* Max future timer expiry for timeouts */
 #define BLK_MAX_TIMEOUT		(5 * HZ)
 
+struct blk_flush_queue {
+	unsigned int		flush_queue_delayed:1;
+	unsigned int		flush_pending_idx:1;
+	unsigned int		flush_running_idx:1;
+	unsigned long		flush_pending_since;
+	struct list_head	flush_queue[2];
+	struct list_head	flush_data_in_flight;
+	struct request		*flush_rq;
+	spinlock_t		mq_flush_lock;
+};
+
 extern struct kmem_cache *blk_requestq_cachep;
 extern struct kmem_cache *request_cachep;
 extern struct kobj_type blk_queue_ktype;
 extern struct ida blk_queue_ida;
 
+static inline struct blk_flush_queue *blk_get_flush_queue(
+		struct request_queue *q)
+{
+	return q->fq;
+}
+
 static inline void __blk_get_queue(struct request_queue *q)
 {
 	kobject_get(&q->kobj);
@@ -91,6 +108,7 @@ void blk_insert_flush(struct request *rq);
 static inline struct request *__elv_next_request(struct request_queue *q)
 {
 	struct request *rq;
+	struct blk_flush_queue *fq = blk_get_flush_queue(q);
 
 	while (1) {
 		if (!list_empty(&q->queue_head)) {
@@ -113,9 +131,9 @@ static inline struct request *__elv_next_request(struct request_queue *q)
 		 * should be restarted later. Please see flush_end_io() for
 		 * details.
 		 */
-		if (q->flush_pending_idx != q->flush_running_idx &&
+		if (fq->flush_pending_idx != fq->flush_running_idx &&
 				!queue_flush_queueable(q)) {
-			q->flush_queue_delayed = 1;
+			fq->flush_queue_delayed = 1;
 			return NULL;
 		}
 		if (unlikely(blk_queue_bypass(q)) ||
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e267bf0..49f3461 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -36,6 +36,7 @@ struct request;
 struct sg_io_hdr;
 struct bsg_job;
 struct blkcg_gq;
+struct blk_flush_queue;
 
 #define BLKDEV_MIN_RQ	4
 #define BLKDEV_MAX_RQ	128	/* Default maximum */
@@ -455,14 +456,7 @@ struct request_queue {
 	 */
 	unsigned int		flush_flags;
 	unsigned int		flush_not_queueable:1;
-	unsigned int		flush_queue_delayed:1;
-	unsigned int		flush_pending_idx:1;
-	unsigned int		flush_running_idx:1;
-	unsigned long		flush_pending_since;
-	struct list_head	flush_queue[2];
-	struct list_head	flush_data_in_flight;
-	struct request		*flush_rq;
-	spinlock_t		mq_flush_lock;
+	struct blk_flush_queue	*fq;
 
 	struct list_head	requeue_list;
 	spinlock_t		requeue_lock;
-- 
1.7.9.5
