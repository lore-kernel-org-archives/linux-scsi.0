From: Ming Lei <ming.lei@canonical.com>
Subject: [PATCH 3/6] blk-mq: don't copy pdu if init_flush_rq is implemented
Date: Sun,  7 Sep 2014 16:39:19 +0800
Message-ID: <1410079162-9872-4-git-send-email-ming.lei@canonical.com>
References: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1410079162-9872-1-git-send-email-ming.lei@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@canonical.com>
List-Id: linux-scsi@vger.kernel.org

Current copying serves purpose of initializing flush req's pdu,
so don't do that if init_flush_rq is implemented.

Signed-off-by: Ming Lei <ming.lei@canonical.com>
---
 block/blk-mq.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 1daef32..113d58d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -292,8 +292,10 @@ void blk_mq_clone_flush_request(struct request *flush_rq,
 
 	flush_rq->mq_ctx = orig_rq->mq_ctx;
 	flush_rq->tag = orig_rq->tag;
-	memcpy(blk_mq_rq_to_pdu(flush_rq), blk_mq_rq_to_pdu(orig_rq),
-		hctx->cmd_size);
+
+	if (!orig_rq->q->mq_ops->init_flush_rq)
+		memcpy(blk_mq_rq_to_pdu(flush_rq),
+			blk_mq_rq_to_pdu(orig_rq), hctx->cmd_size);
 }
 
 inline void __blk_mq_end_io(struct request *rq, int error)
-- 
1.7.9.5
