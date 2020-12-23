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
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFD7DC433E9
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 21:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A8EE52255F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 21:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgLWVjU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Dec 2020 16:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgLWVjU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Dec 2020 16:39:20 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C01C06179C;
        Wed, 23 Dec 2020 13:38:39 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id ce23so995065ejb.8;
        Wed, 23 Dec 2020 13:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xEfv0KZGuuOpTAZ42Hf8x5TIYim2IQQK6zWSdku94+k=;
        b=gEUQk9qS2C47zJKB0oA6KR33HYbXxrbSXWss9ykbUw2WSkU3bDt8c2u1Qbr7irlAl8
         IUtGkBTk5SLS704RnoBwyx+FAJ2jKsKK7Buev/mpJSLkoDPxIBsQe6UkXPv92FE8HnjS
         hFQZuSMNsEnJwCdRjakGHti4dRyMTerjazB84IcY7JiRzVjAkcJuFh/nTIsWRAGGAZML
         HQj9hm/5hfaLEyrVyOpNFV7jk4BuGH5fYLFX0e/ytdp6M9nUi7mdElpTH4MPeulzqpSa
         YRL6r15Hbie9Eeb2khz3ZfRis5bT1ndRhvM5z1E7Ehx4bkNdnIzecRrwoHc9XZ1QV6V3
         GRqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=xEfv0KZGuuOpTAZ42Hf8x5TIYim2IQQK6zWSdku94+k=;
        b=Yq8HX2PluxHAJsGAOxD58WUJbTrQQs1UNwviQ5fBSBr4yh+IF1TmtOal1tJagM5YUG
         Ejs2CxqETFJL0iVm2BQFW0zQhxCKVKKR6PFa8fnwp/LX5z7ZqCWvnS1GurfVSfxWplyc
         d9h2Lfv2B9IFHgU1kHddRYdQMeC+Ll6vHlvDCBA5x5Po5zDliU9g8q0slwc30q94Ouju
         PuO2ILQJYaq4QMKnemCg93rRikaq6TXpCgMzucRKgy81Vt/GLnztEpm74VBIk34AnS7H
         DxYtRf0hVvy0N7kkc9h6E7D3QjRRqJH40ch3wLGk5uNfXXwjfXI9TSOdA1GwhDZbAUST
         Ctdw==
X-Gm-Message-State: AOAM532d4r1Zs6fzJb7EwVdMzYRkn9SjJzPJmOJElH0DI1Wz8r/nGsgi
        OK2KUSmffssvjNeKIRbA6YM=
X-Google-Smtp-Source: ABdhPJyjQyqGtxVcM0WpfAmlb76J7sO0Yfde4Sy6kHrQQ0K117l05X/L4tpxOurGQ9j8OiIsF15OKg==
X-Received: by 2002:a17:906:2798:: with SMTP id j24mr25665872ejc.328.1608759518637;
        Wed, 23 Dec 2020 13:38:38 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id p12sm11896994ejc.116.2020.12.23.13.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 13:38:38 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net
Subject: [PATCH v1 1/2] scsi: ufs: Replace sprintf and snprintf with sysfs_emit
Date:   Wed, 23 Dec 2020 22:38:25 +0100
Message-Id: <20201223213826.20252-2-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223213826.20252-1-huobean@gmail.com>
References: <20201223213826.20252-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

sprintf and snprintf may cause output defect in sysfs content, it is
better to use new added sysfs_emit function which knows the size of the
temporary buffer.

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

