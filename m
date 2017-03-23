From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/23] block: remove the discard_zeroes_data flag
Date: Thu, 23 Mar 2017 10:33:41 -0400
Message-ID: <20170323143341.31549-24-hch@lst.de>
References: <20170323143341.31549-1-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49002 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756048AbdCWOed (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Mar 2017 10:34:33 -0400
In-Reply-To: <20170323143341.31549-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org

Now that we use the proper REQ_OP_WRITE_ZEROES operation everywhere we can
kill this hack.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/ABI/testing/sysfs-block | 10 ++--------
 Documentation/block/queue-sysfs.txt   |  5 -----
 block/blk-lib.c                       |  7 +------
 block/blk-settings.c                  |  3 ---
 block/blk-sysfs.c                     |  2 +-
 block/compat_ioctl.c                  |  2 +-
 block/ioctl.c                         |  2 +-
 drivers/ata/libata-scsi.c             |  2 +-
 drivers/block/drbd/drbd_main.c        |  2 --
 drivers/block/drbd/drbd_nl.c          |  7 +------
 drivers/block/loop.c                  |  2 --
 drivers/block/mtip32xx/mtip32xx.c     |  1 -
 drivers/block/nbd.c                   |  1 -
 drivers/md/dm-cache-target.c          |  1 -
 drivers/md/dm-crypt.c                 |  1 -
 drivers/md/dm-raid.c                  |  6 +++---
 drivers/md/dm-raid1.c                 |  1 -
 drivers/md/dm-table.c                 | 19 -------------------
 drivers/md/dm-thin.c                  |  2 --
 drivers/md/raid5.c                    | 12 +-----------
 drivers/scsi/sd.c                     |  7 -------
 drivers/target/target_core_device.c   |  2 +-
 include/linux/blkdev.h                | 15 ---------------
 include/linux/device-mapper.h         |  5 -----
 24 files changed, 13 insertions(+), 104 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index 2da04ce6aeef..dea212db9df3 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -213,14 +213,8 @@ What:		/sys/block/<disk>/queue/discard_zeroes_data
 Date:		May 2011
 Contact:	Martin K. Petersen <martin.petersen@oracle.com>
 Description:
-		Devices that support discard functionality may return
-		stale or random data when a previously discarded block
-		is read back. This can cause problems if the filesystem
-		expects discarded blocks to be explicitly cleared. If a
-		device reports that it deterministically returns zeroes
-		when a discarded area is read the discard_zeroes_data
-		parameter will be set to one. Otherwise it will be 0 and
-		the result of reading a discarded area is undefined.
+		Will always return 0.  Don't rely on any specific behavior
+		for discards, and don't read this file.
 
 What:		/sys/block/<disk>/queue/write_same_max_bytes
 Date:		January 2012
diff --git a/Documentation/block/queue-sysfs.txt b/Documentation/block/queue-sysfs.txt
index c0a3bb5a6e4e..009150ed7db8 100644
--- a/Documentation/block/queue-sysfs.txt
+++ b/Documentation/block/queue-sysfs.txt
@@ -43,11 +43,6 @@ large discards are issued, setting this value lower will make Linux issue
 smaller discards and potentially help reduce latencies induced by large
 discard operations.
 
-discard_zeroes_data (RO)
-------------------------
-When read, this file will show if the discarded block are zeroed by the
-device or not. If its value is '1' the blocks are zeroed otherwise not.
-
 hw_sector_size (RO)
 -------------------
 This is the hardware sector size of the device, in bytes.
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 153ca59393a7..be44d2725ede 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -37,17 +37,12 @@ int __blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		return -ENXIO;
 
 	if (flags & BLKDEV_DISCARD_SECURE) {
-		if (flags & BLKDEV_DISCARD_ZERO)
-			return -EOPNOTSUPP;
 		if (!blk_queue_secure_erase(q))
 			return -EOPNOTSUPP;
 		op = REQ_OP_SECURE_ERASE;
 	} else {
 		if (!blk_queue_discard(q))
 			return -EOPNOTSUPP;
-		if ((flags & BLKDEV_DISCARD_ZERO) &&
-		    !q->limits.discard_zeroes_data)
-			return -EOPNOTSUPP;
 		op = REQ_OP_DISCARD;
 	}
 
@@ -126,7 +121,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 			&bio);
 	if (!ret && bio) {
 		ret = submit_bio_wait(bio);
-		if (ret == -EOPNOTSUPP && !(flags & BLKDEV_DISCARD_ZERO))
+		if (ret == -EOPNOTSUPP)
 			ret = 0;
 		bio_put(bio);
 	}
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 9d515ae3a405..fe2794986eb9 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -104,7 +104,6 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->discard_granularity = 0;
 	lim->discard_alignment = 0;
 	lim->discard_misaligned = 0;
-	lim->discard_zeroes_data = 0;
 	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
 	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
 	lim->alignment_offset = 0;
@@ -128,7 +127,6 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	blk_set_default_limits(lim);
 
 	/* Inherit limits from component devices */
-	lim->discard_zeroes_data = 1;
 	lim->max_segments = USHRT_MAX;
 	lim->max_discard_segments = 1;
 	lim->max_hw_sectors = UINT_MAX;
@@ -623,7 +621,6 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
 
 	t->cluster &= b->cluster;
-	t->discard_zeroes_data &= b->discard_zeroes_data;
 
 	/* Physical block size a multiple of the logical block size? */
 	if (t->physical_block_size & (t->logical_block_size - 1)) {
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index c44b321335f3..ca88a533b735 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -208,7 +208,7 @@ static ssize_t queue_discard_max_store(struct request_queue *q,
 
 static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *page)
 {
-	return queue_var_show(queue_discard_zeroes_data(q), page);
+	return 0;
 }
 
 static ssize_t queue_write_same_max_show(struct request_queue *q, char *page)
diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 570021a0dc1c..04325b81c2b4 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -685,7 +685,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case BLKALIGNOFF:
 		return compat_put_int(arg, bdev_alignment_offset(bdev));
 	case BLKDISCARDZEROES:
-		return compat_put_uint(arg, bdev_discard_zeroes_data(bdev));
+		return compat_put_uint(arg, 0);
 	case BLKFLSBUF:
 	case BLKROSET:
 	case BLKDISCARD:
diff --git a/block/ioctl.c b/block/ioctl.c
index 304685022d9f..1a1586f3baa1 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -546,7 +546,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKALIGNOFF:
 		return put_int(arg, bdev_alignment_offset(bdev));
 	case BLKDISCARDZEROES:
-		return put_uint(arg, bdev_discard_zeroes_data(bdev));
+		return put_uint(arg, 0);
 	case BLKSECTGET:
 		max_sectors = min_t(unsigned int, USHRT_MAX,
 				    queue_max_sectors(bdev_get_queue(bdev)));
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 965b9e7dbb7d..6fb870cac932 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1327,7 +1327,7 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 		sdev->ata_trim = 1;
 		if (ata_id_has_zero_after_trim(dev->id) &&
 		    (dev->horkage & ATA_HORKAGE_ZERO_AFTER_TRIM)) {
-			ata_dev_info(dev, "Enabling discard_zeroes_data\n");
+			ata_dev_info(dev, "Enabling zeroing using TRIM\n");
 			sdev->ata_trim_zeroes_data = 1;
 		}
 	}
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 8e62d9f65510..84455c365f57 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -931,7 +931,6 @@ void assign_p_sizes_qlim(struct drbd_device *device, struct p_sizes *p, struct r
 		p->qlim->io_min = cpu_to_be32(queue_io_min(q));
 		p->qlim->io_opt = cpu_to_be32(queue_io_opt(q));
 		p->qlim->discard_enabled = blk_queue_discard(q);
-		p->qlim->discard_zeroes_data = queue_discard_zeroes_data(q);
 		p->qlim->write_same_capable = !!q->limits.max_write_same_sectors;
 	} else {
 		q = device->rq_queue;
@@ -941,7 +940,6 @@ void assign_p_sizes_qlim(struct drbd_device *device, struct p_sizes *p, struct r
 		p->qlim->io_min = cpu_to_be32(queue_io_min(q));
 		p->qlim->io_opt = cpu_to_be32(queue_io_opt(q));
 		p->qlim->discard_enabled = 0;
-		p->qlim->discard_zeroes_data = 0;
 		p->qlim->write_same_capable = 0;
 	}
 }
diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index e4516d3b971d..02255a0d68b9 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1199,10 +1199,6 @@ static void decide_on_discard_support(struct drbd_device *device,
 	struct drbd_connection *connection = first_peer_device(device)->connection;
 	bool can_do = b ? blk_queue_discard(b) : true;
 
-	if (can_do && b && !b->limits.discard_zeroes_data && !discard_zeroes_if_aligned) {
-		can_do = false;
-		drbd_info(device, "discard_zeroes_data=0 and discard_zeroes_if_aligned=no: disabling discards\n");
-	}
 	if (can_do && connection->cstate >= C_CONNECTED && !(connection->agreed_features & DRBD_FF_TRIM)) {
 		can_do = false;
 		drbd_info(connection, "peer DRBD too old, does not support TRIM: disabling discards\n");
@@ -1484,8 +1480,7 @@ static void sanitize_disk_conf(struct drbd_device *device, struct disk_conf *dis
 	if (disk_conf->al_extents > drbd_al_extents_max(nbc))
 		disk_conf->al_extents = drbd_al_extents_max(nbc);
 
-	if (!blk_queue_discard(q)
-	    || (!q->limits.discard_zeroes_data && !disk_conf->discard_zeroes_if_aligned)) {
+	if (!blk_queue_discard(q)) {
 		if (disk_conf->rs_discard_granularity) {
 			disk_conf->rs_discard_granularity = 0; /* disable feature */
 			drbd_info(device, "rs_discard_granularity feature disabled\n");
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 265cd2e33ff0..57f68f4ee886 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -828,7 +828,6 @@ static void loop_config_discard(struct loop_device *lo)
 		q->limits.discard_alignment = 0;
 		blk_queue_max_discard_sectors(q, 0);
 		blk_queue_max_write_zeroes_sectors(q, 0);
-		q->limits.discard_zeroes_data = 0;
 		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, q);
 		return;
 	}
@@ -837,7 +836,6 @@ static void loop_config_discard(struct loop_device *lo)
 	q->limits.discard_alignment = 0;
 	blk_queue_max_discard_sectors(q, UINT_MAX >> 9);
 	blk_queue_max_write_zeroes_sectors(q, UINT_MAX >> 9);
-	q->limits.discard_zeroes_data = 1;
 	queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
 }
 
diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index f96ab717534c..7efac4ee26b2 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4025,7 +4025,6 @@ static int mtip_block_initialize(struct driver_data *dd)
 		dd->queue->limits.discard_granularity = 4096;
 		blk_queue_max_discard_sectors(dd->queue,
 			MTIP_MAX_TRIM_ENTRY_LEN * MTIP_MAX_TRIM_ENTRIES);
-		dd->queue->limits.discard_zeroes_data = 0;
 	}
 
 	/* Set the capacity of the device in 512 byte sectors. */
diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 7e4287bc19e5..616e5c6d3ebd 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1040,7 +1040,6 @@ static int nbd_dev_add(int index)
 	queue_flag_clear_unlocked(QUEUE_FLAG_ADD_RANDOM, disk->queue);
 	disk->queue->limits.discard_granularity = 512;
 	blk_queue_max_discard_sectors(disk->queue, UINT_MAX);
-	disk->queue->limits.discard_zeroes_data = 0;
 	blk_queue_max_hw_sectors(disk->queue, 65536);
 	disk->queue->limits.max_sectors = 256;
 
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 9c689b34e6e7..975922c8f231 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2773,7 +2773,6 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 
 	ti->num_discard_bios = 1;
 	ti->discards_supported = true;
-	ti->discard_zeroes_data_unsupported = true;
 	ti->split_discard_bios = false;
 
 	cache->features = ca->features;
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 389a3637ffcc..ef1d836bd81b 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2030,7 +2030,6 @@ static int crypt_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	wake_up_process(cc->write_thread);
 
 	ti->num_flush_bios = 1;
-	ti->discard_zeroes_data_unsupported = true;
 
 	return 0;
 
diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index f8564d63982f..468f1380de1d 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -2813,7 +2813,9 @@ static void configure_discard_support(struct raid_set *rs)
 	/* Assume discards not supported until after checks below. */
 	ti->discards_supported = false;
 
-	/* RAID level 4,5,6 require discard_zeroes_data for data integrity! */
+	/*
+	 * XXX: RAID level 4,5,6 require zeroing for safety.
+	 */
 	raid456 = (rs->md.level == 4 || rs->md.level == 5 || rs->md.level == 6);
 
 	for (i = 0; i < rs->raid_disks; i++) {
@@ -2827,8 +2829,6 @@ static void configure_discard_support(struct raid_set *rs)
 			return;
 
 		if (raid456) {
-			if (!q->limits.discard_zeroes_data)
-				return;
 			if (!devices_handle_discard_safely) {
 				DMERR("raid456 discard support disabled due to discard_zeroes_data uncertainty.");
 				DMERR("Set dm-raid.devices_handle_discard_safely=Y to override.");
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index 2ddc2d20e62d..a95cbb80fb34 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -1124,7 +1124,6 @@ static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->per_io_data_size = sizeof(struct dm_raid1_bio_record);
-	ti->discard_zeroes_data_unsupported = true;
 
 	ms->kmirrord_wq = alloc_workqueue("kmirrord", WQ_MEM_RECLAIM, 0);
 	if (!ms->kmirrord_wq) {
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 5cd665c91ead..958275aca008 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1449,22 +1449,6 @@ static bool dm_table_supports_flush(struct dm_table *t, unsigned long flush)
 	return false;
 }
 
-static bool dm_table_discard_zeroes_data(struct dm_table *t)
-{
-	struct dm_target *ti;
-	unsigned i = 0;
-
-	/* Ensure that all targets supports discard_zeroes_data. */
-	while (i < dm_table_get_num_targets(t)) {
-		ti = dm_table_get_target(t, i++);
-
-		if (ti->discard_zeroes_data_unsupported)
-			return false;
-	}
-
-	return true;
-}
-
 static int device_is_nonrot(struct dm_target *ti, struct dm_dev *dev,
 			    sector_t start, sector_t len, void *data)
 {
@@ -1620,9 +1604,6 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	}
 	blk_queue_write_cache(q, wc, fua);
 
-	if (!dm_table_discard_zeroes_data(t))
-		q->limits.discard_zeroes_data = 0;
-
 	/* Ensure that all underlying devices are non-rotational. */
 	if (dm_table_all_devices_attribute(t, device_is_nonrot))
 		queue_flag_set_unlocked(QUEUE_FLAG_NONROT, q);
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 2b266a2b5035..a5f1916f621a 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -3263,7 +3263,6 @@ static int pool_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	 * them down to the data device.  The thin device's discard
 	 * processing will cause mappings to be removed from the btree.
 	 */
-	ti->discard_zeroes_data_unsupported = true;
 	if (pf.discard_enabled && pf.discard_passdown) {
 		ti->num_discard_bios = 1;
 
@@ -4119,7 +4118,6 @@ static int thin_ctr(struct dm_target *ti, unsigned argc, char **argv)
 	ti->per_io_data_size = sizeof(struct dm_thin_endio_hook);
 
 	/* In case the pool supports discards, pass them on. */
-	ti->discard_zeroes_data_unsupported = true;
 	if (tc->pool->pf.discard_enabled) {
 		ti->discards_supported = true;
 		ti->num_discard_bios = 1;
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8cf1f86dcd05..a4b04d0dc829 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7265,12 +7265,6 @@ static int raid5_run(struct mddev *mddev)
 		blk_queue_max_discard_sectors(mddev->queue,
 					      0xfffe * STRIPE_SECTORS);
 
-		/*
-		 * unaligned part of discard request will be ignored, so can't
-		 * guarantee discard_zeroes_data
-		 */
-		mddev->queue->limits.discard_zeroes_data = 0;
-
 		blk_queue_max_write_same_sectors(mddev->queue, 0);
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
 
@@ -7280,7 +7274,7 @@ static int raid5_run(struct mddev *mddev)
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->new_data_offset << 9);
 			/*
-			 * discard_zeroes_data is required, otherwise data
+			 * zeroing is required, otherwise data
 			 * could be lost. Consider a scenario: discard a stripe
 			 * (the stripe could be inconsistent if
 			 * discard_zeroes_data is 0); write one disk of the
@@ -7289,10 +7283,6 @@ static int raid5_run(struct mddev *mddev)
 			 * parity); the disk is broken; The stripe data of this
 			 * disk is lost.
 			 */
-			if (!blk_queue_discard(bdev_get_queue(rdev->bdev)) ||
-			    !bdev_get_queue(rdev->bdev)->
-						limits.discard_zeroes_data)
-				discard_supported = false;
 			/* Unfortunately, discard_zeroes_data is not currently
 			 * a guarantee - just a hint.  So we only allow DISCARD
 			 * if the sysadmin has confirmed that only safe devices
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ca96bb33471b..65ed02438565 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -645,8 +645,6 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	unsigned int logical_block_size = sdkp->device->sector_size;
 	unsigned int max_blocks = 0, max_ranges = 0, max_range_size = 0;
 
-	q->limits.discard_zeroes_data = 0;
-
 	/*
 	 * When LBPRZ is reported, discard alignment and granularity
 	 * must be fixed to the logical block size. Otherwise the block
@@ -682,27 +680,22 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	case SD_LBP_WS16:
 		max_blocks = min_not_zero(sdkp->max_ws_blocks,
 					  (u32)SD_MAX_WS16_BLOCKS);
-		q->limits.discard_zeroes_data = sdkp->lbprz;
 		break;
 
 	case SD_LBP_WS10:
 		max_blocks = min_not_zero(sdkp->max_ws_blocks,
 					  (u32)SD_MAX_WS10_BLOCKS);
-		q->limits.discard_zeroes_data = sdkp->lbprz;
 		break;
 
 	case SD_LBP_ZERO:
 		max_blocks = min_not_zero(sdkp->max_ws_blocks,
 					  (u32)SD_MAX_WS10_BLOCKS);
-		q->limits.discard_zeroes_data = 1;
 		break;
 
 	case SD_LBP_ATA_TRIM:
 		max_ranges = 512 / sizeof(__le64);
 		max_range_size = USHRT_MAX;
 		max_blocks = max_ranges * max_range_size;
-		if (sdkp->device->ata_trim_zeroes_data)
-			q->limits.discard_zeroes_data = 1;
 		break;
 	}
 
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index c754ae33bf7b..d2f089cfa9ae 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -851,7 +851,7 @@ bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
 	attrib->unmap_granularity = q->limits.discard_granularity / block_size;
 	attrib->unmap_granularity_alignment = q->limits.discard_alignment /
 								block_size;
-	attrib->unmap_zeroes_data = q->limits.discard_zeroes_data;
+	attrib->unmap_zeroes_data = 0;
 	return true;
 }
 EXPORT_SYMBOL(target_configure_unmap_from_queue);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1bddcfc631a4..aa1ac2c0f393 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -338,7 +338,6 @@ struct queue_limits {
 	unsigned char		misaligned;
 	unsigned char		discard_misaligned;
 	unsigned char		cluster;
-	unsigned char		discard_zeroes_data;
 	unsigned char		raid_partial_stripes_expensive;
 	enum blk_zoned_model	zoned;
 };
@@ -1338,7 +1337,6 @@ extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 
 #define BLKDEV_DISCARD_SECURE	(1 << 0)	/* issue a secure erase */
-#define BLKDEV_DISCARD_ZERO	(1 << 1)	/* must reliably zero data */
 
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
@@ -1543,19 +1541,6 @@ static inline int bdev_discard_alignment(struct block_device *bdev)
 	return q->limits.discard_alignment;
 }
 
-static inline unsigned int queue_discard_zeroes_data(struct request_queue *q)
-{
-	if (q->limits.max_discard_sectors && q->limits.discard_zeroes_data == 1)
-		return 1;
-
-	return 0;
-}
-
-static inline unsigned int bdev_discard_zeroes_data(struct block_device *bdev)
-{
-	return queue_discard_zeroes_data(bdev_get_queue(bdev));
-}
-
 static inline unsigned int bdev_write_same(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 3829bee2302a..c7ea33e38fb9 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -296,11 +296,6 @@ struct dm_target {
 	 * on max_io_len boundary.
 	 */
 	bool split_discard_bios:1;
-
-	/*
-	 * Set if this target does not return zeroes on discarded blocks.
-	 */
-	bool discard_zeroes_data_unsupported:1;
 };
 
 /* Each target can link one of these into the table */
-- 
2.11.0
