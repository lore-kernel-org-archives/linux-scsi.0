Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794865025;
	b=ZSXUJy3nkg22nBF9GyItFvZ1smN2OV4GySzCLrN+b/4e3pZY43+1aK4agoMu36F54oAy
	 cVGbcS781fqVieVnEwJGuk1jPN2quPIY30Hca5myJZgDGeh3fForDoPStGbqDORZNE0e7
	 LApSJ+QFjALF4M/8n4aKtWOAqhqyxbtoKHOPMiqY7uQ9FKbYZHIA0tH16Ert5ootV82gM
	 p91wuQutLcXq9ScVr3QOUdY2NElpS0oX0ENKkK+LAL6UL7IFR2RfMJq0og3dJzJar0KUJ
	 9B73nncsgUa8s33zQJbg+sjHNn1/U/CDue9eTzyB3zPVLWWbr3BBA5hKIeEQTmbJjLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794865025;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=V08ilXCGlK/y2RxNOthJkoE4M0p+yOq5hKxM4QIMpio=;
	b=o0JRHSpqoKUHqRR0Y+ZY2A4b7rSQMbMwTaQn+OJ1cwHOESE4awwjDNxdyC8p+dCU5RpO
	 YpSEc0j2IQtcZbgYg6AI/9CzQMzG/usReBrShx6A7s/4+yd+CTT+CjhLAUgOszHcfnAYA
	 BYwt2t9B54XlGzwBw1Yf8EMuDgMPusvvEruROd0BnK9tpn4gD4YY7872AwloPV0N0D+Fl
	 trFFdOLhdMHPE063BmiXklrDo0PcgJrAoav7HqhSYlkcySThnvF5RGat081Zsbv210Kgk
	 15IPnyur9s8YELSj7Eo0iNsAUrsEkRTLyK6/YG1nAoEtDdl4oHkfNO0gaNgTiNA6vIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="YtqO50/R";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB947606A883;
	Mon, 16 Nov 2026 21:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YtqO50/R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2781F000C5;
	Mon, 16 Nov 2026 21:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794865025;
	bh=V08ilXCGlK/y2RxNOthJkoE4M0p+yOq5hKxM4QIMpio=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=YtqO50/RRiaYtx2HJbZddxo3ZAgu1kNxuRG5XRRmRDM1TwZXL1rtv7TRNlqgnRAmE
	 HnC1NoQvdQX2uyRICMn1YjlPlKIdQrUPPeS5t9MHGom3QGWUsCepcy4kNr2zACaHFg
	 rOMzusfHca/lQrzKrC47cCPUzoQ5q2dR5GALHGaAJDAUQc+2cZLv8IIxnoeCeJnrRt
	 RR+APICd/mafxvlTc/5b6Zkx9Ez5a+dNLtlPHqWMSXJ7Rcr63EFDHF0WQoGuiwmGTo
	 I+SNFiv9fteq6GSy6ZGy9NeqNrMFbJAQDx6h7x+xsjrfmEbbsd8dRtpFruoinGP5DY
	 D7Nl0DNG06z8g==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v11 01/13] block: introduce disk_zone_is_offline()
Date: Tue, 17 Nov 2026 06:36:50 +0900
Message-ID: <20261116213702.225970-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261116213702.225970-1-dlemoal@kernel.org>
References: <20261116213702.225970-1-dlemoal@kernel.org>
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

