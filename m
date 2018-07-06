From: Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v1 6/9] scsi: ufs: optimize clock, pm_qos, hibern8 handling in queuecommand
Date: Fri,  6 Jul 2018 18:00:33 +0530
Message-ID: <a562f8607d412ff7ac474b50c5acaf0fe387a822.1530880006.git.asutoshd@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1530880006.git.asutoshd@codeaurora.org>
In-Reply-To: <cover.1530880006.git.asutoshd@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

ufshcd_queuecommand() vote for the resources in this order: clocks,
pm_qos latency, hibern8 exit. If any of these votes are not already
applied, each one has to be applied asynchronously and in that case we are
releasing all the previously applied resource votes (for example, if
hibern8 exit has to be completed asynchronously, we release the votes for
pm_qos and clocks as well). This is not a optimal solution instead we
should skip scheduling the unvoting work for already voted resources.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufs-qcom.c |  2 +-
 drivers/scsi/ufs/ufshcd.c   | 33 +++++++++++++++++----------------
 drivers/scsi/ufs/ufshcd.h   |  2 +-
 3 files changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-qcom.c b/drivers/scsi/ufs/ufs-qcom.c
index 221820a..fa01924 100644
--- a/drivers/scsi/ufs/ufs-qcom.c
+++ b/drivers/scsi/ufs/ufs-qcom.c
@@ -1605,7 +1605,7 @@ int ufs_qcom_testbus_config(struct ufs_qcom_host *host)
 	 * committed before returning.
 	 */
 	mb();
-	ufshcd_release(host->hba);
+	ufshcd_release(host->hba, false);
 	pm_runtime_put_sync(host->hba->dev);
 
 	return 0;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8a56ef6..40d9c35 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1175,7 +1175,7 @@ static int ufshcd_devfreq_scale(struct ufs_hba *hba, bool scale_up)
 
 out:
 	ufshcd_clock_scaling_unprepare(hba);
-	ufshcd_release(hba);
+	ufshcd_release_all(hba);
 	return ret;
 }
 
@@ -1447,7 +1447,7 @@ static ssize_t ufshcd_clkscale_enable_store(struct device *dev,
 					__func__, err);
 	}
 
-	ufshcd_release(hba);
+	ufshcd_release(hba, false);
 	pm_runtime_put_sync(hba->dev);
 out:
 	return count;
@@ -1662,7 +1662,7 @@ static void ufshcd_gate_work(struct work_struct *work)
 }
 
 /* host lock must be held before calling this variant */
-static void __ufshcd_release(struct ufs_hba *hba)
+static void __ufshcd_release(struct ufs_hba *hba, bool no_sched)
 {
 	if (!ufshcd_is_clkgating_allowed(hba))
 		return;
@@ -1673,7 +1673,7 @@ static void __ufshcd_release(struct ufs_hba *hba)
 		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
 		|| hba->lrb_in_use || hba->outstanding_tasks
 		|| hba->active_uic_cmd || hba->uic_async_done
-		|| ufshcd_eh_in_progress(hba))
+		|| ufshcd_eh_in_progress(hba) || no_sched)
 		return;
 
 	hba->clk_gating.state = REQ_CLKS_OFF;
@@ -1682,12 +1682,12 @@ static void __ufshcd_release(struct ufs_hba *hba)
 			msecs_to_jiffies(hba->clk_gating.delay_ms));
 }
 
-void ufshcd_release(struct ufs_hba *hba)
+void ufshcd_release(struct ufs_hba *hba, bool no_sched)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	__ufshcd_release(hba);
+	__ufshcd_release(hba, no_sched);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
 EXPORT_SYMBOL_GPL(ufshcd_release);
@@ -1738,7 +1738,7 @@ static ssize_t ufshcd_clkgate_enable_store(struct device *dev,
 		goto out;
 
 	if (value) {
-		ufshcd_release(hba);
+		ufshcd_release(hba, false);
 	} else {
 		spin_lock_irqsave(hba->host->host_lock, flags);
 		hba->clk_gating.active_reqs++;
@@ -1870,7 +1870,7 @@ int ufshcd_hibern8_hold(struct ufs_hba *hba, bool async)
 }
 
 /* host lock must be held before calling this variant */
-static void __ufshcd_hibern8_release(struct ufs_hba *hba)
+static void __ufshcd_hibern8_release(struct ufs_hba *hba, bool no_sched)
 {
 	unsigned long delay_in_jiffies;
 
@@ -1884,7 +1884,8 @@ static void __ufshcd_hibern8_release(struct ufs_hba *hba)
 		|| hba->hibern8_on_idle.is_suspended
 		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
 		|| hba->lrb_in_use || hba->outstanding_tasks
-		|| hba->active_uic_cmd || hba->uic_async_done)
+		|| hba->active_uic_cmd || hba->uic_async_done
+		|| ufshcd_eh_in_progress(hba) || no_sched)
 		return;
 
 	hba->hibern8_on_idle.state = REQ_HIBERN8_ENTER;
@@ -1907,12 +1908,12 @@ static void __ufshcd_hibern8_release(struct ufs_hba *hba)
 			      delay_in_jiffies);
 }
 
-void ufshcd_hibern8_release(struct ufs_hba *hba)
+void ufshcd_hibern8_release(struct ufs_hba *hba, bool no_sched)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(hba->host->host_lock, flags);
-	__ufshcd_hibern8_release(hba);
+	__ufshcd_hibern8_release(hba, no_sched);
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
 }
 
@@ -2034,8 +2035,8 @@ static void ufshcd_hold_all(struct ufs_hba *hba)
 
 static void ufshcd_release_all(struct ufs_hba *hba)
 {
-	ufshcd_hibern8_release(hba);
-	ufshcd_release(hba);
+	ufshcd_hibern8_release(hba, false);
+	ufshcd_release(hba, false);
 }
 
 /* Must be called with host lock acquired */
@@ -2681,7 +2682,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	if (err) {
 		clear_bit_unlock(tag, &hba->lrb_in_use);
 		err = SCSI_MLQUEUE_HOST_BUSY;
-		ufshcd_release(hba);
+		ufshcd_release(hba, true);
 		goto out;
 	}
 	if (ufshcd_is_hibern8_on_idle_allowed(hba))
@@ -5050,8 +5051,8 @@ static void __ufshcd_transfer_req_compl(struct ufs_hba *hba,
 			clear_bit_unlock(index, &hba->lrb_in_use);
 			/* Do not touch lrbp after scsi done */
 			cmd->scsi_done(cmd);
-			__ufshcd_release(hba);
-			__ufshcd_hibern8_release(hba);
+			__ufshcd_release(hba, false);
+			__ufshcd_hibern8_release(hba, false);
 		} else if (lrbp->command_type == UTP_CMD_TYPE_DEV_MANAGE ||
 			lrbp->command_type == UTP_CMD_TYPE_UFS_STORAGE) {
 			if (hba->dev_cmd.complete) {
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index eaccc76..f79a639 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -927,7 +927,7 @@ int ufshcd_read_string_desc(struct ufs_hba *hba, int desc_index,
 			    u8 *buf, u32 size, bool ascii);
 
 int ufshcd_hold(struct ufs_hba *hba, bool async);
-void ufshcd_release(struct ufs_hba *hba);
+void ufshcd_release(struct ufs_hba *hba, bool no_sched);
 
 int ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
 	int *desc_length);
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
