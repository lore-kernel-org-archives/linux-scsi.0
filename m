Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD92F79F0;
	Mon,  8 Apr 2024 01:41:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712540503; cv=none; b=YLF/kgSMkCgxpYuVlq1W+bxukydLPuWdIqSoKHbhwbf8IOkOiQeNXtyvNy/fez1d1ciLZAfbNhQn8dLNYx+lWF8cZz7SfgemXwtTuxmzIof5CvgnHzu8nFHhtMpZ6goyVRS7LcWgM6EwV75fyd9815KlRtOHvhoqgCNjneSkvaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712540503; c=relaxed/simple;
	bh=Gc6R7atctZxWUBVqGdz/vSl7rTIqmg+BynQMw3AwliU=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XZDyU0/lXaBCTkUZ9qEBbswqMEFIrnfrGYakuccaY/X31h7pIchG7nmWQ52b1qq+wgACnyobmxwM3tgZdf6RQowUvFRhkNZ+TC9mIXH3U9d4n+sv4NScQvYLG6uzINh08FvddjxoirGrxilGk7vTl371f6Rw7RkkEc2rnLZeS5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LDBmgvca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LDBmgvca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80173C43394;
	Mon,  8 Apr 2024 01:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712540502;
	bh=Gc6R7atctZxWUBVqGdz/vSl7rTIqmg+BynQMw3AwliU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=LDBmgvcaWNvNeG3+sAoZ7r5ke/FuuF9qn8gr0HFkh8YnKXsj+7g3+gCqCN6gkgWlS
	 M0WEv8bdYT2VEkEFUYLi4I77xh4bLQfQQitsplX8smPvFGG+wlkVAQsHzaG0sHXYQp
	 QqPQhfyqqGXA9/LJz2RnnC8ZDYml8boLnjrds9a5tuSkr6+kki0ty8O9lalvg7Rrn0
	 oayvW7+AJh3HOIBhOotDQl4jFH7MOh7aylTeTkD3mghl5jG3r6B2PcHUiezkCFzb9A
	 XFcurA8w5ta/K+t71BD932LUgHsDWOUOLfhuvKP3sbhkWMUmNi3gNDmzMitrfF6pD5
	 gpedCsKps47Pg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>,
	linux-nvme@lists.infradead.org,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>
Subject: [PATCH v7 06/28] block: Remember zone capacity when revalidating zones
Date: Mon,  8 Apr 2024 10:41:06 +0900
Message-ID: <20240408014128.205141-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408014128.205141-1-dlemoal@kernel.org>
References: <20240408014128.205141-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In preparation for adding zone write plugging, modify
blk_revalidate_disk_zones() to get the capacity of zones of a zoned
block device. This capacity value as a number of 512B sectors is stored
in the gendisk zone_capacity field.

Given that host-managed SMR disks (including zoned UFS drives) and all
known NVMe ZNS devices have the same zone capacity for all zones
blk_revalidate_disk_zones() returns an error if different capacities are
detected for different zones.

This also adds check to verify that the values reported by the device
for zone capacities are correct, that is, that the zone capacity is
never 0, does not exceed the zone size and is equal to the zone size for
conventional zones.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Tested-by: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-zoned.c      | 26 ++++++++++++++++++++++++++
 include/linux/blkdev.h |  1 +
 2 files changed, 27 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index da0f4b2a8fa0..23d9bb21c459 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -438,6 +438,7 @@ struct blk_revalidate_zone_args {
 	unsigned long	*conv_zones_bitmap;
 	unsigned long	*seq_zones_wlock;
 	unsigned int	nr_zones;
+	unsigned int	zone_capacity;
 	sector_t	sector;
 };
 
@@ -482,9 +483,20 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 		return -ENODEV;
 	}
 
+	if (!zone->capacity || zone->capacity > zone->len) {
+		pr_warn("%s: Invalid zone capacity\n",
+			disk->disk_name);
+		return -ENODEV;
+	}
+
 	/* Check zone type */
 	switch (zone->type) {
 	case BLK_ZONE_TYPE_CONVENTIONAL:
+		if (zone->capacity != zone->len) {
+			pr_warn("%s: Invalid conventional zone capacity\n",
+				disk->disk_name);
+			return -ENODEV;
+		}
 		if (!args->conv_zones_bitmap) {
 			args->conv_zones_bitmap =
 				blk_alloc_zone_bitmap(q->node, args->nr_zones);
@@ -500,6 +512,18 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 			if (!args->seq_zones_wlock)
 				return -ENOMEM;
 		}
+
+		/*
+		 * Remember the capacity of the first sequential zone and check
+		 * if it is constant for all zones.
+		 */
+		if (!args->zone_capacity)
+			args->zone_capacity = zone->capacity;
+		if (zone->capacity != args->zone_capacity) {
+			pr_warn("%s: Invalid variable zone capacity\n",
+				disk->disk_name);
+			return -ENODEV;
+		}
 		break;
 	case BLK_ZONE_TYPE_SEQWRITE_PREF:
 	default:
@@ -595,6 +619,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 	blk_mq_freeze_queue(q);
 	if (ret > 0) {
 		disk->nr_zones = args.nr_zones;
+		disk->zone_capacity = args.zone_capacity;
 		swap(disk->seq_zones_wlock, args.seq_zones_wlock);
 		swap(disk->conv_zones_bitmap, args.conv_zones_bitmap);
 		if (update_driver_data)
@@ -608,6 +633,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 
 	kfree(args.seq_zones_wlock);
 	kfree(args.conv_zones_bitmap);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0380b7e6f818..7f3d85d5486b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -191,6 +191,7 @@ struct gendisk {
 	 * blk_mq_unfreeze_queue().
 	 */
 	unsigned int		nr_zones;
+	unsigned int		zone_capacity;
 	unsigned long		*conv_zones_bitmap;
 	unsigned long		*seq_zones_wlock;
 #endif /* CONFIG_BLK_DEV_ZONED */
-- 
2.44.0

