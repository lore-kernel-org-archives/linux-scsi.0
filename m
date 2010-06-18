From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: [PATCH 5/12] scsi: megaraid_sas - Online Controller Reset (OCR):
 Add and initialize the OCR relaed variable
Date: Fri, 18 Jun 2010 14:49:36 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C3D092748C@cosmail02.lsi.com>
References: <4B6A08C587958942AA3002690DD4F8C3D0804554@cosmail02.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4B6A08C587958942AA3002690DD4F8C3D0804554@cosmail02.lsi.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>, "'James.Bottomley@HansenPartnership.com'" <James.Bottomley@HansenPartnership.com>, "'James.Bottomley@suse.de'" <James.Bottomley@suse.de>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "'akpm@osdl.org'" <akpm@osdl.org>, "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

RE_SUBMIT: fix the " OnOffProperties structure is defined in patch 6/12 as is the process_fw_state_change_wq function".

To support online controller reset, driver need to define some instance based variable and initialize them.

Signed-off-by Bo Yang<bo.yang@lsi.com>

---
drivers/scsi/megaraid/megaraid_sas.c |   89 ++++++++++++++++++++++-------------
 drivers/scsi/megaraid/megaraid_sas.h |   40 ++++++++++++++-
 2 files changed, 94 insertions(+), 35 deletions(-)

diff -rupN old/drivers/scsi/megaraid/megaraid_sas.c new/drivers/scsi/megaraid/megaraid_sas.c
--- old/drivers/scsi/megaraid/megaraid_sas.c	2010-06-17 07:51:23.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.c	2010-06-17 08:08:27.000000000 -0400
@@ -1471,18 +1471,6 @@ static int megasas_slave_alloc(struct sc
 	return 0;
 }
 
-static void megaraid_sas_kill_hba(struct megasas_instance *instance)
-{
-	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
-		writel(MFI_STOP_ADP,
-			&instance->reg_set->reserved_0[0]);
-	} else {
-		writel(MFI_STOP_ADP,
-			&instance->reg_set->inbound_doorbell);
-	}
-}
-
 /**
  * megasas_complete_cmd_dpc	 -	Returns FW's controller structure
  * @instance_addr:			Address of adapter soft state
@@ -1856,7 +1844,8 @@ megasas_service_aen(struct megasas_insta
 	instance->aen_cmd = NULL;
 	megasas_return_cmd(instance, cmd);
 
-	if (instance->unload == 0) {
+	if ((instance->unload == 0) &&
+		((instance->issuepend_done == 1))) {
 		struct megasas_aen_event *ev;
 		ev = kzalloc(sizeof(*ev), GFP_ATOMIC);
 		if (!ev) {
@@ -1951,6 +1940,9 @@ megasas_complete_cmd(struct megasas_inst
 	struct megasas_header *hdr = &cmd->frame->hdr;
 	unsigned long flags;
 
+	/* flag for the retry reset */
+	cmd->retry_for_fw_reset = 0;
+
 	if (cmd->scmd)
 		cmd->scmd->SCp.ptr = NULL;
 
@@ -2076,27 +2068,28 @@ megasas_complete_cmd(struct megasas_inst
  * @alt_status:				Alternate status to be returned to
  * 					SCSI mid-layer instead of the status
  * 					returned by the FW
+ * Note: this must be called with hba lock held
  */
 static int
-megasas_deplete_reply_queue(struct megasas_instance *instance, u8 alt_status)
+megasas_deplete_reply_queue(struct megasas_instance *instance,
+					u8 alt_status)
 {
-	/*
-	 * Check if it is our interrupt
-	 * Clear the interrupt 
-	 */
-	if(instance->instancet->clear_intr(instance->reg_set))
+	u32 mfiStatus;
+
+	if ((mfiStatus = instance->instancet->check_reset(instance,
+					instance->reg_set)) == 1) {
+		return IRQ_HANDLED;
+	}
+
+	if ((mfiStatus = instance->instancet->clear_intr(
+						instance->reg_set)
+						) == 0) {
 		return IRQ_NONE;
+	}
 
-	if (instance->hw_crit_error)
-		goto out_done;
-        /*
-	 * Schedule the tasklet for cmd completion
-	 */
 	tasklet_schedule(&instance->isr_tasklet);
-out_done:
 	return IRQ_HANDLED;
 }
-
 /**
  * megasas_isr - isr entry point
  */
@@ -2260,7 +2253,7 @@ megasas_transition_to_ready(struct megas
 			       "in %d secs\n", fw_state, max_wait);
 			return -ENODEV;
 		}
-	};
+	}
  	printk(KERN_INFO "megasas: FW now in Ready state\n");
 
 	return 0;
@@ -2342,6 +2335,7 @@ static int megasas_create_frame_pool(str
 	 */
 	sgl_sz = sge_sz * instance->max_num_sge;
 	frame_count = (sgl_sz + MEGAMFI_FRAME_SIZE - 1) / MEGAMFI_FRAME_SIZE;
+	frame_count = 15;
 
 	/*
 	 * We need one extra frame for the MFI command
@@ -2489,6 +2483,7 @@ static int megasas_alloc_cmds(struct meg
 		cmd = instance->cmd_list[i];
 		memset(cmd, 0, sizeof(struct megasas_cmd));
 		cmd->index = i;
+		cmd->scmd = NULL;
 		cmd->instance = instance;
 
 		list_add_tail(&cmd->list, &instance->cmd_pool);
@@ -2656,7 +2651,7 @@ megasas_get_ld_list(struct megasas_insta
 
 	/* the following function will get the instance PD LIST */
 
-	if ((ret == 0) && (ci->ldCount < MAX_LOGICAL_DRIVES)) {
+	if ((ret == 0) && (ci->ldCount <= MAX_LOGICAL_DRIVES)) {
 		memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
 
 		for (ld_index = 0; ld_index < ci->ldCount; ld_index++) {
@@ -2970,6 +2965,21 @@ static int megasas_init_mfi(struct megas
 	if (megasas_issue_init_mfi(instance))
 		goto fail_fw_init;
 
+	instance->fw_support_ieee = 0;
+	instance->fw_support_ieee =
+		(instance->instancet->read_fw_status_reg(reg_set) &
+		0x04000000);
+
+	printk(KERN_NOTICE "megasas_init_mfi: fw_support_ieee=%d",
+			instance->fw_support_ieee);
+
+	if (instance->fw_support_ieee)
+		instance->flag_ieee = 1;
+
+	/** for passthrough
+	* the following function will get the PD LIST.
+	*/
+
 	memset(instance->pd_list, 0 ,
 		(MEGASAS_MAX_PD * sizeof(struct megasas_pd_list)));
 	megasas_get_pd_list(instance);
@@ -2996,6 +3006,8 @@ static int megasas_init_mfi(struct megas
 		max_sectors_2 = ctrl_info->max_request_size;
 
 		tmp_sectors = min_t(u32, max_sectors_1 , max_sectors_2);
+		instance->disableOnlineCtrlReset =
+		ctrl_info->properties.OnOffProperties.disableOnlineCtrlReset;
 	}
 
 	instance->max_sectors_per_req = instance->max_num_sge *
@@ -3217,6 +3229,7 @@ megasas_register_aen(struct megasas_inst
 	dcmd->flags = MFI_FRAME_DIR_READ;
 	dcmd->timeout = 0;
 	dcmd->pad_0 = 0;
+	instance->last_seq_num = seq_num;
 	dcmd->data_xfer_len = sizeof(struct megasas_evt_detail);
 	dcmd->opcode = MR_DCMD_CTRL_EVENT_WAIT;
 	dcmd->mbox.w[0] = seq_num;
@@ -3385,6 +3398,7 @@ megasas_probe_one(struct pci_dev *pdev, 
 
 	instance = (struct megasas_instance *)host->hostdata;
 	memset(instance, 0, sizeof(*instance));
+	atomic_set( &instance->fw_reset_no_pci_access, 0 );
 
 	instance->producer = pci_alloc_consistent(pdev, sizeof(u32),
 						  &instance->producer_h);
@@ -3402,6 +3416,9 @@ megasas_probe_one(struct pci_dev *pdev, 
 	megasas_poll_wait_aen = 0;
 	instance->flag_ieee = 0;
 	instance->ev = NULL;
+	instance->issuepend_done = 1;
+	instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
+	megasas_poll_wait_aen = 0;
 
 	instance->evt_detail = pci_alloc_consistent(pdev,
 						    sizeof(struct
@@ -3451,6 +3468,7 @@ megasas_probe_one(struct pci_dev *pdev, 
 	instance->flag = 0;
 	instance->unload = 1;
 	instance->last_time = 0;
+	instance->disableOnlineCtrlReset = 1;
 
 	/*
 	 * Initialize MFI Firmware
@@ -3542,6 +3560,9 @@ static void megasas_flush_cache(struct m
 	struct megasas_cmd *cmd;
 	struct megasas_dcmd_frame *dcmd;
 
+	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR)
+		return;
+
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd)
@@ -3579,6 +3600,9 @@ static void megasas_shutdown_controller(
 	struct megasas_cmd *cmd;
 	struct megasas_dcmd_frame *dcmd;
 
+	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR)
+		return;
+
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd)
@@ -4086,8 +4110,8 @@ static int megasas_mgmt_ioctl_fw(struct 
 		goto out_kfree_ioc;
 	}
 
-	if (instance->hw_crit_error == 1) {
-		printk(KERN_DEBUG "Controller in Crit ERROR\n");
+	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
+		printk(KERN_ERR "Controller in crit error\n");
 		error = -ENODEV;
 		goto out_kfree_ioc;
 	}
@@ -4104,6 +4128,7 @@ static int megasas_mgmt_ioctl_fw(struct 
 		error = -ERESTARTSYS;
 		goto out_kfree_ioc;
 	}
+
 	error = megasas_mgmt_fw_ioctl(instance, user_ioc, ioc);
 	up(&instance->ioctl_sem);
 
@@ -4132,8 +4157,8 @@ static int megasas_mgmt_ioctl_aen(struct
 	if (!instance)
 		return -ENODEV;
 
-	if (instance->hw_crit_error == 1) {
-		error = -ENODEV;
+	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
+		return -ENODEV;
 	}
 
 	if (instance->unload == 1) {
diff -rupN old/drivers/scsi/megaraid/megaraid_sas.h new/drivers/scsi/megaraid/megaraid_sas.h
--- old/drivers/scsi/megaraid/megaraid_sas.h	2010-06-17 07:51:23.000000000 -0400
+++ new/drivers/scsi/megaraid/megaraid_sas.h	2010-06-17 08:08:33.000000000 -0400
@@ -60,6 +60,7 @@
 #define MFI_STATE_READY				0xB0000000
 #define MFI_STATE_OPERATIONAL			0xC0000000
 #define MFI_STATE_FAULT				0xF0000000
+#define  MFI_RESET_REQUIRED			0x00000001
 
 #define MEGAMFI_FRAME_SIZE			64
 
@@ -408,8 +409,34 @@ struct megasas_ctrl_prop {
 	u16 ecc_bucket_leak_rate;
 	u8 restore_hotspare_on_insertion;
 	u8 expose_encl_devices;
-	u8 reserved[38];
+	u8 maintainPdFailHistory;
+	u8 disallowHostRequestReordering;
+	u8 abortCCOnError;
+	u8 loadBalanceMode;
+	u8 disableAutoDetectBackplane;
+	u8 snapVDSpace;
 
+	struct {
+		u32     copyBackDisabled            : 1;
+		u32     SMARTerEnabled              : 1;
+		u32     prCorrectUnconfiguredAreas  : 1;
+		u32     useFdeOnly                  : 1;
+		u32     disableNCQ                  : 1;
+		u32     SSDSMARTerEnabled           : 1;
+		u32     SSDPatrolReadEnabled        : 1;
+		u32     enableSpinDownUnconfigured  : 1;
+		u32     autoEnhancedImport          : 1;
+		u32     enableSecretKeyControl      : 1;
+		u32     disableOnlineCtrlReset      : 1;
+		u32     allowBootWithPinnedCache    : 1;
+		u32     disableSpinDownHS           : 1;
+		u32     enableJBOD                  : 1;
+		u32     reserved                    :18;
+	} OnOffProperties;
+	u8 autoSnapVDSpace;
+	u8 viewSpace;
+	u16 spinDownTime;
+	u8  reserved[24];
 } __packed;
 
 /*
@@ -1265,19 +1292,24 @@ struct megasas_instance {
 
 	struct pci_dev *pdev;
 	u32 unique_id;
+	u32 fw_support_ieee;
 
 	atomic_t fw_outstanding;
-	u32 hw_crit_error;
+	atomic_t fw_reset_no_pci_access;
 
 	struct megasas_instance_template *instancet;
 	struct tasklet_struct isr_tasklet;
+	struct work_struct work_init;
 
 	u8 flag;
 	u8 unload;
 	u8 flag_ieee;
 	u8 issuepend_done;
+	u8 disableOnlineCtrlReset;
 	u8 adprecovery;
 	unsigned long last_time;
+	u32 mfiStatus;
+	u32 last_seq_num;
 
 	struct timer_list io_completion_timer;
 	struct list_head internal_reset_pending_q;
@@ -1325,7 +1357,9 @@ struct megasas_cmd {
 	u32 index;
 	u8 sync_cmd;
 	u8 cmd_status;
-	u16 abort_aen;
+	u8 abort_aen;
+	u8 retry_for_fw_reset;
+
 
 	struct list_head list;
 	struct scsi_cmnd *scmd;
