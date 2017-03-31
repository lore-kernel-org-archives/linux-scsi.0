From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/25] block: add a new BLKDEV_ZERO_NOFALLBACK flag
Date: Fri, 31 Mar 2017 18:33:00 +0200
Message-ID: <20170331163313.31821-13-hch@lst.de>
References: <20170331163313.31821-1-hch@lst.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170331163313.31821-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This avoids fallbacks to explicit zeroing in (__)blkdev_issue_zeroout if
the caller doesn't want them.

Also clean up the convoluted check for the return condition that this
new flag is added to.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-lib.c        | 5 ++++-
 include/linux/blkdev.h | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 2f6d2cb2e1a2..2f882e22890b 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -281,6 +281,9 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
  *
  *  If a device is using logical block provisioning, the underlying space will
  *  not be released if %flags contains BLKDEV_ZERO_NOUNMAP.
+ *
+ *  If %flags contains BLKDEV_ZERO_NOFALLBACK, the function will return
+ *  -EOPNOTSUPP if no explicit hardware offload for zeroing is provided.
  */
 int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop,
@@ -298,7 +301,7 @@ int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 
 	ret = __blkdev_issue_write_zeroes(bdev, sector, nr_sects, gfp_mask,
 			biop, flags);
-	if (ret == 0 || (ret && ret != -EOPNOTSUPP))
+	if (ret != -EOPNOTSUPP || (flags & BLKDEV_ZERO_NOFALLBACK))
 		goto out;
 
 	ret = 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e7513ce3dbde..a5055d760661 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1351,6 +1351,7 @@ extern int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		struct bio **biop);
 
 #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
+#define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes */
 
 extern int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop,
-- 
2.11.0

