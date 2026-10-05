Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC197469840;
	Mon,  5 Oct 2026 09:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193604; cv=none; b=uTrLuqevygKHlpr8rK5RuZ7wCiOWFbBzrj02/lWnVPnoBZS4JkykJRiCN+uXiTFmQ97JC5Zx6P/pV+hG3p/5vfZBqzU/hqt6Bmumfcl+iXHVjYAANSjgEbCn9NBt/ntqcA8cSo6QnY6kXdhjpo6lfa0+SbZe2hnr9ktSIV9ax0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193604; c=relaxed/simple;
	bh=z0OhpNHVFwYgQK56W4Osd/XU0s4pHDJUNi6cVIhnH7s=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MCycW6GbJpvRkjD7HulBI/9O/ZqLpohDWtNboqD+cekoLcFUT07Z4SgbwvcFhVq3zI5zVfVZNE4WAV46fXOX4SX+8Obt8bLxndvXTwY89qaDGZ9KzCnZBxv+rFZO91RUaJEEvpVKOz39wLSNu7zhHheinG5/Mi3sdirK9qTaPZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f5v/+bgn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f5v/+bgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07CFB1F00898;
	Mon,  5 Oct 2026 09:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791193595;
	bh=5jyYbWugP6Rir/T5BTyqxuJUOo6Psr9Te95OL0JPxx4=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=f5v/+bgnWS2kfow3blbk5J7Y8/1JrHqadiXieKdvkRn2pjF3x9a7O092YN7eh154y
	 XK/dOpIpjn5WHHZ0D4yELy2IAt1x/EkBFCCXTXIkLghx+lZA0Y6hDyHMBQYRW2idto
	 YRSdBVda7P1+K8enKOGkbyPz6b3AD8m55s1v3f0ZrFpj0sF68Dkye+QrQpLzXOhZjY
	 s816+GW8Go7pX9He/X1OpQ71gMtIzAcwa2hg7Q4ySnGEF+4RdUP2SR/UCl/jj6mv+p
	 LGKRC/hyjPGBv+hQ1AJsPM0KowpfmNwCmaqymSSDS3i1xmYDIyCmjb+o0wrXId6noL
	 gc6N/BsK+G6lA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1/7] block: fail reads to offline zones early
Date: Mon,  5 Oct 2026 18:46:26 +0900
Message-ID: <20261005094632.580753-2-dlemoal@kernel.org>
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

Any BIO targeting an offline zone of a zoned block device will fail,
including read commands. So there is no point in issuing read BIOs.
Fail these early if we ever see one, and be quiet about the error.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-core.c  |  5 +++++
 block/blk-zoned.c | 18 ++++++++++++++++++
 block/blk.h       |  6 ++++++
 3 files changed, 29 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 13dc70e8f55d..f098a31d19aa 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -866,6 +866,11 @@ void submit_bio_noacct(struct bio *bio)
 
 	switch (bio_op(bio)) {
 	case REQ_OP_READ:
+		if (bdev_is_zoned(bdev) &&
+		    bdev_zone_is_offline(bdev, bio->bi_iter.bi_sector)) {
+			bio_set_flag(bio, BIO_QUIET);
+			goto end_io;
+		}
 		break;
 	case REQ_OP_WRITE:
 		if (bio->bi_opf & REQ_ATOMIC) {
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 19268afb8752..131c9f50b3da 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -308,6 +308,24 @@ bool bdev_zone_is_seq(struct block_device *bdev, sector_t sector)
 }
 EXPORT_SYMBOL_GPL(bdev_zone_is_seq);
 
+/**
+ * bdev_zone_is_offline - check if a sector belongs to an offline zone
+ * @bdev:       block device to check
+ * @sector:     sector number
+ *
+ * Check if @sector on @bdev is contained in an offline zone.
+ */
+bool bdev_zone_is_offline(struct block_device *bdev, sector_t sector)
+{
+	enum blk_zone_cond cond;
+
+	if (!bdev_is_zoned(bdev))
+		return false;
+
+	cond = disk_zone_get_cond(bdev->bd_disk, sector);
+	return cond == BLK_ZONE_COND_OFFLINE;
+}
+
 /**
  * bdev_zone_mgmt_allowed - check if management operations are allowed on a zone
  * @bdev:       block device to check
diff --git a/block/blk.h b/block/blk.h
index 2cc03aa54c53..c2d07347a3ad 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -578,6 +578,7 @@ int blkdev_report_zones_ioctl(struct block_device *bdev, unsigned int cmd,
 int blkdev_zone_mgmt_ioctl(struct block_device *bdev, blk_mode_t mode,
 		unsigned int cmd, unsigned long arg);
 bool bdev_zone_mgmt_allowed(struct block_device *bdev, sector_t sector);
+bool bdev_zone_is_offline(struct block_device *bdev, sector_t sector);
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline void disk_init_zone_resources(struct gendisk *disk)
 {
@@ -625,6 +626,11 @@ static inline bool bdev_zone_mgmt_allowed(struct block_device *bdev,
 {
 	return false;
 }
+static inline bool bdev_zone_is_offline(struct block_device *bdev,
+					sector_t sector)
+{
+	return false;
+}
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 struct block_device *bdev_alloc(struct gendisk *disk, u8 partno);
-- 
2.55.0

