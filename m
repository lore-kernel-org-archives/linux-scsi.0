Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CDAEC433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 14:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16866208E4
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jan 2021 14:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391202AbhASOju (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jan 2021 09:39:50 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:9248 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392007AbhASL4X (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jan 2021 06:56:23 -0500
IronPort-SDR: ZZoBz4pTtpQGVytKQ3DHRANApILwpfC4UkRPbn5u5bv5+HQhn0D+CC/k6a1cdnEjAXmtUGaDjI
 qkONwsi+Ef8DDZ1hb4NmrKfpZi168SI4jyFWAmHuB1N2Q8GZBcPk50i/ehk+hHl918NzqNYNF3
 lo0VYKPE8MgYPKm1QmC8rZ8LB5qSonsoXK7m33rmLR4k6o//r7osss1fO3X2m/ad4en5SsikQH
 KULvscJVKIVb+58RTjlwuXlq1ZaOPhMaO/OO2D17nJZbwNg6TMC6odm5pmmUQ63+XnYBMkLoNs
 1t4=
X-IronPort-AV: E=Sophos;i="5.79,358,1602572400"; 
   d="scan'208";a="29552957"
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by labrats.qualcomm.com with ESMTP; 19 Jan 2021 03:53:35 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 19 Jan 2021 03:53:35 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 7166B218E7; Tue, 19 Jan 2021 03:53:35 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH v10 3/3] scsi: ufs: Revert "Make sure clk scaling happens only when HBA is runtime ACTIVE"
Date:   Tue, 19 Jan 2021 03:53:01 -0800
Message-Id: <1611057183-6925-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1611057183-6925-1-git-send-email-cang@codeaurora.org>
References: <1611057183-6925-1-git-send-email-cang@codeaurora.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 73cc291c27024 ("Make sure clk scaling happens only when HBA is
runtime ACTIVE") is no longer needed since commit f7a42540928a8 ("scsi:
ufs: Protect some contexts from unexpected clock scaling") is a more
mature fix to protect UFS LLD stability from clock scaling invoked through
sysfs nodes by users.

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Can Guo <cang@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index df046bd..8ec41ea 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1355,15 +1355,8 @@ static int ufshcd_devfreq_target(struct device *dev,
 	}
 	spin_unlock_irqrestore(hba->host->host_lock, irq_flags);
 
-	pm_runtime_get_noresume(hba->dev);
-	if (!pm_runtime_active(hba->dev)) {
-		pm_runtime_put_noidle(hba->dev);
-		ret = -EAGAIN;
-		goto out;
-	}
 	start = ktime_get();
 	ret = ufshcd_devfreq_scale(hba, scale_up);
-	pm_runtime_put(hba->dev);
 
 	trace_ufshcd_profile_clk_scaling(dev_name(hba->dev),
 		(scale_up ? "up" : "down"),
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

