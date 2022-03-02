Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC7E0C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239635AbiCBFhX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239174AbiCBFhQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:37:16 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFB0B16DA
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 21:36:33 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222xusi014684
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=spiTjECS3j/j0hj9fPE/LCcxtLqmuh29URnhLx1qvo8=;
 b=vDT9nen1GtL5b4yNWZon6aBAA6/d8ZgHN93NEBVGniTUeh9RLPKjVXUvyPuMranQL+jh
 /R7VdrCFEiRJGNy1kQemc0pVuFncC8+oeyVMWb6DZdgty0Tv35PthhFRQiXGnb46CPeF
 uE6mIIkrWyhqnVbvh0kmfYEyVs+2clHyOxkzoPu9wu9zPmNIBSPU5bxIvDW1axQhrXAM
 /fqVcHXDBp/53pqWhbxtIDBJyAhUIL4zgSqTROpMUGR1MgfnKc+r6Ts6p6B+EMY5sZSW
 u73/7WjBzEW+/ODSmeTbadZRwK7l0BlsHCIWdCOqCRXbVbOeOdgvdk9A4nIrYQp2VKRE vQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh15amq8t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225IqLT175868
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3efc15vajv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:31 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2225aRZl014395
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:31 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3efc15vaeg-10;
        Wed, 02 Mar 2022 05:36:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 09/14] scsi: sd: Fix discard errors during revalidate
Date:   Wed,  2 Mar 2022 00:35:54 -0500
Message-Id: <20220302053559.32147-10-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302053559.32147-1-martin.petersen@oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: W2pIoSh-M4BUfatyCRc1Te3xuqnuMr89
X-Proofpoint-GUID: W2pIoSh-M4BUfatyCRc1Te3xuqnuMr89
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

We previously switched to SD_LBP_WS16 mode by default if a device
identified itself as being thinly provisioned. This was done for
compatibility with older devices that predate the Logical Block
Provisioning VPD page and the introduction of the separate UNMAP command.

Since WS16 was originally the only option there was no way to explicitly
signal support for it outside of the device reporting LBPME=1. And thus we
switch it on every time we discover a thinly provisioned device in READ
CAPACITY(16).

Some devices, however, report different values for unmap operations
performed with WRITE SAME and ones performed with the UNMAP command. For
instance a device may report that it can unmap 64KB with WRITE SAME but
only 32KB with UNMAP. If the device then reports a preference for UNMAP in
the LBP VPD, there is a tiny window between the WS16 being enabled and the
UNMAP limit being set. And during that window the block layer can issue
64KB discards which, when being prepped by the sd driver, now violate the
UNMAP limit.

To avoid temporarily setting WS16 during revalidate, relocate all the
provisioning mode setting heuristics to sd_config_discard(). Introduce a
new mode, SD_LBP_DEFAULT, which sd_revalidate() will use to trigger the
heuristic to select a suitable mode based on what the device reports.

SD_LBP_DEFAULT can also be triggered in sysfs via the string "default",
should a user decide to change back to the kernel-chosen provisioning mode
after manually overriding the default.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 124 +++++++++++++++++++++++++++++++++++-----------
 drivers/scsi/sd.h |   9 ++--
 2 files changed, 101 insertions(+), 32 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8595c4f2e915..eae5c81ae515 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -100,7 +100,7 @@ MODULE_ALIAS_SCSI_DEVICE(TYPE_ZBC);
 
 #define SD_MINORS	16
 
-static void sd_config_discard(struct scsi_disk *, unsigned int);
+static void sd_config_discard(struct scsi_disk *, enum sd_lbp_mode);
 static void sd_config_write_same(struct scsi_disk *);
 static int  sd_revalidate_disk(struct gendisk *);
 static void sd_unlock_native_capacity(struct gendisk *disk);
@@ -374,6 +374,7 @@ static DEVICE_ATTR_RO(thin_provisioning);
 
 /* sysfs_match_string() requires dense arrays */
 static const char *lbp_mode[] = {
+	[SD_LBP_DEFAULT]	= "default",
 	[SD_LBP_FULL]		= "full",
 	[SD_LBP_UNMAP]		= "unmap",
 	[SD_LBP_WS16]		= "writesame_16",
@@ -414,6 +415,11 @@ provisioning_mode_store(struct device *dev, struct device_attribute *attr,
 	if (mode < 0)
 		return -EINVAL;
 
+	if (mode == SD_LBP_DEFAULT)
+		sdkp->provisioning_override = false;
+	else
+		sdkp->provisioning_override = true;
+
 	sd_config_discard(sdkp, mode);
 
 	return count;
@@ -812,23 +818,95 @@ static unsigned char sd_setup_protect_cmnd(struct scsi_cmnd *scmd,
 	return protect;
 }
 
-static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
+/*
+ * It took many iterations in T10 to develop a model for thinly provisioned
+ * devices. Linux was an early adopter of the concept of discards, and as a
+ * result of the SCSI spec being a moving target for several years, we have a
+ * set of heuristics in place that allow us to support a wide variety of
+ * devices that predate the final SBC specification.
+ *
+ * These heuristics are triggered by default during device discovery, but the
+ * user can subsequently override what the kernel decided by writing a
+ * particular mode string to a scsi_disk's provisioning_mode node in sysfs.
+ * For devices that predate any of the provisioning knobs in the spec but rely
+ * on zero-detection, it is possible to enable discard through the
+ * "writesame_zero" override.
+ *
+ * For Linux to automatically identify a SCSI disk as being thinly
+ * provisioned, the device must set the LBPME bit in READ CAPACITY(16).
+ *
+ * In the ratified version of T10 SBC-4, a device must also provide a Logical
+ * Block Provisioning VPD page which has three fields that indicate which
+ * provisioning commands the device supports. The device should also implement
+ * the extended version of the Block Limits VPD which is used to indicate any
+ * limitations on the size of unmap operations as well as alignment and
+ * granularity used inside the device.
+ *
+ * If the device supports the Logical Block Provisioning VPD, and sets the
+ * LBPU flag, and reports a MAXIMUM UNMAP LBA COUNT > 0 and a MAXIMUM UNMAP
+ * BLOCK DESCRIPTOR count > 0 in the extended Block Limits VPD, then we will
+ * use UNMAP for discards. Otherwise, if the device set LBPWS in the LBP VPD,
+ * we will use WRITE SAME(16) with the UNMAP bit set for discards.  Otherwise,
+ * if the device sets LBPWS10 in the LBP VPD, then we will use WRITE SAME(10)
+ * with the UNMAP bit set for discards.
+ *
+ * If the device does *not* support the Logical Block Provisioning VPD, we
+ * rely on the extended version of the Block Limits VPD. If that is supported,
+ * and and the device reports a MAXIMUM UNMAP LBA COUNT > 0 and a MAXIMUM
+ * UNMAP BLOCK DESCRIPTOR count > 0, then we will use UNMAP for discards.
+ * Otherwise we will use WRITE SAME(16) with the UNMAP bit set for discards.
+ *
+ * If a device implements the *short* version of the Block Limits VPD or does
+ * not have a Block Limits VPD at all, we default to using WRITE SAME(16) with
+ * the UNMAP bit set for discards.
+ *
+ * The possible values for provisioning_mode in sysfs are:
+ *
+ *   "default"	      - use heuristics outlined above to decide on command
+ *   "full"           - the device does not support discard
+ *   "unmap"          - use the UNMAP command
+ *   "writesame_16"   - use the WRITE SAME(16) command with the UNMAP bit set
+ *   "writesame_10"   - use the WRITE SAME(10) command with the UNMAP bit set
+ *   "writesame_zero" - use WRITE SAME(16) with a zeroed payload, no UNMAP bit
+ *   "disabled"	      - discards disabled due to command failure
+ */
+static void sd_config_discard(struct scsi_disk *sdkp, enum sd_lbp_mode mode)
 {
 	struct request_queue *q = sdkp->disk->queue;
 	unsigned int logical_block_size = sdkp->device->sector_size;
 	unsigned int max_blocks = 0;
 
-	q->limits.discard_alignment =
-		sdkp->unmap_alignment * logical_block_size;
-	q->limits.discard_granularity =
-		max(sdkp->physical_block_size,
-		    sdkp->unmap_granularity * logical_block_size);
-	sdkp->provisioning_mode = mode;
+	if (mode == SD_LBP_DEFAULT && !sdkp->provisioning_override) {
+		if (sdkp->lbpme) { /* Logical Block Provisioning Enabled */
+			if (sdkp->lbpvpd) { /* Logical Block Provisioning VPD */
+				if (sdkp->lbpu && sdkp->max_unmap_blocks)
+					mode = SD_LBP_UNMAP;
+				else if (sdkp->lbpws)
+					mode = SD_LBP_WS16;
+				else if (sdkp->lbpws10)
+					mode = SD_LBP_WS10;
+				else
+					mode = SD_LBP_FULL;
+			} else if (sdkp->lblvpd) { /* Long Block Limits VPD */
+				if (sdkp->max_unmap_blocks)
+					mode = SD_LBP_UNMAP;
+				else
+					mode = SD_LBP_WS16;
+			} else /* LBPME only, no VPDs supported */
+				mode = SD_LBP_WS16;
+		} else
+			mode = SD_LBP_FULL;
+	}
 
 	switch (mode) {
-
+	case SD_LBP_DEFAULT:
 	case SD_LBP_FULL:
 	case SD_LBP_DISABLE:
+		if (mode == SD_LBP_DISABLE)
+			sdkp->provisioning_override = true;
+		sdkp->provisioning_mode = mode;
+		q->limits.discard_alignment = 0;
+		q->limits.discard_granularity = 0;
 		blk_queue_max_discard_sectors(q, 0);
 		blk_queue_flag_clear(QUEUE_FLAG_DISCARD, q);
 		return;
@@ -862,6 +940,12 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 		break;
 	}
 
+	sdkp->provisioning_mode = mode;
+	q->limits.discard_alignment =
+		sdkp->unmap_alignment * logical_block_size;
+	q->limits.discard_granularity =
+		max(sdkp->physical_block_size,
+		    sdkp->unmap_granularity * logical_block_size);
 	blk_queue_max_discard_sectors(q, max_blocks * (logical_block_size >> 9));
 	blk_queue_flag_set(QUEUE_FLAG_DISCARD, q);
 }
@@ -2355,8 +2439,6 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 
 		if (buffer[14] & 0x40) /* LBPRZ */
 			sdkp->lbprz = 1;
-
-		sd_config_discard(sdkp, SD_LBP_WS16);
 	}
 
 	sdkp->capacity = lba + 1;
@@ -2886,6 +2968,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 	if (vpd->len >= 64) {
 		unsigned int lba_count, desc_count;
 
+		sdkp->lblvpd = 1;
 		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&vpd->data[36]);
 
 		if (!sdkp->lbpme)
@@ -2902,24 +2985,6 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 		if (vpd->data[32] & 0x80)
 			sdkp->unmap_alignment =
 				get_unaligned_be32(&vpd->data[32]) & ~(1 << 31);
-
-		if (!sdkp->lbpvpd) { /* LBP VPD page not provided */
-
-			if (sdkp->max_unmap_blocks)
-				sd_config_discard(sdkp, SD_LBP_UNMAP);
-			else
-				sd_config_discard(sdkp, SD_LBP_WS16);
-
-		} else {	/* LBP VPD page tells us what to use */
-			if (sdkp->lbpu && sdkp->max_unmap_blocks)
-				sd_config_discard(sdkp, SD_LBP_UNMAP);
-			else if (sdkp->lbpws)
-				sd_config_discard(sdkp, SD_LBP_WS16);
-			else if (sdkp->lbpws10)
-				sd_config_discard(sdkp, SD_LBP_WS10);
-			else
-				sd_config_discard(sdkp, SD_LBP_DISABLE);
-		}
 	}
 
  out:
@@ -3287,6 +3352,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_read_write_same(sdkp, buffer);
 		sd_read_security(sdkp, buffer);
 		sd_read_cpr(sdkp);
+		sd_config_discard(sdkp, SD_LBP_DEFAULT);
 	}
 
 	/*
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index f4fbca90e997..57a8241163c5 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -51,12 +51,13 @@ enum {
 	SD_MAX_WS16_BLOCKS = 0x7fffff,
 };
 
-enum {
-	SD_LBP_FULL = 0,	/* Full logical block provisioning */
+enum sd_lbp_mode {
+	SD_LBP_DEFAULT = 0,	/* Select mode based on what device reports */
+	SD_LBP_FULL,		/* Full logical block provisioning */
 	SD_LBP_UNMAP,		/* Use UNMAP command */
 	SD_LBP_WS16,		/* Use WRITE SAME(16) with UNMAP bit */
 	SD_LBP_WS10,		/* Use WRITE SAME(10) with UNMAP bit */
-	SD_LBP_ZERO,		/* Use WRITE SAME(10) with zero payload */
+	SD_LBP_ZERO,		/* Use WRITE SAME(10) with zeroed payload */
 	SD_LBP_DISABLE,		/* Discard disabled due to failed cmd */
 };
 
@@ -108,6 +109,8 @@ struct scsi_disk {
 	u8		provisioning_mode;
 	u8		zeroing_mode;
 	u8		nr_actuators;		/* Number of actuators */
+	bool		lblvpd;
+	bool		provisioning_override;
 	unsigned	ATO : 1;	/* state of disk ATO bit */
 	unsigned	cache_override : 1; /* temp override of WCE,RCD */
 	unsigned	WCE : 1;	/* state of disk WCE bit */
-- 
2.32.0

