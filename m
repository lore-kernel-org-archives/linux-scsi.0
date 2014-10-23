From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH 4/6] scsi: ufs: fix static checker warning in ufshcd_populate_vreg
Date: Thu, 23 Oct 2014 13:25:15 +0300
Message-ID: <1414059917-13831-5-git-send-email-draviv@codeaurora.org>
References: <1414059917-13831-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1414059917-13831-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

This patch fixes newly introduced static checker warning in
ufshcd_populate_vreg, introduced by UFS power management series.

Warning:
drivers/scsi/ufs/ufshcd-pltfrm.c:167 ufshcd_populate_vreg()
warn: missing error code here? 'devm_kzalloc()' failed. 'ret' = '0'

To fix it we return -ENOMEM and skip the message print.

Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd-pltfrm.c b/drivers/scsi/ufs/ufshcd-pltfrm.c
index 8adf067..2cdec78 100644
--- a/drivers/scsi/ufs/ufshcd-pltfrm.c
+++ b/drivers/scsi/ufs/ufshcd-pltfrm.c
@@ -162,10 +162,8 @@ static int ufshcd_populate_vreg(struct device *dev, const char *name,
 	}
 
 	vreg = devm_kzalloc(dev, sizeof(*vreg), GFP_KERNEL);
-	if (!vreg) {
-		dev_err(dev, "No memory for %s regulator\n", name);
-		goto out;
-	}
+	if (!vreg)
+		return -ENOMEM;
 
 	vreg->name = kstrdup(name, GFP_KERNEL);
 
-- 
1.8.5.2
-- 
Qualcomm Israel, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project
