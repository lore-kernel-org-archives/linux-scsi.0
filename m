Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540DD4F93CA;
	Tue, 13 Oct 2026 12:27:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894475; cv=none; b=GfiC+7IdlMhGtnXUUAf1I79Qv+vmSyWPxBqSJ2AaBvUaGVSFihP0IW+IqnAqwVK7ZnYb7jIO2D3oHDDbfNI7Fr3Vy6I52fX39waoLWvI7YKsnGg3ZqJs51JyVKZdTnK5fyKlOXAYGnq1jFWiJnGm4r5GY5Km/BTnRGP7jC10kCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894475; c=relaxed/simple;
	bh=eN6L7Q3aOttcGmT71mrGSy0EyMezUpJAQR12+SWDm1A=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SEgdHebR8uDMpZ0HQeMKSMbXCp8flnLHbCHYmry/7mnPDAKP0hcbw5P2o1018TBadNlPeNavjzLtOOkieRHNBL2wtDZTPOI7ExoU//Zmz9oYS1tAI0nkbcBBrF9KKfRMZSJo9R3ZbvyP1vgnvbJ9fLnX0p+6dquhWcA3MAdZBPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BRhejmQk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BRhejmQk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E75C1F00898;
	Tue, 13 Oct 2026 12:27:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791894474;
	bh=vqWhG4+x+9my2TU/x7qA0pDe3Bew5dVDIhFHXLekGWk=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=BRhejmQkq/2ZuUfEFXfj1IfENy37VFyvhm/wTvDcaSTqiNE+JV/JvzIjf9n/hnuyW
	 fuPppm0EXCi3mVMR46kmiR3BcTt+gBnjbAvEOKDXQ+I6JJbs00bekqszEK/teGpxND
	 Rea698UDgeHUTEF91DoL/oXHBtKRWjLcfgpCNSAECrrPYfz11dmE7THQbG10DB7wXL
	 bboB0WiE0eVWIQD56AknMMkeFju67iyWw8caOEA2C/gHqM+Pjig06KKAiCdD6I9FY7
	 mscQGJ103d7vIzJprNCzu13otbPT0apyFwe/14gFvs6inxCkweHHENut6pMd5R6W7m
	 FIHuL1BB3MGbA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v6 01/10] block: introduce disk_zone_is_offline()
Date: Tue, 13 Oct 2026 21:27:41 +0900
Message-ID: <20261013122750.2237843-2-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261013122750.2237843-1-dlemoal@kernel.org>
References: <20261013122750.2237843-1-dlemoal@kernel.org>
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
index d8688a3d8314..0d4b18290412 100644
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
index 2d5c30823aab..f7f79bfd907a 100644
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

