From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH 15/15] megaraid_sas: SPERC boot driver reorder
Date: Fri, 18 Dec 2015 18:57:08 +0530
Message-ID: <1450445228-26571-16-git-send-email-Sumit.Saxena@avagotech.com>
References: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f48.google.com ([209.85.220.48]:32768 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932270AbbLRN2x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2015 08:28:53 -0500
Received: by mail-pa0-f48.google.com with SMTP id ur14so60630550pab.0
        for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2015 05:28:52 -0800 (PST)
In-Reply-To: <1450445228-26571-1-git-send-email-Sumit.Saxena@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, Uday Lingala <uday.lingala@avagotech.com>

This patch will add support for drive ordering for a particular set of device ID (0x005D, 0x005F) & subsystem vendor ID(0x1028). 

The driver sends down MR_DCMD_CTRL_BIOS_DATA_GET to obtain information about the boot drive and calculates the target ID & Channel ID.
Instead of invoking scsi_scan_host() kernel API to let the SCSI layer scan sequentially, the driver calls scsi_add_device() to add the
targets one by one based on the following algorithms-

* If boot device is not present, driver exposes the LDs first in increasing order of target ID number followed by system PDs in slot order.
* If boot device is present and it is an LD, driver exposes the boot device first, then exposes the LDs in increasing order of target ID number
followed by system PDs in slot order.
* If boot device is present and it is an PD driver exposes the boot device first, then exposes the system PDs in slot order followed by LDs 
in increasing order of target ID.

Signed-off-by: Uday Lingala <uday.lingala@avagotech.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |   32 +++
 drivers/scsi/megaraid/megaraid_sas_base.c |  333 ++++++++++++++++++++++++++++-
 2 files changed, 360 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index ac19d53..fcf2b86 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -217,6 +217,7 @@
 #define MR_DCMD_CTRL_SET_CRASH_DUMP_PARAMS	0x01190100
 #define MR_DRIVER_SET_APP_CRASHDUMP_MODE	(0xF0010000 | 0x0600)
 #define MR_DCMD_PD_GET_INFO			0x02020000
+#define MR_DCMD_CTRL_BIOS_DATA_GET              0x010c0100
 
 /*
  * Global functions
@@ -763,6 +764,21 @@ struct MR_LD_TARGETID_LIST {
 	u8	targetId[MAX_LOGICAL_DRIVES_EXT];
 };
 
+struct MR_BIOS_DATA {
+	u16     bootTargetId;
+	u8      doNotExpose;
+	u8      continueOnError;
+	u8      verbose;
+	u8      geometry;
+	u8      exposeAllDrives;
+	u8      disableCTO;
+	u8      bootDeviceIsPD;
+	u8      EKMStatus;
+	u8      autoSelectBootLd;
+	u8      reserved[52];
+	u8      checkSum;
+};
+
 
 /*
  * SAS controller properties
@@ -1341,6 +1357,8 @@ struct megasas_ctrl_info {
 #define SCAN_PD_CHANNEL	0x1
 #define SCAN_VD_CHANNEL	0x2
 
+#define MEGASAS_INVALID_TARGET_ID               0xFFFF
+
 enum MR_SCSI_CMD_TYPE {
 	READ_WRITE_LDIO = 0,
 	NON_READ_WRITE_LDIO = 1,
@@ -1994,6 +2012,17 @@ enum MR_PD_TYPE {
 		 FC_PD = 4,
 };
 
+/*
+ *  define the structure specific to drive order feature
+ */
+struct megasas_drive_order {
+	u8 needs_ordering;         /* Drive ordering feature is enabled/disabled */
+	u8 boot_drive_is_pd;       /* Set if boot device is PD */
+	u16 boot_fw_tgt_id;        /* FW Target ID */
+	u8 boot_drive_channel_id;  /* OS Channel ID */
+	u16 boot_drive_tgt_id;     /* OS Target ID */
+};
+
 /* JBOD Queue depth definitions */
 #define MEGASAS_SATA_QD	32
 #define MEGASAS_SAS_QD	64
@@ -2133,7 +2162,9 @@ struct megasas_instance {
 	u8 is_imr;
 	u8 is_rdpq;
 	bool dev_handle;
+	struct megasas_drive_order drive_order;
 };
+
 struct MR_LD_VF_MAP {
 	u32 size;
 	union MR_LD_REF ref;
@@ -2319,6 +2350,7 @@ struct megasas_mgmt_info {
 	int max_index;
 };
 
+
 enum MEGASAS_OCR_CAUSE {
 	FW_FAULT_OCR			= 0,
 	SCSIIO_TIMEOUT_OCR		= 1,
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 316d5a0..b946ecb 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4445,6 +4445,139 @@ static void megasas_update_ext_vd_details(struct megasas_instance *instance)
 }
 
 /**
+ * megasas_get_bios_data  -	Returns FW's mr_bios_data structure
+ * @instance:			Adapter structure
+ *
+ * Issues an internal command (DCMD) to get the FW's controller BIOS
+ * data structure.  This information is mainly used to find the
+ * boot drive and its target id.
+ */
+
+static int
+megasas_get_bios_data(struct megasas_instance *instance)
+{
+	int ret = 0;
+	struct megasas_cmd *cmd;
+	struct megasas_dcmd_frame *dcmd;
+	struct MR_BIOS_DATA *ci;
+	struct megasas_drive_order *drv_odr;
+	dma_addr_t ci_h = 0;
+
+	drv_odr = &instance->drive_order;
+	cmd = megasas_get_cmd(instance);
+
+	if (!cmd) {
+		dev_info(&instance->pdev->dev, "%s : "
+		    "Failed to get cmd\n", __func__);
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	dcmd = &cmd->frame->dcmd;
+
+	ci = pci_alloc_consistent(instance->pdev,
+	    sizeof(struct MR_BIOS_DATA), &ci_h);
+
+	if (!ci) {
+		dev_info(&instance->pdev->dev, "%s : "
+		    "Failed to alloc mem for get_bios_data\n", __func__);
+		ret = -ENOMEM;
+		goto cmd_free;
+	}
+
+	memset(ci, 0, sizeof(struct MR_BIOS_DATA));
+	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+
+	dcmd->cmd = MFI_CMD_DCMD;
+	dcmd->cmd_status = 0xFF;
+	dcmd->sge_count = 1;
+	dcmd->flags = cpu_to_le16(MFI_FRAME_DIR_READ);
+	dcmd->timeout = 0;
+	dcmd->data_xfer_len = cpu_to_le32(sizeof(struct MR_BIOS_DATA));
+	dcmd->opcode = cpu_to_le32(MR_DCMD_CTRL_BIOS_DATA_GET);
+	dcmd->sgl.sge32[0].phys_addr = cpu_to_le32(ci_h);
+	dcmd->sgl.sge32[0].length = cpu_to_le32(sizeof(struct MR_BIOS_DATA));
+	dcmd->pad_0  = 0;
+
+	if (instance->ctrl_context && !instance->mask_interrupts)
+		ret = megasas_issue_blocked_cmd(instance, cmd, 60);
+	else
+		ret = megasas_issue_polled(instance, cmd);
+
+	switch (ret) {
+
+	case DCMD_SUCCESS:
+		/* check if boot drive is there */
+		if (le16_to_cpu(ci->bootTargetId) != MEGASAS_INVALID_TARGET_ID) {
+			drv_odr->boot_fw_tgt_id = le16_to_cpu(ci->bootTargetId);
+			drv_odr->boot_drive_is_pd = ci->bootDeviceIsPD;
+
+			if (drv_odr->boot_drive_is_pd) {
+				/* System PD Channel id set to 0 or 1 */
+				drv_odr->boot_drive_channel_id =
+					drv_odr->boot_fw_tgt_id/
+					MEGASAS_MAX_DEV_PER_CHANNEL;
+
+				/* System PD Target id set to 0 - 127 */
+				drv_odr->boot_drive_tgt_id =
+					drv_odr->boot_fw_tgt_id -
+					(drv_odr->boot_drive_channel_id *
+					MEGASAS_MAX_DEV_PER_CHANNEL);
+			} else {
+				/* LD Channel id set to 2 or 3 */
+				drv_odr->boot_drive_channel_id =
+					MEGASAS_MAX_PD_CHANNELS +
+					(drv_odr->boot_fw_tgt_id/
+					MEGASAS_MAX_DEV_PER_CHANNEL);
+
+				/* LD Target id set to 0 - 127 */
+				drv_odr->boot_drive_tgt_id =
+					drv_odr->boot_fw_tgt_id -
+					((drv_odr->boot_drive_channel_id -
+					MEGASAS_MAX_PD_CHANNELS) *
+					MEGASAS_MAX_DEV_PER_CHANNEL);
+			}
+		}
+		break;
+	case DCMD_TIMEOUT:
+		switch (dcmd_timeout_ocr_possible(instance)) {
+		case INITIATE_OCR:
+			cmd->flags |= DRV_DCMD_SKIP_REFIRE;
+			/*
+			 * DCMD failed from AEN path.
+			 * AEN path already hold reset_mutex to avoid PCI access
+			 * while OCR is in progress.
+			 */
+			megasas_reset_fusion(instance->host,
+			MFI_IO_TIMEOUT_OCR);
+			break;
+		case KILL_ADAPTER:
+			megaraid_sas_kill_hba(instance);
+			break;
+		case IGNORE_TIMEOUT:
+			dev_info(&instance->pdev->dev, "Ignore DCMD timeout: %s %d \n",
+						__func__, __LINE__);
+			break;
+
+		}
+		break;
+	case DCMD_FAILED:
+		dev_info(&instance->pdev->dev, "%s : "
+		    "Failed with return(%d)\n", __func__, ret);
+		break;
+	}
+
+	pci_free_consistent(instance->pdev, sizeof(struct MR_BIOS_DATA),
+	    ci, ci_h);
+
+cmd_free:
+	if (ret != DCMD_TIMEOUT)
+		megasas_return_cmd(instance, cmd);
+out:
+	return ret;
+}
+
+/**
  * megasas_get_controller_info -	Returns FW's controller structure
  * @instance:				Adapter soft state
  *
@@ -5653,6 +5786,194 @@ fail_set_dma_mask:
 }
 
 /**
+ * megasas_need_for_drive_ordering - Identify if the card needs drive ordering
+ * @instance:		Adapter structure
+ *
+ * This function looks at the Device ID & SubSystem Vendor ID and decides
+ * whether the drive ordering needs to be performed or not
+ *
+ * returns: 1 - Needs Ordering
+ *          0 - Does Not Need Ordering
+ */
+
+static u8
+megasas_need_for_drive_ordering(struct megasas_instance *instance)
+{
+	u8 ret;
+
+	if (((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
+	    (instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) &&
+	    (instance->pdev->subsystem_vendor == PCI_VENDOR_ID_DELL))
+		ret = 1; /* Needs ordering */
+	else
+		ret = 0; /* Does NOT need ordering */
+
+	return ret;
+}
+
+/**
+ * megasas_expose_drives_to_os - expose drive to OS by scanning or adding
+ * @instance:		Adapter structure
+ *
+ * This function either invokes scsi_scan_host() to add drives for
+ * cards which doesn't need drive ordering or invokes scsi_add_device()
+ * which needs drive ordering.
+ */
+
+static void
+megasas_expose_drives_to_os(struct megasas_instance *instance)
+{
+	int i, j, ret = 0;
+	struct Scsi_Host *host;
+	struct megasas_drive_order *drv_odr;
+	u16 pd_index = 0;
+	u16 ld_index = 0;
+
+	host = instance->host;
+	drv_odr = &instance->drive_order;
+
+	drv_odr->needs_ordering =
+	    megasas_need_for_drive_ordering(instance);
+
+	/*
+	 * Check if drive ordering is needed, if not
+	 * invoke SCSI layer to scan.
+	 */
+	if (!drv_odr->needs_ordering) {
+		/* Trigger SCSI to scan our drives */
+		scsi_scan_host(host);
+		return;
+	}
+
+	/* Drive ordering is needed, obtain details on boot drive */
+	ret = megasas_get_bios_data(instance);
+	if (ret) {
+		dev_info(&instance->pdev->dev, "%s : Failure in updating "
+			"boot disk data-structure disk_order\n", __func__);
+	}
+
+	/* Check if boot drive is behind this controller, if so
+	 * add that first */
+	if (drv_odr->boot_fw_tgt_id != MEGASAS_INVALID_TARGET_ID) {
+		ret = scsi_add_device(host, drv_odr->boot_drive_channel_id,
+		    drv_odr->boot_drive_tgt_id, 0);
+		if (ret) {
+			dev_info(&instance->pdev->dev, "%s : Failure in "
+			    "scsi_add_device() for boot drive (%d)\n",
+			    __func__, ret);
+		}
+	}
+
+	/* Case 1: Boot drive is not there
+	 * Case 2: Boot drive is there & it is LD
+	 * (which is already exposed above) */
+	if ((drv_odr->boot_fw_tgt_id == MEGASAS_INVALID_TARGET_ID) ||
+	    ((drv_odr->boot_fw_tgt_id != MEGASAS_INVALID_TARGET_ID) &&
+	    (!drv_odr->boot_drive_is_pd))) {
+
+		/* Expose LDs */
+		for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
+			for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
+				ld_index = (i * MEGASAS_MAX_DEV_PER_CHANNEL)
+				    + j;
+
+				/* Check if LD is present and it is not
+				 * the already added boot drive */
+				if ((instance->ld_ids[ld_index] != 0xff) &&
+				    (ld_index != drv_odr->boot_fw_tgt_id)) {
+					ret = scsi_add_device(host,
+					    MEGASAS_MAX_PD_CHANNELS + i, j, 0);
+					if (ret) {
+						dev_info(&instance->pdev->dev,
+						    "%s : Failure (%d) in "
+						    "scsi_add_device() for LD "
+						    "Channel:%d, Target:%d\n",
+						    __func__, ret,
+						    (MEGASAS_MAX_PD_CHANNELS
+						    + i), j);
+					}
+				}
+			}
+		}
+
+		/* Expose System PDs */
+		for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
+			for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
+				pd_index = (i * MEGASAS_MAX_DEV_PER_CHANNEL)
+				    + j;
+				if (instance->pd_list[pd_index].driveState ==
+				    MR_PD_STATE_SYSTEM) {
+					ret = scsi_add_device(host, i, j, 0);
+					if (ret) {
+						dev_info(&instance->pdev->dev,
+						    "%s : Failure (%d) in "
+						    "scsi_add_device() for "
+						    "System PD Channel: %d, "
+						    "Target: %d\n",
+						    __func__, ret, i, j);
+					}
+				}
+			}
+		}
+		return;
+	}
+
+	/* Case 3: Boot drive is there & it is System PD
+	 * (which is already exposed above) */
+	if ((drv_odr->boot_fw_tgt_id != MEGASAS_INVALID_TARGET_ID) &&
+	    (drv_odr->boot_drive_is_pd)) {
+
+		/* Expose System PDs */
+		for (i = 0; i < MEGASAS_MAX_PD_CHANNELS; i++) {
+			for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
+				pd_index = (i * MEGASAS_MAX_DEV_PER_CHANNEL)
+				    + j;
+
+				/* Check if System PD is present and
+				 * it is not the already added boot drive */
+				if ((instance->pd_list[pd_index].driveState ==
+				    MR_PD_STATE_SYSTEM) &&
+				    (pd_index != drv_odr->boot_fw_tgt_id)) {
+					ret = scsi_add_device(host, i, j, 0);
+					if (ret) {
+						dev_info(&instance->pdev->dev,
+						    "%s : Failure (%d) in "
+						    "scsi_add_device() for "
+						    "System PD Channel: %d, "
+						    "Target: %d\n",
+						    __func__, ret, i, j);
+					}
+				}
+			}
+		}
+
+		/* Expose LDs */
+		for (i = 0; i < MEGASAS_MAX_LD_CHANNELS; i++) {
+			for (j = 0; j < MEGASAS_MAX_DEV_PER_CHANNEL; j++) {
+				ld_index = (i * MEGASAS_MAX_DEV_PER_CHANNEL)
+				    + j;
+
+				/* Check if LD is present */
+				if (instance->ld_ids[ld_index] != 0xff) {
+					ret = scsi_add_device(host,
+					    MEGASAS_MAX_PD_CHANNELS + i, j, 0);
+					if (ret) {
+						dev_info(&instance->pdev->dev,
+						    "%s : Failure (%d) in "
+						    "scsi_add_device() for LD "
+						    "Channel:%d, Target:%d\n",
+						    __func__, ret,
+						    (MEGASAS_MAX_PD_CHANNELS
+						    + i), j);
+					}
+				}
+			}
+		}
+		return;
+	}
+}
+
+/**
  * megasas_probe_one -	PCI hotplug entry point
  * @pdev:		PCI device structure
  * @id:			PCI ids of supported hotplugged adapter
@@ -5788,6 +6109,8 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	instance->issuepend_done = 1;
 	atomic_set(&instance->adprecovery, MEGASAS_HBA_OPERATIONAL);
 	instance->is_imr = 0;
+	 /* Setting boot_fw_tgt_id to none */
+	instance->drive_order.boot_fw_tgt_id = MEGASAS_INVALID_TARGET_ID;
 
 	instance->evt_detail = pci_alloc_consistent(pdev,
 						    sizeof(struct
@@ -5895,11 +6218,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	if (megasas_io_attach(instance))
 		goto fail_io_attach;
 
-	instance->unload = 0;
-	/*
-	 * Trigger SCSI to scan our drives
-	 */
-	scsi_scan_host(host);
 
 	/*
 	 * Initiate AEN (Asynchronous Event Notification)
@@ -5909,6 +6227,11 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		goto fail_start_aen;
 	}
 
+	instance->unload = 0;
+
+	/* Expose the System PD/LD to Operating System */
+	megasas_expose_drives_to_os(instance);
+
 	/* Get current SR-IOV LD/VF affiliation */
 	if (instance->requestorId)
 		megasas_get_ld_vf_affiliation(instance, 1);
-- 
1.7.1

