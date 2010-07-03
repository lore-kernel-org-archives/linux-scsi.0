From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 2/6] block: push down BKL into .open and .release
Date: Sat,  3 Jul 2010 23:47:16 +0200
Message-ID: <1278193640-24223-3-git-send-email-arnd@arndb.de>
References: <1278193640-24223-1-git-send-email-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1278193640-24223-1-git-send-email-arnd@arndb.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
List-Id: linux-scsi@vger.kernel.org

The open and release block_device_operations are currently
called with the BKL held. In order to change that, we must
first make sure that all drivers that currently rely
on this have no regressions.

This blindly pushes the BKL into all .open and .release
operations for all block drivers to prepare for the
next step. The drivers can subsequently replace the BKL
with their own locks or remove it completely when it can
be shown that it is not needed.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/um/drivers/ubd_kern.c          |    7 ++++++-
 drivers/block/DAC960.c              |   13 +++++++++----
 drivers/block/amiflop.c             |   12 ++++++++++--
 drivers/block/aoe/aoeblk.c          |    4 ++++
 drivers/block/ataflop.c             |   14 +++++++++++++-
 drivers/block/cciss.c               |   23 ++++++++++++++++++++---
 drivers/block/cpqarray.c            |   22 +++++++++++++++++++---
 drivers/block/drbd/drbd_main.c      |    4 ++++
 drivers/block/floppy.c              |    5 +++++
 drivers/block/loop.c                |    5 +++++
 drivers/block/paride/pcd.c          |   10 +++++++++-
 drivers/block/paride/pd.c           |    4 ++++
 drivers/block/paride/pf.c           |   20 +++++++++++++++-----
 drivers/block/pktcdvd.c             |    5 +++++
 drivers/block/swim.c                |   15 ++++++++++++++-
 drivers/block/swim3.c               |   15 ++++++++++++++-
 drivers/block/ub.c                  |   17 ++++++++++++++++-
 drivers/block/viodasd.c             |   19 ++++++++++++++++++-
 drivers/block/xen-blkfront.c        |    7 +++++++
 drivers/block/xsysace.c             |    6 ++++++
 drivers/block/z2ram.c               |   13 ++++++++++---
 drivers/cdrom/gdrom.c               |    8 +++++++-
 drivers/cdrom/viocd.c               |   10 +++++++++-
 drivers/ide/ide-cd.c                |   14 +++++++++-----
 drivers/ide/ide-gd.c                |   17 ++++++++++++++++-
 drivers/ide/ide-tape.c              |    9 ++++++++-
 drivers/md/dm.c                     |    7 +++++++
 drivers/md/md.c                     |    6 ++++++
 drivers/memstick/core/mspro_block.c |    9 ++++++++-
 drivers/message/i2o/i2o_block.c     |    4 ++++
 drivers/mmc/card/block.c            |    5 +++++
 drivers/mtd/mtd_blkdevs.c           |    6 +++++-
 drivers/s390/block/dasd.c           |    6 ++++++
 drivers/s390/block/dcssblk.c        |    5 +++++
 drivers/s390/char/tape_block.c      |    8 +++++++-
 drivers/scsi/sd.c                   |    5 +++++
 drivers/scsi/sr.c                   |    7 ++++++-
 drivers/staging/hv/blkvsc_drv.c     |    5 +++++
 38 files changed, 331 insertions(+), 40 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index da992a3..1bcd208 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -33,6 +33,7 @@
 #include "linux/mm.h"
 #include "linux/slab.h"
 #include "linux/vmalloc.h"
+#include "linux/smp_lock.h"
 #include "linux/blkpg.h"
 #include "linux/genhd.h"
 #include "linux/spinlock.h"
@@ -1098,6 +1099,7 @@ static int ubd_open(struct block_device *bdev, fmode_t mode)
 	struct ubd *ubd_dev = disk->private_data;
 	int err = 0;
 
+	lock_kernel();
 	if(ubd_dev->count == 0){
 		err = ubd_open_dev(ubd_dev);
 		if(err){
@@ -1115,7 +1117,8 @@ static int ubd_open(struct block_device *bdev, fmode_t mode)
 	        if(--ubd_dev->count == 0) ubd_close_dev(ubd_dev);
 	        err = -EROFS;
 	}*/
- out:
+out:
+	unlock_kernel();
 	return err;
 }
 
@@ -1123,8 +1126,10 @@ static int ubd_release(struct gendisk *disk, fmode_t mode)
 {
 	struct ubd *ubd_dev = disk->private_data;
 
+	lock_kernel();
 	if(--ubd_dev->count == 0)
 		ubd_close_dev(ubd_dev);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index c5f22bb..4e2c367 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -79,23 +79,28 @@ static int DAC960_open(struct block_device *bdev, fmode_t mode)
 	struct gendisk *disk = bdev->bd_disk;
 	DAC960_Controller_T *p = disk->queue->queuedata;
 	int drive_nr = (long)disk->private_data;
+	int ret = -ENXIO;
 
+	lock_kernel();
 	if (p->FirmwareType == DAC960_V1_Controller) {
 		if (p->V1.LogicalDriveInformation[drive_nr].
 		    LogicalDriveState == DAC960_V1_LogicalDrive_Offline)
-			return -ENXIO;
+			goto out;
 	} else {
 		DAC960_V2_LogicalDeviceInfo_T *i =
 			p->V2.LogicalDeviceInformation[drive_nr];
 		if (!i || i->LogicalDeviceState == DAC960_V2_LogicalDevice_Offline)
-			return -ENXIO;
+			goto out;
 	}
 
 	check_disk_change(bdev);
 
 	if (!get_capacity(p->disks[drive_nr]))
-		return -ENXIO;
-	return 0;
+		goto out;
+	ret = 0;
+out:
+	unlock_kernel();
+	return ret;
 }
 
 static int DAC960_getgeo(struct block_device *bdev, struct hd_geometry *geo)
diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index 7a51535..8af7af7 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1555,10 +1555,13 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	int old_dev;
 	unsigned long flags;
 
+	lock_kernel();
 	old_dev = fd_device[drive];
 
-	if (fd_ref[drive] && old_dev != system)
+	if (fd_ref[drive] && old_dev != system) {
+		unlock_kernel();
 		return -EBUSY;
+	}
 
 	if (mode & (FMODE_READ|FMODE_WRITE)) {
 		check_disk_change(bdev);
@@ -1571,8 +1574,10 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 			fd_deselect (drive);
 			rel_fdc();
 
-			if (wrprot)
+			if (wrprot) {
+				unlock_kernel();
 				return -EROFS;
+			}
 		}
 	}
 
@@ -1589,6 +1594,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	printk(KERN_INFO "fd%d: accessing %s-disk with %s-layout\n",drive,
 	       unit[drive].type->name, data_types[system].name);
 
+	unlock_kernel();
 	return 0;
 }
 
@@ -1597,6 +1603,7 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 	struct amiga_floppy_struct *p = disk->private_data;
 	int drive = p - unit;
 
+	lock_kernel();
 	if (unit[drive].dirty == 1) {
 		del_timer (flush_track_timer + drive);
 		non_int_flush_track (drive);
@@ -1610,6 +1617,7 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 /* the mod_use counter is handled this way */
 	floppy_off (drive | 0x40000000);
 #endif
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/block/aoe/aoeblk.c b/drivers/block/aoe/aoeblk.c
index 035cefe..3a6da77 100644
--- a/drivers/block/aoe/aoeblk.c
+++ b/drivers/block/aoe/aoeblk.c
@@ -12,6 +12,7 @@
 #include <linux/slab.h>
 #include <linux/genhd.h>
 #include <linux/netdevice.h>
+#include <linux/smp_lock.h>
 #include "aoe.h"
 
 static struct kmem_cache *buf_pool_cache;
@@ -124,13 +125,16 @@ aoeblk_open(struct block_device *bdev, fmode_t mode)
 	struct aoedev *d = bdev->bd_disk->private_data;
 	ulong flags;
 
+	lock_kernel();
 	spin_lock_irqsave(&d->lock, flags);
 	if (d->flags & DEVFL_UP) {
 		d->nopen++;
 		spin_unlock_irqrestore(&d->lock, flags);
+		unlock_kernel();
 		return 0;
 	}
 	spin_unlock_irqrestore(&d->lock, flags);
+	unlock_kernel();
 	return -ENODEV;
 }
 
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 09ae46f..f3eb6d9 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -1850,22 +1850,34 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	return 0;
 }
 
+static int floppy_unlocked_open(struct block_device *bdev, fmode_t mode)
+{
+	int ret;
+
+	lock_kernel();
+	ret = floppy_open(bdev, mode);
+	unlock_kernel();
+
+	return ret;
+}
 
 static int floppy_release(struct gendisk *disk, fmode_t mode)
 {
 	struct atari_floppy_struct *p = disk->private_data;
+	lock_kernel();
 	if (p->ref < 0)
 		p->ref = 0;
 	else if (!p->ref--) {
 		printk(KERN_ERR "floppy_release with fd_ref == 0");
 		p->ref = 0;
 	}
+	unlock_kernel();
 	return 0;
 }
 
 static const struct block_device_operations floppy_fops = {
 	.owner		= THIS_MODULE,
-	.open		= floppy_open,
+	.open		= floppy_unlocked_open,
 	.release	= floppy_release,
 	.ioctl		= fd_unlocked_ioctl,
 	.media_changed	= check_floppy_change,
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 6c3c8c4..f8671c1 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -169,6 +169,7 @@ static LIST_HEAD(scan_q);
 static void do_cciss_request(struct request_queue *q);
 static irqreturn_t do_cciss_intr(int irq, void *dev_id);
 static int cciss_open(struct block_device *bdev, fmode_t mode);
+static int cciss_unlocked_open(struct block_device *bdev, fmode_t mode);
 static int cciss_release(struct gendisk *disk, fmode_t mode);
 static int do_ioctl(struct block_device *bdev, fmode_t mode,
 		    unsigned int cmd, unsigned long arg);
@@ -223,7 +224,7 @@ static int cciss_compat_ioctl(struct block_device *, fmode_t,
 
 static const struct block_device_operations cciss_fops = {
 	.owner = THIS_MODULE,
-	.open = cciss_open,
+	.open = cciss_unlocked_open,
 	.release = cciss_release,
 	.ioctl = do_ioctl,
 	.getgeo = cciss_getgeo,
@@ -1006,13 +1007,28 @@ static int cciss_open(struct block_device *bdev, fmode_t mode)
 	return 0;
 }
 
+static int cciss_unlocked_open(struct block_device *bdev, fmode_t mode)
+{
+	int ret;
+
+	lock_kernel();
+	ret = cciss_open(bdev, mode);
+	unlock_kernel();
+
+	return ret;
+}
+
 /*
  * Close.  Sync first.
  */
 static int cciss_release(struct gendisk *disk, fmode_t mode)
 {
-	ctlr_info_t *host = get_host(disk);
-	drive_info_struct *drv = get_drv(disk);
+	ctlr_info_t *host;
+	drive_info_struct *drv;
+
+	lock_kernel();
+	host = get_host(disk);
+	drv = get_drv(disk);
 
 #ifdef CCISS_DEBUG
 	printk(KERN_DEBUG "cciss_release %s\n", disk->disk_name);
@@ -1020,6 +1036,7 @@ static int cciss_release(struct gendisk *disk, fmode_t mode)
 
 	drv->usage_count--;
 	host->usage_count--;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index b591518..59d55b9 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -158,7 +158,7 @@ static int sendcmd(
 	unsigned int blkcnt,
 	unsigned int log_unit );
 
-static int ida_open(struct block_device *bdev, fmode_t mode);
+static int ida_unlocked_open(struct block_device *bdev, fmode_t mode);
 static int ida_release(struct gendisk *disk, fmode_t mode);
 static int ida_unlocked_ioctl(struct block_device *bdev, fmode_t mode, unsigned int cmd, unsigned long arg);
 static int ida_getgeo(struct block_device *bdev, struct hd_geometry *geo);
@@ -196,7 +196,7 @@ static inline ctlr_info_t *get_host(struct gendisk *disk)
 
 static const struct block_device_operations ida_fops  = {
 	.owner		= THIS_MODULE,
-	.open		= ida_open,
+	.open		= ida_unlocked_open,
 	.release	= ida_release,
 	.ioctl		= ida_unlocked_ioctl,
 	.getgeo		= ida_getgeo,
@@ -841,13 +841,29 @@ static int ida_open(struct block_device *bdev, fmode_t mode)
 	return 0;
 }
 
+static int ida_unlocked_open(struct block_device *bdev, fmode_t mode)
+{
+	int ret;
+
+	lock_kernel();
+	ret = ida_open(bdev, mode);
+	unlock_kernel();
+
+	return ret;
+}
+
 /*
  * Close.  Sync first.
  */
 static int ida_release(struct gendisk *disk, fmode_t mode)
 {
-	ctlr_info_t *host = get_host(disk);
+	ctlr_info_t *host;
+
+	lock_kernel();
+	host = get_host(disk);
 	host->usage_count--;
+	unlock_kernel();
+
 	return 0;
 }
 
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 7258c95..a7c6d8d 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2604,6 +2604,7 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 	unsigned long flags;
 	int rv = 0;
 
+	lock_kernel();
 	spin_lock_irqsave(&mdev->req_lock, flags);
 	/* to have a stable mdev->state.role
 	 * and no race with updating open_cnt */
@@ -2618,6 +2619,7 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 	if (!rv)
 		mdev->open_cnt++;
 	spin_unlock_irqrestore(&mdev->req_lock, flags);
+	unlock_kernel();
 
 	return rv;
 }
@@ -2625,7 +2627,9 @@ static int drbd_open(struct block_device *bdev, fmode_t mode)
 static int drbd_release(struct gendisk *gd, fmode_t mode)
 {
 	struct drbd_conf *mdev = gd->private_data;
+	lock_kernel();
 	mdev->open_cnt--;
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index c61df47..73f1fd9 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3662,6 +3662,7 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 {
 	int drive = (long)disk->private_data;
 
+	lock_kernel();
 	mutex_lock(&open_lock);
 	if (UDRS->fd_ref < 0)
 		UDRS->fd_ref = 0;
@@ -3672,6 +3673,7 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 	if (!UDRS->fd_ref)
 		opened_bdev[drive] = NULL;
 	mutex_unlock(&open_lock);
+	unlock_kernel();
 
 	return 0;
 }
@@ -3689,6 +3691,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	int res = -EBUSY;
 	char *tmp;
 
+	lock_kernel();
 	mutex_lock(&open_lock);
 	old_dev = UDRS->fd_device;
 	if (opened_bdev[drive] && opened_bdev[drive] != bdev)
@@ -3765,6 +3768,7 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 			goto out;
 	}
 	mutex_unlock(&open_lock);
+	unlock_kernel();
 	return 0;
 out:
 	if (UDRS->fd_ref < 0)
@@ -3775,6 +3779,7 @@ out:
 		opened_bdev[drive] = NULL;
 out2:
 	mutex_unlock(&open_lock);
+	unlock_kernel();
 	return res;
 }
 
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6120922..b9f5026 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -67,6 +67,7 @@
 #include <linux/compat.h>
 #include <linux/suspend.h>
 #include <linux/freezer.h>
+#include <linux/smp_lock.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h>		/* for invalidate_bdev() */
 #include <linux/completion.h>
@@ -1408,9 +1409,11 @@ static int lo_open(struct block_device *bdev, fmode_t mode)
 {
 	struct loop_device *lo = bdev->bd_disk->private_data;
 
+	lock_kernel();
 	mutex_lock(&lo->lo_ctl_mutex);
 	lo->lo_refcnt++;
 	mutex_unlock(&lo->lo_ctl_mutex);
+	unlock_kernel();
 
 	return 0;
 }
@@ -1420,6 +1423,7 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
 	struct loop_device *lo = disk->private_data;
 	int err;
 
+	lock_kernel();
 	mutex_lock(&lo->lo_ctl_mutex);
 
 	if (--lo->lo_refcnt)
@@ -1444,6 +1448,7 @@ static int lo_release(struct gendisk *disk, fmode_t mode)
 out:
 	mutex_unlock(&lo->lo_ctl_mutex);
 out_unlocked:
+	lock_kernel();
 	return 0;
 }
 
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index daba7a6..76f8565 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -225,13 +225,21 @@ static char *pcd_buf;		/* buffer for request in progress */
 static int pcd_block_open(struct block_device *bdev, fmode_t mode)
 {
 	struct pcd_unit *cd = bdev->bd_disk->private_data;
-	return cdrom_open(&cd->info, bdev, mode);
+	int ret;
+
+	lock_kernel();
+	ret = cdrom_open(&cd->info, bdev, mode);
+	unlock_kernel();
+
+	return ret;
 }
 
 static int pcd_block_release(struct gendisk *disk, fmode_t mode)
 {
 	struct pcd_unit *cd = disk->private_data;
+	lock_kernel();
 	cdrom_release(&cd->info, mode);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index b22943a..ad8d3a8 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -736,12 +736,14 @@ static int pd_open(struct block_device *bdev, fmode_t mode)
 {
 	struct pd_unit *disk = bdev->bd_disk->private_data;
 
+	lock_kernel();
 	disk->access++;
 
 	if (disk->removable) {
 		pd_special_command(disk, pd_media_check);
 		pd_special_command(disk, pd_door_lock);
 	}
+	unlock_kernel();
 	return 0;
 }
 
@@ -783,8 +785,10 @@ static int pd_release(struct gendisk *p, fmode_t mode)
 {
 	struct pd_unit *disk = p->private_data;
 
+	lock_kernel();
 	if (!--disk->access && disk->removable)
 		pd_special_command(disk, pd_door_unlock);
+	unlock_kernel();
 
 	return 0;
 }
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index 38b4d56..4457b49 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -300,20 +300,26 @@ static void __init pf_init_units(void)
 static int pf_open(struct block_device *bdev, fmode_t mode)
 {
 	struct pf_unit *pf = bdev->bd_disk->private_data;
+	int ret;
 
+	lock_kernel();
 	pf_identify(pf);
 
+	ret = -ENODEV;
 	if (pf->media_status == PF_NM)
-		return -ENODEV;
+		goto out;
 
+	ret = -EROFS;
 	if ((pf->media_status == PF_RO) && (mode & FMODE_WRITE))
-		return -EROFS;
+		goto out;
 
+	ret = 0;
 	pf->access++;
 	if (pf->removable)
 		pf_lock(pf, 1);
-
-	return 0;
+out:
+	unlock_kernel();
+	return ret;
 }
 
 static int pf_getgeo(struct block_device *bdev, struct hd_geometry *geo)
@@ -354,14 +360,18 @@ static int pf_release(struct gendisk *disk, fmode_t mode)
 {
 	struct pf_unit *pf = disk->private_data;
 
-	if (pf->access <= 0)
+	lock_kernel();
+	if (pf->access <= 0) {
+		unlock_kernel();
 		return -EINVAL;
+	}
 
 	pf->access--;
 
 	if (!pf->access && pf->removable)
 		pf_lock(pf, 0);
 
+	unlock_kernel();
 	return 0;
 
 }
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 1f70aec..4f2e12f 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2383,6 +2383,7 @@ static int pkt_open(struct block_device *bdev, fmode_t mode)
 
 	VPRINTK(DRIVER_NAME": entering open\n");
 
+	lock_kernel();
 	mutex_lock(&ctl_mutex);
 	pd = pkt_find_dev_from_minor(MINOR(bdev->bd_dev));
 	if (!pd) {
@@ -2410,6 +2411,7 @@ static int pkt_open(struct block_device *bdev, fmode_t mode)
 	}
 
 	mutex_unlock(&ctl_mutex);
+	unlock_kernel();
 	return 0;
 
 out_dec:
@@ -2417,6 +2419,7 @@ out_dec:
 out:
 	VPRINTK(DRIVER_NAME": failed open (%d)\n", ret);
 	mutex_unlock(&ctl_mutex);
+	unlock_kernel();
 	return ret;
 }
 
@@ -2425,6 +2428,7 @@ static int pkt_close(struct gendisk *disk, fmode_t mode)
 	struct pktcdvd_device *pd = disk->private_data;
 	int ret = 0;
 
+	lock_kernel();
 	mutex_lock(&ctl_mutex);
 	pd->refcnt--;
 	BUG_ON(pd->refcnt < 0);
@@ -2433,6 +2437,7 @@ static int pkt_close(struct gendisk *disk, fmode_t mode)
 		pkt_release_dev(pd, flush);
 	}
 	mutex_unlock(&ctl_mutex);
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index f04f74e..2e46815 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -662,11 +662,23 @@ out:
 	return err;
 }
 
+static int floppy_unlocked_open(struct block_device *bdev, fmode_t mode)
+{
+	int ret;
+
+	lock_kernel();
+	ret = floppy_open(bdev, mode);
+	unlock_kernel();
+
+	return ret;
+}
+
 static int floppy_release(struct gendisk *disk, fmode_t mode)
 {
 	struct floppy_state *fs = disk->private_data;
 	struct swim __iomem *base = fs->swd->base;
 
+	lock_kernel();
 	if (fs->ref_count < 0)
 		fs->ref_count = 0;
 	else if (fs->ref_count > 0)
@@ -674,6 +686,7 @@ static int floppy_release(struct gendisk *disk, fmode_t mode)
 
 	if (fs->ref_count == 0)
 		swim_motor(base, OFF);
+	unlock_kernel();
 
 	return 0;
 }
@@ -754,7 +767,7 @@ static int floppy_revalidate(struct gendisk *disk)
 
 static const struct block_device_operations floppy_fops = {
 	.owner		 = THIS_MODULE,
-	.open		 = floppy_open,
+	.open		 = floppy_unlocked_open,
 	.release	 = floppy_release,
 	.ioctl		 = floppy_ioctl,
 	.getgeo		 = floppy_getgeo,
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 9d6bf06..7c4559e 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -949,15 +949,28 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	return 0;
 }
 
+static int floppy_unlocked_open(struct block_device *bdev, fmode_t mode)
+{
+	int ret;
+
+	lock_kernel();
+	ret = floppy_open(bdev, mode);
+	unlock_kernel();
+
+	return ret;
+}
+
 static int floppy_release(struct gendisk *disk, fmode_t mode)
 {
 	struct floppy_state *fs = disk->private_data;
 	struct swim3 __iomem *sw = fs->swim3;
+	lock_kernel();
 	if (fs->ref_count > 0 && --fs->ref_count == 0) {
 		swim3_action(fs, MOTOR_OFF);
 		out_8(&sw->control_bic, 0xff);
 		swim3_select(fs, RELAX);
 	}
+	unlock_kernel();
 	return 0;
 }
 
@@ -1008,7 +1021,7 @@ static int floppy_revalidate(struct gendisk *disk)
 }
 
 static const struct block_device_operations floppy_fops = {
-	.open		= floppy_open,
+	.open		= floppy_unlocked_open,
 	.release	= floppy_release,
 	.ioctl		= floppy_unlocked_ioctl,
 	.media_changed	= floppy_check_change,
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index d6e14d2..6701886 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -1711,6 +1711,18 @@ err_open:
 	return rc;
 }
 
+static int ub_bd_unlocked_open(struct block_device *bdev, fmode_t mode)
+{
+	int ret;
+
+	lock_kernel();
+	ret = ub_bd_open(bdev, mode);
+	unlock_kernel();
+
+	return ret;
+}
+
+
 /*
  */
 static int ub_bd_release(struct gendisk *disk, fmode_t mode)
@@ -1718,7 +1730,10 @@ static int ub_bd_release(struct gendisk *disk, fmode_t mode)
 	struct ub_lun *lun = disk->private_data;
 	struct ub_dev *sc = lun->udev;
 
+	lock_kernel();
 	ub_put(sc);
+	unlock_kernel();
+
 	return 0;
 }
 
@@ -1798,7 +1813,7 @@ static int ub_bd_media_changed(struct gendisk *disk)
 
 static const struct block_device_operations ub_bd_fops = {
 	.owner		= THIS_MODULE,
-	.open		= ub_bd_open,
+	.open		= ub_bd_unlocked_open,
 	.release	= ub_bd_release,
 	.ioctl		= ub_bd_ioctl,
 	.media_changed	= ub_bd_media_changed,
diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
index 788d938..3cbc85c 100644
--- a/drivers/block/viodasd.c
+++ b/drivers/block/viodasd.c
@@ -41,6 +41,7 @@
 #include <linux/errno.h>
 #include <linux/init.h>
 #include <linux/string.h>
+#include <linux/smp_lock.h>
 #include <linux/dma-mapping.h>
 #include <linux/completion.h>
 #include <linux/device.h>
@@ -175,6 +176,18 @@ static int viodasd_open(struct block_device *bdev, fmode_t mode)
 	return 0;
 }
 
+static int viodasd_unlocked_open(struct block_device *bdev, fmode_t mode)
+{
+	int ret;
+
+	lock_kernel();
+	ret = viodasd_open(bdev, mode);
+	unlock_kernel();
+
+	return ret;
+}
+
+
 /*
  * External release entry point.
  */
@@ -183,6 +196,7 @@ static int viodasd_release(struct gendisk *disk, fmode_t mode)
 	struct viodasd_device *d = disk->private_data;
 	HvLpEvent_Rc hvrc;
 
+	lock_kernel();
 	/* Send the event to OS/400.  We DON'T expect a response */
 	hvrc = HvCallEvent_signalLpEventFast(viopath_hostLp,
 			HvLpEvent_Type_VirtualIo,
@@ -195,6 +209,9 @@ static int viodasd_release(struct gendisk *disk, fmode_t mode)
 			0, 0, 0);
 	if (hvrc != 0)
 		pr_warning("HV close call failed %d\n", (int)hvrc);
+
+	unlock_kernel();
+
 	return 0;
 }
 
@@ -219,7 +236,7 @@ static int viodasd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
  */
 static const struct block_device_operations viodasd_fops = {
 	.owner = THIS_MODULE,
-	.open = viodasd_open,
+	.open = viodasd_unlocked_open,
 	.release = viodasd_release,
 	.getgeo = viodasd_getgeo,
 };
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 96a70bb..dfb3dce 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -41,6 +41,7 @@
 #include <linux/cdrom.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/scatterlist.h>
 
 #include <xen/xen.h>
@@ -1019,13 +1020,18 @@ static int blkfront_is_ready(struct xenbus_device *dev)
 static int blkif_open(struct block_device *bdev, fmode_t mode)
 {
 	struct blkfront_info *info = bdev->bd_disk->private_data;
+
+	lock_kernel();
 	info->users++;
+	unlock_kernel();
+
 	return 0;
 }
 
 static int blkif_release(struct gendisk *disk, fmode_t mode)
 {
 	struct blkfront_info *info = disk->private_data;
+	lock_kernel();
 	info->users--;
 	if (info->users == 0) {
 		/* Check whether we have been instructed to close.  We will
@@ -1037,6 +1043,7 @@ static int blkif_release(struct gendisk *disk, fmode_t mode)
 		if (state == XenbusStateClosing && info->is_ready)
 			blkfront_closing(dev);
 	}
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index a7b83c0..8d435c9 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -89,6 +89,7 @@
 #include <linux/delay.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
+#include <linux/smp_lock.h>
 #include <linux/ata.h>
 #include <linux/hdreg.h>
 #include <linux/platform_device.h>
@@ -901,11 +902,14 @@ static int ace_open(struct block_device *bdev, fmode_t mode)
 
 	dev_dbg(ace->dev, "ace_open() users=%i\n", ace->users + 1);
 
+	lock_kernel();
 	spin_lock_irqsave(&ace->lock, flags);
 	ace->users++;
 	spin_unlock_irqrestore(&ace->lock, flags);
 
 	check_disk_change(bdev);
+	unlock_kernel();
+
 	return 0;
 }
 
@@ -917,6 +921,7 @@ static int ace_release(struct gendisk *disk, fmode_t mode)
 
 	dev_dbg(ace->dev, "ace_release() users=%i\n", ace->users - 1);
 
+	lock_kernel();
 	spin_lock_irqsave(&ace->lock, flags);
 	ace->users--;
 	if (ace->users == 0) {
@@ -924,6 +929,7 @@ static int ace_release(struct gendisk *disk, fmode_t mode)
 		ace_out(ace, ACE_CTRL, val & ~ACE_CTRL_LOCKREQ);
 	}
 	spin_unlock_irqrestore(&ace->lock, flags);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index 9114654..d75b2bb 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -33,6 +33,7 @@
 #include <linux/module.h>
 #include <linux/blkdev.h>
 #include <linux/bitops.h>
+#include <linux/smp_lock.h>
 #include <linux/slab.h>
 
 #include <asm/setup.h>
@@ -153,6 +154,7 @@ static int z2_open(struct block_device *bdev, fmode_t mode)
 
     device = MINOR(bdev->bd_dev);
 
+    lock_kernel();
     if ( current_device != -1 && current_device != device )
     {
 	rc = -EBUSY;
@@ -294,20 +296,25 @@ static int z2_open(struct block_device *bdev, fmode_t mode)
 	set_capacity(z2ram_gendisk, z2ram_size >> 9);
     }
 
+    unlock_kernel();
     return 0;
 
 err_out_kfree:
     kfree(z2ram_map);
 err_out:
+    unlock_kernel();
     return rc;
 }
 
 static int
 z2_release(struct gendisk *disk, fmode_t mode)
 {
-    if ( current_device == -1 )
-	return 0;     
-
+    lock_kernel();
+    if ( current_device == -1 ) {
+    	unlock_kernel();
+    	return 0;
+    }
+    unlock_kernel();
     /*
      * FIXME: unmap memory
      */
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 7d7b894..b5bacd1 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -493,12 +493,18 @@ static struct cdrom_device_ops gdrom_ops = {
 
 static int gdrom_bdops_open(struct block_device *bdev, fmode_t mode)
 {
-	return cdrom_open(gd.cd_info, bdev, mode);
+	int ret;
+	lock_kernel();
+	ret = cdrom_open(gd.cd_info, bdev, mode);
+	unlock_kernel();
+	return ret;
 }
 
 static int gdrom_bdops_release(struct gendisk *disk, fmode_t mode)
 {
+	lock_kernel();
 	cdrom_release(gd.cd_info, mode);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index 203c87c..74d7e55 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -155,13 +155,21 @@ static const struct file_operations proc_viocd_operations = {
 static int viocd_blk_open(struct block_device *bdev, fmode_t mode)
 {
 	struct disk_info *di = bdev->bd_disk->private_data;
-	return cdrom_open(&di->viocd_info, bdev, mode);
+	int ret;
+
+	lock_kernel();
+	ret = cdrom_open(&di->viocd_info, bdev, mode);
+	unlock_kernel();
+
+	return ret;
 }
 
 static int viocd_blk_release(struct gendisk *disk, fmode_t mode)
 {
 	struct disk_info *di = disk->private_data;
+	lock_kernel();
 	cdrom_release(&di->viocd_info, mode);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 03c93ae..a7fb6ea 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1585,17 +1585,19 @@ static struct ide_driver ide_cdrom_driver = {
 
 static int idecd_open(struct block_device *bdev, fmode_t mode)
 {
-	struct cdrom_info *info = ide_cd_get(bdev->bd_disk);
-	int rc = -ENOMEM;
+	struct cdrom_info *info;
+	int rc = -ENXIO;
 
+	lock_kernel();
+	info = ide_cd_get(bdev->bd_disk);
 	if (!info)
-		return -ENXIO;
+		goto out;
 
 	rc = cdrom_open(&info->devinfo, bdev, mode);
-
 	if (rc < 0)
 		ide_cd_put(info);
-
+out:
+	unlock_kernel();
 	return rc;
 }
 
@@ -1603,9 +1605,11 @@ static int idecd_release(struct gendisk *disk, fmode_t mode)
 {
 	struct cdrom_info *info = ide_drv_g(disk, cdrom_info);
 
+	lock_kernel();
 	cdrom_release(&info->devinfo, mode);
 
 	ide_cd_put(info);
+	unlock_kernel();
 
 	return 0;
 }
diff --git a/drivers/ide/ide-gd.c b/drivers/ide/ide-gd.c
index 883f0c9..137337a 100644
--- a/drivers/ide/ide-gd.c
+++ b/drivers/ide/ide-gd.c
@@ -1,3 +1,4 @@
+#include <linux/smp_lock.h>
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/string.h>
@@ -237,6 +238,18 @@ out_put_idkp:
 	return ret;
 }
 
+static int ide_gd_unlocked_open(struct block_device *bdev, fmode_t mode)
+{
+	int ret;
+
+	lock_kernel();
+	ret = ide_gd_open(bdev, mode);
+	unlock_kernel();
+
+	return ret;
+}
+
+
 static int ide_gd_release(struct gendisk *disk, fmode_t mode)
 {
 	struct ide_disk_obj *idkp = ide_drv_g(disk, ide_disk_obj);
@@ -244,6 +257,7 @@ static int ide_gd_release(struct gendisk *disk, fmode_t mode)
 
 	ide_debug_log(IDE_DBG_FUNC, "enter");
 
+	lock_kernel();
 	if (idkp->openers == 1)
 		drive->disk_ops->flush(drive);
 
@@ -255,6 +269,7 @@ static int ide_gd_release(struct gendisk *disk, fmode_t mode)
 	idkp->openers--;
 
 	ide_disk_put(idkp);
+	unlock_kernel();
 
 	return 0;
 }
@@ -321,7 +336,7 @@ static int ide_gd_ioctl(struct block_device *bdev, fmode_t mode,
 
 static const struct block_device_operations ide_gd_ops = {
 	.owner			= THIS_MODULE,
-	.open			= ide_gd_open,
+	.open			= ide_gd_unlocked_open,
 	.release		= ide_gd_release,
 	.ioctl			= ide_gd_ioctl,
 	.getgeo			= ide_gd_getgeo,
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 2487916..c50061e 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -1906,7 +1906,11 @@ static const struct file_operations idetape_fops = {
 
 static int idetape_open(struct block_device *bdev, fmode_t mode)
 {
-	struct ide_tape_obj *tape = ide_tape_get(bdev->bd_disk, false, 0);
+	struct ide_tape_obj *tape;
+
+	lock_kernel();
+	tape = ide_tape_get(bdev->bd_disk, false, 0);
+	unlock_kernel();
 
 	if (!tape)
 		return -ENXIO;
@@ -1918,7 +1922,10 @@ static int idetape_release(struct gendisk *disk, fmode_t mode)
 {
 	struct ide_tape_obj *tape = ide_drv_g(disk, ide_tape_obj);
 
+	lock_kernel();
 	ide_tape_put(tape);
+	unlock_kernel();
+
 	return 0;
 }
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index d21e128..40951a2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -15,6 +15,7 @@
 #include <linux/blkpg.h>
 #include <linux/bio.h>
 #include <linux/buffer_head.h>
+#include <linux/smp_lock.h>
 #include <linux/mempool.h>
 #include <linux/slab.h>
 #include <linux/idr.h>
@@ -338,6 +339,7 @@ static int dm_blk_open(struct block_device *bdev, fmode_t mode)
 {
 	struct mapped_device *md;
 
+	lock_kernel();
 	spin_lock(&_minor_lock);
 
 	md = bdev->bd_disk->private_data;
@@ -355,6 +357,7 @@ static int dm_blk_open(struct block_device *bdev, fmode_t mode)
 
 out:
 	spin_unlock(&_minor_lock);
+	unlock_kernel();
 
 	return md ? 0 : -ENXIO;
 }
@@ -362,8 +365,12 @@ out:
 static int dm_blk_close(struct gendisk *disk, fmode_t mode)
 {
 	struct mapped_device *md = disk->private_data;
+
+	lock_kernel();
 	atomic_dec(&md->open_count);
 	dm_put(md);
+	unlock_kernel();
+
 	return 0;
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index cb20d0b..a98f590 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -36,6 +36,7 @@
 #include <linux/blkdev.h>
 #include <linux/sysctl.h>
 #include <linux/seq_file.h>
+#include <linux/smp_lock.h>
 #include <linux/buffer_head.h> /* for invalidate_bdev */
 #include <linux/poll.h>
 #include <linux/ctype.h>
@@ -5902,6 +5903,7 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 	mddev_t *mddev = mddev_find(bdev->bd_dev);
 	int err;
 
+	lock_kernel();
 	if (mddev->gendisk != bdev->bd_disk) {
 		/* we are racing with mddev_put which is discarding this
 		 * bd_disk.
@@ -5910,6 +5912,7 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 		/* Wait until bdev->bd_disk is definitely gone */
 		flush_scheduled_work();
 		/* Then retry the open from the top */
+		unlock_kernel();
 		return -ERESTARTSYS;
 	}
 	BUG_ON(mddev != bdev->bd_disk->private_data);
@@ -5923,6 +5926,7 @@ static int md_open(struct block_device *bdev, fmode_t mode)
 
 	check_disk_size_change(mddev->gendisk, bdev);
  out:
+	unlock_kernel();
 	return err;
 }
 
@@ -5931,8 +5935,10 @@ static int md_release(struct gendisk *disk, fmode_t mode)
  	mddev_t *mddev = disk->private_data;
 
 	BUG_ON(!mddev);
+	lock_kernel();
 	atomic_dec(&mddev->openers);
 	mddev_put(mddev);
+	unlock_kernel();
 
 	return 0;
 }
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 8327e24..5b1c2cf 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -18,6 +18,7 @@
 #include <linux/kthread.h>
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <linux/smp_lock.h>
 #include <linux/memstick.h>
 
 #define DRIVER_NAME "mspro_block"
@@ -179,6 +180,7 @@ static int mspro_block_bd_open(struct block_device *bdev, fmode_t mode)
 	struct mspro_block_data *msb = disk->private_data;
 	int rc = -ENXIO;
 
+	lock_kernel();
 	mutex_lock(&mspro_block_disk_lock);
 
 	if (msb && msb->card) {
@@ -190,6 +192,7 @@ static int mspro_block_bd_open(struct block_device *bdev, fmode_t mode)
 	}
 
 	mutex_unlock(&mspro_block_disk_lock);
+	unlock_kernel();
 
 	return rc;
 }
@@ -221,7 +224,11 @@ static int mspro_block_disk_release(struct gendisk *disk)
 
 static int mspro_block_bd_release(struct gendisk *disk, fmode_t mode)
 {
-	return mspro_block_disk_release(disk);
+	int ret;
+	lock_kernel();
+	ret = mspro_block_disk_release(disk);
+	unlock_kernel();
+	return ret;
 }
 
 static int mspro_block_bd_getgeo(struct block_device *bdev,
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index 1f3b080..5a9e477 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -578,6 +578,7 @@ static int i2o_block_open(struct block_device *bdev, fmode_t mode)
 	if (!dev->i2o_dev)
 		return -ENODEV;
 
+	lock_kernel();
 	if (dev->power > 0x1f)
 		i2o_block_device_power(dev, 0x02);
 
@@ -586,6 +587,7 @@ static int i2o_block_open(struct block_device *bdev, fmode_t mode)
 	i2o_block_device_lock(dev->i2o_dev, -1);
 
 	osm_debug("Ready.\n");
+	unlock_kernel();
 
 	return 0;
 };
@@ -616,6 +618,7 @@ static int i2o_block_release(struct gendisk *disk, fmode_t mode)
 	if (!dev->i2o_dev)
 		return 0;
 
+	lock_kernel();
 	i2o_block_device_flush(dev->i2o_dev);
 
 	i2o_block_device_unlock(dev->i2o_dev, -1);
@@ -626,6 +629,7 @@ static int i2o_block_release(struct gendisk *disk, fmode_t mode)
 		operation = 0x24;
 
 	i2o_block_device_power(dev, operation);
+	unlock_kernel();
 
 	return 0;
 }
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index cb9fbc8..8433cde 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -29,6 +29,7 @@
 #include <linux/kdev_t.h>
 #include <linux/blkdev.h>
 #include <linux/mutex.h>
+#include <linux/smp_lock.h>
 #include <linux/scatterlist.h>
 #include <linux/string_helpers.h>
 
@@ -107,6 +108,7 @@ static int mmc_blk_open(struct block_device *bdev, fmode_t mode)
 	struct mmc_blk_data *md = mmc_blk_get(bdev->bd_disk);
 	int ret = -ENXIO;
 
+	lock_kernel();
 	if (md) {
 		if (md->usage == 2)
 			check_disk_change(bdev);
@@ -117,6 +119,7 @@ static int mmc_blk_open(struct block_device *bdev, fmode_t mode)
 			ret = -EROFS;
 		}
 	}
+	unlock_kernel();
 
 	return ret;
 }
@@ -125,7 +128,9 @@ static int mmc_blk_release(struct gendisk *disk, fmode_t mode)
 {
 	struct mmc_blk_data *md = disk->private_data;
 
+	lock_kernel();
 	mmc_blk_put(md);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 3ddc95b..7133918 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -165,8 +165,9 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
 	int ret;
 
 	if (!dev)
-		return -ERESTARTSYS;
+		return -ERESTARTSYS; /* FIXME: busy loop! -arnd*/
 
+	lock_kernel();
 	mutex_lock(&dev->lock);
 
 	if (!dev->mtd) {
@@ -183,6 +184,7 @@ static int blktrans_open(struct block_device *bdev, fmode_t mode)
 unlock:
 	mutex_unlock(&dev->lock);
 	blktrans_dev_put(dev);
+	unlock_kernel();
 	return ret;
 }
 
@@ -194,6 +196,7 @@ static int blktrans_release(struct gendisk *disk, fmode_t mode)
 	if (!dev)
 		return ret;
 
+	lock_kernel();
 	mutex_lock(&dev->lock);
 
 	/* Release one reference, we sure its not the last one here*/
@@ -206,6 +209,7 @@ static int blktrans_release(struct gendisk *disk, fmode_t mode)
 unlock:
 	mutex_unlock(&dev->lock);
 	blktrans_dev_put(dev);
+	unlock_kernel();
 	return ret;
 }
 
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 33975e9..ae9da0d 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -21,6 +21,7 @@
 #include <linux/hdreg.h>
 #include <linux/async.h>
 #include <linux/mutex.h>
+#include <linux/smp_lock.h>
 
 #include <asm/ccwdev.h>
 #include <asm/ebcdic.h>
@@ -2235,6 +2236,7 @@ static int dasd_open(struct block_device *bdev, fmode_t mode)
 	if (!block)
 		return -ENODEV;
 
+	lock_kernel();
 	base = block->base;
 	atomic_inc(&block->open_count);
 	if (test_bit(DASD_FLAG_OFFLINE, &base->flags)) {
@@ -2269,12 +2271,14 @@ static int dasd_open(struct block_device *bdev, fmode_t mode)
 		goto out;
 	}
 
+	unlock_kernel();
 	return 0;
 
 out:
 	module_put(base->discipline->owner);
 unlock:
 	atomic_dec(&block->open_count);
+	unlock_kernel();
 	return rc;
 }
 
@@ -2282,8 +2286,10 @@ static int dasd_release(struct gendisk *disk, fmode_t mode)
 {
 	struct dasd_block *block = disk->private_data;
 
+	lock_kernel();
 	atomic_dec(&block->open_count);
 	module_put(block->base->discipline->owner);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index 9b43ae9..2bd72aa 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -14,6 +14,7 @@
 #include <linux/init.h>
 #include <linux/slab.h>
 #include <linux/blkdev.h>
+#include <linux/smp_lock.h>
 #include <linux/completion.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
@@ -775,6 +776,7 @@ dcssblk_open(struct block_device *bdev, fmode_t mode)
 	struct dcssblk_dev_info *dev_info;
 	int rc;
 
+	lock_kernel();
 	dev_info = bdev->bd_disk->private_data;
 	if (NULL == dev_info) {
 		rc = -ENODEV;
@@ -784,6 +786,7 @@ dcssblk_open(struct block_device *bdev, fmode_t mode)
 	bdev->bd_block_size = 4096;
 	rc = 0;
 out:
+	unlock_kernel();
 	return rc;
 }
 
@@ -794,6 +797,7 @@ dcssblk_release(struct gendisk *disk, fmode_t mode)
 	struct segment_info *entry;
 	int rc;
 
+	lock_kernel();
 	if (!dev_info) {
 		rc = -ENODEV;
 		goto out;
@@ -811,6 +815,7 @@ dcssblk_release(struct gendisk *disk, fmode_t mode)
 	up_write(&dcssblk_devices_sem);
 	rc = 0;
 out:
+	unlock_kernel();
 	return rc;
 }
 
diff --git a/drivers/s390/char/tape_block.c b/drivers/s390/char/tape_block.c
index 097da8c..b7de025 100644
--- a/drivers/s390/char/tape_block.c
+++ b/drivers/s390/char/tape_block.c
@@ -16,6 +16,7 @@
 #include <linux/fs.h>
 #include <linux/module.h>
 #include <linux/blkdev.h>
+#include <linux/smp_lock.h>
 #include <linux/interrupt.h>
 #include <linux/buffer_head.h>
 #include <linux/kernel.h>
@@ -361,6 +362,7 @@ tapeblock_open(struct block_device *bdev, fmode_t mode)
 	struct tape_device *	device;
 	int			rc;
 
+	lock_kernel();
 	device = tape_get_device(disk->private_data);
 
 	if (device->required_tapemarks) {
@@ -384,12 +386,14 @@ tapeblock_open(struct block_device *bdev, fmode_t mode)
 	 *       is called.
 	 */
 	tape_state_set(device, TS_BLKUSE);
+	unlock_kernel();
 	return 0;
 
 release:
 	tape_release(device);
  put_device:
 	tape_put_device(device);
+	unlock_kernel();
 	return rc;
 }
 
@@ -403,10 +407,12 @@ static int
 tapeblock_release(struct gendisk *disk, fmode_t mode)
 {
 	struct tape_device *device = disk->private_data;
-
+ 
+	lock_kernel();
 	tape_state_set(device, TS_IN_USE);
 	tape_release(device);
 	tape_put_device(device);
+	unlock_kernel();
 
 	return 0;
 }
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ac1284a..92702b3 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -758,6 +758,7 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_open\n"));
 
+	lock_kernel();
 	sdev = sdkp->device;
 
 	/*
@@ -801,10 +802,12 @@ static int sd_open(struct block_device *bdev, fmode_t mode)
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_PREVENT);
 	}
 
+	unlock_kernel();
 	return 0;
 
 error_out:
 	scsi_disk_put(sdkp);
+	unlock_kernel();
 	return retval;	
 }
 
@@ -826,6 +829,7 @@ static int sd_release(struct gendisk *disk, fmode_t mode)
 
 	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_release\n"));
 
+	lock_kernel();
 	if (!--sdkp->openers && sdev->removable) {
 		if (scsi_block_when_processing_errors(sdev))
 			scsi_set_medium_removal(sdev, SCSI_REMOVAL_ALLOW);
@@ -836,6 +840,7 @@ static int sd_release(struct gendisk *disk, fmode_t mode)
 	 * XXX is followed by a "rmmod sd_mod"?
 	 */
 	scsi_disk_put(sdkp);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index ad62aa8..906f8e7 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -467,22 +467,27 @@ static int sr_prep_fn(struct request_queue *q, struct request *rq)
 
 static int sr_block_open(struct block_device *bdev, fmode_t mode)
 {
-	struct scsi_cd *cd = scsi_cd_get(bdev->bd_disk);
+	struct scsi_cd *cd;
 	int ret = -ENXIO;
 
+	lock_kernel();
+	cd = scsi_cd_get(bdev->bd_disk);
 	if (cd) {
 		ret = cdrom_open(&cd->cdi, bdev, mode);
 		if (ret)
 			scsi_cd_put(cd);
 	}
+	unlock_kernel();
 	return ret;
 }
 
 static int sr_block_release(struct gendisk *disk, fmode_t mode)
 {
 	struct scsi_cd *cd = scsi_cd(disk);
+	lock_kernel();
 	cdrom_release(&cd->cdi, mode);
 	scsi_cd_put(cd);
+	unlock_kernel();
 	return 0;
 }
 
diff --git a/drivers/staging/hv/blkvsc_drv.c b/drivers/staging/hv/blkvsc_drv.c
index 61bd0be..d3947ca 100644
--- a/drivers/staging/hv/blkvsc_drv.c
+++ b/drivers/staging/hv/blkvsc_drv.c
@@ -25,6 +25,7 @@
 #include <linux/major.h>
 #include <linux/delay.h>
 #include <linux/hdreg.h>
+#include <linux/smp_lock.h>
 #include <linux/slab.h>
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -1324,6 +1325,7 @@ static int blkvsc_open(struct block_device *bdev, fmode_t mode)
 	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s\n", blkdev->users,
 		   blkdev->gd->disk_name);
 
+	lock_kernel();
 	spin_lock(&blkdev->lock);
 
 	if (!blkdev->users && blkdev->device_type == DVD_TYPE) {
@@ -1335,6 +1337,7 @@ static int blkvsc_open(struct block_device *bdev, fmode_t mode)
 	blkdev->users++;
 
 	spin_unlock(&blkdev->lock);
+	unlock_kernel();
 	return 0;
 }
 
@@ -1345,6 +1348,7 @@ static int blkvsc_release(struct gendisk *disk, fmode_t mode)
 	DPRINT_DBG(BLKVSC_DRV, "- users %d disk %s\n", blkdev->users,
 		   blkdev->gd->disk_name);
 
+	lock_kernel();
 	spin_lock(&blkdev->lock);
 	if (blkdev->users == 1) {
 		spin_unlock(&blkdev->lock);
@@ -1355,6 +1359,7 @@ static int blkvsc_release(struct gendisk *disk, fmode_t mode)
 	blkdev->users--;
 
 	spin_unlock(&blkdev->lock);
+	unlock_kernel();
 	return 0;
 }
 
-- 
1.7.1
