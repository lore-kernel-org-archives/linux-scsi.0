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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D07DAC4361B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 23:12:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8874022D03
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Dec 2020 23:12:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731471AbgLOXHA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Dec 2020 18:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730679AbgLOXG5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2020 18:06:57 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF02C061282;
        Tue, 15 Dec 2020 15:05:39 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id cm17so22855954edb.4;
        Tue, 15 Dec 2020 15:05:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=K3MOm2Pa8a6n6GbvdDyE1PLoBtq3ydXsNpuVZ9ruIkY=;
        b=LeBj1IEeeI0EuHsDSjJXjs+OrZNmvjWfffinsIOMf2Vz+RmbymgkNgOkGC4/jwtD/I
         6EcpXwR1ZIFUIFkviNWw5Ib5qAvaEJhmR/YNKDcXQphu4TofcUUaDlDQwew+VzstfD62
         F6Rf/fITIsKMjKHXCR2ENzBkMsbuGuLtVACaDV7FE7qkqQOJYB2Ljd+rsjnbqCslQMLi
         JPNShsQLcWl07msW/6ZzJUacZLY92UVcd/bbe/eOyf4LuClDo4tQezWXTmJkBYWdcWA8
         ZKcTXXZn/DvQJPEmsVrjhfY3NCN6OvUZEjwOG9HbKr2eL7LkYlKo7pzV8wQp4t7VxNm2
         MuLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=K3MOm2Pa8a6n6GbvdDyE1PLoBtq3ydXsNpuVZ9ruIkY=;
        b=rlwgzaD2O6oTePk+J1qvMzlrCVHS5f+IPwRQaOlFxUeiSZ2+bwFkjXfY3vEJ4RmaLV
         aIApeYeCY4yRv5ncbDx2xHGKFUctu0MungKOTx3cfyR2GJJ+psThNX7DpLMfbdA/QNyl
         tED3cf8LKl4j5wGOL3kbzCCUxohghbKdkt1HXNDwaIOqouP+y599LXUzOGR67usIjaZv
         N2m817zN1rzSmT2+T9W/reaCeX54kJkCdNx5R8DUgZSJdmFAAPZvPhAwmRaL2I060qfS
         XqscTYchlsYjnowT70epiCK3Vq8LvCQgLNS40txKB8be4NCfbc7pli5gCkPPs1s/70hc
         qJug==
X-Gm-Message-State: AOAM5317+bQ85lQe6nhcDMiypPjG+T4rVAmSGsw7B6R9cEzS5DnNdzo2
        COZxqNIGxlqn2Fs4g3wjV6M=
X-Google-Smtp-Source: ABdhPJyGAjtQeHhLwngoeVLYr3HHgzUUzR0GNDGD5TZX3av3EJ7j3ijAuUV/tpJNgXlEp5mzpj05Fg==
X-Received: by 2002:a50:d5c1:: with SMTP id g1mr32331785edj.299.1608073538042;
        Tue, 15 Dec 2020 15:05:38 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id e11sm19280455edj.44.2020.12.15.15.05.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Dec 2020 15:05:37 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v5 7/7] scsi: ufs: Keep device active mode only fWriteBoosterBufferFlushDuringHibernate == 1
Date:   Wed, 16 Dec 2020 00:05:19 +0100
Message-Id: <20201215230519.15158-8-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201215230519.15158-1-huobean@gmail.com>
References: <20201215230519.15158-1-huobean@gmail.com>
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
 drivers/scsi/ufs/ufs.h    |  1 +
 drivers/scsi/ufs/ufshcd.c | 21 ++++++++++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index ec74cf360b1f..506ae8fab558 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -541,6 +541,7 @@ struct ufs_dev_info {
 	/* UFS WB related flags */
 	bool    wb_enabled;
 	bool    wb_buf_flush_enabled;
+	bool    wb_buf_flush_in_hibern8;
 	u8	wb_dedicated_lu;
 	u8      wb_buffer_type;
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ba8298f0d017..3d9e6f5a7ffe 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -282,10 +282,16 @@ static inline void ufshcd_wb_config(struct ufs_hba *hba)
 		dev_err(hba->dev, "%s: Enable WB failed: %d\n", __func__, ret);
 	else
 		dev_info(hba->dev, "%s: Write Booster Configured\n", __func__);
+
 	ret = ufshcd_wb_toggle_flush_during_h8(hba, true);
-	if (ret)
+	if (ret) {
 		dev_err(hba->dev, "%s: En WB flush during H8: failed: %d\n",
 			__func__, ret);
+		hba->dev_info.wb_buf_flush_in_hibern8 = false;
+	} else {
+		hba->dev_info.wb_buf_flush_in_hibern8 = true;
+	}
+
 	ufshcd_wb_toggle_flush(hba, true);
 }
 
@@ -589,6 +595,7 @@ static void ufshcd_device_reset(struct ufs_hba *hba)
 		if (ufshcd_is_wb_allowed(hba)) {
 			hba->dev_info.wb_enabled = false;
 			hba->dev_info.wb_buf_flush_enabled = false;
+			hba->dev_info.wb_buf_flush_in_hibern8 = false;
 		}
 	}
 	if (err != -EOPNOTSUPP)
@@ -5468,6 +5475,7 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 
 	if (!ufshcd_is_wb_allowed(hba))
 		return false;
+
 	/*
 	 * The ufs device needs the vcc to be ON to flush.
 	 * With user-space reduction enabled, it's enough to enable flush
@@ -8567,6 +8575,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	enum ufs_pm_level pm_lvl;
 	enum ufs_dev_pwr_mode req_dev_pwr_mode;
 	enum uic_link_state req_link_state;
+	bool hibern8;
 
 	hba->pm_op_in_progress = 1;
 	if (!ufshcd_is_shutdown_pm(pm_op)) {
@@ -8626,11 +8635,13 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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
+			hba->dev_info.wb_buf_flush_in_hibern8 &&
 			ufshcd_wb_need_flush(hba));
 	}
 
-- 
2.17.1

