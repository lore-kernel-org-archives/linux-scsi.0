Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10E3B67F;
	Mon,  8 Apr 2024 01:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712540507; cv=none; b=JrX2KnPcLOhREk5LgtCdmJAKZOsdhNNc5bP6SJPjs40jFf1WYPzzpIzlHVzTwj7OoNG1/kzUatWcX1YwvDrQlyBR7ZCS3RL66C6uVY6aLF0uldG02wlPlyQaPAXblEtUgFkajbGE5YjW/T1vqfJMxV+dl3UABWXezRCQDx82mC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712540507; c=relaxed/simple;
	bh=Rwq2mnKZRd162vu4g/073SX1zLVjveI02uqeQ4ww6l4=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mChMjpG0azdsHnTiPwgksu+/MuPaabGIwENBeNoDpKnE3bxwaKGMhCyP6cpFj6ZlOfRdFWGCq958jugssMWBrf6/x9dG/IsoD7yW+83hKBvbBr0hea0yZnpwufAlvi48rC913OBYdDfLTvczkO260dOt5rFvQMkKqP0+xkW5H2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zs483dIr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zs483dIr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13E7C43390;
	Mon,  8 Apr 2024 01:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712540506;
	bh=Rwq2mnKZRd162vu4g/073SX1zLVjveI02uqeQ4ww6l4=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Zs483dIrLiA4486fSjxiTnmxvnrqtDh/9F5qkpN3ju8mybc92IiB9dPKl6HJDVI6c
	 mxKYId4piNgwM8+UZH06T1Epx6Vqj9vFkHt4Ptt6+/Jbp4Nf8ktT0Gsqo+6lZfNNO/
	 u3vSTgE4lGi759h2VYkp+7/FS74/4vYpTCmeTnJmffAP/AEhAyn34i706Uh8FV6t4m
	 oW06b/0nQmX5qiwB/exQcSDdGPZ0bOujysdL1MAC/CRJynEGIcjt8oelXR5cFTGJNU
	 Kze8OtJP5IWgPVVcTf4DWlnX5bA3I4yeh6Y/jpomv2Osh2qps/oDLfenkFks/kKA1A
	 FrnztyEVr+YQA==
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
Subject: [PATCH v7 08/28] block: Fake max open zones limit when there is no limit
Date: Mon,  8 Apr 2024 10:41:08 +0900
Message-ID: <20240408014128.205141-9-dlemoal@kernel.org>
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
Tested-by: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
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

