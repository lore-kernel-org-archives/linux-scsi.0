From: Dolev Raviv <draviv@codeaurora.org>
Subject: [PATCH V5 10/17] scsi: ufs: manually add well known logical units
Date: Wed, 24 Sep 2014 18:14:06 +0300
Message-ID: <1411571653-22729-11-git-send-email-draviv@codeaurora.org>
References: <1411571653-22729-1-git-send-email-draviv@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.11.231]:48618 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897AbaIXPPC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Sep 2014 11:15:02 -0400
In-Reply-To: <1411571653-22729-1-git-send-email-draviv@codeaurora.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, Subhash Jadavani <subhashj@codeaurora.org>, Dolev Raviv <draviv@codeaurora.org>, Sujit Reddy Thumma <sthumma@codeaurora.org>

From: Subhash Jadavani <subhashj@codeaurora.org>

UFS device specification requires the UFS devices to support 4 well known
logical units:
	"REPORT_LUNS" (address: 01h)
	"UFS Device" (address: 50h)
	"RPMB" (address: 44h)
	"BOOT" (address: 30h)

UFS device may have standard LUs and LUN id could be from 0x00 to 0x7F.
UFS device specification use "Peripheral Device Addressing Format"
(SCSI SAM-5) for standard LUs.

UFS device akso have the Well Known LUs (also referred as W-LU) which
again could be from 0x00 to 0x7F. For W-LUs, UFS device specification only
allows the "Extended Addressing Format" (SCSI SAM-5) which means the W-LUNs
would start from 0xC100 onwards.

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
Signed-off-by: Sujit Reddy Thumma <sthumma@codeaurora.org>

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 4ca99ed..37d64c1 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -49,9 +49,28 @@
 #define UPIU_HEADER_DWORD(byte3, byte2, byte1, byte0)\
 			cpu_to_be32((byte3 << 24) | (byte2 << 16) |\
 			 (byte1 << 8) | (byte0))
-
+/*
+ * UFS device may have standard LUs and LUN id could be from 0x00 to
+ * 0x7F. Standard LUs use "Peripheral Device Addressing Format".
+ * UFS device may also have the Well Known LUs (also referred as W-LU)
+ * which again could be from 0x00 to 0x7F. For W-LUs, device only use
+ * the "Extended Addressing Format" which means the W-LUNs would be
+ * from 0xc100 (SCSI_W_LUN_BASE) onwards.
+ * This means max. LUN number reported from UFS device could be 0xC17F.
+ */
+#define UFS_UPIU_MAX_UNIT_NUM_ID	0x7F
+#define UFS_MAX_LUNS		(SCSI_W_LUN_BASE + UFS_UPIU_MAX_UNIT_NUM_ID)
+#define UFS_UPIU_WLUN_ID	(1 << 7)
 #define UFS_UPIU_MAX_GENERAL_LUN	8
 
+/* Well known logical unit id in LUN field of UPIU */
+enum {
+	UFS_UPIU_REPORT_LUNS_WLUN	= 0x81,
+	UFS_UPIU_UFS_DEVICE_WLUN	= 0xD0,
+	UFS_UPIU_BOOT_WLUN		= 0xB0,
+	UFS_UPIU_RPMB_WLUN		= 0xC4,
+};
+
 /*
  * UFS Protocol Information Unit related definitions
  */
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index dc89c48..eede10a 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -100,7 +100,6 @@ static u32 ufs_query_desc_max_size[] = {
 enum {
 	UFSHCD_MAX_CHANNEL	= 0,
 	UFSHCD_MAX_ID		= 1,
-	UFSHCD_MAX_LUNS		= 8,
 	UFSHCD_CMD_PER_LUN	= 32,
 	UFSHCD_CAN_QUEUE	= 32,
 };
@@ -901,6 +900,32 @@ static int ufshcd_compose_upiu(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	return ret;
 }
 
+/*
+ * ufshcd_scsi_to_upiu_lun - maps scsi LUN to UPIU LUN
+ * @scsi_lun: scsi LUN id
+ *
+ * Returns UPIU LUN id
+ */
+static inline u8 ufshcd_scsi_to_upiu_lun(unsigned int scsi_lun)
+{
+	if (scsi_is_wlun(scsi_lun))
+		return (scsi_lun & UFS_UPIU_MAX_UNIT_NUM_ID)
+			| UFS_UPIU_WLUN_ID;
+	else
+		return scsi_lun & UFS_UPIU_MAX_UNIT_NUM_ID;
+}
+
+/**
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
 /**
  * ufshcd_queuecommand - main entry point for SCSI requests
  * @cmd: command from SCSI Midlayer
@@ -959,7 +984,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
 	lrbp->sense_bufflen = SCSI_SENSE_BUFFERSIZE;
 	lrbp->sense_buffer = cmd->sense_buffer;
 	lrbp->task_tag = tag;
-	lrbp->lun = cmd->device->lun;
+	lrbp->lun = ufshcd_scsi_to_upiu_lun(cmd->device->lun);
 	lrbp->intr_cmd = false;
 	lrbp->command_type = UTP_CMD_TYPE_SCSI;
 
@@ -1513,7 +1538,7 @@ static inline int ufshcd_read_unit_desc_param(struct ufs_hba *hba,
 	 * Unit descriptors are only available for general purpose LUs (LUN id
 	 * from 0 to 7) and RPMB Well known LU.
 	 */
-	if (lun >= UFS_UPIU_MAX_GENERAL_LUN)
+	if (lun != UFS_UPIU_RPMB_WLUN && (lun >= UFS_UPIU_MAX_GENERAL_LUN))
 		return -EOPNOTSUPP;
 
 	return ufshcd_read_desc_param(hba, QUERY_DESC_IDN_UNIT, lun,
@@ -2144,6 +2169,44 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 }
 
 /**
+ * ufshcd_set_queue_depth - set lun queue depth
+ * @sdev: pointer to SCSI device
+ *
+ * Read bLUQueueDepth value and activate scsi tagged command
+ * queueing. For WLUN, queue depth is set to 1. For best-effort
+ * cases (bLUQueueDepth = 0) the queue depth is set to a maximum
+ * value that host can queue.
+ */
+static void ufshcd_set_queue_depth(struct scsi_device *sdev)
+{
+	int ret = 0;
+	u8 lun_qdepth;
+	struct ufs_hba *hba;
+
+	hba = shost_priv(sdev->host);
+
+	lun_qdepth = hba->nutrs;
+	ret = ufshcd_read_unit_desc_param(hba,
+					  ufshcd_scsi_to_upiu_lun(sdev->lun),
+					  UNIT_DESC_PARAM_LU_Q_DEPTH,
+					  &lun_qdepth,
+					  sizeof(lun_qdepth));
+
+	/* Some WLUN doesn't support unit descriptor */
+	if (ret == -EOPNOTSUPP)
+		lun_qdepth = 1;
+	else if (!lun_qdepth)
+		/* eventually, we can figure out the real queue depth */
+		lun_qdepth = hba->nutrs;
+	else
+		lun_qdepth = min_t(int, lun_qdepth, hba->nutrs);
+
+	dev_dbg(hba->dev, "%s: activate tcq with queue depth %d\n",
+			__func__, lun_qdepth);
+	scsi_activate_tcq(sdev, lun_qdepth);
+}
+
+/**
  * ufshcd_slave_alloc - handle initial SCSI device configurations
  * @sdev: pointer to SCSI device
  *
@@ -2152,8 +2215,6 @@ static int ufshcd_verify_dev_init(struct ufs_hba *hba)
 static int ufshcd_slave_alloc(struct scsi_device *sdev)
 {
 	struct ufs_hba *hba;
-	u8 lun_qdepth;
-	int ret;
 
 	hba = shost_priv(sdev->host);
 	sdev->tagged_supported = 1;
@@ -2168,20 +2229,8 @@ static int ufshcd_slave_alloc(struct scsi_device *sdev)
 	/* REPORT SUPPORTED OPERATION CODES is not supported */
 	sdev->no_report_opcodes = 1;
 
-	ret = ufshcd_read_unit_desc_param(hba,
-					  sdev->lun,
-					  UNIT_DESC_PARAM_LU_Q_DEPTH,
-					  &lun_qdepth,
-					  sizeof(lun_qdepth));
-	if (!ret || !lun_qdepth)
-		/* eventually, we can figure out the real queue depth */
-		lun_qdepth = hba->nutrs;
-	else
-		lun_qdepth = min_t(int, lun_qdepth, hba->nutrs);
 
-	dev_dbg(hba->dev, "%s: activate tcq with queue depth %d\n",
-			__func__, lun_qdepth);
-	scsi_activate_tcq(sdev, lun_qdepth);
+	ufshcd_set_queue_depth(sdev);
 
 	return 0;
 }
@@ -2961,7 +3010,10 @@ static int ufshcd_issue_tm_cmd(struct ufs_hba *hba, int lun_id, int task_id,
 					      lun_id, task_tag);
 	task_req_upiup->header.dword_1 =
 		UPIU_HEADER_DWORD(0, tm_function, 0, 0);
-
+	/*
+	 * The host shall provide the same value for LUN field in the basic
+	 * header and for Input Parameter.
+	 */
 	task_req_upiup->input_param1 = cpu_to_be32(lun_id);
 	task_req_upiup->input_param2 = cpu_to_be32(task_id);
 
@@ -3384,6 +3436,69 @@ static void ufshcd_init_icc_levels(struct ufs_hba *hba)
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
  * ufshcd_probe_hba - probe hba to detect device and initialize
  * @hba: per-adapter instance
  *
@@ -3415,6 +3530,10 @@ static int ufshcd_probe_hba(struct ufs_hba *hba)
 		if (!hba->is_init_prefetch)
 			ufshcd_init_icc_levels(hba);
 
+		/* Add required well known logical units to scsi mid layer */
+		if (ufshcd_scsi_add_wlus(hba))
+			goto out;
+
 		scsi_scan_host(hba->host);
 		pm_runtime_put_sync(hba->dev);
 	}
@@ -4018,7 +4137,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 	host->can_queue = hba->nutrs;
 	host->cmd_per_lun = hba->nutrs;
 	host->max_id = UFSHCD_MAX_ID;
-	host->max_lun = UFSHCD_MAX_LUNS;
+	host->max_lun = UFS_MAX_LUNS;
 	host->max_channel = UFSHCD_MAX_CHANNEL;
 	host->unique_id = host->host_no;
 	host->max_cmd_len = MAX_CDB_SIZE;
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 8365ad4..5c25337 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -124,7 +124,7 @@ struct ufshcd_lrb {
 
 	int command_type;
 	int task_tag;
-	unsigned int lun;
+	u8 lun; /* UPIU LUN id field is only 8-bit wide */
 	bool intr_cmd;
 };
 
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

