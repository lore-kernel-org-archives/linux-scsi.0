From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v5 11/15] scsi: ufs: handle non spec compliant bkops behaviour by device
Date: Sun, 28 Feb 2016 15:32:43 +0200
Message-ID: <1456666367-11418-12-git-send-email-ygardi@codeaurora.org>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Subhash Jadavani <subhashj@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

We are seeing that some devices are raising the urgent bkops exception
events even when BKOPS status doesn't indicate performace impacted or
critical. Handle these device by determining their urgent bkops status
at runtime.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufshcd.c | 53 ++++++++++++++++++++++++++++++++++++++++-------
 drivers/scsi/ufs/ufshcd.h |  6 ++++++
 2 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 394054e..d28c629 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3763,7 +3763,7 @@ out:
  */
 static int ufshcd_urgent_bkops(struct ufs_hba *hba)
 {
-	return ufshcd_bkops_ctrl(hba, BKOPS_STATUS_PERF_IMPACT);
+	return ufshcd_bkops_ctrl(hba, hba->urgent_bkops_lvl);
 }
 
 static inline int ufshcd_get_ee_status(struct ufs_hba *hba, u32 *status)
@@ -3772,6 +3772,43 @@ static inline int ufshcd_get_ee_status(struct ufs_hba *hba, u32 *status)
 			QUERY_ATTR_IDN_EE_STATUS, 0, 0, status);
 }
 
+static void ufshcd_bkops_exception_event_handler(struct ufs_hba *hba)
+{
+	int err;
+	u32 curr_status = 0;
+
+	if (hba->is_urgent_bkops_lvl_checked)
+		goto enable_auto_bkops;
+
+	err = ufshcd_get_bkops_status(hba, &curr_status);
+	if (err) {
+		dev_err(hba->dev, "%s: failed to get BKOPS status %d\n",
+				__func__, err);
+		goto out;
+	}
+
+	/*
+	 * We are seeing that some devices are raising the urgent bkops
+	 * exception events even when BKOPS status doesn't indicate performace
+	 * impacted or critical. Handle these device by determining their urgent
+	 * bkops status at runtime.
+	 */
+	if (curr_status < BKOPS_STATUS_PERF_IMPACT) {
+		dev_err(hba->dev, "%s: device raised urgent BKOPS exception for bkops status %d\n",
+				__func__, curr_status);
+		/* update the current status as the urgent bkops level */
+		hba->urgent_bkops_lvl = curr_status;
+		hba->is_urgent_bkops_lvl_checked = true;
+	}
+
+enable_auto_bkops:
+	err = ufshcd_enable_auto_bkops(hba);
+out:
+	if (err < 0)
+		dev_err(hba->dev, "%s: failed to handle urgent bkops %d\n",
+				__func__, err);
+}
+
 /**
  * ufshcd_exception_event_handler - handle exceptions raised by device
  * @work: pointer to work data
@@ -3795,12 +3832,10 @@ static void ufshcd_exception_event_handler(struct work_struct *work)
 	}
 
 	status &= hba->ee_ctrl_mask;
-	if (status & MASK_EE_URGENT_BKOPS) {
-		err = ufshcd_urgent_bkops(hba);
-		if (err < 0)
-			dev_err(hba->dev, "%s: failed to handle urgent bkops %d\n",
-					__func__, err);
-	}
+
+	if (status & MASK_EE_URGENT_BKOPS)
+		ufshcd_bkops_exception_event_handler(hba);
+
 out:
 	pm_runtime_put_sync(hba->dev);
 	return;
@@ -4763,6 +4798,10 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 
 	ufshcd_init_pwr_info(hba);
 
+	/* set the default level for urgent bkops */
+	hba->urgent_bkops_lvl = BKOPS_STATUS_PERF_IMPACT;
+	hba->is_urgent_bkops_lvl_checked = false;
+
 	/* UniPro link is active now */
 	ufshcd_set_link_active(hba);
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 77e79c0..65f29aa 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -383,6 +383,9 @@ struct ufs_init_prefetch {
  * @clk_list_head: UFS host controller clocks list node head
  * @pwr_info: holds current power mode
  * @max_pwr_info: keeps the device max valid pwm
+ * @urgent_bkops_lvl: keeps track of urgent bkops level for device
+ * @is_urgent_bkops_lvl_checked: keeps track if the urgent bkops level for
+ *  device is known or not.
  */
 struct ufs_hba {
 	void __iomem *mmio_base;
@@ -538,6 +541,9 @@ struct ufs_hba {
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
 	bool is_sys_suspended;
+
+	enum bkops_status urgent_bkops_lvl;
+	bool is_urgent_bkops_lvl_checked;
 };
 
 /* Returns true if clocks can be gated. Otherwise false */
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
