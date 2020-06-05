Return-Path: <SRS0=+N3d=7S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BD50C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 19:15:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D9A820897
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 19:15:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kkQsqilh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728050AbgFETO7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Jun 2020 15:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727917AbgFETOx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2020 15:14:53 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53888C08C5C2;
        Fri,  5 Jun 2020 12:14:53 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id g1so8297867edv.6;
        Fri, 05 Jun 2020 12:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=pW/NC7zyGgCVnaE2/b9PeCQ7NYEWJXjZ3Xg7zwHZYno=;
        b=kkQsqilhvLTzz/QlVysY2oS3rFrNu6HO/45WFulh7tiX9ri3virfItEjj/+t7xzyM6
         FtvIhGmcd8QQmrKfTIxkyaZkNudAv7EMY1SRxRHGTLnD1f683KGefociP3xGSjHUynPr
         0riwbGch/o2cTTIj/qG5F9OKVUWaQBI9tWl+V1P9zvRoFoqnVDUaKktFmLMRbnR9p6u1
         ZzHi1rlU82XN4hb9AYONaO+Ncp7GExyZbPE6322BrTEp4G+8vkdW92XfsU/M2gGEesN7
         S27V1WDTF6QPsphd/6EeAGzFGm6VfYPCcc0bxhiafIkoS026lJX/mlHBC0nHn/DUzYmg
         9VcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=pW/NC7zyGgCVnaE2/b9PeCQ7NYEWJXjZ3Xg7zwHZYno=;
        b=WsabeR9QV5F2JC2wyRGS+DZySGqQgFdMNZNEAGVuxyLaC/ekOuUl9yWvQR/VMbQw83
         3BNDDCIS/+nJKePLdV/SxSDslu2cFV33QUevjRoxrRGsiKskrzUOE3+DC074yokm7lzp
         L3us4fX1/8YX21/qiJaKnrgdUzGc5VRoqNoxha16xM97yaKd8LkWJPaPtA95rnhKbpro
         m8JlLI+iwq8Al94Jyk2fZPZSk7NO70a8uUKw0cf4lzqWGVjXyzhK7czA5ggnRoDhayUx
         9jp5ICQ9JBx5aBev3VWFLVxIqp8ikJ1ng4NZVrVdZ3kul0QZE5wtHtB7SzpEIU2Lre0S
         PZuQ==
X-Gm-Message-State: AOAM532g6xYBqvKpVXNFBhBQ6XOseFlbgvvBDuG0lOk4Il2uTAr1tnOq
        YjNQhgFP0iI9cswozLFZEWw=
X-Google-Smtp-Source: ABdhPJx4iOCJCA2ISZkSBNFlDiKhfec/qAKIX5bRCy/G6HS8DUIX0DRoh9aMsvIc8mdyE8Ji/tl+AA==
X-Received: by 2002:a50:cfc4:: with SMTP id i4mr10567875edk.252.1591384492046;
        Fri, 05 Jun 2020 12:14:52 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcfd.dynamic.kabel-deutschland.de. [95.91.252.253])
        by smtp.gmail.com with ESMTPSA id ck11sm5123614ejb.41.2020.06.05.12.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2020 12:14:51 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] scsi: ufs: remove wrapper function ufshcd_setup_clocks()
Date:   Fri,  5 Jun 2020 21:14:39 +0200
Message-Id: <20200605191439.19313-3-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200605191439.19313-1-huobean@gmail.com>
References: <20200605191439.19313-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

The static function ufshcd_setup_clocks() is just a wrapper around
__ufshcd_setup_clocks(), remove it. Rename original function wrapped
__ufshcd_setup_clocks() to new ufshcd_setup_clocks().

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 32 ++++++++++++--------------------
 1 file changed, 12 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index e2939382897d..3ad6aac9f193 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -215,9 +215,7 @@ static int ufshcd_eh_host_reset_handler(struct scsi_cmnd *cmd);
 static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag);
 static void ufshcd_hba_exit(struct ufs_hba *hba);
 static int ufshcd_probe_hba(struct ufs_hba *hba, bool async);
-static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
-				 bool skip_ref_clk);
-static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
+static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on, bool skip_ref_clk);
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
 static int ufshcd_host_reset_and_restore(struct ufs_hba *hba);
@@ -1497,7 +1495,7 @@ static void ufshcd_ungate_work(struct work_struct *work)
 	}
 
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	ufshcd_setup_clocks(hba, true);
+	ufshcd_setup_clocks(hba, true, false);
 
 	ufshcd_enable_irq(hba);
 
@@ -1655,10 +1653,10 @@ static void ufshcd_gate_work(struct work_struct *work)
 	ufshcd_disable_irq(hba);
 
 	if (!ufshcd_is_link_active(hba))
-		ufshcd_setup_clocks(hba, false);
+		ufshcd_setup_clocks(hba, false, false);
 	else
 		/* If link is active, device ref_clk can't be switched off */
-		__ufshcd_setup_clocks(hba, false, true);
+		ufshcd_setup_clocks(hba, false, true);
 
 	/*
 	 * In case you are here to cancel this work the gating state
@@ -7683,8 +7681,7 @@ static int ufshcd_init_hba_vreg(struct ufs_hba *hba)
 	return 0;
 }
 
-static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
-					bool skip_ref_clk)
+static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on, bool skip_ref_clk)
 {
 	int ret = 0;
 	struct ufs_clk_info *clki;
@@ -7747,11 +7744,6 @@ static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 	return ret;
 }
 
-static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on)
-{
-	return  __ufshcd_setup_clocks(hba, on, false);
-}
-
 static int ufshcd_init_clocks(struct ufs_hba *hba)
 {
 	int ret = 0;
@@ -7858,7 +7850,7 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 	if (err)
 		goto out_disable_hba_vreg;
 
-	err = ufshcd_setup_clocks(hba, true);
+	err = ufshcd_setup_clocks(hba, true, false);
 	if (err)
 		goto out_disable_hba_vreg;
 
@@ -7880,7 +7872,7 @@ static int ufshcd_hba_init(struct ufs_hba *hba)
 out_disable_vreg:
 	ufshcd_setup_vreg(hba, false);
 out_disable_clks:
-	ufshcd_setup_clocks(hba, false);
+	ufshcd_setup_clocks(hba, false, false);
 out_disable_hba_vreg:
 	ufshcd_setup_hba_vreg(hba, false);
 out:
@@ -7896,7 +7888,7 @@ static void ufshcd_hba_exit(struct ufs_hba *hba)
 		if (ufshcd_is_clkscaling_supported(hba))
 			if (hba->devfreq)
 				ufshcd_suspend_clkscaling(hba);
-		ufshcd_setup_clocks(hba, false);
+		ufshcd_setup_clocks(hba, false, false);
 		ufshcd_setup_hba_vreg(hba, false);
 		hba->is_powered = false;
 		ufs_put_device_desc(hba);
@@ -8259,10 +8251,10 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_disable_irq(hba);
 
 	if (!ufshcd_is_link_active(hba))
-		ufshcd_setup_clocks(hba, false);
+		ufshcd_setup_clocks(hba, false, false);
 	else
 		/* If link is active, device ref_clk can't be switched off */
-		__ufshcd_setup_clocks(hba, false, true);
+		ufshcd_setup_clocks(hba, false, true);
 
 	hba->clk_gating.state = CLKS_OFF;
 	trace_ufshcd_clk_gating(dev_name(hba->dev), hba->clk_gating.state);
@@ -8321,7 +8313,7 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 
 	ufshcd_hba_vreg_set_hpm(hba);
 	/* Make sure clocks are enabled before accessing controller */
-	ret = ufshcd_setup_clocks(hba, true);
+	ret = ufshcd_setup_clocks(hba, true, false);
 	if (ret)
 		goto out;
 
@@ -8404,7 +8396,7 @@ static int ufshcd_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_disable_irq(hba);
 	if (hba->clk_scaling.is_allowed)
 		ufshcd_suspend_clkscaling(hba);
-	ufshcd_setup_clocks(hba, false);
+	ufshcd_setup_clocks(hba, false, false);
 out:
 	hba->pm_op_in_progress = 0;
 	if (ret)
-- 
2.17.1

