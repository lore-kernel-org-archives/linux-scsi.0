From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 7/8] block: introduce 'blk_mq_ctx' parameter to blk_get_flush_queue
Date: Tue,  9 Sep 2014 21:05:48 +0800
Message-ID: <1410267949-21904-8-git-send-email-ming.lei@canonical.com>
References: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410267949-21904-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-scsi@vger.kernel.org

This patch adds 'blk_mq_ctx' parameter to blk_get_flush_queue(),
so that this function can find the corresponding blk_flush_queue
bound with current mq context since the flush queue will become
per hw-queue.

For legacy queue, the parameter can be simply 'NULL'.

For multiqueue case, the parameter should be set the context
from which the related request is originated. With the context
info, the hw queue and related flush queue can be found.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-core.c  |    2 +-
 block/blk-flush.c |   17 ++++++++---------
 block/blk-mq.c    |    3 ++-
 block/blk.h       |    4 ++--
 4 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d278a30..40a5d37 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -390,7 +390,7 @@ static void __blk_drain_queue(struct request_queue *q, bool drain_all)
 		 * be drained.  Check all the queues and counters.
 		 */
 		if (drain_all) {
-			struct blk_flush_queue *fq = blk_get_flush_queue(q);
+			struct blk_flush_queue *fq = blk_get_flush_queue(q, NULL);
 			drain |= !list_empty(&q->queue_head);
 			for (i = 0; i < 2; i++) {
 				drain |= q->nr_rqs[i];
diff --git a/block/blk-flush.c b/block/blk-flush.c
index a9d6e01..4a445a1 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -225,7 +225,7 @@ static void flush_end_io(struct request *flush_rq, int error)
 	bool queued = false;
 	struct request *rq, *n;
 	unsigned long flags = 0;
-	struct blk_flush_queue *fq = blk_get_flush_queue(q);
+	struct blk_flush_queue *fq = blk_get_flush_queue(q, flush_rq->mq_ctx);
 
 	if (q->mq_ops) {
 		spin_lock_irqsave(&fq->mq_flush_lock, flags);
@@ -321,7 +321,7 @@ static bool blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq)
 static void flush_data_end_io(struct request *rq, int error)
 {
 	struct request_queue *q = rq->q;
-	struct blk_flush_queue *fq = blk_get_flush_queue(q);
+	struct blk_flush_queue *fq = blk_get_flush_queue(q, NULL);
 
 	/*
 	 * After populating an empty queue, kick it to avoid stall.  Read
@@ -335,11 +335,10 @@ static void mq_flush_data_end_io(struct request *rq, int error)
 {
 	struct request_queue *q = rq->q;
 	struct blk_mq_hw_ctx *hctx;
-	struct blk_mq_ctx *ctx;
+	struct blk_mq_ctx *ctx = rq->mq_ctx;
 	unsigned long flags;
-	struct blk_flush_queue *fq = blk_get_flush_queue(q);
+	struct blk_flush_queue *fq = blk_get_flush_queue(q, ctx);
 
-	ctx = rq->mq_ctx;
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 
 	/*
@@ -369,7 +368,7 @@ void blk_insert_flush(struct request *rq)
 	struct request_queue *q = rq->q;
 	unsigned int fflags = q->flush_flags;	/* may change, cache */
 	unsigned int policy = blk_flush_policy(fflags, rq);
-	struct blk_flush_queue *fq = blk_get_flush_queue(q);
+	struct blk_flush_queue *fq = blk_get_flush_queue(q, rq->mq_ctx);
 
 	/*
 	 * @policy now records what operations need to be done.  Adjust
@@ -486,7 +485,7 @@ EXPORT_SYMBOL(blkdev_issue_flush);
 static int blk_mq_init_flush(struct request_queue *q)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
-	struct blk_flush_queue *fq = blk_get_flush_queue(q);
+	struct blk_flush_queue *fq = blk_get_flush_queue(q, NULL);
 
 	spin_lock_init(&fq->mq_flush_lock);
 
@@ -500,7 +499,7 @@ static int blk_mq_init_flush(struct request_queue *q)
 
 static void blk_mq_exit_flush(struct request_queue *q)
 {
-	struct blk_flush_queue *fq = blk_get_flush_queue(q);
+	struct blk_flush_queue *fq = blk_get_flush_queue(q, NULL);
 	kfree(fq->flush_rq);
 	kfree(fq);
 }
@@ -542,7 +541,7 @@ void blk_exit_flush(struct request_queue *q)
 	if (q->mq_ops)
 		blk_mq_exit_flush(q);
 	else {
-		struct blk_flush_queue *fq = blk_get_flush_queue(q);
+		struct blk_flush_queue *fq = blk_get_flush_queue(q, NULL);
 		kfree(fq->flush_rq);
 		kfree(fq);
 	}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7782d14..9ca4442 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -518,7 +518,8 @@ static inline bool is_flush_request(struct request *rq,
 struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag)
 {
 	struct request *rq = tags->rqs[tag];
-	struct blk_flush_queue *fq = blk_get_flush_queue(rq->q);
+	/* mq_ctx of flush rq is always cloned from the corresponding req */
+	struct blk_flush_queue *fq = blk_get_flush_queue(rq->q, rq->mq_ctx);
 
 	if (!is_flush_request(rq, fq, tag))
 		return rq;
diff --git a/block/blk.h b/block/blk.h
index 2637349..30f8033 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -29,7 +29,7 @@ extern struct kobj_type blk_queue_ktype;
 extern struct ida blk_queue_ida;
 
 static inline struct blk_flush_queue *blk_get_flush_queue(
-		struct request_queue *q)
+		struct request_queue *q, struct blk_mq_ctx *ctx)
 {
 	return q->fq;
 }
@@ -108,7 +108,7 @@ void blk_insert_flush(struct request *rq);
 static inline struct request *__elv_next_request(struct request_queue *q)
 {
 	struct request *rq;
-	struct blk_flush_queue *fq = blk_get_flush_queue(q);
+	struct blk_flush_queue *fq = blk_get_flush_queue(q, NULL);
 
 	while (1) {
 		if (!list_empty(&q->queue_head)) {
-- 
1.7.9.5
