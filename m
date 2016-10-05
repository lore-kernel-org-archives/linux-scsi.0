From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 4/7] blk-mq: Introduce blk_quiesce_queue() and
 blk_resume_queue()
Date: Tue, 4 Oct 2016 21:16:30 -0700
Message-ID: <a11bb09a-6207-f4a8-cfd4-4fe5627c1700@sandisk.com>
References: <f153ee47-e599-c333-92b0-d5da475012f3@sandisk.com>
 <a9eb4e95-6d77-e527-c42a-fd2e6f104bed@sandisk.com>
 <CACVXFVOO4P3RsnWci8XHdFoYBhNPq0KqjWJddsie-92+31bpEg@mail.gmail.com>
 <9fb67745-954c-a70f-a89a-d184c99ae9aa@sandisk.com>
 <CACVXFVMY19vuDjsECg2uX0_y_K7DUaaGqXPX9PYiBy5sfXmAEw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="------------A05DDFF095E327D971422CF5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0048.outbound.protection.outlook.com ([104.47.37.48]:23920
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750992AbcJEEQn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 5 Oct 2016 00:16:43 -0400
In-Reply-To: <CACVXFVMY19vuDjsECg2uX0_y_K7DUaaGqXPX9PYiBy5sfXmAEw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Doug Ledford <dledford@redhat.com>, Keith Busch <keith.busch@intel.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>

--------------A05DDFF095E327D971422CF5
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

On 10/01/16 15:56, Ming Lei wrote:
> If we just call the rcu/srcu read lock(or the mutex) around .queue_rq(), the
> above code needn't to be duplicated any more.

Hello Ming,

Can you have a look at the attached patch? That patch uses an srcu read 
lock for all queue types, whether or not the BLK_MQ_F_BLOCKING flag has 
been set. Additionally, I have dropped the QUEUE_FLAG_QUIESCING flag. 
Just like previous versions, this patch has been tested.

Thanks,

Bart.

--------------A05DDFF095E327D971422CF5
Content-Type: text/x-patch;
	name="0001-blk-mq-Introduce-blk_mq_quiesce_queue.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-blk-mq-Introduce-blk_mq_quiesce_queue.patch"

>From 25f02ed7ab7b2308fd18b89d180c0c613e55d416 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bart.vanassche@sandisk.com>
Date: Tue, 27 Sep 2016 10:52:36 -0700
Subject: [PATCH] blk-mq: Introduce blk_mq_quiesce_queue()

blk_mq_quiesce_queue() waits until ongoing .queue_rq() invocations
have finished. This function does *not* wait until all outstanding
requests have finished (this means invocation of request.end_io()).

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/blk-mq.c         | 40 ++++++++++++++++++++++++++++++++++------
 include/linux/blk-mq.h |  3 +++
 include/linux/blkdev.h |  1 +
 3 files changed, 38 insertions(+), 6 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d8c45de..38ae685 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -115,6 +115,23 @@ void blk_mq_unfreeze_queue(struct request_queue *q)
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
+
+	queue_for_each_hw_ctx(q, hctx, i)
+		synchronize_srcu(&hctx->queue_rq_srcu);
+}
+EXPORT_SYMBOL_GPL(blk_mq_quiesce_queue);
+
 void blk_mq_wake_waiters(struct request_queue *q)
 {
 	struct blk_mq_hw_ctx *hctx;
@@ -789,11 +806,13 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 	LIST_HEAD(rq_list);
 	LIST_HEAD(driver_list);
 	struct list_head *dptr;
-	int queued;
+	int queued, srcu_idx;
 
 	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
 		return;
 
+	srcu_idx = srcu_read_lock(&hctx->queue_rq_srcu);
+
 	WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask) &&
 		cpu_online(hctx->next_cpu));
 
@@ -885,6 +904,8 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 		 **/
 		blk_mq_run_hw_queue(hctx, true);
 	}
+
+	srcu_read_unlock(&hctx->queue_rq_srcu, srcu_idx);
 }
 
 /*
@@ -1298,7 +1319,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	const int is_flush_fua = bio->bi_opf & (REQ_PREFLUSH | REQ_FUA);
 	struct blk_map_ctx data;
 	struct request *rq;
-	unsigned int request_count = 0;
+	unsigned int request_count = 0, srcu_idx;
 	struct blk_plug *plug;
 	struct request *same_queue_rq = NULL;
 	blk_qc_t cookie;
@@ -1341,7 +1362,7 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_bio_to_request(rq, bio);
 
 		/*
-		 * We do limited pluging. If the bio can be merged, do that.
+		 * We do limited plugging. If the bio can be merged, do that.
 		 * Otherwise the existing request in the plug list will be
 		 * issued. So the plug list will have one request at most
 		 */
@@ -1361,9 +1382,12 @@ static blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		blk_mq_put_ctx(data.ctx);
 		if (!old_rq)
 			goto done;
-		if (!blk_mq_direct_issue_request(old_rq, &cookie))
-			goto done;
-		blk_mq_insert_request(old_rq, false, true, true);
+
+		srcu_idx = srcu_read_lock(&data.hctx->queue_rq_srcu);
+		if (blk_mq_direct_issue_request(old_rq, &cookie) != 0)
+			blk_mq_insert_request(old_rq, false, true, true);
+		srcu_read_unlock(&data.hctx->queue_rq_srcu, srcu_idx);
+
 		goto done;
 	}
 
@@ -1659,6 +1683,8 @@ static void blk_mq_exit_hctx(struct request_queue *q,
 	if (set->ops->exit_hctx)
 		set->ops->exit_hctx(hctx, hctx_idx);
 
+	cleanup_srcu_struct(&hctx->queue_rq_srcu);
+
 	blk_mq_unregister_cpu_notifier(&hctx->cpu_notifier);
 	blk_free_flush_queue(hctx->fq);
 	sbitmap_free(&hctx->ctx_map);
@@ -1741,6 +1767,8 @@ static int blk_mq_init_hctx(struct request_queue *q,
 				   flush_start_tag + hctx_idx, node))
 		goto free_fq;
 
+	init_srcu_struct(&hctx->queue_rq_srcu);
+
 	return 0;
 
  free_fq:
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 368c460d..b2ccd3c 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -3,6 +3,7 @@
 
 #include <linux/blkdev.h>
 #include <linux/sbitmap.h>
+#include <linux/srcu.h>
 
 struct blk_mq_tags;
 struct blk_flush_queue;
@@ -41,6 +42,8 @@ struct blk_mq_hw_ctx {
 
 	struct blk_mq_tags	*tags;
 
+	struct srcu_struct	queue_rq_srcu;
+
 	unsigned long		queued;
 	unsigned long		run;
 #define BLK_MQ_MAX_DISPATCH_ORDER	7
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c47c358..8259d87 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -824,6 +824,7 @@ extern void __blk_run_queue(struct request_queue *q);
 extern void __blk_run_queue_uncond(struct request_queue *q);
 extern void blk_run_queue(struct request_queue *);
 extern void blk_run_queue_async(struct request_queue *q);
+extern void blk_mq_quiesce_queue(struct request_queue *q);
 extern int blk_rq_map_user(struct request_queue *, struct request *,
 			   struct rq_map_data *, void __user *, unsigned long,
 			   gfp_t);
-- 
2.9.3


--------------A05DDFF095E327D971422CF5--
