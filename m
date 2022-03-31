Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CCA3C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 22:37:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242581AbiCaWjo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 18:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242589AbiCaWjm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 18:39:42 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 266111FF406
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:37:55 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id f10so879774plr.6
        for <linux-scsi@vger.kernel.org>; Thu, 31 Mar 2022 15:37:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ee+/xnCKqAdEn8UHVQiXBO+TN7BUlP/a4ZqPwD2DVcU=;
        b=yYr8Sk32lyFkg6qQ2vGwlX1a2MNQ3tVMPye2ZXCC775l3kkXW0nzSrlngAgP7l/pbH
         Z7bhWTQajg2TIBrwlXXER1zPm2Ch068rcun+ofNRLU0JmkK2/HOfsUTBp4mrTTxpsP5N
         YWIe6Uddzr8INiBiHBs3E7gvW058AzMwSO5R2X3+z9bsXy6iOvAv+6GQ1eTM1GwW8JdJ
         zDF9ft3J+XxWsdLkKbL/nAdikTxqkPKGBEC0WVP23BzbjtiNF0GXVRVES1GYsDfQcRLw
         kFmKK8LFqBRxF+PEgq+nXCqIH68KkBqrjHc3gKR62oZ58/l8iExQkfLWBkN6LPGuW5eV
         ltzA==
X-Gm-Message-State: AOAM532Y+x2WrnVAxJB8spzu0aXDBvHKWz2RiGJjA+E9Xp2jD9XikzVd
        2qvlqRNZ7Ul/yaUSmSJrbrY=
X-Google-Smtp-Source: ABdhPJyKmx/eTr7ffTtM8/OfXZBxM7+CdvCSv6Z5F/yKLTFK2oasMe2a0kZq0Ve7yMHZf6wqeoyPBA==
X-Received: by 2002:a17:90b:1e4b:b0:1c6:edfe:70ad with SMTP id pi11-20020a17090b1e4b00b001c6edfe70admr8547052pjb.198.1648766274570;
        Thu, 31 Mar 2022 15:37:54 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6375:fa54:efe8:6c8f])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm483481pfo.155.2022.03.31.15.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 15:37:53 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 20/29] scsi: ufs: Remove locking from around single register writes
Date:   Thu, 31 Mar 2022 15:34:15 -0700
Message-Id: <20220331223424.1054715-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.35.1.1094.g7c7d902a7c-goog
In-Reply-To: <20220331223424.1054715-1-bvanassche@acm.org>
References: <20220331223424.1054715-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Single register writes are atomic and hence do not need to be surrounded
by locking. Additionally, PCI bus writes are posted asynchronously and
hence there is no guarantee that these have finished by the time the
spin_unlock*() call has finished.

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
index c81b5f3f0b9a..d6af4d82dfed 100644
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
