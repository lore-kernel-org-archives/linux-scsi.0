Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A695740D588;
	Wed, 14 Oct 2026 05:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791956027; cv=none; b=PBX3hVaPmmwY/3vHskakF8ehwuzA+/l0ljcO0is7bjAUrJKn7NO+/kICsf5JvXX+8sbUksXVYfziXWLig9f2sznRdJUEw7hFlGPoVTTH8HYv1ujX97NxXd6npTZiuR6iYHvuo6Hipvhq4sw8M3YZTTedGEK1TY8ByQ+k3RH5Rz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791956027; c=relaxed/simple;
	bh=5Qc5eHITfTAHfgVz55ZLAmYwvzJ2HputaZEl4nz/eX4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTM1UlAqe1QAZjrGhcKYFu1n7YIf/STi2R5Yo/3+E6nSkJWars+9NCaoByzCngv4aY6LDyAapEJXOU8JRbXM7QhfDClcJmgicPwLWh4/SD3t+pJvVsMNux9TV7q19vyH0RLW3142Kl4OK7bhbFH8oRDR/0FoIcDegcqKftzo5lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PzmCuQnS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PzmCuQnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2CA1F00893;
	Wed, 14 Oct 2026 05:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791956024;
	bh=8C7mVuXnGFetQs9+oR8QExNP+Wm7eWEtKe7vhER5TTU=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=PzmCuQnSRgfix4NLrV18mfc9FQAVyeHjMdRyPK/OGqe9jRlXsqnlxDjJAmLnfBVkG
	 1pSURWwP4kn8+EI3yQAO0qfEpz8fbYyT2wXe3y9r79A0DUZUmXPYxif1wCC9gSp106
	 ku8QzxcSwBtFA7aSs0cN6kky5IsSz6TsFZDgUo+sH9bzFqXznWC55K1qQXIdb0Vjqg
	 1mpHK+T0eDjGNi9QOV3ESdETykuR8fWw7GFVCl8IN2dtUgWPKGfBZXZ6BY+uSQMSO1
	 /cbSDSk93zevkDmKIPhnjiDay9EcAq9FiKXNpJRLbRRtMZOXB9S2i0G3IVwpc4YFw+
	 DAtkr1l8bHaUQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v7 05/10] zloop: avoid potential wp_lock deadlocks
Date: Wed, 14 Oct 2026 14:33:31 +0900
Message-ID: <20261014053337.2328544-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261014053337.2328544-1-dlemoal@kernel.org>
References: <20261014053337.2328544-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

zloop_queue_rq() maybe called from softirq context with interrupts
disabled. However, zloop_queue_rq() may call
zloop_set_zone_append_sector() which takes a zone wp_lock using a simple
spin_lock(). This can cause deadlocks with competing contexts that have
already taken that lock. Avoid this by using the irq disabling/enabling
variants of spin_lock/unlock. While at it, zloop_report_zones() is also
modified to take the wp_lock around both the write pointer and the zone
condition reporting to ensure that both values are consistent for a
report.

Fixes: fcc6eaa3a03a ("zloop: introduce the ordered_zone_append configuration parameter")
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <mkp@kernel.org>
---
 drivers/block/zloop.c | 37 ++++++++++++++++++++++---------------
 1 file changed, 22 insertions(+), 15 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 8f485ef51557..cbe199c135b0 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -312,6 +312,7 @@ static int zloop_update_seq_zone(struct zloop_device *zlo, unsigned int zone_no)
 	struct zloop_zone *zone = &zlo->zones[zone_no];
 	struct kstat stat;
 	sector_t file_sectors;
+	unsigned long flags;
 	int ret;
 
 	lockdep_assert_held(&zone->lock);
@@ -337,7 +338,7 @@ static int zloop_update_seq_zone(struct zloop_device *zlo, unsigned int zone_no)
 		return -EINVAL;
 	}
 
-	spin_lock(&zone->wp_lock);
+	spin_lock_irqsave(&zone->wp_lock, flags);
 	if (!file_sectors) {
 		zloop_mark_empty(zlo, zone);
 	} else if (file_sectors == zlo->zone_capacity) {
@@ -348,7 +349,7 @@ static int zloop_update_seq_zone(struct zloop_device *zlo, unsigned int zone_no)
 			zone->cond = BLK_ZONE_COND_CLOSED;
 		zone->wp = zone->start + file_sectors;
 	}
-	spin_unlock(&zone->wp_lock);
+	spin_unlock_irqrestore(&zone->wp_lock, flags);
 
 	return 0;
 }
@@ -381,6 +382,7 @@ static int zloop_open_zone(struct zloop_device *zlo, unsigned int zone_no)
 static int zloop_close_zone(struct zloop_device *zlo, unsigned int zone_no)
 {
 	struct zloop_zone *zone = &zlo->zones[zone_no];
+	unsigned long flags;
 	int ret = 0;
 
 	if (test_bit(ZLOOP_ZONE_CONV, &zone->flags))
@@ -399,13 +401,13 @@ static int zloop_close_zone(struct zloop_device *zlo, unsigned int zone_no)
 		break;
 	case BLK_ZONE_COND_IMP_OPEN:
 	case BLK_ZONE_COND_EXP_OPEN:
-		spin_lock(&zone->wp_lock);
+		spin_lock_irqsave(&zone->wp_lock, flags);
 		zloop_lru_remove_open_zone(zlo, zone);
 		if (zone->wp == zone->start)
 			zone->cond = BLK_ZONE_COND_EMPTY;
 		else
 			zone->cond = BLK_ZONE_COND_CLOSED;
-		spin_unlock(&zone->wp_lock);
+		spin_unlock_irqrestore(&zone->wp_lock, flags);
 		break;
 	case BLK_ZONE_COND_EMPTY:
 	case BLK_ZONE_COND_FULL:
@@ -423,6 +425,7 @@ static int zloop_close_zone(struct zloop_device *zlo, unsigned int zone_no)
 static int zloop_reset_zone(struct zloop_device *zlo, unsigned int zone_no)
 {
 	struct zloop_zone *zone = &zlo->zones[zone_no];
+	unsigned long flags;
 	int ret = 0;
 
 	if (test_bit(ZLOOP_ZONE_CONV, &zone->flags))
@@ -440,10 +443,10 @@ static int zloop_reset_zone(struct zloop_device *zlo, unsigned int zone_no)
 		goto unlock;
 	}
 
-	spin_lock(&zone->wp_lock);
+	spin_lock_irqsave(&zone->wp_lock, flags);
 	zloop_mark_empty(zlo, zone);
 	clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
-	spin_unlock(&zone->wp_lock);
+	spin_unlock_irqrestore(&zone->wp_lock, flags);
 
 unlock:
 	mutex_unlock(&zone->lock);
@@ -468,6 +471,7 @@ static int zloop_reset_all_zones(struct zloop_device *zlo)
 static int zloop_finish_zone(struct zloop_device *zlo, unsigned int zone_no)
 {
 	struct zloop_zone *zone = &zlo->zones[zone_no];
+	unsigned long flags;
 	int ret = 0;
 
 	if (test_bit(ZLOOP_ZONE_CONV, &zone->flags))
@@ -486,10 +490,10 @@ static int zloop_finish_zone(struct zloop_device *zlo, unsigned int zone_no)
 		goto unlock;
 	}
 
-	spin_lock(&zone->wp_lock);
+	spin_lock_irqsave(&zone->wp_lock, flags);
 	zloop_mark_full(zlo, zone);
 	clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
-	spin_unlock(&zone->wp_lock);
+	spin_unlock_irqrestore(&zone->wp_lock, flags);
 
  unlock:
 	mutex_unlock(&zone->lock);
@@ -579,9 +583,10 @@ static int zloop_seq_write_prep(struct zloop_cmd *cmd)
 	bool is_append = req_op(rq) == REQ_OP_ZONE_APPEND;
 	struct zloop_zone *zone = &zlo->zones[zone_no];
 	sector_t zone_end = zone->start + zlo->zone_capacity;
+	unsigned long flags;
 	int ret = 0;
 
-	spin_lock(&zone->wp_lock);
+	spin_lock_irqsave(&zone->wp_lock, flags);
 
 	/*
 	 * Zone append operations always go at the current write pointer, but
@@ -632,7 +637,7 @@ static int zloop_seq_write_prep(struct zloop_cmd *cmd)
 			zloop_mark_full(zlo, zone);
 	}
 out_unlock:
-	spin_unlock(&zone->wp_lock);
+	spin_unlock_irqrestore(&zone->wp_lock, flags);
 	return ret;
 }
 
@@ -887,12 +892,13 @@ static bool zloop_set_zone_append_sector(struct request *rq)
 	struct zloop_zone *zone = &zlo->zones[zone_no];
 	sector_t zone_end = zone->start + zlo->zone_capacity;
 	sector_t nr_sectors = blk_rq_sectors(rq);
+	unsigned long flags;
 
-	spin_lock(&zone->wp_lock);
+	spin_lock_irqsave(&zone->wp_lock, flags);
 
 	if (zone->cond == BLK_ZONE_COND_FULL ||
 	    zone->wp + nr_sectors > zone_end) {
-		spin_unlock(&zone->wp_lock);
+		spin_unlock_irqrestore(&zone->wp_lock, flags);
 		return false;
 	}
 
@@ -901,7 +907,7 @@ static bool zloop_set_zone_append_sector(struct request *rq)
 	if (zone->wp >= zone_end)
 		zloop_mark_full(zlo, zone);
 
-	spin_unlock(&zone->wp_lock);
+	spin_unlock_irqrestore(&zone->wp_lock, flags);
 
 	return true;
 }
@@ -962,6 +968,7 @@ static int zloop_report_zones(struct gendisk *disk, sector_t sector,
 	struct zloop_device *zlo = disk->private_data;
 	struct blk_zone blkz = {};
 	unsigned int first, i;
+	unsigned long flags;
 	int ret;
 
 	first = disk_zone_no(disk, sector);
@@ -985,10 +992,10 @@ static int zloop_report_zones(struct gendisk *disk, sector_t sector,
 
 		blkz.start = zone->start;
 		blkz.len = zlo->zone_size;
-		spin_lock(&zone->wp_lock);
+		spin_lock_irqsave(&zone->wp_lock, flags);
 		blkz.wp = zone->wp;
-		spin_unlock(&zone->wp_lock);
 		blkz.cond = zone->cond;
+		spin_unlock_irqrestore(&zone->wp_lock, flags);
 		if (test_bit(ZLOOP_ZONE_CONV, &zone->flags)) {
 			blkz.type = BLK_ZONE_TYPE_CONVENTIONAL;
 			blkz.capacity = zlo->zone_size;
-- 
2.55.0

