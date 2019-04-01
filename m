From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 1/3] blk-mq: free hw queue's resource in hctx's release handler
Date: Mon,  1 Apr 2019 12:42:45 +0800
Message-ID: <20190401044247.29881-2-ming.lei@redhat.com>
References: <20190401044247.29881-1-ming.lei@redhat.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190401044247.29881-1-ming.lei@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Dongli Zhang <dongli.zhang@oracle.com>, James Smart <james.smart@broadcom.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, jianchao wang <jianchao.w.wang@oracle.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Once blk_cleanup_queue() returns, tags shouldn't be used any more,
because blk_mq_free_tag_set() may be called. Commit 45a9c9d909b2
("blk-mq: Fix a use-after-free") fixes this issue exactly.

However, that commit introduces another issue. Before 45a9c9d909b2,
we are allowed to run queue during cleaning up queue if the queue's
kobj refcount is held. After that commit, queue can't be run during
queue cleaning up, otherwise oops can be triggered easily because
some fields of hctx are freed by blk_mq_free_queue() in blk_cleanup_queue().

We have invented ways for addressing this kind of issue before, such as:

	8dc765d438f1 ("SCSI: fix queue cleanup race before queue initialization is done")
	c2856ae2f315 ("blk-mq: quiesce queue before freeing queue")

But still can't cover all cases, recently James reports another such
kind of issue:

	https://marc.info/?l=linux-scsi&m=155389088124782&w=2

This issue can be quite hard to address by previous way, given
scsi_run_queue() may run requeues for other LUNs.

Fixes the above issue by freeing hctx's resources in its release handler, and this
way is safe becasue tags isn't needed for freeing such hctx resource.

This approach follows typical design pattern wrt. kobject's release handler.

Cc: Dongli Zhang <dongli.zhang@oracle.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: Bart Van Assche <bart.vanassche@wdc.com>
Cc: linux-scsi@vger.kernel.org,
Cc: Martin K . Petersen <martin.petersen@oracle.com>,
Cc: Christoph Hellwig <hch@lst.de>,
Cc: James E . J . Bottomley <jejb@linux.vnet.ibm.com>,
Cc: jianchao wang <jianchao.w.wang@oracle.com>
Reported-by: James Smart <james.smart@broadcom.com>
Fixes: 45a9c9d909b2 ("blk-mq: Fix a use-after-free")
Cc: stable@vger.kernel.org
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c     | 2 +-
 block/blk-mq-sysfs.c | 6 ++++++
 block/blk-mq.c       | 8 ++------
 block/blk-mq.h       | 2 +-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 4673ebe42255..b3bbf8a5110d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -375,7 +375,7 @@ void blk_cleanup_queue(struct request_queue *q)
 	blk_exit_queue(q);
 
 	if (queue_is_mq(q))
-		blk_mq_free_queue(q);
+		blk_mq_exit_queue(q);
 
 	percpu_ref_exit(&q->q_usage_counter);
 
diff --git a/block/blk-mq-sysfs.c b/block/blk-mq-sysfs.c
index 3f9c3f4ac44c..4040e62c3737 100644
--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -10,6 +10,7 @@
 #include <linux/smp.h>
 
 #include <linux/blk-mq.h>
+#include "blk.h"
 #include "blk-mq.h"
 #include "blk-mq-tag.h"
 
@@ -33,6 +34,11 @@ static void blk_mq_hw_sysfs_release(struct kobject *kobj)
 {
 	struct blk_mq_hw_ctx *hctx = container_of(kobj, struct blk_mq_hw_ctx,
 						  kobj);
+
+	if (hctx->flags & BLK_MQ_F_BLOCKING)
+		cleanup_srcu_struct(hctx->srcu);
+	blk_free_flush_queue(hctx->fq);
+	sbitmap_free(&hctx->ctx_map);
 	free_cpumask_var(hctx->cpumask);
 	kfree(hctx->ctxs);
 	kfree(hctx);
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 70b210a308c4..05d11149e75a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2243,12 +2243,7 @@ static void blk_mq_exit_hctx(struct request_queue *q,
 	if (set->ops->exit_hctx)
 		set->ops->exit_hctx(hctx, hctx_idx);
 
-	if (hctx->flags & BLK_MQ_F_BLOCKING)
-		cleanup_srcu_struct(hctx->srcu);
-
 	blk_mq_remove_cpuhp(hctx);
-	blk_free_flush_queue(hctx->fq);
-	sbitmap_free(&hctx->ctx_map);
 }
 
 static void blk_mq_exit_hw_queues(struct request_queue *q,
@@ -2881,7 +2876,8 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 }
 EXPORT_SYMBOL(blk_mq_init_allocated_queue);
 
-void blk_mq_free_queue(struct request_queue *q)
+/* tags can _not_ be used after returning from blk_mq_exit_queue */
+void blk_mq_exit_queue(struct request_queue *q)
 {
 	struct blk_mq_tag_set	*set = q->tag_set;
 
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 0ed8e5a8729f..0a5d0893dae4 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -37,7 +37,7 @@ struct blk_mq_ctx {
 	struct kobject		kobj;
 } ____cacheline_aligned_in_smp;
 
-void blk_mq_free_queue(struct request_queue *q);
+void blk_mq_exit_queue(struct request_queue *q);
 int blk_mq_update_nr_requests(struct request_queue *q, unsigned int nr);
 void blk_mq_wake_waiters(struct request_queue *q);
 bool blk_mq_dispatch_rq_list(struct request_queue *, struct list_head *, bool);
-- 
2.9.5
