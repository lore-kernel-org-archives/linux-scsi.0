From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/10] nbd: don't clear rq->sector and nr_sectors unnecessarily
Date: Wed, 29 Apr 2009 18:13:39 +0900
Message-ID: <1240996428-10159-2-git-send-email-tj@kernel.org>
References: <1240996428-10159-1-git-send-email-tj@kernel.org>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1240996428-10159-1-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petko
Cc: Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

There's no reason to clear rq->sector and nr_sectors after calling
blk_rq_init().  They're guaranteed to be clear.  Drop unnecessary
clearing.

[ Impact: cleanup ]

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Paul Clements <paul.clements@steeleye.com>
---
 drivers/block/nbd.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 4d6de4f..a9ab8be 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -580,13 +580,6 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *lo,
 		blk_rq_init(NULL, &sreq);
 		sreq.cmd_type = REQ_TYPE_SPECIAL;
 		nbd_cmd(&sreq) = NBD_CMD_DISC;
-		/*
-		 * Set these to sane values in case server implementation
-		 * fails to check the request type first and also to keep
-		 * debugging output cleaner.
-		 */
-		sreq.sector = 0;
-		sreq.nr_sectors = 0;
 		if (!lo->sock)
 			return -EINVAL;
 		nbd_send_req(lo, &sreq);
-- 
1.6.0.2

