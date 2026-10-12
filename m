Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96A333164AA;
	Mon, 12 Oct 2026 13:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810086; cv=none; b=ADET4kkzQYz3wfTQX81UWR6yCVrd5M0wV+5HqCUNA6PPQQbnxWc9IC8A854taywFlLfFvBaQmbw+4GaN08KW3ZzhuRnnMxyB6zDJpmSdHf5VpRXPWyKHNS1jIq+3NYgBE5mLGDcnp/gL7Wu9c8fk3e3Wnhicw86YyMYPjdhMJfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810086; c=relaxed/simple;
	bh=txf8a77zGiMRKoij4Oxf3M9l+oljk/XOeTpIk4wPXwI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XBVAlDZuYNQytUQpX7wYePTKCH3mJxxtqkpdPghU9RsVmxUhPJ45hnAUP3Fa6lACai1FkqDtCz0EssWma5Q9xh9JgMjGjGLkSetpdXsU+4dZlOTE+bRhe+VeIJG9vVFMd0OUbijLGqdMd/oc9QNmyaF1HfjY57C4niIA66qBZNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CZl1TkO9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CZl1TkO9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94CDF1F0089C;
	Mon, 12 Oct 2026 13:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791810085;
	bh=ukEzCi8a+MdhPFRFiBRRl1k9hZwBqkP8ZRiGKMSMHfo=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=CZl1TkO9w1rFQG8mYdI4XJ/TmlmME4vcf0hATIOS4eu5Ql/zUpzbZvWlX8X1I6y6V
	 CtyaFoo+qyn9Ecl6tG04cHW7by46ZFciKJ+/zltyk5TXXbl61PKijf8sAli+FmqpUY
	 y/JLxu+RAJqwNNn8dYK4MRPARATqhjgCrpVJ51RH2hBqnrp5X2oZngkLtFQkV63BXl
	 VgQmYgTopuyx/bI+UXFbtTKF1gt847mp7HOggT6kIpCy2ixlbMTAdQZazSZvwKF5ra
	 1y3tIBx/jSdg+zMVBcfOlQ43tAdsdTl81zRLbe05LrHQ6GGuCs8TG1JamX6ahF+kPn
	 HGsKX9nDU+04Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v5 1/9] block: introduce disk_zone_is_offline()
Date: Mon, 12 Oct 2026 22:01:13 +0900
Message-ID: <20261012130121.1902634-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261012130121.1902634-1-dlemoal@kernel.org>
References: <20261012130121.1902634-1-dlemoal@kernel.org>
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
---
 block/blk-zoned.c      | 16 ++++++++++++++++
 include/linux/blkdev.h |  9 +++++++++
 2 files changed, 25 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 19268afb8752..44010be6876a 100644
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
index d003a9d2d1f6..83d88dfe59f5 100644
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

