Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B52E3C433E9
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:50:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 848E264DD9
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 04:50:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231259AbhA1Euf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 23:50:35 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:22123 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231243AbhA1Eu3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Jan 2021 23:50:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1611809428; x=1643345428;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FYa88HT0yWBywxqBZGFR8tCz7AMVDuJCnFOsRnimI0M=;
  b=S/Ngb5UmdID3Fi1rnflqq/b9DGEyEOo04pEvOJ8GypaXCAkW36izPOhT
   Kt8ZZm6aDt5G51VjEMteg1fhgB7AQnbXa6TxucHBHQRW2mEjXsypTUNBn
   HSydGWN9Uo2F0kvG5wUYya0gNuXFaNgcLa2O1cpyN+He8m6SqhduHkSA1
   +ccMWZb0pJgYg159BQR+LUOkex/+0/jjuqhBHXQ23CoBmMk6RUj3KNZcJ
   BCxUj4vFsB416hPpjV1SXNeCTfXCgiuRIpGSe3xKRcjlixec0L2HBGo0W
   05ovWBOVfnEGDU7e2BMBNfVovS4IGHQ7mTyigBCLPouOp4nPiazfW2EX/
   A==;
IronPort-SDR: 9VwR49JZBk2581ynwlWv69cD6DcOeLkDVFmY5+I+UOGVguXt6KX2LUlWYt7ULLl/E588/7f2rO
 Vzyzc+gg9JgC/zpNKodfFx9ygpxq66pkoVlL/3n0uKm94Dg5HsnE/gW7899ye8u6TqQBncnizg
 y+gCfS581rhXiqPaWSbgrlFrhtTMvjctP4Bl+fR3FVFQZGaNcbwjISX5+HME0RMDqsq2iPa1uQ
 XMXwSF+GdEXADR3h1vuQd0VI8dzzfe05Rof+2k8vHRe8udXVfvinrOMRifEUjyAI84xMRAnIFH
 XzA=
X-IronPort-AV: E=Sophos;i="5.79,381,1602518400"; 
   d="scan'208";a="158509136"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2021 12:47:43 +0800
IronPort-SDR: bU9IvMTj4o/RjNgHIh2Vwgczaft8crkbQxAUijzz5ZdIUMJHB1JEwcb2ih6wmB5AwIgG7pzmIN
 6rTOyfX/OAxsJwRr/5bFKYTdO9VjXU1gW3EczG9RLr3oPLT3NgtfSfZx7Rgr6vbRui+vkBpVb/
 jUYRB+AvWNRwStmAydVu072G1tPK/6NArJfNNJQMUj/yP+52NdWJPqn/18WhWvWQEAHeYTozrL
 GkBM67oVnHG6z2+z9F8Ow3k7RbRdGAJ2XZBQFQsnXIHnOWg25BiH8XcApuBFFBPYQv0RhAY74G
 bSUDtq+f6fPqouR7kROD1woK
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2021 20:30:02 -0800
IronPort-SDR: c2uU3xUrafHzTvInYusEBlkZFhykLUHkikWL1bY/D0HixajYtB+H/8+7/8J3BxAl+/sQkwwgen
 kOsXKwa7T6GdbPJvyDJbNSLIA0qKhAR6x6CiCVViEFKAmuOVTNS/Y1Igqw6pDguJhYlzk2igIp
 mMWnW1DuNbonLU5OmyHug7NfP9fWF/hL/EvbEdtuSz84juITF14ZEKTGzQAWf2acYNUpflkMA2
 Gck7JNM3OmoZEBBSlJxBNcf0U+gITl/bP/K78FpfJYVv5nrGesXq8uSRjiFmrhvrwNClCSqZYQ
 3no=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 27 Jan 2021 20:47:42 -0800
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@wdc.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH v4 5/8] block: introduce zone_write_granularity limit
Date:   Thu, 28 Jan 2021 13:47:30 +0900
Message-Id: <20210128044733.503606-6-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210128044733.503606-1-damien.lemoal@wdc.com>
References: <20210128044733.503606-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Per ZBC and ZAC specifications, host-managed SMR hard-disks mandate that
all writes into sequential write required zones be aligned to the device
physical block size. However, NVMe ZNS does not have this constraint and
allows write operations into sequential zones to be aligned to the
device logical block size. This inconsistency does not help with
software portability across device types.

To solve this, introduce the zone_write_granularity queue limit to
indicate the alignment constraint, in bytes, of write operations into
zones of a zoned block device. This new limit is exported as a
read-only sysfs queue attribute and the helper
blk_queue_zone_write_granularity() introduced for drivers to set this
limit.

The function blk_queue_set_zoned() is modified to set this new limit to
the device logical block size by default. NVMe ZNS devices as well as
zoned nullb devices use this default value as is. The scsi disk driver
is modified to execute the blk_queue_zone_write_granularity() helper to
set the zone write granularity of host-managed SMR disks to the disk
physical block size.

The accessor functions queue_zone_write_granularity() and
bdev_zone_write_granularity() are also introduced.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 Documentation/block/queue-sysfs.rst |  7 ++++++
 block/blk-settings.c                | 37 ++++++++++++++++++++++++++++-
 block/blk-sysfs.c                   |  8 +++++++
 drivers/scsi/sd_zbc.c               |  8 +++++++
 include/linux/blkdev.h              | 15 ++++++++++++
 5 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index edc6e6960b96..4dc7f0d499a8 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -279,4 +279,11 @@ devices are described in the ZBC (Zoned Block Commands) and ZAC
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
index 4c974340f1a9..a1e66165adcf 100644
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
@@ -875,7 +902,15 @@ void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
 		break;
 	}
 
-	disk->queue->limits.zoned = model;
+	q->limits.zoned = model;
+	if (model != BLK_ZONED_NONE) {
+		/*
+		 * Set the zone write granularity to the device logical block
+		 * size by default. The driver can change this value if needed.
+		 */
+		blk_queue_zone_write_granularity(q,
+						queue_logical_block_size(q));
+	}
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
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index cf07b7f93579..8293b29584b3 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -789,6 +789,14 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	blk_queue_max_active_zones(q, 0);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
+	/*
+	 * Per ZBC and ZAC specifications, writes in sequential write required
+	 * zones of host-managed devices must be aligned to the device physical
+	 * block size.
+	 */
+	if (blk_queue_zoned_model(q) == BLK_ZONED_HM)
+		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
+
 	/* READ16/WRITE16 is mandatory for ZBC disks */
 	sdkp->device->use_16_for_rw = 1;
 	sdkp->device->use_10_for_rw = 0;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0dea268bd61b..9149f4a5adb3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -337,6 +337,7 @@ struct queue_limits {
 	unsigned int		max_zone_append_sectors;
 	unsigned int		discard_granularity;
 	unsigned int		discard_alignment;
+	unsigned int		zone_write_granularity;
 
 	unsigned short		max_segments;
 	unsigned short		max_integrity_segments;
@@ -1160,6 +1161,8 @@ extern void blk_queue_logical_block_size(struct request_queue *, unsigned int);
 extern void blk_queue_max_zone_append_sectors(struct request_queue *q,
 		unsigned int max_zone_append_sectors);
 extern void blk_queue_physical_block_size(struct request_queue *, unsigned int);
+void blk_queue_zone_write_granularity(struct request_queue *q,
+				      unsigned int size);
 extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
 void blk_queue_update_readahead(struct request_queue *q);
@@ -1473,6 +1476,18 @@ static inline int bdev_io_opt(struct block_device *bdev)
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

