From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 5/6] scsi: ufs: fix static checker warning in __ufshcd_setup_clocks
Date: Thu, 23 Oct 2014 13:25:16 +0300
Message-ID: <1414059917-13831-6-git-send-email-draviv@codeaurora.org>
References: <1414059917-13831-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:60815 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753674AbaJWKZk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2014 06:25:40 -0400
In-Reply-To: <1414059917-13831-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>

This patch fixes newly introduced static checker warning in
__ufshcd_setup_clocks, introduced by UFS power management series.

Warning:
drivers/scsi/ufs/ufshcd.c:4474 __ufshcd_setup_clocks()
warn: we tested 'ret' before and it was 'false'

To fix it we remove the (!ret) from the condition.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index d3f6ddb..b9da446 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4473,7 +4473,7 @@ out:
 			if (!IS_ERR_OR_NULL(clki->clk) && clki->enabled)
 				clk_disable_unprepare(clki->clk);
 		}
-	} else if (!ret && on) {
+	} else if (on) {
 		spin_lock_irqsave(hba->host->host_lock, flags);
 		hba->clk_gating.state = CLKS_ON;
 		spin_unlock_irqrestore(hba->host->host_lock, flags);
-- 
1.8.5.2
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project

