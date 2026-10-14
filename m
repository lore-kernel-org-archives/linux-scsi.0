Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCED4409136;
	Wed, 14 Oct 2026 05:33:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791956021; cv=none; b=V/czVUMYdk7bfb0dthpMCvVWdYUj2OkmkyJjf7CLQ5wpjnnkcYDz36oN/MH5a0k1/FeVHZYNYqyJdU/sw8hQru4PRZ2e8I7YSufaRl6coUEH44vDsbPXAfZzKWQp08WvfFzXmA9nx2QAmTc1ru25uzaca6uys1Kzp014SP3x760=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791956021; c=relaxed/simple;
	bh=jORCVLi0hDDzT9+SP/fiG3sZMVy8tRvNX65z0ZSJOhU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Suv9U2DVW+5eqtp1F2RH6owvAUcjMm0nMnbSD8dJm03SCy3mGdTpREnjmO36iIhFm2awpAi9pRuGz9E/DADWbr484UGLlRAlkbzRrV7kYk0mNZdRVmAYHPH+2wj1kEFZ4B7e3HzbHWGkbpSDVlvi3P3fld06VE+DhhhHzjvGGfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P0V10Pu7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P0V10Pu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC5A1F00893;
	Wed, 14 Oct 2026 05:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791956020;
	bh=UlsMWZILcT9BYF1dUPNe1452r5KkpRdbzztd4d7LALs=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=P0V10Pu7owCNnCSO6pdd0NpBKbaG4QsCdIxmnMOxU6brDqdowAt6yqFYCo+Q7iEoO
	 kzHeyuhPWnZrln8D6RktzpscCCZnwn4j6VRLgJER/6F1EWoN3KUChcJ9TlwLOVrD9V
	 u95e7jNAUZpdhGrGi6/HWhEdNVkt5l5VjyKECHugdHFCXrGOp65FD9fqcllU523Cbr
	 6Dz/hfsWq2vxmgobz4lyYcJh2caJgGAO99djuGXUHURTHuPriM3FHLUQYkx91DuX0R
	 1jcAhCtXzW2S4dL2v4+CeF97oWWkthyC+Lo4E14IssEXzvPZaTSLtM/B5+i4Ipa1ks
	 qR+4mAjlgRboQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v7 01/10] block: introduce disk_zone_is_offline()
Date: Wed, 14 Oct 2026 14:33:27 +0900
Message-ID: <20261014053337.2328544-2-dlemoal@kernel.org>
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

Introduce the helper function disk_zone_is_offline() for testing if a zone
of a gendisk has the offline condition. The zone to test is identified
using a sector number that must belong to the target zone to check.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <mkp@kernel.org>
---
 block/blk-zoned.c      | 16 ++++++++++++++++
 include/linux/blkdev.h |  9 +++++++++
 2 files changed, 25 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index d8688a3d8314..0d4b18290412 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -292,6 +292,22 @@ static bool disk_zone_is_seq(struct gendisk *disk, sector_t sector)
 	return !blk_zstate_is_conv(zs);
 }
 
+/**
+ * disk_zone_is_offline - check if a sector belongs to an offline zone
+ * @disk:	gendisk to check
+ * @sector:	sector number
+ *
+ * Check if @sector on @disk is contained in an offline zone.
+ */
+bool disk_zone_is_offline(struct gendisk *disk, sector_t sector)
+{
+	if (!blk_queue_is_zoned(disk->queue))
+		return false;
+
+	return disk_zone_get_cond(disk, sector) == BLK_ZONE_COND_OFFLINE;
+}
+EXPORT_SYMBOL_GPL(disk_zone_is_offline);
+
 /**
  * bdev_zone_is_seq - check if a sector belongs to a sequential write zone
  * @bdev:       block device to check
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2d5c30823aab..f7f79bfd907a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -942,6 +942,9 @@ static inline unsigned int disk_zone_capacity(struct gendisk *disk,
 		return disk->last_zone_capacity;
 	return disk->zone_capacity;
 }
+
+bool disk_zone_is_offline(struct gendisk *disk, sector_t sector);
+
 static inline unsigned int bdev_zone_capacity(struct block_device *bdev,
 					      sector_t pos)
 {
@@ -956,6 +959,12 @@ static inline unsigned int disk_nr_zones(struct gendisk *disk)
 	return 0;
 }
 
+static inline bool disk_zone_is_offline(struct gendisk *disk,
+					sector_t sector)
+{
+	return false;
+}
+
 static inline bool bdev_zone_is_seq(struct block_device *bdev, sector_t sector)
 {
 	return false;
-- 
2.55.0

