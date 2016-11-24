From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 11/11] scsi: ufs: fix default power mode to FAST/SLOW
Date: Wed, 23 Nov 2016 16:33:19 -0800
Message-ID: <1479947599-7337-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

We would by default like to run in FAST/SLOW mode instead
of FASTAUTO/SLOWAUTO mode for performance reasons. This
change sets the default speed mode to FAST/SLOW mode.

Reviewed-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 4b6cc07..0c75c75 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -2821,8 +2821,8 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 	if (hba->max_pwr_info.is_valid)
 		return 0;
 
-	pwr_info->pwr_tx = FASTAUTO_MODE;
-	pwr_info->pwr_rx = FASTAUTO_MODE;
+	pwr_info->pwr_tx = FAST_MODE;
+	pwr_info->pwr_rx = FAST_MODE;
 	pwr_info->hs_rate = PA_HS_MODE_B;
 
 	/* Get the connected lane count */
@@ -2853,7 +2853,7 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 				__func__, pwr_info->gear_rx);
 			return -EINVAL;
 		}
-		pwr_info->pwr_rx = SLOWAUTO_MODE;
+		pwr_info->pwr_rx = SLOW_MODE;
 	}
 
 	ufshcd_dme_peer_get(hba, UIC_ARG_MIB(PA_MAXRXHSGEAR),
@@ -2866,7 +2866,7 @@ static int ufshcd_get_max_pwr_mode(struct ufs_hba *hba)
 				__func__, pwr_info->gear_tx);
 			return -EINVAL;
 		}
-		pwr_info->pwr_tx = SLOWAUTO_MODE;
+		pwr_info->pwr_tx = SLOW_MODE;
 	}
 
 	hba->max_pwr_info.is_valid = true;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
