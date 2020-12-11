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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F54DC2BB48
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 14:04:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E6CF23EF1
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 14:04:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392173AbgLKOC1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 09:02:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395215AbgLKOCG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2020 09:02:06 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 520A0C0617B0;
        Fri, 11 Dec 2020 06:00:56 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id c7so9446334edv.6;
        Fri, 11 Dec 2020 06:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=i9HXAbQDJP2xZsPDaVmYBTFFTsu0tRu3+PJZZnVwRUI=;
        b=s75O6HTKVd/HlHvMsQ5nnV3G9xq3bsMMG/rMZ/3Ap+fD/yN9TzHO0Jc1iVvzuic6CT
         zUHsjEx81va4ckd7kzVVhiwNEIbWUwfu79bFrxYFWDYE9EYcrYuXLxS7/GJa9diVbYtZ
         8M6L/o2zLBlmUqcdQlF8zU9Ob132RvtazvBpH+dNDMZXjQ10Yo4NivfBrvKEd+2+iXIx
         YYEaDji4JZoUvcWZHdDp/HXy1bqlo4k3YxS6zJqqxyLyzoBONeR338CL+Olz6s8LrDQ3
         FjRzdqmlI+0Q3Wyba8Gk+vNeVFFoM3AHPu93RWoD8+undRKLcf/6/Q2XO5vplwukhYGb
         8ZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=i9HXAbQDJP2xZsPDaVmYBTFFTsu0tRu3+PJZZnVwRUI=;
        b=fdGfPnS4Elc1KUtaRrDcnUYGdZ4tEd1N6a4+Down3aW7uymsg2Yp0PIZYpjQzIZcK4
         FSfBZqHncdTid4BxSRkjIdpe83A/X7qPv416O1YCzxznRqiH1Cd6Rv3tX4AqYvLiGKsz
         On88RY2tBKEueRjKi6+N5Vx0W82jWZK73KGGHLA4VtDEY0pd7+/dTRT9Xl0cir5D5HU/
         eWZuoUUOErlFOpBTGx07YQR9H7DqL6ZYzC6D6hEUB5SVPGwxxDJJkHEIcr4ZsbmIIwFj
         JDOix1PzTTX/dRRbzLdqmsuA09bC5A+Yss+TSVLnrhOtnBtx0toSJE0Z1/9cvXH67RRk
         C3gQ==
X-Gm-Message-State: AOAM531Q52VP326Xpl5PI99q0vlaKJ5XhDJ3hGXOd5j2gHpDXSGXu97C
        pL0m1yntj5ZftnFkuuN4szI=
X-Google-Smtp-Source: ABdhPJwYaOglyhNjDKnWXynRZBV9HoR8SHf6xxTIuja2ihVl1EZGZrbg3bM2Rg288F8yY/9wFFoFzg==
X-Received: by 2002:aa7:df0f:: with SMTP id c15mr12124049edy.354.1607695254978;
        Fri, 11 Dec 2020 06:00:54 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id z24sm7797818edr.9.2020.12.11.06.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 06:00:54 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 6/6] scsi: ufs: Keep device active mode only fWriteBoosterBufferFlushDuringHibernate == 1
Date:   Fri, 11 Dec 2020 15:00:35 +0100
Message-Id: <20201211140035.20016-7-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201211140035.20016-1-huobean@gmail.com>
References: <20201211140035.20016-1-huobean@gmail.com>
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
index 8ed342e43883..1b3866f608d9 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -542,6 +542,7 @@ struct ufs_dev_info {
 	/* UFS WB related flags */
 	bool	wb_enabled;
 	bool	wb_buf_flush_enabled;
+	bool	wb_buf_flush_in_hibern8;
 	u8	wb_dedicated_lu;
 	u8	b_wb_buffer_type;
 
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fb3c98724005..7ff486f047d8 100644
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
@@ -5471,6 +5478,7 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 
 	if (!ufshcd_is_wb_allowed(hba))
 		return false;
+
 	/*
 	 * The ufs device needs the vcc to be ON to flush.
 	 * With user-space reduction enabled, it's enough to enable flush
@@ -8571,6 +8579,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	enum ufs_pm_level pm_lvl;
 	enum ufs_dev_pwr_mode req_dev_pwr_mode;
 	enum uic_link_state req_link_state;
+	bool hibern8;
 
 	hba->pm_op_in_progress = 1;
 	if (!ufshcd_is_shutdown_pm(pm_op)) {
@@ -8630,11 +8639,13 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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

