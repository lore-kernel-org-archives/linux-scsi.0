Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D827C43219
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239637AbiCBFhX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239449AbiCBFhQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:37:16 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0A8B16D3
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 21:36:33 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222eVlZ010950
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=IXXw93fNwl3rDuAUNJtQ4WYpdJEw+RuWHMFKcGlsqqo=;
 b=nkbGKmXk16pdY6GybVfrLs2sAZbRW2bxmcXi/aSXywzxp8TZibomKfOi2cw6D8BeS374
 GM4z/40ez4Qr53FHVBKtNgPMl3IwLE6P+99/JHSoJXFqyFR25Ljcye/R0TxLvuUkldNf
 BRnDrh0/Y10aQYqCslwMY2CvJkBvzAVwdFVWFkW6MnuFWtEPtY8aZ4v1CXVhRZIDCVDt
 Lt5jWAouUiW2QH35D7PUoVkwT0fjH64CsNnSPGz1++sZIAOLkDX6+rFsZtPdHyaU/Y/d
 tVQlWN6gpJZFYUynjc+lkRGrMZG+2CV+6jxfvcDvulybExAj3lkojPb2pyKHPaE7QjmP Pw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh14bvwcm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225IuEu175938
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3efc15vak9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:32 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2225aRZn014395
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:32 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3efc15vaeg-11;
        Wed, 02 Mar 2022 05:36:32 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 10/14] scsi: sd: Move WRITE_ZEROES configuration to a separate function
Date:   Wed,  2 Mar 2022 00:35:55 -0500
Message-Id: <20220302053559.32147-11-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302053559.32147-1-martin.petersen@oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: Xed0Q1r28yW4QFwbs1BcedHgI8qGi1m0
X-Proofpoint-ORIG-GUID: Xed0Q1r28yW4QFwbs1BcedHgI8qGi1m0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In preparation for adding support for the WRITE SAME(16) NDOB flag,
move configuration of the WRITE_ZEROES operation to a separate
function. This is done to facilitate fetching all VPD pages before
choosing the appropriate zeroing method for a given device.

The deferred configuration also allows us to mirror the discard
behavior and permit the user to revert a device to the kernel default
configuration by echoing "default" to the sysfs file.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 56 +++++++++++++++++++++++++++++++++--------------
 drivers/scsi/sd.h |  7 ++++--
 2 files changed, 44 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index eae5c81ae515..ee4f4aea5f0f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -101,6 +101,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 #define SD_MINORS	16
 
 static void sd_config_discard(struct scsi_disk *, enum sd_lbp_mode);
+static void sd_config_write_zeroes(struct scsi_disk *, enum sd_zeroing_mode);
 static void sd_config_write_same(struct scsi_disk *);
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
@@ -428,10 +429,12 @@ static DEVICE_ATTR_RW(provisioning_mode);
 
 /* sysfs_match_string() requires dense arrays */
 static const char *zeroing_mode[] = {
+	[SD_ZERO_DEFAULT]	= "default",
 	[SD_ZERO_WRITE]		= "write",
 	[SD_ZERO_WS]		= "writesame",
 	[SD_ZERO_WS16_UNMAP]	= "writesame_16_unmap",
 	[SD_ZERO_WS10_UNMAP]	= "writesame_10_unmap",
+	[SD_ZERO_DISABLE]	= "disabled",
 };
 
 static ssize_t
@@ -457,7 +460,12 @@ zeroing_mode_store(struct device *dev, struct device_attribute *attr,
 	if (mode < 0)
 		return -EINVAL;
 
-	sdkp->zeroing_mode = mode;
+	if (mode == SD_ZERO_DEFAULT)
+		sdkp->zeroing_override = false;
+	else
+		sdkp->zeroing_override = true;
+
+	sd_config_write_zeroes(sdkp, mode);
 
 	return count;
 }
@@ -1049,6 +1057,31 @@ static blk_status_t sd_setup_write_same10_cmnd(struct scsi_cmnd *cmd,
 	return scsi_alloc_sgtables(cmd);
 }
 
+static void sd_config_write_zeroes(struct scsi_disk *sdkp,
+				   enum sd_zeroing_mode mode)
+{
+	struct request_queue *q = sdkp->disk->queue;
+	unsigned int logical_block_size = sdkp->device->sector_size;
+
+	if (mode == SD_ZERO_DEFAULT && !sdkp->zeroing_override) {
+		if (sdkp->lbprz && sdkp->lbpws)
+			mode = SD_ZERO_WS16_UNMAP;
+		else if (sdkp->lbprz && sdkp->lbpws10)
+			mode = SD_ZERO_WS10_UNMAP;
+		else if (sdkp->max_ws_blocks)
+			mode = SD_ZERO_WS;
+		else
+			mode = SD_ZERO_WRITE;
+	}
+
+	if (mode == SD_ZERO_DISABLE)
+		sdkp->zeroing_override = true;
+
+	sdkp->zeroing_mode = mode;
+	blk_queue_max_write_zeroes_sectors(q, sdkp->max_ws_blocks *
+					   (logical_block_size >> 9));
+}
+
 static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = scsi_cmd_to_rq(cmd);
@@ -1079,12 +1112,11 @@ static blk_status_t sd_setup_write_zeroes_cmnd(struct scsi_cmnd *cmd)
 
 static void sd_config_write_same(struct scsi_disk *sdkp)
 {
-	struct request_queue *q = sdkp->disk->queue;
 	unsigned int logical_block_size = sdkp->device->sector_size;
 
 	if (sdkp->device->no_write_same) {
 		sdkp->max_ws_blocks = 0;
-		goto out;
+		return;
 	}
 
 	/* Some devices can not handle block counts above 0xffff despite
@@ -1103,15 +1135,6 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
 		sdkp->max_ws_blocks = 0;
 	}
 
-	if (sdkp->lbprz && sdkp->lbpws)
-		sdkp->zeroing_mode = SD_ZERO_WS16_UNMAP;
-	else if (sdkp->lbprz && sdkp->lbpws10)
-		sdkp->zeroing_mode = SD_ZERO_WS10_UNMAP;
-	else if (sdkp->max_ws_blocks)
-		sdkp->zeroing_mode = SD_ZERO_WS;
-	else
-		sdkp->zeroing_mode = SD_ZERO_WRITE;
-
 	if (sdkp->max_ws_blocks &&
 	    sdkp->physical_block_size > logical_block_size) {
 		/*
@@ -1131,10 +1154,6 @@ static void sd_config_write_same(struct scsi_disk *sdkp)
 				   bytes_to_logical(sdkp->device,
 						    sdkp->physical_block_size));
 	}
-
-out:
-	blk_queue_max_write_zeroes_sectors(q, sdkp->max_ws_blocks *
-					 (logical_block_size >> 9));
 }
 
 static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
@@ -2126,6 +2145,8 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 			case WRITE_SAME:
 				if (SCpnt->cmnd[1] & 8) { /* UNMAP */
 					sd_config_discard(sdkp, SD_LBP_DISABLE);
+					sd_config_write_zeroes(sdkp,
+							       SD_ZERO_DISABLE);
 				} else {
 					sdkp->device->no_write_same = 1;
 					sd_config_write_same(sdkp);
@@ -3352,7 +3373,9 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_write_same(sdkp, buffer);
 		sd_read_security(sdkp, buffer);
 		sd_read_cpr(sdkp);
+		sd_config_write_same(sdkp);
 		sd_config_discard(sdkp, SD_LBP_DEFAULT);
+		sd_config_write_zeroes(sdkp, SD_ZERO_DEFAULT);
 	}
 
 	/*
@@ -3398,7 +3421,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	sdkp->first_scan = 0;
 
 	set_capacity_and_notify(disk, logical_to_sectors(sdp, sdkp->capacity));
-	sd_config_write_same(sdkp);
 	kfree(buffer);
 
 	/*
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 57a8241163c5..e0ee4215a3b4 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -61,11 +61,13 @@ enum sd_lbp_mode {
 	SD_LBP_DISABLE,		/* Discard disabled due to failed cmd */
 };
 
-enum {
-	SD_ZERO_WRITE = 0,	/* Use WRITE(10/16) command */
+enum sd_zeroing_mode {
+	SD_ZERO_DEFAULT = 0,	/* Default mode based on what device reports */
+	SD_ZERO_WRITE,		/* Use WRITE(10/16) command */
 	SD_ZERO_WS,		/* Use WRITE SAME(10/16) command */
 	SD_ZERO_WS16_UNMAP,	/* Use WRITE SAME(16) with UNMAP */
 	SD_ZERO_WS10_UNMAP,	/* Use WRITE SAME(10) with UNMAP */
+	SD_ZERO_DISABLE,	/* Write Zeroes disabled due to failed cmd */
 };
 
 struct scsi_disk {
@@ -111,6 +113,7 @@ struct scsi_disk {
 	u8		nr_actuators;		/* Number of actuators */
 	bool		lblvpd;
 	bool		provisioning_override;
+	bool		zeroing_override;
 	unsigned	ATO : 1;	/* state of disk ATO bit */
 	unsigned	cache_override : 1; /* temp override of WCE,RCD */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
-- 
2.32.0

