From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v4 2/6] blk-mq: Restart a single queue if tag sets are shared
Date: Fri, 7 Apr 2017 11:16:50 -0700
Message-ID: <20170407181654.27836-3-bart.vanassche@sandisk.com>
References: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170407181654.27836-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

To improve scalability, if hardware queues are shared, restart
a single hardware queue in round-robin fashion. Rename
blk_mq_sched_restart_queues() to reflect the new semantics.
Remove blk_mq_sched_mark_restart_queue() because this function
has no callers. Remove flag QUEUE_FLAG_RESTART because this
patch removes the code that uses this flag.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 block/blk-mq-sched.c   | 63 ++++++++++++++++++++++++++++++++++++++++++--------
 block/blk-mq-sched.h   | 16 +------------
 block/blk-mq.c         |  2 +-
 include/linux/blkdev.h |  1 -
 4 files changed, 55 insertions(+), 27 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 09af8ff18719..a5c683a6429c 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -317,25 +317,68 @@ static bool blk_mq_sched_bypass_insert(struct blk_mq_hw_ctx *hctx,
 	return true;
 }
 
-static void blk_mq_sched_restart_hctx(struct blk_mq_hw_ctx *hctx)
+static bool blk_mq_sched_restart_hctx(struct blk_mq_hw_ctx *hctx)
 {
 	if (test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state)) {
 		clear_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
-		if (blk_mq_hctx_has_pending(hctx))
+		if (blk_mq_hctx_has_pending(hctx)) {
 			blk_mq_run_hw_queue(hctx, true);
+			return true;
+		}
 	}
+	return false;
 }
 
-void blk_mq_sched_restart_queues(struct blk_mq_hw_ctx *hctx)
-{
-	struct request_queue *q = hctx->queue;
-	unsigned int i;
+/**
+ * list_for_each_entry_rcu_rr - iterate in a round-robin fashion over rcu list
+ * @pos:    loop cursor.
+ * @skip:   the list element that will not be examined. Iteration starts at
+ *          @skip->next.
+ * @head:   head of the list to examine. This list must have at least one
+ *          element, namely @skip.
+ * @member: name of the list_head structure within typeof(*pos).
+ */
+#define list_for_each_entry_rcu_rr(pos, skip, head, member)		\
+	for ((pos) = (skip);						\
+	     (pos = (pos)->member.next != (head) ? list_entry_rcu(	\
+			(pos)->member.next, typeof(*pos), member) :	\
+	      list_entry_rcu((pos)->member.next->next, typeof(*pos), member)), \
+	     (pos) != (skip); )
 
-	if (test_bit(QUEUE_FLAG_RESTART, &q->queue_flags)) {
-		if (test_and_clear_bit(QUEUE_FLAG_RESTART, &q->queue_flags)) {
-			queue_for_each_hw_ctx(q, hctx, i)
-				blk_mq_sched_restart_hctx(hctx);
+/*
+ * Called after a driver tag has been freed to check whether a hctx needs to
+ * be restarted. Restarts @hctx if its tag set is not shared. Restarts hardware
+ * queues in a round-robin fashion if the tag set of @hctx is shared with other
+ * hardware queues.
+ */
+void blk_mq_sched_restart(struct blk_mq_hw_ctx *const hctx)
+{
+	struct blk_mq_tags *const tags = hctx->tags;
+	struct blk_mq_tag_set *const set = hctx->queue->tag_set;
+	struct request_queue *const queue = hctx->queue, *q;
+	struct blk_mq_hw_ctx *hctx2;
+	unsigned int i, j;
+
+	if (set->flags & BLK_MQ_F_TAG_SHARED) {
+		rcu_read_lock();
+		list_for_each_entry_rcu_rr(q, queue, &set->tag_list,
+					   tag_set_list) {
+			queue_for_each_hw_ctx(q, hctx2, i)
+				if (hctx2->tags == tags &&
+				    blk_mq_sched_restart_hctx(hctx2))
+					goto done;
+		}
+		j = hctx->queue_num + 1;
+		for (i = 0; i < queue->nr_hw_queues; i++, j++) {
+			if (j == queue->nr_hw_queues)
+				j = 0;
+			hctx2 = queue->queue_hw_ctx[j];
+			if (hctx2->tags == tags &&
+			    blk_mq_sched_restart_hctx(hctx2))
+				break;
 		}
+done:
+		rcu_read_unlock();
 	} else {
 		blk_mq_sched_restart_hctx(hctx);
 	}
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index a75b16b123f7..4e3fc2a40207 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -19,7 +19,7 @@ bool blk_mq_sched_try_merge(struct request_queue *q, struct bio *bio,
 				struct request **merged_request);
 bool __blk_mq_sched_bio_merge(struct request_queue *q, struct bio *bio);
 bool blk_mq_sched_try_insert_merge(struct request_queue *q, struct request *rq);
-void blk_mq_sched_restart_queues(struct blk_mq_hw_ctx *hctx);
+void blk_mq_sched_restart(struct blk_mq_hw_ctx *hctx);
 
 void blk_mq_sched_insert_request(struct request *rq, bool at_head,
 				 bool run_queue, bool async, bool can_block);
@@ -131,20 +131,6 @@ static inline void blk_mq_sched_mark_restart_hctx(struct blk_mq_hw_ctx *hctx)
 		set_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
 }
 
-/*
- * Mark a hardware queue and the request queue it belongs to as needing a
- * restart.
- */
-static inline void blk_mq_sched_mark_restart_queue(struct blk_mq_hw_ctx *hctx)
-{
-	struct request_queue *q = hctx->queue;
-
-	if (!test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state))
-		set_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
-	if (!test_bit(QUEUE_FLAG_RESTART, &q->queue_flags))
-		set_bit(QUEUE_FLAG_RESTART, &q->queue_flags);
-}
-
 static inline bool blk_mq_sched_needs_restart(struct blk_mq_hw_ctx *hctx)
 {
 	return test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index c26464f9649a..dba34eb79a08 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -351,7 +351,7 @@ void __blk_mq_finish_request(struct blk_mq_hw_ctx *hctx, struct blk_mq_ctx *ctx,
 		blk_mq_put_tag(hctx, hctx->tags, ctx, rq->tag);
 	if (sched_tag != -1)
 		blk_mq_sched_completed_request(hctx, rq);
-	blk_mq_sched_restart_queues(hctx);
+	blk_mq_sched_restart(hctx);
 	blk_queue_exit(q);
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3cf241b0814d..dc6c8d39d462 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -615,7 +615,6 @@ struct request_queue {
 #define QUEUE_FLAG_FLUSH_NQ    25	/* flush not queueuable */
 #define QUEUE_FLAG_DAX         26	/* device supports DAX */
 #define QUEUE_FLAG_STATS       27	/* track rq completion times */
-#define QUEUE_FLAG_RESTART     28	/* queue needs restart at completion */
 #define QUEUE_FLAG_POLL_STATS  29	/* collecting stats for hybrid polling */
 #define QUEUE_FLAG_REGISTERED  30	/* queue has been registered to a disk */
 
-- 
2.12.0
