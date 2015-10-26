From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v2 06/17] scsi :ufs: verify hba controller hce reg value
Date: Mon, 26 Oct 2015 17:41:01 +0200
Message-ID: <1445874072-25909-7-git-send-email-ygardi@codeaurora.org>
References: <1445874072-25909-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445874072-25909-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: robherring2@gmail.com, James.Bottomley@HansenPartnership.com, pebolle@tiscali.nl, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, subhashj@codeaurora.org, ygardi@codeaurora.org, gbroner@codeaurora.org, draviv@codeaurora.org, Raviv Shvili <rshvili@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>
List-Id: linux-scsi@vger.kernel.org

Sometimes due to hw issues it takes some time to the
host controller register to update. In order to verify the register
has updated, a polling is done until its value is set.

In addition the functions ufshcd_hba_stop() and
ufshcd_wait_for_register() was updated with an additional input
parameter, indicating the timeout between reads will
be done by sleeping or spinning the cpu.

Signed-off-by: Raviv Shvili <rshvili@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 53 ++++++++++++++++++++++++++++-------------------
 drivers/scsi/ufs/ufshcd.h | 12 +++--------
 2 files changed, 35 insertions(+), 30 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3aea64b..e8e7530 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -266,11 +266,13 @@ static inline void ufshcd_disable_irq(struct ufs_hba *hba)
  * @val - wait condition
  * @interval_us - polling interval in microsecs
  * @timeout_ms - timeout in millisecs
+ * @can_sleep - perform sleep or just spin
  *
  * Returns -ETIMEDOUT on error, zero on success
  */
-static int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
-		u32 val, unsigned long interval_us, unsigned long timeout_ms)
+int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
+				u32 val, unsigned long interval_us,
+				unsigned long timeout_ms, bool can_sleep)
 {
 	int err = 0;
 	unsigned long timeout = jiffies + msecs_to_jiffies(timeout_ms);
@@ -279,9 +281,10 @@ static int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
 	val = val & mask;
 
 	while ((ufshcd_readl(hba, reg) & mask) != val) {
-		/* wakeup within 50us of expiry */
-		usleep_range(interval_us, interval_us + 50);
-
+		if (can_sleep)
+			usleep_range(interval_us, interval_us + 50);
+		else
+			udelay(interval_us);
 		if (time_after(jiffies, timeout)) {
 			if ((ufshcd_readl(hba, reg) & mask) != val)
 				err = -ETIMEDOUT;
@@ -1486,7 +1489,7 @@ ufshcd_clear_cmd(struct ufs_hba *hba, int tag)
 	 */
 	err = ufshcd_wait_for_register(hba,
 			REG_UTP_TRANSFER_REQ_DOOR_BELL,
-			mask, ~mask, 1000, 1000);
+			mask, ~mask, 1000, 1000, true);
 
 	return err;
 }
@@ -2842,6 +2845,23 @@ out:
 }
 
 /**
+ * ufshcd_hba_stop - Send controller to reset state
+ * @hba: per adapter instance
+ * @can_sleep: perform sleep or just spin
+ */
+static inline void ufshcd_hba_stop(struct ufs_hba *hba, bool can_sleep)
+{
+	int err;
+
+	ufshcd_writel(hba, CONTROLLER_DISABLE,  REG_CONTROLLER_ENABLE);
+	err = ufshcd_wait_for_register(hba, REG_CONTROLLER_ENABLE,
+					CONTROLLER_ENABLE, CONTROLLER_DISABLE,
+					10, 1, can_sleep);
+	if (err)
+		dev_err(hba->dev, "%s: Controller disable failed\n", __func__);
+}
+
+/**
  * ufshcd_hba_enable - initialize the controller
  * @hba: per adapter instance
  *
@@ -2861,18 +2881,9 @@ static int ufshcd_hba_enable(struct ufs_hba *hba)
 	 * development and testing of this driver. msleep can be changed to
 	 * mdelay and retry count can be reduced based on the controller.
 	 */
-	if (!ufshcd_is_hba_active(hba)) {
-
+	if (!ufshcd_is_hba_active(hba))
 		/* change controller state to "reset state" */
-		ufshcd_hba_stop(hba);
-
-		/*
-		 * This delay is based on the testing done with UFS host
-		 * controller FPGA. The delay can be changed based on the
-		 * host controller used.
-		 */
-		msleep(5);
-	}
+		ufshcd_hba_stop(hba, true);
 
 	/* UniPro link is disabled at this point */
 	ufshcd_set_link_off(hba);
@@ -3925,7 +3936,7 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
 	/* poll for max. 1 sec to clear door bell register by h/w */
 	err = ufshcd_wait_for_register(hba,
 			REG_UTP_TASK_REQ_DOOR_BELL,
-			mask, 0, 1000, 1000);
+			mask, 0, 1000, 1000, true);
 out:
 	return err;
 }
@@ -4209,7 +4220,7 @@ static int ufshcd_host_reset_and_restore(struct ufs_hba *hba)
 
 	/* Reset the host controller */
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	ufshcd_hba_stop(hba);
+	ufshcd_hba_stop(hba, false);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 
 	err = ufshcd_hba_enable(hba);
@@ -5163,7 +5174,7 @@ static int ufshcd_link_state_transition(struct ufs_hba *hba,
 		 * Change controller state to "reset state" which
 		 * should also put the link in off/reset state
 		 */
-		ufshcd_hba_stop(hba);
+		ufshcd_hba_stop(hba, true);
 		/*
 		 * TODO: Check if we need any delay to make sure that
 		 * controller is reset
@@ -5636,7 +5647,7 @@ void ufshcd_remove(struct ufs_hba *hba)
 	scsi_remove_host(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
-	ufshcd_hba_stop(hba);
+	ufshcd_hba_stop(hba, true);
 
 	scsi_host_put(hba->host);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 889335a..55a38a4 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -590,15 +590,9 @@ int ufshcd_alloc_host(struct device *, struct ufs_hba **);
 void ufshcd_dealloc_host(struct ufs_hba *);
 int ufshcd_init(struct ufs_hba * , void __iomem * , unsigned int);
 void ufshcd_remove(struct ufs_hba *);
-
-/**
- * ufshcd_hba_stop - Send controller to reset state
- * @hba: per adapter instance
- */
-static inline void ufshcd_hba_stop(struct ufs_hba *hba)
-{
-	ufshcd_writel(hba, CONTROLLER_DISABLE,  REG_CONTROLLER_ENABLE);
-}
+int ufshcd_wait_for_register(struct ufs_hba *hba, u32 reg, u32 mask,
+				u32 val, unsigned long interval_us,
+				unsigned long timeout_ms, bool can_sleep);
 
 static inline void check_upiu_size(void)
 {
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
