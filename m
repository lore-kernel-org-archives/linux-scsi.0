From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 06/14] blk-mq-sched: introduce blk_mq_sched_queue_depth()
Date: Tue,  1 Aug 2017 00:51:03 +0800
Message-ID: <20170731165111.11536-8-ming.lei@redhat.com>
References: <20170731165111.11536-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59580 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750953AbdGaQwa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Jul 2017 12:52:30 -0400
In-Reply-To: <20170731165111.11536-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Ming Lei <ming.lei@redhat.com>

The following patch will propose some hints to figure out
default queue depth for scheduler queue, so introduce helper
of blk_mq_sched_queue_depth() for this purpose.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-sched.c |  8 +-------
 block/blk-mq-sched.h | 11 +++++++++++
 2 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index eb638063673f..3eb524ccb7aa 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -531,13 +531,7 @@ int blk_mq_init_sched(struct request_queue *q, struct elevator_type *e)
 		return 0;
 	}
 
-	/*
-	 * Default to double of smaller one between hw queue_depth and 128,
-	 * since we don't split into sync/async like the old code did.
-	 * Additionally, this is a per-hw queue depth.
-	 */
-	q->nr_requests = 2 * min_t(unsigned int, q->tag_set->queue_depth,
-				   BLKDEV_MAX_RQ);
+	q->nr_requests = blk_mq_sched_queue_depth(q);
 
 	queue_for_each_hw_ctx(q, hctx, i) {
 		ret = blk_mq_sched_alloc_tags(q, hctx, i);
diff --git a/block/blk-mq-sched.h b/block/blk-mq-sched.h
index 9267d0b7c197..1d47f3fda1d0 100644
--- a/block/blk-mq-sched.h
+++ b/block/blk-mq-sched.h
@@ -96,4 +96,15 @@ static inline bool blk_mq_sched_needs_restart(struct blk_mq_hw_ctx *hctx)
 	return test_bit(BLK_MQ_S_SCHED_RESTART, &hctx->state);
 }
 
+static inline unsigned blk_mq_sched_queue_depth(struct request_queue *q)
+{
+	/*
+	 * Default to double of smaller one between hw queue_depth and 128,
+	 * since we don't split into sync/async like the old code did.
+	 * Additionally, this is a per-hw queue depth.
+	 */
+	return 2 * min_t(unsigned int, q->tag_set->queue_depth,
+				   BLKDEV_MAX_RQ);
+}
+
 #endif
-- 
2.9.4
