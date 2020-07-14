Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8203C433E7
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 21:18:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8D36520658
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 21:18:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="P9kf152C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbgGNVSn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:18:43 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:9520 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgGNVSn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 17:18:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594761557; x=1626297557;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WffFE44kU2ggfRwThMbpz3r9alO8QRLyGr1rkdfJfx0=;
  b=P9kf152C3S4TFjVJC9F8t4wE9Kq+F5r+kxnYMpxXhP8jOu+HFPAlH8wp
   3goz0yKthYhLwocWKoJ5aZuzY0qSmZ4u4VnMMhUe+iYgMkv/82O8RNSAz
   kBPbyOvHmMGGa3JnN8/O2wWgT4SGAz8EYKT6MCoTSr63Gq2b+gsCGE635
   KyBYhicYtS6SLQSv+5lxLfWyNq7FZIHyGEbz4EY7HusNuCZV+LYPr1dLU
   709nF/BKJui82UCrhY++rUs3NQ5O9LfA04NXXhMIEmbAlVM35Qxf3Ry87
   8FFiDMKztl//bQEFQCQAs3350KDTbPqA40BnkHTNe5P3LpIvBdhS3KaUA
   A==;
IronPort-SDR: T4zsodjCb0BBRibUoLAiR1YACdZS+cByxHGnsxx27KT0Mh4UmuxFn5TuGqfKkmmwb6k9sgRTyU
 qI+KiFU6avxynls/An4X+cHuHEoDJbUb8TpwDWYhVGFAfRGz33YfP/SIdOdkbOHOSPwr68w56z
 r0A748ghXWHutu8Fh0/OTIqxIEfBlx74L77s/tJdptI70jviuhZ5Zxo7BYwIic2pcpzBBXfNcM
 XF9jQzXbEgigxNXhmesOjLAuT6jCkhHRXCKW90dULS7a7K6DqyAmWWJN0SceDpiCHQpAXHnb/9
 6Zc=
X-IronPort-AV: E=Sophos;i="5.75,352,1589212800"; 
   d="scan'208";a="245491618"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jul 2020 05:19:16 +0800
IronPort-SDR: 5nHZXhDyxloA6lWOceljG/ah/jKXa7X2e15SUiFiG4x3+s4MwAAkhRY044S043KFokDvn5dzzm
 D/C/5sa2a9iFAVrn7Qo3QahfagYqcXnWs=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 14:06:35 -0700
IronPort-SDR: w1osPDgaPNeLW7r/e7WVVYlYwfeHy6h72qPQzg7oUoH+EyKkhcF6L/uqjwcBjp9PI+vynnl4h/
 dX4OXZDHTvcA==
WDCIronportException: Internal
Received: from usa003306.ad.shared (HELO localhost.hgst.com) ([10.86.57.226])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 Jul 2020 14:18:37 -0700
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@javigon.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH v3 1/2] block: add max_open_zones to blk-sysfs
Date:   Tue, 14 Jul 2020 23:18:23 +0200
Message-Id: <20200714211824.759224-2-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200714211824.759224-1-niklas.cassel@wdc.com>
References: <20200714211824.759224-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a new max_open_zones definition in the sysfs documentation.
This definition will be common for all devices utilizing the zoned block
device support in the kernel.

Export max open zones according to this new definition for NVMe Zoned
Namespace devices, ZAC ATA devices (which are treated as SCSI devices by
the kernel), and ZBC SCSI devices.

Add the new max_open_zones member to struct request_queue, rather
than as a queue limit, since this property cannot be split across stacking
drivers.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Javier González <javier@javigon.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 Documentation/ABI/testing/sysfs-block |  9 +++++++++
 Documentation/block/queue-sysfs.rst   |  7 +++++++
 block/blk-sysfs.c                     | 15 +++++++++++++++
 drivers/nvme/host/zns.c               |  1 +
 drivers/scsi/sd_zbc.c                 |  4 ++++
 include/linux/blkdev.h                | 25 +++++++++++++++++++++++++
 6 files changed, 61 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index ed8c14f161ee..f151d9cf90de 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -273,6 +273,15 @@ Description:
 		device ("host-aware" or "host-managed" zone model). For regular
 		block devices, the value is always 0.
 
+What:		/sys/block/<disk>/queue/max_open_zones
+Date:		July 2020
+Contact:	Niklas Cassel <niklas.cassel@wdc.com>
+Description:
+		For zoned block devices (zoned attribute indicating
+		"host-managed" or "host-aware"), the sum of zones belonging to
+		any of the zone states: EXPLICIT OPEN or IMPLICIT OPEN,
+		is limited by this value. If this value is 0, there is no limit.
+
 What:		/sys/block/<disk>/queue/chunk_sectors
 Date:		September 2016
 Contact:	Hannes Reinecke <hare@suse.com>
diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index 6a8513af9201..f01cf8530ae4 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -117,6 +117,13 @@ Maximum number of elements in a DMA scatter/gather list with integrity
 data that will be submitted by the block layer core to the associated
 block driver.
 
+max_open_zones (RO)
+-------------------
+For zoned block devices (zoned attribute indicating "host-managed" or
+"host-aware"), the sum of zones belonging to any of the zone states:
+EXPLICIT OPEN or IMPLICIT OPEN, is limited by this value.
+If this value is 0, there is no limit.
+
 max_sectors_kb (RW)
 -------------------
 This is the maximum number of kilobytes that the block layer will allow
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index be67952e7be2..414f04579d77 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -306,6 +306,11 @@ static ssize_t queue_nr_zones_show(struct request_queue *q, char *page)
 	return queue_var_show(blk_queue_nr_zones(q), page);
 }
 
+static ssize_t queue_max_open_zones_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(queue_max_open_zones(q), page);
+}
+
 static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
 {
 	return queue_var_show((blk_queue_nomerges(q) << 1) |
@@ -668,6 +673,11 @@ static struct queue_sysfs_entry queue_nr_zones_entry = {
 	.show = queue_nr_zones_show,
 };
 
+static struct queue_sysfs_entry queue_max_open_zones_entry = {
+	.attr = {.name = "max_open_zones", .mode = 0444 },
+	.show = queue_max_open_zones_show,
+};
+
 static struct queue_sysfs_entry queue_nomerges_entry = {
 	.attr = {.name = "nomerges", .mode = 0644 },
 	.show = queue_nomerges_show,
@@ -766,6 +776,7 @@ static struct attribute *queue_attrs[] = {
 	&queue_nonrot_entry.attr,
 	&queue_zoned_entry.attr,
 	&queue_nr_zones_entry.attr,
+	&queue_max_open_zones_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
 	&queue_iostats_entry.attr,
@@ -793,6 +804,10 @@ static umode_t queue_attr_visible(struct kobject *kobj, struct attribute *attr,
 		(!q->mq_ops || !q->mq_ops->timeout))
 			return 0;
 
+	if (attr == &queue_max_open_zones_entry.attr &&
+	    !blk_queue_is_zoned(q))
+		return 0;
+
 	return attr->mode;
 }
 
diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 04e5b991c00c..3d80b9cf6bfc 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -96,6 +96,7 @@ int nvme_update_zone_info(struct gendisk *disk, struct nvme_ns *ns,
 
 	q->limits.zoned = BLK_ZONED_HM;
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
+	blk_queue_max_open_zones(q, le32_to_cpu(id->mor) + 1);
 free_data:
 	kfree(id);
 	return status;
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 183a20720da9..aa3564139b40 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -717,6 +717,10 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	/* The drive satisfies the kernel restrictions: set it up */
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
 	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
+	if (sdkp->zones_max_open == U32_MAX)
+		blk_queue_max_open_zones(q, 0);
+	else
+		blk_queue_max_open_zones(q, sdkp->zones_max_open);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
 	/* READ16/WRITE16 is mandatory for ZBC disks */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 69ad13dacd48..8f558c6fd18b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -513,6 +513,7 @@ struct request_queue {
 	unsigned int		nr_zones;
 	unsigned long		*conv_zones_bitmap;
 	unsigned long		*seq_zones_wlock;
+	unsigned int		max_open_zones;
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 	/*
@@ -722,6 +723,17 @@ static inline bool blk_queue_zone_is_seq(struct request_queue *q,
 		return true;
 	return !test_bit(blk_queue_zone_no(q, sector), q->conv_zones_bitmap);
 }
+
+static inline void blk_queue_max_open_zones(struct request_queue *q,
+		unsigned int max_open_zones)
+{
+	q->max_open_zones = max_open_zones;
+}
+
+static inline unsigned int queue_max_open_zones(const struct request_queue *q)
+{
+	return q->max_open_zones;
+}
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
 {
@@ -737,6 +749,10 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
 {
 	return 0;
 }
+static inline unsigned int queue_max_open_zones(const struct request_queue *q)
+{
+	return 0;
+}
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 static inline bool rq_is_sync(struct request *rq)
@@ -1520,6 +1536,15 @@ static inline sector_t bdev_zone_sectors(struct block_device *bdev)
 	return 0;
 }
 
+static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (q)
+		return queue_max_open_zones(q);
+	return 0;
+}
+
 static inline int queue_dma_alignment(const struct request_queue *q)
 {
 	return q ? q->dma_alignment : 511;
-- 
2.26.2

