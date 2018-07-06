From: Asutosh Das <asutoshd@codeaurora.org>
Subject: [PATCH v1 7/9] scsi: ufs: add UFS power collapse support during hibern8
Date: Fri,  6 Jul 2018 18:00:34 +0530
Message-ID: <13f4fbc290b5e3cfea95f49d65ddb2bf99a15cdb.1530880007.git.asutoshd@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1530880006.git.asutoshd@codeaurora.org>
In-Reply-To: <cover.1530880006.git.asutoshd@codeaurora.org>
References: <cover.1530880006.git.asutoshd@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, rnayak@codeaurora.org, vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: linux-arm-msm@vger.kernel.org, Venkat Gopalakrishnan <venkatg@codeaurora.org>, Asutosh Das <asutoshd@codeaurora.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

UFS host controller hardware may allow the host controller
to be power collapsed when UFS link is hibern8 state, this
change allows the UFS host controller to be power collapsed
during hibern8.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Venkat Gopalakrishnan <venkatg@codeaurora.org>
Signed-off-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Asutosh Das <asutoshd@codeaurora.org>
---
 drivers/scsi/ufs/ufshcd.c |  8 ++++++--
 drivers/scsi/ufs/ufshcd.h | 13 ++++++++++++-
 2 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 40d9c35..50588cf 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7673,13 +7673,17 @@ static int ufshcd_vreg_set_hpm(struct ufs_hba *hba)
 
 static void ufshcd_hba_vreg_set_lpm(struct ufs_hba *hba)
 {
-	if (ufshcd_is_link_off(hba))
+	if (ufshcd_is_link_off(hba) ||
+	    (ufshcd_is_link_hibern8(hba)
+	     && ufshcd_is_power_collapse_during_hibern8_allowed(hba)))
 		ufshcd_setup_hba_vreg(hba, false);
 }
 
 static void ufshcd_hba_vreg_set_hpm(struct ufs_hba *hba)
 {
-	if (ufshcd_is_link_off(hba))
+	if (ufshcd_is_link_off(hba) ||
+	    (ufshcd_is_link_hibern8(hba)
+	     && ufshcd_is_power_collapse_during_hibern8_allowed(hba)))
 		ufshcd_setup_hba_vreg(hba, true);
 }
 
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index f79a639..8c5f987 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -728,7 +728,12 @@ struct ufs_hba {
 	 * to do background operation when it's active but it might degrade
 	 * the performance of ongoing read/write operations.
 	 */
-#define UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND (1 << 5)
+#define UFSHCD_CAP_KEEP_AUTO_BKOPS_ENABLED_EXCEPT_SUSPEND (1 << 6)
+	/*
+	 * If host controller hardware can be power collapsed when UFS link is
+	 * in hibern8 then enable this cap.
+	 */
+#define UFSHCD_CAP_POWER_COLLAPSE_DURING_HIBERN8 (1 << 7)
 
 	struct devfreq *devfreq;
 	struct ufs_clk_scaling clk_scaling;
@@ -764,6 +769,12 @@ static inline bool ufshcd_is_hibern8_on_idle_allowed(struct ufs_hba *hba)
 	return hba->caps & UFSHCD_CAP_HIBERN8_ENTER_ON_IDLE;
 }
 
+static inline bool ufshcd_is_power_collapse_during_hibern8_allowed(
+						struct ufs_hba *hba)
+{
+	return !!(hba->caps & UFSHCD_CAP_POWER_COLLAPSE_DURING_HIBERN8);
+}
+
 static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
 {
 /* DWC UFS Core has the Interrupt aggregation feature but is not detectable*/
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc. 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.
