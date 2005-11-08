From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/10] seperate max sectors and max hw sectors
Date: Tue, 08 Nov 2005 04:06:35 -0600
Message-ID: <1131444395.23111.62.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:6559 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932499AbVKHKG6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2005 05:06:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@suse.de, linux-scsi@vger.kernel.org

Seperate max_hw_sectors and max_sectors.

LLDs call blk_queue_max_hw_sectors() to set max_hw_sectors.
blk_queue_max_sectors will also set max_sectors to a safe
default value.

blk_init_queue still calls blk_queue_max_sectors so if there
are any LLDs that do not call blk_queue_max_hw_sectors() and
were expecting both the max_sectors and max_hw_sectors to be
255 they do not have to do anything.

I was not able to test every driver I touched, but I think the
only place I may have messed up is MD so some testing is needed.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 3760edf..43207e5 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -2543,7 +2543,7 @@ static boolean DAC960_RegisterBlockDevic
   	RequestQueue->queuedata = Controller;
   	blk_queue_max_hw_segments(RequestQueue, Controller->DriverScatterGatherLimit);
 	blk_queue_max_phys_segments(RequestQueue, Controller->DriverScatterGatherLimit);
-	blk_queue_max_sectors(RequestQueue, Controller->MaxBlocksPerCommand);
+	blk_queue_max_hw_sectors(RequestQueue, Controller->MaxBlocksPerCommand);
 	disk->queue = RequestQueue;
 	sprintf(disk->disk_name, "rd/c%dd%d", Controller->ControllerNumber, n);
 	sprintf(disk->devfs_name, "rd/host%d/target%d", Controller->ControllerNumber, n);
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 4827860..32f452c 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1242,7 +1242,7 @@ static void cciss_update_drive_info(int 
 		/* This is a limit in the driver and could be eliminated. */
 		blk_queue_max_phys_segments(disk->queue, MAXSGENTRIES);
 
-		blk_queue_max_sectors(disk->queue, 512);
+		blk_queue_max_hw_sectors(disk->queue, 512);
 
 		disk->queue->queuedata = hba[ctlr];
 
@@ -3141,7 +3141,7 @@ static int __devinit cciss_init_one(stru
 	/* This is a limit in the driver and could be eliminated. */
 	blk_queue_max_phys_segments(q, MAXSGENTRIES);
 
-	blk_queue_max_sectors(q, 512);
+	blk_queue_max_hw_sectors(q, 512);
 
 		q->queuedata = hba[i];
 		sprintf(disk->disk_name, "cciss/c%dd%d", i, j);
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 5eadbb9..f9982bb 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4260,7 +4260,7 @@ static int __init floppy_init(void)
 		err = -ENOMEM;
 		goto out_unreg_blkdev;
 	}
-	blk_queue_max_sectors(floppy_queue, 64);
+	blk_queue_max_hw_sectors(floppy_queue, 64);
 
 	blk_register_region(MKDEV(FLOPPY_MAJOR, 0), 256, THIS_MODULE,
 			    floppy_find, NULL, NULL);
diff --git a/drivers/block/ll_rw_blk.c b/drivers/block/ll_rw_blk.c
index f9b83d2..6fd9121 100644
--- a/drivers/block/ll_rw_blk.c
+++ b/drivers/block/ll_rw_blk.c
@@ -241,7 +241,7 @@ void blk_queue_make_request(request_queu
 	q->backing_dev_info.ra_pages = (VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	q->backing_dev_info.state = 0;
 	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
-	blk_queue_max_sectors(q, MAX_SECTORS);
+	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
 	blk_queue_hardsect_size(q, 512);
 	blk_queue_dma_alignment(q, 511);
 	blk_queue_congestion_threshold(q);
@@ -563,6 +563,32 @@ void blk_queue_max_sectors(request_queue
 EXPORT_SYMBOL(blk_queue_max_sectors);
 
 /**
+ * blk_queue_max_hw_sectors - set max hw sectors for a request for this queue
+ * @q:  the request queue for the device
+ * @max_sectors:  max sectors in the usual 512b unit
+ *
+ * Description:
+ *    Enables a low level driver to set an upper limit on the size of
+ *    received requests.
+ **/
+void blk_queue_max_hw_sectors(request_queue_t *q, unsigned short max_hw_sectors)
+{
+	if ((max_hw_sectors << 9) < PAGE_CACHE_SIZE) {
+		max_hw_sectors = 1 << (PAGE_CACHE_SHIFT - 9);
+		printk("%s: set to minimum %d\n", __FUNCTION__, max_hw_sectors);
+	}
+
+	if (BLK_DEF_MAX_SECTORS > max_hw_sectors)
+		q->max_hw_sectors = q->max_sectors = max_hw_sectors;
+ 	else {
+		q->max_sectors = BLK_DEF_MAX_SECTORS;
+		q->max_hw_sectors = max_hw_sectors;
+	}
+}
+
+EXPORT_SYMBOL(blk_queue_max_hw_sectors);
+
+/**
  * blk_queue_max_phys_segments - set max phys segments for a request for this queue
  * @q:  the request queue for the device
  * @max_segments:  max number of segments
@@ -659,8 +685,8 @@ EXPORT_SYMBOL(blk_queue_hardsect_size);
 void blk_queue_stack_limits(request_queue_t *t, request_queue_t *b)
 {
 	/* zero is "infinity" */
-	t->max_sectors = t->max_hw_sectors =
-		min_not_zero(t->max_sectors,b->max_sectors);
+	t->max_sectors = min_not_zero(t->max_sectors,b->max_sectors);
+	t->max_hw_sectors = min_not_zero(t->max_hw_sectors,b->max_hw_sectors);
 
 	t->max_phys_segments = min(t->max_phys_segments,b->max_phys_segments);
 	t->max_hw_segments = min(t->max_hw_segments,b->max_hw_segments);
@@ -2147,7 +2173,7 @@ int blk_rq_map_user(request_queue_t *q, 
 	struct bio *bio;
 	int reading;
 
-	if (len > (q->max_sectors << 9))
+	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
 	if (!len || !ubuf)
 		return -EINVAL;
@@ -2262,7 +2288,7 @@ int blk_rq_map_kern(request_queue_t *q, 
 {
 	struct bio *bio;
 
-	if (len > (q->max_sectors << 9))
+	if (len > (q->max_hw_sectors << 9))
 		return -EINVAL;
 	if (!len || !kbuf)
 		return -EINVAL;
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index fa49d62..8144d3a 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -908,7 +908,7 @@ static int __init pd_init(void)
 	if (!pd_queue)
 		goto out1;
 
-	blk_queue_max_sectors(pd_queue, cluster);
+	blk_queue_max_hw_sectors(pd_queue, cluster);
 
 	if (register_blkdev(major, name))
 		goto out2;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index a280e67..527d0a5 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -1976,7 +1976,7 @@ static int pkt_open_dev(struct pktcdvd_d
 		 * even if the size is a multiple of the packet size.
 		 */
 		spin_lock_irq(q->queue_lock);
-		blk_queue_max_sectors(q, pd->settings.size);
+		blk_queue_max_hw_sectors(q, pd->settings.size);
 		spin_unlock_irq(q->queue_lock);
 		set_bit(PACKET_WRITABLE, &pd->flags);
 	} else {
@@ -2264,7 +2264,7 @@ static void pkt_init_queue(struct pktcdv
 
 	blk_queue_make_request(q, pkt_make_request);
 	blk_queue_hardsect_size(q, CD_FRAMESIZE);
-	blk_queue_max_sectors(q, PACKET_MAX_SECTORS);
+	blk_queue_max_hw_sectors(q, PACKET_MAX_SECTORS);
 	blk_queue_merge_bvec(q, pkt_merge_bvec);
 	q->queuedata = pd;
 }
diff --git a/drivers/block/ps2esdi.c b/drivers/block/ps2esdi.c
index 29d1518..905af4d 100644
--- a/drivers/block/ps2esdi.c
+++ b/drivers/block/ps2esdi.c
@@ -411,7 +411,7 @@ static int __init ps2esdi_geninit(void)
 		error = -EBUSY;
 		goto err_out3;
 	}
-	blk_queue_max_sectors(ps2esdi_queue, 128);
+	blk_queue_max_hw_sectors(ps2esdi_queue, 128);
 
 	error = -ENOMEM;
 	for (i = 0; i < ps2esdi_drives; i++) {
diff --git a/drivers/block/scsi_ioctl.c b/drivers/block/scsi_ioctl.c
index 382dea7..4e390df 100644
--- a/drivers/block/scsi_ioctl.c
+++ b/drivers/block/scsi_ioctl.c
@@ -233,7 +233,7 @@ static int sg_io(struct file *file, requ
 	if (verify_command(file, cmd))
 		return -EPERM;
 
-	if (hdr->dxfer_len > (q->max_sectors << 9))
+	if (hdr->dxfer_len > (q->max_hw_sectors << 9))
 		return -EIO;
 
 	if (hdr->dxfer_len)
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index bfb23d5..d3a55f6 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -2331,7 +2331,7 @@ static int ub_probe_lun(struct ub_dev *s
 	blk_queue_max_hw_segments(q, UB_MAX_REQ_SG);
 	blk_queue_max_phys_segments(q, UB_MAX_REQ_SG);
 	blk_queue_segment_boundary(q, 0xffffffff);	/* Dubious. */
-	blk_queue_max_sectors(q, UB_MAX_SECTORS);
+	blk_queue_max_hw_sectors(q, UB_MAX_SECTORS);
 	blk_queue_hardsect_size(q, lun->capacity.bsize);
 
 	q->queuedata = lun;
diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
index 2d518aa..1f88678 100644
--- a/drivers/block/viodasd.c
+++ b/drivers/block/viodasd.c
@@ -541,7 +541,7 @@ retry:
 	d->disk = g;
 	blk_queue_max_hw_segments(q, VIOMAXBLOCKDMA);
 	blk_queue_max_phys_segments(q, VIOMAXBLOCKDMA);
-	blk_queue_max_sectors(q, VIODASD_MAXSECTORS);
+	blk_queue_max_hw_sectors(q, VIODASD_MAXSECTORS);
 	g->major = VIODASD_MAJOR;
 	g->first_minor = dev_no << PARTITION_SHIFT;
 	if (dev_no >= 26)
diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index 68b6d7b..488f1af 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -234,7 +234,7 @@ static int __init xd_init(void)
 	}
 
 	/* xd_maxsectors depends on controller - so set after detection */
-	blk_queue_max_sectors(xd_queue, xd_maxsectors);
+	blk_queue_max_hw_sectors(xd_queue, xd_maxsectors);
 
 	for (i = 0; i < xd_drives; i++)
 		add_disk(xd_gendisk[i]);
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index b519178..10df0bf 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -694,7 +694,7 @@ static int viocd_probe(struct vio_dev *v
 			VIOCD_DEVICE_DEVFS "%d", deviceno);
 	blk_queue_max_hw_segments(q, 1);
 	blk_queue_max_phys_segments(q, 1);
-	blk_queue_max_sectors(q, 4096 / 512);
+	blk_queue_max_hw_sectors(q, 4096 / 512);
 	gendisk->queue = q;
 	gendisk->fops = &viocd_fops;
 	gendisk->flags = GENHD_FL_CD|GENHD_FL_REMOVABLE;
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 234f5de..acd109e 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -917,7 +917,7 @@ static void idedisk_setup (ide_drive_t *
 		if (max_s > hwif->rqsize)
 			max_s = hwif->rqsize;
 
-		blk_queue_max_sectors(drive->queue, max_s);
+		blk_queue_max_hw_sectors(drive->queue, max_s);
 	}
 
 	printk(KERN_INFO "%s: max request size: %dKiB\n", drive->name, drive->queue->max_sectors / 2);
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index 29c22fc..f031ee8 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -1853,7 +1853,7 @@ static void idefloppy_setup (ide_drive_t
 		set_bit(IDEFLOPPY_ZIP_DRIVE, &floppy->flags);
 		/* This value will be visible in the /proc/ide/hdx/settings */
 		floppy->ticks = IDEFLOPPY_TICKS_DELAY;
-		blk_queue_max_sectors(drive->queue, 64);
+		blk_queue_max_shw_ectors(drive->queue, 64);
 	}
 
 	/*
@@ -1862,7 +1862,7 @@ static void idefloppy_setup (ide_drive_t
 	*      it, so please don't remove this.
 	*/
 	if (strncmp(drive->id->model, "IOMEGA Clik!", 11) == 0) {
-		blk_queue_max_sectors(drive->queue, 64);
+		blk_queue_max_hw_sectors(drive->queue, 64);
 		set_bit(IDEFLOPPY_CLIK_DRIVE, &floppy->flags);
 	}
 
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index c1128ae..2578f03 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -993,7 +993,7 @@ static int ide_init_queue(ide_drive_t *d
 	}
 	if (hwif->rqsize < max_sectors)
 		max_sectors = hwif->rqsize;
-	blk_queue_max_sectors(q, max_sectors);
+	blk_queue_max_hw_sectors(q, max_sectors);
 
 #ifdef CONFIG_PCI
 	/* When we have an IOMMU, we may have a problem where pci_map_sg()
diff --git a/drivers/ide/legacy/hd.c b/drivers/ide/legacy/hd.c
index 242029c..d989cd5 100644
--- a/drivers/ide/legacy/hd.c
+++ b/drivers/ide/legacy/hd.c
@@ -721,7 +721,7 @@ static int __init hd_init(void)
 		return -ENOMEM;
 	}
 
-	blk_queue_max_sectors(hd_queue, 255);
+	blk_queue_max_hw_sectors(hd_queue, 255);
 	init_timer(&device_timer);
 	device_timer.function = hd_times_out;
 	blk_queue_hardsect_size(hd_queue, 512);
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index a6d3baa..a6f2dc6 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -638,7 +638,7 @@ int dm_split_args(int *argc, char ***arg
 static void check_for_valid_limits(struct io_restrictions *rs)
 {
 	if (!rs->max_sectors)
-		rs->max_sectors = MAX_SECTORS;
+		rs->max_sectors = SAFE_MAX_SECTORS;
 	if (!rs->max_phys_segments)
 		rs->max_phys_segments = MAX_PHYS_SEGMENTS;
 	if (!rs->max_hw_segments)
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 946efef..fa90058 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -150,7 +150,7 @@ static int linear_run (mddev_t *mddev)
 		 */
 		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
 		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+			blk_queue_max_hw_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		disk->size = rdev->size;
 		mddev->array_size += rdev->size;
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index c06f447..205ce26 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -326,7 +326,7 @@ static int multipath_add_disk(mddev_t *m
 		 */
 			if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
 			    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-				blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+				blk_queue_max_hw_sectors(mddev->queue, PAGE_SIZE>>9);
 
 			conf->working_disks++;
 			rdev->raid_disk = path;
@@ -480,7 +480,7 @@ static int multipath_run (mddev_t *mddev
 		 * a merge_bvec_fn to be involved in multipath */
 		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
 		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+			blk_queue_max_hw_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		if (!rdev->faulty) 
 			conf->working_disks++;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index fece327..e895c3d 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -158,7 +158,7 @@ static int create_strip_zones (mddev_t *
 
 		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn &&
 		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+			blk_queue_max_hw_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		if (!smallest || (rdev1->size <smallest->size))
 			smallest = rdev1;
@@ -284,7 +284,7 @@ static int raid0_run (mddev_t *mddev)
 	       mdname(mddev),
 	       mddev->chunk_size >> 9,
 	       (mddev->chunk_size>>1)-1);
-	blk_queue_max_sectors(mddev->queue, mddev->chunk_size >> 9);
+	blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_size >> 9);
 	blk_queue_segment_boundary(mddev->queue, (mddev->chunk_size>>1) - 1);
 
 	conf = kmalloc(sizeof (raid0_conf_t), GFP_KERNEL);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index e16f473..c210022 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -947,7 +947,7 @@ static int raid1_add_disk(mddev_t *mddev
 			 */
 			if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
 			    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-				blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+				blk_queue_max_hw_sectors(mddev->queue, PAGE_SIZE>>9);
 
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
@@ -1475,7 +1475,7 @@ static int run(mddev_t *mddev)
 		 */
 		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
 		    mddev->queue->max_sectors > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+			blk_queue_max_hw_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		disk->head_position = 0;
 		if (!rdev->faulty && rdev->in_sync)
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index f283b5b..30a5e92 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -1097,11 +1097,11 @@ static int i2o_block_probe(struct device
 	queue->queuedata = i2o_blk_dev;
 
 	blk_queue_max_phys_segments(queue, I2O_MAX_PHYS_SEGMENTS);
-	blk_queue_max_sectors(queue, max_sectors);
+	blk_queue_max_hw_sectors(queue, max_sectors);
 	blk_queue_max_hw_segments(queue, i2o_sg_tablesize(c, body_size));
 
-	osm_debug("max sectors = %d\n", queue->max_phys_segments);
-	osm_debug("phys segments = %d\n", queue->max_sectors);
+	osm_debug("phys segments = %d\n", queue->max_phys_segments);
+	osm_debug("max hw sectors = %d\n", queue->max_hw_sectors);
 	osm_debug("max hw segments = %d\n", queue->max_hw_segments);
 
 	/*
diff --git a/drivers/mmc/mmc_queue.c b/drivers/mmc/mmc_queue.c
index 0b9682e..6393859 100644
--- a/drivers/mmc/mmc_queue.c
+++ b/drivers/mmc/mmc_queue.c
@@ -139,7 +139,7 @@ int mmc_init_queue(struct mmc_queue *mq,
 
 	blk_queue_prep_rq(mq->queue, mmc_prep_request);
 	blk_queue_bounce_limit(mq->queue, limit);
-	blk_queue_max_sectors(mq->queue, host->max_sectors);
+	blk_queue_max_hw_sectors(mq->queue, host->max_sectors);
 	blk_queue_max_phys_segments(mq->queue, host->max_phys_segs);
 	blk_queue_max_hw_segments(mq->queue, host->max_hw_segs);
 	blk_queue_max_segment_size(mq->queue, host->max_seg_size);
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 8fc891a..e3e72ab 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -1627,7 +1627,7 @@ dasd_setup_queue(struct dasd_device * de
 
 	blk_queue_hardsect_size(device->request_queue, device->bp_block);
 	max = device->discipline->max_blocks << device->s2b_shift;
-	blk_queue_max_sectors(device->request_queue, max);
+	blk_queue_max_hw_sectors(device->request_queue, max);
 	blk_queue_max_phys_segments(device->request_queue, -1L);
 	blk_queue_max_hw_segments(device->request_queue, -1L);
 	blk_queue_max_segment_size(device->request_queue, -1L);
diff --git a/drivers/s390/char/tape_block.c b/drivers/s390/char/tape_block.c
index 1efc9f2..83ae4e4 100644
--- a/drivers/s390/char/tape_block.c
+++ b/drivers/s390/char/tape_block.c
@@ -231,7 +231,7 @@ tapeblock_setup_device(struct tape_devic
 		goto cleanup_queue;
 
 	blk_queue_hardsect_size(blkdat->request_queue, TAPEBLOCK_HSEC_SIZE);
-	blk_queue_max_sectors(blkdat->request_queue, TAPEBLOCK_MAX_SEC);
+	blk_queue_max_hw_sectors(blkdat->request_queue, TAPEBLOCK_MAX_SEC);
 	blk_queue_max_phys_segments(blkdat->request_queue, -1L);
 	blk_queue_max_hw_segments(blkdat->request_queue, -1L);
 	blk_queue_max_segment_size(blkdat->request_queue, -1L);
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index fa2cb35..c330b9e 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3212,7 +3212,7 @@ static int ipr_slave_configure(struct sc
 		}
 		if (ipr_is_vset_device(res)) {
 			sdev->timeout = IPR_VSET_RW_TIMEOUT;
-			blk_queue_max_sectors(sdev->request_queue, IPR_VSET_MAX_SECTORS);
+			blk_queue_max_hw_sectors(sdev->request_queue, IPR_VSET_MAX_SECTORS);
 		}
 		if (IPR_IS_DASD_DEVICE(res->cfgte.std_inq_data))
 			sdev->allow_restart = 1;
diff --git a/drivers/scsi/libata-scsi.c b/drivers/scsi/libata-scsi.c
index eb604b0..0613d3e 100644
--- a/drivers/scsi/libata-scsi.c
+++ b/drivers/scsi/libata-scsi.c
@@ -700,7 +700,7 @@ int ata_scsi_slave_config(struct scsi_de
 			 * do not overwrite sdev->host->max_sectors, since
 			 * other drives on this host may not support LBA48
 			 */
-			blk_queue_max_sectors(sdev->request_queue, 2048);
+			blk_queue_max_hw_sectors(sdev->request_queue, 2048);
 		}
 
 		/*
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4afef5c..c68888f 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1508,7 +1508,7 @@ struct request_queue *scsi_alloc_queue(s
 
 	blk_queue_max_hw_segments(q, shost->sg_tablesize);
 	blk_queue_max_phys_segments(q, SCSI_MAX_PHYS_SEGMENTS);
-	blk_queue_max_sectors(q, shost->max_sectors);
+	blk_queue_max_hw_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
 	blk_queue_issue_flush_fn(q, scsi_issue_flush_fn);
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 4837524..bf4fce5 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -119,7 +119,7 @@ static int slave_configure(struct scsi_d
 	 * increase max_sectors. */
 	if (le16_to_cpu(us->pusb_dev->descriptor.idVendor) == USB_VENDOR_ID_GENESYS &&
 			sdev->request_queue->max_sectors > 64)
-		blk_queue_max_sectors(sdev->request_queue, 64);
+		blk_queue_max_hw_sectors(sdev->request_queue, 64);
 
 	/* We can't put these settings in slave_alloc() because that gets
 	 * called before the device type is known.  Consequently these
@@ -398,7 +398,7 @@ static ssize_t show_max_sectors(struct d
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
 
-	return sprintf(buf, "%u\n", sdev->request_queue->max_sectors);
+	return sprintf(buf, "%u\n", sdev->request_queue->max_hw_sectors);
 }
 
 /* Input routine for the sysfs max_sectors file */
@@ -409,7 +409,7 @@ static ssize_t store_max_sectors(struct 
 	unsigned short ms;
 
 	if (sscanf(buf, "%hu", &ms) > 0 && ms <= SCSI_DEFAULT_MAX_SECTORS) {
-		blk_queue_max_sectors(sdev->request_queue, ms);
+		blk_queue_max_hw_sectors(sdev->request_queue, ms);
 		return strlen(buf);
 	}
 	return -EINVAL;	
diff --git a/fs/bio.c b/fs/bio.c
index 460554b..d7ed8af 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -313,7 +313,8 @@ int bio_get_nr_vecs(struct block_device 
 }
 
 static int __bio_add_page(request_queue_t *q, struct bio *bio, struct page
-			  *page, unsigned int len, unsigned int offset)
+			  *page, unsigned int len, unsigned int offset,
+			  unsigned short max_sectors)
 {
 	int retried_segments = 0;
 	struct bio_vec *bvec;
@@ -327,7 +328,7 @@ static int __bio_add_page(request_queue_
 	if (bio->bi_vcnt >= bio->bi_max_vecs)
 		return 0;
 
-	if (((bio->bi_size + len) >> 9) > q->max_sectors)
+	if (((bio->bi_size + len) >> 9) > max_sectors)
 		return 0;
 
 	/*
@@ -401,8 +402,8 @@ static int __bio_add_page(request_queue_
 int bio_add_page(struct bio *bio, struct page *page, unsigned int len,
 		 unsigned int offset)
 {
-	return __bio_add_page(bdev_get_queue(bio->bi_bdev), bio, page,
-			      len, offset);
+	struct request_queue *q = bdev_get_queue(bio->bi_bdev);
+	return __bio_add_page(q, bio, page, len, offset, q->max_sectors);
 }
 
 struct bio_map_data {
@@ -514,7 +515,8 @@ struct bio *bio_copy_user(request_queue_
 			break;
 		}
 
-		if (__bio_add_page(q, bio, page, bytes, 0) < bytes) {
+		if (__bio_add_page(q, bio, page, bytes, 0, q->max_hw_sectors) <
+				   bytes) {
 			ret = -EINVAL;
 			break;
 		}
@@ -628,7 +630,8 @@ static struct bio *__bio_map_user_iov(re
 			/*
 			 * sorry...
 			 */
-			if (__bio_add_page(q, bio, pages[j], bytes, offset) < bytes)
+			if (__bio_add_page(q, bio, pages[j], bytes, offset,
+					   q->max_hw_sectors) < bytes)
 				break;
 
 			len -= bytes;
@@ -802,7 +805,7 @@ static struct bio *__bio_map_kern(reques
 			bytes = len;
 
 		if (__bio_add_page(q, bio, virt_to_page(data), bytes,
-				   offset) < bytes)
+				   offset, q->max_hw_sectors) < bytes)
 			break;
 
 		data += bytes;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 46e927b..e0b47fa 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -652,6 +652,7 @@ extern void blk_cleanup_queue(request_qu
 extern void blk_queue_make_request(request_queue_t *, make_request_fn *);
 extern void blk_queue_bounce_limit(request_queue_t *, u64);
 extern void blk_queue_max_sectors(request_queue_t *, unsigned short);
+extern void blk_queue_max_hw_sectors(request_queue_t *, unsigned short);
 extern void blk_queue_max_phys_segments(request_queue_t *, unsigned short);
 extern void blk_queue_max_hw_segments(request_queue_t *, unsigned short);
 extern void blk_queue_max_segment_size(request_queue_t *, unsigned int);
@@ -699,7 +700,8 @@ extern int blkdev_issue_flush(struct blo
 
 #define MAX_PHYS_SEGMENTS 128
 #define MAX_HW_SEGMENTS 128
-#define MAX_SECTORS 255
+#define SAFE_MAX_SECTORS 255
+#define BLK_DEF_MAX_SECTORS 1024
 
 #define MAX_SEGMENT_SIZE	65536
 


