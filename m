From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 5/7] block: remove BKL from BLKROSET and BLKFLSBUF
Date: Wed,  7 Jul 2010 16:51:27 +0200
Message-ID: <1278514289-21054-6-git-send-email-arnd@arndb.de>
References: <1278514289-21054-1-git-send-email-arnd@arndb.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1278514289-21054-1-git-send-email-arnd@arndb.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

We only call the functions set_device_ro(),
invalidate_bdev(), sync_filesystem() and sync_blockdev()
while holding the BKL in these commands. All
of these are also done in other code paths without
the BKL, which leads me to the conclusion that
the BKL is not needed here either.

The reason we hold it here is that it was originally
pushed down into the ioctl function from vfs_ioctl.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/ioctl.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 9d91e83..60f477c 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -197,10 +197,8 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		if (ret != -EINVAL && ret != -ENOTTY)
 			return ret;
 
-		lock_kernel();
 		fsync_bdev(bdev);
 		invalidate_bdev(bdev);
-		unlock_kernel();
 		return 0;
 
 	case BLKROSET:
@@ -212,9 +210,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 			return -EACCES;
 		if (get_user(n, (int __user *)(arg)))
 			return -EFAULT;
-		lock_kernel();
 		set_device_ro(bdev, n);
-		unlock_kernel();
 		return 0;
 
 	case BLKDISCARD: {
-- 
1.7.0.4

