Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF24928DC8;
	Fri,  5 Apr 2024 04:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712292141; cv=none; b=opW++wETkdsXD2Cm7wXeD94WLRQFbZVfrwEkomNtEmDjgJSRLxs/ubrWQkNtRKauitAB9BXZ6ZGSyCXn5R+coGk7VPoItLdAxqmL1OgVHI4Q0o6sIYR9aDrUjvoffrw+/FvLRt0eBi8M+bQ5YXZpbSjHNsbqfX11rZN1X6eQDdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712292141; c=relaxed/simple;
	bh=mpcFRXoG1iMUnEM0OJum7HEVIuA8He6TG6rQRr9K+4k=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3ElMhxg/GPC/ghQGI92POGdt4OLjfTkEf9yLoxWgIgtha7NenQmpR967Jw/mY0Z+xHZmzHN9IW+y6J3Kj0MCNZLkG0VteWErIKy+aPJeb8AxXxyqU4WoQViNA3whqtIaPlit7wsOtXkBUB5Cy10Gk+oHeKXamcpu0fm5ouZRTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=At2cEnKt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="At2cEnKt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38B25C433F1;
	Fri,  5 Apr 2024 04:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712292141;
	bh=mpcFRXoG1iMUnEM0OJum7HEVIuA8He6TG6rQRr9K+4k=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=At2cEnKt2L9Q9vb2PetC3IFEmYbwWZOJGbncRBPJLIxLO4tWws+3EE1FXt0Rj2IiY
	 x6YB585F/YTFBfOLlRZVt6XhHfxbt4q/SI1oG6yIgVPFf+2bC8F/gHqlg3J0ecf7s7
	 +90qAIpdkPhqsnBGVPI3minHNA/TFct4SvW/+sWSKjV6H3XixirLS3F/9aIICEDM08
	 EjlvtZuviOnAqqp1PYXjizFuAp68GVEg2Y20r62msdDCH4pjL3BAfzrt2Ql33/eRzj
	 MyOOEBx8HHsqRE2zaAVzVVKtzAJ/n6sDYebZFkbU4KxtgInlfRZuJM1NQcatf6r+TT
	 XN6PA0r9tvROA==
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
Subject: [PATCH v6 08/28] block: Fake max open zones limit when there is no limit
Date: Fri,  5 Apr 2024 13:41:47 +0900
Message-ID: <20240405044207.1123462-9-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240405044207.1123462-1-dlemoal@kernel.org>
References: <20240405044207.1123462-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For a zoned block device that has no limit on the number of open zones
and no limit on the number of active zones, the zone write plug mempool
is created with a size of 128 zone write plugs. For such case, set the
device max_open_zones queue limit to this value to indicate to the user
the potential performance penalty that may happen when writing
simultaneously to more zones than the mempool size.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
---
 block/blk-zoned.c | 41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index fefcebd70445..4b21a1ec00d4 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1503,6 +1503,38 @@ struct blk_revalidate_zone_args {
 	sector_t	sector;
 };
 
+/*
+ * Update the disk zone resources information and device queue limits.
+ * The disk queue is frozen when this is executed.
+ */
+static int disk_update_zone_resources(struct gendisk *disk,
+				      struct blk_revalidate_zone_args *args)
+{
+	struct request_queue *q = disk->queue;
+	struct queue_limits lim;
+
+	disk->nr_zones = args->nr_zones;
+	disk->zone_capacity = args->zone_capacity;
+	swap(disk->seq_zones_wlock, args->seq_zones_wlock);
+	swap(disk->conv_zones_bitmap, args->conv_zones_bitmap);
+
+	/*
+	 * If the device has no limit on the maximum number of open and active
+	 * zones, set its max open zone limit to the mempool size to indicate
+	 * to the user that there is a potential performance impact due to
+	 * dynamic zone write plug allocation when simultaneously writing to
+	 * more zones than the size of the mempool.
+	 */
+	if (disk->zone_wplugs_pool) {
+		lim = queue_limits_start_update(q);
+		if (!lim.max_open_zones && !lim.max_active_zones)
+			lim.max_open_zones = disk->zone_wplugs_pool->min_nr;
+		return queue_limits_commit_update(q, &lim);
+	}
+
+	return 0;
+}
+
 /*
  * Helper function to check the validity of zones of a zoned block device.
  */
@@ -1703,17 +1735,14 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 	 */
 	blk_mq_freeze_queue(q);
 	if (ret > 0) {
-		disk->nr_zones = args.nr_zones;
-		disk->zone_capacity = args.zone_capacity;
-		swap(disk->seq_zones_wlock, args.seq_zones_wlock);
-		swap(disk->conv_zones_bitmap, args.conv_zones_bitmap);
+		ret = disk_update_zone_resources(disk, &args);
 		if (update_driver_data)
 			update_driver_data(disk);
-		ret = 0;
 	} else {
 		pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
-		disk_free_zone_resources(disk);
 	}
+	if (ret)
+		disk_free_zone_resources(disk);
 	blk_mq_unfreeze_queue(q);
 
 	kfree(args.seq_zones_wlock);
-- 
2.44.0

