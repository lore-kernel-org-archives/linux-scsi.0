From: Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v2 06/10] scsi: ufs: add reference counting for scsi block requests
Date: Thu,  3 May 2018 16:37:18 +0530
Message-ID: <3d524952ffe2c0a14c92f5e322aed5d2c24c2832.1525343531.git.asutoshd@codeaurora.org>
References: <cover.1525341340.git.asutoshd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1525341340.git.asutoshd@codeaurora.org>
In-Reply-To: <cover.1525343531.git.asutoshd@codeaurora.org>
References: <cover.1525343531.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, linux-mmc@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
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
 drivers/scsi/ufs/ufshcd.c | 28 ++++++++++++++++++++--------
 drivers/scsi/ufs/ufshcd.h |  2 ++
 2 files changed, 22 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dfeb194..c35a076 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -264,6 +264,18 @@ static inline void ufshcd_disable_irq(struct ufs_hba *hba)
 	}
 }
 
+static void ufshcd_scsi_unblock_requests(struct ufs_hba *hba)
+{
+	if (atomic_dec_and_test(&hba->scsi_block_reqs_cnt))
+		scsi_unblock_requests(hba->host);
+}
+
+static void ufshcd_scsi_block_requests(struct ufs_hba *hba)
+{
+	if (atomic_inc_return(&hba->scsi_block_reqs_cnt) == 1)
+		scsi_block_requests(hba->host);
+}
+
 /* replace non-printable or non-ASCII characters with spaces */
 static inline void ufshcd_remove_non_printable(char *val)
 {
@@ -1077,12 +1089,12 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
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
@@ -1091,7 +1103,7 @@ static int ufshcd_clock_scaling_prepare(struct ufs_hba *hba)
 static void ufshcd_clock_scaling_unprepare(struct ufs_hba *hba)
 {
 	up_write(&hba->clk_scaling_lock);
-	scsi_unblock_requests(hba->host);
+	ufshcd_scsi_unblock_requests(hba);
 }
 
 /**
@@ -1411,7 +1423,7 @@ static void ufshcd_ungate_work(struct work_struct *work)
 		hba->clk_gating.is_suspended = false;
 	}
 unblock_reqs:
-	scsi_unblock_requests(hba->host);
+	ufshcd_scsi_unblock_requests(hba);
 }
 
 /**
@@ -1467,7 +1479,7 @@ int ufshcd_hold(struct ufs_hba *hba, bool async)
 		 * work and to enable clocks.
 		 */
 	case CLKS_OFF:
-		scsi_block_requests(hba->host);
+		ufshcd_scsi_block_requests(hba);
 		hba->clk_gating.state = REQ_CLKS_ON;
 		trace_ufshcd_clk_gating(dev_name(hba->dev),
 					hba->clk_gating.state);
@@ -5192,7 +5204,7 @@ static void ufshcd_err_handler(struct work_struct *work)
 
 out:
 	spin_unlock_irqrestore(hba->host->host_lock, flags);
-	scsi_unblock_requests(hba->host);
+	ufshcd_scsi_unblock_requests(hba);
 	ufshcd_release(hba);
 	pm_runtime_put_sync(hba->dev);
 }
@@ -5294,7 +5306,7 @@ static void ufshcd_check_errors(struct ufs_hba *hba)
 		/* handle fatal errors only when link is functional */
 		if (hba->ufshcd_state == UFSHCD_STATE_OPERATIONAL) {
 			/* block commands from scsi mid-layer */
-			scsi_block_requests(hba->host);
+			ufshcd_scsi_block_requests(hba);
 
 			hba->ufshcd_state = UFSHCD_STATE_EH_SCHEDULED;
 
@@ -8017,7 +8029,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 
 	/* Hold auto suspend until async scan completes */
 	pm_runtime_get_sync(dev);
-
+	atomic_set(&hba->scsi_block_reqs_cnt, 0);
 	/*
 	 * We are assuming that device wasn't put in sleep/power-down
 	 * state exclusively during the boot stage before kernel.
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 0417c42..76c31d5 100644
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
@@ -698,6 +699,7 @@ struct ufs_hba {
 
 	struct rw_semaphore clk_scaling_lock;
 	struct ufs_desc_size desc_size;
+	atomic_t scsi_block_reqs_cnt;
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
