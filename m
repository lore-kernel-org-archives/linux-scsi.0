From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: MTD kobject warnings due to block layer changes
Date: Fri, 29 Aug 2008 17:19:56 +0900
Message-ID: <20080829171936Z.fujita.tomonori@lab.ntt.co.jp>
References: <20080829065029.GK20055@kernel.dk>
	<20080829165542L.fujita.tomonori@lab.ntt.co.jp>
	<20080829080123.GO20055@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
In-Reply-To: <20080829080123.GO20055@kernel.dk>
List-Unsubscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
	<mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
	<mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: linux-mtd-bounces@lists.infradead.org
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: jens.axboe@oracle.com
Cc: linux-scsi@vger.kernel.org, mano@roarinelk.homelinux.net, linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp, linux-ide@vger.kernel.org, linux-mtd@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 29 Aug 2008 10:01:24 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> What about eg ide-cd?

I'm always SCSI biased.


=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] remove blk_register_filter and blk_unregister_filter in gendisk

This patch remove blk_register_filter and blk_unregister_filter in
gendisk, and adds them to sd.c, sr.c. and ide-cd.c

The commit abf5439370491dd6fbb4fe1a7939680d2a9bc9d4 moved cmdfilter
from gendisk to request_queue. It turned out that in some subsystems
multiple gendisks share a single request_queue. So we get:

Using physmap partition information
Creating 3 MTD partitions on "physmap-flash":
0x00000000-0x01c00000 : "User FS"
0x01c00000-0x01c40000 : "booter"
kobject (8511c410): tried to init an initialized object, something is seriously wrong.
Call Trace:
[<8036644c>] dump_stack+0x8/0x34
[<8021f050>] kobject_init+0x50/0xcc
[<8021fa18>] kobject_init_and_add+0x24/0x58
[<8021d20c>] blk_register_filter+0x4c/0x64
[<8021c194>] add_disk+0x78/0xe0
[<8027d14c>] add_mtd_blktrans_dev+0x254/0x278
[<8027c8f0>] blktrans_notify_add+0x40/0x78
[<80279c00>] add_mtd_device+0xd0/0x150
[<8027b090>] add_mtd_partitions+0x568/0x5d8
[<80285458>] physmap_flash_probe+0x2ac/0x334
[<802644f8>] driver_probe_device+0x12c/0x244
[<8026465c>] __driver_attach+0x4c/0x84
[<80263c64>] bus_for_each_dev+0x58/0xac
[<802633ec>] bus_add_driver+0xc4/0x24c
[<802648e0>] driver_register+0xcc/0x184
[<80100460>] _stext+0x60/0x1bc

In the long term, we need to fix such subsystems but we need a quick
fix now. This patch add the command filter support to only sd and sr
though it might be useful for other SG_IO users (such as cciss).

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reported-by: Manuel Lauss <mano@roarinelk.homelinux.net>
Cc: Jens Axboe <jens.axboe@oracle.com>
---
 block/cmd-filter.c   |    3 ++-
 block/genhd.c        |    2 --
 drivers/ide/ide-cd.c |    2 ++
 drivers/scsi/sd.c    |    2 ++
 drivers/scsi/sr.c    |    2 ++
 5 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/cmd-filter.c b/block/cmd-filter.c
index 1d40262..228b644 100644
--- a/block/cmd-filter.c
+++ b/block/cmd-filter.c
@@ -223,6 +223,7 @@ int blk_register_filter(struct gendisk *disk)
 
 	return 0;
 }
+EXPORT_SYMBOL(blk_register_filter);
 
 void blk_unregister_filter(struct gendisk *disk)
 {
@@ -231,4 +232,4 @@ void blk_unregister_filter(struct gendisk *disk)
 	kobject_put(&filter->kobj);
 	kobject_put(disk->holder_dir->parent);
 }
-
+EXPORT_SYMBOL(blk_unregister_filter);
diff --git a/block/genhd.c b/block/genhd.c
index 656c2c7..d9743ff 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -190,7 +190,6 @@ void add_disk(struct gendisk *disk)
 			    disk->minors, NULL, exact_match, exact_lock, disk);
 	register_disk(disk);
 	blk_register_queue(disk);
-	blk_register_filter(disk);
 
 	bdi = &disk->queue->backing_dev_info;
 	bdi_register_dev(bdi, MKDEV(disk->major, disk->first_minor));
@@ -203,7 +202,6 @@ EXPORT_SYMBOL(del_gendisk);	/* in partitions/check.c */
 
 void unlink_gendisk(struct gendisk *disk)
 {
-	blk_unregister_filter(disk);
 	sysfs_remove_link(&disk->dev.kobj, "bdi");
 	bdi_unregister(&disk->queue->backing_dev_info);
 	blk_unregister_queue(disk);
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 49a8c58..f148999 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -1933,6 +1933,7 @@ static void ide_cd_remove(ide_drive_t *drive)
 
 	ide_proc_unregister_driver(drive, info->driver);
 
+	blk_unregister_filter(info->disk);
 	del_gendisk(info->disk);
 
 	ide_cd_put(info);
@@ -2158,6 +2159,7 @@ static int ide_cd_probe(ide_drive_t *drive)
 	g->fops = &idecd_ops;
 	g->flags |= GENHD_FL_REMOVABLE;
 	add_disk(g);
+	blk_register_filter(g);
 	return 0;
 
 out_free_cd:
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e5e7d78..2a2bc89 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1875,6 +1875,7 @@ static int sd_probe(struct device *dev)
 
 	dev_set_drvdata(dev, sdkp);
 	add_disk(gd);
+	blk_register_filter(gd);
 	sd_dif_config_host(sdkp);
 
 	sd_printk(KERN_NOTICE, sdkp, "Attached SCSI %sdisk\n",
@@ -1908,6 +1909,7 @@ static int sd_remove(struct device *dev)
 	struct scsi_disk *sdkp = dev_get_drvdata(dev);
 
 	device_del(&sdkp->dev);
+	blk_unregister_filter(sdkp->disk);
 	del_gendisk(sdkp->disk);
 	sd_shutdown(dev);
 
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 27f5bfd..3292965 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -656,6 +656,7 @@ static int sr_probe(struct device *dev)
 	dev_set_drvdata(dev, cd);
 	disk->flags |= GENHD_FL_REMOVABLE;
 	add_disk(disk);
+	blk_register_filter(disk);
 
 	sdev_printk(KERN_DEBUG, sdev,
 		    "Attached scsi CD-ROM %s\n", cd->cdi.name);
@@ -894,6 +895,7 @@ static int sr_remove(struct device *dev)
 {
 	struct scsi_cd *cd = dev_get_drvdata(dev);
 
+	blk_unregister_filter(cd->disk);
 	del_gendisk(cd->disk);
 
 	mutex_lock(&sr_ref_mutex);
-- 
1.5.5.GIT


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
