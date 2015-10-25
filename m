From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v4 13/15] scsi: ufs: add missing memory barriers
Date: Sun, 25 Oct 2015 16:56:22 +0200
Message-ID: <1445784984-16443-14-git-send-email-ygardi@codeaurora.org>
References: <1445784984-16443-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1445784984-16443-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Performing several writes to UFS host controller registers has
no gurrantee of ordering, so we must make sure register writes
to setup request list base address etc. are performed before the
run/stop register is enabled.
In addition, when setting up a task request, we must make sure
the updating of descriptors takes places before ringing the
doorbell, similarly to setting up a transfer request.

Signed-off-by: Gilad Broner <gbroner@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 24a879d..14bebc5 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -402,11 +402,9 @@ static inline int ufshcd_get_lists_status(u32 reg)
 	 *  1		UTRLRDY
 	 *  2		UTMRLRDY
 	 *  3		UCRDY
-	 *  4		HEI
-	 *  5		DEI
-	 * 6-7		reserved
+	 * 4-7		reserved
 	 */
-	return (((reg) & (0xFF)) >> 1) ^ (0x07);
+	return ((reg & 0xFF) >> 1) ^ 0x07;
 }
 
 /**
@@ -2727,7 +2725,7 @@ out:
  * To bring UFS host controller to operational state,
  * 1. Enable required interrupts
  * 2. Configure interrupt aggregation
- * 3. Program UTRL and UTMRL base addres
+ * 3. Program UTRL and UTMRL base address
  * 4. Configure run-stop-registers
  *
  * Returns 0 on success, non-zero value on failure
@@ -2757,8 +2755,13 @@ static int ufshcd_make_hba_operational(struct ufs_hba *hba)
 			REG_UTP_TASK_REQ_LIST_BASE_H);
 
 	/*
+	 * Make sure base address and interrupt setup are updated before
+	 * enabling the run/stop registers below.
+	 */
+	wmb();
+
+	/*
 	 * UCRDY, UTMRLDY and UTRLRDY bits must be 1
-	 * DEI, HEI bits must be 0
 	 */
 	reg = ufshcd_readl(hba, REG_CONTROLLER_STATUS);
 	if (!(ufshcd_get_lists_status(reg))) {
@@ -3921,7 +3924,13 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 
 	/* send command to the controller */
 	__set_bit(free_slot, &hba->outstanding_tasks);
+
+	/* Make sure descriptors are ready before ringing the task doorbell */
+	wmb();
+
 	ufshcd_writel(hba, 1 << free_slot, REG_UTP_TASK_REQ_DOOR_BELL);
+	/* Make sure that doorbell is committed immediately */
+	wmb();
 
 	spin_unlock_irqrestore(host->host_lock, flags);
 
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
