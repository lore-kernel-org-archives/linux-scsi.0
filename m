From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/25] block: stop using blkdev_issue_write_same for zeroing
Date: Fri, 31 Mar 2017 18:32:57 +0200
Message-ID: <20170331163313.31821-10-hch@lst.de>
References: <20170331163313.31821-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:41698 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933368AbdCaQdq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2017 12:33:46 -0400
In-Reply-To: <20170331163313.31821-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org

We'll always use the WRITE ZEROES code for zeroing now.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-lib.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index e5b853f2b8a2..2a8d638544a7 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -364,10 +364,6 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			return 0;
 	}
 
-	if (!blkdev_issue_write_same(bdev, sector, nr_sects, gfp_mask,
-			ZERO_PAGE(0)))
-		return 0;
-
 	blk_start_plug(&plug);
 	ret = __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask,
 			&bio, discard);
-- 
2.11.0
