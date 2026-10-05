Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7D9D46D2A5;
	Mon,  5 Oct 2026 09:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193609; cv=none; b=Npb3apoiavOEUsjgSkbwP+AtT43X1oDNTWzuiH3Lgy6lSMUNeBIkZQXUoVq0toFEQdXhVQa1yyxVrpfA216cD/RTSBDPPRz/6fBAz5bI656nmUhgFweRYdKiwM2+TFHZ+Y+PuFoskO3//9rE1wY1SlZMCfFuty+zQWxRjZQTJOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193609; c=relaxed/simple;
	bh=Y80O4b2qDn1hLWxQwAY2DUjYAMcns9PHRRz5L9WMAGg=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CrO1ekbQg0/2RQoBVYcME6kfwNzDn1h8iuOzk9SvU1YG/9VeNl9bt65NaMpneadecef8KkahJZsUToV8wRqAjpX6W2HpQLgcqnHd/fceUNV/tRLSTRXSo3fT4RlOIyNZa3VLHDiE2fl2ggFuv+DsPHCTEc3/rEqjZ0ZFNi8g/NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q851HQzx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q851HQzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB301F000FF;
	Mon,  5 Oct 2026 09:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791193598;
	bh=FG7o7xTt4kYKcmUXI9MWvFiLnplmwjA3M67yDa3j7hM=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=Q851HQzxo/7acL00xC9OoU+4mM8PERSFEEtQLeK8cNs9Ms8FOvoosmgp5VtO0Yv7B
	 Ukd2Miqvdx8f/SEIFt+eRNlk4W078iIa1BVVa2GcIOGLrV9x1HPzfdGo2XuTIef35U
	 KttBnqgF4xRjejbdQBq0hcqIevjA/Bs5ilUumHviZVE5h3ogbIriDEzNZzqTLnTpGV
	 OjXFCX5Bmox+/4zzdaH6QfOlO0WcyrtDf6HH0bRDd+2ankMI2/Nzqwu5jTJwdgv1Rj
	 v21kiwKlhp5+0eVHH9DsZISyFfM3eQXhEixxV45sl6sMG1SvrtsPLYd4Uy89N0Ar3X
	 6CmdIxuSAfijw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/7] zloop: add storage element emulation
Date: Mon,  5 Oct 2026 18:46:29 +0900
Message-ID: <20261005094632.580753-5-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261005094632.580753-1-dlemoal@kernel.org>
References: <20261005094632.580753-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Emulate the storage element depopulation feature of SMR disks in the
zloop driver. This emulation is controlled using the new stor_elements
option.

This option can take several values:
 - ZLOOP_STOR_ELEMENTS_NONE (0): no emulation (default)
 - ZLOOP_STOR_ELEMENTS_RDWR (1): emulate all access storage elements
   (e.g.  read+write heads)
 - ZLOOP_STOR_ELEMENTS_PAIRS (2): emulate fractional access storage
   elements (e.g. pairs of read and write heads)

If enabled with the value 1 or 2, the number of storage elements, or of
pairs of fractional access storage elements, is automatically calculated
based on the number of zones of the device so that we have at least 2 and
at most 32 storage elements (or 2 pairs of fractional access storage
elements).

The mapping of zones to storage elements is defined simply as the modulo
of a zone number and a storage element ID. E.g, removing a storage
element from a set of 4 storage elements will offline 1 zone every 4
zones.

The storage element management operations are specified with the
zloop_se_ops (struct blk_storage_elements_ops).

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 .../admin-guide/blockdev/zoned_loop.rst       |   8 +-
 drivers/block/zloop.c                         | 510 +++++++++++++++++-
 2 files changed, 490 insertions(+), 28 deletions(-)

diff --git a/Documentation/admin-guide/blockdev/zoned_loop.rst b/Documentation/admin-guide/blockdev/zoned_loop.rst
index 64277494fb36..ec39f141af8d 100644
--- a/Documentation/admin-guide/blockdev/zoned_loop.rst
+++ b/Documentation/admin-guide/blockdev/zoned_loop.rst
@@ -61,7 +61,7 @@ The options available for the add command can be listed by reading the
 /dev/zloop-control device::
 
 	$ cat /dev/zloop-control
-        add id=%d,capacity_mb=%u,zone_size_mb=%u,zone_capacity_mb=%u,conv_zones=%u,max_open_zones=%u,base_dir=%s,nr_queues=%u,queue_depth=%u,buffered_io,zone_append=%u,ordered_zone_append,discard_write_cache
+        add id=%d,capacity_mb=%u,zone_size_mb=%u,zone_capacity_mb=%u,conv_zones=%u,max_open_zones=%u,base_dir=%s,nr_queues=%u,queue_depth=%u,buffered_io,zone_append=%u,ordered_zone_append,discard_write_cache,stor_elements=%u
         remove id=%d
 
 In more details, the options that can be used with the "add" command are as
@@ -113,6 +113,12 @@ discard_write_cache   Discard all data that was not explicitly persisted using a
                       each zone file to the size recorded during the last flush
                       operation. This simulates power fail events where
                       uncommitted data is lost.
+stor_elements         Control storage element emulation. The default value is 0,
+                      indicating no emulation. A value of 1 indicates that all
+                      access storage elements (equivalent to read+write head of
+                      a disk) are emulated. A value of 2 enables fractional
+                      access storage element (equivalent to pairs of read and
+                      write heads of a disk) emulation .
 ===================   =========================================================
 
 3) Deleting a Zoned Device
diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index f0ca221524db..7e6b5cc8017d 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -37,6 +37,7 @@ enum {
 	ZLOOP_OPT_ORDERED_ZONE_APPEND	= (1 << 10),
 	ZLOOP_OPT_DISCARD_WRITE_CACHE	= (1 << 11),
 	ZLOOP_OPT_MAX_OPEN_ZONES	= (1 << 12),
+	ZLOOP_OPT_STOR_ELEMENTS		= (1 << 13),
 };
 
 static const match_table_t zloop_opt_tokens = {
@@ -51,11 +52,22 @@ static const match_table_t zloop_opt_tokens = {
 	{ ZLOOP_OPT_BUFFERED_IO,	"buffered_io"		},
 	{ ZLOOP_OPT_ZONE_APPEND,	"zone_append=%u"	},
 	{ ZLOOP_OPT_ORDERED_ZONE_APPEND, "ordered_zone_append"	},
-	{ ZLOOP_OPT_DISCARD_WRITE_CACHE, "discard_write_cache" },
+	{ ZLOOP_OPT_DISCARD_WRITE_CACHE, "discard_write_cache"	},
 	{ ZLOOP_OPT_MAX_OPEN_ZONES,	"max_open_zones=%u"	},
+	{ ZLOOP_OPT_STOR_ELEMENTS,	"stor_elements=%u"	},
 	{ ZLOOP_OPT_ERR,		NULL			}
 };
 
+/* Storage elements emulation types. */
+enum zloop_stor_elements {
+	/* No emulation. */
+	ZLOOP_STOR_ELEMENTS_NONE,
+	/* Emulate read+write storage elements. */
+	ZLOOP_STOR_ELEMENTS_RDWR,
+	/* Emulate pairs of associated read and write storage elements. */
+	ZLOOP_STOR_ELEMENTS_PAIRS,
+};
+
 /* Default values for the "add" operation. */
 #define ZLOOP_DEF_ID			-1
 #define ZLOOP_DEF_ZONE_SIZE		((256ULL * SZ_1M) >> SECTOR_SHIFT)
@@ -68,6 +80,7 @@ static const match_table_t zloop_opt_tokens = {
 #define ZLOOP_DEF_BUFFERED_IO		false
 #define ZLOOP_DEF_ZONE_APPEND		true
 #define ZLOOP_DEF_ORDERED_ZONE_APPEND	false
+#define ZLOOP_DEF_STOR_ELEMENTS		ZLOOP_STOR_ELEMENTS_NONE
 
 /* Arbitrary limit on the zone size (16GB). */
 #define ZLOOP_MAX_ZONE_SIZE_MB		16384
@@ -87,6 +100,7 @@ struct zloop_options {
 	bool			zone_append;
 	bool			ordered_zone_append;
 	bool			discard_write_cache;
+	enum zloop_stor_elements stor_elements;
 };
 
 /*
@@ -117,6 +131,8 @@ struct zloop_zone {
 	enum blk_zone_cond	cond;
 	sector_t		start;
 	sector_t		wp;
+	unsigned int		wr_se_id;
+	unsigned int		rd_se_id;
 
 	gfp_t			old_gfp_mask;
 };
@@ -133,6 +149,7 @@ struct zloop_device {
 	bool			zone_append;
 	bool			ordered_zone_append;
 	bool			discard_write_cache;
+	enum zloop_stor_elements stor_elements;
 
 	const char		*base_dir;
 	struct file		*data_dir;
@@ -150,6 +167,17 @@ struct zloop_device {
 	struct list_head	open_zones_lru_list;
 	unsigned int		nr_open_zones;
 
+	/* For storage elements emulation. */
+	struct mutex		stor_elements_lock;
+	unsigned int		nr_elements;
+	unsigned int		max_nr_removed_elements;
+	unsigned int		nr_removed_elements;
+	struct delayed_work	remove_element_work;
+	unsigned int		remove_element_id;
+	struct delayed_work	restore_elements_work;
+	bool			restore_in_progress;
+	struct blk_storage_element *elements;
+
 	struct zloop_zone	zones[] __counted_by(nr_zones);
 };
 
@@ -289,22 +317,30 @@ static bool zloop_do_open_zone(struct zloop_device *zlo,
 	}
 }
 
-static void zloop_mark_full(struct zloop_device *zlo, struct zloop_zone *zone)
+static void zloop_set_zone_cond(struct zloop_device *zlo,
+				struct zloop_zone *zone,
+				enum blk_zone_cond cond)
 {
 	lockdep_assert_held(&zone->wp_lock);
 
 	zloop_lru_remove_open_zone(zlo, zone);
-	zone->cond = BLK_ZONE_COND_FULL;
-	zone->wp = ULLONG_MAX;
+	zone->cond = cond;
+	if (cond == BLK_ZONE_COND_EMPTY)
+		zone->wp = zone->start;
+	else
+		zone->wp = ULLONG_MAX;
 }
 
-static void zloop_mark_empty(struct zloop_device *zlo, struct zloop_zone *zone)
+static inline void zloop_set_zone_full(struct zloop_device *zlo,
+				       struct zloop_zone *zone)
 {
-	lockdep_assert_held(&zone->wp_lock);
+	zloop_set_zone_cond(zlo, zone, BLK_ZONE_COND_FULL);
+}
 
-	zloop_lru_remove_open_zone(zlo, zone);
-	zone->cond = BLK_ZONE_COND_EMPTY;
-	zone->wp = zone->start;
+static inline void zloop_set_zone_empty(struct zloop_device *zlo,
+					struct zloop_zone *zone)
+{
+	zloop_set_zone_cond(zlo, zone, BLK_ZONE_COND_EMPTY);
 }
 
 static int zloop_update_seq_zone(struct zloop_device *zlo, unsigned int zone_no)
@@ -339,9 +375,9 @@ static int zloop_update_seq_zone(struct zloop_device *zlo, unsigned int zone_no)
 
 	spin_lock(&zone->wp_lock);
 	if (!file_sectors) {
-		zloop_mark_empty(zlo, zone);
+		zloop_set_zone_empty(zlo, zone);
 	} else if (file_sectors == zlo->zone_capacity) {
-		zloop_mark_full(zlo, zone);
+		zloop_set_zone_full(zlo, zone);
 	} else {
 		if (zone->cond != BLK_ZONE_COND_IMP_OPEN &&
 		    zone->cond != BLK_ZONE_COND_EXP_OPEN)
@@ -363,6 +399,12 @@ static int zloop_open_zone(struct zloop_device *zlo, unsigned int zone_no)
 
 	mutex_lock(&zone->lock);
 
+	if (zone->cond == BLK_ZONE_COND_OFFLINE ||
+	    zone->cond == BLK_ZONE_COND_READONLY) {
+		ret = -EIO;
+		goto unlock;
+	}
+
 	if (test_and_clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags)) {
 		ret = zloop_update_seq_zone(zlo, zone_no);
 		if (ret)
@@ -388,6 +430,12 @@ static int zloop_close_zone(struct zloop_device *zlo, unsigned int zone_no)
 
 	mutex_lock(&zone->lock);
 
+	if (zone->cond == BLK_ZONE_COND_OFFLINE ||
+	    zone->cond == BLK_ZONE_COND_READONLY) {
+		ret = -EIO;
+		goto unlock;
+	}
+
 	if (test_and_clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags)) {
 		ret = zloop_update_seq_zone(zlo, zone_no);
 		if (ret)
@@ -420,7 +468,22 @@ static int zloop_close_zone(struct zloop_device *zlo, unsigned int zone_no)
 	return ret;
 }
 
-static int zloop_reset_zone(struct zloop_device *zlo, unsigned int zone_no)
+static int zloop_do_reset_zone(struct zloop_device *zlo,
+			       struct zloop_zone *zone)
+{
+	if (vfs_truncate(&zone->file->f_path, 0))
+		return -EIO;
+
+	spin_lock(&zone->wp_lock);
+	zloop_set_zone_empty(zlo, zone);
+	clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
+	spin_unlock(&zone->wp_lock);
+
+	return 0;
+}
+
+static int zloop_reset_zone(struct zloop_device *zlo, unsigned int zone_no,
+			    bool all_zones)
 {
 	struct zloop_zone *zone = &zlo->zones[zone_no];
 	int ret = 0;
@@ -430,20 +493,20 @@ static int zloop_reset_zone(struct zloop_device *zlo, unsigned int zone_no)
 
 	mutex_lock(&zone->lock);
 
+	if (zone->cond == BLK_ZONE_COND_OFFLINE ||
+	    zone->cond == BLK_ZONE_COND_READONLY) {
+		if (!all_zones)
+			ret = -EIO;
+		goto unlock;
+	}
+
 	if (!test_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags) &&
 	    zone->cond == BLK_ZONE_COND_EMPTY)
 		goto unlock;
 
-	if (vfs_truncate(&zone->file->f_path, 0)) {
+	ret = zloop_do_reset_zone(zlo, zone);
+	if (ret)
 		set_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
-		ret = -EIO;
-		goto unlock;
-	}
-
-	spin_lock(&zone->wp_lock);
-	zloop_mark_empty(zlo, zone);
-	clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
-	spin_unlock(&zone->wp_lock);
 
 unlock:
 	mutex_unlock(&zone->lock);
@@ -457,7 +520,7 @@ static int zloop_reset_all_zones(struct zloop_device *zlo)
 	int ret;
 
 	for (i = zlo->nr_conv_zones; i < zlo->nr_zones; i++) {
-		ret = zloop_reset_zone(zlo, i);
+		ret = zloop_reset_zone(zlo, i, true);
 		if (ret)
 			return ret;
 	}
@@ -475,6 +538,12 @@ static int zloop_finish_zone(struct zloop_device *zlo, unsigned int zone_no)
 
 	mutex_lock(&zone->lock);
 
+	if (zone->cond == BLK_ZONE_COND_OFFLINE ||
+	    zone->cond == BLK_ZONE_COND_READONLY) {
+		ret = -EIO;
+		goto unlock;
+	}
+
 	if (!test_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags) &&
 	    zone->cond == BLK_ZONE_COND_FULL)
 		goto unlock;
@@ -487,7 +556,7 @@ static int zloop_finish_zone(struct zloop_device *zlo, unsigned int zone_no)
 	}
 
 	spin_lock(&zone->wp_lock);
-	zloop_mark_full(zlo, zone);
+	zloop_set_zone_full(zlo, zone);
 	clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
 	spin_unlock(&zone->wp_lock);
 
@@ -624,7 +693,7 @@ static int zloop_seq_write_prep(struct zloop_cmd *cmd)
 	if (!is_append || !zlo->ordered_zone_append) {
 		zone->wp += nr_sectors;
 		if (zone->wp == zone_end)
-			zloop_mark_full(zlo, zone);
+			zloop_set_zone_full(zlo, zone);
 	}
 out_unlock:
 	spin_unlock(&zone->wp_lock);
@@ -664,6 +733,11 @@ static void zloop_rw(struct zloop_cmd *cmd)
 			 zone->start + zlo->zone_size))
 		goto out;
 
+	if (zone->cond == BLK_ZONE_COND_OFFLINE)
+		goto out;
+	if (zone->cond == BLK_ZONE_COND_READONLY && is_write)
+		goto out;
+
 	if (test_and_clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags)) {
 		mutex_lock(&zone->lock);
 		ret = zloop_update_seq_zone(zlo, zone_no);
@@ -766,7 +840,7 @@ static void zloop_handle_cmd(struct zloop_cmd *cmd)
 		cmd->ret = zloop_flush(zlo);
 		break;
 	case REQ_OP_ZONE_RESET:
-		cmd->ret = zloop_reset_zone(zlo, rq_zone_no(rq));
+		cmd->ret = zloop_reset_zone(zlo, rq_zone_no(rq), false);
 		break;
 	case REQ_OP_ZONE_RESET_ALL:
 		cmd->ret = zloop_reset_all_zones(zlo);
@@ -877,7 +951,7 @@ static bool zloop_set_zone_append_sector(struct request *rq)
 	rq->__sector = zone->wp;
 	zone->wp += blk_rq_sectors(rq);
 	if (zone->wp >= zone_end)
-		zloop_mark_full(zlo, zone);
+		zloop_set_zone_full(zlo, zone);
 
 	spin_unlock(&zone->wp_lock);
 
@@ -985,11 +1059,251 @@ static int zloop_report_zones(struct gendisk *disk, sector_t sector,
 	return nr_zones;
 }
 
+static int zloop_report_elements(struct gendisk *disk,
+				 unsigned int *nr_elements,
+				 struct blk_storage_element *elements)
+{
+	struct zloop_device *zlo = disk->private_data;
+	unsigned int nr_report = *nr_elements;
+
+	if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_NONE)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&zlo->stor_elements_lock);
+
+	*nr_elements = zlo->nr_elements;
+	if (elements) {
+		struct blk_storage_element *se = zlo->elements;
+		unsigned int i;
+
+		for (i = 0; i < min(nr_report, zlo->nr_elements); i++, se++) {
+			switch (se->status) {
+			case BLK_SE_STS_REMOVED:
+			case BLK_SE_STS_RESTORE_ERROR:
+				se->restore_allowed = 1;
+				break;
+			default:
+				se->restore_allowed = 0;
+			}
+			memcpy(&elements[i], se,
+			       sizeof(struct blk_storage_element));
+		}
+	}
+
+	mutex_unlock(&zlo->stor_elements_lock);
+
+	return 0;
+}
+
+static void zloop_remove_element_work(struct work_struct *work)
+{
+	struct zloop_device *zlo = container_of(work, struct zloop_device,
+						remove_element_work.work);
+	struct blk_storage_element *se, *paired_se = NULL;
+	enum blk_zone_cond cond;
+	struct zloop_zone *zone;
+	unsigned int i;
+
+	mutex_lock(&zlo->stor_elements_lock);
+
+	/*
+	 * If the element to remove is a read element, zones must go offline and
+	 * the associated write element is also removed.
+	 */
+	se = &zlo->elements[zlo->remove_element_id - 1];
+	switch (se->type) {
+	case BLK_SE_TYPE_RDWR:
+		cond = BLK_ZONE_COND_OFFLINE;
+		break;
+	case BLK_SE_TYPE_READ:
+		cond = BLK_ZONE_COND_OFFLINE;
+		paired_se = &zlo->elements[se->paired_id - 1];
+		break;
+	case BLK_SE_TYPE_WRITE:
+		cond = BLK_ZONE_COND_READONLY;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+	}
+
+	/*
+	 * Change the condition of the zones owned by the (pair of) elements
+	 * being removed and mark the elements removed.
+	 */
+	for (i = 0, zone = zlo->zones; i < zlo->nr_zones; i++, zone++) {
+		if (zone->wr_se_id != se->id && zone->rd_se_id != se->id)
+			continue;
+		mutex_lock(&zone->lock);
+		spin_lock(&zone->wp_lock);
+		zloop_set_zone_cond(zlo, zone, cond);
+		spin_unlock(&zone->wp_lock);
+		mutex_unlock(&zone->lock);
+	}
+
+	se->status = BLK_SE_STS_REMOVED;
+
+	zlo->nr_removed_elements++;
+	if (paired_se) {
+		paired_se->status = BLK_SE_STS_REMOVED;
+		zlo->nr_removed_elements++;
+	}
+
+	zlo->remove_element_id = 0;
+
+	mutex_unlock(&zlo->stor_elements_lock);
+}
+
+static int zloop_remove_element(struct gendisk *disk, unsigned int element_id)
+{
+	struct zloop_device *zlo = disk->private_data;
+	struct blk_storage_element *se, *paired_se = NULL;
+	unsigned int nr_remove = 1;
+	int ret = 0;
+
+	if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_NONE)
+		return -EOPNOTSUPP;
+
+	if (element_id > zlo->nr_elements)
+		return -EINVAL;
+
+	mutex_lock(&zlo->stor_elements_lock);
+
+	if (zlo->remove_element_id || zlo->restore_in_progress) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	/*
+	 * Get the element to remove. If it is already removed, we have nothing
+	 * to do.
+	 */
+	se = &zlo->elements[element_id - 1];
+	if (se->status == BLK_SE_STS_REMOVED)
+		goto unlock;
+
+	/*
+	 * If the element to remove is a read element, the associated write
+	 * element must also be removed.
+	 */
+	if (se->type == BLK_SE_TYPE_READ) {
+		paired_se = &zlo->elements[se->paired_id - 1];
+		nr_remove = 2;
+	}
+
+	if (zlo->nr_removed_elements + nr_remove >
+	    zlo->max_nr_removed_elements) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	/*
+	 * Schedule the element removal with a delay, to emulate the (generally
+	 * short) time it takes for a real device to depopulate a head and
+	 * modify the zones.
+	 */
+	zlo->remove_element_id = element_id;
+	se->status = BLK_SE_STS_REMOVE_IN_PROGRESS;
+	if (paired_se)
+		paired_se->status = BLK_SE_STS_REMOVE_IN_PROGRESS;
+
+	schedule_delayed_work(&zlo->remove_element_work,
+			      msecs_to_jiffies(2000));
+
+unlock:
+	mutex_unlock(&zlo->stor_elements_lock);
+
+	return ret;
+}
+
+static void zloop_restore_elements_work(struct work_struct *work)
+{
+	struct zloop_device *zlo = container_of(work, struct zloop_device,
+						restore_elements_work.work);
+	struct zloop_zone *zone = zlo->zones;
+	struct blk_storage_element *se;
+	unsigned int i;
+	int ret = 0;
+
+	mutex_lock(&zlo->stor_elements_lock);
+
+	/* Reset all zones. */
+	for (i = 0; i < zlo->nr_zones && ret == 0; i++, zone++) {
+		mutex_lock(&zone->lock);
+		if (test_bit(ZLOOP_ZONE_CONV, &zone->flags)) {
+			spin_lock(&zone->wp_lock);
+			zloop_set_zone_cond(zlo, zone, BLK_ZONE_COND_NOT_WP);
+			spin_unlock(&zone->wp_lock);
+		} else {
+			ret = zloop_do_reset_zone(zlo, zone);
+		}
+		mutex_unlock(&zone->lock);
+	}
+
+	/* Restore all removed elements. */
+	for (i = 0, se = zlo->elements; i < zlo->nr_elements; i++, se++) {
+		if (se->status != BLK_SE_STS_RESTORE_IN_PROGRESS)
+			continue;
+		if (!ret)
+			se->status = BLK_SE_STS_OK;
+		else
+			se->status = BLK_SE_STS_RESTORE_ERROR;
+	}
+
+	zlo->nr_removed_elements = 0;
+	zlo->restore_in_progress = false;
+
+	mutex_unlock(&zlo->stor_elements_lock);
+}
+
+static int zloop_restore_elements(struct gendisk *disk)
+{
+	struct zloop_device *zlo = disk->private_data;
+	struct blk_storage_element *se;
+	unsigned int i;
+	int ret = 0;
+
+	if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_NONE)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&zlo->stor_elements_lock);
+
+	if (zlo->remove_element_id || zlo->restore_in_progress) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	/* If we have no removed elements, we have nothing to do. */
+	if (!zlo->nr_removed_elements)
+		goto unlock;
+
+	/*
+	 * Schedule the elements restoration with a delay, to emulate the time
+	 * it takes for a real device to restore all removed heads and reset
+	 * all zones.
+	 */
+	zlo->restore_in_progress = true;
+	for (i = 0, se = zlo->elements; i < zlo->nr_elements; i++, se++) {
+		if (se->status == BLK_SE_STS_REMOVED)
+			se->status = BLK_SE_STS_RESTORE_IN_PROGRESS;
+	}
+
+	schedule_delayed_work(&zlo->restore_elements_work,
+			      msecs_to_jiffies(5000));
+
+unlock:
+	mutex_unlock(&zlo->stor_elements_lock);
+
+	return ret;
+}
+
 static void zloop_free_disk(struct gendisk *disk)
 {
 	struct zloop_device *zlo = disk->private_data;
 	unsigned int i;
 
+	cancel_delayed_work_sync(&zlo->remove_element_work);
+	cancel_delayed_work_sync(&zlo->restore_elements_work);
+
 	blk_mq_free_tag_set(&zlo->tag_set);
 
 	for (i = 0; i < zlo->nr_zones; i++) {
@@ -1002,15 +1316,24 @@ static void zloop_free_disk(struct gendisk *disk)
 
 	fput(zlo->data_dir);
 	destroy_workqueue(zlo->workqueue);
+	kfree(zlo->elements);
 	kfree(zlo->base_dir);
 	kvfree(zlo);
 }
 
+
+static const struct blk_storage_elements_ops zloop_se_ops = {
+	.report_elements	= zloop_report_elements,
+	.remove_element		= zloop_remove_element,
+	.restore_elements	= zloop_restore_elements,
+};
+
 static const struct block_device_operations zloop_fops = {
 	.owner			= THIS_MODULE,
 	.open			= zloop_open,
 	.report_zones		= zloop_report_zones,
 	.free_disk		= zloop_free_disk,
+	.se_ops			= &zloop_se_ops,
 };
 
 __printf(3, 4)
@@ -1095,6 +1418,17 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 	if (!opts->buffered_io)
 		oflags |= O_DIRECT;
 
+	if (zlo->stor_elements != ZLOOP_STOR_ELEMENTS_NONE) {
+		unsigned int nr_elems = zlo->nr_elements;
+
+		if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_PAIRS)
+			nr_elems /= 2;
+		zone->wr_se_id = (zone_no % nr_elems) + 1;
+		zone->rd_se_id = zone->wr_se_id;
+		if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_PAIRS)
+			zone->rd_se_id += nr_elems;
+	}
+
 	if (zone_no < zlo->nr_conv_zones) {
 		/* Conventional zone file. */
 		set_bit(ZLOOP_ZONE_CONV, &zone->flags);
@@ -1165,6 +1499,93 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 	return ret;
 }
 
+#define ZLOOP_MIN_STOR_ELEMENTS			2
+#define ZLOOP_MAX_STOR_ELEMENTS			32
+#define ZLOOP_MIN_ZONES_PER_STOR_ELEMENTS	32
+
+static int zloop_create_storage_elements(struct zloop_device *zlo)
+{
+	struct blk_storage_element *se, *paired_se;
+	unsigned int i, nr_elems, nr_elements;
+	unsigned int nr_zones_per_element, nrz = 0;
+	sector_t capacity_per_element;
+
+	/*
+	 * Calculate the number of storage elements we are going to emulate.
+	 * To achieve a somewhat realistic emulation, we want at least 2 storage
+	 * elements, and no more than 32, targeting at least 32 zones per
+	 * element.
+	 */
+	if (zlo->nr_zones <= 64)
+		nr_elements = 2;
+	else
+		nr_elements =
+			min(ZLOOP_MAX_STOR_ELEMENTS,
+			    zlo->nr_zones / ZLOOP_MIN_ZONES_PER_STOR_ELEMENTS);
+	nr_zones_per_element = zlo->nr_zones / nr_elements;
+	capacity_per_element =
+		(sector_t)nr_zones_per_element << zlo->zone_shift;
+
+	/*
+	 * If we are emulating pairs of read and write storage elements, we need
+	 * double the number of storage element descriptors.
+	 */
+	nr_elems = nr_elements;
+	if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_PAIRS)
+		nr_elems *= 2;
+	zlo->elements = kzalloc_objs(struct blk_storage_element, nr_elems);
+	if (!zlo->elements)
+		return -ENOMEM;
+
+	for (i = 0, se = zlo->elements; i < nr_elements; i++, se++) {
+		se->id = i + 1;
+		if (nrz + nr_zones_per_element > zlo->nr_zones)
+			se->nr_zones = zlo->nr_zones - nrz;
+		else
+			se->nr_zones = nr_zones_per_element;
+
+		if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_PAIRS)
+			se->type = BLK_SE_TYPE_WRITE;
+		else
+			se->type = BLK_SE_TYPE_RDWR;
+
+		se->status = BLK_SE_STS_OK;
+
+		nrz += nr_zones_per_element;
+	}
+
+	/*
+	 * If we are emulating pairs of read and write storage elements,
+	 * initialize the read elements paired with the write elements we just
+	 * initialized.
+	 */
+	if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_PAIRS) {
+		for (i = 0; i < nr_elements; i++, se++) {
+			se->id = nr_elements + i + 1;
+			paired_se = &zlo->elements[i];
+			se->paired_id = paired_se->id;
+			paired_se->paired_id = se->id;
+			se->nr_zones = paired_se->nr_zones;
+			se->type = BLK_SE_TYPE_READ;
+			se->status = BLK_SE_STS_OK;
+		}
+	}
+
+	/*
+	 * Make sure we do not allow removing all storage elements as that does
+	 * not make any sense. This is consistent with the device advertized
+	 * limit of SCSI and ATA devices supporting the storage element
+	 * depopulation feature.
+	 */
+	zlo->nr_elements = nr_elems;
+	if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_PAIRS)
+		zlo->max_nr_removed_elements = zlo->nr_elements - 2;
+	else
+		zlo->max_nr_removed_elements = zlo->nr_elements - 1;
+
+	return 0;
+}
+
 static bool zloop_dev_exists(struct zloop_device *zlo)
 {
 	struct file *cnv, *seq;
@@ -1220,6 +1641,10 @@ static int zloop_ctl_add(struct zloop_options *opts)
 	WRITE_ONCE(zlo->state, Zlo_creating);
 	spin_lock_init(&zlo->open_zones_lock);
 	INIT_LIST_HEAD(&zlo->open_zones_lru_list);
+	mutex_init(&zlo->stor_elements_lock);
+	INIT_DELAYED_WORK(&zlo->remove_element_work, zloop_remove_element_work);
+	INIT_DELAYED_WORK(&zlo->restore_elements_work,
+			  zloop_restore_elements_work);
 
 	ret = mutex_lock_killable(&zloop_ctl_mutex);
 	if (ret)
@@ -1253,12 +1678,19 @@ static int zloop_ctl_add(struct zloop_options *opts)
 	if (zlo->zone_append)
 		zlo->ordered_zone_append = opts->ordered_zone_append;
 	zlo->discard_write_cache = opts->discard_write_cache;
+	zlo->stor_elements = opts->stor_elements;
+
+	if (zlo->stor_elements != ZLOOP_STOR_ELEMENTS_NONE) {
+		ret = zloop_create_storage_elements(zlo);
+		if (ret)
+			goto out_free_idr;
+	}
 
 	zlo->workqueue = alloc_workqueue("zloop%d", WQ_UNBOUND | WQ_FREEZABLE,
 				opts->nr_queues * opts->queue_depth, zlo->id);
 	if (!zlo->workqueue) {
 		ret = -ENOMEM;
-		goto out_free_idr;
+		goto out_destroy_storage_elements;
 	}
 
 	if (opts->base_dir)
@@ -1344,6 +1776,10 @@ static int zloop_ctl_add(struct zloop_options *opts)
 		zlo->id, zlo->nr_zones,
 		((sector_t)zlo->zone_size << SECTOR_SHIFT) >> 20,
 		zlo->block_size);
+	if (zlo->nr_elements)
+		pr_info("zloop%d: %d storage elements\n",
+			zlo->id, zlo->nr_elements);
+
 	pr_info("zloop%d: using %s%s zone append\n",
 		zlo->id,
 		zlo->ordered_zone_append ? "ordered " : "",
@@ -1367,6 +1803,8 @@ static int zloop_ctl_add(struct zloop_options *opts)
 	kfree(zlo->base_dir);
 out_destroy_workqueue:
 	destroy_workqueue(zlo->workqueue);
+out_destroy_storage_elements:
+	kfree(zlo->elements);
 out_free_idr:
 	mutex_lock(&zloop_ctl_mutex);
 	idr_remove(&zloop_index_idr, zlo->id);
@@ -1485,6 +1923,7 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
 	opts->buffered_io = ZLOOP_DEF_BUFFERED_IO;
 	opts->zone_append = ZLOOP_DEF_ZONE_APPEND;
 	opts->ordered_zone_append = ZLOOP_DEF_ORDERED_ZONE_APPEND;
+	opts->stor_elements = ZLOOP_DEF_STOR_ELEMENTS;
 
 	if (!buf)
 		return 0;
@@ -1619,6 +2058,23 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
 		case ZLOOP_OPT_DISCARD_WRITE_CACHE:
 			opts->discard_write_cache = true;
 			break;
+		case ZLOOP_OPT_STOR_ELEMENTS:
+			if (match_uint(args, &token)) {
+				ret = -EINVAL;
+				goto out;
+			}
+			switch (token) {
+			case ZLOOP_STOR_ELEMENTS_NONE:
+			case ZLOOP_STOR_ELEMENTS_RDWR:
+			case ZLOOP_STOR_ELEMENTS_PAIRS:
+				break;
+			default:
+				pr_err("Invalid zone_append value\n");
+				ret = -EINVAL;
+				goto out;
+			}
+			opts->stor_elements = token;
+			break;
 		case ZLOOP_OPT_ERR:
 		default:
 			pr_warn("unknown parameter or missing value '%s'\n", p);
-- 
2.55.0

