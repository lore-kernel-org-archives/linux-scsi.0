Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F49F15ECD6;
	Wed, 29 May 2024 05:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716959137; cv=none; b=ixw6WSEhoZ5N0vqtx1Riqbqe/Gt08MdKaF6Kkqje6y0jQiXNSf3xWDVQDzUy41VtyhF8x31HOAOag1WS+oVYm9fJS0hzUvPsZzW4TcGZMLrStLDL5sdVyzQNCun7pRO7cuO54+TqWylkn+DiS/R9cE7OF3YUMyaSJjW0tZuJGHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716959137; c=relaxed/simple;
	bh=y9AJPh4gmC9vw1YNh4Xo6TPI7BEtNV/5OWSPqveG62M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GbwxHTGPjQIv5Ky4gPm8oE0XDfuKEzoodLUMXgfM39kiXY0QY5/oEulAObbRdrdQV5hQ4rfSN+02/80UJoq25BCL6sV1vbKlBNvKt+hHKbYzvLBhU0epqK+zeSxI29aETz4fV7tBuGLx+WZwSHxyL6R9937mjQ7k71zyWrApwJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sP8WPUo5; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sP8WPUo5"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=FxMZ/TuFQWi8ppJCXfgMd7wJRUIIOyQbd6+WyEUQ+N4=; b=sP8WPUo5vAWKUtYTFsHH8zz4lY
	DJJMR33fYr4eAsLHFTZ8Z9howNp0W6fwZ2fiNjcxUBC3ODEyO2i6vzUcK33pr0IzzNeqbE0OGj1ST
	5S7X+/6iNra2QHh6wsNSXPnXFeKcQpoKWDT2h0ez391hq4EcHyXFSepiXhTUC3N2xV1AZcowiOldm
	4EXlw2b1iSu+BV1NPRisPBN1MDDygrM+eCbEpyBDZ0QTDVC2nwgktvILS31bY5S++5+So+r6x+Kgv
	BwpsZkqpUIOpxNp0XUC+iXoyBN5nUfj9Zb4EGtzt7UNxwaRV/VE3oyhLo7REgxmsgSTIrs8QWAfko
	q33GTzcg==;
Received: from 2a02-8389-2341-5b80-7775-b725-99f7-3344.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:7775:b725:99f7:3344] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCBVE-00000002pch-0ecf;
	Wed, 29 May 2024 05:05:32 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	linux-um@lists.infradead.org,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	ceph-devel@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 08/12] sd: cleanup zoned queue limits initialization
Date: Wed, 29 May 2024 07:04:10 +0200
Message-ID: <20240529050507.1392041-9-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240529050507.1392041-1-hch@lst.de>
References: <20240529050507.1392041-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Consolidate setting zone-related queue limits in sd_zbc_read_zones
instead of splitting them between sd_zbc_revalidate_zones and
sd_zbc_read_zones, and move the early_zone_information initialization
in sd_zbc_read_zones above setting up the queue limits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd_zbc.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 806036e48abeda..1c24c844e8d178 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -565,12 +565,6 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	sdkp->zone_info.zone_blocks = zone_blocks;
 	sdkp->zone_info.nr_zones = nr_zones;
 
-	blk_queue_chunk_sectors(q,
-			logical_to_sectors(sdkp->device, zone_blocks));
-
-	/* Enable block layer zone append emulation */
-	blk_queue_max_zone_append_sectors(q, 0);
-
 	flags = memalloc_noio_save();
 	ret = blk_revalidate_disk_zones(disk);
 	memalloc_noio_restore(flags);
@@ -625,6 +619,10 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 	if (ret != 0)
 		goto err;
 
+	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
+	sdkp->early_zone_info.nr_zones = nr_zones;
+	sdkp->early_zone_info.zone_blocks = zone_blocks;
+
 	/* The drive satisfies the kernel restrictions: set it up */
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
 	if (sdkp->zones_max_open == U32_MAX)
@@ -632,10 +630,10 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 	else
 		disk_set_max_open_zones(disk, sdkp->zones_max_open);
 	disk_set_max_active_zones(disk, 0);
-	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
-
-	sdkp->early_zone_info.nr_zones = nr_zones;
-	sdkp->early_zone_info.zone_blocks = zone_blocks;
+	blk_queue_chunk_sectors(q,
+			logical_to_sectors(sdkp->device, zone_blocks));
+	/* Enable block layer zone append emulation */
+	blk_queue_max_zone_append_sectors(q, 0);
 
 	return 0;
 
-- 
2.43.0

