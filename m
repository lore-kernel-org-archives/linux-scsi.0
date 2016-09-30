From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 4/7] blk-mq: Introduce blk_quiesce_queue() and
 blk_resume_queue()
Date: Fri, 30 Sep 2016 08:55:59 -0700
Message-ID: <9fb67745-954c-a70f-a89a-d184c99ae9aa@sandisk.com>
References: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
 <a9eb4e95-6d77-e527-c42a-fd2e6f104bed@sandisk.com>
 <CACVXFVOO4P3RsnWci8XHdFoYBhNPq0KqjWJddsie-92+31bpEg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="------------655A73FFD4840F0A4750FEA7"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0078.outbound.protection.outlook.com ([104.47.37.78]:6976
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933082AbcI3P4O (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Sep 2016 11:56:14 -0400
In-Reply-To: <CACVXFVOO4P3RsnWci8XHdFoYBhNPq0KqjWJddsie-92+31bpEg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

--------------655A73FFD4840F0A4750FEA7
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

On 09/29/16 14:51, Ming Lei wrote:
> On Thu, Sep 29, 2016 at 7:59 AM, Bart Van Assche
> <bart.vanassche@sandisk.com> wrote:
>> blk_quiesce_queue() prevents that new queue_rq() invocations
>
> blk_mq_quiesce_queue()

Thanks, I will update the patch title and patch description.

>> +void blk_mq_quiesce_queue(struct request_queue *q)
>> +{
>> +       struct blk_mq_hw_ctx *hctx;
>> +       unsigned int i;
>> +       bool res, rcu = false;
>> +
>> +       spin_lock_irq(q->queue_lock);
>> +       WARN_ON_ONCE(blk_queue_quiescing(q));
>> +       queue_flag_set(QUEUE_FLAG_QUIESCING, q);
>> +       spin_unlock_irq(q->queue_lock);
>> +
>> +       res = __blk_mq_freeze_queue_start(q, false);
>
> Looks the implementation is a bit tricky and complicated, if the percpu
> usage counter isn't killed, it isn't necessary to touch .mq_freeze_depth
> since you use QUEUE_FLAG_QUIESCING to set/get this status of
> the queue.
 >
 > Then using synchronize_rcu() and rcu_read_lock()/rcu_read_unlock()
 > with the flag of QUIESCING may be enough to wait for completing
 > of ongoing invocations of .queue_rq() and avoid to run new .queue_rq,
 > right?

That's an interesting thought. Can you have a look at the attached patch 
in which blk_mq_quiesce_queue() no longer manipulates the 
mq_freeze_depth counter?

>> +       WARN_ON_ONCE(!res);
>> +       queue_for_each_hw_ctx(q, hctx, i) {
>> +               if (hctx->flags & BLK_MQ_F_BLOCKING) {
>> +                       mutex_lock(&hctx->queue_rq_mutex);
>> +                       mutex_unlock(&hctx->queue_rq_mutex);
>
> Could you explain a bit why all BLOCKING is treated so special? And
> that flag just means the hw queue always need to schedule asynchronously,
> and of course even though the flag isn't set, it still may be run
> asynchronously too. So looks it should be enough to just use RCU.

The mutex manipulations introduce atomic stores in the hot path. Hence 
the use of synchronize_rcu() and rcu_read_lock()/rcu_read_unlock() when 
possible. Since BLK_MQ_F_BLOCKING indicates that .queue_rq() may sleep 
and since sleeping is not allowed while holding the RCU read lock, 
queue_rq_mutex has been introduced for the BLK_MQ_F_BLOCKING case.

Bart.

--------------655A73FFD4840F0A4750FEA7
Content-Type: text/x-patch;
	name="0001-blk-mq-Introduce-blk_mq_quiesce_queue.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-blk-mq-Introduce-blk_mq_quiesce_queue.patch"

>From 3a549df53eba84fad94279484e54f9c43b2d6626 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bart.vanassche@sandisk.com>
Date: Tue, 27 Sep 2016 10:52:36 -0700
Subject: [PATCH] blk-mq: Introduce blk_mq_quiesce_queue()

blk_mq_quiesce_queue() waits until ongoing .queue_rq() invocations
have finished. This function does *not* wait until all outstanding
requests have finished (this means invocation of request.end_io()).

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/blk-mq.c         | 69 +++++++++++++++++++++++++++++++++++++++++++++-----
 include/linux/blk-mq.h |  2 ++
 include/linux/blkdev.h |  4 +++
 3 files changed, 69 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d8c45de..57701c5 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -115,6 +115,32 @@ void blk_mq_unfreeze_queue(struct request_queue *q)
 }
 EXPORT_SYMBOL_GPL(blk_mq_unfreeze_queue);
 
+/**
+ * blk_mq_quiesce_queue() - wait until all ongoing queue_rq calls have finished
+ *
+ * Note: this function does not prevent that the struct request end_io()
+ * callback function is invoked. Additionally, it is not prevented that
+ * new queue_rq() calls occur unless the queue has been stopped first.
+ */
+void blk_mq_quiesce_queue(struct request_queue *q)
+{
+	struct blk_mq_hw_ctx *hctx;
+	unsigned int i;
+	bool res, rcu = false;
+
+	queue_for_each_hw_ctx(q, hctx, i) {
+		if (hctx->flags & BLK_MQ_F_BLOCKING) {
+			mutex_lock(&hctx->queue_rq_mutex);
+			mutex_unlock(&hctx->queue_rq_mutex);
+		} else {
+			rcu = true;
+		}
+	}
+	if (rcu)
+		synchronize_rcu();
+}
+EXPORT_SYMBOL_GPL(blk_mq_quiesce_queue);
+
 void blk_mq_wake_waiters(struct request_queue *q)
 {
 	struct blk_mq_hw_ctx *hctx;
@@ -782,7 +808,7 @@ static inline unsigned int queued_to_index(unsigned int queued)
  * of IO. In particular, we'd like FIFO behaviour on handling existing
  * items on the hctx->dispatch list. Ignore that for now.
  */
-static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
+static void blk_mq_process_rq_list(struct blk_mq_hw_ctx *hctx)
 {
 	struct request_queue *q = hctx->queue;
 	struct request *rq;
@@ -791,7 +817,7 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 	struct list_head *dptr;
 	int queued;
 
-	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
+	if (unlikely(blk_queue_quiescing(q)))
 		return;
 
 	WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask) &&
@@ -887,6 +913,22 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 	}
 }
 
+static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
+{
+	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
+		return;
+
+	if (hctx->flags & BLK_MQ_F_BLOCKING) {
+		mutex_lock(&hctx->queue_rq_mutex);
+		blk_mq_process_rq_list(hctx);
+		mutex_unlock(&hctx->queue_rq_mutex);
+	} else {
+		rcu_read_lock();
+		blk_mq_process_rq_list(hctx);
+		rcu_read_unlock();
+	}
+}
+
 /*
  * It'd be great if the workqueue API had a way to pass
  * in a mask and had some smarts for more clever placement.
@@ -1341,7 +1383,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_bio_to_request(rq, bio);
 
 		/*
-		 * We do limited pluging. If the bio can be merged, do that.
+		 * We do limited plugging. If the bio can be merged, do that.
 		 * Otherwise the existing request in the plug list will be
 		 * issued. So the plug list will have one request at most
 		 */
@@ -1361,9 +1403,23 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_put_ctx(data.ctx);
 		if (!old_rq)
 			goto done;
-		if (!blk_mq_direct_issue_request(old_rq, &cookie))
-			goto done;
-		blk_mq_insert_request(old_rq, false, true, true);
+
+		if (data.hctx->flags & BLK_MQ_F_BLOCKING) {
+			mutex_lock(&data.hctx->queue_rq_mutex);
+			if (blk_queue_quiescing(q) ||
+			    blk_mq_direct_issue_request(old_rq, &cookie) != 0)
+				blk_mq_insert_request(old_rq, false, true,
+						      true);
+			mutex_unlock(&data.hctx->queue_rq_mutex);
+		} else {
+			rcu_read_lock();
+			if (blk_queue_quiescing(q) ||
+			    blk_mq_direct_issue_request(old_rq, &cookie) != 0)
+				blk_mq_insert_request(old_rq, false, true,
+						      true);
+			rcu_read_unlock();
+		}
+
 		goto done;
 	}
 
@@ -1702,6 +1758,7 @@ static int blk_mq_init_hctx(struct request_queue *q,
 	INIT_DELAYED_WORK(&hctx->delay_work, blk_mq_delay_work_fn);
 	spin_lock_init(&hctx->lock);
 	INIT_LIST_HEAD(&hctx->dispatch);
+	mutex_init(&hctx->queue_rq_mutex);
 	hctx->queue = q;
 	hctx->queue_num = hctx_idx;
 	hctx->flags = set->flags & ~BLK_MQ_F_TAG_SHARED;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 368c460d..4b970f1 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -41,6 +41,8 @@ struct blk_mq_hw_ctx {
 
 	struct blk_mq_tags	*tags;
 
+	struct mutex		queue_rq_mutex;
+
 	unsigned long		queued;
 	unsigned long		run;
 #define BLK_MQ_MAX_DISPATCH_ORDER	7
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c47c358..6c2d987 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -505,6 +505,7 @@ struct request_queue {
 #define QUEUE_FLAG_FUA	       24	/* device supports FUA writes */
 #define QUEUE_FLAG_FLUSH_NQ    25	/* flush not queueuable */
 #define QUEUE_FLAG_DAX         26	/* device supports DAX */
+#define QUEUE_FLAG_QUIESCING   27
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -595,6 +596,8 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_secure_erase(q) \
 	(test_bit(QUEUE_FLAG_SECERASE, &(q)->queue_flags))
 #define blk_queue_dax(q)	test_bit(QUEUE_FLAG_DAX, &(q)->queue_flags)
+#define blk_queue_quiescing(q)	test_bit(QUEUE_FLAG_QUIESCING,	\
+					 &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
@@ -824,6 +827,7 @@ extern void __blk_run_queue(struct request_queue *q);
 extern void __blk_run_queue_uncond(struct request_queue *q);
 extern void blk_run_queue(struct request_queue *);
 extern void blk_run_queue_async(struct request_queue *q);
+extern void blk_mq_quiesce_queue(struct request_queue *q);
 extern int blk_rq_map_user(struct request_queue *, struct request *,
 			   struct rq_map_data *, void __user *, unsigned long,
 			   gfp_t);
-- 
2.10.0


--------------655A73FFD4840F0A4750FEA7--
