Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C24C51A072D;
	Thu,  4 Jul 2024 05:28:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720070911; cv=none; b=dDj3umP7zVct2gw7Q10+/kP3O5OhWOvRZKs9idvSJsn6itmzZV3UFE75EbEr0OpCqLgl68RGHX1xYMFqEl8UTegTmNYw5Hn02ShmH20rPRvLkdgNDlr0t8NP4TS08ADqVUp596nKJV8kJ5jDVcN7zD292SJLc6sRaBcohBUzJjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720070911; c=relaxed/simple;
	bh=BXqTbVMBcBqTN4eTR9wNcMbEWemqH6IfDI6PmgwrIpc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j/G01+M9vFLYZ93BV/12YHNZ968V5oOJoNyXXRalhPBu8cllKL2KnrZnAmlYRZx+2HXAwU1SjxJomgWRxVeeDCsfO/ENfblLZ0ymSGdd+A1V+OqGsQYkRtfXFMLjRRSmOu9tDiKido2APTRK+SH42pMzD/6pL5bg32i/F9OfBI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X/Wv47GB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X/Wv47GB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2460C32786;
	Thu,  4 Jul 2024 05:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720070911;
	bh=BXqTbVMBcBqTN4eTR9wNcMbEWemqH6IfDI6PmgwrIpc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=X/Wv47GBEcJ7091IYxd0wRkUtuO10L1y3oN/hRCofaty6fLcMj06+6S8GQedXekoM
	 R7BhZMoEx/mk7DrCKxbgq+k2rMhufBRFkkd64vxl8zHO2JOLvdezLwy8nN7iFdU86y
	 geh21Z6trd2FGvRr2D0homdaldmpvsz+syvyQYQiplin1lCx7Hqtq5oXc5/+SD6HII
	 fvwaYonQlCvuMdK71wkLv1yRi6Aq3rILzX7HgqQUplVGiWF4UeiQuKLE25AJIKQHI5
	 Npn1kamjr8qbpb5mxN4vcyti63sQb1PgpIITclaXEhsBqa8djlAsHW5Fhdkc7Jl9o2
	 YCGtktQ2oP0lw==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Ming Lei <ming.lei@redhat.com>,
	"Michael S . Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 5/5] block: Remove blk_alloc_zone_bitmap()
Date: Thu,  4 Jul 2024 14:28:16 +0900
Message-ID: <20240704052816.623865-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240704052816.623865-1-dlemoal@kernel.org>
References: <20240704052816.623865-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the helper function blk_alloc_zone_bitmap() and replace its
single call site with a call to bitmap_alloc(). To be consistent with
this change, use bitmap_free() to free a disk convnetional zone bitmap.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-zoned.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index b104f5175783..af19296fa50d 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -150,13 +150,6 @@ int blkdev_report_zones(struct block_device *bdev, sector_t sector,
 }
 EXPORT_SYMBOL_GPL(blkdev_report_zones);
 
-static inline unsigned long *blk_alloc_zone_bitmap(int node,
-						   unsigned int nr_zones)
-{
-	return kcalloc_node(BITS_TO_LONGS(nr_zones), sizeof(unsigned long),
-			    GFP_NOIO, node);
-}
-
 static int blkdev_zone_reset_all(struct block_device *bdev)
 {
 	struct bio bio;
@@ -1485,7 +1478,7 @@ void disk_free_zone_resources(struct gendisk *disk)
 	mempool_destroy(disk->zone_wplugs_pool);
 	disk->zone_wplugs_pool = NULL;
 
-	kfree(disk->conv_zones_bitmap);
+	bitmap_free(disk->conv_zones_bitmap);
 	disk->conv_zones_bitmap = NULL;
 	disk->zone_capacity = 0;
 	disk->last_zone_capacity = 0;
@@ -1607,7 +1600,6 @@ static int blk_revalidate_conv_zone(struct blk_zone *zone, unsigned int idx,
 				    struct blk_revalidate_zone_args *args)
 {
 	struct gendisk *disk = args->disk;
-	struct request_queue *q = disk->queue;
 
 	if (zone->capacity != zone->len) {
 		pr_warn("%s: Invalid conventional zone capacity\n",
@@ -1623,7 +1615,7 @@ static int blk_revalidate_conv_zone(struct blk_zone *zone, unsigned int idx,
 
 	if (!args->conv_zones_bitmap) {
 		args->conv_zones_bitmap =
-			blk_alloc_zone_bitmap(q->node, args->nr_zones);
+			bitmap_zalloc(args->nr_zones, GFP_NOIO);
 		if (!args->conv_zones_bitmap)
 			return -ENOMEM;
 	}
-- 
2.45.2

