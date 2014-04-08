From: Jens Axboe <axboe@kernel.dk>
Subject: Re: blk-mq queue selection and queue_rq preemption
Date: Tue, 08 Apr 2014 09:40:41 -0600
Message-ID: <53441879.3010909@kernel.dk>
References: <53429DA2.4030708@dev.mellanox.co.il> <53430063.1020503@kernel.dk> <5343D93A.3070709@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030801020500030606070709"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:39214 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756121AbaDHPkq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Apr 2014 11:40:46 -0400
Received: by mail-pb0-f49.google.com with SMTP id jt11so1198131pbb.36
        for <linux-scsi@vger.kernel.org>; Tue, 08 Apr 2014 08:40:45 -0700 (PDT)
In-Reply-To: <5343D93A.3070709@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>

This is a multi-part message in MIME format.
--------------030801020500030606070709
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 2014-04-08 05:10, Sagi Grimberg wrote:
> On 4/7/2014 10:45 PM, Jens Axboe wrote:
>> On 04/07/2014 06:44 AM, Sagi Grimberg wrote:
>>> Hey Jens, Christoph & Co,
>>>
>>> I raised this question at LSF but didn't get a clear answer on this
>>> matter.
>>> So it seems to me that the hctx selection and the actual request
>>> dispatch (queue_rq) are preemptive:
>>> (1) blk_mq_get_ctx(q);
>>> (2) map_queue(q, ctx->cpu);
>>> ...
>>> (3) blk_mq_put_ctx(ctx);
>>> (4) blk_mq_run_hw_queue(hctx, async);
>>>
>>> It is possible that an MQ device driver may want to implement a lockless
>>> scheme counting on (running) CPU <-> hctx attachment.
>>> Generally speaking, I think that LLDs will be more comfortable knowing
>>> that they are not preemptive in the dispatch flow.
>>>
>>> My question is, is this a must? if so can you please explain why?
>>>
>>> Is it possible to put the hctx (restoring preemption) after run_hw_queue
>>> allowing to LLDs to be sure that the selected queue
>>> match the running CPU?
>>
>> It's a good question, and one I have thought about before. As you
>> note, in the existing code, the mappings are what I would refer to as
>> "soft". Generally speaking, CPU X will always map to hardware queue Y,
>> but there are no specific guarantees made to effect. It would be
>> trivial to make this mapping hard, and I'd be very open to doing that.
>> But so far I haven't seen cases where it would improve things. If you
>> end up being preempted and moved to a different CPU, it doesn't really
>> matter if this happens before or after you queued the IO - the
>> completion will end up in the "wrong" location regardless.
>>
>> But if drivers can be simplified and improved through relying on hard
>> mappings (and preempt hence disabled), then I would definitely provide
>> that possibility as well. If it doesn't hurt by default, we can just
>> switch to that model.
>>
>
> Hey Jens, thanks for the quick response!
>
> So in my driver I would definitely want to rely on hard mappings.
> The reason is that I maintain a context for IO completions (lets call it
> "completer") and a submission queue percpu.
> The completer handles IO completions and also peeks at the submission
> queue to handle pending IOs.
> I wish to keep mutual exclusion between the completer and the submission
> context.
> The driver is capable of setting the IO submission so that the
> completion will end up on the same core.
>
> Hard mappings providing non-preemptive submission flows will guarantee
> that the above scheme will work.
> At the moment I do:
> (1) queue = hctx->driver_data
> process request...
> (2) cpu = get_cpu()
> (3) if (cpu != queue.id)
>              queue = queues[cpu]
> (4) submit_io(queue)
> (5) put_cpu()
>
> So, adding hard_map indicator to blk_mq_reg will be great.
>
> As I mentioned in the general case, I think that LLDs will be more
> comfortable with hard mappings in order to avoid/reduce
> lock contention in the submission path and also possibly exploiting
> cache/NUMA locality. Moreover I think that setting the device to generate
> IO completion on the submission CPU is common practice for blk-mq
> implementation. isn't it?
>
> I would definitely like to get more input from the driver folks on this.

I've rolled up a set of changes to test this out, I have attached the 
small series. As I originally stated, it was due to performance concerns 
that I didn't do this originally. If this works better (or the same) on 
cases where we don't necessarily care about the hard mappings, then we 
should just do it. It's a cleaner model, and the hardware that has as 
many queues as CPUs, it's definitely the right (and obvious) thing to do.

Note that the attached are TOTALLY untested.

-- 
Jens Axboe


--------------030801020500030606070709
Content-Type: text/x-patch;
 name="0003-blk-mq-ensure-that-hardware-queues-are-always-run-on.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-blk-mq-ensure-that-hardware-queues-are-always-run-on.pa";
 filename*1="tch"

>From 73fecdbf2962b7171cb3a265e795005ee3cf8908 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@fb.com>
Date: Tue, 8 Apr 2014 09:36:09 -0600
Subject: [PATCH 3/3] blk-mq: ensure that hardware queues are always run on the
 mapped CPUs

Instead of providing soft mappings with no guarantees on hardware
queues always being run on the right CPU, switch to a hard mapping
guarantee that ensure that we always run the hardware queue on
(one of, if more) the mapped CPU.

Signed-off-by: Jens Axboe <axboe@fb.com>
---
 block/blk-mq.c         | 55 +++++++++++++++++++++++++++++++++++++++-----------
 include/linux/blk-mq.h |  1 +
 2 files changed, 44 insertions(+), 12 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 9c8f1f4ada7f..58f95d21c210 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -209,11 +209,14 @@ static struct request *blk_mq_alloc_request_pinned(struct request_queue *q,
 			break;
 		}
 
-		blk_mq_put_ctx(ctx);
-		if (!(gfp & __GFP_WAIT))
+		if (gfp & __GFP_WAIT) {
+			__blk_mq_run_hw_queue(hctx);
+			blk_mq_put_ctx(ctx);
+		} else {
+			blk_mq_put_ctx(ctx);
 			break;
+		}
 
-		__blk_mq_run_hw_queue(hctx);
 		blk_mq_wait_for_tags(hctx->tags);
 	} while (1);
 
@@ -606,10 +609,22 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
 		return;
 
-	if (!async)
+	if (!async && cpumask_test_cpu(smp_processor_id(), hctx->cpumask))
 		__blk_mq_run_hw_queue(hctx);
-	else
+	else if (hctx->queue->nr_hw_queues == 1)
 		kblockd_schedule_delayed_work(&hctx->delayed_work, 0);
+	else {
+		unsigned int cpu;
+
+		/*
+		 * It'd be great if the workqueue API had a way to pass
+		 * in a mask and had some smarts for more clever placement
+		 * than the first CPU. Or we could round-robin here. For now,
+		 * just queue on the first CPU.
+		 */
+		cpu = cpumask_first(hctx->cpumask);
+		kblockd_schedule_delayed_work_on(cpu, &hctx->delayed_work, 0);
+	}
 }
 
 void blk_mq_run_queues(struct request_queue *q, bool async)
@@ -623,7 +638,9 @@ void blk_mq_run_queues(struct request_queue *q, bool async)
 		    test_bit(BLK_MQ_S_STOPPED, &hctx->state))
 			continue;
 
+		preempt_disable();
 		blk_mq_run_hw_queue(hctx, async);
+		preempt_enable();
 	}
 }
 EXPORT_SYMBOL(blk_mq_run_queues);
@@ -648,7 +665,10 @@ EXPORT_SYMBOL(blk_mq_stop_hw_queues);
 void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx)
 {
 	clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
+
+	preempt_disable();
 	__blk_mq_run_hw_queue(hctx);
+	preempt_enable();
 }
 EXPORT_SYMBOL(blk_mq_start_hw_queue);
 
@@ -662,7 +682,9 @@ void blk_mq_start_stopped_hw_queues(struct request_queue *q)
 			continue;
 
 		clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
+		preempt_disable();
 		blk_mq_run_hw_queue(hctx, true);
+		preempt_enable();
 	}
 }
 EXPORT_SYMBOL(blk_mq_start_stopped_hw_queues);
@@ -672,7 +694,10 @@ static void blk_mq_work_fn(struct work_struct *work)
 	struct blk_mq_hw_ctx *hctx;
 
 	hctx = container_of(work, struct blk_mq_hw_ctx, delayed_work.work);
+
+	preempt_disable();
 	__blk_mq_run_hw_queue(hctx);
+	preempt_enable();
 }
 
 static void __blk_mq_insert_request(struct blk_mq_hw_ctx *hctx,
@@ -716,10 +741,10 @@ void blk_mq_insert_request(struct request *rq, bool at_head, bool run_queue,
 		spin_unlock(&ctx->lock);
 	}
 
-	blk_mq_put_ctx(current_ctx);
-
 	if (run_queue)
 		blk_mq_run_hw_queue(hctx, async);
+
+	blk_mq_put_ctx(current_ctx);
 }
 
 static void blk_mq_insert_requests(struct request_queue *q,
@@ -755,9 +780,8 @@ static void blk_mq_insert_requests(struct request_queue *q,
 	}
 	spin_unlock(&ctx->lock);
 
-	blk_mq_put_ctx(current_ctx);
-
 	blk_mq_run_hw_queue(hctx, from_schedule);
+	blk_mq_put_ctx(current_ctx);
 }
 
 static int plug_ctx_cmp(void *priv, struct list_head *a, struct list_head *b)
@@ -876,7 +900,6 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 
 	if (unlikely(is_flush_fua)) {
 		blk_mq_bio_to_request(rq, bio);
-		blk_mq_put_ctx(ctx);
 		blk_insert_flush(rq);
 		goto run_queue;
 	}
@@ -914,7 +937,6 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	}
 
 	spin_unlock(&ctx->lock);
-	blk_mq_put_ctx(ctx);
 
 	/*
 	 * For a SYNC request, send it to the hardware immediately. For an
@@ -923,6 +945,7 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	 */
 run_queue:
 	blk_mq_run_hw_queue(hctx, !is_sync || is_flush_fua);
+	blk_mq_put_ctx(ctx);
 }
 
 /*
@@ -990,9 +1013,9 @@ static void blk_mq_hctx_notify(void *data, unsigned long action,
 	blk_mq_hctx_mark_pending(hctx, ctx);
 
 	spin_unlock(&ctx->lock);
-	blk_mq_put_ctx(ctx);
 
 	blk_mq_run_hw_queue(hctx, true);
+	blk_mq_put_ctx(ctx);
 }
 
 static int blk_mq_init_hw_commands(struct blk_mq_hw_ctx *hctx,
@@ -1256,6 +1279,7 @@ static void blk_mq_init_cpu_queues(struct request_queue *q,
 
 		/* If the cpu isn't online, the cpu is mapped to first hctx */
 		hctx = q->mq_ops->map_queue(q, i);
+		cpumask_set_cpu(i, hctx->cpumask);
 		hctx->nr_ctx++;
 
 		if (!cpu_online(i))
@@ -1277,6 +1301,7 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 	struct blk_mq_ctx *ctx;
 
 	queue_for_each_hw_ctx(q, hctx, i) {
+		cpumask_clear(hctx->cpumask);
 		hctx->nr_ctx = 0;
 	}
 
@@ -1286,6 +1311,7 @@ static void blk_mq_map_swqueue(struct request_queue *q)
 	queue_for_each_ctx(q, ctx, i) {
 		/* If the cpu isn't online, the cpu is mapped to first hctx */
 		hctx = q->mq_ops->map_queue(q, i);
+		cpumask_set_cpu(i, hctx->cpumask);
 		ctx->index_hw = hctx->nr_ctx;
 		hctx->ctxs[hctx->nr_ctx++] = ctx;
 	}
@@ -1329,6 +1355,9 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 		if (!hctxs[i])
 			goto err_hctxs;
 
+		if (!alloc_cpumask_var(&hctxs[i]->cpumask, GFP_KERNEL))
+			goto err_hctxs;
+
 		hctxs[i]->numa_node = NUMA_NO_NODE;
 		hctxs[i]->queue_num = i;
 	}
@@ -1392,6 +1421,7 @@ err_hctxs:
 	for (i = 0; i < reg->nr_hw_queues; i++) {
 		if (!hctxs[i])
 			break;
+		free_cpumask_var(hctxs[i]->cpumask);
 		reg->ops->free_hctx(hctxs[i], i);
 	}
 	kfree(hctxs);
@@ -1413,6 +1443,7 @@ void blk_mq_free_queue(struct request_queue *q)
 		blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
 		if (q->mq_ops->exit_hctx)
 			q->mq_ops->exit_hctx(hctx, i);
+		free_cpumask_var(hctx->cpumask);
 		q->mq_ops->free_hctx(hctx, i);
 	}
 
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 0120451545d8..b6ee48740458 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -19,6 +19,7 @@ struct blk_mq_hw_ctx {
 
 	unsigned long		state;		/* BLK_MQ_S_* flags */
 	struct delayed_work	delayed_work;
+	cpumask_var_t		cpumask;
 
 	unsigned long		flags;		/* BLK_MQ_F_* flags */
 
-- 
1.8.3.2


--------------030801020500030606070709
Content-Type: text/x-patch;
 name="0002-block-add-kblockd_schedule_delayed_work_on.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-block-add-kblockd_schedule_delayed_work_on.patch"

>From 0c1fd2dc9fcaac28ab54e9002898db59b224d66c Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@fb.com>
Date: Tue, 8 Apr 2014 09:17:40 -0600
Subject: [PATCH 2/3] block: add kblockd_schedule_delayed_work_on()

Same function as kblockd_schedule_delayed_work(), but allow the
caller to pass in a CPU that the work should be executed on. This
just directly extends and maps into the workqueue API, and will
be used to make the blk-mq mappings more strict.

Signed-off-by: Jens Axboe <axboe@fb.com>
---
 block/blk-core.c       | 7 +++++++
 include/linux/blkdev.h | 1 +
 2 files changed, 8 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index f7d2c3335dfa..7af4a4898dcb 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2917,6 +2917,13 @@ int kblockd_schedule_delayed_work(struct delayed_work *dwork,
 }
 EXPORT_SYMBOL(kblockd_schedule_delayed_work);
 
+int kblockd_schedule_delayed_work_on(int cpu, struct delayed_work *dwork,
+				     unsigned long delay)
+{
+	return queue_delayed_work_on(cpu, kblockd_workqueue, dwork, delay);
+}
+EXPORT_SYMBOL(kblockd_schedule_delayed_work_on);
+
 #define PLUG_MAGIC	0x91827364
 
 /**
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2425945d36ab..5a31307c5ded 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1361,6 +1361,7 @@ static inline void put_dev_sector(Sector p)
 struct work_struct;
 int kblockd_schedule_work(struct work_struct *work);
 int kblockd_schedule_delayed_work(struct delayed_work *dwork, unsigned long delay);
+int kblockd_schedule_delayed_work_on(int cpu, struct delayed_work *dwork, unsigned long delay);
 
 #ifdef CONFIG_BLK_CGROUP
 /*
-- 
1.8.3.2


--------------030801020500030606070709
Content-Type: text/x-patch;
 name="0001-block-remove-q-parameter-from-kblockd_schedule_-_wor.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-block-remove-q-parameter-from-kblockd_schedule_-_wor.pa";
 filename*1="tch"

>From b29f5ba5d5d8f48d9264d591171e642fa24ad640 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@fb.com>
Date: Tue, 8 Apr 2014 09:15:35 -0600
Subject: [PATCH 1/3] block: remove 'q' parameter from
 kblockd_schedule_*_work()

The queue parameter is never used, just get rid of it.

Signed-off-by: Jens Axboe <axboe@fb.com>
---
 block/blk-core.c        | 6 +++---
 block/blk-flush.c       | 2 +-
 block/blk-mq.c          | 7 ++-----
 block/cfq-iosched.c     | 2 +-
 drivers/scsi/scsi_lib.c | 2 +-
 include/linux/blkdev.h  | 4 ++--
 6 files changed, 10 insertions(+), 13 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 34d7c196338b..f7d2c3335dfa 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2904,14 +2904,14 @@ free_and_out:
 }
 EXPORT_SYMBOL_GPL(blk_rq_prep_clone);
 
-int kblockd_schedule_work(struct request_queue *q, struct work_struct *work)
+int kblockd_schedule_work(struct work_struct *work)
 {
 	return queue_work(kblockd_workqueue, work);
 }
 EXPORT_SYMBOL(kblockd_schedule_work);
 
-int kblockd_schedule_delayed_work(struct request_queue *q,
-			struct delayed_work *dwork, unsigned long delay)
+int kblockd_schedule_delayed_work(struct delayed_work *dwork,
+				  unsigned long delay)
 {
 	return queue_delayed_work(kblockd_workqueue, dwork, delay);
 }
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 43e6b4755e9a..77f20458910c 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -144,7 +144,7 @@ static bool blk_flush_queue_rq(struct request *rq, bool add_front)
 {
 	if (rq->q->mq_ops) {
 		INIT_WORK(&rq->mq_flush_work, mq_flush_run);
-		kblockd_schedule_work(rq->q, &rq->mq_flush_work);
+		kblockd_schedule_work(&rq->mq_flush_work);
 		return false;
 	} else {
 		if (add_front)
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1d2a9bdbee57..9c8f1f4ada7f 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -608,11 +608,8 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 
 	if (!async)
 		__blk_mq_run_hw_queue(hctx);
-	else {
-		struct request_queue *q = hctx->queue;
-
-		kblockd_schedule_delayed_work(q, &hctx->delayed_work, 0);
-	}
+	else
+		kblockd_schedule_delayed_work(&hctx->delayed_work, 0);
 }
 
 void blk_mq_run_queues(struct request_queue *q, bool async)
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e0985f1955e7..5063a0bd831a 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -908,7 +908,7 @@ static inline void cfq_schedule_dispatch(struct cfq_data *cfqd)
 {
 	if (cfqd->busy_queues) {
 		cfq_log(cfqd, "schedule dispatch");
-		kblockd_schedule_work(cfqd->queue, &cfqd->unplug_work);
+		kblockd_schedule_work(&cfqd->unplug_work);
 	}
 }
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5681c05ac506..91f99f4ce2e8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -139,7 +139,7 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, int unbusy)
 	 */
 	spin_lock_irqsave(q->queue_lock, flags);
 	blk_requeue_request(q, cmd->request);
-	kblockd_schedule_work(q, &device->requeue_work);
+	kblockd_schedule_work(&device->requeue_work);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1e1fa3f93d5f..2425945d36ab 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1359,8 +1359,8 @@ static inline void put_dev_sector(Sector p)
 }
 
 struct work_struct;
-int kblockd_schedule_work(struct request_queue *q, struct work_struct *work);
-int kblockd_schedule_delayed_work(struct request_queue *q, struct delayed_work *dwork, unsigned long delay);
+int kblockd_schedule_work(struct work_struct *work);
+int kblockd_schedule_delayed_work(struct delayed_work *dwork, unsigned long delay);
 
 #ifdef CONFIG_BLK_CGROUP
 /*
-- 
1.8.3.2


--------------030801020500030606070709--
