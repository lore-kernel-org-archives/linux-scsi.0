Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F0B61BF58;
	Thu, 28 Mar 2024 00:44:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586670; cv=none; b=gZNagJAbtCP7FyWUP7rvubQASEPT4eAS/bfq/f6/4Tzhw2aJVn/OEzEytFpWR2H5V5s22OsG1sawQstTDEMv6UfnhANJLDgicio9i+homtBd/hJP/MyjarwNeIKXHxuqJ/VH1EuWo4ZsDYUZ5SGdUtD9I+JjG2puFbAhvkXg4MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586670; c=relaxed/simple;
	bh=XtaHaOqpUVkGKEgMLpE6hz5CkA4tB5k4DQc8VKHYjss=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MabbCVhbDR9KZ6eRVoD9Z8hLx3/Cw4nZi2NE3Gg2Sp0+6lRkvpXBju6GXs/EAfeNpXvxz09Eah+B0Otw094df5ZwZcAE8hAyv+an52NU0OpZChjMwS4TdobTmKfXA6rYOybTyQ7K31UfRE8oa/Chzz2/cs18gktKVKueeTXIS/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MFdZUxo+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MFdZUxo+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F1AC433F1;
	Thu, 28 Mar 2024 00:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711586669;
	bh=XtaHaOqpUVkGKEgMLpE6hz5CkA4tB5k4DQc8VKHYjss=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=MFdZUxo+UVq2bAemDS018MNM1lybKs/IVv1FCE/Xh3Yfpt5RQj2i1rziX3aOyRLF4
	 NeczC+t6uCtfJrRsT1sQlXWLYfBLxlktldfJoYEUVwPc1xAxHbSqzo+MMUD7EZ408n
	 +8yPIRrvvWIVolX/Fi466xEtFwY13GEKLCJBkoadzFyfHqnnZEu4GhtTxgTA0QKySB
	 3DgPMfbojOJHEEueTV0WzvskWj/p8mFE8ANGVR6nZVDbOKVmsg/ivqCPqZ73zVnNQD
	 r8ArGr+JRYeXjczxKqILm+eNnQyADU8pnMww2+NsrTD3ZiR/zy3in/HwX3gCTn5+aS
	 pTC67KPYFsISg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3 09/30] block: Pre-allocate zone write plugs
Date: Thu, 28 Mar 2024 09:43:48 +0900
Message-ID: <20240328004409.594888-10-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328004409.594888-1-dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allocating zone write plugs using kmalloc() does not guarantee that
enough write plugs can be allocated to simultaneously write up to
the maximum number of active zones or maximum number of open zones of
a zoned block device.

Avoid any issue with memory allocation by pre-allocating zone write
plugs up to the disk maximum number of open zones or maximum number of
active zones, whichever is larger. For zoned devices that do not have
open or active zone limits, the default 128 is used as the number of
write plugs to pre-allocate.

Pre-allocated zone write plugs are managed using a free list. If a
change to the device zone limits is detected, the disk free list is
grown if needed when blk_revalidate_disk_zones() is executed.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c      | 124 ++++++++++++++++++++++++++++++++++++-----
 include/linux/blkdev.h |   2 +
 2 files changed, 113 insertions(+), 13 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 03083522df84..3084dae5408e 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -39,7 +39,8 @@ static const char *const zone_cond_name[] = {
 /*
  * Per-zone write plug.
  * @node: hlist_node structure for managing the plug using a hash table.
- * @link: To list the plug in the zone write plug error list of the disk.
+ * @link: To list the plug in the zone write plug free list or error list of
+ *        the disk.
  * @ref: Zone write plug reference counter. A zone write plug reference is
  *       always at least 1 when the plug is hashed in the disk plug hash table.
  *       The reference is incremented whenever a new BIO needing plugging is
@@ -57,6 +58,7 @@ static const char *const zone_cond_name[] = {
  * @bio_list: The list of BIOs that are currently plugged.
  * @bio_work: Work struct to handle issuing of plugged BIOs
  * @rcu_head: RCU head to free zone write plugs with an RCU grace period.
+ * @disk: The gendisk the plug belongs to.
  */
 struct blk_zone_wplug {
 	struct hlist_node	node;
@@ -69,6 +71,7 @@ struct blk_zone_wplug {
 	struct bio_list		bio_list;
 	struct work_struct	bio_work;
 	struct rcu_head		rcu_head;
+	struct gendisk		*disk;
 };
 
 /*
@@ -85,10 +88,14 @@ struct blk_zone_wplug {
  *    to prevent new references to the zone write plug to be taken for
  *    newly incoming BIOs. A zone write plug flagged with this flag will be
  *    freed once all remaining references from BIOs or functions are dropped.
+ *  - BLK_ZONE_WPLUG_NEEDS_FREE: Indicates that the zone write plug was
+ *    dynamically allocated and needs to be freed instead of returned to the
+ *    free list of zone write plugs of the disk.
  */
 #define BLK_ZONE_WPLUG_PLUGGED		(1U << 0)
 #define BLK_ZONE_WPLUG_ERROR		(1U << 1)
 #define BLK_ZONE_WPLUG_UNHASHED		(1U << 2)
+#define BLK_ZONE_WPLUG_NEEDS_FREE	(1U << 3)
 
 #define BLK_ZONE_WPLUG_BUSY	(BLK_ZONE_WPLUG_PLUGGED | BLK_ZONE_WPLUG_ERROR)
 
@@ -519,23 +526,51 @@ static void disk_init_zone_wplug(struct gendisk *disk,
 	zwplug->wp_offset = sector & (disk->queue->limits.chunk_sectors - 1);
 	bio_list_init(&zwplug->bio_list);
 	INIT_WORK(&zwplug->bio_work, blk_zone_wplug_bio_work);
+	zwplug->disk = disk;
 }
 
 static struct blk_zone_wplug *disk_alloc_zone_wplug(struct gendisk *disk,
 						sector_t sector, gfp_t gfp_mask)
 {
-	struct blk_zone_wplug *zwplug;
+	struct blk_zone_wplug *zwplug = NULL;
+	unsigned int zwp_flags = 0;
+	unsigned long flags;
 
-	/* Allocate a new zone write plug. */
-	zwplug = kmalloc(sizeof(struct blk_zone_wplug), gfp_mask);
-	if (!zwplug)
-		return NULL;
+	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+	zwplug = list_first_entry_or_null(&disk->zone_wplugs_free_list,
+					  struct blk_zone_wplug, link);
+	if (zwplug)
+		list_del_init(&zwplug->link);
+	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
 
-	disk_init_zone_wplug(disk, zwplug, 0, sector);
+	if (!zwplug) {
+		/* Allocate a new zone write plug. */
+		zwplug = kmalloc(sizeof(struct blk_zone_wplug), gfp_mask);
+		if (!zwplug)
+			return NULL;
+		zwp_flags = BLK_ZONE_WPLUG_NEEDS_FREE;
+	}
+
+	disk_init_zone_wplug(disk, zwplug, zwp_flags, sector);
 
 	return zwplug;
 }
 
+static void disk_free_zone_wplug(struct blk_zone_wplug *zwplug)
+{
+	struct gendisk *disk = zwplug->disk;
+	unsigned long flags;
+
+	if (zwplug->flags & BLK_ZONE_WPLUG_NEEDS_FREE) {
+		kfree(zwplug);
+		return;
+	}
+
+	spin_lock_irqsave(&disk->zone_wplugs_lock, flags);
+	list_add_tail(&zwplug->link, &disk->zone_wplugs_free_list);
+	spin_unlock_irqrestore(&disk->zone_wplugs_lock, flags);
+}
+
 static bool disk_insert_zone_wplug(struct gendisk *disk,
 				   struct blk_zone_wplug *zwplug)
 {
@@ -630,18 +665,24 @@ static struct blk_zone_wplug *disk_get_zone_wplug(struct gendisk *disk,
 	return zwplug;
 }
 
+static void disk_free_zone_wplug_rcu(struct rcu_head *rcu_head)
+{
+	struct blk_zone_wplug *zwplug =
+		container_of(rcu_head, struct blk_zone_wplug, rcu_head);
+
+	disk_free_zone_wplug(zwplug);
+}
+
 static inline void disk_put_zone_wplug(struct blk_zone_wplug *zwplug)
 {
 	if (atomic_dec_and_test(&zwplug->ref)) {
 		WARN_ON_ONCE(!bio_list_empty(&zwplug->bio_list));
 		WARN_ON_ONCE(!list_empty(&zwplug->link));
 
-		kfree_rcu(zwplug, rcu_head);
+		call_rcu(&zwplug->rcu_head, disk_free_zone_wplug_rcu);
 	}
 }
 
-static void blk_zone_wplug_bio_work(struct work_struct *work);
-
 /*
  * Get a reference on the write plug for the zone containing @sector.
  * If the plug does not exist, it is allocated and hashed.
@@ -684,7 +725,7 @@ static struct blk_zone_wplug *disk_get_and_lock_zone_wplug(struct gendisk *disk,
 	 */
 	if (!disk_insert_zone_wplug(disk, zwplug)) {
 		spin_unlock_irqrestore(&zwplug->lock, *flags);
-		kfree(zwplug);
+		disk_free_zone_wplug(zwplug);
 		goto again;
 	}
 
@@ -1401,6 +1442,30 @@ static inline unsigned int disk_zone_wplugs_hash_size(struct gendisk *disk)
 	return 1U << disk->zone_wplugs_hash_bits;
 }
 
+static int disk_alloc_zone_wplugs(struct gendisk *disk,
+				  unsigned int max_nr_zwplugs)
+{
+	struct blk_zone_wplug *zwplug;
+	unsigned int i;
+
+	if (!disk->zone_wplugs_hash)
+		return 0;
+
+	/* Pre-allocate zone write plugs */
+	for (i = 0; i < max_nr_zwplugs; i++) {
+		zwplug = kmalloc(sizeof(struct blk_zone_wplug), GFP_KERNEL);
+		if (!zwplug)
+			return -ENOMEM;
+		disk_init_zone_wplug(disk, zwplug, 0, 0);
+
+		list_add_tail(&zwplug->link, &disk->zone_wplugs_free_list);
+	}
+
+	disk->zone_wplugs_max_nr += max_nr_zwplugs;
+
+	return 0;
+}
+
 static void disk_free_zone_wplugs(struct gendisk *disk)
 {
 	struct blk_zone_wplug *zwplug;
@@ -1422,11 +1487,22 @@ static void disk_free_zone_wplugs(struct gendisk *disk)
 
 	/* Wait for the zone write plugs to be RCU-freed. */
 	rcu_barrier();
+
+	while (!list_empty(&disk->zone_wplugs_free_list)) {
+		zwplug = list_first_entry(&disk->zone_wplugs_free_list,
+					  struct blk_zone_wplug, link);
+		list_del_init(&zwplug->link);
+
+		kfree(zwplug);
+	}
+
+	disk->zone_wplugs_max_nr = 0;
 }
 
 void disk_init_zone_resources(struct gendisk *disk)
 {
 	spin_lock_init(&disk->zone_wplugs_lock);
+	INIT_LIST_HEAD(&disk->zone_wplugs_free_list);
 	INIT_LIST_HEAD(&disk->zone_wplugs_err_list);
 	INIT_WORK(&disk->zone_wplugs_work, disk_zone_wplugs_work);
 }
@@ -1444,6 +1520,7 @@ static int disk_alloc_zone_resources(struct gendisk *disk,
 				     unsigned int max_nr_zwplugs)
 {
 	unsigned int i;
+	int ret;
 
 	disk->zone_wplugs_hash_bits =
 		min(ilog2(max_nr_zwplugs) + 1, BLK_ZONE_MAX_WPLUG_HASH_BITS);
@@ -1457,6 +1534,15 @@ static int disk_alloc_zone_resources(struct gendisk *disk,
 	for (i = 0; i < disk_zone_wplugs_hash_size(disk); i++)
 		INIT_HLIST_HEAD(&disk->zone_wplugs_hash[i]);
 
+	ret = disk_alloc_zone_wplugs(disk, max_nr_zwplugs);
+	if (ret) {
+		disk_free_zone_wplugs(disk);
+		kfree(disk->zone_wplugs_hash);
+		disk->zone_wplugs_hash = NULL;
+		disk->zone_wplugs_hash_bits = 0;
+		return ret;
+	}
+
 	return 0;
 }
 
@@ -1484,6 +1570,7 @@ static int disk_revalidate_zone_resources(struct gendisk *disk,
 {
 	struct queue_limits *lim = &disk->queue->limits;
 	unsigned int max_nr_zwplugs;
+	int ret;
 
 	/*
 	 * If the device has no limit on the maximum number of open and active
@@ -1495,8 +1582,19 @@ static int disk_revalidate_zone_resources(struct gendisk *disk,
 		max_nr_zwplugs =
 			min(BLK_ZONE_DEFAULT_MAX_NR_WPLUGS, nr_zones);
 
-	if (!disk->zone_wplugs_hash)
-		return disk_alloc_zone_resources(disk, max_nr_zwplugs);
+	if (!disk->zone_wplugs_hash) {
+		ret = disk_alloc_zone_resources(disk, max_nr_zwplugs);
+		if (ret)
+			return ret;
+	}
+
+	/* Grow the free list of zone write plugs if needed. */
+	if (disk->zone_wplugs_max_nr < max_nr_zwplugs) {
+		ret = disk_alloc_zone_wplugs(disk,
+				max_nr_zwplugs - disk->zone_wplugs_max_nr);
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6faa1abe8506..962ee0496659 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -194,9 +194,11 @@ struct gendisk {
 	unsigned int		zone_capacity;
 	unsigned long		*conv_zones_bitmap;
 	unsigned long		*seq_zones_wlock;
+	unsigned int		zone_wplugs_max_nr;
 	unsigned int            zone_wplugs_hash_bits;
 	spinlock_t              zone_wplugs_lock;
 	struct hlist_head       *zone_wplugs_hash;
+	struct list_head        zone_wplugs_free_list;
 	struct list_head        zone_wplugs_err_list;
 	struct work_struct	zone_wplugs_work;
 #endif /* CONFIG_BLK_DEV_ZONED */
-- 
2.44.0

