From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v7 11/14] scsi: ufs: reduce the interrupts for power mode change requests
Date: Mon,  1 Feb 2016 15:02:47 +0200
Message-ID: <1454331770-29642-12-git-send-email-ygardi@codeaurora.org>
References: <1454331770-29642-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1454331770-29642-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

DME commands such as Hibern8 enter/exit and gear switch generate 2
completion interrupts, one for confirmation that command is received
by local UniPro and 2nd one is the final confirmation after communication
with remote UniPro. Currently both of these completions are registered
as interrupt events which is not quite necessary and instead we can
just wait for the interrupt of 2nd completion, this should reduce
the number of interrupts and could reduce the unnecessary CPU wakeups
to handle extra interrupts.

Reviewed-by: Gilad Broner <gbroner@codeaurora.org>
Reviewed-by: Dolev Raviv <draviv@codeaurora.org>
Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 41 +++++++++++++++++++++++++++--------------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 87da429..a1e9d82 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -985,13 +985,15 @@ ufshcd_wait_for_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
  * __ufshcd_send_uic_cmd - Send UIC commands and retrieve the result
  * @hba: per adapter instance
  * @uic_cmd: UIC command
+ * @completion: initialize the completion only if this is set to true
  *
  * Identical to ufshcd_send_uic_cmd() expect mutex. Must be called
  * with mutex held and host_lock locked.
  * Returns 0 only if success.
  */
 static int
-__ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
+__ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd,
+		      bool completion)
 {
 	if (!ufshcd_ready_for_uic_cmd(hba)) {
 		dev_err(hba->dev,
@@ -999,7 +1001,8 @@ __ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 		return -EIO;
 	}
 
-	init_completion(&uic_cmd->done);
+	if (completion)
+		init_completion(&uic_cmd->done);
 
 	ufshcd_dispatch_uic_cmd(hba, uic_cmd);
 
@@ -1024,7 +1027,7 @@ ufshcd_send_uic_cmd(struct ufs_hba *hba, struct uic_command *uic_cmd)
 	ufshcd_add_delay_before_dme_cmd(hba);
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ret = __ufshcd_send_uic_cmd(hba, uic_cmd);
+	ret = __ufshcd_send_uic_cmd(hba, uic_cmd, true);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	if (!ret)
 		ret = ufshcd_wait_for_uic_cmd(hba, uic_cmd);
@@ -2344,6 +2347,7 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	unsigned long flags;
 	u8 status;
 	int ret;
+	bool reenable_intr = false;
 
 	mutex_lock(&hba->uic_cmd_mutex);
 	init_completion(&uic_async_done);
@@ -2351,15 +2355,17 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
 	hba->uic_async_done = &uic_async_done;
-	ret = __ufshcd_send_uic_cmd(hba, cmd);
-	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	if (ret) {
-		dev_err(hba->dev,
-			"pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
-			cmd->command, cmd->argument3, ret);
-		goto out;
+	if (ufshcd_readl(hba, REG_INTERRUPT_ENABLE) & UIC_COMMAND_COMPL) {
+		ufshcd_disable_intr(hba, UIC_COMMAND_COMPL);
+		/*
+		 * Make sure UIC command completion interrupt is disabled before
+		 * issuing UIC command.
+		 */
+		wmb();
+		reenable_intr = true;
 	}
-	ret = ufshcd_wait_for_uic_cmd(hba, cmd);
+	ret = __ufshcd_send_uic_cmd(hba, cmd, false);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	if (ret) {
 		dev_err(hba->dev,
 			"pwr ctrl cmd 0x%x with mode 0x%x uic error %d\n",
@@ -2385,7 +2391,10 @@ static int ufshcd_uic_pwr_ctrl(struct ufs_hba *hba, struct uic_command *cmd)
 	}
 out:
 	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->active_uic_cmd = NULL;
 	hba->uic_async_done = NULL;
+	if (reenable_intr)
+		ufshcd_enable_intr(hba, UIC_COMMAND_COMPL);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 	mutex_unlock(&hba->uic_cmd_mutex);
 
@@ -3810,16 +3819,20 @@ static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
  */
 static irqreturn_t ufshcd_intr(int irq, void *__hba)
 {
-	u32 intr_status;
+	u32 intr_status, enabled_intr_status;
 	irqreturn_t retval = IRQ_NONE;
 	struct ufs_hba *hba = __hba;
 
 	spin_lock(hba->host->host_lock);
 	intr_status = ufshcd_readl(hba, REG_INTERRUPT_STATUS);
+	enabled_intr_status =
+		intr_status & ufshcd_readl(hba, REG_INTERRUPT_ENABLE);
 
-	if (intr_status) {
+	if (intr_status)
 		ufshcd_writel(hba, intr_status, REG_INTERRUPT_STATUS);
-		ufshcd_sl_intr(hba, intr_status);
+
+	if (enabled_intr_status) {
+		ufshcd_sl_intr(hba, enabled_intr_status);
 		retval = IRQ_HANDLED;
 	}
 	spin_unlock(hba->host->host_lock);
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
