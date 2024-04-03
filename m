Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE71C73510;
	Wed,  3 Apr 2024 08:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712133782; cv=none; b=DAG6z2URsL4SVsPRhu6Voz6x/kTot+FTtaaLINtF5AlkoH7S5dloHnhM5+XEO77eVEyuXj85dXs5QEWj0BhcsJCGENkmvkh7W0qwY7GTxc37Gjnyzv8h+1/hO16k1BrB6wwgKulp4SwO5CHGjkro6wrMGPda3xCR0IFmvr1AGgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712133782; c=relaxed/simple;
	bh=wVo0ZqXyRzJKUABEP7Wolj7hvAogx2h4xbYsKoizMIc=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JLWLEwj6CQ538V/XDOFWgiPDrJLdU6r5XNEaXQj4TCXFbdpbjFsTqprgXni5Vx5ed4p2O4+AQ6DWCxLfmofo4Higv8m5YOV59tPSOAK2IWBMFyk6DCziwnFHQecjGLmlZg7evNTuU6K54QpQjFKq7XfwxcJOOPeZuvl4CDf/ius=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h3HS7ds6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h3HS7ds6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FD4EC433B1;
	Wed,  3 Apr 2024 08:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712133782;
	bh=wVo0ZqXyRzJKUABEP7Wolj7hvAogx2h4xbYsKoizMIc=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=h3HS7ds6U9vEVten47VBvzx6pmp7xIcTCneulCOOE0MH8Ly/t38+Z4U1dLJrJiMBm
	 DpYux/JqvCpjsfOT67r1v8OGnNbYTVgRF04JuysjcZrKFguq+OaeYcvTc52A/4BGqK
	 Xr7MzTTLYRqpfLH+wBp+XfptAW8JovG1hdvxHfNAsDzHnb2kie+PCUDeGS8ecLvK3y
	 NQPPhZAopovdkzKeF7wdT4m2/Ra0SEs5wjSZNGuMU7beM9fEd/rYsgT1SRj4ehg05W
	 Rg1UyjH0tJQuYPv3nLCXiEfLZkdV8JFYmg0HroIWFfjNOcAgmAshOUNLtqkSwJDjtx
	 3qskh1Wzgx03Q==
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
Subject: [PATCH v5 08/28] block: Fake max open zones limit when there is no limit
Date: Wed,  3 Apr 2024 17:42:27 +0900
Message-ID: <20240403084247.856481-9-dlemoal@kernel.org>
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

For a zoned block device that has no limit on the number of open zones
and no limit on the number of active zones, the zone write plug mempool
is created with a size of 128 zone write plugs. For such case, set the
device max_open_zones queue limit to this value to indicate to the user
the potential performance penalty that may happen when writing
simultaneously to more zones than the mempool size.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c | 41 +++++++++++++++++++++++++++++++++++------
 1 file changed, 35 insertions(+), 6 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 9c9600642299..3dceeaaeb973 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1502,6 +1502,38 @@ struct blk_revalidate_zone_args {
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
@@ -1702,17 +1734,14 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
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

