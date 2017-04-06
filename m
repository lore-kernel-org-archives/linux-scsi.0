From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/25] blk-mq: simplify __blk_mq_complete_request
Date: Thu,  6 Apr 2017 17:39:37 +0200
Message-ID: <20170406153944.10058-19-hch@lst.de>
References: <20170406153944.10058-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:40629 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933192AbdDFPkt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2017 11:40:49 -0400
In-Reply-To: <20170406153944.10058-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

Merge blk_mq_ipi_complete_request and blk_mq_stat_add into their only
caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c | 21 ++++++---------------
 1 file changed, 6 insertions(+), 15 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 393f350ebb90..a6e14a3c87ce 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -405,12 +405,17 @@ static void __blk_mq_complete_request_remote(void *data)
 	rq->q->softirq_done_fn(rq);
 }
 
-static void blk_mq_ipi_complete_request(struct request *rq)
+static void __blk_mq_complete_request(struct request *rq)
 {
 	struct blk_mq_ctx *ctx = rq->mq_ctx;
 	bool shared = false;
 	int cpu;
 
+	if (rq->rq_flags & RQF_STATS) {
+		blk_mq_poll_stats_start(rq->q);
+		blk_stat_add(rq);
+	}
+
 	if (!test_bit(QUEUE_FLAG_SAME_COMP, &rq->q->queue_flags)) {
 		rq->q->softirq_done_fn(rq);
 		return;
@@ -431,20 +436,6 @@ static void blk_mq_ipi_complete_request(struct request *rq)
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
-	blk_mq_stat_add(rq);
-	blk_mq_ipi_complete_request(rq);
-}
-
 /**
  * blk_mq_complete_request - end I/O on a request
  * @rq:		the request being processed
-- 
2.11.0
