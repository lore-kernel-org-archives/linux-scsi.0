Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C58015FEE5;
	Wed,  3 Apr 2024 08:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133779; cv=none; b=bRlqZEtjnxKg6GPN/SdVQHL6OOPEjViKS4ZWsozz+vnfa33WevpqwHUF4eB7vPVcuFrzS2WY6302T14GuBCoPU/em+oYKuyEmrJrLolXN49+zRBOMb+e4mMh1rCRpJe51bpkVZJiECuDY8MRqXg8VF77YKzSvhDlHEUAtP1P28E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133779; c=relaxed/simple;
	bh=M8e+jXVZ4tLmr7CwR6HYE+x2zILoUFdPsgl+BH6rT7M=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8O3DJheg0GF4d5/qRH4ZJCWya1oUIXBEvRFK93Nl8exw7eicgh1F8zFndYPauK1yYFvlYfOiR+is7GSjNYHfr1IaAO/3jY98eaWU3rbgm2hweDlOCsDeOrCPBetWmXWYudVo6B4pXx+Xj20VHOB/8Uff0qURJMt9/Mgt/7F75s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NRLdYmXK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NRLdYmXK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27433C433B2;
	Wed,  3 Apr 2024 08:42:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712133779;
	bh=M8e+jXVZ4tLmr7CwR6HYE+x2zILoUFdPsgl+BH6rT7M=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=NRLdYmXKMPVGm4jEFIIb2BObi9nbcoOSXLor+UVTb7218qvnMFAvSyPm+kvPJO0VL
	 xbVwMiDJnE7G9sIlaJPOPxtsfxk0UfrSNxGjZPnSrXhQGM72iLi55c+CTXlSwOUiB7
	 Nq8d50V199ExyZIipo6gb8EDyDn4sBGHLqD68I2zUBk8er/qWECn84JceV4v9lgfxG
	 UvWEkWh5TEyMOwwUNvqUvQFLGAzVdTXVEkP6XYBavEUQipHDco9cFu+4X3AGubZ/Lo
	 dpiGPl0OluDoYb49aMi1ktdewRtRWVmHy0itPaLIqtVZ9E2u7YwWVs44Vw7gSZWFsH
	 a6zyQix5GbTFg==
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
Subject: [PATCH v5 06/28] block: Remember zone capacity when revalidating zones
Date: Wed,  3 Apr 2024 17:42:25 +0900
Message-ID: <20240403084247.856481-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240403084247.856481-1-dlemoal@kernel.org>
References: <20240403084247.856481-1-dlemoal@kernel.org>
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

