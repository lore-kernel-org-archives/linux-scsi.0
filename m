From: Yaniv Gardi <ygardi@codeaurora.org>
Subject: [PATCH v5 07/15] scsi: ufs: disable vccq if it's not needed by UFS device
Date: Sun, 28 Feb 2016 15:32:39 +0200
Message-ID: <1456666367-11418-8-git-send-email-ygardi@codeaurora.org>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, ygardi@codeaurora.org, Subhash Jadavani <subhashj@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <JBottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

Some UFS devices don't require VCCQ rail for device operations hence
this change adds support to recognize such devices and remove vote for
the unused VCCQ rail.

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Yaniv Gardi <ygardi@codeaurora.org>

---
 drivers/scsi/ufs/ufs.h    |  1 +
 drivers/scsi/ufs/ufshcd.c | 60 +++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 57 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 8ec6356..b291fa6 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -501,6 +501,7 @@ struct ufs_vreg {
 	struct regulator *reg;
 	const char *name;
 	bool enabled;
+	bool unused;
 	int min_uV;
 	int max_uV;
 	int min_uA;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 91a341b..987cf27 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -195,6 +195,7 @@ static int ufshcd_probe_hba(struct ufs_hba *hba);
 static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 				 bool skip_ref_clk);
 static int ufshcd_setup_clocks(struct ufs_hba *hba, bool on);
+static int ufshcd_set_vccq_rail_unused(struct ufs_hba *hba, bool unused);
 static int ufshcd_uic_hibern8_exit(struct ufs_hba *hba);
 static int ufshcd_uic_hibern8_enter(struct ufs_hba *hba);
 static inline void ufshcd_add_delay_before_dme_cmd(struct ufs_hba *hba);
@@ -4593,6 +4594,12 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		goto out;
 
 	ufs_advertise_fixup_device(hba);
+
+	ret = ufshcd_set_vccq_rail_unused(hba,
+		(hba->dev_quirks & UFS_DEVICE_NO_VCCQ) ? true : false);
+	if (ret)
+		goto out;
+
 	/* UFS device is also active now */
 	ufshcd_set_ufs_dev_active(hba);
 	ufshcd_force_reset_auto_bkops(hba);
@@ -4743,13 +4750,24 @@ static int ufshcd_config_vreg_load(struct device *dev, struct ufs_vreg *vreg,
 static inline int ufshcd_config_vreg_lpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
-	return ufshcd_config_vreg_load(hba->dev, vreg, UFS_VREG_LPM_LOAD_UA);
+	if (!vreg)
+		return 0;
+	else if (vreg->unused)
+		return 0;
+	else
+		return ufshcd_config_vreg_load(hba->dev, vreg,
+					       UFS_VREG_LPM_LOAD_UA);
 }
 
 static inline int ufshcd_config_vreg_hpm(struct ufs_hba *hba,
 					 struct ufs_vreg *vreg)
 {
-	return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
+	if (!vreg)
+		return 0;
+	else if (vreg->unused)
+		return 0;
+	else
+		return ufshcd_config_vreg_load(hba->dev, vreg, vreg->max_uA);
 }
 
 static int ufshcd_config_vreg(struct device *dev,
@@ -4784,7 +4802,9 @@ static int ufshcd_enable_vreg(struct device *dev, struct ufs_vreg *vreg)
 {
 	int ret = 0;
 
-	if (!vreg || vreg->enabled)
+	if (!vreg)
+		goto out;
+	else if (vreg->enabled || vreg->unused)
 		goto out;
 
 	ret = ufshcd_config_vreg(dev, vreg, true);
@@ -4804,7 +4824,9 @@ static int ufshcd_disable_vreg(struct device *dev, struct ufs_vreg *vreg)
 {
 	int ret = 0;
 
-	if (!vreg || !vreg->enabled)
+	if (!vreg)
+		goto out;
+	else if (!vreg->enabled || vreg->unused)
 		goto out;
 
 	ret = regulator_disable(vreg->reg);
@@ -4910,6 +4932,36 @@ static int ufshcd_init_hba_vreg(struct ufs_hba *hba)
 	return 0;
 }
 
+static int ufshcd_set_vccq_rail_unused(struct ufs_hba *hba, bool unused)
+{
+	int ret = 0;
+	struct ufs_vreg_info *info = &hba->vreg_info;
+
+	if (!info)
+		goto out;
+	else if (!info->vccq)
+		goto out;
+
+	if (unused) {
+		/* shut off the rail here */
+		ret = ufshcd_toggle_vreg(hba->dev, info->vccq, false);
+		/*
+		 * Mark this rail as no longer used, so it doesn't get enabled
+		 * later by mistake
+		 */
+		if (!ret)
+			info->vccq->unused = true;
+	} else {
+		/*
+		 * rail should have been already enabled hence just make sure
+		 * that unused flag is cleared.
+		 */
+		info->vccq->unused = false;
+	}
+out:
+	return ret;
+}
+
 static int __ufshcd_setup_clocks(struct ufs_hba *hba, bool on,
 					bool skip_ref_clk)
 {
-- 
1.8.5.2

-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation
