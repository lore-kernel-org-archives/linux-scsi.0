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
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD8A1C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 21:39:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EC142247F
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Dec 2020 21:39:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgLWVjW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Dec 2020 16:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725536AbgLWVjV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Dec 2020 16:39:21 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37DA9C0617A6;
        Wed, 23 Dec 2020 13:38:41 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id d17so982919ejy.9;
        Wed, 23 Dec 2020 13:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=M/LQBu//i4RMgFaViCE8yWcfBThRAvtu9np9/z5UKcA=;
        b=JZ8POMQIpp9nX9ywg7hCQh3AQe14rgom6PSXxOY75H/lREoS25BiYPMYZPSWQm/trh
         RLExldw0tS/QtYvXDryEH8cDvhFLpVCyRxJT3HJXZaCsnfTJmBHfxWiRvq4Cp4glNTbd
         QPiralQN9hM7AcznYpCqfD0DmPGnY9NUPAcDf8oGdpjFEzzZ8vXslWp2zbvLuCj8ouMU
         Bg+1ruziIM+oEDPAJGtq+sV/pBB5UtoGydfSJDsbTuWHKxNuwLI+I6muSBgUtiWoOCos
         ASLxBJhoBt0bpFCwmx+W21Gq5Mo7gmk4MhrjK/gF2m03gaWrBeQGe0sNLAA6zUbGPRT6
         DX3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=M/LQBu//i4RMgFaViCE8yWcfBThRAvtu9np9/z5UKcA=;
        b=lV4u5Sun7+29L7L3srwKYu1MgFqAFnXCUwk+pkJNkxH6Co0Hw49RrGERBj71iOlNfD
         yQW4B+u66bdseHpqgPne860NpagpBbNY+VvD894S6naR9ma3/9fszrynmlPYvIFfwXEc
         avQrebscfWXaDyfmfarfXWd8u2EZuiaZ9K2eLNlr+wcnXBJFCe2feh/c2RcTQ2woNPBS
         R69IDlYwlYzFIeP/rqhIBuHPN3DjnQx+wKC3OwFqpi8F+qUT9qVb1f1bsUCT8lrh7w3w
         LJAB+6GW2qA1MdVv+R5jk4isDX+13v3h+rjxyhXU4ZbMtUXdYv50KfR3T4vjTtyMHJvp
         lQhQ==
X-Gm-Message-State: AOAM531EwAmCW+1jYxJCVSIoy0nvWxTAm2ERqCC1TzqZPObet77n68Lf
        /v2cKSgfQuUVG2+XVf74khk=
X-Google-Smtp-Source: ABdhPJxiTEDxNroZp+SyHRVp7Kg5p38KDfFQ6UV5GxrQsfB8uydvCz2jxXpkAWtqFDp0ikoql4Zpdg==
X-Received: by 2002:a17:906:94d4:: with SMTP id d20mr25475975ejy.475.1608759520016;
        Wed, 23 Dec 2020 13:38:40 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id p12sm11896994ejc.116.2020.12.23.13.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Dec 2020 13:38:39 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net
Subject: [PATCH v1 2/2] scsi: ufs: Add handling of the return value of pm_runtime_get_sync()
Date:   Wed, 23 Dec 2020 22:38:26 +0100
Message-Id: <20201223213826.20252-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201223213826.20252-1-huobean@gmail.com>
References: <20201223213826.20252-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

The race issue may exist between UFS access in UFS sysfs context and UFS
shutdown, thus will cause pm_runtime_get_sync() resume failure.
Add handling of the return value of pm_runtime_get_sync(). Let it return
in case pm_runtime_get_sync() resume failed.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs-sysfs.c | 38 ++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index 0e1438485133..8e5e36e01bee 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -154,12 +154,17 @@ static ssize_t auto_hibern8_show(struct device *dev,
 				 struct device_attribute *attr, char *buf)
 {
 	u32 ahit;
+	int ret;
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
 	if (!ufshcd_is_auto_hibern8_supported(hba))
 		return -EOPNOTSUPP;
 
-	pm_runtime_get_sync(hba->dev);
+	ret = pm_runtime_get_sync(hba->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(hba->dev);
+		return ret;
+	}
 	ufshcd_hold(hba, false);
 	ahit = ufshcd_readl(hba, REG_AUTO_HIBERNATE_IDLE_TIMER);
 	ufshcd_release(hba);
@@ -225,7 +230,12 @@ static ssize_t ufs_sysfs_read_desc_param(struct ufs_hba *hba,
 	if (param_size > 8)
 		return -EINVAL;
 
-	pm_runtime_get_sync(hba->dev);
+	ret = pm_runtime_get_sync(hba->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(hba->dev);
+		return ret;
+	}
+
 	ret = ufshcd_read_desc_param(hba, desc_id, desc_index,
 				param_offset, desc_buf, param_size);
 	pm_runtime_put_sync(hba->dev);
@@ -594,7 +604,11 @@ static ssize_t _name##_show(struct device *dev,				\
 	desc_buf = kzalloc(QUERY_DESC_MAX_SIZE, GFP_ATOMIC);		\
 	if (!desc_buf)                                                  \
 		return -ENOMEM;                                         \
-	pm_runtime_get_sync(hba->dev);					\
+	ret = pm_runtime_get_sync(hba->dev);				\
+	if (ret < 0) {							\
+		pm_runtime_put_noidle(hba->dev);			\
+		return ret;						\
+	}								\
 	ret = ufshcd_query_descriptor_retry(hba,			\
 		UPIU_QUERY_OPCODE_READ_DESC, QUERY_DESC_IDN_DEVICE,	\
 		0, 0, desc_buf, &desc_len);				\
@@ -653,7 +667,11 @@ static ssize_t _name##_show(struct device *dev,				\
 	struct ufs_hba *hba = dev_get_drvdata(dev);			\
 	if (ufshcd_is_wb_flags(QUERY_FLAG_IDN##_uname))			\
 		index = ufshcd_wb_get_query_index(hba);			\
-	pm_runtime_get_sync(hba->dev);					\
+	ret = pm_runtime_get_sync(hba->dev);				\
+	if (ret < 0) {							\
+		pm_runtime_put_noidle(hba->dev);			\
+		return ret;						\
+	}								\
 	ret = ufshcd_query_flag(hba, UPIU_QUERY_OPCODE_READ_FLAG,	\
 		QUERY_FLAG_IDN##_uname, index, &flag);			\
 	pm_runtime_put_sync(hba->dev);					\
@@ -711,7 +729,11 @@ static ssize_t _name##_show(struct device *dev,				\
 	u8 index = 0;							\
 	if (ufshcd_is_wb_attrs(QUERY_ATTR_IDN##_uname))			\
 		index = ufshcd_wb_get_query_index(hba);			\
-	pm_runtime_get_sync(hba->dev);					\
+	ret = pm_runtime_get_sync(hba->dev);				\
+	if (ret < 0) {							\
+		pm_runtime_put_noidle(hba->dev);			\
+		return ret;						\
+	}								\
 	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,	\
 		QUERY_ATTR_IDN##_uname, index, 0, &value);		\
 	pm_runtime_put_sync(hba->dev);					\
@@ -850,7 +872,11 @@ static ssize_t dyn_cap_needed_attribute_show(struct device *dev,
 	u8 lun = ufshcd_scsi_to_upiu_lun(sdev->lun);
 	int ret;
 
-	pm_runtime_get_sync(hba->dev);
+	ret = pm_runtime_get_sync(hba->dev);
+	if (ret < 0) {
+		pm_runtime_put_noidle(hba->dev);
+		return ret;
+	}
 	ret = ufshcd_query_attr(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 		QUERY_ATTR_IDN_DYN_CAP_NEEDED, lun, 0, &value);
 	pm_runtime_put_sync(hba->dev);
-- 
2.17.1

