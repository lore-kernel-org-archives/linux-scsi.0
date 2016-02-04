From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [v3 12/14] scsi: ufs: fix leakage during link off state
Date: Thu,  4 Feb 2016 11:45:26 +0200
Message-ID: <1454579128-2682-13-git-send-email-ygardi@codeaurora.org>
References: <1454579128-2682-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454579128-2682-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Currently when we try to put the link in off/disabled state during
suspend, it seems link is not being kept in low power mode.
This patch fixes the issue by putting the link in hibern8 first
(so device also puts the link in low power mode) and then stop the
host controller.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3c550e2..f7a699c2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -5619,6 +5619,16 @@ static int ufshcd_link_state_transition(struct ufs_hba *hba,
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
