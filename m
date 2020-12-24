Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDCDFC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 17:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6EF922512
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 17:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728700AbgLXRVI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Dec 2020 12:21:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbgLXRVH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Dec 2020 12:21:07 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A91EC061757;
        Thu, 24 Dec 2020 09:20:27 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id b9so4084265ejy.0;
        Thu, 24 Dec 2020 09:20:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GGGzCG6IsBMm3fKDl4elkBUls6e2qJh6NDI+c/9UOVg=;
        b=A84eQ8uVK969jiJpPK8vMzc/Lqjy5tRqL3zSTKKnNfLXXRbLO49oKzNcIsl5NvxqkZ
         /yy2sLywselg8mHHlONdYTQocLy5wRinuSfyYjX7/a+f6Ch1wfXUYGMpjsaLOIBCU187
         pnGKVoAYsTZgBo27GPBbhqPe12PdgAVsU6d0V9OTEFpz5k4DKFB2QHukyQcP9Mkk8554
         a2y/kvrPoPHSZV4vw0tBXm5vjZXy+uFrGE9NlmovHSgEsyJO5wpvXlZv92tbfgLxeUtO
         dN/by6puRFDD3UD+xw5DFdNCrcxMbjk3j59b8py6SIAHGvChuk/Yf865Mc4gurCGNLoz
         qaMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GGGzCG6IsBMm3fKDl4elkBUls6e2qJh6NDI+c/9UOVg=;
        b=H9h5Zk+UFGMqxiybUN+Xxmx1cvzNbj481zcGg40O/gpH1YuIV829VT1X8MYS6L6K3f
         MmnRxEswZlbXgMf2J4cBoysijiy0iZMBuG0gGA1Qpxloy35KnyvXDSamBqUb6CWQ5Lis
         y45PtEpI5FRj+2Hbz1IlZ2M2uK9AqwwU/sAbM7rZnI2ayN6Vzndv3PpPjnkFmm1EHNUH
         dwrvdNzQTugvd/LefpraRiSWeay/CapTQEqHC4NBx6nE20vGHKz3MRxGgfO9RaLYLIlj
         EirXirX3/0plPOjWFkRUk2LBVz8b4nHt7d5D6tA1Ze78g0t4rPzAnu7DQOHMX9kpid5l
         f/1g==
X-Gm-Message-State: AOAM533bEyfVzzk/BUXBMAMDQYHoGyPrnfjryntD//9HJ9HMQgwb7Yom
        AODWHYK+G7ZQws5QFJ6Ancw=
X-Google-Smtp-Source: ABdhPJxwfqpAyB2nBZn54mlMWSjbeK9ir7qV1+u+LZm+giSvrDBMjS2wmfYoMIQt+zwAMfeqFTVAhw==
X-Received: by 2002:a17:907:105e:: with SMTP id oy30mr28636567ejb.495.1608830425752;
        Thu, 24 Dec 2020 09:20:25 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id m5sm12874446eja.11.2020.12.24.09.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 09:20:25 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net
Subject: [PATCH v2 1/3] scsi: ufs: Replace sprintf and snprintf with sysfs_emit
Date:   Thu, 24 Dec 2020 18:20:08 +0100
Message-Id: <20201224172010.10701-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201224172010.10701-1-huobean@gmail.com>
References: <20201224172010.10701-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

sprintf and snprintf may cause output defect in sysfs content, it is
better to use new added sysfs_emit function which knows the size of the
temporary buffer.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs-sysfs.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 08e72b7eef6a..0e1438485133 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -67,7 +67,7 @@ static ssize_t rpm_lvl_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%d\n", hba->rpm_lvl);
+	return sysfs_emit(buf, "%d\n", hba->rpm_lvl);
 }
 
 static ssize_t rpm_lvl_store(struct device *dev,
@@ -81,7 +81,7 @@ static ssize_t rpm_target_dev_state_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%s\n", ufschd_ufs_dev_pwr_mode_to_string(
+	return sysfs_emit(buf, "%s\n", ufschd_ufs_dev_pwr_mode_to_string(
 			ufs_pm_lvl_states[hba->rpm_lvl].dev_state));
 }
 
@@ -90,7 +90,7 @@ static ssize_t rpm_target_link_state_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%s\n", ufschd_uic_link_state_to_string(
+	return sysfs_emit(buf, "%s\n", ufschd_uic_link_state_to_string(
 			ufs_pm_lvl_states[hba->rpm_lvl].link_state));
 }
 
@@ -99,7 +99,7 @@ static ssize_t spm_lvl_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%d\n", hba->spm_lvl);
+	return sysfs_emit(buf, "%d\n", hba->spm_lvl);
 }
 
 static ssize_t spm_lvl_store(struct device *dev,
@@ -113,7 +113,7 @@ static ssize_t spm_target_dev_state_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%s\n", ufschd_ufs_dev_pwr_mode_to_string(
+	return sysfs_emit(buf, "%s\n", ufschd_ufs_dev_pwr_mode_to_string(
 				ufs_pm_lvl_states[hba->spm_lvl].dev_state));
 }
 
@@ -122,7 +122,7 @@ static ssize_t spm_target_link_state_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return sprintf(buf, "%s\n", ufschd_uic_link_state_to_string(
+	return sysfs_emit(buf, "%s\n", ufschd_uic_link_state_to_string(
 				ufs_pm_lvl_states[hba->spm_lvl].link_state));
 }
 
@@ -165,7 +165,7 @@ static ssize_t auto_hibern8_show(struct device *dev,
 	ufshcd_release(hba);
 	pm_runtime_put_sync(hba->dev);
 
-	return scnprintf(buf, PAGE_SIZE, "%d\n", ufshcd_ahit_to_us(ahit));
+	return sysfs_emit(buf, "%d\n", ufshcd_ahit_to_us(ahit));
 }
 
 static ssize_t auto_hibern8_store(struct device *dev,
@@ -233,18 +233,18 @@ static ssize_t ufs_sysfs_read_desc_param(struct ufs_hba *hba,
 		return -EINVAL;
 	switch (param_size) {
 	case 1:
-		ret = sprintf(sysfs_buf, "0x%02X\n", *desc_buf);
+		ret = sysfs_emit(sysfs_buf, "0x%02X\n", *desc_buf);
 		break;
 	case 2:
-		ret = sprintf(sysfs_buf, "0x%04X\n",
+		ret = sysfs_emit(sysfs_buf, "0x%04X\n",
 			get_unaligned_be16(desc_buf));
 		break;
 	case 4:
-		ret = sprintf(sysfs_buf, "0x%08X\n",
+		ret = sysfs_emit(sysfs_buf, "0x%08X\n",
 			get_unaligned_be32(desc_buf));
 		break;
 	case 8:
-		ret = sprintf(sysfs_buf, "0x%016llX\n",
+		ret = sysfs_emit(sysfs_buf, "0x%016llX\n",
 			get_unaligned_be64(desc_buf));
 		break;
 	}
@@ -609,7 +609,7 @@ static ssize_t _name##_show(struct device *dev,				\
 				      SD_ASCII_STD);			\
 	if (ret < 0)							\
 		goto out;						\
-	ret = snprintf(buf, PAGE_SIZE, "%s\n", desc_buf);		\
+	ret = sysfs_emit(buf, "%s\n", desc_buf);		\
 out:									\
 	pm_runtime_put_sync(hba->dev);					\
 	kfree(desc_buf);						\
@@ -659,7 +659,7 @@ static ssize_t _name##_show(struct device *dev,				\
 	pm_runtime_put_sync(hba->dev);					\
 	if (ret)							\
 		return -EINVAL;						\
-	return sprintf(buf, "%s\n", flag ? "true" : "false"); \
+	return sysfs_emit(buf, "%s\n", flag ? "true" : "false");	\
 }									\
 static DEVICE_ATTR_RO(_name)
 
@@ -717,7 +717,7 @@ static ssize_t _name##_show(struct device *dev,				\
 	pm_runtime_put_sync(hba->dev);					\
 	if (ret)							\
 		return -EINVAL;						\
-	return sprintf(buf, "0x%08X\n", value);				\
+	return sysfs_emit(buf, "0x%08X\n", value);			\
 }									\
 static DEVICE_ATTR_RO(_name)
 
@@ -856,7 +856,7 @@ static ssize_t dyn_cap_needed_attribute_show(struct device *dev,
 	pm_runtime_put_sync(hba->dev);
 	if (ret)
 		return -EINVAL;
-	return sprintf(buf, "0x%08X\n", value);
+	return sysfs_emit(buf, "0x%08X\n", value);
 }
 static DEVICE_ATTR_RO(dyn_cap_needed_attribute);
 
-- 
2.17.1

