From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 6/7] block: remove BKL from partition ioctls
Date: Wed,  7 Jul 2010 16:51:28 +0200
Message-ID: <1278514289-21054-7-git-send-email-arnd@arndb.de>
References: <1278514289-21054-1-git-send-email-arnd@arndb.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.171]:65458 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756370Ab0GGOv4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2010 10:51:56 -0400
In-Reply-To: <1278514289-21054-1-git-send-email-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>

The blkpg_ioctl and blkdev_reread_part access fields of
the bdev and gendisk structures, yet they always do so
under the protection of bdev->bd_mutex, which seems
sufficient.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/ioctl.c |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 60f477c..09fd7f1 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -296,14 +296,10 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 			bd_release(bdev);
 		return ret;
 	case BLKPG:
-		lock_kernel();
 		ret = blkpg_ioctl(bdev, (struct blkpg_ioctl_arg __user *) arg);
-		unlock_kernel();
 		break;
 	case BLKRRPART:
-		lock_kernel();
 		ret = blkdev_reread_part(bdev);
-		unlock_kernel();
 		break;
 	case BLKGETSIZE:
 		size = bdev->bd_inode->i_size;
-- 
1.7.0.4

