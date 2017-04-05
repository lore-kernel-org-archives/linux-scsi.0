From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/27] block_dev: use blkdev_issue_zerout for hole punches
Date: Wed,  5 Apr 2017 16:21:51 +0200
Message-ID: <20170405142205.6477-14-hch@lst.de>
References: <20170405142205.6477-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170405142205.6477-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This gets us support for non-discard efficient write of zeroes (e.g. NVMe)
and prepares for removing the discard_zeroes_data flag.

Also remove a pointless discard support check, which is done in
blkdev_issue_discard already.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 fs/block_dev.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2f704c3a816f..e405d8e58e31 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -2069,7 +2069,6 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 			     loff_t len)
 {
 	struct block_device *bdev = I_BDEV(bdev_file_inode(file));
-	struct request_queue *q = bdev_get_queue(bdev);
 	struct address_space *mapping;
 	loff_t end = start + len - 1;
 	loff_t isize;
@@ -2108,15 +2107,10 @@ static long blkdev_fallocate(struct file *file, int mode, loff_t start,
 					    GFP_KERNEL, BLKDEV_ZERO_NOUNMAP);
 		break;
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE:
-		/* Only punch if the device can do zeroing discard. */
-		if (!blk_queue_discard(q) || !q->limits.discard_zeroes_data)
-			return -EOPNOTSUPP;
-		error = blkdev_issue_discard(bdev, start >> 9, len >> 9,
-					     GFP_KERNEL, 0);
+		error = blkdev_issue_zeroout(bdev, start >> 9, len >> 9,
+					     GFP_KERNEL, BLKDEV_ZERO_NOFALLBACK);
 		break;
 	case FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE | FALLOC_FL_NO_HIDE_STALE:
-		if (!blk_queue_discard(q))
-			return -EOPNOTSUPP;
 		error = blkdev_issue_discard(bdev, start >> 9, len >> 9,
 					     GFP_KERNEL, 0);
 		break;
-- 
2.11.0
