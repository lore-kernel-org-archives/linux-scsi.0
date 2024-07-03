Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678F31C68D;
	Wed,  3 Jul 2024 23:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720049981; cv=none; b=P34IXVsdBc2m8wxyAnAFlZN2b5QCwFssIMAv+LYa4S9cqjX9kIGNt1F8cMQffQospG0QxV371YO+8Xa1DO80WLFi45HlBzDGM0tHc5Mrx7ZfjgS2PttNOgV3Bgd8fBxakyOAzI64shQIogOydTxg/64mq2HTmcu/ZH/9GAKWpGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720049981; c=relaxed/simple;
	bh=jLQM6I5vyGpFlL7n7KESLJ3HHCxcPTLgVjes8j65Bfw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcP+TyyVDNkEVdETXpez6rvcFuqxzLu0E+z/RWtZeCyZB1G4xReX9LW2jnz2FCb+r7b6R7mHATEMcHOvFcnopeXGFMYQwDbx7ZfAowslDzYD6MedwCEkCA5O7vSHZB8vMLriBfPHKdtHuCz6oHrywcCZKgi/uS/napbZvThYNGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HNhWy0Qj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HNhWy0Qj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD99BC2BD10;
	Wed,  3 Jul 2024 23:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720049981;
	bh=jLQM6I5vyGpFlL7n7KESLJ3HHCxcPTLgVjes8j65Bfw=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HNhWy0Qj9qQmUWVR+pxLv7nmTTvPFOmxMndbpJRkZXjdbNT54MSwoSrI0gOeEXnNb
	 8ra4oJpC/BwcGh0UK2yJC6ogAwP6T4EBXzBcUtMGyd7dDI4Def3WWnI+TeNeEGM5Qa
	 mKBv3PkD7nNOwvUI/tv0ylHzIE4siTnpB0h1kMSAV/ZoG1+Y05udo7LBug6NXmLffA
	 mZw1czUWi8WI/wE5poTSL9rd9ieGLRfUiuGOZ0AriprupwMTvbbgqJ+O00tw9FsSxf
	 m5ULtNW9a52ve9wsxtzrlrPYNWqaNomLmRjMdHEPXXps9USSLoEFn4mM701VmFaEzl
	 RM6tzzak+iavQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/5] block: Remove REQ_OP_ZONE_RESET_ALL emulation
Date: Thu,  4 Jul 2024 08:39:31 +0900
Message-ID: <20240703233932.545228-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703233932.545228-1-dlemoal@kernel.org>
References: <20240703233932.545228-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Now that device mapper can handle resetting all zones of a mapped zoned
device using REQ_OP_ZONE_RESET_ALL, all zoned block device drivers
support this operation. With this, the request queue feature
BLK_FEAT_ZONE_RESETALL is not necessary and the emulation code in
blk-zone.c can be removed.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-core.c               |  2 +-
 block/blk-zoned.c              | 76 ++--------------------------------
 drivers/block/null_blk/zoned.c |  2 +-
 drivers/block/ublk_drv.c       |  2 +-
 drivers/block/virtio_blk.c     |  2 +-
 drivers/nvme/host/zns.c        |  2 +-
 drivers/scsi/sd_zbc.c          |  2 +-
 include/linux/blkdev.h         |  5 ---
 8 files changed, 9 insertions(+), 84 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 71b7622c523a..0c25df9758d0 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -834,7 +834,7 @@ void submit_bio_noacct(struct bio *bio)
 			goto not_supported;
 		break;
 	case REQ_OP_ZONE_RESET_ALL:
-		if (!bdev_is_zoned(bio->bi_bdev) || !blk_queue_zone_resetall(q))
+		if (!bdev_is_zoned(bio->bi_bdev))
 			goto not_supported;
 		break;
 	case REQ_OP_DRV_IN:
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 07831fb67201..b104f5175783 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -157,70 +157,6 @@ static inline unsigned long *blk_alloc_zone_bitmap(int node,
 			    GFP_NOIO, node);
 }
 
-static int blk_zone_need_reset_cb(struct blk_zone *zone, unsigned int idx,
-				  void *data)
-{
-	/*
-	 * For an all-zones reset, ignore conventional, empty, read-only
-	 * and offline zones.
-	 */
-	switch (zone->cond) {
-	case BLK_ZONE_COND_NOT_WP:
-	case BLK_ZONE_COND_EMPTY:
-	case BLK_ZONE_COND_READONLY:
-	case BLK_ZONE_COND_OFFLINE:
-		return 0;
-	default:
-		set_bit(idx, (unsigned long *)data);
-		return 0;
-	}
-}
-
-static int blkdev_zone_reset_all_emulated(struct block_device *bdev)
-{
-	struct gendisk *disk = bdev->bd_disk;
-	sector_t capacity = bdev_nr_sectors(bdev);
-	sector_t zone_sectors = bdev_zone_sectors(bdev);
-	unsigned long *need_reset;
-	struct bio *bio = NULL;
-	sector_t sector = 0;
-	int ret;
-
-	need_reset = blk_alloc_zone_bitmap(disk->queue->node, disk->nr_zones);
-	if (!need_reset)
-		return -ENOMEM;
-
-	ret = disk->fops->report_zones(disk, 0, disk->nr_zones,
-				       blk_zone_need_reset_cb, need_reset);
-	if (ret < 0)
-		goto out_free_need_reset;
-
-	ret = 0;
-	while (sector < capacity) {
-		if (!test_bit(disk_zone_no(disk, sector), need_reset)) {
-			sector += zone_sectors;
-			continue;
-		}
-
-		bio = blk_next_bio(bio, bdev, 0, REQ_OP_ZONE_RESET | REQ_SYNC,
-				   GFP_KERNEL);
-		bio->bi_iter.bi_sector = sector;
-		sector += zone_sectors;
-
-		/* This may take a while, so be nice to others */
-		cond_resched();
-	}
-
-	if (bio) {
-		ret = submit_bio_wait(bio);
-		bio_put(bio);
-	}
-
-out_free_need_reset:
-	kfree(need_reset);
-	return ret;
-}
-
 static int blkdev_zone_reset_all(struct block_device *bdev)
 {
 	struct bio bio;
@@ -247,7 +183,6 @@ static int blkdev_zone_reset_all(struct block_device *bdev)
 int blkdev_zone_mgmt(struct block_device *bdev, enum req_op op,
 		     sector_t sector, sector_t nr_sectors)
 {
-	struct request_queue *q = bdev_get_queue(bdev);
 	sector_t zone_sectors = bdev_zone_sectors(bdev);
 	sector_t capacity = bdev_nr_sectors(bdev);
 	sector_t end_sector = sector + nr_sectors;
@@ -275,16 +210,11 @@ int blkdev_zone_mgmt(struct block_device *bdev, enum req_op op,
 		return -EINVAL;
 
 	/*
-	 * In the case of a zone reset operation over all zones,
-	 * REQ_OP_ZONE_RESET_ALL can be used with devices supporting this
-	 * command. For other devices, we emulate this command behavior by
-	 * identifying the zones needing a reset.
+	 * In the case of a zone reset operation over all zones, use
+	 * REQ_OP_ZONE_RESET_ALL.
 	 */
-	if (op == REQ_OP_ZONE_RESET && sector == 0 && nr_sectors == capacity) {
-		if (!blk_queue_zone_resetall(q))
-			return blkdev_zone_reset_all_emulated(bdev);
+	if (op == REQ_OP_ZONE_RESET && sector == 0 && nr_sectors == capacity)
 		return blkdev_zone_reset_all(bdev);
-	}
 
 	while (sector < end_sector) {
 		bio = blk_next_bio(bio, bdev, 0, op | REQ_SYNC, GFP_KERNEL);
diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 7996e2e7dce2..9bc768b2ca56 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -164,7 +164,7 @@ int null_init_zoned_dev(struct nullb_device *dev,
 		sector += dev->zone_size_sects;
 	}
 
-	lim->features |= BLK_FEAT_ZONED | BLK_FEAT_ZONE_RESETALL;
+	lim->features |= BLK_FEAT_ZONED;
 	lim->chunk_sectors = dev->zone_size_sects;
 	lim->max_zone_append_sectors = dev->zone_append_max_sectors;
 	lim->max_open_zones = dev->zone_max_open;
diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 4fdff13fc23b..d10a2ea07292 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2194,7 +2194,7 @@ static int ublk_ctrl_start_dev(struct ublk_device *ub, struct io_uring_cmd *cmd)
 		if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED))
 			return -EOPNOTSUPP;
 
-		lim.features |= BLK_FEAT_ZONED | BLK_FEAT_ZONE_RESETALL;
+		lim.features |= BLK_FEAT_ZONED;
 		lim.max_active_zones = p->max_active_zones;
 		lim.max_open_zones =  p->max_open_zones;
 		lim.max_zone_append_sectors = p->max_zone_append_sectors;
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index 6c64a67ab9c9..84c3efd0c611 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -728,7 +728,7 @@ static int virtblk_read_zoned_limits(struct virtio_blk *vblk,
 
 	dev_dbg(&vdev->dev, "probing host-managed zoned device\n");
 
-	lim->features |= BLK_FEAT_ZONED | BLK_FEAT_ZONE_RESETALL;
+	lim->features |= BLK_FEAT_ZONED;
 
 	virtio_cread(vdev, struct virtio_blk_config,
 		     zoned.max_open_zones, &v);
diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 99bb89c2495a..9a06f9d98cd6 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -108,7 +108,7 @@ int nvme_query_zone_info(struct nvme_ns *ns, unsigned lbaf,
 void nvme_update_zone_info(struct nvme_ns *ns, struct queue_limits *lim,
 		struct nvme_zone_info *zi)
 {
-	lim->features |= BLK_FEAT_ZONED | BLK_FEAT_ZONE_RESETALL;
+	lim->features |= BLK_FEAT_ZONED;
 	lim->max_open_zones = zi->max_open_zones;
 	lim->max_active_zones = zi->max_active_zones;
 	lim->max_zone_append_sectors = ns->ctrl->max_zone_append;
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index f7067afac79c..c8b9654d30f0 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -599,7 +599,7 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, struct queue_limits *lim,
 	if (sdkp->device->type != TYPE_ZBC)
 		return 0;
 
-	lim->features |= BLK_FEAT_ZONED | BLK_FEAT_ZONE_RESETALL;
+	lim->features |= BLK_FEAT_ZONED;
 
 	/*
 	 * Per ZBC and ZAC specifications, writes in sequential write required
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 4d0d4b83bc74..dc250d8070d2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -318,9 +318,6 @@ typedef unsigned int __bitwise blk_features_t;
 /* is a zoned device */
 #define BLK_FEAT_ZONED			((__force blk_features_t)(1u << 10))
 
-/* supports Zone Reset All */
-#define BLK_FEAT_ZONE_RESETALL		((__force blk_features_t)(1u << 11))
-
 /* supports PCI(e) p2p requests */
 #define BLK_FEAT_PCI_P2PDMA		((__force blk_features_t)(1u << 12))
 
@@ -618,8 +615,6 @@ void blk_queue_flag_clear(unsigned int flag, struct request_queue *q);
 	test_bit(QUEUE_FLAG_NOXMERGES, &(q)->queue_flags)
 #define blk_queue_nonrot(q)	(!((q)->limits.features & BLK_FEAT_ROTATIONAL))
 #define blk_queue_io_stat(q)	((q)->limits.features & BLK_FEAT_IO_STAT)
-#define blk_queue_zone_resetall(q)	\
-	((q)->limits.features & BLK_FEAT_ZONE_RESETALL)
 #define blk_queue_dax(q)	((q)->limits.features & BLK_FEAT_DAX)
 #define blk_queue_pci_p2pdma(q)	((q)->limits.features & BLK_FEAT_PCI_P2PDMA)
 #ifdef CONFIG_BLK_RQ_ALLOC_TIME
-- 
2.45.2

