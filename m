From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 4/7] block: push BKL into blktrace ioctls
Date: Wed,  7 Jul 2010 16:51:26 +0200
Message-ID: <1278514289-21054-5-git-send-email-arnd@arndb.de>
References: <1278514289-21054-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1278514289-21054-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

The blktrace driver currently needs the BKL, but
we should not need to take that in the block layer,
so just push it down into the driver itself.

It is quite likely that the BKL is not actually
required in blktrace code and could be removed
in a follow-on patch.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/compat_ioctl.c         |   56 ------------------------------------------
 block/ioctl.c                |    2 -
 include/linux/blktrace_api.h |   12 +++++++++
 kernel/trace/blktrace.c      |   43 ++++++++++++++++++++++++++++++++
 4 files changed, 55 insertions(+), 58 deletions(-)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index f26051f..d530856 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -535,56 +535,6 @@ out:
 	return err;
 }
 
-struct compat_blk_user_trace_setup {
-	char name[32];
-	u16 act_mask;
-	u32 buf_size;
-	u32 buf_nr;
-	compat_u64 start_lba;
-	compat_u64 end_lba;
-	u32 pid;
-};
-#define BLKTRACESETUP32 _IOWR(0x12, 115, struct compat_blk_user_trace_setup)
-
-static int compat_blk_trace_setup(struct block_device *bdev, char __user *arg)
-{
-	struct blk_user_trace_setup buts;
-	struct compat_blk_user_trace_setup cbuts;
-	struct request_queue *q;
-	char b[BDEVNAME_SIZE];
-	int ret;
-
-	q = bdev_get_queue(bdev);
-	if (!q)
-		return -ENXIO;
-
-	if (copy_from_user(&cbuts, arg, sizeof(cbuts)))
-		return -EFAULT;
-
-	bdevname(bdev, b);
-
-	buts = (struct blk_user_trace_setup) {
-		.act_mask = cbuts.act_mask,
-		.buf_size = cbuts.buf_size,
-		.buf_nr = cbuts.buf_nr,
-		.start_lba = cbuts.start_lba,
-		.end_lba = cbuts.end_lba,
-		.pid = cbuts.pid,
-	};
-	memcpy(&buts.name, &cbuts.name, 32);
-
-	mutex_lock(&bdev->bd_mutex);
-	ret = do_blk_trace_setup(q, b, bdev->bd_dev, bdev, &buts);
-	mutex_unlock(&bdev->bd_mutex);
-	if (ret)
-		return ret;
-
-	if (copy_to_user(arg, &buts.name, 32))
-		return -EFAULT;
-
-	return 0;
-}
-
 static int compat_blkdev_driver_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned cmd, unsigned long arg)
 {
@@ -802,16 +752,10 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		return compat_put_u64(arg, bdev->bd_inode->i_size);
 
 	case BLKTRACESETUP32:
-		lock_kernel();
-		ret = compat_blk_trace_setup(bdev, compat_ptr(arg));
-		unlock_kernel();
-		return ret;
 	case BLKTRACESTART: /* compatible */
 	case BLKTRACESTOP:  /* compatible */
 	case BLKTRACETEARDOWN: /* compatible */
-		lock_kernel();
 		ret = blk_trace_ioctl(bdev, cmd, compat_ptr(arg));
-		unlock_kernel();
 		return ret;
 	default:
 		if (disk->fops->compat_ioctl)
diff --git a/block/ioctl.c b/block/ioctl.c
index 1cfa8d4..9d91e83 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -320,9 +320,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKTRACESTOP:
 	case BLKTRACESETUP:
 	case BLKTRACETEARDOWN:
-		lock_kernel();
 		ret = blk_trace_ioctl(bdev, cmd, (char __user *) arg);
-		unlock_kernel();
 		break;
 	default:
 		ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
diff --git a/include/linux/blktrace_api.h b/include/linux/blktrace_api.h
index 416bf62..d4dd16c 100644
--- a/include/linux/blktrace_api.h
+++ b/include/linux/blktrace_api.h
@@ -5,6 +5,7 @@
 #ifdef __KERNEL__
 #include <linux/blkdev.h>
 #include <linux/relay.h>
+#include <linux/compat.h>
 #endif
 
 /*
@@ -203,6 +204,17 @@ extern int blk_trace_init_sysfs(struct device *dev);
 
 extern struct attribute_group blk_trace_attr_group;
 
+struct compat_blk_user_trace_setup {
+	char name[32];
+	u16 act_mask;
+	u32 buf_size;
+	u32 buf_nr;
+	compat_u64 start_lba;
+	compat_u64 end_lba;
+	u32 pid;
+};
+#define BLKTRACESETUP32 _IOWR(0x12, 115, struct compat_blk_user_trace_setup)
+
 #else /* !CONFIG_BLK_DEV_IO_TRACE */
 # define blk_trace_ioctl(bdev, cmd, arg)		(-ENOTTY)
 # define blk_trace_shutdown(q)				do { } while (0)
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 638711c..ef4a294 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -549,6 +549,41 @@ int blk_trace_setup(struct request_queue *q, char *name, dev_t dev,
 }
 EXPORT_SYMBOL_GPL(blk_trace_setup);
 
+#if defined(CONFIG_COMPAT) && defined(CONFIG_X86_64)
+static int compat_blk_trace_setup(struct request_queue *q, char *name,
+				  dev_t dev, struct block_device *bdev,
+				  char __user *arg)
+{
+	struct blk_user_trace_setup buts;
+	struct compat_blk_user_trace_setup cbuts;
+	int ret;
+
+	if (copy_from_user(&cbuts, arg, sizeof(cbuts)))
+		return -EFAULT;
+
+	buts = (struct blk_user_trace_setup) {
+		.act_mask = cbuts.act_mask,
+		.buf_size = cbuts.buf_size,
+		.buf_nr = cbuts.buf_nr,
+		.start_lba = cbuts.start_lba,
+		.end_lba = cbuts.end_lba,
+		.pid = cbuts.pid,
+	};
+	memcpy(&buts.name, &cbuts.name, 32);
+
+	ret = do_blk_trace_setup(q, name, dev, bdev, &buts);
+	if (ret)
+		return ret;
+
+	if (copy_to_user(arg, &buts.name, 32)) {
+		blk_trace_remove(q);
+		return -EFAULT;
+	}
+
+	return 0;
+}
+#endif
+
 int blk_trace_startstop(struct request_queue *q, int start)
 {
 	int ret;
@@ -601,6 +636,7 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
 	if (!q)
 		return -ENXIO;
 
+	lock_kernel();
 	mutex_lock(&bdev->bd_mutex);
 
 	switch (cmd) {
@@ -608,6 +644,12 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
 		bdevname(bdev, b);
 		ret = blk_trace_setup(q, b, bdev->bd_dev, bdev, arg);
 		break;
+#if defined(CONFIG_COMPAT) && defined(CONFIG_X86_64)
+	case BLKTRACESETUP32:
+		bdevname(bdev, b);
+		ret = compat_blk_trace_setup(q, b, bdev->bd_dev, bdev, arg);
+		break;
+#endif
 	case BLKTRACESTART:
 		start = 1;
 	case BLKTRACESTOP:
@@ -622,6 +664,7 @@ int blk_trace_ioctl(struct block_device *bdev, unsigned cmd, char __user *arg)
 	}
 
 	mutex_unlock(&bdev->bd_mutex);
+	unlock_kernel();
 	return ret;
 }
 
-- 
1.7.0.4
