From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/39] blk-mq: fix blk_mq_end_io_partial
Date: Mon, 17 Mar 2014 06:27:36 -0700
Message-ID: <20140317133131.797576672@bombadil.infradead.org>
References: <20140317132733.789623766@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline; filename=0003-blk-mq-fix-blk_mq_end_io_partial.patch
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

We need to pass the actual nr_bytes instead of all bytes in the request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 883f720..d81dc8b 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -285,7 +285,7 @@ void blk_mq_free_request(struct request *rq)
 
 bool blk_mq_end_io_partial(struct request *rq, int error, unsigned int nr_bytes)
 {
-	if (blk_update_request(rq, error, blk_rq_bytes(rq)))
+	if (blk_update_request(rq, error, nr_bytes))
 		return true;
 
 	blk_account_io_done(rq);
-- 
1.7.10.4
