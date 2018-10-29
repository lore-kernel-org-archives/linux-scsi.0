From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/14] blk-mq: ensure that plug lists don't straddle hardware queues
Date: Mon, 29 Oct 2018 10:37:33 -0600
Message-ID: <20181029163738.10172-10-axboe@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-1-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Since we insert per hardware queue, we have to ensure that every
request on the plug list being inserted belongs to the same
hardware queue.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-mq.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 60a951c4934c..52b07188b39a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1621,6 +1621,27 @@ static int plug_ctx_cmp(void *priv, struct list_head *a, struct list_head *b)
 		  blk_rq_pos(rqa) < blk_rq_pos(rqb)));
 }
 
+/*
+ * Need to ensure that the hardware queue matches, so we don't submit
+ * a list of requests that end up on different hardware queues.
+ */
+static bool ctx_match(struct request *req, struct blk_mq_ctx *ctx,
+		      unsigned int flags)
+{
+	if (req->mq_ctx != ctx)
+		return false;
+
+	/*
+	 * If we just have one map, then we know the hctx will match
+	 * if the ctx matches
+	 */
+	if (req->q->tag_set->nr_maps == 1)
+		return true;
+
+	return blk_mq_map_queue(req->q, req->cmd_flags, ctx->cpu) ==
+		blk_mq_map_queue(req->q, flags, ctx->cpu);
+}
+
 void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 {
 	struct blk_mq_ctx *this_ctx;
@@ -1628,7 +1649,7 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 	struct request *rq;
 	LIST_HEAD(list);
 	LIST_HEAD(ctx_list);
-	unsigned int depth;
+	unsigned int depth, this_flags;
 
 	list_splice_init(&plug->mq_list, &list);
 
@@ -1636,13 +1657,14 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 
 	this_q = NULL;
 	this_ctx = NULL;
+	this_flags = 0;
 	depth = 0;
 
 	while (!list_empty(&list)) {
 		rq = list_entry_rq(list.next);
 		list_del_init(&rq->queuelist);
 		BUG_ON(!rq->q);
-		if (rq->mq_ctx != this_ctx) {
+		if (!ctx_match(rq, this_ctx, this_flags)) {
 			if (this_ctx) {
 				trace_block_unplug(this_q, depth, !from_schedule);
 				blk_mq_sched_insert_requests(this_q, this_ctx,
@@ -1650,6 +1672,7 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 								from_schedule);
 			}
 
+			this_flags = rq->cmd_flags;
 			this_ctx = rq->mq_ctx;
 			this_q = rq->q;
 			depth = 0;
-- 
2.17.1
