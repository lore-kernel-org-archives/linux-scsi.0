From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 11/11] scsi: ufs: optimize clock gate work
Date: Mon, 17 Oct 2016 17:11:07 -0700
Message-ID: <1476749468-11486-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: Venkat Gopalakrishnan <venkatg@codeaurora.org>, Subhash Jadavani <subhashj@codeaurora.org>, "open list:UNIVERSAL FLASH STORAGE HOST
        CONTROLLER DRIVER" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Venkat Gopalakrishnan <venkatg@codeaurora.org>

In a case where gate work is called as part of cancel work
from ungate path the clk state would be marked as REQ_CLKS_ON.
There is no point gating the clocks and then end up turning
them ON immediately in ungate work, save time by skipping the
gate work and change the clk state to CLKS_ON as they are not
turned off yet.

Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 7959793..8cf5d8f 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -739,7 +739,14 @@ static void ufshcd_gate_work(struct work_struct *work)
 	unsigned long flags;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	if (hba->clk_gating.is_suspended) {
+	/*
+	 * In case you are here to cancel this work the gating state
+	 * would be marked as REQ_CLKS_ON. In this case save time by
+	 * skipping the gating work and exit after changing the clock
+	 * state to CLKS_ON.
+	 */
+	if (hba->clk_gating.is_suspended ||
+		(hba->clk_gating.state == REQ_CLKS_ON)) {
 		hba->clk_gating.state = CLKS_ON;
 		goto rel_lock;
 	}
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
