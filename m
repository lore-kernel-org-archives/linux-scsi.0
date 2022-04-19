Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94477C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 22:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358405AbiDSXB6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 19:01:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358395AbiDSXBm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 19:01:42 -0400
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FA3238781
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:59 -0700 (PDT)
Received: by mail-pg1-f172.google.com with SMTP id k14so25476518pga.0
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 15:58:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=suepi4ajJAfM8bieNhK4/XUW0mgtvhHSHvhiWsmr9rE=;
        b=XYkD+mYtkiha25OxWVShVDiNYoTrvJ/rcU7nhQsh0V8O/hsS2e4jeUyKeiKyZNIFiP
         0JkcpPRo4rQqZ5hE8fJ9ywMyINiMZqU7X/qkaHFx9zStd2KxIAJrfya/jPiSfE1JBbYi
         4WMLxjrVjnjgYqx1Opf7ftV/xrUg76c2UPTb/BcBXsGlQF5r6DlT+c6Aq3N5JzC365vk
         14IHfmesxvc03fylpwVaQDD4Xhy2GYyJshtLtCuQgKOuI5lfeL8CfdVYljsZcEii3+I9
         DkaCCngOC5At8qcOudx4KaFKsNo8f6C+Q126P27EIQxgx+ZcBS7+4MOlUH+e7uicKWT0
         zXyg==
X-Gm-Message-State: AOAM532k2uupK0aRXiGi8Fg1o0b6P1vVGgElpgK1iIL9qqiHvjE41nn+
        HvK5KEU+jgq1GjVSme5iwg0=
X-Google-Smtp-Source: ABdhPJyZ2GPZq4IuMxeQvQdRzlhq1A4BKwCtuQvdduBZnCsPB72nhHGi4fGP6riYfU5GArhaz7MZiA==
X-Received: by 2002:a65:4108:0:b0:399:1f0e:50da with SMTP id w8-20020a654108000000b003991f0e50damr16979201pgp.2.1650409138865;
        Tue, 19 Apr 2022 15:58:58 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id c15-20020a63350f000000b003992202f95fsm17622557pga.38.2022.04.19.15.58.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 15:58:57 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v3 20/28] scsi: ufs: Remove locking from around single register writes
Date:   Tue, 19 Apr 2022 15:58:03 -0700
Message-Id: <20220419225811.4127248-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org>
References: <20220419225811.4127248-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Single register writes are atomic and hence do not need to be surrounded
by locking. Additionally, MMIO writes are typically posted asynchronously.
Hence, there is no guarantee that these have finished by the time the
spin_unlock*() call has finished. See also the nonposted-mmio property of
the Open Firmware tree. See also pci_iomap().

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufs-mediatek.c | 8 --------
 drivers/scsi/ufs/ufshcd.c       | 4 ----
 2 files changed, 12 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-mediatek.c b/drivers/scsi/ufs/ufs-mediatek.c
index 9a4474210627..2b26acc74efb 100644
--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -171,7 +171,6 @@ static int ufs_mtk_hce_enable_notify(struct ufs_hba *hba,
 				     enum ufs_notify_change_status status)
 {
 	struct ufs_mtk_host *host = ufshcd_get_variant(hba);
-	unsigned long flags;
 
 	if (status == PRE_CHANGE) {
 		if (host->unipro_lpm) {
@@ -185,12 +184,8 @@ static int ufs_mtk_hce_enable_notify(struct ufs_hba *hba,
 			ufs_mtk_crypto_enable(hba);
 
 		if (host->caps & UFS_MTK_CAP_DISABLE_AH8) {
-			spin_lock_irqsave(hba->host->host_lock, flags);
 			ufshcd_writel(hba, 0,
 				      REG_AUTO_HIBERNATE_IDLE_TIMER);
-			spin_unlock_irqrestore(hba->host->host_lock,
-					       flags);
-
 			hba->capabilities &= ~MASK_AUTO_HIBERN8_SUPPORT;
 			hba->ahit = 0;
 		}
@@ -994,13 +989,10 @@ static void ufs_mtk_vreg_set_lpm(struct ufs_hba *hba, bool lpm)
 
 static void ufs_mtk_auto_hibern8_disable(struct ufs_hba *hba)
 {
-	unsigned long flags;
 	int ret;
 
 	/* disable auto-hibern8 */
-	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_writel(hba, 0, REG_AUTO_HIBERNATE_IDLE_TIMER);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	/* wait host return to idle state when auto-hibern8 off */
 	ufs_mtk_wait_idle_state(hba, 5);
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 37527865e26b..d1c3f6291538 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4207,14 +4207,10 @@ EXPORT_SYMBOL_GPL(ufshcd_auto_hibern8_update);
 
 void ufshcd_auto_hibern8_enable(struct ufs_hba *hba)
 {
-	unsigned long flags;
-
 	if (!ufshcd_is_auto_hibern8_supported(hba))
 		return;
 
-	spin_lock_irqsave(hba->host->host_lock, flags);
 	ufshcd_writel(hba, hba->ahit, REG_AUTO_HIBERNATE_IDLE_TIMER);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
 
  /**
