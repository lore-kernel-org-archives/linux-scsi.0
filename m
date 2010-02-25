From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Maximum data size in a single transfer for MS driver
Date: Thu, 25 Feb 2010 14:07:54 -0500
Message-ID: <yq1bpfdkub9.fsf@sermon.lab.mkp.net>
References: <20100225165901.GZ30797@beardog.cce.hp.com>
	<20100225171826.GC30797@beardog.cce.hp.com>
	<yq1vddlkyxo.fsf@sermon.lab.mkp.net> <4B86B666.2070806@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet12.oracle.com ([148.87.113.124]:22209 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932664Ab0BYTKK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Feb 2010 14:10:10 -0500
In-Reply-To: <4B86B666.2070806@panasas.com> (Boaz Harrosh's message of "Thu,
	25 Feb 2010 09:41:58 -0800")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, scameron@beardog.cce.hp.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, axboe@kernel.dk


Boaz> It seems like the confusion calls for a rename. We are made to
Boaz> believe that the accessors naming convention is the same as the
Boaz> queue member it changes. But here it is named as another very
Boaz> confusing member.

Like this, maybe?


block: Rename blk_queue_max_sectors to blk_queue_max_hw_sectors

The block layer calling convention is blk_queue_<limit name>.
blk_queue_max_sectors predates this practice, leading to some confusion.
Rename the function to appropriately reflect that its intended use is to
set max_hw_sectors and update and expand the documentation.

Also introduce a temporary wrapper for backwards compability.  This can
be removed after the merge window is closed.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index 5ff5546..c2051b0 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -747,7 +747,7 @@ static int ubd_open_dev(struct ubd *ubd_dev)
 	ubd_dev->fd = fd;
 
 	if(ubd_dev->cow.file != NULL){
-		blk_queue_max_sectors(ubd_dev->queue, 8 * sizeof(long));
+		blk_queue_max_hw_sectors(ubd_dev->queue, 8 * sizeof(long));
 
 		err = -ENOMEM;
 		ubd_dev->cow.bitmap = vmalloc(ubd_dev->cow.bitmap_len);
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 69b7c67..1a56840 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -154,7 +154,7 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	q->unplug_timer.data = (unsigned long)q;
 
 	blk_set_default_limits(&q->limits);
-	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
+	blk_queue_max_hw_sectors(q, SAFE_MAX_SECTORS);
 
 	/*
 	 * If the caller didn't supply a lock, fall back to our embedded
@@ -210,15 +210,22 @@ void blk_queue_bounce_limit(struct request_queue *q, u64 dma_mask)
 EXPORT_SYMBOL(blk_queue_bounce_limit);
 
 /**
- * blk_queue_max_sectors - set max sectors for a request for this queue
+ * blk_queue_max_hw_sectors - set max sectors for a request for this queue
  * @q:  the request queue for the device
  * @max_sectors:  max sectors in the usual 512b unit
  *
  * Description:
- *    Enables a low level driver to set an upper limit on the size of
- *    received requests.
+ *    Enables a low level driver to set a hard upper limit,
+ *    max_hw_sectors, on the size of requests.  max_hw_sectors is set by
+ *    the device driver based upon the combined capabilities of I/O
+ *    controller and storage device.
+ *
+ *    max_sectors is a soft limit imposed by the block layer for
+ *    filesystem type requests.  This value can be overridden on a
+ *    per-device basis in /sys/block/<device>/queue/max_sectors_kb.
+ *    The soft limit can not exceed max_hw_sectors.
  **/
-void blk_queue_max_sectors(struct request_queue *q, unsigned int max_sectors)
+void blk_queue_max_hw_sectors(struct request_queue *q, unsigned int max_sectors)
 {
 	if ((max_sectors << 9) < PAGE_CACHE_SIZE) {
 		max_sectors = 1 << (PAGE_CACHE_SHIFT - 9);
@@ -233,7 +240,7 @@ void blk_queue_max_sectors(struct request_queue *q, unsigned int max_sectors)
 		q->limits.max_hw_sectors = max_sectors;
 	}
 }
-EXPORT_SYMBOL(blk_queue_max_sectors);
+EXPORT_SYMBOL(blk_queue_max_hw_sectors);
 
 /**
  * blk_queue_max_discard_sectors - set max sectors for a single discard
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index d096fbc..bea003a 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1097,7 +1097,7 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 		dev->flags |= ATA_DFLAG_NO_UNLOAD;
 
 	/* configure max sectors */
-	blk_queue_max_sectors(sdev->request_queue, dev->max_sectors);
+	blk_queue_max_hw_sectors(sdev->request_queue, dev->max_sectors);
 
 	if (dev->class == ATA_DEV_ATAPI) {
 		struct request_queue *q = sdev->request_queue;
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index ce1fa92..8c4f937 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -2535,7 +2535,7 @@ static bool DAC960_RegisterBlockDevice(DAC960_Controller_T *Controller)
   	RequestQueue->queuedata = Controller;
   	blk_queue_max_hw_segments(RequestQueue, Controller->DriverScatterGatherLimit);
 	blk_queue_max_phys_segments(RequestQueue, Controller->DriverScatterGatherLimit);
-	blk_queue_max_sectors(RequestQueue, Controller->MaxBlocksPerCommand);
+	blk_queue_max_hw_sectors(RequestQueue, Controller->MaxBlocksPerCommand);
 	disk->queue = RequestQueue;
 	sprintf(disk->disk_name, "rd/c%dd%d", Controller->ControllerNumber, n);
 	disk->major = MajorNumber;
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 4f68843..c6ddeac 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -434,7 +434,7 @@ static struct brd_device *brd_alloc(int i)
 		goto out_free_dev;
 	blk_queue_make_request(brd->brd_queue, brd_make_request);
 	blk_queue_ordered(brd->brd_queue, QUEUE_ORDERED_TAG, NULL);
-	blk_queue_max_sectors(brd->brd_queue, 1024);
+	blk_queue_max_hw_sectors(brd->brd_queue, 1024);
 	blk_queue_bounce_limit(brd->brd_queue, BLK_BOUNCE_ANY);
 
 	disk = brd->brd_disk = alloc_disk(1 << part_shift);
diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 9291614..4f8198e 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -1801,7 +1801,7 @@ static int cciss_add_disk(ctlr_info_t *h, struct gendisk *disk,
 	/* This is a limit in the driver and could be eliminated. */
 	blk_queue_max_phys_segments(disk->queue, h->maxsgentries);
 
-	blk_queue_max_sectors(disk->queue, h->cciss_max_sectors);
+	blk_queue_max_hw_sectors(disk->queue, h->cciss_max_sectors);
 
 	blk_queue_softirq_done(disk->queue, cciss_softirq_done);
 
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 1292e06..9b55e64 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -709,7 +709,7 @@ void drbd_setup_queue_param(struct drbd_conf *mdev, unsigned int max_seg_s) __mu
 
 	max_seg_s = min(queue_max_sectors(b) * queue_logical_block_size(b), max_seg_s);
 
-	blk_queue_max_sectors(q, max_seg_s >> 9);
+	blk_queue_max_hw_sectors(q, max_seg_s >> 9);
 	blk_queue_max_phys_segments(q, max_segments ? max_segments : MAX_PHYS_SEGMENTS);
 	blk_queue_max_hw_segments(q, max_segments ? max_segments : MAX_HW_SEGMENTS);
 	blk_queue_max_segment_size(q, max_seg_s);
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 3266b4f..b9b1170 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4234,7 +4234,7 @@ static int __init floppy_init(void)
 		err = -ENOMEM;
 		goto out_unreg_driver;
 	}
-	blk_queue_max_sectors(floppy_queue, 64);
+	blk_queue_max_hw_sectors(floppy_queue, 64);
 
 	blk_register_region(MKDEV(FLOPPY_MAJOR, 0), 256, THIS_MODULE,
 			    floppy_find, NULL, NULL);
diff --git a/drivers/block/hd.c b/drivers/block/hd.c
index d5cdce0..5116c65 100644
--- a/drivers/block/hd.c
+++ b/drivers/block/hd.c
@@ -719,7 +719,7 @@ static int __init hd_init(void)
 		return -ENOMEM;
 	}
 
-	blk_queue_max_sectors(hd_queue, 255);
+	blk_queue_max_hw_sectors(hd_queue, 255);
 	init_timer(&device_timer);
 	device_timer.function = hd_times_out;
 	blk_queue_logical_block_size(hd_queue, 512);
diff --git a/drivers/block/mg_disk.c b/drivers/block/mg_disk.c
index 02b2583..5416c9a 100644
--- a/drivers/block/mg_disk.c
+++ b/drivers/block/mg_disk.c
@@ -980,7 +980,7 @@ static int mg_probe(struct platform_device *plat_dev)
 				__func__, __LINE__);
 		goto probe_err_6;
 	}
-	blk_queue_max_sectors(host->breq, MG_MAX_SECTS);
+	blk_queue_max_hw_sectors(host->breq, MG_MAX_SECTS);
 	blk_queue_logical_block_size(host->breq, MG_SECTOR_SIZE);
 
 	init_timer(&host->timer);
diff --git a/drivers/block/paride/pd.c b/drivers/block/paride/pd.c
index 569e39e..e712cd5 100644
--- a/drivers/block/paride/pd.c
+++ b/drivers/block/paride/pd.c
@@ -906,7 +906,7 @@ static int __init pd_init(void)
 	if (!pd_queue)
 		goto out1;
 
-	blk_queue_max_sectors(pd_queue, cluster);
+	blk_queue_max_hw_sectors(pd_queue, cluster);
 
 	if (register_blkdev(major, name))
 		goto out2;
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 68b5957..a3bfd24 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2360,7 +2360,7 @@ static int pkt_open_dev(struct pktcdvd_device *pd, fmode_t write)
 		 * even if the size is a multiple of the packet size.
 		 */
 		spin_lock_irq(q->queue_lock);
-		blk_queue_max_sectors(q, pd->settings.size);
+		blk_queue_max_hw_sectors(q, pd->settings.size);
 		spin_unlock_irq(q->queue_lock);
 		set_bit(PACKET_WRITABLE, &pd->flags);
 	} else {
@@ -2662,7 +2662,7 @@ static void pkt_init_queue(struct pktcdvd_device *pd)
 
 	blk_queue_make_request(q, pkt_make_request);
 	blk_queue_logical_block_size(q, CD_FRAMESIZE);
-	blk_queue_max_sectors(q, PACKET_MAX_SECTORS);
+	blk_queue_max_hw_sectors(q, PACKET_MAX_SECTORS);
 	blk_queue_merge_bvec(q, pkt_merge_bvec);
 	q->queuedata = pd;
 }
diff --git a/drivers/block/ps3disk.c b/drivers/block/ps3disk.c
index 03a130d..9cd1a4a 100644
--- a/drivers/block/ps3disk.c
+++ b/drivers/block/ps3disk.c
@@ -474,7 +474,7 @@ static int __devinit ps3disk_probe(struct ps3_system_bus_device *_dev)
 
 	blk_queue_bounce_limit(queue, BLK_BOUNCE_HIGH);
 
-	blk_queue_max_sectors(queue, dev->bounce_size >> 9);
+	blk_queue_max_hw_sectors(queue, dev->bounce_size >> 9);
 	blk_queue_segment_boundary(queue, -1UL);
 	blk_queue_dma_alignment(queue, dev->blk_size-1);
 	blk_queue_logical_block_size(queue, dev->blk_size);
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index 1fb6c31..6a0daf8 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -754,7 +754,7 @@ static int __devinit ps3vram_probe(struct ps3_system_bus_device *dev)
 	blk_queue_max_phys_segments(queue, MAX_PHYS_SEGMENTS);
 	blk_queue_max_hw_segments(queue, MAX_HW_SEGMENTS);
 	blk_queue_max_segment_size(queue, MAX_SEGMENT_SIZE);
-	blk_queue_max_sectors(queue, SAFE_MAX_SECTORS);
+	blk_queue_max_hw_sectors(queue, SAFE_MAX_SECTORS);
 
 	gendisk = alloc_disk(1);
 	if (!gendisk) {
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index 411f064..dd30cdd 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -693,7 +693,7 @@ static int probe_disk(struct vdc_port *port)
 
 	blk_queue_max_hw_segments(q, port->ring_cookies);
 	blk_queue_max_phys_segments(q, port->ring_cookies);
-	blk_queue_max_sectors(q, port->max_xfer_size);
+	blk_queue_max_hw_sectors(q, port->max_xfer_size);
 	g->major = vdc_major;
 	g->first_minor = port->vio.vdev->dev_no << PARTITION_SHIFT;
 	strcpy(g->disk_name, port->disk_name);
diff --git a/drivers/block/ub.c b/drivers/block/ub.c
index c739b20..79ca5ba 100644
--- a/drivers/block/ub.c
+++ b/drivers/block/ub.c
@@ -2323,7 +2323,7 @@ static int ub_probe_lun(struct ub_dev *sc, int lnum)
 	blk_queue_max_hw_segments(q, UB_MAX_REQ_SG);
 	blk_queue_max_phys_segments(q, UB_MAX_REQ_SG);
 	blk_queue_segment_boundary(q, 0xffffffff);	/* Dubious. */
-	blk_queue_max_sectors(q, UB_MAX_SECTORS);
+	blk_queue_max_hw_sectors(q, UB_MAX_SECTORS);
 	blk_queue_logical_block_size(q, lun->capacity.bsize);
 
 	lun->disk = disk;
diff --git a/drivers/block/viodasd.c b/drivers/block/viodasd.c
index a8c8b56..d44ece7 100644
--- a/drivers/block/viodasd.c
+++ b/drivers/block/viodasd.c
@@ -473,7 +473,7 @@ retry:
 	d->disk = g;
 	blk_queue_max_hw_segments(q, VIOMAXBLOCKDMA);
 	blk_queue_max_phys_segments(q, VIOMAXBLOCKDMA);
-	blk_queue_max_sectors(q, VIODASD_MAXSECTORS);
+	blk_queue_max_hw_sectors(q, VIODASD_MAXSECTORS);
 	g->major = VIODASD_MAJOR;
 	g->first_minor = dev_no << PARTITION_SHIFT;
 	if (dev_no >= 26)
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 51042f0..53750bb 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -352,7 +352,7 @@ static int __devinit virtblk_probe(struct virtio_device *vdev)
 	blk_queue_bounce_limit(vblk->disk->queue, BLK_BOUNCE_ANY);
 
 	/* No real sector limit. */
-	blk_queue_max_sectors(vblk->disk->queue, -1U);
+	blk_queue_max_hw_sectors(vblk->disk->queue, -1U);
 
 	/* Host can optionally specify maximum segment size and number of
 	 * segments. */
diff --git a/drivers/block/xd.c b/drivers/block/xd.c
index d1fd032..1a325fb 100644
--- a/drivers/block/xd.c
+++ b/drivers/block/xd.c
@@ -242,7 +242,7 @@ static int __init xd_init(void)
 	}
 
 	/* xd_maxsectors depends on controller - so set after detection */
-	blk_queue_max_sectors(xd_queue, xd_maxsectors);
+	blk_queue_max_hw_sectors(xd_queue, xd_maxsectors);
 
 	for (i = 0; i < xd_drives; i++)
 		add_disk(xd_gendisk[i]);
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 05a31e5..1bd08b3 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -346,7 +346,7 @@ static int xlvbd_init_blk_queue(struct gendisk *gd, u16 sector_size)
 
 	/* Hard sector size and max sectors impersonate the equiv. hardware. */
 	blk_queue_logical_block_size(rq, sector_size);
-	blk_queue_max_sectors(rq, 512);
+	blk_queue_max_hw_sectors(rq, 512);
 
 	/* Each segment in a request is up to an aligned page in size. */
 	blk_queue_segment_boundary(rq, PAGE_SIZE - 1);
diff --git a/drivers/cdrom/viocd.c b/drivers/cdrom/viocd.c
index 57ca69e..b1dfd23 100644
--- a/drivers/cdrom/viocd.c
+++ b/drivers/cdrom/viocd.c
@@ -618,7 +618,7 @@ static int viocd_probe(struct vio_dev *vdev, const struct vio_device_id *id)
 			sizeof(gendisk->disk_name));
 	blk_queue_max_hw_segments(q, 1);
 	blk_queue_max_phys_segments(q, 1);
-	blk_queue_max_sectors(q, 4096 / 512);
+	blk_queue_max_hw_sectors(q, 4096 / 512);
 	gendisk->queue = q;
 	gendisk->fops = &viocd_fops;
 	gendisk->flags = GENHD_FL_CD|GENHD_FL_REMOVABLE;
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index d485cdd..70fef40 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1571,7 +1571,7 @@ static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
 		sdev->start_stop_pwr_cond = 1;
 
 	if (lu->tgt->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
-		blk_queue_max_sectors(sdev->request_queue, 128 * 1024 / 512);
+		blk_queue_max_hw_sectors(sdev->request_queue, 128 * 1024 / 512);
 
 	blk_queue_max_segment_size(sdev->request_queue, SBP2_MAX_SEG_SIZE);
 
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 7f87801..3b128dc 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -679,7 +679,7 @@ static void ide_disk_setup(ide_drive_t *drive)
 		if (max_s > hwif->rqsize)
 			max_s = hwif->rqsize;
 
-		blk_queue_max_sectors(q, max_s);
+		blk_queue_max_hw_sectors(q, max_s);
 	}
 
 	printk(KERN_INFO "%s: max request size: %dKiB\n", drive->name,
diff --git a/drivers/ide/ide-floppy.c b/drivers/ide/ide-floppy.c
index fefbdfc..efd9076 100644
--- a/drivers/ide/ide-floppy.c
+++ b/drivers/ide/ide-floppy.c
@@ -486,7 +486,7 @@ static void ide_floppy_setup(ide_drive_t *drive)
 		drive->atapi_flags |= IDE_AFLAG_ZIP_DRIVE;
 		/* This value will be visible in the /proc/ide/hdx/settings */
 		drive->pc_delay = IDEFLOPPY_PC_DELAY;
-		blk_queue_max_sectors(drive->queue, 64);
+		blk_queue_max_hw_sectors(drive->queue, 64);
 	}
 
 	/*
@@ -494,7 +494,7 @@ static void ide_floppy_setup(ide_drive_t *drive)
 	 * nasty clicking noises without it, so please don't remove this.
 	 */
 	if (strncmp((char *)&id[ATA_ID_PROD], "IOMEGA Clik!", 11) == 0) {
-		blk_queue_max_sectors(drive->queue, 64);
+		blk_queue_max_hw_sectors(drive->queue, 64);
 		drive->atapi_flags |= IDE_AFLAG_CLIK_DRIVE;
 		/* IOMEGA Clik! drives do not support lock/unlock commands */
 		drive->dev_flags &= ~IDE_DFLAG_DOORLOCKING;
diff --git a/drivers/ide/ide-probe.c b/drivers/ide/ide-probe.c
index 4d76ba4..1ec8b31 100644
--- a/drivers/ide/ide-probe.c
+++ b/drivers/ide/ide-probe.c
@@ -774,7 +774,7 @@ static int ide_init_queue(ide_drive_t *drive)
 
 	if (hwif->rqsize < max_sectors)
 		max_sectors = hwif->rqsize;
-	blk_queue_max_sectors(q, max_sectors);
+	blk_queue_max_hw_sectors(q, max_sectors);
 
 #ifdef CONFIG_PCI
 	/* When we have an IOMMU, we may have a problem where pci_map_sg()
diff --git a/drivers/ieee1394/sbp2.c b/drivers/ieee1394/sbp2.c
index f199896..c88696a 100644
--- a/drivers/ieee1394/sbp2.c
+++ b/drivers/ieee1394/sbp2.c
@@ -2020,7 +2020,7 @@ static int sbp2scsi_slave_configure(struct scsi_device *sdev)
 	if (lu->workarounds & SBP2_WORKAROUND_POWER_CONDITION)
 		sdev->start_stop_pwr_cond = 1;
 	if (lu->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
-		blk_queue_max_sectors(sdev->request_queue, 128 * 1024 / 512);
+		blk_queue_max_hw_sectors(sdev->request_queue, 128 * 1024 / 512);
 
 	blk_queue_max_segment_size(sdev->request_queue, SBP2_MAX_SEG_SIZE);
 	return 0;
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index 7409d5f..7d7714d 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -177,7 +177,7 @@ static linear_conf_t *linear_conf(mddev_t *mddev, int raid_disks)
 		 */
 		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
 		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+			blk_queue_max_hw_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		conf->array_sectors += rdev->sectors;
 		cnt++;
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index cc8caa7..bb810a0 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -308,7 +308,7 @@ static int multipath_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 		 */
 			if (q->merge_bvec_fn &&
 			    queue_max_sectors(q) > (PAGE_SIZE>>9))
-				blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+				blk_queue_max_hw_sectors(mddev->queue, PAGE_SIZE>>9);
 
 			conf->working_disks++;
 			mddev->degraded--;
@@ -478,7 +478,7 @@ static int multipath_run (mddev_t *mddev)
 		 * a merge_bvec_fn to be involved in multipath */
 		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
 		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+			blk_queue_max_hw_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		if (!test_bit(Faulty, &rdev->flags))
 			conf->working_disks++;
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 086dec4..3007f1c 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -182,7 +182,7 @@ static int create_strip_zones(mddev_t *mddev)
 
 		if (rdev1->bdev->bd_disk->queue->merge_bvec_fn &&
 		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+			blk_queue_max_hw_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		if (!smallest || (rdev1->sectors < smallest->sectors))
 			smallest = rdev1;
@@ -325,7 +325,7 @@ static int raid0_run(mddev_t *mddev)
 	}
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
-	blk_queue_max_sectors(mddev->queue, mddev->chunk_sectors);
+	blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
 	mddev->queue->queue_lock = &mddev->queue->__queue_lock;
 
 	ret = create_strip_zones(mddev);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 51da0f7..df2fa68 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1158,7 +1158,7 @@ static int raid1_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 			 */
 			if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
 			    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
-				blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+				blk_queue_max_hw_sectors(mddev->queue, PAGE_SIZE>>9);
 
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
@@ -2103,7 +2103,7 @@ static int run(mddev_t *mddev)
 		 */
 		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
 		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+			blk_queue_max_hw_sectors(mddev->queue, PAGE_SIZE>>9);
 	}
 
 	mddev->degraded = 0;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ae3153b..b2b00f7 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1161,7 +1161,7 @@ static int raid10_add_disk(mddev_t *mddev, mdk_rdev_t *rdev)
 			 */
 			if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
 			    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
-				blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+				blk_queue_max_hw_sectors(mddev->queue, PAGE_SIZE>>9);
 
 			p->head_position = 0;
 			rdev->raid_disk = mirror;
@@ -2260,7 +2260,7 @@ static int run(mddev_t *mddev)
 		 */
 		if (rdev->bdev->bd_disk->queue->merge_bvec_fn &&
 		    queue_max_sectors(mddev->queue) > (PAGE_SIZE>>9))
-			blk_queue_max_sectors(mddev->queue, PAGE_SIZE>>9);
+			blk_queue_max_hw_sectors(mddev->queue, PAGE_SIZE>>9);
 
 		disk->head_position = 0;
 	}
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index bd83fa0..44d4178 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -1226,7 +1226,7 @@ static int mspro_block_init_disk(struct memstick_dev *card)
 	blk_queue_prep_rq(msb->queue, mspro_block_prepare_req);
 
 	blk_queue_bounce_limit(msb->queue, limit);
-	blk_queue_max_sectors(msb->queue, MSPRO_BLOCK_MAX_PAGES);
+	blk_queue_max_hw_sectors(msb->queue, MSPRO_BLOCK_MAX_PAGES);
 	blk_queue_max_phys_segments(msb->queue, MSPRO_BLOCK_MAX_SEGS);
 	blk_queue_max_hw_segments(msb->queue, MSPRO_BLOCK_MAX_SEGS);
 	blk_queue_max_segment_size(msb->queue,
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index e39986a..d033cfd 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -1066,7 +1066,7 @@ static int i2o_block_probe(struct device *dev)
 	queue->queuedata = i2o_blk_dev;
 
 	blk_queue_max_phys_segments(queue, I2O_MAX_PHYS_SEGMENTS);
-	blk_queue_max_sectors(queue, max_sectors);
+	blk_queue_max_hw_sectors(queue, max_sectors);
 	blk_queue_max_hw_segments(queue, i2o_sg_tablesize(c, body_size));
 
 	osm_debug("max sectors = %d\n", queue->max_sectors);
diff --git a/drivers/mmc/card/queue.c b/drivers/mmc/card/queue.c
index c5a7a85..09b633d 100644
--- a/drivers/mmc/card/queue.c
+++ b/drivers/mmc/card/queue.c
@@ -154,7 +154,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 
 		if (mq->bounce_buf) {
 			blk_queue_bounce_limit(mq->queue, BLK_BOUNCE_ANY);
-			blk_queue_max_sectors(mq->queue, bouncesz / 512);
+			blk_queue_max_hw_sectors(mq->queue, bouncesz / 512);
 			blk_queue_max_phys_segments(mq->queue, bouncesz / 512);
 			blk_queue_max_hw_segments(mq->queue, bouncesz / 512);
 			blk_queue_max_segment_size(mq->queue, bouncesz);
@@ -180,7 +180,7 @@ int mmc_init_queue(struct mmc_queue *mq, struct mmc_card *card, spinlock_t *lock
 
 	if (!mq->bounce_buf) {
 		blk_queue_bounce_limit(mq->queue, limit);
-		blk_queue_max_sectors(mq->queue,
+		blk_queue_max_hw_sectors(mq->queue,
 			min(host->max_blk_count, host->max_req_size / 512));
 		blk_queue_max_phys_segments(mq->queue, host->max_phys_segs);
 		blk_queue_max_hw_segments(mq->queue, host->max_hw_segs);
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 5905936..14b1e25 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2129,7 +2129,7 @@ static void dasd_setup_queue(struct dasd_block *block)
 
 	blk_queue_logical_block_size(block->request_queue, block->bp_block);
 	max = block->base->discipline->max_blocks << block->s2b_shift;
-	blk_queue_max_sectors(block->request_queue, max);
+	blk_queue_max_hw_sectors(block->request_queue, max);
 	blk_queue_max_phys_segments(block->request_queue, -1L);
 	blk_queue_max_hw_segments(block->request_queue, -1L);
 	/* with page sized segments we can translate each segement into
diff --git a/drivers/s390/char/tape_block.c b/drivers/s390/char/tape_block.c
index 8d3d720..509ed05 100644
--- a/drivers/s390/char/tape_block.c
+++ b/drivers/s390/char/tape_block.c
@@ -222,7 +222,7 @@ tapeblock_setup_device(struct tape_device * device)
 		goto cleanup_queue;
 
 	blk_queue_logical_block_size(blkdat->request_queue, TAPEBLOCK_HSEC_SIZE);
-	blk_queue_max_sectors(blkdat->request_queue, TAPEBLOCK_MAX_SEC);
+	blk_queue_max_hw_sectors(blkdat->request_queue, TAPEBLOCK_MAX_SEC);
 	blk_queue_max_phys_segments(blkdat->request_queue, -1L);
 	blk_queue_max_hw_segments(blkdat->request_queue, -1L);
 	blk_queue_max_segment_size(blkdat->request_queue, -1L);
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 9e52d16..032f0d0 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -3674,7 +3674,7 @@ static int ipr_slave_configure(struct scsi_device *sdev)
 		if (ipr_is_vset_device(res)) {
 			blk_queue_rq_timeout(sdev->request_queue,
 					     IPR_VSET_RW_TIMEOUT);
-			blk_queue_max_sectors(sdev->request_queue, IPR_VSET_MAX_SECTORS);
+			blk_queue_max_hw_sectors(sdev->request_queue, IPR_VSET_MAX_SECTORS);
 		}
 		if (ipr_is_vset_device(res) || ipr_is_scsi_disk(res))
 			sdev->allow_restart = 1;
diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index b6f1ef9..9b1c143 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -235,7 +235,7 @@ static int pmcraid_slave_configure(struct scsi_device *scsi_dev)
 		scsi_dev->allow_restart = 1;
 		blk_queue_rq_timeout(scsi_dev->request_queue,
 				     PMCRAID_VSET_IO_TIMEOUT);
-		blk_queue_max_sectors(scsi_dev->request_queue,
+		blk_queue_max_hw_sectors(scsi_dev->request_queue,
 				      PMCRAID_VSET_MAX_SECTORS);
 	}
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c664242..ac3cca7 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1627,7 +1627,7 @@ struct request_queue *__scsi_alloc_queue(struct Scsi_Host *shost,
 	blk_queue_max_hw_segments(q, shost->sg_tablesize);
 	blk_queue_max_phys_segments(q, SCSI_MAX_SG_CHAIN_SEGMENTS);
 
-	blk_queue_max_sectors(q, shost->max_sectors);
+	blk_queue_max_hw_sectors(q, shost->max_sectors);
 	blk_queue_bounce_limit(q, scsi_calculate_bounce_limit(shost));
 	blk_queue_segment_boundary(q, shost->dma_boundary);
 	dma_set_seg_boundary(dev, shost->dma_boundary);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 012f73a..5d9b513 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -879,7 +879,7 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 * broken RA4x00 Compaq Disk Array
 	 */
 	if (*bflags & BLIST_MAX_512)
-		blk_queue_max_sectors(sdev->request_queue, 512);
+		blk_queue_max_hw_sectors(sdev->request_queue, 512);
 
 	/*
 	 * Some devices may not want to have a start command automatically
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index e5e6df3..aadc16b 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -134,14 +134,14 @@ static int slave_configure(struct scsi_device *sdev)
 		if (us->fflags & US_FL_MAX_SECTORS_MIN)
 			max_sectors = PAGE_CACHE_SIZE >> 9;
 		if (queue_max_sectors(sdev->request_queue) > max_sectors)
-			blk_queue_max_sectors(sdev->request_queue,
+			blk_queue_max_hw_sectors(sdev->request_queue,
 					      max_sectors);
 	} else if (sdev->type == TYPE_TAPE) {
 		/* Tapes need much higher max_sector limits, so just
 		 * raise it to the maximum possible (4 GB / 512) and
 		 * let the queue segment size sort out the real limit.
 		 */
-		blk_queue_max_sectors(sdev->request_queue, 0x7FFFFF);
+		blk_queue_max_hw_sectors(sdev->request_queue, 0x7FFFFF);
 	}
 
 	/* Some USB host controllers can't do DMA; they have to use PIO.
@@ -495,7 +495,7 @@ static ssize_t store_max_sectors(struct device *dev, struct device_attribute *at
 	unsigned short ms;
 
 	if (sscanf(buf, "%hu", &ms) > 0 && ms <= SCSI_DEFAULT_MAX_SECTORS) {
-		blk_queue_max_sectors(sdev->request_queue, ms);
+		blk_queue_max_hw_sectors(sdev->request_queue, ms);
 		return strlen(buf);
 	}
 	return -EINVAL;	
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0b05791..8c0ef3a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -920,7 +920,14 @@ extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
-extern void blk_queue_max_sectors(struct request_queue *, unsigned int);
+extern void blk_queue_max_hw_sectors(struct request_queue *, unsigned int);
+
+/* Temporary compatibility wrapper */
+static inline void blk_queue_max_sectors(struct request_queue *q, unsigned int max)
+{
+	blk_queue_max_hw_sectors(q, max);
+}
+
 extern void blk_queue_max_phys_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_hw_segments(struct request_queue *, unsigned short);
 extern void blk_queue_max_segment_size(struct request_queue *, unsigned int);
