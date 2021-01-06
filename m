Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6CDCC433E0
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 21:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78BE323158
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Jan 2021 21:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbhAFVQd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Jan 2021 16:16:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725788AbhAFVQd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jan 2021 16:16:33 -0500
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7365C061575;
        Wed,  6 Jan 2021 13:15:52 -0800 (PST)
Received: by mail-ej1-x62f.google.com with SMTP id b9so7050260ejy.0;
        Wed, 06 Jan 2021 13:15:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=QRheIFhD7wkffZBzA+D0IWmMPq8XWePLdFJFeZNmTTE=;
        b=bRHWVrv+1LB6kz+uWchiHR1g44HJll0bbdUxQMPuSCRZEe21+dSyEzE2xavl84dkM/
         1JM0bR94HwZ7TdSFqkD7psrYb8Nr75S33ipPfDK10JpvVo9A/VrAh3FNYTzKFOmHe52z
         eDJx0KqcHFFKxq2CU20RZXqLvn4aEVAbtfI+vOVqDnuY1JyS1Fr5tmW/BVj1wM9dgOCs
         n+PdwuUEQGNJGBErw9DcjW4Z0E6p+657fM4CoIt0s2Hkm7OUeAidoC+AGViIi1BDPhHS
         rhzqNmrWTeGgT9j92KkxdDGIY8aVXYAc8SDGtPimo0edibIrhXoiBJ9iLJWX4ACzOuxS
         zt3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=QRheIFhD7wkffZBzA+D0IWmMPq8XWePLdFJFeZNmTTE=;
        b=dHMSYpcClc3rYIsGMPsXRy/YhZ3wM5M37SchcLnlClJgNLRb9hwTDv0s51iAtgJB5s
         8rauMAxavwnilyTWmy5sj6XRQ7bCvYj9qwr/SKVbsi08hXTV5l2y4N78M4MspTTco+aK
         Y3kKQmEuwCaisocbMi0DV6/SFJLFF6FUDuVZvdyJUJSp1VMH1s+eDRLiLTSefeEYu4p+
         +6F3AW/z0X8HlnchxR69rbslBihaDUn+RhYEDyJr4OjAG+0JUyxTJNrZncN4t2NoXrJA
         ER+4owvy566qux52kSnAa5O1iq13yE6Zq03xRe4WZgf2R2HKRnvW+x1fwWNdZpEJQMzz
         Thjw==
X-Gm-Message-State: AOAM530220rG0TbuZ+Cv+nLZFSye2uFSiBu3cEJpAl42dA4uMI+eTrJA
        HADQ1UNxYL8Ij+Pme/A6ah4=
X-Google-Smtp-Source: ABdhPJxiwbnXnmwJ4cYIJokJa0IPQstspls+eHItyVciliOguLSsSmydbHVKe54DFPXQ+mdWMJfKJA==
X-Received: by 2002:a17:906:eb5b:: with SMTP id mc27mr4114502ejb.163.1609967751428;
        Wed, 06 Jan 2021 13:15:51 -0800 (PST)
Received: from localhost.localdomain ([95.91.252.255])
        by smtp.gmail.com with ESMTPSA id n8sm1708742eju.33.2021.01.06.13.15.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 13:15:50 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3] scsi: ufs: Replace sprintf and snprintf with sysfs_emit
Date:   Wed,  6 Jan 2021 22:15:41 +0100
Message-Id: <20210106211541.23039-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
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
Nothing changed in this patch, just take it out from patchset:
https://patchwork.kernel.org/project/linux-scsi/cover/20201224172010.10701-1-huobean@gmail.com/

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

