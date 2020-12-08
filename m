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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13AD3C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:10:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E098B23B1A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 21:10:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729733AbgLHVKg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 16:10:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728551AbgLHVKe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 16:10:34 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27490C061794;
        Tue,  8 Dec 2020 13:09:54 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id ga15so26665183ejb.4;
        Tue, 08 Dec 2020 13:09:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=yxa79y+dWlbM9PnngE1WxJbURfn2atLQazPtCccKi84=;
        b=taeT/fjNy+0QXQqkqdjvSGD26ZejL2QQJihlf8T+oUzs6wCqd1MtnM7f72eQk5HJb8
         E1TwPFcFnyysMSj1lWSF4GkyhVjNMlc3yTwLLvdizTGcUKDiCBiY84SSd4Ef1hEDlgKn
         LMiJdSiIJ+qci8JqqVUI19uVfDm9HO+aZBpnw/W1/jMJ2npYtbHT1WY29irl/CIF06aX
         kHzStvX55wGJbg6sUgYaUvL+uy37Zm5askIJpLoO6cX6JQ4gXcvBN+eFgcqAq7m3oyvZ
         iA5eagMpUtKyNYDw/hbk7U45d0+I0/IIEQ289hYKS5V3I2m6aP8KT48l0Z88wPxmebsT
         xEFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=yxa79y+dWlbM9PnngE1WxJbURfn2atLQazPtCccKi84=;
        b=O21Qe2W5u4MMb96rCY4R/R1wUyr6QGmV5LX6/LsFfldc5eQ6r3h29hTmWZordmA6nx
         6RMMacU2OeKb8oNe62yhI4/4eFNO+dfGZ61HBVt5ugX0JAJ8JmIuUZDR89t7cUZCnMGx
         WrFIHKHRYLxlUQWv9Oc72k5I4K1yKD572yRwhSDwhOa6dBEBPDVhYM86TAIzzcmNFUAI
         oF96JDK85ydpoB6Wx8OpipaPFzU7M2i9pfMigQ5PwDcP1J5yA8VUBX7xSFf+fAGrvCl1
         EnSF5O+TRJyPw01lQ3fMO8eKqnZQFsLFbTVBaDH18RQS7vsOqGsXhpGa0oFBd+FutpwE
         CqIw==
X-Gm-Message-State: AOAM531RnWMSp19dieY4K+jlpuVDm8vGZ76yy8co0Ge+8G07dlLKpfWp
        jW7CHdLUCRsXpVzMkBpFDaM=
X-Google-Smtp-Source: ABdhPJwROkqzPhQM+uQq1OVxMOuajT6R9Gl2i78m1q4iDt2csUFF2BeD/PApEURBDeFaGqUXmrDoGw==
X-Received: by 2002:a17:906:94c5:: with SMTP id d5mr24179757ejy.427.1607461792899;
        Tue, 08 Dec 2020 13:09:52 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id n22sm17908edr.11.2020.12.08.13.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 13:09:52 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/3] scsi: ufs: Keep device active mode only fWriteBoosterBufferFlushDuringHibernate == 1
Date:   Tue,  8 Dec 2020 22:09:40 +0100
Message-Id: <20201208210941.2177-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201208210941.2177-1-huobean@gmail.com>
References: <20201208210941.2177-1-huobean@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

According to the JEDEC UFS 3.1 Spec, If fWriteBoosterBufferFlushDuringHibernate
is set to one, the device flushes the WriteBooster Buffer data automatically
whenever the link enters the hibernate (HIBERN8) state. While the flushing
operation is in progress, the device should be kept in Active power mode.
Currently, we set this flag during the UFSHCD probe stage, but we didn't deal
with its programming failure. Even this failure is less likely to occur, but
still it is possible.
This patch is to add checkup of fWriteBoosterBufferFlushDuringHibernate setting,
keep the device as "active power mode" only when this flag be successfully set
to 1.

Fixes: 51dd905bd2f6 ("scsi: ufs: Fix WriteBooster flush during runtime suspend")
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h    |  2 ++
 drivers/scsi/ufs/ufshcd.c | 20 +++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index d593edb48767..311d5f7a024d 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -530,6 +530,8 @@ struct ufs_dev_info {
 	bool f_power_on_wp_en;
 	/* Keeps information if any of the LU is power on write protected */
 	bool is_lu_power_on_wp;
+	/* Indicates if flush WB buffer during hibern8 successfully enabled */
+	bool is_hibern8_wb_flush;
 	/* Maximum number of general LU supported by the UFS device */
 	u8 max_lu_supported;
 	u8 wb_dedicated_lu;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f9fefb6c7ddb..f3ba46c48383 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -283,10 +283,16 @@ static inline void ufshcd_wb_config(struct ufs_hba *hba)
 		dev_err(hba->dev, "%s: Enable WB failed: %d\n", __func__, ret);
 	else
 		dev_info(hba->dev, "%s: Write Booster Configured\n", __func__);
+
 	ret = ufshcd_wb_toggle_flush_during_h8(hba, true);
-	if (ret)
+	if (ret) {
 		dev_err(hba->dev, "%s: En WB flush during H8: failed: %d\n",
 			__func__, ret);
+		hba->dev_info.is_hibern8_wb_flush = false;
+	} else {
+		hba->dev_info.is_hibern8_wb_flush = true;
+	}
+
 	ufshcd_wb_toggle_flush(hba, true);
 }
 
@@ -5444,6 +5450,7 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 
 	if (!ufshcd_is_wb_allowed(hba))
 		return false;
+
 	/*
 	 * The ufs device needs the vcc to be ON to flush.
 	 * With user-space reduction enabled, it's enough to enable flush
@@ -8535,6 +8542,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	enum ufs_pm_level pm_lvl;
 	enum ufs_dev_pwr_mode req_dev_pwr_mode;
 	enum uic_link_state req_link_state;
+	bool hibern8;
 
 	hba->pm_op_in_progress = 1;
 	if (!ufshcd_is_shutdown_pm(pm_op)) {
@@ -8594,11 +8602,13 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 		 * Hibern8, keep device power mode as "active power mode"
 		 * and VCC supply.
 		 */
+		hibern8 = req_link_state == UIC_LINK_HIBERN8_STATE ||
+			(req_link_state == UIC_LINK_ACTIVE_STATE &&
+			 ufshcd_is_auto_hibern8_enabled(hba));
+
 		hba->dev_info.b_rpm_dev_flush_capable =
-			hba->auto_bkops_enabled ||
-			(((req_link_state == UIC_LINK_HIBERN8_STATE) ||
-			((req_link_state == UIC_LINK_ACTIVE_STATE) &&
-			ufshcd_is_auto_hibern8_enabled(hba))) &&
+			hba->auto_bkops_enabled || (hibern8 &&
+			hba->dev_info.is_hibern8_wb_flush &&
 			ufshcd_wb_need_flush(hba));
 	}
 
-- 
2.17.1

