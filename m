Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 908406131;
	Thu, 28 Dec 2023 07:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RbOlatFh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=44RD+jZ6DX4O8SC8COa74HVFOT+lGHCy7Syx/jSjYPc=; b=RbOlatFhVuiRr6iNXXxcTrrVaw
	ffZjFv7WcGYSquyQygRjai6B6JXCXhgurG5ZKILEiJt+Jab99W2G0CKY2gPh3rW7yNwgZrhJJP5M2
	woz6bYRdTEKdb3RKu18vXYYFO0T6WzcD5ocJWjqt++DKphILrC2DYJCY7Tk+hgHvBqaL9xPuoYrWy
	AUieUJNteSFCpqwNQuayGtoNF1iktSN8Va6/e41qhlxsDV/gHhLteT6SIX/6TPBBC1klN0iVba9+r
	PlgGx4QFLpPiW28ImXb18GkAdrIXx9JH1XUXm7EhZ9FSCg6aulgTvvwimg/TZKz3qpzWKExOqVqTG
	NtpRt0dA==;
Received: from 213-147-167-209.nat.highway.webapn.at ([213.147.167.209] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rIlBO-00GMhU-0V;
	Thu, 28 Dec 2023 07:51:59 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <damien.lemoal@wdc.com>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] block: remove disk_clear_zoned
Date: Thu, 28 Dec 2023 07:51:41 +0000
Message-Id: <20231228075141.362560-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231228075141.362560-1-hch@lst.de>
References: <20231228075141.362560-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

disk_clear_zoned is unused now that the last warts of the host-aware
model support in sd are gone.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-zoned.c      | 21 ---------------------
 include/linux/blkdev.h |  1 -
 2 files changed, 22 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index c59d44ee6b236e..623879d875a43f 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -615,24 +615,3 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
-
-void disk_clear_zoned(struct gendisk *disk)
-{
-	struct request_queue *q = disk->queue;
-
-	blk_mq_freeze_queue(q);
-
-	q->limits.zoned = false;
-	disk_free_zone_bitmaps(disk);
-	blk_queue_flag_clear(QUEUE_FLAG_ZONE_RESETALL, q);
-	q->required_elevator_features &= ~ELEVATOR_F_ZBD_SEQ_WRITE;
-	disk->nr_zones = 0;
-	disk->max_open_zones = 0;
-	disk->max_active_zones = 0;
-	q->limits.chunk_sectors = 0;
-	q->limits.zone_write_granularity = 0;
-	q->limits.max_zone_append_sectors = 0;
-
-	blk_mq_unfreeze_queue(q);
-}
-EXPORT_SYMBOL_GPL(disk_clear_zoned);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9f9fbc22c4b037..de944baddd6036 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -318,7 +318,6 @@ typedef int (*report_zones_cb)(struct blk_zone *zone, unsigned int idx,
 			       void *data);
 
 void disk_set_zoned(struct gendisk *disk);
-void disk_clear_zoned(struct gendisk *disk);
 
 #define BLK_ALL_ZONES  ((unsigned int)-1)
 int blkdev_report_zones(struct block_device *bdev, sector_t sector,
-- 
2.39.2

