Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC9F1C4332B
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 08:01:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE26223A1E
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Jan 2021 08:01:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbhAVIB1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 03:01:27 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:38097 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbhAVIBY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 03:01:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611302483; x=1642838483;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9WSfllpGuQIiffbbN5+v7zOqg6HXUAMGib9qjyX/9zo=;
  b=hr6PyYr9gPffFUar7nPLU5bj7GY54klc5Kz+iX8xANynIB/g72nd6Ygn
   mSiU6VtyK3x1kuliBrnAmg6srR06SvUPTuI1KSCAvfusITyMR28pkSwZ7
   e+HDTDPXjE6VkPkMNi5ILS9RkQHywddeMAxi0x17n09Bayq+ZvlshellT
   xks92rAEghZz/ZYZQh8RfCJdrtMWZv+3CUiWch9+1kyT53+fDtptz/g1D
   o2M7JR43hRtWB1qmiWoI4dezaFcJFvHHksr9PEoUZC+nl959nPPR7wEn7
   vpHGatsUjWHEIZ9Vy+ueoyN09Jx7flRZ3o3CafV+qZE8adsIpIlBZ6hTj
   w==;
IronPort-SDR: jrTVkmWfO7h8S0FTVgmjxkSZgc4WQcgJjsWUArAFyFNw74ROgaeBJV0oMhB719JF7qk9Tp0d2w
 sTobIyqj4AVaNyfxQNFhtemdGRKDzhZy2d5BLxKNx+sk1hZKPAOUpJzjA67gvvx/Wpp/2ZFXdW
 fPZkZC0AdqvV7jwdxY+Jruh4s5vwN7q+Kj+NSs8PGa7wCU6/BEaVGOlwoQcADEs5tfOKYV1iSm
 9Ra3TkHCsII4whLKSCAH3MvCLc928Devpdys78IEOlGvSPLfMZSBrP2vbXWsNJs18uxFJqw8bb
 P3I=
X-IronPort-AV: E=Sophos;i="5.79,366,1602518400"; 
   d="scan'208";a="268398846"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jan 2021 16:00:17 +0800
IronPort-SDR: xrgHA29AiETvzrG8tIk37FwVA4LYkJ0bDKJVwvin91OzwR5RxQhZikZPi6mZR1ifftfz/Gp4ET
 a0cA4rm7G7WOzf4jz1BWTBr2mnEnaC8UnjczhguM+qyjLB9erDQILVy9pL49lxcgFV2ym9wZu8
 kp/TjTDXYmlFJLJdrxCmDq5aYc6oLqMrCCDeHlvqD4kAQjZeKUn4IvdQqNGf+aQS3YefI6UcA7
 KnfrAOPAuHFWD+akPpyt7zbGtXOVvUHKg1E53PNlAl49LbiAe33jh57LMutd3S/NHxB2aOaYvl
 Kvgx5ehR4S6nAuI3xtoI5LeN
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Jan 2021 23:42:49 -0800
IronPort-SDR: S4GZPg3dlGc0qg5lrTOlKhI73pMqTnH5VI8yt3wy3LxXg2VyDibIIK0nU9Zg2WncDxlYuqRzzI
 ikH5nT8z1upiQntTYxJ4XYQ4n+qqOaSKeUVRkeott1eb9wh1gIMl+9ygpFrAdxrC6RTS84zJGJ
 q1T9EkJlsnGJBTni624ZX3+eapXdxsPGzPLYC2ObLk/RnepfupvClVj7p4NX0uypGFsl2Y7dJ8
 RajCzDeG3G/LUAIubXzOT4Q29t++funJ45m9yUfF4hJkTBpVupssEK+TE/BlwVO1WctVeJ/H3j
 aek=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 22 Jan 2021 00:00:17 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>
Subject: [PATCH v3 1/3] block: introduce zone_write_granularity limit
Date:   Fri, 22 Jan 2021 17:00:12 +0900
Message-Id: <20210122080014.174391-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210122080014.174391-1-damien.lemoal@wdc.com>
References: <20210122080014.174391-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Per ZBC and ZAC specifications, host-managed SMR hard-disks mandate that
all writes into sequential write required zones be aligned to the device
physical block size. However, NVMe ZNS does not have this constraint and
allows write operations into sequential zones to be logical block size
aligned. This inconsistency does not help with portability of software
across device types.
To solve this, introduce the zone_write_granularity queue limit to
indicate the alignment constraint, in bytes, of write operations into
zones of a zoned block device. This new limit is exported as a
read-only sysfs queue attribute and the helper
blk_queue_zone_write_granularity() introduced for drivers to set this
limit. The scsi disk driver is modified to use this helper to set
host-managed SMR disk zone write granularity to the disk physical block
size. The ZNS support code of the NVMe driver is also modified to use
this helper to set the new limit to the logical block size of the
namespace. The nullblk driver is similarly modified too.

The accessor functions queue_zone_write_granularity() and
bdev_zone_write_granularity() are also introduced.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 Documentation/block/queue-sysfs.rst |  7 ++++++
 block/blk-settings.c                | 39 +++++++++++++++++++++++++----
 block/blk-sysfs.c                   |  8 ++++++
 drivers/block/null_blk/zoned.c      |  1 +
 drivers/nvme/host/zns.c             |  1 +
 drivers/scsi/sd_zbc.c               | 10 ++++++++
 include/linux/blkdev.h              | 15 +++++++++++
 7 files changed, 76 insertions(+), 5 deletions(-)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index 2638d3446b79..c8bf8bc3c03a 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -273,4 +273,11 @@ devices are described in the ZBC (Zoned Block Commands) and ZAC
 do not support zone commands, they will be treated as regular block devices
 and zoned will report "none".
 
+zone_write_granularity (RO)
+---------------------------
+This indicates the alignment constraint, in bytes, for write operations in
+sequential zones of zoned block devices (devices with a zoned attributed
+that reports "host-managed" or "host-aware"). This value is always 0 for
+regular block devices.
+
 Jens Axboe <jens.axboe@oracle.com>, February 2009
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 43990b1d148b..48872b4085d4 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -60,6 +60,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->io_opt = 0;
 	lim->misaligned = 0;
 	lim->zoned = BLK_ZONED_NONE;
+	lim->zone_write_granularity = 0;
 }
 EXPORT_SYMBOL(blk_set_default_limits);
 
@@ -366,6 +367,28 @@ void blk_queue_physical_block_size(struct request_queue *q, unsigned int size)
 }
 EXPORT_SYMBOL(blk_queue_physical_block_size);
 
+/**
+ * blk_queue_zone_write_granularity - set zone write granularity for the queue
+ * @q:  the request queue for the zoned device
+ * @size:  the zone write granularity size, in bytes
+ *
+ * Description:
+ *   This should be set to the lowest possible size allowing to write in
+ *   sequential zones of a zoned block device.
+ */
+void blk_queue_zone_write_granularity(struct request_queue *q,
+				      unsigned int size)
+{
+	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))
+		return;
+
+	q->limits.zone_write_granularity = size;
+
+	if (q->limits.zone_write_granularity < q->limits.logical_block_size)
+		q->limits.zone_write_granularity = q->limits.logical_block_size;
+}
+EXPORT_SYMBOL_GPL(blk_queue_zone_write_granularity);
+
 /**
  * blk_queue_alignment_offset - set physical block alignment offset
  * @q:	the request queue for the device
@@ -631,6 +654,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			t->discard_granularity;
 	}
 
+	t->zone_write_granularity = max(t->zone_write_granularity,
+					b->zone_write_granularity);
 	t->zoned = max(t->zoned, b->zoned);
 	return ret;
 }
@@ -847,6 +872,8 @@ EXPORT_SYMBOL_GPL(blk_queue_can_use_dma_map_merging);
  */
 void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 {
+	struct request_queue *q = disk->queue;
+
 	switch (model) {
 	case BLK_ZONED_HM:
 		/*
@@ -864,18 +891,20 @@ void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 		 * partitions and zoned block device support is enabled, else
 		 * we do nothing special as far as the block layer is concerned.
 		 */
-		if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) ||
-		    disk_has_partitions(disk))
-			model = BLK_ZONED_NONE;
-		break;
+		if (IS_ENABLED(CONFIG_BLK_DEV_ZONED) &&
+		    !disk_has_partitions(disk))
+			break;
+		model = BLK_ZONED_NONE;
+		fallthrough;
 	case BLK_ZONED_NONE:
 	default:
 		if (WARN_ON_ONCE(model != BLK_ZONED_NONE))
 			model = BLK_ZONED_NONE;
+		q->limits.zone_write_granularity = 0;
 		break;
 	}
 
-	disk->queue->limits.zoned = model;
+	q->limits.zoned = model;
 }
 EXPORT_SYMBOL_GPL(blk_queue_set_zoned);
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index b513f1683af0..ae39c7f3d83d 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -219,6 +219,12 @@ static ssize_t queue_write_zeroes_max_show(struct request_queue *q, char *page)
 		(unsigned long long)q->limits.max_write_zeroes_sectors << 9);
 }
 
+static ssize_t queue_zone_write_granularity_show(struct request_queue *q,
+						 char *page)
+{
+	return queue_var_show(queue_zone_write_granularity(q), page);
+}
+
 static ssize_t queue_zone_append_max_show(struct request_queue *q, char *page)
 {
 	unsigned long long max_sectors = q->limits.max_zone_append_sectors;
@@ -585,6 +591,7 @@ QUEUE_RO_ENTRY(queue_discard_zeroes_data, "discard_zeroes_data");
 QUEUE_RO_ENTRY(queue_write_same_max, "write_same_max_bytes");
 QUEUE_RO_ENTRY(queue_write_zeroes_max, "write_zeroes_max_bytes");
 QUEUE_RO_ENTRY(queue_zone_append_max, "zone_append_max_bytes");
+QUEUE_RO_ENTRY(queue_zone_write_granularity, "zone_write_granularity");
 
 QUEUE_RO_ENTRY(queue_zoned, "zoned");
 QUEUE_RO_ENTRY(queue_nr_zones, "nr_zones");
@@ -639,6 +646,7 @@ static struct attribute *queue_attrs[] = {
 	&queue_write_same_max_entry.attr,
 	&queue_write_zeroes_max_entry.attr,
 	&queue_zone_append_max_entry.attr,
+	&queue_zone_write_granularity_entry.attr,
 	&queue_nonrot_entry.attr,
 	&queue_zoned_entry.attr,
 	&queue_nr_zones_entry.attr,
diff --git a/drivers/block/null_blk/zoned.c b/drivers/block/null_blk/zoned.c
index 535351570bb2..704d09481e0d 100644
--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -172,6 +172,7 @@ int null_register_zoned_dev(struct nullb *nullb)
 	blk_queue_max_zone_append_sectors(q, dev->zone_size_sects);
 	blk_queue_max_open_zones(q, dev->zone_max_open);
 	blk_queue_max_active_zones(q, dev->zone_max_active);
+	blk_queue_zone_write_granularity(q, dev->blocksize);
 
 	return 0;
 }
diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 1dfe9a3500e3..f25311ccd996 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -113,6 +113,7 @@ int nvme_update_zone_info(struct nvme_ns *ns, unsigned lbaf)
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
 	blk_queue_max_open_zones(q, le32_to_cpu(id->mor) + 1);
 	blk_queue_max_active_zones(q, le32_to_cpu(id->mar) + 1);
+	blk_queue_zone_write_granularity(q, q->limits.logical_block_size);
 free_data:
 	kfree(id);
 	return status;
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index cf07b7f93579..10e9f33cc069 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -789,6 +789,16 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	blk_queue_max_active_zones(q, 0);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
+	/*
+	 * Per ZBC and ZAC specifications, writes in sequential write required
+	 * zones of host-managed devices must be aligned to the device physical
+	 * block size.
+	 */
+	if (blk_queue_zoned_model(q) == BLK_ZONED_HM)
+		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
+	else if (blk_queue_zoned_model(q) == BLK_ZONED_HA)
+		blk_queue_zone_write_granularity(q, sdkp->device->sector_size);
+
 	/* READ16/WRITE16 is mandatory for ZBC disks */
 	sdkp->device->use_16_for_rw = 1;
 	sdkp->device->use_10_for_rw = 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f94ee3089e01..142e3b34be75 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -337,6 +337,7 @@ struct queue_limits {
 	unsigned int		max_zone_append_sectors;
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
+	unsigned int		zone_write_granularity;
 
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
@@ -1161,6 +1162,8 @@ extern void blk_queue_logical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_max_zone_append_sectors(struct request_queue *q,
 		unsigned int max_zone_append_sectors);
 extern void blk_queue_physical_block_size(struct request_queue *, unsigned int);
+void blk_queue_zone_write_granularity(struct request_queue *q,
+				      unsigned int size);
 extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
 void blk_queue_update_readahead(struct request_queue *q);
@@ -1474,6 +1477,18 @@ static inline int bdev_io_opt(struct block_device *bdev)
 	return queue_io_opt(bdev_get_queue(bdev));
 }
 
+static inline unsigned int
+queue_zone_write_granularity(const struct request_queue *q)
+{
+	return q->limits.zone_write_granularity;
+}
+
+static inline unsigned int
+bdev_zone_write_granularity(struct block_device *bdev)
+{
+	return queue_zone_write_granularity(bdev_get_queue(bdev));
+}
+
 static inline int queue_alignment_offset(const struct request_queue *q)
 {
 	if (q->limits.misaligned)
-- 
2.29.2

