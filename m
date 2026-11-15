Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794785611;
	b=i1r0uU1K/5JgBib0/CNKGuoLzLKqfHom32zzcGLBP6XCEA/2g14nhMQpna6AbMPkXocH
	 voRy70USFSbLfzkoWtzMiHb+Im6eUugmtDCTAKl3LmE1Vd6T8CeKS9oV7whdWhPDV/AtL
	 JVOmPa+Osc/34tXmne8CebKymwqezYAu53jZYIOrO+by8BoLtc2hSM3TafOl/EkoJ3Eax
	 jRCU3t5aplLcT3Y+TsyzSDUexVUIMnqX1xkhn705IiSJRk7kI0iFLpvsrRJKCrowGMg2C
	 KZXsiotRIkcvhCNbSwxXJQrwWpvWGvNE+wplvQD84I/GrE2fn+bPzFiAgRR/clUSBZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794785611;
	h=Received:DKIM-Signature:From:To:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Oni92pXM+I7fxOlbC1/ubF4NHvTv/X9JfcgsogGeo7k=;
	b=tPcGE+93qViwt8JCQRA2GT/LOkuC/AMUndbQyCKwPICXapb5+zAeqZ8bJ8Q9OsM1Ftp8
	 dSzGgE9e926psHr19Ai0lXM5WVraWPPHbl2pefxit0teSUB/ivM5Reohnh1LcoMQcxPUW
	 lxluxME26uRIIBxhwp7qXseyaKqLQbXZqAum7KF2ABN20QKFxN5qLg0sW/ZCtbsHZ03VE
	 NOoiGFjYyD9ngdnB14NQCvU+XtU+33aP+HzqeWh3T0HFrP6aJsk18KfyeyqhBaGO3prx2
	 nlFQF3lLEWJ13WzqPV/rkp5CKeAZ4kIZFBaqXY5L6YCTdu4mPTubmA6YUUTlWTub4FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DwbEl9m6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29536606A336;
	Sun, 15 Nov 2026 23:33:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DwbEl9m6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDB51F000C6;
	Sun, 15 Nov 2026 23:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794785611;
	bh=Oni92pXM+I7fxOlbC1/ubF4NHvTv/X9JfcgsogGeo7k=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=DwbEl9m6yCZ8nMlawdm9oAU7zOwyNlscsIqdLlM1atuyNNDg/MaDvWlJeA17sibnk
	 mToRKGH6twIHGKjN5wMdHJuuqghv35V7KVWoeRiPpZTBblVlhjd4Da0s1eeWxatmct
	 rgTRhXFegsLYAFLus22B8QqPhyTbZCCPwoFSCbsONtKchPE+rlwIAn8WBW/oe0LvLt
	 pKnmuCuWi8QALtBuqE3SkqWHe06LrM5Bk2CNU5jNNXgjps1cxCHq61IfKkQSSMxhIB
	 vkqrVjOEHG8j4X/kFuvL2kfJ8GCEAd0DuUxMn2ZGjMEPfuruETHoyd47a86WSbO44o
	 MF3mweKJw7p5Q==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v10 01/13] block: introduce disk_zone_is_offline()
Date: Mon, 16 Nov 2026 08:33:15 +0900
Message-ID: <20261115233327.941586-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261115233327.941586-1-dlemoal@kernel.org>
References: <20261115233327.941586-1-dlemoal@kernel.org>
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

