From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 3/6] scsi: ufs: fix static checker errors in ufshcd_system_suspend
Date: Thu, 23 Oct 2014 13:25:14 +0300
Message-ID: <1414059917-13831-4-git-send-email-draviv@codeaurora.org>
References: <1414059917-13831-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:60789 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbaJWKZg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Oct 2014 06:25:36 -0400
In-Reply-To: <1414059917-13831-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>

This patch fixes newly introduced sparse warning in
ufshcd_system_suspend, introduced by UFS power management series.

Sparse warning:
drivers/scsi/ufs/ufshcd.c:5118 ufshcd_system_suspend()
error: we previously assumed 'hba' could be null (see line 5089)

To fix it, we return 0 in case HBA is not initialized or is
not powered.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 77a4e38..d3f6ddb 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5104,7 +5104,7 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	int ret = 0;
 
 	if (!hba || !hba->is_powered)
-		goto out;
+		return 0;
 
 	if (pm_runtime_suspended(hba->dev)) {
 		if (hba->rpm_lvl == hba->spm_lvl)
-- 
1.8.5.2
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project

