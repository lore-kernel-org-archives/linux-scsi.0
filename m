Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A52E11C68D;
	Wed,  3 Jul 2024 23:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720049979; cv=none; b=NQZkyvE8fibD8bux9qGHgz9jDC94uR1xFbbNAs934RXmbP5KpExH0DmVSZlAxAzcyOBfLhTkuhkgeFshFSQAC1h9AAL/g+k2fti3z4KFoqnlCIEGATygWhlTp6tw16+P/wns5eOPOaS6zCaTgd0FzpX2DzxLoGJG+XxwJx9TgRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720049979; c=relaxed/simple;
	bh=hVPrrqR7W8LGkf+RKhFYNnCR4ChkY3tLC+JnwzTbrpk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PSy2+hZfZGQLpizzf+4gTTsrfU59ufDbzHFp4+O2DH0uoMqOouCS9cTfDL/eLL4vD6KFOhDVSZnpIx55a4YNNGzpqs5F46ye2YuJH3ypSe67T9CIwIrals78P+bW4dpZR9gU57y3dmBhJiTtq8o34uAAHeMk51DhpMARiqXc7F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vFq/8PkV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vFq/8PkV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59032C4AF0A;
	Wed,  3 Jul 2024 23:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720049979;
	bh=hVPrrqR7W8LGkf+RKhFYNnCR4ChkY3tLC+JnwzTbrpk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=vFq/8PkVrBNlgfjqgJvWuI2R/Vhzp56aEgpnmtDzN+k77bDRZOrWn3dcKbDofT54E
	 UqR5O80twG8Cw5oApG5g0oUD6n81mroh9mhXFwzxzQJLFu5HmRb25dqZ+TDkyHgOQ8
	 SS9xpuNxSPytGh8E3pVGMhr212hQFRNun1uVrCKpdnNT4rk6sSCxQ79DZwO0fN9vAa
	 5XZ3u6AIyMa+trIoJjCm3UNhjjHphb4obQMe19zvjgKNJU+vMZvQjUiMBK4JJ/tUfz
	 fCVB/9n1X3oABaPFtm9zpophsgk8zdFx47wSeaU8MgneDNSjpWtipHNxMjoWjkS2Aa
	 awaDuL0NkwIAQ==
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
Subject: [PATCH 3/5] dm: handle REQ_OP_ZONE_RESET_ALL
Date: Thu,  4 Jul 2024 08:39:30 +0900
Message-ID: <20240703233932.545228-4-dlemoal@kernel.org>
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

This commit implements processing of the REQ_OP_ZONE_RESET_ALL operation
for zoned mapped devices. Given that this operation always has a BIO
sector of 0 and a 0 size, processing through the regular BIO
__split_and_process_bio() function does not work because this function
would always select the first target. Instead, handling of this
operation is implemented using the function __send_zone_reset_all().

Similarly to the __send_empty_flush() function, the new
__send_zone_reset_all() function manually goes through all targets of a
mapped device table doing the following:
1) If the target can natively support REQ_OP_ZONE_RESET_ALL,
   __send_duplicate_bios() is used to forward the reset all operation to
   the target. This case is handled with the
   __send_zone_reset_all_native() function.
2) For other targets, the function __send_zone_reset_all_emulated() is
   executed to emulate the execution of REQ_OP_ZONE_RESET_ALL using
   regular REQ_OP_ZONE_RESET operations.

Targets that can natively support REQ_OP_ZONE_RESET_ALL are identified
using the new target field zone_reset_all_supported. This boolean is set
to true in for targets that have reliable zone limitsi, that is, targets
that map all sequential write required zones of their zoned device(s).
Setting this field is handled in dm_set_zones_restrictions() and
device_get_zone_resource_limits().

For targets with unreliable zone limits, REQ_OP_ZONE_RESET_ALL must be
emulated (case 2 above). This is implemented with
__send_zone_reset_all_emulated() and is similar to the block layer
function blkdev_zone_reset_all_emulated(): first a report zones is done
for the zones of the target to identify zones that need reset, that is,
any sequential write required zone that is not already empty. This is
done using a bitmap and the function dm_zone_get_reset_bitmap() which
sets to 1 the bit corresponding to a zone that needs reset. Next, this
zone bitmap is inspected and a clone BIO modified to use the
REQ_OP_ZONE_RESET operation issued for any zone with its bit set in the
zone bitmap.

This implementation is more efficient than what the block layer does
with blkdev_zone_reset_all_emulated(), which is always used for DM zoned
devices currently: as we can natively use REQ_OP_ZONE_RESET_ALL on
targets mapping all sequential write required zones, resetting all zones
of a zoned mapped device can be much faster compared to always emulating
this operation using regular per-zone reset. In the worst case, this
implementation is as-efficient as the block layer emulation. This
reduction in the time it takes to reset all zones of a zoned mapped
device depends directly on the mapped device targets mapping (reliable
zone limits or not).

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/md/dm-zone.c          |  50 ++++++++++++-
 drivers/md/dm.c               | 135 +++++++++++++++++++++++++++++++++-
 drivers/md/dm.h               |  10 +++
 include/linux/device-mapper.h |   7 ++
 4 files changed, 197 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 4d37e53b50ee..41b4d230f6f6 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -292,10 +292,12 @@ static int device_get_zone_resource_limits(struct dm_target *ti,
 
 	/*
 	 * If the target does not map all sequential zones, the limits
-	 * will not be reliable.
+	 * will not be reliable and we cannot use REQ_OP_ZONE_RESET_ALL.
 	 */
-	if (zc.target_nr_seq_zones < zc.total_nr_seq_zones)
+	if (zc.target_nr_seq_zones < zc.total_nr_seq_zones) {
 		zlim->reliable_limits = false;
+		ti->zone_reset_all_supported = false;
+	}
 
 	/*
 	 * If the target maps less sequential zones than the limit values, then
@@ -353,6 +355,14 @@ int dm_set_zones_restrictions(struct dm_table *t, struct request_queue *q,
 	for (unsigned int i = 0; i < t->num_targets; i++) {
 		struct dm_target *ti = dm_table_get_target(t, i);
 
+		/*
+		 * Assume that the target can accept REQ_OP_ZONE_RESET_ALL.
+		 * device_get_zone_resource_limits() may adjust this if one of
+		 * the device used by the target does not have all its sequential
+		 * write required zones mapped.
+		 */
+		ti->zone_reset_all_supported = true;
+
 		if (!ti->type->iterate_devices ||
 		    ti->type->iterate_devices(ti,
 				device_get_zone_resource_limits, &zlim)) {
@@ -420,3 +430,39 @@ void dm_zone_endio(struct dm_io *io, struct bio *clone)
 
 	return;
 }
+
+static int dm_zone_need_reset_cb(struct blk_zone *zone, unsigned int idx,
+				 void *data)
+{
+	/*
+	 * For an all-zones reset, ignore conventional, empty, read-only
+	 * and offline zones.
+	 */
+	switch (zone->cond) {
+	case BLK_ZONE_COND_NOT_WP:
+	case BLK_ZONE_COND_EMPTY:
+	case BLK_ZONE_COND_READONLY:
+	case BLK_ZONE_COND_OFFLINE:
+		return 0;
+	default:
+		set_bit(idx, (unsigned long *)data);
+		return 0;
+	}
+}
+
+int dm_zone_get_reset_bitmap(struct mapped_device *md, struct dm_table *t,
+			     sector_t sector, unsigned int nr_zones,
+			     unsigned long *need_reset)
+{
+	int ret;
+
+	ret = dm_blk_do_report_zones(md, t, sector, nr_zones,
+				     dm_zone_need_reset_cb, need_reset);
+	if (ret != nr_zones) {
+		DMERR("Get %s zone reset bitmap failed\n",
+		      md->disk->disk_name);
+		return -EIO;
+	}
+
+	return 0;
+}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 0d80caccbd9e..9ee5b8355269 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1606,6 +1606,7 @@ static bool is_abnormal_io(struct bio *bio)
 	case REQ_OP_DISCARD:
 	case REQ_OP_SECURE_ERASE:
 	case REQ_OP_WRITE_ZEROES:
+	case REQ_OP_ZONE_RESET_ALL:
 		return true;
 	default:
 		return false;
@@ -1774,6 +1775,119 @@ static inline bool dm_zone_plug_bio(struct mapped_device *md, struct bio *bio)
 {
 	return dm_emulate_zone_append(md) && blk_zone_plug_bio(bio, 0);
 }
+
+static blk_status_t __send_zone_reset_all_emulated(struct clone_info *ci,
+						   struct dm_target *ti)
+{
+	struct bio_list blist = BIO_EMPTY_LIST;
+	struct mapped_device *md = ci->io->md;
+	unsigned int zone_sectors = md->disk->queue->limits.chunk_sectors;
+	unsigned long *need_reset;
+	unsigned int i, nr_zones, nr_reset;
+	unsigned int num_bios = 0;
+	blk_status_t sts = BLK_STS_OK;
+	sector_t sector = ti->begin;
+	struct bio *clone;
+	int ret;
+
+	nr_zones = ti->len >> ilog2(zone_sectors);
+	need_reset = bitmap_zalloc(nr_zones, GFP_NOIO);
+	if (!need_reset)
+		return BLK_STS_RESOURCE;
+
+	ret = dm_zone_get_reset_bitmap(md, ci->map, ti->begin,
+				       nr_zones, need_reset);
+	if (ret) {
+		sts = BLK_STS_IOERR;
+		goto free_bitmap;
+	}
+
+	/* If we have no zone to reset, we are done. */
+	nr_reset = bitmap_weight(need_reset, nr_zones);
+	if (!nr_reset)
+		goto free_bitmap;
+
+	atomic_add(nr_zones, &ci->io->io_count);
+
+	for (i = 0; i < nr_zones; i++) {
+
+		if (!test_bit(i, need_reset)) {
+			sector += zone_sectors;
+			continue;
+		}
+
+		if (bio_list_empty(&blist)) {
+			/* This may take a while, so be nice to others */
+			if (i > 0)
+				cond_resched();
+
+			/*
+			 * We may need to reset thousands of zones, so let's
+			 * not go crazy with the clone allocation.
+			 */
+			alloc_multiple_bios(&blist, ci, ti, min(nr_reset, 32),
+					    NULL, GFP_NOIO);
+		}
+
+		/* Get a clone and change it to a regular reset operation. */
+		clone = bio_list_pop(&blist);
+		clone->bi_opf &= ~REQ_OP_MASK;
+		clone->bi_opf |= REQ_OP_ZONE_RESET | REQ_SYNC;
+		clone->bi_iter.bi_sector = sector;
+		clone->bi_iter.bi_size = 0;
+		__map_bio(clone);
+
+		sector += zone_sectors;
+		num_bios++;
+		nr_reset--;
+	}
+
+	WARN_ON_ONCE(!bio_list_empty(&blist));
+	atomic_sub(nr_zones - num_bios, &ci->io->io_count);
+	ci->sector_count = 0;
+
+free_bitmap:
+	bitmap_free(need_reset);
+
+	return sts;
+}
+
+static void __send_zone_reset_all_native(struct clone_info *ci,
+					 struct dm_target *ti)
+{
+	unsigned int bios;
+
+	atomic_add(1, &ci->io->io_count);
+	bios = __send_duplicate_bios(ci, ti, 1, NULL, GFP_NOIO);
+	atomic_sub(1 - bios, &ci->io->io_count);
+
+	ci->sector_count = 0;
+}
+
+static blk_status_t __send_zone_reset_all(struct clone_info *ci)
+{
+	struct dm_table *t = ci->map;
+	blk_status_t sts = BLK_STS_OK;
+
+	for (unsigned int i = 0; i < t->num_targets; i++) {
+		struct dm_target *ti = dm_table_get_target(t, i);
+
+		if (ti->zone_reset_all_supported) {
+			__send_zone_reset_all_native(ci, ti);
+			continue;
+		}
+
+		sts = __send_zone_reset_all_emulated(ci, ti);
+		if (sts != BLK_STS_OK)
+			break;
+	}
+
+	/* Release the reference that alloc_io() took for submission. */
+	atomic_sub(1, &ci->io->io_count);
+
+	return sts;
+}
+
 #else
 static inline bool dm_zone_bio_needs_split(struct mapped_device *md,
 					   struct bio *bio)
@@ -1784,6 +1898,10 @@ static inline bool dm_zone_plug_bio(struct mapped_device *md, struct bio *bio)
 {
 	return false;
 }
+static blk_status_t __send_zone_reset_all(struct clone_info *ci)
+{
+	return BLK_STS_NOTSUPP;
+}
 #endif
 
 /*
@@ -1797,9 +1915,14 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 	blk_status_t error = BLK_STS_OK;
 	bool is_abnormal, need_split;
 
-	need_split = is_abnormal = is_abnormal_io(bio);
-	if (static_branch_unlikely(&zoned_enabled))
-		need_split = is_abnormal || dm_zone_bio_needs_split(md, bio);
+	is_abnormal = is_abnormal_io(bio);
+	if (static_branch_unlikely(&zoned_enabled)) {
+		/* Special case REQ_OP_ZONE_RESET_ALL as it cannot be split. */
+		need_split = (bio_op(bio) != REQ_OP_ZONE_RESET_ALL) &&
+			(is_abnormal || dm_zone_bio_needs_split(md, bio));
+	} else {
+		need_split = is_abnormal;
+	}
 
 	if (unlikely(need_split)) {
 		/*
@@ -1840,6 +1963,12 @@ static void dm_split_and_process_bio(struct mapped_device *md,
 		goto out;
 	}
 
+	if (static_branch_unlikely(&zoned_enabled) &&
+	    (bio_op(bio) == REQ_OP_ZONE_RESET_ALL)) {
+		error = __send_zone_reset_all(&ci);
+		goto out;
+	}
+
 	error = __split_and_process_bio(&ci);
 	if (error || !ci.sector_count)
 		goto out;
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index c984ecb64b1e..4137bcdb95e7 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -110,6 +110,9 @@ int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 			unsigned int nr_zones, report_zones_cb cb, void *data);
 bool dm_is_zone_write(struct mapped_device *md, struct bio *bio);
 int dm_zone_map_bio(struct dm_target_io *io);
+int dm_zone_get_reset_bitmap(struct mapped_device *md, struct dm_table *t,
+			     sector_t sector, unsigned int nr_zones,
+			     unsigned long *need_reset);
 #else
 #define dm_blk_report_zones	NULL
 static inline bool dm_is_zone_write(struct mapped_device *md, struct bio *bio)
@@ -120,6 +123,13 @@ static inline int dm_zone_map_bio(struct dm_target_io *tio)
 {
 	return DM_MAPIO_KILL;
 }
+static inline int dm_zone_get_reset_bitmap(struct mapped_device *md,
+					struct dm_table *t,
+					sector_t sector, unsigned int nr_zones,
+					unsigned long *need_reset)
+{
+	return -ENOTSUPP;
+}
 #endif
 
 /*
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 82b2195efaca..15d28164bbbd 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -357,6 +357,13 @@ struct dm_target {
 	 */
 	bool discards_supported:1;
 
+	/*
+	 * Automatically set by dm-core if this target supports
+	 * REQ_OP_ZONE_RESET_ALL. Otherwise, this operation will be emulated
+	 * using REQ_OP_ZONE_RESET. Target drivers must not set this manually.
+	 */
+	bool zone_reset_all_supported:1;
+
 	/*
 	 * Set if this target requires that discards be split on
 	 * 'max_discard_sectors' boundaries.
-- 
2.45.2

