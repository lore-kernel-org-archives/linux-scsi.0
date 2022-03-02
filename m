Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 080DEC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Mar 2022 05:36:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238953AbiCBFh1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 00:37:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239578AbiCBFhR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 00:37:17 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CB1B16D5
        for <linux-scsi@vger.kernel.org>; Tue,  1 Mar 2022 21:36:35 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 2222i1m2001868
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2021-07-09;
 bh=slvaE0koUQp1MIiLuVvatiT/eGul5UCm0GxK+8Z5dG8=;
 b=aaRVvFWmT4YpRtv1eNDJWL42+DEvx19a/DcqDLi4djEp5kSCO35nTN0M8i6+YkOj5Gnd
 y507v4b2ybJUlWNsPxGaNyzzkx3Mosca377Wn33SQ7vv4W9gqh41iNZhylIL9VUqlBaj
 5m2mY8gxTIpKzozPf2DbaUiwDCA+meNqmJtE5kEX1O1ORcTl7xCKHN88LAamEcMHrqNy
 0k0wOjSNxTuWp96ySypgU7mcS/o+RKI5yJ8c2zNj9a9WKRHGKhJ1K6cm4i127gUQ4Z0f
 39zjrcPM3DWaBW860JF4oOXwWhDubsoJzNW4IHgB4sO7pv2NdZ2E5sH7MTyPrmG6S9EC Mg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3eh1k44uef-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:35 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2225IqLU175868
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 3efc15vamb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 05:36:34 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 2225aRZt014395
        for <linux-scsi@vger.kernel.org>; Wed, 2 Mar 2022 05:36:33 GMT
Received: from ca-mkp.mkp.ca.oracle.com (ca-mkp.ca.oracle.com [10.156.108.201])
        by aserp3020.oracle.com with ESMTP id 3efc15vaeg-14;
        Wed, 02 Mar 2022 05:36:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 13/14] scsi: sd: Reorganize DIF/DIX code to avoid calling revalidate twice
Date:   Wed,  2 Mar 2022 00:35:58 -0500
Message-Id: <20220302053559.32147-14-martin.petersen@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220302053559.32147-1-martin.petersen@oracle.com>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: kTePIZVxPRCfXVit4QJ2d9yH-wQRfxGk
X-Proofpoint-GUID: kTePIZVxPRCfXVit4QJ2d9yH-wQRfxGk
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

During device discovery we ended up calling revalidate twice and thus
requested the same parameters multiple times. This was originally
necessary due to the request_queue and gendisk needing to be
instantiated to configure the block integrity profile.

Since this dependency no longer exists, reorganize the integrity
probing code so it can be run once at the end of discovery and drop
the superfluous revalidate call. Postponing the registration step
involves splitting sd_read_protection() into two functions, one to
read the device protection type and one to configure the mode of
operation.

As part of this cleanup, make the printing code a bit less verbose.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/scsi/sd.c     | 62 +++++++++++++++++++++++--------------------
 drivers/scsi/sd_dif.c |  8 +++---
 2 files changed, 36 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 9d6b2205339d..163697dd799a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2338,40 +2338,48 @@ static int sd_read_protection_type(struct scsi_disk *sdkp, unsigned char *buffer
 {
 	struct scsi_device *sdp = sdkp->device;
 	u8 type;
-	int ret = 0;
 
 	if (scsi_device_protection(sdp) == 0 || (buffer[12] & 1) == 0) {
 		sdkp->protection_type = 0;
-		return ret;
+		return 0;
 	}
 
 	type = ((buffer[12] >> 1) & 7) + 1; /* P_TYPE 0 = Type 1 */
 
-	if (type > T10_PI_TYPE3_PROTECTION)
-		ret = -ENODEV;
-	else if (scsi_host_dif_capable(sdp->host, type))
-		ret = 1;
-
-	if (sdkp->first_scan || type != sdkp->protection_type)
-		switch (ret) {
-		case -ENODEV:
-			sd_printk(KERN_ERR, sdkp, "formatted with unsupported" \
-				  " protection type %u. Disabling disk!\n",
-				  type);
-			break;
-		case 1:
-			sd_printk(KERN_NOTICE, sdkp,
-				  "Enabling DIF Type %u protection\n", type);
-			break;
-		case 0:
-			sd_printk(KERN_NOTICE, sdkp,
-				  "Disabling DIF Type %u protection\n", type);
-			break;
-		}
+	if (type > T10_PI_TYPE3_PROTECTION) {
+		sd_printk(KERN_ERR, sdkp, "formatted with unsupported"	\
+			  " protection type %u. Disabling disk!\n",
+			  type);
+		sdkp->protection_type = 0;
+		return -ENODEV;
+	}
 
 	sdkp->protection_type = type;
 
-	return ret;
+	return 0;
+}
+
+static void sd_config_protection(struct scsi_disk *sdkp)
+{
+	struct scsi_device *sdp = sdkp->device;
+
+	if (!sdkp->first_scan)
+		return;
+
+	sd_dif_config_host(sdkp);
+
+	if (!sdkp->protection_type)
+		return;
+
+	if (!scsi_host_dif_capable(sdp->host, sdkp->protection_type)) {
+		sd_printk(KERN_NOTICE, sdkp,
+			  "Disabling DIF Type %u protection\n",
+			  sdkp->protection_type);
+		sdkp->protection_type = 0;
+	}
+
+	sd_printk(KERN_NOTICE, sdkp, "Enabling DIF Type %u protection\n",
+		  sdkp->protection_type);
 }
 
 static void read_capacity_error(struct scsi_disk *sdkp, struct scsi_device *sdp,
@@ -3409,6 +3417,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
 		sd_config_write_same(sdkp);
 		sd_config_discard(sdkp, SD_LBP_DEFAULT);
 		sd_config_write_zeroes(sdkp, SD_ZERO_DEFAULT);
+		sd_config_protection(sdkp);
 	}
 
 	/*
@@ -3667,11 +3676,6 @@ static int sd_probe(struct device *dev)
 		goto out;
 	}
 
-	if (sdkp->capacity)
-		sd_dif_config_host(sdkp);
-
-	sd_revalidate_disk(gd);
-
 	if (sdkp->security) {
 		sdkp->opal_dev = init_opal_dev(sdkp, &sd_sec_submit);
 		if (sdkp->opal_dev)
diff --git a/drivers/scsi/sd_dif.c b/drivers/scsi/sd_dif.c
index 349950616adc..968993ee6d5d 100644
--- a/drivers/scsi/sd_dif.c
+++ b/drivers/scsi/sd_dif.c
@@ -59,8 +59,6 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 			bi.profile = &t10_pi_type1_crc;
 
 	bi.tuple_size = sizeof(struct t10_pi_tuple);
-	sd_printk(KERN_NOTICE, sdkp,
-		  "Enabling DIX %s protection\n", bi.profile->name);
 
 	if (dif && type) {
 		bi.flags |= BLK_INTEGRITY_DEVICE_CAPABLE;
@@ -72,11 +70,11 @@ void sd_dif_config_host(struct scsi_disk *sdkp)
 			bi.tag_size = sizeof(u16) + sizeof(u32);
 		else
 			bi.tag_size = sizeof(u16);
-
-		sd_printk(KERN_NOTICE, sdkp, "DIF application tag size %u\n",
-			  bi.tag_size);
 	}
 
+	sd_printk(KERN_NOTICE, sdkp,
+		  "Enabling DIX %s, application tag size %u bytes\n",
+		  bi.profile->name, bi.tag_size);
 out:
 	blk_integrity_register(disk, &bi);
 }
-- 
2.32.0

