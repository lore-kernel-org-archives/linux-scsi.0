Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0563CDDBD;
	Thu, 28 Mar 2024 00:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586666; cv=none; b=apjuYlBIpfniBW1pyhZAXFEoeYFMLUjWbpVqIk84NPc30gusUqMWl2fDRdMHmhyt8/NUV9vksag9svzlJdPuHhQ13D4QKApznFWfB0KvnDDcvIYZDGJVIFh51nobz6E6bZkKEHO4qq5pUXFuqKa3p9ztlx/BV0rztyxdPsOoIVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586666; c=relaxed/simple;
	bh=x5cFsMGD/lA3hPfk3eS2pT7dUwKOv8FM7clCI0JESDk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEaQYDjrMcrML4l8GfTtmY/bqxaV5LQG+0oY2VjGZtZReUi6tqKf4OdkkN1vL7fOU87TQo0ZshtT8oF30Azp2XQ4Fat+72HYiGW01MIo4LCGs77n0D2Txyju2x6xU40aMeBaDIAo60RRoRwjIPmkCYd2/EKwehpOZNh9U/6p4Sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Kl7NLyGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Kl7NLyGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2E4C433F1;
	Thu, 28 Mar 2024 00:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711586665;
	bh=x5cFsMGD/lA3hPfk3eS2pT7dUwKOv8FM7clCI0JESDk=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Kl7NLyGOO/xKcL1L7YwAon0eO0A4UPWb9yYip3bwAPJ27IdfvcbMeWVxEjwSYnebI
	 st1W5oboQZrFXYBF9QRakc4gfDWkW4qsDZQbkFByAe8Pfy6MI0IianrA1WqZGqS/nA
	 IEPYoKcpgV/Ta2ECQq5e9dgiv+HRYplxY+GkgvEIy//3ypL6YnUFtl6xvJq2Q+KCBb
	 Fy5/A9Toi29qcz5qa0pvhkeASBS3mCzoU2QhOXRrS9VG5Frmk1ur9liK27CZ7+67Xs
	 EyGlV6yFZxAu/laBpktoHcBEnIoD++DmyM0FBaGTq4ACkNgY96F2n0215aYAVlWamG
	 bos450OHuWdUQ==
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
Subject: [PATCH v3 07/30] block: Remember zone capacity when revalidating zones
Date: Thu, 28 Mar 2024 09:43:46 +0900
Message-ID: <20240328004409.594888-8-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328004409.594888-1-dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
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
index ec7bd7091467..4e81f714cca7 100644
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

