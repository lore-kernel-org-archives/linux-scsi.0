Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028D61C3228;
	Mon, 25 Mar 2024 04:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711341907; cv=none; b=E9qYAycAGBWiXqOz64I/rCLNggwGsRC8kwVlmTRHacA77PYcUftVGTlTW3jdKhu2SJn/o59dHTGsIU1P72z1MPjOiITlaafeJLTGw6KjsbSEUdB0bHUeerjJqt+wI2JQ2vPT7gOhLSReEjZtaF8bejOJ4uKxYuVaokSioOonJjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711341907; c=relaxed/simple;
	bh=8XXjTyyyscJfO6X+ebJ04HM/euD+268DXMjGsAV6cVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LgarY5fR8ld5OfWxPTnXBVdq+p1t1RfBtZJtNTfK29/CTI5UreiQA+cKQBrvs67KKDQlAfaL4gqi5yE95N33V8xzmH3P1PcqI3Wp6G5TyI8/BfqlO63ZSXHNuc6Re2x6hRMORoes5B2CnzvdfeQVVHGOmNPrNDgD1hDWpvqZkxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gyDAmHx2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gyDAmHx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8971C43394;
	Mon, 25 Mar 2024 04:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711341906;
	bh=8XXjTyyyscJfO6X+ebJ04HM/euD+268DXMjGsAV6cVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyDAmHx2cWnpiI2GU6lJmQ5j4Wp5JIFak+QlMBlIXLADyplyuC3a3qCYLfH3jkJqu
	 9XGE7Oysk6Lgvf3NV8rRhDBbTCHSZ6HIbdZCNWhXA0HrZsiXE+lysNfP+wCuxqKZfm
	 ysNB7mex8y7reYS+g/DISttBw/kH20eHnOq29+yePuAblQ2w4M3IQchBYvvLHZrXOe
	 sY62suOPYNJ1DG47OPEJv/FgEzie0eJQRuNjwAN6Cs55/NE/7Vazrk2B2oLIYU7wYd
	 wMxOhM3NxDVQsUud2xayAq06aIjwUplZJucnmkevjxDeUhK3ur6WIGWenSzPIsTYzQ
	 M7IkpBx0obHaQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 06/28] block: Remember zone capacity when revalidating zones
Date: Mon, 25 Mar 2024 13:44:30 +0900
Message-ID: <20240325044452.3125418-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240325044452.3125418-1-dlemoal@kernel.org>
References: <20240325044452.3125418-1-dlemoal@kernel.org>
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

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c      | 15 +++++++++++++++
 include/linux/blkdev.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index da0f4b2a8fa0..88110a1329cd 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -438,6 +438,7 @@ struct blk_revalidate_zone_args {
 	unsigned long	*conv_zones_bitmap;
 	unsigned long	*seq_zones_wlock;
 	unsigned int	nr_zones;
+	unsigned int	zone_capacity;
 	sector_t	sector;
 };
 
@@ -500,6 +501,18 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
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
@@ -597,6 +610,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 		disk->nr_zones = args.nr_zones;
 		swap(disk->seq_zones_wlock, args.seq_zones_wlock);
 		swap(disk->conv_zones_bitmap, args.conv_zones_bitmap);
+		disk->zone_capacity = args.zone_capacity;
 		if (update_driver_data)
 			update_driver_data(disk);
 		ret = 0;
@@ -608,6 +622,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 
 	kfree(args.seq_zones_wlock);
 	kfree(args.conv_zones_bitmap);
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(blk_revalidate_disk_zones);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 93f93f352b54..b57244ee74f0 100644
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

