Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 155D01953AD;
	Wed,  3 Jul 2024 23:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720049983; cv=none; b=ul+yAK6BaXIaPOAE+uu7VH/Xt99wm4tpeP/NsXO2aCzBjQUQtqv/9l0clHu5JeeaGIlevTzKr72kQbOPxI4QC0xU2uGBpoSI7VVwerBqtJ9PjbE3QAwOq/pT3uDjPlkakPSyhQMAVjQu3SAaSqUeUPPqJvJ3qWyoNj8l33UdDrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720049983; c=relaxed/simple;
	bh=+3exVKdsSUiXOtP+zbFK0kxihm1luEPUtQE0mCdFLdk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8UquO56Ctkgr6Y7dom4BKrp06wTmPshG2SCUghfbRPAeSuN9TFLQV0YB5FnPcJ/DRo2BYpAwQGRe8bt8R+nLgS+C/GJWkPKaCKfB9SRdZQIqr7507xmpcirE+Go1WFiJ++L0iPlIE2E9YuieuOHwq8vQOoMQzzI35rUkkVdYbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JuQTvPt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JuQTvPt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E785C4AF0A;
	Wed,  3 Jul 2024 23:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720049982;
	bh=+3exVKdsSUiXOtP+zbFK0kxihm1luEPUtQE0mCdFLdk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=JuQTvPt20vljhL2oXB2VfYGZmg+q917AZpb8kn1rOgF/A1x72TlEfXOyaRzTjiM6u
	 /UniKC+gvE8VOQLnJYeB89ZAlYyHx/yeflIZjkRDTGuUoADdo3uVmPEuWazGAcUDGP
	 rVRRPV2zFkhPiol9Ad+CrooMI6xDKCAfUXOHm2NOHAvXS5cs7hsuACAXigz4DK4eZ3
	 GK9/1q0lvATFKLdMqJBQL3viMPv9VZNzVcf9dLRFv5jSddM5UaLrPCDceYd3kPnT34
	 fGrRijGsV6TdSD3VNFh/vBcNkiet/tkGOZLnIqO5N2UAL/GjZhW5B1YamED7ZOQP+t
	 531jZ2S7mhKKw==
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
Subject: [PATCH 5/5] block: Remove blk_alloc_zone_bitmap()
Date: Thu,  4 Jul 2024 08:39:32 +0900
Message-ID: <20240703233932.545228-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703233932.545228-1-dlemoal@kernel.org>
References: <20240703233932.545228-1-dlemoal@kernel.org>
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

