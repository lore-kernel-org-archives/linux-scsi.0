Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794931063;
	b=gI4d5OCdq4Gh3pzANjQyz0EVD015AwHPWpjzrsUDGf7fBr9R/Kpc7ZbHvljG9FIuQvCj
	 0y5bsuIl4nSxuSzTfoqJUkv2v0Xh1mX/zkDmVZy2Lso20fT3SLRxcLQpmqC5CG4JHNHLK
	 rKZJGDcdV5sHQvOpyq+EwKBu9zubfUxMsQzTyIq6FEk4izPj+Vy2Tu2TJt+eUObL2kKUd
	 Wls0fbwnVQ2RqUbC7jaM9qnoMvzwaAVNPy1QHTCuc81R9zdwieXtjLN44ho1hf3o+CFMA
	 /B3h1C5ogYWvjg7ACovhKvBNAz298hJ6s2374q7yRYfGb2P3xB5aYb6NT4b0N1sLIVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794931063;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=V08ilXCGlK/y2RxNOthJkoE4M0p+yOq5hKxM4QIMpio=;
	b=a2bXoY2Jd++4LvJgKLUwipSLXnoJdeSOJzt8yvFhMIm+Kd69IQ/bGfJkWJ1mjjQtjwmv
	 OIPAnL7eTDS77uzPtoFLab9Qq2Za+8Wcco5y7T4j1mGcyuOaVUgMSnFtA24HmhemdUA12
	 b7XVJ0eKU525Mc7cQlpJn5yCxsjRQEGNjBsXjpPOIb3S4kYBtHsa5bs1gBaOW3RcY9tIN
	 5rbSFY9Kc60SsE06Q4DP1QzerA+F33/XC/YPcKPZXCdMjQ2U+h61LQ/vpWwR/3UgwpYsi
	 VZUyCWV+U3K6F+g/6qUNStxkYsr/Ynszboz0pOrJxOUrHBo5RflkKWlRGTudZ5ouTqg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mOiV2FDk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A793606A331;
	Tue, 17 Nov 2026 15:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mOiV2FDk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 500571F000CB;
	Tue, 17 Nov 2026 15:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794931063;
	bh=V08ilXCGlK/y2RxNOthJkoE4M0p+yOq5hKxM4QIMpio=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=mOiV2FDkQpAnrnfempjphvaJqzTWlsvSxhXEM2M51B7o+M54+Rh90W/Jeok0POZe+
	 hbE5APpRvEK+3FmbjK3Dw3Hr7weYZx9GyJ2wdQsX8+ukRTy1C17q86t4PORyKdSCPV
	 eXVoE3YVdxEm5WEUFmTcODyVcjtnZTPtZ7TRmXy8mgQpCRqL6k8etjOjXYLQq/Ts6B
	 6LQTlFNDgT9RY+RMl4TbGZgqG6QWtKXCCiFtLYJjlAZB/D5ttxQOtCxFMlWn7O7SUj
	 bqbaAJ9S0TM4iL7LKHbi4QWAw0dAnV5uBpyTXMak5S9ci3KK2YkzzGnZOde0oUcFhE
	 4qG5s7iWcdQew==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v12 01/13] block: introduce disk_zone_is_offline()
Date: Wed, 18 Nov 2026 00:57:27 +0900
Message-ID: <20261117155739.304506-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261117155739.304506-1-dlemoal@kernel.org>
References: <20261117155739.304506-1-dlemoal@kernel.org>
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
2.56.1

