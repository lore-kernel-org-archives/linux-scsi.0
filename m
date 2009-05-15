From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 01/13] block: Do away with the notion of hardsect_size
Date: Fri, 15 May 2009 00:40:23 -0400
Message-ID: <1242362435-11953-2-git-send-email-martin.petersen@oracle.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Martin K. Petersen <martin.petersen@oracle.com>

Until now we have had a 1:1 mapping between storage device physical
block size and the logical block sized used when addressing the device.
With SATA 4KB drives coming out that will no longer be the case.  The
sector size will be 4KB but the logical block size will remain
512-bytes.  Hence we need to distinguish between the physical block size
and the logical ditto.

This patch renames hardsect_size to logical_block_size.


Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 arch/powerpc/sysdev/axonram.c       |    2 +-
 block/blk-integrity.c               |    2 +-
 block/blk-settings.c                |   21 ++++++++++-----------
 block/blk-sysfs.c                   |   12 +++++++++---
 block/compat_ioctl.c                |    2 +-
 block/ioctl.c                       |    2 +-
 drivers/block/cciss.c               |    6 +++---
 drivers/block/cpqarray.c            |    4 ++--
 drivers/block/hd.c                  |    2 +-
 drivers/block/mg_disk.c             |    2 +-
 drivers/block/pktcdvd.c             |    2 +-
 drivers/block/ps3disk.c             |    2 +-
 drivers/block/ub.c                  |    6 +++---
 drivers/block/virtio_blk.c          |    2 +-
 drivers/block/xen-blkfront.c        |    2 +-
 drivers/block/xsysace.c             |    2 +-
 drivers/cdrom/gdrom.c               |    2 +-
 drivers/cdrom/viocd.c               |    4 ++--
 drivers/char/raw.c                  |    2 +-
 drivers/ide/ide-cd.c                |   12 ++++++------
 drivers/md/bitmap.c                 |    4 ++--
 drivers/md/dm-exception-store.c     |    2 +-
 drivers/md/dm-log.c                 |    3 ++-
 drivers/md/dm-snap-persistent.c     |    2 +-
 drivers/md/dm-table.c               |   12 +++++++-----
 drivers/md/md.c                     |    2 +-
 drivers/memstick/core/mspro_block.c |    2 +-
 drivers/message/i2o/i2o_block.c     |    5 +++--
 drivers/mmc/card/block.c            |    2 +-
 drivers/mtd/mtd_blkdevs.c           |    2 +-
 drivers/s390/block/dasd.c           |    2 +-
 drivers/s390/block/dcssblk.c        |    2 +-
 drivers/s390/block/xpram.c          |    2 +-
 drivers/s390/char/tape_block.c      |    2 +-
 drivers/scsi/sd.c                   |    2 +-
 drivers/scsi/sr.c                   |    2 +-
 fs/bio.c                            |    3 ++-
 fs/block_dev.c                      |    6 +++---
 fs/buffer.c                         |    6 +++---
 fs/direct-io.c                      |    2 +-
 fs/ext3/super.c                     |    4 ++--
 fs/ext4/super.c                     |    2 +-
 fs/gfs2/ops_fstype.c                |    4 ++--
 fs/gfs2/rgrp.c                      |    2 +-
 fs/nilfs2/the_nilfs.c               |    2 +-
 fs/ntfs/super.c                     |    6 +++---
 fs/ocfs2/cluster/heartbeat.c        |    2 +-
 fs/ocfs2/super.c                    |    2 +-
 fs/partitions/ibm.c                 |    2 +-
 fs/partitions/msdos.c               |    4 ++--
 fs/udf/super.c                      |    2 +-
 fs/xfs/linux-2.6/xfs_buf.c          |    2 +-
 include/linux/blkdev.h              |   14 +++++++-------
 include/linux/device-mapper.h       |    2 +-
 54 files changed, 108 insertions(+), 98 deletions(-)

diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index 9e105cb..a477991 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -250,7 +250,7 @@ axon_ram_probe(struct of_device *device, const struct of_device_id *device_id)
 
 	set_capacity(bank->disk, bank->size >> AXON_RAM_SECTOR_SHIFT);
 	blk_queue_make_request(bank->disk->queue, axon_ram_make_request);
-	blk_queue_hardsect_size(bank->disk->queue, AXON_RAM_SECTOR_SIZE);
+	blk_queue_logical_block_size(bank->disk->queue, AXON_RAM_SECTOR_SIZE);
 	add_disk(bank->disk);
 
 	bank->irq_id = irq_of_parse_and_map(device->node, 0);
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index 91fa8e0..73e28d3 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -340,7 +340,7 @@ int blk_integrity_register(struct gendisk *disk, struct blk_integrity *template)
 		kobject_uevent(&bi->kobj, KOBJ_ADD);
 
 		bi->flags |= INTEGRITY_FLAG_READ | INTEGRITY_FLAG_WRITE;
-		bi->sector_size = disk->queue->hardsect_size;
+		bi->sector_size = queue_logical_block_size(disk->queue);
 		disk->integrity = bi;
 	} else
 		bi = disk->integrity;
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 57af728..15c3164 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -134,7 +134,7 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	q->backing_dev_info.state = 0;
 	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
 	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
-	blk_queue_hardsect_size(q, 512);
+	blk_queue_logical_block_size(q, 512);
 	blk_queue_dma_alignment(q, 511);
 	blk_queue_congestion_threshold(q);
 	q->nr_batching = BLK_BATCH_REQ;
@@ -288,21 +288,20 @@ void blk_queue_max_segment_size(struct request_queue *q, unsigned int max_size)
 EXPORT_SYMBOL(blk_queue_max_segment_size);
 
 /**
- * blk_queue_hardsect_size - set hardware sector size for the queue
+ * blk_queue_logical_block_size - set logical block size for the queue
  * @q:  the request queue for the device
- * @size:  the hardware sector size, in bytes
+ * @size:  the logical block size, in bytes
  *
  * Description:
- *   This should typically be set to the lowest possible sector size
- *   that the hardware can operate on (possible without reverting to
- *   even internal read-modify-write operations). Usually the default
- *   of 512 covers most hardware.
+ *   This should be set to the lowest possible block size that the
+ *   storage device can address.  The default of 512 covers most
+ *   hardware.
  **/
-void blk_queue_hardsect_size(struct request_queue *q, unsigned short size)
+void blk_queue_logical_block_size(struct request_queue *q, unsigned short size)
 {
-	q->hardsect_size = size;
+	q->logical_block_size = size;
 }
-EXPORT_SYMBOL(blk_queue_hardsect_size);
+EXPORT_SYMBOL(blk_queue_logical_block_size);
 
 /*
  * Returns the minimum that is _not_ zero, unless both are zero.
@@ -324,7 +323,7 @@ void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
 	t->max_phys_segments = min_not_zero(t->max_phys_segments, b->max_phys_segments);
 	t->max_hw_segments = min_not_zero(t->max_hw_segments, b->max_hw_segments);
 	t->max_segment_size = min_not_zero(t->max_segment_size, b->max_segment_size);
-	t->hardsect_size = max(t->hardsect_size, b->hardsect_size);
+	t->logical_block_size = max(t->logical_block_size, b->logical_block_size);
 	if (!t->queue_lock)
 		WARN_ON_ONCE(1);
 	else if (!test_bit(QUEUE_FLAG_CLUSTER, &b->queue_flags)) {
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 3ff9bba..13d38b7 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -100,9 +100,9 @@ static ssize_t queue_max_sectors_show(struct request_queue *q, char *page)
 	return queue_var_show(max_sectors_kb, (page));
 }
 
-static ssize_t queue_hw_sector_size_show(struct request_queue *q, char *page)
+static ssize_t queue_logical_block_size_show(struct request_queue *q, char *page)
 {
-	return queue_var_show(q->hardsect_size, page);
+	return queue_var_show(queue_logical_block_size(q), page);
 }
 
 static ssize_t
@@ -249,7 +249,12 @@ static struct queue_sysfs_entry queue_iosched_entry = {
 
 static struct queue_sysfs_entry queue_hw_sector_size_entry = {
 	.attr = {.name = "hw_sector_size", .mode = S_IRUGO },
-	.show = queue_hw_sector_size_show,
+	.show = queue_logical_block_size_show,
+};
+
+static struct queue_sysfs_entry queue_logical_block_size_entry = {
+	.attr = {.name = "logical_block_size", .mode = S_IRUGO },
+	.show = queue_logical_block_size_show,
 };
 
 static struct queue_sysfs_entry queue_nonrot_entry = {
@@ -283,6 +288,7 @@ static struct attribute *default_attrs[] = {
 	&queue_max_sectors_entry.attr,
 	&queue_iosched_entry.attr,
 	&queue_hw_sector_size_entry.attr,
+	&queue_logical_block_size_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index f87615d..9eaa194 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -763,7 +763,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case BLKBSZGET_32: /* get the logical block size (cf. BLKSSZGET) */
 		return compat_put_int(arg, block_size(bdev));
 	case BLKSSZGET: /* get block device hardware sector size */
-		return compat_put_int(arg, bdev_hardsect_size(bdev));
+		return compat_put_int(arg, bdev_logical_block_size(bdev));
 	case BLKSECTGET:
 		return compat_put_ushort(arg,
 					 bdev_get_queue(bdev)->max_sectors);
diff --git a/block/ioctl.c b/block/ioctl.c
index ad474d4..7aa97f6 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -311,7 +311,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKBSZGET: /* get the logical block size (cf. BLKSSZGET) */
 		return put_int(arg, block_size(bdev));
 	case BLKSSZGET: /* get block device hardware sector size */
-		return put_int(arg, bdev_hardsect_size(bdev));
+		return put_int(arg, bdev_logical_block_size(bdev));
 	case BLKSECTGET:
 		return put_ushort(arg, bdev_get_queue(bdev)->max_sectors);
 	case BLKRASET:
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index e714e7c..94474f5 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1389,8 +1389,8 @@ static void cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 
 	disk->queue->queuedata = h;
 
-	blk_queue_hardsect_size(disk->queue,
-				h->drv[drv_index].block_size);
+	blk_queue_logical_block_size(disk->queue,
+				     h->drv[drv_index].block_size);
 
 	/* Make sure all queue data is written out before */
 	/* setting h->drv[drv_index].queue, as setting this */
@@ -2298,7 +2298,7 @@ static int cciss_revalidate(struct gendisk *disk)
 	cciss_geometry_inquiry(h->ctlr, logvol, 1, total_size, block_size,
 			       inq_buff, drv);
 
-	blk_queue_hardsect_size(drv->queue, drv->block_size);
+	blk_queue_logical_block_size(drv->queue, drv->block_size);
 	set_capacity(disk, drv->nr_blocks);
 
 	kfree(inq_buff);
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index a02dcfc..44fa201 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -474,7 +474,7 @@ static int __init cpqarray_register_ctlr( int i, struct pci_dev *pdev)
 		disk->fops = &ida_fops;
 		if (j && !drv->nr_blks)
 			continue;
-		blk_queue_hardsect_size(hba[i]->queue, drv->blk_size);
+		blk_queue_logical_block_size(hba[i]->queue, drv->blk_size);
 		set_capacity(disk, drv->nr_blks);
 		disk->queue = hba[i]->queue;
 		disk->private_data = drv;
@@ -1546,7 +1546,7 @@ static int revalidate_allvol(ctlr_info_t *host)
 		drv_info_t *drv = &host->drv[i];
 		if (i && !drv->nr_blks)
 			continue;
-		blk_queue_hardsect_size(host->queue, drv->blk_size);
+		blk_queue_logical_block_size(host->queue, drv->blk_size);
 		set_capacity(disk, drv->nr_blks);
 		disk->queue = host->queue;
 		disk->private_data = drv;
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index 961de56..f65b3f3 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -724,7 +724,7 @@ static int __init hd_init(void)
 	blk_queue_max_sectors(hd_queue, 255);
 	init_timer(&device_timer);
 	device_timer.function = hd_times_out;
-	blk_queue_hardsect_size(hd_queue, 512);
+	blk_queue_logical_block_size(hd_queue, 512);
 
 	if (!NR_HD) {
 		/*
diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index c0cd0a0..60de5a0 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -996,7 +996,7 @@ static int mg_probe(struct platform_device *plat_dev)
 		goto probe_err_6;
 	}
 	blk_queue_max_sectors(host->breq, MG_MAX_SECTS);
-	blk_queue_hardsect_size(host->breq, MG_SECTOR_SIZE);
+	blk_queue_logical_block_size(host->breq, MG_SECTOR_SIZE);
 
 	init_timer(&host->timer);
 	host->timer.function = mg_times_out;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index dc7a8c3..293f585 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2657,7 +2657,7 @@ static void pkt_init_queue(struct pktcdvd_device *pd)
 	struct request_queue *q = pd->disk->queue;
 
 	blk_queue_make_request(q, pkt_make_request);
-	blk_queue_hardsect_size(q, CD_FRAMESIZE);
+	blk_queue_logical_block_size(q, CD_FRAMESIZE);
 	blk_queue_max_sectors(q, PACKET_MAX_SECTORS);
 	blk_queue_merge_bvec(q, pkt_merge_bvec);
 	q->queuedata = pd;
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 338cee4..aaeeb54 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -477,7 +477,7 @@ static int __devinit ps3disk_probe(struct ps3_system_bus_device *_dev)
 	blk_queue_max_sectors(queue, dev->bounce_size >> 9);
 	blk_queue_segment_boundary(queue, -1UL);
 	blk_queue_dma_alignment(queue, dev->blk_size-1);
-	blk_queue_hardsect_size(queue, dev->blk_size);
+	blk_queue_logical_block_size(queue, dev->blk_size);
 
 	blk_queue_ordered(queue, QUEUE_ORDERED_DRAIN_FLUSH,
 			  ps3disk_prepare_flush);
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index 178f459..917c161 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -723,7 +723,7 @@ static void ub_cmd_build_block(struct ub_dev *sc, struct ub_lun *lun,
 	/*
 	 * build the command
 	 *
-	 * The call to blk_queue_hardsect_size() guarantees that request
+	 * The call to blk_queue_logical_block_size() guarantees that request
 	 * is aligned, but it is given in terms of 512 byte units, always.
 	 */
 	block = blk_rq_pos(rq) >> lun->capacity.bshift;
@@ -1757,7 +1757,7 @@ static int ub_bd_revalidate(struct gendisk *disk)
 	ub_revalidate(lun->udev, lun);
 
 	/* XXX Support sector size switching like in sr.c */
-	blk_queue_hardsect_size(disk->queue, lun->capacity.bsize);
+	blk_queue_logical_block_size(disk->queue, lun->capacity.bsize);
 	set_capacity(disk, lun->capacity.nsec);
 	// set_disk_ro(sdkp->disk, lun->readonly);
 
@@ -2332,7 +2332,7 @@ static int ub_probe_lun(struct ub_dev *sc, int lnum)
 	blk_queue_max_phys_segments(q, UB_MAX_REQ_SG);
 	blk_queue_segment_boundary(q, 0xffffffff);	/* Dubious. */
 	blk_queue_max_sectors(q, UB_MAX_SECTORS);
-	blk_queue_hardsect_size(q, lun->capacity.bsize);
+	blk_queue_logical_block_size(q, lun->capacity.bsize);
 
 	lun->disk = disk;
 	q->queuedata = lun;
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 29a9daf..89603c4 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -313,7 +313,7 @@ static int virtblk_probe(struct virtio_device *vdev)
 				offsetof(struct virtio_blk_config, blk_size),
 				&blk_size);
 	if (!err)
-		blk_queue_hardsect_size(vblk->disk->queue, blk_size);
+		blk_queue_logical_block_size(vblk->disk->queue, blk_size);
 
 	add_disk(vblk->disk);
 	return 0;
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 6d4ac76..074b1b9 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -344,7 +344,7 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
 	queue_flag_set_unlocked(QUEUE_FLAG_VIRT, rq);
 
 	/* Hard sector size and max sectors impersonate the equiv. hardware. */
-	blk_queue_hardsect_size(rq, sector_size);
+	blk_queue_logical_block_size(rq, sector_size);
 	blk_queue_max_sectors(rq, 512);
 
 	/* Each segment in a request is up to an aligned page in size. */
diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
index 3a4397e..f08491a 100644
--- a/drivers/block/xsysace.c
+++ b/drivers/block/xsysace.c
@@ -984,7 +984,7 @@ static int __devinit ace_setup(struct ace_device *ace)
 	ace->queue = blk_init_queue(ace_request, &ace->lock);
 	if (ace->queue == NULL)
 		goto err_blk_initq;
-	blk_queue_hardsect_size(ace->queue, 512);
+	blk_queue_logical_block_size(ace->queue, 512);
 
 	/*
 	 * Allocate and initialize GD structure
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index 1e366ad..b5621f2 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -739,7 +739,7 @@ static void __devinit probe_gdrom_setupdisk(void)
 
 static int __devinit probe_gdrom_setupqueue(void)
 {
-	blk_queue_hardsect_size(gd.gdrom_rq, GDROM_HARD_SECTOR);
+	blk_queue_logical_block_size(gd.gdrom_rq, GDROM_HARD_SECTOR);
 	/* using DMA so memory will need to be contiguous */
 	blk_queue_max_hw_segments(gd.gdrom_rq, 1);
 	/* set a large max size to get most from DMA */
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index ca741c2..fb11651 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -469,8 +469,8 @@ static void vio_handle_cd_event(struct HvLpEvent *event)
 	case viocdopen:
 		if (event->xRc == 0) {
 			di = &viocd_diskinfo[bevent->disk];
-			blk_queue_hardsect_size(di->viocd_disk->queue,
-					bevent->block_size);
+			blk_queue_logical_block_size(di->viocd_disk->queue,
+						     bevent->block_size);
 			set_capacity(di->viocd_disk,
 					bevent->media_size *
 					bevent->block_size / 512);
diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 20d90e6..db32f0e 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -71,7 +71,7 @@ static int raw_open(struct inode *inode, struct file *filp)
 	err = bd_claim(bdev, raw_open);
 	if (err)
 		goto out1;
-	err = set_blocksize(bdev, bdev_hardsect_size(bdev));
+	err = set_blocksize(bdev, bdev_logical_block_size(bdev));
 	if (err)
 		goto out2;
 	filp->f_flags |= O_DIRECT;
diff --git a/drivers/ide/ide-cd.c b/drivers/ide/ide-cd.c
index 4c7792f..03b43e0 100644
--- a/drivers/ide/ide-cd.c
+++ b/drivers/ide/ide-cd.c
@@ -182,7 +182,7 @@ static void cdrom_analyze_sense_data(ide_drive_t *drive,
 				 (sense->information[2] <<  8) |
 				 (sense->information[3]);
 
-			if (drive->queue->hardsect_size == 2048)
+			if (queue_logical_block_size(drive->queue) == 2048)
 				/* device sector size is 2K */
 				sector <<= 2;
 
@@ -738,7 +738,7 @@ static ide_startstop_t cdrom_start_rw(ide_drive_t *drive, struct request *rq)
 	struct request_queue *q = drive->queue;
 	int write = rq_data_dir(rq) == WRITE;
 	unsigned short sectors_per_frame =
-		queue_hardsect_size(q) >> SECTOR_BITS;
+		queue_logical_block_size(q) >> SECTOR_BITS;
 
 	ide_debug_log(IDE_DBG_RQ, "rq->cmd[0]: 0x%x, rq->cmd_flags: 0x%x, "
 				  "secs_per_frame: %u",
@@ -1022,8 +1022,8 @@ int ide_cd_read_toc(ide_drive_t *drive, struct request_sense *sense)
 	/* save a private copy of the TOC capacity for error handling */
 	drive->probed_capacity = toc->capacity * sectors_per_frame;
 
-	blk_queue_hardsect_size(drive->queue,
-				sectors_per_frame << SECTOR_BITS);
+	blk_queue_logical_block_size(drive->queue,
+				     sectors_per_frame << SECTOR_BITS);
 
 	/* first read just the header, so we know how long the TOC is */
 	stat = cdrom_read_tocentry(drive, 0, 1, 0, (char *) &toc->hdr,
@@ -1339,7 +1339,7 @@ static int ide_cdrom_probe_capabilities(ide_drive_t *drive)
 /* standard prep_rq_fn that builds 10 byte cmds */
 static int ide_cdrom_prep_fs(struct request_queue *q, struct request *rq)
 {
-	int hard_sect = queue_hardsect_size(q);
+	int hard_sect = queue_logical_block_size(q);
 	long block = (long)blk_rq_pos(rq) / (hard_sect >> 9);
 	unsigned long blocks = blk_rq_sectors(rq) / (hard_sect >> 9);
 
@@ -1544,7 +1544,7 @@ static int ide_cdrom_setup(ide_drive_t *drive)
 
 	nslots = ide_cdrom_probe_capabilities(drive);
 
-	blk_queue_hardsect_size(q, CD_FRAMESIZE);
+	blk_queue_logical_block_size(q, CD_FRAMESIZE);
 
 	if (ide_cdrom_register(drive, nslots)) {
 		printk(KERN_ERR PFX "%s: %s failed to register device with the"
diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
index 1fb91ed..4f7e985 100644
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -232,7 +232,7 @@ static struct page *read_sb_page(mddev_t *mddev, long offset,
 		target = rdev->sb_start + offset + index * (PAGE_SIZE/512);
 
 		if (sync_page_io(rdev->bdev, target,
-				 roundup(size, bdev_hardsect_size(rdev->bdev)),
+				 roundup(size, bdev_logical_block_size(rdev->bdev)),
 				 page, READ)) {
 			page->index = index;
 			attach_page_buffers(page, NULL); /* so that free_buffer will
@@ -287,7 +287,7 @@ static int write_sb_page(struct bitmap *bitmap, struct page *page, int wait)
 			int size = PAGE_SIZE;
 			if (page->index == bitmap->file_pages-1)
 				size = roundup(bitmap->last_page_size,
-					       bdev_hardsect_size(rdev->bdev));
+					       bdev_logical_block_size(rdev->bdev));
 			/* Just make sure we aren't corrupting data or
 			 * metadata
 			 */
diff --git a/drivers/md/dm-exception-store.c b/drivers/md/dm-exception-store.c
index a2e26c2..75d8081 100644
--- a/drivers/md/dm-exception-store.c
+++ b/drivers/md/dm-exception-store.c
@@ -178,7 +178,7 @@ static int set_chunk_size(struct dm_exception_store *store,
 	}
 
 	/* Validate the chunk size against the device block size */
-	if (chunk_size_ulong % (bdev_hardsect_size(store->cow->bdev) >> 9)) {
+	if (chunk_size_ulong % (bdev_logical_block_size(store->cow->bdev) >> 9)) {
 		*error = "Chunk size is not a multiple of device blocksize";
 		return -EINVAL;
 	}
diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index be233bc..6fa8ccf 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -413,7 +413,8 @@ static int create_log_context(struct dm_dirty_log *log, struct dm_target *ti,
 		 * Buffer holds both header and bitset.
 		 */
 		buf_size = dm_round_up((LOG_OFFSET << SECTOR_SHIFT) +
-				       bitset_size, ti->limits.hardsect_size);
+				       bitset_size,
+				       ti->limits.logical_block_size);
 
 		if (buf_size > dev->bdev->bd_inode->i_size) {
 			DMWARN("log device %s too small: need %llu bytes",
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index e75c6dd..2662a41 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -282,7 +282,7 @@ static int read_header(struct pstore *ps, int *new_snapshot)
 	 */
 	if (!ps->store->chunk_size) {
 		ps->store->chunk_size = max(DM_CHUNK_SIZE_DEFAULT_SECTORS,
-		    bdev_hardsect_size(ps->store->cow->bdev) >> 9);
+		    bdev_logical_block_size(ps->store->cow->bdev) >> 9);
 		ps->store->chunk_mask = ps->store->chunk_size - 1;
 		ps->store->chunk_shift = ffs(ps->store->chunk_size) - 1;
 		chunk_size_supplied = 0;
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 429b50b..65e2d97 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -108,7 +108,8 @@ static void combine_restrictions_low(struct io_restrictions *lhs,
 	lhs->max_hw_segments =
 		min_not_zero(lhs->max_hw_segments, rhs->max_hw_segments);
 
-	lhs->hardsect_size = max(lhs->hardsect_size, rhs->hardsect_size);
+	lhs->logical_block_size = max(lhs->logical_block_size,
+				      rhs->logical_block_size);
 
 	lhs->max_segment_size =
 		min_not_zero(lhs->max_segment_size, rhs->max_segment_size);
@@ -529,7 +530,8 @@ void dm_set_device_limits(struct dm_target *ti, struct block_device *bdev)
 	rs->max_hw_segments =
 		min_not_zero(rs->max_hw_segments, q->max_hw_segments);
 
-	rs->hardsect_size = max(rs->hardsect_size, q->hardsect_size);
+	rs->logical_block_size = max(rs->logical_block_size,
+				     queue_logical_block_size(q));
 
 	rs->max_segment_size =
 		min_not_zero(rs->max_segment_size, q->max_segment_size);
@@ -683,8 +685,8 @@ static void check_for_valid_limits(struct io_restrictions *rs)
 		rs->max_phys_segments = MAX_PHYS_SEGMENTS;
 	if (!rs->max_hw_segments)
 		rs->max_hw_segments = MAX_HW_SEGMENTS;
-	if (!rs->hardsect_size)
-		rs->hardsect_size = 1 << SECTOR_SHIFT;
+	if (!rs->logical_block_size)
+		rs->logical_block_size = 1 << SECTOR_SHIFT;
 	if (!rs->max_segment_size)
 		rs->max_segment_size = MAX_SEGMENT_SIZE;
 	if (!rs->seg_boundary_mask)
@@ -914,7 +916,7 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
 	blk_queue_max_sectors(q, t->limits.max_sectors);
 	q->max_phys_segments = t->limits.max_phys_segments;
 	q->max_hw_segments = t->limits.max_hw_segments;
-	q->hardsect_size = t->limits.hardsect_size;
+	q->logical_block_size = t->limits.logical_block_size;
 	q->max_segment_size = t->limits.max_segment_size;
 	q->max_hw_sectors = t->limits.max_hw_sectors;
 	q->seg_boundary_mask = t->limits.seg_boundary_mask;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 612343f..7f9d58f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -1202,7 +1202,7 @@ static int super_1_load(mdk_rdev_t *rdev, mdk_rdev_t *refdev, int minor_version)
 	atomic_set(&rdev->corrected_errors, le32_to_cpu(sb->cnt_corrected_read));
 
 	rdev->sb_size = le32_to_cpu(sb->max_dev) * 2 + 256;
-	bmask = queue_hardsect_size(rdev->bdev->bd_disk->queue)-1;
+	bmask = queue_logical_block_size(rdev->bdev->bd_disk->queue)-1;
 	if (rdev->sb_size & bmask)
 		rdev->sb_size = (rdev->sb_size | bmask) + 1;
 
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index c0bebc6..7847bbc 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1242,7 +1242,7 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 
 	sprintf(msb->disk->disk_name, "mspblk%d", disk_id);
 
-	blk_queue_hardsect_size(msb->queue, msb->page_size);
+	blk_queue_logical_block_size(msb->queue, msb->page_size);
 
 	capacity = be16_to_cpu(sys_info->user_block_count);
 	capacity *= be16_to_cpu(sys_info->block_size);
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index 6573ef4..335d4c7 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -794,8 +794,9 @@ static int i2o_block_transfer(struct request *req)
 	if (c->adaptec) {
 		u8 cmd[10];
 		u32 scsi_flags;
-		u16 hwsec = queue_hardsect_size(req->q) >> KERNEL_SECTOR_SHIFT;
+		u16 hwsec;
 
+		hwsec = queue_logical_block_size(req->q) >> KERNEL_SECTOR_SHIFT;
 		memset(cmd, 0, 10);
 
 		sgl_offset = SGL_OFFSET_12;
@@ -1078,7 +1079,7 @@ static int i2o_block_probe(struct device *dev)
 	 */
 	if (!i2o_parm_field_get(i2o_dev, 0x0004, 1, &blocksize, 4) ||
 	    !i2o_parm_field_get(i2o_dev, 0x0000, 3, &blocksize, 4)) {
-		blk_queue_hardsect_size(queue, le32_to_cpu(blocksize));
+		blk_queue_logical_block_size(queue, le32_to_cpu(blocksize));
 	} else
 		osm_warn("unable to get blocksize of %s\n", gd->disk_name);
 
diff --git a/drivers/mmc/card/block.c b/drivers/mmc/card/block.c
index 949e997..2f6703d 100644
--- a/drivers/mmc/card/block.c
+++ b/drivers/mmc/card/block.c
@@ -513,7 +513,7 @@ static struct mmc_blk_data *mmc_blk_alloc(struct mmc_card *card)
 
 	sprintf(md->disk->disk_name, "mmcblk%d", devidx);
 
-	blk_queue_hardsect_size(md->queue.queue, 512);
+	blk_queue_logical_block_size(md->queue.queue, 512);
 
 	if (!mmc_card_sd(card) && mmc_card_blockaddr(card)) {
 		/*
diff --git a/drivers/mtd/mtd_blkdevs.c b/drivers/mtd/mtd_blkdevs.c
index 502622f..aaac3b6 100644
--- a/drivers/mtd/mtd_blkdevs.c
+++ b/drivers/mtd/mtd_blkdevs.c
@@ -378,7 +378,7 @@ int register_mtd_blktrans(struct mtd_blktrans_ops *tr)
 	}
 
 	tr->blkcore_priv->rq->queuedata = tr;
-	blk_queue_hardsect_size(tr->blkcore_priv->rq, tr->blksize);
+	blk_queue_logical_block_size(tr->blkcore_priv->rq, tr->blksize);
 	if (tr->discard)
 		blk_queue_set_discard(tr->blkcore_priv->rq,
 				      blktrans_discard_request);
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index e64f62d..27a1be0 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1990,7 +1990,7 @@ static void dasd_setup_queue(struct dasd_block *block)
 {
 	int max;
 
-	blk_queue_hardsect_size(block->request_queue, block->bp_block);
+	blk_queue_logical_block_size(block->request_queue, block->bp_block);
 	max = block->base->discipline->max_blocks << block->s2b_shift;
 	blk_queue_max_sectors(block->request_queue, max);
 	blk_queue_max_phys_segments(block->request_queue, -1L);
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index cfdcf1a..a4c7ffc 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -602,7 +602,7 @@ dcssblk_add_store(struct device *dev, struct device_attribute *attr, const char
 	dev_info->gd->private_data = dev_info;
 	dev_info->gd->driverfs_dev = &dev_info->dev;
 	blk_queue_make_request(dev_info->dcssblk_queue, dcssblk_make_request);
-	blk_queue_hardsect_size(dev_info->dcssblk_queue, 4096);
+	blk_queue_logical_block_size(dev_info->dcssblk_queue, 4096);
 
 	seg_byte_size = (dev_info->end - dev_info->start + 1);
 	set_capacity(dev_info->gd, seg_byte_size >> 9); // size in sectors
diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index 76814f3..0ae0c83 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -343,7 +343,7 @@ static int __init xpram_setup_blkdev(void)
 			goto out;
 		}
 		blk_queue_make_request(xpram_queues[i], xpram_make_request);
-		blk_queue_hardsect_size(xpram_queues[i], 4096);
+		blk_queue_logical_block_size(xpram_queues[i], 4096);
 	}
 
 	/*
diff --git a/drivers/s390/char/tape_block.c b/drivers/s390/char/tape_block.c
index 1e79676..47ff695 100644
--- a/drivers/s390/char/tape_block.c
+++ b/drivers/s390/char/tape_block.c
@@ -222,7 +222,7 @@ tapeblock_setup_device(struct tape_device * device)
 	if (rc)
 		goto cleanup_queue;
 
-	blk_queue_hardsect_size(blkdat->request_queue, TAPEBLOCK_HSEC_SIZE);
+	blk_queue_logical_block_size(blkdat->request_queue, TAPEBLOCK_HSEC_SIZE);
 	blk_queue_max_sectors(blkdat->request_queue, TAPEBLOCK_MAX_SEC);
 	blk_queue_max_phys_segments(blkdat->request_queue, -1L);
 	blk_queue_max_hw_segments(blkdat->request_queue, -1L);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 70c4dd9..c3afcae 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1515,7 +1515,7 @@ got_data:
 		 */
 		sector_size = 512;
 	}
-	blk_queue_hardsect_size(sdp->request_queue, sector_size);
+	blk_queue_logical_block_size(sdp->request_queue, sector_size);
 
 	{
 		char cap_str_2[10], cap_str_10[10];
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index fddba53..cd350df 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -727,7 +727,7 @@ static void get_sectorsize(struct scsi_cd *cd)
 	}
 
 	queue = cd->device->request_queue;
-	blk_queue_hardsect_size(queue, sector_size);
+	blk_queue_logical_block_size(queue, sector_size);
 
 	return;
 }
diff --git a/fs/bio.c b/fs/bio.c
index 7bbc98f..28f9f17 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -1487,11 +1487,12 @@ struct bio_pair *bio_split(struct bio *bi, int first_sectors)
 sector_t bio_sector_offset(struct bio *bio, unsigned short index,
 			   unsigned int offset)
 {
-	unsigned int sector_sz = queue_hardsect_size(bio->bi_bdev->bd_disk->queue);
+	unsigned int sector_sz;
 	struct bio_vec *bv;
 	sector_t sectors;
 	int i;
 
+	sector_sz = queue_logical_block_size(bio->bi_bdev->bd_disk->queue);
 	sectors = 0;
 
 	if (index >= bio->bi_idx)
diff --git a/fs/block_dev.c b/fs/block_dev.c
index a85fe31..a29b4dc 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -76,7 +76,7 @@ int set_blocksize(struct block_device *bdev, int size)
 		return -EINVAL;
 
 	/* Size cannot be smaller than the size supported by the device */
-	if (size < bdev_hardsect_size(bdev))
+	if (size < bdev_logical_block_size(bdev))
 		return -EINVAL;
 
 	/* Don't change the size if it is same as current */
@@ -106,7 +106,7 @@ EXPORT_SYMBOL(sb_set_blocksize);
 
 int sb_min_blocksize(struct super_block *sb, int size)
 {
-	int minsize = bdev_hardsect_size(sb->s_bdev);
+	int minsize = bdev_logical_block_size(sb->s_bdev);
 	if (size < minsize)
 		size = minsize;
 	return sb_set_blocksize(sb, size);
@@ -1117,7 +1117,7 @@ EXPORT_SYMBOL(check_disk_change);
 
 void bd_set_size(struct block_device *bdev, loff_t size)
 {
-	unsigned bsize = bdev_hardsect_size(bdev);
+	unsigned bsize = bdev_logical_block_size(bdev);
 
 	bdev->bd_inode->i_size = size;
 	while (bsize < PAGE_CACHE_SIZE) {
diff --git a/fs/buffer.c b/fs/buffer.c
index b3e5be7..405086a 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1085,12 +1085,12 @@ static struct buffer_head *
 __getblk_slow(struct block_device *bdev, sector_t block, int size)
 {
 	/* Size must be multiple of hard sectorsize */
-	if (unlikely(size & (bdev_hardsect_size(bdev)-1) ||
+	if (unlikely(size & (bdev_logical_block_size(bdev)-1) ||
 			(size < 512 || size > PAGE_SIZE))) {
 		printk(KERN_ERR "getblk(): invalid block size %d requested\n",
 					size);
-		printk(KERN_ERR "hardsect size: %d\n",
-					bdev_hardsect_size(bdev));
+		printk(KERN_ERR "logical block size: %d\n",
+					bdev_logical_block_size(bdev));
 
 		dump_stack();
 		return NULL;
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 05763bb..8b10b87 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -1127,7 +1127,7 @@ __blockdev_direct_IO(int rw, struct kiocb *iocb, struct inode *inode,
 		rw = WRITE_ODIRECT;
 
 	if (bdev)
-		bdev_blkbits = blksize_bits(bdev_hardsect_size(bdev));
+		bdev_blkbits = blksize_bits(bdev_logical_block_size(bdev));
 
 	if (offset & blocksize_mask) {
 		if (bdev)
diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index 599dbfe..acbb94f 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -1696,7 +1696,7 @@ static int ext3_fill_super (struct super_block *sb, void *data, int silent)
 		goto failed_mount;
 	}
 
-	hblock = bdev_hardsect_size(sb->s_bdev);
+	hblock = bdev_logical_block_size(sb->s_bdev);
 	if (sb->s_blocksize != blocksize) {
 		/*
 		 * Make sure the blocksize for the filesystem is larger
@@ -2119,7 +2119,7 @@ static journal_t *ext3_get_dev_journal(struct super_block *sb,
 	}
 
 	blocksize = sb->s_blocksize;
-	hblock = bdev_hardsect_size(bdev);
+	hblock = bdev_logical_block_size(bdev);
 	if (blocksize < hblock) {
 		printk(KERN_ERR
 			"EXT3-fs: blocksize too small for journal device.\n");
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 2958f4e..a30549f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -2962,7 +2962,7 @@ static journal_t *ext4_get_dev_journal(struct super_block *sb,
 	}
 
 	blocksize = sb->s_blocksize;
-	hblock = bdev_hardsect_size(bdev);
+	hblock = bdev_logical_block_size(bdev);
 	if (blocksize < hblock) {
 		printk(KERN_ERR
 			"EXT4-fs: blocksize too small for journal device.\n");
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 650a730..5e53716 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -526,11 +526,11 @@ static int init_sb(struct gfs2_sbd *sdp, int silent)
 	}
 
 	/* Set up the buffer cache and SB for real */
-	if (sdp->sd_sb.sb_bsize < bdev_hardsect_size(sb->s_bdev)) {
+	if (sdp->sd_sb.sb_bsize < bdev_logical_block_size(sb->s_bdev)) {
 		ret = -EINVAL;
 		fs_err(sdp, "FS block size (%u) is too small for device "
 		       "block size (%u)\n",
-		       sdp->sd_sb.sb_bsize, bdev_hardsect_size(sb->s_bdev));
+		       sdp->sd_sb.sb_bsize, bdev_logical_block_size(sb->s_bdev));
 		goto out;
 	}
 	if (sdp->sd_sb.sb_bsize > PAGE_SIZE) {
diff --git a/fs/gfs2/rgrp.c b/fs/gfs2/rgrp.c
index 5650382..a971d24 100644
--- a/fs/gfs2/rgrp.c
+++ b/fs/gfs2/rgrp.c
@@ -845,7 +845,7 @@ static void gfs2_rgrp_send_discards(struct gfs2_sbd *sdp, u64 offset,
 	struct super_block *sb = sdp->sd_vfs;
 	struct block_device *bdev = sb->s_bdev;
 	const unsigned int sects_per_blk = sdp->sd_sb.sb_bsize /
-					   bdev_hardsect_size(sb->s_bdev);
+					   bdev_logical_block_size(sb->s_bdev);
 	u64 blk;
 	sector_t start = 0;
 	sector_t nr_sects = 0;
diff --git a/fs/nilfs2/the_nilfs.c b/fs/nilfs2/the_nilfs.c
index 7f65b3b..a91f15b 100644
--- a/fs/nilfs2/the_nilfs.c
+++ b/fs/nilfs2/the_nilfs.c
@@ -515,7 +515,7 @@ int init_nilfs(struct the_nilfs *nilfs, struct nilfs_sb_info *sbi, char *data)
 
 	blocksize = BLOCK_SIZE << le32_to_cpu(sbp->s_log_block_size);
 	if (sb->s_blocksize != blocksize) {
-		int hw_blocksize = bdev_hardsect_size(sb->s_bdev);
+		int hw_blocksize = bdev_logical_block_size(sb->s_bdev);
 
 		if (blocksize < hw_blocksize) {
 			printk(KERN_ERR
diff --git a/fs/ntfs/super.c b/fs/ntfs/super.c
index f76951d..6aa7c47 100644
--- a/fs/ntfs/super.c
+++ b/fs/ntfs/super.c
@@ -25,7 +25,7 @@
 #include <linux/slab.h>
 #include <linux/string.h>
 #include <linux/spinlock.h>
-#include <linux/blkdev.h>	/* For bdev_hardsect_size(). */
+#include <linux/blkdev.h>	/* For bdev_logical_block_size(). */
 #include <linux/backing-dev.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
@@ -2785,13 +2785,13 @@ static int ntfs_fill_super(struct super_block *sb, void *opt, const int silent)
 		goto err_out_now;
 
 	/* We support sector sizes up to the PAGE_CACHE_SIZE. */
-	if (bdev_hardsect_size(sb->s_bdev) > PAGE_CACHE_SIZE) {
+	if (bdev_logical_block_size(sb->s_bdev) > PAGE_CACHE_SIZE) {
 		if (!silent)
 			ntfs_error(sb, "Device has unsupported sector size "
 					"(%i).  The maximum supported sector "
 					"size on this architecture is %lu "
 					"bytes.",
-					bdev_hardsect_size(sb->s_bdev),
+					bdev_logical_block_size(sb->s_bdev),
 					PAGE_CACHE_SIZE);
 		goto err_out_now;
 	}
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 4f85ece..09cc25d 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1371,7 +1371,7 @@ static ssize_t o2hb_region_dev_write(struct o2hb_region *reg,
 
 	bdevname(reg->hr_bdev, reg->hr_dev_name);
 
-	sectsize = bdev_hardsect_size(reg->hr_bdev);
+	sectsize = bdev_logical_block_size(reg->hr_bdev);
 	if (sectsize != reg->hr_block_bytes) {
 		mlog(ML_ERROR,
 		     "blocksize %u incorrect for device, expected %d",
diff --git a/fs/ocfs2/super.c b/fs/ocfs2/super.c
index 79ff8d9..5c6163f 100644
--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -713,7 +713,7 @@ static int ocfs2_sb_probe(struct super_block *sb,
 	*bh = NULL;
 
 	/* may be > 512 */
-	*sector_size = bdev_hardsect_size(sb->s_bdev);
+	*sector_size = bdev_logical_block_size(sb->s_bdev);
 	if (*sector_size > OCFS2_MAX_BLOCKSIZE) {
 		mlog(ML_ERROR, "Hardware sector size too large: %d (max=%d)\n",
 		     *sector_size, OCFS2_MAX_BLOCKSIZE);
diff --git a/fs/partitions/ibm.c b/fs/partitions/ibm.c
index 4629768..fc71aab 100644
--- a/fs/partitions/ibm.c
+++ b/fs/partitions/ibm.c
@@ -76,7 +76,7 @@ ibm_partition(struct parsed_partitions *state, struct block_device *bdev)
 	Sector sect;
 
 	res = 0;
-	blocksize = bdev_hardsect_size(bdev);
+	blocksize = bdev_logical_block_size(bdev);
 	if (blocksize <= 0)
 		goto out_exit;
 	i_size = i_size_read(bdev->bd_inode);
diff --git a/fs/partitions/msdos.c b/fs/partitions/msdos.c
index 7965118..0028d2e 100644
--- a/fs/partitions/msdos.c
+++ b/fs/partitions/msdos.c
@@ -110,7 +110,7 @@ parse_extended(struct parsed_partitions *state, struct block_device *bdev,
 	Sector sect;
 	unsigned char *data;
 	u32 this_sector, this_size;
-	int sector_size = bdev_hardsect_size(bdev) / 512;
+	int sector_size = bdev_logical_block_size(bdev) / 512;
 	int loopct = 0;		/* number of links followed
 				   without finding a data partition */
 	int i;
@@ -415,7 +415,7 @@ static struct {
  
 int msdos_partition(struct parsed_partitions *state, struct block_device *bdev)
 {
-	int sector_size = bdev_hardsect_size(bdev) / 512;
+	int sector_size = bdev_logical_block_size(bdev) / 512;
 	Sector sect;
 	unsigned char *data;
 	struct partition *p;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 72348cc..0ba4410 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -1915,7 +1915,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	if (uopt.flags & (1 << UDF_FLAG_BLOCKSIZE_SET)) {
 		ret = udf_load_vrs(sb, &uopt, silent, &fileset);
 	} else {
-		uopt.blocksize = bdev_hardsect_size(sb->s_bdev);
+		uopt.blocksize = bdev_logical_block_size(sb->s_bdev);
 		ret = udf_load_vrs(sb, &uopt, silent, &fileset);
 		if (!ret && uopt.blocksize != UDF_DEFAULT_BLOCKSIZE) {
 			if (!silent)
diff --git a/fs/xfs/linux-2.6/xfs_buf.c b/fs/xfs/linux-2.6/xfs_buf.c
index e28800a..1418b91 100644
--- a/fs/xfs/linux-2.6/xfs_buf.c
+++ b/fs/xfs/linux-2.6/xfs_buf.c
@@ -1501,7 +1501,7 @@ xfs_setsize_buftarg_early(
 	struct block_device	*bdev)
 {
 	return xfs_setsize_buftarg_flags(btp,
-			PAGE_CACHE_SIZE, bdev_hardsect_size(bdev), 0);
+			PAGE_CACHE_SIZE, bdev_logical_block_size(bdev), 0);
 }
 
 int
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f9d60a7..85c7f7d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -391,7 +391,7 @@ struct request_queue
 	unsigned int		max_hw_sectors;
 	unsigned short		max_phys_segments;
 	unsigned short		max_hw_segments;
-	unsigned short		hardsect_size;
+	unsigned short		logical_block_size;
 	unsigned int		max_segment_size;
 
 	unsigned long		seg_boundary_mask;
@@ -899,7 +899,7 @@ extern void blk_queue_max_sectors(struct request_queue *, unsigned int);
 extern void blk_queue_max_phys_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_hw_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
-extern void blk_queue_hardsect_size(struct request_queue *, unsigned short);
+extern void blk_queue_logical_block_size(struct request_queue *, unsigned short);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
 extern void blk_queue_dma_pad(struct request_queue *, unsigned int);
 extern void blk_queue_update_dma_pad(struct request_queue *, unsigned int);
@@ -986,19 +986,19 @@ extern void blk_set_cmd_filter_defaults(struct blk_cmd_filter *filter);
 
 #define blkdev_entry_to_request(entry) list_entry((entry), struct request, queuelist)
 
-static inline int queue_hardsect_size(struct request_queue *q)
+static inline unsigned short queue_logical_block_size(struct request_queue *q)
 {
 	int retval = 512;
 
-	if (q && q->hardsect_size)
-		retval = q->hardsect_size;
+	if (q && q->logical_block_size)
+		retval = q->logical_block_size;
 
 	return retval;
 }
 
-static inline int bdev_hardsect_size(struct block_device *bdev)
+static inline unsigned short bdev_logical_block_size(struct block_device *bdev)
 {
-	return queue_hardsect_size(bdev_get_queue(bdev));
+	return queue_logical_block_size(bdev_get_queue(bdev));
 }
 
 static inline int queue_dma_alignment(struct request_queue *q)
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index ded2d7c..49c2362 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -149,7 +149,7 @@ struct io_restrictions {
 	unsigned max_hw_sectors;
 	unsigned max_sectors;
 	unsigned max_segment_size;
-	unsigned short hardsect_size;
+	unsigned short logical_block_size;
 	unsigned short max_hw_segments;
 	unsigned short max_phys_segments;
 	unsigned char no_cluster; /* inverted so that 0 is default */
-- 
1.6.0.6

