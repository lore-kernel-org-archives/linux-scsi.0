Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085DB1C322D;
	Mon, 25 Mar 2024 04:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711341916; cv=none; b=nhfRx7kH5z8QWAAZKA4/2Rbmh/NWkk1/o8oe4Ni8yhuA1EdwmK/ldzrdkYX0Dp6a6vIlmLz3d+xWFz8gavDqopRsDgsNa5iXh48qP8IViVD/EgNRsLb9Uw7cWlEQu30MoJ8jAdToKVlDflgRVSCIkLoxnwVg2T/B0E5bCSP8IIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711341916; c=relaxed/simple;
	bh=LIdQq+Zpk4R/zJzqbg4N/OAThIu3sAW/GQHQEGs4ejY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHKAdYZT2D4K16ushVGqzqqTo7PuO8k2Fy3ONvkb/LoEHhCuTJM3Q+x+n0RNPOA01HUuyJWL348i9XlAvYhoQEw/yGNGxSC1SnxJzKEwshgW94UmaaDFG7zTaw9/FpWIgZ76/zmWVkSEqiZxnrRBk+IGEdwW5CEDnAdGdgvh7yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=usyDGePG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="usyDGePG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 147CFC43390;
	Mon, 25 Mar 2024 04:45:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711341915;
	bh=LIdQq+Zpk4R/zJzqbg4N/OAThIu3sAW/GQHQEGs4ejY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=usyDGePGcbgZCM8ZDEKtcXiN6NkRet0PlPD7/ATSUt8iLgbGiH05g6q6oyhcX17Xn
	 xx7Ujm4ojS5pZUM/1/K4KIxgw7ybvSGEJxJ6O25kaoWNSWXegvk37FIejTPfK4oMGn
	 6wLcVXIzGGeW/UIbzgoj4/VYeUvzZOP29gToOtAeOV86of9zF0qWnVK7WHiGylTCal
	 8DoQD4UuafgGBebqy8PGDBa2yWAgprXqN3u5oHaJ6KVGtFL+TMr7PaLbN0CpTtBLVA
	 X2cwsJPfWbqaBuE3BXLT3/5dJWdavF6CsJKvWBWKPufYupjjpgPl5Gu9BI03OugCD3
	 4Hoj8WcEhe6DQ==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 10/28] block: Allow zero value of max_zone_append_sectors queue limit
Date: Mon, 25 Mar 2024 13:44:34 +0900
Message-ID: <20240325044452.3125418-11-dlemoal@kernel.org>
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

In preparation for adding a generic zone append emulation using zone
write plugging, allow device drivers supporting zoned block device to
set a the max_zone_append_sectors queue limit of a device to 0 to
indicate the lack of native support for zone append operations and that
the block layer should emulate these operations using regular write
operations.

blk_queue_max_zone_append_sectors() is modified to allow passing 0 as
the max_zone_append_sectors argument. The function
queue_max_zone_append_sectors() is also modified to ensure that the
minimum of the max_hw_sectors and chunk_sectors limit is used whenever
the max_zone_append_sectors limit is 0. This minimum is consistent with
the value set for the max_zone_append_sectors limit by the function
blk_validate_zoned_limits() when limits for a queue are validated.

The helper functions queue_emulates_zone_append() and
bdev_emulates_zone_append() are added to test if a queue (or block
device) emulates zone append operations.

In order for blk_revalidate_disk_zones() to accept zoned block devices
relying on zone append emulation, the direct check to the
max_zone_append_sectors queue limit of the disk is replaced by a check
using the value returned by queue_max_zone_append_sectors(). Similarly,
queue_zone_append_max_show() is modified to use the same accessor so
that the sysfs attribute advertizes the non-zero limit that will be
used, regardless if it is for native or emulated commands.

For stacking drivers, a top device should not need to care if the
underlying devices have native or emulated zone append operations.
blk_stack_limits() is thus modified to set the top device
max_zone_append_sectors limit using the new accessor
queue_limits_max_zone_append_sectors(). queue_max_zone_append_sectors()
is modified to use this function as well. Stacking drivers that require
zone append emulation, e.g. dm-crypt, can still request this feature by
calling blk_queue_max_zone_append_sectors() with a 0 limit.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 block/blk-core.c       |  2 +-
 block/blk-settings.c   | 30 +++++++++++++++++++-----------
 block/blk-sysfs.c      |  2 +-
 block/blk-zoned.c      |  2 +-
 include/linux/blkdev.h | 23 ++++++++++++++++++++---
 5 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index b6bc1978207d..c6d41e1c7a0a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -602,7 +602,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 		return BLK_STS_IOERR;
 
 	/* Make sure the BIO is small enough and will not get split */
-	if (nr_sectors > q->limits.max_zone_append_sectors)
+	if (nr_sectors > queue_max_zone_append_sectors(q))
 		return BLK_STS_IOERR;
 
 	bio->bi_opf |= REQ_NOMERGE;
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 3c7d8d638ab5..82c61d2e4bb8 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -413,24 +413,32 @@ EXPORT_SYMBOL(blk_queue_max_write_zeroes_sectors);
  * blk_queue_max_zone_append_sectors - set max sectors for a single zone append
  * @q:  the request queue for the device
  * @max_zone_append_sectors: maximum number of sectors to write per command
+ *
+ * Sets the maximum number of sectors allowed for zone append commands. If
+ * Specifying 0 for @max_zone_append_sectors indicates that the queue does
+ * not natively support zone append operations and that the block layer must
+ * emulate these operations using regular writes.
  **/
 void blk_queue_max_zone_append_sectors(struct request_queue *q,
 		unsigned int max_zone_append_sectors)
 {
-	unsigned int max_sectors;
+	unsigned int max_sectors = 0;
 
 	if (WARN_ON(!blk_queue_is_zoned(q)))
 		return;
 
-	max_sectors = min(q->limits.max_hw_sectors, max_zone_append_sectors);
-	max_sectors = min(q->limits.chunk_sectors, max_sectors);
+	if (max_zone_append_sectors) {
+		max_sectors = min(q->limits.max_hw_sectors,
+				  max_zone_append_sectors);
+		max_sectors = min(q->limits.chunk_sectors, max_sectors);
 
-	/*
-	 * Signal eventual driver bugs resulting in the max_zone_append sectors limit
-	 * being 0 due to a 0 argument, the chunk_sectors limit (zone size) not set,
-	 * or the max_hw_sectors limit not set.
-	 */
-	WARN_ON(!max_sectors);
+		/*
+		 * Signal eventual driver bugs resulting in the max_zone_append
+		 * sectors limit being 0 due to the chunk_sectors limit (zone
+		 * size) not set or the max_hw_sectors limit not set.
+		 */
+		WARN_ON_ONCE(!max_sectors);
+	}
 
 	q->limits.max_zone_append_sectors = max_sectors;
 }
@@ -757,8 +765,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->max_dev_sectors = min_not_zero(t->max_dev_sectors, b->max_dev_sectors);
 	t->max_write_zeroes_sectors = min(t->max_write_zeroes_sectors,
 					b->max_write_zeroes_sectors);
-	t->max_zone_append_sectors = min(t->max_zone_append_sectors,
-					b->max_zone_append_sectors);
+	t->max_zone_append_sectors = min(queue_limits_max_zone_append_sectors(t),
+					 queue_limits_max_zone_append_sectors(b));
 	t->bounce = max(t->bounce, b->bounce);
 
 	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask,
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 8c8f69d8ba48..e3ed5a921aff 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -224,7 +224,7 @@ static ssize_t queue_zone_write_granularity_show(struct request_queue *q,
 
 static ssize_t queue_zone_append_max_show(struct request_queue *q, char *page)
 {
-	unsigned long long max_sectors = q->limits.max_zone_append_sectors;
+	unsigned long long max_sectors = queue_max_zone_append_sectors(q);
 
 	return sprintf(page, "%llu\n", max_sectors << SECTOR_SHIFT);
 }
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 33dea8ca9a6f..27ea88e976c2 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1629,7 +1629,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 		return -ENODEV;
 	}
 
-	if (!q->limits.max_zone_append_sectors) {
+	if (!queue_max_zone_append_sectors(q)) {
 		pr_warn("%s: Invalid 0 maximum zone append limit\n",
 			disk->disk_name);
 		return -ENODEV;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8eb99cab7221..916334f173a2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1177,12 +1177,29 @@ static inline unsigned int queue_max_segment_size(const struct request_queue *q)
 	return q->limits.max_segment_size;
 }
 
-static inline unsigned int queue_max_zone_append_sectors(const struct request_queue *q)
+static inline unsigned int queue_limits_max_zone_append_sectors(struct queue_limits *l)
 {
+	unsigned int max_sectors = min(l->chunk_sectors, l->max_hw_sectors);
 
-	const struct queue_limits *l = &q->limits;
+	return min_not_zero(l->max_zone_append_sectors, max_sectors);
+}
+
+static inline unsigned int queue_max_zone_append_sectors(struct request_queue *q)
+{
+	if (!blk_queue_is_zoned(q))
+		return 0;
 
-	return min(l->max_zone_append_sectors, l->max_sectors);
+	return queue_limits_max_zone_append_sectors(&q->limits);
+}
+
+static inline bool queue_emulates_zone_append(struct request_queue *q)
+{
+	return blk_queue_is_zoned(q) && !q->limits.max_zone_append_sectors;
+}
+
+static inline bool bdev_emulates_zone_append(struct block_device *bdev)
+{
+	return queue_emulates_zone_append(bdev_get_queue(bdev));
 }
 
 static inline unsigned int
-- 
2.44.0

