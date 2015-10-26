From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v2 03/17] scsi: ufs: optimize system suspend handling
Date: Mon, 26 Oct 2015 17:40:58 +0200
Message-ID: <1445874072-25909-4-git-send-email-ygardi@codeaurora.org>
References: <1445874072-25909-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445874072-25909-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Consider following sequence of events:
1. UFS is runtime suspended, link_state = Hibern8, device_state = sleep
2. System goes into system suspend, ufshcd_system_suspend() brings both
   link and device to active state and then puts the device in
   Power_Down state and link in OFF state.
3. System resumes at some later point in time, ufshcd_system_resume()
   doesn't do anything as UFS state is runtime suspended. Note that
   link is still on OFF state and device is in Power_Down state.
4. Now system again goes into suspend without any UFS accesses
   before it.
   ufshcd_system_suspend() again brings both link and device to active
   state and then puts the device in Power_Down state and link if OFF
   state. But it's unnecessary to bring the link & device in active
   state as both link and device are already in desired low power
   states. This change fixes this issue by adding proper state checks
   in ufshcd_system_suspend().

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 20c5b5d..00964f9 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5459,16 +5459,13 @@ int ufshcd_system_suspend(struct ufs_hba *hba)
 	if (!hba || !hba->is_powered)
 		return 0;
 
-	if (pm_runtime_suspended(hba->dev)) {
-		if (hba->rpm_lvl == hba->spm_lvl)
-			/*
-			 * There is possibility that device may still be in
-			 * active state during the runtime suspend.
-			 */
-			if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
-			    hba->curr_dev_pwr_mode) && !hba->auto_bkops_enabled)
-				goto out;
+	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
+	     hba->curr_dev_pwr_mode) &&
+	    (ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl) ==
+	     hba->uic_link_state))
+		goto out;
 
+	if (pm_runtime_suspended(hba->dev)) {
 		/*
 		 * UFS device and/or UFS link low power states during runtime
 		 * suspend seems to be different than what is expected during
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
