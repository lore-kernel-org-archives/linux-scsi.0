Return-Path: <SRS0=HQac=AN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E268C433E4
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 18:20:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B57520870
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jul 2020 18:20:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="CRrt4iP7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgGBST6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jul 2020 14:19:58 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:23401 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbgGBST4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jul 2020 14:19:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1593713995; x=1625249995;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SvFE2bHAH+Kw0YnhTxvsAs2nLmEUXkT7BrexgMWERgE=;
  b=CRrt4iP7PFQKq2MHMEtdtDwyJMEa+ZIgYA1lPc7ut6qRNJ06g2VaLaZA
   +9DaKJ8mHWdn+M34+BaJSR4i9Is0SoquWdD8sX3vunoFqhaO3/JNksEjW
   sOLnr5dxqkyjFUhltLqOxGlJUZidX+jp1lcZpuEEVGVuPxzcOnTT8MzNh
   bXFtiPBcReoAcTxKIZ0s3Fv4GAl2i0Xjzqj2r4ZV8PvPwqINh7ae81/Qu
   EVYAHLRLxu2+tNvL5VdajRcL1Nx1BOt8G2VKYKwcSYTGFbDzRK8pha5LQ
   GRTfVT+k/YbcIPQbeaqRiim/q4++85D5d3fzZWm7FsNMFKMJH9lw7uNWQ
   g==;
IronPort-SDR: 2XL8HaX927aEzPdFmOG0QESWluSHbteWaTepXpqpAV/Iat0rmFnWnIki07MF8Vt+C0lqdwKzia
 hIE2V8heOOwIZomGTVKKKdgYv2L38rd9xYOEdM2UC2SVeaGKs5++yQYqaDAgoU/TLCKeUTcldH
 Cl9Cg0MBq47Gn+9emLkPpWauNvSGaF2Xyk4BJjqr6Fq+AFgs6pKC5Qpr1hHMRIoDppwoWvmmj5
 zvMRgtE9bjm5uR0xaHEpSVPfrm+p70Cy9vtkadlFC2Dy0MCs9sCcPWXgBdrmKz1z81CD5pm6a+
 kKo=
X-IronPort-AV: E=Sophos;i="5.75,305,1589212800"; 
   d="scan'208";a="142854305"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Jul 2020 02:19:55 +0800
IronPort-SDR: TZxXH3crJnRQAH12CVfreL83ZdaeCPEtwER+lWEI7ete32Ry3FLwU9taT11RUX6uQ02BXw1eTk
 ZIyI+KX41dfGwIlAFkJW3N3idug5YgjFw=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2020 11:08:42 -0700
IronPort-SDR: iMgIrhVY0SYcbcVyY68/fxETSNvtlgDTu93PuZc2r/rkeZjUYdDmLFySjuqltul+JHvqy5aOzO
 zE6Y7YJUP1Vw==
WDCIronportException: Internal
Received: from caiyi-lt.ad.shared (HELO localhost.hgst.com) ([10.86.58.119])
  by uls-op-cesaip01.wdc.com with ESMTP; 02 Jul 2020 11:19:51 -0700
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
Subject: [PATCH v2 2/2] block: add max_active_zones to blk-sysfs
Date:   Thu,  2 Jul 2020 20:19:22 +0200
Message-Id: <20200702181922.24190-3-niklas.cassel@wdc.com>
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
---
 Documentation/block/queue-sysfs.rst |  7 +++++++
 block/blk-sysfs.c                   | 14 +++++++++++++-
 drivers/nvme/host/zns.c             |  1 +
 drivers/scsi/sd_zbc.c               |  1 +
 include/linux/blkdev.h              | 16 ++++++++++++++++
 5 files changed, 38 insertions(+), 1 deletion(-)

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
index fa42961e9678..624bb4d85fc7 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -310,6 +310,11 @@ static ssize_t queue_max_open_zones_show(struct request_queue *q, char *page)
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
@@ -677,6 +682,11 @@ static struct queue_sysfs_entry queue_max_open_zones_entry = {
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
@@ -776,6 +786,7 @@ static struct attribute *queue_attrs[] = {
 	&queue_zoned_entry.attr,
 	&queue_nr_zones_entry.attr,
 	&queue_max_open_zones_entry.attr,
+	&queue_max_active_zones_entry.attr,
 	&queue_nomerges_entry.attr,
 	&queue_rq_affinity_entry.attr,
 	&queue_iostats_entry.attr,
@@ -803,7 +814,8 @@ static umode_t queue_attr_visible(struct kobject *kobj, struct attribute *attr,
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
index fe168abcfdda..bb9e6eb6a7e6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -521,6 +521,7 @@ struct request_queue {
 	unsigned long		*conv_zones_bitmap;
 	unsigned long		*seq_zones_wlock;
 	unsigned int		max_open_zones;
+	unsigned int		max_active_zones;
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 	/*
@@ -741,6 +742,17 @@ static inline unsigned int queue_max_open_zones(const struct request_queue *q)
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
@@ -760,6 +772,10 @@ static inline unsigned int queue_max_open_zones(const struct request_queue *q)
 {
 	return 0;
 }
+static inline unsigned int queue_max_active_zones(const struct request_queue *q)
+{
+	return 0;
+}
 #endif /* CONFIG_BLK_DEV_ZONED */
 
 static inline bool rq_is_sync(struct request *rq)
-- 
2.26.2

