From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/7] blk-mq: export blk_mq_run_hw_queues
Date: Wed, 11 Mar 2015 23:56:38 -0400
Message-ID: <1426132602-34331-4-git-send-email-snitzer@redhat.com>
References: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361AbbCLD4u (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Mar 2015 23:56:50 -0400
In-Reply-To: <1426132602-34331-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com

Rename blk_mq_run_queues to blk_mq_run_hw_queues, add async argument,
and export it.

DM's suspend support must be able to run the queue without starting
stopped hw queues.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-mq.c         | 8 ++++----
 include/linux/blk-mq.h | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index d576a78..5706dd9 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -33,7 +33,6 @@ static DEFINE_MUTEX(all_q_mutex);
 static LIST_HEAD(all_q_list);
 
 static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx);
-static void blk_mq_run_queues(struct request_queue *q);
 
 /*
  * Check if any of the ctx's have pending work in this hardware queue
@@ -118,7 +117,7 @@ void blk_mq_freeze_queue_start(struct request_queue *q)
 
 	if (freeze) {
 		percpu_ref_kill(&q->mq_usage_counter);
-		blk_mq_run_queues(q);
+		blk_mq_run_hw_queues(q, false);
 	}
 }
 EXPORT_SYMBOL_GPL(blk_mq_freeze_queue_start);
@@ -904,7 +903,7 @@ void blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx, bool async)
 			&hctx->run_work, 0);
 }
 
-static void blk_mq_run_queues(struct request_queue *q)
+void blk_mq_run_hw_queues(struct request_queue *q, bool async)
 {
 	struct blk_mq_hw_ctx *hctx;
 	int i;
@@ -915,9 +914,10 @@ static void blk_mq_run_queues(struct request_queue *q)
 		    test_bit(BLK_MQ_S_STOPPED, &hctx->state))
 			continue;
 
-		blk_mq_run_hw_queue(hctx, false);
+		blk_mq_run_hw_queue(hctx, async);
 	}
 }
+EXPORT_SYMBOL(blk_mq_run_hw_queues);
 
 void blk_mq_stop_hw_queue(struct blk_mq_hw_ctx *hctx)
 {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 9a75c88..ebfe707 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -220,6 +220,7 @@ void blk_mq_start_hw_queue(struct blk_mq_hw_ctx *hctx);
 void blk_mq_stop_hw_queues(struct request_queue *q);
 void blk_mq_start_hw_queues(struct request_queue *q);
 void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async);
+void blk_mq_run_hw_queues(struct request_queue *q, bool async);
 void blk_mq_delay_queue(struct blk_mq_hw_ctx *hctx, unsigned long msecs);
 void blk_mq_tag_busy_iter(struct blk_mq_hw_ctx *hctx, busy_iter_fn *fn,
 		void *priv);
-- 
1.9.5 (Apple Git-50.3)

