From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V6 10/18] scsi: ufs: manually add well known logical units
Date: Thu, 25 Sep 2014 15:32:28 +0300
Message-ID: <1411648356-3883-11-git-send-email-draviv@codeaurora.org>
References: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-arm-msm-owner@vger.kernel.org>
In-Reply-To: <1411648356-3883-1-git-send-email-draviv@codeaurora.org>
Sender: linux-arm-msm-owner@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>
List-Id: linux-scsi@vger.kernel.org

From: Subhash Jadavani <subhashj@codeaurora.org>

UFS device specification requires the UFS devices to support 4 well known
logical units:
	"REPORT_LUNS" (address: 01h)
	"UFS Device" (address: 50h)
	"RPMB" (address: 44h)
	"BOOT" (address: 30h)

UFS device's power management needs to be controlled by "POWER CONDITION"
field of SSU (START STOP UNIT) command. But this "power condition" field
will take effect only when its sent to "UFS device" well known logical unit
hence we require the scsi_device instance to represent this logical unit in
order for the UFS host driver to send the SSU command for power management.

We also require the scsi_device instance for "RPMB" (Replay Protected
Memory Block) LU so user space process can control this LU. User space may
also want to have access to BOOT LU.

This patch adds the scsi device instances for each of all well known LUs
(except "REPORT LUNS" LU).

Signed-off-by: Subhash Jadavani <subhashj@codeaurora.org>
Signed-off-by: Dolev Raviv <draviv@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dc89c48..692fd7a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -902,6 +902,17 @@ static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 }
 
 /**
+ * ufshcd_upiu_wlun_to_scsi_wlun - maps UPIU W-LUN id to SCSI W-LUN ID
+ * @scsi_lun: UPIU W-LUN id
+ *
+ * Returns SCSI W-LUN id
+ */
+static inline u16 ufshcd_upiu_wlun_to_scsi_wlun(u8 upiu_wlun_id)
+{
+	return (upiu_wlun_id & ~UFS_UPIU_WLUN_ID) | SCSI_W_LUN_BASE;
+}
+
+/**
  * ufshcd_queuecommand - main entry point for SCSI requests
  * @cmd: command from SCSI Midlayer
  * @done: call back function
@@ -3384,6 +3395,93 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_scsi_add_wlus - Adds required W-LUs
+ * @hba: per-adapter instance
+ *
+ * UFS device specification requires the UFS devices to support 4 well known
+ * logical units:
+ *	"REPORT_LUNS" (address: 01h)
+ *	"UFS Device" (address: 50h)
+ *	"RPMB" (address: 44h)
+ *	"BOOT" (address: 30h)
+ * UFS device's power management needs to be controlled by "POWER CONDITION"
+ * field of SSU (START STOP UNIT) command. But this "power condition" field
+ * will take effect only when its sent to "UFS device" well known logical unit
+ * hence we require the scsi_device instance to represent this logical unit in
+ * order for the UFS host driver to send the SSU command for power management.
+
+ * We also require the scsi_device instance for "RPMB" (Replay Protected Memory
+ * Block) LU so user space process can control this LU. User space may also
+ * want to have access to BOOT LU.
+
+ * This function adds scsi device instances for each of all well known LUs
+ * (except "REPORT LUNS" LU).
+ *
+ * Returns zero on success (all required W-LUs are added successfully),
+ * non-zero error value on failure (if failed to add any of the required W-LU).
+ */
+static int ufshcd_scsi_add_wlus(struct ufs_hba *hba)
+{
+	int ret = 0;
+
+	hba->sdev_ufs_device = __scsi_add_device(hba->host, 0, 0,
+		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_UFS_DEVICE_WLUN), NULL);
+	if (IS_ERR(hba->sdev_ufs_device)) {
+		ret = PTR_ERR(hba->sdev_ufs_device);
+		hba->sdev_ufs_device = NULL;
+		goto out;
+	}
+
+	hba->sdev_boot = __scsi_add_device(hba->host, 0, 0,
+		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_BOOT_WLUN), NULL);
+	if (IS_ERR(hba->sdev_boot)) {
+		ret = PTR_ERR(hba->sdev_boot);
+		hba->sdev_boot = NULL;
+		goto remove_sdev_ufs_device;
+	}
+
+	hba->sdev_rpmb = __scsi_add_device(hba->host, 0, 0,
+		ufshcd_upiu_wlun_to_scsi_wlun(UFS_UPIU_RPMB_WLUN), NULL);
+	if (IS_ERR(hba->sdev_rpmb)) {
+		ret = PTR_ERR(hba->sdev_rpmb);
+		hba->sdev_rpmb = NULL;
+		goto remove_sdev_boot;
+	}
+	goto out;
+
+remove_sdev_boot:
+	scsi_remove_device(hba->sdev_boot);
+remove_sdev_ufs_device:
+	scsi_remove_device(hba->sdev_ufs_device);
+out:
+	return ret;
+}
+
+/**
+ * ufshcd_scsi_remove_wlus - Removes the W-LUs which were added by
+ *			     ufshcd_scsi_add_wlus()
+ * @hba: per-adapter instance
+ *
+ */
+static void ufshcd_scsi_remove_wlus(struct ufs_hba *hba)
+{
+	if (hba->sdev_ufs_device) {
+		scsi_remove_device(hba->sdev_ufs_device);
+		hba->sdev_ufs_device = NULL;
+	}
+
+	if (hba->sdev_boot) {
+		scsi_remove_device(hba->sdev_boot);
+		hba->sdev_boot = NULL;
+	}
+
+	if (hba->sdev_rpmb) {
+		scsi_remove_device(hba->sdev_rpmb);
+		hba->sdev_rpmb = NULL;
+	}
+}
+
+/**
  * ufshcd_probe_hba - probe hba to detect device and initialize
  * @hba: per-adapter instance
  *
@@ -3415,6 +3513,10 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		if (!hba->is_init_prefetch)
 			ufshcd_init_icc_levels(hba);
 
+		/* Add required well known logical units to scsi mid layer */
+		if (ufshcd_scsi_add_wlus(hba))
+			goto out;
+
 		scsi_scan_host(hba->host);
 		pm_runtime_put_sync(hba->dev);
 	}
@@ -3901,6 +4003,7 @@ EXPORT_SYMBOL(ufshcd_runtime_idle);
 void ufshcd_remove(struct ufs_hba *hba)
 {
 	scsi_remove_host(hba->host);
+	ufshcd_scsi_remove_wlus(hba);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8365ad4..25065ea 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -266,6 +266,13 @@ struct ufs_hba {
 
 	struct Scsi_Host *host;
 	struct device *dev;
+	/*
+	 * This field is to keep a reference to "scsi_device" corresponding to
+	 * "UFS device" W-LU.
+	 */
+	struct scsi_device *sdev_ufs_device;
+	struct scsi_device *sdev_rpmb;
+	struct scsi_device *sdev_boot;
 
 	struct ufshcd_lrb *lrb;
 	unsigned long lrb_in_use;
-- 
1.8.5.2
-- 
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation
