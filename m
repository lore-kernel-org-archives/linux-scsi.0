From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 09/39] megaraid_sas: NVME Interface detection and prop settings
Date: Mon,  6 Feb 2017 01:59:42 -0800
Message-ID: <1486375212-17329-10-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f180.google.com ([209.85.192.180]:33651 "EHLO
        mail-pf0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751314AbdBFKBt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:01:49 -0500
Received: by mail-pf0-f180.google.com with SMTP id y143so23097068pfb.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:01:49 -0800 (PST)
In-Reply-To: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

New functionality
Adding detection logic for NVME device attached behind Ventura controller.
Driver set HostPageSize in IOC_INIT frame to inform about page size for NVME devices.
Firmware reports NVME page size to the driver.
PD INFO DCMD provide new interface type NVME_PD. Driver set property of NVME device.

Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |  23 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c   | 170 ++++++++++++++++++++--------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   6 +-
 drivers/scsi/megaraid/megaraid_sas_fusion.h |   2 +-
 4 files changed, 142 insertions(+), 59 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index dff877f..c5c55fe 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -733,7 +733,6 @@ struct megasas_pd_list {
 	u16             tid;
 	u8             driveType;
 	u8             driveState;
-	u8             interface;
 } __packed;
 
  /*
@@ -1530,8 +1529,8 @@ struct megasas_register_set {
 	u32 	outbound_scratch_pad ;		/*00B0h*/
 	u32	outbound_scratch_pad_2;         /*00B4h*/
 	u32	outbound_scratch_pad_3;         /*00B8h*/
+	u32	outbound_scratch_pad_4;         /*00BCh*/
 
-	u32	reserved_4;			/*00BCh*/
 
 	u32 	inbound_low_queue_port ;	/*00C0h*/
 
@@ -1864,6 +1863,7 @@ union megasas_frame {
 struct MR_PRIV_DEVICE {
 	bool is_tm_capable;
 	bool tm_busy;
+	u8   interface_type;
 };
 struct megasas_cmd;
 
@@ -2055,17 +2055,24 @@ struct MR_DRV_SYSTEM_INFO {
 };
 
 enum MR_PD_TYPE {
-		 UNKNOWN_DRIVE = 0,
-		 PARALLEL_SCSI = 1,
-		 SAS_PD = 2,
-		 SATA_PD = 3,
-		 FC_PD = 4,
+	UNKNOWN_DRIVE = 0,
+	PARALLEL_SCSI = 1,
+	SAS_PD = 2,
+	SATA_PD = 3,
+	FC_PD = 4,
+	NVME_PD = 5,
 };
 
 /* JBOD Queue depth definitions */
 #define MEGASAS_SATA_QD	32
 #define MEGASAS_SAS_QD	64
 #define MEGASAS_DEFAULT_PD_QD	64
+#define MEGASAS_NVME_QD		32
+
+#define MR_DEFAULT_NVME_PAGE_SIZE	4096
+#define MR_DEFAULT_NVME_PAGE_SHIFT	12
+#define MR_DEFAULT_NVME_MDTS_KB		128
+#define MR_NVME_PAGE_SIZE_MASK		0x000000FF
 
 struct megasas_instance {
 
@@ -2209,6 +2216,7 @@ struct megasas_instance {
 	bool is_ventura;
 	bool msix_combined;
 	u16 max_raid_mapsize;
+	u32 nvme_page_size;
 };
 struct MR_LD_VF_MAP {
 	u32 size;
@@ -2428,6 +2436,7 @@ int megasas_get_ctrl_info(struct megasas_instance *instance);
 /* PD sequence */
 int
 megasas_sync_pd_seq_num(struct megasas_instance *instance, bool pend);
+void megasas_set_dynamic_target_properties(struct scsi_device *sdev);
 int megasas_set_crash_dump_params(struct megasas_instance *instance,
 	u8 crash_buf_state);
 void megasas_free_host_crash_buffer(struct megasas_instance *instance);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 138d028..7b47109 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -116,8 +116,8 @@ static int megasas_ld_list_query(struct megasas_instance *instance,
 static int megasas_issue_init_mfi(struct megasas_instance *instance);
 static int megasas_register_aen(struct megasas_instance *instance,
 				u32 seq_num, u32 class_locale_word);
-static int
-megasas_get_pd_info(struct megasas_instance *instance, u16 device_id);
+static void megasas_get_pd_info(struct megasas_instance *instance,
+				struct scsi_device *sdev);
 /*
  * PCI ID table for all supported controllers
  */
@@ -1735,16 +1735,21 @@ static struct megasas_instance *megasas_lookup_instance(u16 host_no)
 }
 
 /*
-* megasas_update_sdev_properties - Update sdev structure based on controller's FW capabilities
+* megasas_set_dynamic_target_properties -
+* Device property set by driver may not be static and it is required to be
+* updated after OCR
+*
+* set tm_capable.
+* set dma alignment (only for eedp protection enable vd).
 *
 * @sdev: OS provided scsi device
 *
 * Returns void
 */
-void megasas_update_sdev_properties(struct scsi_device *sdev)
+void megasas_set_dynamic_target_properties(struct scsi_device *sdev)
 {
-	u16 pd_index = 0;
-	u32 device_id, ld;
+	u16 pd_index = 0, ld;
+	u32 device_id;
 	struct megasas_instance *instance;
 	struct fusion_context *fusion;
 	struct MR_PRIV_DEVICE *mr_device_priv_data;
@@ -1769,57 +1774,102 @@ void megasas_update_sdev_properties(struct scsi_device *sdev)
 		raid = MR_LdRaidGet(ld, local_map_ptr);
 
 		if (raid->capability.ldPiMode == MR_PROT_INFO_TYPE_CONTROLLER)
-			blk_queue_update_dma_alignment(sdev->request_queue,
-						       0x7);
+		blk_queue_update_dma_alignment(sdev->request_queue, 0x7);
 
 		mr_device_priv_data->is_tm_capable =
 			raid->capability.tmCapable;
 	} else if (instance->use_seqnum_jbod_fp) {
 		pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +
-				sdev->id;
+			sdev->id;
 		pd_sync = (void *)fusion->pd_seq_sync
 				[(instance->pd_seq_map_id - 1) & 1];
 		mr_device_priv_data->is_tm_capable =
-				pd_sync->seq[pd_index].capability.tmCapable;
+			pd_sync->seq[pd_index].capability.tmCapable;
 	}
 }
 
-static void megasas_set_device_queue_depth(struct scsi_device *sdev)
+/*
+ * megasas_set_nvme_device_properties -
+ * set nomerges=2
+ * set virtual page boundary = 4K (current mr_nvme_pg_size is 4K).
+ * set maximum io transfer = MDTS of NVME device provided by MR firmware.
+ *
+ * MR firmware provides value in KB. Caller of this function converts
+ * kb into bytes.
+ *
+ * e.a MDTS=5 means 2^5 * nvme page size. (In case of 4K page size,
+ * MR firmware provides value 128 as (32 * 4K) = 128K.
+ *
+ * @sdev:				scsi device
+ * @max_io_size:				maximum io transfer size
+ *
+ */
+static inline void
+megasas_set_nvme_device_properties(struct scsi_device *sdev, u32 max_io_size)
 {
-	u16				pd_index = 0;
-	int		ret = DCMD_FAILED;
 	struct megasas_instance *instance;
+	u32 mr_nvme_pg_size;
 
-	instance = megasas_lookup_instance(sdev->host->host_no);
+	instance = (struct megasas_instance *)sdev->host->hostdata;
+	mr_nvme_pg_size = max_t(u32, instance->nvme_page_size,
+				MR_DEFAULT_NVME_PAGE_SIZE);
 
-	if (sdev->channel < MEGASAS_MAX_PD_CHANNELS) {
-		pd_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) + sdev->id;
+	blk_queue_max_hw_sectors(sdev->request_queue, (max_io_size / 512));
 
-		if (instance->pd_info) {
-			mutex_lock(&instance->hba_mutex);
-			ret = megasas_get_pd_info(instance, pd_index);
-			mutex_unlock(&instance->hba_mutex);
-		}
+	queue_flag_set_unlocked(QUEUE_FLAG_NOMERGES, sdev->request_queue);
+	blk_queue_virt_boundary(sdev->request_queue, mr_nvme_pg_size - 1);
+}
 
-		if (ret != DCMD_SUCCESS)
-			return;
 
-		if (instance->pd_list[pd_index].driveState == MR_PD_STATE_SYSTEM) {
+/*
+ * megasas_set_static_target_properties -
+ * Device property set by driver are static and it is not required to be
+ * updated after OCR.
+ *
+ * set io timeout
+ * set device queue depth
+ * set nvme device properties. see - megasas_set_nvme_device_properties
+ *
+ * @sdev:				scsi device
+ *
+ */
+static void megasas_set_static_target_properties(struct scsi_device *sdev)
+{
+	u16	target_index = 0;
+	u8 interface_type;
+	u32 device_qd = MEGASAS_DEFAULT_CMD_PER_LUN;
+	u32 max_io_size_kb = MR_DEFAULT_NVME_MDTS_KB;
+	struct megasas_instance *instance;
+	struct MR_PRIV_DEVICE *mr_device_priv_data;
 
-			switch (instance->pd_list[pd_index].interface) {
-			case SAS_PD:
-				scsi_change_queue_depth(sdev, MEGASAS_SAS_QD);
-				break;
+	instance = megasas_lookup_instance(sdev->host->host_no);
+	mr_device_priv_data = sdev->hostdata;
+	interface_type  = mr_device_priv_data->interface_type;
 
-			case SATA_PD:
-				scsi_change_queue_depth(sdev, MEGASAS_SATA_QD);
-				break;
+	/*
+	 * The RAID firmware may require extended timeouts.
+	 */
+	blk_queue_rq_timeout(sdev->request_queue, scmd_timeout * HZ);
 
-			default:
-				scsi_change_queue_depth(sdev, MEGASAS_DEFAULT_PD_QD);
-			}
-		}
+	target_index = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) + sdev->id;
+
+	switch (interface_type) {
+	case SAS_PD:
+		device_qd = MEGASAS_SAS_QD;
+		break;
+	case SATA_PD:
+		device_qd = MEGASAS_SATA_QD;
+		break;
+	case NVME_PD:
+		device_qd = MEGASAS_NVME_QD;
+		break;
 	}
+
+	if (instance->nvme_page_size && max_io_size_kb)
+		megasas_set_nvme_device_properties(sdev, (max_io_size_kb << 10));
+
+	scsi_change_queue_depth(sdev, device_qd);
+
 }
 
 
@@ -1838,14 +1888,18 @@ static int megasas_slave_configure(struct scsi_device *sdev)
 				return -ENXIO;
 		}
 	}
-	megasas_set_device_queue_depth(sdev);
-	megasas_update_sdev_properties(sdev);
 
-	/*
-	 * The RAID firmware may require extended timeouts.
-	 */
-	blk_queue_rq_timeout(sdev->request_queue,
-		scmd_timeout * HZ);
+	mutex_lock(&instance->hba_mutex);
+	/* Send DCMD to Firmware and cache the information */
+	if ((instance->pd_info) && !MEGASAS_IS_LOGICAL(sdev))
+		megasas_get_pd_info(instance, sdev);
+
+	megasas_set_static_target_properties(sdev);
+
+	mutex_unlock(&instance->hba_mutex);
+
+	/* This sdev property may change post OCR */
+	megasas_set_dynamic_target_properties(sdev);
 
 	return 0;
 }
@@ -3983,18 +4037,22 @@ dcmd_timeout_ocr_possible(struct megasas_instance *instance) {
 		return INITIATE_OCR;
 }
 
-static int
-megasas_get_pd_info(struct megasas_instance *instance, u16 device_id)
+static void
+megasas_get_pd_info(struct megasas_instance *instance, struct scsi_device *sdev)
 {
 	int ret;
 	struct megasas_cmd *cmd;
 	struct megasas_dcmd_frame *dcmd;
 
+	struct MR_PRIV_DEVICE *mr_device_priv_data;
+	u16 device_id = 0;
+
+	device_id = (sdev->channel * MEGASAS_MAX_DEV_PER_CHANNEL) + sdev->id;
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
 		dev_err(&instance->pdev->dev, "Failed to get cmd %s\n", __func__);
-		return -ENOMEM;
+		return;
 	}
 
 	dcmd = &cmd->frame->dcmd;
@@ -4021,7 +4079,9 @@ megasas_get_pd_info(struct megasas_instance *instance, u16 device_id)
 
 	switch (ret) {
 	case DCMD_SUCCESS:
-		instance->pd_list[device_id].interface =
+		mr_device_priv_data = sdev->hostdata;
+		le16_to_cpus((u16 *)&instance->pd_info->state.ddf.pdType);
+		mr_device_priv_data->interface_type =
 				instance->pd_info->state.ddf.pdType.intf;
 		break;
 
@@ -4048,7 +4108,7 @@ megasas_get_pd_info(struct megasas_instance *instance, u16 device_id)
 	if (ret != DCMD_TIMEOUT)
 		megasas_return_cmd(instance, cmd);
 
-	return ret;
+	return;
 }
 /*
  * megasas_get_pd_list_info -	Returns FW's pd_list structure
@@ -5017,8 +5077,8 @@ megasas_setup_jbod_map(struct megasas_instance *instance)
 static int megasas_init_fw(struct megasas_instance *instance)
 {
 	u32 max_sectors_1;
-	u32 max_sectors_2;
-	u32 tmp_sectors, msix_enable, scratch_pad_2, scratch_pad_3;
+	u32 max_sectors_2, tmp_sectors, msix_enable;
+	u32 scratch_pad_2, scratch_pad_3, scratch_pad_4;
 	resource_size_t base_addr;
 	struct megasas_register_set __iomem *reg_set;
 	struct megasas_ctrl_info *ctrl_info = NULL;
@@ -5199,6 +5259,18 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (instance->instancet->init_adapter(instance))
 		goto fail_init_adapter;
 
+	if (instance->is_ventura) {
+		scratch_pad_4 =
+			readl(&instance->reg_set->outbound_scratch_pad_4);
+		if ((scratch_pad_4 & MR_NVME_PAGE_SIZE_MASK) >=
+			MR_DEFAULT_NVME_PAGE_SHIFT)
+			instance->nvme_page_size =
+				(1 << (scratch_pad_4 & MR_NVME_PAGE_SIZE_MASK));
+
+		dev_info(&instance->pdev->dev,
+			 "NVME page size\t: (%d)\n", instance->nvme_page_size);
+	}
+
 	if (instance->msix_vectors ?
 		megasas_setup_irqs_msix(instance, 1) :
 		megasas_setup_irqs_ioapic(instance))
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 1ec482e..d87483e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -376,7 +376,8 @@ static int megasas_create_sg_sense_fusion(struct megasas_instance *instance)
 
 	fusion->sg_dma_pool =
 			pci_pool_create("mr_sg", instance->pdev,
-				instance->max_chain_frame_sz, 4, 0);
+				instance->max_chain_frame_sz,
+				MR_DEFAULT_NVME_PAGE_SIZE, 0);
 	/* SCSI_SENSE_BUFFERSIZE  = 96 bytes */
 	fusion->sense_dma_pool =
 			pci_pool_create("mr_sense", instance->pdev,
@@ -823,6 +824,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 			MPI2_IOCINIT_MSGFLAG_RDPQ_ARRAY_MODE : 0;
 	IOCInitMessage->SystemRequestFrameBaseAddress = cpu_to_le64(fusion->io_request_frames_phys);
 	IOCInitMessage->HostMSIxVectors = instance->msix_vectors;
+	IOCInitMessage->HostPageSize = MR_DEFAULT_NVME_PAGE_SHIFT;
 	init_frame = (struct megasas_init_frame *)cmd->frame;
 	memset(init_frame, 0, MEGAMFI_FRAME_SIZE);
 
@@ -3931,7 +3933,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int reason)
 			megasas_setup_jbod_map(instance);
 
 			shost_for_each_device(sdev, shost)
-				megasas_update_sdev_properties(sdev);
+				megasas_set_dynamic_target_properties(sdev);
 
 			/* reset stream detection array */
 			if (instance->is_ventura) {
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 9d9658e..9f19f00 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -657,7 +657,7 @@ struct MPI2_IOC_INIT_REQUEST {
 	__le16			HeaderVersion;                  /* 0x0E */
 	u32                     Reserved5;                      /* 0x10 */
 	__le16			Reserved6;                      /* 0x14 */
-	u8                      Reserved7;                      /* 0x16 */
+	u8                      HostPageSize;                   /* 0x16 */
 	u8                      HostMSIxVectors;                /* 0x17 */
 	__le16			Reserved8;                      /* 0x18 */
 	__le16			SystemRequestFrameSize;         /* 0x1A */
-- 
2.8.3
