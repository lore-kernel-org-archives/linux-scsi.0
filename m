Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C13C4349A7;
	Wed,  7 Oct 2026 08:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791361429; cv=none; b=Bqu9bW6mYsedCVKxICrh6hYVOAyar7l6/Pz/i0Lctzswc3wMCm3IjrfVg3tKSsZSU7GkeLGoGM4wZyJEVJogRDsAQ//IYu94O1aNa3twrrnNU3Pzn6YrMj6QmYGU639zRg+0nNXRMP0v8qZBSz2AsKwtr1PmetNzUtNS+5eT9+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791361429; c=relaxed/simple;
	bh=koOoHfQDZcEIx4WvekhR9X8Q0eh66NYUeTC8a72hSSY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLpqJOGuMAWrogMSxSOHhFAqi9oDXUJW4KkEsb7P+8d2vPBoU7Wn65HpJolcYsE0T4pL7KlTTOmhPOfbFdl20oQgc3B3x70+mIXeI7wzvpWYyby+5GYIsY9HxbAqJbQpU94m3Drwn6MbCFLAWH9PErl/sb6xcEsjLYv4fCkeriM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=imHjVdaH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="imHjVdaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FA71F0089C;
	Wed,  7 Oct 2026 08:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791361428;
	bh=yHDROnBjd1ynNnW7MzmMCKXs4l5uSHYT9QWtZJ0TEzc=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=imHjVdaHqjgpq4HnRpRP4dvGG2bNzxCW/bt1NLHytDMN9puZ9KlSH94/LXYIZFXK+
	 +DdCHd06C+Hc4zQHOLT+Yw6TxCMq3TXalkaOXNyvHrw7hYjMeT4XwJRqx4Oy1KWwyG
	 PIW6Tkki0jnjC2kiWEE2hwVdOjYq+tGACEynOoZ/aWQ4qy/+/fhiivvwBbawDt1IVF
	 M4aQiUfxAmgaX1ALrnQwMbk+Dx247NOfJde2bAqlss7KBKMg48zWhbIiUjAC/dgngD
	 zn59qlCCsQKynUQyC4tKdvoOlziyPQM1hj7nSIxBBvI70Fd0qAJnLdBNjxrAAJn2G7
	 a6ai0Btg7rcmg==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 1/7] block: fail reads to offline zones early
Date: Wed,  7 Oct 2026 17:23:38 +0900
Message-ID: <20261007082344.1049179-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261007082344.1049179-1-dlemoal@kernel.org>
References: <20261007082344.1049179-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Any BIO targeting an offline zone of a zoned block device will fail,
including read commands. So there is no point in issuing read BIOs.
Fail these read operations early if we ever see one.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-core.c  |  3 +++
 block/blk-zoned.c | 18 ++++++++++++++++++
 block/blk.h       |  6 ++++++
 3 files changed, 27 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 13dc70e8f55d..d420c80d2d93 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -866,6 +866,9 @@ void submit_bio_noacct(struct bio *bio)
 
 	switch (bio_op(bio)) {
 	case REQ_OP_READ:
+		if (bdev_is_zoned(bdev) &&
+		    bdev_zone_is_offline(bdev, bio->bi_iter.bi_sector))
+			goto end_io;
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

