From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 10/23] null_blk: don't pass always-0 req->errors to blk_mq_complete_request
Date: Wed, 19 Apr 2017 21:26:55 +0200
Message-ID: <20170419192708.22098-11-hch@lst.de>
References: <20170419192708.22098-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:38659 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763319AbdDST1w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2017 15:27:52 -0400
In-Reply-To: <20170419192708.22098-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/null_blk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index f93906ff31e8..24ca85a70fd8 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -281,7 +281,7 @@ static inline void null_handle_cmd(struct nullb_cmd *cmd)
 	case NULL_IRQ_SOFTIRQ:
 		switch (queue_mode)  {
 		case NULL_Q_MQ:
-			blk_mq_complete_request(cmd->rq, cmd->rq->errors);
+			blk_mq_complete_request(cmd->rq, 0);
 			break;
 		case NULL_Q_RQ:
 			blk_complete_request(cmd->rq);
-- 
2.11.0
