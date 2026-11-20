Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795208815;
	b=xs96WdAukJnJ9HvO7nsPxfLvaBp1N8if7MjizKXoDwFg25Ov+r7fbF2q88N7R0S0Xsk2
	 RBNc4jBZ1cI3Ke26een1pALWp001WnhEBjYzfybBSHAFzpWl7S79sBSP7HV/4eJuzAsei
	 JoDtV+1tmeRk8jdd5GSZD80oOHYXWhPOL3QhHTo/uHBNkt6sz2oX2NUGzFXb1xJzxbrYV
	 ouUn6lnAKiEOd6FFOWazSUyxxPZd+vU6cSsI5pHSmxEamhXUdggfVd/QLvPYoD4e/t9AY
	 XdMcQhWy+wjM014676AE1Py0GHQBHwwQKaQa6QzG9amINEx7QM7YUem3V5cAmkJbTLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795208815;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=V08ilXCGlK/y2RxNOthJkoE4M0p+yOq5hKxM4QIMpio=;
	b=uvJVkVpB2yCRp171gVIoHUqbu0dRXVCvUacf8ZslX7N7Fab+EqNsahlmCRTiPxEifFBY
	 tFp5K3FN6lcvB6bI+hkDPGaxhYjjgMfXVIg5F5a5UuRGp1rEv++iEzvIkyv9wXN/i00vr
	 /1U8Ami1wE1UgKaCxA0wp1Xjjx9jwImP2xTLfPT29Tn8F3ujmmMEJIL5UiCAr6bRjKH8K
	 jE1/d8OwmQDNlO18RvK5L2Ca56jj3tLit7pOagibrSoB+RYBzOwywO3XQ2sxtgXk6dWST
	 Cme15PVe4/JpVZK7cP23y/LpI5yeD2REnzkrLEcItVNrtpif3NxfJbps3Y/7WBGs7aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="E/eaBYG8";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A709606A6B8;
	Fri, 20 Nov 2026 21:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E/eaBYG8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 506111F000C6;
	Fri, 20 Nov 2026 21:06:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795208815;
	bh=V08ilXCGlK/y2RxNOthJkoE4M0p+yOq5hKxM4QIMpio=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=E/eaBYG83Qakd2hrH9x/34IDhUW08S6KIwz5pzyYRkJvSKxG9DGeAQphG7X4I/DzJ
	 ix70arVNsszw1IDH3TP2ET2SqEs8LGWa75xLvJuU1LWGPBaAtybIiUbNsSQqCWH2J4
	 zddtcEfPQXrKAK01HXwwrPLYTiaUBTtZ1zKQFMzML+lcpwW0CTjCkdhLK6L6lyyHSl
	 nhY30gahoywCT/M09sjxFG1/z3bdI00Wmm5v/DkszxUhpLXwyw1XKTwuUu/Qz+92mW
	 K+wR+YKs9Ro1QAaBMYlsbLlqVnu638ByHp9Y0+KkLuX6tDUKum3NhErmSuAH0gXFPz
	 /TThUUUsZy5mw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v13 01/13] block: introduce disk_zone_is_offline()
Date: Sat, 21 Nov 2026 06:06:39 +0900
Message-ID: <20261120210651.580511-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261120210651.580511-1-dlemoal@kernel.org>
References: <20261120210651.580511-1-dlemoal@kernel.org>
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

