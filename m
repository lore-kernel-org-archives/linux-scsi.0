From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 25/27] block: remove the discard_zeroes_data flag
Date: Wed,  5 Apr 2017 19:21:23 +0200
Message-ID: <20170405172125.22600-26-hch@lst.de>
References: <20170405172125.22600-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170405172125.22600-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com, agk@redhat.com, snitzer@redhat.com, shli@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, drbd-dev@lists.linbit.com, dm-devel@redhat.com, linux-raid@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Now that we use the proper REQ_OP_WRITE_ZEROES operation everywhere we can
kill this hack.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 Documentation/ABI/testing/sysfs-block | 10 ++-----
 Documentation/block/queue-sysfs.txt   |  5 ----
 block/blk-lib.c                       |  7 +----
 block/blk-settings.c                  |  3 ---
 block/blk-sysfs.c                     |  2 +-
 block/compat_ioctl.c                  |  2 +-
 block/ioctl.c                         |  2 +-
 drivers/block/drbd/drbd_main.c        |  2 --
 drivers/block/drbd/drbd_nl.c          |  7 +----
 drivers/block/loop.c                  |  2 --
 drivers/block/mtip32xx/mtip32xx.c     |  1 -
 drivers/block/nbd.c                   |  1 -
 drivers/md/dm-cache-target.c          |  1 -
 drivers/md/dm-crypt.c                 |  1 -
 drivers/md/dm-raid.c                  |  6 ++---
 drivers/md/dm-raid1.c                 |  1 -
 drivers/md/dm-table.c                 | 19 -------------
 drivers/md/dm-thin.c                  |  2 --
 drivers/md/raid5.c                    | 50 +++++++++++------------------------
 drivers/scsi/sd.c                     |  5 ----
 drivers/target/target_core_device.c   |  2 +-
 include/linux/blkdev.h                | 15 -----------
 include/linux/device-mapper.h         |  5 ----
 23 files changed, 27 insertions(+), 124 deletions(-)

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
index b7f6bdc96d73..2c1e67058fd3 100644
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
index b0c6c4bcf441..e8caecd71688 100644
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
index 1e7174ffc9d4..4fa81ed383ca 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -103,7 +103,6 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->discard_granularity = 0;
 	lim->discard_alignment = 0;
 	lim->discard_misaligned = 0;
-	lim->discard_zeroes_data = 0;
 	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
 	lim->bounce_pfn = (unsigned long)(BLK_BOUNCE_ANY >> PAGE_SHIFT);
 	lim->alignment_offset = 0;
@@ -127,7 +126,6 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	blk_set_default_limits(lim);
 
 	/* Inherit limits from component devices */
-	lim->discard_zeroes_data = 1;
 	lim->max_segments = USHRT_MAX;
 	lim->max_discard_segments = 1;
 	lim->max_hw_sectors = UINT_MAX;
@@ -609,7 +607,6 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->io_opt = lcm_not_zero(t->io_opt, b->io_opt);
 
 	t->cluster &= b->cluster;
-	t->discard_zeroes_data &= b->discard_zeroes_data;
 
 	/* Physical block size a multiple of the logical block size? */
 	if (t->physical_block_size & (t->logical_block_size - 1)) {
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 45854266e398..b65ce3c65ae8 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -208,7 +208,7 @@ static ssize_t queue_discard_max_store(struct request_queue *q,
 
 static ssize_t queue_discard_zeroes_data_show(struct request_queue *q, char *page)
 {
-	return queue_var_show(queue_discard_zeroes_data(q), page);
+	return queue_var_show(0, page);
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
index 8ea00a41be01..0de02ee67eed 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -547,7 +547,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKALIGNOFF:
 		return put_int(arg, bdev_alignment_offset(bdev));
 	case BLKDISCARDZEROES:
-		return put_uint(arg, bdev_discard_zeroes_data(bdev));
+		return put_uint(arg, 0);
 	case BLKSECTGET:
 		max_sectors = min_t(unsigned int, USHRT_MAX,
 				    queue_max_sectors(bdev_get_queue(bdev)));
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
index 3bb04c1a4ba1..3081d83d2ea3 100644
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
index 30076e7753bc..05e3e664ea1b 100644
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
index 03ae72985c79..b02f2362fdf7 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1110,7 +1110,6 @@ static int nbd_dev_add(int index)
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
index 8cf1f86dcd05..d6ae8d22d461 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7229,7 +7229,6 @@ static int raid5_run(struct mddev *mddev)
 
 	if (mddev->queue) {
 		int chunk_size;
-		bool discard_supported = true;
 		/* read-ahead size must cover two whole stripes, which
 		 * is 2 * (datadisks) * chunksize where 'n' is the
 		 * number of raid devices
@@ -7265,12 +7264,6 @@ static int raid5_run(struct mddev *mddev)
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
 
@@ -7279,35 +7272,24 @@ static int raid5_run(struct mddev *mddev)
 					  rdev->data_offset << 9);
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->new_data_offset << 9);
-			/*
-			 * discard_zeroes_data is required, otherwise data
-			 * could be lost. Consider a scenario: discard a stripe
-			 * (the stripe could be inconsistent if
-			 * discard_zeroes_data is 0); write one disk of the
-			 * stripe (the stripe could be inconsistent again
-			 * depending on which disks are used to calculate
-			 * parity); the disk is broken; The stripe data of this
-			 * disk is lost.
-			 */
-			if (!blk_queue_discard(bdev_get_queue(rdev->bdev)) ||
-			    !bdev_get_queue(rdev->bdev)->
-						limits.discard_zeroes_data)
-				discard_supported = false;
-			/* Unfortunately, discard_zeroes_data is not currently
-			 * a guarantee - just a hint.  So we only allow DISCARD
-			 * if the sysadmin has confirmed that only safe devices
-			 * are in use by setting a module parameter.
-			 */
-			if (!devices_handle_discard_safely) {
-				if (discard_supported) {
-					pr_info("md/raid456: discard support disabled due to uncertainty.\n");
-					pr_info("Set raid456.devices_handle_discard_safely=Y to override.\n");
-				}
-				discard_supported = false;
-			}
 		}
 
-		if (discard_supported &&
+		/*
+		 * zeroing is required, otherwise data
+		 * could be lost. Consider a scenario: discard a stripe
+		 * (the stripe could be inconsistent if
+		 * discard_zeroes_data is 0); write one disk of the
+		 * stripe (the stripe could be inconsistent again
+		 * depending on which disks are used to calculate
+		 * parity); the disk is broken; The stripe data of this
+		 * disk is lost.
+		 *
+		 * We only allow DISCARD if the sysadmin has confirmed that
+		 * only safe devices are in use by setting a module parameter.
+		 * A better idea might be to turn DISCARD into WRITE_ZEROES
+		 * requests, as that is required to be safe.
+		 */
+		if (devices_handle_discard_safely &&
 		    mddev->queue->limits.max_discard_sectors >= (stripe >> 9) &&
 		    mddev->queue->limits.discard_granularity >= stripe)
 			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 001593ed0444..bcb0cb020fd2 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -644,8 +644,6 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 	unsigned int logical_block_size = sdkp->device->sector_size;
 	unsigned int max_blocks = 0;
 
-	q->limits.discard_zeroes_data = 0;
-
 	/*
 	 * When LBPRZ is reported, discard alignment and granularity
 	 * must be fixed to the logical block size. Otherwise the block
@@ -681,19 +679,16 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
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
index a5055d760661..d5d9dd72418a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -339,7 +339,6 @@ struct queue_limits {
 	unsigned char		misaligned;
 	unsigned char		discard_misaligned;
 	unsigned char		cluster;
-	unsigned char		discard_zeroes_data;
 	unsigned char		raid_partial_stripes_expensive;
 	enum blk_zoned_model	zoned;
 };
@@ -1342,7 +1341,6 @@ extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 
 #define BLKDEV_DISCARD_SECURE	(1 << 0)	/* issue a secure erase */
-#define BLKDEV_DISCARD_ZERO	(1 << 1)	/* must reliably zero data */
 
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
@@ -1542,19 +1540,6 @@ static inline int bdev_discard_alignment(struct block_device *bdev)
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
