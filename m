Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7B91C322F;
	Mon, 25 Mar 2024 04:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711341911; cv=none; b=lSfzB5edrA5D+YqToXM0dvQUGPayA9MoojXiXF9/LxIZl1vCY9ebCwLk5kU5w3ASsuBhOHwI0K4gmhFHPgbaoLB8JwwWEujjhaFifkOeZK9ms72CXJZOi5MMoIbDC6lZb7o/heSV2uELPWiLPoyl6m414b/F6ZHPr4764SIRXTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711341911; c=relaxed/simple;
	bh=0ES/j5YKwo9VcxpvKOHpEYwHplTfg2Fp17R4OcX8qXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYcnl3pDklNY1i9bboo7a0jJ7qEi02s5jxRXY0g8flflPqatakWh5ut5y2jFzRpClZ2cwqobqG9fdjbviHHUXBwnTNrTzDyXLB+uGyeGBz4tGTEyLHw8LgQm3KWiXgRtlE0B39CJfLdzOUIDGNPzaX3CpPuLZ1By1YLPgUvLsWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bRu5D+KP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bRu5D+KP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F66C43394;
	Mon, 25 Mar 2024 04:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711341911;
	bh=0ES/j5YKwo9VcxpvKOHpEYwHplTfg2Fp17R4OcX8qXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bRu5D+KPzy47FQqK0I4t5DPsaxmQJjqUXp8LwzFuOcrY57K8kR03zFuHiDXZ7rO9H
	 E7Tt9Zp99Fr7vOX3jfpsmuTRH/QGybDBvDdbiCgm+YpTpqtsOtfZWWJWuPWwsMMmHY
	 DSVN42qJECOkZmXdDpfL734fRjohF3juxm1MzEZgQOi4G88lTz7SS6ksjK31VD+K1f
	 Fjv9NBmXvw8PonZJAe/U1es7Ak+MmrjMDGkMU2DPbTgMQSPYiq9XcMPJ1P2O3Qk+hg
	 ACKpxIiuM9elMHihcOgnjwi4WO4XuDx8wP5BwgKi42UwGAUv6U3dmoRyHaEOxa55hI
	 Uh3T2PtYDgZmw==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 08/28] block: Use a mempool to allocate zone write plugs
Date: Mon, 25 Mar 2024 13:44:32 +0900
Message-ID: <20240325044452.3125418-9-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240325044452.3125418-1-dlemoal@kernel.org>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocating zone write plugs using a struct kmem_cache does not guarantee
that enough write plugs can be allocated to simultaneously write up to
the maximum number of active zones of a zoned block device.

Avoid any issue with memory allocation by using a mempool with a size
equal to the disk maximum number of open zones or maximum number of
active zones, whichever is larger. For zoned devices that do not have
open or active zone limits, the default 128 is used as the mempool size.
If a change to the zone limits is detected, the mempool is resized in
blk_revalidate_disk_zones().

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c      | 62 ++++++++++++++++++++++++++++++------------
 include/linux/blkdev.h |  3 ++
 2 files changed, 47 insertions(+), 18 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 39e66d64ea55..4e93293b1233 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -568,13 +568,14 @@ static struct blk_zone_wplug *disk_get_zone_wplug(struct gendisk *disk,
 	return zwplug;
 }
 
-static inline void disk_put_zone_wplug(struct blk_zone_wplug *zwplug)
+static inline void disk_put_zone_wplug(struct gendisk *disk,
+				       struct blk_zone_wplug *zwplug)
 {
 	if (atomic_dec_and_test(&zwplug->ref)) {
 		WARN_ON_ONCE(!bio_list_empty(&zwplug->bio_list));
 		WARN_ON_ONCE(!list_empty(&zwplug->err));
 
-		kmem_cache_free(blk_zone_wplugs_cachep, zwplug);
+		mempool_free(zwplug, disk->zone_wplugs_pool);
 	}
 }
 
@@ -599,14 +600,14 @@ static struct blk_zone_wplug *disk_get_zone_wplug_locked(struct gendisk *disk,
 		spin_lock_irqsave(&zwplug->lock, *flags);
 		if (zwplug->flags & BLK_ZONE_WPLUG_FREEING) {
 			spin_unlock_irqrestore(&zwplug->lock, *flags);
-			disk_put_zone_wplug(zwplug);
+			disk_put_zone_wplug(disk, zwplug);
 			goto again;
 		}
 		return zwplug;
 	}
 
 	/* Allocate and insert a new zone write plug. */
-	zwplug = kmem_cache_alloc(blk_zone_wplugs_cachep, gfp_mask);
+	zwplug = mempool_alloc(disk->zone_wplugs_pool, gfp_mask);
 	if (!zwplug)
 		return NULL;
 
@@ -629,7 +630,7 @@ static struct blk_zone_wplug *disk_get_zone_wplug_locked(struct gendisk *disk,
 	 */
 	if (!disk_insert_zone_wplug(disk, zwplug)) {
 		spin_unlock_irqrestore(&zwplug->lock, *flags);
-		kmem_cache_free(blk_zone_wplugs_cachep, zwplug);
+		mempool_free(zwplug, disk->zone_wplugs_pool);
 		goto again;
 	}
 
@@ -659,13 +660,14 @@ static inline void blk_zone_wplug_bio_io_error(struct bio *bio)
 	blk_queue_exit(q);
 }
 
-static void disk_zone_wplug_abort(struct blk_zone_wplug *zwplug)
+static void disk_zone_wplug_abort(struct gendisk *disk,
+				  struct blk_zone_wplug *zwplug)
 {
 	struct bio *bio;
 
 	while ((bio = bio_list_pop(&zwplug->bio_list))) {
 		blk_zone_wplug_bio_io_error(bio);
-		disk_put_zone_wplug(zwplug);
+		disk_put_zone_wplug(disk, zwplug);
 	}
 }
 
@@ -681,7 +683,7 @@ static void disk_zone_wplug_abort_unaligned(struct gendisk *disk,
 		if (wp_offset >= zone_capacity ||
 		     bio_offset_from_zone_start(bio) != wp_offset) {
 			blk_zone_wplug_bio_io_error(bio);
-			disk_put_zone_wplug(zwplug);
+			disk_put_zone_wplug(disk, zwplug);
 			continue;
 		}
 
@@ -718,7 +720,7 @@ static void disk_zone_wplug_set_wp_offset(struct gendisk *disk,
 
 	/* Update the zone write pointer and abort all plugged BIOs. */
 	zwplug->wp_offset = wp_offset;
-	disk_zone_wplug_abort(zwplug);
+	disk_zone_wplug_abort(disk, zwplug);
 
 	/*
 	 * Updating the write pointer offset puts back the zone
@@ -765,7 +767,7 @@ static bool blk_zone_wplug_handle_reset_or_finish(struct bio *bio,
 	zwplug = disk_get_zone_wplug(disk, bio->bi_iter.bi_sector);
 	if (zwplug) {
 		disk_zone_wplug_set_wp_offset(disk, zwplug, wp_offset);
-		disk_put_zone_wplug(zwplug);
+		disk_put_zone_wplug(disk, zwplug);
 	}
 
 	return false;
@@ -787,7 +789,7 @@ static bool blk_zone_wplug_handle_reset_all(struct bio *bio)
 		zwplug = disk_get_zone_wplug(disk, sector);
 		if (zwplug) {
 			disk_zone_wplug_set_wp_offset(disk, zwplug, 0);
-			disk_put_zone_wplug(zwplug);
+			disk_put_zone_wplug(disk, zwplug);
 		}
 	}
 
@@ -1158,7 +1160,7 @@ void blk_zone_write_plug_bio_endio(struct bio *bio)
 	if (bio->bi_bdev->bd_has_submit_bio)
 		disk_zone_wplug_unplug_bio(disk, zwplug);
 
-	disk_put_zone_wplug(zwplug);
+	disk_put_zone_wplug(disk, zwplug);
 }
 
 void blk_zone_write_plug_complete_request(struct request *req)
@@ -1171,7 +1173,7 @@ void blk_zone_write_plug_complete_request(struct request *req)
 
 	disk_zone_wplug_unplug_bio(disk, zwplug);
 
-	disk_put_zone_wplug(zwplug);
+	disk_put_zone_wplug(disk, zwplug);
 }
 
 static void blk_zone_wplug_bio_work(struct work_struct *work)
@@ -1284,7 +1286,7 @@ static void disk_zone_wplug_handle_error(struct gendisk *disk,
 		 * plugged BIOs as otherwise we could endup waiting forever on
 		 * plugged BIOs to complete if there is a queue freeze on-going.
 		 */
-		disk_zone_wplug_abort(zwplug);
+		disk_zone_wplug_abort(disk, zwplug);
 		goto unplug;
 	}
 
@@ -1325,7 +1327,7 @@ static void disk_zone_wplugs_work(struct work_struct *work)
 		spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
 
 		disk_zone_wplug_handle_error(disk, zwplug);
-		disk_put_zone_wplug(zwplug);
+		disk_put_zone_wplug(disk, zwplug);
 
 		spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
 	}
@@ -1353,7 +1355,7 @@ static void disk_free_zone_wplugs(struct gendisk *disk)
 					     struct blk_zone_wplug, node);
 			blk_get_zone_wplug(zwplug);
 			disk_remove_zone_wplug(disk, zwplug);
-			disk_put_zone_wplug(zwplug);
+			disk_put_zone_wplug(disk, zwplug);
 		}
 	}
 }
@@ -1369,7 +1371,7 @@ void disk_init_zone_resources(struct gendisk *disk)
  * For the size of a disk zone write plug hash table, use the disk maximum
  * open zones and maximum active zones limits, but do not exceed 4KB (512 hlist
  * head entries), that is, 9 bits. For a disk that has no limits, default to
- * 128 zones to hash.
+ * 128 zones for the mempool size and the hash size.
  */
 #define BLK_ZONE_MAX_WPLUG_HASH_BITS		9
 #define BLK_ZONE_DEFAULT_WPLUG_HASH_SIZE	128
@@ -1391,6 +1393,17 @@ static int disk_alloc_zone_resources(struct gendisk *disk,
 	for (i = 0; i < disk_zone_wplugs_hash_size(disk); i++)
 		INIT_HLIST_HEAD(&disk->zone_wplugs_hash[i]);
 
+	disk->zone_wplugs_pool =
+		mempool_create_slab_pool(hash_size, blk_zone_wplugs_cachep);
+	if (!disk->zone_wplugs_pool) {
+		kfree(disk->zone_wplugs_hash);
+		disk->zone_wplugs_hash = NULL;
+		disk->zone_wplugs_hash_bits = 0;
+		return -ENOMEM;
+	}
+
+	disk->zone_wplugs_pool_size = hash_size;
+
 	return 0;
 }
 
@@ -1404,6 +1417,10 @@ void disk_free_zone_resources(struct gendisk *disk)
 	disk->zone_wplugs_hash = NULL;
 	disk->zone_wplugs_hash_bits = 0;
 
+	mempool_destroy(disk->zone_wplugs_pool);
+	disk->zone_wplugs_pool = NULL;
+	disk->zone_wplugs_pool_size = 0;
+
 	kfree(disk->conv_zones_bitmap);
 	disk->conv_zones_bitmap = NULL;
 	kfree(disk->seq_zones_wlock);
@@ -1418,6 +1435,7 @@ static int disk_revalidate_zone_resources(struct gendisk *disk,
 {
 	struct queue_limits *lim = &disk->queue->limits;
 	unsigned int hash_size;
+	int ret;
 
 	hash_size = max(lim->max_open_zones, lim->max_active_zones);
 	if (!hash_size)
@@ -1427,6 +1445,14 @@ static int disk_revalidate_zone_resources(struct gendisk *disk,
 	if (!disk->zone_wplugs_hash)
 		return disk_alloc_zone_resources(disk, hash_size);
 
+	/* Resize the memory pool if needed. */
+	if (disk->zone_wplugs_pool_size != hash_size) {
+		ret = mempool_resize(disk->zone_wplugs_pool, hash_size);
+		if (ret)
+			return ret;
+		disk->zone_wplugs_pool_size = hash_size;
+	}
+
 	return 0;
 }
 
@@ -1526,7 +1552,7 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 			if (!zwplug)
 				return -ENOMEM;
 			spin_unlock_irqrestore(&zwplug->lock, flags);
-			disk_put_zone_wplug(zwplug);
+			disk_put_zone_wplug(disk, zwplug);
 		}
 
 		break;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e9b670be338b..68c60039a7ea 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -25,6 +25,7 @@
 #include <linux/uuid.h>
 #include <linux/xarray.h>
 #include <linux/file.h>
+#include <linux/mempool.h>
 
 struct module;
 struct request_queue;
@@ -194,6 +195,8 @@ struct gendisk {
 	unsigned int		zone_capacity;
 	unsigned long		*conv_zones_bitmap;
 	unsigned long		*seq_zones_wlock;
+	unsigned int		zone_wplugs_pool_size;
+	mempool_t		*zone_wplugs_pool;
 	unsigned int            zone_wplugs_hash_bits;
 	spinlock_t              zone_wplugs_lock;
 	struct hlist_head       *zone_wplugs_hash;
-- 
2.44.0

