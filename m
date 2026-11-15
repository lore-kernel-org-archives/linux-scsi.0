Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794754228;
	b=awi3Hwmy0iG8i7Ts9FN1/q8AfpW8HWsyfSoQ4Wjch8guTH+e3cHida4g1KiuPt+E+1WT
	 TTOwdeNf85VAqu+ZBJKIPo4zSEjQrX6xzKfRROhZzS2dmcDDbx8F8Gpmoz52uw8+xLLtY
	 hGPtO8xLC+mz0qK2goERobHIWtYs1OebFeMhw8wQXm6GZoEGJVJt0uTxapZKFgUgr1r9C
	 1N7G4K81loqCeeYNlcaDZlEtEZoWO3eE8ni6GobaLr7d/4NiUsOxQHR6Wm3LngjZfG3H+
	 9wyKEJycU3kaxp+xk9nlhrKsZvZE9ZRRUfQmQEG8/K1nQGtkbPLIT23qcioW9be+dtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794754228;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=FE8kKaKVyrUd6ImWvNXFC4Cy7CduKpIcXg1mKGAryKc=;
	b=pc48UbJyty/K/xAGS9/O0IpChUs/q6xfGupR3uHpyVRWrxOUpaVVpPJxeZSEzspBSgPy
	 TFWv4Bh1InG5F7az3yY2puAc9ZOwHkaYtFdxQV2LCzQNi80QpHXzQaryE3XA4Kh/fpu5/
	 KRqpOPw18RCxGTdVfYeED+ZE8GtwyOJYyQZRxUSpnhpBV2gY1NBnxR0cwdsFejdW93E9z
	 dX+3dxrPMSWynVl/751bkFrjzbrJYIYfWpBTVCFZJGMIR4YhFdxGAc5EwW4ubs8md+Vg9
	 H3SMXQA+yii25iNUvWaX/D6g34AXt2p968jCsyXXKKNs0tB/4w/0aGkPU1Bv3zbGVMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QZ7cybLd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5253D606A31D;
	Sun, 15 Nov 2026 14:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=QZ7cybLd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F176E1F000C5;
	Sun, 15 Nov 2026 14:50:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794754227;
	bh=FE8kKaKVyrUd6ImWvNXFC4Cy7CduKpIcXg1mKGAryKc=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=QZ7cybLdON/hw39Q6gvYe9Oao51X2DuUjQs/5b826UIsR5ZUJBXODrMBeSAeQ/T08
	 FtTQaytzvJWmVppIEGeZl+B9SxzDav4+u2zBeCo/epJmstbksFQd0UQrKIgs1Uebo7
	 AW5YUj0YvudQcaNBU4xAVaV26Jam4DPLijy12DbkabXU7K1fKiEvC0VsmAP94CfeCI
	 WZj9rzf2WLoeAlJc77HjqN1SAOZazwmPfiW84x5VjZ9CL/PTK5y8m6BslAr+8EFV1x
	 zQ+jtdFO2808RkBQKrAREDj292zoUOzxvx62B6C/fDZjCK1wFqA1NxzUL6hefwqX7S
	 5P8IINJxlllPA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v9 08/13] zloop: add storage element emulation
Date: Sun, 15 Nov 2026 23:50:10 +0900
Message-ID: <20261115145015.938426-9-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115145015.938426-1-dlemoal@kernel.org>
References: <20261115145015.938426-1-dlemoal@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Emulate the storage element depopulation feature of SMR disks in the
zloop driver. This emulation is controlled using the new stor_elements
option. This option can take several values:
 - ZLOOP_STOR_ELEMENTS_NONE (0): no emulation (default)
 - ZLOOP_STOR_ELEMENTS_RDWR (1): emulate all access storage elements
   (e.g.  read+write heads)
 - ZLOOP_STOR_ELEMENTS_PAIRS (2): emulate fractional access storage
   elements (e.g. pairs of read and write heads)

If enabled with the value 1 or 2, the number of storage elements, or of
pairs of fractional access storage elements, is automatically calculated
based on the number of zones of the device so that we have at least 2 and
at most 32 storage elements or pairs of fractional access storage
elements.

The mapping of zones to storage elements is defined simply as the modulo
of a zone number with the the number of storage elements for the all
access storage elements emulation and with the number of storage element
pairs for the fractional access storage element emulation case.
E.g, removing a storage element from a set of 4 all access storage
elements will offline 1 zone every 4 zones.

The storage element management operations are specified with the
zloop_se_ops (struct blk_se_ops).

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 .../admin-guide/blockdev/zoned_loop.rst       |  11 +-
 drivers/block/zloop.c                         | 738 ++++++++++++++++--
 2 files changed, 700 insertions(+), 49 deletions(-)

diff --git a/Documentation/admin-guide/blockdev/zoned_loop.rst b/Documentation/admin-guide/blockdev/zoned_loop.rst
index 64277494fb36..80a564836c1b 100644
--- a/Documentation/admin-guide/blockdev/zoned_loop.rst
+++ b/Documentation/admin-guide/blockdev/zoned_loop.rst
@@ -61,7 +61,7 @@ The options available for the add command can be listed by reading the
 /dev/zloop-control device::
 
 	$ cat /dev/zloop-control
-        add id=%d,capacity_mb=%u,zone_size_mb=%u,zone_capacity_mb=%u,conv_zones=%u,max_open_zones=%u,base_dir=%s,nr_queues=%u,queue_depth=%u,buffered_io,zone_append=%u,ordered_zone_append,discard_write_cache
+        add id=%d,capacity_mb=%u,zone_size_mb=%u,zone_capacity_mb=%u,conv_zones=%u,max_open_zones=%u,base_dir=%s,nr_queues=%u,queue_depth=%u,buffered_io,zone_append=%u,ordered_zone_append,discard_write_cache,stor_elements=%u
         remove id=%d
 
 In more details, the options that can be used with the "add" command are as
@@ -113,6 +113,15 @@ discard_write_cache   Discard all data that was not explicitly persisted using a
                       each zone file to the size recorded during the last flush
                       operation. This simulates power fail events where
                       uncommitted data is lost.
+stor_elements         Control storage element emulation. The default value is
+                      0, indicating no emulation. A value of 1 indicates that
+                      storage elements are emulated as full access physical
+                      elements, which is equivalent to combined read+write heads
+                      of a hard-disk. A value of 2 enables storage element
+                      emulation as fractional access physical storage elements,
+                      which is equivalent to pairs of read and write heads of a
+                      hard-disk. The health state of storage elements is not
+                      preserved across a zloop device remove and add.
 ===================   =========================================================
 
 3) Deleting a Zoned Device
diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index a13937f3bf6b..057cc2db0bec 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -18,6 +18,7 @@
 #include <linux/parser.h>
 #include <linux/seq_file.h>
 #include <linux/xattr.h>
+#include <linux/delay.h>
 
 /*
  * Options for adding (and removing) a device.
@@ -37,6 +38,7 @@ enum {
 	ZLOOP_OPT_ORDERED_ZONE_APPEND	= (1 << 10),
 	ZLOOP_OPT_DISCARD_WRITE_CACHE	= (1 << 11),
 	ZLOOP_OPT_MAX_OPEN_ZONES	= (1 << 12),
+	ZLOOP_OPT_STOR_ELEMENTS		= (1 << 13),
 };
 
 static const match_table_t zloop_opt_tokens = {
@@ -51,11 +53,22 @@ static const match_table_t zloop_opt_tokens = {
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
@@ -68,6 +81,7 @@ static const match_table_t zloop_opt_tokens = {
 #define ZLOOP_DEF_BUFFERED_IO		false
 #define ZLOOP_DEF_ZONE_APPEND		true
 #define ZLOOP_DEF_ORDERED_ZONE_APPEND	false
+#define ZLOOP_DEF_STOR_ELEMENTS		ZLOOP_STOR_ELEMENTS_NONE
 
 /* Arbitrary limit on the zone size (16GB). */
 #define ZLOOP_MAX_ZONE_SIZE_MB		16384
@@ -87,6 +101,7 @@ struct zloop_options {
 	bool			zone_append;
 	bool			ordered_zone_append;
 	bool			discard_write_cache;
+	enum zloop_stor_elements stor_elements;
 };
 
 /*
@@ -117,6 +132,8 @@ struct zloop_zone {
 	enum blk_zone_cond	cond;
 	sector_t		start;
 	sector_t		wp;
+	unsigned int		wr_se_id;
+	unsigned int		rd_se_id;
 
 	gfp_t			old_gfp_mask;
 };
@@ -133,6 +150,7 @@ struct zloop_device {
 	bool			zone_append;
 	bool			ordered_zone_append;
 	bool			discard_write_cache;
+	enum zloop_stor_elements stor_elements;
 
 	const char		*base_dir;
 	struct file		*data_dir;
@@ -150,6 +168,13 @@ struct zloop_device {
 	struct list_head	open_zones_lru_list;
 	unsigned int		nr_open_zones;
 
+	/* For storage elements emulation. */
+	struct mutex		stor_elements_lock;
+	unsigned int		nr_elements;
+	unsigned int		remove_element_id;
+	bool			restore_in_progress;
+	struct blk_se		*elements;
+
 	struct zloop_zone	zones[] __counted_by(nr_zones);
 };
 
@@ -289,22 +314,80 @@ static bool zloop_do_open_zone(struct zloop_device *zlo,
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
+}
+
+static enum blk_se_status zloop_zone_element_status(struct zloop_device *zlo,
+						    struct zloop_zone *zone,
+						    bool for_write)
+{
+	struct blk_se *se;
+
+	if (!zlo->nr_elements)
+		return BLK_SE_STS_OK;
+
+	if (for_write)
+		se = &zlo->elements[zone->wr_se_id - 1];
+	else
+		se = &zlo->elements[zone->rd_se_id - 1];
+
+	return READ_ONCE(se->status);
+}
+
+static enum blk_se_status zloop_zone_element_is_ok(struct zloop_device *zlo,
+						   struct zloop_zone *zone,
+						   bool for_write)
+{
+	enum blk_se_status sts =
+		zloop_zone_element_status(zlo, zone, for_write);
+
+	return sts < BLK_SE_STS_DEGRADED;
+}
+
+static bool zloop_zone_mgmt_is_ok(struct zloop_device *zlo,
+				  struct zloop_zone *zone)
+{
+	enum blk_se_status se_sts;
+	bool ret;
+
+	spin_lock(&zone->wp_lock);
+
+	/*
+	 * Since a zone management operation (open, close, reset or finish)
+	 * should not access the media, allow these operations even if the zone
+	 * element is degraded.
+	 */
+	se_sts = zloop_zone_element_status(zlo, zone, true);
+	ret = se_sts <= BLK_SE_STS_DEGRADED &&
+		zone->cond != BLK_ZONE_COND_OFFLINE &&
+		zone->cond != BLK_ZONE_COND_READONLY;
+
+	spin_unlock(&zone->wp_lock);
+
+	return ret;
 }
 
 static int zloop_update_seq_zone(struct zloop_device *zlo, unsigned int zone_no)
@@ -339,16 +422,26 @@ static int zloop_update_seq_zone(struct zloop_device *zlo, unsigned int zone_no)
 	}
 
 	spin_lock(&zone->wp_lock);
+
+	/* If the zone is readonly or offline, the write pointer is invalid. */
+	if (zone->cond == BLK_ZONE_COND_OFFLINE ||
+	    zone->cond == BLK_ZONE_COND_READONLY) {
+		zone->wp = ULLONG_MAX;
+		goto unlock;
+	}
+
 	if (!file_sectors) {
-		zloop_mark_empty(zlo, zone);
+		zloop_set_zone_empty(zlo, zone);
 	} else if (file_sectors == zlo->zone_capacity) {
-		zloop_mark_full(zlo, zone);
+		zloop_set_zone_full(zlo, zone);
 	} else {
 		if (zone->cond != BLK_ZONE_COND_IMP_OPEN &&
 		    zone->cond != BLK_ZONE_COND_EXP_OPEN)
 			zone->cond = BLK_ZONE_COND_CLOSED;
 		zone->wp = zone->start + file_sectors;
 	}
+
+unlock:
 	spin_unlock(&zone->wp_lock);
 
 	return 0;
@@ -364,6 +457,11 @@ static int zloop_open_zone(struct zloop_device *zlo, unsigned int zone_no)
 
 	mutex_lock(&zone->lock);
 
+	if (!zloop_zone_mgmt_is_ok(zlo, zone)) {
+		ret = -EIO;
+		goto unlock;
+	}
+
 	if (test_and_clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags)) {
 		ret = zloop_update_seq_zone(zlo, zone_no);
 		if (ret)
@@ -389,6 +487,11 @@ static int zloop_close_zone(struct zloop_device *zlo, unsigned int zone_no)
 
 	mutex_lock(&zone->lock);
 
+	if (!zloop_zone_mgmt_is_ok(zlo, zone)) {
+		ret = -EIO;
+		goto unlock;
+	}
+
 	if (test_and_clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags)) {
 		ret = zloop_update_seq_zone(zlo, zone_no);
 		if (ret)
@@ -421,7 +524,22 @@ static int zloop_close_zone(struct zloop_device *zlo, unsigned int zone_no)
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
@@ -431,20 +549,19 @@ static int zloop_reset_zone(struct zloop_device *zlo, unsigned int zone_no)
 
 	mutex_lock(&zone->lock);
 
+	if (!zloop_zone_mgmt_is_ok(zlo, zone)) {
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
@@ -458,7 +575,7 @@ static int zloop_reset_all_zones(struct zloop_device *zlo)
 	int ret;
 
 	for (i = zlo->nr_conv_zones; i < zlo->nr_zones; i++) {
-		ret = zloop_reset_zone(zlo, i);
+		ret = zloop_reset_zone(zlo, i, true);
 		if (ret)
 			return ret;
 	}
@@ -476,6 +593,11 @@ static int zloop_finish_zone(struct zloop_device *zlo, unsigned int zone_no)
 
 	mutex_lock(&zone->lock);
 
+	if (!zloop_zone_mgmt_is_ok(zlo, zone)) {
+		ret = -EIO;
+		goto unlock;
+	}
+
 	if (!test_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags) &&
 	    zone->cond == BLK_ZONE_COND_FULL)
 		goto unlock;
@@ -488,7 +610,7 @@ static int zloop_finish_zone(struct zloop_device *zlo, unsigned int zone_no)
 	}
 
 	spin_lock(&zone->wp_lock);
-	zloop_mark_full(zlo, zone);
+	zloop_set_zone_full(zlo, zone);
 	clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
 	spin_unlock(&zone->wp_lock);
 
@@ -632,7 +754,7 @@ static int zloop_seq_write_prep(struct zloop_cmd *cmd)
 	if (!is_append || !zlo->ordered_zone_append) {
 		zone->wp += nr_sectors;
 		if (zone->wp == zone_end)
-			zloop_mark_full(zlo, zone);
+			zloop_set_zone_full(zlo, zone);
 	}
 out_unlock:
 	spin_unlock(&zone->wp_lock);
@@ -774,7 +896,7 @@ static void zloop_handle_cmd(struct zloop_cmd *cmd)
 		cmd->ret = zloop_flush(zlo);
 		break;
 	case REQ_OP_ZONE_RESET:
-		cmd->ret = zloop_reset_zone(zlo, rq_zone_no(rq));
+		cmd->ret = zloop_reset_zone(zlo, rq_zone_no(rq), false);
 		break;
 	case REQ_OP_ZONE_RESET_ALL:
 		cmd->ret = zloop_reset_all_zones(zlo);
@@ -885,34 +1007,65 @@ static void zloop_complete_rq(struct request *rq)
 	blk_mq_end_request(rq, sts);
 }
 
-static blk_status_t zloop_set_zone_append_sector(struct request *rq)
+static blk_status_t zloop_set_zone_append_sector(struct zloop_device *zlo,
+						 struct zloop_zone *zone,
+						 struct request *rq)
 {
-	struct zloop_device *zlo = rq->q->queuedata;
-	unsigned int zone_no = rq_zone_no(rq);
-	struct zloop_zone *zone = &zlo->zones[zone_no];
 	sector_t zone_end = zone->start + zlo->zone_capacity;
 	sector_t nr_sectors = blk_rq_sectors(rq);
-	static blk_status_t ret = BLK_STS_OK;
-
-	spin_lock(&zone->wp_lock);
 
 	if (zone->cond == BLK_ZONE_COND_FULL ||
-	    zone->wp + nr_sectors > zone_end) {
-		ret = BLK_STS_IOERR;
-		goto unlock;
-	}
+	    zone->wp + nr_sectors > zone_end)
+		return BLK_STS_IOERR;
 
-	if (!zloop_do_open_zone(zlo, zone, false)) {
-		ret = BLK_STS_ZONE_OPEN_RESOURCE;
-		goto unlock;
-	}
+	if (!zloop_do_open_zone(zlo, zone, false))
+		return BLK_STS_ZONE_OPEN_RESOURCE;
 
 	rq->__sector = zone->wp;
 	zone->wp += blk_rq_sectors(rq);
 	if (zone->wp >= zone_end)
-		zloop_mark_full(zlo, zone);
+		zloop_set_zone_full(zlo, zone);
 
- unlock:
+	return BLK_STS_OK;
+}
+
+static bool zloop_prep_rq(struct zloop_device *zlo, struct request *rq)
+{
+	struct zloop_zone *zone = &zlo->zones[rq_zone_no(rq)];
+	bool is_write = op_is_write(req_op(rq));
+	blk_status_t ret = BLK_STS_OK;
+
+	if (!zlo->nr_elements &&
+	    (!zlo->ordered_zone_append || req_op(rq) != REQ_OP_ZONE_APPEND))
+		return BLK_STS_OK;
+
+	spin_lock(&zone->wp_lock);
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
+			ret = BLK_STS_IOERR;
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
+
+unlock:
 	spin_unlock(&zone->wp_lock);
 
 	return ret;
@@ -932,14 +1085,28 @@ static blk_status_t zloop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	}
 
 	/*
-	 * If we need to strongly order zone append operations, set the request
-	 * sector to the zone write pointer location now instead of when the
-	 * command work runs.
+	 * Do not allow commands while the restoration of storage elements is
+	 * in progress.
 	 */
-	if (zlo->ordered_zone_append && req_op(rq) == REQ_OP_ZONE_APPEND) {
-		ret = zloop_set_zone_append_sector(rq);
+	if (READ_ONCE(zlo->restore_in_progress))
+		return BLK_STS_IOERR;
+
+	/*
+	 * Check if we can accept data access commands and prepare zone append.
+	 * If storage element emulation is enabled, this will check if the data
+	 * access can be allowed based on the health state of the storage
+	 * element assigned to the zone being accessed.
+	 */
+	switch (req_op(rq)) {
+	case REQ_OP_READ:
+	case REQ_OP_WRITE:
+	case REQ_OP_ZONE_APPEND:
+		ret = zloop_prep_rq(zlo, rq);
 		if (ret != BLK_STS_OK)
 			return ret;
+		break;
+	default:
+		break;
 	}
 
 	blk_mq_start_request(rq);
@@ -1021,6 +1188,354 @@ static int zloop_report_zones(struct gendisk *disk, sector_t sector,
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
+	if (test_bit(GD_DEAD, &disk->state) ||
+	    data_race(READ_ONCE(zlo->state)) == Zlo_deleting)
+		return -ENODEV;
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
+		case BLK_SE_STS_RESTORE_ERROR:
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
+static int zloop_execute_remove_element(struct zloop_device *zlo)
+{
+	struct gendisk *disk = zlo->disk;
+	struct blk_se *se, *paired_se = NULL;
+	enum blk_zone_cond cond;
+	struct zloop_zone *zone;
+	unsigned int memflags, i;
+	int ret = 0;
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
+		return -EINVAL;
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
+		clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
+		spin_unlock(&zone->wp_lock);
+		mutex_unlock(&zone->lock);
+	}
+
+	WRITE_ONCE(se->status, BLK_SE_STS_REMOVED);
+	if (paired_se && READ_ONCE(paired_se->status) != BLK_SE_STS_REMOVED)
+		WRITE_ONCE(paired_se->status, BLK_SE_STS_REMOVED);
+
+	return ret;
+}
+
+static int zloop_remove_element(struct gendisk *disk, unsigned int element_id)
+{
+	struct zloop_device *zlo = disk->private_data;
+	struct blk_se *se, *rse, *rpse = NULL;
+	unsigned int i, nr_se_remaining = 0;
+	int ret = 0;
+
+	if (test_bit(GD_DEAD, &disk->state) ||
+	    data_race(READ_ONCE(zlo->state)) == Zlo_deleting)
+		return -ENODEV;
+
+	if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_NONE)
+		return -EOPNOTSUPP;
+
+	if (!element_id || element_id > zlo->nr_elements)
+		return -EINVAL;
+
+	mutex_lock(&zlo->stor_elements_lock);
+
+	/* If a remove or restore operation is already in progress, bail out. */
+	if (zlo->remove_element_id || READ_ONCE(zlo->restore_in_progress)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	/*
+	 * Get the element to remove. If it is a read element, the associated
+	 * write element must also be removed.
+	 */
+	rse = &zlo->elements[element_id - 1];
+	if (rse->type == BLK_SE_TYPE_READ)
+		rpse = &zlo->elements[rse->paired_id - 1];
+
+	/* If the element is already removed, we have nothing to do. */
+	if (READ_ONCE(rse->status) == BLK_SE_STS_REMOVED)
+		goto unlock;
+
+	/*
+	 * Make sure we do not allow removing all storage elements as that does
+	 * not make any sense. This is consistent with the device advertized
+	 * limit of SCSI and ATA devices supporting the storage element
+	 * depopulation feature.
+	 */
+	for (i = 0, se = zlo->elements; i < zlo->nr_elements; i++, se++) {
+		if (se == rse || se == rpse)
+			continue;
+		if (READ_ONCE(se->status) <= BLK_SE_STS_DEGRADED)
+			nr_se_remaining++;
+	}
+	if (!nr_se_remaining) {
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	/*
+	 * Change the elements to be removed to the remove in progress state so
+	 * that concurrent report elements can see the operation on-going.
+	 */
+	WRITE_ONCE(rse->status, BLK_SE_STS_REMOVE_IN_PROGRESS);
+	if (rpse && READ_ONCE(rpse->status) != BLK_SE_STS_REMOVED)
+		WRITE_ONCE(rpse->status, BLK_SE_STS_REMOVE_IN_PROGRESS);
+	zlo->remove_element_id = element_id;
+
+	mutex_unlock(&zlo->stor_elements_lock);
+
+	/*
+	 * Wait a little so that this looks like a real device taking time to
+	 * operate.
+	 */
+	msleep(2000);
+
+	mutex_lock(&zlo->stor_elements_lock);
+
+	/*
+	 * Re-check the device as its removal may have been initiated
+	 * while we were sleeping.
+	 */
+	if (test_bit(GD_DEAD, &disk->state) ||
+	    data_race(READ_ONCE(zlo->state)) == Zlo_deleting) {
+		ret = -ENODEV;
+		goto clear_id;
+	}
+
+	/* Remove the element(s). */
+	ret = zloop_execute_remove_element(zlo);
+
+clear_id:
+	zlo->remove_element_id = 0;
+
+unlock:
+	mutex_unlock(&zlo->stor_elements_lock);
+
+	return ret;
+}
+
+static int zloop_restore_zone_file(struct zloop_device *zlo,
+				   struct zloop_zone *zone)
+{
+	int ret = 0;
+
+	if (!test_bit(ZLOOP_ZONE_CONV, &zone->flags))
+		return 0;
+
+	mutex_lock(&zone->lock);
+
+	ret = vfs_truncate(&zone->file->f_path, 0);
+	if (ret)
+		set_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
+
+	return ret;
+}
+
+static void zloop_restore_zone_cond(struct zloop_device *zlo,
+				    struct zloop_zone *zone)
+{
+	mutex_lock(&zone->lock);
+	spin_lock(&zone->wp_lock);
+
+	if (test_bit(ZLOOP_ZONE_CONV, &zone->flags)) {
+		zloop_set_zone_cond(zlo, zone, BLK_ZONE_COND_NOT_WP);
+	} else {
+		zloop_set_zone_empty(zlo, zone);
+		clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
+	}
+
+	spin_unlock(&zone->wp_lock);
+	mutex_unlock(&zone->lock);
+}
+
+static int zloop_execute_restore_elements(struct zloop_device *zlo)
+{
+	struct gendisk *disk = zlo->disk;
+	struct zloop_zone *zone;
+	struct blk_se *se;
+	enum blk_se_status sts;
+	unsigned int memflags, i;
+	int ret = 0;
+
+	/* Wait for all IOs to complete. */
+	memflags = blk_mq_freeze_queue(disk->queue);
+	blk_mq_unfreeze_queue(disk->queue, memflags);
+
+	/* First, truncate all files for sequential zones. */
+	for (i = 0, zone = zlo->zones; i < zlo->nr_zones; i++, zone++) {
+		ret = zloop_restore_zone_file(zlo, zone);
+		if (ret) {
+			pr_err("zloop%d: restore zone %u file failed %d\n",
+			       zlo->id, i, ret);
+			break;
+		}
+	}
+
+	/*
+	 * Now, resetore the condition of all zones, unless we failed to
+	 * truncate all files, in which case we report a restoration error
+	 * without changing the zone conditions.
+	 */
+	if (!ret) {
+		for (i = 0, zone = zlo->zones; i < zlo->nr_zones; i++, zone++)
+			zloop_restore_zone_cond(zlo, zone);
+		sts = BLK_SE_STS_OK;
+	} else {
+		sts = BLK_SE_STS_RESTORE_ERROR;
+	}
+
+	/*
+	 * Update the status of all elements being restored based on the zone
+	 * restoration result.
+	 */
+	for (i = 0, se = zlo->elements; i < zlo->nr_elements; i++, se++) {
+		if (READ_ONCE(se->status) == BLK_SE_STS_RESTORE_IN_PROGRESS)
+			WRITE_ONCE(se->status, sts);
+	}
+
+	return ret;
+}
+
+static int zloop_restore_elements(struct gendisk *disk)
+{
+	struct zloop_device *zlo = disk->private_data;
+	struct blk_se *se;
+	unsigned int i, n = 0;
+	int ret = 0;
+
+	if (test_bit(GD_DEAD, &disk->state) ||
+	    data_race(READ_ONCE(zlo->state)) == Zlo_deleting)
+		return -ENODEV;
+
+	if (zlo->stor_elements == ZLOOP_STOR_ELEMENTS_NONE)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&zlo->stor_elements_lock);
+
+	/* If a remove or restore operation is already in progress, bail out. */
+	if (zlo->remove_element_id || READ_ONCE(zlo->restore_in_progress)) {
+		ret = -EBUSY;
+		goto unlock;
+	}
+
+	/*
+	 * Set the restore in progress state for elements that will be
+	 * restored.
+	 */
+	for (i = 0, se = zlo->elements; i < zlo->nr_elements; i++, se++) {
+		switch (READ_ONCE(se->status)) {
+		case BLK_SE_STS_REMOVED:
+		case BLK_SE_STS_RESTORE_ERROR:
+			WRITE_ONCE(se->status, BLK_SE_STS_RESTORE_IN_PROGRESS);
+			n++;
+			break;
+		default:
+			break;
+		}
+	}
+
+	/* If we have no removed or in error elements, we have nothing to do. */
+	if (!n)
+		goto unlock;
+
+	WRITE_ONCE(zlo->restore_in_progress, true);
+	mutex_unlock(&zlo->stor_elements_lock);
+
+	/*
+	 * Wait a little so that this looks like a real device taking time to
+	 * operate.
+	 */
+	msleep(5000);
+
+	mutex_lock(&zlo->stor_elements_lock);
+
+	/*
+	 * Re-check the device as its removal may have been initiated
+	 * while we were sleeping.
+	 */
+	if (test_bit(GD_DEAD, &disk->state) ||
+	    data_race(READ_ONCE(zlo->state)) == Zlo_deleting) {
+		ret = -ENODEV;
+		goto clear_restore;
+	}
+
+	/* Restore the elements. */
+	ret = zloop_execute_restore_elements(zlo);
+
+clear_restore:
+	WRITE_ONCE(zlo->restore_in_progress, false);
+unlock:
+	mutex_unlock(&zlo->stor_elements_lock);
+
+	return ret;
+}
+
 static void zloop_free_disk(struct gendisk *disk)
 {
 	struct zloop_device *zlo = disk->private_data;
@@ -1038,15 +1553,23 @@ static void zloop_free_disk(struct gendisk *disk)
 
 	fput(zlo->data_dir);
 	destroy_workqueue(zlo->workqueue);
+	kfree(zlo->elements);
 	kfree(zlo->base_dir);
 	kvfree(zlo);
 }
 
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
@@ -1123,6 +1646,25 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 	spin_lock_init(&zone->wp_lock);
 	zone->start = (sector_t)zone_no << zlo->zone_shift;
 
+	/* If we are emulating storage elements, assign one to the zone. */
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
 	if (!restore)
 		oflags |= O_CREAT;
 
@@ -1198,6 +1740,74 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
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
+	 * To achieve a somewhat realistic emulation, we want at least
+	 * ZLOOP_MIN_STOR_ELEMENTS storage elements, and no more than
+	 * ZLOOP_MAX_STOR_ELEMENTS, with a number of zones per storage element
+	 * that is at least ZLOOP_MIN_ZONES_PER_STOR_ELEMENTS. This means that
+	 * we need at least ZLOOP_MIN_STOR_ELEMENTS zones.
+	 */
+	if (zlo->nr_zones < ZLOOP_MIN_STOR_ELEMENTS)
+		return -EINVAL;
+
+	if (zlo->nr_zones <= ZLOOP_MAX_STOR_ELEMENTS * 2)
+		nr_elements = ZLOOP_MIN_STOR_ELEMENTS;
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
+	zlo->nr_elements = nr_elems;
+
+	return 0;
+}
+
 static bool zloop_dev_exists(struct zloop_device *zlo)
 {
 	struct file *cnv, *seq;
@@ -1253,6 +1863,7 @@ static int zloop_ctl_add(struct zloop_options *opts)
 	WRITE_ONCE(zlo->state, Zlo_creating);
 	spin_lock_init(&zlo->open_zones_lock);
 	INIT_LIST_HEAD(&zlo->open_zones_lru_list);
+	mutex_init(&zlo->stor_elements_lock);
 
 	ret = mutex_lock_killable(&zloop_ctl_mutex);
 	if (ret)
@@ -1286,12 +1897,19 @@ static int zloop_ctl_add(struct zloop_options *opts)
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
@@ -1377,6 +1995,10 @@ static int zloop_ctl_add(struct zloop_options *opts)
 		zlo->id, zlo->nr_zones,
 		((sector_t)zlo->zone_size << SECTOR_SHIFT) >> 20,
 		zlo->block_size);
+	if (zlo->nr_elements)
+		pr_info("zloop%d: %u storage elements\n",
+			zlo->id, zlo->nr_elements);
+
 	pr_info("zloop%d: using %s%s zone append\n",
 		zlo->id,
 		zlo->ordered_zone_append ? "ordered " : "",
@@ -1400,6 +2022,8 @@ static int zloop_ctl_add(struct zloop_options *opts)
 	kfree(zlo->base_dir);
 out_destroy_workqueue:
 	destroy_workqueue(zlo->workqueue);
+out_destroy_storage_elements:
+	kfree(zlo->elements);
 out_free_idr:
 	mutex_lock(&zloop_ctl_mutex);
 	idr_remove(&zloop_index_idr, zlo->id);
@@ -1518,6 +2142,7 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
 	opts->buffered_io = ZLOOP_DEF_BUFFERED_IO;
 	opts->zone_append = ZLOOP_DEF_ZONE_APPEND;
 	opts->ordered_zone_append = ZLOOP_DEF_ORDERED_ZONE_APPEND;
+	opts->stor_elements = ZLOOP_DEF_STOR_ELEMENTS;
 
 	if (!buf)
 		return 0;
@@ -1652,6 +2277,23 @@ static int zloop_parse_options(struct zloop_options *opts, const char *buf)
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
2.56.0

