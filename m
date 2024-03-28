Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 725CE2E3E8;
	Thu, 28 Mar 2024 00:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711586677; cv=none; b=vGa1DBlK+rPCFRVXVo41PZEOgkSiFs5z5APFruiqRVuuENUgBcKp2x4YsM+tyd37CsKw4omG/PNoMVEhgB0V+PSPiAX98TuWyJVPiaA/gLLbBEf40Ev7w4yXzg/3QRAltGrbjrKOuH31RreAJ5tdthAm6qiMpK9veq1OTALG0J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711586677; c=relaxed/simple;
	bh=6oWsViLfEZxGYaGwqyo/tuv7BeO/cqnTgpNUxa37bXo=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TsBxWbwQSENYs9cOvQ2+NID6J4bZLSq72PcTnYMV5IPUBOsvd7Rg7sEQ/QriFCtUT4Q6gqMKj/ICIopBIOR/3DMw08by/58FnMPIHsiIxsrJA5EbHcP09qPGa5y2R+2K3gt1dYQCEdU5AQjuaaNitj5ieIoA2Phcf2deR4rXFms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fbjjw1TM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fbjjw1TM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0597C43390;
	Thu, 28 Mar 2024 00:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711586677;
	bh=6oWsViLfEZxGYaGwqyo/tuv7BeO/cqnTgpNUxa37bXo=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Fbjjw1TMV+muF23cISdNkveog8vBSOpsqAbxNP3fa9jeDmd+TpsG/VQ+2jtmu3pP0
	 MG1JL4E6u4otqRoixJyj5bXUmFuORtd/kY1yE/my/pwB80nnfrGX/552a6K5wlvOg5
	 GWb+FHN0I/1sQET7E4vX/6HsChtGE0NhaYyVymptNg2GwZaEWNO2QUcIGumXkDGE2S
	 8wRsfscwZUgajWf9SZl4/jB4nu+SCrUKIhRAzD4c3cKKDCx/G26MrfCl/elcd0WxEN
	 bIhzPLVaOzdMTY9aymxYP+jXrtFEHwzN+Ukr3JKcXLd8W0ERDU1+CgSRrUivMoPcYv
	 A17PD5rBiwIDw==
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
Subject: [PATCH v3 13/30] block: Allow BIO-based drivers to use blk_revalidate_disk_zones()
Date: Thu, 28 Mar 2024 09:43:52 +0900
Message-ID: <20240328004409.594888-14-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240328004409.594888-1-dlemoal@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
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
and can be safely frozen.

The helper function disk_need_zone_resources() is added to control the
allocation and initialization of the zone write plug hash table and
of the conventional zone bitmap only for mq devices and for BIO-based
devices that require zone append emulation.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-zoned.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index eec6a392ae31..c41ac1519818 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1606,6 +1606,19 @@ void disk_free_zone_resources(struct gendisk *disk)
 	disk->nr_zones = 0;
 }
 
+static inline bool disk_need_zone_resources(struct gendisk *disk)
+{
+	/*
+	 * All mq zoned devices need zone resources so that the block layer
+	 * can automatically handle write BIO plugging. BIO-based device drivers
+	 * (e.g. DM devices) are normally responsible for handling zone write
+	 * ordering and do not need zone resources, unless the driver requires
+	 * zone append emulation.
+	 */
+	return queue_is_mq(disk->queue) ||
+		queue_emulates_zone_append(disk->queue);
+}
+
 static int disk_revalidate_zone_resources(struct gendisk *disk,
 					  unsigned int nr_zones)
 {
@@ -1614,6 +1627,9 @@ static int disk_revalidate_zone_resources(struct gendisk *disk,
 	bool set_max_open = false;
 	int ret;
 
+	if (!disk_need_zone_resources(disk))
+		return 0;
+
 	/*
 	 * If the device has no limit on the maximum number of open and active
 	 * zones, use BLK_ZONE_DEFAULT_MAX_NR_WPLUGS for the maximum number
@@ -1717,6 +1733,9 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
 				disk->disk_name);
 			return -ENODEV;
 		}
+
+		if (!disk_need_zone_resources(disk))
+			break;
 		if (!args->conv_zones_bitmap) {
 			args->conv_zones_bitmap =
 				blk_alloc_zone_bitmap(q->node, args->nr_zones);
@@ -1748,10 +1767,11 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
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
 			zwplug = disk_get_and_lock_zone_wplug(disk, zone->start,
 							      GFP_NOIO, &flags);
 			if (!zwplug)
@@ -1782,8 +1802,8 @@ static int blk_revalidate_zone_cb(struct blk_zone *zone, unsigned int idx,
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
@@ -1800,8 +1820,6 @@ int blk_revalidate_disk_zones(struct gendisk *disk,
 
 	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))
 		return -EIO;
-	if (WARN_ON_ONCE(!queue_is_mq(q)))
-		return -EIO;
 
 	if (!capacity)
 		return -ENODEV;
-- 
2.44.0

