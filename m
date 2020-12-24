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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43777C4332B
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 17:21:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 246762333B
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 17:21:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728782AbgLXRVJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Dec 2020 12:21:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728757AbgLXRVI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Dec 2020 12:21:08 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 280BAC0613C1;
        Thu, 24 Dec 2020 09:20:28 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id g20so4073544ejb.1;
        Thu, 24 Dec 2020 09:20:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=M/LQBu//i4RMgFaViCE8yWcfBThRAvtu9np9/z5UKcA=;
        b=Ms/eruC8VTv6TU8MVGSXjz7bkMOulkKXj8aW/dBzQM/k391Oj2+5HCt21Deuk89pCk
         gGQpC+FkIkk0+mHk9yCDec4qpsLnJg1JXekl4qxqaGzjAMNX/XeOHS6dPoCwF9E4P4vJ
         d6rKtbgkUuexYec+s3lpxG4xuQKPEip79i6JOVheWrhAU6Crx28T2OZ5p92Jrvs/Bn7h
         e/+kbJkESR0tIXZ4IUjr2Kvn6bMz//axjjkM6XQ1Fv5F//Dl6cXiOeV77J0cFvszqNy3
         vBRTpDC4M0i7fOsjFzF3p8FSBCj/Oq+s24yPUiRDKhHiRUAg4AKFeBW/oLlFYQiP8k65
         BsVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=M/LQBu//i4RMgFaViCE8yWcfBThRAvtu9np9/z5UKcA=;
        b=NltxW1FvtvSsFRhqVSNDtdw31PCPaDDsHajjSlgZ0PBvP51eDOUfsvOoOBGQVY2Aw8
         w3PsxF5ajT3woVXn7tNB4L0dVu2gYNHm8dnpRFM7g4GqFCkaRyVLkF97aqZEK/htvUbw
         IurUjYHlQccDWVTImLNXgqXoQFtAUeEehrpQhLRCaWYUlozYGy7xvpPaXJxCAhjXjhG5
         2Thqi+j8BkaNG2Ozl1aB5QKGC3U0lhtEHEInImxOZFfoDvUIInJKodPWZb1CaNrrEo+6
         QOSo+VjO9kT7jPijpjQ6la+imnvwjXnXeKP/0YrKx7a6WFEJfQ2/4bWpQP9jgfMsC0p+
         RTQQ==
X-Gm-Message-State: AOAM533DzXXUC1IcMY+CI/g2erQ4TtKGKRvPRWBnq8bbIS8le19+HxlH
        qLQgh8iV3GSoSqmpm6yZkFw=
X-Google-Smtp-Source: ABdhPJzN/gLmuzqyLugtiP/+C7l4ix2b7L87Sg6F/PypGxkJxjWRIHY3iPGhayjhSrMJ+LaMifWMLw==
X-Received: by 2002:a17:906:59a:: with SMTP id 26mr28356496ejn.309.1608830426883;
        Thu, 24 Dec 2020 09:20:26 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id m5sm12874446eja.11.2020.12.24.09.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 09:20:26 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net
Subject: [PATCH v2 2/3] scsi: ufs: Add handling of the return value of pm_runtime_get_sync()
Date:   Thu, 24 Dec 2020 18:20:09 +0100
Message-Id: <20201224172010.10701-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201224172010.10701-1-huobean@gmail.com>
References: <20201224172010.10701-1-huobean@gmail.com>
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

