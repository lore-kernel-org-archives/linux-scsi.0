Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D5F1C3231;
	Mon, 25 Mar 2024 04:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711341920; cv=none; b=IpmCRgwqNah4IEUNbasKGMh9v9pts+2BQ0t1Ixrljbfi7SnmFYKZDXAtS+MDm8rmg66Sclk1e4gGqyGdhS5HEqW8ggXDEWjnKvuim01AkbjRmh3e47djiEEVwnJERYVekwvvq4wiu7pA5xQCwPmIKHig1TuDKAnuYL4NOnAojYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711341920; c=relaxed/simple;
	bh=+dZalPMFsBkvL3AxKVlqSynRhnZEd1PbfEv4tPdnRoI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ut0vQUYow921291Q089MdwbM5otkg9zSuy8uUBo9sxk8um0WF3jC48TyANpRkGoB2RFaM33puuTRmxM1bKzE3ZeCaihE+F5u5ZBRGfx1Z9zgyvu1tqFYixB24pSeehVl50GniKUg9nzgaDV5NNCM/DoDBgQBKIvUEWXc4KIpMog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/ChcYxd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/ChcYxd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36C01C43394;
	Mon, 25 Mar 2024 04:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711341919;
	bh=+dZalPMFsBkvL3AxKVlqSynRhnZEd1PbfEv4tPdnRoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/ChcYxdUgwQZ1tOlOE9l/4WpI9aZPMK3ZxcOfTbtDb9mU67f6LKaMFLSvG8QWKLB
	 bPBB2TmFAhj++nrxCi1TvFMcvFhA25krDTqZ3LKmoS5TnQF0Q5hBgm6zDQG5JS/hy9
	 4UBVH48iD27j2xpAxgvY3dQXhH2RgeJ76n9xiJpHluK/k0P1psW4a47wVstBG1ChIK
	 sEXW70GoLbFaGbIMn8wcMg0icz7RdeBnTdNkA/IGk7BbFzBBxGBT+rB7W3zpd695Y8
	 Lo50XQanniHzZIjjpGRfyeE1tv7xi2sYHzLLbCHAsBzIg6AFT+GAHxtIKTQE+7PitT
	 lwvLnkRXgzYYg==
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	dm-devel@lists.linux.dev,
	Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2 12/28] block: Allow BIO-based drivers to use blk_revalidate_disk_zones()
Date: Mon, 25 Mar 2024 13:44:36 +0900
Message-ID: <20240325044452.3125418-13-dlemoal@kernel.org>
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

In preparation for allowing BIO based device drivers to use zone write
plugging and its zone append emulation, allow these drivers to call
blk_revalidate_disk_zones() so that all zone resources necessary to zone
write plugging can be initialized.

To do so, remove the check in blk_revalidate_disk_zones() restricting
the use of this function to mq request-based drivers to allow also
BIO-based drivers to use it. This is safe to do as long as the
BIO-based block device queue is already setup and usable, as it should,
and can be safely frozen. The zone write plug hash table and
conventional zone bitmap are allocated and initialized only for mq
devices and for BIO-based devices that require zone append emulation.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-zoned.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 5b86f1aa80f0..8dc7cdc539c6 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1481,6 +1481,14 @@ static int disk_revalidate_zone_resources(struct gendisk *disk,
 	unsigned int hash_size;
 	int ret;
 
+	/*
+	 * For devices using a BIO-based driver, we need zone resources only
+	 * if zone append emulation is required.
+	 */
+	if (!queue_is_mq(disk->queue) &&
+	    !queue_emulates_zone_append(disk->queue))
+		return 0;
+
 	/*
 	 * If the device has no limit on the maximum number of open and active
 	 * zones, set the max_open_zones queue limit to indicate the size of
@@ -1571,6 +1579,13 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 	/* Check zone type */
 	switch (zone->type) {
 	case BLK_ZONE_TYPE_CONVENTIONAL:
+		/*
+		 * For devices using a BIO-based driver, we need zone resources
+		 * only if zone append emulation is required.
+		 */
+		if (!queue_is_mq(disk->queue) &&
+		    !queue_emulates_zone_append(disk->queue))
+			break;
 		if (!args->conv_zones_bitmap) {
 			args->conv_zones_bitmap =
 				blk_alloc_zone_bitmap(q->node, args->nr_zones);
@@ -1602,10 +1617,11 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 		/*
 		 * We need to track the write pointer of all zones that are not
 		 * empty nor full. So make sure we have a zone write plug for
-		 * such zone.
+		 * such zone if the device has a zone write plug hash table.
 		 */
 		wp_offset = blk_zone_wp_offset(zone);
-		if (wp_offset && wp_offset < zone_sectors) {
+		if (disk->zone_wplugs_hash &&
+		    wp_offset && wp_offset < zone_sectors) {
 			zwplug = disk_get_zone_wplug_locked(disk, zone->start,
 							    GFP_NOIO, &flags);
 			if (!zwplug)
@@ -1636,8 +1652,8 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
  * be called within the disk ->revalidate method for blk-mq based drivers.
  * Before calling this function, the device driver must already have set the
  * device zone size (chunk_sector limit) and the max zone append limit.
- * For BIO based drivers, this function cannot be used. BIO based device drivers
- * only need to set disk->nr_zones so that the sysfs exposed value is correct.
+ * BIO based drivers can also use this function as long as the device queue
+ * can be safely frozen.
  * If the @update_driver_data callback function is not NULL, the callback is
  * executed with the device request queue frozen after all zones have been
  * checked.
@@ -1654,8 +1670,6 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 
 	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))
 		return -EIO;
-	if (WARN_ON_ONCE(!queue_is_mq(q)))
-		return -EIO;
 
 	if (!capacity)
 		return -ENODEV;
-- 
2.44.0

