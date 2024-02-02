Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A861863E;
	Fri,  2 Feb 2024 07:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859077; cv=none; b=S3uQifVutf0zc4fD4e4WYFilOfq+zIoKLroMv4/F12ggu+RYgtIjPyYqUTk5dda85lhPLVCcMY2JBVioSOeIUGrDixwamdn4c+t2sO/DXfYI1GUzb1E7rXhNscoIcwd4LAoKx7u7qvbNQUmX+d1Rjdr26WC7afy0gMT7Kng8tpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859077; c=relaxed/simple;
	bh=vyZGJ9J0L+X6l9xUWRlmHuosOENBaoWSKksg8LPn29M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p1OvhmxdnKoagQaOjweS7Hf2obxI4bKIcUSnzgdh23TJgczyZat/OG764nFDwA47m5zgFpTKWTY4UYZG3l8Bu4rOY/bDblEp6RkKwNUGVb40pQKoPf2QCKRgJlwTl/qU7iFQl2sB1oRMpCjR4zlOiWNbHLR1NEg87T+ux/rkpkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UgCeR10N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UgCeR10N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 364B4C433A6;
	Fri,  2 Feb 2024 07:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859077;
	bh=vyZGJ9J0L+X6l9xUWRlmHuosOENBaoWSKksg8LPn29M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgCeR10NgR1woyTTyeI4VBtbwIOgc049ma+KdE7qcU3jJ0dr9TfpBXGfR4AdS0fCf
	 SHvXH8KepW/Em3j83zeupaMXTzMKCA4b5Q3tpRp4jTF1k85r1kAbTOp3E7tWg2x4zZ
	 FYBW4A1NiM9GIU40MoyIv3CYhwU0vLJWjhE4Yc0qTFsm73SP4fkCOUJXlQDt0iSVj2
	 IoFwZlGcui0y2mlfAyu6lVYyLiWlai3IlNTRy9kLFoMTBCHpC4uwL/XZ3HqDh7Nm/c
	 BJ1XbEVqXgZfzL1ex/PtxxjLoBDlIuN2mdhIZepSwhxRV0yJF2DwSGYka6kN2HtNav
	 hlfDWk4Tfeu4A==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 07/26] block: Allow zero value of max_zone_append_sectors queue limit
Date: Fri,  2 Feb 2024 16:30:45 +0900
Message-ID: <20240202073104.2418230-8-dlemoal@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240202073104.2418230-1-dlemoal@kernel.org>
References: <20240202073104.2418230-1-dlemoal@kernel.org>
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
minimum of the max_sectors and chunk_sectors limit is used whenever the
max_zone_append_sectors limit is 0.

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
---
 block/blk-core.c       |  2 +-
 block/blk-settings.c   | 35 +++++++++++++++++++++++------------
 block/blk-sysfs.c      |  2 +-
 block/blk-zoned.c      |  2 +-
 include/linux/blkdev.h | 20 +++++++++++++++++---
 5 files changed, 43 insertions(+), 18 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 71c6614a97fe..3945cfcc4d9b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -590,7 +590,7 @@ static inline blk_status_t blk_check_zone_append(struct request_queue *q,
 		return BLK_STS_IOERR;
 
 	/* Make sure the BIO is small enough and will not get split */
-	if (nr_sectors > q->limits.max_zone_append_sectors)
+	if (nr_sectors > queue_max_zone_append_sectors(q))
 		return BLK_STS_IOERR;
 
 	bio->bi_opf |= REQ_NOMERGE;
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 06ea91e51b8b..f00bcb595444 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -211,24 +211,32 @@ EXPORT_SYMBOL(blk_queue_max_write_zeroes_sectors);
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
-
-	/*
-	 * Signal eventual driver bugs resulting in the max_zone_append sectors limit
-	 * being 0 due to a 0 argument, the chunk_sectors limit (zone size) not set,
-	 * or the max_hw_sectors limit not set.
-	 */
-	WARN_ON(!max_sectors);
+	if (max_zone_append_sectors) {
+		max_sectors = min(q->limits.max_hw_sectors,
+				  max_zone_append_sectors);
+		max_sectors = min(q->limits.chunk_sectors, max_sectors);
+
+		/*
+		 * Signal eventual driver bugs resulting in the max_zone_append
+		 * sectors limit being 0 due to the chunk_sectors limit (zone
+		 * size) not set or the max_hw_sectors limit not set.
+		 */
+		WARN_ON(!max_sectors);
+	}
 
 	q->limits.max_zone_append_sectors = max_sectors;
 }
@@ -563,8 +571,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->max_dev_sectors = min_not_zero(t->max_dev_sectors, b->max_dev_sectors);
 	t->max_write_zeroes_sectors = min(t->max_write_zeroes_sectors,
 					b->max_write_zeroes_sectors);
-	t->max_zone_append_sectors = min(t->max_zone_append_sectors,
-					b->max_zone_append_sectors);
+	t->max_zone_append_sectors = min(queue_limits_max_zone_append_sectors(t),
+					 queue_limits_max_zone_append_sectors(b));
 	t->bounce = max(t->bounce, b->bounce);
 
 	t->seg_boundary_mask = min_not_zero(t->seg_boundary_mask,
@@ -689,6 +697,9 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->zone_write_granularity = max(t->zone_write_granularity,
 					b->zone_write_granularity);
 	t->zoned = max(t->zoned, b->zoned);
+	if (!t->zoned)
+		t->max_zone_append_sectors = 0;
+
 	return ret;
 }
 EXPORT_SYMBOL(blk_stack_limits);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 6b2429cad81a..89c41dcd8bc4 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -218,7 +218,7 @@ static ssize_t queue_zone_write_granularity_show(struct request_queue *q,
 
 static ssize_t queue_zone_append_max_show(struct request_queue *q, char *page)
 {
-	unsigned long long max_sectors = q->limits.max_zone_append_sectors;
+	unsigned long long max_sectors = queue_max_zone_append_sectors(q);
 
 	return sprintf(page, "%llu\n", max_sectors << SECTOR_SHIFT);
 }
diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index f6d4f511b664..661ef61ca3b1 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -946,7 +946,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 		return -ENODEV;
 	}
 
-	if (!q->limits.max_zone_append_sectors) {
+	if (!queue_max_zone_append_sectors(q)) {
 		pr_warn("%s: Invalid 0 maximum zone append limit\n",
 			disk->disk_name);
 		return -ENODEV;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d58aaed6dc24..87fba5af34ba 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1137,12 +1137,26 @@ static inline unsigned int queue_max_segment_size(const struct request_queue *q)
 	return q->limits.max_segment_size;
 }
 
-static inline unsigned int queue_max_zone_append_sectors(const struct request_queue *q)
+static inline unsigned int queue_limits_max_zone_append_sectors(struct queue_limits *l)
 {
+	unsigned int max_sectors = min(l->chunk_sectors, l->max_sectors);
 
-	const struct queue_limits *l = &q->limits;
+	return min_not_zero(l->max_zone_append_sectors, max_sectors);
+}
+
+static inline unsigned int queue_max_zone_append_sectors(struct request_queue *q)
+{
+	return queue_limits_max_zone_append_sectors(&q->limits);
+}
 
-	return min(l->max_zone_append_sectors, l->max_sectors);
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
2.43.0

