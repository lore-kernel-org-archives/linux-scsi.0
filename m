From: mchristi@redhat.com
Subject: [PATCH 1/5] blk mq: take ref to q when running it
Date: Wed, 25 May 2016 02:54:59 -0500
Message-ID: <1464162903-14735-2-git-send-email-mchristi@redhat.com>
References: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47973 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229AbcEYHzI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2016 03:55:08 -0400
In-Reply-To: <1464162903-14735-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

From: Mike Christie <mchristi@redhat.com>

If the __blk_mq_run_hw_queue is a result of a async run or retry
then we do not have a reference to the queue. At this time,
blk_cleanup_queue could begin tearing it down while the queue_rq
function is being run.

This patch just has us do a blk_queue_enter call.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 block/blk-mq.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7df9c92..5958a02 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -738,8 +738,13 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 
 	WARN_ON(!cpumask_test_cpu(raw_smp_processor_id(), hctx->cpumask));
 
-	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
+	if (blk_queue_enter(q, false)) {
+		blk_mq_run_hw_queue(hctx, true);
 		return;
+	}
+
+	if (unlikely(test_bit(BLK_MQ_S_STOPPED, &hctx->state)))
+		goto exit_queue;
 
 	hctx->run++;
 
@@ -832,6 +837,9 @@ static void __blk_mq_run_hw_queue(struct blk_mq_hw_ctx *hctx)
 		 **/
 		blk_mq_run_hw_queue(hctx, true);
 	}
+
+exit_queue:
+	blk_queue_exit(q);
 }
 
 /*
-- 
2.7.2

