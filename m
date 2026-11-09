Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217908;
	b=29F909zPJlZuyJ+YdWSubPpnsY/9/5jc6VYoEakS4jrPDMXYPVY84jiHqMqohtfIbfWD
	 ALOQ5PIeZFzY55qVtyHd6fT6S8rUGC5hv4rYg5hiUhqSK/12dOFHOYOBsMvw5HMPaLxvb
	 iSBbFQek6gOgO+fdaelMLd0vQjDVC8Z7WxvTFEHiH4gsl0YLAUW0UWmTJy61S7jWdRtEG
	 iE/+k9cWmJNWyPns/BPhlbeSKzkMJhtv4wo4NE8XoMX0w8czqS3v8+rdUcYueT1qiOlaS
	 zm640PB4CLvAg06xnPPuk8rIq+V35P1wN2xSKmfM3TaICSv3+c0UwMz6II+L8aKgHlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217908;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Oni92pXM+I7fxOlbC1/ubF4NHvTv/X9JfcgsogGeo7k=;
	b=NKDuwV/ACJvCnX3td4hj6vPtlMj8i5elwZ+OEt/VipTrOqZN+ds1mHzlxiGWD7la2+Ac
	 i+mD+V2dac3odOjlLm+R7UvNU3DEVXwZktYR+V0trHsIQWhD39NTNE0lSBHLj7Y2Ur3dZ
	 JZxfA650NjCqbzZqJ+VhthuTB8HdmEQg9iFp8MUy8ZlQj1OcOdAXO1yN3KfjFUYNnUF3d
	 kHD49Xq3E+Ushid7Ux2jYdAgRW5oAsqKA/x8LJ/erw8lqHV24jKsXvm79wjqPvK08m6sC
	 u4MtjpB4EyoB4tvaaRmmYGMB1TsqbKxGIFiIj2qIKv5Z5+YcSv07xKq239tOvRKrufA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TE7aLmE5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8103B606A33D;
	Mon,  9 Nov 2026 09:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TE7aLmE5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59BBE1F008A1;
	Mon,  9 Nov 2026 09:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794217908;
	bh=Oni92pXM+I7fxOlbC1/ubF4NHvTv/X9JfcgsogGeo7k=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=TE7aLmE55xoIM3hInk2UbNLeLk9Qjw8zrgIt4p+kGR8IdfshqllJWrqyz97GDX09s
	 IdlaTPN5jgUX2yXpXTGQTirQGAk4dinz8DRXes3TRp8EIwihVCa0SUBH3BwKH1ZZ7d
	 bweURp05vB8xNVfYw1viDzRODlWziNNvgWjZoD2HC3VzikIQ5ZIOzRl/rJ+QtiVdaX
	 6MNrNQVyooJbooIICo2USlsuR0NEziZ5I4JJOHWL0OrvlXKgiuLkx8/ncxdEwVpWuF
	 9EVOQs+qOIRx5lWrYcV9B3GFsJivDyiBCgVvyLvBnKFJ3Asiu5CUiO4dVtEzIf3ibE
	 slm8Y6R4Mz5/A==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v8 01/12] block: introduce disk_zone_is_offline()
Date: Mon,  9 Nov 2026 18:51:33 +0900
Message-ID: <20261109095144.819709-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261109095144.819709-1-dlemoal@kernel.org>
References: <20261109095144.819709-1-dlemoal@kernel.org>
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

Introduce the helper function disk_zone_is_offline() for testing if a zone
of a gendisk has the offline condition. The zone to test is identified
using a sector number that must belong to the target zone to check.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <mkp@kernel.org>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 block/blk-zoned.c      | 18 ++++++++++++++++++
 include/linux/blkdev.h |  9 +++++++++
 2 files changed, 27 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 4c5889296191..07d504287024 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -292,6 +292,24 @@ static bool disk_zone_is_seq(struct gendisk *disk, sector_t sector)
 	return !blk_zstate_is_conv(zs);
 }
 
+/**
+ * disk_zone_is_offline - check if a sector belongs to an offline zone
+ * @disk:	gendisk to check
+ * @sector:	sector number
+ *
+ * Check if @sector on @disk is contained in an offline zone.
+ * This function can be used only when the bdev queue was entered (BIOs
+ * submitted but not yet completed) or when holding zone_revalidate_mutex.
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
index 215753171cef..a2c36b4e6308 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -940,6 +940,9 @@ static inline unsigned int disk_zone_capacity(struct gendisk *disk,
 		return disk->last_zone_capacity;
 	return disk->zone_capacity;
 }
+
+bool disk_zone_is_offline(struct gendisk *disk, sector_t sector);
+
 static inline unsigned int bdev_zone_capacity(struct block_device *bdev,
 					      sector_t pos)
 {
@@ -954,6 +957,12 @@ static inline unsigned int disk_nr_zones(struct gendisk *disk)
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
2.56.0

