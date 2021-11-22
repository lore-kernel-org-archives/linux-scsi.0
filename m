Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F70DC4167E
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 13:06:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239483AbhKVNJw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 08:09:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237621AbhKVNJu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 08:09:50 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 723A9C061574;
        Mon, 22 Nov 2021 05:06:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=zI2tqBnb5FtHDN+RHJHV/hNwK8oDx0rf36kBp2GygCE=; b=lGJCzOFq+c75kCQD8+NR0dKm4U
        fpoqbOs3SiQ5sQFhbnAbjGFOAVvNYTrttUgZ/YsBciCnRmnvIzs+xjh3PjXeqi+vl7Y1lglowSsN0
        6W1FqqTg9dJqIld49xFSb0w4ymeciOX5VKXoMGV+M3+0EsIB1uOc4G8w8JVzWeD8Gj/jpg5IHDJfY
        1dxZaNamwleRpoga6ZS4KsMwYyrveCk6lh0GDL4EllMYOWgO1qOrwgOfo0VBiZxMxigG6BY0K5pHE
        /+dG6Pcu6mlCgolrDMXriPbkxssrtcXAO1UcuCqdbXDXZnI9mef3qTbWCWYnGXR/cQrTGM4ExEzAY
        Nw4rZHLQ==;
Received: from [2001:4bb8:180:22b2:9649:4579:dcf9:9fb2] (helo=localhost)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mp91s-00Crsc-Ca; Mon, 22 Nov 2021 13:06:41 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: [PATCH 11/14] block: remove GENHD_FL_EXT_DEVT
Date:   Mon, 22 Nov 2021 14:06:22 +0100
Message-Id: <20211122130625.1136848-12-hch@lst.de>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211122130625.1136848-1-hch@lst.de>
References: <20211122130625.1136848-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

All modern drivers can support extra partitions using the extended
dev_t.  In fact except for the ioctl method drivers never even see
partitions in normal operation.

So remove the GENHD_FL_EXT_DEVT and allow extra partitions for all
block devices that do support partitions, and require those that
do not support partitions to explicit disallow them using
GENHD_FL_NO_PART.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c                  |  6 +++---
 block/partitions/core.c        |  9 ++++-----
 drivers/block/amiflop.c        |  1 +
 drivers/block/ataflop.c        |  1 +
 drivers/block/brd.c            |  1 -
 drivers/block/drbd/drbd_main.c |  1 +
 drivers/block/floppy.c         |  1 +
 drivers/block/loop.c           |  1 -
 drivers/block/null_blk/main.c  |  1 -
 drivers/block/paride/pcd.c     |  1 +
 drivers/block/paride/pf.c      |  1 +
 drivers/block/pktcdvd.c        |  2 +-
 drivers/block/ps3vram.c        |  1 +
 drivers/block/rbd.c            |  6 ++----
 drivers/block/swim.c           |  1 +
 drivers/block/swim3.c          |  2 +-
 drivers/block/virtio_blk.c     |  1 -
 drivers/block/z2ram.c          |  1 +
 drivers/block/zram/zram_drv.c  |  1 +
 drivers/cdrom/gdrom.c          |  1 +
 drivers/md/dm.c                |  1 +
 drivers/md/md.c                |  5 -----
 drivers/mmc/core/block.c       |  1 -
 drivers/mtd/ubi/block.c        |  1 +
 drivers/scsi/sd.c              |  1 -
 drivers/scsi/sr.c              |  1 +
 include/linux/genhd.h          | 28 +++++-----------------------
 27 files changed, 30 insertions(+), 48 deletions(-)

diff --git a/block/genhd.c b/block/genhd.c
index 09abd41249fd4..e9346fae48ad4 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -376,7 +376,7 @@ int disk_scan_partitions(struct gendisk *disk, fmode_t mode)
 {
 	struct block_device *bdev;
 
-	if (!disk_part_scan_enabled(disk))
+	if (disk->flags & GENHD_FL_NO_PART)
 		return -EINVAL;
 	if (disk->open_partitions)
 		return -EBUSY;
@@ -438,7 +438,6 @@ int __must_check device_add_disk(struct device *parent, struct gendisk *disk,
 			return ret;
 		disk->major = BLOCK_EXT_MAJOR;
 		disk->first_minor = ret;
-		disk->flags |= GENHD_FL_EXT_DEVT;
 	}
 
 	ret = disk_alloc_events(disk);
@@ -872,7 +871,8 @@ static ssize_t disk_ext_range_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n", disk_max_parts(disk));
+	return sprintf(buf, "%d\n",
+		(disk->flags & GENHD_FL_NO_PART) ? 1 : DISK_MAX_PARTS);
 }
 
 static ssize_t disk_removable_show(struct device *dev,
diff --git a/block/partitions/core.c b/block/partitions/core.c
index 520292fee9339..c2a1635922b1c 100644
--- a/block/partitions/core.c
+++ b/block/partitions/core.c
@@ -98,13 +98,12 @@ static void bdev_set_nr_sectors(struct block_device *bdev, sector_t sectors)
 static struct parsed_partitions *allocate_partitions(struct gendisk *hd)
 {
 	struct parsed_partitions *state;
-	int nr;
+	int nr = DISK_MAX_PARTS;
 
 	state = kzalloc(sizeof(*state), GFP_KERNEL);
 	if (!state)
 		return NULL;
 
-	nr = disk_max_parts(hd);
 	state->parts = vzalloc(array_size(nr, sizeof(state->parts[0])));
 	if (!state->parts) {
 		kfree(state);
@@ -326,7 +325,7 @@ static struct block_device *add_partition(struct gendisk *disk, int partno,
 
 	lockdep_assert_held(&disk->open_mutex);
 
-	if (partno >= disk_max_parts(disk))
+	if (partno >= DISK_MAX_PARTS)
 		return ERR_PTR(-EINVAL);
 
 	/*
@@ -604,7 +603,7 @@ static int blk_add_partitions(struct gendisk *disk)
 	struct parsed_partitions *state;
 	int ret = -EAGAIN, p;
 
-	if (!disk_part_scan_enabled(disk))
+	if (disk->flags & GENHD_FL_NO_PART)
 		return 0;
 
 	state = check_partition(disk);
@@ -687,7 +686,7 @@ int bdev_disk_changed(struct gendisk *disk, bool invalidate)
 	 * userspace for this particular setup.
 	 */
 	if (invalidate) {
-		if (disk_part_scan_enabled(disk) ||
+		if (!(disk->flags & GENHD_FL_NO_PART) ||
 		    !(disk->flags & GENHD_FL_REMOVABLE))
 			set_capacity(disk, 0);
 	}
diff --git a/drivers/block/amiflop.c b/drivers/block/amiflop.c
index bf5c124c5452a..1eec5113d0b5b 100644
--- a/drivers/block/amiflop.c
+++ b/drivers/block/amiflop.c
@@ -1790,6 +1790,7 @@ static int fd_alloc_disk(int drive, int system)
 	disk->first_minor = drive + system;
 	disk->minors = 1;
 	disk->fops = &floppy_fops;
+	disk->flags |= GENHD_FL_NO_PART;
 	disk->events = DISK_EVENT_MEDIA_CHANGE;
 	if (system)
 		sprintf(disk->disk_name, "fd%d_msdos", drive);
diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index bf769e6e32fef..f3ff9babdb5cd 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -2000,6 +2000,7 @@ static int ataflop_alloc_disk(unsigned int drive, unsigned int type)
 	disk->minors = 1;
 	sprintf(disk->disk_name, "fd%d", drive);
 	disk->fops = &floppy_fops;
+	disk->flags |= GENHD_FL_NO_PART;
 	disk->events = DISK_EVENT_MEDIA_CHANGE;
 	disk->private_data = &unit[drive];
 	set_capacity(disk, MAX_DISK_SIZE * 2);
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index a896ee175d863..8fe2e4289dae3 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -405,7 +405,6 @@ static int brd_alloc(int i)
 	disk->minors		= max_part;
 	disk->fops		= &brd_fops;
 	disk->private_data	= brd;
-	disk->flags		= GENHD_FL_EXT_DEVT;
 	strlcpy(disk->disk_name, buf, DISK_NAME_LEN);
 	set_capacity(disk, rd_size * 2);
 	
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 53ba2dddba6e6..07b3c6093e7db 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2734,6 +2734,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	disk->first_minor = minor;
 	disk->minors = 1;
 	disk->fops = &drbd_ops;
+	disk->flags |= GENHD_FL_NO_PART;
 	sprintf(disk->disk_name, "drbd%d", minor);
 	disk->private_data = device;
 
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index c4267da716fe6..7f0a60c4079fd 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4503,6 +4503,7 @@ static int floppy_alloc_disk(unsigned int drive, unsigned int type)
 	disk->first_minor = TOMINOR(drive) | (type << 2);
 	disk->minors = 1;
 	disk->fops = &floppy_fops;
+	disk->flags |= GENHD_FL_NO_PART;
 	disk->events = DISK_EVENT_MEDIA_CHANGE;
 	if (type)
 		sprintf(disk->disk_name, "fd%d_type%d", drive, type);
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 7219d98c6fb8a..0954ea8cf9e3b 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -2033,7 +2033,6 @@ static int loop_add(int i)
 	 */
 	if (!part_shift)
 		disk->flags |= GENHD_FL_NO_PART;
-	disk->flags |= GENHD_FL_EXT_DEVT;
 	atomic_set(&lo->lo_refcnt, 0);
 	mutex_init(&lo->lo_mutex);
 	lo->lo_number		= i;
diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index eb17def1f265e..54f7d490f8ebb 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1850,7 +1850,6 @@ static int null_gendisk_register(struct nullb *nullb)
 
 	set_capacity(disk, size);
 
-	disk->flags |= GENHD_FL_EXT_DEVT;
 	disk->major		= null_major;
 	disk->first_minor	= nullb->index;
 	disk->minors		= 1;
diff --git a/drivers/block/paride/pcd.c b/drivers/block/paride/pcd.c
index 430ee8004a514..255fd3d4b8a84 100644
--- a/drivers/block/paride/pcd.c
+++ b/drivers/block/paride/pcd.c
@@ -928,6 +928,7 @@ static int pcd_init_unit(struct pcd_unit *cd, bool autoprobe, int port,
 	disk->minors = 1;
 	strcpy(disk->disk_name, cd->name);	/* umm... */
 	disk->fops = &pcd_bdops;
+	disk->flags |= GENHD_FL_NO_PART;
 	disk->events = DISK_EVENT_MEDIA_CHANGE;
 	disk->event_flags = DISK_EVENT_FLAG_BLOCK_ON_EXCL_WRITE;
 
diff --git a/drivers/block/paride/pf.c b/drivers/block/paride/pf.c
index bf8d0ef41a0a2..b84a6448a4f75 100644
--- a/drivers/block/paride/pf.c
+++ b/drivers/block/paride/pf.c
@@ -942,6 +942,7 @@ static int __init pf_init_unit(struct pf_unit *pf, bool autoprobe, int port,
 	disk->minors = 1;
 	strcpy(disk->disk_name, pf->name);
 	disk->fops = &pf_fops;
+	disk->flags |= GENHD_FL_NO_PART;
 	disk->events = DISK_EVENT_MEDIA_CHANGE;
 	disk->private_data = pf;
 
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index b53f648302c15..3af0499857ecf 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -2719,7 +2719,7 @@ static int pkt_setup_dev(dev_t dev, dev_t* pkt_dev)
 	disk->first_minor = idx;
 	disk->minors = 1;
 	disk->fops = &pktcdvd_ops;
-	disk->flags = GENHD_FL_REMOVABLE;
+	disk->flags = GENHD_FL_REMOVABLE | GENHD_FL_NO_PART;
 	strcpy(disk->disk_name, pd->name);
 	disk->private_data = pd;
 
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index c1876646a4cb9..4f90819e245e9 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -742,6 +742,7 @@ static int ps3vram_probe(struct ps3_system_bus_device *dev)
 	priv->gendisk = gendisk;
 	gendisk->major = ps3vram_major;
 	gendisk->minors = 1;
+	gendisk->flags |= GENHD_FL_NO_PART;
 	gendisk->fops = &ps3vram_fops;
 	gendisk->private_data = dev;
 	strlcpy(gendisk->disk_name, DEVICE_NAME, sizeof(gendisk->disk_name));
diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 953fa134cd3db..8f140da1efe30 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4924,12 +4924,10 @@ static int rbd_init_disk(struct rbd_device *rbd_dev)
 		 rbd_dev->dev_id);
 	disk->major = rbd_dev->major;
 	disk->first_minor = rbd_dev->minor;
-	if (single_major) {
+	if (single_major)
 		disk->minors = (1 << RBD_SINGLE_MAJOR_PART_SHIFT);
-		disk->flags |= GENHD_FL_EXT_DEVT;
-	} else {
+	else
 		disk->minors = RBD_MINORS_PER_MAJOR;
-	}
 	disk->fops = &rbd_bd_ops;
 	disk->private_data = rbd_dev;
 
diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 821594cd13151..fef65a18d56fa 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -840,6 +840,7 @@ static int swim_floppy_init(struct swim_priv *swd)
 		swd->unit[drive].disk->minors = 1;
 		sprintf(swd->unit[drive].disk->disk_name, "fd%d", drive);
 		swd->unit[drive].disk->fops = &floppy_fops;
+		swd->unit[drive].disk->flags |= GENHD_FL_NO_PART;
 		swd->unit[drive].disk->events = DISK_EVENT_MEDIA_CHANGE;
 		swd->unit[drive].disk->private_data = &swd->unit[drive];
 		set_capacity(swd->unit[drive].disk, 2880);
diff --git a/drivers/block/swim3.c b/drivers/block/swim3.c
index 4b91c9aa58926..6c39f2c9f806d 100644
--- a/drivers/block/swim3.c
+++ b/drivers/block/swim3.c
@@ -1227,7 +1227,7 @@ static int swim3_attach(struct macio_dev *mdev,
 	disk->fops = &floppy_fops;
 	disk->private_data = fs;
 	disk->events = DISK_EVENT_MEDIA_CHANGE;
-	disk->flags |= GENHD_FL_REMOVABLE;
+	disk->flags |= GENHD_FL_REMOVABLE | GENHD_FL_NO_PART;
 	sprintf(disk->disk_name, "fd%d", floppy_count);
 	set_capacity(disk, 2880);
 	rc = add_disk(disk);
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 97bf051a50ced..5bb11a8b02652 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -843,7 +843,6 @@ static int virtblk_probe(struct virtio_device *vdev)
 	vblk->disk->minors = 1 << PART_BITS;
 	vblk->disk->private_data = vblk;
 	vblk->disk->fops = &virtblk_fops;
-	vblk->disk->flags |= GENHD_FL_EXT_DEVT;
 	vblk->index = index;
 
 	/* configure queue flush support */
diff --git a/drivers/block/z2ram.c b/drivers/block/z2ram.c
index ccc52c935fafc..7a6ed83481b8d 100644
--- a/drivers/block/z2ram.c
+++ b/drivers/block/z2ram.c
@@ -327,6 +327,7 @@ static int z2ram_register_disk(int minor)
 	disk->major = Z2RAM_MAJOR;
 	disk->first_minor = minor;
 	disk->minors = 1;
+	disk->flags |= GENHD_FL_NO_PART;
 	disk->fops = &z2_fops;
 	if (minor)
 		sprintf(disk->disk_name, "z2ram%d", minor);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 08d7953ec5f10..b4a6a832afe33 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1945,6 +1945,7 @@ static int zram_add(void)
 	zram->disk->major = zram_major;
 	zram->disk->first_minor = device_id;
 	zram->disk->minors = 1;
+	zram->disk->flags |= GENHD_FL_NO_PART;
 	zram->disk->fops = &zram_devops;
 	zram->disk->private_data = zram;
 	snprintf(zram->disk->disk_name, 16, "zram%d", device_id);
diff --git a/drivers/cdrom/gdrom.c b/drivers/cdrom/gdrom.c
index d50cc1fd34d5f..faead41709bcd 100644
--- a/drivers/cdrom/gdrom.c
+++ b/drivers/cdrom/gdrom.c
@@ -719,6 +719,7 @@ static void probe_gdrom_setupdisk(void)
 	gd.disk->major = gdrom_major;
 	gd.disk->first_minor = 1;
 	gd.disk->minors = 1;
+	gd.disk->flags |= GENHD_FL_NO_PART;
 	strcpy(gd.disk->disk_name, GDROM_DEV_NAME);
 }
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 662742a310cbb..280918cdcabd3 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1778,6 +1778,7 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->major = _major;
 	md->disk->first_minor = minor;
 	md->disk->minors = 1;
+	md->disk->flags |= GENHD_FL_NO_PART;
 	md->disk->fops = &dm_blk_dops;
 	md->disk->queue = md->queue;
 	md->disk->private_data = md;
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 5111ed966947e..7fbf6f0ac01be 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5707,11 +5707,6 @@ static int md_alloc(dev_t dev, char *name)
 	mddev->queue = disk->queue;
 	blk_set_stacking_limits(&mddev->queue->limits);
 	blk_queue_write_cache(mddev->queue, true, true);
-	/* Allow extended partitions.  This makes the
-	 * 'mdp' device redundant, but we can't really
-	 * remove it now.
-	 */
-	disk->flags |= GENHD_FL_EXT_DEVT;
 	disk->events |= DISK_EVENT_MEDIA_CHANGE;
 	mddev->gendisk = disk;
 	error = add_disk(disk);
diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 2dd93d49d822c..5e0960560eab7 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2395,7 +2395,6 @@ static struct mmc_blk_data *mmc_blk_alloc_req(struct mmc_card *card,
 	md->disk->private_data = md;
 	md->parent = parent;
 	set_disk_ro(md->disk, md->read_only || default_ro);
-	md->disk->flags = GENHD_FL_EXT_DEVT;
 	if (area_type & (MMC_BLK_DATA_AREA_RPMB | MMC_BLK_DATA_AREA_BOOT))
 		md->disk->flags |= GENHD_FL_NO_PART;
 
diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
index 302426ab30f8d..a78fdf3b30f7e 100644
--- a/drivers/mtd/ubi/block.c
+++ b/drivers/mtd/ubi/block.c
@@ -430,6 +430,7 @@ int ubiblock_create(struct ubi_volume_info *vi)
 		ret = -ENODEV;
 		goto out_cleanup_disk;
 	}
+	gd->flags |= GENHD_FL_NO_PART;
 	gd->private_data = dev;
 	sprintf(gd->disk_name, "ubiblock%d_%d", dev->ubi_num, dev->vol_id);
 	set_capacity(gd, disk_capacity);
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 65875a598d629..bba1f5dafd387 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3566,7 +3566,6 @@ static int sd_probe(struct device *dev)
 
 	sd_revalidate_disk(gd);
 
-	gd->flags = GENHD_FL_EXT_DEVT;
 	if (sdp->removable) {
 		gd->flags |= GENHD_FL_REMOVABLE;
 		gd->events |= DISK_EVENT_MEDIA_CHANGE;
diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 6646797a7756e..cf093387e42a1 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -684,6 +684,7 @@ static int sr_probe(struct device *dev)
 	disk->minors = 1;
 	sprintf(disk->disk_name, "sr%d", minor);
 	disk->fops = &sr_bdops;
+	disk->flags |= GENHD_FL_NO_PART;
 	disk->events = DISK_EVENT_MEDIA_CHANGE | DISK_EVENT_EJECT_REQUEST;
 	disk->event_flags = DISK_EVENT_FLAG_POLL | DISK_EVENT_FLAG_UEVENT |
 				DISK_EVENT_FLAG_BLOCK_ON_EXCL_WRITE;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 64a2f33ae9ea4..b8ced80178d64 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -46,11 +46,6 @@ struct partition_meta_info {
  * Must not be set for devices which are removed entirely when the
  * media is removed.
  *
- * ``GENHD_FL_EXT_DEVT`` (0x0040): the driver supports extended
- * dynamic ``dev_t``, i.e. it wants extended device numbers
- * (``BLOCK_EXT_MAJOR``).
- * This affects the maximum number of partitions.
- *
  * ``GENHD_FL_NO_PART`` (0x0200): partition support is disabled.
  * The kernel will not scan for partitions from add_disk, and users
  * can't add partitions manually.
@@ -64,7 +59,6 @@ struct partition_meta_info {
 #define GENHD_FL_REMOVABLE			0x0001
 /* 2 is unused (used to be GENHD_FL_DRIVERFS) */
 /* 4 is unused (used to be GENHD_FL_MEDIA_CHANGE_NOTIFY) */
-#define GENHD_FL_EXT_DEVT			0x0040
 #define GENHD_FL_NO_PART			0x0200
 #define GENHD_FL_HIDDEN				0x0400
 
@@ -94,13 +88,13 @@ struct blk_integrity {
 };
 
 struct gendisk {
-	/* major, first_minor and minors are input parameters only,
-	 * don't use directly.  Use disk_devt() and disk_max_parts().
+	/*
+	 * major/first_minor/minors should not be set by any new driver, the
+	 * block core will take care of allocating them automatically.
 	 */
-	int major;			/* major number of driver */
+	int major;
 	int first_minor;
-	int minors;                     /* maximum number of minors, =1 for
-                                         * disks that can't be partitioned. */
+	int minors;
 
 	char disk_name[DISK_NAME_LEN];	/* name of major driver */
 
@@ -164,18 +158,6 @@ static inline bool disk_live(struct gendisk *disk)
 #define disk_to_cdi(disk)	NULL
 #endif
 
-static inline int disk_max_parts(struct gendisk *disk)
-{
-	if (disk->flags & GENHD_FL_EXT_DEVT)
-		return DISK_MAX_PARTS;
-	return disk->minors;
-}
-
-static inline bool disk_part_scan_enabled(struct gendisk *disk)
-{
-	return disk_max_parts(disk) > 1 && !(disk->flags & GENHD_FL_NO_PART);
-}
-
 static inline dev_t disk_devt(struct gendisk *disk)
 {
 	return MKDEV(disk->major, disk->first_minor);
-- 
2.30.2

