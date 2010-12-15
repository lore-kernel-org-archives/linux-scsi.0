From: adam radford <aradford@gmail.com>
Subject: [PATCH 6/11]: megaraid_sas: Add MegaRAID 9265/9285 specific code to megaraid_sas_base.c
Date: Tue, 14 Dec 2010 19:01:17 -0800
Message-ID: <AANLkTino3AQrLzMj9XBgSr30ayAMju0k+gr3CxYc9PVn@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00163683204e9f56a404976a26b6
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52202 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754748Ab0LODBS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2010 22:01:18 -0500
Received: by qwa26 with SMTP id 26so1488636qwa.19
        for <linux-scsi@vger.kernel.org>; Tue, 14 Dec 2010 19:01:17 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--00163683204e9f56a404976a26b6
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

This patch adds MegaRAID 9265/9285 (Device id 0x5b) specific code to
megaraid_sas_base.c.

Signed-off-by: Adam Radford <aradford@gmail.com>

Note: Patches 6 thru 10 have to be applied at once in order to build.

Note: The patch has been included in-line below, and also as an
attachment in case Gmail hoses the patch.

diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_base.c	2010-12-14
17:06:01.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2010-12-14
17:08:32.000000000 -0800
@@ -53,6 +53,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_device.h>
 #include <scsi/scsi_host.h>
+#include "megaraid_sas_fusion.h"
 #include "megaraid_sas.h"

 /*
@@ -81,7 +82,7 @@
 MODULE_AUTHOR("megaraidlinux@lsi.com");
 MODULE_DESCRIPTION("LSI MegaRAID SAS Driver");

-static int megasas_transition_to_ready(struct megasas_instance *instance);
+int megasas_transition_to_ready(struct megasas_instance *instance);
 static int megasas_get_pd_list(struct megasas_instance *instance);
 static int megasas_issue_init_mfi(struct megasas_instance *instance);
 static int megasas_register_aen(struct megasas_instance *instance,
@@ -109,6 +110,8 @@
 	/* xscale IOP, vega */
 	{PCI_DEVICE(PCI_VENDOR_ID_DELL, PCI_DEVICE_ID_DELL_PERC5)},
 	/* xscale IOP */
+	{PCI_DEVICE(PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_FUSION)},
+	/* Fusion */
 	{}
 };

@@ -122,15 +125,16 @@
 static int megasas_poll_wait_aen;
 static DECLARE_WAIT_QUEUE_HEAD(megasas_poll_wait);
 static u32 support_poll_for_event;
-static u32 megasas_dbg_lvl;
+u32 megasas_dbg_lvl;
 static u32 support_device_change;

 /* define lock for aen poll */
 spinlock_t poll_aen_lock;

-static void
+void
 megasas_complete_cmd(struct megasas_instance *instance, struct
megasas_cmd *cmd,
 		     u8 alt_status);
+
 static irqreturn_t megasas_isr(int irq, void *devp);
 static u32
 megasas_init_adapter_mfi(struct megasas_instance *instance);
@@ -138,6 +142,23 @@
 megasas_build_and_issue_cmd(struct megasas_instance *instance,
 			    struct scsi_cmnd *scmd);
 static void megasas_complete_cmd_dpc(unsigned long instance_addr);
+void
+megasas_release_fusion(struct megasas_instance *instance);
+int
+megasas_ioc_init_fusion(struct megasas_instance *instance);
+void
+megasas_free_cmds_fusion(struct megasas_instance *instance);
+u8
+megasas_get_map_info(struct megasas_instance *instance);
+int
+megasas_sync_map_info(struct megasas_instance *instance);
+int
+wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd);
+void megasas_reset_reply_desc(struct megasas_instance *instance);
+u8 MR_ValidateMapInfo(struct MR_FW_RAID_MAP_ALL *map,
+		      struct LD_LOAD_BALANCE_INFO *lbInfo);
+int megasas_reset_fusion(struct scsi_cmnd *scmd);
+void megasas_fusion_ocr_wq(struct work_struct *work);

 void
 megasas_issue_dcmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
@@ -152,7 +173,7 @@
  *
  * Returns a free command from the pool
  */
-static struct megasas_cmd *megasas_get_cmd(struct megasas_instance
+struct megasas_cmd *megasas_get_cmd(struct megasas_instance
 						  *instance)
 {
 	unsigned long flags;
@@ -177,7 +198,7 @@
  * @instance:		Adapter soft state
  * @cmd:		Command packet to be returned to free command pool
  */
-static inline void
+inline void
 megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
 {
 	unsigned long flags;
@@ -185,6 +206,7 @@
 	spin_lock_irqsave(&instance->cmd_pool_lock, flags);

 	cmd->scmd = NULL;
+	cmd->frame_count = 0;
 	list_add_tail(&cmd->list, &instance->cmd_pool);

 	spin_unlock_irqrestore(&instance->cmd_pool_lock, flags);
@@ -796,6 +818,11 @@
 *       specific to gen2 (deviceid : 0x78, 0x79) controllers
 */

+/*
+ * Template added for TB (Fusion)
+ */
+extern struct megasas_instance_template megasas_instance_template_fusion;
+
 /**
  * megasas_issue_polled -	Issues a polling command
  * @instance:			Adapter soft state
@@ -803,11 +830,9 @@
  *
  * For polling, MFI requires the cmd_status to be set to 0xFF before posting.
  */
-static int
+int
 megasas_issue_polled(struct megasas_instance *instance, struct
megasas_cmd *cmd)
 {
-	int i;
-	u32 msecs = MFI_POLL_TIMEOUT_SECS * 1000;

 	struct megasas_header *frame_hdr = &cmd->frame->hdr;

@@ -817,21 +842,12 @@
 	/*
 	 * Issue the frame using inbound queue port
 	 */
-	instance->instancet->fire_cmd(instance,
-			cmd->frame_phys_addr, 0, instance->reg_set);
+	instance->instancet->issue_dcmd(instance, cmd);

 	/*
 	 * Wait for cmd_status to change
 	 */
-	for (i = 0; (i < msecs) && (frame_hdr->cmd_status == 0xff); i++) {
-		rmb();
-		msleep(1);
-	}
-
-	if (frame_hdr->cmd_status == 0xff)
-		return -ETIME;
-
-	return 0;
+	return wait_and_poll(instance, cmd);
 }

 /**
@@ -849,8 +865,7 @@
 {
 	cmd->cmd_status = ENODATA;

-	instance->instancet->fire_cmd(instance,
-			cmd->frame_phys_addr, 0, instance->reg_set);
+	instance->instancet->issue_dcmd(instance, cmd);

 	wait_event(instance->int_cmd_wait_q, cmd->cmd_status != ENODATA);

@@ -894,8 +909,7 @@
 	cmd->sync_cmd = 1;
 	cmd->cmd_status = 0xFF;

-	instance->instancet->fire_cmd(instance,
-			cmd->frame_phys_addr, 0, instance->reg_set);
+	instance->instancet->issue_dcmd(instance, cmd);

 	/*
 	 * Wait for this cmd to complete
@@ -1291,7 +1305,7 @@
  * Called by megasas_queue_command to find out if the command to be queued
  * is a logical drive command	
  */
-static inline int megasas_is_ldio(struct scsi_cmnd *cmd)
+inline int megasas_is_ldio(struct scsi_cmnd *cmd)
 {
 	if (!MEGASAS_IS_LOGICAL(cmd))
 		return 0;
@@ -1551,15 +1565,44 @@
 	return 0;
 }

-static void megaraid_sas_kill_hba(struct megasas_instance *instance)
+void megaraid_sas_kill_hba(struct megasas_instance *instance)
 {
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
-		writel(MFI_STOP_ADP,
-			&instance->reg_set->reserved_0[0]);
+	    (instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY) ||
+	    (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION)) {
+		writel(MFI_STOP_ADP, &instance->reg_set->doorbell);
 	} else {
-		writel(MFI_STOP_ADP,
-			&instance->reg_set->inbound_doorbell);
+		writel(MFI_STOP_ADP, &instance->reg_set->inbound_doorbell);
+	}
+}
+
+ /**
+  * megasas_check_and_restore_queue_depth - Check if queue depth needs to be
+  *					restored to max value
+  * @instance:			Adapter soft state
+  *
+  */
+void
+megasas_check_and_restore_queue_depth(struct megasas_instance *instance)
+{
+	unsigned long flags;
+	if (instance->flag & MEGASAS_FW_BUSY
+		&& time_after(jiffies, instance->last_time + 5 * HZ)
+		&& atomic_read(&instance->fw_outstanding) < 17) {
+
+		spin_lock_irqsave(instance->host->host_lock, flags);
+		instance->flag &= ~MEGASAS_FW_BUSY;
+		if ((instance->pdev->device ==
+			PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+			(instance->pdev->device ==
+			PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+			instance->host->can_queue =
+				instance->max_fw_cmds - MEGASAS_SKINNY_INT_CMDS;
+		} else
+			instance->host->can_queue =
+				instance->max_fw_cmds - MEGASAS_INT_CMDS;
+
+		spin_unlock_irqrestore(instance->host->host_lock, flags);
 	}
 }

@@ -1613,24 +1656,7 @@
 	/*
 	 * Check if we can restore can_queue
 	 */
-	if (instance->flag & MEGASAS_FW_BUSY
-		&& time_after(jiffies, instance->last_time + 5 * HZ)
-		&& atomic_read(&instance->fw_outstanding) < 17) {
-
-		spin_lock_irqsave(instance->host->host_lock, flags);
-		instance->flag &= ~MEGASAS_FW_BUSY;
-		if ((instance->pdev->device ==
-			PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
-			(instance->pdev->device ==
-			PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
-			instance->host->can_queue =
-				instance->max_fw_cmds - MEGASAS_SKINNY_INT_CMDS;
-		} else
-			instance->host->can_queue =
-				instance->max_fw_cmds - MEGASAS_INT_CMDS;
-
-		spin_unlock_irqrestore(instance->host->host_lock, flags);
-	}
+	megasas_check_and_restore_queue_depth(instance);
 }

 static void
@@ -1808,7 +1834,7 @@
 			(instance->pdev->device ==
 			PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
 			writel(MFI_STOP_ADP,
-				&instance->reg_set->reserved_0[0]);
+				&instance->reg_set->doorbell);
 		} else {
 			writel(MFI_STOP_ADP,
 				&instance->reg_set->inbound_doorbell);
@@ -1912,11 +1938,16 @@
 static int megasas_reset_bus_host(struct scsi_cmnd *scmd)
 {
 	int ret;
+	struct megasas_instance *instance;
+	instance = (struct megasas_instance *)scmd->device->host->hostdata;

 	/*
 	 * First wait for all commands to complete
 	 */
-	ret = megasas_generic_reset(scmd);
+	if (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION)
+		ret = megasas_reset_fusion(scmd);
+	else
+		ret = megasas_generic_reset(scmd);

 	return ret;
 }
@@ -2086,13 +2117,14 @@
  * 				an alternate status (as in the case of aborted
  * 				commands)
  */
-static void
+void
 megasas_complete_cmd(struct megasas_instance *instance, struct
megasas_cmd *cmd,
 		     u8 alt_status)
 {
 	int exception = 0;
 	struct megasas_header *hdr = &cmd->frame->hdr;
 	unsigned long flags;
+	struct fusion_context *fusion = instance->ctrl_context;

 	/* flag for the retry reset */
 	cmd->retry_for_fw_reset = 0;
@@ -2185,6 +2217,37 @@
 	case MFI_CMD_SMP:
 	case MFI_CMD_STP:
 	case MFI_CMD_DCMD:
+		/* Check for LD map update */
+		if ((cmd->frame->dcmd.opcode == MR_DCMD_LD_MAP_GET_INFO) &&
+		    (cmd->frame->dcmd.mbox.b[1] == 1)) {
+			spin_lock_irqsave(instance->host->host_lock, flags);
+			if (cmd->frame->hdr.cmd_status != 0) {
+				if (cmd->frame->hdr.cmd_status !=
+				    MFI_STAT_NOT_FOUND)
+					printk(KERN_WARNING "megasas: map sync"
+					       "failed, status = 0x%x.\n",
+					       cmd->frame->hdr.cmd_status);
+				else {
+					megasas_return_cmd(instance, cmd);
+					spin_unlock_irqrestore(
+						instance->host->host_lock,
+						flags);
+					break;
+				}
+			} else
+				instance->map_id++;
+			megasas_return_cmd(instance, cmd);
+			if (MR_ValidateMapInfo(
+				    fusion->ld_map[(instance->map_id & 1)],
+				    fusion->load_balance_info))
+				fusion->fast_path_io = 1;
+			else
+				fusion->fast_path_io = 0;
+			megasas_sync_map_info(instance);
+			spin_unlock_irqrestore(instance->host->host_lock,
+					       flags);
+			break;
+		}
 		if (cmd->frame->dcmd.opcode == MR_DCMD_CTRL_EVENT_GET_INFO ||
 			cmd->frame->dcmd.opcode == MR_DCMD_CTRL_EVENT_GET) {
 			spin_lock_irqsave(&poll_aen_lock, flags);
@@ -2523,7 +2586,7 @@
  * states, driver must take steps to bring it to ready state. Otherwise, it
  * has to wait for the ready state.
  */
-static int
+int
 megasas_transition_to_ready(struct megasas_instance* instance)
 {
 	int i;
@@ -2557,11 +2620,12 @@
 			if ((instance->pdev->device ==
 				PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
 				(instance->pdev->device ==
-				PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
-
+				 PCI_DEVICE_ID_LSI_SAS0071SKINNY) ||
+				(instance->pdev->device ==
+				 PCI_DEVICE_ID_LSI_FUSION)) {
 				writel(
 				  MFI_INIT_CLEAR_HANDSHAKE|MFI_INIT_HOTPLUG,
-				  &instance->reg_set->reserved_0[0]);
+				  &instance->reg_set->doorbell);
 			} else {
 				writel(
 				    MFI_INIT_CLEAR_HANDSHAKE|MFI_INIT_HOTPLUG,
@@ -2574,11 +2638,13 @@

 		case MFI_STATE_BOOT_MESSAGE_PENDING:
 			if ((instance->pdev->device ==
-				PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
-			(instance->pdev->device ==
-				PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+			     PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+				(instance->pdev->device ==
+				 PCI_DEVICE_ID_LSI_SAS0071SKINNY) ||
+			    (instance->pdev->device ==
+			     PCI_DEVICE_ID_LSI_FUSION)) {
 				writel(MFI_INIT_HOTPLUG,
-				&instance->reg_set->reserved_0[0]);
+				       &instance->reg_set->doorbell);
 			} else
 				writel(MFI_INIT_HOTPLUG,
 					&instance->reg_set->inbound_doorbell);
@@ -2595,9 +2661,23 @@
 			if ((instance->pdev->device ==
 				PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
 				(instance->pdev->device ==
-				PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+				PCI_DEVICE_ID_LSI_SAS0071SKINNY)  ||
+				(instance->pdev->device
+					== PCI_DEVICE_ID_LSI_FUSION)) {
 				writel(MFI_RESET_FLAGS,
-					&instance->reg_set->reserved_0[0]);
+					&instance->reg_set->doorbell);
+				if (instance->pdev->device ==
+				    PCI_DEVICE_ID_LSI_FUSION) {
+					for (i = 0; i < (10 * 1000); i += 20) {
+						if (readl(
+							    &instance->
+							    reg_set->
+							    doorbell) & 1)
+							msleep(20);
+						else
+							break;
+					}
+				}
 			} else
 				writel(MFI_RESET_FLAGS,
 					&instance->reg_set->inbound_doorbell);
@@ -2681,7 +2761,7 @@
 static void megasas_teardown_frame_pool(struct megasas_instance *instance)
 {
 	int i;
-	u32 max_cmd = instance->max_fw_cmds;
+	u32 max_cmd = instance->max_mfi_cmds;
 	struct megasas_cmd *cmd;

 	if (!instance->frame_dma_pool)
@@ -2732,7 +2812,7 @@
 	u32 frame_count;
 	struct megasas_cmd *cmd;

-	max_cmd = instance->max_fw_cmds;
+	max_cmd = instance->max_mfi_cmds;

 	/*
 	 * Size of our frame is 64 bytes for MFI frame, followed by max SG
@@ -2819,14 +2899,15 @@
  * megasas_free_cmds -	Free all the cmds in the free cmd pool
  * @instance:		Adapter soft state
  */
-static void megasas_free_cmds(struct megasas_instance *instance)
+void megasas_free_cmds(struct megasas_instance *instance)
 {
 	int i;
 	/* First free the MFI frame pool */
 	megasas_teardown_frame_pool(instance);

 	/* Free all the commands in the cmd_list */
-	for (i = 0; i < instance->max_fw_cmds; i++)
+	for (i = 0; i < instance->max_mfi_cmds; i++)
+
 		kfree(instance->cmd_list[i]);

 	/* Free the cmd_list buffer itself */
@@ -2854,14 +2935,14 @@
  * This array is used only to look up the megasas_cmd given the context. The
  * free commands themselves are maintained in a linked list called cmd_pool.
  */
-static int megasas_alloc_cmds(struct megasas_instance *instance)
+int megasas_alloc_cmds(struct megasas_instance *instance)
 {
 	int i;
 	int j;
 	u32 max_cmd;
 	struct megasas_cmd *cmd;

-	max_cmd = instance->max_fw_cmds;
+	max_cmd = instance->max_mfi_cmds;

 	/*
 	 * instance->cmd_list is an array of struct megasas_cmd pointers.
@@ -2875,6 +2956,7 @@
 		return -ENOMEM;
 	}

+	memset(instance->cmd_list, 0, sizeof(struct megasas_cmd *) *max_cmd);

 	for (i = 0; i < max_cmd; i++) {
 		instance->cmd_list[i] = kmalloc(sizeof(struct megasas_cmd),
@@ -3288,6 +3370,7 @@
 	 * does not exceed max cmds that the FW can support
 	 */
 	instance->max_fw_cmds = instance->max_fw_cmds-1;
+	instance->max_mfi_cmds = instance->max_fw_cmds;
 	instance->max_num_sge =
(instance->instancet->read_fw_status_reg(reg_set) & 0xFF0000) >>
 					0x10;
 	/*
@@ -3381,6 +3464,9 @@
 	reg_set = instance->reg_set;

 	switch (instance->pdev->device) {
+	case PCI_DEVICE_ID_LSI_FUSION:
+		instance->instancet = &megasas_instance_template_fusion;
+		break;
 	case PCI_DEVICE_ID_LSI_SAS1078R:
 	case PCI_DEVICE_ID_LSI_SAS1078DE:
 		instance->instancet = &megasas_instance_template_ppc;
@@ -3482,9 +3568,10 @@
  */
 static void megasas_release_mfi(struct megasas_instance *instance)
 {
-	u32 reply_q_sz = sizeof(u32) * (instance->max_fw_cmds + 1);
+	u32 reply_q_sz = sizeof(u32) *(instance->max_mfi_cmds + 1);

-	pci_free_consistent(instance->pdev, reply_q_sz,
+	if (instance->reply_queue)
+		pci_free_consistent(instance->pdev, reply_q_sz,
 			    instance->reply_queue, instance->reply_queue_h);

 	megasas_free_cmds(instance);
@@ -3678,8 +3765,7 @@
 	/*
 	 * Issue the aen registration frame
 	 */
-	instance->instancet->fire_cmd(instance,
-			cmd->frame_phys_addr, 0, instance->reg_set);
+	instance->instancet->issue_dcmd(instance, cmd);

 	return 0;
 }
@@ -3756,12 +3842,18 @@
 	}

 	host->max_sectors = instance->max_sectors_per_req;
-	host->cmd_per_lun = 128;
+	host->cmd_per_lun = MEGASAS_DEFAULT_CMD_PER_LUN;
 	host->max_channel = MEGASAS_MAX_CHANNELS - 1;
 	host->max_id = MEGASAS_MAX_DEV_PER_CHANNEL;
 	host->max_lun = MEGASAS_MAX_LUN;
 	host->max_cmd_len = 16;

+	/* Fusion only supports host reset */
+	if (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) {
+		host->hostt->eh_device_reset_handler = NULL;
+		host->hostt->eh_bus_reset_handler = NULL;
+	}
+
 	/*
 	 * Notify the mid-layer about the new controller
 	 */
@@ -3846,20 +3938,45 @@
 	instance = (struct megasas_instance *)host->hostdata;
 	memset(instance, 0, sizeof(*instance));
 	atomic_set( &instance->fw_reset_no_pci_access, 0 );
+	instance->pdev = pdev;

-	instance->producer = pci_alloc_consistent(pdev, sizeof(u32),
-						  &instance->producer_h);
-	instance->consumer = pci_alloc_consistent(pdev, sizeof(u32),
-						  &instance->consumer_h);
+	switch (instance->pdev->device) {
+	case PCI_DEVICE_ID_LSI_FUSION:
+	{
+		struct fusion_context *fusion;
+
+		instance->ctrl_context =
+			kzalloc(sizeof(struct fusion_context), GFP_KERNEL);
+		if (!instance->ctrl_context) {
+			printk(KERN_DEBUG "megasas: Failed to allocate "
+			       "memory for Fusion context info\n");
+			goto fail_alloc_dma_buf;
+		}
+		fusion = instance->ctrl_context;
+		INIT_LIST_HEAD(&fusion->cmd_pool);
+		spin_lock_init(&fusion->cmd_pool_lock);
+	}
+	break;
+	default: /* For all other supported controllers */
+
+		instance->producer =
+			pci_alloc_consistent(pdev, sizeof(u32),
+					     &instance->producer_h);
+		instance->consumer =
+			pci_alloc_consistent(pdev, sizeof(u32),
+					     &instance->consumer_h);
+
+		if (!instance->producer || !instance->consumer) {
+			printk(KERN_DEBUG "megasas: Failed to allocate"
+			       "memory for producer, consumer\n");
+			goto fail_alloc_dma_buf;
+		}

-	if (!instance->producer || !instance->consumer) {
-		printk(KERN_DEBUG "megasas: Failed to allocate memory for "
-		       "producer, consumer\n");
-		goto fail_alloc_dma_buf;
+		*instance->producer = 0;
+		*instance->consumer = 0;
+		break;
 	}

-	*instance->producer = 0;
-	*instance->consumer = 0;
 	megasas_poll_wait_aen = 0;
 	instance->flag_ieee = 0;
 	instance->ev = NULL;
@@ -3895,11 +4012,11 @@
 	spin_lock_init(&poll_aen_lock);

 	mutex_init(&instance->aen_mutex);
+	mutex_init(&instance->reset_mutex);

 	/*
 	 * Initialize PCI related and misc parameters
 	 */
-	instance->pdev = pdev;
 	instance->host = host;
 	instance->unique_id = pdev->bus->number << 8 | pdev->devfn;
 	instance->init_id = MEGASAS_DEFAULT_INIT_ID;
@@ -3917,7 +4034,10 @@
 	instance->last_time = 0;
 	instance->disableOnlineCtrlReset = 1;

-	INIT_WORK(&instance->work_init, process_fw_state_change_wq);
+	if (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION)
+		INIT_WORK(&instance->work_init, megasas_fusion_ocr_wq);
+	else
+		INIT_WORK(&instance->work_init, process_fw_state_change_wq);

 	/*
 	 * Initialize MFI Firmware
@@ -4000,6 +4120,8 @@
 		pci_free_consistent(pdev, sizeof(u32), instance->producer,
 				    instance->producer_h);
 		megasas_release_mfi(instance);
+	} else {
+		megasas_release_fusion(instance);
 	}
 	if (instance->consumer)
 		pci_free_consistent(pdev, sizeof(u32), instance->consumer,
@@ -4072,7 +4194,9 @@

 	if (instance->aen_cmd)
 		megasas_issue_blocked_abort_cmd(instance, instance->aen_cmd);
-
+	if (instance->map_update_cmd)
+		megasas_issue_blocked_abort_cmd(instance,
+						instance->map_update_cmd);
 	dcmd = &cmd->frame->dcmd;

 	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
@@ -4177,9 +4301,6 @@
 	 * Initialize MFI Firmware
 	 */

-	*instance->producer = 0;
-	*instance->consumer = 0;
-
 	atomic_set(&instance->fw_outstanding, 0);

 	/*
@@ -4188,11 +4309,29 @@
 	if (megasas_transition_to_ready(instance))
 		goto fail_ready_state;

-	if (megasas_issue_init_mfi(instance))
-		goto fail_init_mfi;
+	switch (instance->pdev->device) {
+	case PCI_DEVICE_ID_LSI_FUSION:
+	{
+		megasas_reset_reply_desc(instance);
+		if (megasas_ioc_init_fusion(instance)) {
+			megasas_free_cmds(instance);
+			megasas_free_cmds_fusion(instance);
+			goto fail_init_mfi;
+		}
+		if (!megasas_get_map_info(instance))
+			megasas_sync_map_info(instance);
+	}
+	break;
+	default:
+		*instance->producer = 0;
+		*instance->consumer = 0;
+		if (megasas_issue_init_mfi(instance))
+			goto fail_init_mfi;
+		break;
+	}

-	tasklet_init(&instance->isr_tasklet, megasas_complete_cmd_dpc,
-			(unsigned long)instance);
+	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
+		     (unsigned long)instance);

 	/* Now re-enable MSI-X */
 	if (instance->msi_flag)
@@ -4261,10 +4400,12 @@
 	int i;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
+	struct fusion_context *fusion;

 	instance = pci_get_drvdata(pdev);
 	instance->unload = 1;
 	host = instance->host;
+	fusion = instance->ctrl_context;

 	if (poll_mode_io)
 		del_timer_sync(&instance->io_completion_timer);
@@ -4306,16 +4447,32 @@
 	if (instance->msi_flag)
 		pci_disable_msix(instance->pdev);

-	megasas_release_mfi(instance);
-
-	pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
-			    instance->evt_detail, instance->evt_detail_h);
-
-	pci_free_consistent(pdev, sizeof(u32), instance->producer,
-			    instance->producer_h);
-
-	pci_free_consistent(pdev, sizeof(u32), instance->consumer,
-			    instance->consumer_h);
+	switch (instance->pdev->device) {
+	case PCI_DEVICE_ID_LSI_FUSION:
+		megasas_release_fusion(instance);
+		for (i = 0; i < 2 ; i++)
+			if (fusion->ld_map[i])
+				dma_free_coherent(&instance->pdev->dev,
+						  fusion->map_sz,
+						  fusion->ld_map[i],
+						  fusion->
+						  ld_map_phys[i]);
+		kfree(instance->ctrl_context);
+		break;
+	default:
+		megasas_release_mfi(instance);
+		pci_free_consistent(pdev,
+				    sizeof(struct megasas_evt_detail),
+				    instance->evt_detail,
+				    instance->evt_detail_h);
+		pci_free_consistent(pdev, sizeof(u32),
+				    instance->producer,
+				    instance->producer_h);
+		pci_free_consistent(pdev, sizeof(u32),
+				    instance->consumer,
+				    instance->consumer_h);
+		break;
+	}

 	scsi_host_put(host);

@@ -5079,6 +5236,7 @@
 			break;
 		case MR_EVT_CTRL_HOST_BUS_SCAN_REQUESTED:
 		case MR_EVT_FOREIGN_CFG_IMPORTED:
+		case MR_EVT_LD_STATE_CHANGE:
 			doscan = 1;
 			break;
 		default:

--00163683204e9f56a404976a26b6
Content-Type: application/octet-stream; name="megaraid_sas.patch6"
Content-Disposition: attachment; filename="megaraid_sas.patch6"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghpmrljj0

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVn
YXJhaWRfc2FzX2Jhc2UuYyBsaW51eC0yLjYuMzctcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJh
aWQvbWVnYXJhaWRfc2FzX2Jhc2UuYwotLS0gbGludXgtMi42LjM3LXJjNS5vbGQvZHJpdmVycy9z
Y3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19iYXNlLmMJMjAxMC0xMi0xNCAxNzowNjowMS4wMDAw
MDAwMDAgLTA4MDAKKysrIGxpbnV4LTIuNi4zNy1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFp
ZC9tZWdhcmFpZF9zYXNfYmFzZS5jCTIwMTAtMTItMTQgMTc6MDg6MzIuMDAwMDAwMDAwIC0wODAw
CkBAIC01Myw2ICs1Myw3IEBACiAjaW5jbHVkZSA8c2NzaS9zY3NpX2NtbmQuaD4KICNpbmNsdWRl
IDxzY3NpL3Njc2lfZGV2aWNlLmg+CiAjaW5jbHVkZSA8c2NzaS9zY3NpX2hvc3QuaD4KKyNpbmNs
dWRlICJtZWdhcmFpZF9zYXNfZnVzaW9uLmgiCiAjaW5jbHVkZSAibWVnYXJhaWRfc2FzLmgiCiAK
IC8qCkBAIC04MSw3ICs4Miw3IEBACiBNT0RVTEVfQVVUSE9SKCJtZWdhcmFpZGxpbnV4QGxzaS5j
b20iKTsKIE1PRFVMRV9ERVNDUklQVElPTigiTFNJIE1lZ2FSQUlEIFNBUyBEcml2ZXIiKTsKIAot
c3RhdGljIGludCBtZWdhc2FzX3RyYW5zaXRpb25fdG9fcmVhZHkoc3RydWN0IG1lZ2FzYXNfaW5z
dGFuY2UgKmluc3RhbmNlKTsKK2ludCBtZWdhc2FzX3RyYW5zaXRpb25fdG9fcmVhZHkoc3RydWN0
IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKTsKIHN0YXRpYyBpbnQgbWVnYXNhc19nZXRfcGRf
bGlzdChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpOwogc3RhdGljIGludCBtZWdh
c2FzX2lzc3VlX2luaXRfbWZpKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSk7CiBz
dGF0aWMgaW50IG1lZ2FzYXNfcmVnaXN0ZXJfYWVuKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICpp
bnN0YW5jZSwKQEAgLTEwOSw2ICsxMTAsOCBAQAogCS8qIHhzY2FsZSBJT1AsIHZlZ2EgKi8KIAl7
UENJX0RFVklDRShQQ0lfVkVORE9SX0lEX0RFTEwsIFBDSV9ERVZJQ0VfSURfREVMTF9QRVJDNSl9
LAogCS8qIHhzY2FsZSBJT1AgKi8KKwl7UENJX0RFVklDRShQQ0lfVkVORE9SX0lEX0xTSV9MT0dJ
QywgUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OKX0sCisJLyogRnVzaW9uICovCiAJe30KIH07CiAK
QEAgLTEyMiwxNSArMTI1LDE2IEBACiBzdGF0aWMgaW50IG1lZ2FzYXNfcG9sbF93YWl0X2FlbjsK
IHN0YXRpYyBERUNMQVJFX1dBSVRfUVVFVUVfSEVBRChtZWdhc2FzX3BvbGxfd2FpdCk7CiBzdGF0
aWMgdTMyIHN1cHBvcnRfcG9sbF9mb3JfZXZlbnQ7Ci1zdGF0aWMgdTMyIG1lZ2FzYXNfZGJnX2x2
bDsKK3UzMiBtZWdhc2FzX2RiZ19sdmw7CiBzdGF0aWMgdTMyIHN1cHBvcnRfZGV2aWNlX2NoYW5n
ZTsKIAogLyogZGVmaW5lIGxvY2sgZm9yIGFlbiBwb2xsICovCiBzcGlubG9ja190IHBvbGxfYWVu
X2xvY2s7CiAKLXN0YXRpYyB2b2lkCit2b2lkCiBtZWdhc2FzX2NvbXBsZXRlX2NtZChzdHJ1Y3Qg
bWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kLAogCQkg
ICAgIHU4IGFsdF9zdGF0dXMpOworCiBzdGF0aWMgaXJxcmV0dXJuX3QgbWVnYXNhc19pc3IoaW50
IGlycSwgdm9pZCAqZGV2cCk7CiBzdGF0aWMgdTMyCiBtZWdhc2FzX2luaXRfYWRhcHRlcl9tZmko
c3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKTsKQEAgLTEzOCw2ICsxNDIsMjMgQEAK
IG1lZ2FzYXNfYnVpbGRfYW5kX2lzc3VlX2NtZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5z
dGFuY2UsCiAJCQkgICAgc3RydWN0IHNjc2lfY21uZCAqc2NtZCk7CiBzdGF0aWMgdm9pZCBtZWdh
c2FzX2NvbXBsZXRlX2NtZF9kcGModW5zaWduZWQgbG9uZyBpbnN0YW5jZV9hZGRyKTsKK3ZvaWQK
K21lZ2FzYXNfcmVsZWFzZV9mdXNpb24oc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNl
KTsKK2ludAorbWVnYXNhc19pb2NfaW5pdF9mdXNpb24oc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2Ug
Kmluc3RhbmNlKTsKK3ZvaWQKK21lZ2FzYXNfZnJlZV9jbWRzX2Z1c2lvbihzdHJ1Y3QgbWVnYXNh
c19pbnN0YW5jZSAqaW5zdGFuY2UpOwordTgKK21lZ2FzYXNfZ2V0X21hcF9pbmZvKHN0cnVjdCBt
ZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSk7CitpbnQKK21lZ2FzYXNfc3luY19tYXBfaW5mbyhz
dHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpOworaW50Cit3YWl0X2FuZF9wb2xsKHN0
cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwgc3RydWN0IG1lZ2FzYXNfY21kICpjbWQp
Owordm9pZCBtZWdhc2FzX3Jlc2V0X3JlcGx5X2Rlc2Moc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2Ug
Kmluc3RhbmNlKTsKK3U4IE1SX1ZhbGlkYXRlTWFwSW5mbyhzdHJ1Y3QgTVJfRldfUkFJRF9NQVBf
QUxMICptYXAsCisJCSAgICAgIHN0cnVjdCBMRF9MT0FEX0JBTEFOQ0VfSU5GTyAqbGJJbmZvKTsK
K2ludCBtZWdhc2FzX3Jlc2V0X2Z1c2lvbihzdHJ1Y3Qgc2NzaV9jbW5kICpzY21kKTsKK3ZvaWQg
bWVnYXNhc19mdXNpb25fb2NyX3dxKHN0cnVjdCB3b3JrX3N0cnVjdCAqd29yayk7CiAKIHZvaWQK
IG1lZ2FzYXNfaXNzdWVfZGNtZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIHN0
cnVjdCBtZWdhc2FzX2NtZCAqY21kKQpAQCAtMTUyLDcgKzE3Myw3IEBACiAgKgogICogUmV0dXJu
cyBhIGZyZWUgY29tbWFuZCBmcm9tIHRoZSBwb29sCiAgKi8KLXN0YXRpYyBzdHJ1Y3QgbWVnYXNh
c19jbWQgKm1lZ2FzYXNfZ2V0X2NtZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZQorc3RydWN0IG1l
Z2FzYXNfY21kICptZWdhc2FzX2dldF9jbWQoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UKIAkJCQkJ
CSAgKmluc3RhbmNlKQogewogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CkBAIC0xNzcsNyArMTk4LDcg
QEAKICAqIEBpbnN0YW5jZToJCUFkYXB0ZXIgc29mdCBzdGF0ZQogICogQGNtZDoJCUNvbW1hbmQg
cGFja2V0IHRvIGJlIHJldHVybmVkIHRvIGZyZWUgY29tbWFuZCBwb29sCiAgKi8KLXN0YXRpYyBp
bmxpbmUgdm9pZAoraW5saW5lIHZvaWQKIG1lZ2FzYXNfcmV0dXJuX2NtZChzdHJ1Y3QgbWVnYXNh
c19pbnN0YW5jZSAqaW5zdGFuY2UsIHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kKQogewogCXVuc2ln
bmVkIGxvbmcgZmxhZ3M7CkBAIC0xODUsNiArMjA2LDcgQEAKIAlzcGluX2xvY2tfaXJxc2F2ZSgm
aW5zdGFuY2UtPmNtZF9wb29sX2xvY2ssIGZsYWdzKTsKIAogCWNtZC0+c2NtZCA9IE5VTEw7CisJ
Y21kLT5mcmFtZV9jb3VudCA9IDA7CiAJbGlzdF9hZGRfdGFpbCgmY21kLT5saXN0LCAmaW5zdGFu
Y2UtPmNtZF9wb29sKTsKIAogCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmluc3RhbmNlLT5jbWRf
cG9vbF9sb2NrLCBmbGFncyk7CkBAIC03OTYsNiArODE4LDExIEBACiAqICAgICAgIHNwZWNpZmlj
IHRvIGdlbjIgKGRldmljZWlkIDogMHg3OCwgMHg3OSkgY29udHJvbGxlcnMKICovCiAKKy8qCisg
KiBUZW1wbGF0ZSBhZGRlZCBmb3IgVEIgKEZ1c2lvbikKKyAqLworZXh0ZXJuIHN0cnVjdCBtZWdh
c2FzX2luc3RhbmNlX3RlbXBsYXRlIG1lZ2FzYXNfaW5zdGFuY2VfdGVtcGxhdGVfZnVzaW9uOwor
CiAvKioKICAqIG1lZ2FzYXNfaXNzdWVfcG9sbGVkIC0JSXNzdWVzIGEgcG9sbGluZyBjb21tYW5k
CiAgKiBAaW5zdGFuY2U6CQkJQWRhcHRlciBzb2Z0IHN0YXRlCkBAIC04MDMsMTEgKzgzMCw5IEBA
CiAgKgogICogRm9yIHBvbGxpbmcsIE1GSSByZXF1aXJlcyB0aGUgY21kX3N0YXR1cyB0byBiZSBz
ZXQgdG8gMHhGRiBiZWZvcmUgcG9zdGluZy4KICAqLwotc3RhdGljIGludAoraW50CiBtZWdhc2Fz
X2lzc3VlX3BvbGxlZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIHN0cnVjdCBt
ZWdhc2FzX2NtZCAqY21kKQogewotCWludCBpOwotCXUzMiBtc2VjcyA9IE1GSV9QT0xMX1RJTUVP
VVRfU0VDUyAqIDEwMDA7CiAKIAlzdHJ1Y3QgbWVnYXNhc19oZWFkZXIgKmZyYW1lX2hkciA9ICZj
bWQtPmZyYW1lLT5oZHI7CiAKQEAgLTgxNywyMSArODQyLDEyIEBACiAJLyoKIAkgKiBJc3N1ZSB0
aGUgZnJhbWUgdXNpbmcgaW5ib3VuZCBxdWV1ZSBwb3J0CiAJICovCi0JaW5zdGFuY2UtPmluc3Rh
bmNldC0+ZmlyZV9jbWQoaW5zdGFuY2UsCi0JCQljbWQtPmZyYW1lX3BoeXNfYWRkciwgMCwgaW5z
dGFuY2UtPnJlZ19zZXQpOworCWluc3RhbmNlLT5pbnN0YW5jZXQtPmlzc3VlX2RjbWQoaW5zdGFu
Y2UsIGNtZCk7CiAKIAkvKgogCSAqIFdhaXQgZm9yIGNtZF9zdGF0dXMgdG8gY2hhbmdlCiAJICov
Ci0JZm9yIChpID0gMDsgKGkgPCBtc2VjcykgJiYgKGZyYW1lX2hkci0+Y21kX3N0YXR1cyA9PSAw
eGZmKTsgaSsrKSB7Ci0JCXJtYigpOwotCQltc2xlZXAoMSk7Ci0JfQotCi0JaWYgKGZyYW1lX2hk
ci0+Y21kX3N0YXR1cyA9PSAweGZmKQotCQlyZXR1cm4gLUVUSU1FOwotCi0JcmV0dXJuIDA7CisJ
cmV0dXJuIHdhaXRfYW5kX3BvbGwoaW5zdGFuY2UsIGNtZCk7CiB9CiAKIC8qKgpAQCAtODQ5LDgg
Kzg2NSw3IEBACiB7CiAJY21kLT5jbWRfc3RhdHVzID0gRU5PREFUQTsKIAotCWluc3RhbmNlLT5p
bnN0YW5jZXQtPmZpcmVfY21kKGluc3RhbmNlLAotCQkJY21kLT5mcmFtZV9waHlzX2FkZHIsIDAs
IGluc3RhbmNlLT5yZWdfc2V0KTsKKwlpbnN0YW5jZS0+aW5zdGFuY2V0LT5pc3N1ZV9kY21kKGlu
c3RhbmNlLCBjbWQpOwogCiAJd2FpdF9ldmVudChpbnN0YW5jZS0+aW50X2NtZF93YWl0X3EsIGNt
ZC0+Y21kX3N0YXR1cyAhPSBFTk9EQVRBKTsKIApAQCAtODk0LDggKzkwOSw3IEBACiAJY21kLT5z
eW5jX2NtZCA9IDE7CiAJY21kLT5jbWRfc3RhdHVzID0gMHhGRjsKIAotCWluc3RhbmNlLT5pbnN0
YW5jZXQtPmZpcmVfY21kKGluc3RhbmNlLAotCQkJY21kLT5mcmFtZV9waHlzX2FkZHIsIDAsIGlu
c3RhbmNlLT5yZWdfc2V0KTsKKwlpbnN0YW5jZS0+aW5zdGFuY2V0LT5pc3N1ZV9kY21kKGluc3Rh
bmNlLCBjbWQpOwogCiAJLyoKIAkgKiBXYWl0IGZvciB0aGlzIGNtZCB0byBjb21wbGV0ZQpAQCAt
MTI5MSw3ICsxMzA1LDcgQEAKICAqIENhbGxlZCBieSBtZWdhc2FzX3F1ZXVlX2NvbW1hbmQgdG8g
ZmluZCBvdXQgaWYgdGhlIGNvbW1hbmQgdG8gYmUgcXVldWVkCiAgKiBpcyBhIGxvZ2ljYWwgZHJp
dmUgY29tbWFuZAkKICAqLwotc3RhdGljIGlubGluZSBpbnQgbWVnYXNhc19pc19sZGlvKHN0cnVj
dCBzY3NpX2NtbmQgKmNtZCkKK2lubGluZSBpbnQgbWVnYXNhc19pc19sZGlvKHN0cnVjdCBzY3Np
X2NtbmQgKmNtZCkKIHsKIAlpZiAoIU1FR0FTQVNfSVNfTE9HSUNBTChjbWQpKQogCQlyZXR1cm4g
MDsKQEAgLTE1NTEsMTUgKzE1NjUsNDQgQEAKIAlyZXR1cm4gMDsKIH0KIAotc3RhdGljIHZvaWQg
bWVnYXJhaWRfc2FzX2tpbGxfaGJhKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkK
K3ZvaWQgbWVnYXJhaWRfc2FzX2tpbGxfaGJhKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0
YW5jZSkKIHsKIAlpZiAoKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF9M
U0lfU0FTMDA3M1NLSU5OWSkgfHwKLQkJKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RF
VklDRV9JRF9MU0lfU0FTMDA3MVNLSU5OWSkpIHsKLQkJd3JpdGVsKE1GSV9TVE9QX0FEUCwKLQkJ
CSZpbnN0YW5jZS0+cmVnX3NldC0+cmVzZXJ2ZWRfMFswXSk7CisJICAgIChpbnN0YW5jZS0+cGRl
di0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfTFNJX1NBUzAwNzFTS0lOTlkpIHx8CisJICAgIChp
bnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTikpIHsKKwkJ
d3JpdGVsKE1GSV9TVE9QX0FEUCwgJmluc3RhbmNlLT5yZWdfc2V0LT5kb29yYmVsbCk7CiAJfSBl
bHNlIHsKLQkJd3JpdGVsKE1GSV9TVE9QX0FEUCwKLQkJCSZpbnN0YW5jZS0+cmVnX3NldC0+aW5i
b3VuZF9kb29yYmVsbCk7CisJCXdyaXRlbChNRklfU1RPUF9BRFAsICZpbnN0YW5jZS0+cmVnX3Nl
dC0+aW5ib3VuZF9kb29yYmVsbCk7CisJfQorfQorCisgLyoqCisgICogbWVnYXNhc19jaGVja19h
bmRfcmVzdG9yZV9xdWV1ZV9kZXB0aCAtIENoZWNrIGlmIHF1ZXVlIGRlcHRoIG5lZWRzIHRvIGJl
CisgICoJCQkJCXJlc3RvcmVkIHRvIG1heCB2YWx1ZQorICAqIEBpbnN0YW5jZToJCQlBZGFwdGVy
IHNvZnQgc3RhdGUKKyAgKgorICAqLwordm9pZAorbWVnYXNhc19jaGVja19hbmRfcmVzdG9yZV9x
dWV1ZV9kZXB0aChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCit7CisJdW5zaWdu
ZWQgbG9uZyBmbGFnczsKKwlpZiAoaW5zdGFuY2UtPmZsYWcgJiBNRUdBU0FTX0ZXX0JVU1kKKwkJ
JiYgdGltZV9hZnRlcihqaWZmaWVzLCBpbnN0YW5jZS0+bGFzdF90aW1lICsgNSAqIEhaKQorCQkm
JiBhdG9taWNfcmVhZCgmaW5zdGFuY2UtPmZ3X291dHN0YW5kaW5nKSA8IDE3KSB7CisKKwkJc3Bp
bl9sb2NrX2lycXNhdmUoaW5zdGFuY2UtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOworCQlpbnN0
YW5jZS0+ZmxhZyAmPSB+TUVHQVNBU19GV19CVVNZOworCQlpZiAoKGluc3RhbmNlLT5wZGV2LT5k
ZXZpY2UgPT0KKwkJCVBDSV9ERVZJQ0VfSURfTFNJX1NBUzAwNzNTS0lOTlkpIHx8CisJCQkoaW5z
dGFuY2UtPnBkZXYtPmRldmljZSA9PQorCQkJUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3MVNLSU5O
WSkpIHsKKwkJCWluc3RhbmNlLT5ob3N0LT5jYW5fcXVldWUgPQorCQkJCWluc3RhbmNlLT5tYXhf
ZndfY21kcyAtIE1FR0FTQVNfU0tJTk5ZX0lOVF9DTURTOworCQl9IGVsc2UKKwkJCWluc3RhbmNl
LT5ob3N0LT5jYW5fcXVldWUgPQorCQkJCWluc3RhbmNlLT5tYXhfZndfY21kcyAtIE1FR0FTQVNf
SU5UX0NNRFM7CisKKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShpbnN0YW5jZS0+aG9zdC0+aG9z
dF9sb2NrLCBmbGFncyk7CiAJfQogfQogCkBAIC0xNjEzLDI0ICsxNjU2LDcgQEAKIAkvKgogCSAq
IENoZWNrIGlmIHdlIGNhbiByZXN0b3JlIGNhbl9xdWV1ZQogCSAqLwotCWlmIChpbnN0YW5jZS0+
ZmxhZyAmIE1FR0FTQVNfRldfQlVTWQotCQkmJiB0aW1lX2FmdGVyKGppZmZpZXMsIGluc3RhbmNl
LT5sYXN0X3RpbWUgKyA1ICogSFopCi0JCSYmIGF0b21pY19yZWFkKCZpbnN0YW5jZS0+Zndfb3V0
c3RhbmRpbmcpIDwgMTcpIHsKLQotCQlzcGluX2xvY2tfaXJxc2F2ZShpbnN0YW5jZS0+aG9zdC0+
aG9zdF9sb2NrLCBmbGFncyk7Ci0JCWluc3RhbmNlLT5mbGFnICY9IH5NRUdBU0FTX0ZXX0JVU1k7
Ci0JCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PQotCQkJUENJX0RFVklDRV9JRF9MU0lf
U0FTMDA3M1NLSU5OWSkgfHwKLQkJCShpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09Ci0JCQlQQ0lf
REVWSUNFX0lEX0xTSV9TQVMwMDcxU0tJTk5ZKSkgewotCQkJaW5zdGFuY2UtPmhvc3QtPmNhbl9x
dWV1ZSA9Ci0JCQkJaW5zdGFuY2UtPm1heF9md19jbWRzIC0gTUVHQVNBU19TS0lOTllfSU5UX0NN
RFM7Ci0JCX0gZWxzZQotCQkJaW5zdGFuY2UtPmhvc3QtPmNhbl9xdWV1ZSA9Ci0JCQkJaW5zdGFu
Y2UtPm1heF9md19jbWRzIC0gTUVHQVNBU19JTlRfQ01EUzsKLQotCQlzcGluX3VubG9ja19pcnFy
ZXN0b3JlKGluc3RhbmNlLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsKLQl9CisJbWVnYXNhc19j
aGVja19hbmRfcmVzdG9yZV9xdWV1ZV9kZXB0aChpbnN0YW5jZSk7CiB9CiAKIHN0YXRpYyB2b2lk
CkBAIC0xODA4LDcgKzE4MzQsNyBAQAogCQkJKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0KIAkJ
CVBDSV9ERVZJQ0VfSURfTFNJX1NBUzAwNzFTS0lOTlkpKSB7CiAJCQl3cml0ZWwoTUZJX1NUT1Bf
QURQLAotCQkJCSZpbnN0YW5jZS0+cmVnX3NldC0+cmVzZXJ2ZWRfMFswXSk7CisJCQkJJmluc3Rh
bmNlLT5yZWdfc2V0LT5kb29yYmVsbCk7CiAJCX0gZWxzZSB7CiAJCQl3cml0ZWwoTUZJX1NUT1Bf
QURQLAogCQkJCSZpbnN0YW5jZS0+cmVnX3NldC0+aW5ib3VuZF9kb29yYmVsbCk7CkBAIC0xOTEy
LDExICsxOTM4LDE2IEBACiBzdGF0aWMgaW50IG1lZ2FzYXNfcmVzZXRfYnVzX2hvc3Qoc3RydWN0
IHNjc2lfY21uZCAqc2NtZCkKIHsKIAlpbnQgcmV0OworCXN0cnVjdCBtZWdhc2FzX2luc3RhbmNl
ICppbnN0YW5jZTsKKwlpbnN0YW5jZSA9IChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqKXNjbWQt
PmRldmljZS0+aG9zdC0+aG9zdGRhdGE7CiAKIAkvKgogCSAqIEZpcnN0IHdhaXQgZm9yIGFsbCBj
b21tYW5kcyB0byBjb21wbGV0ZQogCSAqLwotCXJldCA9IG1lZ2FzYXNfZ2VuZXJpY19yZXNldChz
Y21kKTsKKwlpZiAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9G
VVNJT04pCisJCXJldCA9IG1lZ2FzYXNfcmVzZXRfZnVzaW9uKHNjbWQpOworCWVsc2UKKwkJcmV0
ID0gbWVnYXNhc19nZW5lcmljX3Jlc2V0KHNjbWQpOwogCiAJcmV0dXJuIHJldDsKIH0KQEAgLTIw
ODYsMTMgKzIxMTcsMTQgQEAKICAqIAkJCQlhbiBhbHRlcm5hdGUgc3RhdHVzIChhcyBpbiB0aGUg
Y2FzZSBvZiBhYm9ydGVkCiAgKiAJCQkJY29tbWFuZHMpCiAgKi8KLXN0YXRpYyB2b2lkCit2b2lk
CiBtZWdhc2FzX2NvbXBsZXRlX2NtZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2Us
IHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kLAogCQkgICAgIHU4IGFsdF9zdGF0dXMpCiB7CiAJaW50
IGV4Y2VwdGlvbiA9IDA7CiAJc3RydWN0IG1lZ2FzYXNfaGVhZGVyICpoZHIgPSAmY21kLT5mcmFt
ZS0+aGRyOwogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CisJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpm
dXNpb24gPSBpbnN0YW5jZS0+Y3RybF9jb250ZXh0OwogCiAJLyogZmxhZyBmb3IgdGhlIHJldHJ5
IHJlc2V0ICovCiAJY21kLT5yZXRyeV9mb3JfZndfcmVzZXQgPSAwOwpAQCAtMjE4NSw2ICsyMjE3
LDM3IEBACiAJY2FzZSBNRklfQ01EX1NNUDoKIAljYXNlIE1GSV9DTURfU1RQOgogCWNhc2UgTUZJ
X0NNRF9EQ01EOgorCQkvKiBDaGVjayBmb3IgTEQgbWFwIHVwZGF0ZSAqLworCQlpZiAoKGNtZC0+
ZnJhbWUtPmRjbWQub3Bjb2RlID09IE1SX0RDTURfTERfTUFQX0dFVF9JTkZPKSAmJgorCQkgICAg
KGNtZC0+ZnJhbWUtPmRjbWQubWJveC5iWzFdID09IDEpKSB7CisJCQlzcGluX2xvY2tfaXJxc2F2
ZShpbnN0YW5jZS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7CisJCQlpZiAoY21kLT5mcmFtZS0+
aGRyLmNtZF9zdGF0dXMgIT0gMCkgeworCQkJCWlmIChjbWQtPmZyYW1lLT5oZHIuY21kX3N0YXR1
cyAhPQorCQkJCSAgICBNRklfU1RBVF9OT1RfRk9VTkQpCisJCQkJCXByaW50ayhLRVJOX1dBUk5J
TkcgIm1lZ2FzYXM6IG1hcCBzeW5jIgorCQkJCQkgICAgICAgImZhaWxlZCwgc3RhdHVzID0gMHgl
eC5cbiIsCisJCQkJCSAgICAgICBjbWQtPmZyYW1lLT5oZHIuY21kX3N0YXR1cyk7CisJCQkJZWxz
ZSB7CisJCQkJCW1lZ2FzYXNfcmV0dXJuX2NtZChpbnN0YW5jZSwgY21kKTsKKwkJCQkJc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgKKwkJCQkJCWluc3RhbmNlLT5ob3N0LT5ob3N0X2xvY2ssCisJCQkJ
CQlmbGFncyk7CisJCQkJCWJyZWFrOworCQkJCX0KKwkJCX0gZWxzZQorCQkJCWluc3RhbmNlLT5t
YXBfaWQrKzsKKwkJCW1lZ2FzYXNfcmV0dXJuX2NtZChpbnN0YW5jZSwgY21kKTsKKwkJCWlmIChN
Ul9WYWxpZGF0ZU1hcEluZm8oCisJCQkJICAgIGZ1c2lvbi0+bGRfbWFwWyhpbnN0YW5jZS0+bWFw
X2lkICYgMSldLAorCQkJCSAgICBmdXNpb24tPmxvYWRfYmFsYW5jZV9pbmZvKSkKKwkJCQlmdXNp
b24tPmZhc3RfcGF0aF9pbyA9IDE7CisJCQllbHNlCisJCQkJZnVzaW9uLT5mYXN0X3BhdGhfaW8g
PSAwOworCQkJbWVnYXNhc19zeW5jX21hcF9pbmZvKGluc3RhbmNlKTsKKwkJCXNwaW5fdW5sb2Nr
X2lycXJlc3RvcmUoaW5zdGFuY2UtPmhvc3QtPmhvc3RfbG9jaywKKwkJCQkJICAgICAgIGZsYWdz
KTsKKwkJCWJyZWFrOworCQl9CiAJCWlmIChjbWQtPmZyYW1lLT5kY21kLm9wY29kZSA9PSBNUl9E
Q01EX0NUUkxfRVZFTlRfR0VUX0lORk8gfHwKIAkJCWNtZC0+ZnJhbWUtPmRjbWQub3Bjb2RlID09
IE1SX0RDTURfQ1RSTF9FVkVOVF9HRVQpIHsKIAkJCXNwaW5fbG9ja19pcnFzYXZlKCZwb2xsX2Fl
bl9sb2NrLCBmbGFncyk7CkBAIC0yNTIzLDcgKzI1ODYsNyBAQAogICogc3RhdGVzLCBkcml2ZXIg
bXVzdCB0YWtlIHN0ZXBzIHRvIGJyaW5nIGl0IHRvIHJlYWR5IHN0YXRlLiBPdGhlcndpc2UsIGl0
CiAgKiBoYXMgdG8gd2FpdCBmb3IgdGhlIHJlYWR5IHN0YXRlLgogICovCi1zdGF0aWMgaW50Citp
bnQKIG1lZ2FzYXNfdHJhbnNpdGlvbl90b19yZWFkeShzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSog
aW5zdGFuY2UpCiB7CiAJaW50IGk7CkBAIC0yNTU3LDExICsyNjIwLDEyIEBACiAJCQlpZiAoKGlu
c3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0KIAkJCQlQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDczU0tJ
Tk5ZKSB8fAogCQkJCShpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09Ci0JCQkJUENJX0RFVklDRV9J
RF9MU0lfU0FTMDA3MVNLSU5OWSkpIHsKLQorCQkJCSBQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDcx
U0tJTk5ZKSB8fAorCQkJCShpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09CisJCQkJIFBDSV9ERVZJ
Q0VfSURfTFNJX0ZVU0lPTikpIHsKIAkJCQl3cml0ZWwoCiAJCQkJICBNRklfSU5JVF9DTEVBUl9I
QU5EU0hBS0V8TUZJX0lOSVRfSE9UUExVRywKLQkJCQkgICZpbnN0YW5jZS0+cmVnX3NldC0+cmVz
ZXJ2ZWRfMFswXSk7CisJCQkJICAmaW5zdGFuY2UtPnJlZ19zZXQtPmRvb3JiZWxsKTsKIAkJCX0g
ZWxzZSB7CiAJCQkJd3JpdGVsKAogCQkJCSAgICBNRklfSU5JVF9DTEVBUl9IQU5EU0hBS0V8TUZJ
X0lOSVRfSE9UUExVRywKQEAgLTI1NzQsMTEgKzI2MzgsMTMgQEAKIAogCQljYXNlIE1GSV9TVEFU
RV9CT09UX01FU1NBR0VfUEVORElORzoKIAkJCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9
PQotCQkJCVBDSV9ERVZJQ0VfSURfTFNJX1NBUzAwNzNTS0lOTlkpIHx8Ci0JCQkoaW5zdGFuY2Ut
PnBkZXYtPmRldmljZSA9PQotCQkJCVBDSV9ERVZJQ0VfSURfTFNJX1NBUzAwNzFTS0lOTlkpKSB7
CisJCQkgICAgIFBDSV9ERVZJQ0VfSURfTFNJX1NBUzAwNzNTS0lOTlkpIHx8CisJCQkJKGluc3Rh
bmNlLT5wZGV2LT5kZXZpY2UgPT0KKwkJCQkgUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3MVNLSU5O
WSkgfHwKKwkJCSAgICAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PQorCQkJICAgICBQQ0lfREVW
SUNFX0lEX0xTSV9GVVNJT04pKSB7CiAJCQkJd3JpdGVsKE1GSV9JTklUX0hPVFBMVUcsCi0JCQkJ
Jmluc3RhbmNlLT5yZWdfc2V0LT5yZXNlcnZlZF8wWzBdKTsKKwkJCQkgICAgICAgJmluc3RhbmNl
LT5yZWdfc2V0LT5kb29yYmVsbCk7CiAJCQl9IGVsc2UKIAkJCQl3cml0ZWwoTUZJX0lOSVRfSE9U
UExVRywKIAkJCQkJJmluc3RhbmNlLT5yZWdfc2V0LT5pbmJvdW5kX2Rvb3JiZWxsKTsKQEAgLTI1
OTUsOSArMjY2MSwyMyBAQAogCQkJaWYgKChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09CiAJCQkJ
UENJX0RFVklDRV9JRF9MU0lfU0FTMDA3M1NLSU5OWSkgfHwKIAkJCQkoaW5zdGFuY2UtPnBkZXYt
PmRldmljZSA9PQotCQkJCVBDSV9ERVZJQ0VfSURfTFNJX1NBUzAwNzFTS0lOTlkpKSB7CisJCQkJ
UENJX0RFVklDRV9JRF9MU0lfU0FTMDA3MVNLSU5OWSkgIHx8CisJCQkJKGluc3RhbmNlLT5wZGV2
LT5kZXZpY2UKKwkJCQkJPT0gUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OKSkgewogCQkJCXdyaXRl
bChNRklfUkVTRVRfRkxBR1MsCi0JCQkJCSZpbnN0YW5jZS0+cmVnX3NldC0+cmVzZXJ2ZWRfMFsw
XSk7CisJCQkJCSZpbnN0YW5jZS0+cmVnX3NldC0+ZG9vcmJlbGwpOworCQkJCWlmIChpbnN0YW5j
ZS0+cGRldi0+ZGV2aWNlID09CisJCQkJICAgIFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTikgewor
CQkJCQlmb3IgKGkgPSAwOyBpIDwgKDEwICogMTAwMCk7IGkgKz0gMjApIHsKKwkJCQkJCWlmIChy
ZWFkbCgKKwkJCQkJCQkgICAgJmluc3RhbmNlLT4KKwkJCQkJCQkgICAgcmVnX3NldC0+CisJCQkJ
CQkJICAgIGRvb3JiZWxsKSAmIDEpCisJCQkJCQkJbXNsZWVwKDIwKTsKKwkJCQkJCWVsc2UKKwkJ
CQkJCQlicmVhazsKKwkJCQkJfQorCQkJCX0KIAkJCX0gZWxzZQogCQkJCXdyaXRlbChNRklfUkVT
RVRfRkxBR1MsCiAJCQkJCSZpbnN0YW5jZS0+cmVnX3NldC0+aW5ib3VuZF9kb29yYmVsbCk7CkBA
IC0yNjgxLDcgKzI3NjEsNyBAQAogc3RhdGljIHZvaWQgbWVnYXNhc190ZWFyZG93bl9mcmFtZV9w
b29sKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKIHsKIAlpbnQgaTsKLQl1MzIg
bWF4X2NtZCA9IGluc3RhbmNlLT5tYXhfZndfY21kczsKKwl1MzIgbWF4X2NtZCA9IGluc3RhbmNl
LT5tYXhfbWZpX2NtZHM7CiAJc3RydWN0IG1lZ2FzYXNfY21kICpjbWQ7CiAKIAlpZiAoIWluc3Rh
bmNlLT5mcmFtZV9kbWFfcG9vbCkKQEAgLTI3MzIsNyArMjgxMiw3IEBACiAJdTMyIGZyYW1lX2Nv
dW50OwogCXN0cnVjdCBtZWdhc2FzX2NtZCAqY21kOwogCi0JbWF4X2NtZCA9IGluc3RhbmNlLT5t
YXhfZndfY21kczsKKwltYXhfY21kID0gaW5zdGFuY2UtPm1heF9tZmlfY21kczsKIAogCS8qCiAJ
ICogU2l6ZSBvZiBvdXIgZnJhbWUgaXMgNjQgYnl0ZXMgZm9yIE1GSSBmcmFtZSwgZm9sbG93ZWQg
YnkgbWF4IFNHCkBAIC0yODE5LDE0ICsyODk5LDE1IEBACiAgKiBtZWdhc2FzX2ZyZWVfY21kcyAt
CUZyZWUgYWxsIHRoZSBjbWRzIGluIHRoZSBmcmVlIGNtZCBwb29sCiAgKiBAaW5zdGFuY2U6CQlB
ZGFwdGVyIHNvZnQgc3RhdGUKICAqLwotc3RhdGljIHZvaWQgbWVnYXNhc19mcmVlX2NtZHMoc3Ry
dWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKQordm9pZCBtZWdhc2FzX2ZyZWVfY21kcyhz
dHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCiB7CiAJaW50IGk7CiAJLyogRmlyc3Qg
ZnJlZSB0aGUgTUZJIGZyYW1lIHBvb2wgKi8KIAltZWdhc2FzX3RlYXJkb3duX2ZyYW1lX3Bvb2wo
aW5zdGFuY2UpOwogCiAJLyogRnJlZSBhbGwgdGhlIGNvbW1hbmRzIGluIHRoZSBjbWRfbGlzdCAq
LwotCWZvciAoaSA9IDA7IGkgPCBpbnN0YW5jZS0+bWF4X2Z3X2NtZHM7IGkrKykKKwlmb3IgKGkg
PSAwOyBpIDwgaW5zdGFuY2UtPm1heF9tZmlfY21kczsgaSsrKQorCiAJCWtmcmVlKGluc3RhbmNl
LT5jbWRfbGlzdFtpXSk7CiAKIAkvKiBGcmVlIHRoZSBjbWRfbGlzdCBidWZmZXIgaXRzZWxmICov
CkBAIC0yODU0LDE0ICsyOTM1LDE0IEBACiAgKiBUaGlzIGFycmF5IGlzIHVzZWQgb25seSB0byBs
b29rIHVwIHRoZSBtZWdhc2FzX2NtZCBnaXZlbiB0aGUgY29udGV4dC4gVGhlCiAgKiBmcmVlIGNv
bW1hbmRzIHRoZW1zZWx2ZXMgYXJlIG1haW50YWluZWQgaW4gYSBsaW5rZWQgbGlzdCBjYWxsZWQg
Y21kX3Bvb2wuCiAgKi8KLXN0YXRpYyBpbnQgbWVnYXNhc19hbGxvY19jbWRzKHN0cnVjdCBtZWdh
c2FzX2luc3RhbmNlICppbnN0YW5jZSkKK2ludCBtZWdhc2FzX2FsbG9jX2NtZHMoc3RydWN0IG1l
Z2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKQogewogCWludCBpOwogCWludCBqOwogCXUzMiBtYXhf
Y21kOwogCXN0cnVjdCBtZWdhc2FzX2NtZCAqY21kOwogCi0JbWF4X2NtZCA9IGluc3RhbmNlLT5t
YXhfZndfY21kczsKKwltYXhfY21kID0gaW5zdGFuY2UtPm1heF9tZmlfY21kczsKIAogCS8qCiAJ
ICogaW5zdGFuY2UtPmNtZF9saXN0IGlzIGFuIGFycmF5IG9mIHN0cnVjdCBtZWdhc2FzX2NtZCBw
b2ludGVycy4KQEAgLTI4NzUsNiArMjk1Niw3IEBACiAJCXJldHVybiAtRU5PTUVNOwogCX0KIAor
CW1lbXNldChpbnN0YW5jZS0+Y21kX2xpc3QsIDAsIHNpemVvZihzdHJ1Y3QgbWVnYXNhc19jbWQg
KikgKm1heF9jbWQpOwogCiAJZm9yIChpID0gMDsgaSA8IG1heF9jbWQ7IGkrKykgewogCQlpbnN0
YW5jZS0+Y21kX2xpc3RbaV0gPSBrbWFsbG9jKHNpemVvZihzdHJ1Y3QgbWVnYXNhc19jbWQpLApA
QCAtMzI4OCw2ICszMzcwLDcgQEAKIAkgKiBkb2VzIG5vdCBleGNlZWQgbWF4IGNtZHMgdGhhdCB0
aGUgRlcgY2FuIHN1cHBvcnQKIAkgKi8KIAlpbnN0YW5jZS0+bWF4X2Z3X2NtZHMgPSBpbnN0YW5j
ZS0+bWF4X2Z3X2NtZHMtMTsKKwlpbnN0YW5jZS0+bWF4X21maV9jbWRzID0gaW5zdGFuY2UtPm1h
eF9md19jbWRzOwogCWluc3RhbmNlLT5tYXhfbnVtX3NnZSA9IChpbnN0YW5jZS0+aW5zdGFuY2V0
LT5yZWFkX2Z3X3N0YXR1c19yZWcocmVnX3NldCkgJiAweEZGMDAwMCkgPj4gCiAJCQkJCTB4MTA7
CiAJLyoKQEAgLTMzODEsNiArMzQ2NCw5IEBACiAJcmVnX3NldCA9IGluc3RhbmNlLT5yZWdfc2V0
OwogCiAJc3dpdGNoIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlKSB7CisJY2FzZSBQQ0lfREVWSUNF
X0lEX0xTSV9GVVNJT046CisJCWluc3RhbmNlLT5pbnN0YW5jZXQgPSAmbWVnYXNhc19pbnN0YW5j
ZV90ZW1wbGF0ZV9mdXNpb247CisJCWJyZWFrOwogCWNhc2UgUENJX0RFVklDRV9JRF9MU0lfU0FT
MTA3OFI6CiAJY2FzZSBQQ0lfREVWSUNFX0lEX0xTSV9TQVMxMDc4REU6CiAJCWluc3RhbmNlLT5p
bnN0YW5jZXQgPSAmbWVnYXNhc19pbnN0YW5jZV90ZW1wbGF0ZV9wcGM7CkBAIC0zNDgyLDkgKzM1
NjgsMTAgQEAKICAqLwogc3RhdGljIHZvaWQgbWVnYXNhc19yZWxlYXNlX21maShzdHJ1Y3QgbWVn
YXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCiB7Ci0JdTMyIHJlcGx5X3Ffc3ogPSBzaXplb2YodTMy
KSAqIChpbnN0YW5jZS0+bWF4X2Z3X2NtZHMgKyAxKTsKKwl1MzIgcmVwbHlfcV9zeiA9IHNpemVv
Zih1MzIpICooaW5zdGFuY2UtPm1heF9tZmlfY21kcyArIDEpOwogCi0JcGNpX2ZyZWVfY29uc2lz
dGVudChpbnN0YW5jZS0+cGRldiwgcmVwbHlfcV9zeiwKKwlpZiAoaW5zdGFuY2UtPnJlcGx5X3F1
ZXVlKQorCQlwY2lfZnJlZV9jb25zaXN0ZW50KGluc3RhbmNlLT5wZGV2LCByZXBseV9xX3N6LAog
CQkJICAgIGluc3RhbmNlLT5yZXBseV9xdWV1ZSwgaW5zdGFuY2UtPnJlcGx5X3F1ZXVlX2gpOwog
CiAJbWVnYXNhc19mcmVlX2NtZHMoaW5zdGFuY2UpOwpAQCAtMzY3OCw4ICszNzY1LDcgQEAKIAkv
KgogCSAqIElzc3VlIHRoZSBhZW4gcmVnaXN0cmF0aW9uIGZyYW1lCiAJICovCi0JaW5zdGFuY2Ut
Pmluc3RhbmNldC0+ZmlyZV9jbWQoaW5zdGFuY2UsCi0JCQljbWQtPmZyYW1lX3BoeXNfYWRkciwg
MCwgaW5zdGFuY2UtPnJlZ19zZXQpOworCWluc3RhbmNlLT5pbnN0YW5jZXQtPmlzc3VlX2RjbWQo
aW5zdGFuY2UsIGNtZCk7CiAKIAlyZXR1cm4gMDsKIH0KQEAgLTM3NTYsMTIgKzM4NDIsMTggQEAK
IAl9CiAKIAlob3N0LT5tYXhfc2VjdG9ycyA9IGluc3RhbmNlLT5tYXhfc2VjdG9yc19wZXJfcmVx
OwotCWhvc3QtPmNtZF9wZXJfbHVuID0gMTI4OworCWhvc3QtPmNtZF9wZXJfbHVuID0gTUVHQVNB
U19ERUZBVUxUX0NNRF9QRVJfTFVOOwogCWhvc3QtPm1heF9jaGFubmVsID0gTUVHQVNBU19NQVhf
Q0hBTk5FTFMgLSAxOwogCWhvc3QtPm1heF9pZCA9IE1FR0FTQVNfTUFYX0RFVl9QRVJfQ0hBTk5F
TDsKIAlob3N0LT5tYXhfbHVuID0gTUVHQVNBU19NQVhfTFVOOwogCWhvc3QtPm1heF9jbWRfbGVu
ID0gMTY7CiAKKwkvKiBGdXNpb24gb25seSBzdXBwb3J0cyBob3N0IHJlc2V0ICovCisJaWYgKGlu
c3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OKSB7CisJCWhv
c3QtPmhvc3R0LT5laF9kZXZpY2VfcmVzZXRfaGFuZGxlciA9IE5VTEw7CisJCWhvc3QtPmhvc3R0
LT5laF9idXNfcmVzZXRfaGFuZGxlciA9IE5VTEw7CisJfQorCiAJLyoKIAkgKiBOb3RpZnkgdGhl
IG1pZC1sYXllciBhYm91dCB0aGUgbmV3IGNvbnRyb2xsZXIKIAkgKi8KQEAgLTM4NDYsMjAgKzM5
MzgsNDUgQEAKIAlpbnN0YW5jZSA9IChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqKWhvc3QtPmhv
c3RkYXRhOwogCW1lbXNldChpbnN0YW5jZSwgMCwgc2l6ZW9mKCppbnN0YW5jZSkpOwogCWF0b21p
Y19zZXQoICZpbnN0YW5jZS0+ZndfcmVzZXRfbm9fcGNpX2FjY2VzcywgMCApOworCWluc3RhbmNl
LT5wZGV2ID0gcGRldjsKIAotCWluc3RhbmNlLT5wcm9kdWNlciA9IHBjaV9hbGxvY19jb25zaXN0
ZW50KHBkZXYsIHNpemVvZih1MzIpLAotCQkJCQkJICAmaW5zdGFuY2UtPnByb2R1Y2VyX2gpOwot
CWluc3RhbmNlLT5jb25zdW1lciA9IHBjaV9hbGxvY19jb25zaXN0ZW50KHBkZXYsIHNpemVvZih1
MzIpLAotCQkJCQkJICAmaW5zdGFuY2UtPmNvbnN1bWVyX2gpOworCXN3aXRjaCAoaW5zdGFuY2Ut
PnBkZXYtPmRldmljZSkgeworCWNhc2UgUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OOgorCXsKKwkJ
c3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb247CisKKwkJaW5zdGFuY2UtPmN0cmxfY29udGV4
dCA9CisJCQlremFsbG9jKHNpemVvZihzdHJ1Y3QgZnVzaW9uX2NvbnRleHQpLCBHRlBfS0VSTkVM
KTsKKwkJaWYgKCFpbnN0YW5jZS0+Y3RybF9jb250ZXh0KSB7CisJCQlwcmludGsoS0VSTl9ERUJV
RyAibWVnYXNhczogRmFpbGVkIHRvIGFsbG9jYXRlICIKKwkJCSAgICAgICAibWVtb3J5IGZvciBG
dXNpb24gY29udGV4dCBpbmZvXG4iKTsKKwkJCWdvdG8gZmFpbF9hbGxvY19kbWFfYnVmOworCQl9
CisJCWZ1c2lvbiA9IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CisJCUlOSVRfTElTVF9IRUFEKCZm
dXNpb24tPmNtZF9wb29sKTsKKwkJc3Bpbl9sb2NrX2luaXQoJmZ1c2lvbi0+Y21kX3Bvb2xfbG9j
ayk7CisJfQorCWJyZWFrOworCWRlZmF1bHQ6IC8qIEZvciBhbGwgb3RoZXIgc3VwcG9ydGVkIGNv
bnRyb2xsZXJzICovCisKKwkJaW5zdGFuY2UtPnByb2R1Y2VyID0KKwkJCXBjaV9hbGxvY19jb25z
aXN0ZW50KHBkZXYsIHNpemVvZih1MzIpLAorCQkJCQkgICAgICZpbnN0YW5jZS0+cHJvZHVjZXJf
aCk7CisJCWluc3RhbmNlLT5jb25zdW1lciA9CisJCQlwY2lfYWxsb2NfY29uc2lzdGVudChwZGV2
LCBzaXplb2YodTMyKSwKKwkJCQkJICAgICAmaW5zdGFuY2UtPmNvbnN1bWVyX2gpOworCisJCWlm
ICghaW5zdGFuY2UtPnByb2R1Y2VyIHx8ICFpbnN0YW5jZS0+Y29uc3VtZXIpIHsKKwkJCXByaW50
ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBGYWlsZWQgdG8gYWxsb2NhdGUiCisJCQkgICAgICAgIm1l
bW9yeSBmb3IgcHJvZHVjZXIsIGNvbnN1bWVyXG4iKTsKKwkJCWdvdG8gZmFpbF9hbGxvY19kbWFf
YnVmOworCQl9CiAKLQlpZiAoIWluc3RhbmNlLT5wcm9kdWNlciB8fCAhaW5zdGFuY2UtPmNvbnN1
bWVyKSB7Ci0JCXByaW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBGYWlsZWQgdG8gYWxsb2NhdGUg
bWVtb3J5IGZvciAiCi0JCSAgICAgICAicHJvZHVjZXIsIGNvbnN1bWVyXG4iKTsKLQkJZ290byBm
YWlsX2FsbG9jX2RtYV9idWY7CisJCSppbnN0YW5jZS0+cHJvZHVjZXIgPSAwOworCQkqaW5zdGFu
Y2UtPmNvbnN1bWVyID0gMDsKKwkJYnJlYWs7CiAJfQogCi0JKmluc3RhbmNlLT5wcm9kdWNlciA9
IDA7Ci0JKmluc3RhbmNlLT5jb25zdW1lciA9IDA7CiAJbWVnYXNhc19wb2xsX3dhaXRfYWVuID0g
MDsKIAlpbnN0YW5jZS0+ZmxhZ19pZWVlID0gMDsKIAlpbnN0YW5jZS0+ZXYgPSBOVUxMOwpAQCAt
Mzg5NSwxMSArNDAxMiwxMSBAQAogCXNwaW5fbG9ja19pbml0KCZwb2xsX2Flbl9sb2NrKTsKIAog
CW11dGV4X2luaXQoJmluc3RhbmNlLT5hZW5fbXV0ZXgpOworCW11dGV4X2luaXQoJmluc3RhbmNl
LT5yZXNldF9tdXRleCk7CiAKIAkvKgogCSAqIEluaXRpYWxpemUgUENJIHJlbGF0ZWQgYW5kIG1p
c2MgcGFyYW1ldGVycwogCSAqLwotCWluc3RhbmNlLT5wZGV2ID0gcGRldjsKIAlpbnN0YW5jZS0+
aG9zdCA9IGhvc3Q7CiAJaW5zdGFuY2UtPnVuaXF1ZV9pZCA9IHBkZXYtPmJ1cy0+bnVtYmVyIDw8
IDggfCBwZGV2LT5kZXZmbjsKIAlpbnN0YW5jZS0+aW5pdF9pZCA9IE1FR0FTQVNfREVGQVVMVF9J
TklUX0lEOwpAQCAtMzkxNyw3ICs0MDM0LDEwIEBACiAJaW5zdGFuY2UtPmxhc3RfdGltZSA9IDA7
CiAJaW5zdGFuY2UtPmRpc2FibGVPbmxpbmVDdHJsUmVzZXQgPSAxOwogCi0JSU5JVF9XT1JLKCZp
bnN0YW5jZS0+d29ya19pbml0LCBwcm9jZXNzX2Z3X3N0YXRlX2NoYW5nZV93cSk7CisJaWYgKGlu
c3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OKQorCQlJTklU
X1dPUksoJmluc3RhbmNlLT53b3JrX2luaXQsIG1lZ2FzYXNfZnVzaW9uX29jcl93cSk7CisJZWxz
ZQorCQlJTklUX1dPUksoJmluc3RhbmNlLT53b3JrX2luaXQsIHByb2Nlc3NfZndfc3RhdGVfY2hh
bmdlX3dxKTsKIAogCS8qCiAJICogSW5pdGlhbGl6ZSBNRkkgRmlybXdhcmUKQEAgLTQwMDAsNiAr
NDEyMCw4IEBACiAJCXBjaV9mcmVlX2NvbnNpc3RlbnQocGRldiwgc2l6ZW9mKHUzMiksIGluc3Rh
bmNlLT5wcm9kdWNlciwKIAkJCQkgICAgaW5zdGFuY2UtPnByb2R1Y2VyX2gpOwogCQltZWdhc2Fz
X3JlbGVhc2VfbWZpKGluc3RhbmNlKTsKKwl9IGVsc2UgeworCQltZWdhc2FzX3JlbGVhc2VfZnVz
aW9uKGluc3RhbmNlKTsKIAl9CiAJaWYgKGluc3RhbmNlLT5jb25zdW1lcikKIAkJcGNpX2ZyZWVf
Y29uc2lzdGVudChwZGV2LCBzaXplb2YodTMyKSwgaW5zdGFuY2UtPmNvbnN1bWVyLApAQCAtNDA3
Miw3ICs0MTk0LDkgQEAKIAogCWlmIChpbnN0YW5jZS0+YWVuX2NtZCkKIAkJbWVnYXNhc19pc3N1
ZV9ibG9ja2VkX2Fib3J0X2NtZChpbnN0YW5jZSwgaW5zdGFuY2UtPmFlbl9jbWQpOwotCisJaWYg
KGluc3RhbmNlLT5tYXBfdXBkYXRlX2NtZCkKKwkJbWVnYXNhc19pc3N1ZV9ibG9ja2VkX2Fib3J0
X2NtZChpbnN0YW5jZSwKKwkJCQkJCWluc3RhbmNlLT5tYXBfdXBkYXRlX2NtZCk7CiAJZGNtZCA9
ICZjbWQtPmZyYW1lLT5kY21kOwogCiAJbWVtc2V0KGRjbWQtPm1ib3guYiwgMCwgTUZJX01CT1hf
U0laRSk7CkBAIC00MTc3LDkgKzQzMDEsNiBAQAogCSAqIEluaXRpYWxpemUgTUZJIEZpcm13YXJl
CiAJICovCiAKLQkqaW5zdGFuY2UtPnByb2R1Y2VyID0gMDsKLQkqaW5zdGFuY2UtPmNvbnN1bWVy
ID0gMDsKLQogCWF0b21pY19zZXQoJmluc3RhbmNlLT5md19vdXRzdGFuZGluZywgMCk7CiAKIAkv
KgpAQCAtNDE4OCwxMSArNDMwOSwyOSBAQAogCWlmIChtZWdhc2FzX3RyYW5zaXRpb25fdG9fcmVh
ZHkoaW5zdGFuY2UpKQogCQlnb3RvIGZhaWxfcmVhZHlfc3RhdGU7CiAKLQlpZiAobWVnYXNhc19p
c3N1ZV9pbml0X21maShpbnN0YW5jZSkpCi0JCWdvdG8gZmFpbF9pbml0X21maTsKKwlzd2l0Y2gg
KGluc3RhbmNlLT5wZGV2LT5kZXZpY2UpIHsKKwljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lP
TjoKKwl7CisJCW1lZ2FzYXNfcmVzZXRfcmVwbHlfZGVzYyhpbnN0YW5jZSk7CisJCWlmIChtZWdh
c2FzX2lvY19pbml0X2Z1c2lvbihpbnN0YW5jZSkpIHsKKwkJCW1lZ2FzYXNfZnJlZV9jbWRzKGlu
c3RhbmNlKTsKKwkJCW1lZ2FzYXNfZnJlZV9jbWRzX2Z1c2lvbihpbnN0YW5jZSk7CisJCQlnb3Rv
IGZhaWxfaW5pdF9tZmk7CisJCX0KKwkJaWYgKCFtZWdhc2FzX2dldF9tYXBfaW5mbyhpbnN0YW5j
ZSkpCisJCQltZWdhc2FzX3N5bmNfbWFwX2luZm8oaW5zdGFuY2UpOworCX0KKwlicmVhazsKKwlk
ZWZhdWx0OgorCQkqaW5zdGFuY2UtPnByb2R1Y2VyID0gMDsKKwkJKmluc3RhbmNlLT5jb25zdW1l
ciA9IDA7CisJCWlmIChtZWdhc2FzX2lzc3VlX2luaXRfbWZpKGluc3RhbmNlKSkKKwkJCWdvdG8g
ZmFpbF9pbml0X21maTsKKwkJYnJlYWs7CisJfQogCi0JdGFza2xldF9pbml0KCZpbnN0YW5jZS0+
aXNyX3Rhc2tsZXQsIG1lZ2FzYXNfY29tcGxldGVfY21kX2RwYywKLQkJCSh1bnNpZ25lZCBsb25n
KWluc3RhbmNlKTsKKwl0YXNrbGV0X2luaXQoJmluc3RhbmNlLT5pc3JfdGFza2xldCwgaW5zdGFu
Y2UtPmluc3RhbmNldC0+dGFza2xldCwKKwkJICAgICAodW5zaWduZWQgbG9uZylpbnN0YW5jZSk7
CiAKIAkvKiBOb3cgcmUtZW5hYmxlIE1TSS1YICovCiAJaWYgKGluc3RhbmNlLT5tc2lfZmxhZykK
QEAgLTQyNjEsMTAgKzQ0MDAsMTIgQEAKIAlpbnQgaTsKIAlzdHJ1Y3QgU2NzaV9Ib3N0ICpob3N0
OwogCXN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZTsKKwlzdHJ1Y3QgZnVzaW9uX2Nv
bnRleHQgKmZ1c2lvbjsKIAogCWluc3RhbmNlID0gcGNpX2dldF9kcnZkYXRhKHBkZXYpOwogCWlu
c3RhbmNlLT51bmxvYWQgPSAxOwogCWhvc3QgPSBpbnN0YW5jZS0+aG9zdDsKKwlmdXNpb24gPSBp
bnN0YW5jZS0+Y3RybF9jb250ZXh0OwogCiAJaWYgKHBvbGxfbW9kZV9pbykKIAkJZGVsX3RpbWVy
X3N5bmMoJmluc3RhbmNlLT5pb19jb21wbGV0aW9uX3RpbWVyKTsKQEAgLTQzMDYsMTYgKzQ0NDcs
MzIgQEAKIAlpZiAoaW5zdGFuY2UtPm1zaV9mbGFnKQogCQlwY2lfZGlzYWJsZV9tc2l4KGluc3Rh
bmNlLT5wZGV2KTsKIAotCW1lZ2FzYXNfcmVsZWFzZV9tZmkoaW5zdGFuY2UpOwotCi0JcGNpX2Zy
ZWVfY29uc2lzdGVudChwZGV2LCBzaXplb2Yoc3RydWN0IG1lZ2FzYXNfZXZ0X2RldGFpbCksCi0J
CQkgICAgaW5zdGFuY2UtPmV2dF9kZXRhaWwsIGluc3RhbmNlLT5ldnRfZGV0YWlsX2gpOwotCi0J
cGNpX2ZyZWVfY29uc2lzdGVudChwZGV2LCBzaXplb2YodTMyKSwgaW5zdGFuY2UtPnByb2R1Y2Vy
LAotCQkJICAgIGluc3RhbmNlLT5wcm9kdWNlcl9oKTsKLQotCXBjaV9mcmVlX2NvbnNpc3RlbnQo
cGRldiwgc2l6ZW9mKHUzMiksIGluc3RhbmNlLT5jb25zdW1lciwKLQkJCSAgICBpbnN0YW5jZS0+
Y29uc3VtZXJfaCk7CisJc3dpdGNoIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlKSB7CisJY2FzZSBQ
Q0lfREVWSUNFX0lEX0xTSV9GVVNJT046CisJCW1lZ2FzYXNfcmVsZWFzZV9mdXNpb24oaW5zdGFu
Y2UpOworCQlmb3IgKGkgPSAwOyBpIDwgMiA7IGkrKykKKwkJCWlmIChmdXNpb24tPmxkX21hcFtp
XSkKKwkJCQlkbWFfZnJlZV9jb2hlcmVudCgmaW5zdGFuY2UtPnBkZXYtPmRldiwKKwkJCQkJCSAg
ZnVzaW9uLT5tYXBfc3osCisJCQkJCQkgIGZ1c2lvbi0+bGRfbWFwW2ldLAorCQkJCQkJICBmdXNp
b24tPgorCQkJCQkJICBsZF9tYXBfcGh5c1tpXSk7CisJCWtmcmVlKGluc3RhbmNlLT5jdHJsX2Nv
bnRleHQpOworCQlicmVhazsKKwlkZWZhdWx0OgorCQltZWdhc2FzX3JlbGVhc2VfbWZpKGluc3Rh
bmNlKTsKKwkJcGNpX2ZyZWVfY29uc2lzdGVudChwZGV2LAorCQkJCSAgICBzaXplb2Yoc3RydWN0
IG1lZ2FzYXNfZXZ0X2RldGFpbCksCisJCQkJICAgIGluc3RhbmNlLT5ldnRfZGV0YWlsLAorCQkJ
CSAgICBpbnN0YW5jZS0+ZXZ0X2RldGFpbF9oKTsKKwkJcGNpX2ZyZWVfY29uc2lzdGVudChwZGV2
LCBzaXplb2YodTMyKSwKKwkJCQkgICAgaW5zdGFuY2UtPnByb2R1Y2VyLAorCQkJCSAgICBpbnN0
YW5jZS0+cHJvZHVjZXJfaCk7CisJCXBjaV9mcmVlX2NvbnNpc3RlbnQocGRldiwgc2l6ZW9mKHUz
MiksCisJCQkJICAgIGluc3RhbmNlLT5jb25zdW1lciwKKwkJCQkgICAgaW5zdGFuY2UtPmNvbnN1
bWVyX2gpOworCQlicmVhazsKKwl9CiAKIAlzY3NpX2hvc3RfcHV0KGhvc3QpOwogCkBAIC01MDc5
LDYgKzUyMzYsNyBAQAogCQkJYnJlYWs7CiAJCWNhc2UgTVJfRVZUX0NUUkxfSE9TVF9CVVNfU0NB
Tl9SRVFVRVNURUQ6CiAJCWNhc2UgTVJfRVZUX0ZPUkVJR05fQ0ZHX0lNUE9SVEVEOgorCQljYXNl
IE1SX0VWVF9MRF9TVEFURV9DSEFOR0U6CiAJCQlkb3NjYW4gPSAxOwogCQkJYnJlYWs7CiAJCWRl
ZmF1bHQ6Cg==
--00163683204e9f56a404976a26b6--
