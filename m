From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/25] pd: remove bogus check for req->errors
Date: Thu,  6 Apr 2017 17:39:42 +0200
Message-ID: <20170406153944.10058-24-hch@lst.de>
References: <20170406153944.10058-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170406153944.10058-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Josef Bacik <jbacik@fb.com>, James Smart <james.smart@broadcom.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, =?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

The driver never sets req->errors
---
 drivers/block/paride/pd.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 82c6d02193ae..3b0ab214fe74 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -739,7 +739,6 @@ static int pd_special_command(struct pd_unit *disk,
 		      enum action (*func)(struct pd_unit *disk))
 {
 	struct request *rq;
-	int err = 0;
 
 	rq = blk_get_request(disk->gd->queue, REQ_OP_DRV_IN, __GFP_RECLAIM);
 	if (IS_ERR(rq))
@@ -748,10 +747,9 @@ static int pd_special_command(struct pd_unit *disk,
 	rq->special = func;
 
 	blk_execute_rq(disk->gd->queue, disk->gd, rq, 0);
-	err = req->errors ? -EIO : 0;
 
 	blk_put_request(rq);
-	return err;
+	return 0;
 }
 
 /* kernel glue structures */
-- 
2.11.0
