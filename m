From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] block: push down BKL into .locked_ioctl
Date: Wed, 2 Jun 2010 00:43:11 +0200
Message-ID: <201006020043.12257.arnd@arndb.de>
References: <1275428028-10901-1-git-send-email-arnd@arndb.de> <20100601213755.GA1004@infradead.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100601213755.GA1004@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "Martin K. Petersen" <martin.petersen@oracle.com>, Steven Rostedt <rostedt@goodmis.org>, Douglas Gilbert <dgilbert@interlog.com>, Ingo Molnar <mingo@redhat.com>, John Kacur <jkacur@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

As a preparation for the removal of the big kernel
lock in the block layer, this removes the BKL
from the common ioctl handling code, moving it
into every single driver still using it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 block/ioctl.c                   |   11 +----------
 drivers/block/amiflop.c         |   15 ++++++++++++++-
 drivers/block/ataflop.c         |   14 +++++++++++++-
 drivers/block/brd.c             |    5 ++++-
 drivers/block/cciss.c           |    8 +++++---
 drivers/block/cpqarray.c        |   18 ++++++++++++++++--
 drivers/block/floppy.c          |   15 ++++++++++++++-
 drivers/block/nbd.c             |    5 ++++-
 drivers/block/paride/pcd.c      |   11 +++++++++--
 drivers/block/paride/pd.c       |    5 ++++-
 drivers/block/paride/pf.c       |    6 +++++-
 drivers/block/pktcdvd.c         |   11 ++++++++---
 drivers/block/swim.c            |    5 ++++-
 drivers/block/swim3.c           |   15 ++++++++++++++-
 drivers/block/ub.c              |   10 ++++++++--
 drivers/block/virtio_blk.c      |   15 ++++++++++++++-
 drivers/block/xd.c              |   15 ++++++++++++++-
 drivers/block/xd.h              |    2 +-
 drivers/block/xen-blkfront.c    |    2 +-
 drivers/cdrom/gdrom.c           |   11 +++++++++--
 drivers/cdrom/viocd.c           |   11 +++++++++--
 drivers/ide/ide-cd.c            |   16 +++++++++++++++-
 drivers/ide/ide-disk_ioctl.c    |    9 +++++++--
 drivers/ide/ide-floppy_ioctl.c  |   12 +++++++++---
 drivers/ide/ide-gd.c            |    2 +-
 drivers/ide/ide-tape.c          |   10 ++++++++--
 drivers/message/i2o/i2o_block.c |   15 ++++++++++++++-
 drivers/mtd/mtd_blkdevs.c       |    5 ++++-
 drivers/scsi/sd.c               |   15 ++++++++++++++-
 drivers/scsi/sr.c               |   15 ++++++++++++++-
 include/linux/blkdev.h          |    1 -
 31 files changed, 257 insertions(+), 53 deletions(-)


On Tuesday 01 June 2010 23:37:55 Christoph Hellwig wrote:
> NAK.  You're really only creation a mini-BKL here without
> sorting out the locking.  Please go through the individual
> callers and sort them out.  Start by pushing the remaining
> ioctls to the unlocked version and moving the BKL into the
> ->open and ->release methods.
 
Ok, here comes the first step. Can you be more specific
about what you mean with the open and release methods? 
Do you mean the sg.c and bsg.c chrdev file operations?

	Arnd

diff --git a/block/ioctl.c b/block/ioctl.c
index e8eb679..1cfa8d4 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -163,18 +163,10 @@ int __blkdev_driver_ioctl(struct block_device *bdev, fmode_t mode,
 			unsigned cmd, unsigned long arg)
 {
 	struct gendisk *disk = bdev->bd_disk;
-	int ret;
 
 	if (disk->fops->ioctl)
 		return disk->fops->ioctl(bdev, mode, cmd, arg);
 
-	if (disk->fops->locked_ioctl) {
-		lock_kernel();
-		ret = disk->fops->locked_ioctl(bdev, mode, cmd, arg);
-		unlock_kernel();
-		return ret;
-	}
-
 	return -ENOTTY;
 }
 /*
@@ -185,8 +177,7 @@ int __blkdev_driver_ioctl(struct block_device *bdev, fmode_t mode,
 EXPORT_SYMBOL_GPL(__blkdev_driver_ioctl);
 
 /*
- * always keep this in sync with compat_blkdev_ioctl() and
- * compat_blkdev_locked_ioctl()
+ * always keep this in sync with compat_blkdev_ioctl()
  */
 int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 			unsigned long arg)
diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 832798a..7a51535 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -60,6 +60,7 @@
 #include <linux/hdreg.h>
 #include <linux/delay.h>
 #include <linux/init.h>
+#include <linux/smp_lock.h>
 #include <linux/amifdreg.h>
 #include <linux/amifd.h>
 #include <linux/buffer_head.h>
@@ -1500,6 +1501,18 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode,
 	return 0;
 }
 
+static int fd_unlocked_ioctl(struct block_device *bdev, fmode_t mode,
+			     unsigned int cmd, unsigned long param)
+{
+	int ret;
+
+	lock_kernel();
+	ret = fd_ioctl(bdev, mode, cmd, param);
+	unlock_kernel();
+
+	return ret;
+}
+
 static void fd_probe(int dev)
 {
 	unsigned long code;
@@ -1638,7 +1651,7 @@ static const struct block_device_operations floppy_fops = {
 	.owner		= THIS_MODULE,
 	.open		= floppy_open,
 	.release	= floppy_release,
-	.locked_ioctl	= fd_ioctl,
+	.ioctl		= fd_unlocked_ioctl,
 	.getgeo		= fd_getgeo,
 	.media_changed	= amiga_floppy_change,
 };
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index e35cf59..09ae46f 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -67,6 +67,7 @@
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/blkdev.h>
+#include <linux/smp_lock.h>
 
 #include <asm/atafd.h>
 #include <asm/atafdreg.h>
@@ -1665,6 +1666,17 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode,
 	}
 }
 
+static int fd_unlocked_ioctl(struct block_device *bdev, fmode_t mode,
+			     unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = fd_ioctl(bdev, mode, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
 
 /* Initialize the 'unit' variable for drive 'drive' */
 
@@ -1855,7 +1867,7 @@ static const struct block_device_operations floppy_fops = {
 	.owner		= THIS_MODULE,
 	.open		= floppy_open,
 	.release	= floppy_release,
-	.locked_ioctl	= fd_ioctl,
+	.ioctl		= fd_unlocked_ioctl,
 	.media_changed	= check_floppy_change,
 	.revalidate_disk= floppy_revalidate,
 };
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 6081e81..b424cca 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -15,6 +15,7 @@
 #include <linux/blkdev.h>
 #include <linux/bio.h>
 #include <linux/highmem.h>
+#include <linux/smp_lock.h>
 #include <linux/radix-tree.h>
 #include <linux/buffer_head.h> /* invalidate_bh_lrus() */
 #include <linux/slab.h>
@@ -355,6 +356,7 @@ static int brd_ioctl(struct block_device *bdev, fmode_t mode,
 	 * ram device BLKFLSBUF has special semantics, we want to actually
 	 * release and destroy the ramdisk data.
 	 */
+	lock_kernel();
 	mutex_lock(&bdev->bd_mutex);
 	error = -EBUSY;
 	if (bdev->bd_openers <= 1) {
@@ -371,13 +373,14 @@ static int brd_ioctl(struct block_device *bdev, fmode_t mode,
 		error = 0;
 	}
 	mutex_unlock(&bdev->bd_mutex);
+	unlock_kernel();
 
 	return error;
 }
 
 static const struct block_device_operations brd_fops = {
 	.owner =		THIS_MODULE,
-	.locked_ioctl =		brd_ioctl,
+	.ioctl =		brd_ioctl,
 #ifdef CONFIG_BLK_DEV_XIP
 	.direct_access =	brd_direct_access,
 #endif
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 51ceaee..6c3c8c4 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -170,6 +170,8 @@ static void do_cciss_request(struct request_queue *q);
 static irqreturn_t do_cciss_intr(int irq, void *dev_id);
 static int cciss_open(struct block_device *bdev, fmode_t mode);
 static int cciss_release(struct gendisk *disk, fmode_t mode);
+static int do_ioctl(struct block_device *bdev, fmode_t mode,
+		    unsigned int cmd, unsigned long arg);
 static int cciss_ioctl(struct block_device *bdev, fmode_t mode,
 		       unsigned int cmd, unsigned long arg);
 static int cciss_getgeo(struct block_device *bdev, struct hd_geometry *geo);
@@ -223,7 +225,7 @@ static const struct block_device_operations cciss_fops = {
 	.owner = THIS_MODULE,
 	.open = cciss_open,
 	.release = cciss_release,
-	.locked_ioctl = cciss_ioctl,
+	.ioctl = do_ioctl,
 	.getgeo = cciss_getgeo,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl = cciss_compat_ioctl,
@@ -1021,8 +1023,6 @@ static int cciss_release(struct gendisk *disk, fmode_t mode)
 	return 0;
 }
 
-#ifdef CONFIG_COMPAT
-
 static int do_ioctl(struct block_device *bdev, fmode_t mode,
 		    unsigned cmd, unsigned long arg)
 {
@@ -1033,6 +1033,8 @@ static int do_ioctl(struct block_device *bdev, fmode_t mode,
 	return ret;
 }
 
+#ifdef CONFIG_COMPAT
+
 static int cciss_ioctl32_passthru(struct block_device *bdev, fmode_t mode,
 				  unsigned cmd, unsigned long arg);
 static int cciss_ioctl32_big_passthru(struct block_device *bdev, fmode_t mode,
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index 91d1163..072e57c 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -35,6 +35,7 @@
 #include <linux/seq_file.h>
 #include <linux/init.h>
 #include <linux/hdreg.h>
+#include <linux/smp_lock.h>
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
 #include <linux/genhd.h>
@@ -159,7 +160,7 @@ static int sendcmd(
 
 static int ida_open(struct block_device *bdev, fmode_t mode);
 static int ida_release(struct gendisk *disk, fmode_t mode);
-static int ida_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd, unsigned long arg);
+static int ida_unlocked_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd, unsigned long arg);
 static int ida_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 static int ida_ctlr_ioctl(ctlr_info_t *h, int dsk, ida_ioctl_t *io);
 
@@ -197,7 +198,7 @@ static const struct block_device_operations ida_fops  = {
 	.owner		= THIS_MODULE,
 	.open		= ida_open,
 	.release	= ida_release,
-	.locked_ioctl	= ida_ioctl,
+	.ioctl		= ida_unlocked_ioctl,
 	.getgeo		= ida_getgeo,
 	.revalidate_disk= ida_revalidate,
 };
@@ -1192,6 +1193,19 @@ out_passthru:
 	}
 		
 }
+
+static int ida_unlocked_ioctl(struct block_device *bdev, fmode_t mode,
+			     unsigned int cmd, unsigned long param)
+{
+	int ret;
+
+	lock_kernel();
+	ret = ida_ioctl(bdev, mode, cmd, param);
+	unlock_kernel();
+
+	return ret;
+}
+
 /*
  * ida_ctlr_ioctl is for passing commands to the controller from userspace.
  * The command block (io) has already been copied to kernel space for us,
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 90c4038..c61df47 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -178,6 +178,7 @@ static int print_unex = 1;
 #include <linux/slab.h>
 #include <linux/mm.h>
 #include <linux/bio.h>
+#include <linux/smp_lock.h>
 #include <linux/string.h>
 #include <linux/jiffies.h>
 #include <linux/fcntl.h>
@@ -3593,6 +3594,18 @@ static int fd_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 	return 0;
 }
 
+static int fd_unlocked_ioctl(struct block_device *bdev, fmode_t mode,
+			     unsigned int cmd, unsigned long param)
+{
+	int ret;
+
+	lock_kernel();
+	ret = fd_ioctl(bdev, mode, cmd, param);
+	unlock_kernel();
+
+	return ret;
+}
+
 static void __init config_types(void)
 {
 	bool has_drive = false;
@@ -3893,7 +3906,7 @@ static const struct block_device_operations floppy_fops = {
 	.owner			= THIS_MODULE,
 	.open			= floppy_open,
 	.release		= floppy_release,
-	.locked_ioctl		= fd_ioctl,
+	.ioctl			= fd_unlocked_ioctl,
 	.getgeo			= fd_getgeo,
 	.media_changed		= check_floppy_change,
 	.revalidate_disk	= floppy_revalidate,
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 218d091..9789907 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -24,6 +24,7 @@
 #include <linux/errno.h>
 #include <linux/file.h>
 #include <linux/ioctl.h>
+#include <linux/smp_lock.h>
 #include <linux/compiler.h>
 #include <linux/err.h>
 #include <linux/kernel.h>
@@ -716,9 +717,11 @@ static int nbd_ioctl(struct block_device *bdev, fmode_t mode,
 	dprintk(DBG_IOCTL, "%s: nbd_ioctl cmd=%s(0x%x) arg=%lu\n",
 			lo->disk->disk_name, ioctl_cmd_to_ascii(cmd), cmd, arg);
 
+	lock_kernel();
 	mutex_lock(&lo->tx_lock);
 	error = __nbd_ioctl(bdev, lo, cmd, arg);
 	mutex_unlock(&lo->tx_lock);
+	unlock_kernel();
 
 	return error;
 }
@@ -726,7 +729,7 @@ static int nbd_ioctl(struct block_device *bdev, fmode_t mode,
 static const struct block_device_operations nbd_fops =
 {
 	.owner =	THIS_MODULE,
-	.locked_ioctl =	nbd_ioctl,
+	.ioctl =	nbd_ioctl,
 };
 
 /*
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 71acf4e..daba7a6 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -138,6 +138,7 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_SLV, D_DLY};
 #include <linux/cdrom.h>
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
+#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 
 static DEFINE_SPINLOCK(pcd_lock);
@@ -238,7 +239,13 @@ static int pcd_block_ioctl(struct block_device *bdev, fmode_t mode,
 				unsigned cmd, unsigned long arg)
 {
 	struct pcd_unit *cd = bdev->bd_disk->private_data;
-	return cdrom_ioctl(&cd->info, bdev, mode, cmd, arg);
+	int ret;
+
+	lock_kernel();
+	ret = cdrom_ioctl(&cd->info, bdev, mode, cmd, arg);
+	unlock_kernel();
+
+	return ret;
 }
 
 static int pcd_block_media_changed(struct gendisk *disk)
@@ -251,7 +258,7 @@ static const struct block_device_operations pcd_bdops = {
 	.owner		= THIS_MODULE,
 	.open		= pcd_block_open,
 	.release	= pcd_block_release,
-	.locked_ioctl	= pcd_block_ioctl,
+	.ioctl		= pcd_block_ioctl,
 	.media_changed	= pcd_block_media_changed,
 };
 
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index c1e5cd0..b22943a 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -153,6 +153,7 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_GEO, D_SBY, D_DLY, D_SLV};
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
 #include <linux/kernel.h>
+#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 #include <linux/workqueue.h>
 
@@ -768,8 +769,10 @@ static int pd_ioctl(struct block_device *bdev, fmode_t mode,
 
 	switch (cmd) {
 	case CDROMEJECT:
+		lock_kernel();
 		if (disk->access == 1)
 			pd_special_command(disk, pd_eject);
+		unlock_kernel();
 		return 0;
 	default:
 		return -EINVAL;
@@ -812,7 +815,7 @@ static const struct block_device_operations pd_fops = {
 	.owner		= THIS_MODULE,
 	.open		= pd_open,
 	.release	= pd_release,
-	.locked_ioctl	= pd_ioctl,
+	.ioctl		= pd_ioctl,
 	.getgeo		= pd_getgeo,
 	.media_changed	= pd_check_media,
 	.revalidate_disk= pd_revalidate
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index c059aab..38b4d56 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -152,6 +152,7 @@ enum {D_PRT, D_PRO, D_UNI, D_MOD, D_SLV, D_LUN, D_DLY};
 #include <linux/spinlock.h>
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
+#include <linux/smp_lock.h>
 #include <asm/uaccess.h>
 
 static DEFINE_SPINLOCK(pf_spin_lock);
@@ -266,7 +267,7 @@ static const struct block_device_operations pf_fops = {
 	.owner		= THIS_MODULE,
 	.open		= pf_open,
 	.release	= pf_release,
-	.locked_ioctl	= pf_ioctl,
+	.ioctl		= pf_ioctl,
 	.getgeo		= pf_getgeo,
 	.media_changed	= pf_check_media,
 };
@@ -342,7 +343,10 @@ static int pf_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd, u
 
 	if (pf->access != 1)
 		return -EBUSY;
+	lock_kernel();
 	pf_eject(pf);
+	unlock_kernel();
+
 	return 0;
 }
 
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 8a549db..1f70aec 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -57,6 +57,7 @@
 #include <linux/seq_file.h>
 #include <linux/miscdevice.h>
 #include <linux/freezer.h>
+#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/slab.h>
 #include <scsi/scsi_cmnd.h>
@@ -2762,10 +2763,12 @@ out_mem:
 static int pkt_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd, unsigned long arg)
 {
 	struct pktcdvd_device *pd = bdev->bd_disk->private_data;
+	int ret;
 
 	VPRINTK("pkt_ioctl: cmd %x, dev %d:%d\n", cmd,
 		MAJOR(bdev->bd_dev), MINOR(bdev->bd_dev));
 
+	lock_kernel();
 	switch (cmd) {
 	case CDROMEJECT:
 		/*
@@ -2783,12 +2786,14 @@ static int pkt_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd,
 	case CDROM_LAST_WRITTEN:
 	case CDROM_SEND_PACKET:
 	case SCSI_IOCTL_SEND_COMMAND:
-		return __blkdev_driver_ioctl(pd->bdev, mode, cmd, arg);
+		ret = __blkdev_driver_ioctl(pd->bdev, mode, cmd, arg);
+		break;
 
 	default:
 		VPRINTK(DRIVER_NAME": Unknown ioctl for %s (%x)\n", pd->name, cmd);
-		return -ENOTTY;
+		ret = -ENOTTY;
 	}
+	unlock_kernel();
 
 	return 0;
 }
@@ -2812,7 +2817,7 @@ static const struct block_device_operations pktcdvd_ops = {
 	.owner =		THIS_MODULE,
 	.open =			pkt_open,
 	.release =		pkt_close,
-	.locked_ioctl =		pkt_ioctl,
+	.ioctl =		pkt_ioctl,
 	.media_changed =	pkt_media_changed,
 };
 
diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index e463657..f04f74e 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -20,6 +20,7 @@
 #include <linux/fd.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
+#include <linux/smp_lock.h>
 #include <linux/hdreg.h>
 #include <linux/kernel.h>
 #include <linux/delay.h>
@@ -690,7 +691,9 @@ static int floppy_ioctl(struct block_device *bdev, fmode_t mode,
 	case FDEJECT:
 		if (fs->ref_count != 1)
 			return -EBUSY;
+		lock_kernel();
 		err = floppy_eject(fs);
+		unlock_kernel();
 		return err;
 
 	case FDGETPRM:
@@ -753,7 +756,7 @@ static const struct block_device_operations floppy_fops = {
 	.owner		 = THIS_MODULE,
 	.open		 = floppy_open,
 	.release	 = floppy_release,
-	.locked_ioctl	 = floppy_ioctl,
+	.ioctl		 = floppy_ioctl,
 	.getgeo		 = floppy_getgeo,
 	.media_changed	 = floppy_check_change,
 	.revalidate_disk = floppy_revalidate,
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 52f2d11..4a83540 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -25,6 +25,7 @@
 #include <linux/ioctl.h>
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
+#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/spinlock.h>
 #include <asm/io.h>
@@ -867,6 +868,18 @@ static int floppy_ioctl(struct block_device *bdev, fmode_t mode,
 	return -ENOTTY;
 }
 
+static int floppy_unlocked_ioctl(struct block_device *bdev, fmode_t mode,
+				 unsigned int cmd, unsigned long param)
+{
+	int ret;
+
+	lock_kernel();
+	ret = floppy_ioctl(bdev, mode, cmd, param);
+	unlock_kernel();
+
+	return ret;
+}
+
 static int floppy_open(struct block_device *bdev, fmode_t mode)
 {
 	struct floppy_state *fs = bdev->bd_disk->private_data;
@@ -997,7 +1010,7 @@ static int floppy_revalidate(struct gendisk *disk)
 static const struct block_device_operations floppy_fops = {
 	.open		= floppy_open,
 	.release	= floppy_release,
-	.locked_ioctl	= floppy_ioctl,
+	.ioctl		= floppy_unlocked_ioctl,
 	.media_changed	= floppy_check_change,
 	.revalidate_disk= floppy_revalidate,
 };
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index 0536b5b..d6e14d2 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -28,6 +28,7 @@
 #include <linux/timer.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <scsi/scsi.h>
 
 #define DRV_NAME "ub"
@@ -1729,8 +1730,13 @@ static int ub_bd_ioctl(struct block_device *bdev, fmode_t mode,
 {
 	struct gendisk *disk = bdev->bd_disk;
 	void __user *usermem = (void __user *) arg;
+	int ret;
+
+	lock_kernel();
+	ret = scsi_cmd_ioctl(disk->queue, disk, mode, cmd, usermem);
+	unlock_kernel();
 
-	return scsi_cmd_ioctl(disk->queue, disk, mode, cmd, usermem);
+	return ret;
 }
 
 /*
@@ -1794,7 +1800,7 @@ static const struct block_device_operations ub_bd_fops = {
 	.owner		= THIS_MODULE,
 	.open		= ub_bd_open,
 	.release	= ub_bd_release,
-	.locked_ioctl	= ub_bd_ioctl,
+	.ioctl		= ub_bd_ioctl,
 	.media_changed	= ub_bd_media_changed,
 	.revalidate_disk = ub_bd_revalidate,
 };
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 83fa09a..a0f9383 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -2,6 +2,7 @@
 #include <linux/spinlock.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
+#include <linux/smp_lock.h>
 #include <linux/hdreg.h>
 #include <linux/virtio.h>
 #include <linux/virtio_blk.h>
@@ -245,6 +246,18 @@ static int virtblk_ioctl(struct block_device *bdev, fmode_t mode,
 			      (void __user *)data);
 }
 
+static int virtblk_unlocked_ioctl(struct block_device *bdev, fmode_t mode,
+			     unsigned int cmd, unsigned long param)
+{
+	int ret;
+
+	lock_kernel();
+	ret = virtblk_ioctl(bdev, mode, cmd, param);
+	unlock_kernel();
+
+	return ret;
+}
+
 /* We provide getgeo only to please some old bootloader/partitioning tools */
 static int virtblk_getgeo(struct block_device *bd, struct hd_geometry *geo)
 {
@@ -271,7 +284,7 @@ static int virtblk_getgeo(struct block_device *bd, struct hd_geometry *geo)
 }
 
 static const struct block_device_operations virtblk_fops = {
-	.locked_ioctl = virtblk_ioctl,
+	.ioctl  = virtblk_unlocked_ioctl,
 	.owner  = THIS_MODULE,
 	.getgeo = virtblk_getgeo,
 };
diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 18a80ff..7f00543 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -46,6 +46,7 @@
 #include <linux/init.h>
 #include <linux/wait.h>
 #include <linux/blkdev.h>
+#include <linux/smp_lock.h>
 #include <linux/blkpg.h>
 #include <linux/delay.h>
 #include <linux/io.h>
@@ -133,7 +134,7 @@ static int xd_getgeo(struct block_device *bdev, struct hd_geometry *geo);
 
 static const struct block_device_operations xd_fops = {
 	.owner	= THIS_MODULE,
-	.locked_ioctl	= xd_ioctl,
+	.ioctl	= xd_unlocked_ioctl,
 	.getgeo = xd_getgeo,
 };
 static DECLARE_WAIT_QUEUE_HEAD(xd_wait_int);
@@ -375,6 +376,18 @@ static int xd_ioctl(struct block_device *bdev, fmode_t mode, u_int cmd, u_long a
 	}
 }
 
+static int xd_unlocked_ioctl(struct block_device *bdev, fmode_t mode,
+			     unsigned int cmd, unsigned long param)
+{
+	int ret;
+
+	lock_kernel();
+	ret = xd_ioctl(bdev, mode, cmd, param);
+	unlock_kernel();
+
+	return ret;
+}
+
 /* xd_readwrite: handle a read/write request */
 static int xd_readwrite (u_char operation,XD_INFO *p,char *buffer,u_int block,u_int count)
 {
diff --git a/drivers/block/xd.h b/drivers/block/xd.h
index 37cacef..bded505 100644
--- a/drivers/block/xd.h
+++ b/drivers/block/xd.h
@@ -105,7 +105,7 @@ static u_char xd_detect (u_char *controller, unsigned int *address);
 static u_char xd_initdrives (void (*init_drive)(u_char drive));
 
 static void do_xd_request (struct request_queue * q);
-static int xd_ioctl (struct block_device *bdev,fmode_t mode,unsigned int cmd,unsigned long arg);
+static int xd_unlocked_ioctl (struct block_device *bdev,fmode_t mode,unsigned int cmd,unsigned long arg);
 static int xd_readwrite (u_char operation,XD_INFO *disk,char *buffer,u_int block,u_int count);
 static void xd_recalibrate (u_char drive);
 
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 82ed403..96a70bb 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1046,7 +1046,7 @@ static const struct block_device_operations xlvbd_block_fops =
 	.open = blkif_open,
 	.release = blkif_release,
 	.getgeo = blkif_getgeo,
-	.locked_ioctl = blkif_ioctl,
+	.ioctl = blkif_ioctl,
 };
 
 
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 03c71f7..7d7b894 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -32,6 +32,7 @@
 #include <linux/blkdev.h>
 #include <linux/interrupt.h>
 #include <linux/device.h>
+#include <linux/smp_lock.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/platform_device.h>
@@ -509,7 +510,13 @@ static int gdrom_bdops_mediachanged(struct gendisk *disk)
 static int gdrom_bdops_ioctl(struct block_device *bdev, fmode_t mode,
 	unsigned cmd, unsigned long arg)
 {
-	return cdrom_ioctl(gd.cd_info, bdev, mode, cmd, arg);
+	int ret;
+
+	lock_kernel();
+	ret = cdrom_ioctl(gd.cd_info, bdev, mode, cmd, arg);
+	unlock_kernel();
+
+	return ret;
 }
 
 static const struct block_device_operations gdrom_bdops = {
@@ -517,7 +524,7 @@ static const struct block_device_operations gdrom_bdops = {
 	.open			= gdrom_bdops_open,
 	.release		= gdrom_bdops_release,
 	.media_changed		= gdrom_bdops_mediachanged,
-	.locked_ioctl		= gdrom_bdops_ioctl,
+	.ioctl			= gdrom_bdops_ioctl,
 };
 
 static irqreturn_t gdrom_command_interrupt(int irq, void *dev_id)
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index 451cd70..203c87c 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -40,6 +40,7 @@
 #include <linux/module.h>
 #include <linux/completion.h>
 #include <linux/proc_fs.h>
+#include <linux/smp_lock.h>
 #include <linux/seq_file.h>
 #include <linux/scatterlist.h>
 
@@ -168,7 +169,13 @@ static int viocd_blk_ioctl(struct block_device *bdev, fmode_t mode,
 		unsigned cmd, unsigned long arg)
 {
 	struct disk_info *di = bdev->bd_disk->private_data;
-	return cdrom_ioctl(&di->viocd_info, bdev, mode, cmd, arg);
+	int ret;
+
+	lock_kernel();
+	ret = cdrom_ioctl(&di->viocd_info, bdev, mode, cmd, arg);
+	unlock_kernel();
+
+	return ret;
 }
 
 static int viocd_blk_media_changed(struct gendisk *disk)
@@ -181,7 +188,7 @@ static const struct block_device_operations viocd_fops = {
 	.owner =		THIS_MODULE,
 	.open =			viocd_blk_open,
 	.release =		viocd_blk_release,
-	.locked_ioctl =		viocd_blk_ioctl,
+	.ioctl =		viocd_blk_ioctl,
 	.media_changed =	viocd_blk_media_changed,
 };
 
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 64207df..03c93ae 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -31,6 +31,7 @@
 #include <linux/delay.h>
 #include <linux/timer.h>
 #include <linux/seq_file.h>
+#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/interrupt.h>
 #include <linux/errno.h>
@@ -1670,6 +1671,19 @@ static int idecd_ioctl(struct block_device *bdev, fmode_t mode,
 	return err;
 }
 
+static int idecd_unlocked_ioctl(struct block_device *bdev, fmode_t mode,
+			     unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = idecd_ioctl(bdev, mode, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
+
 static int idecd_media_changed(struct gendisk *disk)
 {
 	struct cdrom_info *info = ide_drv_g(disk, cdrom_info);
@@ -1690,7 +1704,7 @@ static const struct block_device_operations idecd_ops = {
 	.owner			= THIS_MODULE,
 	.open			= idecd_open,
 	.release		= idecd_release,
-	.locked_ioctl		= idecd_ioctl,
+	.ioctl			= idecd_unlocked_ioctl,
 	.media_changed		= idecd_media_changed,
 	.revalidate_disk	= idecd_revalidate_disk
 };
diff --git a/drivers/ide/ide-disk_ioctl.c b/drivers/ide/ide-disk_ioctl.c
index 7b783dd..ec94c66 100644
--- a/drivers/ide/ide-disk_ioctl.c
+++ b/drivers/ide/ide-disk_ioctl.c
@@ -1,6 +1,7 @@
 #include <linux/kernel.h>
 #include <linux/ide.h>
 #include <linux/hdreg.h>
+#include <linux/smp_lock.h>
 
 #include "ide-disk.h"
 
@@ -18,9 +19,13 @@ int ide_disk_ioctl(ide_drive_t *drive, struct block_device *bdev, fmode_t mode,
 {
 	int err;
 
+	lock_kernel();
 	err = ide_setting_ioctl(drive, bdev, cmd, arg, ide_disk_ioctl_settings);
 	if (err != -EOPNOTSUPP)
-		return err;
+		goto out;
 
-	return generic_ide_ioctl(drive, bdev, cmd, arg);
+	err = generic_ide_ioctl(drive, bdev, cmd, arg);
+out:
+	unlock_kernel();
+	return err;
 }
diff --git a/drivers/ide/ide-floppy_ioctl.c b/drivers/ide/ide-floppy_ioctl.c
index 9c22882..fd3d05a 100644
--- a/drivers/ide/ide-floppy_ioctl.c
+++ b/drivers/ide/ide-floppy_ioctl.c
@@ -5,6 +5,7 @@
 #include <linux/kernel.h>
 #include <linux/ide.h>
 #include <linux/cdrom.h>
+#include <linux/smp_lock.h>
 
 #include <asm/unaligned.h>
 
@@ -275,12 +276,15 @@ int ide_floppy_ioctl(ide_drive_t *drive, struct block_device *bdev,
 	void __user *argp = (void __user *)arg;
 	int err;
 
-	if (cmd == CDROMEJECT || cmd == CDROM_LOCKDOOR)
-		return ide_floppy_lockdoor(drive, &pc, arg, cmd);
+	lock_kernel();
+	if (cmd == CDROMEJECT || cmd == CDROM_LOCKDOOR) {
+		err = ide_floppy_lockdoor(drive, &pc, arg, cmd);
+		goto out;
+	}
 
 	err = ide_floppy_format_ioctl(drive, &pc, mode, cmd, argp);
 	if (err != -ENOTTY)
-		return err;
+		goto out;
 
 	/*
 	 * skip SCSI_IOCTL_SEND_COMMAND (deprecated)
@@ -293,5 +297,7 @@ int ide_floppy_ioctl(ide_drive_t *drive, struct block_device *bdev,
 	if (err == -ENOTTY)
 		err = generic_ide_ioctl(drive, bdev, cmd, arg);
 
+out:
+	unlock_kernel();
 	return err;
 }
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index c102d23..883f0c9 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -323,7 +323,7 @@ static const struct block_device_operations ide_gd_ops = {
 	.owner			= THIS_MODULE,
 	.open			= ide_gd_open,
 	.release		= ide_gd_release,
-	.locked_ioctl		= ide_gd_ioctl,
+	.ioctl			= ide_gd_ioctl,
 	.getgeo			= ide_gd_getgeo,
 	.media_changed		= ide_gd_media_changed,
 	.unlock_native_capacity	= ide_gd_unlock_native_capacity,
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index b072328..2487916 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -32,6 +32,7 @@
 #include <linux/errno.h>
 #include <linux/genhd.h>
 #include <linux/seq_file.h>
+#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <linux/pci.h>
 #include <linux/ide.h>
@@ -1926,9 +1927,14 @@ static int idetape_ioctl(struct block_device *bdev, fmode_t mode,
 {
 	struct ide_tape_obj *tape = ide_drv_g(bdev->bd_disk, ide_tape_obj);
 	ide_drive_t *drive = tape->drive;
-	int err = generic_ide_ioctl(drive, bdev, cmd, arg);
+	int err;
+
+	lock_kernel();
+	err = generic_ide_ioctl(drive, bdev, cmd, arg);
 	if (err == -EINVAL)
 		err = idetape_blkdev_ioctl(drive, cmd, arg);
+	unlock_kernel();
+
 	return err;
 }
 
@@ -1936,7 +1942,7 @@ static const struct block_device_operations idetape_block_ops = {
 	.owner		= THIS_MODULE,
 	.open		= idetape_open,
 	.release	= idetape_release,
-	.locked_ioctl	= idetape_ioctl,
+	.ioctl		= idetape_ioctl,
 };
 
 static int ide_tape_probe(ide_drive_t *drive)
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index fc593fb..1f3b080 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -53,6 +53,7 @@
 #include <linux/module.h>
 #include <linux/slab.h>
 #include <linux/i2o.h>
+#include <linux/smp_lock.h>
 
 #include <linux/mempool.h>
 
@@ -678,6 +679,18 @@ static int i2o_block_ioctl(struct block_device *bdev, fmode_t mode,
 	return -ENOTTY;
 };
 
+static int i2o_block_unlocked_ioctl(struct block_device *bdev, fmode_t mode,
+			     unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = i2o_block_ioctl(bdev, mode, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 /**
  *	i2o_block_media_changed - Have we seen a media change?
  *	@disk: gendisk which should be verified
@@ -930,7 +943,7 @@ static const struct block_device_operations i2o_block_fops = {
 	.owner = THIS_MODULE,
 	.open = i2o_block_open,
 	.release = i2o_block_release,
-	.locked_ioctl = i2o_block_ioctl,
+	.ioctl = i2o_block_unlocked_ioctl,
 	.getgeo = i2o_block_getgeo,
 	.media_changed = i2o_block_media_changed
 };
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 03e19c1..3ddc95b 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -15,6 +15,7 @@
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
 #include <linux/spinlock.h>
+#include <linux/smp_lock.h>
 #include <linux/hdreg.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
@@ -237,6 +238,7 @@ static int blktrans_ioctl(struct block_device *bdev, fmode_t mode,
 	if (!dev)
 		return ret;
 
+	lock_kernel();
 	mutex_lock(&dev->lock);
 
 	if (!dev->mtd)
@@ -250,6 +252,7 @@ static int blktrans_ioctl(struct block_device *bdev, fmode_t mode,
 	}
 unlock:
 	mutex_unlock(&dev->lock);
+	unlock_kernel();
 	blktrans_dev_put(dev);
 	return ret;
 }
@@ -258,7 +261,7 @@ static const struct block_device_operations mtd_blktrans_ops = {
 	.owner		= THIS_MODULE,
 	.open		= blktrans_open,
 	.release	= blktrans_release,
-	.locked_ioctl	= blktrans_ioctl,
+	.ioctl		= blktrans_ioctl,
 	.getgeo		= blktrans_getgeo,
 };
 
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 829cc37..858c89d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -46,6 +46,7 @@
 #include <linux/blkdev.h>
 #include <linux/blkpg.h>
 #include <linux/delay.h>
+#include <linux/smp_lock.h>
 #include <linux/mutex.h>
 #include <linux/string_helpers.h>
 #include <linux/async.h>
@@ -914,6 +915,18 @@ static int sd_ioctl(struct block_device *bdev, fmode_t mode,
 	return scsi_ioctl(sdp, cmd, p);
 }
 
+static int sd_unlocked_ioctl(struct block_device *bdev, fmode_t mode,
+			     unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = sd_ioctl(bdev, mode, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 static void set_media_not_present(struct scsi_disk *sdkp)
 {
 	sdkp->media_present = 0;
@@ -1094,7 +1107,7 @@ static const struct block_device_operations sd_fops = {
 	.owner			= THIS_MODULE,
 	.open			= sd_open,
 	.release		= sd_release,
-	.locked_ioctl		= sd_ioctl,
+	.ioctl			= sd_unlocked_ioctl,
 	.getgeo			= sd_getgeo,
 #ifdef CONFIG_COMPAT
 	.compat_ioctl		= sd_compat_ioctl,
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0a90abc..ad62aa8 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -44,6 +44,7 @@
 #include <linux/init.h>
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
+#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <asm/uaccess.h>
 
@@ -520,6 +521,18 @@ static int sr_block_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	return scsi_ioctl(sdev, cmd, argp);
 }
 
+static int sr_block_unlocked_ioctl(struct block_device *bdev, fmode_t mode,
+				   unsigned int cmd, unsigned long arg)
+{
+	int ret;
+
+	lock_kernel();
+	ret = sr_block_ioctl(bdev, mode, cmd, arg);
+	unlock_kernel();
+
+	return ret;
+}
+
 static int sr_block_media_changed(struct gendisk *disk)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
@@ -531,7 +544,7 @@ static const struct block_device_operations sr_bdops =
 	.owner		= THIS_MODULE,
 	.open		= sr_block_open,
 	.release	= sr_block_release,
-	.locked_ioctl	= sr_block_ioctl,
+	.ioctl		= sr_block_unlocked_ioctl,
 	.media_changed	= sr_block_media_changed,
 	/* 
 	 * No compat_ioctl for now because sr_block_ioctl never
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8b7f5e0..e947688 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1324,7 +1324,6 @@ static inline int blk_integrity_rq(struct request *rq)
 struct block_device_operations {
 	int (*open) (struct block_device *, fmode_t);
 	int (*release) (struct gendisk *, fmode_t);
-	int (*locked_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*compat_ioctl) (struct block_device *, fmode_t, unsigned, unsigned long);
 	int (*direct_access) (struct block_device *, sector_t,
-- 
1.7.0.4
