Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFABEC001DB
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Jun 2023 08:40:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjF3Ijv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Jun 2023 04:39:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232613AbjF3Ijo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 30 Jun 2023 04:39:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 764EA1FD8;
        Fri, 30 Jun 2023 01:39:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BD41616FA;
        Fri, 30 Jun 2023 08:39:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EE4C433CA;
        Fri, 30 Jun 2023 08:39:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688114382;
        bh=m3uYkFESO4SPXlo0dJapKHAXbaVHD0mlQ7CgJ6mKBHo=;
        h=From:To:Subject:Date:In-Reply-To:References:From;
        b=iubKeW11hXuhIHpy+/tgnneglGDNMCbUg8z5+Ju1HsoI+QUkfXCn6TQXX5kiIqxVx
         ivfKz0xcCA2Ei+6vukwpM0T4sNEmnDXtCK8Ai7/Jgi1DgIQOBGU3yM+j9JTexQn/g0
         PGOnU8Qz5qMdUxuaSgCflQr2v4KeaSJa2iL3QtIP78GZKW20aFyE1NaC2RwA3WCfqx
         9mdpN/FUN6NZjEk4tGRCDd6YbMShec7LIbR4UZbELQfIfb4wwbqSKX22ywl1wqmMJQ
         pWz5jsfdT+GKJFzxd8k+OtCKYKzxsGvh5UIqe1zoDu9BQk6l2U9gvBZCgbw1arnZSZ
         GnwxbBuJAXb/w==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 5/5] block: improve checks in blk_revalidate_disk_zones()
Date:   Fri, 30 Jun 2023 17:39:35 +0900
Message-ID: <20230630083935.433334-6-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230630083935.433334-1-dlemoal@kernel.org>
References: <20230630083935.433334-1-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk_revalidate_disk_zones() implements checks of the zones of a zoned
block device, verifying that the zone size is a power of 2 number of
sectors, that all zones (except possibly the last one) have the same
size and that zones cover the entire addressing space of the device.

While these checks are appropriate to verify that well tested hardware
devices have an adequate zone configurations, they lack in certain areas
which may result in issues with emulated devices implemented with user
drivers such as ublk or tcmu. Specifically, this function does not
check if the device driver indicated support for the mandatory zone
append writes, that is, if the device max_zone_append_sectors queue
limit is set to a non-zero value. Additionally, invalid zones such as
a zero length zone with a start sector equal to the device capacity will
not be detected and result in out of bounds use of the zone bitmaps
prepared with the callback function blk_revalidate_zone_cb().

Improve blk_revalidate_disk_zones() to address these inadequate checks,
relying on the fact that all device drivers supporting zoned block
devices must set the device zone size (chunk_sectors queue limit) and
the max_zone_append_sectors queue limit before executing this function.

The check for a non-zero max_zone_append_sectors value is done in
blk_revalidate_disk_zones() before executing the zone report. The zone
report callback function blk_revalidate_zone_cb() is also modified to
add a check that a zone start is below the device capacity.

The check that the zone size is a power of 2 number of sectors is moved
to blk_revalidate_disk_zones() as the zone size is already known.
Similarly, the number of zones of the device can be calculated in
blk_revalidate_disk_zones() before executing the zone report.

The kdoc comment for blk_revalidate_disk_zones() is also updated to
mention that device drivers must set the device zone size and the
max_zone_append_sectors queue limit before calling this function.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c | 86 +++++++++++++++++++++++++++--------------------
 1 file changed, 50 insertions(+), 36 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 0f9f97cdddd9..619ee41a51cc 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -442,7 +442,6 @@ struct blk_revalidate_zone_args {
 	unsigned long	*conv_zones_bitmap;
 	unsigned long	*seq_zones_wlock;
 	unsigned int	nr_zones;
-	sector_t	zone_sectors;
 	sector_t	sector;
 };
 
@@ -456,38 +455,34 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 	struct gendisk *disk = args->disk;
 	struct request_queue *q = disk->queue;
 	sector_t capacity = get_capacity(disk);
+	sector_t zone_sectors = q->limits.chunk_sectors;
+
+	/* Check for bad zones and holes in the zone report */
+	if (zone->start != args->sector) {
+		pr_warn("%s: Zone gap at sectors %llu..%llu\n",
+			disk->disk_name, args->sector, zone->start);
+		return -ENODEV;
+	}
+
+	if (zone->start >= capacity || !zone->len) {
+		pr_warn("%s: Invalid zone start %llu, length %llu\n",
+			disk->disk_name, zone->start, zone->len);
+		return -ENODEV;
+	}
 
 	/*
 	 * All zones must have the same size, with the exception on an eventual
 	 * smaller last zone.
 	 */
-	if (zone->start == 0) {
-		if (zone->len == 0 || !is_power_of_2(zone->len)) {
-			pr_warn("%s: Invalid zoned device with non power of two zone size (%llu)\n",
-				disk->disk_name, zone->len);
-			return -ENODEV;
-		}
-
-		args->zone_sectors = zone->len;
-		args->nr_zones = (capacity + zone->len - 1) >> ilog2(zone->len);
-	} else if (zone->start + args->zone_sectors < capacity) {
-		if (zone->len != args->zone_sectors) {
+	if (zone->start + zone->len < capacity) {
+		if (zone->len != zone_sectors) {
 			pr_warn("%s: Invalid zoned device with non constant zone size\n",
 				disk->disk_name);
 			return -ENODEV;
 		}
-	} else {
-		if (zone->len > args->zone_sectors) {
-			pr_warn("%s: Invalid zoned device with larger last zone size\n",
-				disk->disk_name);
-			return -ENODEV;
-		}
-	}
-
-	/* Check for holes in the zone report */
-	if (zone->start != args->sector) {
-		pr_warn("%s: Zone gap at sectors %llu..%llu\n",
-			disk->disk_name, args->sector, zone->start);
+	} else if (zone->len > zone_sectors) {
+		pr_warn("%s: Invalid zoned device with larger last zone size\n",
+			disk->disk_name);
 		return -ENODEV;
 	}
 
@@ -526,11 +521,13 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
  * @disk:	Target disk
  * @update_driver_data:	Callback to update driver data on the frozen disk
  *
- * Helper function for low-level device drivers to (re) allocate and initialize
- * a disk request queue zone bitmaps. This functions should normally be called
- * within the disk ->revalidate method for blk-mq based drivers.  For BIO based
- * drivers only q->nr_zones needs to be updated so that the sysfs exposed value
- * is correct.
+ * Helper function for low-level device drivers to check and (re) allocate and
+ * initialize a disk request queue zone bitmaps. This functions should normally
+ * be called within the disk ->revalidate method for blk-mq based drivers.
+ * Before calling this function, the device driver must already have set the
+ * device zone size (chunk_sector limit) and the max zone append limit.
+ * For BIO based drivers, this function cannot be used. BIO based device drivers
+ * only need to set disk->nr_zones so that the sysfs exposed value is correct.
  * If the @update_driver_data callback function is not NULL, the callback is
  * executed with the device request queue frozen after all zones have been
  * checked.
@@ -539,9 +536,9 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 			      void (*update_driver_data)(struct gendisk *disk))
 {
 	struct request_queue *q = disk->queue;
-	struct blk_revalidate_zone_args args = {
-		.disk		= disk,
-	};
+	sector_t zone_sectors = q->limits.chunk_sectors;
+	sector_t capacity = get_capacity(disk);
+	struct blk_revalidate_zone_args args = { };
 	unsigned int noio_flag;
 	int ret;
 
@@ -550,13 +547,31 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 	if (WARN_ON_ONCE(!queue_is_mq(q)))
 		return -EIO;
 
-	if (!get_capacity(disk))
-		return -EIO;
+	if (!capacity)
+		return -ENODEV;
+
+	/*
+	 * Checks that the device driver indicated a valid zone size and that
+	 * the max zone append limit is set.
+	 */
+	if (!zone_sectors || !is_power_of_2(zone_sectors)) {
+		pr_warn("%s: Invalid non power of two zone size (%llu)\n",
+			disk->disk_name, zone_sectors);
+		return -ENODEV;
+	}
+
+	if (!q->limits.max_zone_append_sectors) {
+		pr_warn("%s: Invalid 0 maximum zone append limit\n",
+			disk->disk_name);
+		return -ENODEV;
+	}
 
 	/*
 	 * Ensure that all memory allocations in this context are done as if
 	 * GFP_NOIO was specified.
 	 */
+	args.disk = disk;
+	args.nr_zones = (capacity + zone_sectors - 1) >> ilog2(zone_sectors);
 	noio_flag = memalloc_noio_save();
 	ret = disk->fops->report_zones(disk, 0, UINT_MAX,
 				       blk_revalidate_zone_cb, &args);
@@ -570,7 +585,7 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 	 * If zones where reported, make sure that the entire disk capacity
 	 * has been checked.
 	 */
-	if (ret > 0 && args.sector != get_capacity(disk)) {
+	if (ret > 0 && args.sector != capacity) {
 		pr_warn("%s: Missing zones from sector %llu\n",
 			disk->disk_name, args.sector);
 		ret = -ENODEV;
@@ -583,7 +598,6 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 	 */
 	blk_mq_freeze_queue(q);
 	if (ret > 0) {
-		blk_queue_chunk_sectors(q, args.zone_sectors);
 		disk->nr_zones = args.nr_zones;
 		swap(disk->seq_zones_wlock, args.seq_zones_wlock);
 		swap(disk->conv_zones_bitmap, args.conv_zones_bitmap);
-- 
2.41.0

