From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 07/11] scsi: ufs: fail ufshcd_probe_hba() if power configuration fails
Date: Mon, 17 Oct 2016 17:10:14 -0700
Message-ID: <1476749414-11325-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Dov Levenglick <dovl@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Dov Levenglick <dovl@codeaurora.org>

In case the power configuration fails, skip further processing
of the  probing function and return immediately. This has 2 reasons:
1. Don't allow the UFS to continue running in PWM
2. Avoid multiple calls to pm_runtime_put_sync() when not
   in error handling or power management contexts

Signed-off-by: Dov Levenglick <dovl@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index c6fa3c0..fced52f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5051,9 +5051,11 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 			__func__);
 	} else {
 		ret = ufshcd_config_pwr_mode(hba, &hba->max_pwr_info.info);
-		if (ret)
+		if (ret) {
 			dev_err(hba->dev, "%s: Failed setting power mode, err = %d\n",
 					__func__, ret);
+			goto out;
+		}
 	}
 
 	/* set the state as operational after switching to desired gear */
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
