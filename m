Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794754219;
	b=nN76Ig+hMtJxpZcwzRZv/b6a+uYvNqtfy7gA8OgmkeUsPfXpGTMma4jI0P8RDDBRwOn4
	 Djm6dL6hlpabdry6latLXlmMiYi6KcvryBsetdQSzBT9Yh+SJH6cbJlGil0QUM1PLMWWt
	 XAoYY5waPGdGgaun0qxjqxpad5gJkLMulUypjpZi4tCt9OMM4neF5Iv8nIRucb33jaKuW
	 ayvbpvFSjxivW6EHndJ5fNlGv1KmIUkXprH+jzQvGsjYiqcYZJguhwy8hQ7ujXtnK8GuL
	 4g0gVmFH/GnB4XOMpq5XpgGBABc7x8kq/Vw5YZGXMv+pOkV4lQFW/zGGV9ycZpO7HKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794754219;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Oni92pXM+I7fxOlbC1/ubF4NHvTv/X9JfcgsogGeo7k=;
	b=evuuzqbvrhoegpAgYfcZs7RnH4IjjBi7VMncdkJuklXh0LXx/1IDP5c6UeIrhzqAZjeZ
	 E2MRmiX5RY/SPWO08GIyIajCH88pr3MvtCMBkCDk4+hPmRBMKWJGkD1As40z1Xp9CYt1j
	 ZQbssIvdZyoVBE7HlaymDseqWsa0rxCRmklpQiBE0Tc245GiNG7Pou8CflnpXKozQX1nT
	 0LZxZxi8NImSwLyyexrX99LGXa3bMZHutshTRyrX8qXFyxKv4VUOkKGAbOcbRs3Bf94Ir
	 /4/SDX3vhUUN2VA6T6ZbFTXKVpvMFNH11C09nnH6C37AwO3cxBSh8tGsWdsCGsQLJ2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RzXXxCkW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDDDA606A31A;
	Sun, 15 Nov 2026 14:50:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RzXXxCkW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4881F000C5;
	Sun, 15 Nov 2026 14:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794754219;
	bh=Oni92pXM+I7fxOlbC1/ubF4NHvTv/X9JfcgsogGeo7k=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=RzXXxCkWG/5K0dtejZ3hbTgLCrTnA3BGkRQeAoUo/odHMxIRkd4Uupfl3/tIXsVcp
	 +CDcjYCn45tA0T+CbhAWDWqwxJxmjZ1PPhUDRON2Ry7ZPDEfqEd8LeaJE0Ib9JTIqB
	 KFOO/KeDXjnP0hT7YWUY+qPWSMQq2bpkxRvLlsEY6T5KVxK9N0xJ5lXm4eqYULEdUE
	 mv7/RRnr4Pc/EEBIQ9zRwTAuCRQwEXTq3rN67BtlJy2GLxjie6FyQ+6OuCdiQ4ASvA
	 s6EMt62r8HbrYnP5b64eKl2BGPHqp2H7iu9XJcz0/9KjTQem0NP3Uu1VvDqXOxqtIg
	 v3V64CdjlCO9w==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v9 01/13] block: introduce disk_zone_is_offline()
Date: Sun, 15 Nov 2026 23:50:03 +0900
Message-ID: <20261115145015.938426-2-dlemoal@kernel.org>
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

