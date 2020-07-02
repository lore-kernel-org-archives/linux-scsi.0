Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C94FC433E1
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 18:19:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC1C620885
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 18:19:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="BBaj79JJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728038AbgGBSTw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 14:19:52 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:23401 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgGBSTv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2020 14:19:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593713990; x=1625249990;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C96U6OLZtnSllFFqkpHK6KaLC68cZkLXzy+9vzfkRXc=;
  b=BBaj79JJ15IZa6Yqo+FduknmPSM9JtVPxcCDG0iMft+pxGhbi+KcITI/
   MABfgA3xaDNIMj67nYSjF+1Wiv4FX+O5KAduFQfQmXWEOrYifaQ4A/Mv4
   tlIkNAuKkTNTsRPxKvL3J/2ihkl5GUFfyt9EePZE1PF3O0llIKdJ5X6+O
   Ecgw+q8guEz2NtRDfpLC2jiVqoSalx0pSmCKBIr95j+nefCdJ6lOIg6SO
   W3119S3TK3ZfIykTuzJGGSLA4x59GJZP9E8pi1Wa4s+4sLG6/EQ1l4Ehx
   FcZ9jtTwD4wmc5RdYWlhEFMG/w9o4N1FDnL3uKI+YKkQ1TT+ym6enjkNN
   g==;
IronPort-SDR: OySU73GqASLYJvxmY1xRAzldwFNjIZBFpI8H0FvsC/MPajPyn/vaXWUn9iO0SV5oA6QdJc9WUZ
 xMST05WHYjVfQpm7cdVlMmOvP5vphNEHbVnsLEptkIk+dOKz6RPmHLjYCdQo2SixhPg8AO63ib
 LVpVW8gsDa40ziNoez3LTCH+zePE//Az46ZMS/LHi+f2tO7OPbhAtb5GNrZxB8MSG+Du8IXxK7
 6PD1gEOZvhdP+C/2MpWXGuk3FwPjjkH/2vyExAzpa8O3MaBNxOYhw7YMxSshFfnvdP3pdcHot9
 Y0E=
X-IronPort-AV: E=Sophos;i="5.75,305,1589212800"; 
   d="scan'208";a="142854301"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2020 02:19:50 +0800
IronPort-SDR: BxNhUxg6rmcS0lmDszCOvqISEdkKbgwqI4m9Rd8t80SE0OwFo5lqBDOnGt+k1pg1WngAYHGHWH
 tbkZCUc9oTSlaKkSYIHd68dh0JXDtrlNE=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 11:08:38 -0700
IronPort-SDR: QuJlHFIqHpCOsdeGocH5gvyNWfp3QVwVnDjosMt14leCh0vFWuJRrjCgCnVEiEbafyjQZO9GFo
 M2+wpJQWE15w==
WDCIronportException: Internal
Received: from caiyi-lt.ad.shared (HELO localhost.hgst.com) ([10.86.58.119])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Jul 2020 11:19:46 -0700
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        =?UTF-8?q?Javier=20Gonz=C3=A1lez?= <javier@javigon.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH v2 1/2] block: add max_open_zones to blk-sysfs
Date:   Thu,  2 Jul 2020 20:19:21 +0200
Message-Id: <20200702181922.24190-2-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200702181922.24190-1-niklas.cassel@wdc.com>
References: <20200702181922.24190-1-niklas.cassel@wdc.com>
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
---
 Documentation/block/queue-sysfs.rst |  7 +++++++
 block/blk-sysfs.c                   | 15 +++++++++++++++
 drivers/nvme/host/zns.c             |  1 +
 drivers/scsi/sd_zbc.c               |  4 ++++
 include/linux/blkdev.h              | 16 ++++++++++++++++
 5 files changed, 43 insertions(+)

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
index 8fd900998b4e..fe168abcfdda 100644
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
@@ -744,6 +756,10 @@ static inline unsigned int blk_queue_zone_no(struct request_queue *q,
 {
 	return 0;
 }
+static inline unsigned int queue_max_open_zones(const struct request_queue *q)
+{
+	return 0;
+}
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 static inline bool rq_is_sync(struct request *rq)
-- 
2.26.2

