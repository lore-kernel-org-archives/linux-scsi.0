From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/23] block: stop using discards for zeroing
Date: Thu, 23 Mar 2017 10:33:38 -0400
Message-ID: <20170323143341.31549-21-hch@lst.de>
References: <20170323143341.31549-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170323143341.31549-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Now that we have REQ_OP_WRITE_ZEROES implemented for all devices that
support efficient zeroing of devices we can remove the call to
blkdev_issue_discard.  This means we only have two ways of zeroing left
and can simply the code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-lib.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 33c5bf373b7f..153ca59393a7 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -279,6 +279,11 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
  *  Zero-fill a block range, either using hardware offload or by explicitly
  *  writing zeroes to the device.
  *
+ *  Note that this function may fail with -EOPNOTSUPP if the driver supports
+ *  efficient zeroing operation, but the device capabilities can only be
+ *  discovered by trial and error.  In this case the caller should call the
+ *  function again, and it will use the fallback path.
+ *
  *  If a device is using logical block provisioning, the underlying space will
  *  only be release if %flags contains BLKDEV_ZERO_UNMAP.
  *
@@ -349,12 +354,6 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	struct bio *bio = NULL;
 	struct blk_plug plug;
 
-	if (flags & BLKDEV_ZERO_UNMAP) {
-		if (!blkdev_issue_discard(bdev, sector, nr_sects, gfp_mask,
-				BLKDEV_DISCARD_ZERO))
-			return 0;
-	}
-
 	blk_start_plug(&plug);
 	ret = __blkdev_issue_zeroout(bdev, sector, nr_sects, gfp_mask,
 			&bio, flags);
-- 
2.11.0
