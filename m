Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70B5357CEA;
	Fri,  9 Oct 2026 09:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791536989; cv=none; b=H+499wpU2CGC0FHWTDR4By7qJ9D6S87EzEaZ0yF5UeusSUUU6MdYbrQ/A2JV4bPeUgBtfLW8qsJHUFndHNDHc2NJFty4Dzby4AjlLLGuLKt7Ldn+uaNRTlpeQWg7bhYHvVqT3Yu4+NeH2FT4gWAz3Xtg5HkoCD6More+PoKz31o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791536989; c=relaxed/simple;
	bh=jgadORKttZ12x2TaYa/j+lxG8U4Aek3YRr5ijfedn8k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TiJBrq/PZ5UDR3OuiBMHlhKfhrPFNXhwwTMNoDG5wleg38ARlbuY2XFST6CAYd3iez+3U3g6p6sP8MqKITyumMW7Qku6/7MarK+TuiqmOxBJxqGCHoSBSKl3fuppeJ5e7Odf877DP4ldTbsRwKjFxDm1gVtFcPL5REWATSYo69c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gID/hWxo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gID/hWxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68BF1F00893;
	Fri,  9 Oct 2026 09:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791536988;
	bh=sE25rYTzjBrD47RGhz5o2D5VEvZv92djD3LqOfqnBcs=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=gID/hWxoCgoAclX5caFMsYYtnxu8BhvE9qbM23OM4VIaate0AVOK9OfPfnDl//tqq
	 50nas8o5gmjbK79znmgHq/6hlVtNVulaTQdfSAtEbDnn8A9U2Wp5AcC3mLjbXTqOHw
	 Zj93SdlSFzXoLh7XYSEuq1EaVTa4Cp5pGyinUHKeNPmwKSPG/3S63ezvoIQWzLXGfP
	 Oi5VTiNyQPwe7rrTgkPsoSRwCAQoC1zSNcGLpOpW0RjtfUH6PsEMkxdIjwyTlFGIWW
	 brWVgO5CfkAMSMj6ofpCv/wuXuLoeKjAOfiPzVsrnl2VQS9abw9v3miwk/tZlj1f7g
	 cEZW2m/cS5gPQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v4 1/9] block: introduce disk_zone_is_offline()
Date: Fri,  9 Oct 2026 18:09:37 +0900
Message-ID: <20261009090945.1504194-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261009090945.1504194-1-dlemoal@kernel.org>
References: <20261009090945.1504194-1-dlemoal@kernel.org>
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

