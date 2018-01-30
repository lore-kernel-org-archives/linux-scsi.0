From: Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH 1/1] scsi: ufs: add reference counting for scsi block requests
Date: Tue, 30 Jan 2018 09:48:08 +0530
Message-ID: <1517285888-29433-1-git-send-email-asutoshd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

Currently we call the scsi_block_requests()/scsi_unblock_requests()
whenever we want to block/unblock scsi requests but as there is no
reference counting, nesting of these calls could leave us in undesired
state sometime. Consider following call flow sequence:
1. func1() calls scsi_block_requests() but calls func2() before
   calling scsi_unblock_requests()
2. func2() calls scsi_block_requests()
3. func2() calls scsi_unblock_requests()
4. func1() calls scsi_unblock_requests()

As there is no reference counting, we will have scsi requests unblocked
after #3 instead of it to be unblocked only after #4. Though we may not
have failures seen with this, we might run into some failures in future.
Better solution would be to fix this by adding reference counting.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c | 44 +++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.h |  5 +++++
 2 files changed, 42 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 8af2af3..a9ebc8d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -264,6 +264,36 @@ static inline void ufshcd_disable_irq(struct ufs_hba *hba)
 	}
 }
 
+void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)
+{
+	unsigned long flags;
+	bool unblock = false;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	hba->scsi_block_reqs_cnt--;
+	unblock = !hba->scsi_block_reqs_cnt;
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+	if (unblock)
+		scsi_unblock_requests(hba->host);
+}
+EXPORT_SYMBOL(ufshcd_scsi_unblock_requests);
+
+static inline void __ufshcd_scsi_block_requests(struct ufs_hba *hba)
+{
+	if (!hba->scsi_block_reqs_cnt++)
+		scsi_block_requests(hba->host);
+}
+
+void ufshcd_scsi_block_requests(struct ufs_hba *hba)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(hba->host->host_lock, flags);
+	__ufshcd_scsi_block_requests(hba);
+	spin_unlock_irqrestore(hba->host->host_lock, flags);
+}
+EXPORT_SYMBOL(ufshcd_scsi_block_requests);
+
 /* replace non-printable or non-ASCII characters with spaces */
 static inline void ufshcd_remove_non_printable(char *val)
 {
@@ -1079,12 +1109,12 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 	 * make sure that there are no outstanding requests when
 	 * clock scaling is in progress
 	 */
-	scsi_block_requests(hba->host);
+	ufshcd_scsi_block_requests(hba);
 	down_write(&hba->clk_scaling_lock);
 	if (ufshcd_wait_for_doorbell_clr(hba, DOORBELL_CLR_TOUT_US)) {
 		ret = -EBUSY;
 		up_write(&hba->clk_scaling_lock);
-		scsi_unblock_requests(hba->host);
+		ufshcd_scsi_unblock_requests(hba);
 	}
 
 	return ret;
@@ -1093,7 +1123,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
 {
 	up_write(&hba->clk_scaling_lock);
-	scsi_unblock_requests(hba->host);
+	ufshcd_scsi_unblock_requests(hba);
 }
 
 /**
@@ -1413,7 +1443,7 @@ static void ufshcd_ungate_work(struct work_struct *work)
 		hba->clk_gating.is_suspended = false;
 	}
 unblock_reqs:
-	scsi_unblock_requests(hba->host);
+	ufshcd_scsi_unblock_requests(hba);
 }
 
 /**
@@ -1469,7 +1499,7 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		 * work and to enable clocks.
 		 */
 	case CLKS_OFF:
-		scsi_block_requests(hba->host);
+		__ufshcd_scsi_block_requests(hba);
 		hba->clk_gating.state = REQ_CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
 					hba->clk_gating.state);
@@ -5178,7 +5208,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 out:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	scsi_unblock_requests(hba->host);
+	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 	pm_runtime_put_sync(hba->dev);
 }
@@ -5280,7 +5310,7 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 		/* handle fatal errors only when link is functional */
 		if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
 			/* block commands from scsi mid-layer */
-			scsi_block_requests(hba->host);
+			__ufshcd_scsi_block_requests(hba);
 
 			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED;
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 1332e54..84f4175 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -498,6 +498,7 @@ struct ufs_stats {
  * @urgent_bkops_lvl: keeps track of urgent bkops level for device
  * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
  *  device is known or not.
+ * @scsi_block_reqs_cnt: reference counting for scsi block requests
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -679,6 +680,7 @@ struct ufs_hba {
 
 	struct rw_semaphore clk_scaling_lock;
 	struct ufs_desc_size desc_size;
+	int scsi_block_reqs_cnt;
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
@@ -851,6 +853,9 @@ int ufshcd_map_desc_id_to_length(struct ufs_hba *hba, enum desc_idn desc_id,
 
 u32 ufshcd_get_local_unipro_ver(struct ufs_hba *hba);
 
+void ufshcd_scsi_block_requests(struct ufs_hba *hba);
+void ufshcd_scsi_unblock_requests(struct ufs_hba *hba);
+
 /* Wrapper functions for safely calling variant operations */
 static inline const char *ufshcd_get_var_name(struct ufs_hba *hba)
 {
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
