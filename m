Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACB1C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Apr 2022 18:30:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1391367AbiDUSdb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Apr 2022 14:33:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1391354AbiDUSd1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Apr 2022 14:33:27 -0400
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E66564BB80
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:36 -0700 (PDT)
Received: by mail-pf1-f169.google.com with SMTP id y14so4991354pfe.10
        for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2022 11:30:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K/cy4vL7n7xbQDxByfmcCwumO1cEnIuebqivcjkHRlw=;
        b=YM7M577CNdQ0y4ACPgXJ1XrFeAPSQvnLFm0hwqrYO1rxwfKLtHEnMD6NJm4ioJGPBw
         EvHth6P23XojiAu2ayVHN9bkvoradZmSDnKxtr0GXdqBvDoy6Wo2Op7RJbGYdf+diI2O
         JxFMibN9v8r+e1hTWf5sdiX2T9E/6GcQy2djrcfnI54vjvV38h4NcDPXnPaAOcHfDBiM
         DVLTggenY/0v3ieoskgZUdrwyTop345K2Mrb7CBnODJV7dzpWgWM8BbKeVQ1D0Aqn/C4
         rry/q45Hf2S4RiU0AlGPhjxLuMx5si0rbRFkHMZ/XKwgHV1O89DtDpyBXFlwrobqrotp
         fEJQ==
X-Gm-Message-State: AOAM530rn4a6qmEDRs35uN1ISb9JzA8Leiz6jTSsdFNeqTxmCVPPjI03
        JGDbmDi10PdKpVr3w8n9DFk=
X-Google-Smtp-Source: ABdhPJxt7sxs/Ab3OT6hlR2YjUt0A8oBhWwPxnmYXGz5e9nyXaq+0USFxAiQeY8FhVuKKI+idy7Cww==
X-Received: by 2002:a05:6a00:22c4:b0:50a:63d9:f5b4 with SMTP id f4-20020a056a0022c400b0050a63d9f5b4mr947358pfj.80.1650565836301;
        Thu, 21 Apr 2022 11:30:36 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:a034:31d8:ca4e:1f35])
        by smtp.gmail.com with ESMTPSA id a22-20020a62d416000000b0050bd98eaccbsm2181079pfh.213.2022.04.21.11.30.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 11:30:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v2 1/9] scsi: sd_zbc: Improve source code documentation
Date:   Thu, 21 Apr 2022 11:30:15 -0700
Message-Id: <20220421183023.3462291-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
In-Reply-To: <20220421183023.3462291-1-bvanassche@acm.org>
References: <20220421183023.3462291-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add several kernel-doc headers. Declare input arrays const. Specify the
array size in function declarations.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd.h     |  5 ++--
 drivers/scsi/sd_zbc.c | 55 ++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 0a33a4b68ffb..4849cbe771a7 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -222,7 +222,7 @@ static inline int sd_is_zoned(struct scsi_disk *sdkp)
 #ifdef CONFIG_BLK_DEV_ZONED
 
 void sd_zbc_release_disk(struct scsi_disk *sdkp);
-int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buffer);
+int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE]);
 int sd_zbc_revalidate_zones(struct scsi_disk *sdkp);
 blk_status_t sd_zbc_setup_zone_mgmt_cmnd(struct scsi_cmnd *cmd,
 					 unsigned char op, bool all);
@@ -238,8 +238,7 @@ blk_status_t sd_zbc_prepare_zone_append(struct scsi_cmnd *cmd, sector_t *lba,
 
 static inline void sd_zbc_release_disk(struct scsi_disk *sdkp) {}
 
-static inline int sd_zbc_read_zones(struct scsi_disk *sdkp,
-				    unsigned char *buf)
+static inline int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 {
 	return 0;
 }
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 7f466280993b..2ae44bc52a5f 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -20,6 +20,12 @@
 
 #include "sd.h"
 
+/**
+ * sd_zbc_get_zone_wp_offset - Get zone write pointer offset.
+ * @zone: Zone for which to return the write pointer offset.
+ *
+ * Return: offset of the write pointer from the start of the zone.
+ */
 static unsigned int sd_zbc_get_zone_wp_offset(struct blk_zone *zone)
 {
 	if (zone->type == ZBC_ZONE_TYPE_CONV)
@@ -44,7 +50,21 @@ static unsigned int sd_zbc_get_zone_wp_offset(struct blk_zone *zone)
 	}
 }
 
-static int sd_zbc_parse_report(struct scsi_disk *sdkp, u8 *buf,
+/**
+ * sd_zbc_parse_report - Parse a SCSI zone descriptor
+ * @sdkp: SCSI disk pointer.
+ * @buf: SCSI zone descriptor.
+ * @idx: Index of the zone relative to the first zone reported by the current
+ *	sd_zbc_report_zones() call.
+ * @cb: Callback function pointer.
+ * @data: Second argument passed to @cb.
+ *
+ * Return: Value returned by @cb.
+ *
+ * Convert a SCSI zone descriptor into struct blk_zone format. Additionally,
+ * call @cb(blk_zone, @data).
+ */
+static int sd_zbc_parse_report(struct scsi_disk *sdkp, const u8 buf[64],
 			       unsigned int idx, report_zones_cb cb, void *data)
 {
 	struct scsi_device *sdp = sdkp->device;
@@ -189,6 +209,17 @@ static inline sector_t sd_zbc_zone_sectors(struct scsi_disk *sdkp)
 	return logical_to_sectors(sdkp->device, sdkp->zone_blocks);
 }
 
+/**
+ * sd_zbc_report_zones - SCSI .report_zones() callback.
+ * @disk: Disk to report zones for.
+ * @sector: Start sector.
+ * @nr_zones: Maximum number of zones to report.
+ * @cb: Callback function called to report zone information.
+ * @data: Second argument passed to @cb.
+ *
+ * Called by the block layer to iterate over zone information. See also the
+ * disk->fops->report_zones() calls in block/blk-zoned.c.
+ */
 int sd_zbc_report_zones(struct gendisk *disk, sector_t sector,
 			unsigned int nr_zones, report_zones_cb cb, void *data)
 {
@@ -276,6 +307,10 @@ static int sd_zbc_update_wp_offset_cb(struct blk_zone *zone, unsigned int idx,
 	return 0;
 }
 
+/*
+ * An attempt to append a zone triggered an invalid write pointer error.
+ * Reread the write pointer of the zone(s) in which the append failed.
+ */
 static void sd_zbc_update_wp_offset_workfn(struct work_struct *work)
 {
 	struct scsi_disk *sdkp;
@@ -585,7 +620,7 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
  * sd_zbc_check_capacity - Check the device capacity
  * @sdkp: Target disk
  * @buf: command buffer
- * @zblocks: zone size in number of blocks
+ * @zblocks: zone size in logical blocks
  *
  * Get the device zone size and check that the device capacity as reported
  * by READ CAPACITY matches the max_lba value (plus one) of the report zones
@@ -696,6 +731,11 @@ static void sd_zbc_revalidate_zones_cb(struct gendisk *disk)
 	swap(sdkp->zones_wp_offset, sdkp->rev_wp_offset);
 }
 
+/*
+ * Call blk_revalidate_disk_zones() if any of the zoned disk properties have
+ * changed that make it necessary to call that function. Called by
+ * sd_revalidate_disk() after the gendisk capacity has been set.
+ */
 int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 {
 	struct gendisk *disk = sdkp->disk;
@@ -774,7 +814,16 @@ int sd_zbc_revalidate_zones(struct scsi_disk *sdkp)
 	return ret;
 }
 
-int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
+/**
+ * sd_zbc_read_zones - Read zone information and update the request queue
+ * @sdkp: SCSI disk pointer.
+ * @buf: 512 byte buffer used for storing SCSI command output.
+ *
+ * Read zone information and update the request queue zone characteristics and
+ * also the zoned device information in *sdkp. Called by sd_revalidate_disk()
+ * before the gendisk capacity has been set.
+ */
+int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
 {
 	struct gendisk *disk = sdkp->disk;
 	struct request_queue *q = disk->queue;
