Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E626383CB6;
	Tue,  2 Apr 2024 12:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712061562; cv=none; b=BzjiMaHHnztNW8l9DHULDrfLwz35tpLNF20WHoPQAuYJS7LiVyXdSTeai9v3ZQEGbt97eNVGHhpNY0Lh7gr2cdrXMgy1lQTCIydljiDx++5pSyMFHRQYwEyAOU2O5Xe4ecuK4Hfy44fPvMcV2vWvTRG6sGUjQVMccIYHS/wh7wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712061562; c=relaxed/simple;
	bh=Hqzw09GXXQ6wdY2Xpar3ylvGox8b6gVEx9K9Mubf4ss=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UpqM2XjhDwx77b6GmeoWWLojMxTAEJoqx+3Qrw4RkADHwoLVayMndHEGZ9EtlDYzIKfcms7VisOWOFgx4B5UgvAZnMN6N9taWhSVW8ttYHQbbBAkwP9SjkZ9jjdONBvJWOT7755RpPmCY5Z7E092uRFEQJQ2ew84mDZEtSBDs/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p+wyCe3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p+wyCe3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A91C43394;
	Tue,  2 Apr 2024 12:39:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712061561;
	bh=Hqzw09GXXQ6wdY2Xpar3ylvGox8b6gVEx9K9Mubf4ss=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=p+wyCe3PPaDNesKXcjrVkO4t2kb7tEhWe0KDfbv4AVgoQ4FQPiIIrU6Nnl27EEK97
	 00OuTv/FAOyKch8f01jum2NlOQiz+iIlhA1rKRmciFnZzHf0yQ1cBP+54scFpSSUOw
	 ewg0xcBO5aXGprti+IVr1t1Ne3I9gSzCeU/JCVUM/lB5s9d0o2uTPcfTo5MZzk/uNN
	 r7sAvFqwI6Ca+uZgeo3Pkb74lmXHB5pqBH2Lmotsu2hFwROithQnLYyDK8OhRmB6uw
	 hVyixQ2nzIl6L6n4CF4zxV/czWJjxaEe4UEpYKKBtEMFWtyGqFw5TzkVas44G0qGvB
	 TohZ/KkcVHiPw==
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
Subject: [PATCH v4 08/28] block: Fake max open zones limit when there is no limit
Date: Tue,  2 Apr 2024 21:38:47 +0900
Message-ID: <20240402123907.512027-9-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240402123907.512027-1-dlemoal@kernel.org>
References: <20240402123907.512027-1-dlemoal@kernel.org>
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
index c6130f17f359..1c713a258ff2 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1519,6 +1519,38 @@ struct blk_revalidate_zone_args {
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
@@ -1719,17 +1751,14 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
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

