From: Christoph Hellwig <hch@bombadil.infradead.org>
Subject: null_blk: don't pass always-0 req->errors to blk_mq_complete_request
Date: Tue, 18 Apr 2017 08:52:15 -0700
Message-ID: <20170418155229.5977-10-hch@bombadil.infradead.org>
References: <20170418155229.5977-1-hch@bombadil.infradead.org>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170418155229.5977-1-hch@bombadil.infradead.org>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

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
