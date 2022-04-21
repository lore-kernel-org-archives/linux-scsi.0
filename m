Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 181A8C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 18:30:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391388AbiDUSdn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 14:33:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391354AbiDUSdd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 14:33:33 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B672F4BB81
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:42 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id d23-20020a17090a115700b001d2bde6c234so5950141pje.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3sUcPhWk4UZGD/LCG+ymTIg5avupQuvVBZpeiA+1el0=;
        b=x9lScGjAtk+Qc+cD017u+/eNGJSCKKzWOpcUvl2Es+ycjcCsq1LIUu7wr5rhpUr9mh
         mTOQxc/nInGyXvqcBeBo9Tsgm5AZApwAR6fi1nUTb2U55hsFhS+IuNxkZAySUz+lOf4R
         dJR4Q1iWtZLDyrNRk10/LEqavZ/zeKkNVjZMSbYMeVec7KzFpAuMEm05hL9uXEvoToPK
         V9TY889Uump80mTTT6bx2KuPHs+wsW7jcEvf5khC7x6muZnCEx1LKTS/W02+2ftNIiMY
         NDEVfFUDQJkqsV8WAyoBGMOEP2SidygX6OAQzDzHsXV5dCXOkhQnaiqRRLXPrJln32I9
         SrUQ==
X-Gm-Message-State: AOAM530ykfb2/jtb6+5F+lde+waWJLc3IOKZ4otgeXtaa5U9ZbORguhC
        +jA54RoXORSobDFzofjZBHE=
X-Google-Smtp-Source: ABdhPJy4pSeNdGInmM19S8zunnebz1MmYR3cdu17RFj429yO/uozMU74CMO2vkf4cxn85/sm92n2pw==
X-Received: by 2002:a17:90a:7c04:b0:1d7:d7e6:2916 with SMTP id v4-20020a17090a7c0400b001d7d7e62916mr122636pjf.25.1650565841878;
        Thu, 21 Apr 2022 11:30:41 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a034:31d8:ca4e:1f35])
        by smtp.gmail.com with ESMTPSA id a22-20020a62d416000000b0050bd98eaccbsm2181079pfh.213.2022.04.21.11.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 11:30:41 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 4/9] scsi: sd_zbc: Introduce struct zoned_disk_info
Date:   Thu, 21 Apr 2022 11:30:18 -0700
Message-Id: <20220421183023.3462291-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
In-Reply-To: <20220421183023.3462291-1-bvanassche@acm.org>
References: <20220421183023.3462291-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Deriving the meaning of the nr_zones, rev_nr_zones, zone_blocks and
rev_zone_blocks member variables requires careful analysis of the source
code. Make the meaning of these member variables easier to understand by
introducing struct zoned_disk_info.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.h     | 22 +++++++++++++++----
 drivers/scsi/sd_zbc.c | 49 ++++++++++++++++++++-----------------------
 2 files changed, 41 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 4849cbe771a7..47434f905b0a 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -67,6 +67,20 @@ enum {
 	SD_ZERO_WS10_UNMAP,	/* Use WRITE SAME(10) with UNMAP */
 };
 
+/**
+ * struct zoned_disk_info - Specific properties of a ZBC SCSI device.
+ * @nr_zones: number of zones.
+ * @zone_blocks: number of logical blocks per zone.
+ *
+ * This data structure holds the ZBC SCSI device properties that are retrieved
+ * twice: a first time before the gendisk capacity is known and a second time
+ * after the gendisk capacity is known.
+ */
+struct zoned_disk_info {
+	u32		nr_zones;
+	u32		zone_blocks;
+};
+
 struct scsi_disk {
 	struct scsi_device *device;
 
@@ -78,10 +92,10 @@ struct scsi_disk {
 	struct gendisk	*disk;
 	struct opal_dev *opal_dev;
 #ifdef CONFIG_BLK_DEV_ZONED
-	u32		nr_zones;
-	u32		rev_nr_zones;
-	u32		zone_blocks;
-	u32		rev_zone_blocks;
+	/* Updated during revalidation before the gendisk capacity is known. */
+	struct zoned_disk_info	early_zone_info;
+	/* Updated during revalidation after the gendisk capacity is known. */
+	struct zoned_disk_info	zone_info;
 	u32		zones_optimal_open;
 	u32		zones_optimal_nonseq;
 	u32		zones_max_open;
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index e76bcbfd0d1c..ac557a5a65c8 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -181,7 +181,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
 	 * sure that the allocated buffer can always be mapped by limiting the
 	 * number of pages allocated to the HBA max segments limit.
 	 */
-	nr_zones = min(nr_zones, sdkp->nr_zones);
+	nr_zones = min(nr_zones, sdkp->zone_info.nr_zones);
 	bufsize = roundup((nr_zones + 1) * 64, SECTOR_SIZE);
 	bufsize = min_t(size_t, bufsize,
 			queue_max_hw_sectors(q) << SECTOR_SHIFT);
@@ -206,7 +206,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
  */
 static inline sector_t sd_zbc_zone_sectors(struct scsi_disk *sdkp)
 {
-	return logical_to_sectors(sdkp->device, sdkp->zone_blocks);
+	return logical_to_sectors(sdkp->device, sdkp->zone_info.zone_blocks);
 }
 
 /**
@@ -262,7 +262,7 @@ int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 			zone_idx++;
 		}
 
-		lba += sdkp->zone_blocks * i;
+		lba += sdkp->zone_info.zone_blocks * i;
 	}
 
 	ret = zone_idx;
@@ -320,14 +320,14 @@ static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)
 	sdkp = container_of(work, struct scsi_disk, zone_wp_offset_work);
 
 	spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
-	for (zno = 0; zno < sdkp->nr_zones; zno++) {
+	for (zno = 0; zno < sdkp->zone_info.nr_zones; zno++) {
 		if (sdkp->zones_wp_offset[zno] != SD_ZBC_UPDATING_WP_OFST)
 			continue;
 
 		spin_unlock_irqrestore(&sdkp->zones_wp_offset_lock, flags);
 		ret = sd_zbc_do_report_zones(sdkp, sdkp->zone_wp_update_buf,
 					     SD_BUF_SIZE,
-					     zno * sdkp->zone_blocks, true);
+					     zno * sdkp->zone_info.zone_blocks, true);
 		spin_lock_irqsave(&sdkp->zones_wp_offset_lock, flags);
 		if (!ret)
 			sd_zbc_parse_report(sdkp, sdkp->zone_wp_update_buf + 64,
@@ -394,7 +394,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 		break;
 	default:
 		wp_offset = sectors_to_logical(sdkp->device, wp_offset);
-		if (wp_offset + nr_blocks > sdkp->zone_blocks) {
+		if (wp_offset + nr_blocks > sdkp->zone_info.zone_blocks) {
 			ret = BLK_STS_IOERR;
 			break;
 		}
@@ -523,7 +523,7 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 		break;
 	case REQ_OP_ZONE_RESET_ALL:
 		memset(sdkp->zones_wp_offset, 0,
-		       sdkp->nr_zones * sizeof(unsigned int));
+		       sdkp->zone_info.nr_zones * sizeof(unsigned int));
 		break;
 	default:
 		break;
@@ -680,16 +680,16 @@ static void sd_zbc_print_zones(struct scsi_disk *sdkp)
 	if (!sd_is_zoned(sdkp) || !sdkp->capacity)
 		return;
 
-	if (sdkp->capacity & (sdkp->zone_blocks - 1))
+	if (sdkp->capacity & (sdkp->zone_info.zone_blocks - 1))
 		sd_printk(KERN_NOTICE, sdkp,
 			  "%u zones of %u logical blocks + 1 runt zone\n",
-			  sdkp->nr_zones - 1,
-			  sdkp->zone_blocks);
+			  sdkp->zone_info.nr_zones - 1,
+			  sdkp->zone_info.zone_blocks);
 	else
 		sd_printk(KERN_NOTICE, sdkp,
 			  "%u zones of %u logical blocks\n",
-			  sdkp->nr_zones,
-			  sdkp->zone_blocks);
+			  sdkp->zone_info.nr_zones,
+			  sdkp->zone_info.zone_blocks);
 }
 
 static int sd_zbc_init_disk(struct scsi_disk *sdkp)
@@ -716,10 +716,8 @@ static void sd_zbc_clear_zone_info(struct scsi_disk *sdkp)
 	kfree(sdkp->zone_wp_update_buf);
 	sdkp->zone_wp_update_buf = NULL;
 
-	sdkp->nr_zones = 0;
-	sdkp->rev_nr_zones = 0;
-	sdkp->zone_blocks = 0;
-	sdkp->rev_zone_blocks = 0;
+	sdkp->early_zone_info = (struct zoned_disk_info){ };
+	sdkp->zone_info = (struct zoned_disk_info){ };
 
 	mutex_unlock(&sdkp->rev_mutex);
 }
@@ -746,8 +744,8 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 {
 	struct gendisk *disk = sdkp->disk;
 	struct request_queue *q = disk->queue;
-	u32 zone_blocks = sdkp->rev_zone_blocks;
-	unsigned int nr_zones = sdkp->rev_nr_zones;
+	u32 zone_blocks = sdkp->early_zone_info.zone_blocks;
+	unsigned int nr_zones = sdkp->early_zone_info.nr_zones;
 	u32 max_append;
 	int ret = 0;
 	unsigned int flags;
@@ -778,14 +776,14 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	 */
 	mutex_lock(&sdkp->rev_mutex);
 
-	if (sdkp->zone_blocks == zone_blocks &&
-	    sdkp->nr_zones == nr_zones &&
+	if (sdkp->zone_info.zone_blocks == zone_blocks &&
+	    sdkp->zone_info.nr_zones == nr_zones &&
 	    disk->queue->nr_zones == nr_zones)
 		goto unlock;
 
 	flags = memalloc_noio_save();
-	sdkp->zone_blocks = zone_blocks;
-	sdkp->nr_zones = nr_zones;
+	sdkp->zone_info.zone_blocks = zone_blocks;
+	sdkp->zone_info.nr_zones = nr_zones;
 	sdkp->rev_wp_offset = kvcalloc(nr_zones, sizeof(u32), GFP_KERNEL);
 	if (!sdkp->rev_wp_offset) {
 		ret = -ENOMEM;
@@ -800,8 +798,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	sdkp->rev_wp_offset = NULL;
 
 	if (ret) {
-		sdkp->zone_blocks = 0;
-		sdkp->nr_zones = 0;
+		sdkp->zone_info = (struct zoned_disk_info){ };
 		sdkp->capacity = 0;
 		goto unlock;
 	}
@@ -887,8 +884,8 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 	if (blk_queue_zoned_model(q) == BLK_ZONED_HM)
 		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
 
-	sdkp->rev_nr_zones = nr_zones;
-	sdkp->rev_zone_blocks = zone_blocks;
+	sdkp->early_zone_info.nr_zones = nr_zones;
+	sdkp->early_zone_info.zone_blocks = zone_blocks;
 
 	return 0;
 
