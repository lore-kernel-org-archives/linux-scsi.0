Return-Path: <SRS0=Wxou=75=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14D34C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 10:28:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB7582074D
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Jun 2020 10:28:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="jG3WEUab"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgFPK2n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Jun 2020 06:28:43 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:10600 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726799AbgFPK0n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2020 06:26:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1592303203; x=1623839203;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qZXeZ35l6Tg1o+AfwPJ/dXEc3SOq2uKn6D1u3pjTLMs=;
  b=jG3WEUabKn5bOy8uRA/2AbIbsOIWXS+FyDGKFDyEL2RDrn1EqwRsuy5g
   gMKcxUFja3isT41hX0F5cNET18cppXAGdIobbFeHpiIh/t2varS4hxRag
   hO+KA8wGWFORxG35T+0Sf4UH32Uu0VchnuE0PpzoF2Xs9DrkjdyDDrW5M
   Ez95MXBVi0jJpQ5jlWznkGGc7jWQez7uDq9f9/RgQjDY/QByy+xWeL9Xi
   HVhQndEFqoWE96VjH/IQHNNDihe7/SQ7DAPKjB2oPkXWc5l9fO1KcELtg
   QIuF0M0if+kHed/2dNniiB8sfNWhV0Jd+tM2Z48cYOXiWR47E7jaf0umI
   A==;
IronPort-SDR: MCTN1DAS8ATutlSXZnMs/ZoFPlEffF55Yqt5COj8AYfdcxInYunGd9x51skbWz3wIAUijMn8va
 vhUpHlXaYtzpQJTIl6WND1iSqnIv2YdPRo8Xc9+zfvoJuBvXFSEOlbAjh6UiyqBYlEedEtryqp
 ptnrs2/f94f8XNgezmeevYsSUzBZrNZ5uKvjXY8GD8rkoSCLiuw+TLoeN1WZ10SzFmbWMs8rSv
 RruZC5gFBz93d3q1MtaRNLkBtVFmqRGoDZOWwIlLEhHGv46DkP6ZWSRMQKw5GhE8g2QgRW4RQj
 Fko=
X-IronPort-AV: E=Sophos;i="5.73,518,1583164800"; 
   d="scan'208";a="140116393"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jun 2020 18:26:06 +0800
IronPort-SDR: tLIRBJaX2dkfOvqhI+dYYXJK9+F1XW4TN07t+Cm9YAfytJQ6zwxqs3ojNeaVlR7SPzAn1C98da
 DU0TXN06RYmIzcQhwqaSvG+8WnDcGATXE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2020 03:15:23 -0700
IronPort-SDR: iVnIWtXPA/dGk9U25h0fz3WY01cp3OSxm9g/5Ny9+bPX5ErXM93SaiV2bjG0BQ9mOLZpVdBiNR
 Kb09OVGViXdw==
WDCIronportException: Internal
Received: from 31yhj72.ad.shared (HELO localhost.hgst.com) ([10.86.58.100])
  by uls-op-cesaip02.wdc.com with ESMTP; 16 Jun 2020 03:26:00 -0700
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: [PATCH 1/2] block: add max_open_zones to blk-sysfs
Date:   Tue, 16 Jun 2020 12:25:45 +0200
Message-Id: <20200616102546.491961-2-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200616102546.491961-1-niklas.cassel@wdc.com>
References: <20200616102546.491961-1-niklas.cassel@wdc.com>
MIME-Version: 1.0
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

Add the new max_open_zones struct member to the request_queue, rather
than as a queue limit, since this property cannot be split across stacking
drivers.

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 Documentation/block/queue-sysfs.rst |  7 +++++++
 block/blk-sysfs.c                   | 15 +++++++++++++++
 drivers/nvme/host/zns.c             |  1 +
 drivers/scsi/sd_zbc.c               |  4 ++++
 include/linux/blkdev.h              | 20 ++++++++++++++++++++
 5 files changed, 47 insertions(+)

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
index 02643e149d5e..fa42961e9678 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -305,6 +305,11 @@ static ssize_t queue_nr_zones_show(struct request_queue *q, char *page)
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
@@ -667,6 +672,11 @@ static struct queue_sysfs_entry queue_nr_zones_entry = {
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
@@ -765,6 +775,7 @@ static struct attribute *queue_attrs[] = {
 	&queue_nonrot_entry.attr,
 	&queue_zoned_entry.attr,
 	&queue_nr_zones_entry.attr,
+	&queue_max_open_zones_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
 	&queue_iostats_entry.attr,
@@ -792,6 +803,10 @@ static umode_t queue_attr_visible(struct kobject *kobj, struct attribute *attr,
 		(!q->mq_ops || !q->mq_ops->timeout))
 			return 0;
 
+	if (attr == &queue_max_open_zones_entry.attr &&
+	    !blk_queue_is_zoned(q))
+		return 0;
+
 	return attr->mode;
 }
 
diff --git a/drivers/nvme/host/zns.c b/drivers/nvme/host/zns.c
index c08f6281b614..af156529f3b6 100644
--- a/drivers/nvme/host/zns.c
+++ b/drivers/nvme/host/zns.c
@@ -82,6 +82,7 @@ int nvme_update_zone_info(struct gendisk *disk, struct nvme_ns *ns,
 
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
index 8fd900998b4e..2f332f00501d 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -520,6 +520,7 @@ struct request_queue {
 	unsigned int		nr_zones;
 	unsigned long		*conv_zones_bitmap;
 	unsigned long		*seq_zones_wlock;
+	unsigned int		max_open_zones;
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 	/*
@@ -729,6 +730,17 @@ static inline bool blk_queue_zone_is_seq(struct request_queue *q,
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
@@ -744,6 +756,14 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
 {
 	return 0;
 }
+static inline void blk_queue_max_open_zones(struct request_queue *q,
+		unsigned int max_open_zones)
+{
+}
+static inline unsigned int queue_max_open_zones(const struct request_queue *q)
+{
+	return 0;
+}
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 static inline bool rq_is_sync(struct request *rq)
-- 
2.26.2

