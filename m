Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C903C43217
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:36:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239638AbiCBFhX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:37:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239520AbiCBFhQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:37:16 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F29DBB16D4
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 21:36:33 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222jYNB010945;
        Wed, 2 Mar 2022 05:36:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=GkDE/hlNw16W+LVhEbObnJBC9YC+b98WI5GqfISARrI=;
 b=AtWq515GPMNIDsjAE6fJNcPvOTLyUHN8bF8k8AcpNYyHlfdlNScPfpie4w6LxKyFk2Es
 ZExkq7jmqy7TwpMSehgpeRTmRfpeZUXLPjEH9NV/xZZEmP3OUp16Bka6VBYdoPd/GVDQ
 GUwBaSnc9czNRKj/OMH1L8QvL/Ua3BIH9sMrzW6K7XmLso0Swtcr1O/vE2u54sAlCoFM
 gXpwZp1VtOhAbNhyeArq4sPrqbOp5XGelVf6AAQK1a+wi9DDJN4u/w99E4qJ30ESP+oD
 fG0JwHym2Fvj+25gUSY2/JRXIsBEle5Ww8+CP4TBMn6/ay2Mmzzi6sD+U3OQw5NNeHdI xA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh14bvwck-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 05:36:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225IqLS175868;
        Wed, 2 Mar 2022 05:36:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3efc15vajg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Mar 2022 05:36:31 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2225aRZj014395;
        Wed, 2 Mar 2022 05:36:31 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3efc15vaeg-9;
        Wed, 02 Mar 2022 05:36:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bernhard Sulzer <micraft.b@gmail.com>
Subject: [PATCH 08/14] scsi: sd: Optimal I/O size should be a multiple of reported granularity
Date:   Wed,  2 Mar 2022 00:35:53 -0500
Message-Id: <20220302053559.32147-9-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302053559.32147-1-martin.petersen@oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: BClhjpCyshYtpq2LqtMEiaaBV-IiAjmD
X-Proofpoint-ORIG-GUID: BClhjpCyshYtpq2LqtMEiaaBV-IiAjmD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit a83da8a4509d ("scsi: sd: Optimal I/O size should be a multiple of
physical block size") validated the reported optimal I/O size against the
physical block size to overcome problems with devices reporting nonsensical
transfer sizes.

However, some devices claim conformity to older SCSI versions that predate
the physical block size being reported. Other devices do not report a
physical block size at all. We need to be able to validate the optimal I/O
size on those devices as well.

Many devices report an OPTIMAL TRANSFER LENGTH GRANULARITY in the same VPD
page as the OPTIMAL TRANSFER LENGTH. Use this value to validate the optimal
I/O size. Also check that the reported granularity is a multiple of the
physical block size, if supported.

Link: https://lore.kernel.org/r/33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com
Reported-by: Bernhard Sulzer <micraft.b@gmail.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c | 45 +++++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/sd.h |  1 +
 2 files changed, 42 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 84c04691841f..8595c4f2e915 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2871,7 +2871,6 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
  */
 static void sd_read_block_limits(struct scsi_disk *sdkp)
 {
-	unsigned int sector_sz = sdkp->device->sector_size;
 	struct scsi_vpd *vpd;
 
 	rcu_read_lock();
@@ -2880,9 +2879,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 	if (!vpd || vpd->len < 16)
 		goto out;
 
-	blk_queue_io_min(sdkp->disk->queue,
-			 get_unaligned_be16(&vpd->data[6]) * sector_sz);
-
+	sdkp->min_xfer_blocks = get_unaligned_be16(&vpd->data[6]);
 	sdkp->max_xfer_blocks = get_unaligned_be32(&vpd->data[8]);
 	sdkp->opt_xfer_blocks = get_unaligned_be32(&vpd->data[12]);
 
@@ -3140,6 +3137,29 @@ static void sd_read_cpr(struct scsi_disk *sdkp)
 	kfree(buffer);
 }
 
+static bool sd_validate_min_xfer_size(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+	unsigned int min_xfer_bytes =
+		logical_to_bytes(sdp, sdkp->min_xfer_blocks);
+
+	if (sdkp->min_xfer_blocks == 0)
+		return false;
+
+	if (min_xfer_bytes & (sdkp->physical_block_size - 1)) {
+		sd_first_printk(KERN_WARNING, sdkp,
+				"Preferred minimum I/O size %u bytes not a " \
+				"multiple of physical block size (%u bytes)\n",
+				min_xfer_bytes, sdkp->physical_block_size);
+		sdkp->min_xfer_blocks = 0;
+		return false;
+	}
+
+	sd_first_printk(KERN_INFO, sdkp, "Preferred minimum I/O size %u bytes\n",
+			min_xfer_bytes);
+	return true;
+}
+
 /*
  * Determine the device's preferred I/O size for reads and writes
  * unless the reported value is unreasonably small, large, not a
@@ -3151,6 +3171,8 @@ static bool sd_validate_opt_xfer_size(struct scsi_disk *sdkp,
 	struct scsi_device *sdp = sdkp->device;
 	unsigned int opt_xfer_bytes =
 		logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
+	unsigned int min_xfer_bytes =
+		logical_to_bytes(sdp, sdkp->min_xfer_blocks);
 
 	if (sdkp->opt_xfer_blocks == 0)
 		return false;
@@ -3179,6 +3201,15 @@ static bool sd_validate_opt_xfer_size(struct scsi_disk *sdkp,
 		return false;
 	}
 
+	if (min_xfer_bytes && opt_xfer_bytes & (min_xfer_bytes - 1)) {
+		sd_first_printk(KERN_WARNING, sdkp,
+				"Optimal transfer size %u bytes not a " \
+				"multiple of preferred minimum block " \
+				"size (%u bytes)\n",
+				opt_xfer_bytes, min_xfer_bytes);
+		return false;
+	}
+
 	if (opt_xfer_bytes & (sdkp->physical_block_size - 1)) {
 		sd_first_printk(KERN_WARNING, sdkp,
 				"Optimal transfer size %u bytes not a " \
@@ -3271,6 +3302,12 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	dev_max = min_not_zero(dev_max, sdkp->max_xfer_blocks);
 	q->limits.max_dev_sectors = logical_to_sectors(sdp, dev_max);
 
+	if (sd_validate_min_xfer_size(sdkp))
+		blk_queue_io_min(sdkp->disk->queue,
+				 logical_to_bytes(sdp, sdkp->min_xfer_blocks));
+	else
+		blk_queue_io_min(sdkp->disk->queue, 0);
+
 	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
 		q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
 		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 2e5932bde43d..f4fbca90e997 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -91,6 +91,7 @@ struct scsi_disk {
 	atomic_t	openers;
 	sector_t	capacity;	/* size in logical blocks */
 	int		max_retries;
+	u32		min_xfer_blocks;
 	u32		max_xfer_blocks;
 	u32		opt_xfer_blocks;
 	u32		max_ws_blocks;
-- 
2.32.0

