From: Jens Axboe <axboe@kernel.dk>
Subject: Re: Oops when completing request on the wrong queue
Date: Wed, 24 Aug 2016 12:34:42 -0600
Message-ID: <49a954e6-2f96-8a63-ce15-2c82c1a1d36d@kernel.dk>
References: <87a8gltgks.fsf@linux.vnet.ibm.com>
 <871t1kq455.fsf@linux.vnet.ibm.com>
 <bb6f8757-4c3d-8f49-8aff-aa0fdb8bae89@kernel.dk>
 <8fc9ae38-9488-ef52-f620-08499edebffa@kernel.dk>
 <87shu0hfye.fsf@linux.vnet.ibm.com> <87a8g39pg4.fsf@linux.vnet.ibm.com>
 <43693064-dd37-92ce-7753-2a8edb43eab5@kernel.dk>
 <164a4c63-065b-b766-36f3-bcef4aa46a38@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f42.google.com ([209.85.214.42]:37113 "EHLO
        mail-it0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753762AbcHXSmS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2016 14:42:18 -0400
Received: by mail-it0-f42.google.com with SMTP id f6so49961372ith.0
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2016 11:41:29 -0700 (PDT)
In-Reply-To: <164a4c63-065b-b766-36f3-bcef4aa46a38@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Cc: Keith Busch <keith.busch@intel.com>, Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org, Brian King <brking@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org

On 08/23/2016 03:14 PM, Jens Axboe wrote:
> On 08/23/2016 03:11 PM, Jens Axboe wrote:
>> On 08/23/2016 02:54 PM, Gabriel Krisman Bertazi wrote:
>>> Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com> writes:
>>>
>>>>> Can you share what you ran to online/offline CPUs? I can't reproduce
>>>>> this here.
>>>>
>>>> I was using the ppc64_cpu tool, which shouldn't do nothing more than
>>>> write to sysfs.  but I just reproduced it with the script below.
>>>>
>>>> Note that this is ppc64le.  I don't have a x86 in hand to attempt to
>>>> reproduce right now, but I'll look for one and see how it goes.
>>>
>>> Hi,
>>>
>>> Any luck on reproducing it?  We were initially reproducing with a
>>> proprietary stress test, but I gave a try to a generated fio jobfile
>>> associated with the SMT script I shared earlier and I could reproduce
>>> the crash consistently in less than 10 minutes of execution.  this was
>>> still ppc64le, though.  I couldn't get my hands on nvme on x86 yet.
>>
>> Nope, I have not been able to reproduce it. How long does the CPU
>> offline/online actions take on ppc64? It's pretty slow on x86, which may
>> hide the issue. I took out the various printk's associated with bringing
>> a CPU off/online, as well as IRQ breaking parts, but didn't help in
>> reproducing it.
>>
>>> The job file I used, as well as the smt.sh script, in case you want to
>>> give it a try:
>>>
>>> jobfile: http://krisman.be/k/nvmejob.fio
>>> smt.sh:  http://krisman.be/k/smt.sh
>>>
>>> Still, the trigger seems to be consistently a heavy load of IO
>>> associated with CPU addition/removal.
>>
>> My workload looks similar to yours, in that it's high depth and with a
>> lot of jobs to keep most CPUs loaded. My bash script is different than
>> yours, I'll try that and see if it helps here.
>
> Actually, I take that back. You're not using O_DIRECT, hence all your
> jobs are running at QD=1, not the 256 specified. That looks odd, but
> I'll try, maybe it'll hit something different.

Can you try this patch? It's not perfect, but I'll be interested if it
makes a difference for you.

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 758a9b5..41def54 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -810,11 +810,11 @@ static void __blk_mq_run_hw_queue(struct 
blk_mq_hw_ctx *hctx)
  	struct list_head *dptr;
  	int queued;

-	WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask));
-
  	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
  		return;

+	WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask));
+
  	hctx->run++;

  	/*
@@ -1075,15 +1075,11 @@ static void __blk_mq_insert_request(struct 
blk_mq_hw_ctx *hctx,
  }

  void blk_mq_insert_request(struct request *rq, bool at_head, bool 
run_queue,
-		bool async)
+			   bool async)
  {
+	struct blk_mq_ctx *ctx = rq->mq_ctx;
  	struct request_queue *q = rq->q;
  	struct blk_mq_hw_ctx *hctx;
-	struct blk_mq_ctx *ctx = rq->mq_ctx, *current_ctx;
-
-	current_ctx = blk_mq_get_ctx(q);
-	if (!cpu_online(ctx->cpu))
-		rq->mq_ctx = ctx = current_ctx;

  	hctx = q->mq_ops->map_queue(q, ctx->cpu);

@@ -1093,8 +1089,6 @@ void blk_mq_insert_request(struct request *rq, 
bool at_head, bool run_queue,

  	if (run_queue)
  		blk_mq_run_hw_queue(hctx, async);
-
-	blk_mq_put_ctx(current_ctx);
  }

  static void blk_mq_insert_requests(struct request_queue *q,
@@ -1105,14 +1099,9 @@ static void blk_mq_insert_requests(struct 
request_queue *q,

  {
  	struct blk_mq_hw_ctx *hctx;
-	struct blk_mq_ctx *current_ctx;

  	trace_block_unplug(q, depth, !from_schedule);

-	current_ctx = blk_mq_get_ctx(q);
-
-	if (!cpu_online(ctx->cpu))
-		ctx = current_ctx;
  	hctx = q->mq_ops->map_queue(q, ctx->cpu);

  	/*
@@ -1125,14 +1114,12 @@ static void blk_mq_insert_requests(struct 
request_queue *q,

  		rq = list_first_entry(list, struct request, queuelist);
  		list_del_init(&rq->queuelist);
-		rq->mq_ctx = ctx;
  		__blk_mq_insert_req_list(hctx, ctx, rq, false);
  	}
  	blk_mq_hctx_mark_pending(hctx, ctx);
  	spin_unlock(&ctx->lock);

  	blk_mq_run_hw_queue(hctx, from_schedule);
-	blk_mq_put_ctx(current_ctx);
  }

  static int plug_ctx_cmp(void *priv, struct list_head *a, struct 
list_head *b)
@@ -1692,6 +1679,11 @@ static int blk_mq_hctx_cpu_offline(struct 
blk_mq_hw_ctx *hctx, int cpu)
  	while (!list_empty(&tmp)) {
  		struct request *rq;

+		/*
+		 * FIXME: we can't just move the req here. We'd have to
+		 * pull off the bio chain and add it to a new request
+		 * on the target hw queue
+		 */
  		rq = list_first_entry(&tmp, struct request, queuelist);
  		rq->mq_ctx = ctx;
  		list_move_tail(&rq->queuelist, &ctx->rq_list);

-- 
Jens Axboe
