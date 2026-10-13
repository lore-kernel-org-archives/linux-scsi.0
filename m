Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDDC4FB9DE;
	Tue, 13 Oct 2026 12:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894482; cv=none; b=ljPCdnNKM/1dJip/pT0+ODDzJDgHj93503ESS7vuO77RElTXdPLUParatwltUtf8sr47ENPW8lpSItTLk0tAVCYwWuYmqIa7CMQZwjC40zww8z0XaLZQUQ2AtlDQH+5IdiYXWMUbzhmP6zihfhIVeEje6ubeyhlzz55pJwKWpgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894482; c=relaxed/simple;
	bh=Lor8bBBQQ0bXU0JFiPFPoYxVF5O0rObWt6GTK57YoGw=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fEzKBY/UhZlA1+GmQrcelEMC7ndJcTYp+n25bShCboS04Zn2fOFAru65VQ0QeEUyfO9vFCCuFZyBkOPA0iFccNw+j53Tk2+H0E9y941s44KHTe31dZf14vyH3snz4gS8Q6izWMnXqxtZttLveObuQr6XVoWqKz/QKl+y9wlVFqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JKhyH29L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JKhyH29L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0AD01F0089A;
	Tue, 13 Oct 2026 12:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791894479;
	bh=U2FQLuTapyKTp5sEn8Z+OIZbyKUfw85qgyQjOJjpqUw=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=JKhyH29LqLqQx/GQuuZPlLHQMCAESyVEC9pscuDTykbtz4tbu3aElHGO/WZ3mAe3p
	 Kh0E3EkpoC92RYja/6pHw5DShn8cnoeyGwesjndskTiBwD4TLQEzrack/IXWhaIfcF
	 8HESVdY9RBWhDRsxLluMw/zFHXky4CMRVWtyGDJfD4eXv2p/QcaMc5vtIQYEw9Fiph
	 UlA1ctGYn9vcbfYFiG5vP5oALLuaIf8BtgTYV+uvm2Pbx9RHFneU44PNXITb/r0aXn
	 W3sqhllwJ+iJMtr3WO07gybo8jFblxQbVcivMRpT9QSwqxoLC4nBYtlLd7VZgaovjH
	 i9BQG8KLIl1Uw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v6 06/10] zloop: add storage element emulation
Date: Tue, 13 Oct 2026 21:27:46 +0900
Message-ID: <20261013122750.2237843-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013122750.2237843-1-dlemoal@kernel.org>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
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
 .../admin-guide/blockdev/zoned_loop.rst       |  10 +-
 drivers/block/zloop.c                         | 690 ++++++++++++++++--
 2 files changed, 656 insertions(+), 44 deletions(-)

diff --git a/Documentation/admin-guide/blockdev/zoned_loop.rst b/Documentation/admin-guide/blockdev/zoned_loop.rst
index 64277494fb36..6f344dc151a0 100644
--- a/Documentation/admin-guide/blockdev/zoned_loop.rst
+++ b/Documentation/admin-guide/blockdev/zoned_loop.rst
@@ -61,7 +61,7 @@ The options available for the add command can be listed by reading the
 /dev/zloop-control device::
 
 	$ cat /dev/zloop-control
-        add id=%d,capacity_mb=%u,zone_size_mb=%u,zone_capacity_mb=%u,conv_zones=%u,max_open_zones=%u,base_dir=%s,nr_queues=%u,queue_depth=%u,buffered_io,zone_append=%u,ordered_zone_append,discard_write_cache
+        add id=%d,capacity_mb=%u,zone_size_mb=%u,zone_capacity_mb=%u,conv_zones=%u,max_open_zones=%u,base_dir=%s,nr_queues=%u,queue_depth=%u,buffered_io,zone_append=%u,ordered_zone_append,discard_write_cache,stor_elements=%u
         remove id=%d
 
 In more details, the options that can be used with the "add" command are as
@@ -113,6 +113,14 @@ discard_write_cache   Discard all data that was not explicitly persisted using a
                       each zone file to the size recorded during the last flush
                       operation. This simulates power fail events where
                       uncommitted data is lost.
+stor_elements         Control storage element emulation. The default value is
+                      0, indicating no emulation. A value of 1 indicates that
+                      access storage elements are emulated as full access
+                      physical elements, which is equivalent to combined
+                      read+write heads of a hard-disk. A value of 2 enables
+                      storage element emulation as fractional access physical
+                      storage elements, which is equivalent to pairs of read
+                      and write heads of a hard-disk.
 ===================   =========================================================
 
 3) Deleting a Zoned Device
diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index cbe199c135b0..24470c3d2e80 100644
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
+	struct blk_se		*elements;
+
 	struct zloop_zone	zones[] __counted_by(nr_zones);
 };
 
@@ -289,22 +317,65 @@ static bool zloop_do_open_zone(struct zloop_device *zlo,
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
+}
+
+static inline void zloop_set_zone_full(struct zloop_device *zlo,
+				       struct zloop_zone *zone)
+{
+	zloop_set_zone_cond(zlo, zone, BLK_ZONE_COND_FULL);
+}
+
+static inline void zloop_set_zone_empty(struct zloop_device *zlo,
+					struct zloop_zone *zone)
+{
+	zloop_set_zone_cond(zlo, zone, BLK_ZONE_COND_EMPTY);
 }
 
-static void zloop_mark_empty(struct zloop_device *zlo, struct zloop_zone *zone)
+static bool zloop_zone_element_is_ok(struct zloop_device *zlo,
+				     struct zloop_zone *zone, bool for_write)
 {
+	struct blk_se *se;
+
 	lockdep_assert_held(&zone->wp_lock);
 
-	zloop_lru_remove_open_zone(zlo, zone);
-	zone->cond = BLK_ZONE_COND_EMPTY;
-	zone->wp = zone->start;
+	if (!zlo->nr_elements)
+		return true;
+
+	if (for_write)
+		se = &zlo->elements[zone->wr_se_id - 1];
+	else
+		se = &zlo->elements[zone->rd_se_id - 1];
+
+	return READ_ONCE(se->status) == BLK_SE_STS_OK;
+}
+
+static bool zloop_zone_is_ok(struct zloop_device *zlo, struct zloop_zone *zone)
+{
+	unsigned long flags;
+	bool ret;
+
+	spin_lock_irqsave(&zone->wp_lock, flags);
+
+	ret = zloop_zone_element_is_ok(zlo, zone, true);
+	if (ret)
+		ret = zone->cond != BLK_ZONE_COND_OFFLINE &&
+			zone->cond != BLK_ZONE_COND_READONLY;
+
+	spin_unlock_irqrestore(&zone->wp_lock, flags);
+
+	return ret;
 }
 
 static int zloop_update_seq_zone(struct zloop_device *zlo, unsigned int zone_no)
@@ -317,6 +388,13 @@ static int zloop_update_seq_zone(struct zloop_device *zlo, unsigned int zone_no)
 
 	lockdep_assert_held(&zone->lock);
 
+	/*
+	 * If the zone is about to or was already changed to offline or
+	 * read-only, we have nothing to do.
+	 */
+	if (!zloop_zone_is_ok(zlo, zone))
+		return 0;
+
 	ret = vfs_getattr(&zone->file->f_path, &stat, STATX_SIZE, 0);
 	if (ret < 0) {
 		pr_err("Failed to get zone %u file stat (err=%d)\n",
@@ -340,9 +418,9 @@ static int zloop_update_seq_zone(struct zloop_device *zlo, unsigned int zone_no)
 
 	spin_lock_irqsave(&zone->wp_lock, flags);
 	if (!file_sectors) {
-		zloop_mark_empty(zlo, zone);
+		zloop_set_zone_empty(zlo, zone);
 	} else if (file_sectors == zlo->zone_capacity) {
-		zloop_mark_full(zlo, zone);
+		zloop_set_zone_full(zlo, zone);
 	} else {
 		if (zone->cond != BLK_ZONE_COND_IMP_OPEN &&
 		    zone->cond != BLK_ZONE_COND_EXP_OPEN)
@@ -364,6 +442,11 @@ static int zloop_open_zone(struct zloop_device *zlo, unsigned int zone_no)
 
 	mutex_lock(&zone->lock);
 
+	if (!zloop_zone_is_ok(zlo, zone)) {
+		ret = -EIO;
+		goto unlock;
+	}
+
 	if (test_and_clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags)) {
 		ret = zloop_update_seq_zone(zlo, zone_no);
 		if (ret)
@@ -390,6 +473,11 @@ static int zloop_close_zone(struct zloop_device *zlo, unsigned int zone_no)
 
 	mutex_lock(&zone->lock);
 
+	if (!zloop_zone_is_ok(zlo, zone)) {
+		ret = -EIO;
+		goto unlock;
+	}
+
 	if (test_and_clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags)) {
 		ret = zloop_update_seq_zone(zlo, zone_no);
 		if (ret)
@@ -422,10 +510,26 @@ static int zloop_close_zone(struct zloop_device *zlo, unsigned int zone_no)
 	return ret;
 }
 
-static int zloop_reset_zone(struct zloop_device *zlo, unsigned int zone_no)
+static int zloop_do_reset_zone(struct zloop_device *zlo,
+			       struct zloop_zone *zone)
 {
-	struct zloop_zone *zone = &zlo->zones[zone_no];
 	unsigned long flags;
+
+	if (vfs_truncate(&zone->file->f_path, 0))
+		return -EIO;
+
+	spin_lock_irqsave(&zone->wp_lock, flags);
+	zloop_set_zone_empty(zlo, zone);
+	clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
+	spin_unlock_irqrestore(&zone->wp_lock, flags);
+
+	return 0;
+}
+
+static int zloop_reset_zone(struct zloop_device *zlo, unsigned int zone_no,
+			    bool all_zones)
+{
+	struct zloop_zone *zone = &zlo->zones[zone_no];
 	int ret = 0;
 
 	if (test_bit(ZLOOP_ZONE_CONV, &zone->flags))
@@ -433,20 +537,19 @@ static int zloop_reset_zone(struct zloop_device *zlo, unsigned int zone_no)
 
 	mutex_lock(&zone->lock);
 
+	if (!zloop_zone_is_ok(zlo, zone)) {
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
-	spin_lock_irqsave(&zone->wp_lock, flags);
-	zloop_mark_empty(zlo, zone);
-	clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
-	spin_unlock_irqrestore(&zone->wp_lock, flags);
 
 unlock:
 	mutex_unlock(&zone->lock);
@@ -460,7 +563,7 @@ static int zloop_reset_all_zones(struct zloop_device *zlo)
 	int ret;
 
 	for (i = zlo->nr_conv_zones; i < zlo->nr_zones; i++) {
-		ret = zloop_reset_zone(zlo, i);
+		ret = zloop_reset_zone(zlo, i, true);
 		if (ret)
 			return ret;
 	}
@@ -479,6 +582,11 @@ static int zloop_finish_zone(struct zloop_device *zlo, unsigned int zone_no)
 
 	mutex_lock(&zone->lock);
 
+	if (!zloop_zone_is_ok(zlo, zone)) {
+		ret = -EIO;
+		goto unlock;
+	}
+
 	if (!test_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags) &&
 	    zone->cond == BLK_ZONE_COND_FULL)
 		goto unlock;
@@ -491,7 +599,7 @@ static int zloop_finish_zone(struct zloop_device *zlo, unsigned int zone_no)
 	}
 
 	spin_lock_irqsave(&zone->wp_lock, flags);
-	zloop_mark_full(zlo, zone);
+	zloop_set_zone_full(zlo, zone);
 	clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
 	spin_unlock_irqrestore(&zone->wp_lock, flags);
 
@@ -634,7 +742,7 @@ static int zloop_seq_write_prep(struct zloop_cmd *cmd)
 	if (!is_append || !zlo->ordered_zone_append) {
 		zone->wp += nr_sectors;
 		if (zone->wp == zone_end)
-			zloop_mark_full(zlo, zone);
+			zloop_set_zone_full(zlo, zone);
 	}
 out_unlock:
 	spin_unlock_irqrestore(&zone->wp_lock, flags);
@@ -776,7 +884,7 @@ static void zloop_handle_cmd(struct zloop_cmd *cmd)
 		cmd->ret = zloop_flush(zlo);
 		break;
 	case REQ_OP_ZONE_RESET:
-		cmd->ret = zloop_reset_zone(zlo, rq_zone_no(rq));
+		cmd->ret = zloop_reset_zone(zlo, rq_zone_no(rq), false);
 		break;
 	case REQ_OP_ZONE_RESET_ALL:
 		cmd->ret = zloop_reset_all_zones(zlo);
@@ -885,31 +993,62 @@ static void zloop_complete_rq(struct request *rq)
 	blk_mq_end_request(rq, sts);
 }
 
-static bool zloop_set_zone_append_sector(struct request *rq)
+static bool zloop_set_zone_append_sector(struct zloop_device *zlo,
+					 struct zloop_zone *zone,
+					 struct request *rq)
 {
-	struct zloop_device *zlo = rq->q->queuedata;
-	unsigned int zone_no = rq_zone_no(rq);
-	struct zloop_zone *zone = &zlo->zones[zone_no];
 	sector_t zone_end = zone->start + zlo->zone_capacity;
 	sector_t nr_sectors = blk_rq_sectors(rq);
-	unsigned long flags;
-
-	spin_lock_irqsave(&zone->wp_lock, flags);
 
 	if (zone->cond == BLK_ZONE_COND_FULL ||
-	    zone->wp + nr_sectors > zone_end) {
-		spin_unlock_irqrestore(&zone->wp_lock, flags);
+	    zone->wp + nr_sectors > zone_end)
 		return false;
-	}
 
 	rq->__sector = zone->wp;
 	zone->wp += blk_rq_sectors(rq);
 	if (zone->wp >= zone_end)
-		zloop_mark_full(zlo, zone);
+		zloop_set_zone_full(zlo, zone);
+
+	return true;
+}
+
+static bool zloop_prep_rq(struct zloop_device *zlo, struct request *rq)
+{
+	struct zloop_zone *zone = &zlo->zones[rq_zone_no(rq)];
+	bool is_write = op_is_write(req_op(rq));
+	unsigned long flags;
+	bool ret = true;
+
+	spin_lock_irqsave(&zone->wp_lock, flags);
+
+	/*
+	 * If storage element emulation is enabled, check the health state of
+	 * the storage element serving the zone and the zone condition: do not
+	 * allow any operation to zones served by an unusable storage element,
+	 * operations to offline zones, and allow only read operations to
+	 * read-only zones.
+	 */
+	if (zlo->nr_elements) {
+		if (!zloop_zone_element_is_ok(zlo, zone, is_write) ||
+		    zone->cond == BLK_ZONE_COND_OFFLINE ||
+		    (zone->cond == BLK_ZONE_COND_READONLY && is_write)) {
+			ret = false;
+			goto unlock;
+		}
+	}
+
+	/*
+	 * If we need to strongly order zone append operations, set the request
+	 * sector to the zone write pointer location now instead of when the
+	 * command work runs.
+	 */
+	if (zlo->ordered_zone_append && req_op(rq) == REQ_OP_ZONE_APPEND)
+		ret = zloop_set_zone_append_sector(zlo, zone, rq);
 
+unlock:
 	spin_unlock_irqrestore(&zone->wp_lock, flags);
 
-	return true;
+	return ret;
 }
 
 static blk_status_t zloop_queue_rq(struct blk_mq_hw_ctx *hctx,
@@ -925,13 +1064,30 @@ static blk_status_t zloop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	}
 
 	/*
-	 * If we need to strongly order zone append operations, set the request
-	 * sector to the zone write pointer location now instead of when the
-	 * command work runs.
+	 * Do not allow commands while the restoration of storage elements is
+	 * in progress.
+	 */
+	if (READ_ONCE(zlo->restore_in_progress))
+		return BLK_STS_IOERR;
+
+	/*
+	 * If restoration is not in progress, check if commands are allowed. If
+	 * storage element emulation is enabled, also check the state of the
+	 * storage element serving the target zones. The exception here is
+	 * flush: we let flush proceed as we assume that a real device would
+	 * flush data only to zones served by good storage elements. Similarly,
+	 * a reset all operation is allow to proceed as zones under a storage
+	 * element being removed are skipped.
 	 */
-	if (zlo->ordered_zone_append && req_op(rq) == REQ_OP_ZONE_APPEND) {
-		if (!zloop_set_zone_append_sector(rq))
+	switch (req_op(rq)) {
+	case REQ_OP_READ:
+	case REQ_OP_WRITE:
+	case REQ_OP_ZONE_APPEND:
+		if (!zloop_prep_rq(zlo, rq))
 			return BLK_STS_IOERR;
+		break;
+	default:
+		break;
 	}
 
 	blk_mq_start_request(rq);
@@ -1014,11 +1170,323 @@ static int zloop_report_zones(struct gendisk *disk, sector_t sector,
 	return nr_zones;
 }
 
+static int zloop_report_elements(struct gendisk *disk,
+				 struct blk_se *elements,
+				 unsigned int *nr_elements)
+{
+	struct zloop_device *zlo = disk->private_data;
+	struct blk_se *se;
+	unsigned int i;
+
+	if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_NONE)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&zlo->stor_elements_lock);
+
+	if (!elements) {
+		*nr_elements = zlo->nr_elements;
+		goto unlock;
+	}
+
+	*nr_elements = min(*nr_elements, zlo->nr_elements);
+	for (i = 0, se = zlo->elements; i < *nr_elements; i++, se++) {
+		switch (READ_ONCE(se->status)) {
+		case BLK_SE_STS_REMOVED:
+			se->restore_allowed = 1;
+			break;
+		default:
+			se->restore_allowed = 0;
+		}
+		memcpy(&elements[i], se, sizeof(struct blk_se));
+	}
+
+unlock:
+	mutex_unlock(&zlo->stor_elements_lock);
+
+	return 0;
+}
+
+static void zloop_remove_element_work(struct work_struct *work)
+{
+	struct zloop_device *zlo = container_of(work, struct zloop_device,
+						remove_element_work.work);
+	struct gendisk *disk = zlo->disk;
+	struct blk_se *se, *paired_se = NULL;
+	enum blk_zone_cond cond;
+	struct zloop_zone *zone;
+	unsigned int memflags, i;
+
+	mutex_lock(&zlo->stor_elements_lock);
+
+	if (test_bit(GD_DEAD, &disk->state))
+		goto unlock;
+
+	/* Wait for all IOs to complete. */
+	memflags = blk_mq_freeze_queue(disk->queue);
+	blk_mq_unfreeze_queue(disk->queue, memflags);
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
+		unsigned long flags;
+
+		if (zone->wr_se_id != se->id && zone->rd_se_id != se->id)
+			continue;
+		mutex_lock(&zone->lock);
+		spin_lock_irqsave(&zone->wp_lock, flags);
+		clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
+		zloop_set_zone_cond(zlo, zone, cond);
+		spin_unlock_irqrestore(&zone->wp_lock, flags);
+		mutex_unlock(&zone->lock);
+	}
+
+	WRITE_ONCE(se->status, BLK_SE_STS_REMOVED);
+	zlo->nr_removed_elements++;
+	if (paired_se && READ_ONCE(paired_se->status) != BLK_SE_STS_REMOVED) {
+		WRITE_ONCE(paired_se->status, BLK_SE_STS_REMOVED);
+		zlo->nr_removed_elements++;
+	}
+
+	zlo->remove_element_id = 0;
+
+unlock:
+	mutex_unlock(&zlo->stor_elements_lock);
+	put_disk(disk);
+}
+
+static int zloop_remove_element(struct gendisk *disk, unsigned int element_id)
+{
+	struct zloop_device *zlo = disk->private_data;
+	struct blk_se *se, *paired_se = NULL;
+	unsigned int nr_remove = 1;
+	bool remove_scheduled = false;
+	int ret = 0;
+
+	if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_NONE)
+		return -EOPNOTSUPP;
+
+	if (!element_id || element_id > zlo->nr_elements)
+		return -EINVAL;
+
+	mutex_lock(&zlo->stor_elements_lock);
+
+	if (zlo->remove_element_id || READ_ONCE(zlo->restore_in_progress)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	/*
+	 * Get the element to remove. If it is already removed, we have nothing
+	 * to do.
+	 */
+	se = &zlo->elements[element_id - 1];
+	if (READ_ONCE(se->status) == BLK_SE_STS_REMOVED)
+		goto unlock;
+
+	/*
+	 * If the element to remove is a read element, the associated write
+	 * element must also be removed.
+	 */
+	if (se->type == BLK_SE_TYPE_READ) {
+		paired_se = &zlo->elements[se->paired_id - 1];
+		if (READ_ONCE(paired_se->status) != BLK_SE_STS_REMOVED)
+			nr_remove = 2;
+	}
+
+	if (zlo->nr_removed_elements + nr_remove >
+	    zlo->max_nr_removed_elements) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	/*
+	 * Use a delayed work to schedule the actual element removal, to
+	 * emulate the (generally short) time it takes for a real zoned device
+	 * to depopulate a head and modify the zones. Protect the delayed work
+	 * operation against disk removal by taking a reference on the disk.
+	 */
+	zlo->remove_element_id = element_id;
+	WRITE_ONCE(se->status, BLK_SE_STS_REMOVE_IN_PROGRESS);
+	if (paired_se && READ_ONCE(paired_se->status) != BLK_SE_STS_REMOVED)
+		WRITE_ONCE(paired_se->status, BLK_SE_STS_REMOVE_IN_PROGRESS);
+
+	get_device(disk_to_dev(disk));
+	remove_scheduled = schedule_delayed_work(&zlo->remove_element_work,
+						 msecs_to_jiffies(2000));
+
+unlock:
+	mutex_unlock(&zlo->stor_elements_lock);
+	if (!remove_scheduled)
+		put_disk(disk);
+
+	return ret;
+}
+
+static int zloop_restore_truncate_zone_file(struct zloop_device *zlo,
+					    struct zloop_zone *zone)
+{
+	int ret = 0;
+
+	if (test_bit(ZLOOP_ZONE_CONV, &zone->flags))
+		return 0;
+
+	mutex_lock(&zone->lock);
+	if (vfs_truncate(&zone->file->f_path, 0))
+		ret = -EIO;
+	mutex_unlock(&zone->lock);
+
+	return ret;
+}
+
+static void zloop_restore_zone(struct zloop_device *zlo,
+			       struct zloop_zone *zone)
+{
+	unsigned long flags;
+
+	mutex_lock(&zone->lock);
+	spin_lock_irqsave(&zone->wp_lock, flags);
+	if (test_bit(ZLOOP_ZONE_CONV, &zone->flags))
+		zloop_set_zone_cond(zlo, zone, BLK_ZONE_COND_NOT_WP);
+	else
+		zloop_set_zone_empty(zlo, zone);
+	spin_unlock_irqrestore(&zone->wp_lock, flags);
+	mutex_unlock(&zone->lock);
+}
+
+static void zloop_restore_elements_work(struct work_struct *work)
+{
+	struct zloop_device *zlo = container_of(work, struct zloop_device,
+						restore_elements_work.work);
+	struct gendisk *disk = zlo->disk;
+	struct zloop_zone *zone;
+	struct blk_se *se;
+	unsigned int memflags, i;
+	enum blk_se_status sts;
+	int ret = 0;
+
+	mutex_lock(&zlo->stor_elements_lock);
+
+	if (test_bit(GD_DEAD, &disk->state))
+		goto unlock;
+
+	/* Wait for all IOs to complete. */
+	memflags = blk_mq_freeze_queue(disk->queue);
+	blk_mq_unfreeze_queue(disk->queue, memflags);
+
+	/*
+	 * First, truncate all files for sequential zones. If this fails,
+	 * we will change the storage elements back to a removed state.
+	 */
+	for (i = 0, zone = zlo->zones; i < zlo->nr_zones; i++, zone++) {
+		ret = zloop_restore_truncate_zone_file(zlo, zone);
+		if (ret) {
+			pr_err("zloop%d: truncate zone %u file failed\n",
+			       zlo->id, i);
+			break;
+		}
+	}
+
+	/*
+	 * If all files for sequential zones have been truncated, adjust the
+	 * zone conditions.
+	 */
+	if (!ret) {
+		for (i = 0, zone = zlo->zones; i < zlo->nr_zones; i++, zone++)
+			zloop_restore_zone(zlo, zone);
+		sts = BLK_SE_STS_OK;
+	} else {
+		sts = BLK_SE_STS_REMOVED;
+	}
+
+	/* Restore all removed elements. */
+	for (i = 0, se = zlo->elements; i < zlo->nr_elements; i++, se++) {
+		if (READ_ONCE(se->status) == BLK_SE_STS_RESTORE_IN_PROGRESS)
+			WRITE_ONCE(se->status, sts);
+	}
+	if (!ret)
+		zlo->nr_removed_elements = 0;
+
+unlock:
+	WRITE_ONCE(zlo->restore_in_progress, false);
+	mutex_unlock(&zlo->stor_elements_lock);
+	put_disk(disk);
+}
+
+static int zloop_restore_elements(struct gendisk *disk)
+{
+	struct zloop_device *zlo = disk->private_data;
+	struct blk_se *se;
+	unsigned int i;
+	bool restore_scheduled = false;
+	int ret = 0;
+
+	if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_NONE)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&zlo->stor_elements_lock);
+
+	if (zlo->remove_element_id || READ_ONCE(zlo->restore_in_progress)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	/* If we have no removed elements, we have nothing to do. */
+	if (!zlo->nr_removed_elements)
+		goto unlock;
+	/*
+	 * Use a delayed work to schedule the actual element restoration, to
+	 * emulate the (potentially long) time it takes for a real zoned device
+	 * to restore storage elements. Protect the delayed work operation
+	 * against disk removal by taking a reference on the disk.
+	 */
+	WRITE_ONCE(zlo->restore_in_progress, true);
+	for (i = 0, se = zlo->elements; i < zlo->nr_elements; i++, se++) {
+		if (READ_ONCE(se->status) == BLK_SE_STS_REMOVED)
+			WRITE_ONCE(se->status, BLK_SE_STS_RESTORE_IN_PROGRESS);
+	}
+
+	get_device(disk_to_dev(disk));
+	restore_scheduled = schedule_delayed_work(&zlo->restore_elements_work,
+						  msecs_to_jiffies(5000));
+
+unlock:
+	mutex_unlock(&zlo->stor_elements_lock);
+	if (!restore_scheduled)
+		put_disk(zlo->disk);
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
@@ -1031,15 +1499,24 @@ static void zloop_free_disk(struct gendisk *disk)
 
 	fput(zlo->data_dir);
 	destroy_workqueue(zlo->workqueue);
+	kfree(zlo->elements);
 	kfree(zlo->base_dir);
 	kvfree(zlo);
 }
 
+
+static const struct blk_se_ops zloop_se_ops = {
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
@@ -1124,6 +1601,24 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 	if (!opts->buffered_io)
 		oflags |= O_DIRECT;
 
+	if (zlo->stor_elements != ZLOOP_STOR_ELEMENTS_NONE) {
+		unsigned int nr_elems = zlo->nr_elements;
+		unsigned int se_idx;
+
+		if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_PAIRS)
+			nr_elems /= 2;
+		se_idx = zone_no % nr_elems;
+		zlo->elements[se_idx].nr_zones++;
+
+		zone->wr_se_id = se_idx + 1;
+		zone->rd_se_id = zone->wr_se_id;
+		if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_PAIRS) {
+			zone->rd_se_id += nr_elems;
+			zlo->elements[zone->rd_se_id - 1].nr_zones =
+				zlo->elements[se_idx].nr_zones;
+		}
+	}
+
 	if (zone_no < zlo->nr_conv_zones) {
 		/* Conventional zone file. */
 		set_bit(ZLOOP_ZONE_CONV, &zone->flags);
@@ -1194,6 +1689,79 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 	return ret;
 }
 
+#define ZLOOP_MIN_STOR_ELEMENTS			2
+#define ZLOOP_MAX_STOR_ELEMENTS			32
+#define ZLOOP_MIN_ZONES_PER_STOR_ELEMENTS	32
+
+static int zloop_create_storage_elements(struct zloop_device *zlo)
+{
+	struct blk_se *se, *paired_se;
+	unsigned int i, nr_elems, nr_elements;
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
+
+	/*
+	 * If we are emulating pairs of read and write storage elements, we need
+	 * double the number of storage element descriptors.
+	 */
+	nr_elems = nr_elements;
+	if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_PAIRS)
+		nr_elems *= 2;
+	zlo->elements = kzalloc_objs(struct blk_se, nr_elems);
+	if (!zlo->elements)
+		return -ENOMEM;
+
+	for (i = 0, se = zlo->elements; i < nr_elements; i++, se++) {
+		se->id = i + 1;
+		if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_PAIRS)
+			se->type = BLK_SE_TYPE_WRITE;
+		else
+			se->type = BLK_SE_TYPE_RDWR;
+		se->status = BLK_SE_STS_OK;
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
@@ -1249,6 +1817,11 @@ static int zloop_ctl_add(struct zloop_options *opts)
 	WRITE_ONCE(zlo->state, Zlo_creating);
 	spin_lock_init(&zlo->open_zones_lock);
 	INIT_LIST_HEAD(&zlo->open_zones_lru_list);
+	mutex_init(&zlo->stor_elements_lock);
+	INIT_DELAYED_WORK(&zlo->remove_element_work,
+			  zloop_remove_element_work);
+	INIT_DELAYED_WORK(&zlo->restore_elements_work,
+			  zloop_restore_elements_work);
 
 	ret = mutex_lock_killable(&zloop_ctl_mutex);
 	if (ret)
@@ -1282,12 +1855,19 @@ static int zloop_ctl_add(struct zloop_options *opts)
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
@@ -1373,6 +1953,10 @@ static int zloop_ctl_add(struct zloop_options *opts)
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
@@ -1396,6 +1980,8 @@ static int zloop_ctl_add(struct zloop_options *opts)
 	kfree(zlo->base_dir);
 out_destroy_workqueue:
 	destroy_workqueue(zlo->workqueue);
+out_destroy_storage_elements:
+	kfree(zlo->elements);
 out_free_idr:
 	mutex_lock(&zloop_ctl_mutex);
 	idr_remove(&zloop_index_idr, zlo->id);
@@ -1514,6 +2100,7 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
 	opts->buffered_io = ZLOOP_DEF_BUFFERED_IO;
 	opts->zone_append = ZLOOP_DEF_ZONE_APPEND;
 	opts->ordered_zone_append = ZLOOP_DEF_ORDERED_ZONE_APPEND;
+	opts->stor_elements = ZLOOP_DEF_STOR_ELEMENTS;
 
 	if (!buf)
 		return 0;
@@ -1648,6 +2235,23 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
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
+				pr_err("Invalid stor_elements value\n");
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

