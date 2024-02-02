Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67D1E40BE9;
	Fri,  2 Feb 2024 07:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859093; cv=none; b=fOC71BDgS0wzaHnkyKx6++3YtCnlgchtdNmSI6jt1Wf6czmbZZqqpnaUVkDBPiHH8su2r4TowwKK7KKF485f8rmVhzDZGTz1AyINqvNKmWtnpTTO2v0KjhM70ni00G7ziIgBiY7bipitCgIT/vULdI2VASdt0jA2uyt0QZFS+Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859093; c=relaxed/simple;
	bh=Jat/kVp123yWGk22irG4aEbfBVPnhWQGVUpd2BA1/fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AZnqv43kl6f9bPn7AWnMRai1is8fcCQV9owYmmoXU+QjLjXXxzIAvPTvUZxYtshW2lO0u+69r2Eq/vmIrSQvdvUoCI5Jji/5uZFKVtDQuQDCVutSqO/Wv4Bum3wbZ2LTiZ2S0b9A/CGF6jQpZn3xLNLlroGxHOty61Tq3wehC5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FeJUOT/L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FeJUOT/L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5C6C433F1;
	Fri,  2 Feb 2024 07:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859093;
	bh=Jat/kVp123yWGk22irG4aEbfBVPnhWQGVUpd2BA1/fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FeJUOT/LvoxQYDwiUF+iV0tFzwg0qo/N8GQDYAi/DErd7PZUXyZpUUBYKWnosHS3E
	 YpPRF0jEe5Jt64fLnyzlfgulSAkWMnJR7RCyGu5u8kd2P9Nxa8SBmu3GCg8pDbQQ9r
	 xSvz9h4cXUthg/Fj+d6/3Ah6NsBO3+jEBEnU/F6hDZGtdG7/jID4nNn6XAzPhfC0Xk
	 vPEj7wDP7L4fm3V1E2/mWC+xx/5SUr8t3k1osIByNmoD83xVmHtF3Ho9+a22ULHHox
	 msPs4GzBFcktGvzb4WqE7WqwHdzmm4TQhn/S51Bqe9O++4Kd2SsUXjAnQlQwM2mRcn
	 FIdiBNBTGjtGA==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 18/26] block: Simplify blk_revalidate_disk_zones() interface
Date: Fri,  2 Feb 2024 16:30:56 +0900
Message-ID: <20240202073104.2418230-19-dlemoal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202073104.2418230-1-dlemoal@kernel.org>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The only user of blk_revalidate_disk_zones() second argument was the
SCSI disk driver (sd). Now that this driver does not require this
update_driver_data argument, remove it to simplify the interface of
blk_revalidate_disk_zones(). Also update the function kdoc comment to
be more accurate (i.e. there is no gendisk ->revalidate method).

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c              | 16 +++++-----------
 drivers/block/null_blk/zoned.c |  2 +-
 drivers/block/ublk_drv.c       |  2 +-
 drivers/block/virtio_blk.c     |  2 +-
 drivers/md/dm-zone.c           |  2 +-
 drivers/nvme/host/zns.c        |  2 +-
 drivers/scsi/sd_zbc.c          |  2 +-
 include/linux/blkdev.h         |  3 +--
 8 files changed, 12 insertions(+), 19 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 8bf6821735f3..3dadf37ad787 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1309,21 +1309,17 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 /**
  * blk_revalidate_disk_zones - (re)allocate and initialize zone bitmaps
  * @disk:	Target disk
- * @update_driver_data:	Callback to update driver data on the frozen disk
  *
- * Helper function for low-level device drivers to check and (re) allocate and
- * initialize a disk request queue zone bitmaps. This functions should normally
- * be called within the disk ->revalidate method for blk-mq based drivers.
+ * Helper function for low-level device drivers to check, (re) allocate and
+ * initialize resources used for managing zoned disks. This function should
+ * normally be called by blk-mq based drivers when a zoned gendisk is probed
+ * and when the zone configuration of the gendisk changes (e.g. after a format).
  * Before calling this function, the device driver must already have set the
  * device zone size (chunk_sector limit) and the max zone append limit.
  * BIO based drivers can also use this function as long as the device queue
  * can be safely frozen.
- * If the @update_driver_data callback function is not NULL, the callback is
- * executed with the device request queue frozen after all zones have been
- * checked.
  */
-int blk_revalidate_disk_zones(struct gendisk *disk,
-			      void (*update_driver_data)(struct gendisk *disk))
+int blk_revalidate_disk_zones(struct gendisk *disk)
 {
 	struct request_queue *q = disk->queue;
 	sector_t zone_sectors = q->limits.chunk_sectors;
@@ -1403,8 +1399,6 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 		swap(disk->seq_zones_wlock, args.seq_zones_wlock);
 		swap(disk->conv_zones_bitmap, args.conv_zones_bitmap);
 		swap(disk->zone_wplugs, args.zone_wplugs);
-		if (update_driver_data)
-			update_driver_data(disk);
 		mutex_unlock(&disk->zone_wplugs_mutex);
 		ret = 0;
 	} else {
diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index dd418b174e03..15fc325d8134 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -182,7 +182,7 @@ int null_register_zoned_dev(struct nullb *nullb)
 		queue_emulates_zone_append(q) ? "emulated" : "native");
 
 	if (queue_is_mq(q) || queue_emulates_zone_append(q))
-		return blk_revalidate_disk_zones(disk, NULL);
+		return blk_revalidate_disk_zones(disk);
 
 	return 0;
 }
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 35fb9cc739eb..daa0b5f5788c 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -221,7 +221,7 @@ static int ublk_get_nr_zones(const struct ublk_device *ub)
 
 static int ublk_revalidate_disk_zones(struct ublk_device *ub)
 {
-	return blk_revalidate_disk_zones(ub->ub_disk, NULL);
+	return blk_revalidate_disk_zones(ub->ub_disk);
 }
 
 static int ublk_dev_param_zoned_validate(const struct ublk_device *ub)
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 5bf98fd6a651..6c2b167ca136 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -788,7 +788,7 @@ static int virtblk_probe_zoned_device(struct virtio_device *vdev,
 	blk_queue_max_zone_append_sectors(q, v);
 	dev_dbg(&vdev->dev, "max append sectors = %u\n", v);
 
-	return blk_revalidate_disk_zones(vblk->disk, NULL);
+	return blk_revalidate_disk_zones(vblk->disk);
 }
 
 #else
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 570b44b924b8..b2ce19a78bbb 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -169,7 +169,7 @@ static int dm_revalidate_zones(struct mapped_device *md, struct dm_table *t)
 	 * our table for dm_blk_report_zones() to use directly.
 	 */
 	md->zone_revalidate_map = t;
-	ret = blk_revalidate_disk_zones(disk, NULL);
+	ret = blk_revalidate_disk_zones(disk);
 	md->zone_revalidate_map = NULL;
 
 	if (ret) {
diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 499bbb0eee8d..c02658af6c34 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -14,7 +14,7 @@ int nvme_revalidate_zones(struct nvme_ns *ns)
 	blk_queue_chunk_sectors(q, ns->head->zsze);
 	blk_queue_max_zone_append_sectors(q, ns->ctrl->max_zone_append);
 
-	return blk_revalidate_disk_zones(ns->disk, NULL);
+	return blk_revalidate_disk_zones(ns->disk);
 }
 
 static int nvme_set_max_append(struct nvme_ctrl *ctrl)
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index d0ead9858954..806036e48abe 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -572,7 +572,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	blk_queue_max_zone_append_sectors(q, 0);
 
 	flags = memalloc_noio_save();
-	ret = blk_revalidate_disk_zones(disk, NULL);
+	ret = blk_revalidate_disk_zones(disk);
 	memalloc_noio_restore(flags);
 	if (ret) {
 		sdkp->zone_info = (struct zoned_disk_info){ };
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e619e10847bd..a39ebf075d26 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -331,8 +331,7 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 		unsigned int nr_zones, report_zones_cb cb, void *data);
 int blkdev_zone_mgmt(struct block_device *bdev, enum req_op op,
 		sector_t sectors, sector_t nr_sectors, gfp_t gfp_mask);
-int blk_revalidate_disk_zones(struct gendisk *disk,
-		void (*update_driver_data)(struct gendisk *disk));
+int blk_revalidate_disk_zones(struct gendisk *disk);
 
 /*
  * Independent access ranges: struct blk_independent_access_range describes
-- 
2.43.0

