Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 237B2C4361B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 23:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D944F22D02
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 23:14:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbgLOXOf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:14:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731252AbgLOXG3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 18:06:29 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C8D7C0617A7;
        Tue, 15 Dec 2020 15:05:36 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id p22so22794169edu.11;
        Tue, 15 Dec 2020 15:05:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hfStZcmj6KeW2zkSZcYnBiE6Gi5znfpneu3gU+gm3Ms=;
        b=JS9wwCE3n53YJbbqCNVUqTP6v+7T2q9D9natTb+Qhk82C8DmcQBjUSyJaJYy8L7v00
         QjMqZKdrQuM/li3FmMB0Xk1I9pahd787WtutVhLE2qjNncq2dqKUwYzJg8keuxghCuza
         nccxhLUCTGLMeqy4xE64CQY2Fa/p/7Xxxye9X8lNbfhv8M+2LpWqf2Hoj0oDqadJOjXv
         +RyntaJic1WKg46bl4glZ9K1IIgOCY7I1UoWeutIWBHtqcxIWyo/jeNrdfOuVOG/6sZt
         OG212VhQsRgykK3BFITTvlx7kPpThqGc/DdKVEuayzV4eLDpC3WfTjzWvyWn2o4OkVuD
         3qvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hfStZcmj6KeW2zkSZcYnBiE6Gi5znfpneu3gU+gm3Ms=;
        b=Mbc9c3uuPYjJjGDF/h2RgMrJ7fJipDRzdbe0LKpjZGw8V3z3Uwo8Ybt+T82EfHKNl6
         U7eGa+4m9AjNxal5Rnr12u2+ucVmiMfvNFh52/Kdid5CVDMl93ktiV2OGLbmVJ9F6SGb
         /37gYDMiqGo/GBKxxULo48Hs6mKLtn7Bq2lO/njO9wLPSiiQDWwV9Pqav2gS2uep+Wk7
         WXoHqHnf9Ak+b0jH5dJOlDg27FX4IErIpTPwvg6o62/F4M5ARVnix5ulfYbO6SgyBmgo
         c6a4V14ZDEApkeHxf/ZRaHZAIkXzGDZK1oGX6Vmm9EPGWnMhYw1zvRysQIKlCS4MTT9Z
         HoIw==
X-Gm-Message-State: AOAM530QHf4JuHmllvd7rMNHe1AYLWV4VkCfTECCLMu4JGYom7TIyVZW
        To9ZuHNSQZVn2WJxat1Brc0=
X-Google-Smtp-Source: ABdhPJxptQIHrQQy8Ik5bKwyfUmKxTKId3Zzso6A03IVgc0alcr2+q8z+ngyeLM1qKsxr4w37EoRQA==
X-Received: by 2002:a05:6402:d09:: with SMTP id eb9mr31073849edb.71.1608073535037;
        Tue, 15 Dec 2020 15:05:35 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id e11sm19280455edj.44.2020.12.15.15.05.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 15:05:34 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 4/7] scsi: ufs: Remove two WB related fields from struct ufs_dev_info
Date:   Wed, 16 Dec 2020 00:05:16 +0100
Message-Id: <20201215230519.15158-5-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215230519.15158-1-huobean@gmail.com>
References: <20201215230519.15158-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

d_wb_alloc_units and d_ext_ufs_feature_sup only be used while WB probe.
They are just used to confirm the condition that "if bWriteBoosterBufferType
is set to 01h but dNumSharedWriteBoosterBufferAllocUnits is set to zero,
the WriteBooster feature is disabled", and if UFS device supports WB.
After that, no user uses them any more. So, don't need to keep time in
runtime.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h    |  2 --
 drivers/scsi/ufs/ufshcd.c | 14 ++++++--------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 14dfda735adf..a789e074ae3f 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -538,9 +538,7 @@ struct ufs_dev_info {
 	u8 *model;
 	u16 wspecversion;
 	u32 clk_gating_wait_us;
-	u32 d_ext_ufs_feature_sup;
 	u8 b_wb_buffer_type;
-	u32 d_wb_alloc_units;
 	bool b_rpm_dev_flush_capable;
 	u8 b_presrv_uspc_en;
 };
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 6a5532b752aa..5f08f4a59a17 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7207,6 +7207,7 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 	u8 lun;
 	u32 d_lu_wb_buf_alloc;
+	u32 ext_ufs_feature;
 
 	if (!ufshcd_is_wb_allowed(hba))
 		return;
@@ -7224,11 +7225,10 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 	    DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP + 4)
 		goto wb_disabled;
 
-	dev_info->d_ext_ufs_feature_sup =
-		get_unaligned_be32(desc_buf +
-				   DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
+	ext_ufs_feature = get_unaligned_be32(desc_buf +
+					DEVICE_DESC_PARAM_EXT_UFS_FEATURE_SUP);
 
-	if (!(dev_info->d_ext_ufs_feature_sup & UFS_DEV_WRITE_BOOSTER_SUP))
+	if (!(ext_ufs_feature & UFS_DEV_WRITE_BOOSTER_SUP))
 		goto wb_disabled;
 
 	/*
@@ -7243,10 +7243,8 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 		desc_buf[DEVICE_DESC_PARAM_WB_PRESRV_USRSPC_EN];
 
 	if (dev_info->b_wb_buffer_type == WB_BUF_MODE_SHARED) {
-		dev_info->d_wb_alloc_units =
-		get_unaligned_be32(desc_buf +
-				   DEVICE_DESC_PARAM_WB_SHARED_ALLOC_UNITS);
-		if (!dev_info->d_wb_alloc_units)
+		if (!get_unaligned_be32(desc_buf +
+				   DEVICE_DESC_PARAM_WB_SHARED_ALLOC_UNITS))
 			goto wb_disabled;
 	} else {
 		for (lun = 0; lun < UFS_UPIU_MAX_WB_LUN_ID; lun++) {
-- 
2.17.1

