Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEFB282F1;
	Fri,  2 Feb 2024 07:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706859087; cv=none; b=mKzgWbpng27d2aQsk9raBDEEhTON1Ia7wlorMeOyWT9NTAnpxlK1pXrcyS4R0FAQGfVYlxfwtFEa9mpl7lLOc7vM2TX/A81T69+iDtV/KSMUlAg/8iG+s2MxEdt6wAtkwQE6r1UQ5C0y0RHJBZFuy9DisVLhMny+gqhFlUAUbM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706859087; c=relaxed/simple;
	bh=k9B30fkHwRlFd2KKzAM/vyQLWAOu3M6hwLCBjpDEDzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+Vr1uaeirASYSnm1O3IlofkBUzN4AOHIVsS4/WUV8hCyAaIlEOr1Echju0hyC6UVpjFmxOeii2ScDXJis8LTSHL4v8LDVszE4QXlE6Ah4YjnARePOqlkabZzYLpBPnLu5k+9gbSrkfr8btxDbxTWSbhA6lC1jrSK2AI11CYgR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jPVvIAXZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jPVvIAXZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F7EC43390;
	Fri,  2 Feb 2024 07:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1706859087;
	bh=k9B30fkHwRlFd2KKzAM/vyQLWAOu3M6hwLCBjpDEDzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPVvIAXZwLKQtw9cVAOKktO1BgesMHUn9Tllo0PzQYvOILE2NaEMQriKLkQ/gVoZx
	 yMNy4TOUqruTxlsYVabSMHETIxLz3xbq/CpoDCSzROYwdYDYYMZcskxVBIk0IxYOB+
	 OrRVpWGn1e4IyKbDkGNGpiQJHwHY8byJy7IqEmZKNovPq3UVa7zKIejzNICLnbfEjU
	 2QYL/HLRMeIfH88si+L+MP7kejvXlRRoWAaOaRwh5im+7Iux9VGf6wS4fW081NKemc
	 wDgR9YgaLlycCJOpuPW1OqXn/36VJX/UIsFpAKX+8lYDU39NPv1/QEgHL2bwmGEBwQ
	 ks8cBsCHQfOQg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/26] null_blk: Introduce zone_append_max_sectors attribute
Date: Fri,  2 Feb 2024 16:30:52 +0900
Message-ID: <20240202073104.2418230-15-dlemoal@kernel.org>
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

Add the zone_append_max_sectors configfs attribute and module parameter
to allow configuring the maximum number of 512B sectors of zone append
operations. This attribute is meaningful only for zoned null block
devices.

If not specified, the default is unchanged and the zoned device max
append sectors limit is set to the device max sectors limit.
If a non 0 value is used for this attribute, which is the default,
then native support for zone append operations is enabled.
Setting a 0 value disables native zone append operations support to
instead use the block layer emulation.

null_submit_bio() is modified to use blk_zone_write_plug_bio() to
handle zone append emulation if that is enabled.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/block/null_blk/main.c     | 40 +++++++++++++++++++++----------
 drivers/block/null_blk/null_blk.h |  1 +
 drivers/block/null_blk/zoned.c    | 31 ++++++++++++++++++------
 3 files changed, 52 insertions(+), 20 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 514c2592046a..c294792fc451 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -241,6 +241,11 @@ static unsigned int g_zone_max_active;
 module_param_named(zone_max_active, g_zone_max_active, uint, 0444);
 MODULE_PARM_DESC(zone_max_active, "Maximum number of active zones when block device is zoned. Default: 0 (no limit)");
 
+static int g_zone_append_max_sectors = INT_MAX;
+module_param_named(zone_append_max_sectors, g_zone_append_max_sectors, int, 0444);
+MODULE_PARM_DESC(zone_append_max_sectors,
+		 "Maximum size of a zone append command (in 512B sectors). Specify 0 for zone append emulation");
+
 static struct nullb_device *null_alloc_dev(void);
 static void null_free_dev(struct nullb_device *dev);
 static void null_del_dev(struct nullb *nullb);
@@ -424,6 +429,7 @@ NULLB_DEVICE_ATTR(zone_capacity, ulong, NULL);
 NULLB_DEVICE_ATTR(zone_nr_conv, uint, NULL);
 NULLB_DEVICE_ATTR(zone_max_open, uint, NULL);
 NULLB_DEVICE_ATTR(zone_max_active, uint, NULL);
+NULLB_DEVICE_ATTR(zone_append_max_sectors, uint, NULL);
 NULLB_DEVICE_ATTR(virt_boundary, bool, NULL);
 NULLB_DEVICE_ATTR(no_sched, bool, NULL);
 NULLB_DEVICE_ATTR(shared_tag_bitmap, bool, NULL);
@@ -567,6 +573,7 @@ static struct configfs_attribute *nullb_device_attrs[] = {
 	&nullb_device_attr_zone_nr_conv,
 	&nullb_device_attr_zone_max_open,
 	&nullb_device_attr_zone_max_active,
+	&nullb_device_attr_zone_append_max_sectors,
 	&nullb_device_attr_zone_readonly,
 	&nullb_device_attr_zone_offline,
 	&nullb_device_attr_virt_boundary,
@@ -656,7 +663,8 @@ static ssize_t memb_group_features_show(struct config_item *item, char *page)
 			"poll_queues,power,queue_mode,shared_tag_bitmap,size,"
 			"submit_queues,use_per_node_hctx,virt_boundary,zoned,"
 			"zone_capacity,zone_max_active,zone_max_open,"
-			"zone_nr_conv,zone_offline,zone_readonly,zone_size\n");
+			"zone_nr_conv,zone_offline,zone_readonly,zone_size,"
+			"zone_append_max_sectors\n");
 }
 
 CONFIGFS_ATTR_RO(memb_group_, features);
@@ -736,6 +744,7 @@ static struct nullb_device *null_alloc_dev(void)
 	dev->zone_nr_conv = g_zone_nr_conv;
 	dev->zone_max_open = g_zone_max_open;
 	dev->zone_max_active = g_zone_max_active;
+	dev->zone_append_max_sectors = g_zone_append_max_sectors;
 	dev->virt_boundary = g_virt_boundary;
 	dev->no_sched = g_no_sched;
 	dev->shared_tag_bitmap = g_shared_tag_bitmap;
@@ -1528,14 +1537,19 @@ static struct nullb_queue *nullb_to_queue(struct nullb *nullb)
 
 static void null_submit_bio(struct bio *bio)
 {
-	struct nullb_queue *nq =
-		nullb_to_queue(bio->bi_bdev->bd_disk->private_data);
+	struct gendisk *disk = bio->bi_bdev->bd_disk;
+	struct nullb_queue *nq = nullb_to_queue(disk->private_data);
 
 	/* Respect the queue limits */
 	bio = bio_split_to_limits(bio);
 	if (!bio)
 		return;
 
+	/* Use zone write plugging to emulate zone append. */
+	if (queue_emulates_zone_append(disk->queue) &&
+	    blk_zone_write_plug_bio(bio, 0))
+		return;
+
 	null_handle_cmd(alloc_cmd(nq, bio), bio->bi_iter.bi_sector,
 			bio_sectors(bio), bio_op(bio));
 }
@@ -2168,12 +2182,6 @@ static int null_add_dev(struct nullb_device *dev)
 		blk_queue_write_cache(nullb->q, true, true);
 	}
 
-	if (dev->zoned) {
-		rv = null_init_zoned_dev(dev, nullb->q);
-		if (rv)
-			goto out_cleanup_disk;
-	}
-
 	nullb->q->queuedata = nullb;
 	blk_queue_flag_set(QUEUE_FLAG_NONROT, nullb->q);
 
@@ -2181,7 +2189,7 @@ static int null_add_dev(struct nullb_device *dev)
 	rv = ida_alloc(&nullb_indexes, GFP_KERNEL);
 	if (rv < 0) {
 		mutex_unlock(&lock);
-		goto out_cleanup_zone;
+		goto out_cleanup_disk;
 	}
 	nullb->index = rv;
 	dev->index = rv;
@@ -2195,6 +2203,12 @@ static int null_add_dev(struct nullb_device *dev)
 	if (dev->virt_boundary)
 		blk_queue_virt_boundary(nullb->q, PAGE_SIZE - 1);
 
+	if (dev->zoned) {
+		rv = null_init_zoned_dev(dev, nullb->q);
+		if (rv)
+			goto out_ida_free;
+	}
+
 	null_config_discard(nullb);
 
 	if (config_item_name(&dev->group.cg_item)) {
@@ -2207,7 +2221,7 @@ static int null_add_dev(struct nullb_device *dev)
 
 	rv = null_gendisk_register(nullb);
 	if (rv)
-		goto out_ida_free;
+		goto out_cleanup_zone;
 
 	mutex_lock(&lock);
 	list_add_tail(&nullb->list, &nullb_list);
@@ -2217,10 +2231,10 @@ static int null_add_dev(struct nullb_device *dev)
 
 	return 0;
 
-out_ida_free:
-	ida_free(&nullb_indexes, nullb->index);
 out_cleanup_zone:
 	null_free_zoned_dev(dev);
+out_ida_free:
+	ida_free(&nullb_indexes, nullb->index);
 out_cleanup_disk:
 	put_disk(nullb->disk);
 out_cleanup_tags:
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index 929f659dd255..8001e398a016 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -99,6 +99,7 @@ struct nullb_device {
 	unsigned int zone_nr_conv; /* number of conventional zones */
 	unsigned int zone_max_open; /* max number of open zones */
 	unsigned int zone_max_active; /* max number of active zones */
+	unsigned int zone_append_max_sectors; /* Max sectors per zone append command */
 	unsigned int submit_queues; /* number of submission queues */
 	unsigned int prev_submit_queues; /* number of submission queues before change */
 	unsigned int poll_queues; /* number of IOPOLL submission queues */
diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index f2cb6da0dd0d..dd418b174e03 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -61,6 +61,7 @@ static inline void null_unlock_zone(struct nullb_device *dev,
 int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 {
 	sector_t dev_capacity_sects, zone_capacity_sects;
+	sector_t zone_append_max_bytes;
 	struct nullb_zone *zone;
 	sector_t sector = 0;
 	unsigned int i;
@@ -102,6 +103,14 @@ int null_init_zoned_dev(struct nullb_device *dev, struct request_queue *q)
 			dev->zone_nr_conv);
 	}
 
+	dev->zone_append_max_sectors =
+		min(dev->zone_append_max_sectors, queue_max_sectors(q));
+	zone_append_max_bytes =
+		ALIGN_DOWN(dev->zone_append_max_sectors << SECTOR_SHIFT,
+			   dev->blocksize);
+	dev->zone_append_max_sectors =
+		min(zone_append_max_bytes >> SECTOR_SHIFT, zone_capacity_sects);
+
 	/* Max active zones has to be < nbr of seq zones in order to be enforceable */
 	if (dev->zone_max_active >= dev->nr_zones - dev->zone_nr_conv) {
 		dev->zone_max_active = 0;
@@ -158,17 +167,22 @@ int null_register_zoned_dev(struct nullb *nullb)
 {
 	struct nullb_device *dev = nullb->dev;
 	struct request_queue *q = nullb->q;
+	struct gendisk *disk = nullb->disk;
 
-	disk_set_zoned(nullb->disk);
+	disk_set_zoned(disk);
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
 	blk_queue_chunk_sectors(q, dev->zone_size_sects);
-	nullb->disk->nr_zones = bdev_nr_zones(nullb->disk->part0);
-	blk_queue_max_zone_append_sectors(q, dev->zone_size_sects);
-	disk_set_max_open_zones(nullb->disk, dev->zone_max_open);
-	disk_set_max_active_zones(nullb->disk, dev->zone_max_active);
+	disk->nr_zones = bdev_nr_zones(disk->part0);
+	blk_queue_max_zone_append_sectors(q, dev->zone_append_max_sectors);
+	disk_set_max_open_zones(disk, dev->zone_max_open);
+	disk_set_max_active_zones(disk, dev->zone_max_active);
+
+	pr_info("%s: using %s zone append\n",
+		disk->disk_name,
+		queue_emulates_zone_append(q) ? "emulated" : "native");
 
-	if (queue_is_mq(q))
-		return blk_revalidate_disk_zones(nullb->disk, NULL);
+	if (queue_is_mq(q) || queue_emulates_zone_append(q))
+		return blk_revalidate_disk_zones(disk, NULL);
 
 	return 0;
 }
@@ -369,6 +383,9 @@ static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 
 	trace_nullb_zone_op(cmd, zno, zone->cond);
 
+	if (WARN_ON_ONCE(append && !dev->zone_append_max_sectors))
+		return BLK_STS_IOERR;
+
 	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL) {
 		if (append)
 			return BLK_STS_IOERR;
-- 
2.43.0

