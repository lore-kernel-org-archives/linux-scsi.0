From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 05/15] blk-mq: initialize sg_reserved_size
Date: Wed, 05 Feb 2014 04:41:23 -0800
Message-ID: <20140205124153.058740666@bombadil.infradead.org>
References: <20140205124118.332902571@bombadil.infradead.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:53226 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426AbaBEMly (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 07:41:54 -0500
Content-Disposition: inline; filename=0005-blk-mq-initialize-sg_reserved_size.patch
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org

To behave the same way as the old request path.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-mq.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 0b72927..d116282 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1363,6 +1363,8 @@ struct request_queue *blk_mq_init_queue(struct blk_mq_reg *reg,
 	q->mq_ops = reg->ops;
 	q->queue_flags |= QUEUE_FLAG_MQ_DEFAULT;
 
+	q->sg_reserved_size = INT_MAX;
+
 	blk_queue_make_request(q, blk_mq_make_request);
 	blk_queue_rq_timed_out(q, reg->ops->timeout);
 	if (reg->timeout)
-- 
1.7.10.4


