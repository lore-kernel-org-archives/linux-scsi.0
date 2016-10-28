From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 4/4] scsi: ufs: change device rails hpm mode ramp up sequence
Date: Thu, 27 Oct 2016 17:26:24 -0700
Message-ID: <1477614384-5526-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

When we are resuming the UFS device rails in HPM mode, we are first
powering on the VCC rail while VCCQ and VCCQ2 rails still being in LPM
mode. Some UFS devices may take VCC on event as hint that host wants
UFS device to be resumed and may start drawing more power from the
VCCQ/VCCQ2 rails (while they are still in LPM mode) causing voltage drop
on these rails. This change fixes this issue by bringing VCCQ & VCCQ2 rails
out of LPM before powering on VCC rail.

Reviewed-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 9ed96ae..8cf5d8f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5819,7 +5819,6 @@ static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)
 	    !hba->dev_info.is_lu_power_on_wp) {
 		ret = ufshcd_setup_vreg(hba, true);
 	} else if (!ufshcd_is_ufs_dev_active(hba)) {
-		ret = ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, true);
 		if (!ret && !ufshcd_is_link_active(hba)) {
 			ret = ufshcd_config_vreg_hpm(hba, hba->vreg_info.vccq);
 			if (ret)
@@ -5828,6 +5827,7 @@ static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)
 			if (ret)
 				goto vccq_lpm;
 		}
+		ret = ufshcd_toggle_vreg(hba->dev, hba->vreg_info.vcc, true);
 	}
 	goto out;
 
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
