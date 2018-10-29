From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 09/14] blk-mq: ensure that plug lists don't straddle
 hardware queues
Date: Mon, 29 Oct 2018 13:30:30 -0600
Message-ID: <2e8ae405-6cc2-ce7b-a6a3-ca2e19549e40@kernel.dk>
References: <20181029163738.10172-1-axboe@kernel.dk>
 <20181029163738.10172-10-axboe@kernel.dk>
 <1540841278.196084.84.camel@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1540841278.196084.84.camel@acm.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 10/29/18 1:27 PM, Bart Van Assche wrote:
> On Mon, 2018-10-29 at 10:37 -0600, Jens Axboe wrote:
>>  void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
>>  {
>>  	struct blk_mq_ctx *this_ctx;
>> @@ -1628,7 +1649,7 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
>>  	struct request *rq;
>>  	LIST_HEAD(list);
>>  	LIST_HEAD(ctx_list);
>> -	unsigned int depth;
>> +	unsigned int depth, this_flags;
>>  
>>  	list_splice_init(&plug->mq_list, &list);
>>  
>> @@ -1636,13 +1657,14 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
>>  
>>  	this_q = NULL;
>>  	this_ctx = NULL;
>> +	this_flags = 0;
>>  	depth = 0;
>>  
>>  	while (!list_empty(&list)) {
>>  		rq = list_entry_rq(list.next);
>>  		list_del_init(&rq->queuelist);
>>  		BUG_ON(!rq->q);
>> -		if (rq->mq_ctx != this_ctx) {
>> +		if (!ctx_match(rq, this_ctx, this_flags)) {
>>  			if (this_ctx) {
>>  				trace_block_unplug(this_q, depth, !from_schedule);
>>  				blk_mq_sched_insert_requests(this_q, this_ctx,
>> @@ -1650,6 +1672,7 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
>>  								from_schedule);
>>  			}
>>  
>> +			this_flags = rq->cmd_flags;
>>  			this_ctx = rq->mq_ctx;
>>  			this_q = rq->q;
>>  			depth = 0;
> 
> This patch will cause the function stored in the flags_to_type pointer to be
> called 2 * (n - 1) times where n is the number of elements in 'list' when
> blk_mq_sched_insert_requests() is called. Have you considered to rearrange
> the code such that that number of calls is reduced to n?

One alternative is to improve the sorting, but then we'd need to call
it in there instead. My longer term plan is something like the below,
which will reduce the number of calls in general, not just for
this path. But that is a separate change, should not be mixed
with this one.


diff --git a/block/blk-flush.c b/block/blk-flush.c
index 7922dba81497..397985808b75 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -219,7 +219,7 @@ static void flush_end_io(struct request *flush_rq, blk_status_t error)
 
 	/* release the tag's ownership to the req cloned from */
 	spin_lock_irqsave(&fq->mq_flush_lock, flags);
-	hctx = blk_mq_map_queue(q, flush_rq->cmd_flags, flush_rq->mq_ctx->cpu);
+	hctx = flush_rq->mq_hctx;
 	if (!q->elevator) {
 		blk_mq_tag_set_rq(hctx, flush_rq->tag, fq->orig_rq);
 		flush_rq->tag = -1;
@@ -307,13 +307,13 @@ static bool blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq,
 	if (!q->elevator) {
 		fq->orig_rq = first_rq;
 		flush_rq->tag = first_rq->tag;
-		hctx = blk_mq_map_queue(q, first_rq->cmd_flags,
-					first_rq->mq_ctx->cpu);
+		hctx = flush_rq->mq_hctx;
 		blk_mq_tag_set_rq(hctx, first_rq->tag, flush_rq);
 	} else {
 		flush_rq->internal_tag = first_rq->internal_tag;
 	}
 
+	flush_rq->mq_hctx = first_rq->mq_hctx;
 	flush_rq->cmd_flags = REQ_OP_FLUSH | REQ_PREFLUSH;
 	flush_rq->cmd_flags |= (flags & REQ_DRV) | (flags & REQ_FAILFAST_MASK);
 	flush_rq->rq_flags |= RQF_FLUSH_SEQ;
@@ -326,13 +326,11 @@ static bool blk_kick_flush(struct request_queue *q, struct blk_flush_queue *fq,
 static void mq_flush_data_end_io(struct request *rq, blk_status_t error)
 {
 	struct request_queue *q = rq->q;
-	struct blk_mq_hw_ctx *hctx;
+	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
 	unsigned long flags;
 	struct blk_flush_queue *fq = blk_get_flush_queue(q, ctx);
 
-	hctx = blk_mq_map_queue(q, rq->cmd_flags, ctx->cpu);
-
 	if (q->elevator) {
 		WARN_ON(rq->tag < 0);
 		blk_mq_put_driver_tag_hctx(hctx, rq);
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index fac70c81b7de..cde19be36135 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -427,10 +427,8 @@ struct show_busy_params {
 static void hctx_show_busy_rq(struct request *rq, void *data, bool reserved)
 {
 	const struct show_busy_params *params = data;
-	struct blk_mq_hw_ctx *hctx;
 
-	hctx = blk_mq_map_queue(rq->q, rq->cmd_flags, rq->mq_ctx->cpu);
-	if (hctx == params->hctx)
+	if (rq->mq_hctx == params->hctx)
 		__blk_mq_debugfs_rq_show(params->m,
 					 list_entry_rq(&rq->queuelist));
 }
diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index d232ecf3290c..8bc1f37acca2 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -367,9 +367,7 @@ void blk_mq_sched_insert_request(struct request *rq, bool at_head,
 	struct request_queue *q = rq->q;
 	struct elevator_queue *e = q->elevator;
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
-	struct blk_mq_hw_ctx *hctx;
-
-	hctx = blk_mq_map_queue(q, rq->cmd_flags, ctx->cpu);
+	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
 
 	/* flush rq in flush machinery need to be dispatched directly */
 	if (!(rq->rq_flags & RQF_FLUSH_SEQ) && op_is_flush(rq->cmd_flags)) {
@@ -408,7 +406,7 @@ void blk_mq_sched_insert_requests(struct request_queue *q,
 
 	/* For list inserts, requests better be on the same hw queue */
 	rq = list_first_entry(list, struct request, queuelist);
-	hctx = blk_mq_map_queue(q, rq->cmd_flags, ctx->cpu);
+	hctx = rq->mq_hctx;
 
 	e = hctx->queue->elevator;
 	if (e && e->type->ops.mq.insert_requests)
diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index 478a959357f5..fb836d818b80 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -527,14 +527,7 @@ int blk_mq_tag_update_depth(struct blk_mq_hw_ctx *hctx,
  */
 u32 blk_mq_unique_tag(struct request *rq)
 {
-	struct request_queue *q = rq->q;
-	struct blk_mq_hw_ctx *hctx;
-	int hwq = 0;
-
-	hctx = blk_mq_map_queue(q, rq->cmd_flags, rq->mq_ctx->cpu);
-	hwq = hctx->queue_num;
-
-	return (hwq << BLK_MQ_UNIQUE_TAG_BITS) |
+	return (rq->mq_hctx->queue_num << BLK_MQ_UNIQUE_TAG_BITS) |
 		(rq->tag & BLK_MQ_UNIQUE_TAG_MASK);
 }
 EXPORT_SYMBOL(blk_mq_unique_tag);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 52b07188b39a..6b74e186be8a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -300,6 +300,7 @@ static struct request *blk_mq_rq_ctx_init(struct blk_mq_alloc_data *data,
 	/* csd/requeue_work/fifo_time is initialized before use */
 	rq->q = data->q;
 	rq->mq_ctx = data->ctx;
+	rq->mq_hctx = data->hctx;
 	rq->rq_flags = rq_flags;
 	rq->cpu = -1;
 	rq->cmd_flags = op;
@@ -473,10 +474,11 @@ static void __blk_mq_free_request(struct request *rq)
 {
 	struct request_queue *q = rq->q;
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
-	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, rq->cmd_flags, ctx->cpu);
+	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
 	const int sched_tag = rq->internal_tag;
 
 	blk_pm_mark_last_busy(rq);
+	rq->mq_hctx = NULL;
 	if (rq->tag != -1)
 		blk_mq_put_tag(hctx, hctx->tags, ctx, rq->tag);
 	if (sched_tag != -1)
@@ -490,7 +492,7 @@ void blk_mq_free_request(struct request *rq)
 	struct request_queue *q = rq->q;
 	struct elevator_queue *e = q->elevator;
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
-	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(q, rq->cmd_flags, ctx->cpu);
+	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
 
 	if (rq->rq_flags & RQF_ELVPRIV) {
 		if (e && e->type->ops.mq.finish_request)
@@ -982,7 +984,7 @@ bool blk_mq_get_driver_tag(struct request *rq)
 {
 	struct blk_mq_alloc_data data = {
 		.q = rq->q,
-		.hctx = blk_mq_map_queue(rq->q, rq->cmd_flags, rq->mq_ctx->cpu),
+		.hctx = rq->mq_hctx,
 		.flags = BLK_MQ_REQ_NOWAIT,
 		.cmd_flags = rq->cmd_flags,
 	};
@@ -1148,7 +1150,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 
 		rq = list_first_entry(list, struct request, queuelist);
 
-		hctx = blk_mq_map_queue(rq->q, rq->cmd_flags, rq->mq_ctx->cpu);
+		hctx = rq->mq_hctx;
 		if (!got_budget && !blk_mq_get_dispatch_budget(hctx))
 			break;
 
@@ -1578,9 +1580,7 @@ void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx, struct request *rq,
  */
 void blk_mq_request_bypass_insert(struct request *rq, bool run_queue)
 {
-	struct blk_mq_ctx *ctx = rq->mq_ctx;
-	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(rq->q, rq->cmd_flags,
-							ctx->cpu);
+	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
 
 	spin_lock(&hctx->lock);
 	list_add_tail(&rq->queuelist, &hctx->dispatch);
@@ -1638,8 +1638,7 @@ static bool ctx_match(struct request *req, struct blk_mq_ctx *ctx,
 	if (req->q->tag_set->nr_maps == 1)
 		return true;
 
-	return blk_mq_map_queue(req->q, req->cmd_flags, ctx->cpu) ==
-		blk_mq_map_queue(req->q, flags, ctx->cpu);
+	return req->mq_hctx == blk_mq_map_queue(req->q, flags, ctx->cpu);
 }
 
 void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
@@ -1812,9 +1811,7 @@ blk_status_t blk_mq_request_issue_directly(struct request *rq)
 	blk_status_t ret;
 	int srcu_idx;
 	blk_qc_t unused_cookie;
-	struct blk_mq_ctx *ctx = rq->mq_ctx;
-	struct blk_mq_hw_ctx *hctx = blk_mq_map_queue(rq->q, rq->cmd_flags,
-							ctx->cpu);
+	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
 
 	hctx_lock(hctx, &srcu_idx);
 	ret = __blk_mq_try_issue_directly(hctx, rq, &unused_cookie, true);
@@ -1939,9 +1936,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_put_ctx(data.ctx);
 
 		if (same_queue_rq) {
-			data.hctx = blk_mq_map_queue(q,
-					same_queue_rq->cmd_flags,
-					same_queue_rq->mq_ctx->cpu);
+			data.hctx = same_queue_rq->mq_hctx;
 			blk_mq_try_issue_directly(data.hctx, same_queue_rq,
 					&cookie);
 		}
diff --git a/block/blk-mq.h b/block/blk-mq.h
index e27c6f8dc86c..f3d58f9a4552 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -210,13 +210,10 @@ static inline void blk_mq_put_driver_tag_hctx(struct blk_mq_hw_ctx *hctx,
 
 static inline void blk_mq_put_driver_tag(struct request *rq)
 {
-	struct blk_mq_hw_ctx *hctx;
-
 	if (rq->tag == -1 || rq->internal_tag == -1)
 		return;
 
-	hctx = blk_mq_map_queue(rq->q, rq->cmd_flags, rq->mq_ctx->cpu);
-	__blk_mq_put_driver_tag(hctx, rq);
+	__blk_mq_put_driver_tag(rq->mq_hctx, rq);
 }
 
 static inline void blk_mq_clear_mq_map(struct blk_mq_queue_map *qmap)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6e506044a309..e5e8e05ada4e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -129,6 +129,7 @@ enum mq_rq_state {
 struct request {
 	struct request_queue *q;
 	struct blk_mq_ctx *mq_ctx;
+	struct blk_mq_hw_ctx *mq_hctx;
 
 	int cpu;
 	unsigned int cmd_flags;		/* op and common flags */

-- 
Jens Axboe
