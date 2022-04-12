Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00989C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 18:22:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358492AbiDLSYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 14:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349095AbiDLSYy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 14:24:54 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6532F5D64B
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:22:36 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id mm4-20020a17090b358400b001cb93d8b137so3822670pjb.2
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 11:22:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=suepi4ajJAfM8bieNhK4/XUW0mgtvhHSHvhiWsmr9rE=;
        b=OQrimYZ4wdODK1rU2iWDGH8WFCYjwBTNw1Z4fXdrOlguyDDiH/p68rtS6qq1t5SM1f
         t2kdxhrUKss3eX9DdndmeYGUnK0t6TzXN2R6XkoRtcQ+MVR34Hs9BsXx25oNv+cl7iF9
         7q3Shjk3BBi9AIRP08w4wJ6+BhGQU5AgWnI5MJw4/BVUFvW367AXqDsiV40QsKMX5cph
         RIyy/e89pUen2JxezHW10rKE+dZ/GzianzaWzhm0ngQuxrjZFH6aZ3qabHgEh/4fdhiV
         6/tBifg2dEWJOqgHSRrH0Roph7TiA9MDJe9h7EhvWhRntPSoz8kH+zeCvsSmIfEJv+wW
         DO2g==
X-Gm-Message-State: AOAM533ycoXJtE9tqHwUaMAy1FB2zyZbvZ4+K5F2UpE8Ao6EVzJQlZdu
        +EsxGPgl+P8Ayo+juVZ+Dtg=
X-Google-Smtp-Source: ABdhPJxB2YDqRHlxmoyyNNR2vH5iBDMpiNuMpaq2p7jlrhn29LhcJxaEjbUVQ7LzVCbAMugJj2Bhsw==
X-Received: by 2002:a17:902:f708:b0:153:839f:bf2c with SMTP id h8-20020a170902f70800b00153839fbf2cmr39625371plo.113.1649787755498;
        Tue, 12 Apr 2022 11:22:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:d4b2:56ee:d001:c159])
        by smtp.gmail.com with ESMTPSA id d18-20020a056a0010d200b004fa2e13ce80sm40367037pfu.76.2022.04.12.11.22.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 11:22:34 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Daejun Park <daejun7.park@samsung.com>
Subject: [PATCH v2 20/29] scsi: ufs: Remove locking from around single register writes
Date:   Tue, 12 Apr 2022 11:18:44 -0700
Message-Id: <20220412181853.3715080-21-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.0.rc0.470.gd361397f0d-goog
In-Reply-To: <20220412181853.3715080-1-bvanassche@acm.org>
References: <20220412181853.3715080-1-bvanassche@acm.org>
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
