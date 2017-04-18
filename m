From: Christoph Hellwig <hch@bombadil.infradead.org>
Subject: blk-mq: simplify __blk_mq_complete_request
Date: Tue, 18 Apr 2017 08:52:22 -0700
Message-ID: <20170418155229.5977-17-hch@bombadil.infradead.org>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:45362 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757372AbdDRPwp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2017 11:52:45 -0400
In-Reply-To: <20170418155229.5977-1-hch@bombadil.infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>

From: Christoph Hellwig <hch@lst.de>

Merge blk_mq_ipi_complete_request and blk_mq_stat_add into their only
caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0c19df66f5a0..1f98db082da3 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -406,12 +406,19 @@ static void __blk_mq_complete_request_remote(void *data)
 	rq->q->softirq_done_fn(rq);
 }
 
-static void blk_mq_ipi_complete_request(struct request *rq)
+static void __blk_mq_complete_request(struct request *rq)
 {
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
 	bool shared = false;
 	int cpu;
 
+	if (rq->internal_tag != -1)
+		blk_mq_sched_completed_request(rq);
+	if (rq->rq_flags & RQF_STATS) {
+		blk_mq_poll_stats_start(rq->q);
+		blk_stat_add(rq);
+	}
+
 	if (!test_bit(QUEUE_FLAG_SAME_COMP, &rq->q->queue_flags)) {
 		rq->q->softirq_done_fn(rq);
 		return;
@@ -432,22 +439,6 @@ static void blk_mq_ipi_complete_request(struct request *rq)
 	put_cpu();
 }
 
-static void blk_mq_stat_add(struct request *rq)
-{
-	if (rq->rq_flags & RQF_STATS) {
-		blk_mq_poll_stats_start(rq->q);
-		blk_stat_add(rq);
-	}
-}
-
-static void __blk_mq_complete_request(struct request *rq)
-{
-	if (rq->internal_tag != -1)
-		blk_mq_sched_completed_request(rq);
-	blk_mq_stat_add(rq);
-	blk_mq_ipi_complete_request(rq);
-}
-
 /**
  * blk_mq_complete_request - end I/O on a request
  * @rq:		the request being processed
-- 
2.11.0
