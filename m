Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF3E6C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Apr 2022 20:18:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351716AbiDOUUl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Apr 2022 16:20:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351692AbiDOUUi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2022 16:20:38 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC24DE913
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 13:18:08 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id i24-20020a17090adc1800b001cd5529465aso7844754pjv.0
        for <linux-scsi@vger.kernel.org>; Fri, 15 Apr 2022 13:18:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C75zA7uUs0ohEpmMaSAFxlDToj4grp61RUl/Xw4siGs=;
        b=t1ZqLda9nfAcAgC7MTUzlWX7xzbQbO7iGxk+s12FshUIVz3PA2ug8BjnrdsICv8k9J
         LsATiO6bxfB7E/jTLwc6JnhYBJZmXOrl8aG+s97T4bhcTCqLHK9QPC303uOQebFgA8YO
         p3K3Iqjk3RPmaCyQjPh5DAOb260lfc5+T9pZK8U43pOtDueTEK04OXyb58s7vSkmzV0q
         ugqxFOoGfQS/pzN/GZi2dgJIr9iIffhYu+cT+8CLq6gEyjRueNW+t8jYZE4L+EF45PRq
         Z6yyipb+rk8qG1sv8vq8U61O1TlYeEa97+iDDeFsuYmBMa/X/FrZxWyyL3k1okRmhB5J
         HM4Q==
X-Gm-Message-State: AOAM533EWGVI9NE0JUmDSsfwciTXuoYnb3k+ru3i3dORRsuYqZh7vDR+
        0eEAAPgTddPaM7cEeXS3w1PxsfmblhEZxQ==
X-Google-Smtp-Source: ABdhPJy/aujspCZcVc6HHWCdXHHcBy2GNIX1bLIuksGxLR/f7HEET+wrKj8JSqgw3ha2bC43gyKs7g==
X-Received: by 2002:a17:90b:3c12:b0:1cb:70ef:240a with SMTP id pb18-20020a17090b3c1200b001cb70ef240amr525712pjb.217.1650053888036;
        Fri, 15 Apr 2022 13:18:08 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a014:c21c:c3f8:d62])
        by smtp.gmail.com with ESMTPSA id q9-20020a056a00088900b004fe1a045e97sm3641141pfj.118.2022.04.15.13.18.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 13:18:07 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH 4/8] scsi: sd_zbc: Introduce struct zoned_disk_info
Date:   Fri, 15 Apr 2022 13:17:48 -0700
Message-Id: <20220415201752.2793700-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220415201752.2793700-1-bvanassche@acm.org>
References: <20220415201752.2793700-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Deriving the meaning of the nr_zones, rev_nr_zones, zone_blocks and
rev_zone_blocks member variables requires careful analysis of the source
code. Make the meaning of these member variables easier to understand by
introducing struct zoned_disk_info.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.h     | 18 +++++++++++++----
 drivers/scsi/sd_zbc.c | 47 ++++++++++++++++++++-----------------------
 2 files changed, 36 insertions(+), 29 deletions(-)

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 4849cbe771a7..2e983578a699 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -67,6 +67,16 @@ enum {
 	SD_ZERO_WS10_UNMAP,	/* Use WRITE SAME(10) with UNMAP */
 };
 
+/**
+ * struct zoned_disk_info - Properties of a zoned SCSI disk.
+ * @nr_zones: number of zones.
+ * @zone_blocks: number of logical blocks per zone.
+ */
+struct zoned_disk_info {
+	u32		nr_zones;
+	u32		zone_blocks;
+};
+
 struct scsi_disk {
 	struct scsi_device *device;
 
@@ -78,10 +88,10 @@ struct scsi_disk {
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
index c1f295859b27..fe46b4b9913a 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -180,7 +180,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
 	 * sure that the allocated buffer can always be mapped by limiting the
 	 * number of pages allocated to the HBA max segments limit.
 	 */
-	nr_zones = min(nr_zones, sdkp->nr_zones);
+	nr_zones = min(nr_zones, sdkp->zone_info.nr_zones);
 	bufsize = roundup((nr_zones + 1) * 64, SECTOR_SIZE);
 	bufsize = min_t(size_t, bufsize,
 			queue_max_hw_sectors(q) << SECTOR_SHIFT);
@@ -205,7 +205,7 @@ static void *sd_zbc_alloc_report_buffer(struct scsi_disk *sdkp,
  */
 static inline sector_t sd_zbc_zone_sectors(struct scsi_disk *sdkp)
 {
-	return logical_to_sectors(sdkp->device, sdkp->zone_blocks);
+	return logical_to_sectors(sdkp->device, sdkp->zone_info.zone_blocks);
 }
 
 /**
@@ -321,14 +321,14 @@ static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)
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
@@ -395,7 +395,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 		break;
 	default:
 		wp_offset = sectors_to_logical(sdkp->device, wp_offset);
-		if (wp_offset + nr_blocks > sdkp->zone_blocks) {
+		if (wp_offset + nr_blocks > sdkp->zone_info.zone_blocks) {
 			ret = BLK_STS_IOERR;
 			break;
 		}
@@ -524,7 +524,7 @@ static unsigned int sd_zbc_zone_wp_update(struct scsi_cmnd *cmd,
 		break;
 	case REQ_OP_ZONE_RESET_ALL:
 		memset(sdkp->zones_wp_offset, 0,
-		       sdkp->nr_zones * sizeof(unsigned int));
+		       sdkp->zone_info.nr_zones * sizeof(unsigned int));
 		break;
 	default:
 		break;
@@ -681,16 +681,16 @@ static void sd_zbc_print_zones(struct scsi_disk *sdkp)
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
@@ -717,10 +717,8 @@ static void sd_zbc_clear_zone_info(struct scsi_disk *sdkp)
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
@@ -747,8 +745,8 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
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
@@ -779,14 +777,14 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
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
@@ -801,8 +799,7 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	sdkp->rev_wp_offset = NULL;
 
 	if (ret) {
-		sdkp->zone_blocks = 0;
-		sdkp->nr_zones = 0;
+		sdkp->zone_info = (struct zoned_disk_info){ };
 		sdkp->capacity = 0;
 		goto unlock;
 	}
@@ -888,8 +885,8 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 	if (blk_queue_zoned_model(q) == BLK_ZONED_HM)
 		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
 
-	sdkp->rev_nr_zones = nr_zones;
-	sdkp->rev_zone_blocks = zone_blocks;
+	sdkp->early_zone_info.nr_zones = nr_zones;
+	sdkp->early_zone_info.zone_blocks = zone_blocks;
 
 	return 0;
 
