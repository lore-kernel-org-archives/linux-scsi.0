Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6AF8C4161F
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A7F9B20706
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 18:28:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391123AbhASRCw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 12:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387787AbhASQjs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 11:39:48 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B856BC0613C1;
        Tue, 19 Jan 2021 08:39:07 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id rv9so10625283ejb.13;
        Tue, 19 Jan 2021 08:39:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=x3iaktssMsx35re+ePjSYuuphi63Sg/vQJuTVNRQ1PI=;
        b=A1Fvc8QyZgmYnW0bcJy9kLzd/JdI4l9U3e0n3usU66uClwx5bGsif+K7Ud9gRpXxRk
         KNgYGL/z3dEa51WSIcmYoe+CFLQXqUDyO7S2uR3tw5rIXnMu0UbhtZCGnHAI7d7gnt37
         6uwVLJhTUw8wF3QDfCyHGfvC7/JHH018NZlLr1PJ21q42PihmTvcgHvhB094eiLdkVFf
         Q7CHUykZZtTA8dIvHFbPgDiaQmY5KJVkMKqfDFnGtyZhT4CO5//4oAVtu3DLvt6pq4RQ
         mgObN/GwkajethESdblctExRQj5/5fDAgqLoUzcuqRW/P9vSZ9L3k2RYPonoxeFH4Agi
         ZETA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=x3iaktssMsx35re+ePjSYuuphi63Sg/vQJuTVNRQ1PI=;
        b=JwPZW2YDKrNiYM2WCMFvW7rtGae1AUTBvs0icYfw5zUMAEMwAxGIX0sDavmWBThj08
         17U7McjBXr8XxfNEOEtrwdff7qwLAHcrQNTYJrb38LaojtLiyel5BjyyFpqiaBk78Vyp
         bg1AtcW6AOuw4jMKpy515uIFPA2laxULTzJXfIbeO9O+jdJ/XFhykWmmKZ5kKoAMIjIO
         ILeTHZEwuDppNqGJ1JOqU3AJWD6Fz9WKGqR4Fneoce5DTCgxO9O5uhYDrFANlwyng2un
         /fjQXXAuRZ3o4F+ZJ4oynvU8qLXZdRlSVgVM5Xcj3tmLakrgvcIzb4VT5KxjrrAHVhlo
         8z4Q==
X-Gm-Message-State: AOAM531hwLdCnyA5mM9HoklpI52oC50ZMfWKBH+asnWLcBatw0p8BRiT
        TFAp+behA592EwILhwh91K4=
X-Google-Smtp-Source: ABdhPJyVWfv2S9QFX/OxCCnsapHy5tUlnzFkOFyn5I2/qGJZZ3Mf1NVS16GJtgYFWIkUP+Ia3rlUwQ==
X-Received: by 2002:a17:907:16a2:: with SMTP id hc34mr3616256ejc.9.1611074346477;
        Tue, 19 Jan 2021 08:39:06 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.gmail.com with ESMTPSA id k22sm9589993eji.101.2021.01.19.08.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 08:39:06 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v7 4/6] scsi: ufs: Remove two WB related fields from struct ufs_dev_info
Date:   Tue, 19 Jan 2021 17:38:45 +0100
Message-Id: <20210119163847.20165-5-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210119163847.20165-1-huobean@gmail.com>
References: <20210119163847.20165-1-huobean@gmail.com>
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

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h    |  2 --
 drivers/scsi/ufs/ufshcd.c | 14 ++++++--------
 2 files changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 09c7cc8a678d..a8000ed0017e 100644
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
index d13c6eb2efcd..f6fe14b60eff 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7270,6 +7270,7 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 	u8 lun;
 	u32 d_lu_wb_buf_alloc;
+	u32 ext_ufs_feature;
 
 	if (!ufshcd_is_wb_allowed(hba))
 		return;
@@ -7287,11 +7288,10 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
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
@@ -7306,10 +7306,8 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
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

