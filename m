From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v8 13/17] scsi: ufs: fix leakage during link off state
Date: Thu, 10 Mar 2016 17:37:17 +0200
Message-ID: <1457624241-20525-14-git-send-email-ygardi@codeaurora.org>
References: <1457624241-20525-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1457624241-20525-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Subhash Jadavani <subhashj@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Currently when we try to put the link in off/disabled state during
suspend, it seems link is not being kept in low power mode.
This patch fixes the issue by putting the link in hibern8 first
(so device also puts the link in low power mode) and then stop the
host controller.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 305210f..93cc02f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5688,6 +5688,16 @@ static int ufshcd_link_state_transition(struct ufs_hba *hba,
 		   (!check_for_bkops || (check_for_bkops &&
 		    !hba->auto_bkops_enabled))) {
 		/*
+		 * Let's make sure that link is in low power mode, we are doing
+		 * this currently by putting the link in Hibern8. Otherway to
+		 * put the link in low power mode is to send the DME end point
+		 * to device and then send the DME reset command to local
+		 * unipro. But putting the link in hibern8 is much faster.
+		 */
+		ret = ufshcd_uic_hibern8_enter(hba);
+		if (ret)
+			goto out;
+		/*
 		 * Change controller state to "reset state" which
 		 * should also put the link in off/reset state
 		 */
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
