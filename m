From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 8/8] IB/srp: Add multichannel support
Date: Fri, 19 Sep 2014 17:35:11 +0200
Message-ID: <541C4D2F.9060907@acm.org>
References: <541C27BF.6070609@acm.org>	<541C28E0.7010705@acm.org>	<CACVXFVPzz37J-613NZCfPStUBxf0rLOtz71LJ07PpCxYg5nn+g@mail.gmail.com>	<541C49EC.6030404@acm.org> <CACVXFVPH_qPFUTT+796BZmWxeeG4tJ-Pyp8hqGqqSwt3YYkEqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:48291 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932225AbaISPfO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Sep 2014 11:35:14 -0400
In-Reply-To: <CACVXFVPH_qPFUTT+796BZmWxeeG4tJ-Pyp8hqGqqSwt3YYkEqA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@canonical.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Robert Elliott <Elliott@hp.com>

On 09/19/14 17:27, Ming Lei wrote:
> On Fri, Sep 19, 2014 at 11:21 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>> On 09/19/14 16:28, Ming Lei wrote:
>>>
>>> On Fri, Sep 19, 2014 at 9:00 PM, Bart Van Assche <bvanassche@acm.org>
>>> wrote:
>>>>
>>>> @@ -2643,7 +2754,8 @@ static struct scsi_host_template srp_template = {
>>>>           .proc_name                      = DRV_NAME,
>>>>           .slave_configure                = srp_slave_configure,
>>>>           .info                           = srp_target_info,
>>>> -       .queuecommand                   = srp_queuecommand,
>>>> +       .queuecommand                   = srp_sq_queuecommand,
>>>> +       .mq_queuecommand                = srp_mq_queuecommand,
>>>
>>>
>>> Another choice is to obtain hctx from request directly, then mq can
>>> reuse the .queuecommand interface too.
>>
>>
>> Hello Ming,
>>
>> Is the hctx information already available in the request data structure ? I
>> have found a mq_ctx member but no hctx member. Did I perhaps overlook
>> something ?
> 
> You are right, but the mq_ctx can be mapped to hctx like below way:
> 
> ctx = rq->mq_ctx;
> hctx = q->mq_ops->map_queue(q, ctx->cpu);

Hello Ming,

Had you already noticed that the blk_mq_ctx data structure is a private
data structure (declared in block/blk-mq.h) and hence not available to
SCSI LLDs ? However, what might be possible is to cache the hctx pointer
in the request structure, e.g. like in the (completely untested) patch
below.

[PATCH] blk-mq: Cache hardware context pointer in struct request

Cache the hardware context pointer in struct request such that block
drivers can determine which hardware queue has been selected by
reading rq->mq_hctx->queue_num. This information is needed to select
the appropriate hardware queue in e.g. SCSI LLDs.
---
 block/blk-flush.c      |  6 +-----
 block/blk-mq.c         | 16 +++++++++-------
 include/linux/blkdev.h |  1 +
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 3cb5e9e..698812d 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -327,13 +327,9 @@ static void flush_data_end_io(struct request *rq, int error)
 static void mq_flush_data_end_io(struct request *rq, int error)
 {
 	struct request_queue *q = rq->q;
-	struct blk_mq_hw_ctx *hctx;
-	struct blk_mq_ctx *ctx;
+	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
 	unsigned long flags;
 
-	ctx = rq->mq_ctx;
-	hctx = q->mq_ops->map_queue(q, ctx->cpu);
-
 	/*
 	 * After populating an empty queue, kick it to avoid stall.  Read
 	 * the comment in flush_end_io().
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 383ea0c..8e428fe 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -210,6 +210,7 @@ __blk_mq_alloc_request(struct blk_mq_alloc_data *data, int rw)
 		}
 
 		rq->tag = tag;
+		rq->mq_hctx = data->hctx;
 		blk_mq_rq_ctx_init(data->q, data->ctx, rq, rw);
 		return rq;
 	}
@@ -267,12 +268,10 @@ static void __blk_mq_free_request(struct blk_mq_hw_ctx *hctx,
 void blk_mq_free_request(struct request *rq)
 {
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
-	struct blk_mq_hw_ctx *hctx;
-	struct request_queue *q = rq->q;
+	struct blk_mq_hw_ctx *hctx = rq->mq_hctx;
 
 	ctx->rq_completed[rq_is_sync(rq)]++;
 
-	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 	__blk_mq_free_request(hctx, ctx, rq);
 }
 
@@ -287,10 +286,10 @@ void blk_mq_free_request(struct request *rq)
 void blk_mq_clone_flush_request(struct request *flush_rq,
 		struct request *orig_rq)
 {
-	struct blk_mq_hw_ctx *hctx =
-		orig_rq->q->mq_ops->map_queue(orig_rq->q, orig_rq->mq_ctx->cpu);
+	struct blk_mq_hw_ctx *hctx = orig_rq->mq_hctx;
 
 	flush_rq->mq_ctx = orig_rq->mq_ctx;
+	flush_rq->mq_hctx = hctx;
 	flush_rq->tag = orig_rq->tag;
 	memcpy(blk_mq_rq_to_pdu(flush_rq), blk_mq_rq_to_pdu(orig_rq),
 		hctx->cmd_size);
@@ -956,6 +955,7 @@ void blk_mq_insert_request(struct request *rq, bool at_head, bool run_queue,
 		rq->mq_ctx = ctx = current_ctx;
 
 	hctx = q->mq_ops->map_queue(q, ctx->cpu);
+	rq->mq_hctx = hctx;
 
 	if (rq->cmd_flags & (REQ_FLUSH | REQ_FUA) &&
 	    !(rq->cmd_flags & (REQ_FLUSH_SEQ))) {
@@ -1001,6 +1001,7 @@ static void blk_mq_insert_requests(struct request_queue *q,
 		rq = list_first_entry(list, struct request, queuelist);
 		list_del_init(&rq->queuelist);
 		rq->mq_ctx = ctx;
+		rq->mq_hctx = hctx;
 		__blk_mq_insert_request(hctx, rq, false);
 	}
 	spin_unlock(&ctx->lock);
@@ -1475,6 +1476,8 @@ static int blk_mq_hctx_cpu_offline(struct blk_mq_hw_ctx *hctx, int cpu)
 		return NOTIFY_OK;
 
 	ctx = blk_mq_get_ctx(q);
+	hctx = q->mq_ops->map_queue(q, ctx->cpu);
+
 	spin_lock(&ctx->lock);
 
 	while (!list_empty(&tmp)) {
@@ -1482,10 +1485,9 @@ static int blk_mq_hctx_cpu_offline(struct blk_mq_hw_ctx *hctx, int cpu)
 
 		rq = list_first_entry(&tmp, struct request, queuelist);
 		rq->mq_ctx = ctx;
+		rq->mq_hctx = hctx;
 		list_move_tail(&rq->queuelist, &ctx->rq_list);
 	}
-
-	hctx = q->mq_ops->map_queue(q, ctx->cpu);
 	blk_mq_hctx_mark_pending(hctx, ctx);
 
 	spin_unlock(&ctx->lock);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 518b465..e3a14a2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -105,6 +105,7 @@ struct request {
 
 	struct request_queue *q;
 	struct blk_mq_ctx *mq_ctx;
+	struct blk_mq_hw_ctx *mq_hctx;
 
 	u64 cmd_flags;
 	enum rq_cmd_type_bits cmd_type;
-- 
1.8.4.5


