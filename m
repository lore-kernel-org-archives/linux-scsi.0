From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 4/7] megaraid_sas : Online Firmware upgrade support for Extended VD feature
Date: Mon, 17 Nov 2014 15:24:13 +0530
Message-ID: <201411170957.sAH9vsAv008963@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0076.outbound.protection.outlook.com ([157.56.110.76]:30080
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751936AbaKQJy3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 04:54:29 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

In OCR(Online Controller Reset) path, driver sets adapter state to MEGASAS_HBA_OPERATIONAL before getting new RAID map.
There will be a small window where IO will come from OS with old RAID map.
This patch will update adapter state to MEGASAS_HBA_OPERATIONAL, only after driver has new RAID map to avoid
any IOs getting build using old RAID map.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
 drivers/scsi/megaraid/megaraid_sas.h        |    3 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |   82 +++++++++++++++++++++++----
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   55 +++++-------------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |    2 -
 4 files changed, 85 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 401f4a2..0d44d91 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1931,8 +1931,7 @@ u16 get_updated_dev_handle(struct megasas_instance *instance,
 	struct LD_LOAD_BALANCE_INFO *lbInfo, struct IO_REQUEST_INFO *in_info);
 void mr_update_load_balance_params(struct MR_DRV_RAID_MAP_ALL *map,
 	struct LD_LOAD_BALANCE_INFO *lbInfo);
-int megasas_get_ctrl_info(struct megasas_instance *instance,
-	struct megasas_ctrl_info *ctrl_info);
+int megasas_get_ctrl_info(struct megasas_instance *instance);
 int megasas_set_crash_dump_params(struct megasas_instance *instance,
 	u8 crash_buf_state);
 void megasas_free_host_crash_buffer(struct megasas_instance *instance);
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 3781920..8262067 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -4033,25 +4033,83 @@ megasas_ld_list_query(struct megasas_instance *instance, u8 query_type)
 	return ret;
 }
 
+/*
+ * megasas_update_ext_vd_details : Update details w.r.t Extended VD
+ * instance			 : Controller's instance
+*/
+static void megasas_update_ext_vd_details(struct megasas_instance *instance)
+{
+	struct fusion_context *fusion;
+	u32 old_map_sz;
+	u32 new_map_sz;
+
+	fusion = instance->ctrl_context;
+	/* For MFI based controllers return dummy success */
+	if (!fusion)
+		return;
+
+	instance->supportmax256vd =
+		instance->ctrl_info->adapterOperations3.supportMaxExtLDs;
+	/* Below is additional check to address future FW enhancement */
+	if (instance->ctrl_info->max_lds > 64)
+		instance->supportmax256vd = 1;
+
+	instance->drv_supported_vd_count = MEGASAS_MAX_LD_CHANNELS
+					* MEGASAS_MAX_DEV_PER_CHANNEL;
+	instance->drv_supported_pd_count = MEGASAS_MAX_PD_CHANNELS
+					* MEGASAS_MAX_DEV_PER_CHANNEL;
+	if (instance->supportmax256vd) {
+		instance->fw_supported_vd_count = MAX_LOGICAL_DRIVES_EXT;
+		instance->fw_supported_pd_count = MAX_PHYSICAL_DEVICES;
+	} else {
+		instance->fw_supported_vd_count = MAX_LOGICAL_DRIVES;
+		instance->fw_supported_pd_count = MAX_PHYSICAL_DEVICES;
+	}
+	dev_info(&instance->pdev->dev, "Firmware supports %d VD %d PD\n",
+		instance->fw_supported_vd_count,
+		instance->fw_supported_pd_count);
+	dev_info(&instance->pdev->dev, "Driver supports %d VD  %d PD\n",
+		instance->drv_supported_vd_count,
+		instance->drv_supported_pd_count);
+
+	old_map_sz =  sizeof(struct MR_FW_RAID_MAP) +
+				(sizeof(struct MR_LD_SPAN_MAP) *
+				(instance->fw_supported_vd_count - 1));
+	new_map_sz =  sizeof(struct MR_FW_RAID_MAP_EXT);
+	fusion->drv_map_sz =  sizeof(struct MR_DRV_RAID_MAP) +
+				(sizeof(struct MR_LD_SPAN_MAP) *
+				(instance->drv_supported_vd_count - 1));
+
+	fusion->max_map_sz = max(old_map_sz, new_map_sz);
+
+
+	if (instance->supportmax256vd)
+		fusion->current_map_sz = new_map_sz;
+	else
+		fusion->current_map_sz = old_map_sz;
+
+}
+
 /**
  * megasas_get_controller_info -	Returns FW's controller structure
  * @instance:				Adapter soft state
- * @ctrl_info:				Controller information structure
  *
  * Issues an internal command (DCMD) to get the FW's controller structure.
  * This information is mainly used to find out the maximum IO transfer per
  * command supported by the FW.
  */
 int
-megasas_get_ctrl_info(struct megasas_instance *instance,
-		      struct megasas_ctrl_info *ctrl_info)
+megasas_get_ctrl_info(struct megasas_instance *instance)
 {
 	int ret = 0;
 	struct megasas_cmd *cmd;
 	struct megasas_dcmd_frame *dcmd;
 	struct megasas_ctrl_info *ci;
+	struct megasas_ctrl_info *ctrl_info;
 	dma_addr_t ci_h = 0;
 
+	ctrl_info = instance->ctrl_info;
+
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
@@ -4091,8 +4149,13 @@ megasas_get_ctrl_info(struct megasas_instance *instance,
 	else
 		ret = megasas_issue_polled(instance, cmd);
 
-	if (!ret)
+	if (!ret) {
 		memcpy(ctrl_info, ci, sizeof(struct megasas_ctrl_info));
+		le32_to_cpus((u32 *)&ctrl_info->properties.OnOffProperties);
+		le32_to_cpus((u32 *)&ctrl_info->adapterOperations2);
+		le32_to_cpus((u32 *)&ctrl_info->adapterOperations3);
+		megasas_update_ext_vd_details(instance);
+	}
 
 	pci_free_consistent(instance->pdev, sizeof(struct megasas_ctrl_info),
 			    ci, ci_h);
@@ -4294,7 +4357,7 @@ megasas_init_adapter_mfi(struct megasas_instance *instance)
 	if (megasas_issue_init_mfi(instance))
 		goto fail_fw_init;
 
-	if (megasas_get_ctrl_info(instance, instance->ctrl_info)) {
+	if (megasas_get_ctrl_info(instance)) {
 		dev_err(&instance->pdev->dev, "(%d): Could get controller info "
 			"Fail from %s %d\n", instance->unique_id,
 			__func__, __LINE__);
@@ -4532,12 +4595,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		dev_info(&instance->pdev->dev,
 			"Controller type: iMR\n");
 	}
-	/* OnOffProperties are converted into CPU arch*/
-	le32_to_cpus((u32 *)&ctrl_info->properties.OnOffProperties);
 	instance->disableOnlineCtrlReset =
 	ctrl_info->properties.OnOffProperties.disableOnlineCtrlReset;
-	/* adapterOperations2 are converted into CPU arch*/
-	le32_to_cpus((u32 *)&ctrl_info->adapterOperations2);
 	instance->mpio = ctrl_info->adapterOperations2.mpio;
 	instance->UnevenSpanSupport =
 		ctrl_info->adapterOperations2.supportUnevenSpans;
@@ -4567,7 +4626,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		       "requestorId %d\n", instance->requestorId);
 	}
 
-	le32_to_cpus((u32 *)&ctrl_info->adapterOperations3);
 	instance->crash_dump_fw_support =
 		ctrl_info->adapterOperations3.supportCrashDump;
 	instance->crash_dump_drv_support =
@@ -4592,8 +4650,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (tmp_sectors && (instance->max_sectors_per_req > tmp_sectors))
 		instance->max_sectors_per_req = tmp_sectors;
 
-	kfree(ctrl_info);
-
 	/* Check for valid throttlequeuedepth module parameter */
 	if (instance->is_imr) {
 		if (throttlequeuedepth > (instance->max_fw_cmds -
@@ -5084,6 +5140,8 @@ static int megasas_probe_one(struct pci_dev *pdev,
 			goto fail_alloc_dma_buf;
 		}
 		fusion = instance->ctrl_context;
+		memset(fusion, 0,
+			((1 << PAGE_SHIFT) << instance->ctrl_context_pages));
 		INIT_LIST_HEAD(&fusion->cmd_pool);
 		spin_lock_init(&fusion->mpt_pool_lock);
 		memset(fusion->load_balance_info, 0,
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 92f3354..98dfc1d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1067,48 +1067,16 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 		goto fail_ioc_init;
 
 	megasas_display_intel_branding(instance);
-	if (megasas_get_ctrl_info(instance, instance->ctrl_info)) {
+	if (megasas_get_ctrl_info(instance)) {
 		dev_err(&instance->pdev->dev,
 			"Could not get controller info. Fail from %s %d\n",
 			__func__, __LINE__);
 		goto fail_ioc_init;
 	}
 
-	instance->supportmax256vd =
-		instance->ctrl_info->adapterOperations3.supportMaxExtLDs;
-	/* Below is additional check to address future FW enhancement */
-	if (instance->ctrl_info->max_lds > 64)
-		instance->supportmax256vd = 1;
-	instance->drv_supported_vd_count = MEGASAS_MAX_LD_CHANNELS
-					* MEGASAS_MAX_DEV_PER_CHANNEL;
-	instance->drv_supported_pd_count = MEGASAS_MAX_PD_CHANNELS
-					* MEGASAS_MAX_DEV_PER_CHANNEL;
-	if (instance->supportmax256vd) {
-		instance->fw_supported_vd_count = MAX_LOGICAL_DRIVES_EXT;
-		instance->fw_supported_pd_count = MAX_PHYSICAL_DEVICES;
-	} else {
-		instance->fw_supported_vd_count = MAX_LOGICAL_DRIVES;
-		instance->fw_supported_pd_count = MAX_PHYSICAL_DEVICES;
-	}
-	dev_info(&instance->pdev->dev, "Firmware supports %d VDs %d PDs\n"
-		"Driver supports %d VDs  %d PDs\n",
-		instance->fw_supported_vd_count,
-		instance->fw_supported_pd_count,
-		instance->drv_supported_vd_count,
-		instance->drv_supported_pd_count);
-
 	instance->flag_ieee = 1;
 	fusion->fast_path_io = 0;
 
-	fusion->old_map_sz =
-		sizeof(struct MR_FW_RAID_MAP) + (sizeof(struct MR_LD_SPAN_MAP) *
-		(instance->fw_supported_vd_count - 1));
-	fusion->new_map_sz =
-		sizeof(struct MR_FW_RAID_MAP_EXT);
-	fusion->drv_map_sz =
-		sizeof(struct MR_DRV_RAID_MAP) + (sizeof(struct MR_LD_SPAN_MAP) *
-		(instance->drv_supported_vd_count - 1));
-
 	fusion->drv_map_pages = get_order(fusion->drv_map_sz);
 	for (i = 0; i < 2; i++) {
 		fusion->ld_map[i] = NULL;
@@ -1123,16 +1091,10 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 					fusion->drv_map_pages);
 			goto fail_ioc_init;
 		}
+		memset(fusion->ld_drv_map[i], 0,
+			((1 << PAGE_SHIFT) << fusion->drv_map_pages));
 	}
 
-	fusion->max_map_sz = max(fusion->old_map_sz, fusion->new_map_sz);
-
-	if (instance->supportmax256vd)
-		fusion->current_map_sz = fusion->new_map_sz;
-	else
-		fusion->current_map_sz = fusion->old_map_sz;
-
-
 	for (i = 0; i < 2; i++) {
 		fusion->ld_map[i] = dma_alloc_coherent(&instance->pdev->dev,
 						       fusion->max_map_sz,
@@ -2387,6 +2349,8 @@ megasas_alloc_host_crash_buffer(struct megasas_instance *instance)
 				"memory allocation failed at index %d\n", i);
 			break;
 		}
+		memset(instance->crash_buf[i], 0,
+			((1 << PAGE_SHIFT) << instance->crash_buf_pages));
 	}
 	instance->drv_buf_alloc = i;
 }
@@ -2844,6 +2808,15 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 			instance->instancet->enable_intr(instance);
 			instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
 
+			if (megasas_get_ctrl_info(instance)) {
+				dev_info(&instance->pdev->dev,
+					"Failed from %s %d\n",
+					__func__, __LINE__);
+				instance->adprecovery =
+					MEGASAS_HW_CRITICAL_ERROR;
+				megaraid_sas_kill_hba(instance);
+				retval = FAILED;
+			}
 			/* Reset load balance info */
 			memset(fusion->load_balance_info, 0,
 			       sizeof(struct LD_LOAD_BALANCE_INFO)
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index 92ecd39..5ab7dae 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -836,8 +836,6 @@ struct fusion_context {
 
 	u32 max_map_sz;
 	u32 current_map_sz;
-	u32 old_map_sz;
-	u32 new_map_sz;
 	u32 drv_map_sz;
 	u32 drv_map_pages;
 	u8 fast_path_io;
-- 
1.7.1

