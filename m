From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 38/39] blk-mq: make blk_mq_start_stopped_hw_queues run a queue even if not
 stopped
Date: Mon, 17 Mar 2014 06:28:11 -0700
Message-ID: <20140317133137.284157634@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0038-blk-mq-make-blk_mq_start_stopped_hw_queues-run-a-que.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We need this as a workaround for the scsi midlayer, should be fixed in
a nicer way eventually.
---
 block/blk-mq.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 4408c70..4950f8e 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -677,10 +677,8 @@ void blk_mq_start_stopped_hw_queues(struct request_queue *q, bool async)
 	int i;
 
 	queue_for_each_hw_ctx(q, hctx, i) {
-		if (!test_bit(BLK_MQ_S_STOPPED, &hctx->state))
-			continue;
-
-		clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
+		if (test_bit(BLK_MQ_S_STOPPED, &hctx->state))
+			clear_bit(BLK_MQ_S_STOPPED, &hctx->state);
 		blk_mq_run_hw_queue(hctx, async);
 	}
 }
-- 
1.7.10.4
