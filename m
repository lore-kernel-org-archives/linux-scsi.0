From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 10/14] blk-mq-sched: introduce helpers for query, change busy state
Date: Tue,  1 Aug 2017 00:51:07 +0800
Message-ID: <20170731165111.11536-12-ming.lei@redhat.com>
References: <20170731165111.11536-1-ming.lei@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60532 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750877AbdGaQxG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 31 Jul 2017 12:53:06 -0400
In-Reply-To: <20170731165111.11536-1-ming.lei@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Ming Lei <ming.lei@redhat.com>

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-mq-sched.c |  6 +++---
 block/blk-mq.h       | 15 +++++++++++++++
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/block/blk-mq-sched.c b/block/blk-mq-sched.c
index 07ff53187617..112270961af0 100644
--- a/block/blk-mq-sched.c
+++ b/block/blk-mq-sched.c
@@ -140,7 +140,7 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
 			 * BUSY won't be cleared until all requests
 			 * in hctx->dispatch are dispatched successfully
 			 */
-			set_bit(BLK_MQ_S_BUSY, &hctx->state);
+			blk_mq_hctx_set_busy(hctx);
 		}
 		spin_unlock(&hctx->lock);
 	}
@@ -158,11 +158,11 @@ void blk_mq_sched_dispatch_requests(struct blk_mq_hw_ctx *hctx)
 		blk_mq_sched_mark_restart_hctx(hctx);
 		can_go = blk_mq_dispatch_rq_list(q, &rq_list);
 		if (can_go)
-			clear_bit(BLK_MQ_S_BUSY, &hctx->state);
+			blk_mq_hctx_clear_busy(hctx);
 	}
 
 	/* can't go until ->dispatch is flushed */
-	if (!can_go || test_bit(BLK_MQ_S_BUSY, &hctx->state))
+	if (!can_go || blk_mq_hctx_is_busy(hctx))
 		return;
 
 	/*
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 44d3aaa03d7c..d9f875093613 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -135,4 +135,19 @@ static inline bool blk_mq_hw_queue_mapped(struct blk_mq_hw_ctx *hctx)
 	return hctx->nr_ctx && hctx->tags;
 }
 
+static inline bool blk_mq_hctx_is_busy(struct blk_mq_hw_ctx *hctx)
+{
+	return test_bit(BLK_MQ_S_BUSY, &hctx->state);
+}
+
+static inline void blk_mq_hctx_set_busy(struct blk_mq_hw_ctx *hctx)
+{
+	set_bit(BLK_MQ_S_BUSY, &hctx->state);
+}
+
+static inline void blk_mq_hctx_clear_busy(struct blk_mq_hw_ctx *hctx)
+{
+	clear_bit(BLK_MQ_S_BUSY, &hctx->state);
+}
+
 #endif
-- 
2.9.4
