Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82C62C2BBCD
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 05:44:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 538A923A82
	for <linux-scsi@archiver.kernel.org>; Sun, 20 Dec 2020 05:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgLTFnq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 20 Dec 2020 00:43:46 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:23395 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726099AbgLTFnq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 20 Dec 2020 00:43:46 -0500
IronPort-SDR: RCN3T0Uid7HhfOQilNLdImPJtMoutoSW4oODCDaA5dqXhd0Tz4MrYGo7jkjVNMakN7bfiij6xk
 LbxmgqkqKOivwQUCiHtyIIN/QmInTYGuM9SuwLTww42V5WaGPOVW2/jtEkJ6ukbXnXOYC1KEDP
 EYbfDMIsu/WHPWmnpK8nEbyMIX4vyCzZdpVYKMSb2LxV2rxiTCo3RZERiR/7NtlkbxYLH3DK4v
 6B8jmu23ViY2FrcS+Kf6O4MjJT6HW7scwx+0Tl/yyEivgMFROS4Ij9Gsl8TqbmWZdmFxWNHEVy
 jDo=
X-IronPort-AV: E=Sophos;i="5.78,434,1599548400"; 
   d="scan'208";a="47599281"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 19 Dec 2020 21:43:06 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 19 Dec 2020 21:43:05 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 1FB79212A8; Sat, 19 Dec 2020 21:43:05 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: [PATCH v6 3/3] scsi: ufs: Revert "Make sure clk scaling happens only when HBA is runtime ACTIVE"
Date:   Sat, 19 Dec 2020 21:42:47 -0800
Message-Id: <1608442968-38560-4-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1608442968-38560-1-git-send-email-cang@codeaurora.org>
References: <1608442968-38560-1-git-send-email-cang@codeaurora.org>
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
index 2dee21e..7229a1b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1300,15 +1300,8 @@ static int ufshcd_devfreq_target(struct device *dev,
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

