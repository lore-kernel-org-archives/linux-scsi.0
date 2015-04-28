From: Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 3/3] megaraid_sas: use dev_printk when possible
Date: Tue, 28 Apr 2015 18:14:17 -0500
Message-ID: <20150428231417.10378.97464.stgit@bhelgaas-glaptop2.roam.corp.google.com>
References: <20150428231312.10378.49039.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150428231312.10378.49039.stgit@bhelgaas-glaptop2.roam.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kashyap Desai <kashyap.desai@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>
Cc: megaraidlinux.pdl@avagotech.com, "James E.J. Bottomley" <JBottomley@odin.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Use dev_printk() when possible to make messages more useful.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c |   96 ++++++++++++++-------------
 1 file changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 5a0800d..0b20bd8 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -173,7 +173,7 @@ struct megasas_cmd_fusion *megasas_get_cmd_fusion(struct megasas_instance
 				 struct megasas_cmd_fusion, list);
 		list_del_init(&cmd->list);
 	} else {
-		printk(KERN_ERR "megasas: Command pool (fusion) empty!\n");
+		dev_err(&instance->pdev->dev, "Command pool (fusion) empty!\n");
 	}
 
 	spin_unlock_irqrestore(&fusion->mpt_pool_lock, flags);
@@ -244,7 +244,7 @@ static void megasas_teardown_frame_pool_fusion(
 	struct megasas_cmd_fusion *cmd;
 
 	if (!fusion->sg_dma_pool || !fusion->sense_dma_pool) {
-		printk(KERN_ERR "megasas: dma pool is null. SG Pool %p, "
+		dev_err(&instance->pdev->dev, "dma pool is null. SG Pool %p, "
 		       "sense pool : %p\n", fusion->sg_dma_pool,
 		       fusion->sense_dma_pool);
 		return;
@@ -356,7 +356,7 @@ static int megasas_create_frame_pool_fusion(struct megasas_instance *instance)
 					      total_sz_chain_frame, 4,
 					      0);
 	if (!fusion->sg_dma_pool) {
-		printk(KERN_DEBUG "megasas: failed to setup request pool "
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "failed to setup request pool "
 		       "fusion\n");
 		return -ENOMEM;
 	}
@@ -365,7 +365,7 @@ static int megasas_create_frame_pool_fusion(struct megasas_instance *instance)
 						 SCSI_SENSE_BUFFERSIZE, 64, 0);
 
 	if (!fusion->sense_dma_pool) {
-		printk(KERN_DEBUG "megasas: failed to setup sense pool "
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "failed to setup sense pool "
 		       "fusion\n");
 		pci_pool_destroy(fusion->sg_dma_pool);
 		fusion->sg_dma_pool = NULL;
@@ -390,7 +390,7 @@ static int megasas_create_frame_pool_fusion(struct megasas_instance *instance)
 		 * whatever has been allocated
 		 */
 		if (!cmd->sg_frame || !cmd->sense) {
-			printk(KERN_DEBUG "megasas: pci_pool_alloc failed\n");
+			dev_printk(KERN_DEBUG, &instance->pdev->dev, "pci_pool_alloc failed\n");
 			megasas_teardown_frame_pool_fusion(instance);
 			return -ENOMEM;
 		}
@@ -436,7 +436,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 				   &fusion->req_frames_desc_phys, GFP_KERNEL);
 
 	if (!fusion->req_frames_desc) {
-		printk(KERN_ERR "megasas; Could not allocate memory for "
+		dev_err(&instance->pdev->dev, "Could not allocate memory for "
 		       "request_frames\n");
 		goto fail_req_desc;
 	}
@@ -447,7 +447,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 				fusion->reply_alloc_sz * count, 16, 0);
 
 	if (!fusion->reply_frames_desc_pool) {
-		printk(KERN_ERR "megasas; Could not allocate memory for "
+		dev_err(&instance->pdev->dev, "Could not allocate memory for "
 		       "reply_frame pool\n");
 		goto fail_reply_desc;
 	}
@@ -456,7 +456,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 		pci_pool_alloc(fusion->reply_frames_desc_pool, GFP_KERNEL,
 			       &fusion->reply_frames_desc_phys);
 	if (!fusion->reply_frames_desc) {
-		printk(KERN_ERR "megasas; Could not allocate memory for "
+		dev_err(&instance->pdev->dev, "Could not allocate memory for "
 		       "reply_frame pool\n");
 		pci_pool_destroy(fusion->reply_frames_desc_pool);
 		goto fail_reply_desc;
@@ -473,7 +473,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 				fusion->io_frames_alloc_sz, 16, 0);
 
 	if (!fusion->io_request_frames_pool) {
-		printk(KERN_ERR "megasas: Could not allocate memory for "
+		dev_err(&instance->pdev->dev, "Could not allocate memory for "
 		       "io_request_frame pool\n");
 		goto fail_io_frames;
 	}
@@ -482,7 +482,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 		pci_pool_alloc(fusion->io_request_frames_pool, GFP_KERNEL,
 			       &fusion->io_request_frames_phys);
 	if (!fusion->io_request_frames) {
-		printk(KERN_ERR "megasas: Could not allocate memory for "
+		dev_err(&instance->pdev->dev, "Could not allocate memory for "
 		       "io_request_frames frames\n");
 		pci_pool_destroy(fusion->io_request_frames_pool);
 		goto fail_io_frames;
@@ -497,7 +497,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 				   * max_cmd, GFP_KERNEL);
 
 	if (!fusion->cmd_list) {
-		printk(KERN_DEBUG "megasas: out of memory. Could not alloc "
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "out of memory. Could not alloc "
 		       "memory for cmd_list_fusion\n");
 		goto fail_cmd_list;
 	}
@@ -507,7 +507,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 		fusion->cmd_list[i] = kmalloc(sizeof(struct megasas_cmd_fusion),
 					      GFP_KERNEL);
 		if (!fusion->cmd_list[i]) {
-			printk(KERN_ERR "Could not alloc cmd list fusion\n");
+			dev_err(&instance->pdev->dev, "Could not alloc cmd list fusion\n");
 
 			for (j = 0; j < i; j++)
 				kfree(fusion->cmd_list[j]);
@@ -551,7 +551,7 @@ megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 	 * Create a frame pool and assign one frame to each cmd
 	 */
 	if (megasas_create_frame_pool_fusion(instance)) {
-		printk(KERN_DEBUG "megasas: Error creating frame DMA pool\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Error creating frame DMA pool\n");
 		megasas_free_cmds_fusion(instance);
 		goto fail_req_desc;
 	}
@@ -639,7 +639,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_ERR "Could not allocate cmd for INIT Frame\n");
+		dev_err(&instance->pdev->dev, "Could not allocate cmd for INIT Frame\n");
 		ret = 1;
 		goto fail_get_cmd;
 	}
@@ -650,7 +650,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 			     &ioc_init_handle, GFP_KERNEL);
 
 	if (!IOCInitMessage) {
-		printk(KERN_ERR "Could not allocate memory for "
+		dev_err(&instance->pdev->dev, "Could not allocate memory for "
 		       "IOCInitMessage\n");
 		ret = 1;
 		goto fail_fw_init;
@@ -729,7 +729,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 		ret = 1;
 		goto fail_fw_init;
 	}
-	printk(KERN_ERR "megasas:IOC Init cmd success\n");
+	dev_err(&instance->pdev->dev, "Init cmd success\n");
 
 	ret = 0;
 
@@ -772,7 +772,7 @@ megasas_get_ld_map_info(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: Failed to get cmd for map info.\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to get cmd for map info.\n");
 		return -ENOMEM;
 	}
 
@@ -791,7 +791,7 @@ megasas_get_ld_map_info(struct megasas_instance *instance)
 	ci_h = fusion->ld_map_phys[(instance->map_id & 1)];
 
 	if (!ci) {
-		printk(KERN_DEBUG "Failed to alloc mem for ld_map_info\n");
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to alloc mem for ld_map_info\n");
 		megasas_return_cmd(instance, cmd);
 		return -ENOMEM;
 	}
@@ -870,7 +870,7 @@ megasas_sync_map_info(struct megasas_instance *instance)
 	cmd = megasas_get_cmd(instance);
 
 	if (!cmd) {
-		printk(KERN_DEBUG "megasas: Failed to get cmd for sync"
+		dev_printk(KERN_DEBUG, &instance->pdev->dev, "Failed to get cmd for sync"
 		       "info.\n");
 		return -ENOMEM;
 	}
@@ -1107,7 +1107,7 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 						       &fusion->ld_map_phys[i],
 						       GFP_KERNEL);
 		if (!fusion->ld_map[i]) {
-			printk(KERN_ERR "megasas: Could not allocate memory "
+			dev_err(&instance->pdev->dev, "Could not allocate memory "
 			       "for map info\n");
 			goto fail_map_info;
 		}
@@ -1200,7 +1200,7 @@ map_cmd_status(struct megasas_cmd_fusion *cmd, u8 status, u8 ext_status)
 		cmd->scmd->result = DID_IMM_RETRY << 16;
 		break;
 	default:
-		printk(KERN_DEBUG "megasas: FW status %#x\n", status);
+		dev_printk(KERN_DEBUG, &cmd->instance->pdev->dev, "FW status %#x\n", status);
 		cmd->scmd->result = DID_ERROR << 16;
 		break;
 	}
@@ -1852,7 +1852,7 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 					&io_request->SGL, cmd);
 
 	if (sge_count > instance->max_num_sge) {
-		printk(KERN_ERR "megasas: Error. sge_count (0x%x) exceeds "
+		dev_err(&instance->pdev->dev, "Error. sge_count (0x%x) exceeds "
 		       "max (0x%x) allowed\n", sge_count,
 		       instance->max_num_sge);
 		return 1;
@@ -1886,7 +1886,7 @@ megasas_get_request_descriptor(struct megasas_instance *instance, u16 index)
 	struct fusion_context *fusion;
 
 	if (index >= instance->max_fw_cmds) {
-		printk(KERN_ERR "megasas: Invalid SMID (0x%x)request for "
+		dev_err(&instance->pdev->dev, "Invalid SMID (0x%x)request for "
 		       "descriptor for scsi%d\n", index,
 			instance->host->host_no);
 		return NULL;
@@ -1930,7 +1930,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 
 	if (megasas_build_io_fusion(instance, scmd, cmd)) {
 		megasas_return_cmd_fusion(instance, cmd);
-		printk(KERN_ERR "megasas: Error building command.\n");
+		dev_err(&instance->pdev->dev, "Error building command.\n");
 		cmd->request_desc = NULL;
 		return 1;
 	}
@@ -1940,7 +1940,7 @@ megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
 
 	if (cmd->io_request->ChainOffset != 0 &&
 	    cmd->io_request->ChainOffset != 0xF)
-		printk(KERN_ERR "megasas: The chain offset value is not "
+		dev_err(&instance->pdev->dev, "The chain offset value is not "
 		       "correct : %x\n", cmd->io_request->ChainOffset);
 
 	/*
@@ -2028,7 +2028,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 			if (reply_descript_type ==
 			    MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS) {
 				if (megasas_dbg_lvl == 5)
-					printk(KERN_ERR "\nmegasas: FAST Path "
+					dev_err(&instance->pdev->dev, "\nFAST Path "
 					       "IO Success\n");
 			}
 			/* Fall thru and complete IO */
@@ -2193,7 +2193,7 @@ irqreturn_t megasas_isr_fusion(int irq, void *devp)
 			else if (fw_state == MFI_STATE_FAULT)
 				schedule_work(&instance->work_init);
 		} else if (fw_state == MFI_STATE_FAULT) {
-			printk(KERN_WARNING "megaraid_sas: Iop2SysDoorbellInt"
+			dev_warn(&instance->pdev->dev, "Iop2SysDoorbellInt"
 			       "for scsi%d\n", instance->host->host_no);
 			schedule_work(&instance->work_init);
 		}
@@ -2290,7 +2290,7 @@ build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 	u16 index;
 
 	if (build_mpt_mfi_pass_thru(instance, cmd)) {
-		printk(KERN_ERR "Couldn't build MFI pass thru cmd\n");
+		dev_err(&instance->pdev->dev, "Couldn't build MFI pass thru cmd\n");
 		return NULL;
 	}
 
@@ -2324,7 +2324,7 @@ megasas_issue_dcmd_fusion(struct megasas_instance *instance,
 
 	req_desc = build_mpt_cmd(instance, cmd);
 	if (!req_desc) {
-		printk(KERN_ERR "Couldn't issue MFI pass thru cmd\n");
+		dev_err(&instance->pdev->dev, "Couldn't issue MFI pass thru cmd\n");
 		return;
 	}
 	atomic_set(&cmd->mfi_mpt_pthr, MFI_MPT_ATTACHED);
@@ -2436,7 +2436,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 		fw_state = instance->instancet->read_fw_status_reg(
 			instance->reg_set) & MFI_STATE_MASK;
 		if (fw_state == MFI_STATE_FAULT) {
-			printk(KERN_WARNING "megasas: Found FW in FAULT state,"
+			dev_warn(&instance->pdev->dev, "Found FW in FAULT state,"
 			       " will reset adapter scsi%d.\n",
 				instance->host->host_no);
 			retval = 1;
@@ -2459,7 +2459,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 				hb_seconds_missed++;
 				if (hb_seconds_missed ==
 				    (MEGASAS_SRIOV_HEARTBEAT_INTERVAL_VF/HZ)) {
-					printk(KERN_WARNING "megasas: SR-IOV:"
+					dev_warn(&instance->pdev->dev, "SR-IOV:"
 					       " Heartbeat never completed "
 					       " while polling during I/O "
 					       " timeout handling for "
@@ -2477,7 +2477,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 			goto out;
 
 		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
-			printk(KERN_NOTICE "megasas: [%2d]waiting for %d "
+			dev_notice(&instance->pdev->dev, "[%2d]waiting for %d "
 			       "commands to complete for scsi%d\n", i,
 			       outstanding, instance->host->host_no);
 			megasas_complete_cmd_dpc_fusion(
@@ -2487,7 +2487,7 @@ int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance,
 	}
 
 	if (atomic_read(&instance->fw_outstanding)) {
-		printk("megaraid_sas: pending commands remain after waiting, "
+		dev_err(&instance->pdev->dev, "pending commands remain after waiting, "
 		       "will reset adapter scsi%d.\n",
 		       instance->host->host_no);
 		retval = 1;
@@ -2553,7 +2553,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 	mutex_lock(&instance->reset_mutex);
 
 	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
-		printk(KERN_WARNING "megaraid_sas: Hardware critical error, "
+		dev_warn(&instance->pdev->dev, "Hardware critical error, "
 		       "returning FAILED for scsi%d.\n",
 			instance->host->host_no);
 		mutex_unlock(&instance->reset_mutex);
@@ -2607,7 +2607,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 	if (megasas_wait_for_outstanding_fusion(instance, iotimeout,
 						&convert)) {
 		instance->adprecovery = MEGASAS_ADPRESET_SM_INFAULT;
-		printk(KERN_WARNING "megaraid_sas: resetting fusion "
+		dev_warn(&instance->pdev->dev, "resetting fusion "
 		       "adapter scsi%d.\n", instance->host->host_no);
 		if (convert)
 			iotimeout = 0;
@@ -2633,7 +2633,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 		if (instance->disableOnlineCtrlReset ||
 		    (abs_state == MFI_STATE_FAULT && !reset_adapter)) {
 			/* Reset not supported, kill adapter */
-			printk(KERN_WARNING "megaraid_sas: Reset not supported"
+			dev_warn(&instance->pdev->dev, "Reset not supported"
 			       ", killing adapter scsi%d.\n",
 				instance->host->host_no);
 			megaraid_sas_kill_hba(instance);
@@ -2651,7 +2651,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 			     instance->hb_host_mem->HB.driverCounter)) {
 					instance->hb_host_mem->HB.driverCounter =
 						instance->hb_host_mem->HB.fwCounter;
-					printk(KERN_WARNING "megasas: SR-IOV:"
+					dev_warn(&instance->pdev->dev, "SR-IOV:"
 					       "Late FW heartbeat update for "
 					       "scsi%d.\n",
 					       instance->host->host_no);
@@ -2667,8 +2667,8 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 					abs_state = status_reg &
 						MFI_STATE_MASK;
 					if (abs_state == MFI_STATE_READY) {
-						printk(KERN_WARNING "megasas"
-						       ": SR-IOV: FW was found"
+						dev_warn(&instance->pdev->dev,
+						       "SR-IOV: FW was found"
 						       "to be in ready state "
 						       "for scsi%d.\n",
 						       instance->host->host_no);
@@ -2677,7 +2677,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 					msleep(20);
 				}
 				if (abs_state != MFI_STATE_READY) {
-					printk(KERN_WARNING "megasas: SR-IOV: "
+					dev_warn(&instance->pdev->dev, "SR-IOV: "
 					       "FW not in ready state after %d"
 					       " seconds for scsi%d, status_reg = "
 					       "0x%x.\n",
@@ -2719,7 +2719,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 				host_diag =
 				readl(&instance->reg_set->fusion_host_diag);
 				if (retry++ == 100) {
-					printk(KERN_WARNING "megaraid_sas: "
+					dev_warn(&instance->pdev->dev,
 					       "Host diag unlock failed! "
 					       "for scsi%d\n",
 						instance->host->host_no);
@@ -2742,7 +2742,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 				host_diag =
 				readl(&instance->reg_set->fusion_host_diag);
 				if (retry++ == 1000) {
-					printk(KERN_WARNING "megaraid_sas: "
+					dev_warn(&instance->pdev->dev,
 					       "Diag reset adapter never "
 					       "cleared for scsi%d!\n",
 						instance->host->host_no);
@@ -2765,7 +2765,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 					instance->reg_set) & MFI_STATE_MASK;
 			}
 			if (abs_state <= MFI_STATE_FW_INIT) {
-				printk(KERN_WARNING "megaraid_sas: firmware "
+				dev_warn(&instance->pdev->dev, "firmware "
 				       "state < MFI_STATE_FW_INIT, state = "
 				       "0x%x for scsi%d\n", abs_state,
 					instance->host->host_no);
@@ -2774,7 +2774,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 
 			/* Wait for FW to become ready */
 			if (megasas_transition_to_ready(instance, 1)) {
-				printk(KERN_WARNING "megaraid_sas: Failed to "
+				dev_warn(&instance->pdev->dev, "Failed to "
 				       "transition controller to ready "
 				       "for scsi%d.\n",
 				       instance->host->host_no);
@@ -2783,7 +2783,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 
 			megasas_reset_reply_desc(instance);
 			if (megasas_ioc_init_fusion(instance)) {
-				printk(KERN_WARNING "megaraid_sas: "
+				dev_warn(&instance->pdev->dev,
 				       "megasas_ioc_init_fusion() failed!"
 				       " for scsi%d\n",
 				       instance->host->host_no);
@@ -2808,7 +2808,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 							cmd_mfi->context.smid
 							-1);
 						if (!req_desc) {
-							printk(KERN_WARNING
+							dev_warn(&instance->pdev->dev,
 							       "req_desc NULL"
 							       " for scsi%d\n",
 								instance->host->host_no);
@@ -2861,7 +2861,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 			}
 
 			/* Adapter reset completed successfully */
-			printk(KERN_WARNING "megaraid_sas: Reset "
+			dev_warn(&instance->pdev->dev, "Reset "
 			       "successful for scsi%d.\n",
 				instance->host->host_no);
 
@@ -2877,7 +2877,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 			goto out;
 		}
 		/* Reset failed, kill the adapter */
-		printk(KERN_WARNING "megaraid_sas: Reset failed, killing "
+		dev_warn(&instance->pdev->dev, "Reset failed, killing "
 		       "adapter scsi%d.\n", instance->host->host_no);
 		megaraid_sas_kill_hba(instance);
 		instance->skip_heartbeat_timer_del = 1;
