From: Jens Axboe <axboe@fb.com>
Subject: [PATCH 2/7] blk-mq: add helper to iterate all busy tags on all hardware queues
Date: Fri, 3 Apr 2015 09:58:18 -0600
Message-ID: <1428076703-31014-3-git-send-email-axboe@fb.com>
References: <1428076703-31014-1-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1428076703-31014-1-git-send-email-axboe@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, Jens Axboe <axboe@fb.com>
List-Id: linux-scsi@vger.kernel.org

The current iter helper function deals with a hardware queue. Some
callers want to access all queues, like the internal blk-mq timeout
handling does. So add a helper for that.

Signed-off-by: Jens Axboe <axboe@fb.com>
---
 block/blk-mq.c         | 35 +++++++++++++++++++++++------------
 include/linux/blk-mq.h |  2 ++
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1cd34d4d707c..d8dcb71d3076 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -561,6 +561,25 @@ void blk_mq_abort_requeue_list(struct request_queue *q)
 }
 EXPORT_SYMBOL(blk_mq_abort_requeue_list);
 
+void blk_mq_queue_busy_iter(struct request_queue *q, busy_iter_fn *fn,
+			    void *priv)
+{
+	struct blk_mq_hw_ctx *hctx;
+	int i;
+
+	queue_for_each_hw_ctx(q, hctx, i) {
+		/*
+		 * If no software queues are currently mapped to this
+		 * hardware queue, there's nothing to check
+		 */
+		if (!blk_mq_hw_queue_mapped(hctx))
+			continue;
+
+		blk_mq_tag_busy_iter(hctx, fn, priv);
+	}
+}
+EXPORT_SYMBOL_GPL(blk_mq_queue_busy_iter);
+
 static inline bool is_flush_request(struct request *rq,
 		struct blk_flush_queue *fq, unsigned int tag)
 {
@@ -659,24 +678,16 @@ static void blk_mq_rq_timer(unsigned long priv)
 		.next		= 0,
 		.next_set	= 0,
 	};
-	struct blk_mq_hw_ctx *hctx;
-	int i;
 
-	queue_for_each_hw_ctx(q, hctx, i) {
-		/*
-		 * If not software queues are currently mapped to this
-		 * hardware queue, there's nothing to check
-		 */
-		if (!blk_mq_hw_queue_mapped(hctx))
-			continue;
-
-		blk_mq_tag_busy_iter(hctx, blk_mq_check_expired, &data);
-	}
+	blk_mq_queue_busy_iter(q, blk_mq_check_expired, &data);
 
 	if (data.next_set) {
 		data.next = blk_rq_timeout(round_jiffies_up(data.next));
 		mod_timer(&q->timeout, data.next);
 	} else {
+		struct blk_mq_hw_ctx *hctx;
+		int i;
+
 		queue_for_each_hw_ctx(q, hctx, i)
 			blk_mq_tag_idle(hctx);
 	}
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index b216deab80d9..8c010b5ea1b6 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -219,6 +219,8 @@ void blk_mq_stop_hw_queues(struct request_queue *q);
 void blk_mq_start_hw_queues(struct request_queue *q);
 void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async);
 void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
+void blk_mq_queue_busy_iter(struct request_queue *q, busy_iter_fn *fn,
+			    void *priv);
 void blk_mq_tag_busy_iter(struct blk_mq_hw_ctx *hctx, busy_iter_fn *fn,
 		void *priv);
 void blk_mq_freeze_queue(struct request_queue *q);
-- 
1.9.1
