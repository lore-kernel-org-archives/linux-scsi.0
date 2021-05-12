Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877A1C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33EB7613E6
	for <linux-scsi@archiver.kernel.org>; Wed, 12 May 2021 21:26:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238275AbhELVXH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 May 2021 17:23:07 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:43734 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384508AbhELT6j (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 May 2021 15:58:39 -0400
Received: by mail-pl1-f176.google.com with SMTP id b15so6923471plh.10
        for <linux-scsi@vger.kernel.org>; Wed, 12 May 2021 12:57:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=cfzC70vyVwMhRtpzySVBT/aaw1kbfakj9c3nn2ijhwA=;
        b=fTTDeVV9xHQ0Zm8M0afYwc/BIVFVkniXWrinzRbHEEzVhUv0y6KiFeMvK7ghdfZhkq
         9sG7gZEfIblSmXbNnzh0Eyeq1DwjpgctyvNRH6sIfokJ1LN3l48uqQsLT3Lq5G8Zi8RA
         wJuBtNhiHW59ko2eF4XSuI4TfDIr9LE8uueTIvW/f2pQZ0fbhmZcPFndYNC473l741Di
         Z20oATTCb+RDvueTyWhglQh8GmTxWnXOyJdVfsIdaeQ1iFyUKMNmDatyMG985RG88jn0
         Iv4jMiy30J7yUC2YIG1dxAp8cz1KxsBnoku/Wy4sbdT+5YgUeX4FpXC60AJ9rtPsEa9f
         RAfA==
X-Gm-Message-State: AOAM532raPXZEG+yjdcLywZ90TPUwNiOAcjIIUTB6GMYn+lhYD8+rvJg
        CRGpj2m9lnL2zICOk9884Q8=
X-Google-Smtp-Source: ABdhPJwPLF54EujXQikxup1fPWZxkbo+DtTNj86tKJMas4AcgqSXnDf1Kl+i76NY3JkR1ZuQzLKoDg==
X-Received: by 2002:a17:902:ed82:b029:ef:48c8:128e with SMTP id e2-20020a170902ed82b02900ef48c8128emr13515452plj.72.1620849447715;
        Wed, 12 May 2021 12:57:27 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:993e:1516:b2ba:76fe])
        by smtp.gmail.com with ESMTPSA id f18sm454712pjh.55.2021.05.12.12.57.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 12:57:26 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Can Guo <cang@codeaurora.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH] ufs: Fix handling of active power mode in ufshcd_suspend()
Date:   Wed, 12 May 2021 12:57:21 -0700
Message-Id: <20210512195721.8157-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If the rpm_lvl and spm_lvl sysfs attributes indicate that ufshcd_suspend()
should keep the link active, re-enable clock gating instead of disabling
clocks.

Suggested-by: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Can Guo <cang@codeaurora.org>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Bean Huo <beanhuo@micron.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/ufs/ufshcd.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f540b0cc253f..c96e36aab989 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8690,9 +8690,8 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	ufshcd_clk_scaling_suspend(hba, true);
 
 	if (req_dev_pwr_mode == UFS_ACTIVE_PWR_MODE &&
-			req_link_state == UIC_LINK_ACTIVE_STATE) {
-		goto disable_clks;
-	}
+			req_link_state == UIC_LINK_ACTIVE_STATE)
+		goto enable_gating;
 
 	if ((req_dev_pwr_mode == hba->curr_dev_pwr_mode) &&
 	    (req_link_state == hba->uic_link_state))
@@ -8754,7 +8753,6 @@ static int ufshcd_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 	if (ret)
 		goto set_dev_active;
 
-disable_clks:
 	/*
 	 * Call vendor specific suspend callback. As these callbacks may access
 	 * vendor specific host controller register space call them before the
