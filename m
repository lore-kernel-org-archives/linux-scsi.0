Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A248C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:36:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239615AbiCBFhW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:37:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238851AbiCBFhO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:37:14 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B68B16D3
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 21:36:32 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222iL0V001861
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=/P5q7khzDGWORmvHzneH31Pu5xI/KSICky+FITQwTec=;
 b=RlH/WrA5ZhhTY3hPTz2KhblsbYN25rIpC2R3/++3g/RmtxWwI5FjT9/fB742rKzYDn6u
 STzyVl9o7k4u/OE8P0rhlskDLraa8g0yc8dHjMjwpB0sijm8rWOt4P3EIi8M27wAnH8r
 DP61tvlnTvKDJBK6kw5sqs1Gu+Pg870NjegfAsjh6J1kKhGHoTEeAtcRGWFLYYl31G5J
 jNUdIc72c114Dsb3hGqQ3ehj355fYS06Ws3D+Co9OXuZfy6XgvCoXROeb8J+mno3Hx8e
 WPB4g2I+pJRJ7wSzZU+dwAb9bmDRo055hbUOsxsDnLQMnbL0l2rSV3J5XLh1U9tIRWd9 5Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k44uec-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:31 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225IqDM175869
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3efc15vaj8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:30 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2225aRZh014395
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:30 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3efc15vaeg-8;
        Wed, 02 Mar 2022 05:36:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 07/14] scsi: sd: Switch to using scsi_device VPD pages
Date:   Wed,  2 Mar 2022 00:35:52 -0500
Message-Id: <20220302053559.32147-8-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302053559.32147-1-martin.petersen@oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: p0kXBoXRdWWqJAyNe_kM1ftWTDOmcDVT
X-Proofpoint-GUID: p0kXBoXRdWWqJAyNe_kM1ftWTDOmcDVT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Use the VPD pages already provided by the SCSI midlayer. No need to
request them individually in the SCSI disk driver.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 80 +++++++++++++++++++++++------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d6aec12aef76..84c04691841f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2872,39 +2872,39 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
 static void sd_read_block_limits(struct scsi_disk *sdkp)
 {
 	unsigned int sector_sz = sdkp->device->sector_size;
-	const int vpd_len = 64;
-	unsigned char *buffer = kmalloc(vpd_len, GFP_KERNEL);
+	struct scsi_vpd *vpd;
 
-	if (!buffer ||
-	    /* Block Limits VPD */
-	    scsi_get_vpd_page(sdkp->device, 0xb0, buffer, vpd_len))
+	rcu_read_lock();
+
+	vpd = rcu_dereference(sdkp->device->vpd_pgb0);
+	if (!vpd || vpd->len < 16)
 		goto out;
 
 	blk_queue_io_min(sdkp->disk->queue,
-			 get_unaligned_be16(&buffer[6]) * sector_sz);
+			 get_unaligned_be16(&vpd->data[6]) * sector_sz);
 
-	sdkp->max_xfer_blocks = get_unaligned_be32(&buffer[8]);
-	sdkp->opt_xfer_blocks = get_unaligned_be32(&buffer[12]);
+	sdkp->max_xfer_blocks = get_unaligned_be32(&vpd->data[8]);
+	sdkp->opt_xfer_blocks = get_unaligned_be32(&vpd->data[12]);
 
-	if (buffer[3] == 0x3c) {
+	if (vpd->len >= 64) {
 		unsigned int lba_count, desc_count;
 
-		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&buffer[36]);
+		sdkp->max_ws_blocks = (u32)get_unaligned_be64(&vpd->data[36]);
 
 		if (!sdkp->lbpme)
 			goto out;
 
-		lba_count = get_unaligned_be32(&buffer[20]);
-		desc_count = get_unaligned_be32(&buffer[24]);
+		lba_count = get_unaligned_be32(&vpd->data[20]);
+		desc_count = get_unaligned_be32(&vpd->data[24]);
 
 		if (lba_count && desc_count)
 			sdkp->max_unmap_blocks = lba_count;
 
-		sdkp->unmap_granularity = get_unaligned_be32(&buffer[28]);
+		sdkp->unmap_granularity = get_unaligned_be32(&vpd->data[28]);
 
-		if (buffer[32] & 0x80)
+		if (vpd->data[32] & 0x80)
 			sdkp->unmap_alignment =
-				get_unaligned_be32(&buffer[32]) & ~(1 << 31);
+				get_unaligned_be32(&vpd->data[32]) & ~(1 << 31);
 
 		if (!sdkp->lbpvpd) { /* LBP VPD page not provided */
 
@@ -2926,7 +2926,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 	}
 
  out:
-	kfree(buffer);
+	rcu_read_unlock();
 }
 
 /**
@@ -2936,18 +2936,21 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 {
 	struct request_queue *q = sdkp->disk->queue;
-	unsigned char *buffer;
+	struct scsi_vpd *vpd;
 	u16 rot;
-	const int vpd_len = 64;
+	u8 zoned;
 
-	buffer = kmalloc(vpd_len, GFP_KERNEL);
+	rcu_read_lock();
+	vpd = rcu_dereference(sdkp->device->vpd_pgb1);
 
-	if (!buffer ||
-	    /* Block Device Characteristics VPD */
-	    scsi_get_vpd_page(sdkp->device, 0xb1, buffer, vpd_len))
-		goto out;
+	if (!vpd || vpd->len < 8) {
+		rcu_read_unlock();
+	        return;
+	}
 
-	rot = get_unaligned_be16(&buffer[4]);
+	rot = get_unaligned_be16(&vpd->data[4]);
+	zoned = (vpd->data[8] >> 4) & 3;
+	rcu_read_unlock();
 
 	if (rot == 1) {
 		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
@@ -2958,7 +2961,7 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 		/* Host-managed */
 		blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HM);
 	} else {
-		sdkp->zoned = (buffer[8] >> 4) & 3;
+		sdkp->zoned = zoned;
 		if (sdkp->zoned == 1) {
 			/* Host-aware */
 			blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HA);
@@ -2969,7 +2972,7 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 	}
 
 	if (!sdkp->first_scan)
-		goto out;
+		return;
 
 	if (blk_queue_is_zoned(q)) {
 		sd_printk(KERN_NOTICE, sdkp, "Host-%s zoned block device\n",
@@ -2982,9 +2985,6 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
 			sd_printk(KERN_NOTICE, sdkp,
 				  "Drive-managed SMR disk\n");
 	}
-
- out:
-	kfree(buffer);
 }
 
 /**
@@ -2993,24 +2993,24 @@ static void sd_read_block_characteristics(struct scsi_disk *sdkp)
  */
 static void sd_read_block_provisioning(struct scsi_disk *sdkp)
 {
-	unsigned char *buffer;
-	const int vpd_len = 8;
+	struct scsi_vpd *vpd;
 
 	if (sdkp->lbpme == 0)
 		return;
 
-	buffer = kmalloc(vpd_len, GFP_KERNEL);
+	rcu_read_lock();
+	vpd = rcu_dereference(sdkp->device->vpd_pgb2);
 
-	if (!buffer || scsi_get_vpd_page(sdkp->device, 0xb2, buffer, vpd_len))
-		goto out;
+	if (!vpd || vpd->len < 8) {
+		rcu_read_unlock();
+		return;
+	}
 
 	sdkp->lbpvpd	= 1;
-	sdkp->lbpu	= (buffer[5] >> 7) & 1;	/* UNMAP */
-	sdkp->lbpws	= (buffer[5] >> 6) & 1;	/* WRITE SAME(16) with UNMAP */
-	sdkp->lbpws10	= (buffer[5] >> 5) & 1;	/* WRITE SAME(10) with UNMAP */
-
- out:
-	kfree(buffer);
+	sdkp->lbpu	= (vpd->data[5] >> 7) & 1; /* UNMAP */
+	sdkp->lbpws	= (vpd->data[5] >> 6) & 1; /* WRITE SAME(16) w/ UNMAP */
+	sdkp->lbpws10	= (vpd->data[5] >> 5) & 1; /* WRITE SAME(10) w/ UNMAP */
+	rcu_read_unlock();
 }
 
 static void sd_read_write_same(struct scsi_disk *sdkp, unsigned char *buffer)
-- 
2.32.0

