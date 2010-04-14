From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 1/2] [RFC] block: replace BKL with global mutex
Date: Wed, 14 Apr 2010 22:36:23 +0200
Message-ID: <1271277384-7627-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>, Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Martin K. Petersen" <martin.petersen@oracle.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

The block layer is one of the remaining users
of the Big Kernel Lock. In there, it is used
mainly for serializing the blkdev_get and
blkdev_put functions and some ioctl implementations
as well as some less common open functions of
related character devices following a previous
pushdown and parts of the blktrace code.

The only one that seems to be a bit nasty is the
blkdev_get function which is actually recursive
and may try to get the BKL twice.

All users except the one in blkdev_get seem to
be outermost locks, meaning we don't rely on
the release-on-sleep semantics to avoid deadlocks.

The ctl_mutex (pktcdvd.ko), raw_mutex (raw.ko),
state_mutex (dasd.ko), reconfig_mutex (md.ko),
and jfs_log_mutex (jfs.ko) may be held when
blkdev_get is called, but as far as I can tell,
these mutexes are never acquired from any of the
functions that get converted in this patch.

In order to get rid of the BKL, this introduces
a new global mutex called blkdev_mutex, which
replaces the BKL in all drivers that directly
interact with the block layer. In case of blkdev_get,
the mutex is moved outside of the function itself
in order to avoid the recursive taking of blkdev_mutex.

Testing so far has shown no problems whatsoever
from this patch, but the usage in blkdev_get
may introduce extra latencies, and I may have
missed corner cases where an block device ioctl
function sleeps for a significant amount of time,
which may be harmful to the performance of other
threads.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: John Kacur <jkacur@redhat.com>
Cc: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 block/bsg.c               |    2 --
 block/compat_ioctl.c      |    8 ++++----
 block/ioctl.c             |   24 ++++++++++++------------
 drivers/block/DAC960.c    |    4 ++--
 drivers/block/cciss.c     |    4 ++--
 drivers/block/paride/pg.c |    4 ++--
 drivers/block/paride/pt.c |   16 ++++++++--------
 drivers/scsi/sg.c         |   22 ++++++++++++++++------
 fs/block_dev.c            |   20 +++++++++++++-------
 include/linux/blkdev.h    |    6 ++++++
 kernel/trace/blktrace.c   |   14 ++++++++------
 11 files changed, 73 insertions(+), 51 deletions(-)

diff --git a/block/bsg.c b/block/bsg.c
index 82d5882..7c50a26 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -843,9 +843,7 @@ static int bsg_open(struct inode *inode, struct file *file)
 {
 	struct bsg_device *bd;
 
-	lock_kernel();
 	bd = bsg_get_device(inode, file);
-	unlock_kernel();
 
 	if (IS_ERR(bd))
 		return PTR_ERR(bd);
diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index f26051f..11cfd3c 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -802,16 +802,16 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		return compat_put_u64(arg, bdev->bd_inode->i_size);
 
 	case BLKTRACESETUP32:
-		lock_kernel();
+		mutex_lock(&blkdev_mutex);
 		ret = compat_blk_trace_setup(bdev, compat_ptr(arg));
-		unlock_kernel();
+		mutex_unlock(&blkdev_mutex);
 		return ret;
 	case BLKTRACESTART: /* compatible */
 	case BLKTRACESTOP:  /* compatible */
 	case BLKTRACETEARDOWN: /* compatible */
-		lock_kernel();
+		mutex_lock(&blkdev_mutex);
 		ret = blk_trace_ioctl(bdev, cmd, compat_ptr(arg));
-		unlock_kernel();
+		mutex_unlock(&blkdev_mutex);
 		return ret;
 	default:
 		if (disk->fops->compat_ioctl)
diff --git a/block/ioctl.c b/block/ioctl.c
index 8905d2a..272cdce 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -169,9 +169,9 @@ int __blkdev_driver_ioctl(struct block_device *bdev, fmode_t mode,
 		return disk->fops->ioctl(bdev, mode, cmd, arg);
 
 	if (disk->fops->locked_ioctl) {
-		lock_kernel();
+		mutex_lock(&blkdev_mutex);
 		ret = disk->fops->locked_ioctl(bdev, mode, cmd, arg);
-		unlock_kernel();
+		mutex_unlock(&blkdev_mutex);
 		return ret;
 	}
 
@@ -206,10 +206,10 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		if (ret != -EINVAL && ret != -ENOTTY)
 			return ret;
 
-		lock_kernel();
+		mutex_lock(&blkdev_mutex);
 		fsync_bdev(bdev);
 		invalidate_bdev(bdev);
-		unlock_kernel();
+		mutex_unlock(&blkdev_mutex);
 		return 0;
 
 	case BLKROSET:
@@ -221,9 +221,9 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 			return -EACCES;
 		if (get_user(n, (int __user *)(arg)))
 			return -EFAULT;
-		lock_kernel();
+		mutex_lock(&blkdev_mutex);
 		set_device_ro(bdev, n);
-		unlock_kernel();
+		mutex_unlock(&blkdev_mutex);
 		return 0;
 
 	case BLKDISCARD: {
@@ -309,14 +309,14 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 			bd_release(bdev);
 		return ret;
 	case BLKPG:
-		lock_kernel();
+		mutex_lock(&blkdev_mutex);
 		ret = blkpg_ioctl(bdev, (struct blkpg_ioctl_arg __user *) arg);
-		unlock_kernel();
+		mutex_unlock(&blkdev_mutex);
 		break;
 	case BLKRRPART:
-		lock_kernel();
+		mutex_lock(&blkdev_mutex);
 		ret = blkdev_reread_part(bdev);
-		unlock_kernel();
+		mutex_unlock(&blkdev_mutex);
 		break;
 	case BLKGETSIZE:
 		size = bdev->bd_inode->i_size;
@@ -329,9 +329,9 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKTRACESTOP:
 	case BLKTRACESETUP:
 	case BLKTRACETEARDOWN:
-		lock_kernel();
+		mutex_lock(&blkdev_mutex);
 		ret = blk_trace_ioctl(bdev, cmd, (char __user *) arg);
-		unlock_kernel();
+		mutex_unlock(&blkdev_mutex);
 		break;
 	default:
 		ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index c5f22bb..8faaa12 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -6620,7 +6620,7 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
   long ErrorCode = 0;
   if (!capable(CAP_SYS_ADMIN)) return -EACCES;
 
-  lock_kernel();
+  mutex_lock(&blkdev_mutex);
   switch (Request)
     {
     case DAC960_IOCTL_GET_CONTROLLER_COUNT:
@@ -7051,7 +7051,7 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
       default:
 	ErrorCode = -ENOTTY;
     }
-  unlock_kernel();
+  mutex_unlock(&blkdev_mutex);
   return ErrorCode;
 }
 
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index eb5ff05..0e21a9d 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1027,9 +1027,9 @@ static int do_ioctl(struct block_device *bdev, fmode_t mode,
 		    unsigned cmd, unsigned long arg)
 {
 	int ret;
-	lock_kernel();
+	mutex_lock(&blkdev_mutex);
 	ret = cciss_ioctl(bdev, mode, cmd, arg);
-	unlock_kernel();
+	mutex_unlock(&blkdev_mutex);
 	return ret;
 }
 
diff --git a/drivers/block/paride/pg.c b/drivers/block/paride/pg.c
index c397b3d..81660d0 100644
--- a/drivers/block/paride/pg.c
+++ b/drivers/block/paride/pg.c
@@ -518,7 +518,7 @@ static int pg_open(struct inode *inode, struct file *file)
 	struct pg *dev = &devices[unit];
 	int ret = 0;
 
-	lock_kernel();
+	mutex_lock(&blkdev_mutex);
 	if ((unit >= PG_UNITS) || (!dev->present)) {
 		ret = -ENODEV;
 		goto out;
@@ -547,7 +547,7 @@ static int pg_open(struct inode *inode, struct file *file)
 	file->private_data = dev;
 
 out:
-	unlock_kernel();
+	mutex_unlock(&blkdev_mutex);
 	return ret;
 }
 
diff --git a/drivers/block/paride/pt.c b/drivers/block/paride/pt.c
index bc5825f..05e272e 100644
--- a/drivers/block/paride/pt.c
+++ b/drivers/block/paride/pt.c
@@ -650,9 +650,9 @@ static int pt_open(struct inode *inode, struct file *file)
 	struct pt_unit *tape = pt + unit;
 	int err;
 
-	lock_kernel();
+	mutex_lock(&blkdev_mutex);
 	if (unit >= PT_UNITS || (!tape->present)) {
-		unlock_kernel();
+		mutex_unlock(&blkdev_mutex);
 		return -ENODEV;
 	}
 
@@ -681,12 +681,12 @@ static int pt_open(struct inode *inode, struct file *file)
 	}
 
 	file->private_data = tape;
-	unlock_kernel();
+	mutex_unlock(&blkdev_mutex);
 	return 0;
 
 out:
 	atomic_inc(&tape->available);
-	unlock_kernel();
+	mutex_unlock(&blkdev_mutex);
 	return err;
 }
 
@@ -704,15 +704,15 @@ static long pt_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		switch (mtop.mt_op) {
 
 		case MTREW:
-			lock_kernel();
+			mutex_lock(&blkdev_mutex);
 			pt_rewind(tape);
-			unlock_kernel();
+			mutex_unlock(&blkdev_mutex);
 			return 0;
 
 		case MTWEOF:
-			lock_kernel();
+			mutex_lock(&blkdev_mutex);
 			pt_write_fm(tape);
-			unlock_kernel();
+			mutex_unlock(&blkdev_mutex);
 			return 0;
 
 		default:
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index dee1c96..ec5b43e 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -229,7 +229,7 @@ sg_open(struct inode *inode, struct file *filp)
 	int res;
 	int retval;
 
-	lock_kernel();
+	mutex_lock(&blkdev_mutex);
 	nonseekable_open(inode, filp);
 	SCSI_LOG_TIMEOUT(3, printk("sg_open: dev=%d, flags=0x%x\n", dev, flags));
 	sdp = sg_get_dev(dev);
@@ -307,7 +307,7 @@ error_out:
 sg_put:
 	if (sdp)
 		sg_put_dev(sdp);
-	unlock_kernel();
+	mutex_unlock(&blkdev_mutex);
 	return retval;
 }
 
@@ -757,9 +757,7 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 	return 0;
 }
 
-static int
-sg_ioctl(struct inode *inode, struct file *filp,
-	 unsigned int cmd_in, unsigned long arg)
+static long sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
 	void __user *p = (void __user *)arg;
 	int __user *ip = p;
@@ -1078,6 +1076,17 @@ sg_ioctl(struct inode *inode, struct file *filp,
 	}
 }
 
+static long sg_unlocked_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
+{
+	int ret;
+
+	mutex_lock(&blkdev_mutex);
+	ret = sg_ioctl(filp, cmd_in, arg);
+	mutex_unlock(&blkdev_mutex);
+
+	return ret;
+}
+
 #ifdef CONFIG_COMPAT
 static long sg_compat_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 {
@@ -1322,7 +1331,8 @@ static const struct file_operations sg_fops = {
 	.read = sg_read,
 	.write = sg_write,
 	.poll = sg_poll,
-	.ioctl = sg_ioctl,
+	.llseek = generic_file_llseek,
+	.unlocked_ioctl = sg_unlocked_ioctl,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = sg_compat_ioctl,
 #endif
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 2a6d019..f43d24f 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -29,6 +29,9 @@
 #include <asm/uaccess.h>
 #include "internal.h"
 
+DEFINE_MUTEX(blkdev_mutex);
+EXPORT_SYMBOL_GPL(blkdev_mutex);
+
 struct bdev_inode {
 	struct block_device bdev;
 	struct inode vfs_inode;
@@ -1191,7 +1194,6 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 		return ret;
 	}
 
-	lock_kernel();
  restart:
 
 	ret = -ENXIO;
@@ -1277,7 +1279,6 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 	if (for_part)
 		bdev->bd_part_count++;
 	mutex_unlock(&bdev->bd_mutex);
-	unlock_kernel();
 	return 0;
 
  out_clear:
@@ -1291,7 +1292,6 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
  out_unlock_bdev:
 	mutex_unlock(&bdev->bd_mutex);
  out_unlock_kernel:
-	unlock_kernel();
 
 	if (disk)
 		module_put(disk->fops->owner);
@@ -1303,7 +1303,11 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 
 int blkdev_get(struct block_device *bdev, fmode_t mode)
 {
-	return __blkdev_get(bdev, mode, 0);
+	int ret;
+	mutex_lock(&blkdev_mutex);
+	ret = __blkdev_get(bdev, mode, 0);
+	mutex_unlock(&blkdev_mutex);
+	return ret;
 }
 EXPORT_SYMBOL(blkdev_get);
 
@@ -1357,7 +1361,6 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 	struct block_device *victim = NULL;
 
 	mutex_lock_nested(&bdev->bd_mutex, for_part);
-	lock_kernel();
 	if (for_part)
 		bdev->bd_part_count--;
 
@@ -1382,7 +1385,6 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 			victim = bdev->bd_contains;
 		bdev->bd_contains = NULL;
 	}
-	unlock_kernel();
 	mutex_unlock(&bdev->bd_mutex);
 	bdput(bdev);
 	if (victim)
@@ -1392,7 +1394,11 @@ static int __blkdev_put(struct block_device *bdev, fmode_t mode, int for_part)
 
 int blkdev_put(struct block_device *bdev, fmode_t mode)
 {
-	return __blkdev_put(bdev, mode, 0);
+	int ret;
+	mutex_lock(&blkdev_mutex);
+	ret = __blkdev_put(bdev, mode, 0);
+	mutex_unlock(&blkdev_mutex);
+	return ret;
 }
 EXPORT_SYMBOL(blkdev_put);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6690e8b..7810a2d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1292,6 +1292,12 @@ struct block_device_operations {
 
 extern int __blkdev_driver_ioctl(struct block_device *, fmode_t, unsigned int,
 				 unsigned long);
+
+/*
+ * replaces the big kernel lock in the block subsystem
+ */
+extern struct mutex blkdev_mutex;
+
 #else /* CONFIG_BLOCK */
 /*
  * stubs for when the block layer is configured out
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index b3bc91a..5012fe1 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -305,7 +305,7 @@ static int blk_dropped_open(struct inode *inode, struct file *filp)
 {
 	filp->private_data = inode->i_private;
 
-	return 0;
+	return nonseekable_open(inode, filp);
 }
 
 static ssize_t blk_dropped_read(struct file *filp, char __user *buffer,
@@ -323,13 +323,14 @@ static const struct file_operations blk_dropped_fops = {
 	.owner =	THIS_MODULE,
 	.open =		blk_dropped_open,
 	.read =		blk_dropped_read,
+	.llseek =	no_llseek,
 };
 
 static int blk_msg_open(struct inode *inode, struct file *filp)
 {
 	filp->private_data = inode->i_private;
 
-	return 0;
+	return nonseekable_open(inode, filp);
 }
 
 static ssize_t blk_msg_write(struct file *filp, const char __user *buffer,
@@ -362,6 +363,7 @@ static const struct file_operations blk_msg_fops = {
 	.owner =	THIS_MODULE,
 	.open =		blk_msg_open,
 	.write =	blk_msg_write,
+	.llseek =	no_llseek,
 };
 
 /*
@@ -1581,7 +1583,7 @@ static ssize_t sysfs_blk_trace_attr_show(struct device *dev,
 	struct block_device *bdev;
 	ssize_t ret = -ENXIO;
 
-	lock_kernel();
+	mutex_lock(&blkdev_mutex);
 	bdev = bdget(part_devt(p));
 	if (bdev == NULL)
 		goto out_unlock_kernel;
@@ -1613,7 +1615,7 @@ out_unlock_bdev:
 out_bdput:
 	bdput(bdev);
 out_unlock_kernel:
-	unlock_kernel();
+	mutex_unlock(&blkdev_mutex);
 	return ret;
 }
 
@@ -1643,7 +1645,7 @@ static ssize_t sysfs_blk_trace_attr_store(struct device *dev,
 
 	ret = -ENXIO;
 
-	lock_kernel();
+	mutex_unlock(&blkdev_mutex);
 	p = dev_to_part(dev);
 	bdev = bdget(part_devt(p));
 	if (bdev == NULL)
@@ -1683,7 +1685,7 @@ out_unlock_bdev:
 out_bdput:
 	bdput(bdev);
 out_unlock_kernel:
-	unlock_kernel();
+	mutex_unlock(&blkdev_mutex);
 out:
 	return ret ? ret : count;
 }
-- 
1.7.0.4
