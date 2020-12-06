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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 405ECC19425
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 10:14:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F19B62311B
	for <linux-scsi@archiver.kernel.org>; Sun,  6 Dec 2020 10:14:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726604AbgLFKOl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 6 Dec 2020 05:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726035AbgLFKOh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Dec 2020 05:14:37 -0500
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65501C0613D4;
        Sun,  6 Dec 2020 02:13:51 -0800 (PST)
Received: by mail-ed1-x541.google.com with SMTP id d18so10475888edt.7;
        Sun, 06 Dec 2020 02:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DzTqd9dkl5EkbKVipIPtqS62+QvHIcMxfNkqNfnETf0=;
        b=ioqAM6y+ez21ZM4xdfyLATaiLpkXrrYMyJi/PiGZarxFrmRB2uS4yBfoPB6Y6urYSm
         yVLTFxmq2pFZ1HJ6NvQC8aY4VRHfiZe/L6ygDh8kKBTgCiXHHrv4qhjHgj9tyrqtrJDa
         Qm+EDB01FvYrYPhqZtQvIz4QudWX37F/0JetxUv+V0yqoOU0kaexpE2XFanv9SnXC47N
         e2rmPfnH53Ajvk9PuJsn3D+a9uTQHI6qBDmVGLNwjvtzSTiR44U0xkxsNUd1TF+mcS3x
         bz6AZ2X9wul/YouDlHJslvuYcoFDD67LjE37bQ3ZCmmjsa4eGbKGAsX5dQLb/mnDkeus
         snag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DzTqd9dkl5EkbKVipIPtqS62+QvHIcMxfNkqNfnETf0=;
        b=AeVA8PNyzSWhFQJuZUk6FDRgx2KOeqP1ATJmwnsn7tWf3FIlEUU5O60ElWuRNZsmT2
         RrpktISkf9aNX65TeukCQoqIk7W0vxFQ1EQ37HY+gsn60vggIEqa2QpyHVSGrRGHIsjc
         woWRzKjt2U49d05Joh9YGtwWXfiw1zBcLNMfiF08RCOksjw/hubHG8riKAa4F5kfi+T+
         vH5b3pEbMv0NbNc1fgFzOQxoHXS5DCgp6IS5HGJSoFkJCx+o4EDF7PJP+PgKUZVrGXxx
         kmKtyQERQ7EsV9LcSGG7n/B0DJayC/zINl/B6twJ6luKL4fqVABX2A/Zh/t8jpDjPF08
         r4ow==
X-Gm-Message-State: AOAM531NBtFTrrVCZncTcqvwW/vtgYxMfImXLTkQfwq3pVFu9crHOQov
        Y9mwgnwpuaOLqw1xb+W8dK4=
X-Google-Smtp-Source: ABdhPJzpP9j7qajOfYX98NuVK48hM76s+4TnOkp6Bfgfv4GqBBweq16YGAUt8DgxAZPnSi5YDtKRmw==
X-Received: by 2002:a05:6402:366:: with SMTP id s6mr3807855edw.44.1607249630163;
        Sun, 06 Dec 2020 02:13:50 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id f24sm7701919ejf.117.2020.12.06.02.13.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 02:13:49 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/3] scsi: ufs: Keep device active mode only fWriteBoosterBufferFlushDuringHibernate == 1
Date:   Sun,  6 Dec 2020 11:13:34 +0100
Message-Id: <20201206101335.3418-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201206101335.3418-1-huobean@gmail.com>
References: <20201206101335.3418-1-huobean@gmail.com>
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
index 30332592e624..da38d760944b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -285,10 +285,16 @@ static inline void ufshcd_wb_config(struct ufs_hba *hba)
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
 
@@ -5448,6 +5454,7 @@ static bool ufshcd_wb_need_flush(struct ufs_hba *hba)
 
 	if (!ufshcd_is_wb_allowed(hba))
 		return false;
+
 	/*
 	 * The ufs device needs the vcc to be ON to flush.
 	 * With user-space reduction enabled, it's enough to enable flush
@@ -8540,6 +8547,7 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	enum ufs_pm_level pm_lvl;
 	enum ufs_dev_pwr_mode req_dev_pwr_mode;
 	enum uic_link_state req_link_state;
+	bool hibern8;
 
 	hba->pm_op_in_progress = 1;
 	if (!ufshcd_is_shutdown_pm(pm_op)) {
@@ -8599,11 +8607,13 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
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

