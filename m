From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/7] scsi/i2o_block: cleanup ioctl handling
Date: Wed,  7 Jul 2010 16:51:23 +0200
Message-ID: <1278514289-21054-2-git-send-email-arnd@arndb.de>
References: <1278514289-21054-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1278514289-21054-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

This fixes the ioctl function of the i2o_block driver, which
has multiple problems:

* The BLKI2OSRSTRAT and BLKI2OSWSTRAT commands always return
  -ENOTTY on success, where they should return 0.
* Support for 32 bit compat is missing
* The driver should use the .ioctl function and because
  .locked_ioctl is going away.

The use of the big kernel lock remains for now, but gets
made explictit in the ioctl function.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/message/i2o/i2o_block.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index fc593fb..ad3ddef 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -53,6 +53,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2o.h>
+#include <linux/smp_lock.h>
 
 #include <linux/mempool.h>
 
@@ -652,30 +653,40 @@ static int i2o_block_ioctl(struct block_device *bdev, fmode_t mode,
 {
 	struct gendisk *disk = bdev->bd_disk;
 	struct i2o_block_device *dev = disk->private_data;
+	int ret = -ENOTTY;
 
 	/* Anyone capable of this syscall can do *real bad* things */
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	lock_kernel();
 	switch (cmd) {
 	case BLKI2OGRSTRAT:
-		return put_user(dev->rcache, (int __user *)arg);
+		ret = put_user(dev->rcache, (int __user *)arg);
+		break;
 	case BLKI2OGWSTRAT:
-		return put_user(dev->wcache, (int __user *)arg);
+		ret = put_user(dev->wcache, (int __user *)arg);
+		break;
 	case BLKI2OSRSTRAT:
+		ret = -EINVAL;
 		if (arg < 0 || arg > CACHE_SMARTFETCH)
-			return -EINVAL;
+			break;
 		dev->rcache = arg;
+		ret = 0;
 		break;
 	case BLKI2OSWSTRAT:
+		ret = -EINVAL;
 		if (arg != 0
 		    && (arg < CACHE_WRITETHROUGH || arg > CACHE_SMARTBACK))
-			return -EINVAL;
+			break;
 		dev->wcache = arg;
+		ret = 0;
 		break;
 	}
-	return -ENOTTY;
+	unlock_kernel();
+
+	return ret;
 };
 
 /**
@@ -930,7 +941,8 @@ static const struct block_device_operations i2o_block_fops = {
 	.owner = THIS_MODULE,
 	.open = i2o_block_open,
 	.release = i2o_block_release,
-	.locked_ioctl = i2o_block_ioctl,
+	.ioctl = i2o_block_ioctl,
+	.compat_ioctl = i2o_block_ioctl,
 	.getgeo = i2o_block_getgeo,
 	.media_changed = i2o_block_media_changed
 };
-- 
1.7.0.4
