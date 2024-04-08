Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0343926AE4;
	Mon,  8 Apr 2024 01:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712540521; cv=none; b=s1Hsu7gTeaCrub768QTiqstO4J1jySRAf3UtFFckMMVKp8h5F1eDWFeGtEybVKlKJ+tmX7qijg+FwLt1Oa3phXm/1mBddvfLRIlsfDzFOBuBtMZjSf8uBSIcKql3uaBwxXpogwhsNPLSjEh43e1bnK1hIuIuUeU06hbPQ+zbRWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712540521; c=relaxed/simple;
	bh=mJ/ZsIBWl7PcXIPOrwEtYjBMv2nfhnkqtDcPIwoQDSA=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7+j/DaU6QhOT+d3kgwts8n5wBFh3lMo5+K8eA7DpcwS16RRoEU/AVL+S0RWOYO8eirz6vjO7tg+4rOOqYL3ezLSbjf1kqJJmia3TPK/m6/xcx0YtUAzC5V3S0mxQYgVTs79Bmk2dcWN8hN16BZ3K0j4hBdbP3j95NF9FOFVPUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zeuv6ALC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zeuv6ALC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80BFCC433F1;
	Mon,  8 Apr 2024 01:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712540520;
	bh=mJ/ZsIBWl7PcXIPOrwEtYjBMv2nfhnkqtDcPIwoQDSA=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=Zeuv6ALCMeO4RKZZWyiReq0xhTMLjiJdm997mQehghFvtG0Dlf7M/lz6v0fiSiv/Q
	 zu8TRwoOCQI0baEE+mWEvii9dUO0tDKEvJcmh2VRlu+mQSbeG7IljJpmAoINQFLuwi
	 RM6xv9ZN8xOVHHtRxwGGI0bWbSxA+ckaZJqyrFWDhDfHPfLrV9T6vrtNabs4B8H9rY
	 wFdG0X0RSFlzLgZ2HGn+L5JoS5NmwulBQDj8rQjtHKiE9q2V6JVgAbhGzuTdvPUctC
	 zVKbzQ6Hty50sguK/05rYW2y48FlD3A9j7dQInaE9lNlRx09GpqryEsOzBc9t3Nscu
	 5BMJ5J48p+vqg==
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
Subject: [PATCH v7 16/28] null_blk: Introduce zone_append_max_sectors attribute
Date: Mon,  8 Apr 2024 10:41:16 +0900
Message-ID: <20240408014128.205141-17-dlemoal@kernel.org>
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

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Hans Holmberg <hans.holmberg@wdc.com>
Tested-by: Dennis Maisenbacher <dennis.maisenbacher@wdc.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/block/null_blk/main.c     | 10 +++++++++-
 drivers/block/null_blk/null_blk.h |  1 +
 drivers/block/null_blk/zoned.c    | 20 +++++++++++++++++---
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index ed33cf7192d2..14e9aa867afe 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -253,6 +253,11 @@ static unsigned int g_zone_max_active;
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
@@ -436,6 +441,7 @@ NULLB_DEVICE_ATTR(zone_capacity, ulong, NULL);
 NULLB_DEVICE_ATTR(zone_nr_conv, uint, NULL);
 NULLB_DEVICE_ATTR(zone_max_open, uint, NULL);
 NULLB_DEVICE_ATTR(zone_max_active, uint, NULL);
+NULLB_DEVICE_ATTR(zone_append_max_sectors, uint, NULL);
 NULLB_DEVICE_ATTR(virt_boundary, bool, NULL);
 NULLB_DEVICE_ATTR(no_sched, bool, NULL);
 NULLB_DEVICE_ATTR(shared_tags, bool, NULL);
@@ -580,6 +586,7 @@ static struct configfs_attribute *nullb_device_attrs[] = {
 	&nullb_device_attr_zone_nr_conv,
 	&nullb_device_attr_zone_max_open,
 	&nullb_device_attr_zone_max_active,
+	&nullb_device_attr_zone_append_max_sectors,
 	&nullb_device_attr_zone_readonly,
 	&nullb_device_attr_zone_offline,
 	&nullb_device_attr_virt_boundary,
@@ -671,7 +678,7 @@ static ssize_t memb_group_features_show(struct config_item *item, char *page)
 			"shared_tags,size,submit_queues,use_per_node_hctx,"
 			"virt_boundary,zoned,zone_capacity,zone_max_active,"
 			"zone_max_open,zone_nr_conv,zone_offline,zone_readonly,"
-			"zone_size\n");
+			"zone_size,zone_append_max_sectors\n");
 }
 
 CONFIGFS_ATTR_RO(memb_group_, features);
@@ -751,6 +758,7 @@ static struct nullb_device *null_alloc_dev(void)
 	dev->zone_nr_conv = g_zone_nr_conv;
 	dev->zone_max_open = g_zone_max_open;
 	dev->zone_max_active = g_zone_max_active;
+	dev->zone_append_max_sectors = g_zone_append_max_sectors;
 	dev->virt_boundary = g_virt_boundary;
 	dev->no_sched = g_no_sched;
 	dev->shared_tags = g_shared_tags;
diff --git a/drivers/block/null_blk/null_blk.h b/drivers/block/null_blk/null_blk.h
index 477b97746823..a9c5df650ddb 100644
--- a/drivers/block/null_blk/null_blk.h
+++ b/drivers/block/null_blk/null_blk.h
@@ -82,6 +82,7 @@ struct nullb_device {
 	unsigned int zone_nr_conv; /* number of conventional zones */
 	unsigned int zone_max_open; /* max number of open zones */
 	unsigned int zone_max_active; /* max number of active zones */
+	unsigned int zone_append_max_sectors; /* Max sectors per zone append command */
 	unsigned int submit_queues; /* number of submission queues */
 	unsigned int prev_submit_queues; /* number of submission queues before change */
 	unsigned int poll_queues; /* number of IOPOLL submission queues */
diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 8e217f8fadcd..0b2af273adaf 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -103,6 +103,11 @@ int null_init_zoned_dev(struct nullb_device *dev,
 			dev->zone_nr_conv);
 	}
 
+	dev->zone_append_max_sectors =
+		min(ALIGN_DOWN(dev->zone_append_max_sectors,
+			       dev->blocksize >> SECTOR_SHIFT),
+		    zone_capacity_sects);
+
 	/* Max active zones has to be < nbr of seq zones in order to be enforceable */
 	if (dev->zone_max_active >= dev->nr_zones - dev->zone_nr_conv) {
 		dev->zone_max_active = 0;
@@ -154,7 +159,7 @@ int null_init_zoned_dev(struct nullb_device *dev,
 
 	lim->zoned = true;
 	lim->chunk_sectors = dev->zone_size_sects;
-	lim->max_zone_append_sectors = dev->zone_size_sects;
+	lim->max_zone_append_sectors = dev->zone_append_max_sectors;
 	lim->max_open_zones = dev->zone_max_open;
 	lim->max_active_zones = dev->zone_max_active;
 	return 0;
@@ -163,10 +168,16 @@ int null_init_zoned_dev(struct nullb_device *dev,
 int null_register_zoned_dev(struct nullb *nullb)
 {
 	struct request_queue *q = nullb->q;
+	struct gendisk *disk = nullb->disk;
 
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
-	nullb->disk->nr_zones = bdev_nr_zones(nullb->disk->part0);
-	return blk_revalidate_disk_zones(nullb->disk, NULL);
+	disk->nr_zones = bdev_nr_zones(disk->part0);
+
+	pr_info("%s: using %s zone append\n",
+		disk->disk_name,
+		queue_emulates_zone_append(q) ? "emulated" : "native");
+
+	return blk_revalidate_disk_zones(disk, NULL);
 }
 
 void null_free_zoned_dev(struct nullb_device *dev)
@@ -365,6 +376,9 @@ static blk_status_t null_zone_write(struct nullb_cmd *cmd, sector_t sector,
 
 	trace_nullb_zone_op(cmd, zno, zone->cond);
 
+	if (WARN_ON_ONCE(append && !dev->zone_append_max_sectors))
+		return BLK_STS_IOERR;
+
 	if (zone->type == BLK_ZONE_TYPE_CONVENTIONAL) {
 		if (append)
 			return BLK_STS_IOERR;
-- 
2.44.0

