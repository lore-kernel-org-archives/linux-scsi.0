Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E5A933CF5;
	Fri,  5 Apr 2024 04:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712292153; cv=none; b=hsOl8HcsTP2b6hl/+2d7MBjmtgRVGxZLyG7eAMb2TXsmEx1Yo1ULFseC1Sy3rw3Twe9+HsicxXWz0eRd7RmhP1wzhBmpMpgqS3Y3FRKdoLYQE1btdYC0/8u1LKnGPkleVc2Ua1pA5mpA7a+rlXr9gdv0baAXmHGYwiZlx3hLrWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712292153; c=relaxed/simple;
	bh=4RbyB8pFOPbUmrxzF0LMuyx+NzUUMMPFHXg4fpzXXi8=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=la/JKv4Yn8e0MCOVAnlE/gW+r6q+DtYQvwQIgCkw/9LocFoMamX7QM4DApGqzjayJ89z2tMpeTFAdnK8goVDxBwkQX/0cCD3m1sn/DWwiVKXIpGEjaeTNbTqGucOcsWpU93mCI2PD2oaY/A8IVqyw9WHaXd5LKF+iTjIAUYhnF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V8dtMirq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V8dtMirq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AAA5C43394;
	Fri,  5 Apr 2024 04:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712292153;
	bh=4RbyB8pFOPbUmrxzF0LMuyx+NzUUMMPFHXg4fpzXXi8=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=V8dtMirqrCqlGrAeqQ0KhfM9yFKGh0/EejASaEyNN0is5FKlgsYfDqcrKuMTSrjJA
	 3dPDVf3SBxXnBkCJbYm/rKdWmcDsGZJ8SZFqO149nP+rlqUPURxf3BUm7owydh8eqm
	 m6RgcbdxSUiHnCftUQplOhM+znmhQPf31zOPPXF4vKLM6kzdVKsfN4Wzzl6W4KfZpC
	 e2XML+fDPbXmztJ1C8J1N2SO3+XSB1TWqoFyRbau3p4J6/V0hjuOGi8sX1h1U0OdAX
	 CdnFrx/FOcGyKvSBnADskkk5jZo09To73biRJZA7Z2CatvkoGjmHPlI9RrKXD5mxPU
	 zK1Bdrj1nYXbQ==
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
Subject: [PATCH v6 16/28] null_blk: Introduce zone_append_max_sectors attribute
Date: Fri,  5 Apr 2024 13:41:55 +0900
Message-ID: <20240405044207.1123462-17-dlemoal@kernel.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240405044207.1123462-1-dlemoal@kernel.org>
References: <20240405044207.1123462-1-dlemoal@kernel.org>
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
---
 drivers/block/null_blk/main.c     | 10 +++++++++-
 drivers/block/null_blk/null_blk.h |  1 +
 drivers/block/null_blk/zoned.c    | 20 +++++++++++++++++---
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 71c39bcd872c..a5a50ba6ad9f 100644
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

