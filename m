Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AD1EC1975A
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 20:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29D7A2072D
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 20:57:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="gzgTZP3F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726781AbgCVU5L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 16:57:11 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53098 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgCVU5L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 16:57:11 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02MKrqPw102776;
        Sun, 22 Mar 2020 20:57:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=FIwVyqu4c48RFy3+kJD6Xa8k36ombPE0nFDJc1eVHs0=;
 b=gzgTZP3Fda3Ww+EWIz/r6A4rqVXdLFmlo6pOy7IwHNDw8o4qMbb8/1sX4QSdkrM8SSfg
 Mid8FgkIyuuiD/VT5r1jyo/vYBLSlHCUc/thlvgU9bN2xODT1jqZKMGmNayvALVmu+MV
 jH32RSn37aJy97FkYG/XsNusy+N98+E00saV3gZk9CL0TS92xwOrXFpKFgxjhW2CrCXA
 GfV2unmCh/Nbv1VrOTEZz6ecGqnZpd9fcHS9lWn28JaTyYbCrQL5W9dxkqOg0E1RUmJm
 QUxpo0VvEf677YmO9AmZ3urxVommtpav5EQP+FARs/yCMw11C//3R8aXadsfo9qeCSHq 7A== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 2ywabquqgf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Mar 2020 20:57:09 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 02MKrDVR020791;
        Sun, 22 Mar 2020 20:57:08 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3020.oracle.com with ESMTP id 2ywvqp249d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 22 Mar 2020 20:57:08 +0000
Received: from abhmp0011.oracle.com (abhmp0011.oracle.com [141.146.116.17])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 02MKv7jw029870;
        Sun, 22 Mar 2020 20:57:07 GMT
Received: from ca-mkp.ca.oracle.com (/10.156.108.201)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Sun, 22 Mar 2020 13:57:07 -0700
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bernhard Sulzer <micraft.b@gmail.com>
Subject: [PATCH] scsi: sd: Optimal I/O size should be a multiple of reported granularity
Date:   Sun, 22 Mar 2020 16:57:06 -0400
Message-Id: <20200322205706.1593-1-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
References: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9568 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 suspectscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2003220127
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9568 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 lowpriorityscore=0 malwarescore=0 phishscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxscore=0 mlxlogscore=999 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2003220127
Sender: linux-scsi-owner@vger.kernel.org
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
 drivers/scsi/sd.c | 43 +++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/sd.h |  1 +
 2 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 8ca9299ffd36..e41f8eb00787 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2858,7 +2858,6 @@ static void sd_read_app_tag_own(struct scsi_disk *sdkp, unsigned char *buffer)
  */
 static void sd_read_block_limits(struct scsi_disk *sdkp)
 {
-	unsigned int sector_sz = sdkp->device->sector_size;
 	const int vpd_len = 64;
 	unsigned char *buffer = kmalloc(vpd_len, GFP_KERNEL);
 
@@ -2867,9 +2866,7 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 	    scsi_get_vpd_page(sdkp->device, 0xb0, buffer, vpd_len))
 		goto out;
 
-	blk_queue_io_min(sdkp->disk->queue,
-			 get_unaligned_be16(&buffer[6]) * sector_sz);
-
+	sdkp->min_xfer_blocks = get_unaligned_be16(&buffer[6]);
 	sdkp->max_xfer_blocks = get_unaligned_be32(&buffer[8]);
 	sdkp->opt_xfer_blocks = get_unaligned_be32(&buffer[12]);
 
@@ -3036,6 +3033,29 @@ static void sd_read_security(struct scsi_disk *sdkp, unsigned char *buffer)
 		sdkp->security = 1;
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
@@ -3047,6 +3067,8 @@ static bool sd_validate_opt_xfer_size(struct scsi_disk *sdkp,
 	struct scsi_device *sdp = sdkp->device;
 	unsigned int opt_xfer_bytes =
 		logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
+	unsigned int min_xfer_bytes =
+		logical_to_bytes(sdp, sdkp->min_xfer_blocks);
 
 	if (sdkp->opt_xfer_blocks == 0)
 		return false;
@@ -3083,6 +3105,15 @@ static bool sd_validate_opt_xfer_size(struct scsi_disk *sdkp,
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
 	sd_first_printk(KERN_INFO, sdkp, "Optimal transfer size %u bytes\n",
 			opt_xfer_bytes);
 	return true;
@@ -3166,6 +3197,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	dev_max = min_not_zero(dev_max, sdkp->max_xfer_blocks);
 	q->limits.max_dev_sectors = logical_to_sectors(sdp, dev_max);
 
+	if (sd_validate_min_xfer_size(sdkp))
+		blk_queue_io_min(sdkp->disk->queue,
+				 logical_to_bytes(sdp, sdkp->min_xfer_blocks));
+
 	if (sd_validate_opt_xfer_size(sdkp, dev_max)) {
 		q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
 		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
diff --git a/drivers/scsi/sd.h b/drivers/scsi/sd.h
index 50fff0bf8c8e..7efdcb103c2a 100644
--- a/drivers/scsi/sd.h
+++ b/drivers/scsi/sd.h
@@ -82,6 +82,7 @@ struct scsi_disk {
 #endif
 	atomic_t	openers;
 	sector_t	capacity;	/* size in logical blocks */
+	u32		min_xfer_blocks;
 	u32		max_xfer_blocks;
 	u32		opt_xfer_blocks;
 	u32		max_ws_blocks;
-- 
2.24.1

