From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH V7 4/6] blk-mq: introduce .get_budget and .put_budget in
 blk_mq_ops
Date: Fri, 13 Oct 2017 10:28:00 -0600
Message-ID: <18389d59-4228-e4f5-c6e2-ebeabe17fc37@kernel.dk>
References: <20171012183704.22326-1-ming.lei@redhat.com>
 <20171012183704.22326-5-ming.lei@redhat.com>
 <9a741c03-90a3-e583-ddde-0ed71c8570a2@kernel.dk>
 <20171013001919.GA24715@ming.t460p>
 <6efdb459-8746-562d-06dc-5b3e172076e1@kernel.dk>
 <20171013160731.GA30899@ming.t460p>
 <845bd050-8566-8749-d73f-9a3731c7736f@kernel.dk>
 <20171013162111.GC30899@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171013162111.GC30899@ming.t460p>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, Laurence Oberman <loberman@redhat.com>, Paolo Valente <paolo.valente@linaro.org>, Oleksandr Natalenko <oleksandr@natalenko.name>, Tom Nguyen <tom81094@gmail.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Omar Sandoval <osandov@fb.com>, John Garry <john.garry@huawei.com>
List-Id: linux-scsi@vger.kernel.org

On 10/13/2017 10:21 AM, Ming Lei wrote:
> On Fri, Oct 13, 2017 at 10:19:04AM -0600, Jens Axboe wrote:
>> On 10/13/2017 10:07 AM, Ming Lei wrote:
>>> On Fri, Oct 13, 2017 at 08:44:23AM -0600, Jens Axboe wrote:
>>>> On 10/12/2017 06:19 PM, Ming Lei wrote:
>>>>> On Thu, Oct 12, 2017 at 12:46:24PM -0600, Jens Axboe wrote:
>>>>>> On 10/12/2017 12:37 PM, Ming Lei wrote:
>>>>>>> For SCSI devices, there is often per-request-queue depth, which need
>>>>>>> to be respected before queuing one request.
>>>>>>>
>>>>>>> The current blk-mq always dequeues one request first, then calls .queue_rq()
>>>>>>> to dispatch the request to lld. One obvious issue of this way is that I/O
>>>>>>> merge may not be good, because when the per-request-queue depth can't be
>>>>>>> respected,  .queue_rq() has to return BLK_STS_RESOURCE, then this request
>>>>>>> has to staty in hctx->dispatch list, and never got chance to participate
>>>>>>> into I/O merge.
>>>>>>>
>>>>>>> This patch introduces .get_budget and .put_budget callback in blk_mq_ops,
>>>>>>> then we can try to get reserved budget first before dequeuing request.
>>>>>>> Once we can't get budget for queueing I/O, we don't need to dequeue request
>>>>>>> at all, then I/O merge can get improved a lot.
>>>>>>
>>>>>> I can't help but think that it would be cleaner to just be able to
>>>>>> reinsert the request into the scheduler properly, if we fail to
>>>>>> dispatch it. Bart hinted at that earlier as well.
>>>>>
>>>>> Actually when I start to investigate the issue, the 1st thing I tried
>>>>> is to reinsert, but that way is even worse on qla2xxx.
>>>>>
>>>>> Once request is dequeued, the IO merge chance is decreased a lot.
>>>>> With none scheduler, it becomes not possible to merge because
>>>>> we only try to merge over the last 8 requests. With mq-deadline,
>>>>> when one request is reinserted, another request may be dequeued
>>>>> at the same time.
>>>>
>>>> I don't care too much about 'none'. If perfect merging is crucial for
>>>> getting to the performance level you want on the hardware you are using,
>>>> you should not be using 'none'. 'none' will work perfectly fine for NVMe
>>>> etc style devices, where we are not dependent on merging to the same
>>>> extent that we are on other devices.
>>>>
>>>> mq-deadline reinsertion will be expensive, that's in the nature of that
>>>> beast. It's basically the same as a normal request inserition.  So for
>>>> that, we'd have to be a bit careful not to run into this too much. Even
>>>> with a dumb approach, it should only happen 1 out of N times, where N is
>>>> the typical point at which the device will return STS_RESOURCE. The
>>>> reinsertion vs dequeue should be serialized with your patch to do that,
>>>> at least for the single queue mq-deadline setup. In fact, I think your
>>>> approach suffers from that same basic race, in that the budget isn't a
>>>> hard allocation, it's just a hint. It can change from the time you check
>>>> it, and when you go and dispatch the IO, if you don't serialize that
>>>> part. So really should be no different in that regard.
>>>
>>> In case of SCSI, the .get_buget is done as atomic counting,
>>> and it is completely effective to avoid unnecessary dequeue, please take
>>> a look at patch 6.
>>
>> Looks like you are right, I had initially misread that as just checking
>> the busy count. But you are actually getting the count at that point,
>> so it should be solid.
>>
>>>>> Not mention the cost of acquiring/releasing lock, that work
>>>>> is just doing useless work and wasting CPU.
>>>>
>>>> Sure, my point is that if it doesn't happen too often, it doesn't really
>>>> matter. It's not THAT expensive.
>>>
>>> Actually it is in hot path, for example, lpfc and qla2xx's queue depth is 3,
>>> it is quite easy to trigger STS_RESOURCE.
>>
>> Ugh, that is low.
>>
>> OK, I think we should just roll with this and see how far we can go. I'll
>> apply it for 4.15.
> 
> OK, I have some update, will post a new version soon.

Fold something like this into it then:


diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index ccbbc7e108ea..b7bf84b5ddf2 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -102,13 +102,12 @@ static bool blk_mq_do_dispatch_sched(struct blk_mq_hw_ctx *hctx)
 				!e->type->ops.mq.has_work(hctx))
 			break;
 
-		if (q->mq_ops->get_budget && !q->mq_ops->get_budget(hctx))
+		if (!blk_mq_get_dispatch_budget(hctx))
 			return true;
 
 		rq = e->type->ops.mq.dispatch_request(hctx);
 		if (!rq) {
-			if (q->mq_ops->put_budget)
-				q->mq_ops->put_budget(hctx);
+			blk_mq_put_dispatch_budget(hctx, true);
 			break;
 		}
 		list_add(&rq->queuelist, &rq_list);
@@ -140,13 +139,12 @@ static bool blk_mq_do_dispatch_ctx(struct blk_mq_hw_ctx *hctx)
 		if (!sbitmap_any_bit_set(&hctx->ctx_map))
 			break;
 
-		if (q->mq_ops->get_budget && !q->mq_ops->get_budget(hctx))
+		if (!blk_mq_get_dispatch_budget(hctx))
 			return true;
 
 		rq = blk_mq_dequeue_from_ctx(hctx, ctx);
 		if (!rq) {
-			if (q->mq_ops->put_budget)
-				q->mq_ops->put_budget(hctx);
+			blk_mq_put_dispatch_budget(hctx, true);
 			break;
 		}
 		list_add(&rq->queuelist, &rq_list);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 255a705f8672..008c975b6f4b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1087,14 +1087,6 @@ static bool blk_mq_dispatch_wait_add(struct blk_mq_hw_ctx *hctx)
 	return true;
 }
 
-static void blk_mq_put_budget(struct blk_mq_hw_ctx *hctx, bool got_budget)
-{
-	struct request_queue *q = hctx->queue;
-
-	if (q->mq_ops->put_budget && got_budget)
-		q->mq_ops->put_budget(hctx);
-}
-
 bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 		bool got_budget)
 {
@@ -1125,7 +1117,7 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 			 * rerun the hardware queue when a tag is freed.
 			 */
 			if (!blk_mq_dispatch_wait_add(hctx)) {
-				blk_mq_put_budget(hctx, got_budget);
+				blk_mq_put_dispatch_budget(hctx, got_budget);
 				break;
 			}
 
@@ -1135,16 +1127,13 @@ bool blk_mq_dispatch_rq_list(struct request_queue *q, struct list_head *list,
 			 * hardware queue to the wait queue.
 			 */
 			if (!blk_mq_get_driver_tag(rq, &hctx, false)) {
-				blk_mq_put_budget(hctx, got_budget);
+				blk_mq_put_dispatch_budget(hctx, got_budget);
 				break;
 			}
 		}
 
-		if (!got_budget) {
-			if (q->mq_ops->get_budget &&
-					!q->mq_ops->get_budget(hctx))
-				break;
-		}
+		if (!got_budget && !blk_mq_get_dispatch_budget(hctx))
+			break;
 
 		list_del_init(&rq->queuelist);
 
@@ -1642,7 +1631,7 @@ static void __blk_mq_try_issue_directly(struct blk_mq_hw_ctx *hctx,
 	if (!blk_mq_get_driver_tag(rq, NULL, false))
 		goto insert;
 
-	if (q->mq_ops->get_budget && !q->mq_ops->get_budget(hctx)) {
+	if (!blk_mq_get_dispatch_budget(hctx)) {
 		blk_mq_put_driver_tag(rq);
 		goto insert;
 	}
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 4d12ef08b0a9..9a1426e8b6e5 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -139,4 +139,23 @@ static inline bool blk_mq_hw_queue_mapped(struct blk_mq_hw_ctx *hctx)
 void blk_mq_in_flight(struct request_queue *q, struct hd_struct *part,
 			unsigned int inflight[2]);
 
+static inline bool blk_mq_get_dispatch_budget(struct blk_mq_hw_ctx *hctx)
+{
+	struct request_queue *q = hctx->queue;
+
+	if (!q->mq_ops->get_budget)
+		return true;
+
+	return q->mq_ops->get_budget(hctx);
+}
+
+static inline void blk_mq_put_dispatch_budget(struct blk_mq_hw_ctx *hctx,
+					      bool got_budget)
+{
+	struct request_queue *q = hctx->queue;
+
+	if (got_budget && q->mq_ops->put_budget)
+		q->mq_ops->put_budget(hctx);
+}
+
 #endif

-- 
Jens Axboe
