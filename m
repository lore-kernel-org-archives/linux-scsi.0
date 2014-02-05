From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 03/15] blk-mq: divert __blk_put_request for MQ ops
Date: Wed, 05 Feb 2014 04:41:21 -0800
Message-ID: <20140205124152.682489075@bombadil.infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53219 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaBEMly (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:41:54 -0500
Content-Disposition: inline; filename=0003-blk-mq-divert-__blk_put_request-for-MQ-ops.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

__blk_put_request needs to call into the blk-mq code just like
blk_put_request.  As we don't have the queue lock in this case both
end up calling the same function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index d3eb330..853f927 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1287,6 +1287,11 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	if (unlikely(!q))
 		return;
 
+	if (q->mq_ops) {
+		blk_mq_free_request(req);
+		return;
+	}
+
 	blk_pm_put_request(req);
 
 	elv_completed_request(q, req);
-- 
1.7.10.4


