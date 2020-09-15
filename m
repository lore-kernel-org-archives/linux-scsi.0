Return-Path: <SRS0=8u70=CY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7120C2D0E1
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 07:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 470F221D41
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Sep 2020 07:34:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="a/j+k54N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726153AbgIOHeA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Sep 2020 03:34:00 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:12672 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbgIOHdx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Sep 2020 03:33:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1600155234; x=1631691234;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BWXURWoEU09CQRUd6Fu9A8rMOw3FgaA6TZmwY7+vSlY=;
  b=a/j+k54Nz3H+21AbRSjB+4iFQJ9ZQFpFE/7qyhXqcdzPEe2DB5XoO7od
   lw7JYfWAGt9gZQSDQ1vGG7m8lCTwd0K1wx7P+Oh0TcKqzz5cRTB+plJ0Z
   KXwvo/P5AlefZXlJNm2QK55tIy+EIktD9J1MP0rI3zsq5sPOvGRczIAyz
   8gG5WM0NbYaZk1CFFg3LjsGo7kovram/aw2vOZDz57JRy2jfHkVR643/4
   gAQmK7uc7pi3jDvmcMZoUwfQBVB5NEQrs6rBWfrMbeFvHSapinzq/5ocn
   /VXkXmEU6kRY6FtsE7QQfSoFDeuDyJGOk7wk/TSDoapI6mfK4C2ymnhdU
   Q==;
IronPort-SDR: 0eHpGmBGiX76IlUNUkiWptSHyzx2i7WWEC3Aw2DNK99djpbIJTHlVDpUCYYJQd64vHrhE6lJiG
 IMABVqLelkbM2PmCcL4M14Ue65cNzasOH5abRtzQ+LkrBQWTAli5hfohcztmSJfpqBsejRGeWO
 DMsdhnniRs6YyAW0rizKU2Y8JvMtFIqVv97u5MgHDU8FKfo3uWfnDM4nSabuNBQxPk9xz82L6i
 FAIqqpwhrM2KIBel6+PhO5UOcsSynCF3d/exD8zRGqUwYrlLlKjC7wm6Vh7hKFFAWkCY+yFvHj
 +wM=
X-IronPort-AV: E=Sophos;i="5.76,429,1592841600"; 
   d="scan'208";a="147405118"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 15 Sep 2020 15:33:54 +0800
IronPort-SDR: GFze0GxqoYq24RtApHbWRzwkjH1BiTpfPrNMyFAmvFmsBk8wSfY1h/AfrYtxqJEkPMtCDO9SpT
 BEpl9x+Wm1MA==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2020 00:21:03 -0700
IronPort-SDR: fubIrKCPuHJxRST5xR7N2CQxBcJnqZsGGkLbXTUJTrUlWvwth/K38cvgsH16clJPhGp+cMxmik
 rWzfCFUYecaQ==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 15 Sep 2020 00:33:51 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@suse.de>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH v3 1/2] scsi: Fix handling of host-aware ZBC disks
Date:   Tue, 15 Sep 2020 16:33:46 +0900
Message-Id: <20200915073347.832424-2-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200915073347.832424-1-damien.lemoal@wdc.com>
References: <20200915073347.832424-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When CONFIG_BLK_DEV_ZONED is disabled, allow using host-aware ZBC
disks as regular disks. In this case, ensure that command completion
is correctly executed by changing sd_zbc_complete() to return good_bytes
instead of 0 and causing a hang during device probe (endless retries).

When CONFIG_BLK_DEV_ZONED is enabled and a host-aware disk is detected
to have partitions, it will be used as a regular disk. In this case,
make sure to not do anything in sd_zbc_revalidate_zones() as that
triggers warnings.

Since all these different cases result in subtle settings of the disk
queue zoned model, introduce the block layer helper function
blk_queue_set_zoned() to generically implement setting up the effective
zoned model according to the disk type, the presence of partitions on
the disk and CONFIG_BLK_DEV_ZONED configuration.

Reported-by: Borislav Petkov <bp@alien8.de>
Suggested-by: Christoph Hellwig <hch@infradead.org>
Fixes: b72053072c0b ("block: allow partitions on host aware zone devices")
Cc: <stable@vger.kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-settings.c   | 46 ++++++++++++++++++++++++++++++++++++++++++
 drivers/scsi/sd.c      | 30 ++++++++++++++++-----------
 drivers/scsi/sd.h      |  2 +-
 drivers/scsi/sd_zbc.c  |  6 +++++-
 include/linux/blkdev.h |  2 ++
 5 files changed, 72 insertions(+), 14 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 76a7e03bcd6c..34b721a2743a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -801,6 +801,52 @@ bool blk_queue_can_use_dma_map_merging(struct request_queue *q,
 }
 EXPORT_SYMBOL_GPL(blk_queue_can_use_dma_map_merging);
 
+/**
+ * blk_queue_set_zoned - configure a disk queue zoned model.
+ * @disk:	the gendisk of the queue to configure
+ * @model:	the zoned model to set
+ *
+ * Set the zoned model of the request queue of @disk according to @model.
+ * When @model is BLK_ZONED_HM (host managed), this should be called only
+ * if zoned block device support is enabled (CONFIG_BLK_DEV_ZONED option).
+ * If @model specifies BLK_ZONED_HA (host aware), the effective model used
+ * depends on CONFIG_BLK_DEV_ZONED settings and on the existence of partitions
+ * on the disk.
+ */
+void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model)
+{
+	switch (model) {
+	case BLK_ZONED_HM:
+		/*
+		 * Host managed devices are supported only if
+		 * CONFIG_BLK_DEV_ZONED is enabled.
+		 */
+		WARN_ON_ONCE(!IS_ENABLED(CONFIG_BLK_DEV_ZONED));
+		break;
+	case BLK_ZONED_HA:
+		/*
+		 * Host aware devices can be treated either as regular block
+		 * devices (similar to drive managed devices) or as zoned block
+		 * devices to take advantage of the zone command set, similarly
+		 * to host managed devices. We try the latter if there are no
+		 * partitions and zoned block device support is enabled, else
+		 * we do nothing special as far as the block layer is concerned.
+		 */
+		if (!IS_ENABLED(CONFIG_BLK_DEV_ZONED) ||
+		    disk_has_partitions(disk))
+			model = BLK_ZONED_NONE;
+		break;
+	case BLK_ZONED_NONE:
+	default:
+		if (WARN_ON_ONCE(model != BLK_ZONED_NONE))
+			model = BLK_ZONED_NONE;
+		break;
+	}
+
+	disk->queue->limits.zoned = model;
+}
+EXPORT_SYMBOL_GPL(blk_queue_set_zoned);
+
 static int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 95018e650f2d..06286b6aeaec 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2964,26 +2964,32 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 
 	if (sdkp->device->type == TYPE_ZBC) {
 		/* Host-managed */
-		q->limits.zoned = BLK_ZONED_HM;
+		blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HM);
 	} else {
 		sdkp->zoned = (buffer[8] >> 4) & 3;
-		if (sdkp->zoned == 1 && !disk_has_partitions(sdkp->disk)) {
+		if (sdkp->zoned == 1) {
 			/* Host-aware */
-			q->limits.zoned = BLK_ZONED_HA;
+			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HA);
 		} else {
-			/*
-			 * Treat drive-managed devices and host-aware devices
-			 * with partitions as regular block devices.
-			 */
-			q->limits.zoned = BLK_ZONED_NONE;
-			if (sdkp->zoned == 2 && sdkp->first_scan)
-				sd_printk(KERN_NOTICE, sdkp,
-					  "Drive-managed SMR disk\n");
+			/* Regular disk or drive managed disk */
+			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_NONE);
 		}
 	}
-	if (blk_queue_is_zoned(q) && sdkp->first_scan)
+
+	if (!sdkp->first_scan)
+		goto out;
+
+	if (blk_queue_is_zoned(q)) {
 		sd_printk(KERN_NOTICE, sdkp, "Host-%s zoned block device\n",
 		      q->limits.zoned == BLK_ZONED_HM ? "managed" : "aware");
+	} else {
+		if (sdkp->zoned == 1)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Host-aware SMR disk used as regular disk\n");
+		else if (sdkp->zoned == 2)
+			sd_printk(KERN_NOTICE, sdkp,
+				  "Drive-managed SMR disk\n");
+	}
 
  out:
 	kfree(buffer);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 4933e7daf17d..7251434100e6 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -259,7 +259,7 @@ static inline blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
 static inline unsigned int sd_zbc_complete(struct scsi_cmnd *cmd,
 			unsigned int good_bytes, struct scsi_sense_hdr *sshdr)
 {
-	return 0;
+	return good_bytes;
 }
 
 static inline blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd,
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 0e94ff056bff..a739456dea02 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -667,7 +667,11 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	u32 max_append;
 	int ret = 0;
 
-	if (!sd_is_zoned(sdkp))
+	/*
+	 * There is nothing to do for regular disks, including host-aware disks
+	 * that have partitions.
+	 */
+	if (!blk_queue_is_zoned(q))
 		return 0;
 
 	/*
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bb5636cc17b9..868e11face00 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -352,6 +352,8 @@ struct queue_limits {
 typedef int (*report_zones_cb)(struct blk_zone *zone, unsigned int idx,
 			       void *data);
 
+void blk_queue_set_zoned(struct gendisk *disk, enum blk_zoned_model model);
+
 #ifdef CONFIG_BLK_DEV_ZONED
 
 #define BLK_ALL_ZONES  ((unsigned int)-1)
-- 
2.26.2

