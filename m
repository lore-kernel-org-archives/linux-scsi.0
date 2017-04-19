From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 11/23] dm rq: don't pass irrelevant error code to blk_mq_complete_request
Date: Wed, 19 Apr 2017 21:26:56 +0200
Message-ID: <20170419192708.22098-12-hch@lst.de>
References: <20170419192708.22098-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:36268 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763400AbdDST1x (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2017 15:27:53 -0400
In-Reply-To: <20170419192708.22098-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

dm never uses rq->errors, so there is no need to pass an error argument
to blk_mq_complete_request.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-rq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index e60f1b6845be..1173be21f6f6 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -363,7 +363,7 @@ static void dm_complete_request(struct request *rq, int error)
 	if (!rq->q->mq_ops)
 		blk_complete_request(rq);
 	else
-		blk_mq_complete_request(rq, error);
+		blk_mq_complete_request(rq, 0);
 }
 
 /*
-- 
2.11.0
