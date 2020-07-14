Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48EACC433F2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 21:18:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21DAA20658
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 21:18:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="l2wEnZvq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgGNVSu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 17:18:50 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:40336 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgGNVSt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 17:18:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594761528; x=1626297528;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bWuqzbHA4O2WchwH+B4L7HQhS8/DqqEhr1nJBlmjemk=;
  b=l2wEnZvqLAoi3Ap1iU7483s+IeZKzVUoBwA9LTF4QEYUV36Gdp1fVE9v
   +DJcgvlJIwL3wIfdDoe0aEhKXVyHRaUUrj6ibQ6khycoqeNokji7P3XdM
   kbRdoSzTdcrIUVvuIWieIq8hgD/yGIf212ZsRSvkArGXkd/UBHbLIM90S
   WTxiDYGmnRn/R/MgVNudLP+5TPIE3w09qr+i1G0wncpIY+fehhcJe6ZFw
   4mZpXoIh/UTNHJfbf1Vdys3+XsJ+HjpAQXBWIwiVK+Ixl/1xigQPHW6ry
   Ku0F5WAkeCDYvA6fFfp3gt+s0fWbY1phbNMhHTlJ4rvG9D8j6OlISLILT
   A==;
IronPort-SDR: D1901dtWYeLswVPXvbcA6kfQlNeH17Pzl8mlmo/Rf9YLHlwmuemQ0j/NmxECx9ABs8IS6qoIOo
 0lbVhjbgdbGLLJruLG3u5wu9+fZWrXEK6Hps/GMfQHC4ohs9Po/DXSOQhZB5dSa96nwWzgDQqA
 ky/sU43S8zrGJUSN5ot76C3YIFeYF5g1wR+wvuoA23WvyIrzA3PUO7mPL1d/AhwiTeEkr53PJ1
 GjRQCTWEaFst0ps3PZinODyT19gmjyUWgfjXiVoomAgGLYDlWkZfmgVVHZTk04q2qEWDfwJh77
 wLM=
X-IronPort-AV: E=Sophos;i="5.75,352,1589212800"; 
   d="scan'208";a="146776552"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jul 2020 05:18:48 +0800
IronPort-SDR: fjqpmtvmaeO8y77E2xDxYVyW7TJRyUzGoAS5ywEniWwQyuzWm88Vxc+WHDsKElLQ3OaqCriQ/2
 YRGnvj24ea1H3k8uUNuBv3uGBam3oVLSM=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2020 14:07:14 -0700
IronPort-SDR: ZyAshRSo1jGSBw4ONlIVJTEHiIsC4Gtc+J1MCOqmJ+dJpE5uYoAOh+nX4qvWavHI7Yz4c6tdsJ
 F+s25NwdO/NA==
WDCIronportException: Internal
Received: from usa003306.ad.shared (HELO localhost.hgst.com) ([10.86.57.226])
  by uls-op-cesaip01.wdc.com with ESMTP; 14 Jul 2020 14:18:43 -0700
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
Subject: [PATCH v3 2/2] block: add max_active_zones to blk-sysfs
Date:   Tue, 14 Jul 2020 23:18:24 +0200
Message-Id: <20200714211824.759224-3-niklas.cassel@wdc.com>
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

Add a new max_active zones definition in the sysfs documentation.
This definition will be common for all devices utilizing the zoned block
device support in the kernel.

Export max_active_zones according to this new definition for NVMe Zoned
Namespace devices, ZAC ATA devices (which are treated as SCSI devices by
the kernel), and ZBC SCSI devices.

Add the new max_active_zones member to struct request_queue, rather
than as a queue limit, since this property cannot be split across stacking
drivers.

For SCSI devices, even though max active zones is not part of the ZBC/ZAC
spec, export max_active_zones as 0, signifying "no limit".

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Javier González <javier@javigon.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 Documentation/ABI/testing/sysfs-block |  9 +++++++++
 Documentation/block/queue-sysfs.rst   |  7 +++++++
 block/blk-sysfs.c                     | 14 +++++++++++++-
 drivers/nvme/host/zns.c               |  1 +
 drivers/scsi/sd_zbc.c                 |  1 +
 include/linux/blkdev.h                | 25 +++++++++++++++++++++++++
 6 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index f151d9cf90de..2322eb748b38 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -273,6 +273,15 @@ Description:
 		device ("host-aware" or "host-managed" zone model). For regular
 		block devices, the value is always 0.
 
+What:		/sys/block/<disk>/queue/max_active_zones
+Date:		July 2020
+Contact:	Niklas Cassel <niklas.cassel@wdc.com>
+Description:
+		For zoned block devices (zoned attribute indicating
+		"host-managed" or "host-aware"), the sum of zones belonging to
+		any of the zone states: EXPLICIT OPEN, IMPLICIT OPEN or CLOSED,
+		is limited by this value. If this value is 0, there is no limit.
+
 What:		/sys/block/<disk>/queue/max_open_zones
 Date:		July 2020
 Contact:	Niklas Cassel <niklas.cassel@wdc.com>
diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
index f01cf8530ae4..f261a5c84170 100644
--- a/Documentation/block/queue-sysfs.rst
+++ b/Documentation/block/queue-sysfs.rst
@@ -117,6 +117,13 @@ Maximum number of elements in a DMA scatter/gather list with integrity
 data that will be submitted by the block layer core to the associated
 block driver.
 
+max_active_zones (RO)
+---------------------
+For zoned block devices (zoned attribute indicating "host-managed" or
+"host-aware"), the sum of zones belonging to any of the zone states:
+EXPLICIT OPEN, IMPLICIT OPEN or CLOSED, is limited by this value.
+If this value is 0, there is no limit.
+
 max_open_zones (RO)
 -------------------
 For zoned block devices (zoned attribute indicating "host-managed" or
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 414f04579d77..7dda709f3ccb 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -311,6 +311,11 @@ static ssize_t queue_max_open_zones_show(struct request_queue *q, char *page)
 	return queue_var_show(queue_max_open_zones(q), page);
 }
 
+static ssize_t queue_max_active_zones_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(queue_max_active_zones(q), page);
+}
+
 static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
 {
 	return queue_var_show((blk_queue_nomerges(q) << 1) |
@@ -678,6 +683,11 @@ static struct queue_sysfs_entry queue_max_open_zones_entry = {
 	.show = queue_max_open_zones_show,
 };
 
+static struct queue_sysfs_entry queue_max_active_zones_entry = {
+	.attr = {.name = "max_active_zones", .mode = 0444 },
+	.show = queue_max_active_zones_show,
+};
+
 static struct queue_sysfs_entry queue_nomerges_entry = {
 	.attr = {.name = "nomerges", .mode = 0644 },
 	.show = queue_nomerges_show,
@@ -777,6 +787,7 @@ static struct attribute *queue_attrs[] = {
 	&queue_zoned_entry.attr,
 	&queue_nr_zones_entry.attr,
 	&queue_max_open_zones_entry.attr,
+	&queue_max_active_zones_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
 	&queue_iostats_entry.attr,
@@ -804,7 +815,8 @@ static umode_t queue_attr_visible(struct kobject *kobj, struct attribute *attr,
 		(!q->mq_ops || !q->mq_ops->timeout))
 			return 0;
 
-	if (attr == &queue_max_open_zones_entry.attr &&
+	if ((attr == &queue_max_open_zones_entry.attr ||
+	     attr == &queue_max_active_zones_entry.attr) &&
 	    !blk_queue_is_zoned(q))
 		return 0;
 
diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index 3d80b9cf6bfc..57cfd78731fb 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -97,6 +97,7 @@ int nvme_update_zone_info(struct gendisk *disk, struct nvme_ns *ns,
 	q->limits.zoned = BLK_ZONED_HM;
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
 	blk_queue_max_open_zones(q, le32_to_cpu(id->mor) + 1);
+	blk_queue_max_active_zones(q, le32_to_cpu(id->mar) + 1);
 free_data:
 	kfree(id);
 	return status;
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index aa3564139b40..d8b2c49d645b 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -721,6 +721,7 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 		blk_queue_max_open_zones(q, 0);
 	else
 		blk_queue_max_open_zones(q, sdkp->zones_max_open);
+	blk_queue_max_active_zones(q, 0);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
 	/* READ16/WRITE16 is mandatory for ZBC disks */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 8f558c6fd18b..692ddaf07dc4 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -514,6 +514,7 @@ struct request_queue {
 	unsigned long		*conv_zones_bitmap;
 	unsigned long		*seq_zones_wlock;
 	unsigned int		max_open_zones;
+	unsigned int		max_active_zones;
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 	/*
@@ -734,6 +735,17 @@ static inline unsigned int queue_max_open_zones(const struct request_queue *q)
 {
 	return q->max_open_zones;
 }
+
+static inline void blk_queue_max_active_zones(struct request_queue *q,
+		unsigned int max_active_zones)
+{
+	q->max_active_zones = max_active_zones;
+}
+
+static inline unsigned int queue_max_active_zones(const struct request_queue *q)
+{
+	return q->max_active_zones;
+}
 #else /* CONFIG_BLK_DEV_ZONED */
 static inline unsigned int blk_queue_nr_zones(struct request_queue *q)
 {
@@ -753,6 +765,10 @@ static inline unsigned int queue_max_open_zones(const struct request_queue *q)
 {
 	return 0;
 }
+static inline unsigned int queue_max_active_zones(const struct request_queue *q)
+{
+	return 0;
+}
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 static inline bool rq_is_sync(struct request *rq)
@@ -1545,6 +1561,15 @@ static inline unsigned int bdev_max_open_zones(struct block_device *bdev)
 	return 0;
 }
 
+static inline unsigned int bdev_max_active_zones(struct block_device *bdev)
+{
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	if (q)
+		return queue_max_active_zones(q);
+	return 0;
+}
+
 static inline int queue_dma_alignment(const struct request_queue *q)
 {
 	return q ? q->dma_alignment : 511;
-- 
2.26.2

