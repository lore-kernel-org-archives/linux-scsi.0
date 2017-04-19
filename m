From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 01/23] pd: don't check blk_execute_rq return value.
Date: Wed, 19 Apr 2017 21:26:46 +0200
Message-ID: <20170419192708.22098-2-hch@lst.de>
References: <20170419192708.22098-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170419192708.22098-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

The driver never sets req->errors, so blk_execute_rq will always return 0.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/paride/pd.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index b05e151c9b38..7d2402f90978 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -739,18 +739,15 @@ static int pd_special_command(struct pd_unit *disk,
 		      enum action (*func)(struct pd_unit *disk))
 {
 	struct request *rq;
-	int err = 0;
 
 	rq = blk_get_request(disk->gd->queue, REQ_OP_DRV_IN, __GFP_RECLAIM);
 	if (IS_ERR(rq))
 		return PTR_ERR(rq);
 
 	rq->special = func;
-
-	err = blk_execute_rq(disk->gd->queue, disk->gd, rq, 0);
-
+	blk_execute_rq(disk->gd->queue, disk->gd, rq, 0);
 	blk_put_request(rq);
-	return err;
+	return 0;
 }
 
 /* kernel glue structures */
-- 
2.11.0
