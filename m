Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D2B0C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:12:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A27E22DA9
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Jan 2021 20:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388075AbhARULu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Jan 2021 15:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437862AbhARULh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Jan 2021 15:11:37 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA342C0613CF;
        Mon, 18 Jan 2021 12:10:56 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id w1so25355352ejf.11;
        Mon, 18 Jan 2021 12:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=ltiNIANAr10krz1rWQiJ2pZ0/X2sLNeMpvDcCYoHUaY=;
        b=MVA9dTIDRvYh6XXUpamir6tr2JSXd4+CrkBOdiGdSvl6lYqjAOrQqfvfqLPiGz2yHI
         L3iEzw1Ag+ZWRoIKjbjd2/RVx6fzrGMmgiSRvM6dOyLrq7VWN7msSrOU+M8i00Wfezdt
         i4z3qX6Trs0cP8+wVeAmZ5hYW3MI4xMkzmBC/yHkF4TOYoPdITZaVPj+gMxk98OLQKaM
         l+v/t/kAbEMcAhEPjDpJQyd7ps/nqOpJES0QBpC31DcK3RtetyEBSakCYOnBaB3kDg13
         UI8AfdPv7EoOjERGMuyrZd+4wMAogad1Pcws10m22wce1e/OGflqAmNchj6Uu9HFqV14
         MrOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=ltiNIANAr10krz1rWQiJ2pZ0/X2sLNeMpvDcCYoHUaY=;
        b=iNh2SNWN96nD/VJZ5eOWTN039jf4hwlX3033J6sk4XjQZsNuvFqQ7srz3jBJzTv0xN
         Tw96LvK8OnvSYYeDnofGQeVVGdYYrP0tjtP/6Psk9p9se65e1osdfsWt0BMovcTBt2C1
         vBTwAiJ0Y+zl7dcGXWPI6gi5eEFk6PTXQ6Q88CGi8DpSi/xo+4tgy+1Z+HRO6Pm3ZDQE
         vsdYj+uzgHG+lRBJ1CDrseTUhfpWvUExKJVdBaA2P14OSbsnF/45JNj+D+vGonQQSs0+
         zY34icb1JF5tn7Ky8S5iTn8rTZTqaBW0eOywD3IKqA7xa8xuhHg3aH3UiqVsSBVeIl04
         wr7A==
X-Gm-Message-State: AOAM531RM6JXw92MtS6GfqLuZ+Yh866VYEn0E3wqbXJL4OHneUX025Ru
        XZNbnUpcUfAN5S43Ko64BqQ=
X-Google-Smtp-Source: ABdhPJw0xKA+oHIWulQZfG90elveZMHUGbjfIACbR8mR7TqqBkatGmRKoRN3KQ7kDb0Dd7H1fzaaMw==
X-Received: by 2002:a17:906:bfcc:: with SMTP id us12mr836618ejb.163.1611000655621;
        Mon, 18 Jan 2021 12:10:55 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.gmail.com with ESMTPSA id qh13sm3972543ejb.33.2021.01.18.12.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 12:10:55 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v6 4/6] scsi: ufs: Remove two WB related fields from struct ufs_dev_info
Date:   Mon, 18 Jan 2021 21:10:37 +0100
Message-Id: <20210118201039.2398-5-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210118201039.2398-1-huobean@gmail.com>
References: <20210118201039.2398-1-huobean@gmail.com>
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
index a3758fd83ebd..827d9f360287 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7269,6 +7269,7 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 	struct ufs_dev_info *dev_info = &hba->dev_info;
 	u8 lun;
 	u32 d_lu_wb_buf_alloc;
+	u32 ext_ufs_feature;
 
 	if (!ufshcd_is_wb_allowed(hba))
 		return;
@@ -7286,11 +7287,10 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
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
@@ -7305,10 +7305,8 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
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

