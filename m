From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/14] blk-mq: pass in request/bio flags to queue mapping
Date: Mon, 29 Oct 2018 10:37:28 -0600
Message-ID: <20181029163738.10172-5-axboe@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181029163738.10172-1-axboe@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Prep patch for being able to place request based not just on
CPU location, but also on the type of request.

Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-flush.c      |  7 +++---
 block/blk-mq-debugfs.c |  4 +++-
 block/blk-mq-sched.c   | 16 ++++++++++----
 block/blk-mq-tag.c     |  5 +++--
 block/blk-mq.c         | 50 +++++++++++++++++++++++-------------------
 block/blk-mq.h         |  8 ++++---
 block/blk.h            |  6 ++---
 7 files changed, 58 insertions(+), 38 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 9baa9a119447..7922dba81497 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -219,7 +219,7 @@ static void flush_end_io(struct request *flush_rq, blk_status_t error)
 
 	/* release the tag's ownership to the req cloned from */
 	spin_lock_irqsave(&fq->mq_flush_lock, flags);
-	hctx = blk_mq_map_queue(q, flush_rq->mq_ctx->cpu);
+	hctx = blk_mq_map_queue(q, flush_rq->cmd_flags, flush_rq->mq_ctx->cpu);
 	if (!q->elevator) {
 		blk_mq_tag_set_rq(hctx, flush_rq->tag, fq->orig_rq);
 		flush_rq->tag = -1;
@@ -307,7 +307,8 @@ static bool blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq,
 	if (!q->elevator) {
 		fq->orig_rq = first_rq;
 		flush_rq->tag = first_rq->tag;
-		hctx = blk_mq_map_queue(q, first_rq->mq_ctx->cpu);
+		hctx = blk_mq_map_queue(q, first_rq->cmd_flags,
+					first_rq->mq_ctx->cpu);
 		blk_mq_tag_set_rq(hctx, first_rq->tag, flush_rq);
 	} else {
 		flush_rq->internal_tag = first_rq->internal_tag;
@@ -330,7 +331,7 @@ static void mq_flush_data_end_io(struct request *rq, blk_status_t error)
 	unsigned long flags;
 	struct blk_flush_queue *fq = blk_get_flush_queue(q, ctx);
 
-	hctx = blk_mq_map_queue(q, ctx->cpu);
+	hctx = blk_mq_map_queue(q, rq->cmd_flags, ctx->cpu);
 
 	if (q->elevator) {
 		WARN_ON(rq->tag < 0);
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 9ed43a7c70b5..fac70c81b7de 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -427,8 +427,10 @@ struct show_busy_params {
 static void hctx_show_busy_rq(struct request *rq, void *data, bool reserved)
 {
 	const struct show_busy_params *params = data;
+	struct blk_mq_hw_ctx *hctx;
 
-	if (blk_mq_map_queue(rq->q, rq->mq_ctx->cpu) == params->hctx)
+	hctx = blk_mq_map_queue(rq->q, rq->cmd_flags, rq->mq_ctx->cpu);
+	if (hctx == params->hctx)
 		__blk_mq_debugfs_rq_show(params->m,
 					 list_entry_rq(&rq->queuelist));
 }
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 29bfe8017a2d..8125e9393ec2 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -311,7 +311,7 @@ bool __blk_mq_sched_bio_merge(struct request_queue *q, struct bio *bio)
 {
 	struct elevator_queue *e = q->elevator;
 	struct blk_mq_ctx *ctx = blk_mq_get_ctx(q);
-	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, ctx->cpu);
+	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, bio->bi_opf, ctx->cpu);
 	bool ret = false;
 
 	if (e && e->type->ops.mq.bio_merge) {
@@ -367,7 +367,9 @@ void blk_mq_sched_insert_request(struct request *rq, bool at_head,
 	struct request_queue *q = rq->q;
 	struct elevator_queue *e = q->elevator;
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
-	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, ctx->cpu);
+	struct blk_mq_hw_ctx *hctx;
+
+	hctx = blk_mq_map_queue(q, rq->cmd_flags, ctx->cpu);
 
 	/* flush rq in flush machinery need to be dispatched directly */
 	if (!(rq->rq_flags & RQF_FLUSH_SEQ) && op_is_flush(rq->cmd_flags)) {
@@ -400,9 +402,15 @@ void blk_mq_sched_insert_requests(struct request_queue *q,
 				  struct blk_mq_ctx *ctx,
 				  struct list_head *list, bool run_queue_async)
 {
-	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, ctx->cpu);
-	struct elevator_queue *e = hctx->queue->elevator;
+	struct blk_mq_hw_ctx *hctx;
+	struct elevator_queue *e;
+	struct request *rq;
+
+	/* For list inserts, requests better be on the same hw queue */
+	rq = list_first_entry(list, struct request, queuelist);
+	hctx = blk_mq_map_queue(q, rq->cmd_flags, ctx->cpu);
 
+	e = hctx->queue->elevator;
 	if (e && e->type->ops.mq.insert_requests)
 		e->type->ops.mq.insert_requests(hctx, list, false);
 	else {
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 4254e74c1446..478a959357f5 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -168,7 +168,8 @@ unsigned int blk_mq_get_tag(struct blk_mq_alloc_data *data)
 		io_schedule();
 
 		data->ctx = blk_mq_get_ctx(data->q);
-		data->hctx = blk_mq_map_queue(data->q, data->ctx->cpu);
+		data->hctx = blk_mq_map_queue(data->q, data->cmd_flags,
+						data->ctx->cpu);
 		tags = blk_mq_tags_from_data(data);
 		if (data->flags & BLK_MQ_REQ_RESERVED)
 			bt = &tags->breserved_tags;
@@ -530,7 +531,7 @@ u32 blk_mq_unique_tag(struct request *rq)
 	struct blk_mq_hw_ctx *hctx;
 	int hwq = 0;
 
-	hctx = blk_mq_map_queue(q, rq->mq_ctx->cpu);
+	hctx = blk_mq_map_queue(q, rq->cmd_flags, rq->mq_ctx->cpu);
 	hwq = hctx->queue_num;
 
 	return (hwq << BLK_MQ_UNIQUE_TAG_BITS) |
diff --git a/block/blk-mq.c b/block/blk-mq.c
index fa2e5176966e..e6ea7da99125 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -332,8 +332,8 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 }
 
 static struct request *blk_mq_get_request(struct request_queue *q,
-		struct bio *bio, unsigned int op,
-		struct blk_mq_alloc_data *data)
+					  struct bio *bio,
+					  struct blk_mq_alloc_data *data)
 {
 	struct elevator_queue *e = q->elevator;
 	struct request *rq;
@@ -347,8 +347,9 @@ static struct request *blk_mq_get_request(struct request_queue *q,
 		put_ctx_on_error = true;
 	}
 	if (likely(!data->hctx))
-		data->hctx = blk_mq_map_queue(q, data->ctx->cpu);
-	if (op & REQ_NOWAIT)
+		data->hctx = blk_mq_map_queue(q, data->cmd_flags,
+						data->ctx->cpu);
+	if (data->cmd_flags & REQ_NOWAIT)
 		data->flags |= BLK_MQ_REQ_NOWAIT;
 
 	if (e) {
@@ -359,9 +360,10 @@ static struct request *blk_mq_get_request(struct request_queue *q,
 		 * dispatch list. Don't include reserved tags in the
 		 * limiting, as it isn't useful.
 		 */
-		if (!op_is_flush(op) && e->type->ops.mq.limit_depth &&
+		if (!op_is_flush(data->cmd_flags) &&
+		    e->type->ops.mq.limit_depth &&
 		    !(data->flags & BLK_MQ_REQ_RESERVED))
-			e->type->ops.mq.limit_depth(op, data);
+			e->type->ops.mq.limit_depth(data->cmd_flags, data);
 	} else {
 		blk_mq_tag_busy(data->hctx);
 	}
@@ -376,8 +378,8 @@ static struct request *blk_mq_get_request(struct request_queue *q,
 		return NULL;
 	}
 
-	rq = blk_mq_rq_ctx_init(data, tag, op);
-	if (!op_is_flush(op)) {
+	rq = blk_mq_rq_ctx_init(data, tag, data->cmd_flags);
+	if (!op_is_flush(data->cmd_flags)) {
 		rq->elv.icq = NULL;
 		if (e && e->type->ops.mq.prepare_request) {
 			if (e->type->icq_cache && rq_ioc(bio))
@@ -394,7 +396,7 @@ static struct request *blk_mq_get_request(struct request_queue *q,
 struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
 		blk_mq_req_flags_t flags)
 {
-	struct blk_mq_alloc_data alloc_data = { .flags = flags };
+	struct blk_mq_alloc_data alloc_data = { .flags = flags, .cmd_flags = op };
 	struct request *rq;
 	int ret;
 
@@ -402,7 +404,7 @@ struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
 	if (ret)
 		return ERR_PTR(ret);
 
-	rq = blk_mq_get_request(q, NULL, op, &alloc_data);
+	rq = blk_mq_get_request(q, NULL, &alloc_data);
 	blk_queue_exit(q);
 
 	if (!rq)
@@ -420,7 +422,7 @@ EXPORT_SYMBOL(blk_mq_alloc_request);
 struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
 	unsigned int op, blk_mq_req_flags_t flags, unsigned int hctx_idx)
 {
-	struct blk_mq_alloc_data alloc_data = { .flags = flags };
+	struct blk_mq_alloc_data alloc_data = { .flags = flags, .cmd_flags = op };
 	struct request *rq;
 	unsigned int cpu;
 	int ret;
@@ -453,7 +455,7 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
 	cpu = cpumask_first_and(alloc_data.hctx->cpumask, cpu_online_mask);
 	alloc_data.ctx = __blk_mq_get_ctx(q, cpu);
 
-	rq = blk_mq_get_request(q, NULL, op, &alloc_data);
+	rq = blk_mq_get_request(q, NULL, &alloc_data);
 	blk_queue_exit(q);
 
 	if (!rq)
@@ -467,7 +469,7 @@ static void __blk_mq_free_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
-	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, ctx->cpu);
+	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, rq->cmd_flags, ctx->cpu);
 	const int sched_tag = rq->internal_tag;
 
 	blk_pm_mark_last_busy(rq);
@@ -484,7 +486,7 @@ void blk_mq_free_request(struct request *rq)
 	struct request_queue *q = rq->q;
 	struct elevator_queue *e = q->elevator;
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
-	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, ctx->cpu);
+	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, rq->cmd_flags, ctx->cpu);
 
 	if (rq->rq_flags & RQF_ELVPRIV) {
 		if (e && e->type->ops.mq.finish_request)
@@ -976,8 +978,9 @@ bool blk_mq_get_driver_tag(struct request *rq)
 {
 	struct blk_mq_alloc_data data = {
 		.q = rq->q,
-		.hctx = blk_mq_map_queue(rq->q, rq->mq_ctx->cpu),
+		.hctx = blk_mq_map_queue(rq->q, rq->cmd_flags, rq->mq_ctx->cpu),
 		.flags = BLK_MQ_REQ_NOWAIT,
+		.cmd_flags = rq->cmd_flags,
 	};
 	bool shared;
 
@@ -1141,7 +1144,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 
 		rq = list_first_entry(list, struct request, queuelist);
 
-		hctx = blk_mq_map_queue(rq->q, rq->mq_ctx->cpu);
+		hctx = blk_mq_map_queue(rq->q, rq->cmd_flags, rq->mq_ctx->cpu);
 		if (!got_budget && !blk_mq_get_dispatch_budget(hctx))
 			break;
 
@@ -1572,7 +1575,8 @@ void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
 void blk_mq_request_bypass_insert(struct request *rq, bool run_queue)
 {
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
-	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(rq->q, ctx->cpu);
+	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(rq->q, rq->cmd_flags,
+							ctx->cpu);
 
 	spin_lock(&hctx->lock);
 	list_add_tail(&rq->queuelist, &hctx->dispatch);
@@ -1782,7 +1786,8 @@ blk_status_t blk_mq_request_issue_directly(struct request *rq)
 	int srcu_idx;
 	blk_qc_t unused_cookie;
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
-	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(rq->q, ctx->cpu);
+	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(rq->q, rq->cmd_flags,
+							ctx->cpu);
 
 	hctx_lock(hctx, &srcu_idx);
 	ret = __blk_mq_try_issue_directly(hctx, rq, &unused_cookie, true);
@@ -1816,7 +1821,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 {
 	const int is_sync = op_is_sync(bio->bi_opf);
 	const int is_flush_fua = op_is_flush(bio->bi_opf);
-	struct blk_mq_alloc_data data = { .flags = 0 };
+	struct blk_mq_alloc_data data = { .flags = 0, .cmd_flags = bio->bi_opf };
 	struct request *rq;
 	unsigned int request_count = 0;
 	struct blk_plug *plug;
@@ -1839,7 +1844,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 
 	rq_qos_throttle(q, bio, NULL);
 
-	rq = blk_mq_get_request(q, bio, bio->bi_opf, &data);
+	rq = blk_mq_get_request(q, bio, &data);
 	if (unlikely(!rq)) {
 		rq_qos_cleanup(q, bio);
 		if (bio->bi_opf & REQ_NOWAIT)
@@ -1908,6 +1913,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 
 		if (same_queue_rq) {
 			data.hctx = blk_mq_map_queue(q,
+					same_queue_rq->cmd_flags,
 					same_queue_rq->mq_ctx->cpu);
 			blk_mq_try_issue_directly(data.hctx, same_queue_rq,
 					&cookie);
@@ -2262,7 +2268,7 @@ static void blk_mq_init_cpu_queues(struct request_queue *q,
 		 * Set local node, IFF we have more than one hw queue. If
 		 * not, we remain on the home node of the device
 		 */
-		hctx = blk_mq_map_queue(q, i);
+		hctx = blk_mq_map_queue_type(q, 0, i);
 		if (nr_hw_queues > 1 && hctx->numa_node == NUMA_NO_NODE)
 			hctx->numa_node = local_memory_node(cpu_to_node(i));
 	}
@@ -2335,7 +2341,7 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 		}
 
 		ctx = per_cpu_ptr(q->queue_ctx, i);
-		hctx = blk_mq_map_queue(q, i);
+		hctx = blk_mq_map_queue_type(q, 0, i);
 
 		cpumask_set_cpu(i, hctx->cpumask);
 		ctx->index_hw = hctx->nr_ctx;
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 79c300faa7ce..55428b92c019 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -73,7 +73,8 @@ void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
 extern int blk_mq_hw_queue_to_node(struct blk_mq_queue_map *qmap, unsigned int);
 
 static inline struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *q,
-		int cpu)
+						     unsigned int flags,
+						     int cpu)
 {
 	struct blk_mq_tag_set *set = q->tag_set;
 
@@ -83,7 +84,7 @@ static inline struct blk_mq_hw_ctx *blk_mq_map_queue(struct request_queue *q,
 static inline struct blk_mq_hw_ctx *blk_mq_map_queue_type(struct request_queue *q,
 							  int type, int cpu)
 {
-	return blk_mq_map_queue(q, cpu);
+	return blk_mq_map_queue(q, type, cpu);
 }
 
 /*
@@ -134,6 +135,7 @@ struct blk_mq_alloc_data {
 	struct request_queue *q;
 	blk_mq_req_flags_t flags;
 	unsigned int shallow_depth;
+	unsigned int cmd_flags;
 
 	/* input & output parameter */
 	struct blk_mq_ctx *ctx;
@@ -208,7 +210,7 @@ static inline void blk_mq_put_driver_tag(struct request *rq)
 	if (rq->tag == -1 || rq->internal_tag == -1)
 		return;
 
-	hctx = blk_mq_map_queue(rq->q, rq->mq_ctx->cpu);
+	hctx = blk_mq_map_queue(rq->q, rq->cmd_flags, rq->mq_ctx->cpu);
 	__blk_mq_put_driver_tag(hctx, rq);
 }
 
diff --git a/block/blk.h b/block/blk.h
index 2bf1cfeeb9c0..78ae94886acf 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -104,10 +104,10 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 	__clear_bit(flag, &q->queue_flags);
 }
 
-static inline struct blk_flush_queue *blk_get_flush_queue(
-		struct request_queue *q, struct blk_mq_ctx *ctx)
+static inline struct blk_flush_queue *
+blk_get_flush_queue(struct request_queue *q, struct blk_mq_ctx *ctx)
 {
-	return blk_mq_map_queue(q, ctx->cpu)->fq;
+	return blk_mq_map_queue(q, REQ_OP_FLUSH, ctx->cpu)->fq;
 }
 
 static inline void __blk_get_queue(struct request_queue *q)
-- 
2.17.1
