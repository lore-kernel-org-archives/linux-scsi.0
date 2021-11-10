Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E791C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 02:39:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1690561181
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 02:39:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbhKJClx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Nov 2021 21:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbhKJClx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Nov 2021 21:41:53 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC532C061764;
        Tue,  9 Nov 2021 18:39:06 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id n85so1246285pfd.10;
        Tue, 09 Nov 2021 18:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mkk7gNnp0YbcgFN+jbyPPP0eQtmzhbTwC6PXKFwoF30=;
        b=KL7KVnMFCClji6KlA9p7MuR0LxCDQRRL+NPJNYdld0H4EkWwSNJGWhvnPM8qHsyPzB
         aGT6R98M2BSxUTnGmdOz9rKuRZu1aLYsINvOX62Kh1NKe6edOJz+sDlI9AVvjwd7VGdY
         b9NKPcR4EciR10xM6u43Yd2t+BeFErnT3KW714lBG0DS7twp8Q76vvQVQMsag34ceNDi
         3CP6BWq2dSFQskCMGIsG5uBoRtoH0LbAv2xo6okuRl3QEbSLdFhlj8yB8du3Mz4rmHTw
         NqOYd54LQj9wN/IoRzotr9vCMzwPNzCyIHLHHwtgMPfT07pAt/AlJevjvaUAASKBpP60
         oD4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Mkk7gNnp0YbcgFN+jbyPPP0eQtmzhbTwC6PXKFwoF30=;
        b=c17XimLUrvbk6ZZrVSISwD84wSL+EmPDTYHacz7Kfc99vg3mOm3upWpahyrQMDre8x
         gqKY7jv8XJIW9vqNGXJAs0ThkRTsAvgHVWj8CAi4GeMrOOtduAe6O2rKDEVUrnhM7GWW
         yENysgTDwfAzoZLAXM5Byw9qsle54YGq3rJSQjEtzNUiEH1FzrbWPwPJNU2sx/d2nPfq
         uXjG7qxB7pOHdokpN8AAqGEDdb+WZcJO3wufMIHrJYj3IEzmcSJXGRy2nUP4VjjQKoUf
         Rw9IUtqkLEYVq9SoXVnShRWiC5mq2bT5OxdodFtbJvLLlazv2YAibT6iBrQ/O0SMLWFn
         vBtA==
X-Gm-Message-State: AOAM531LcdyOl01NR9VCIpE/BwX8/DTH23TeVuRrnQm4ckoS1mNnAjid
        QSR5mLRd2biiZ744NcW2OV1rhQ9ArA4=
X-Google-Smtp-Source: ABdhPJxgLJOQnDEmsTET+jLnbw+6l4UJubpySbki3xtlwreUujDvyjgy75RCan+NVJjNvFtI+QTJOA==
X-Received: by 2002:a05:6a00:1693:b0:44c:64a3:d318 with SMTP id k19-20020a056a00169300b0044c64a3d318mr13547511pfc.81.1636511946240;
        Tue, 09 Nov 2021 18:39:06 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id k1sm3715889pjj.54.2021.11.09.18.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Nov 2021 18:39:06 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: yao.jing2@zte.com.cn
To:     hare@kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jing Yao <yao.jing2@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] scsi: myrs: Replace snprintf in show functions with sysfs_emit
Date:   Wed, 10 Nov 2021 02:39:01 +0000
Message-Id: <20211110023901.135804-1-yao.jing2@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Jing Yao <yao.jing2@zte.com.cn>

coccicheck complains about the use of snprintf() in sysfs show
functions:
WARNING use scnprintf or sprintf

Use sysfs_emit instead of scnprintf, snprintf or sprintf makes more
sense.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Jing Yao <yao.jing2@zte.com.cn>
---
 drivers/scsi/myrs.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/myrs.c b/drivers/scsi/myrs.c
index 6ea323e9a2e3..22cb819c0c06 100644
--- a/drivers/scsi/myrs.c
+++ b/drivers/scsi/myrs.c
@@ -941,7 +941,7 @@ static ssize_t raid_state_show(struct device *dev,
 	int ret;
 
 	if (!sdev->hostdata)
-		return snprintf(buf, 16, "Unknown\n");
+		return sysfs_emit(buf, "Unknown\n");
 
 	if (sdev->channel >= cs->ctlr_info->physchan_present) {
 		struct myrs_ldev_info *ldev_info = sdev->hostdata;
@@ -949,9 +949,9 @@ static ssize_t raid_state_show(struct device *dev,
 
 		name = myrs_devstate_name(ldev_info->dev_state);
 		if (name)
-			ret = snprintf(buf, 32, "%s\n", name);
+			ret = sysfs_emit(buf, "%s\n", name);
 		else
-			ret = snprintf(buf, 32, "Invalid (%02X)\n",
+			ret = sysfs_emit(buf, "Invalid (%02X)\n",
 				       ldev_info->dev_state);
 	} else {
 		struct myrs_pdev_info *pdev_info;
@@ -960,9 +960,9 @@ static ssize_t raid_state_show(struct device *dev,
 		pdev_info = sdev->hostdata;
 		name = myrs_devstate_name(pdev_info->dev_state);
 		if (name)
-			ret = snprintf(buf, 32, "%s\n", name);
+			ret = sysfs_emit(buf, "%s\n", name);
 		else
-			ret = snprintf(buf, 32, "Invalid (%02X)\n",
+			ret = sysfs_emit(buf, "Invalid (%02X)\n",
 				       pdev_info->dev_state);
 	}
 	return ret;
@@ -1060,7 +1060,7 @@ static ssize_t raid_level_show(struct device *dev,
 	const char *name = NULL;
 
 	if (!sdev->hostdata)
-		return snprintf(buf, 16, "Unknown\n");
+		return sysfs_emit(buf, "Unknown\n");
 
 	if (sdev->channel >= cs->ctlr_info->physchan_present) {
 		struct myrs_ldev_info *ldev_info;
@@ -1068,13 +1068,13 @@ static ssize_t raid_level_show(struct device *dev,
 		ldev_info = sdev->hostdata;
 		name = myrs_raid_level_name(ldev_info->raid_level);
 		if (!name)
-			return snprintf(buf, 32, "Invalid (%02X)\n",
+			return sysfs_emit(buf, "Invalid (%02X)\n",
 					ldev_info->dev_state);
 
 	} else
 		name = myrs_raid_level_name(MYRS_RAID_PHYSICAL);
 
-	return snprintf(buf, 32, "%s\n", name);
+	return sysfs_emit(buf, "%s\n", name);
 }
 static DEVICE_ATTR_RO(raid_level);
 
@@ -1088,7 +1088,7 @@ static ssize_t rebuild_show(struct device *dev,
 	unsigned char status;
 
 	if (sdev->channel < cs->ctlr_info->physchan_present)
-		return snprintf(buf, 32, "physical device - not rebuilding\n");
+		return sysfs_emit(buf, "physical device - not rebuilding\n");
 
 	ldev_info = sdev->hostdata;
 	ldev_num = ldev_info->ldev_num;
@@ -1100,11 +1100,11 @@ static ssize_t rebuild_show(struct device *dev,
 		return -EIO;
 	}
 	if (ldev_info->rbld_active) {
-		return snprintf(buf, 32, "rebuilding block %zu of %zu\n",
+		return sysfs_emit(buf, "rebuilding block %zu of %zu\n",
 				(size_t)ldev_info->rbld_lba,
 				(size_t)ldev_info->cfg_devsize);
 	} else
-		return snprintf(buf, 32, "not rebuilding\n");
+		return sysfs_emit(buf, "not rebuilding\n");
 }
 
 static ssize_t rebuild_store(struct device *dev,
@@ -1192,7 +1192,7 @@ static ssize_t consistency_check_show(struct device *dev,
 	unsigned short ldev_num;
 
 	if (sdev->channel < cs->ctlr_info->physchan_present)
-		return snprintf(buf, 32, "physical device - not checking\n");
+		return sysfs_emit(buf, "physical device - not checking\n");
 
 	ldev_info = sdev->hostdata;
 	if (!ldev_info)
@@ -1200,11 +1200,11 @@ static ssize_t consistency_check_show(struct device *dev,
 	ldev_num = ldev_info->ldev_num;
 	myrs_get_ldev_info(cs, ldev_num, ldev_info);
 	if (ldev_info->cc_active)
-		return snprintf(buf, 32, "checking block %zu of %zu\n",
+		return sysfs_emit(buf, "checking block %zu of %zu\n",
 				(size_t)ldev_info->cc_lba,
 				(size_t)ldev_info->cfg_devsize);
 	else
-		return snprintf(buf, 32, "not checking\n");
+		return sysfs_emit(buf, "not checking\n");
 }
 
 static ssize_t consistency_check_store(struct device *dev,
@@ -1305,7 +1305,7 @@ static ssize_t serial_show(struct device *dev,
 
 	memcpy(serial, cs->ctlr_info->serial_number, 16);
 	serial[16] = '\0';
-	return snprintf(buf, 16, "%s\n", serial);
+	return sysfs_emit(buf, "%s\n", serial);
 }
 static DEVICE_ATTR_RO(serial);
 
@@ -1315,7 +1315,7 @@ static ssize_t ctlr_num_show(struct device *dev,
 	struct Scsi_Host *shost = class_to_shost(dev);
 	struct myrs_hba *cs = shost_priv(shost);
 
-	return snprintf(buf, 20, "%d\n", cs->host->host_no);
+	return sysfs_emit(buf, "%d\n", cs->host->host_no);
 }
 static DEVICE_ATTR_RO(ctlr_num);
 
-- 
2.25.1

