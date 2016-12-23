From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v3 09/12] scsi: ufs: fix setting init power mode
Date: Thu, 22 Dec 2016 18:41:33 -0800
Message-ID: <1482460893-6289-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Immediately after successful UFS link startup, UFS link power mode would
be in PWM-G1, 1-lane, SLOW-AUTO mode. But currently we are doing few
of the DME local/peer attributes access before setting the "hba->pwr_info"
to default power mode. If we are doing link startup as part of error
recovery then old power mode might be set to FAST mode and doing DME peer
access (after link startup but before updating "hba->pwr_info" to default
power mode) unintentionally tries to switch from FAST to FAST_AUTO mode (if
UFSHCD_QUIRK_DME_PEER_ACCESS_AUTO_MODE quirk is enabled).

Above issue is fixed by setting the default power mode immediately after
successful link startup.

Reviewed-by: Sahitya Tummala <stummala@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a647bcf..2d3ca18 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3512,6 +3512,10 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 		goto link_startup;
 	}
 
+	/* Mark that link is up in PWM-G1, 1-lane, SLOW-AUTO mode */
+	ufshcd_init_pwr_info(hba);
+	ufshcd_print_pwr_info(hba);
+
 	if (hba->quirks & UFSHCD_QUIRK_BROKEN_LCC) {
 		ret = ufshcd_disable_device_tx_lcc(hba);
 		if (ret)
@@ -5547,9 +5551,6 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 	if (ret)
 		goto out;
 
-	ufshcd_init_pwr_info(hba);
-	ufshcd_print_pwr_info(hba);
-
 	/* set the default level for urgent bkops */
 	hba->urgent_bkops_lvl = BKOPS_STATUS_PERF_IMPACT;
 	hba->is_urgent_bkops_lvl_checked = false;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
