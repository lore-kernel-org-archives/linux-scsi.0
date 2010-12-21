From: adam radford <aradford@gmail.com>
Subject: [PATCH 6-10/11]: REPOST: megaraid_sas: Add 9565/9285 specific code
Date: Tue, 21 Dec 2010 11:19:15 -0800
Message-ID: <AANLkTiknH+_vCKsbuBN+mYWRtbgHVu5_HtmHm6KS_0c0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=00163630ffe327cf3d0497f08362
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:52149 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525Ab0LUTTQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Dec 2010 14:19:16 -0500
Received: by qwa26 with SMTP id 26so4327823qwa.19
        for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2010 11:19:15 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--00163630ffe327cf3d0497f08362
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

REPOST patches 6 thru 10 into a single patch.

Add MegaRAID 9265/9285 specific code to megaraid_sas_base.c.
Add MegaRAID 9265/9285 specific functions: megaraid_sas_fusion.c
Add MegaRAID 9265/9285 megaraid_sas_fusion.h header.
Add MegaRAID 9265/9285 FastPath code.
Add MegaRAID 9265/9285 specific code to megaraid_sas.h.

Singed-off-by: Adam Radford <aradford@gmail.com>

Note: The patch has been included in-line below, and also as an
attachment in case Gmail hoses the patch.

diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/Makefile
linux-2.6.37-rc5.new/drivers/scsi/megaraid/Makefile
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/Makefile	2010-12-21
09:45:41.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/Makefile	2010-12-21
11:04:08.000000000 -0800
@@ -1,4 +1,5 @@
 obj-$(CONFIG_MEGARAID_MM)	+= megaraid_mm.o
 obj-$(CONFIG_MEGARAID_MAILBOX)	+= megaraid_mbox.o
 obj-$(CONFIG_MEGARAID_SAS)	+= megaraid_sas.o
-megaraid_sas-objs := megaraid_sas_base.o
+megaraid_sas-objs := megaraid_sas_base.o megaraid_sas_fusion.o \
+	megaraid_sas_fp.o
diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_base.c
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_base.c	2010-12-21
10:06:27.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_base.c	2010-12-21
11:04:04.000000000 -0800
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
diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_fp.c
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_fp.c
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_fp.c	1969-12-31
16:00:00.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_fp.c	2010-12-21
11:04:08.000000000 -0800
@@ -0,0 +1,516 @@
+/*
+ *  Linux MegaRAID driver for SAS based RAID controllers
+ *
+ *  Copyright (c) 2009-2011  LSI Corporation.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ *  FILE: megaraid_sas_fp.c
+ *
+ *  Authors: LSI Corporation
+ *           Sumant Patro
+ *           Varad Talamacki
+ *           Manoj Jose
+ *
+ *  Send feedback to: <megaraidlinux@lsi.com>
+ *
+ *  Mail to: LSI Corporation, 1621 Barber Lane, Milpitas, CA 95035
+ *     ATTN: Linuxraid
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/list.h>
+#include <linux/moduleparam.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/smp_lock.h>
+#include <linux/uio.h>
+#include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/compat.h>
+#include <linux/blkdev.h>
+#include <linux/poll.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+
+#include "megaraid_sas_fusion.h"
+#include <asm/div64.h>
+
+#define ABS_DIFF(a, b)   (((a) > (b)) ? ((a) - (b)) : ((b) - (a)))
+#define MR_LD_STATE_OPTIMAL 3
+#define FALSE 0
+#define TRUE 1
+
+/* Prototypes */
+void
+mr_update_load_balance_params(struct MR_FW_RAID_MAP_ALL *map,
+			      struct LD_LOAD_BALANCE_INFO *lbInfo);
+
+u32 mega_mod64(u64 dividend, u32 divisor)
+{
+	u64 d;
+	u32 remainder;
+
+	if (!divisor)
+		printk(KERN_ERR "megasas : DIVISOR is zero, in div fn\n");
+	d = dividend;
+	remainder = do_div(d, divisor);
+	return remainder;
+}
+
+/**
+ * @param dividend    : Dividend
+ * @param divisor    : Divisor
+ *
+ * @return quotient
+ **/
+u64 mega_div64_32(uint64_t dividend, uint32_t divisor)
+{
+	u32 remainder;
+	u64 d;
+
+	if (!divisor)
+		printk(KERN_ERR "megasas : DIVISOR is zero in mod fn\n");
+
+	d = dividend;
+	remainder = do_div(d, divisor);
+
+	return d;
+}
+
+struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct MR_FW_RAID_MAP_ALL *map)
+{
+	return &map->raidMap.ldSpanMap[ld].ldRaid;
+}
+
+static struct MR_SPAN_BLOCK_INFO *MR_LdSpanInfoGet(u32 ld,
+						   struct MR_FW_RAID_MAP_ALL
+						   *map)
+{
+	return &map->raidMap.ldSpanMap[ld].spanBlock[0];
+}
+
+static u8 MR_LdDataArmGet(u32 ld, u32 armIdx, struct MR_FW_RAID_MAP_ALL *map)
+{
+	return map->raidMap.ldSpanMap[ld].dataArmMap[armIdx];
+}
+
+static u16 MR_ArPdGet(u32 ar, u32 arm, struct MR_FW_RAID_MAP_ALL *map)
+{
+	return map->raidMap.arMapInfo[ar].pd[arm];
+}
+
+static u16 MR_LdSpanArrayGet(u32 ld, u32 span, struct MR_FW_RAID_MAP_ALL *map)
+{
+	return map->raidMap.ldSpanMap[ld].spanBlock[span].span.arrayRef;
+}
+
+static u16 MR_PdDevHandleGet(u32 pd, struct MR_FW_RAID_MAP_ALL *map)
+{
+	return map->raidMap.devHndlInfo[pd].curDevHdl;
+}
+
+u16 MR_GetLDTgtId(u32 ld, struct MR_FW_RAID_MAP_ALL *map)
+{
+	return map->raidMap.ldSpanMap[ld].ldRaid.targetId;
+}
+
+u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_FW_RAID_MAP_ALL *map)
+{
+	return map->raidMap.ldTgtIdToLd[ldTgtId];
+}
+
+static struct MR_LD_SPAN *MR_LdSpanPtrGet(u32 ld, u32 span,
+					  struct MR_FW_RAID_MAP_ALL *map)
+{
+	return &map->raidMap.ldSpanMap[ld].spanBlock[span].span;
+}
+
+/*
+ * This function will validate Map info data provided by FW
+ */
+u8 MR_ValidateMapInfo(struct MR_FW_RAID_MAP_ALL *map,
+		      struct LD_LOAD_BALANCE_INFO *lbInfo)
+{
+	struct MR_FW_RAID_MAP *pFwRaidMap = &map->raidMap;
+
+	if (pFwRaidMap->totalSize !=
+	    (sizeof(struct MR_FW_RAID_MAP) -sizeof(struct MR_LD_SPAN_MAP) +
+	     (sizeof(struct MR_LD_SPAN_MAP) *pFwRaidMap->ldCount))) {
+		printk(KERN_ERR "megasas: map info structure size 0x%x is not
matching with ld count\n",
+		       (unsigned int)((sizeof(struct MR_FW_RAID_MAP) -
+				       sizeof(struct MR_LD_SPAN_MAP)) +
+				      (sizeof(struct MR_LD_SPAN_MAP) *
+				       pFwRaidMap->ldCount)));
+		printk(KERN_ERR "megasas: span map %x, pFwRaidMap->totalSize "
+		       ": %x\n", (unsigned int)sizeof(struct MR_LD_SPAN_MAP),
+		       pFwRaidMap->totalSize);
+		return 0;
+	}
+
+	mr_update_load_balance_params(map, lbInfo);
+
+	return 1;
+}
+
+u32 MR_GetSpanBlock(u32 ld, u64 row, u64 *span_blk,
+		    struct MR_FW_RAID_MAP_ALL *map, int *div_error)
+{
+	struct MR_SPAN_BLOCK_INFO *pSpanBlock = MR_LdSpanInfoGet(ld, map);
+	struct MR_QUAD_ELEMENT    *quad;
+	struct MR_LD_RAID         *raid = MR_LdRaidGet(ld, map);
+	u32                span, j;
+
+	for (span = 0; span < raid->spanDepth; span++, pSpanBlock++) {
+
+		for (j = 0; j < pSpanBlock->block_span_info.noElements; j++) {
+			quad = &pSpanBlock->block_span_info.quad[j];
+
+			if (quad->diff == 0) {
+				*div_error = 1;
+				return span;
+			}
+			if (quad->logStart <= row  &&  row <= quad->logEnd  &&
+			    (mega_mod64(row-quad->logStart, quad->diff)) == 0) {
+				if (span_blk != NULL) {
+					u64  blk, debugBlk;
+					blk =
+						mega_div64_32(
+							(row-quad->logStart),
+							quad->diff);
+					debugBlk = blk;
+
+					blk = (blk + quad->offsetInSpan) <<
+						raid->stripeShift;
+					*span_blk = blk;
+				}
+				return span;
+			}
+		}
+	}
+	return span;
+}
+
+/*
+******************************************************************************
+*
+* This routine calculates the arm, span and block for the specified stripe and
+* reference in stripe.
+*
+* Inputs :
+*
+*    ld   - Logical drive number
+*    stripRow        - Stripe number
+*    stripRef    - Reference in stripe
+*
+* Outputs :
+*
+*    span          - Span number
+*    block         - Absolute Block number in the physical disk
+*/
+u8 MR_GetPhyParams(u32 ld, u64 stripRow, u16 stripRef, u64 *pdBlock,
+		   u16 *pDevHandle, struct RAID_CONTEXT *pRAID_Context,
+		   struct MR_FW_RAID_MAP_ALL *map)
+{
+	struct MR_LD_RAID  *raid = MR_LdRaidGet(ld, map);
+	u32         pd, arRef;
+	u8          physArm, span;
+	u64         row;
+	u8	    retval = TRUE;
+	int	    error_code = 0;
+
+	row =  mega_div64_32(stripRow, raid->rowDataSize);
+
+	if (raid->level == 6) {
+		/* logical arm within row */
+		u32 logArm =  mega_mod64(stripRow, raid->rowDataSize);
+		u32 rowMod, armQ, arm;
+
+		if (raid->rowSize == 0)
+			return FALSE;
+		/* get logical row mod */
+		rowMod = mega_mod64(row, raid->rowSize);
+		armQ = raid->rowSize-1-rowMod; /* index of Q drive */
+		arm = armQ+1+logArm; /* data always logically follows Q */
+		if (arm >= raid->rowSize) /* handle wrap condition */
+			arm -= raid->rowSize;
+		physArm = (u8)arm;
+	} else  {
+		if (raid->modFactor == 0)
+			return FALSE;
+		physArm = MR_LdDataArmGet(ld,  mega_mod64(stripRow,
+							  raid->modFactor),
+					  map);
+	}
+
+	if (raid->spanDepth == 1) {
+		span = 0;
+		*pdBlock = row << raid->stripeShift;
+	} else {
+		span = (u8)MR_GetSpanBlock(ld, row, pdBlock, map, &error_code);
+		if (error_code == 1)
+			return FALSE;
+	}
+
+	/* Get the array on which this span is present */
+	arRef       = MR_LdSpanArrayGet(ld, span, map);
+	pd          = MR_ArPdGet(arRef, physArm, map); /* Get the pd */
+
+	if (pd != MR_PD_INVALID)
+		/* Get dev handle from Pd. */
+		*pDevHandle = MR_PdDevHandleGet(pd, map);
+	else {
+		*pDevHandle = MR_PD_INVALID; /* set dev handle as invalid. */
+		if (raid->level >= 5)
+			pRAID_Context->regLockFlags = REGION_TYPE_EXCLUSIVE;
+		else if (raid->level == 1) {
+			/* Get alternate Pd. */
+			pd = MR_ArPdGet(arRef, physArm + 1, map);
+			if (pd != MR_PD_INVALID)
+				/* Get dev handle from Pd */
+				*pDevHandle = MR_PdDevHandleGet(pd, map);
+		}
+		retval = FALSE;
+	}
+
+	*pdBlock += stripRef + MR_LdSpanPtrGet(ld, span, map)->startBlk;
+	pRAID_Context->spanArm = (span << RAID_CTX_SPANARM_SPAN_SHIFT) |
+		physArm;
+	return retval;
+}
+
+/*
+******************************************************************************
+*
+* MR_BuildRaidContext function
+*
+* This function will initiate command processing.  The start/end row and strip
+* information is calculated then the lock is acquired.
+* This function will return 0 if region lock was acquired OR return num strips
+*/
+u8
+MR_BuildRaidContext(struct IO_REQUEST_INFO *io_info,
+		    struct RAID_CONTEXT *pRAID_Context,
+		    struct MR_FW_RAID_MAP_ALL *map)
+{
+	struct MR_LD_RAID  *raid;
+	u32         ld, stripSize, stripe_mask;
+	u64         endLba, endStrip, endRow, start_row, start_strip;
+	u64         regStart;
+	u32         regSize;
+	u8          num_strips, numRows;
+	u16         ref_in_start_stripe, ref_in_end_stripe;
+	u64         ldStartBlock;
+	u32         numBlocks, ldTgtId;
+	u8          isRead;
+	u8	    retval = 0;
+
+	ldStartBlock = io_info->ldStartBlock;
+	numBlocks = io_info->numBlocks;
+	ldTgtId = io_info->ldTgtId;
+	isRead = io_info->isRead;
+
+	ld = MR_TargetIdToLdGet(ldTgtId, map);
+	raid = MR_LdRaidGet(ld, map);
+
+	stripSize = 1 << raid->stripeShift;
+	stripe_mask = stripSize-1;
+	/*
+	 * calculate starting row and stripe, and number of strips and rows
+	 */
+	start_strip         = ldStartBlock >> raid->stripeShift;
+	ref_in_start_stripe = (u16)(ldStartBlock & stripe_mask);
+	endLba              = ldStartBlock + numBlocks - 1;
+	ref_in_end_stripe   = (u16)(endLba & stripe_mask);
+	endStrip            = endLba >> raid->stripeShift;
+	num_strips          = (u8)(endStrip - start_strip + 1); /* End strip */
+	if (raid->rowDataSize == 0)
+		return FALSE;
+	start_row           =  mega_div64_32(start_strip, raid->rowDataSize);
+	endRow              =  mega_div64_32(endStrip, raid->rowDataSize);
+	numRows             = (u8)(endRow - start_row + 1);
+
+	/*
+	 * calculate region info.
+	 */
+
+	/* assume region is at the start of the first row */
+	regStart            = start_row << raid->stripeShift;
+	/* assume this IO needs the full row - we'll adjust if not true */
+	regSize             = stripSize;
+
+	/* If IO spans more than 1 strip, fp is not possible
+	   FP is not possible for writes on non-0 raid levels
+	   FP is not possible if LD is not capable */
+	if (num_strips > 1 || (!isRead && raid->level != 0) ||
+	    !raid->capability.fpCapable) {
+		io_info->fpOkForIo = FALSE;
+	} else {
+		io_info->fpOkForIo = TRUE;
+	}
+
+	if (numRows == 1) {
+		/* single-strip IOs can always lock only the data needed */
+		if (num_strips == 1) {
+			regStart += ref_in_start_stripe;
+			regSize = numBlocks;
+		}
+		/* multi-strip IOs always need to full stripe locked */
+	} else {
+		if (start_strip == (start_row + 1) * raid->rowDataSize - 1) {
+			/* If the start strip is the last in the start row */
+			regStart += ref_in_start_stripe;
+			regSize = stripSize - ref_in_start_stripe;
+			/* initialize count to sectors from startref to end
+			   of strip */
+		}
+
+		if (numRows > 2)
+			/* Add complete rows in the middle of the transfer */
+			regSize += (numRows-2) << raid->stripeShift;
+
+		/* if IO ends within first strip of last row */
+		if (endStrip == endRow*raid->rowDataSize)
+			regSize += ref_in_end_stripe+1;
+		else
+			regSize += stripSize;
+	}
+
+	pRAID_Context->timeoutValue     = map->raidMap.fpPdIoTimeoutSec;
+	pRAID_Context->regLockFlags     = (isRead) ? REGION_TYPE_SHARED_READ :
+		raid->regTypeReqOnWrite;
+	pRAID_Context->VirtualDiskTgtId = raid->targetId;
+	pRAID_Context->regLockRowLBA    = regStart;
+	pRAID_Context->regLockLength    = regSize;
+	pRAID_Context->configSeqNum	= raid->seqNum;
+
+	/*Get Phy Params only if FP capable, or else leave it to MR firmware
+	  to do the calculation.*/
+	if (io_info->fpOkForIo) {
+		retval = MR_GetPhyParams(ld, start_strip, ref_in_start_stripe,
+					 &io_info->pdBlock,
+					 &io_info->devHandle, pRAID_Context,
+					 map);
+		/* If IO on an invalid Pd, then FP i snot possible */
+		if (io_info->devHandle == MR_PD_INVALID)
+			io_info->fpOkForIo = FALSE;
+		return retval;
+	} else if (isRead) {
+		uint stripIdx;
+		for (stripIdx = 0; stripIdx < num_strips; stripIdx++) {
+			if (!MR_GetPhyParams(ld, start_strip + stripIdx,
+					     ref_in_start_stripe,
+					     &io_info->pdBlock,
+					     &io_info->devHandle,
+					     pRAID_Context, map))
+				return TRUE;
+		}
+	}
+	return TRUE;
+}
+
+void
+mr_update_load_balance_params(struct MR_FW_RAID_MAP_ALL *map,
+			      struct LD_LOAD_BALANCE_INFO *lbInfo)
+{
+	int ldCount;
+	u16 ld;
+	struct MR_LD_RAID *raid;
+
+	for (ldCount = 0; ldCount < MAX_LOGICAL_DRIVES; ldCount++) {
+		ld = MR_TargetIdToLdGet(ldCount, map);
+		if (ld >= MAX_LOGICAL_DRIVES) {
+			lbInfo[ldCount].loadBalanceFlag = 0;
+			continue;
+		}
+
+		raid = MR_LdRaidGet(ld, map);
+
+		/* Two drive Optimal RAID 1 */
+		if ((raid->level == 1)  &&  (raid->rowSize == 2) &&
+		    (raid->spanDepth == 1) && raid->ldState ==
+		    MR_LD_STATE_OPTIMAL) {
+			u32 pd, arRef;
+
+			lbInfo[ldCount].loadBalanceFlag = 1;
+
+			/* Get the array on which this span is present */
+			arRef = MR_LdSpanArrayGet(ld, 0, map);
+
+			/* Get the Pd */
+			pd = MR_ArPdGet(arRef, 0, map);
+			/* Get dev handle from Pd */
+			lbInfo[ldCount].raid1DevHandle[0] =
+				MR_PdDevHandleGet(pd, map);
+			/* Get the Pd */
+			pd = MR_ArPdGet(arRef, 1, map);
+
+			/* Get the dev handle from Pd */
+			lbInfo[ldCount].raid1DevHandle[1] =
+				MR_PdDevHandleGet(pd, map);
+		} else
+			lbInfo[ldCount].loadBalanceFlag = 0;
+	}
+}
+
+u8 megasas_get_best_arm(struct LD_LOAD_BALANCE_INFO *lbInfo, u8 arm, u64 block,
+			u32 count)
+{
+	u16     pend0, pend1;
+	u64     diff0, diff1;
+	u8      bestArm;
+
+	/* get the pending cmds for the data and mirror arms */
+	pend0 = atomic_read(&lbInfo->scsi_pending_cmds[0]);
+	pend1 = atomic_read(&lbInfo->scsi_pending_cmds[1]);
+
+	/* Determine the disk whose head is nearer to the req. block */
+	diff0 = ABS_DIFF(block, lbInfo->last_accessed_block[0]);
+	diff1 = ABS_DIFF(block, lbInfo->last_accessed_block[1]);
+	bestArm = (diff0 <= diff1 ? 0 : 1);
+
+	if ((bestArm == arm && pend0 > pend1 + 16)  ||
+	    (bestArm != arm && pend1 > pend0 + 16))
+		bestArm ^= 1;
+
+	/* Update the last accessed block on the correct pd */
+	lbInfo->last_accessed_block[bestArm] = block + count - 1;
+
+	return bestArm;
+}
+
+u16 get_updated_dev_handle(struct LD_LOAD_BALANCE_INFO *lbInfo,
+			   struct IO_REQUEST_INFO *io_info)
+{
+	u8 arm, old_arm;
+	u16 devHandle;
+
+	old_arm = lbInfo->raid1DevHandle[0] == io_info->devHandle ? 0 : 1;
+
+	/* get best new arm */
+	arm  = megasas_get_best_arm(lbInfo, old_arm, io_info->ldStartBlock,
+				    io_info->numBlocks);
+	devHandle = lbInfo->raid1DevHandle[arm];
+	atomic_inc(&lbInfo->scsi_pending_cmds[arm]);
+
+	return devHandle;
+}
diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_fusion.c
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_fusion.c	1969-12-31
16:00:00.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2010-12-21
11:04:06.000000000 -0800
@@ -0,0 +1,2250 @@
+/*
+ *  Linux MegaRAID driver for SAS based RAID controllers
+ *
+ *  Copyright (c) 2009-2011  LSI Corporation.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ *  FILE: megaraid_sas_fusion.c
+ *
+ *  Authors: LSI Corporation
+ *           Sumant Patro
+ *           Adam Radford <linuxraid@lsi.com>
+ *
+ *  Send feedback to: <megaraidlinux@lsi.com>
+ *
+ *  Mail to: LSI Corporation, 1621 Barber Lane, Milpitas, CA 95035
+ *     ATTN: Linuxraid
+ */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/pci.h>
+#include <linux/list.h>
+#include <linux/moduleparam.h>
+#include <linux/module.h>
+#include <linux/spinlock.h>
+#include <linux/interrupt.h>
+#include <linux/delay.h>
+#include <linux/smp_lock.h>
+#include <linux/uio.h>
+#include <linux/uaccess.h>
+#include <linux/fs.h>
+#include <linux/compat.h>
+#include <linux/blkdev.h>
+#include <linux/mutex.h>
+#include <linux/poll.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+
+#include "megaraid_sas_fusion.h"
+#include "megaraid_sas.h"
+
+extern void megasas_free_cmds(struct megasas_instance *instance);
+extern struct megasas_cmd *megasas_get_cmd(struct megasas_instance
+					   *instance);
+extern void
+megasas_complete_cmd(struct megasas_instance *instance,
+		     struct megasas_cmd *cmd, u8 alt_status);
+int megasas_is_ldio(struct scsi_cmnd *cmd);
+int
+wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd);
+
+void
+megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd);
+int megasas_alloc_cmds(struct megasas_instance *instance);
+int
+megasas_clear_intr_fusion(struct megasas_register_set __iomem *regs);
+int
+megasas_issue_polled(struct megasas_instance *instance,
+		     struct megasas_cmd *cmd);
+
+u8
+MR_BuildRaidContext(struct IO_REQUEST_INFO *io_info,
+		    struct RAID_CONTEXT *pRAID_Context,
+		    struct MR_FW_RAID_MAP_ALL *map);
+u16 MR_TargetIdToLdGet(u32 ldTgtId, struct MR_FW_RAID_MAP_ALL *map);
+struct MR_LD_RAID *MR_LdRaidGet(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
+
+u16 MR_GetLDTgtId(u32 ld, struct MR_FW_RAID_MAP_ALL *map);
+u8 MR_ValidateMapInfo(struct MR_FW_RAID_MAP_ALL *map,
+		      struct LD_LOAD_BALANCE_INFO *lbInfo);
+u16 get_updated_dev_handle(struct LD_LOAD_BALANCE_INFO *lbInfo,
+			   struct IO_REQUEST_INFO *in_info);
+int megasas_transition_to_ready(struct megasas_instance *instance);
+void megaraid_sas_kill_hba(struct megasas_instance *instance);
+
+extern u32 megasas_dbg_lvl;
+
+/**
+ * megasas_enable_intr_fusion -	Enables interrupts
+ * @regs:			MFI register set
+ */
+void
+megasas_enable_intr_fusion(struct megasas_register_set __iomem *regs)
+{
+	writel(~MFI_FUSION_ENABLE_INTERRUPT_MASK, &(regs)->outbound_intr_mask);
+
+	/* Dummy readl to force pci flush */
+	readl(&regs->outbound_intr_mask);
+}
+
+/**
+ * megasas_disable_intr_fusion - Disables interrupt
+ * @regs:			 MFI register set
+ */
+void
+megasas_disable_intr_fusion(struct megasas_register_set __iomem *regs)
+{
+	u32 mask = 0xFFFFFFFF;
+	u32 status;
+
+	writel(mask, &regs->outbound_intr_mask);
+	/* Dummy readl to force pci flush */
+	status = readl(&regs->outbound_intr_mask);
+}
+
+int
+megasas_clear_intr_fusion(struct megasas_register_set __iomem *regs)
+{
+	u32 status;
+	/*
+	 * Check if it is our interrupt
+	 */
+	status = readl(&regs->outbound_intr_status);
+
+	if (status & 1) {
+		writel(status, &regs->outbound_intr_status);
+		readl(&regs->outbound_intr_status);
+		return 1;
+	}
+	if (!(status & MFI_FUSION_ENABLE_INTERRUPT_MASK))
+		return 0;
+
+	/*
+	 * dummy read to flush PCI
+	 */
+	readl(&regs->outbound_intr_status);
+
+	return 1;
+}
+
+/**
+ * megasas_get_cmd_fusion -	Get a command from the free pool
+ * @instance:		Adapter soft state
+ *
+ * Returns a free command from the pool
+ */
+struct megasas_cmd_fusion *megasas_get_cmd_fusion(struct megasas_instance
+						  *instance)
+{
+	unsigned long flags;
+	struct fusion_context *fusion =
+		(struct fusion_context *)instance->ctrl_context;
+	struct megasas_cmd_fusion *cmd = NULL;
+
+	spin_lock_irqsave(&fusion->cmd_pool_lock, flags);
+
+	if (!list_empty(&fusion->cmd_pool)) {
+		cmd = list_entry((&fusion->cmd_pool)->next,
+				 struct megasas_cmd_fusion, list);
+		list_del_init(&cmd->list);
+	} else {
+		printk(KERN_ERR "megasas: Command pool (fusion) empty!\n");
+	}
+
+	spin_unlock_irqrestore(&fusion->cmd_pool_lock, flags);
+	return cmd;
+}
+
+/**
+ * megasas_return_cmd_fusion -	Return a cmd to free command pool
+ * @instance:		Adapter soft state
+ * @cmd:		Command packet to be returned to free command pool
+ */
+static inline void
+megasas_return_cmd_fusion(struct megasas_instance *instance,
+			  struct megasas_cmd_fusion *cmd)
+{
+	unsigned long flags;
+	struct fusion_context *fusion =
+		(struct fusion_context *)instance->ctrl_context;
+
+	spin_lock_irqsave(&fusion->cmd_pool_lock, flags);
+
+	cmd->scmd = NULL;
+	cmd->sync_cmd_idx = (u32)ULONG_MAX;
+	list_add_tail(&cmd->list, &fusion->cmd_pool);
+
+	spin_unlock_irqrestore(&fusion->cmd_pool_lock, flags);
+}
+
+/**
+ * megasas_teardown_frame_pool_fusion -	Destroy the cmd frame DMA pool
+ * @instance:				Adapter soft state
+ */
+static void megasas_teardown_frame_pool_fusion(
+	struct megasas_instance *instance)
+{
+	int i;
+	struct fusion_context *fusion = instance->ctrl_context;
+
+	u16 max_cmd = instance->max_fw_cmds;
+
+	struct megasas_cmd_fusion *cmd;
+
+	if (!fusion->sg_dma_pool || !fusion->sense_dma_pool) {
+		printk(KERN_ERR "megasas: dma pool is null. SG Pool %p, "
+		       "sense pool : %p\n", fusion->sg_dma_pool,
+		       fusion->sense_dma_pool);
+		return;
+	}
+
+	/*
+	 * Return all frames to pool
+	 */
+	for (i = 0; i < max_cmd; i++) {
+
+		cmd = fusion->cmd_list[i];
+
+		if (cmd->sg_frame)
+			pci_pool_free(fusion->sg_dma_pool, cmd->sg_frame,
+				      cmd->sg_frame_phys_addr);
+
+		if (cmd->sense)
+			pci_pool_free(fusion->sense_dma_pool, cmd->sense,
+				      cmd->sense_phys_addr);
+	}
+
+	/*
+	 * Now destroy the pool itself
+	 */
+	pci_pool_destroy(fusion->sg_dma_pool);
+	pci_pool_destroy(fusion->sense_dma_pool);
+
+	fusion->sg_dma_pool = NULL;
+	fusion->sense_dma_pool = NULL;
+}
+
+/**
+ * megasas_free_cmds_fusion -	Free all the cmds in the free cmd pool
+ * @instance:		Adapter soft state
+ */
+void
+megasas_free_cmds_fusion(struct megasas_instance *instance)
+{
+	int i;
+	struct fusion_context *fusion = instance->ctrl_context;
+
+	u32 max_cmds, req_sz, reply_sz, io_frames_sz;
+
+
+	req_sz = fusion->request_alloc_sz;
+	reply_sz = fusion->reply_alloc_sz;
+	io_frames_sz = fusion->io_frames_alloc_sz;
+
+	max_cmds = instance->max_fw_cmds;
+
+	/* Free descriptors and request Frames memory */
+	if (fusion->req_frames_desc)
+		dma_free_coherent(&instance->pdev->dev, req_sz,
+				  fusion->req_frames_desc,
+				  fusion->req_frames_desc_phys);
+
+	if (fusion->reply_frames_desc) {
+		pci_pool_free(fusion->reply_frames_desc_pool,
+			      fusion->reply_frames_desc,
+			      fusion->reply_frames_desc_phys);
+		pci_pool_destroy(fusion->reply_frames_desc_pool);
+	}
+
+	if (fusion->io_request_frames) {
+		pci_pool_free(fusion->io_request_frames_pool,
+			      fusion->io_request_frames,
+			      fusion->io_request_frames_phys);
+		pci_pool_destroy(fusion->io_request_frames_pool);
+	}
+
+	/* Free the Fusion frame pool */
+	megasas_teardown_frame_pool_fusion(instance);
+
+	/* Free all the commands in the cmd_list */
+	for (i = 0; i < max_cmds; i++)
+		kfree(fusion->cmd_list[i]);
+
+	/* Free the cmd_list buffer itself */
+	kfree(fusion->cmd_list);
+	fusion->cmd_list = NULL;
+
+	INIT_LIST_HEAD(&fusion->cmd_pool);
+}
+
+/**
+ * megasas_create_frame_pool_fusion -	Creates DMA pool for cmd frames
+ * @instance:			Adapter soft state
+ *
+ */
+static int megasas_create_frame_pool_fusion(struct megasas_instance *instance)
+{
+	int i;
+	u32 max_cmd;
+	struct fusion_context *fusion;
+	struct megasas_cmd_fusion *cmd;
+	u32 total_sz_chain_frame;
+
+	fusion = instance->ctrl_context;
+	max_cmd = instance->max_fw_cmds;
+
+	total_sz_chain_frame = MEGASAS_MAX_SZ_CHAIN_FRAME;
+
+	/*
+	 * Use DMA pool facility provided by PCI layer
+	 */
+
+	fusion->sg_dma_pool = pci_pool_create("megasas sg pool fusion",
+					      instance->pdev,
+					      total_sz_chain_frame, 4,
+					      0);
+	if (!fusion->sg_dma_pool) {
+		printk(KERN_DEBUG "megasas: failed to setup request pool "
+		       "fusion\n");
+		return -ENOMEM;
+	}
+	fusion->sense_dma_pool = pci_pool_create("megasas sense pool fusion",
+						 instance->pdev,
+						 SCSI_SENSE_BUFFERSIZE, 64, 0);
+
+	if (!fusion->sense_dma_pool) {
+		printk(KERN_DEBUG "megasas: failed to setup sense pool "
+		       "fusion\n");
+		pci_pool_destroy(fusion->sg_dma_pool);
+		fusion->sg_dma_pool = NULL;
+		return -ENOMEM;
+	}
+
+	/*
+	 * Allocate and attach a frame to each of the commands in cmd_list
+	 */
+	for (i = 0; i < max_cmd; i++) {
+
+		cmd = fusion->cmd_list[i];
+
+		cmd->sg_frame = pci_pool_alloc(fusion->sg_dma_pool,
+					       GFP_KERNEL,
+					       &cmd->sg_frame_phys_addr);
+
+		cmd->sense = pci_pool_alloc(fusion->sense_dma_pool,
+					    GFP_KERNEL, &cmd->sense_phys_addr);
+		/*
+		 * megasas_teardown_frame_pool_fusion() takes care of freeing
+		 * whatever has been allocated
+		 */
+		if (!cmd->sg_frame || !cmd->sense) {
+			printk(KERN_DEBUG "megasas: pci_pool_alloc failed\n");
+			megasas_teardown_frame_pool_fusion(instance);
+			return -ENOMEM;
+		}
+	}
+	return 0;
+}
+
+/**
+ * megasas_alloc_cmds_fusion -	Allocates the command packets
+ * @instance:		Adapter soft state
+ *
+ *
+ * Each frame has a 32-bit field called context. This context is used to get
+ * back the megasas_cmd_fusion from the frame when a frame gets completed
+ * In this driver, the 32 bit values are the indices into an array cmd_list.
+ * This array is used only to look up the megasas_cmd_fusion given the context.
+ * The free commands themselves are maintained in a linked list
called cmd_pool.
+ *
+ * cmds are formed in the io_request and sg_frame members of the
+ * megasas_cmd_fusion. The context field is used to get a request descriptor
+ * and is used as SMID of the cmd.
+ * SMID value range is from 1 to max_fw_cmds.
+ */
+int
+megasas_alloc_cmds_fusion(struct megasas_instance *instance)
+{
+	int i, j;
+	u32 max_cmd, io_frames_sz;
+	struct fusion_context *fusion;
+	struct megasas_cmd_fusion *cmd;
+	union MPI2_REPLY_DESCRIPTORS_UNION *reply_desc;
+	u32 offset;
+	dma_addr_t io_req_base_phys;
+	u8 *io_req_base;
+
+	fusion = instance->ctrl_context;
+
+	max_cmd = instance->max_fw_cmds;
+
+	fusion->req_frames_desc =
+		dma_alloc_coherent(&instance->pdev->dev,
+				   fusion->request_alloc_sz,
+				   &fusion->req_frames_desc_phys, GFP_KERNEL);
+
+	if (!fusion->req_frames_desc) {
+		printk(KERN_ERR "megasas; Could not allocate memory for "
+		       "request_frames\n");
+		goto fail_req_desc;
+	}
+
+	fusion->reply_frames_desc_pool =
+		pci_pool_create("reply_frames pool", instance->pdev,
+				fusion->reply_alloc_sz, 16, 0);
+
+	if (!fusion->reply_frames_desc_pool) {
+		printk(KERN_ERR "megasas; Could not allocate memory for "
+		       "reply_frame pool\n");
+		goto fail_reply_desc;
+	}
+
+	fusion->reply_frames_desc =
+		pci_pool_alloc(fusion->reply_frames_desc_pool, GFP_KERNEL,
+			       &fusion->reply_frames_desc_phys);
+	if (!fusion->reply_frames_desc) {
+		printk(KERN_ERR "megasas; Could not allocate memory for "
+		       "reply_frame pool\n");
+		pci_pool_destroy(fusion->reply_frames_desc_pool);
+		goto fail_reply_desc;
+	}
+
+	reply_desc = fusion->reply_frames_desc;
+	for (i = 0; i < fusion->reply_q_depth; i++, reply_desc++)
+		reply_desc->Words = ULLONG_MAX;
+
+	io_frames_sz = fusion->io_frames_alloc_sz;
+
+	fusion->io_request_frames_pool =
+		pci_pool_create("io_request_frames pool", instance->pdev,
+				fusion->io_frames_alloc_sz, 16, 0);
+
+	if (!fusion->io_request_frames_pool) {
+		printk(KERN_ERR "megasas: Could not allocate memory for "
+		       "io_request_frame pool\n");
+		goto fail_io_frames;
+	}
+
+	fusion->io_request_frames =
+		pci_pool_alloc(fusion->io_request_frames_pool, GFP_KERNEL,
+			       &fusion->io_request_frames_phys);
+	if (!fusion->io_request_frames) {
+		printk(KERN_ERR "megasas: Could not allocate memory for "
+		       "io_request_frames frames\n");
+		pci_pool_destroy(fusion->io_request_frames_pool);
+		goto fail_io_frames;
+	}
+
+	/*
+	 * fusion->cmd_list is an array of struct megasas_cmd_fusion pointers.
+	 * Allocate the dynamic array first and then allocate individual
+	 * commands.
+	 */
+	fusion->cmd_list = kmalloc(sizeof(struct megasas_cmd_fusion *)
+				   *max_cmd, GFP_KERNEL);
+
+	if (!fusion->cmd_list) {
+		printk(KERN_DEBUG "megasas: out of memory. Could not alloc "
+		       "memory for cmd_list_fusion\n");
+		goto fail_cmd_list;
+	}
+
+	memset(fusion->cmd_list, 0, sizeof(struct megasas_cmd_fusion *)
+	       *max_cmd);
+
+	max_cmd = instance->max_fw_cmds;
+	for (i = 0; i < max_cmd; i++) {
+		fusion->cmd_list[i] = kmalloc(sizeof(struct megasas_cmd_fusion),
+					      GFP_KERNEL);
+		if (!fusion->cmd_list[i]) {
+			printk(KERN_ERR "Could not alloc cmd list fusion\n");
+
+			for (j = 0; j < i; j++)
+				kfree(fusion->cmd_list[j]);
+
+			kfree(fusion->cmd_list);
+			fusion->cmd_list = NULL;
+			goto fail_cmd_list;
+		}
+	}
+
+	/* The first 256 bytes (SMID 0) is not used. Don't add to cmd list */
+	io_req_base = fusion->io_request_frames +
+		MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE;
+	io_req_base_phys = fusion->io_request_frames_phys +
+		MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE;
+
+	/*
+	 * Add all the commands to command pool (fusion->cmd_pool)
+	 */
+
+	/* SMID 0 is reserved. Set SMID/index from 1 */
+	for (i = 0; i < max_cmd; i++) {
+		cmd = fusion->cmd_list[i];
+		offset = MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE * i;
+		memset(cmd, 0, sizeof(struct megasas_cmd_fusion));
+		cmd->index = i + 1;
+		cmd->scmd = NULL;
+		cmd->sync_cmd_idx = (u32)ULONG_MAX; /* Set to Invalid */
+		cmd->instance = instance;
+		cmd->io_request =
+			(struct MPI2_RAID_SCSI_IO_REQUEST *)
+		  (io_req_base + offset);
+		memset(cmd->io_request, 0,
+		       sizeof(struct MPI2_RAID_SCSI_IO_REQUEST));
+		cmd->io_request_phys_addr = io_req_base_phys + offset;
+
+		list_add_tail(&cmd->list, &fusion->cmd_pool);
+	}
+
+	/*
+	 * Create a frame pool and assign one frame to each cmd
+	 */
+	if (megasas_create_frame_pool_fusion(instance)) {
+		printk(KERN_DEBUG "megasas: Error creating frame DMA pool\n");
+		megasas_free_cmds_fusion(instance);
+		goto fail_req_desc;
+	}
+
+	return 0;
+
+fail_cmd_list:
+	pci_pool_free(fusion->io_request_frames_pool, fusion->io_request_frames,
+		      fusion->io_request_frames_phys);
+	pci_pool_destroy(fusion->io_request_frames_pool);
+fail_io_frames:
+	dma_free_coherent(&instance->pdev->dev, fusion->request_alloc_sz,
+			  fusion->reply_frames_desc,
+			  fusion->reply_frames_desc_phys);
+	pci_pool_free(fusion->reply_frames_desc_pool,
+		      fusion->reply_frames_desc,
+		      fusion->reply_frames_desc_phys);
+	pci_pool_destroy(fusion->reply_frames_desc_pool);
+
+fail_reply_desc:
+	dma_free_coherent(&instance->pdev->dev, fusion->request_alloc_sz,
+			  fusion->req_frames_desc,
+			  fusion->req_frames_desc_phys);
+fail_req_desc:
+	return -ENOMEM;
+}
+
+/**
+ * wait_and_poll -	Issues a polling command
+ * @instance:			Adapter soft state
+ * @cmd:			Command packet to be issued
+ *
+ * For polling, MFI requires the cmd_status to be set to 0xFF before posting.
+ */
+int
+wait_and_poll(struct megasas_instance *instance, struct megasas_cmd *cmd)
+{
+	int i;
+	struct megasas_header *frame_hdr = &cmd->frame->hdr;
+
+	u32 msecs = MFI_POLL_TIMEOUT_SECS * 1000;
+
+	/*
+	 * Wait for cmd_status to change
+	 */
+	for (i = 0; (i < msecs) && (frame_hdr->cmd_status == 0xff); i += 20) {
+		rmb();
+		msleep(20);
+	}
+
+	if (frame_hdr->cmd_status == 0xff)
+		return -ETIME;
+
+	return 0;
+}
+
+/**
+ * megasas_ioc_init_fusion -	Initializes the FW
+ * @instance:		Adapter soft state
+ *
+ * Issues the IOC Init cmd
+ */
+int
+megasas_ioc_init_fusion(struct megasas_instance *instance)
+{
+	struct megasas_init_frame *init_frame;
+	struct MPI2_IOC_INIT_REQUEST *IOCInitMessage;
+	dma_addr_t	ioc_init_handle;
+	u32 context;
+	struct megasas_cmd *cmd;
+	u8 ret;
+	struct fusion_context *fusion;
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	int i;
+	struct megasas_header *frame_hdr;
+
+	fusion = instance->ctrl_context;
+
+	cmd = megasas_get_cmd(instance);
+
+	if (!cmd) {
+		printk(KERN_ERR "Could not allocate cmd for INIT Frame\n");
+		ret = 1;
+		goto fail_get_cmd;
+	}
+
+	IOCInitMessage =
+	  dma_alloc_coherent(&instance->pdev->dev,
+			     sizeof(struct MPI2_IOC_INIT_REQUEST),
+			     &ioc_init_handle, GFP_KERNEL);
+
+	if (!IOCInitMessage) {
+		printk(KERN_ERR "Could not allocate memory for "
+		       "IOCInitMessage\n");
+		ret = 1;
+		goto fail_fw_init;
+	}
+
+	memset(IOCInitMessage, 0, sizeof(struct MPI2_IOC_INIT_REQUEST));
+
+	IOCInitMessage->Function = MPI2_FUNCTION_IOC_INIT;
+	IOCInitMessage->WhoInit	= MPI2_WHOINIT_HOST_DRIVER;
+	IOCInitMessage->MsgVersion = MPI2_VERSION;
+	IOCInitMessage->HeaderVersion = MPI2_HEADER_VERSION;
+	IOCInitMessage->SystemRequestFrameSize =
+		MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE / 4;
+
+	IOCInitMessage->ReplyDescriptorPostQueueDepth = fusion->reply_q_depth;
+	IOCInitMessage->ReplyDescriptorPostQueueAddress	=
+		fusion->reply_frames_desc_phys;
+	IOCInitMessage->SystemRequestFrameBaseAddress =
+		fusion->io_request_frames_phys;
+
+	init_frame = (struct megasas_init_frame *)cmd->frame;
+	memset(init_frame, 0, MEGAMFI_FRAME_SIZE);
+
+	frame_hdr = &cmd->frame->hdr;
+	context = init_frame->context;
+	init_frame->context = context;
+
+	frame_hdr->cmd_status = 0xFF;
+	frame_hdr->flags |= MFI_FRAME_DONT_POST_IN_REPLY_QUEUE;
+
+	init_frame->cmd	= MFI_CMD_INIT;
+	init_frame->cmd_status = 0xFF;
+
+	init_frame->queue_info_new_phys_addr_lo = ioc_init_handle;
+	init_frame->data_xfer_len = sizeof(struct MPI2_IOC_INIT_REQUEST);
+
+	req_desc =
+	  (union MEGASAS_REQUEST_DESCRIPTOR_UNION *)fusion->req_frames_desc;
+
+	req_desc->Words = cmd->frame_phys_addr;
+	req_desc->MFAIo.RequestFlags =
+		(MEGASAS_REQ_DESCRIPT_FLAGS_MFA <<
+		 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+
+	/*
+	 * disable the intr before firing the init frame
+	 */
+	instance->instancet->disable_intr(instance->reg_set);
+
+	for (i = 0; i < (10 * 1000); i += 20) {
+		if (readl(&instance->reg_set->doorbell) & 1)
+			msleep(20);
+		else
+			break;
+	}
+
+	instance->instancet->fire_cmd(instance, req_desc->u.low,
+				      req_desc->u.high, instance->reg_set);
+
+	wait_and_poll(instance, cmd);
+
+	frame_hdr = &cmd->frame->hdr;
+	if (frame_hdr->cmd_status != 0) {
+		ret = 1;
+		goto fail_fw_init;
+	}
+	printk(KERN_ERR "megasas:IOC Init cmd success\n");
+
+	ret = 0;
+
+fail_fw_init:
+	megasas_return_cmd(instance, cmd);
+	if (IOCInitMessage)
+		dma_free_coherent(&instance->pdev->dev,
+				  sizeof(struct MPI2_IOC_INIT_REQUEST),
+				  IOCInitMessage, ioc_init_handle);
+fail_get_cmd:
+	return ret;
+}
+
+/*
+ * megasas_return_cmd_for_smid -	Returns a cmd_fusion for a SMID
+ * @instance:				Adapter soft state
+ *
+ */
+void
+megasas_return_cmd_for_smid(struct megasas_instance *instance, u16 smid)
+{
+	struct fusion_context *fusion;
+	struct megasas_cmd_fusion *cmd;
+
+	fusion = instance->ctrl_context;
+	cmd = fusion->cmd_list[smid - 1];
+	megasas_return_cmd_fusion(instance, cmd);
+}
+
+/*
+ * megasas_get_ld_map_info -	Returns FW's ld_map structure
+ * @instance:				Adapter soft state
+ * @pend:				Pend the command or not
+ * Issues an internal command (DCMD) to get the FW's controller PD
+ * list structure.  This information is mainly used to find out SYSTEM
+ * supported by the FW.
+ */
+static int
+megasas_get_ld_map_info(struct megasas_instance *instance)
+{
+	int ret = 0;
+	struct megasas_cmd *cmd;
+	struct megasas_dcmd_frame *dcmd;
+	struct MR_FW_RAID_MAP_ALL *ci;
+	dma_addr_t ci_h = 0;
+	u32 size_map_info;
+	struct fusion_context *fusion;
+
+	cmd = megasas_get_cmd(instance);
+
+	if (!cmd) {
+		printk(KERN_DEBUG "megasas: Failed to get cmd for map info.\n");
+		return -ENOMEM;
+	}
+
+	fusion = instance->ctrl_context;
+
+	if (!fusion) {
+		megasas_return_cmd(instance, cmd);
+		return 1;
+	}
+
+	dcmd = &cmd->frame->dcmd;
+
+	size_map_info = sizeof(struct MR_FW_RAID_MAP) +
+		(sizeof(struct MR_LD_SPAN_MAP) *(MAX_LOGICAL_DRIVES - 1));
+
+	ci = fusion->ld_map[(instance->map_id & 1)];
+	ci_h = fusion->ld_map_phys[(instance->map_id & 1)];
+
+	if (!ci) {
+		printk(KERN_DEBUG "Failed to alloc mem for ld_map_info\n");
+		megasas_return_cmd(instance, cmd);
+		return -ENOMEM;
+	}
+
+	memset(ci, 0, sizeof(*ci));
+	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+
+	dcmd->cmd = MFI_CMD_DCMD;
+	dcmd->cmd_status = 0xFF;
+	dcmd->sge_count = 1;
+	dcmd->flags = MFI_FRAME_DIR_READ;
+	dcmd->timeout = 0;
+	dcmd->pad_0 = 0;
+	dcmd->data_xfer_len = size_map_info;
+	dcmd->opcode = MR_DCMD_LD_MAP_GET_INFO;
+	dcmd->sgl.sge32[0].phys_addr = ci_h;
+	dcmd->sgl.sge32[0].length = size_map_info;
+
+	if (!megasas_issue_polled(instance, cmd))
+		ret = 0;
+	else {
+		printk(KERN_ERR "megasas: Get LD Map Info Failed\n");
+		ret = -1;
+	}
+
+	megasas_return_cmd(instance, cmd);
+
+	return ret;
+}
+
+u8
+megasas_get_map_info(struct megasas_instance *instance)
+{
+	struct fusion_context *fusion = instance->ctrl_context;
+
+	fusion->fast_path_io = 0;
+	if (!megasas_get_ld_map_info(instance)) {
+		if (MR_ValidateMapInfo(fusion->ld_map[(instance->map_id & 1)],
+				       fusion->load_balance_info)) {
+			fusion->fast_path_io = 1;
+			return 0;
+		}
+	}
+	return 1;
+}
+
+/*
+ * megasas_sync_map_info -	Returns FW's ld_map structure
+ * @instance:				Adapter soft state
+ *
+ * Issues an internal command (DCMD) to get the FW's controller PD
+ * list structure.  This information is mainly used to find out SYSTEM
+ * supported by the FW.
+ */
+int
+megasas_sync_map_info(struct megasas_instance *instance)
+{
+	int ret = 0, i;
+	struct megasas_cmd *cmd;
+	struct megasas_dcmd_frame *dcmd;
+	u32 size_sync_info, num_lds;
+	struct fusion_context *fusion;
+	struct MR_LD_TARGET_SYNC *ci = NULL;
+	struct MR_FW_RAID_MAP_ALL *map;
+	struct MR_LD_RAID  *raid;
+	struct MR_LD_TARGET_SYNC *ld_sync;
+	dma_addr_t ci_h = 0;
+	u32 size_map_info;
+
+	cmd = megasas_get_cmd(instance);
+
+	if (!cmd) {
+		printk(KERN_DEBUG "megasas: Failed to get cmd for sync"
+		       "info.\n");
+		return -ENOMEM;
+	}
+
+	fusion = instance->ctrl_context;
+
+	if (!fusion) {
+		megasas_return_cmd(instance, cmd);
+		return 1;
+	}
+
+	map = fusion->ld_map[instance->map_id & 1];
+
+	num_lds = map->raidMap.ldCount;
+
+	dcmd = &cmd->frame->dcmd;
+
+	size_sync_info = sizeof(struct MR_LD_TARGET_SYNC) *num_lds;
+
+	memset(dcmd->mbox.b, 0, MFI_MBOX_SIZE);
+
+	ci = (struct MR_LD_TARGET_SYNC *)
+	  fusion->ld_map[(instance->map_id - 1) & 1];
+	memset(ci, 0, sizeof(struct MR_FW_RAID_MAP_ALL));
+
+	ci_h = fusion->ld_map_phys[(instance->map_id - 1) & 1];
+
+	ld_sync = (struct MR_LD_TARGET_SYNC *)ci;
+
+	for (i = 0; i < num_lds; i++, ld_sync++) {
+		raid = MR_LdRaidGet(i, map);
+		ld_sync->targetId = MR_GetLDTgtId(i, map);
+		ld_sync->seqNum = raid->seqNum;
+	}
+
+	size_map_info = sizeof(struct MR_FW_RAID_MAP) +
+		(sizeof(struct MR_LD_SPAN_MAP) *(MAX_LOGICAL_DRIVES - 1));
+
+	dcmd->cmd = MFI_CMD_DCMD;
+	dcmd->cmd_status = 0xFF;
+	dcmd->sge_count = 1;
+	dcmd->flags = MFI_FRAME_DIR_WRITE;
+	dcmd->timeout = 0;
+	dcmd->pad_0 = 0;
+	dcmd->data_xfer_len = size_map_info;
+	dcmd->mbox.b[0] = num_lds;
+	dcmd->mbox.b[1] = MEGASAS_DCMD_MBOX_PEND_FLAG;
+	dcmd->opcode = MR_DCMD_LD_MAP_GET_INFO;
+	dcmd->sgl.sge32[0].phys_addr = ci_h;
+	dcmd->sgl.sge32[0].length = size_map_info;
+
+	instance->map_update_cmd = cmd;
+
+	instance->instancet->issue_dcmd(instance, cmd);
+
+	return ret;
+}
+
+/**
+ * megasas_init_adapter_fusion -	Initializes the FW
+ * @instance:		Adapter soft state
+ *
+ * This is the main function for initializing firmware.
+ */
+u32
+megasas_init_adapter_fusion(struct megasas_instance *instance)
+{
+	struct megasas_register_set __iomem *reg_set;
+	struct fusion_context *fusion;
+	u32 max_cmd;
+	int i = 0;
+
+	fusion = instance->ctrl_context;
+
+	reg_set = instance->reg_set;
+
+	/*
+	 * Get various operational parameters from status register
+	 */
+	instance->max_fw_cmds =
+		instance->instancet->read_fw_status_reg(reg_set) & 0x00FFFF;
+	instance->max_fw_cmds = min(instance->max_fw_cmds, (u16)1008);
+
+	/*
+	 * Reduce the max supported cmds by 1. This is to ensure that the
+	 * reply_q_sz (1 more than the max cmd that driver may send)
+	 * does not exceed max cmds that the FW can support
+	 */
+	instance->max_fw_cmds = instance->max_fw_cmds-1;
+	/* Only internal cmds (DCMD) need to have MFI frames */
+	instance->max_mfi_cmds = MEGASAS_INT_CMDS;
+
+	max_cmd = instance->max_fw_cmds;
+
+	fusion->reply_q_depth = ((max_cmd + 1 + 15)/16)*16;
+
+	fusion->request_alloc_sz =
+		sizeof(union MEGASAS_REQUEST_DESCRIPTOR_UNION) *max_cmd;
+	fusion->reply_alloc_sz = sizeof(union MPI2_REPLY_DESCRIPTORS_UNION)
+		*(fusion->reply_q_depth);
+	fusion->io_frames_alloc_sz = MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE +
+		(MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE *
+		 (max_cmd + 1)); /* Extra 1 for SMID 0 */
+
+	fusion->max_sge_in_main_msg =
+	  (MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE -
+	   offsetof(struct MPI2_RAID_SCSI_IO_REQUEST, SGL))/16;
+
+	fusion->max_sge_in_chain =
+		MEGASAS_MAX_SZ_CHAIN_FRAME / sizeof(union MPI2_SGE_IO_UNION);
+
+	instance->max_num_sge = fusion->max_sge_in_main_msg +
+		fusion->max_sge_in_chain - 2;
+
+	/* Used for pass thru MFI frame (DCMD) */
+	fusion->chain_offset_mfi_pthru =
+		offsetof(struct MPI2_RAID_SCSI_IO_REQUEST, SGL)/16;
+
+	fusion->chain_offset_io_request =
+		(MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE -
+		 sizeof(union MPI2_SGE_IO_UNION))/16;
+
+	fusion->last_reply_idx = 0;
+
+	/*
+	 * Allocate memory for descriptors
+	 * Create a pool of commands
+	 */
+	if (megasas_alloc_cmds(instance))
+		goto fail_alloc_mfi_cmds;
+	if (megasas_alloc_cmds_fusion(instance))
+		goto fail_alloc_cmds;
+
+	if (megasas_ioc_init_fusion(instance))
+		goto fail_ioc_init;
+
+	instance->flag_ieee = 1;
+
+	fusion->map_sz =  sizeof(struct MR_FW_RAID_MAP) +
+	  (sizeof(struct MR_LD_SPAN_MAP) *(MAX_LOGICAL_DRIVES - 1));
+
+	fusion->fast_path_io = 0;
+
+	for (i = 0; i < 2; i++) {
+		fusion->ld_map[i] = dma_alloc_coherent(&instance->pdev->dev,
+						       fusion->map_sz,
+						       &fusion->ld_map_phys[i],
+						       GFP_KERNEL);
+		if (!fusion->ld_map[i]) {
+			printk(KERN_ERR "megasas: Could not allocate memory "
+			       "for map info\n");
+			goto fail_map_info;
+		}
+	}
+
+	if (!megasas_get_map_info(instance))
+		megasas_sync_map_info(instance);
+
+	return 0;
+
+fail_alloc_cmds:
+fail_alloc_mfi_cmds:
+fail_map_info:
+	if (i == 1)
+		dma_free_coherent(&instance->pdev->dev, fusion->map_sz,
+				  fusion->ld_map[0], fusion->ld_map_phys[0]);
+fail_ioc_init:
+	return 1;
+}
+
+/**
+ * megasas_fire_cmd_fusion -	Sends command to the FW
+ * @frame_phys_addr :		Physical address of cmd
+ * @frame_count :		Number of frames for the command
+ * @regs :			MFI register set
+ */
+void
+megasas_fire_cmd_fusion(struct megasas_instance *instance,
+			dma_addr_t req_desc_lo,
+			u32 req_desc_hi,
+			struct megasas_register_set __iomem *regs)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&instance->hba_lock, flags);
+
+	writel(req_desc_lo,
+	       &(regs)->inbound_low_queue_port);
+	writel(req_desc_hi, &(regs)->inbound_high_queue_port);
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
+}
+
+/**
+ * map_cmd_status -	Maps FW cmd status to OS cmd status
+ * @cmd :		Pointer to cmd
+ * @status :		status of cmd returned by FW
+ * @ext_status :	ext status of cmd returned by FW
+ */
+
+void
+map_cmd_status(struct megasas_cmd_fusion *cmd, u8 status, u8 ext_status)
+{
+
+	switch (status) {
+
+	case MFI_STAT_OK:
+		cmd->scmd->result = DID_OK << 16;
+		break;
+
+	case MFI_STAT_SCSI_IO_FAILED:
+	case MFI_STAT_LD_INIT_IN_PROGRESS:
+		cmd->scmd->result = (DID_ERROR << 16) | ext_status;
+		break;
+
+	case MFI_STAT_SCSI_DONE_WITH_ERROR:
+
+		cmd->scmd->result = (DID_OK << 16) | ext_status;
+		if (ext_status == SAM_STAT_CHECK_CONDITION) {
+			memset(cmd->scmd->sense_buffer, 0,
+			       SCSI_SENSE_BUFFERSIZE);
+			memcpy(cmd->scmd->sense_buffer, cmd->sense,
+			       SCSI_SENSE_BUFFERSIZE);
+			cmd->scmd->result |= DRIVER_SENSE << 24;
+		}
+		break;
+
+	case MFI_STAT_LD_OFFLINE:
+	case MFI_STAT_DEVICE_NOT_FOUND:
+		cmd->scmd->result = DID_BAD_TARGET << 16;
+		break;
+
+	default:
+		printk(KERN_DEBUG "megasas: FW status %#x\n", status);
+		cmd->scmd->result = DID_ERROR << 16;
+		break;
+	}
+}
+
+/**
+ * megasas_make_sgl_fusion -	Prepares 32-bit SGL
+ * @instance:		Adapter soft state
+ * @scp:		SCSI command from the mid-layer
+ * @sgl_ptr:		SGL to be filled in
+ * @cmd:		cmd we are working on
+ *
+ * If successful, this function returns the number of SG elements.
+ */
+static int
+megasas_make_sgl_fusion(struct megasas_instance *instance,
+			struct scsi_cmnd *scp,
+			struct MPI25_IEEE_SGE_CHAIN64 *sgl_ptr,
+			struct megasas_cmd_fusion *cmd)
+{
+	int i, sg_processed;
+	int sge_count, sge_idx;
+	struct scatterlist *os_sgl;
+	struct fusion_context *fusion;
+
+	fusion = instance->ctrl_context;
+
+	cmd->io_request->ChainOffset = 0;
+
+	sge_count = scsi_dma_map(scp);
+
+	BUG_ON(sge_count < 0);
+
+	if (sge_count > instance->max_num_sge || !sge_count)
+		return sge_count;
+
+	if (sge_count > fusion->max_sge_in_main_msg) {
+		/* One element to store the chain info */
+		sge_idx = fusion->max_sge_in_main_msg - 1;
+	} else
+		sge_idx = sge_count;
+
+	scsi_for_each_sg(scp, os_sgl, sge_count, i) {
+		sgl_ptr->Length = sg_dma_len(os_sgl);
+		sgl_ptr->Address = sg_dma_address(os_sgl);
+		sgl_ptr->Flags = 0;
+		sgl_ptr++;
+
+		sg_processed = i + 1;
+
+		if ((sg_processed ==  (fusion->max_sge_in_main_msg - 1)) &&
+		    (sge_count > fusion->max_sge_in_main_msg)) {
+
+			struct MPI25_IEEE_SGE_CHAIN64 *sg_chain;
+			cmd->io_request->ChainOffset =
+				fusion->chain_offset_io_request;
+			sg_chain = sgl_ptr;
+			/* Prepare chain element */
+			sg_chain->NextChainOffset = 0;
+			sg_chain->Flags = (IEEE_SGE_FLAGS_CHAIN_ELEMENT |
+					   MPI2_IEEE_SGE_FLAGS_IOCPLBNTA_ADDR);
+			sg_chain->Length =  (sizeof(union MPI2_SGE_IO_UNION)
+					     *(sge_count - sg_processed));
+			sg_chain->Address = cmd->sg_frame_phys_addr;
+
+			sgl_ptr =
+			  (struct MPI25_IEEE_SGE_CHAIN64 *)cmd->sg_frame;
+		}
+	}
+
+	return sge_count;
+}
+
+/**
+ * megasas_set_pd_lba -	Sets PD LBA
+ * @cdb:		CDB
+ * @cdb_len:		cdb length
+ * @start_blk:		Start block of IO
+ *
+ * Used to set the PD LBA in CDB for FP IOs
+ */
+void
+megasas_set_pd_lba(struct MPI2_RAID_SCSI_IO_REQUEST *io_request, u8 cdb_len,
+		   struct IO_REQUEST_INFO *io_info, struct scsi_cmnd *scp,
+		   struct MR_FW_RAID_MAP_ALL *local_map_ptr, u32 ref_tag)
+{
+	struct MR_LD_RAID *raid;
+	u32 ld;
+	u64 start_blk = io_info->pdBlock;
+	u8 *cdb = io_request->CDB.CDB32;
+	u32 num_blocks = io_info->numBlocks;
+	u8 opcode, flagvals, groupnum, control;
+
+	/* Check if T10 PI (DIF) is enabled for this LD */
+	ld = MR_TargetIdToLdGet(io_info->ldTgtId, local_map_ptr);
+	raid = MR_LdRaidGet(ld, local_map_ptr);
+	if (raid->capability.ldPiMode == MR_PROT_INFO_TYPE_CONTROLLER) {
+		memset(cdb, 0, sizeof(io_request->CDB.CDB32));
+		cdb[0] =  MEGASAS_SCSI_VARIABLE_LENGTH_CMD;
+		cdb[7] =  MEGASAS_SCSI_ADDL_CDB_LEN;
+
+		if (scp->sc_data_direction == PCI_DMA_FROMDEVICE)
+			cdb[9] = MEGASAS_SCSI_SERVICE_ACTION_READ32;
+		else
+			cdb[9] = MEGASAS_SCSI_SERVICE_ACTION_WRITE32;
+		cdb[10] = MEGASAS_RD_WR_PROTECT_CHECK_ALL;
+
+		/* LBA */
+		cdb[12] = (u8)((start_blk >> 56) & 0xff);
+		cdb[13] = (u8)((start_blk >> 48) & 0xff);
+		cdb[14] = (u8)((start_blk >> 40) & 0xff);
+		cdb[15] = (u8)((start_blk >> 32) & 0xff);
+		cdb[16] = (u8)((start_blk >> 24) & 0xff);
+		cdb[17] = (u8)((start_blk >> 16) & 0xff);
+		cdb[18] = (u8)((start_blk >> 8) & 0xff);
+		cdb[19] = (u8)(start_blk & 0xff);
+
+		/* Logical block reference tag */
+		io_request->CDB.EEDP32.PrimaryReferenceTag =
+			cpu_to_be32(ref_tag);
+		io_request->CDB.EEDP32.PrimaryApplicationTagMask = 0xffff;
+
+		io_request->DataLength = num_blocks * 512;
+		io_request->IoFlags = 32; /* Specify 32-byte cdb */
+
+		/* Transfer length */
+		cdb[28] = (u8)((num_blocks >> 24) & 0xff);
+		cdb[29] = (u8)((num_blocks >> 16) & 0xff);
+		cdb[30] = (u8)((num_blocks >> 8) & 0xff);
+		cdb[31] = (u8)(num_blocks & 0xff);
+
+		/* set SCSI IO EEDPFlags */
+		if (scp->sc_data_direction == PCI_DMA_FROMDEVICE) {
+			io_request->EEDPFlags =
+				MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG  |
+				MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG |
+				MPI2_SCSIIO_EEDPFLAGS_CHECK_REMOVE_OP |
+				MPI2_SCSIIO_EEDPFLAGS_CHECK_APPTAG |
+				MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD;
+		} else {
+			io_request->EEDPFlags =
+				MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG |
+				MPI2_SCSIIO_EEDPFLAGS_INSERT_OP;
+		}
+		io_request->Control |= (0x4 << 26);
+		io_request->EEDPBlockSize = MEGASAS_EEDPBLOCKSIZE;
+	} else {
+		/* Some drives don't support 16/12 byte CDB's, convert to 10 */
+		if (((cdb_len == 12) || (cdb_len == 16)) &&
+		    (start_blk <= 0xffffffff)) {
+			if (cdb_len == 16) {
+				opcode = cdb[0] == READ_16 ? READ_10 : WRITE_10;
+				flagvals = cdb[1];
+				groupnum = cdb[14];
+				control = cdb[15];
+			} else {
+				opcode = cdb[0] == READ_12 ? READ_10 : WRITE_10;
+				flagvals = cdb[1];
+				groupnum = cdb[10];
+				control = cdb[11];
+			}
+
+			memset(cdb, 0, sizeof(io_request->CDB.CDB32));
+
+			cdb[0] = opcode;
+			cdb[1] = flagvals;
+			cdb[6] = groupnum;
+			cdb[9] = control;
+
+			/* Transfer length */
+			cdb[8] = (u8)(num_blocks & 0xff);
+			cdb[7] = (u8)((num_blocks >> 8) & 0xff);
+
+			cdb_len = 10;
+		}
+
+		/* Normal case, just load LBA here */
+		switch (cdb_len) {
+		case 6:
+		{
+			u8 val = cdb[1] & 0xE0;
+			cdb[3] = (u8)(start_blk & 0xff);
+			cdb[2] = (u8)((start_blk >> 8) & 0xff);
+			cdb[1] = val | ((u8)(start_blk >> 16) & 0x1f);
+			break;
+		}
+		case 10:
+			cdb[5] = (u8)(start_blk & 0xff);
+			cdb[4] = (u8)((start_blk >> 8) & 0xff);
+			cdb[3] = (u8)((start_blk >> 16) & 0xff);
+			cdb[2] = (u8)((start_blk >> 24) & 0xff);
+			break;
+		case 12:
+			cdb[5]    = (u8)(start_blk & 0xff);
+			cdb[4]    = (u8)((start_blk >> 8) & 0xff);
+			cdb[3]    = (u8)((start_blk >> 16) & 0xff);
+			cdb[2]    = (u8)((start_blk >> 24) & 0xff);
+			break;
+		case 16:
+			cdb[9]    = (u8)(start_blk & 0xff);
+			cdb[8]    = (u8)((start_blk >> 8) & 0xff);
+			cdb[7]    = (u8)((start_blk >> 16) & 0xff);
+			cdb[6]    = (u8)((start_blk >> 24) & 0xff);
+			cdb[5]    = (u8)((start_blk >> 32) & 0xff);
+			cdb[4]    = (u8)((start_blk >> 40) & 0xff);
+			cdb[3]    = (u8)((start_blk >> 48) & 0xff);
+			cdb[2]    = (u8)((start_blk >> 56) & 0xff);
+			break;
+		}
+	}
+}
+
+/**
+ * megasas_build_ldio_fusion -	Prepares IOs to devices
+ * @instance:		Adapter soft state
+ * @scp:		SCSI command
+ * @cmd:		Command to be prepared
+ *
+ * Prepares the io_request and chain elements (sg_frame) for IO
+ * The IO can be for PD (Fast Path) or LD
+ */
+void
+megasas_build_ldio_fusion(struct megasas_instance *instance,
+			  struct scsi_cmnd *scp,
+			  struct megasas_cmd_fusion *cmd)
+{
+	u8 fp_possible;
+	u32 start_lba_lo, start_lba_hi, device_id;
+	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	struct IO_REQUEST_INFO io_info;
+	struct fusion_context *fusion;
+	struct MR_FW_RAID_MAP_ALL *local_map_ptr;
+
+	device_id = MEGASAS_DEV_INDEX(instance, scp);
+
+	fusion = instance->ctrl_context;
+
+	io_request = cmd->io_request;
+	io_request->RaidContext.VirtualDiskTgtId = device_id;
+	io_request->RaidContext.status = 0;
+	io_request->RaidContext.exStatus = 0;
+
+	req_desc = (union MEGASAS_REQUEST_DESCRIPTOR_UNION *)cmd->request_desc;
+
+	start_lba_lo = 0;
+	start_lba_hi = 0;
+	fp_possible = 0;
+
+	/*
+	 * 6-byte READ(0x08) or WRITE(0x0A) cdb
+	 */
+	if (scp->cmd_len == 6) {
+		io_request->DataLength = (u32) scp->cmnd[4];
+		start_lba_lo = ((u32) scp->cmnd[1] << 16) |
+			((u32) scp->cmnd[2] << 8) | (u32) scp->cmnd[3];
+
+		start_lba_lo &= 0x1FFFFF;
+	}
+
+	/*
+	 * 10-byte READ(0x28) or WRITE(0x2A) cdb
+	 */
+	else if (scp->cmd_len == 10) {
+		io_request->DataLength = (u32) scp->cmnd[8] |
+			((u32) scp->cmnd[7] << 8);
+		start_lba_lo = ((u32) scp->cmnd[2] << 24) |
+			((u32) scp->cmnd[3] << 16) |
+			((u32) scp->cmnd[4] << 8) | (u32) scp->cmnd[5];
+	}
+
+	/*
+	 * 12-byte READ(0xA8) or WRITE(0xAA) cdb
+	 */
+	else if (scp->cmd_len == 12) {
+		io_request->DataLength = ((u32) scp->cmnd[6] << 24) |
+			((u32) scp->cmnd[7] << 16) |
+			((u32) scp->cmnd[8] << 8) | (u32) scp->cmnd[9];
+		start_lba_lo = ((u32) scp->cmnd[2] << 24) |
+			((u32) scp->cmnd[3] << 16) |
+			((u32) scp->cmnd[4] << 8) | (u32) scp->cmnd[5];
+	}
+
+	/*
+	 * 16-byte READ(0x88) or WRITE(0x8A) cdb
+	 */
+	else if (scp->cmd_len == 16) {
+		io_request->DataLength = ((u32) scp->cmnd[10] << 24) |
+			((u32) scp->cmnd[11] << 16) |
+			((u32) scp->cmnd[12] << 8) | (u32) scp->cmnd[13];
+		start_lba_lo = ((u32) scp->cmnd[6] << 24) |
+			((u32) scp->cmnd[7] << 16) |
+			((u32) scp->cmnd[8] << 8) | (u32) scp->cmnd[9];
+
+		start_lba_hi = ((u32) scp->cmnd[2] << 24) |
+			((u32) scp->cmnd[3] << 16) |
+			((u32) scp->cmnd[4] << 8) | (u32) scp->cmnd[5];
+	}
+
+	memset(&io_info, 0, sizeof(struct IO_REQUEST_INFO));
+	io_info.ldStartBlock = ((u64)start_lba_hi << 32) | start_lba_lo;
+	io_info.numBlocks = io_request->DataLength;
+	io_info.ldTgtId = device_id;
+
+	if (scp->sc_data_direction == PCI_DMA_FROMDEVICE)
+		io_info.isRead = 1;
+
+	local_map_ptr = fusion->ld_map[(instance->map_id & 1)];
+
+	if ((MR_TargetIdToLdGet(device_id, local_map_ptr) >=
+	     MAX_LOGICAL_DRIVES) || (!fusion->fast_path_io)) {
+		io_request->RaidContext.regLockFlags  = 0;
+		fp_possible = 0;
+	} else {
+		if (MR_BuildRaidContext(&io_info, &io_request->RaidContext,
+					local_map_ptr))
+			fp_possible = io_info.fpOkForIo;
+	}
+
+	if (fp_possible) {
+		megasas_set_pd_lba(io_request, scp->cmd_len, &io_info, scp,
+				   local_map_ptr, start_lba_lo);
+		io_request->DataLength = scsi_bufflen(scp);
+		io_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
+		cmd->request_desc->SCSIIO.RequestFlags =
+			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY
+			 << MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+		if ((fusion->load_balance_info[device_id].loadBalanceFlag) &&
+		    (io_info.isRead)) {
+			io_info.devHandle =
+				get_updated_dev_handle(
+					&fusion->load_balance_info[device_id],
+					&io_info);
+			scp->SCp.Status |= MEGASAS_LOAD_BALANCE_FLAG;
+		} else
+			scp->SCp.Status &= ~MEGASAS_LOAD_BALANCE_FLAG;
+		cmd->request_desc->SCSIIO.DevHandle = io_info.devHandle;
+		io_request->DevHandle = io_info.devHandle;
+	} else {
+		io_request->RaidContext.timeoutValue =
+			local_map_ptr->raidMap.fpPdIoTimeoutSec;
+		io_request->Function = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
+		io_request->DevHandle = device_id;
+		cmd->request_desc->SCSIIO.RequestFlags =
+			(MEGASAS_REQ_DESCRIPT_FLAGS_LD_IO
+			 << MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+	} /* Not FP */
+}
+
+/**
+ * megasas_build_dcdb_fusion -	Prepares IOs to devices
+ * @instance:		Adapter soft state
+ * @scp:		SCSI command
+ * @cmd:		Command to be prepared
+ *
+ * Prepares the io_request frame for non-io cmds
+ */
+static void
+megasas_build_dcdb_fusion(struct megasas_instance *instance,
+			  struct scsi_cmnd *scmd,
+			  struct megasas_cmd_fusion *cmd)
+{
+	u32 device_id;
+	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
+	u16 pd_index = 0;
+	struct MR_FW_RAID_MAP_ALL *local_map_ptr;
+	struct fusion_context *fusion = instance->ctrl_context;
+
+	io_request = cmd->io_request;
+	device_id = MEGASAS_DEV_INDEX(instance, scmd);
+	pd_index = (scmd->device->channel * MEGASAS_MAX_DEV_PER_CHANNEL)
+		+scmd->device->id;
+	local_map_ptr = fusion->ld_map[(instance->map_id & 1)];
+
+	/* Check if this is a system PD I/O */
+	if ((instance->pd_list[pd_index].driveState == MR_PD_STATE_SYSTEM) &&
+	    (instance->pd_list[pd_index].driveType == TYPE_DISK)) {
+		io_request->Function = 0;
+		io_request->DevHandle =
+			local_map_ptr->raidMap.devHndlInfo[device_id].curDevHdl;
+		io_request->RaidContext.timeoutValue =
+			local_map_ptr->raidMap.fpPdIoTimeoutSec;
+		io_request->RaidContext.regLockFlags = 0;
+		io_request->RaidContext.regLockRowLBA = 0;
+		io_request->RaidContext.regLockLength = 0;
+		io_request->RaidContext.RAIDFlags =
+			MR_RAID_FLAGS_IO_SUB_TYPE_SYSTEM_PD <<
+			MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT;
+		cmd->request_desc->SCSIIO.RequestFlags =
+			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY <<
+			 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+	} else {
+		io_request->Function  = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
+		io_request->DevHandle = device_id;
+		cmd->request_desc->SCSIIO.RequestFlags =
+			(MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
+			 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+	}
+	io_request->RaidContext.VirtualDiskTgtId = device_id;
+	io_request->LUN[0] = scmd->device->lun;
+	io_request->DataLength = scsi_bufflen(scmd);
+}
+
+/**
+ * megasas_build_io_fusion -	Prepares IOs to devices
+ * @instance:		Adapter soft state
+ * @scp:		SCSI command
+ * @cmd:		Command to be prepared
+ *
+ * Invokes helper functions to prepare request frames
+ * and sets flags appropriate for IO/Non-IO cmd
+ */
+int
+megasas_build_io_fusion(struct megasas_instance *instance,
+			struct scsi_cmnd *scp,
+			struct megasas_cmd_fusion *cmd)
+{
+	u32 device_id, sge_count;
+	struct MPI2_RAID_SCSI_IO_REQUEST *io_request = cmd->io_request;
+
+	device_id = MEGASAS_DEV_INDEX(instance, scp);
+
+	/* Zero out some fields so they don't get reused */
+	io_request->LUN[0] = 0;
+	io_request->CDB.EEDP32.PrimaryReferenceTag = 0;
+	io_request->CDB.EEDP32.PrimaryApplicationTagMask = 0;
+	io_request->EEDPFlags = 0;
+	io_request->Control = 0;
+	io_request->EEDPBlockSize = 0;
+	io_request->IoFlags = 0;
+	io_request->RaidContext.RAIDFlags = 0;
+
+	memcpy(io_request->CDB.CDB32, scp->cmnd, scp->cmd_len);
+	/*
+	 * Just the CDB length,rest of the Flags are zero
+	 * This will be modified for FP in build_ldio_fusion
+	 */
+	io_request->IoFlags = scp->cmd_len;
+
+	if (megasas_is_ldio(scp))
+		megasas_build_ldio_fusion(instance, scp, cmd);
+	else
+		megasas_build_dcdb_fusion(instance, scp, cmd);
+
+	/*
+	 * Construct SGL
+	 */
+
+	sge_count =
+		megasas_make_sgl_fusion(instance, scp,
+					(struct MPI25_IEEE_SGE_CHAIN64 *)
+					&io_request->SGL, cmd);
+
+	if (sge_count > instance->max_num_sge) {
+		printk(KERN_ERR "megasas: Error. sge_count (0x%x) exceeds "
+		       "max (0x%x) allowed\n", sge_count,
+		       instance->max_num_sge);
+		return 1;
+	}
+
+	io_request->RaidContext.numSGE = sge_count;
+
+	io_request->SGLFlags = MPI2_SGE_FLAGS_64_BIT_ADDRESSING;
+
+	if (scp->sc_data_direction == PCI_DMA_TODEVICE)
+		io_request->Control |= MPI2_SCSIIO_CONTROL_WRITE;
+	else if (scp->sc_data_direction == PCI_DMA_FROMDEVICE)
+		io_request->Control |= MPI2_SCSIIO_CONTROL_READ;
+
+	io_request->SGLOffset0 =
+		offsetof(struct MPI2_RAID_SCSI_IO_REQUEST, SGL) / 4;
+
+	io_request->SenseBufferLowAddress = cmd->sense_phys_addr;
+	io_request->SenseBufferLength = SCSI_SENSE_BUFFERSIZE;
+
+	cmd->scmd = scp;
+	scp->SCp.ptr = (char *)cmd;
+
+	return 0;
+}
+
+union MEGASAS_REQUEST_DESCRIPTOR_UNION *
+megasas_get_request_descriptor(struct megasas_instance *instance, u16 index)
+{
+	u8 *p;
+	struct fusion_context *fusion;
+
+	if (index >= instance->max_fw_cmds) {
+		printk(KERN_ERR "megasas: Invalid SMID (0x%x)request for "
+		       "descriptor\n", index);
+		return NULL;
+	}
+	fusion = instance->ctrl_context;
+	p = fusion->req_frames_desc
+		+sizeof(union MEGASAS_REQUEST_DESCRIPTOR_UNION) *index;
+
+	return (union MEGASAS_REQUEST_DESCRIPTOR_UNION *)p;
+}
+
+/**
+ * megasas_build_and_issue_cmd_fusion -Main routine for building and
+ *                                     issuing non IOCTL cmd
+ * @instance:			Adapter soft state
+ * @scmd:			pointer to scsi cmd from OS
+ */
+static u32
+megasas_build_and_issue_cmd_fusion(struct megasas_instance *instance,
+				   struct scsi_cmnd *scmd)
+{
+	struct megasas_cmd_fusion *cmd;
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	u32 index;
+	struct fusion_context *fusion;
+
+	fusion = instance->ctrl_context;
+
+	cmd = megasas_get_cmd_fusion(instance);
+	if (!cmd)
+		return SCSI_MLQUEUE_HOST_BUSY;
+
+	index = cmd->index;
+
+	req_desc = megasas_get_request_descriptor(instance, index-1);
+	if (!req_desc)
+		return 1;
+
+	req_desc->Words = 0;
+	cmd->request_desc = req_desc;
+	cmd->request_desc->Words = 0;
+
+	if (megasas_build_io_fusion(instance, scmd, cmd)) {
+		megasas_return_cmd_fusion(instance, cmd);
+		printk(KERN_ERR "megasas: Error building command.\n");
+		cmd->request_desc = NULL;
+		return 1;
+	}
+
+	req_desc = cmd->request_desc;
+	req_desc->SCSIIO.SMID = index;
+
+	if (cmd->io_request->ChainOffset != 0 &&
+	    cmd->io_request->ChainOffset != 0xF)
+		printk(KERN_ERR "megasas: The chain offset value is not "
+		       "correct : %x\n", cmd->io_request->ChainOffset);
+
+	/*
+	 * Issue the command to the FW
+	 */
+	atomic_inc(&instance->fw_outstanding);
+
+	instance->instancet->fire_cmd(instance,
+				      req_desc->u.low, req_desc->u.high,
+				      instance->reg_set);
+
+	return 0;
+}
+
+/**
+ * complete_cmd_fusion -	Completes command
+ * @instance:			Adapter soft state
+ * Completes all commands that is in reply descriptor queue
+ */
+int
+complete_cmd_fusion(struct megasas_instance *instance)
+{
+	union MPI2_REPLY_DESCRIPTORS_UNION *desc;
+	struct MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR *reply_desc;
+	struct MPI2_RAID_SCSI_IO_REQUEST *scsi_io_req;
+	struct fusion_context *fusion;
+	struct megasas_cmd *cmd_mfi;
+	struct megasas_cmd_fusion *cmd_fusion;
+	u16 smid, num_completed;
+	u8 reply_descript_type, arm;
+	u32 status, extStatus, device_id;
+	union desc_value d_val;
+	struct LD_LOAD_BALANCE_INFO *lbinfo;
+
+	fusion = instance->ctrl_context;
+
+	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR)
+		return IRQ_HANDLED;
+
+	desc = fusion->reply_frames_desc;
+	desc += fusion->last_reply_idx;
+
+	reply_desc = (struct MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR *)desc;
+
+	d_val.word = desc->Words;
+
+	reply_descript_type = reply_desc->ReplyFlags &
+		MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
+
+	if (reply_descript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
+		return IRQ_NONE;
+
+	d_val.word = desc->Words;
+
+	num_completed = 0;
+
+	while ((d_val.u.low != UINT_MAX) && (d_val.u.high != UINT_MAX)) {
+		smid = reply_desc->SMID;
+
+		cmd_fusion = fusion->cmd_list[smid - 1];
+
+		scsi_io_req =
+			(struct MPI2_RAID_SCSI_IO_REQUEST *)
+		  cmd_fusion->io_request;
+
+		if (cmd_fusion->scmd)
+			cmd_fusion->scmd->SCp.ptr = NULL;
+
+		status = scsi_io_req->RaidContext.status;
+		extStatus = scsi_io_req->RaidContext.exStatus;
+
+		switch (scsi_io_req->Function) {
+		case MPI2_FUNCTION_SCSI_IO_REQUEST:  /*Fast Path IO.*/
+			/* Update load balancing info */
+			device_id = MEGASAS_DEV_INDEX(instance,
+						      cmd_fusion->scmd);
+			lbinfo = &fusion->load_balance_info[device_id];
+			if (cmd_fusion->scmd->SCp.Status &
+			    MEGASAS_LOAD_BALANCE_FLAG) {
+				arm = lbinfo->raid1DevHandle[0] ==
+					cmd_fusion->io_request->DevHandle ? 0 :
+					1;
+				atomic_dec(&lbinfo->scsi_pending_cmds[arm]);
+				cmd_fusion->scmd->SCp.Status &=
+					~MEGASAS_LOAD_BALANCE_FLAG;
+			}
+			if (reply_descript_type ==
+			    MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS) {
+				if (megasas_dbg_lvl == 5)
+					printk(KERN_ERR "\nmegasas: FAST Path "
+					       "IO Success\n");
+			}
+			/* Fall thru and complete IO */
+		case MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST: /* LD-IO Path */
+			/* Map the FW Cmd Status */
+			map_cmd_status(cmd_fusion, status, extStatus);
+			scsi_dma_unmap(cmd_fusion->scmd);
+			cmd_fusion->scmd->scsi_done(cmd_fusion->scmd);
+			scsi_io_req->RaidContext.status = 0;
+			scsi_io_req->RaidContext.exStatus = 0;
+			megasas_return_cmd_fusion(instance, cmd_fusion);
+			atomic_dec(&instance->fw_outstanding);
+
+			break;
+		case MEGASAS_MPI2_FUNCTION_PASSTHRU_IO_REQUEST: /*MFI command */
+			cmd_mfi = instance->cmd_list[cmd_fusion->sync_cmd_idx];
+			megasas_complete_cmd(instance, cmd_mfi, DID_OK);
+			cmd_fusion->flags = 0;
+			megasas_return_cmd_fusion(instance, cmd_fusion);
+
+			break;
+		}
+
+		fusion->last_reply_idx++;
+		if (fusion->last_reply_idx >= fusion->reply_q_depth)
+			fusion->last_reply_idx = 0;
+
+		desc->Words = ULLONG_MAX;
+		num_completed++;
+
+		/* Get the next reply descriptor */
+		if (!fusion->last_reply_idx)
+			desc = fusion->reply_frames_desc;
+		else
+			desc++;
+
+		reply_desc =
+		  (struct MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR *)desc;
+
+		d_val.word = desc->Words;
+
+		reply_descript_type = reply_desc->ReplyFlags &
+			MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK;
+
+		if (reply_descript_type == MPI2_RPY_DESCRIPT_FLAGS_UNUSED)
+			break;
+	}
+
+	if (!num_completed)
+		return IRQ_NONE;
+
+	wmb();
+	writel(fusion->last_reply_idx,
+	       &instance->reg_set->reply_post_host_index);
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * megasas_complete_cmd_dpc_fusion -	Completes command
+ * @instance:			Adapter soft state
+ *
+ * Tasklet to complete cmds
+ */
+void
+megasas_complete_cmd_dpc_fusion(unsigned long instance_addr)
+{
+	struct megasas_instance *instance =
+		(struct megasas_instance *)instance_addr;
+	unsigned long flags;
+
+	/* If we have already declared adapter dead, donot complete cmds */
+	spin_lock_irqsave(&instance->hba_lock, flags);
+	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
+		spin_unlock_irqrestore(&instance->hba_lock, flags);
+		return;
+	}
+	spin_unlock_irqrestore(&instance->hba_lock, flags);
+
+	spin_lock_irqsave(&instance->completion_lock, flags);
+	complete_cmd_fusion(instance);
+	spin_unlock_irqrestore(&instance->completion_lock, flags);
+}
+
+/**
+ * megasas_isr_fusion - isr entry point
+ */
+irqreturn_t megasas_isr_fusion(int irq, void *devp)
+{
+	struct megasas_instance *instance = (struct megasas_instance *)devp;
+	u32 mfiStatus, fw_state;
+
+	if (!instance->msi_flag) {
+		mfiStatus = instance->instancet->clear_intr(instance->reg_set);
+		if (!mfiStatus)
+			return IRQ_NONE;
+	}
+
+	/* If we are resetting, bail */
+	if (test_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags))
+		return IRQ_HANDLED;
+
+	if (!complete_cmd_fusion(instance)) {
+		/* If we didn't complete any commands, check for FW fault */
+		fw_state = instance->instancet->read_fw_status_reg(
+			instance->reg_set) & MFI_STATE_MASK;
+		if (fw_state == MFI_STATE_FAULT)
+			schedule_work(&instance->work_init);
+	}
+
+	return IRQ_HANDLED;
+}
+
+/**
+ * build_mpt_mfi_pass_thru - builds a cmd fo MFI Pass thru
+ * @instance:			Adapter soft state
+ * mfi_cmd:			megasas_cmd pointer
+ *
+ */
+u8
+build_mpt_mfi_pass_thru(struct megasas_instance *instance,
+			struct megasas_cmd *mfi_cmd)
+{
+	struct MPI25_IEEE_SGE_CHAIN64 *mpi25_ieee_chain;
+	struct MPI2_RAID_SCSI_IO_REQUEST *io_req;
+	struct megasas_cmd_fusion *cmd;
+	struct fusion_context *fusion;
+	struct megasas_header *frame_hdr = &mfi_cmd->frame->hdr;
+
+	cmd = megasas_get_cmd_fusion(instance);
+	if (!cmd)
+		return 1;
+
+	/*  Save the smid. To be used for returning the cmd */
+	mfi_cmd->context.smid = cmd->index;
+
+	cmd->sync_cmd_idx = mfi_cmd->index;
+
+	/*
+	 * For cmds where the flag is set, store the flag and check
+	 * on completion. For cmds with this flag, don't call
+	 * megasas_complete_cmd
+	 */
+
+	if (frame_hdr->flags & MFI_FRAME_DONT_POST_IN_REPLY_QUEUE)
+		cmd->flags = MFI_FRAME_DONT_POST_IN_REPLY_QUEUE;
+
+	fusion = instance->ctrl_context;
+	io_req = cmd->io_request;
+	mpi25_ieee_chain =
+	  (struct MPI25_IEEE_SGE_CHAIN64 *)&io_req->SGL.IeeeChain;
+
+	io_req->Function    = MEGASAS_MPI2_FUNCTION_PASSTHRU_IO_REQUEST;
+	io_req->SGLOffset0  = offsetof(struct MPI2_RAID_SCSI_IO_REQUEST,
+				       SGL) / 4;
+	io_req->ChainOffset = fusion->chain_offset_mfi_pthru;
+
+	mpi25_ieee_chain->Address = mfi_cmd->frame_phys_addr;
+
+	mpi25_ieee_chain->Flags = IEEE_SGE_FLAGS_CHAIN_ELEMENT |
+		MPI2_IEEE_SGE_FLAGS_IOCPLBNTA_ADDR;
+
+	mpi25_ieee_chain->Length = MEGASAS_MAX_SZ_CHAIN_FRAME;
+
+	return 0;
+}
+
+/**
+ * build_mpt_cmd - Calls helper function to build a cmd MFI Pass thru cmd
+ * @instance:			Adapter soft state
+ * @cmd:			mfi cmd to build
+ *
+ */
+union MEGASAS_REQUEST_DESCRIPTOR_UNION *
+build_mpt_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
+{
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	u16 index;
+
+	if (build_mpt_mfi_pass_thru(instance, cmd)) {
+		printk(KERN_ERR "Couldn't build MFI pass thru cmd\n");
+		return NULL;
+	}
+
+	index = cmd->context.smid;
+
+	req_desc = megasas_get_request_descriptor(instance, index - 1);
+
+	if (!req_desc)
+		return NULL;
+
+	req_desc->Words = 0;
+	req_desc->SCSIIO.RequestFlags = (MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
+					 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+
+	req_desc->SCSIIO.SMID = index;
+
+	return req_desc;
+}
+
+/**
+ * megasas_issue_dcmd_fusion - Issues a MFI Pass thru cmd
+ * @instance:			Adapter soft state
+ * @cmd:			mfi cmd pointer
+ *
+ */
+void
+megasas_issue_dcmd_fusion(struct megasas_instance *instance,
+			  struct megasas_cmd *cmd)
+{
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	union desc_value d_val;
+
+	req_desc = build_mpt_cmd(instance, cmd);
+	if (!req_desc) {
+		printk(KERN_ERR "Couldn't issue MFI pass thru cmd\n");
+		return;
+	}
+	d_val.word = req_desc->Words;
+
+	instance->instancet->fire_cmd(instance, req_desc->u.low,
+				      req_desc->u.high, instance->reg_set);
+}
+
+/**
+ * megasas_release_fusion -	Reverses the FW initialization
+ * @intance:			Adapter soft state
+ */
+void
+megasas_release_fusion(struct megasas_instance *instance)
+{
+	megasas_free_cmds(instance);
+	megasas_free_cmds_fusion(instance);
+
+	iounmap(instance->reg_set);
+
+	pci_release_selected_regions(instance->pdev, instance->bar);
+}
+
+/**
+ * megasas_read_fw_status_reg_fusion - returns the current FW status value
+ * @regs:			MFI register set
+ */
+static u32
+megasas_read_fw_status_reg_fusion(struct megasas_register_set __iomem *regs)
+{
+	return readl(&(regs)->outbound_scratch_pad);
+}
+
+/**
+ * megasas_adp_reset_fusion -	For controller reset
+ * @regs:				MFI register set
+ */
+static int
+megasas_adp_reset_fusion(struct megasas_instance *instance,
+			 struct megasas_register_set __iomem *regs)
+{
+	return 0;
+}
+
+/**
+ * megasas_check_reset_fusion -	For controller reset check
+ * @regs:				MFI register set
+ */
+static int
+megasas_check_reset_fusion(struct megasas_instance *instance,
+			   struct megasas_register_set __iomem *regs)
+{
+	return 0;
+}
+
+/* This function waits for outstanding commands on fusion to complete */
+int megasas_wait_for_outstanding_fusion(struct megasas_instance *instance)
+{
+	int i, outstanding, retval = 0;
+	u32 fw_state, wait_time = MEGASAS_RESET_WAIT_TIME;
+
+	for (i = 0; i < wait_time; i++) {
+		/* Check if firmware is in fault state */
+		fw_state = instance->instancet->read_fw_status_reg(
+			instance->reg_set) & MFI_STATE_MASK;
+		if (fw_state == MFI_STATE_FAULT) {
+			printk(KERN_WARNING "megasas: Found FW in FAULT state,"
+			       " will reset adapter.\n");
+			retval = 1;
+			goto out;
+		}
+
+		outstanding = atomic_read(&instance->fw_outstanding);
+		if (!outstanding)
+			goto out;
+
+		if (!(i % MEGASAS_RESET_NOTICE_INTERVAL)) {
+			printk(KERN_NOTICE "megasas: [%2d]waiting for %d "
+			       "commands to complete\n", i, outstanding);
+			megasas_complete_cmd_dpc_fusion(
+				(unsigned long)instance);
+		}
+		msleep(1000);
+	}
+
+	if (atomic_read(&instance->fw_outstanding)) {
+		printk("megaraid_sas: pending commands remain after waiting, "
+		       "will reset adapter.\n");
+		retval = 1;
+	}
+out:
+	return retval;
+}
+
+void  megasas_reset_reply_desc(struct megasas_instance *instance)
+{
+	int i;
+	struct fusion_context *fusion;
+	union MPI2_REPLY_DESCRIPTORS_UNION *reply_desc;
+
+	fusion = instance->ctrl_context;
+	fusion->last_reply_idx = 0;
+	reply_desc = fusion->reply_frames_desc;
+	for (i = 0 ; i < fusion->reply_q_depth; i++, reply_desc++)
+		reply_desc->Words = ULLONG_MAX;
+}
+
+/* Core fusion reset function */
+int megasas_reset_fusion(struct scsi_cmnd *scmd)
+{
+	int retval = SUCCESS, i, j, retry = 0;
+	struct megasas_instance *instance;
+	struct megasas_cmd_fusion *cmd_fusion;
+	struct fusion_context *fusion;
+	struct megasas_cmd *cmd_mfi;
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	u32 host_diag, abs_state;
+
+	instance = (struct megasas_instance *)scmd->device->host->hostdata;
+	fusion = instance->ctrl_context;
+
+	mutex_lock(&instance->reset_mutex);
+	set_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	instance->adprecovery = MEGASAS_ADPRESET_SM_INFAULT;
+	instance->instancet->disable_intr(instance->reg_set);
+	msleep(1000);
+
+	if (instance->adprecovery == MEGASAS_HW_CRITICAL_ERROR) {
+		printk(KERN_WARNING "megaraid_sas: Hardware critical error, "
+		       "returning FAILED.\n");
+		retval = FAILED;
+		goto out;
+	}
+
+	/* First try waiting for commands to complete */
+	if (megasas_wait_for_outstanding_fusion(instance)) {
+		printk(KERN_WARNING "megaraid_sas: resetting fusion "
+		       "adapter.\n");
+		/* Now return commands back to the OS */
+		for (i = 0 ; i < instance->max_fw_cmds; i++) {
+			cmd_fusion = fusion->cmd_list[i];
+			if (cmd_fusion->scmd) {
+				scsi_dma_unmap(cmd_fusion->scmd);
+				cmd_fusion->scmd->result = (DID_RESET << 16);
+				cmd_fusion->scmd->scsi_done(cmd_fusion->scmd);
+				megasas_return_cmd_fusion(instance, cmd_fusion);
+				atomic_dec(&instance->fw_outstanding);
+			}
+		}
+
+		if (instance->disableOnlineCtrlReset == 1) {
+			/* Reset not supported, kill adapter */
+			printk(KERN_WARNING "megaraid_sas: Reset not supported"
+			       ", killing adapter.\n");
+			megaraid_sas_kill_hba(instance);
+			instance->adprecovery = MEGASAS_HW_CRITICAL_ERROR;
+			retval = FAILED;
+			goto out;
+		}
+
+		/* Now try to reset the chip */
+		for (i = 0; i < MEGASAS_FUSION_MAX_RESET_TRIES; i++) {
+			writel(MPI2_WRSEQ_FLUSH_KEY_VALUE,
+			       &instance->reg_set->fusion_seq_offset);
+			writel(MPI2_WRSEQ_1ST_KEY_VALUE,
+			       &instance->reg_set->fusion_seq_offset);
+			writel(MPI2_WRSEQ_2ND_KEY_VALUE,
+			       &instance->reg_set->fusion_seq_offset);
+			writel(MPI2_WRSEQ_3RD_KEY_VALUE,
+			       &instance->reg_set->fusion_seq_offset);
+			writel(MPI2_WRSEQ_4TH_KEY_VALUE,
+			       &instance->reg_set->fusion_seq_offset);
+			writel(MPI2_WRSEQ_5TH_KEY_VALUE,
+			       &instance->reg_set->fusion_seq_offset);
+			writel(MPI2_WRSEQ_6TH_KEY_VALUE,
+			       &instance->reg_set->fusion_seq_offset);
+
+			/* Check that the diag write enable (DRWE) bit is on */
+			host_diag = readl(&instance->reg_set->fusion_host_diag);
+			while (!(host_diag & HOST_DIAG_WRITE_ENABLE)) {
+				msleep(100);
+				host_diag =
+				readl(&instance->reg_set->fusion_host_diag);
+				if (retry++ == 100) {
+					printk(KERN_WARNING "megaraid_sas: "
+					       "Host diag unlock failed!\n");
+					break;
+				}
+			}
+			if (!(host_diag & HOST_DIAG_WRITE_ENABLE))
+				continue;
+
+			/* Send chip reset command */
+			writel(host_diag | HOST_DIAG_RESET_ADAPTER,
+			       &instance->reg_set->fusion_host_diag);
+			msleep(3000);
+
+			/* Make sure reset adapter bit is cleared */
+			host_diag = readl(&instance->reg_set->fusion_host_diag);
+			retry = 0;
+			while (host_diag & HOST_DIAG_RESET_ADAPTER) {
+				msleep(100);
+				host_diag =
+				readl(&instance->reg_set->fusion_host_diag);
+				if (retry++ == 1000) {
+					printk(KERN_WARNING "megaraid_sas: "
+					       "Diag reset adapter never "
+					       "cleared!\n");
+					break;
+				}
+			}
+			if (host_diag & HOST_DIAG_RESET_ADAPTER)
+				continue;
+
+			abs_state =
+				instance->instancet->read_fw_status_reg(
+					instance->reg_set);
+			retry = 0;
+
+			while ((abs_state <= MFI_STATE_FW_INIT) &&
+			       (retry++ < 1000)) {
+				msleep(100);
+				abs_state =
+				instance->instancet->read_fw_status_reg(
+					instance->reg_set);
+			}
+			if (abs_state <= MFI_STATE_FW_INIT) {
+				printk(KERN_WARNING "megaraid_sas: firmware "
+				       "state < MFI_STATE_FW_INIT, state = "
+				       "0x%x\n", abs_state);
+				continue;
+			}
+
+			/* Wait for FW to become ready */
+			if (megasas_transition_to_ready(instance)) {
+				printk(KERN_WARNING "megaraid_sas: Failed to "
+				       "transition controller to ready.\n");
+				continue;
+			}
+
+			megasas_reset_reply_desc(instance);
+			if (megasas_ioc_init_fusion(instance)) {
+				printk(KERN_WARNING "megaraid_sas: "
+				       "megasas_ioc_init_fusion() failed!\n");
+				continue;
+			}
+
+			instance->instancet->enable_intr(instance->reg_set);
+			instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
+
+			/* Re-fire management commands */
+			for (j = 0 ; j < instance->max_fw_cmds; j++) {
+				cmd_fusion = fusion->cmd_list[j];
+				if (cmd_fusion->sync_cmd_idx !=
+				    (u32)ULONG_MAX) {
+					cmd_mfi =
+					instance->
+					cmd_list[cmd_fusion->sync_cmd_idx];
+					if (cmd_mfi->frame->dcmd.opcode ==
+					    MR_DCMD_LD_MAP_GET_INFO) {
+						megasas_return_cmd(instance,
+								   cmd_mfi);
+						megasas_return_cmd_fusion(
+							instance, cmd_fusion);
+					} else  {
+						req_desc =
+						megasas_get_request_descriptor(
+							instance,
+							cmd_mfi->context.smid
+							-1);
+						if (!req_desc)
+							printk(KERN_WARNING
+							       "req_desc NULL"
+							       "\n");
+						else {
+							instance->instancet->
+							fire_cmd(instance,
+								 req_desc->
+								 u.low,
+								 req_desc->
+								 u.high,
+								 instance->
+								 reg_set);
+						}
+					}
+				}
+			}
+
+			/* Reset load balance info */
+			memset(fusion->load_balance_info, 0,
+			       sizeof(struct LD_LOAD_BALANCE_INFO)
+			       *MAX_LOGICAL_DRIVES);
+
+			if (!megasas_get_map_info(instance))
+				megasas_sync_map_info(instance);
+
+			/* Adapter reset completed successfully */
+			printk(KERN_WARNING "megaraid_sas: Reset "
+			       "successful.\n");
+			retval = SUCCESS;
+			goto out;
+		}
+		/* Reset failed, kill the adapter */
+		printk(KERN_WARNING "megaraid_sas: Reset failed, killing "
+		       "adapter.\n");
+		megaraid_sas_kill_hba(instance);
+		retval = FAILED;
+	} else {
+		instance->instancet->enable_intr(instance->reg_set);
+		instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
+	}
+out:
+	clear_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
+	mutex_unlock(&instance->reset_mutex);
+	return retval;
+}
+
+/* Fusion OCR work queue */
+void megasas_fusion_ocr_wq(struct work_struct *work)
+{
+	struct megasas_instance *instance =
+		container_of(work, struct megasas_instance, work_init);
+
+	instance->scmd.device = &instance->dev;
+	instance->dev.host = instance->host;
+	megasas_reset_fusion(&instance->scmd);
+}
+
+struct megasas_instance_template megasas_instance_template_fusion = {
+	.fire_cmd = megasas_fire_cmd_fusion,
+	.enable_intr = megasas_enable_intr_fusion,
+	.disable_intr = megasas_disable_intr_fusion,
+	.clear_intr = megasas_clear_intr_fusion,
+	.read_fw_status_reg = megasas_read_fw_status_reg_fusion,
+	.adp_reset = megasas_adp_reset_fusion,
+	.check_reset = megasas_check_reset_fusion,
+	.service_isr = megasas_isr_fusion,
+	.tasklet = megasas_complete_cmd_dpc_fusion,
+	.init_adapter = megasas_init_adapter_fusion,
+	.build_and_issue_cmd = megasas_build_and_issue_cmd_fusion,
+	.issue_dcmd = megasas_issue_dcmd_fusion,
+};
diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_fusion.h
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_fusion.h
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas_fusion.h	1969-12-31
16:00:00.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas_fusion.h	2010-12-21
11:04:07.000000000 -0800
@@ -0,0 +1,695 @@
+/*
+ *  Linux MegaRAID driver for SAS based RAID controllers
+ *
+ *  Copyright (c) 2009-2011  LSI Corporation.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation; either version 2
+ *  of the License, or (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ *
+ *  FILE: megaraid_sas_fusion.h
+ *
+ *  Authors: LSI Corporation
+ *           Manoj Jose
+ *           Sumant Patro
+ *
+ *  Send feedback to: <megaraidlinux@lsi.com>
+ *
+ *  Mail to: LSI Corporation, 1621 Barber Lane, Milpitas, CA 95035
+ *     ATTN: Linuxraid
+ */
+
+#ifndef _MEGARAID_SAS_FUSION_H_
+#define _MEGARAID_SAS_FUSION_H_
+
+/* Fusion defines */
+#define MEGASAS_MAX_SZ_CHAIN_FRAME 1024
+#define MFI_FUSION_ENABLE_INTERRUPT_MASK (0x00000009)
+#define MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE 256
+#define MEGASAS_MPI2_FUNCTION_PASSTHRU_IO_REQUEST   0xF0
+#define MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST         0xF1
+#define MEGASAS_LOAD_BALANCE_FLAG		    0x1
+#define MEGASAS_DCMD_MBOX_PEND_FLAG		    0x1
+#define HOST_DIAG_WRITE_ENABLE			    0x80
+#define HOST_DIAG_RESET_ADAPTER			    0x4
+#define MEGASAS_FUSION_MAX_RESET_TRIES		    3
+
+/* T10 PI defines */
+#define MR_PROT_INFO_TYPE_CONTROLLER                0x8
+#define MEGASAS_SCSI_VARIABLE_LENGTH_CMD            0x7f
+#define MEGASAS_SCSI_SERVICE_ACTION_READ32          0x9
+#define MEGASAS_SCSI_SERVICE_ACTION_WRITE32         0xB
+#define MEGASAS_SCSI_ADDL_CDB_LEN                   0x18
+#define MEGASAS_RD_WR_PROTECT_CHECK_ALL		    0x20
+#define MEGASAS_RD_WR_PROTECT_CHECK_NONE	    0x60
+#define MEGASAS_EEDPBLOCKSIZE			    512
+
+/*
+ * Raid context flags
+ */
+
+#define MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT   0x4
+#define MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_MASK    0x30
+enum MR_RAID_FLAGS_IO_SUB_TYPE {
+	MR_RAID_FLAGS_IO_SUB_TYPE_NONE = 0,
+	MR_RAID_FLAGS_IO_SUB_TYPE_SYSTEM_PD = 1,
+};
+
+/*
+ * Request descriptor types
+ */
+#define MEGASAS_REQ_DESCRIPT_FLAGS_LD_IO           0x7
+#define MEGASAS_REQ_DESCRIPT_FLAGS_MFA             0x1
+
+#define MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT      1
+
+#define MEGASAS_FP_CMD_LEN	16
+#define MEGASAS_FUSION_IN_RESET 0
+
+/*
+ * Raid Context structure which describes MegaRAID specific IO Paramenters
+ * This resides at offset 0x60 where the SGL normally starts in MPT IO Frames
+ */
+
+struct RAID_CONTEXT {
+	u16     resvd0;
+	u16     timeoutValue;
+	u8      regLockFlags;
+	u8      resvd1;
+	u16     VirtualDiskTgtId;
+	u64     regLockRowLBA;
+	u32     regLockLength;
+	u16     nextLMId;
+	u8      exStatus;
+	u8      status;
+	u8      RAIDFlags;
+	u8      numSGE;
+	u16	configSeqNum;
+	u8      spanArm;
+	u8      resvd2[3];
+};
+
+#define RAID_CTX_SPANARM_ARM_SHIFT	(0)
+#define RAID_CTX_SPANARM_ARM_MASK	(0x1f)
+
+#define RAID_CTX_SPANARM_SPAN_SHIFT	(5)
+#define RAID_CTX_SPANARM_SPAN_MASK	(0xE0)
+
+/*
+ * define region lock types
+ */
+enum REGION_TYPE {
+	REGION_TYPE_UNUSED       = 0,
+	REGION_TYPE_SHARED_READ  = 1,
+	REGION_TYPE_SHARED_WRITE = 2,
+	REGION_TYPE_EXCLUSIVE    = 3,
+};
+
+/* MPI2 defines */
+#define MPI2_FUNCTION_IOC_INIT              (0x02) /* IOC Init */
+#define MPI2_WHOINIT_HOST_DRIVER            (0x04)
+#define MPI2_VERSION_MAJOR                  (0x02)
+#define MPI2_VERSION_MINOR                  (0x00)
+#define MPI2_VERSION_MAJOR_MASK             (0xFF00)
+#define MPI2_VERSION_MAJOR_SHIFT            (8)
+#define MPI2_VERSION_MINOR_MASK             (0x00FF)
+#define MPI2_VERSION_MINOR_SHIFT            (0)
+#define MPI2_VERSION ((MPI2_VERSION_MAJOR << MPI2_VERSION_MAJOR_SHIFT) | \
+		      MPI2_VERSION_MINOR)
+#define MPI2_HEADER_VERSION_UNIT            (0x10)
+#define MPI2_HEADER_VERSION_DEV             (0x00)
+#define MPI2_HEADER_VERSION_UNIT_MASK       (0xFF00)
+#define MPI2_HEADER_VERSION_UNIT_SHIFT      (8)
+#define MPI2_HEADER_VERSION_DEV_MASK        (0x00FF)
+#define MPI2_HEADER_VERSION_DEV_SHIFT       (0)
+#define MPI2_HEADER_VERSION ((MPI2_HEADER_VERSION_UNIT << 8) | \
+			     MPI2_HEADER_VERSION_DEV)
+#define MPI2_IEEE_SGE_FLAGS_IOCPLBNTA_ADDR      (0x03)
+#define MPI2_SCSIIO_EEDPFLAGS_INC_PRI_REFTAG        (0x8000)
+#define MPI2_SCSIIO_EEDPFLAGS_CHECK_REFTAG          (0x0400)
+#define MPI2_SCSIIO_EEDPFLAGS_CHECK_REMOVE_OP       (0x0003)
+#define MPI2_SCSIIO_EEDPFLAGS_CHECK_APPTAG          (0x0200)
+#define MPI2_SCSIIO_EEDPFLAGS_CHECK_GUARD           (0x0100)
+#define MPI2_SCSIIO_EEDPFLAGS_INSERT_OP             (0x0004)
+#define MPI2_FUNCTION_SCSI_IO_REQUEST               (0x00) /* SCSI IO */
+#define MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY           (0x06)
+#define MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO                 (0x00)
+#define MPI2_SGE_FLAGS_64_BIT_ADDRESSING        (0x02)
+#define MPI2_SCSIIO_CONTROL_WRITE               (0x01000000)
+#define MPI2_SCSIIO_CONTROL_READ                (0x02000000)
+#define MPI2_REQ_DESCRIPT_FLAGS_TYPE_MASK       (0x0E)
+#define MPI2_RPY_DESCRIPT_FLAGS_UNUSED          (0x0F)
+#define MPI2_RPY_DESCRIPT_FLAGS_SCSI_IO_SUCCESS (0x00)
+#define MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK       (0x0F)
+#define MPI2_WRSEQ_FLUSH_KEY_VALUE              (0x0)
+#define MPI2_WRITE_SEQUENCE_OFFSET              (0x00000004)
+#define MPI2_WRSEQ_1ST_KEY_VALUE                (0xF)
+#define MPI2_WRSEQ_2ND_KEY_VALUE                (0x4)
+#define MPI2_WRSEQ_3RD_KEY_VALUE                (0xB)
+#define MPI2_WRSEQ_4TH_KEY_VALUE                (0x2)
+#define MPI2_WRSEQ_5TH_KEY_VALUE                (0x7)
+#define MPI2_WRSEQ_6TH_KEY_VALUE                (0xD)
+
+struct MPI25_IEEE_SGE_CHAIN64 {
+	u64                     Address;
+	u32                     Length;
+	u16                     Reserved1;
+	u8                      NextChainOffset;
+	u8                      Flags;
+};
+
+struct MPI2_SGE_SIMPLE_UNION {
+	u32                     FlagsLength;
+	union {
+		u32                 Address32;
+		u64                 Address64;
+	} u;
+};
+
+struct MPI2_SCSI_IO_CDB_EEDP32 {
+	u8                      CDB[20];                    /* 0x00 */
+	u32                     PrimaryReferenceTag;        /* 0x14 */
+	u16                     PrimaryApplicationTag;      /* 0x18 */
+	u16                     PrimaryApplicationTagMask;  /* 0x1A */
+	u32                     TransferLength;             /* 0x1C */
+};
+
+struct MPI2_SGE_CHAIN_UNION {
+	u16                     Length;
+	u8                      NextChainOffset;
+	u8                      Flags;
+	union {
+		u32                 Address32;
+		u64                 Address64;
+	} u;
+};
+
+struct MPI2_IEEE_SGE_SIMPLE32 {
+	u32                     Address;
+	u32                     FlagsLength;
+};
+
+struct MPI2_IEEE_SGE_CHAIN32 {
+	u32                     Address;
+	u32                     FlagsLength;
+};
+
+struct MPI2_IEEE_SGE_SIMPLE64 {
+	u64                     Address;
+	u32                     Length;
+	u16                     Reserved1;
+	u8                      Reserved2;
+	u8                      Flags;
+};
+
+struct MPI2_IEEE_SGE_CHAIN64 {
+	u64                     Address;
+	u32                     Length;
+	u16                     Reserved1;
+	u8                      Reserved2;
+	u8                      Flags;
+};
+
+union MPI2_IEEE_SGE_SIMPLE_UNION {
+	struct MPI2_IEEE_SGE_SIMPLE32  Simple32;
+	struct MPI2_IEEE_SGE_SIMPLE64  Simple64;
+};
+
+union MPI2_IEEE_SGE_CHAIN_UNION {
+	struct MPI2_IEEE_SGE_CHAIN32   Chain32;
+	struct MPI2_IEEE_SGE_CHAIN64   Chain64;
+};
+
+union MPI2_SGE_IO_UNION {
+	struct MPI2_SGE_SIMPLE_UNION       MpiSimple;
+	struct MPI2_SGE_CHAIN_UNION        MpiChain;
+	union MPI2_IEEE_SGE_SIMPLE_UNION  IeeeSimple;
+	union MPI2_IEEE_SGE_CHAIN_UNION   IeeeChain;
+};
+
+union MPI2_SCSI_IO_CDB_UNION {
+	u8                      CDB32[32];
+	struct MPI2_SCSI_IO_CDB_EEDP32 EEDP32;
+	struct MPI2_SGE_SIMPLE_UNION SGE;
+};
+
+/*
+ * RAID SCSI IO Request Message
+ * Total SGE count will be one less than  _MPI2_SCSI_IO_REQUEST
+ */
+struct MPI2_RAID_SCSI_IO_REQUEST {
+	u16                     DevHandle;                      /* 0x00 */
+	u8                      ChainOffset;                    /* 0x02 */
+	u8                      Function;                       /* 0x03 */
+	u16                     Reserved1;                      /* 0x04 */
+	u8                      Reserved2;                      /* 0x06 */
+	u8                      MsgFlags;                       /* 0x07 */
+	u8                      VP_ID;                          /* 0x08 */
+	u8                      VF_ID;                          /* 0x09 */
+	u16                     Reserved3;                      /* 0x0A */
+	u32                     SenseBufferLowAddress;          /* 0x0C */
+	u16                     SGLFlags;                       /* 0x10 */
+	u8                      SenseBufferLength;              /* 0x12 */
+	u8                      Reserved4;                      /* 0x13 */
+	u8                      SGLOffset0;                     /* 0x14 */
+	u8                      SGLOffset1;                     /* 0x15 */
+	u8                      SGLOffset2;                     /* 0x16 */
+	u8                      SGLOffset3;                     /* 0x17 */
+	u32                     SkipCount;                      /* 0x18 */
+	u32                     DataLength;                     /* 0x1C */
+	u32                     BidirectionalDataLength;        /* 0x20 */
+	u16                     IoFlags;                        /* 0x24 */
+	u16                     EEDPFlags;                      /* 0x26 */
+	u32                     EEDPBlockSize;                  /* 0x28 */
+	u32                     SecondaryReferenceTag;          /* 0x2C */
+	u16                     SecondaryApplicationTag;        /* 0x30 */
+	u16                     ApplicationTagTranslationMask;  /* 0x32 */
+	u8                      LUN[8];                         /* 0x34 */
+	u32                     Control;                        /* 0x3C */
+	union MPI2_SCSI_IO_CDB_UNION  CDB;			/* 0x40 */
+	struct RAID_CONTEXT	RaidContext;                    /* 0x60 */
+	union MPI2_SGE_IO_UNION       SGL;			/* 0x80 */
+};
+
+/*
+ * MPT RAID MFA IO Descriptor.
+ */
+struct MEGASAS_RAID_MFA_IO_REQUEST_DESCRIPTOR {
+	u32     RequestFlags:8;
+	u32     MessageAddress1:24; /* bits 31:8*/
+	u32     MessageAddress2;      /* bits 61:32 */
+};
+
+/* Default Request Descriptor */
+struct MPI2_DEFAULT_REQUEST_DESCRIPTOR {
+	u8              RequestFlags;               /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u16             LMID;                       /* 0x04 */
+	u16             DescriptorTypeDependent;    /* 0x06 */
+};
+
+/* High Priority Request Descriptor */
+struct MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR {
+	u8              RequestFlags;               /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u16             LMID;                       /* 0x04 */
+	u16             Reserved1;                  /* 0x06 */
+};
+
+/* SCSI IO Request Descriptor */
+struct MPI2_SCSI_IO_REQUEST_DESCRIPTOR {
+	u8              RequestFlags;               /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u16             LMID;                       /* 0x04 */
+	u16             DevHandle;                  /* 0x06 */
+};
+
+/* SCSI Target Request Descriptor */
+struct MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR {
+	u8              RequestFlags;               /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u16             LMID;                       /* 0x04 */
+	u16             IoIndex;                    /* 0x06 */
+};
+
+/* RAID Accelerator Request Descriptor */
+struct MPI2_RAID_ACCEL_REQUEST_DESCRIPTOR {
+	u8              RequestFlags;               /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u16             LMID;                       /* 0x04 */
+	u16             Reserved;                   /* 0x06 */
+};
+
+/* union of Request Descriptors */
+union MEGASAS_REQUEST_DESCRIPTOR_UNION {
+	struct MPI2_DEFAULT_REQUEST_DESCRIPTOR             Default;
+	struct MPI2_HIGH_PRIORITY_REQUEST_DESCRIPTOR       HighPriority;
+	struct MPI2_SCSI_IO_REQUEST_DESCRIPTOR             SCSIIO;
+	struct MPI2_SCSI_TARGET_REQUEST_DESCRIPTOR         SCSITarget;
+	struct MPI2_RAID_ACCEL_REQUEST_DESCRIPTOR          RAIDAccelerator;
+	struct MEGASAS_RAID_MFA_IO_REQUEST_DESCRIPTOR      MFAIo;
+	union {
+		struct {
+			u32 low;
+			u32 high;
+		} u;
+		u64 Words;
+	};
+};
+
+/* Default Reply Descriptor */
+struct MPI2_DEFAULT_REPLY_DESCRIPTOR {
+	u8              ReplyFlags;                 /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             DescriptorTypeDependent1;   /* 0x02 */
+	u32             DescriptorTypeDependent2;   /* 0x04 */
+};
+
+/* Address Reply Descriptor */
+struct MPI2_ADDRESS_REPLY_DESCRIPTOR {
+	u8              ReplyFlags;                 /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u32             ReplyFrameAddress;          /* 0x04 */
+};
+
+/* SCSI IO Success Reply Descriptor */
+struct MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR {
+	u8              ReplyFlags;                 /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u16             TaskTag;                    /* 0x04 */
+	u16             Reserved1;                  /* 0x06 */
+};
+
+/* TargetAssist Success Reply Descriptor */
+struct MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR {
+	u8              ReplyFlags;                 /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u8              SequenceNumber;             /* 0x04 */
+	u8              Reserved1;                  /* 0x05 */
+	u16             IoIndex;                    /* 0x06 */
+};
+
+/* Target Command Buffer Reply Descriptor */
+struct MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR {
+	u8              ReplyFlags;                 /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u8              VP_ID;                      /* 0x02 */
+	u8              Flags;                      /* 0x03 */
+	u16             InitiatorDevHandle;         /* 0x04 */
+	u16             IoIndex;                    /* 0x06 */
+};
+
+/* RAID Accelerator Success Reply Descriptor */
+struct MPI2_RAID_ACCELERATOR_SUCCESS_REPLY_DESCRIPTOR {
+	u8              ReplyFlags;                 /* 0x00 */
+	u8              MSIxIndex;                  /* 0x01 */
+	u16             SMID;                       /* 0x02 */
+	u32             Reserved;                   /* 0x04 */
+};
+
+/* union of Reply Descriptors */
+union MPI2_REPLY_DESCRIPTORS_UNION {
+	struct MPI2_DEFAULT_REPLY_DESCRIPTOR                   Default;
+	struct MPI2_ADDRESS_REPLY_DESCRIPTOR                   AddressReply;
+	struct MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR           SCSIIOSuccess;
+	struct MPI2_TARGETASSIST_SUCCESS_REPLY_DESCRIPTOR TargetAssistSuccess;
+	struct MPI2_TARGET_COMMAND_BUFFER_REPLY_DESCRIPTOR TargetCommandBuffer;
+	struct MPI2_RAID_ACCELERATOR_SUCCESS_REPLY_DESCRIPTOR
+	RAIDAcceleratorSuccess;
+	u64                                             Words;
+};
+
+/* IOCInit Request message */
+struct MPI2_IOC_INIT_REQUEST {
+	u8                      WhoInit;                        /* 0x00 */
+	u8                      Reserved1;                      /* 0x01 */
+	u8                      ChainOffset;                    /* 0x02 */
+	u8                      Function;                       /* 0x03 */
+	u16                     Reserved2;                      /* 0x04 */
+	u8                      Reserved3;                      /* 0x06 */
+	u8                      MsgFlags;                       /* 0x07 */
+	u8                      VP_ID;                          /* 0x08 */
+	u8                      VF_ID;                          /* 0x09 */
+	u16                     Reserved4;                      /* 0x0A */
+	u16                     MsgVersion;                     /* 0x0C */
+	u16                     HeaderVersion;                  /* 0x0E */
+	u32                     Reserved5;                      /* 0x10 */
+	u16                     Reserved6;                      /* 0x14 */
+	u8                      Reserved7;                      /* 0x16 */
+	u8                      HostMSIxVectors;                /* 0x17 */
+	u16                     Reserved8;                      /* 0x18 */
+	u16                     SystemRequestFrameSize;         /* 0x1A */
+	u16                     ReplyDescriptorPostQueueDepth;  /* 0x1C */
+	u16                     ReplyFreeQueueDepth;            /* 0x1E */
+	u32                     SenseBufferAddressHigh;         /* 0x20 */
+	u32                     SystemReplyAddressHigh;         /* 0x24 */
+	u64                     SystemRequestFrameBaseAddress;  /* 0x28 */
+	u64                     ReplyDescriptorPostQueueAddress;/* 0x30 */
+	u64                     ReplyFreeQueueAddress;          /* 0x38 */
+	u64                     TimeStamp;                      /* 0x40 */
+};
+
+/* mrpriv defines */
+#define MR_PD_INVALID 0xFFFF
+#define MAX_SPAN_DEPTH 8
+#define MAX_RAIDMAP_SPAN_DEPTH (MAX_SPAN_DEPTH)
+#define MAX_ROW_SIZE 32
+#define MAX_RAIDMAP_ROW_SIZE (MAX_ROW_SIZE)
+#define MAX_LOGICAL_DRIVES 64
+#define MAX_RAIDMAP_LOGICAL_DRIVES (MAX_LOGICAL_DRIVES)
+#define MAX_RAIDMAP_VIEWS (MAX_LOGICAL_DRIVES)
+#define MAX_ARRAYS 128
+#define MAX_RAIDMAP_ARRAYS (MAX_ARRAYS)
+#define MAX_PHYSICAL_DEVICES 256
+#define MAX_RAIDMAP_PHYSICAL_DEVICES (MAX_PHYSICAL_DEVICES)
+#define MR_DCMD_LD_MAP_GET_INFO             0x0300e101
+
+struct MR_DEV_HANDLE_INFO {
+	u16     curDevHdl;
+	u8      validHandles;
+	u8      reserved;
+	u16     devHandle[2];
+};
+
+struct MR_ARRAY_INFO {
+	u16      pd[MAX_RAIDMAP_ROW_SIZE];
+};
+
+struct MR_QUAD_ELEMENT {
+	u64     logStart;
+	u64     logEnd;
+	u64     offsetInSpan;
+	u32     diff;
+	u32     reserved1;
+};
+
+struct MR_SPAN_INFO {
+	u32             noElements;
+	u32             reserved1;
+	struct MR_QUAD_ELEMENT quad[MAX_RAIDMAP_SPAN_DEPTH];
+};
+
+struct MR_LD_SPAN {
+	u64      startBlk;
+	u64      numBlks;
+	u16      arrayRef;
+	u8       reserved[6];
+};
+
+struct MR_SPAN_BLOCK_INFO {
+	u64          num_rows;
+	struct MR_LD_SPAN   span;
+	struct MR_SPAN_INFO block_span_info;
+};
+
+struct MR_LD_RAID {
+	struct {
+		u32     fpCapable:1;
+		u32     reserved5:3;
+		u32     ldPiMode:4;
+		u32     pdPiMode:4;
+		u32     encryptionType:8;
+		u32     fpWriteCapable:1;
+		u32     fpReadCapable:1;
+		u32     fpWriteAcrossStripe:1;
+		u32     fpReadAcrossStripe:1;
+		u32     reserved4:8;
+	} capability;
+	u32     reserved6;
+	u64     size;
+	u8      spanDepth;
+	u8      level;
+	u8      stripeShift;
+	u8      rowSize;
+	u8      rowDataSize;
+	u8      writeMode;
+	u8      PRL;
+	u8      SRL;
+	u16     targetId;
+	u8      ldState;
+	u8      regTypeReqOnWrite;
+	u8      modFactor;
+	u8      reserved2[1];
+	u16     seqNum;
+
+	struct {
+		u32 ldSyncRequired:1;
+		u32 reserved:31;
+	} flags;
+
+	u8      reserved3[0x5C];
+};
+
+struct MR_LD_SPAN_MAP {
+	struct MR_LD_RAID          ldRaid;
+	u8                  dataArmMap[MAX_RAIDMAP_ROW_SIZE];
+	struct MR_SPAN_BLOCK_INFO  spanBlock[MAX_RAIDMAP_SPAN_DEPTH];
+};
+
+struct MR_FW_RAID_MAP {
+	u32                 totalSize;
+	union {
+		struct {
+			u32         maxLd;
+			u32         maxSpanDepth;
+			u32         maxRowSize;
+			u32         maxPdCount;
+			u32         maxArrays;
+		} validationInfo;
+		u32             version[5];
+		u32             reserved1[5];
+	};
+
+	u32                 ldCount;
+	u32                 Reserved1;
+	u8                  ldTgtIdToLd[MAX_RAIDMAP_LOGICAL_DRIVES+
+					MAX_RAIDMAP_VIEWS];
+	u8                  fpPdIoTimeoutSec;
+	u8                  reserved2[7];
+	struct MR_ARRAY_INFO       arMapInfo[MAX_RAIDMAP_ARRAYS];
+	struct MR_DEV_HANDLE_INFO  devHndlInfo[MAX_RAIDMAP_PHYSICAL_DEVICES];
+	struct MR_LD_SPAN_MAP      ldSpanMap[1];
+};
+
+struct IO_REQUEST_INFO {
+	u64 ldStartBlock;
+	u32 numBlocks;
+	u16 ldTgtId;
+	u8 isRead;
+	u16 devHandle;
+	u64 pdBlock;
+	u8 fpOkForIo;
+};
+
+struct MR_LD_TARGET_SYNC {
+	u8  targetId;
+	u8  reserved;
+	u16 seqNum;
+};
+
+#define IEEE_SGE_FLAGS_ADDR_MASK            (0x03)
+#define IEEE_SGE_FLAGS_SYSTEM_ADDR          (0x00)
+#define IEEE_SGE_FLAGS_IOCDDR_ADDR          (0x01)
+#define IEEE_SGE_FLAGS_IOCPLB_ADDR          (0x02)
+#define IEEE_SGE_FLAGS_IOCPLBNTA_ADDR       (0x03)
+#define IEEE_SGE_FLAGS_CHAIN_ELEMENT        (0x80)
+#define IEEE_SGE_FLAGS_END_OF_LIST          (0x40)
+
+struct megasas_register_set;
+struct megasas_instance;
+
+union desc_word {
+	u64 word;
+	struct {
+		u32 low;
+		u32 high;
+	} u;
+};
+
+struct megasas_cmd_fusion {
+	struct MPI2_RAID_SCSI_IO_REQUEST	*io_request;
+	dma_addr_t			io_request_phys_addr;
+
+	union MPI2_SGE_IO_UNION	*sg_frame;
+	dma_addr_t		sg_frame_phys_addr;
+
+	u8 *sense;
+	dma_addr_t sense_phys_addr;
+
+	struct list_head list;
+	struct scsi_cmnd *scmd;
+	struct megasas_instance *instance;
+
+	u8 retry_for_fw_reset;
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION  *request_desc;
+
+	/*
+	 * Context for a MFI frame.
+	 * Used to get the mfi cmd from list when a MFI cmd is completed
+	 */
+	u32 sync_cmd_idx;
+	u32 index;
+	u8 flags;
+};
+
+struct LD_LOAD_BALANCE_INFO {
+	u8	loadBalanceFlag;
+	u8	reserved1;
+	u16     raid1DevHandle[2];
+	atomic_t     scsi_pending_cmds[2];
+	u64     last_accessed_block[2];
+};
+
+struct MR_FW_RAID_MAP_ALL {
+	struct MR_FW_RAID_MAP raidMap;
+	struct MR_LD_SPAN_MAP ldSpanMap[MAX_LOGICAL_DRIVES - 1];
+} __attribute__ ((packed));
+
+struct fusion_context {
+	struct megasas_cmd_fusion **cmd_list;
+	struct list_head cmd_pool;
+
+	spinlock_t cmd_pool_lock;
+
+	dma_addr_t req_frames_desc_phys;
+	u8 *req_frames_desc;
+
+	struct dma_pool *io_request_frames_pool;
+	dma_addr_t io_request_frames_phys;
+	u8 *io_request_frames;
+
+	struct dma_pool *sg_dma_pool;
+	struct dma_pool *sense_dma_pool;
+
+	dma_addr_t reply_frames_desc_phys;
+	union MPI2_REPLY_DESCRIPTORS_UNION *reply_frames_desc;
+	struct dma_pool *reply_frames_desc_pool;
+
+	u16 last_reply_idx;
+
+	u32 reply_q_depth;
+	u32 request_alloc_sz;
+	u32 reply_alloc_sz;
+	u32 io_frames_alloc_sz;
+
+	u16	max_sge_in_main_msg;
+	u16	max_sge_in_chain;
+
+	u8	chain_offset_io_request;
+	u8	chain_offset_mfi_pthru;
+
+	struct MR_FW_RAID_MAP_ALL *ld_map[2];
+	dma_addr_t ld_map_phys[2];
+
+	u32 map_sz;
+	u8 fast_path_io;
+	struct LD_LOAD_BALANCE_INFO load_balance_info[MAX_LOGICAL_DRIVES];
+};
+
+union desc_value {
+	u64 word;
+	struct {
+		u32 low;
+		u32 high;
+	} u;
+};
+
+#endif /* _MEGARAID_SAS_FUSION_H_ */
diff -Naur linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas.h
linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.37-rc5.old/drivers/scsi/megaraid/megaraid_sas.h	2010-12-21
10:06:27.000000000 -0800
+++ linux-2.6.37-rc5.new/drivers/scsi/megaraid/megaraid_sas.h	2010-12-21
11:04:09.000000000 -0800
@@ -33,9 +33,9 @@
 /*
  * MegaRAID SAS Driver meta data
  */
-#define MEGASAS_VERSION			"00.00.04.31-rc1"
-#define MEGASAS_RELDATE			"May 3, 2010"
-#define MEGASAS_EXT_VERSION		"Mon. May 3, 11:41:51 PST 2010"
+#define MEGASAS_VERSION				"00.00.05.29-rc1"
+#define MEGASAS_RELDATE				"Dec. 7, 2010"
+#define MEGASAS_EXT_VERSION			"Tue. Dec. 7 17:00:00 PDT 2010"

 /*
  * Device IDs
@@ -47,6 +47,7 @@
 #define	PCI_DEVICE_ID_LSI_SAS0079GEN2		0x0079
 #define	PCI_DEVICE_ID_LSI_SAS0073SKINNY		0x0073
 #define	PCI_DEVICE_ID_LSI_SAS0071SKINNY		0x0071
+#define	PCI_DEVICE_ID_LSI_FUSION		0x005b

 /*
  * =====================================
@@ -436,7 +437,6 @@
 	* Add properties that can be controlled by
 	* a bit in the following structure.
 	*/
-
 	struct {
 		u32     copyBackDisabled            : 1;
 		u32     SMARTerEnabled              : 1;
@@ -716,6 +716,7 @@
 #define MEGASAS_DEFAULT_INIT_ID			-1
 #define MEGASAS_MAX_LUN				8
 #define MEGASAS_MAX_LD				64
+#define MEGASAS_DEFAULT_CMD_PER_LUN		128
 #define MEGASAS_MAX_PD                          (MEGASAS_MAX_PD_CHANNELS * \
 						MEGASAS_MAX_DEV_PER_CHANNEL)
 #define MEGASAS_MAX_LD_IDS			(MEGASAS_MAX_LD_CHANNELS * \
@@ -784,7 +785,10 @@
 */

 struct megasas_register_set {
-	u32 	reserved_0[4];			/*0000h*/
+	u32	doorbell;                       /*0000h*/
+	u32	fusion_seq_offset;		/*0004h*/
+	u32	fusion_host_diag;		/*0008h*/
+	u32	reserved_01;			/*000Ch*/

 	u32 	inbound_msg_0;			/*0010h*/
 	u32 	inbound_msg_1;			/*0014h*/
@@ -804,15 +808,18 @@
 	u32 	inbound_queue_port;		/*0040h*/
 	u32 	outbound_queue_port;		/*0044h*/

-	u32 	reserved_2[22];			/*0048h*/
+	u32	reserved_2[9];			/*0048h*/
+	u32	reply_post_host_index;		/*006Ch*/
+	u32	reserved_2_2[12];		/*0070h*/

 	u32 	outbound_doorbell_clear;	/*00A0h*/

 	u32 	reserved_3[3];			/*00A4h*/

 	u32 	outbound_scratch_pad ;		/*00B0h*/
+	u32	outbound_scratch_pad_2;         /*00B4h*/

-	u32 	reserved_4[3];			/*00B4h*/
+	u32	reserved_4[2];			/*00B8h*/

 	u32 	inbound_low_queue_port ;	/*00C0h*/

@@ -1287,6 +1294,9 @@

 	u16 max_num_sge;
 	u16 max_fw_cmds;
+	/* For Fusion its num IOCTL cmds, for others MFI based its
+	   max_fw_cmds */
+	u16 max_mfi_cmds;
 	u32 max_sectors_per_req;
 	struct megasas_aen_event *ev;

@@ -1336,9 +1346,17 @@
 	struct timer_list io_completion_timer;
 	struct list_head internal_reset_pending_q;

+	/* Ptr to hba specfic information */
+	void *ctrl_context;
 	u8	msi_flag;
 	struct msix_entry msixentry;
+	u64 map_id;
+	struct megasas_cmd *map_update_cmd;
 	unsigned long bar;
+	long reset_flags;
+	struct mutex reset_mutex;
+	struct scsi_cmnd scmd;
+	struct scsi_device dev;
 };

 enum {
@@ -1397,7 +1415,13 @@
 	struct list_head list;
 	struct scsi_cmnd *scmd;
 	struct megasas_instance *instance;
-	u32 frame_count;
+	union {
+		struct {
+			u16 smid;
+			u16 resvd;
+		} context;
+		u32 frame_count;
+	};
 };

 #define MAX_MGMT_ADAPTERS		1024

--00163630ffe327cf3d0497f08362
Content-Type: application/octet-stream; name="megaraid_sas.patch6thru10"
Content-Disposition: attachment; filename="megaraid_sas.patch6thru10"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghz6blb40

ZGlmZiAtTmF1ciBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvTWFr
ZWZpbGUgbGludXgtMi42LjM3LXJjNS5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL01ha2VmaWxl
Ci0tLSBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvTWFrZWZpbGUJ
MjAxMC0xMi0yMSAwOTo0NTo0MS4wMDAwMDAwMDAgLTA4MDAKKysrIGxpbnV4LTIuNi4zNy1yYzUu
bmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9NYWtlZmlsZQkyMDEwLTEyLTIxIDExOjA0OjA4LjAw
MDAwMDAwMCAtMDgwMApAQCAtMSw0ICsxLDUgQEAKIG9iai0kKENPTkZJR19NRUdBUkFJRF9NTSkJ
Kz0gbWVnYXJhaWRfbW0ubwogb2JqLSQoQ09ORklHX01FR0FSQUlEX01BSUxCT1gpCSs9IG1lZ2Fy
YWlkX21ib3gubwogb2JqLSQoQ09ORklHX01FR0FSQUlEX1NBUykJKz0gbWVnYXJhaWRfc2FzLm8K
LW1lZ2FyYWlkX3Nhcy1vYmpzIDo9IG1lZ2FyYWlkX3Nhc19iYXNlLm8KK21lZ2FyYWlkX3Nhcy1v
YmpzIDo9IG1lZ2FyYWlkX3Nhc19iYXNlLm8gbWVnYXJhaWRfc2FzX2Z1c2lvbi5vIFwKKwltZWdh
cmFpZF9zYXNfZnAubwpkaWZmIC1OYXVyIGxpbnV4LTIuNi4zNy1yYzUub2xkL2RyaXZlcnMvc2Nz
aS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jIGxpbnV4LTIuNi4zNy1yYzUubmV3L2RyaXZl
cnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfYmFzZS5jCi0tLSBsaW51eC0yLjYuMzctcmM1
Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2UuYwkyMDEwLTEyLTIx
IDEwOjA2OjI3LjAwMDAwMDAwMCAtMDgwMAorKysgbGludXgtMi42LjM3LXJjNS5uZXcvZHJpdmVy
cy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19iYXNlLmMJMjAxMC0xMi0yMSAxMTowNDowNC4w
MDAwMDAwMDAgLTA4MDAKQEAgLTUzLDYgKzUzLDcgQEAKICNpbmNsdWRlIDxzY3NpL3Njc2lfY21u
ZC5oPgogI2luY2x1ZGUgPHNjc2kvc2NzaV9kZXZpY2UuaD4KICNpbmNsdWRlIDxzY3NpL3Njc2lf
aG9zdC5oPgorI2luY2x1ZGUgIm1lZ2FyYWlkX3Nhc19mdXNpb24uaCIKICNpbmNsdWRlICJtZWdh
cmFpZF9zYXMuaCIKIAogLyoKQEAgLTgxLDcgKzgyLDcgQEAKIE1PRFVMRV9BVVRIT1IoIm1lZ2Fy
YWlkbGludXhAbHNpLmNvbSIpOwogTU9EVUxFX0RFU0NSSVBUSU9OKCJMU0kgTWVnYVJBSUQgU0FT
IERyaXZlciIpOwogCi1zdGF0aWMgaW50IG1lZ2FzYXNfdHJhbnNpdGlvbl90b19yZWFkeShzdHJ1
Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpOworaW50IG1lZ2FzYXNfdHJhbnNpdGlvbl90
b19yZWFkeShzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpOwogc3RhdGljIGludCBt
ZWdhc2FzX2dldF9wZF9saXN0KHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSk7CiBz
dGF0aWMgaW50IG1lZ2FzYXNfaXNzdWVfaW5pdF9tZmkoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2Ug
Kmluc3RhbmNlKTsKIHN0YXRpYyBpbnQgbWVnYXNhc19yZWdpc3Rlcl9hZW4oc3RydWN0IG1lZ2Fz
YXNfaW5zdGFuY2UgKmluc3RhbmNlLApAQCAtMTA5LDYgKzExMCw4IEBACiAJLyogeHNjYWxlIElP
UCwgdmVnYSAqLwogCXtQQ0lfREVWSUNFKFBDSV9WRU5ET1JfSURfREVMTCwgUENJX0RFVklDRV9J
RF9ERUxMX1BFUkM1KX0sCiAJLyogeHNjYWxlIElPUCAqLworCXtQQ0lfREVWSUNFKFBDSV9WRU5E
T1JfSURfTFNJX0xPR0lDLCBQQ0lfREVWSUNFX0lEX0xTSV9GVVNJT04pfSwKKwkvKiBGdXNpb24g
Ki8KIAl7fQogfTsKIApAQCAtMTIyLDE1ICsxMjUsMTYgQEAKIHN0YXRpYyBpbnQgbWVnYXNhc19w
b2xsX3dhaXRfYWVuOwogc3RhdGljIERFQ0xBUkVfV0FJVF9RVUVVRV9IRUFEKG1lZ2FzYXNfcG9s
bF93YWl0KTsKIHN0YXRpYyB1MzIgc3VwcG9ydF9wb2xsX2Zvcl9ldmVudDsKLXN0YXRpYyB1MzIg
bWVnYXNhc19kYmdfbHZsOwordTMyIG1lZ2FzYXNfZGJnX2x2bDsKIHN0YXRpYyB1MzIgc3VwcG9y
dF9kZXZpY2VfY2hhbmdlOwogCiAvKiBkZWZpbmUgbG9jayBmb3IgYWVuIHBvbGwgKi8KIHNwaW5s
b2NrX3QgcG9sbF9hZW5fbG9jazsKIAotc3RhdGljIHZvaWQKK3ZvaWQKIG1lZ2FzYXNfY29tcGxl
dGVfY21kKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwgc3RydWN0IG1lZ2FzYXNf
Y21kICpjbWQsCiAJCSAgICAgdTggYWx0X3N0YXR1cyk7CisKIHN0YXRpYyBpcnFyZXR1cm5fdCBt
ZWdhc2FzX2lzcihpbnQgaXJxLCB2b2lkICpkZXZwKTsKIHN0YXRpYyB1MzIKIG1lZ2FzYXNfaW5p
dF9hZGFwdGVyX21maShzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpOwpAQCAtMTM4
LDYgKzE0MiwyMyBAQAogbWVnYXNhc19idWlsZF9hbmRfaXNzdWVfY21kKHN0cnVjdCBtZWdhc2Fz
X2luc3RhbmNlICppbnN0YW5jZSwKIAkJCSAgICBzdHJ1Y3Qgc2NzaV9jbW5kICpzY21kKTsKIHN0
YXRpYyB2b2lkIG1lZ2FzYXNfY29tcGxldGVfY21kX2RwYyh1bnNpZ25lZCBsb25nIGluc3RhbmNl
X2FkZHIpOwordm9pZAorbWVnYXNhc19yZWxlYXNlX2Z1c2lvbihzdHJ1Y3QgbWVnYXNhc19pbnN0
YW5jZSAqaW5zdGFuY2UpOworaW50CittZWdhc2FzX2lvY19pbml0X2Z1c2lvbihzdHJ1Y3QgbWVn
YXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpOwordm9pZAorbWVnYXNhc19mcmVlX2NtZHNfZnVzaW9u
KHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSk7Cit1OAorbWVnYXNhc19nZXRfbWFw
X2luZm8oc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKTsKK2ludAorbWVnYXNhc19z
eW5jX21hcF9pbmZvKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSk7CitpbnQKK3dh
aXRfYW5kX3BvbGwoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLCBzdHJ1Y3QgbWVn
YXNhc19jbWQgKmNtZCk7Cit2b2lkIG1lZ2FzYXNfcmVzZXRfcmVwbHlfZGVzYyhzdHJ1Y3QgbWVn
YXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpOwordTggTVJfVmFsaWRhdGVNYXBJbmZvKHN0cnVjdCBN
Ul9GV19SQUlEX01BUF9BTEwgKm1hcCwKKwkJICAgICAgc3RydWN0IExEX0xPQURfQkFMQU5DRV9J
TkZPICpsYkluZm8pOworaW50IG1lZ2FzYXNfcmVzZXRfZnVzaW9uKHN0cnVjdCBzY3NpX2NtbmQg
KnNjbWQpOwordm9pZCBtZWdhc2FzX2Z1c2lvbl9vY3Jfd3Eoc3RydWN0IHdvcmtfc3RydWN0ICp3
b3JrKTsKIAogdm9pZAogbWVnYXNhc19pc3N1ZV9kY21kKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNl
ICppbnN0YW5jZSwgc3RydWN0IG1lZ2FzYXNfY21kICpjbWQpCkBAIC0xNTIsNyArMTczLDcgQEAK
ICAqCiAgKiBSZXR1cm5zIGEgZnJlZSBjb21tYW5kIGZyb20gdGhlIHBvb2wKICAqLwotc3RhdGlj
IHN0cnVjdCBtZWdhc2FzX2NtZCAqbWVnYXNhc19nZXRfY21kKHN0cnVjdCBtZWdhc2FzX2luc3Rh
bmNlCitzdHJ1Y3QgbWVnYXNhc19jbWQgKm1lZ2FzYXNfZ2V0X2NtZChzdHJ1Y3QgbWVnYXNhc19p
bnN0YW5jZQogCQkJCQkJICAqaW5zdGFuY2UpCiB7CiAJdW5zaWduZWQgbG9uZyBmbGFnczsKQEAg
LTE3Nyw3ICsxOTgsNyBAQAogICogQGluc3RhbmNlOgkJQWRhcHRlciBzb2Z0IHN0YXRlCiAgKiBA
Y21kOgkJQ29tbWFuZCBwYWNrZXQgdG8gYmUgcmV0dXJuZWQgdG8gZnJlZSBjb21tYW5kIHBvb2wK
ICAqLwotc3RhdGljIGlubGluZSB2b2lkCitpbmxpbmUgdm9pZAogbWVnYXNhc19yZXR1cm5fY21k
KHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwgc3RydWN0IG1lZ2FzYXNfY21kICpj
bWQpCiB7CiAJdW5zaWduZWQgbG9uZyBmbGFnczsKQEAgLTE4NSw2ICsyMDYsNyBAQAogCXNwaW5f
bG9ja19pcnFzYXZlKCZpbnN0YW5jZS0+Y21kX3Bvb2xfbG9jaywgZmxhZ3MpOwogCiAJY21kLT5z
Y21kID0gTlVMTDsKKwljbWQtPmZyYW1lX2NvdW50ID0gMDsKIAlsaXN0X2FkZF90YWlsKCZjbWQt
Pmxpc3QsICZpbnN0YW5jZS0+Y21kX3Bvb2wpOwogCiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgm
aW5zdGFuY2UtPmNtZF9wb29sX2xvY2ssIGZsYWdzKTsKQEAgLTc5Niw2ICs4MTgsMTEgQEAKICog
ICAgICAgc3BlY2lmaWMgdG8gZ2VuMiAoZGV2aWNlaWQgOiAweDc4LCAweDc5KSBjb250cm9sbGVy
cwogKi8KIAorLyoKKyAqIFRlbXBsYXRlIGFkZGVkIGZvciBUQiAoRnVzaW9uKQorICovCitleHRl
cm4gc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2VfdGVtcGxhdGUgbWVnYXNhc19pbnN0YW5jZV90ZW1w
bGF0ZV9mdXNpb247CisKIC8qKgogICogbWVnYXNhc19pc3N1ZV9wb2xsZWQgLQlJc3N1ZXMgYSBw
b2xsaW5nIGNvbW1hbmQKICAqIEBpbnN0YW5jZToJCQlBZGFwdGVyIHNvZnQgc3RhdGUKQEAgLTgw
MywxMSArODMwLDkgQEAKICAqCiAgKiBGb3IgcG9sbGluZywgTUZJIHJlcXVpcmVzIHRoZSBjbWRf
c3RhdHVzIHRvIGJlIHNldCB0byAweEZGIGJlZm9yZSBwb3N0aW5nLgogICovCi1zdGF0aWMgaW50
CitpbnQKIG1lZ2FzYXNfaXNzdWVfcG9sbGVkKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0
YW5jZSwgc3RydWN0IG1lZ2FzYXNfY21kICpjbWQpCiB7Ci0JaW50IGk7Ci0JdTMyIG1zZWNzID0g
TUZJX1BPTExfVElNRU9VVF9TRUNTICogMTAwMDsKIAogCXN0cnVjdCBtZWdhc2FzX2hlYWRlciAq
ZnJhbWVfaGRyID0gJmNtZC0+ZnJhbWUtPmhkcjsKIApAQCAtODE3LDIxICs4NDIsMTIgQEAKIAkv
KgogCSAqIElzc3VlIHRoZSBmcmFtZSB1c2luZyBpbmJvdW5kIHF1ZXVlIHBvcnQKIAkgKi8KLQlp
bnN0YW5jZS0+aW5zdGFuY2V0LT5maXJlX2NtZChpbnN0YW5jZSwKLQkJCWNtZC0+ZnJhbWVfcGh5
c19hZGRyLCAwLCBpbnN0YW5jZS0+cmVnX3NldCk7CisJaW5zdGFuY2UtPmluc3RhbmNldC0+aXNz
dWVfZGNtZChpbnN0YW5jZSwgY21kKTsKIAogCS8qCiAJICogV2FpdCBmb3IgY21kX3N0YXR1cyB0
byBjaGFuZ2UKIAkgKi8KLQlmb3IgKGkgPSAwOyAoaSA8IG1zZWNzKSAmJiAoZnJhbWVfaGRyLT5j
bWRfc3RhdHVzID09IDB4ZmYpOyBpKyspIHsKLQkJcm1iKCk7Ci0JCW1zbGVlcCgxKTsKLQl9Ci0K
LQlpZiAoZnJhbWVfaGRyLT5jbWRfc3RhdHVzID09IDB4ZmYpCi0JCXJldHVybiAtRVRJTUU7Ci0K
LQlyZXR1cm4gMDsKKwlyZXR1cm4gd2FpdF9hbmRfcG9sbChpbnN0YW5jZSwgY21kKTsKIH0KIAog
LyoqCkBAIC04NDksOCArODY1LDcgQEAKIHsKIAljbWQtPmNtZF9zdGF0dXMgPSBFTk9EQVRBOwog
Ci0JaW5zdGFuY2UtPmluc3RhbmNldC0+ZmlyZV9jbWQoaW5zdGFuY2UsCi0JCQljbWQtPmZyYW1l
X3BoeXNfYWRkciwgMCwgaW5zdGFuY2UtPnJlZ19zZXQpOworCWluc3RhbmNlLT5pbnN0YW5jZXQt
Pmlzc3VlX2RjbWQoaW5zdGFuY2UsIGNtZCk7CiAKIAl3YWl0X2V2ZW50KGluc3RhbmNlLT5pbnRf
Y21kX3dhaXRfcSwgY21kLT5jbWRfc3RhdHVzICE9IEVOT0RBVEEpOwogCkBAIC04OTQsOCArOTA5
LDcgQEAKIAljbWQtPnN5bmNfY21kID0gMTsKIAljbWQtPmNtZF9zdGF0dXMgPSAweEZGOwogCi0J
aW5zdGFuY2UtPmluc3RhbmNldC0+ZmlyZV9jbWQoaW5zdGFuY2UsCi0JCQljbWQtPmZyYW1lX3Bo
eXNfYWRkciwgMCwgaW5zdGFuY2UtPnJlZ19zZXQpOworCWluc3RhbmNlLT5pbnN0YW5jZXQtPmlz
c3VlX2RjbWQoaW5zdGFuY2UsIGNtZCk7CiAKIAkvKgogCSAqIFdhaXQgZm9yIHRoaXMgY21kIHRv
IGNvbXBsZXRlCkBAIC0xMjkxLDcgKzEzMDUsNyBAQAogICogQ2FsbGVkIGJ5IG1lZ2FzYXNfcXVl
dWVfY29tbWFuZCB0byBmaW5kIG91dCBpZiB0aGUgY29tbWFuZCB0byBiZSBxdWV1ZWQKICAqIGlz
IGEgbG9naWNhbCBkcml2ZSBjb21tYW5kCQogICovCi1zdGF0aWMgaW5saW5lIGludCBtZWdhc2Fz
X2lzX2xkaW8oc3RydWN0IHNjc2lfY21uZCAqY21kKQoraW5saW5lIGludCBtZWdhc2FzX2lzX2xk
aW8oc3RydWN0IHNjc2lfY21uZCAqY21kKQogewogCWlmICghTUVHQVNBU19JU19MT0dJQ0FMKGNt
ZCkpCiAJCXJldHVybiAwOwpAQCAtMTU1MSwxNSArMTU2NSw0NCBAQAogCXJldHVybiAwOwogfQog
Ci1zdGF0aWMgdm9pZCBtZWdhcmFpZF9zYXNfa2lsbF9oYmEoc3RydWN0IG1lZ2FzYXNfaW5zdGFu
Y2UgKmluc3RhbmNlKQordm9pZCBtZWdhcmFpZF9zYXNfa2lsbF9oYmEoc3RydWN0IG1lZ2FzYXNf
aW5zdGFuY2UgKmluc3RhbmNlKQogewogCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQ
Q0lfREVWSUNFX0lEX0xTSV9TQVMwMDczU0tJTk5ZKSB8fAotCQkoaW5zdGFuY2UtPnBkZXYtPmRl
dmljZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDcxU0tJTk5ZKSkgewotCQl3cml0ZWwoTUZJ
X1NUT1BfQURQLAotCQkJJmluc3RhbmNlLT5yZWdfc2V0LT5yZXNlcnZlZF8wWzBdKTsKKwkgICAg
KGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3MVNLSU5O
WSkgfHwKKwkgICAgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lf
RlVTSU9OKSkgeworCQl3cml0ZWwoTUZJX1NUT1BfQURQLCAmaW5zdGFuY2UtPnJlZ19zZXQtPmRv
b3JiZWxsKTsKIAl9IGVsc2UgewotCQl3cml0ZWwoTUZJX1NUT1BfQURQLAotCQkJJmluc3RhbmNl
LT5yZWdfc2V0LT5pbmJvdW5kX2Rvb3JiZWxsKTsKKwkJd3JpdGVsKE1GSV9TVE9QX0FEUCwgJmlu
c3RhbmNlLT5yZWdfc2V0LT5pbmJvdW5kX2Rvb3JiZWxsKTsKKwl9Cit9CisKKyAvKioKKyAgKiBt
ZWdhc2FzX2NoZWNrX2FuZF9yZXN0b3JlX3F1ZXVlX2RlcHRoIC0gQ2hlY2sgaWYgcXVldWUgZGVw
dGggbmVlZHMgdG8gYmUKKyAgKgkJCQkJcmVzdG9yZWQgdG8gbWF4IHZhbHVlCisgICogQGluc3Rh
bmNlOgkJCUFkYXB0ZXIgc29mdCBzdGF0ZQorICAqCisgICovCit2b2lkCittZWdhc2FzX2NoZWNr
X2FuZF9yZXN0b3JlX3F1ZXVlX2RlcHRoKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5j
ZSkKK3sKKwl1bnNpZ25lZCBsb25nIGZsYWdzOworCWlmIChpbnN0YW5jZS0+ZmxhZyAmIE1FR0FT
QVNfRldfQlVTWQorCQkmJiB0aW1lX2FmdGVyKGppZmZpZXMsIGluc3RhbmNlLT5sYXN0X3RpbWUg
KyA1ICogSFopCisJCSYmIGF0b21pY19yZWFkKCZpbnN0YW5jZS0+Zndfb3V0c3RhbmRpbmcpIDwg
MTcpIHsKKworCQlzcGluX2xvY2tfaXJxc2F2ZShpbnN0YW5jZS0+aG9zdC0+aG9zdF9sb2NrLCBm
bGFncyk7CisJCWluc3RhbmNlLT5mbGFnICY9IH5NRUdBU0FTX0ZXX0JVU1k7CisJCWlmICgoaW5z
dGFuY2UtPnBkZXYtPmRldmljZSA9PQorCQkJUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3M1NLSU5O
WSkgfHwKKwkJCShpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09CisJCQlQQ0lfREVWSUNFX0lEX0xT
SV9TQVMwMDcxU0tJTk5ZKSkgeworCQkJaW5zdGFuY2UtPmhvc3QtPmNhbl9xdWV1ZSA9CisJCQkJ
aW5zdGFuY2UtPm1heF9md19jbWRzIC0gTUVHQVNBU19TS0lOTllfSU5UX0NNRFM7CisJCX0gZWxz
ZQorCQkJaW5zdGFuY2UtPmhvc3QtPmNhbl9xdWV1ZSA9CisJCQkJaW5zdGFuY2UtPm1heF9md19j
bWRzIC0gTUVHQVNBU19JTlRfQ01EUzsKKworCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKGluc3Rh
bmNlLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsKIAl9CiB9CiAKQEAgLTE2MTMsMjQgKzE2NTYs
NyBAQAogCS8qCiAJICogQ2hlY2sgaWYgd2UgY2FuIHJlc3RvcmUgY2FuX3F1ZXVlCiAJICovCi0J
aWYgKGluc3RhbmNlLT5mbGFnICYgTUVHQVNBU19GV19CVVNZCi0JCSYmIHRpbWVfYWZ0ZXIoamlm
ZmllcywgaW5zdGFuY2UtPmxhc3RfdGltZSArIDUgKiBIWikKLQkJJiYgYXRvbWljX3JlYWQoJmlu
c3RhbmNlLT5md19vdXRzdGFuZGluZykgPCAxNykgewotCi0JCXNwaW5fbG9ja19pcnFzYXZlKGlu
c3RhbmNlLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsKLQkJaW5zdGFuY2UtPmZsYWcgJj0gfk1F
R0FTQVNfRldfQlVTWTsKLQkJaWYgKChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09Ci0JCQlQQ0lf
REVWSUNFX0lEX0xTSV9TQVMwMDczU0tJTk5ZKSB8fAotCQkJKGluc3RhbmNlLT5wZGV2LT5kZXZp
Y2UgPT0KLQkJCVBDSV9ERVZJQ0VfSURfTFNJX1NBUzAwNzFTS0lOTlkpKSB7Ci0JCQlpbnN0YW5j
ZS0+aG9zdC0+Y2FuX3F1ZXVlID0KLQkJCQlpbnN0YW5jZS0+bWF4X2Z3X2NtZHMgLSBNRUdBU0FT
X1NLSU5OWV9JTlRfQ01EUzsKLQkJfSBlbHNlCi0JCQlpbnN0YW5jZS0+aG9zdC0+Y2FuX3F1ZXVl
ID0KLQkJCQlpbnN0YW5jZS0+bWF4X2Z3X2NtZHMgLSBNRUdBU0FTX0lOVF9DTURTOwotCi0JCXNw
aW5fdW5sb2NrX2lycXJlc3RvcmUoaW5zdGFuY2UtPmhvc3QtPmhvc3RfbG9jaywgZmxhZ3MpOwot
CX0KKwltZWdhc2FzX2NoZWNrX2FuZF9yZXN0b3JlX3F1ZXVlX2RlcHRoKGluc3RhbmNlKTsKIH0K
IAogc3RhdGljIHZvaWQKQEAgLTE4MDgsNyArMTgzNCw3IEBACiAJCQkoaW5zdGFuY2UtPnBkZXYt
PmRldmljZSA9PQogCQkJUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3MVNLSU5OWSkpIHsKIAkJCXdy
aXRlbChNRklfU1RPUF9BRFAsCi0JCQkJJmluc3RhbmNlLT5yZWdfc2V0LT5yZXNlcnZlZF8wWzBd
KTsKKwkJCQkmaW5zdGFuY2UtPnJlZ19zZXQtPmRvb3JiZWxsKTsKIAkJfSBlbHNlIHsKIAkJCXdy
aXRlbChNRklfU1RPUF9BRFAsCiAJCQkJJmluc3RhbmNlLT5yZWdfc2V0LT5pbmJvdW5kX2Rvb3Ji
ZWxsKTsKQEAgLTE5MTIsMTEgKzE5MzgsMTYgQEAKIHN0YXRpYyBpbnQgbWVnYXNhc19yZXNldF9i
dXNfaG9zdChzdHJ1Y3Qgc2NzaV9jbW5kICpzY21kKQogewogCWludCByZXQ7CisJc3RydWN0IG1l
Z2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlOworCWluc3RhbmNlID0gKHN0cnVjdCBtZWdhc2FzX2lu
c3RhbmNlICopc2NtZC0+ZGV2aWNlLT5ob3N0LT5ob3N0ZGF0YTsKIAogCS8qCiAJICogRmlyc3Qg
d2FpdCBmb3IgYWxsIGNvbW1hbmRzIHRvIGNvbXBsZXRlCiAJICovCi0JcmV0ID0gbWVnYXNhc19n
ZW5lcmljX3Jlc2V0KHNjbWQpOworCWlmIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBDSV9E
RVZJQ0VfSURfTFNJX0ZVU0lPTikKKwkJcmV0ID0gbWVnYXNhc19yZXNldF9mdXNpb24oc2NtZCk7
CisJZWxzZQorCQlyZXQgPSBtZWdhc2FzX2dlbmVyaWNfcmVzZXQoc2NtZCk7CiAKIAlyZXR1cm4g
cmV0OwogfQpAQCAtMjA4NiwxMyArMjExNywxNCBAQAogICogCQkJCWFuIGFsdGVybmF0ZSBzdGF0
dXMgKGFzIGluIHRoZSBjYXNlIG9mIGFib3J0ZWQKICAqIAkJCQljb21tYW5kcykKICAqLwotc3Rh
dGljIHZvaWQKK3ZvaWQKIG1lZ2FzYXNfY29tcGxldGVfY21kKHN0cnVjdCBtZWdhc2FzX2luc3Rh
bmNlICppbnN0YW5jZSwgc3RydWN0IG1lZ2FzYXNfY21kICpjbWQsCiAJCSAgICAgdTggYWx0X3N0
YXR1cykKIHsKIAlpbnQgZXhjZXB0aW9uID0gMDsKIAlzdHJ1Y3QgbWVnYXNhc19oZWFkZXIgKmhk
ciA9ICZjbWQtPmZyYW1lLT5oZHI7CiAJdW5zaWduZWQgbG9uZyBmbGFnczsKKwlzdHJ1Y3QgZnVz
aW9uX2NvbnRleHQgKmZ1c2lvbiA9IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CiAKIAkvKiBmbGFn
IGZvciB0aGUgcmV0cnkgcmVzZXQgKi8KIAljbWQtPnJldHJ5X2Zvcl9md19yZXNldCA9IDA7CkBA
IC0yMTg1LDYgKzIyMTcsMzcgQEAKIAljYXNlIE1GSV9DTURfU01QOgogCWNhc2UgTUZJX0NNRF9T
VFA6CiAJY2FzZSBNRklfQ01EX0RDTUQ6CisJCS8qIENoZWNrIGZvciBMRCBtYXAgdXBkYXRlICov
CisJCWlmICgoY21kLT5mcmFtZS0+ZGNtZC5vcGNvZGUgPT0gTVJfRENNRF9MRF9NQVBfR0VUX0lO
Rk8pICYmCisJCSAgICAoY21kLT5mcmFtZS0+ZGNtZC5tYm94LmJbMV0gPT0gMSkpIHsKKwkJCXNw
aW5fbG9ja19pcnFzYXZlKGluc3RhbmNlLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsKKwkJCWlm
IChjbWQtPmZyYW1lLT5oZHIuY21kX3N0YXR1cyAhPSAwKSB7CisJCQkJaWYgKGNtZC0+ZnJhbWUt
Pmhkci5jbWRfc3RhdHVzICE9CisJCQkJICAgIE1GSV9TVEFUX05PVF9GT1VORCkKKwkJCQkJcHJp
bnRrKEtFUk5fV0FSTklORyAibWVnYXNhczogbWFwIHN5bmMiCisJCQkJCSAgICAgICAiZmFpbGVk
LCBzdGF0dXMgPSAweCV4LlxuIiwKKwkJCQkJICAgICAgIGNtZC0+ZnJhbWUtPmhkci5jbWRfc3Rh
dHVzKTsKKwkJCQllbHNlIHsKKwkJCQkJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNlLCBjbWQp
OworCQkJCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKAorCQkJCQkJaW5zdGFuY2UtPmhvc3QtPmhv
c3RfbG9jaywKKwkJCQkJCWZsYWdzKTsKKwkJCQkJYnJlYWs7CisJCQkJfQorCQkJfSBlbHNlCisJ
CQkJaW5zdGFuY2UtPm1hcF9pZCsrOworCQkJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNlLCBj
bWQpOworCQkJaWYgKE1SX1ZhbGlkYXRlTWFwSW5mbygKKwkJCQkgICAgZnVzaW9uLT5sZF9tYXBb
KGluc3RhbmNlLT5tYXBfaWQgJiAxKV0sCisJCQkJICAgIGZ1c2lvbi0+bG9hZF9iYWxhbmNlX2lu
Zm8pKQorCQkJCWZ1c2lvbi0+ZmFzdF9wYXRoX2lvID0gMTsKKwkJCWVsc2UKKwkJCQlmdXNpb24t
PmZhc3RfcGF0aF9pbyA9IDA7CisJCQltZWdhc2FzX3N5bmNfbWFwX2luZm8oaW5zdGFuY2UpOwor
CQkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShpbnN0YW5jZS0+aG9zdC0+aG9zdF9sb2NrLAorCQkJ
CQkgICAgICAgZmxhZ3MpOworCQkJYnJlYWs7CisJCX0KIAkJaWYgKGNtZC0+ZnJhbWUtPmRjbWQu
b3Bjb2RlID09IE1SX0RDTURfQ1RSTF9FVkVOVF9HRVRfSU5GTyB8fAogCQkJY21kLT5mcmFtZS0+
ZGNtZC5vcGNvZGUgPT0gTVJfRENNRF9DVFJMX0VWRU5UX0dFVCkgewogCQkJc3Bpbl9sb2NrX2ly
cXNhdmUoJnBvbGxfYWVuX2xvY2ssIGZsYWdzKTsKQEAgLTI1MjMsNyArMjU4Niw3IEBACiAgKiBz
dGF0ZXMsIGRyaXZlciBtdXN0IHRha2Ugc3RlcHMgdG8gYnJpbmcgaXQgdG8gcmVhZHkgc3RhdGUu
IE90aGVyd2lzZSwgaXQKICAqIGhhcyB0byB3YWl0IGZvciB0aGUgcmVhZHkgc3RhdGUuCiAgKi8K
LXN0YXRpYyBpbnQKK2ludAogbWVnYXNhc190cmFuc2l0aW9uX3RvX3JlYWR5KHN0cnVjdCBtZWdh
c2FzX2luc3RhbmNlKiBpbnN0YW5jZSkKIHsKIAlpbnQgaTsKQEAgLTI1NTcsMTEgKzI2MjAsMTIg
QEAKIAkJCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PQogCQkJCVBDSV9ERVZJQ0VfSURf
TFNJX1NBUzAwNzNTS0lOTlkpIHx8CiAJCQkJKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0KLQkJ
CQlQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDcxU0tJTk5ZKSkgewotCisJCQkJIFBDSV9ERVZJQ0Vf
SURfTFNJX1NBUzAwNzFTS0lOTlkpIHx8CisJCQkJKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0K
KwkJCQkgUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OKSkgewogCQkJCXdyaXRlbCgKIAkJCQkgIE1G
SV9JTklUX0NMRUFSX0hBTkRTSEFLRXxNRklfSU5JVF9IT1RQTFVHLAotCQkJCSAgJmluc3RhbmNl
LT5yZWdfc2V0LT5yZXNlcnZlZF8wWzBdKTsKKwkJCQkgICZpbnN0YW5jZS0+cmVnX3NldC0+ZG9v
cmJlbGwpOwogCQkJfSBlbHNlIHsKIAkJCQl3cml0ZWwoCiAJCQkJICAgIE1GSV9JTklUX0NMRUFS
X0hBTkRTSEFLRXxNRklfSU5JVF9IT1RQTFVHLApAQCAtMjU3NCwxMSArMjYzOCwxMyBAQAogCiAJ
CWNhc2UgTUZJX1NUQVRFX0JPT1RfTUVTU0FHRV9QRU5ESU5HOgogCQkJaWYgKChpbnN0YW5jZS0+
cGRldi0+ZGV2aWNlID09Ci0JCQkJUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3M1NLSU5OWSkgfHwK
LQkJCShpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09Ci0JCQkJUENJX0RFVklDRV9JRF9MU0lfU0FT
MDA3MVNLSU5OWSkpIHsKKwkJCSAgICAgUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3M1NLSU5OWSkg
fHwKKwkJCQkoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PQorCQkJCSBQQ0lfREVWSUNFX0lEX0xT
SV9TQVMwMDcxU0tJTk5ZKSB8fAorCQkJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09CisJ
CQkgICAgIFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTikpIHsKIAkJCQl3cml0ZWwoTUZJX0lOSVRf
SE9UUExVRywKLQkJCQkmaW5zdGFuY2UtPnJlZ19zZXQtPnJlc2VydmVkXzBbMF0pOworCQkJCSAg
ICAgICAmaW5zdGFuY2UtPnJlZ19zZXQtPmRvb3JiZWxsKTsKIAkJCX0gZWxzZQogCQkJCXdyaXRl
bChNRklfSU5JVF9IT1RQTFVHLAogCQkJCQkmaW5zdGFuY2UtPnJlZ19zZXQtPmluYm91bmRfZG9v
cmJlbGwpOwpAQCAtMjU5NSw5ICsyNjYxLDIzIEBACiAJCQlpZiAoKGluc3RhbmNlLT5wZGV2LT5k
ZXZpY2UgPT0KIAkJCQlQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDczU0tJTk5ZKSB8fAogCQkJCShp
bnN0YW5jZS0+cGRldi0+ZGV2aWNlID09Ci0JCQkJUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3MVNL
SU5OWSkpIHsKKwkJCQlQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDcxU0tJTk5ZKSAgfHwKKwkJCQko
aW5zdGFuY2UtPnBkZXYtPmRldmljZQorCQkJCQk9PSBQQ0lfREVWSUNFX0lEX0xTSV9GVVNJT04p
KSB7CiAJCQkJd3JpdGVsKE1GSV9SRVNFVF9GTEFHUywKLQkJCQkJJmluc3RhbmNlLT5yZWdfc2V0
LT5yZXNlcnZlZF8wWzBdKTsKKwkJCQkJJmluc3RhbmNlLT5yZWdfc2V0LT5kb29yYmVsbCk7CisJ
CQkJaWYgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0KKwkJCQkgICAgUENJX0RFVklDRV9JRF9M
U0lfRlVTSU9OKSB7CisJCQkJCWZvciAoaSA9IDA7IGkgPCAoMTAgKiAxMDAwKTsgaSArPSAyMCkg
eworCQkJCQkJaWYgKHJlYWRsKAorCQkJCQkJCSAgICAmaW5zdGFuY2UtPgorCQkJCQkJCSAgICBy
ZWdfc2V0LT4KKwkJCQkJCQkgICAgZG9vcmJlbGwpICYgMSkKKwkJCQkJCQltc2xlZXAoMjApOwor
CQkJCQkJZWxzZQorCQkJCQkJCWJyZWFrOworCQkJCQl9CisJCQkJfQogCQkJfSBlbHNlCiAJCQkJ
d3JpdGVsKE1GSV9SRVNFVF9GTEFHUywKIAkJCQkJJmluc3RhbmNlLT5yZWdfc2V0LT5pbmJvdW5k
X2Rvb3JiZWxsKTsKQEAgLTI2ODEsNyArMjc2MSw3IEBACiBzdGF0aWMgdm9pZCBtZWdhc2FzX3Rl
YXJkb3duX2ZyYW1lX3Bvb2woc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKQogewog
CWludCBpOwotCXUzMiBtYXhfY21kID0gaW5zdGFuY2UtPm1heF9md19jbWRzOworCXUzMiBtYXhf
Y21kID0gaW5zdGFuY2UtPm1heF9tZmlfY21kczsKIAlzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZDsK
IAogCWlmICghaW5zdGFuY2UtPmZyYW1lX2RtYV9wb29sKQpAQCAtMjczMiw3ICsyODEyLDcgQEAK
IAl1MzIgZnJhbWVfY291bnQ7CiAJc3RydWN0IG1lZ2FzYXNfY21kICpjbWQ7CiAKLQltYXhfY21k
ID0gaW5zdGFuY2UtPm1heF9md19jbWRzOworCW1heF9jbWQgPSBpbnN0YW5jZS0+bWF4X21maV9j
bWRzOwogCiAJLyoKIAkgKiBTaXplIG9mIG91ciBmcmFtZSBpcyA2NCBieXRlcyBmb3IgTUZJIGZy
YW1lLCBmb2xsb3dlZCBieSBtYXggU0cKQEAgLTI4MTksMTQgKzI4OTksMTUgQEAKICAqIG1lZ2Fz
YXNfZnJlZV9jbWRzIC0JRnJlZSBhbGwgdGhlIGNtZHMgaW4gdGhlIGZyZWUgY21kIHBvb2wKICAq
IEBpbnN0YW5jZToJCUFkYXB0ZXIgc29mdCBzdGF0ZQogICovCi1zdGF0aWMgdm9pZCBtZWdhc2Fz
X2ZyZWVfY21kcyhzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCit2b2lkIG1lZ2Fz
YXNfZnJlZV9jbWRzKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKIHsKIAlpbnQg
aTsKIAkvKiBGaXJzdCBmcmVlIHRoZSBNRkkgZnJhbWUgcG9vbCAqLwogCW1lZ2FzYXNfdGVhcmRv
d25fZnJhbWVfcG9vbChpbnN0YW5jZSk7CiAKIAkvKiBGcmVlIGFsbCB0aGUgY29tbWFuZHMgaW4g
dGhlIGNtZF9saXN0ICovCi0JZm9yIChpID0gMDsgaSA8IGluc3RhbmNlLT5tYXhfZndfY21kczsg
aSsrKQorCWZvciAoaSA9IDA7IGkgPCBpbnN0YW5jZS0+bWF4X21maV9jbWRzOyBpKyspCisKIAkJ
a2ZyZWUoaW5zdGFuY2UtPmNtZF9saXN0W2ldKTsKIAogCS8qIEZyZWUgdGhlIGNtZF9saXN0IGJ1
ZmZlciBpdHNlbGYgKi8KQEAgLTI4NTQsMTQgKzI5MzUsMTQgQEAKICAqIFRoaXMgYXJyYXkgaXMg
dXNlZCBvbmx5IHRvIGxvb2sgdXAgdGhlIG1lZ2FzYXNfY21kIGdpdmVuIHRoZSBjb250ZXh0LiBU
aGUKICAqIGZyZWUgY29tbWFuZHMgdGhlbXNlbHZlcyBhcmUgbWFpbnRhaW5lZCBpbiBhIGxpbmtl
ZCBsaXN0IGNhbGxlZCBjbWRfcG9vbC4KICAqLwotc3RhdGljIGludCBtZWdhc2FzX2FsbG9jX2Nt
ZHMoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKQoraW50IG1lZ2FzYXNfYWxsb2Nf
Y21kcyhzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCiB7CiAJaW50IGk7CiAJaW50
IGo7CiAJdTMyIG1heF9jbWQ7CiAJc3RydWN0IG1lZ2FzYXNfY21kICpjbWQ7CiAKLQltYXhfY21k
ID0gaW5zdGFuY2UtPm1heF9md19jbWRzOworCW1heF9jbWQgPSBpbnN0YW5jZS0+bWF4X21maV9j
bWRzOwogCiAJLyoKIAkgKiBpbnN0YW5jZS0+Y21kX2xpc3QgaXMgYW4gYXJyYXkgb2Ygc3RydWN0
IG1lZ2FzYXNfY21kIHBvaW50ZXJzLgpAQCAtMjg3NSw2ICsyOTU2LDcgQEAKIAkJcmV0dXJuIC1F
Tk9NRU07CiAJfQogCisJbWVtc2V0KGluc3RhbmNlLT5jbWRfbGlzdCwgMCwgc2l6ZW9mKHN0cnVj
dCBtZWdhc2FzX2NtZCAqKSAqbWF4X2NtZCk7CiAKIAlmb3IgKGkgPSAwOyBpIDwgbWF4X2NtZDsg
aSsrKSB7CiAJCWluc3RhbmNlLT5jbWRfbGlzdFtpXSA9IGttYWxsb2Moc2l6ZW9mKHN0cnVjdCBt
ZWdhc2FzX2NtZCksCkBAIC0zMjg4LDYgKzMzNzAsNyBAQAogCSAqIGRvZXMgbm90IGV4Y2VlZCBt
YXggY21kcyB0aGF0IHRoZSBGVyBjYW4gc3VwcG9ydAogCSAqLwogCWluc3RhbmNlLT5tYXhfZndf
Y21kcyA9IGluc3RhbmNlLT5tYXhfZndfY21kcy0xOworCWluc3RhbmNlLT5tYXhfbWZpX2NtZHMg
PSBpbnN0YW5jZS0+bWF4X2Z3X2NtZHM7CiAJaW5zdGFuY2UtPm1heF9udW1fc2dlID0gKGluc3Rh
bmNlLT5pbnN0YW5jZXQtPnJlYWRfZndfc3RhdHVzX3JlZyhyZWdfc2V0KSAmIDB4RkYwMDAwKSA+
PiAKIAkJCQkJMHgxMDsKIAkvKgpAQCAtMzM4MSw2ICszNDY0LDkgQEAKIAlyZWdfc2V0ID0gaW5z
dGFuY2UtPnJlZ19zZXQ7CiAKIAlzd2l0Y2ggKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UpIHsKKwlj
YXNlIFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTjoKKwkJaW5zdGFuY2UtPmluc3RhbmNldCA9ICZt
ZWdhc2FzX2luc3RhbmNlX3RlbXBsYXRlX2Z1c2lvbjsKKwkJYnJlYWs7CiAJY2FzZSBQQ0lfREVW
SUNFX0lEX0xTSV9TQVMxMDc4UjoKIAljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX1NBUzEwNzhERToK
IAkJaW5zdGFuY2UtPmluc3RhbmNldCA9ICZtZWdhc2FzX2luc3RhbmNlX3RlbXBsYXRlX3BwYzsK
QEAgLTM0ODIsOSArMzU2OCwxMCBAQAogICovCiBzdGF0aWMgdm9pZCBtZWdhc2FzX3JlbGVhc2Vf
bWZpKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKIHsKLQl1MzIgcmVwbHlfcV9z
eiA9IHNpemVvZih1MzIpICogKGluc3RhbmNlLT5tYXhfZndfY21kcyArIDEpOworCXUzMiByZXBs
eV9xX3N6ID0gc2l6ZW9mKHUzMikgKihpbnN0YW5jZS0+bWF4X21maV9jbWRzICsgMSk7CiAKLQlw
Y2lfZnJlZV9jb25zaXN0ZW50KGluc3RhbmNlLT5wZGV2LCByZXBseV9xX3N6LAorCWlmIChpbnN0
YW5jZS0+cmVwbHlfcXVldWUpCisJCXBjaV9mcmVlX2NvbnNpc3RlbnQoaW5zdGFuY2UtPnBkZXYs
IHJlcGx5X3Ffc3osCiAJCQkgICAgaW5zdGFuY2UtPnJlcGx5X3F1ZXVlLCBpbnN0YW5jZS0+cmVw
bHlfcXVldWVfaCk7CiAKIAltZWdhc2FzX2ZyZWVfY21kcyhpbnN0YW5jZSk7CkBAIC0zNjc4LDgg
KzM3NjUsNyBAQAogCS8qCiAJICogSXNzdWUgdGhlIGFlbiByZWdpc3RyYXRpb24gZnJhbWUKIAkg
Ki8KLQlpbnN0YW5jZS0+aW5zdGFuY2V0LT5maXJlX2NtZChpbnN0YW5jZSwKLQkJCWNtZC0+ZnJh
bWVfcGh5c19hZGRyLCAwLCBpbnN0YW5jZS0+cmVnX3NldCk7CisJaW5zdGFuY2UtPmluc3RhbmNl
dC0+aXNzdWVfZGNtZChpbnN0YW5jZSwgY21kKTsKIAogCXJldHVybiAwOwogfQpAQCAtMzc1Niwx
MiArMzg0MiwxOCBAQAogCX0KIAogCWhvc3QtPm1heF9zZWN0b3JzID0gaW5zdGFuY2UtPm1heF9z
ZWN0b3JzX3Blcl9yZXE7Ci0JaG9zdC0+Y21kX3Blcl9sdW4gPSAxMjg7CisJaG9zdC0+Y21kX3Bl
cl9sdW4gPSBNRUdBU0FTX0RFRkFVTFRfQ01EX1BFUl9MVU47CiAJaG9zdC0+bWF4X2NoYW5uZWwg
PSBNRUdBU0FTX01BWF9DSEFOTkVMUyAtIDE7CiAJaG9zdC0+bWF4X2lkID0gTUVHQVNBU19NQVhf
REVWX1BFUl9DSEFOTkVMOwogCWhvc3QtPm1heF9sdW4gPSBNRUdBU0FTX01BWF9MVU47CiAJaG9z
dC0+bWF4X2NtZF9sZW4gPSAxNjsKIAorCS8qIEZ1c2lvbiBvbmx5IHN1cHBvcnRzIGhvc3QgcmVz
ZXQgKi8KKwlpZiAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9G
VVNJT04pIHsKKwkJaG9zdC0+aG9zdHQtPmVoX2RldmljZV9yZXNldF9oYW5kbGVyID0gTlVMTDsK
KwkJaG9zdC0+aG9zdHQtPmVoX2J1c19yZXNldF9oYW5kbGVyID0gTlVMTDsKKwl9CisKIAkvKgog
CSAqIE5vdGlmeSB0aGUgbWlkLWxheWVyIGFib3V0IHRoZSBuZXcgY29udHJvbGxlcgogCSAqLwpA
QCAtMzg0NiwyMCArMzkzOCw0NSBAQAogCWluc3RhbmNlID0gKHN0cnVjdCBtZWdhc2FzX2luc3Rh
bmNlICopaG9zdC0+aG9zdGRhdGE7CiAJbWVtc2V0KGluc3RhbmNlLCAwLCBzaXplb2YoKmluc3Rh
bmNlKSk7CiAJYXRvbWljX3NldCggJmluc3RhbmNlLT5md19yZXNldF9ub19wY2lfYWNjZXNzLCAw
ICk7CisJaW5zdGFuY2UtPnBkZXYgPSBwZGV2OwogCi0JaW5zdGFuY2UtPnByb2R1Y2VyID0gcGNp
X2FsbG9jX2NvbnNpc3RlbnQocGRldiwgc2l6ZW9mKHUzMiksCi0JCQkJCQkgICZpbnN0YW5jZS0+
cHJvZHVjZXJfaCk7Ci0JaW5zdGFuY2UtPmNvbnN1bWVyID0gcGNpX2FsbG9jX2NvbnNpc3RlbnQo
cGRldiwgc2l6ZW9mKHUzMiksCi0JCQkJCQkgICZpbnN0YW5jZS0+Y29uc3VtZXJfaCk7CisJc3dp
dGNoIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlKSB7CisJY2FzZSBQQ0lfREVWSUNFX0lEX0xTSV9G
VVNJT046CisJeworCQlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lvbjsKKworCQlpbnN0YW5j
ZS0+Y3RybF9jb250ZXh0ID0KKwkJCWt6YWxsb2Moc2l6ZW9mKHN0cnVjdCBmdXNpb25fY29udGV4
dCksIEdGUF9LRVJORUwpOworCQlpZiAoIWluc3RhbmNlLT5jdHJsX2NvbnRleHQpIHsKKwkJCXBy
aW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBGYWlsZWQgdG8gYWxsb2NhdGUgIgorCQkJICAgICAg
ICJtZW1vcnkgZm9yIEZ1c2lvbiBjb250ZXh0IGluZm9cbiIpOworCQkJZ290byBmYWlsX2FsbG9j
X2RtYV9idWY7CisJCX0KKwkJZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKKwkJSU5J
VF9MSVNUX0hFQUQoJmZ1c2lvbi0+Y21kX3Bvb2wpOworCQlzcGluX2xvY2tfaW5pdCgmZnVzaW9u
LT5jbWRfcG9vbF9sb2NrKTsKKwl9CisJYnJlYWs7CisJZGVmYXVsdDogLyogRm9yIGFsbCBvdGhl
ciBzdXBwb3J0ZWQgY29udHJvbGxlcnMgKi8KKworCQlpbnN0YW5jZS0+cHJvZHVjZXIgPQorCQkJ
cGNpX2FsbG9jX2NvbnNpc3RlbnQocGRldiwgc2l6ZW9mKHUzMiksCisJCQkJCSAgICAgJmluc3Rh
bmNlLT5wcm9kdWNlcl9oKTsKKwkJaW5zdGFuY2UtPmNvbnN1bWVyID0KKwkJCXBjaV9hbGxvY19j
b25zaXN0ZW50KHBkZXYsIHNpemVvZih1MzIpLAorCQkJCQkgICAgICZpbnN0YW5jZS0+Y29uc3Vt
ZXJfaCk7CisKKwkJaWYgKCFpbnN0YW5jZS0+cHJvZHVjZXIgfHwgIWluc3RhbmNlLT5jb25zdW1l
cikgeworCQkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IEZhaWxlZCB0byBhbGxvY2F0ZSIK
KwkJCSAgICAgICAibWVtb3J5IGZvciBwcm9kdWNlciwgY29uc3VtZXJcbiIpOworCQkJZ290byBm
YWlsX2FsbG9jX2RtYV9idWY7CisJCX0KIAotCWlmICghaW5zdGFuY2UtPnByb2R1Y2VyIHx8ICFp
bnN0YW5jZS0+Y29uc3VtZXIpIHsKLQkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IEZhaWxl
ZCB0byBhbGxvY2F0ZSBtZW1vcnkgZm9yICIKLQkJICAgICAgICJwcm9kdWNlciwgY29uc3VtZXJc
biIpOwotCQlnb3RvIGZhaWxfYWxsb2NfZG1hX2J1ZjsKKwkJKmluc3RhbmNlLT5wcm9kdWNlciA9
IDA7CisJCSppbnN0YW5jZS0+Y29uc3VtZXIgPSAwOworCQlicmVhazsKIAl9CiAKLQkqaW5zdGFu
Y2UtPnByb2R1Y2VyID0gMDsKLQkqaW5zdGFuY2UtPmNvbnN1bWVyID0gMDsKIAltZWdhc2FzX3Bv
bGxfd2FpdF9hZW4gPSAwOwogCWluc3RhbmNlLT5mbGFnX2llZWUgPSAwOwogCWluc3RhbmNlLT5l
diA9IE5VTEw7CkBAIC0zODk1LDExICs0MDEyLDExIEBACiAJc3Bpbl9sb2NrX2luaXQoJnBvbGxf
YWVuX2xvY2spOwogCiAJbXV0ZXhfaW5pdCgmaW5zdGFuY2UtPmFlbl9tdXRleCk7CisJbXV0ZXhf
aW5pdCgmaW5zdGFuY2UtPnJlc2V0X211dGV4KTsKIAogCS8qCiAJICogSW5pdGlhbGl6ZSBQQ0kg
cmVsYXRlZCBhbmQgbWlzYyBwYXJhbWV0ZXJzCiAJICovCi0JaW5zdGFuY2UtPnBkZXYgPSBwZGV2
OwogCWluc3RhbmNlLT5ob3N0ID0gaG9zdDsKIAlpbnN0YW5jZS0+dW5pcXVlX2lkID0gcGRldi0+
YnVzLT5udW1iZXIgPDwgOCB8IHBkZXYtPmRldmZuOwogCWluc3RhbmNlLT5pbml0X2lkID0gTUVH
QVNBU19ERUZBVUxUX0lOSVRfSUQ7CkBAIC0zOTE3LDcgKzQwMzQsMTAgQEAKIAlpbnN0YW5jZS0+
bGFzdF90aW1lID0gMDsKIAlpbnN0YW5jZS0+ZGlzYWJsZU9ubGluZUN0cmxSZXNldCA9IDE7CiAK
LQlJTklUX1dPUksoJmluc3RhbmNlLT53b3JrX2luaXQsIHByb2Nlc3NfZndfc3RhdGVfY2hhbmdl
X3dxKTsKKwlpZiAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lfREVWSUNFX0lEX0xTSV9G
VVNJT04pCisJCUlOSVRfV09SSygmaW5zdGFuY2UtPndvcmtfaW5pdCwgbWVnYXNhc19mdXNpb25f
b2NyX3dxKTsKKwllbHNlCisJCUlOSVRfV09SSygmaW5zdGFuY2UtPndvcmtfaW5pdCwgcHJvY2Vz
c19md19zdGF0ZV9jaGFuZ2Vfd3EpOwogCiAJLyoKIAkgKiBJbml0aWFsaXplIE1GSSBGaXJtd2Fy
ZQpAQCAtNDAwMCw2ICs0MTIwLDggQEAKIAkJcGNpX2ZyZWVfY29uc2lzdGVudChwZGV2LCBzaXpl
b2YodTMyKSwgaW5zdGFuY2UtPnByb2R1Y2VyLAogCQkJCSAgICBpbnN0YW5jZS0+cHJvZHVjZXJf
aCk7CiAJCW1lZ2FzYXNfcmVsZWFzZV9tZmkoaW5zdGFuY2UpOworCX0gZWxzZSB7CisJCW1lZ2Fz
YXNfcmVsZWFzZV9mdXNpb24oaW5zdGFuY2UpOwogCX0KIAlpZiAoaW5zdGFuY2UtPmNvbnN1bWVy
KQogCQlwY2lfZnJlZV9jb25zaXN0ZW50KHBkZXYsIHNpemVvZih1MzIpLCBpbnN0YW5jZS0+Y29u
c3VtZXIsCkBAIC00MDcyLDcgKzQxOTQsOSBAQAogCiAJaWYgKGluc3RhbmNlLT5hZW5fY21kKQog
CQltZWdhc2FzX2lzc3VlX2Jsb2NrZWRfYWJvcnRfY21kKGluc3RhbmNlLCBpbnN0YW5jZS0+YWVu
X2NtZCk7Ci0KKwlpZiAoaW5zdGFuY2UtPm1hcF91cGRhdGVfY21kKQorCQltZWdhc2FzX2lzc3Vl
X2Jsb2NrZWRfYWJvcnRfY21kKGluc3RhbmNlLAorCQkJCQkJaW5zdGFuY2UtPm1hcF91cGRhdGVf
Y21kKTsKIAlkY21kID0gJmNtZC0+ZnJhbWUtPmRjbWQ7CiAKIAltZW1zZXQoZGNtZC0+bWJveC5i
LCAwLCBNRklfTUJPWF9TSVpFKTsKQEAgLTQxNzcsOSArNDMwMSw2IEBACiAJICogSW5pdGlhbGl6
ZSBNRkkgRmlybXdhcmUKIAkgKi8KIAotCSppbnN0YW5jZS0+cHJvZHVjZXIgPSAwOwotCSppbnN0
YW5jZS0+Y29uc3VtZXIgPSAwOwotCiAJYXRvbWljX3NldCgmaW5zdGFuY2UtPmZ3X291dHN0YW5k
aW5nLCAwKTsKIAogCS8qCkBAIC00MTg4LDExICs0MzA5LDI5IEBACiAJaWYgKG1lZ2FzYXNfdHJh
bnNpdGlvbl90b19yZWFkeShpbnN0YW5jZSkpCiAJCWdvdG8gZmFpbF9yZWFkeV9zdGF0ZTsKIAot
CWlmIChtZWdhc2FzX2lzc3VlX2luaXRfbWZpKGluc3RhbmNlKSkKLQkJZ290byBmYWlsX2luaXRf
bWZpOworCXN3aXRjaCAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSkgeworCWNhc2UgUENJX0RFVklD
RV9JRF9MU0lfRlVTSU9OOgorCXsKKwkJbWVnYXNhc19yZXNldF9yZXBseV9kZXNjKGluc3RhbmNl
KTsKKwkJaWYgKG1lZ2FzYXNfaW9jX2luaXRfZnVzaW9uKGluc3RhbmNlKSkgeworCQkJbWVnYXNh
c19mcmVlX2NtZHMoaW5zdGFuY2UpOworCQkJbWVnYXNhc19mcmVlX2NtZHNfZnVzaW9uKGluc3Rh
bmNlKTsKKwkJCWdvdG8gZmFpbF9pbml0X21maTsKKwkJfQorCQlpZiAoIW1lZ2FzYXNfZ2V0X21h
cF9pbmZvKGluc3RhbmNlKSkKKwkJCW1lZ2FzYXNfc3luY19tYXBfaW5mbyhpbnN0YW5jZSk7CisJ
fQorCWJyZWFrOworCWRlZmF1bHQ6CisJCSppbnN0YW5jZS0+cHJvZHVjZXIgPSAwOworCQkqaW5z
dGFuY2UtPmNvbnN1bWVyID0gMDsKKwkJaWYgKG1lZ2FzYXNfaXNzdWVfaW5pdF9tZmkoaW5zdGFu
Y2UpKQorCQkJZ290byBmYWlsX2luaXRfbWZpOworCQlicmVhazsKKwl9CiAKLQl0YXNrbGV0X2lu
aXQoJmluc3RhbmNlLT5pc3JfdGFza2xldCwgbWVnYXNhc19jb21wbGV0ZV9jbWRfZHBjLAotCQkJ
KHVuc2lnbmVkIGxvbmcpaW5zdGFuY2UpOworCXRhc2tsZXRfaW5pdCgmaW5zdGFuY2UtPmlzcl90
YXNrbGV0LCBpbnN0YW5jZS0+aW5zdGFuY2V0LT50YXNrbGV0LAorCQkgICAgICh1bnNpZ25lZCBs
b25nKWluc3RhbmNlKTsKIAogCS8qIE5vdyByZS1lbmFibGUgTVNJLVggKi8KIAlpZiAoaW5zdGFu
Y2UtPm1zaV9mbGFnKQpAQCAtNDI2MSwxMCArNDQwMCwxMiBAQAogCWludCBpOwogCXN0cnVjdCBT
Y3NpX0hvc3QgKmhvc3Q7CiAJc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlOworCXN0
cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uOwogCiAJaW5zdGFuY2UgPSBwY2lfZ2V0X2RydmRh
dGEocGRldik7CiAJaW5zdGFuY2UtPnVubG9hZCA9IDE7CiAJaG9zdCA9IGluc3RhbmNlLT5ob3N0
OworCWZ1c2lvbiA9IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CiAKIAlpZiAocG9sbF9tb2RlX2lv
KQogCQlkZWxfdGltZXJfc3luYygmaW5zdGFuY2UtPmlvX2NvbXBsZXRpb25fdGltZXIpOwpAQCAt
NDMwNiwxNiArNDQ0NywzMiBAQAogCWlmIChpbnN0YW5jZS0+bXNpX2ZsYWcpCiAJCXBjaV9kaXNh
YmxlX21zaXgoaW5zdGFuY2UtPnBkZXYpOwogCi0JbWVnYXNhc19yZWxlYXNlX21maShpbnN0YW5j
ZSk7Ci0KLQlwY2lfZnJlZV9jb25zaXN0ZW50KHBkZXYsIHNpemVvZihzdHJ1Y3QgbWVnYXNhc19l
dnRfZGV0YWlsKSwKLQkJCSAgICBpbnN0YW5jZS0+ZXZ0X2RldGFpbCwgaW5zdGFuY2UtPmV2dF9k
ZXRhaWxfaCk7Ci0KLQlwY2lfZnJlZV9jb25zaXN0ZW50KHBkZXYsIHNpemVvZih1MzIpLCBpbnN0
YW5jZS0+cHJvZHVjZXIsCi0JCQkgICAgaW5zdGFuY2UtPnByb2R1Y2VyX2gpOwotCi0JcGNpX2Zy
ZWVfY29uc2lzdGVudChwZGV2LCBzaXplb2YodTMyKSwgaW5zdGFuY2UtPmNvbnN1bWVyLAotCQkJ
ICAgIGluc3RhbmNlLT5jb25zdW1lcl9oKTsKKwlzd2l0Y2ggKGluc3RhbmNlLT5wZGV2LT5kZXZp
Y2UpIHsKKwljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTjoKKwkJbWVnYXNhc19yZWxlYXNl
X2Z1c2lvbihpbnN0YW5jZSk7CisJCWZvciAoaSA9IDA7IGkgPCAyIDsgaSsrKQorCQkJaWYgKGZ1
c2lvbi0+bGRfbWFwW2ldKQorCQkJCWRtYV9mcmVlX2NvaGVyZW50KCZpbnN0YW5jZS0+cGRldi0+
ZGV2LAorCQkJCQkJICBmdXNpb24tPm1hcF9zeiwKKwkJCQkJCSAgZnVzaW9uLT5sZF9tYXBbaV0s
CisJCQkJCQkgIGZ1c2lvbi0+CisJCQkJCQkgIGxkX21hcF9waHlzW2ldKTsKKwkJa2ZyZWUoaW5z
dGFuY2UtPmN0cmxfY29udGV4dCk7CisJCWJyZWFrOworCWRlZmF1bHQ6CisJCW1lZ2FzYXNfcmVs
ZWFzZV9tZmkoaW5zdGFuY2UpOworCQlwY2lfZnJlZV9jb25zaXN0ZW50KHBkZXYsCisJCQkJICAg
IHNpemVvZihzdHJ1Y3QgbWVnYXNhc19ldnRfZGV0YWlsKSwKKwkJCQkgICAgaW5zdGFuY2UtPmV2
dF9kZXRhaWwsCisJCQkJICAgIGluc3RhbmNlLT5ldnRfZGV0YWlsX2gpOworCQlwY2lfZnJlZV9j
b25zaXN0ZW50KHBkZXYsIHNpemVvZih1MzIpLAorCQkJCSAgICBpbnN0YW5jZS0+cHJvZHVjZXIs
CisJCQkJICAgIGluc3RhbmNlLT5wcm9kdWNlcl9oKTsKKwkJcGNpX2ZyZWVfY29uc2lzdGVudChw
ZGV2LCBzaXplb2YodTMyKSwKKwkJCQkgICAgaW5zdGFuY2UtPmNvbnN1bWVyLAorCQkJCSAgICBp
bnN0YW5jZS0+Y29uc3VtZXJfaCk7CisJCWJyZWFrOworCX0KIAogCXNjc2lfaG9zdF9wdXQoaG9z
dCk7CiAKQEAgLTUwNzksNiArNTIzNiw3IEBACiAJCQlicmVhazsKIAkJY2FzZSBNUl9FVlRfQ1RS
TF9IT1NUX0JVU19TQ0FOX1JFUVVFU1RFRDoKIAkJY2FzZSBNUl9FVlRfRk9SRUlHTl9DRkdfSU1Q
T1JURUQ6CisJCWNhc2UgTVJfRVZUX0xEX1NUQVRFX0NIQU5HRToKIAkJCWRvc2NhbiA9IDE7CiAJ
CQlicmVhazsKIAkJZGVmYXVsdDoKZGlmZiAtTmF1ciBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2
ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2ZwLmMgbGludXgtMi42LjM3LXJjNS5uZXcv
ZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mcC5jCi0tLSBsaW51eC0yLjYuMzct
cmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2ZwLmMJMTk2OS0xMi0z
MSAxNjowMDowMC4wMDAwMDAwMDAgLTA4MDAKKysrIGxpbnV4LTIuNi4zNy1yYzUubmV3L2RyaXZl
cnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnAuYwkyMDEwLTEyLTIxIDExOjA0OjA4LjAw
MDAwMDAwMCAtMDgwMApAQCAtMCwwICsxLDUxNiBAQAorLyoKKyAqICBMaW51eCBNZWdhUkFJRCBk
cml2ZXIgZm9yIFNBUyBiYXNlZCBSQUlEIGNvbnRyb2xsZXJzCisgKgorICogIENvcHlyaWdodCAo
YykgMjAwOS0yMDExICBMU0kgQ29ycG9yYXRpb24uCisgKgorICogIFRoaXMgcHJvZ3JhbSBpcyBm
cmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IKKyAqICBtb2RpZnkg
aXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZQorICog
IGFzIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVy
c2lvbiAyCisgKiAgb2YgdGhlIExpY2Vuc2UsIG9yIChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVy
IHZlcnNpb24uCisgKgorICogIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9w
ZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLAorICogIGJ1dCBXSVRIT1VUIEFOWSBXQVJSQU5UWTsg
d2l0aG91dCBldmVuIHRoZSBpbXBsaWVkIHdhcnJhbnR5IG9mCisgKiAgTUVSQ0hBTlRBQklMSVRZ
IG9yIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlIHRoZQorICogIEdOVSBH
ZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZvciBtb3JlIGRldGFpbHMuCisgKgorICogIFlvdSBzaG91
bGQgaGF2ZSByZWNlaXZlZCBhIGNvcHkgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNl
CisgKiAgYWxvbmcgd2l0aCB0aGlzIHByb2dyYW07IGlmIG5vdCwgd3JpdGUgdG8gdGhlIEZyZWUg
U29mdHdhcmUKKyAqICBGb3VuZGF0aW9uLCBJbmMuLCA1OSBUZW1wbGUgUGxhY2UsIFN1aXRlIDMz
MCwgQm9zdG9uLCBNQSAwMjExMS0xMzA3IFVTQQorICoKKyAqICBGSUxFOiBtZWdhcmFpZF9zYXNf
ZnAuYworICoKKyAqICBBdXRob3JzOiBMU0kgQ29ycG9yYXRpb24KKyAqICAgICAgICAgICBTdW1h
bnQgUGF0cm8KKyAqICAgICAgICAgICBWYXJhZCBUYWxhbWFja2kKKyAqICAgICAgICAgICBNYW5v
aiBKb3NlCisgKgorICogIFNlbmQgZmVlZGJhY2sgdG86IDxtZWdhcmFpZGxpbnV4QGxzaS5jb20+
CisgKgorICogIE1haWwgdG86IExTSSBDb3Jwb3JhdGlvbiwgMTYyMSBCYXJiZXIgTGFuZSwgTWls
cGl0YXMsIENBIDk1MDM1CisgKiAgICAgQVRUTjogTGludXhyYWlkCisgKi8KKworI2luY2x1ZGUg
PGxpbnV4L2tlcm5lbC5oPgorI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+CisjaW5jbHVkZSA8bGlu
dXgvcGNpLmg+CisjaW5jbHVkZSA8bGludXgvbGlzdC5oPgorI2luY2x1ZGUgPGxpbnV4L21vZHVs
ZXBhcmFtLmg+CisjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+CisjaW5jbHVkZSA8bGludXgvc3Bp
bmxvY2suaD4KKyNpbmNsdWRlIDxsaW51eC9pbnRlcnJ1cHQuaD4KKyNpbmNsdWRlIDxsaW51eC9k
ZWxheS5oPgorI2luY2x1ZGUgPGxpbnV4L3NtcF9sb2NrLmg+CisjaW5jbHVkZSA8bGludXgvdWlv
Lmg+CisjaW5jbHVkZSA8bGludXgvdWFjY2Vzcy5oPgorI2luY2x1ZGUgPGxpbnV4L2ZzLmg+Cisj
aW5jbHVkZSA8bGludXgvY29tcGF0Lmg+CisjaW5jbHVkZSA8bGludXgvYmxrZGV2Lmg+CisjaW5j
bHVkZSA8bGludXgvcG9sbC5oPgorCisjaW5jbHVkZSA8c2NzaS9zY3NpLmg+CisjaW5jbHVkZSA8
c2NzaS9zY3NpX2NtbmQuaD4KKyNpbmNsdWRlIDxzY3NpL3Njc2lfZGV2aWNlLmg+CisjaW5jbHVk
ZSA8c2NzaS9zY3NpX2hvc3QuaD4KKworI2luY2x1ZGUgIm1lZ2FyYWlkX3Nhc19mdXNpb24uaCIK
KyNpbmNsdWRlIDxhc20vZGl2NjQuaD4KKworI2RlZmluZSBBQlNfRElGRihhLCBiKSAgICgoKGEp
ID4gKGIpKSA/ICgoYSkgLSAoYikpIDogKChiKSAtIChhKSkpCisjZGVmaW5lIE1SX0xEX1NUQVRF
X09QVElNQUwgMworI2RlZmluZSBGQUxTRSAwCisjZGVmaW5lIFRSVUUgMQorCisvKiBQcm90b3R5
cGVzICovCit2b2lkCittcl91cGRhdGVfbG9hZF9iYWxhbmNlX3BhcmFtcyhzdHJ1Y3QgTVJfRldf
UkFJRF9NQVBfQUxMICptYXAsCisJCQkgICAgICBzdHJ1Y3QgTERfTE9BRF9CQUxBTkNFX0lORk8g
KmxiSW5mbyk7CisKK3UzMiBtZWdhX21vZDY0KHU2NCBkaXZpZGVuZCwgdTMyIGRpdmlzb3IpCit7
CisJdTY0IGQ7CisJdTMyIHJlbWFpbmRlcjsKKworCWlmICghZGl2aXNvcikKKwkJcHJpbnRrKEtF
Uk5fRVJSICJtZWdhc2FzIDogRElWSVNPUiBpcyB6ZXJvLCBpbiBkaXYgZm5cbiIpOworCWQgPSBk
aXZpZGVuZDsKKwlyZW1haW5kZXIgPSBkb19kaXYoZCwgZGl2aXNvcik7CisJcmV0dXJuIHJlbWFp
bmRlcjsKK30KKworLyoqCisgKiBAcGFyYW0gZGl2aWRlbmQgICAgOiBEaXZpZGVuZAorICogQHBh
cmFtIGRpdmlzb3IgICAgOiBEaXZpc29yCisgKgorICogQHJldHVybiBxdW90aWVudAorICoqLwor
dTY0IG1lZ2FfZGl2NjRfMzIodWludDY0X3QgZGl2aWRlbmQsIHVpbnQzMl90IGRpdmlzb3IpCit7
CisJdTMyIHJlbWFpbmRlcjsKKwl1NjQgZDsKKworCWlmICghZGl2aXNvcikKKwkJcHJpbnRrKEtF
Uk5fRVJSICJtZWdhc2FzIDogRElWSVNPUiBpcyB6ZXJvIGluIG1vZCBmblxuIik7CisKKwlkID0g
ZGl2aWRlbmQ7CisJcmVtYWluZGVyID0gZG9fZGl2KGQsIGRpdmlzb3IpOworCisJcmV0dXJuIGQ7
Cit9CisKK3N0cnVjdCBNUl9MRF9SQUlEICpNUl9MZFJhaWRHZXQodTMyIGxkLCBzdHJ1Y3QgTVJf
RldfUkFJRF9NQVBfQUxMICptYXApCit7CisJcmV0dXJuICZtYXAtPnJhaWRNYXAubGRTcGFuTWFw
W2xkXS5sZFJhaWQ7Cit9CisKK3N0YXRpYyBzdHJ1Y3QgTVJfU1BBTl9CTE9DS19JTkZPICpNUl9M
ZFNwYW5JbmZvR2V0KHUzMiBsZCwKKwkJCQkJCSAgIHN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwK
KwkJCQkJCSAgICptYXApCit7CisJcmV0dXJuICZtYXAtPnJhaWRNYXAubGRTcGFuTWFwW2xkXS5z
cGFuQmxvY2tbMF07Cit9CisKK3N0YXRpYyB1OCBNUl9MZERhdGFBcm1HZXQodTMyIGxkLCB1MzIg
YXJtSWR4LCBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApCit7CisJcmV0dXJuIG1hcC0+
cmFpZE1hcC5sZFNwYW5NYXBbbGRdLmRhdGFBcm1NYXBbYXJtSWR4XTsKK30KKworc3RhdGljIHUx
NiBNUl9BclBkR2V0KHUzMiBhciwgdTMyIGFybSwgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAq
bWFwKQoreworCXJldHVybiBtYXAtPnJhaWRNYXAuYXJNYXBJbmZvW2FyXS5wZFthcm1dOworfQor
CitzdGF0aWMgdTE2IE1SX0xkU3BhbkFycmF5R2V0KHUzMiBsZCwgdTMyIHNwYW4sIHN0cnVjdCBN
Ul9GV19SQUlEX01BUF9BTEwgKm1hcCkKK3sKKwlyZXR1cm4gbWFwLT5yYWlkTWFwLmxkU3Bhbk1h
cFtsZF0uc3BhbkJsb2NrW3NwYW5dLnNwYW4uYXJyYXlSZWY7Cit9CisKK3N0YXRpYyB1MTYgTVJf
UGREZXZIYW5kbGVHZXQodTMyIHBkLCBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApCit7
CisJcmV0dXJuIG1hcC0+cmFpZE1hcC5kZXZIbmRsSW5mb1twZF0uY3VyRGV2SGRsOworfQorCit1
MTYgTVJfR2V0TERUZ3RJZCh1MzIgbGQsIHN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKm1hcCkK
K3sKKwlyZXR1cm4gbWFwLT5yYWlkTWFwLmxkU3Bhbk1hcFtsZF0ubGRSYWlkLnRhcmdldElkOwor
fQorCit1MTYgTVJfVGFyZ2V0SWRUb0xkR2V0KHUzMiBsZFRndElkLCBzdHJ1Y3QgTVJfRldfUkFJ
RF9NQVBfQUxMICptYXApCit7CisJcmV0dXJuIG1hcC0+cmFpZE1hcC5sZFRndElkVG9MZFtsZFRn
dElkXTsKK30KKworc3RhdGljIHN0cnVjdCBNUl9MRF9TUEFOICpNUl9MZFNwYW5QdHJHZXQodTMy
IGxkLCB1MzIgc3BhbiwKKwkJCQkJICBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApCit7
CisJcmV0dXJuICZtYXAtPnJhaWRNYXAubGRTcGFuTWFwW2xkXS5zcGFuQmxvY2tbc3Bhbl0uc3Bh
bjsKK30KKworLyoKKyAqIFRoaXMgZnVuY3Rpb24gd2lsbCB2YWxpZGF0ZSBNYXAgaW5mbyBkYXRh
IHByb3ZpZGVkIGJ5IEZXCisgKi8KK3U4IE1SX1ZhbGlkYXRlTWFwSW5mbyhzdHJ1Y3QgTVJfRldf
UkFJRF9NQVBfQUxMICptYXAsCisJCSAgICAgIHN0cnVjdCBMRF9MT0FEX0JBTEFOQ0VfSU5GTyAq
bGJJbmZvKQoreworCXN0cnVjdCBNUl9GV19SQUlEX01BUCAqcEZ3UmFpZE1hcCA9ICZtYXAtPnJh
aWRNYXA7CisKKwlpZiAocEZ3UmFpZE1hcC0+dG90YWxTaXplICE9CisJICAgIChzaXplb2Yoc3Ry
dWN0IE1SX0ZXX1JBSURfTUFQKSAtc2l6ZW9mKHN0cnVjdCBNUl9MRF9TUEFOX01BUCkgKworCSAg
ICAgKHNpemVvZihzdHJ1Y3QgTVJfTERfU1BBTl9NQVApICpwRndSYWlkTWFwLT5sZENvdW50KSkp
IHsKKwkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBtYXAgaW5mbyBzdHJ1Y3R1cmUgc2l6ZSAw
eCV4IGlzIG5vdCBtYXRjaGluZyB3aXRoIGxkIGNvdW50XG4iLAorCQkgICAgICAgKHVuc2lnbmVk
IGludCkoKHNpemVvZihzdHJ1Y3QgTVJfRldfUkFJRF9NQVApIC0KKwkJCQkgICAgICAgc2l6ZW9m
KHN0cnVjdCBNUl9MRF9TUEFOX01BUCkpICsKKwkJCQkgICAgICAoc2l6ZW9mKHN0cnVjdCBNUl9M
RF9TUEFOX01BUCkgKgorCQkJCSAgICAgICBwRndSYWlkTWFwLT5sZENvdW50KSkpOworCQlwcmlu
dGsoS0VSTl9FUlIgIm1lZ2FzYXM6IHNwYW4gbWFwICV4LCBwRndSYWlkTWFwLT50b3RhbFNpemUg
IgorCQkgICAgICAgIjogJXhcbiIsICh1bnNpZ25lZCBpbnQpc2l6ZW9mKHN0cnVjdCBNUl9MRF9T
UEFOX01BUCksCisJCSAgICAgICBwRndSYWlkTWFwLT50b3RhbFNpemUpOworCQlyZXR1cm4gMDsK
Kwl9CisKKwltcl91cGRhdGVfbG9hZF9iYWxhbmNlX3BhcmFtcyhtYXAsIGxiSW5mbyk7CisKKwly
ZXR1cm4gMTsKK30KKwordTMyIE1SX0dldFNwYW5CbG9jayh1MzIgbGQsIHU2NCByb3csIHU2NCAq
c3Bhbl9ibGssCisJCSAgICBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXAsIGludCAqZGl2
X2Vycm9yKQoreworCXN0cnVjdCBNUl9TUEFOX0JMT0NLX0lORk8gKnBTcGFuQmxvY2sgPSBNUl9M
ZFNwYW5JbmZvR2V0KGxkLCBtYXApOworCXN0cnVjdCBNUl9RVUFEX0VMRU1FTlQgICAgKnF1YWQ7
CisJc3RydWN0IE1SX0xEX1JBSUQgICAgICAgICAqcmFpZCA9IE1SX0xkUmFpZEdldChsZCwgbWFw
KTsKKwl1MzIgICAgICAgICAgICAgICAgc3BhbiwgajsKKworCWZvciAoc3BhbiA9IDA7IHNwYW4g
PCByYWlkLT5zcGFuRGVwdGg7IHNwYW4rKywgcFNwYW5CbG9jaysrKSB7CisKKwkJZm9yIChqID0g
MDsgaiA8IHBTcGFuQmxvY2stPmJsb2NrX3NwYW5faW5mby5ub0VsZW1lbnRzOyBqKyspIHsKKwkJ
CXF1YWQgPSAmcFNwYW5CbG9jay0+YmxvY2tfc3Bhbl9pbmZvLnF1YWRbal07CisKKwkJCWlmIChx
dWFkLT5kaWZmID09IDApIHsKKwkJCQkqZGl2X2Vycm9yID0gMTsKKwkJCQlyZXR1cm4gc3BhbjsK
KwkJCX0KKwkJCWlmIChxdWFkLT5sb2dTdGFydCA8PSByb3cgICYmICByb3cgPD0gcXVhZC0+bG9n
RW5kICAmJgorCQkJICAgIChtZWdhX21vZDY0KHJvdy1xdWFkLT5sb2dTdGFydCwgcXVhZC0+ZGlm
ZikpID09IDApIHsKKwkJCQlpZiAoc3Bhbl9ibGsgIT0gTlVMTCkgeworCQkJCQl1NjQgIGJsaywg
ZGVidWdCbGs7CisJCQkJCWJsayA9CisJCQkJCQltZWdhX2RpdjY0XzMyKAorCQkJCQkJCShyb3ct
cXVhZC0+bG9nU3RhcnQpLAorCQkJCQkJCXF1YWQtPmRpZmYpOworCQkJCQlkZWJ1Z0JsayA9IGJs
azsKKworCQkJCQlibGsgPSAoYmxrICsgcXVhZC0+b2Zmc2V0SW5TcGFuKSA8PAorCQkJCQkJcmFp
ZC0+c3RyaXBlU2hpZnQ7CisJCQkJCSpzcGFuX2JsayA9IGJsazsKKwkJCQl9CisJCQkJcmV0dXJu
IHNwYW47CisJCQl9CisJCX0KKwl9CisJcmV0dXJuIHNwYW47Cit9CisKKy8qCisqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioKKyoKKyogVGhpcyByb3V0aW5lIGNhbGN1bGF0ZXMgdGhlIGFybSwgc3BhbiBh
bmQgYmxvY2sgZm9yIHRoZSBzcGVjaWZpZWQgc3RyaXBlIGFuZAorKiByZWZlcmVuY2UgaW4gc3Ry
aXBlLgorKgorKiBJbnB1dHMgOgorKgorKiAgICBsZCAgIC0gTG9naWNhbCBkcml2ZSBudW1iZXIK
KyogICAgc3RyaXBSb3cgICAgICAgIC0gU3RyaXBlIG51bWJlcgorKiAgICBzdHJpcFJlZiAgICAt
IFJlZmVyZW5jZSBpbiBzdHJpcGUKKyoKKyogT3V0cHV0cyA6CisqCisqICAgIHNwYW4gICAgICAg
ICAgLSBTcGFuIG51bWJlcgorKiAgICBibG9jayAgICAgICAgIC0gQWJzb2x1dGUgQmxvY2sgbnVt
YmVyIGluIHRoZSBwaHlzaWNhbCBkaXNrCisqLwordTggTVJfR2V0UGh5UGFyYW1zKHUzMiBsZCwg
dTY0IHN0cmlwUm93LCB1MTYgc3RyaXBSZWYsIHU2NCAqcGRCbG9jaywKKwkJICAgdTE2ICpwRGV2
SGFuZGxlLCBzdHJ1Y3QgUkFJRF9DT05URVhUICpwUkFJRF9Db250ZXh0LAorCQkgICBzdHJ1Y3Qg
TVJfRldfUkFJRF9NQVBfQUxMICptYXApCit7CisJc3RydWN0IE1SX0xEX1JBSUQgICpyYWlkID0g
TVJfTGRSYWlkR2V0KGxkLCBtYXApOworCXUzMiAgICAgICAgIHBkLCBhclJlZjsKKwl1OCAgICAg
ICAgICBwaHlzQXJtLCBzcGFuOworCXU2NCAgICAgICAgIHJvdzsKKwl1OAkgICAgcmV0dmFsID0g
VFJVRTsKKwlpbnQJICAgIGVycm9yX2NvZGUgPSAwOworCisJcm93ID0gIG1lZ2FfZGl2NjRfMzIo
c3RyaXBSb3csIHJhaWQtPnJvd0RhdGFTaXplKTsKKworCWlmIChyYWlkLT5sZXZlbCA9PSA2KSB7
CisJCS8qIGxvZ2ljYWwgYXJtIHdpdGhpbiByb3cgKi8KKwkJdTMyIGxvZ0FybSA9ICBtZWdhX21v
ZDY0KHN0cmlwUm93LCByYWlkLT5yb3dEYXRhU2l6ZSk7CisJCXUzMiByb3dNb2QsIGFybVEsIGFy
bTsKKworCQlpZiAocmFpZC0+cm93U2l6ZSA9PSAwKQorCQkJcmV0dXJuIEZBTFNFOworCQkvKiBn
ZXQgbG9naWNhbCByb3cgbW9kICovCisJCXJvd01vZCA9IG1lZ2FfbW9kNjQocm93LCByYWlkLT5y
b3dTaXplKTsKKwkJYXJtUSA9IHJhaWQtPnJvd1NpemUtMS1yb3dNb2Q7IC8qIGluZGV4IG9mIFEg
ZHJpdmUgKi8KKwkJYXJtID0gYXJtUSsxK2xvZ0FybTsgLyogZGF0YSBhbHdheXMgbG9naWNhbGx5
IGZvbGxvd3MgUSAqLworCQlpZiAoYXJtID49IHJhaWQtPnJvd1NpemUpIC8qIGhhbmRsZSB3cmFw
IGNvbmRpdGlvbiAqLworCQkJYXJtIC09IHJhaWQtPnJvd1NpemU7CisJCXBoeXNBcm0gPSAodTgp
YXJtOworCX0gZWxzZSAgeworCQlpZiAocmFpZC0+bW9kRmFjdG9yID09IDApCisJCQlyZXR1cm4g
RkFMU0U7CisJCXBoeXNBcm0gPSBNUl9MZERhdGFBcm1HZXQobGQsICBtZWdhX21vZDY0KHN0cmlw
Um93LAorCQkJCQkJCSAgcmFpZC0+bW9kRmFjdG9yKSwKKwkJCQkJICBtYXApOworCX0KKworCWlm
IChyYWlkLT5zcGFuRGVwdGggPT0gMSkgeworCQlzcGFuID0gMDsKKwkJKnBkQmxvY2sgPSByb3cg
PDwgcmFpZC0+c3RyaXBlU2hpZnQ7CisJfSBlbHNlIHsKKwkJc3BhbiA9ICh1OClNUl9HZXRTcGFu
QmxvY2sobGQsIHJvdywgcGRCbG9jaywgbWFwLCAmZXJyb3JfY29kZSk7CisJCWlmIChlcnJvcl9j
b2RlID09IDEpCisJCQlyZXR1cm4gRkFMU0U7CisJfQorCisJLyogR2V0IHRoZSBhcnJheSBvbiB3
aGljaCB0aGlzIHNwYW4gaXMgcHJlc2VudCAqLworCWFyUmVmICAgICAgID0gTVJfTGRTcGFuQXJy
YXlHZXQobGQsIHNwYW4sIG1hcCk7CisJcGQgICAgICAgICAgPSBNUl9BclBkR2V0KGFyUmVmLCBw
aHlzQXJtLCBtYXApOyAvKiBHZXQgdGhlIHBkICovCisKKwlpZiAocGQgIT0gTVJfUERfSU5WQUxJ
RCkKKwkJLyogR2V0IGRldiBoYW5kbGUgZnJvbSBQZC4gKi8KKwkJKnBEZXZIYW5kbGUgPSBNUl9Q
ZERldkhhbmRsZUdldChwZCwgbWFwKTsKKwllbHNlIHsKKwkJKnBEZXZIYW5kbGUgPSBNUl9QRF9J
TlZBTElEOyAvKiBzZXQgZGV2IGhhbmRsZSBhcyBpbnZhbGlkLiAqLworCQlpZiAocmFpZC0+bGV2
ZWwgPj0gNSkKKwkJCXBSQUlEX0NvbnRleHQtPnJlZ0xvY2tGbGFncyA9IFJFR0lPTl9UWVBFX0VY
Q0xVU0lWRTsKKwkJZWxzZSBpZiAocmFpZC0+bGV2ZWwgPT0gMSkgeworCQkJLyogR2V0IGFsdGVy
bmF0ZSBQZC4gKi8KKwkJCXBkID0gTVJfQXJQZEdldChhclJlZiwgcGh5c0FybSArIDEsIG1hcCk7
CisJCQlpZiAocGQgIT0gTVJfUERfSU5WQUxJRCkKKwkJCQkvKiBHZXQgZGV2IGhhbmRsZSBmcm9t
IFBkICovCisJCQkJKnBEZXZIYW5kbGUgPSBNUl9QZERldkhhbmRsZUdldChwZCwgbWFwKTsKKwkJ
fQorCQlyZXR2YWwgPSBGQUxTRTsKKwl9CisKKwkqcGRCbG9jayArPSBzdHJpcFJlZiArIE1SX0xk
U3BhblB0ckdldChsZCwgc3BhbiwgbWFwKS0+c3RhcnRCbGs7CisJcFJBSURfQ29udGV4dC0+c3Bh
bkFybSA9IChzcGFuIDw8IFJBSURfQ1RYX1NQQU5BUk1fU1BBTl9TSElGVCkgfAorCQlwaHlzQXJt
OworCXJldHVybiByZXR2YWw7Cit9CisKKy8qCisqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioKKyoKKyog
TVJfQnVpbGRSYWlkQ29udGV4dCBmdW5jdGlvbgorKgorKiBUaGlzIGZ1bmN0aW9uIHdpbGwgaW5p
dGlhdGUgY29tbWFuZCBwcm9jZXNzaW5nLiAgVGhlIHN0YXJ0L2VuZCByb3cgYW5kIHN0cmlwCisq
IGluZm9ybWF0aW9uIGlzIGNhbGN1bGF0ZWQgdGhlbiB0aGUgbG9jayBpcyBhY3F1aXJlZC4KKyog
VGhpcyBmdW5jdGlvbiB3aWxsIHJldHVybiAwIGlmIHJlZ2lvbiBsb2NrIHdhcyBhY3F1aXJlZCBP
UiByZXR1cm4gbnVtIHN0cmlwcworKi8KK3U4CitNUl9CdWlsZFJhaWRDb250ZXh0KHN0cnVjdCBJ
T19SRVFVRVNUX0lORk8gKmlvX2luZm8sCisJCSAgICBzdHJ1Y3QgUkFJRF9DT05URVhUICpwUkFJ
RF9Db250ZXh0LAorCQkgICAgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwKQoreworCXN0
cnVjdCBNUl9MRF9SQUlEICAqcmFpZDsKKwl1MzIgICAgICAgICBsZCwgc3RyaXBTaXplLCBzdHJp
cGVfbWFzazsKKwl1NjQgICAgICAgICBlbmRMYmEsIGVuZFN0cmlwLCBlbmRSb3csIHN0YXJ0X3Jv
dywgc3RhcnRfc3RyaXA7CisJdTY0ICAgICAgICAgcmVnU3RhcnQ7CisJdTMyICAgICAgICAgcmVn
U2l6ZTsKKwl1OCAgICAgICAgICBudW1fc3RyaXBzLCBudW1Sb3dzOworCXUxNiAgICAgICAgIHJl
Zl9pbl9zdGFydF9zdHJpcGUsIHJlZl9pbl9lbmRfc3RyaXBlOworCXU2NCAgICAgICAgIGxkU3Rh
cnRCbG9jazsKKwl1MzIgICAgICAgICBudW1CbG9ja3MsIGxkVGd0SWQ7CisJdTggICAgICAgICAg
aXNSZWFkOworCXU4CSAgICByZXR2YWwgPSAwOworCisJbGRTdGFydEJsb2NrID0gaW9faW5mby0+
bGRTdGFydEJsb2NrOworCW51bUJsb2NrcyA9IGlvX2luZm8tPm51bUJsb2NrczsKKwlsZFRndElk
ID0gaW9faW5mby0+bGRUZ3RJZDsKKwlpc1JlYWQgPSBpb19pbmZvLT5pc1JlYWQ7CisKKwlsZCA9
IE1SX1RhcmdldElkVG9MZEdldChsZFRndElkLCBtYXApOworCXJhaWQgPSBNUl9MZFJhaWRHZXQo
bGQsIG1hcCk7CisKKwlzdHJpcFNpemUgPSAxIDw8IHJhaWQtPnN0cmlwZVNoaWZ0OworCXN0cmlw
ZV9tYXNrID0gc3RyaXBTaXplLTE7CisJLyoKKwkgKiBjYWxjdWxhdGUgc3RhcnRpbmcgcm93IGFu
ZCBzdHJpcGUsIGFuZCBudW1iZXIgb2Ygc3RyaXBzIGFuZCByb3dzCisJICovCisJc3RhcnRfc3Ry
aXAgICAgICAgICA9IGxkU3RhcnRCbG9jayA+PiByYWlkLT5zdHJpcGVTaGlmdDsKKwlyZWZfaW5f
c3RhcnRfc3RyaXBlID0gKHUxNikobGRTdGFydEJsb2NrICYgc3RyaXBlX21hc2spOworCWVuZExi
YSAgICAgICAgICAgICAgPSBsZFN0YXJ0QmxvY2sgKyBudW1CbG9ja3MgLSAxOworCXJlZl9pbl9l
bmRfc3RyaXBlICAgPSAodTE2KShlbmRMYmEgJiBzdHJpcGVfbWFzayk7CisJZW5kU3RyaXAgICAg
ICAgICAgICA9IGVuZExiYSA+PiByYWlkLT5zdHJpcGVTaGlmdDsKKwludW1fc3RyaXBzICAgICAg
ICAgID0gKHU4KShlbmRTdHJpcCAtIHN0YXJ0X3N0cmlwICsgMSk7IC8qIEVuZCBzdHJpcCAqLwor
CWlmIChyYWlkLT5yb3dEYXRhU2l6ZSA9PSAwKQorCQlyZXR1cm4gRkFMU0U7CisJc3RhcnRfcm93
ICAgICAgICAgICA9ICBtZWdhX2RpdjY0XzMyKHN0YXJ0X3N0cmlwLCByYWlkLT5yb3dEYXRhU2l6
ZSk7CisJZW5kUm93ICAgICAgICAgICAgICA9ICBtZWdhX2RpdjY0XzMyKGVuZFN0cmlwLCByYWlk
LT5yb3dEYXRhU2l6ZSk7CisJbnVtUm93cyAgICAgICAgICAgICA9ICh1OCkoZW5kUm93IC0gc3Rh
cnRfcm93ICsgMSk7CisKKwkvKgorCSAqIGNhbGN1bGF0ZSByZWdpb24gaW5mby4KKwkgKi8KKwor
CS8qIGFzc3VtZSByZWdpb24gaXMgYXQgdGhlIHN0YXJ0IG9mIHRoZSBmaXJzdCByb3cgKi8KKwly
ZWdTdGFydCAgICAgICAgICAgID0gc3RhcnRfcm93IDw8IHJhaWQtPnN0cmlwZVNoaWZ0OworCS8q
IGFzc3VtZSB0aGlzIElPIG5lZWRzIHRoZSBmdWxsIHJvdyAtIHdlJ2xsIGFkanVzdCBpZiBub3Qg
dHJ1ZSAqLworCXJlZ1NpemUgICAgICAgICAgICAgPSBzdHJpcFNpemU7CisKKwkvKiBJZiBJTyBz
cGFucyBtb3JlIHRoYW4gMSBzdHJpcCwgZnAgaXMgbm90IHBvc3NpYmxlCisJICAgRlAgaXMgbm90
IHBvc3NpYmxlIGZvciB3cml0ZXMgb24gbm9uLTAgcmFpZCBsZXZlbHMKKwkgICBGUCBpcyBub3Qg
cG9zc2libGUgaWYgTEQgaXMgbm90IGNhcGFibGUgKi8KKwlpZiAobnVtX3N0cmlwcyA+IDEgfHwg
KCFpc1JlYWQgJiYgcmFpZC0+bGV2ZWwgIT0gMCkgfHwKKwkgICAgIXJhaWQtPmNhcGFiaWxpdHku
ZnBDYXBhYmxlKSB7CisJCWlvX2luZm8tPmZwT2tGb3JJbyA9IEZBTFNFOworCX0gZWxzZSB7CisJ
CWlvX2luZm8tPmZwT2tGb3JJbyA9IFRSVUU7CisJfQorCisJaWYgKG51bVJvd3MgPT0gMSkgewor
CQkvKiBzaW5nbGUtc3RyaXAgSU9zIGNhbiBhbHdheXMgbG9jayBvbmx5IHRoZSBkYXRhIG5lZWRl
ZCAqLworCQlpZiAobnVtX3N0cmlwcyA9PSAxKSB7CisJCQlyZWdTdGFydCArPSByZWZfaW5fc3Rh
cnRfc3RyaXBlOworCQkJcmVnU2l6ZSA9IG51bUJsb2NrczsKKwkJfQorCQkvKiBtdWx0aS1zdHJp
cCBJT3MgYWx3YXlzIG5lZWQgdG8gZnVsbCBzdHJpcGUgbG9ja2VkICovCisJfSBlbHNlIHsKKwkJ
aWYgKHN0YXJ0X3N0cmlwID09IChzdGFydF9yb3cgKyAxKSAqIHJhaWQtPnJvd0RhdGFTaXplIC0g
MSkgeworCQkJLyogSWYgdGhlIHN0YXJ0IHN0cmlwIGlzIHRoZSBsYXN0IGluIHRoZSBzdGFydCBy
b3cgKi8KKwkJCXJlZ1N0YXJ0ICs9IHJlZl9pbl9zdGFydF9zdHJpcGU7CisJCQlyZWdTaXplID0g
c3RyaXBTaXplIC0gcmVmX2luX3N0YXJ0X3N0cmlwZTsKKwkJCS8qIGluaXRpYWxpemUgY291bnQg
dG8gc2VjdG9ycyBmcm9tIHN0YXJ0cmVmIHRvIGVuZAorCQkJICAgb2Ygc3RyaXAgKi8KKwkJfQor
CisJCWlmIChudW1Sb3dzID4gMikKKwkJCS8qIEFkZCBjb21wbGV0ZSByb3dzIGluIHRoZSBtaWRk
bGUgb2YgdGhlIHRyYW5zZmVyICovCisJCQlyZWdTaXplICs9IChudW1Sb3dzLTIpIDw8IHJhaWQt
PnN0cmlwZVNoaWZ0OworCisJCS8qIGlmIElPIGVuZHMgd2l0aGluIGZpcnN0IHN0cmlwIG9mIGxh
c3Qgcm93ICovCisJCWlmIChlbmRTdHJpcCA9PSBlbmRSb3cqcmFpZC0+cm93RGF0YVNpemUpCisJ
CQlyZWdTaXplICs9IHJlZl9pbl9lbmRfc3RyaXBlKzE7CisJCWVsc2UKKwkJCXJlZ1NpemUgKz0g
c3RyaXBTaXplOworCX0KKworCXBSQUlEX0NvbnRleHQtPnRpbWVvdXRWYWx1ZSAgICAgPSBtYXAt
PnJhaWRNYXAuZnBQZElvVGltZW91dFNlYzsKKwlwUkFJRF9Db250ZXh0LT5yZWdMb2NrRmxhZ3Mg
ICAgID0gKGlzUmVhZCkgPyBSRUdJT05fVFlQRV9TSEFSRURfUkVBRCA6CisJCXJhaWQtPnJlZ1R5
cGVSZXFPbldyaXRlOworCXBSQUlEX0NvbnRleHQtPlZpcnR1YWxEaXNrVGd0SWQgPSByYWlkLT50
YXJnZXRJZDsKKwlwUkFJRF9Db250ZXh0LT5yZWdMb2NrUm93TEJBICAgID0gcmVnU3RhcnQ7CisJ
cFJBSURfQ29udGV4dC0+cmVnTG9ja0xlbmd0aCAgICA9IHJlZ1NpemU7CisJcFJBSURfQ29udGV4
dC0+Y29uZmlnU2VxTnVtCT0gcmFpZC0+c2VxTnVtOworCisJLypHZXQgUGh5IFBhcmFtcyBvbmx5
IGlmIEZQIGNhcGFibGUsIG9yIGVsc2UgbGVhdmUgaXQgdG8gTVIgZmlybXdhcmUKKwkgIHRvIGRv
IHRoZSBjYWxjdWxhdGlvbi4qLworCWlmIChpb19pbmZvLT5mcE9rRm9ySW8pIHsKKwkJcmV0dmFs
ID0gTVJfR2V0UGh5UGFyYW1zKGxkLCBzdGFydF9zdHJpcCwgcmVmX2luX3N0YXJ0X3N0cmlwZSwK
KwkJCQkJICZpb19pbmZvLT5wZEJsb2NrLAorCQkJCQkgJmlvX2luZm8tPmRldkhhbmRsZSwgcFJB
SURfQ29udGV4dCwKKwkJCQkJIG1hcCk7CisJCS8qIElmIElPIG9uIGFuIGludmFsaWQgUGQsIHRo
ZW4gRlAgaSBzbm90IHBvc3NpYmxlICovCisJCWlmIChpb19pbmZvLT5kZXZIYW5kbGUgPT0gTVJf
UERfSU5WQUxJRCkKKwkJCWlvX2luZm8tPmZwT2tGb3JJbyA9IEZBTFNFOworCQlyZXR1cm4gcmV0
dmFsOworCX0gZWxzZSBpZiAoaXNSZWFkKSB7CisJCXVpbnQgc3RyaXBJZHg7CisJCWZvciAoc3Ry
aXBJZHggPSAwOyBzdHJpcElkeCA8IG51bV9zdHJpcHM7IHN0cmlwSWR4KyspIHsKKwkJCWlmICgh
TVJfR2V0UGh5UGFyYW1zKGxkLCBzdGFydF9zdHJpcCArIHN0cmlwSWR4LAorCQkJCQkgICAgIHJl
Zl9pbl9zdGFydF9zdHJpcGUsCisJCQkJCSAgICAgJmlvX2luZm8tPnBkQmxvY2ssCisJCQkJCSAg
ICAgJmlvX2luZm8tPmRldkhhbmRsZSwKKwkJCQkJICAgICBwUkFJRF9Db250ZXh0LCBtYXApKQor
CQkJCXJldHVybiBUUlVFOworCQl9CisJfQorCXJldHVybiBUUlVFOworfQorCit2b2lkCittcl91
cGRhdGVfbG9hZF9iYWxhbmNlX3BhcmFtcyhzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXAs
CisJCQkgICAgICBzdHJ1Y3QgTERfTE9BRF9CQUxBTkNFX0lORk8gKmxiSW5mbykKK3sKKwlpbnQg
bGRDb3VudDsKKwl1MTYgbGQ7CisJc3RydWN0IE1SX0xEX1JBSUQgKnJhaWQ7CisKKwlmb3IgKGxk
Q291bnQgPSAwOyBsZENvdW50IDwgTUFYX0xPR0lDQUxfRFJJVkVTOyBsZENvdW50KyspIHsKKwkJ
bGQgPSBNUl9UYXJnZXRJZFRvTGRHZXQobGRDb3VudCwgbWFwKTsKKwkJaWYgKGxkID49IE1BWF9M
T0dJQ0FMX0RSSVZFUykgeworCQkJbGJJbmZvW2xkQ291bnRdLmxvYWRCYWxhbmNlRmxhZyA9IDA7
CisJCQljb250aW51ZTsKKwkJfQorCisJCXJhaWQgPSBNUl9MZFJhaWRHZXQobGQsIG1hcCk7CisK
KwkJLyogVHdvIGRyaXZlIE9wdGltYWwgUkFJRCAxICovCisJCWlmICgocmFpZC0+bGV2ZWwgPT0g
MSkgICYmICAocmFpZC0+cm93U2l6ZSA9PSAyKSAmJgorCQkgICAgKHJhaWQtPnNwYW5EZXB0aCA9
PSAxKSAmJiByYWlkLT5sZFN0YXRlID09CisJCSAgICBNUl9MRF9TVEFURV9PUFRJTUFMKSB7CisJ
CQl1MzIgcGQsIGFyUmVmOworCisJCQlsYkluZm9bbGRDb3VudF0ubG9hZEJhbGFuY2VGbGFnID0g
MTsKKworCQkJLyogR2V0IHRoZSBhcnJheSBvbiB3aGljaCB0aGlzIHNwYW4gaXMgcHJlc2VudCAq
LworCQkJYXJSZWYgPSBNUl9MZFNwYW5BcnJheUdldChsZCwgMCwgbWFwKTsKKworCQkJLyogR2V0
IHRoZSBQZCAqLworCQkJcGQgPSBNUl9BclBkR2V0KGFyUmVmLCAwLCBtYXApOworCQkJLyogR2V0
IGRldiBoYW5kbGUgZnJvbSBQZCAqLworCQkJbGJJbmZvW2xkQ291bnRdLnJhaWQxRGV2SGFuZGxl
WzBdID0KKwkJCQlNUl9QZERldkhhbmRsZUdldChwZCwgbWFwKTsKKwkJCS8qIEdldCB0aGUgUGQg
Ki8KKwkJCXBkID0gTVJfQXJQZEdldChhclJlZiwgMSwgbWFwKTsKKworCQkJLyogR2V0IHRoZSBk
ZXYgaGFuZGxlIGZyb20gUGQgKi8KKwkJCWxiSW5mb1tsZENvdW50XS5yYWlkMURldkhhbmRsZVsx
XSA9CisJCQkJTVJfUGREZXZIYW5kbGVHZXQocGQsIG1hcCk7CisJCX0gZWxzZQorCQkJbGJJbmZv
W2xkQ291bnRdLmxvYWRCYWxhbmNlRmxhZyA9IDA7CisJfQorfQorCit1OCBtZWdhc2FzX2dldF9i
ZXN0X2FybShzdHJ1Y3QgTERfTE9BRF9CQUxBTkNFX0lORk8gKmxiSW5mbywgdTggYXJtLCB1NjQg
YmxvY2ssCisJCQl1MzIgY291bnQpCit7CisJdTE2ICAgICBwZW5kMCwgcGVuZDE7CisJdTY0ICAg
ICBkaWZmMCwgZGlmZjE7CisJdTggICAgICBiZXN0QXJtOworCisJLyogZ2V0IHRoZSBwZW5kaW5n
IGNtZHMgZm9yIHRoZSBkYXRhIGFuZCBtaXJyb3IgYXJtcyAqLworCXBlbmQwID0gYXRvbWljX3Jl
YWQoJmxiSW5mby0+c2NzaV9wZW5kaW5nX2NtZHNbMF0pOworCXBlbmQxID0gYXRvbWljX3JlYWQo
JmxiSW5mby0+c2NzaV9wZW5kaW5nX2NtZHNbMV0pOworCisJLyogRGV0ZXJtaW5lIHRoZSBkaXNr
IHdob3NlIGhlYWQgaXMgbmVhcmVyIHRvIHRoZSByZXEuIGJsb2NrICovCisJZGlmZjAgPSBBQlNf
RElGRihibG9jaywgbGJJbmZvLT5sYXN0X2FjY2Vzc2VkX2Jsb2NrWzBdKTsKKwlkaWZmMSA9IEFC
U19ESUZGKGJsb2NrLCBsYkluZm8tPmxhc3RfYWNjZXNzZWRfYmxvY2tbMV0pOworCWJlc3RBcm0g
PSAoZGlmZjAgPD0gZGlmZjEgPyAwIDogMSk7CisKKwlpZiAoKGJlc3RBcm0gPT0gYXJtICYmIHBl
bmQwID4gcGVuZDEgKyAxNikgIHx8CisJICAgIChiZXN0QXJtICE9IGFybSAmJiBwZW5kMSA+IHBl
bmQwICsgMTYpKQorCQliZXN0QXJtIF49IDE7CisKKwkvKiBVcGRhdGUgdGhlIGxhc3QgYWNjZXNz
ZWQgYmxvY2sgb24gdGhlIGNvcnJlY3QgcGQgKi8KKwlsYkluZm8tPmxhc3RfYWNjZXNzZWRfYmxv
Y2tbYmVzdEFybV0gPSBibG9jayArIGNvdW50IC0gMTsKKworCXJldHVybiBiZXN0QXJtOworfQor
Cit1MTYgZ2V0X3VwZGF0ZWRfZGV2X2hhbmRsZShzdHJ1Y3QgTERfTE9BRF9CQUxBTkNFX0lORk8g
KmxiSW5mbywKKwkJCSAgIHN0cnVjdCBJT19SRVFVRVNUX0lORk8gKmlvX2luZm8pCit7CisJdTgg
YXJtLCBvbGRfYXJtOworCXUxNiBkZXZIYW5kbGU7CisKKwlvbGRfYXJtID0gbGJJbmZvLT5yYWlk
MURldkhhbmRsZVswXSA9PSBpb19pbmZvLT5kZXZIYW5kbGUgPyAwIDogMTsKKworCS8qIGdldCBi
ZXN0IG5ldyBhcm0gKi8KKwlhcm0gID0gbWVnYXNhc19nZXRfYmVzdF9hcm0obGJJbmZvLCBvbGRf
YXJtLCBpb19pbmZvLT5sZFN0YXJ0QmxvY2ssCisJCQkJICAgIGlvX2luZm8tPm51bUJsb2Nrcyk7
CisJZGV2SGFuZGxlID0gbGJJbmZvLT5yYWlkMURldkhhbmRsZVthcm1dOworCWF0b21pY19pbmMo
JmxiSW5mby0+c2NzaV9wZW5kaW5nX2NtZHNbYXJtXSk7CisKKwlyZXR1cm4gZGV2SGFuZGxlOwor
fQpkaWZmIC1OYXVyIGxpbnV4LTIuNi4zNy1yYzUub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfZnVzaW9uLmMgbGludXgtMi42LjM3LXJjNS5uZXcvZHJpdmVycy9zY3NpL21l
Z2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uYwotLS0gbGludXgtMi42LjM3LXJjNS5vbGQvZHJp
dmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uYwkxOTY5LTEyLTMxIDE2OjAw
OjAwLjAwMDAwMDAwMCAtMDgwMAorKysgbGludXgtMi42LjM3LXJjNS5uZXcvZHJpdmVycy9zY3Np
L21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uYwkyMDEwLTEyLTIxIDExOjA0OjA2LjAwMDAw
MDAwMCAtMDgwMApAQCAtMCwwICsxLDIyNTAgQEAKKy8qCisgKiAgTGludXggTWVnYVJBSUQgZHJp
dmVyIGZvciBTQVMgYmFzZWQgUkFJRCBjb250cm9sbGVycworICoKKyAqICBDb3B5cmlnaHQgKGMp
IDIwMDktMjAxMSAgTFNJIENvcnBvcmF0aW9uLgorICoKKyAqICBUaGlzIHByb2dyYW0gaXMgZnJl
ZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29yCisgKiAgbW9kaWZ5IGl0
IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGljIExpY2Vuc2UKKyAqICBh
cyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlvbjsgZWl0aGVyIHZlcnNp
b24gMgorICogIG9mIHRoZSBMaWNlbnNlLCBvciAoYXQgeW91ciBvcHRpb24pIGFueSBsYXRlciB2
ZXJzaW9uLgorICoKKyAqICBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0ZWQgaW4gdGhlIGhvcGUg
dGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwKKyAqICBidXQgV0lUSE9VVCBBTlkgV0FSUkFOVFk7IHdp
dGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgorICogIE1FUkNIQU5UQUJJTElUWSBv
ciBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0aGUKKyAqICBHTlUgR2Vu
ZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLgorICoKKyAqICBZb3Ugc2hvdWxk
IGhhdmUgcmVjZWl2ZWQgYSBjb3B5IG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZQor
ICogIGFsb25nIHdpdGggdGhpcyBwcm9ncmFtOyBpZiBub3QsIHdyaXRlIHRvIHRoZSBGcmVlIFNv
ZnR3YXJlCisgKiAgRm91bmRhdGlvbiwgSW5jLiwgNTkgVGVtcGxlIFBsYWNlLCBTdWl0ZSAzMzAs
IEJvc3RvbiwgTUEgMDIxMTEtMTMwNyBVU0EKKyAqCisgKiAgRklMRTogbWVnYXJhaWRfc2FzX2Z1
c2lvbi5jCisgKgorICogIEF1dGhvcnM6IExTSSBDb3Jwb3JhdGlvbgorICogICAgICAgICAgIFN1
bWFudCBQYXRybworICogICAgICAgICAgIEFkYW0gUmFkZm9yZCA8bGludXhyYWlkQGxzaS5jb20+
CisgKgorICogIFNlbmQgZmVlZGJhY2sgdG86IDxtZWdhcmFpZGxpbnV4QGxzaS5jb20+CisgKgor
ICogIE1haWwgdG86IExTSSBDb3Jwb3JhdGlvbiwgMTYyMSBCYXJiZXIgTGFuZSwgTWlscGl0YXMs
IENBIDk1MDM1CisgKiAgICAgQVRUTjogTGludXhyYWlkCisgKi8KKworI2luY2x1ZGUgPGxpbnV4
L2tlcm5lbC5oPgorI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+CisjaW5jbHVkZSA8bGludXgvcGNp
Lmg+CisjaW5jbHVkZSA8bGludXgvbGlzdC5oPgorI2luY2x1ZGUgPGxpbnV4L21vZHVsZXBhcmFt
Lmg+CisjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+CisjaW5jbHVkZSA8bGludXgvc3BpbmxvY2su
aD4KKyNpbmNsdWRlIDxsaW51eC9pbnRlcnJ1cHQuaD4KKyNpbmNsdWRlIDxsaW51eC9kZWxheS5o
PgorI2luY2x1ZGUgPGxpbnV4L3NtcF9sb2NrLmg+CisjaW5jbHVkZSA8bGludXgvdWlvLmg+Cisj
aW5jbHVkZSA8bGludXgvdWFjY2Vzcy5oPgorI2luY2x1ZGUgPGxpbnV4L2ZzLmg+CisjaW5jbHVk
ZSA8bGludXgvY29tcGF0Lmg+CisjaW5jbHVkZSA8bGludXgvYmxrZGV2Lmg+CisjaW5jbHVkZSA8
bGludXgvbXV0ZXguaD4KKyNpbmNsdWRlIDxsaW51eC9wb2xsLmg+CisKKyNpbmNsdWRlIDxzY3Np
L3Njc2kuaD4KKyNpbmNsdWRlIDxzY3NpL3Njc2lfY21uZC5oPgorI2luY2x1ZGUgPHNjc2kvc2Nz
aV9kZXZpY2UuaD4KKyNpbmNsdWRlIDxzY3NpL3Njc2lfaG9zdC5oPgorCisjaW5jbHVkZSAibWVn
YXJhaWRfc2FzX2Z1c2lvbi5oIgorI2luY2x1ZGUgIm1lZ2FyYWlkX3Nhcy5oIgorCitleHRlcm4g
dm9pZCBtZWdhc2FzX2ZyZWVfY21kcyhzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2Up
OworZXh0ZXJuIHN0cnVjdCBtZWdhc2FzX2NtZCAqbWVnYXNhc19nZXRfY21kKHN0cnVjdCBtZWdh
c2FzX2luc3RhbmNlCisJCQkJCSAgICppbnN0YW5jZSk7CitleHRlcm4gdm9pZAorbWVnYXNhc19j
b21wbGV0ZV9jbWQoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAorCQkgICAgIHN0
cnVjdCBtZWdhc2FzX2NtZCAqY21kLCB1OCBhbHRfc3RhdHVzKTsKK2ludCBtZWdhc2FzX2lzX2xk
aW8oc3RydWN0IHNjc2lfY21uZCAqY21kKTsKK2ludAord2FpdF9hbmRfcG9sbChzdHJ1Y3QgbWVn
YXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kKTsKKwordm9p
ZAorbWVnYXNhc19yZXR1cm5fY21kKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwg
c3RydWN0IG1lZ2FzYXNfY21kICpjbWQpOworaW50IG1lZ2FzYXNfYWxsb2NfY21kcyhzdHJ1Y3Qg
bWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpOworaW50CittZWdhc2FzX2NsZWFyX2ludHJfZnVz
aW9uKHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdzKTsKK2ludAorbWVn
YXNhc19pc3N1ZV9wb2xsZWQoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAorCQkg
ICAgIHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kKTsKKwordTgKK01SX0J1aWxkUmFpZENvbnRleHQo
c3RydWN0IElPX1JFUVVFU1RfSU5GTyAqaW9faW5mbywKKwkJICAgIHN0cnVjdCBSQUlEX0NPTlRF
WFQgKnBSQUlEX0NvbnRleHQsCisJCSAgICBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXAp
OwordTE2IE1SX1RhcmdldElkVG9MZEdldCh1MzIgbGRUZ3RJZCwgc3RydWN0IE1SX0ZXX1JBSURf
TUFQX0FMTCAqbWFwKTsKK3N0cnVjdCBNUl9MRF9SQUlEICpNUl9MZFJhaWRHZXQodTMyIGxkLCBz
dHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApOworCit1MTYgTVJfR2V0TERUZ3RJZCh1MzIg
bGQsIHN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKm1hcCk7Cit1OCBNUl9WYWxpZGF0ZU1hcElu
Zm8oc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwLAorCQkgICAgICBzdHJ1Y3QgTERfTE9B
RF9CQUxBTkNFX0lORk8gKmxiSW5mbyk7Cit1MTYgZ2V0X3VwZGF0ZWRfZGV2X2hhbmRsZShzdHJ1
Y3QgTERfTE9BRF9CQUxBTkNFX0lORk8gKmxiSW5mbywKKwkJCSAgIHN0cnVjdCBJT19SRVFVRVNU
X0lORk8gKmluX2luZm8pOworaW50IG1lZ2FzYXNfdHJhbnNpdGlvbl90b19yZWFkeShzdHJ1Y3Qg
bWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpOwordm9pZCBtZWdhcmFpZF9zYXNfa2lsbF9oYmEo
c3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKTsKKworZXh0ZXJuIHUzMiBtZWdhc2Fz
X2RiZ19sdmw7CisKKy8qKgorICogbWVnYXNhc19lbmFibGVfaW50cl9mdXNpb24gLQlFbmFibGVz
IGludGVycnVwdHMKKyAqIEByZWdzOgkJCU1GSSByZWdpc3RlciBzZXQKKyAqLwordm9pZAorbWVn
YXNhc19lbmFibGVfaW50cl9mdXNpb24oc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9t
ZW0gKnJlZ3MpCit7CisJd3JpdGVsKH5NRklfRlVTSU9OX0VOQUJMRV9JTlRFUlJVUFRfTUFTSywg
JihyZWdzKS0+b3V0Ym91bmRfaW50cl9tYXNrKTsKKworCS8qIER1bW15IHJlYWRsIHRvIGZvcmNl
IHBjaSBmbHVzaCAqLworCXJlYWRsKCZyZWdzLT5vdXRib3VuZF9pbnRyX21hc2spOworfQorCisv
KioKKyAqIG1lZ2FzYXNfZGlzYWJsZV9pbnRyX2Z1c2lvbiAtIERpc2FibGVzIGludGVycnVwdAor
ICogQHJlZ3M6CQkJIE1GSSByZWdpc3RlciBzZXQKKyAqLwordm9pZAorbWVnYXNhc19kaXNhYmxl
X2ludHJfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdzKQor
eworCXUzMiBtYXNrID0gMHhGRkZGRkZGRjsKKwl1MzIgc3RhdHVzOworCisJd3JpdGVsKG1hc2ss
ICZyZWdzLT5vdXRib3VuZF9pbnRyX21hc2spOworCS8qIER1bW15IHJlYWRsIHRvIGZvcmNlIHBj
aSBmbHVzaCAqLworCXN0YXR1cyA9IHJlYWRsKCZyZWdzLT5vdXRib3VuZF9pbnRyX21hc2spOwor
fQorCitpbnQKK21lZ2FzYXNfY2xlYXJfaW50cl9mdXNpb24oc3RydWN0IG1lZ2FzYXNfcmVnaXN0
ZXJfc2V0IF9faW9tZW0gKnJlZ3MpCit7CisJdTMyIHN0YXR1czsKKwkvKgorCSAqIENoZWNrIGlm
IGl0IGlzIG91ciBpbnRlcnJ1cHQKKwkgKi8KKwlzdGF0dXMgPSByZWFkbCgmcmVncy0+b3V0Ym91
bmRfaW50cl9zdGF0dXMpOworCisJaWYgKHN0YXR1cyAmIDEpIHsKKwkJd3JpdGVsKHN0YXR1cywg
JnJlZ3MtPm91dGJvdW5kX2ludHJfc3RhdHVzKTsKKwkJcmVhZGwoJnJlZ3MtPm91dGJvdW5kX2lu
dHJfc3RhdHVzKTsKKwkJcmV0dXJuIDE7CisJfQorCWlmICghKHN0YXR1cyAmIE1GSV9GVVNJT05f
RU5BQkxFX0lOVEVSUlVQVF9NQVNLKSkKKwkJcmV0dXJuIDA7CisKKwkvKgorCSAqIGR1bW15IHJl
YWQgdG8gZmx1c2ggUENJCisJICovCisJcmVhZGwoJnJlZ3MtPm91dGJvdW5kX2ludHJfc3RhdHVz
KTsKKworCXJldHVybiAxOworfQorCisvKioKKyAqIG1lZ2FzYXNfZ2V0X2NtZF9mdXNpb24gLQlH
ZXQgYSBjb21tYW5kIGZyb20gdGhlIGZyZWUgcG9vbAorICogQGluc3RhbmNlOgkJQWRhcHRlciBz
b2Z0IHN0YXRlCisgKgorICogUmV0dXJucyBhIGZyZWUgY29tbWFuZCBmcm9tIHRoZSBwb29sCisg
Ki8KK3N0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24gKm1lZ2FzYXNfZ2V0X2NtZF9mdXNpb24oc3Ry
dWN0IG1lZ2FzYXNfaW5zdGFuY2UKKwkJCQkJCSAgKmluc3RhbmNlKQoreworCXVuc2lnbmVkIGxv
bmcgZmxhZ3M7CisJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb24gPQorCQkoc3RydWN0IGZ1
c2lvbl9jb250ZXh0ICopaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKKwlzdHJ1Y3QgbWVnYXNhc19j
bWRfZnVzaW9uICpjbWQgPSBOVUxMOworCisJc3Bpbl9sb2NrX2lycXNhdmUoJmZ1c2lvbi0+Y21k
X3Bvb2xfbG9jaywgZmxhZ3MpOworCisJaWYgKCFsaXN0X2VtcHR5KCZmdXNpb24tPmNtZF9wb29s
KSkgeworCQljbWQgPSBsaXN0X2VudHJ5KCgmZnVzaW9uLT5jbWRfcG9vbCktPm5leHQsCisJCQkJ
IHN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24sIGxpc3QpOworCQlsaXN0X2RlbF9pbml0KCZjbWQt
Pmxpc3QpOworCX0gZWxzZSB7CisJCXByaW50ayhLRVJOX0VSUiAibWVnYXNhczogQ29tbWFuZCBw
b29sIChmdXNpb24pIGVtcHR5IVxuIik7CisJfQorCisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgm
ZnVzaW9uLT5jbWRfcG9vbF9sb2NrLCBmbGFncyk7CisJcmV0dXJuIGNtZDsKK30KKworLyoqCisg
KiBtZWdhc2FzX3JldHVybl9jbWRfZnVzaW9uIC0JUmV0dXJuIGEgY21kIHRvIGZyZWUgY29tbWFu
ZCBwb29sCisgKiBAaW5zdGFuY2U6CQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAqIEBjbWQ6CQlDb21t
YW5kIHBhY2tldCB0byBiZSByZXR1cm5lZCB0byBmcmVlIGNvbW1hbmQgcG9vbAorICovCitzdGF0
aWMgaW5saW5lIHZvaWQKK21lZ2FzYXNfcmV0dXJuX2NtZF9mdXNpb24oc3RydWN0IG1lZ2FzYXNf
aW5zdGFuY2UgKmluc3RhbmNlLAorCQkJICBzdHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9uICpjbWQp
Cit7CisJdW5zaWduZWQgbG9uZyBmbGFnczsKKwlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lv
biA9CisJCShzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKilpbnN0YW5jZS0+Y3RybF9jb250ZXh0Owor
CisJc3Bpbl9sb2NrX2lycXNhdmUoJmZ1c2lvbi0+Y21kX3Bvb2xfbG9jaywgZmxhZ3MpOworCisJ
Y21kLT5zY21kID0gTlVMTDsKKwljbWQtPnN5bmNfY21kX2lkeCA9ICh1MzIpVUxPTkdfTUFYOwor
CWxpc3RfYWRkX3RhaWwoJmNtZC0+bGlzdCwgJmZ1c2lvbi0+Y21kX3Bvb2wpOworCisJc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgmZnVzaW9uLT5jbWRfcG9vbF9sb2NrLCBmbGFncyk7Cit9CisKKy8q
KgorICogbWVnYXNhc190ZWFyZG93bl9mcmFtZV9wb29sX2Z1c2lvbiAtCURlc3Ryb3kgdGhlIGNt
ZCBmcmFtZSBETUEgcG9vbAorICogQGluc3RhbmNlOgkJCQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAq
Lworc3RhdGljIHZvaWQgbWVnYXNhc190ZWFyZG93bl9mcmFtZV9wb29sX2Z1c2lvbigKKwlzdHJ1
Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCit7CisJaW50IGk7CisJc3RydWN0IGZ1c2lv
bl9jb250ZXh0ICpmdXNpb24gPSBpbnN0YW5jZS0+Y3RybF9jb250ZXh0OworCisJdTE2IG1heF9j
bWQgPSBpbnN0YW5jZS0+bWF4X2Z3X2NtZHM7CisKKwlzdHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9u
ICpjbWQ7CisKKwlpZiAoIWZ1c2lvbi0+c2dfZG1hX3Bvb2wgfHwgIWZ1c2lvbi0+c2Vuc2VfZG1h
X3Bvb2wpIHsKKwkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBkbWEgcG9vbCBpcyBudWxsLiBT
RyBQb29sICVwLCAiCisJCSAgICAgICAic2Vuc2UgcG9vbCA6ICVwXG4iLCBmdXNpb24tPnNnX2Rt
YV9wb29sLAorCQkgICAgICAgZnVzaW9uLT5zZW5zZV9kbWFfcG9vbCk7CisJCXJldHVybjsKKwl9
CisKKwkvKgorCSAqIFJldHVybiBhbGwgZnJhbWVzIHRvIHBvb2wKKwkgKi8KKwlmb3IgKGkgPSAw
OyBpIDwgbWF4X2NtZDsgaSsrKSB7CisKKwkJY21kID0gZnVzaW9uLT5jbWRfbGlzdFtpXTsKKwor
CQlpZiAoY21kLT5zZ19mcmFtZSkKKwkJCXBjaV9wb29sX2ZyZWUoZnVzaW9uLT5zZ19kbWFfcG9v
bCwgY21kLT5zZ19mcmFtZSwKKwkJCQkgICAgICBjbWQtPnNnX2ZyYW1lX3BoeXNfYWRkcik7CisK
KwkJaWYgKGNtZC0+c2Vuc2UpCisJCQlwY2lfcG9vbF9mcmVlKGZ1c2lvbi0+c2Vuc2VfZG1hX3Bv
b2wsIGNtZC0+c2Vuc2UsCisJCQkJICAgICAgY21kLT5zZW5zZV9waHlzX2FkZHIpOworCX0KKwor
CS8qCisJICogTm93IGRlc3Ryb3kgdGhlIHBvb2wgaXRzZWxmCisJICovCisJcGNpX3Bvb2xfZGVz
dHJveShmdXNpb24tPnNnX2RtYV9wb29sKTsKKwlwY2lfcG9vbF9kZXN0cm95KGZ1c2lvbi0+c2Vu
c2VfZG1hX3Bvb2wpOworCisJZnVzaW9uLT5zZ19kbWFfcG9vbCA9IE5VTEw7CisJZnVzaW9uLT5z
ZW5zZV9kbWFfcG9vbCA9IE5VTEw7Cit9CisKKy8qKgorICogbWVnYXNhc19mcmVlX2NtZHNfZnVz
aW9uIC0JRnJlZSBhbGwgdGhlIGNtZHMgaW4gdGhlIGZyZWUgY21kIHBvb2wKKyAqIEBpbnN0YW5j
ZToJCUFkYXB0ZXIgc29mdCBzdGF0ZQorICovCit2b2lkCittZWdhc2FzX2ZyZWVfY21kc19mdXNp
b24oc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKQoreworCWludCBpOworCXN0cnVj
dCBmdXNpb25fY29udGV4dCAqZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKKworCXUz
MiBtYXhfY21kcywgcmVxX3N6LCByZXBseV9zeiwgaW9fZnJhbWVzX3N6OworCisKKwlyZXFfc3og
PSBmdXNpb24tPnJlcXVlc3RfYWxsb2Nfc3o7CisJcmVwbHlfc3ogPSBmdXNpb24tPnJlcGx5X2Fs
bG9jX3N6OworCWlvX2ZyYW1lc19zeiA9IGZ1c2lvbi0+aW9fZnJhbWVzX2FsbG9jX3N6OworCisJ
bWF4X2NtZHMgPSBpbnN0YW5jZS0+bWF4X2Z3X2NtZHM7CisKKwkvKiBGcmVlIGRlc2NyaXB0b3Jz
IGFuZCByZXF1ZXN0IEZyYW1lcyBtZW1vcnkgKi8KKwlpZiAoZnVzaW9uLT5yZXFfZnJhbWVzX2Rl
c2MpCisJCWRtYV9mcmVlX2NvaGVyZW50KCZpbnN0YW5jZS0+cGRldi0+ZGV2LCByZXFfc3osCisJ
CQkJICBmdXNpb24tPnJlcV9mcmFtZXNfZGVzYywKKwkJCQkgIGZ1c2lvbi0+cmVxX2ZyYW1lc19k
ZXNjX3BoeXMpOworCisJaWYgKGZ1c2lvbi0+cmVwbHlfZnJhbWVzX2Rlc2MpIHsKKwkJcGNpX3Bv
b2xfZnJlZShmdXNpb24tPnJlcGx5X2ZyYW1lc19kZXNjX3Bvb2wsCisJCQkgICAgICBmdXNpb24t
PnJlcGx5X2ZyYW1lc19kZXNjLAorCQkJICAgICAgZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzY19w
aHlzKTsKKwkJcGNpX3Bvb2xfZGVzdHJveShmdXNpb24tPnJlcGx5X2ZyYW1lc19kZXNjX3Bvb2wp
OworCX0KKworCWlmIChmdXNpb24tPmlvX3JlcXVlc3RfZnJhbWVzKSB7CisJCXBjaV9wb29sX2Zy
ZWUoZnVzaW9uLT5pb19yZXF1ZXN0X2ZyYW1lc19wb29sLAorCQkJICAgICAgZnVzaW9uLT5pb19y
ZXF1ZXN0X2ZyYW1lcywKKwkJCSAgICAgIGZ1c2lvbi0+aW9fcmVxdWVzdF9mcmFtZXNfcGh5cyk7
CisJCXBjaV9wb29sX2Rlc3Ryb3koZnVzaW9uLT5pb19yZXF1ZXN0X2ZyYW1lc19wb29sKTsKKwl9
CisKKwkvKiBGcmVlIHRoZSBGdXNpb24gZnJhbWUgcG9vbCAqLworCW1lZ2FzYXNfdGVhcmRvd25f
ZnJhbWVfcG9vbF9mdXNpb24oaW5zdGFuY2UpOworCisJLyogRnJlZSBhbGwgdGhlIGNvbW1hbmRz
IGluIHRoZSBjbWRfbGlzdCAqLworCWZvciAoaSA9IDA7IGkgPCBtYXhfY21kczsgaSsrKQorCQlr
ZnJlZShmdXNpb24tPmNtZF9saXN0W2ldKTsKKworCS8qIEZyZWUgdGhlIGNtZF9saXN0IGJ1ZmZl
ciBpdHNlbGYgKi8KKwlrZnJlZShmdXNpb24tPmNtZF9saXN0KTsKKwlmdXNpb24tPmNtZF9saXN0
ID0gTlVMTDsKKworCUlOSVRfTElTVF9IRUFEKCZmdXNpb24tPmNtZF9wb29sKTsKK30KKworLyoq
CisgKiBtZWdhc2FzX2NyZWF0ZV9mcmFtZV9wb29sX2Z1c2lvbiAtCUNyZWF0ZXMgRE1BIHBvb2wg
Zm9yIGNtZCBmcmFtZXMKKyAqIEBpbnN0YW5jZToJCQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAqCisg
Ki8KK3N0YXRpYyBpbnQgbWVnYXNhc19jcmVhdGVfZnJhbWVfcG9vbF9mdXNpb24oc3RydWN0IG1l
Z2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKQoreworCWludCBpOworCXUzMiBtYXhfY21kOworCXN0
cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uOworCXN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24g
KmNtZDsKKwl1MzIgdG90YWxfc3pfY2hhaW5fZnJhbWU7CisKKwlmdXNpb24gPSBpbnN0YW5jZS0+
Y3RybF9jb250ZXh0OworCW1heF9jbWQgPSBpbnN0YW5jZS0+bWF4X2Z3X2NtZHM7CisKKwl0b3Rh
bF9zel9jaGFpbl9mcmFtZSA9IE1FR0FTQVNfTUFYX1NaX0NIQUlOX0ZSQU1FOworCisJLyoKKwkg
KiBVc2UgRE1BIHBvb2wgZmFjaWxpdHkgcHJvdmlkZWQgYnkgUENJIGxheWVyCisJICovCisKKwlm
dXNpb24tPnNnX2RtYV9wb29sID0gcGNpX3Bvb2xfY3JlYXRlKCJtZWdhc2FzIHNnIHBvb2wgZnVz
aW9uIiwKKwkJCQkJICAgICAgaW5zdGFuY2UtPnBkZXYsCisJCQkJCSAgICAgIHRvdGFsX3N6X2No
YWluX2ZyYW1lLCA0LAorCQkJCQkgICAgICAwKTsKKwlpZiAoIWZ1c2lvbi0+c2dfZG1hX3Bvb2wp
IHsKKwkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IGZhaWxlZCB0byBzZXR1cCByZXF1ZXN0
IHBvb2wgIgorCQkgICAgICAgImZ1c2lvblxuIik7CisJCXJldHVybiAtRU5PTUVNOworCX0KKwlm
dXNpb24tPnNlbnNlX2RtYV9wb29sID0gcGNpX3Bvb2xfY3JlYXRlKCJtZWdhc2FzIHNlbnNlIHBv
b2wgZnVzaW9uIiwKKwkJCQkJCSBpbnN0YW5jZS0+cGRldiwKKwkJCQkJCSBTQ1NJX1NFTlNFX0JV
RkZFUlNJWkUsIDY0LCAwKTsKKworCWlmICghZnVzaW9uLT5zZW5zZV9kbWFfcG9vbCkgeworCQlw
cmludGsoS0VSTl9ERUJVRyAibWVnYXNhczogZmFpbGVkIHRvIHNldHVwIHNlbnNlIHBvb2wgIgor
CQkgICAgICAgImZ1c2lvblxuIik7CisJCXBjaV9wb29sX2Rlc3Ryb3koZnVzaW9uLT5zZ19kbWFf
cG9vbCk7CisJCWZ1c2lvbi0+c2dfZG1hX3Bvb2wgPSBOVUxMOworCQlyZXR1cm4gLUVOT01FTTsK
Kwl9CisKKwkvKgorCSAqIEFsbG9jYXRlIGFuZCBhdHRhY2ggYSBmcmFtZSB0byBlYWNoIG9mIHRo
ZSBjb21tYW5kcyBpbiBjbWRfbGlzdAorCSAqLworCWZvciAoaSA9IDA7IGkgPCBtYXhfY21kOyBp
KyspIHsKKworCQljbWQgPSBmdXNpb24tPmNtZF9saXN0W2ldOworCisJCWNtZC0+c2dfZnJhbWUg
PSBwY2lfcG9vbF9hbGxvYyhmdXNpb24tPnNnX2RtYV9wb29sLAorCQkJCQkgICAgICAgR0ZQX0tF
Uk5FTCwKKwkJCQkJICAgICAgICZjbWQtPnNnX2ZyYW1lX3BoeXNfYWRkcik7CisKKwkJY21kLT5z
ZW5zZSA9IHBjaV9wb29sX2FsbG9jKGZ1c2lvbi0+c2Vuc2VfZG1hX3Bvb2wsCisJCQkJCSAgICBH
RlBfS0VSTkVMLCAmY21kLT5zZW5zZV9waHlzX2FkZHIpOworCQkvKgorCQkgKiBtZWdhc2FzX3Rl
YXJkb3duX2ZyYW1lX3Bvb2xfZnVzaW9uKCkgdGFrZXMgY2FyZSBvZiBmcmVlaW5nCisJCSAqIHdo
YXRldmVyIGhhcyBiZWVuIGFsbG9jYXRlZAorCQkgKi8KKwkJaWYgKCFjbWQtPnNnX2ZyYW1lIHx8
ICFjbWQtPnNlbnNlKSB7CisJCQlwcmludGsoS0VSTl9ERUJVRyAibWVnYXNhczogcGNpX3Bvb2xf
YWxsb2MgZmFpbGVkXG4iKTsKKwkJCW1lZ2FzYXNfdGVhcmRvd25fZnJhbWVfcG9vbF9mdXNpb24o
aW5zdGFuY2UpOworCQkJcmV0dXJuIC1FTk9NRU07CisJCX0KKwl9CisJcmV0dXJuIDA7Cit9CisK
Ky8qKgorICogbWVnYXNhc19hbGxvY19jbWRzX2Z1c2lvbiAtCUFsbG9jYXRlcyB0aGUgY29tbWFu
ZCBwYWNrZXRzCisgKiBAaW5zdGFuY2U6CQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAqCisgKgorICog
RWFjaCBmcmFtZSBoYXMgYSAzMi1iaXQgZmllbGQgY2FsbGVkIGNvbnRleHQuIFRoaXMgY29udGV4
dCBpcyB1c2VkIHRvIGdldAorICogYmFjayB0aGUgbWVnYXNhc19jbWRfZnVzaW9uIGZyb20gdGhl
IGZyYW1lIHdoZW4gYSBmcmFtZSBnZXRzIGNvbXBsZXRlZAorICogSW4gdGhpcyBkcml2ZXIsIHRo
ZSAzMiBiaXQgdmFsdWVzIGFyZSB0aGUgaW5kaWNlcyBpbnRvIGFuIGFycmF5IGNtZF9saXN0Lgor
ICogVGhpcyBhcnJheSBpcyB1c2VkIG9ubHkgdG8gbG9vayB1cCB0aGUgbWVnYXNhc19jbWRfZnVz
aW9uIGdpdmVuIHRoZSBjb250ZXh0LgorICogVGhlIGZyZWUgY29tbWFuZHMgdGhlbXNlbHZlcyBh
cmUgbWFpbnRhaW5lZCBpbiBhIGxpbmtlZCBsaXN0IGNhbGxlZCBjbWRfcG9vbC4KKyAqCisgKiBj
bWRzIGFyZSBmb3JtZWQgaW4gdGhlIGlvX3JlcXVlc3QgYW5kIHNnX2ZyYW1lIG1lbWJlcnMgb2Yg
dGhlCisgKiBtZWdhc2FzX2NtZF9mdXNpb24uIFRoZSBjb250ZXh0IGZpZWxkIGlzIHVzZWQgdG8g
Z2V0IGEgcmVxdWVzdCBkZXNjcmlwdG9yCisgKiBhbmQgaXMgdXNlZCBhcyBTTUlEIG9mIHRoZSBj
bWQuCisgKiBTTUlEIHZhbHVlIHJhbmdlIGlzIGZyb20gMSB0byBtYXhfZndfY21kcy4KKyAqLwor
aW50CittZWdhc2FzX2FsbG9jX2NtZHNfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICpp
bnN0YW5jZSkKK3sKKwlpbnQgaSwgajsKKwl1MzIgbWF4X2NtZCwgaW9fZnJhbWVzX3N6OworCXN0
cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uOworCXN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24g
KmNtZDsKKwl1bmlvbiBNUEkyX1JFUExZX0RFU0NSSVBUT1JTX1VOSU9OICpyZXBseV9kZXNjOwor
CXUzMiBvZmZzZXQ7CisJZG1hX2FkZHJfdCBpb19yZXFfYmFzZV9waHlzOworCXU4ICppb19yZXFf
YmFzZTsKKworCWZ1c2lvbiA9IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CisKKwltYXhfY21kID0g
aW5zdGFuY2UtPm1heF9md19jbWRzOworCisJZnVzaW9uLT5yZXFfZnJhbWVzX2Rlc2MgPQorCQlk
bWFfYWxsb2NfY29oZXJlbnQoJmluc3RhbmNlLT5wZGV2LT5kZXYsCisJCQkJICAgZnVzaW9uLT5y
ZXF1ZXN0X2FsbG9jX3N6LAorCQkJCSAgICZmdXNpb24tPnJlcV9mcmFtZXNfZGVzY19waHlzLCBH
RlBfS0VSTkVMKTsKKworCWlmICghZnVzaW9uLT5yZXFfZnJhbWVzX2Rlc2MpIHsKKwkJcHJpbnRr
KEtFUk5fRVJSICJtZWdhc2FzOyBDb3VsZCBub3QgYWxsb2NhdGUgbWVtb3J5IGZvciAiCisJCSAg
ICAgICAicmVxdWVzdF9mcmFtZXNcbiIpOworCQlnb3RvIGZhaWxfcmVxX2Rlc2M7CisJfQorCisJ
ZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzY19wb29sID0KKwkJcGNpX3Bvb2xfY3JlYXRlKCJyZXBs
eV9mcmFtZXMgcG9vbCIsIGluc3RhbmNlLT5wZGV2LAorCQkJCWZ1c2lvbi0+cmVwbHlfYWxsb2Nf
c3osIDE2LCAwKTsKKworCWlmICghZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzY19wb29sKSB7CisJ
CXByaW50ayhLRVJOX0VSUiAibWVnYXNhczsgQ291bGQgbm90IGFsbG9jYXRlIG1lbW9yeSBmb3Ig
IgorCQkgICAgICAgInJlcGx5X2ZyYW1lIHBvb2xcbiIpOworCQlnb3RvIGZhaWxfcmVwbHlfZGVz
YzsKKwl9CisKKwlmdXNpb24tPnJlcGx5X2ZyYW1lc19kZXNjID0KKwkJcGNpX3Bvb2xfYWxsb2Mo
ZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzY19wb29sLCBHRlBfS0VSTkVMLAorCQkJICAgICAgICZm
dXNpb24tPnJlcGx5X2ZyYW1lc19kZXNjX3BoeXMpOworCWlmICghZnVzaW9uLT5yZXBseV9mcmFt
ZXNfZGVzYykgeworCQlwcmludGsoS0VSTl9FUlIgIm1lZ2FzYXM7IENvdWxkIG5vdCBhbGxvY2F0
ZSBtZW1vcnkgZm9yICIKKwkJICAgICAgICJyZXBseV9mcmFtZSBwb29sXG4iKTsKKwkJcGNpX3Bv
b2xfZGVzdHJveShmdXNpb24tPnJlcGx5X2ZyYW1lc19kZXNjX3Bvb2wpOworCQlnb3RvIGZhaWxf
cmVwbHlfZGVzYzsKKwl9CisKKwlyZXBseV9kZXNjID0gZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVz
YzsKKwlmb3IgKGkgPSAwOyBpIDwgZnVzaW9uLT5yZXBseV9xX2RlcHRoOyBpKyssIHJlcGx5X2Rl
c2MrKykKKwkJcmVwbHlfZGVzYy0+V29yZHMgPSBVTExPTkdfTUFYOworCisJaW9fZnJhbWVzX3N6
ID0gZnVzaW9uLT5pb19mcmFtZXNfYWxsb2Nfc3o7CisKKwlmdXNpb24tPmlvX3JlcXVlc3RfZnJh
bWVzX3Bvb2wgPQorCQlwY2lfcG9vbF9jcmVhdGUoImlvX3JlcXVlc3RfZnJhbWVzIHBvb2wiLCBp
bnN0YW5jZS0+cGRldiwKKwkJCQlmdXNpb24tPmlvX2ZyYW1lc19hbGxvY19zeiwgMTYsIDApOwor
CisJaWYgKCFmdXNpb24tPmlvX3JlcXVlc3RfZnJhbWVzX3Bvb2wpIHsKKwkJcHJpbnRrKEtFUk5f
RVJSICJtZWdhc2FzOiBDb3VsZCBub3QgYWxsb2NhdGUgbWVtb3J5IGZvciAiCisJCSAgICAgICAi
aW9fcmVxdWVzdF9mcmFtZSBwb29sXG4iKTsKKwkJZ290byBmYWlsX2lvX2ZyYW1lczsKKwl9CisK
KwlmdXNpb24tPmlvX3JlcXVlc3RfZnJhbWVzID0KKwkJcGNpX3Bvb2xfYWxsb2MoZnVzaW9uLT5p
b19yZXF1ZXN0X2ZyYW1lc19wb29sLCBHRlBfS0VSTkVMLAorCQkJICAgICAgICZmdXNpb24tPmlv
X3JlcXVlc3RfZnJhbWVzX3BoeXMpOworCWlmICghZnVzaW9uLT5pb19yZXF1ZXN0X2ZyYW1lcykg
eworCQlwcmludGsoS0VSTl9FUlIgIm1lZ2FzYXM6IENvdWxkIG5vdCBhbGxvY2F0ZSBtZW1vcnkg
Zm9yICIKKwkJICAgICAgICJpb19yZXF1ZXN0X2ZyYW1lcyBmcmFtZXNcbiIpOworCQlwY2lfcG9v
bF9kZXN0cm95KGZ1c2lvbi0+aW9fcmVxdWVzdF9mcmFtZXNfcG9vbCk7CisJCWdvdG8gZmFpbF9p
b19mcmFtZXM7CisJfQorCisJLyoKKwkgKiBmdXNpb24tPmNtZF9saXN0IGlzIGFuIGFycmF5IG9m
IHN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24gcG9pbnRlcnMuCisJICogQWxsb2NhdGUgdGhlIGR5
bmFtaWMgYXJyYXkgZmlyc3QgYW5kIHRoZW4gYWxsb2NhdGUgaW5kaXZpZHVhbAorCSAqIGNvbW1h
bmRzLgorCSAqLworCWZ1c2lvbi0+Y21kX2xpc3QgPSBrbWFsbG9jKHNpemVvZihzdHJ1Y3QgbWVn
YXNhc19jbWRfZnVzaW9uICopCisJCQkJICAgKm1heF9jbWQsIEdGUF9LRVJORUwpOworCisJaWYg
KCFmdXNpb24tPmNtZF9saXN0KSB7CisJCXByaW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBvdXQg
b2YgbWVtb3J5LiBDb3VsZCBub3QgYWxsb2MgIgorCQkgICAgICAgIm1lbW9yeSBmb3IgY21kX2xp
c3RfZnVzaW9uXG4iKTsKKwkJZ290byBmYWlsX2NtZF9saXN0OworCX0KKworCW1lbXNldChmdXNp
b24tPmNtZF9saXN0LCAwLCBzaXplb2Yoc3RydWN0IG1lZ2FzYXNfY21kX2Z1c2lvbiAqKQorCSAg
ICAgICAqbWF4X2NtZCk7CisKKwltYXhfY21kID0gaW5zdGFuY2UtPm1heF9md19jbWRzOworCWZv
ciAoaSA9IDA7IGkgPCBtYXhfY21kOyBpKyspIHsKKwkJZnVzaW9uLT5jbWRfbGlzdFtpXSA9IGtt
YWxsb2Moc2l6ZW9mKHN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24pLAorCQkJCQkgICAgICBHRlBf
S0VSTkVMKTsKKwkJaWYgKCFmdXNpb24tPmNtZF9saXN0W2ldKSB7CisJCQlwcmludGsoS0VSTl9F
UlIgIkNvdWxkIG5vdCBhbGxvYyBjbWQgbGlzdCBmdXNpb25cbiIpOworCisJCQlmb3IgKGogPSAw
OyBqIDwgaTsgaisrKQorCQkJCWtmcmVlKGZ1c2lvbi0+Y21kX2xpc3Rbal0pOworCisJCQlrZnJl
ZShmdXNpb24tPmNtZF9saXN0KTsKKwkJCWZ1c2lvbi0+Y21kX2xpc3QgPSBOVUxMOworCQkJZ290
byBmYWlsX2NtZF9saXN0OworCQl9CisJfQorCisJLyogVGhlIGZpcnN0IDI1NiBieXRlcyAoU01J
RCAwKSBpcyBub3QgdXNlZC4gRG9uJ3QgYWRkIHRvIGNtZCBsaXN0ICovCisJaW9fcmVxX2Jhc2Ug
PSBmdXNpb24tPmlvX3JlcXVlc3RfZnJhbWVzICsKKwkJTUVHQV9NUEkyX1JBSURfREVGQVVMVF9J
T19GUkFNRV9TSVpFOworCWlvX3JlcV9iYXNlX3BoeXMgPSBmdXNpb24tPmlvX3JlcXVlc3RfZnJh
bWVzX3BoeXMgKworCQlNRUdBX01QSTJfUkFJRF9ERUZBVUxUX0lPX0ZSQU1FX1NJWkU7CisKKwkv
KgorCSAqIEFkZCBhbGwgdGhlIGNvbW1hbmRzIHRvIGNvbW1hbmQgcG9vbCAoZnVzaW9uLT5jbWRf
cG9vbCkKKwkgKi8KKworCS8qIFNNSUQgMCBpcyByZXNlcnZlZC4gU2V0IFNNSUQvaW5kZXggZnJv
bSAxICovCisJZm9yIChpID0gMDsgaSA8IG1heF9jbWQ7IGkrKykgeworCQljbWQgPSBmdXNpb24t
PmNtZF9saXN0W2ldOworCQlvZmZzZXQgPSBNRUdBX01QSTJfUkFJRF9ERUZBVUxUX0lPX0ZSQU1F
X1NJWkUgKiBpOworCQltZW1zZXQoY21kLCAwLCBzaXplb2Yoc3RydWN0IG1lZ2FzYXNfY21kX2Z1
c2lvbikpOworCQljbWQtPmluZGV4ID0gaSArIDE7CisJCWNtZC0+c2NtZCA9IE5VTEw7CisJCWNt
ZC0+c3luY19jbWRfaWR4ID0gKHUzMilVTE9OR19NQVg7IC8qIFNldCB0byBJbnZhbGlkICovCisJ
CWNtZC0+aW5zdGFuY2UgPSBpbnN0YW5jZTsKKwkJY21kLT5pb19yZXF1ZXN0ID0KKwkJCShzdHJ1
Y3QgTVBJMl9SQUlEX1NDU0lfSU9fUkVRVUVTVCAqKQorCQkgIChpb19yZXFfYmFzZSArIG9mZnNl
dCk7CisJCW1lbXNldChjbWQtPmlvX3JlcXVlc3QsIDAsCisJCSAgICAgICBzaXplb2Yoc3RydWN0
IE1QSTJfUkFJRF9TQ1NJX0lPX1JFUVVFU1QpKTsKKwkJY21kLT5pb19yZXF1ZXN0X3BoeXNfYWRk
ciA9IGlvX3JlcV9iYXNlX3BoeXMgKyBvZmZzZXQ7CisKKwkJbGlzdF9hZGRfdGFpbCgmY21kLT5s
aXN0LCAmZnVzaW9uLT5jbWRfcG9vbCk7CisJfQorCisJLyoKKwkgKiBDcmVhdGUgYSBmcmFtZSBw
b29sIGFuZCBhc3NpZ24gb25lIGZyYW1lIHRvIGVhY2ggY21kCisJICovCisJaWYgKG1lZ2FzYXNf
Y3JlYXRlX2ZyYW1lX3Bvb2xfZnVzaW9uKGluc3RhbmNlKSkgeworCQlwcmludGsoS0VSTl9ERUJV
RyAibWVnYXNhczogRXJyb3IgY3JlYXRpbmcgZnJhbWUgRE1BIHBvb2xcbiIpOworCQltZWdhc2Fz
X2ZyZWVfY21kc19mdXNpb24oaW5zdGFuY2UpOworCQlnb3RvIGZhaWxfcmVxX2Rlc2M7CisJfQor
CisJcmV0dXJuIDA7CisKK2ZhaWxfY21kX2xpc3Q6CisJcGNpX3Bvb2xfZnJlZShmdXNpb24tPmlv
X3JlcXVlc3RfZnJhbWVzX3Bvb2wsIGZ1c2lvbi0+aW9fcmVxdWVzdF9mcmFtZXMsCisJCSAgICAg
IGZ1c2lvbi0+aW9fcmVxdWVzdF9mcmFtZXNfcGh5cyk7CisJcGNpX3Bvb2xfZGVzdHJveShmdXNp
b24tPmlvX3JlcXVlc3RfZnJhbWVzX3Bvb2wpOworZmFpbF9pb19mcmFtZXM6CisJZG1hX2ZyZWVf
Y29oZXJlbnQoJmluc3RhbmNlLT5wZGV2LT5kZXYsIGZ1c2lvbi0+cmVxdWVzdF9hbGxvY19zeiwK
KwkJCSAgZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzYywKKwkJCSAgZnVzaW9uLT5yZXBseV9mcmFt
ZXNfZGVzY19waHlzKTsKKwlwY2lfcG9vbF9mcmVlKGZ1c2lvbi0+cmVwbHlfZnJhbWVzX2Rlc2Nf
cG9vbCwKKwkJICAgICAgZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzYywKKwkJICAgICAgZnVzaW9u
LT5yZXBseV9mcmFtZXNfZGVzY19waHlzKTsKKwlwY2lfcG9vbF9kZXN0cm95KGZ1c2lvbi0+cmVw
bHlfZnJhbWVzX2Rlc2NfcG9vbCk7CisKK2ZhaWxfcmVwbHlfZGVzYzoKKwlkbWFfZnJlZV9jb2hl
cmVudCgmaW5zdGFuY2UtPnBkZXYtPmRldiwgZnVzaW9uLT5yZXF1ZXN0X2FsbG9jX3N6LAorCQkJ
ICBmdXNpb24tPnJlcV9mcmFtZXNfZGVzYywKKwkJCSAgZnVzaW9uLT5yZXFfZnJhbWVzX2Rlc2Nf
cGh5cyk7CitmYWlsX3JlcV9kZXNjOgorCXJldHVybiAtRU5PTUVNOworfQorCisvKioKKyAqIHdh
aXRfYW5kX3BvbGwgLQlJc3N1ZXMgYSBwb2xsaW5nIGNvbW1hbmQKKyAqIEBpbnN0YW5jZToJCQlB
ZGFwdGVyIHNvZnQgc3RhdGUKKyAqIEBjbWQ6CQkJQ29tbWFuZCBwYWNrZXQgdG8gYmUgaXNzdWVk
CisgKgorICogRm9yIHBvbGxpbmcsIE1GSSByZXF1aXJlcyB0aGUgY21kX3N0YXR1cyB0byBiZSBz
ZXQgdG8gMHhGRiBiZWZvcmUgcG9zdGluZy4KKyAqLworaW50Cit3YWl0X2FuZF9wb2xsKHN0cnVj
dCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwgc3RydWN0IG1lZ2FzYXNfY21kICpjbWQpCit7
CisJaW50IGk7CisJc3RydWN0IG1lZ2FzYXNfaGVhZGVyICpmcmFtZV9oZHIgPSAmY21kLT5mcmFt
ZS0+aGRyOworCisJdTMyIG1zZWNzID0gTUZJX1BPTExfVElNRU9VVF9TRUNTICogMTAwMDsKKwor
CS8qCisJICogV2FpdCBmb3IgY21kX3N0YXR1cyB0byBjaGFuZ2UKKwkgKi8KKwlmb3IgKGkgPSAw
OyAoaSA8IG1zZWNzKSAmJiAoZnJhbWVfaGRyLT5jbWRfc3RhdHVzID09IDB4ZmYpOyBpICs9IDIw
KSB7CisJCXJtYigpOworCQltc2xlZXAoMjApOworCX0KKworCWlmIChmcmFtZV9oZHItPmNtZF9z
dGF0dXMgPT0gMHhmZikKKwkJcmV0dXJuIC1FVElNRTsKKworCXJldHVybiAwOworfQorCisvKioK
KyAqIG1lZ2FzYXNfaW9jX2luaXRfZnVzaW9uIC0JSW5pdGlhbGl6ZXMgdGhlIEZXCisgKiBAaW5z
dGFuY2U6CQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAqCisgKiBJc3N1ZXMgdGhlIElPQyBJbml0IGNt
ZAorICovCitpbnQKK21lZ2FzYXNfaW9jX2luaXRfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX2luc3Rh
bmNlICppbnN0YW5jZSkKK3sKKwlzdHJ1Y3QgbWVnYXNhc19pbml0X2ZyYW1lICppbml0X2ZyYW1l
OworCXN0cnVjdCBNUEkyX0lPQ19JTklUX1JFUVVFU1QgKklPQ0luaXRNZXNzYWdlOworCWRtYV9h
ZGRyX3QJaW9jX2luaXRfaGFuZGxlOworCXUzMiBjb250ZXh0OworCXN0cnVjdCBtZWdhc2FzX2Nt
ZCAqY21kOworCXU4IHJldDsKKwlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lvbjsKKwl1bmlv
biBNRUdBU0FTX1JFUVVFU1RfREVTQ1JJUFRPUl9VTklPTiAqcmVxX2Rlc2M7CisJaW50IGk7CisJ
c3RydWN0IG1lZ2FzYXNfaGVhZGVyICpmcmFtZV9oZHI7CisKKwlmdXNpb24gPSBpbnN0YW5jZS0+
Y3RybF9jb250ZXh0OworCisJY21kID0gbWVnYXNhc19nZXRfY21kKGluc3RhbmNlKTsKKworCWlm
ICghY21kKSB7CisJCXByaW50ayhLRVJOX0VSUiAiQ291bGQgbm90IGFsbG9jYXRlIGNtZCBmb3Ig
SU5JVCBGcmFtZVxuIik7CisJCXJldCA9IDE7CisJCWdvdG8gZmFpbF9nZXRfY21kOworCX0KKwor
CUlPQ0luaXRNZXNzYWdlID0KKwkgIGRtYV9hbGxvY19jb2hlcmVudCgmaW5zdGFuY2UtPnBkZXYt
PmRldiwKKwkJCSAgICAgc2l6ZW9mKHN0cnVjdCBNUEkyX0lPQ19JTklUX1JFUVVFU1QpLAorCQkJ
ICAgICAmaW9jX2luaXRfaGFuZGxlLCBHRlBfS0VSTkVMKTsKKworCWlmICghSU9DSW5pdE1lc3Nh
Z2UpIHsKKwkJcHJpbnRrKEtFUk5fRVJSICJDb3VsZCBub3QgYWxsb2NhdGUgbWVtb3J5IGZvciAi
CisJCSAgICAgICAiSU9DSW5pdE1lc3NhZ2VcbiIpOworCQlyZXQgPSAxOworCQlnb3RvIGZhaWxf
ZndfaW5pdDsKKwl9CisKKwltZW1zZXQoSU9DSW5pdE1lc3NhZ2UsIDAsIHNpemVvZihzdHJ1Y3Qg
TVBJMl9JT0NfSU5JVF9SRVFVRVNUKSk7CisKKwlJT0NJbml0TWVzc2FnZS0+RnVuY3Rpb24gPSBN
UEkyX0ZVTkNUSU9OX0lPQ19JTklUOworCUlPQ0luaXRNZXNzYWdlLT5XaG9Jbml0CT0gTVBJMl9X
SE9JTklUX0hPU1RfRFJJVkVSOworCUlPQ0luaXRNZXNzYWdlLT5Nc2dWZXJzaW9uID0gTVBJMl9W
RVJTSU9OOworCUlPQ0luaXRNZXNzYWdlLT5IZWFkZXJWZXJzaW9uID0gTVBJMl9IRUFERVJfVkVS
U0lPTjsKKwlJT0NJbml0TWVzc2FnZS0+U3lzdGVtUmVxdWVzdEZyYW1lU2l6ZSA9CisJCU1FR0Ff
TVBJMl9SQUlEX0RFRkFVTFRfSU9fRlJBTUVfU0laRSAvIDQ7CisKKwlJT0NJbml0TWVzc2FnZS0+
UmVwbHlEZXNjcmlwdG9yUG9zdFF1ZXVlRGVwdGggPSBmdXNpb24tPnJlcGx5X3FfZGVwdGg7CisJ
SU9DSW5pdE1lc3NhZ2UtPlJlcGx5RGVzY3JpcHRvclBvc3RRdWV1ZUFkZHJlc3MJPQorCQlmdXNp
b24tPnJlcGx5X2ZyYW1lc19kZXNjX3BoeXM7CisJSU9DSW5pdE1lc3NhZ2UtPlN5c3RlbVJlcXVl
c3RGcmFtZUJhc2VBZGRyZXNzID0KKwkJZnVzaW9uLT5pb19yZXF1ZXN0X2ZyYW1lc19waHlzOwor
CisJaW5pdF9mcmFtZSA9IChzdHJ1Y3QgbWVnYXNhc19pbml0X2ZyYW1lICopY21kLT5mcmFtZTsK
KwltZW1zZXQoaW5pdF9mcmFtZSwgMCwgTUVHQU1GSV9GUkFNRV9TSVpFKTsKKworCWZyYW1lX2hk
ciA9ICZjbWQtPmZyYW1lLT5oZHI7CisJY29udGV4dCA9IGluaXRfZnJhbWUtPmNvbnRleHQ7CisJ
aW5pdF9mcmFtZS0+Y29udGV4dCA9IGNvbnRleHQ7CisKKwlmcmFtZV9oZHItPmNtZF9zdGF0dXMg
PSAweEZGOworCWZyYW1lX2hkci0+ZmxhZ3MgfD0gTUZJX0ZSQU1FX0RPTlRfUE9TVF9JTl9SRVBM
WV9RVUVVRTsKKworCWluaXRfZnJhbWUtPmNtZAk9IE1GSV9DTURfSU5JVDsKKwlpbml0X2ZyYW1l
LT5jbWRfc3RhdHVzID0gMHhGRjsKKworCWluaXRfZnJhbWUtPnF1ZXVlX2luZm9fbmV3X3BoeXNf
YWRkcl9sbyA9IGlvY19pbml0X2hhbmRsZTsKKwlpbml0X2ZyYW1lLT5kYXRhX3hmZXJfbGVuID0g
c2l6ZW9mKHN0cnVjdCBNUEkyX0lPQ19JTklUX1JFUVVFU1QpOworCisJcmVxX2Rlc2MgPQorCSAg
KHVuaW9uIE1FR0FTQVNfUkVRVUVTVF9ERVNDUklQVE9SX1VOSU9OICopZnVzaW9uLT5yZXFfZnJh
bWVzX2Rlc2M7CisKKwlyZXFfZGVzYy0+V29yZHMgPSBjbWQtPmZyYW1lX3BoeXNfYWRkcjsKKwly
ZXFfZGVzYy0+TUZBSW8uUmVxdWVzdEZsYWdzID0KKwkJKE1FR0FTQVNfUkVRX0RFU0NSSVBUX0ZM
QUdTX01GQSA8PAorCQkgTUVHQVNBU19SRVFfREVTQ1JJUFRfRkxBR1NfVFlQRV9TSElGVCk7CisK
KwkvKgorCSAqIGRpc2FibGUgdGhlIGludHIgYmVmb3JlIGZpcmluZyB0aGUgaW5pdCBmcmFtZQor
CSAqLworCWluc3RhbmNlLT5pbnN0YW5jZXQtPmRpc2FibGVfaW50cihpbnN0YW5jZS0+cmVnX3Nl
dCk7CisKKwlmb3IgKGkgPSAwOyBpIDwgKDEwICogMTAwMCk7IGkgKz0gMjApIHsKKwkJaWYgKHJl
YWRsKCZpbnN0YW5jZS0+cmVnX3NldC0+ZG9vcmJlbGwpICYgMSkKKwkJCW1zbGVlcCgyMCk7CisJ
CWVsc2UKKwkJCWJyZWFrOworCX0KKworCWluc3RhbmNlLT5pbnN0YW5jZXQtPmZpcmVfY21kKGlu
c3RhbmNlLCByZXFfZGVzYy0+dS5sb3csCisJCQkJICAgICAgcmVxX2Rlc2MtPnUuaGlnaCwgaW5z
dGFuY2UtPnJlZ19zZXQpOworCisJd2FpdF9hbmRfcG9sbChpbnN0YW5jZSwgY21kKTsKKworCWZy
YW1lX2hkciA9ICZjbWQtPmZyYW1lLT5oZHI7CisJaWYgKGZyYW1lX2hkci0+Y21kX3N0YXR1cyAh
PSAwKSB7CisJCXJldCA9IDE7CisJCWdvdG8gZmFpbF9md19pbml0OworCX0KKwlwcmludGsoS0VS
Tl9FUlIgIm1lZ2FzYXM6SU9DIEluaXQgY21kIHN1Y2Nlc3NcbiIpOworCisJcmV0ID0gMDsKKwor
ZmFpbF9md19pbml0OgorCW1lZ2FzYXNfcmV0dXJuX2NtZChpbnN0YW5jZSwgY21kKTsKKwlpZiAo
SU9DSW5pdE1lc3NhZ2UpCisJCWRtYV9mcmVlX2NvaGVyZW50KCZpbnN0YW5jZS0+cGRldi0+ZGV2
LAorCQkJCSAgc2l6ZW9mKHN0cnVjdCBNUEkyX0lPQ19JTklUX1JFUVVFU1QpLAorCQkJCSAgSU9D
SW5pdE1lc3NhZ2UsIGlvY19pbml0X2hhbmRsZSk7CitmYWlsX2dldF9jbWQ6CisJcmV0dXJuIHJl
dDsKK30KKworLyoKKyAqIG1lZ2FzYXNfcmV0dXJuX2NtZF9mb3Jfc21pZCAtCVJldHVybnMgYSBj
bWRfZnVzaW9uIGZvciBhIFNNSUQKKyAqIEBpbnN0YW5jZToJCQkJQWRhcHRlciBzb2Z0IHN0YXRl
CisgKgorICovCit2b2lkCittZWdhc2FzX3JldHVybl9jbWRfZm9yX3NtaWQoc3RydWN0IG1lZ2Fz
YXNfaW5zdGFuY2UgKmluc3RhbmNlLCB1MTYgc21pZCkKK3sKKwlzdHJ1Y3QgZnVzaW9uX2NvbnRl
eHQgKmZ1c2lvbjsKKwlzdHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9uICpjbWQ7CisKKwlmdXNpb24g
PSBpbnN0YW5jZS0+Y3RybF9jb250ZXh0OworCWNtZCA9IGZ1c2lvbi0+Y21kX2xpc3Rbc21pZCAt
IDFdOworCW1lZ2FzYXNfcmV0dXJuX2NtZF9mdXNpb24oaW5zdGFuY2UsIGNtZCk7Cit9CisKKy8q
CisgKiBtZWdhc2FzX2dldF9sZF9tYXBfaW5mbyAtCVJldHVybnMgRlcncyBsZF9tYXAgc3RydWN0
dXJlCisgKiBAaW5zdGFuY2U6CQkJCUFkYXB0ZXIgc29mdCBzdGF0ZQorICogQHBlbmQ6CQkJCVBl
bmQgdGhlIGNvbW1hbmQgb3Igbm90CisgKiBJc3N1ZXMgYW4gaW50ZXJuYWwgY29tbWFuZCAoRENN
RCkgdG8gZ2V0IHRoZSBGVydzIGNvbnRyb2xsZXIgUEQKKyAqIGxpc3Qgc3RydWN0dXJlLiAgVGhp
cyBpbmZvcm1hdGlvbiBpcyBtYWlubHkgdXNlZCB0byBmaW5kIG91dCBTWVNURU0KKyAqIHN1cHBv
cnRlZCBieSB0aGUgRlcuCisgKi8KK3N0YXRpYyBpbnQKK21lZ2FzYXNfZ2V0X2xkX21hcF9pbmZv
KHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKK3sKKwlpbnQgcmV0ID0gMDsKKwlz
dHJ1Y3QgbWVnYXNhc19jbWQgKmNtZDsKKwlzdHJ1Y3QgbWVnYXNhc19kY21kX2ZyYW1lICpkY21k
OworCXN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKmNpOworCWRtYV9hZGRyX3QgY2lfaCA9IDA7
CisJdTMyIHNpemVfbWFwX2luZm87CisJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb247CisK
KwljbWQgPSBtZWdhc2FzX2dldF9jbWQoaW5zdGFuY2UpOworCisJaWYgKCFjbWQpIHsKKwkJcHJp
bnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IEZhaWxlZCB0byBnZXQgY21kIGZvciBtYXAgaW5mby5c
biIpOworCQlyZXR1cm4gLUVOT01FTTsKKwl9CisKKwlmdXNpb24gPSBpbnN0YW5jZS0+Y3RybF9j
b250ZXh0OworCisJaWYgKCFmdXNpb24pIHsKKwkJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNl
LCBjbWQpOworCQlyZXR1cm4gMTsKKwl9CisKKwlkY21kID0gJmNtZC0+ZnJhbWUtPmRjbWQ7CisK
KwlzaXplX21hcF9pbmZvID0gc2l6ZW9mKHN0cnVjdCBNUl9GV19SQUlEX01BUCkgKworCQkoc2l6
ZW9mKHN0cnVjdCBNUl9MRF9TUEFOX01BUCkgKihNQVhfTE9HSUNBTF9EUklWRVMgLSAxKSk7CisK
KwljaSA9IGZ1c2lvbi0+bGRfbWFwWyhpbnN0YW5jZS0+bWFwX2lkICYgMSldOworCWNpX2ggPSBm
dXNpb24tPmxkX21hcF9waHlzWyhpbnN0YW5jZS0+bWFwX2lkICYgMSldOworCisJaWYgKCFjaSkg
eworCQlwcmludGsoS0VSTl9ERUJVRyAiRmFpbGVkIHRvIGFsbG9jIG1lbSBmb3IgbGRfbWFwX2lu
Zm9cbiIpOworCQltZWdhc2FzX3JldHVybl9jbWQoaW5zdGFuY2UsIGNtZCk7CisJCXJldHVybiAt
RU5PTUVNOworCX0KKworCW1lbXNldChjaSwgMCwgc2l6ZW9mKCpjaSkpOworCW1lbXNldChkY21k
LT5tYm94LmIsIDAsIE1GSV9NQk9YX1NJWkUpOworCisJZGNtZC0+Y21kID0gTUZJX0NNRF9EQ01E
OworCWRjbWQtPmNtZF9zdGF0dXMgPSAweEZGOworCWRjbWQtPnNnZV9jb3VudCA9IDE7CisJZGNt
ZC0+ZmxhZ3MgPSBNRklfRlJBTUVfRElSX1JFQUQ7CisJZGNtZC0+dGltZW91dCA9IDA7CisJZGNt
ZC0+cGFkXzAgPSAwOworCWRjbWQtPmRhdGFfeGZlcl9sZW4gPSBzaXplX21hcF9pbmZvOworCWRj
bWQtPm9wY29kZSA9IE1SX0RDTURfTERfTUFQX0dFVF9JTkZPOworCWRjbWQtPnNnbC5zZ2UzMlsw
XS5waHlzX2FkZHIgPSBjaV9oOworCWRjbWQtPnNnbC5zZ2UzMlswXS5sZW5ndGggPSBzaXplX21h
cF9pbmZvOworCisJaWYgKCFtZWdhc2FzX2lzc3VlX3BvbGxlZChpbnN0YW5jZSwgY21kKSkKKwkJ
cmV0ID0gMDsKKwllbHNlIHsKKwkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBHZXQgTEQgTWFw
IEluZm8gRmFpbGVkXG4iKTsKKwkJcmV0ID0gLTE7CisJfQorCisJbWVnYXNhc19yZXR1cm5fY21k
KGluc3RhbmNlLCBjbWQpOworCisJcmV0dXJuIHJldDsKK30KKwordTgKK21lZ2FzYXNfZ2V0X21h
cF9pbmZvKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKK3sKKwlzdHJ1Y3QgZnVz
aW9uX2NvbnRleHQgKmZ1c2lvbiA9IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CisKKwlmdXNpb24t
PmZhc3RfcGF0aF9pbyA9IDA7CisJaWYgKCFtZWdhc2FzX2dldF9sZF9tYXBfaW5mbyhpbnN0YW5j
ZSkpIHsKKwkJaWYgKE1SX1ZhbGlkYXRlTWFwSW5mbyhmdXNpb24tPmxkX21hcFsoaW5zdGFuY2Ut
Pm1hcF9pZCAmIDEpXSwKKwkJCQkgICAgICAgZnVzaW9uLT5sb2FkX2JhbGFuY2VfaW5mbykpIHsK
KwkJCWZ1c2lvbi0+ZmFzdF9wYXRoX2lvID0gMTsKKwkJCXJldHVybiAwOworCQl9CisJfQorCXJl
dHVybiAxOworfQorCisvKgorICogbWVnYXNhc19zeW5jX21hcF9pbmZvIC0JUmV0dXJucyBGVydz
IGxkX21hcCBzdHJ1Y3R1cmUKKyAqIEBpbnN0YW5jZToJCQkJQWRhcHRlciBzb2Z0IHN0YXRlCisg
KgorICogSXNzdWVzIGFuIGludGVybmFsIGNvbW1hbmQgKERDTUQpIHRvIGdldCB0aGUgRlcncyBj
b250cm9sbGVyIFBECisgKiBsaXN0IHN0cnVjdHVyZS4gIFRoaXMgaW5mb3JtYXRpb24gaXMgbWFp
bmx5IHVzZWQgdG8gZmluZCBvdXQgU1lTVEVNCisgKiBzdXBwb3J0ZWQgYnkgdGhlIEZXLgorICov
CitpbnQKK21lZ2FzYXNfc3luY19tYXBfaW5mbyhzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5z
dGFuY2UpCit7CisJaW50IHJldCA9IDAsIGk7CisJc3RydWN0IG1lZ2FzYXNfY21kICpjbWQ7CisJ
c3RydWN0IG1lZ2FzYXNfZGNtZF9mcmFtZSAqZGNtZDsKKwl1MzIgc2l6ZV9zeW5jX2luZm8sIG51
bV9sZHM7CisJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb247CisJc3RydWN0IE1SX0xEX1RB
UkdFVF9TWU5DICpjaSA9IE5VTEw7CisJc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwOwor
CXN0cnVjdCBNUl9MRF9SQUlEICAqcmFpZDsKKwlzdHJ1Y3QgTVJfTERfVEFSR0VUX1NZTkMgKmxk
X3N5bmM7CisJZG1hX2FkZHJfdCBjaV9oID0gMDsKKwl1MzIgc2l6ZV9tYXBfaW5mbzsKKworCWNt
ZCA9IG1lZ2FzYXNfZ2V0X2NtZChpbnN0YW5jZSk7CisKKwlpZiAoIWNtZCkgeworCQlwcmludGso
S0VSTl9ERUJVRyAibWVnYXNhczogRmFpbGVkIHRvIGdldCBjbWQgZm9yIHN5bmMiCisJCSAgICAg
ICAiaW5mby5cbiIpOworCQlyZXR1cm4gLUVOT01FTTsKKwl9CisKKwlmdXNpb24gPSBpbnN0YW5j
ZS0+Y3RybF9jb250ZXh0OworCisJaWYgKCFmdXNpb24pIHsKKwkJbWVnYXNhc19yZXR1cm5fY21k
KGluc3RhbmNlLCBjbWQpOworCQlyZXR1cm4gMTsKKwl9CisKKwltYXAgPSBmdXNpb24tPmxkX21h
cFtpbnN0YW5jZS0+bWFwX2lkICYgMV07CisKKwludW1fbGRzID0gbWFwLT5yYWlkTWFwLmxkQ291
bnQ7CisKKwlkY21kID0gJmNtZC0+ZnJhbWUtPmRjbWQ7CisKKwlzaXplX3N5bmNfaW5mbyA9IHNp
emVvZihzdHJ1Y3QgTVJfTERfVEFSR0VUX1NZTkMpICpudW1fbGRzOworCisJbWVtc2V0KGRjbWQt
Pm1ib3guYiwgMCwgTUZJX01CT1hfU0laRSk7CisKKwljaSA9IChzdHJ1Y3QgTVJfTERfVEFSR0VU
X1NZTkMgKikKKwkgIGZ1c2lvbi0+bGRfbWFwWyhpbnN0YW5jZS0+bWFwX2lkIC0gMSkgJiAxXTsK
KwltZW1zZXQoY2ksIDAsIHNpemVvZihzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMKSk7CisKKwlj
aV9oID0gZnVzaW9uLT5sZF9tYXBfcGh5c1soaW5zdGFuY2UtPm1hcF9pZCAtIDEpICYgMV07CisK
KwlsZF9zeW5jID0gKHN0cnVjdCBNUl9MRF9UQVJHRVRfU1lOQyAqKWNpOworCisJZm9yIChpID0g
MDsgaSA8IG51bV9sZHM7IGkrKywgbGRfc3luYysrKSB7CisJCXJhaWQgPSBNUl9MZFJhaWRHZXQo
aSwgbWFwKTsKKwkJbGRfc3luYy0+dGFyZ2V0SWQgPSBNUl9HZXRMRFRndElkKGksIG1hcCk7CisJ
CWxkX3N5bmMtPnNlcU51bSA9IHJhaWQtPnNlcU51bTsKKwl9CisKKwlzaXplX21hcF9pbmZvID0g
c2l6ZW9mKHN0cnVjdCBNUl9GV19SQUlEX01BUCkgKworCQkoc2l6ZW9mKHN0cnVjdCBNUl9MRF9T
UEFOX01BUCkgKihNQVhfTE9HSUNBTF9EUklWRVMgLSAxKSk7CisKKwlkY21kLT5jbWQgPSBNRklf
Q01EX0RDTUQ7CisJZGNtZC0+Y21kX3N0YXR1cyA9IDB4RkY7CisJZGNtZC0+c2dlX2NvdW50ID0g
MTsKKwlkY21kLT5mbGFncyA9IE1GSV9GUkFNRV9ESVJfV1JJVEU7CisJZGNtZC0+dGltZW91dCA9
IDA7CisJZGNtZC0+cGFkXzAgPSAwOworCWRjbWQtPmRhdGFfeGZlcl9sZW4gPSBzaXplX21hcF9p
bmZvOworCWRjbWQtPm1ib3guYlswXSA9IG51bV9sZHM7CisJZGNtZC0+bWJveC5iWzFdID0gTUVH
QVNBU19EQ01EX01CT1hfUEVORF9GTEFHOworCWRjbWQtPm9wY29kZSA9IE1SX0RDTURfTERfTUFQ
X0dFVF9JTkZPOworCWRjbWQtPnNnbC5zZ2UzMlswXS5waHlzX2FkZHIgPSBjaV9oOworCWRjbWQt
PnNnbC5zZ2UzMlswXS5sZW5ndGggPSBzaXplX21hcF9pbmZvOworCisJaW5zdGFuY2UtPm1hcF91
cGRhdGVfY21kID0gY21kOworCisJaW5zdGFuY2UtPmluc3RhbmNldC0+aXNzdWVfZGNtZChpbnN0
YW5jZSwgY21kKTsKKworCXJldHVybiByZXQ7Cit9CisKKy8qKgorICogbWVnYXNhc19pbml0X2Fk
YXB0ZXJfZnVzaW9uIC0JSW5pdGlhbGl6ZXMgdGhlIEZXCisgKiBAaW5zdGFuY2U6CQlBZGFwdGVy
IHNvZnQgc3RhdGUKKyAqCisgKiBUaGlzIGlzIHRoZSBtYWluIGZ1bmN0aW9uIGZvciBpbml0aWFs
aXppbmcgZmlybXdhcmUuCisgKi8KK3UzMgorbWVnYXNhc19pbml0X2FkYXB0ZXJfZnVzaW9uKHN0
cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKK3sKKwlzdHJ1Y3QgbWVnYXNhc19yZWdp
c3Rlcl9zZXQgX19pb21lbSAqcmVnX3NldDsKKwlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lv
bjsKKwl1MzIgbWF4X2NtZDsKKwlpbnQgaSA9IDA7CisKKwlmdXNpb24gPSBpbnN0YW5jZS0+Y3Ry
bF9jb250ZXh0OworCisJcmVnX3NldCA9IGluc3RhbmNlLT5yZWdfc2V0OworCisJLyoKKwkgKiBH
ZXQgdmFyaW91cyBvcGVyYXRpb25hbCBwYXJhbWV0ZXJzIGZyb20gc3RhdHVzIHJlZ2lzdGVyCisJ
ICovCisJaW5zdGFuY2UtPm1heF9md19jbWRzID0KKwkJaW5zdGFuY2UtPmluc3RhbmNldC0+cmVh
ZF9md19zdGF0dXNfcmVnKHJlZ19zZXQpICYgMHgwMEZGRkY7CisJaW5zdGFuY2UtPm1heF9md19j
bWRzID0gbWluKGluc3RhbmNlLT5tYXhfZndfY21kcywgKHUxNikxMDA4KTsKKworCS8qCisJICog
UmVkdWNlIHRoZSBtYXggc3VwcG9ydGVkIGNtZHMgYnkgMS4gVGhpcyBpcyB0byBlbnN1cmUgdGhh
dCB0aGUKKwkgKiByZXBseV9xX3N6ICgxIG1vcmUgdGhhbiB0aGUgbWF4IGNtZCB0aGF0IGRyaXZl
ciBtYXkgc2VuZCkKKwkgKiBkb2VzIG5vdCBleGNlZWQgbWF4IGNtZHMgdGhhdCB0aGUgRlcgY2Fu
IHN1cHBvcnQKKwkgKi8KKwlpbnN0YW5jZS0+bWF4X2Z3X2NtZHMgPSBpbnN0YW5jZS0+bWF4X2Z3
X2NtZHMtMTsKKwkvKiBPbmx5IGludGVybmFsIGNtZHMgKERDTUQpIG5lZWQgdG8gaGF2ZSBNRkkg
ZnJhbWVzICovCisJaW5zdGFuY2UtPm1heF9tZmlfY21kcyA9IE1FR0FTQVNfSU5UX0NNRFM7CisK
KwltYXhfY21kID0gaW5zdGFuY2UtPm1heF9md19jbWRzOworCisJZnVzaW9uLT5yZXBseV9xX2Rl
cHRoID0gKChtYXhfY21kICsgMSArIDE1KS8xNikqMTY7CisKKwlmdXNpb24tPnJlcXVlc3RfYWxs
b2Nfc3ogPQorCQlzaXplb2YodW5pb24gTUVHQVNBU19SRVFVRVNUX0RFU0NSSVBUT1JfVU5JT04p
ICptYXhfY21kOworCWZ1c2lvbi0+cmVwbHlfYWxsb2Nfc3ogPSBzaXplb2YodW5pb24gTVBJMl9S
RVBMWV9ERVNDUklQVE9SU19VTklPTikKKwkJKihmdXNpb24tPnJlcGx5X3FfZGVwdGgpOworCWZ1
c2lvbi0+aW9fZnJhbWVzX2FsbG9jX3N6ID0gTUVHQV9NUEkyX1JBSURfREVGQVVMVF9JT19GUkFN
RV9TSVpFICsKKwkJKE1FR0FfTVBJMl9SQUlEX0RFRkFVTFRfSU9fRlJBTUVfU0laRSAqCisJCSAo
bWF4X2NtZCArIDEpKTsgLyogRXh0cmEgMSBmb3IgU01JRCAwICovCisKKwlmdXNpb24tPm1heF9z
Z2VfaW5fbWFpbl9tc2cgPQorCSAgKE1FR0FfTVBJMl9SQUlEX0RFRkFVTFRfSU9fRlJBTUVfU0la
RSAtCisJICAgb2Zmc2V0b2Yoc3RydWN0IE1QSTJfUkFJRF9TQ1NJX0lPX1JFUVVFU1QsIFNHTCkp
LzE2OworCisJZnVzaW9uLT5tYXhfc2dlX2luX2NoYWluID0KKwkJTUVHQVNBU19NQVhfU1pfQ0hB
SU5fRlJBTUUgLyBzaXplb2YodW5pb24gTVBJMl9TR0VfSU9fVU5JT04pOworCisJaW5zdGFuY2Ut
Pm1heF9udW1fc2dlID0gZnVzaW9uLT5tYXhfc2dlX2luX21haW5fbXNnICsKKwkJZnVzaW9uLT5t
YXhfc2dlX2luX2NoYWluIC0gMjsKKworCS8qIFVzZWQgZm9yIHBhc3MgdGhydSBNRkkgZnJhbWUg
KERDTUQpICovCisJZnVzaW9uLT5jaGFpbl9vZmZzZXRfbWZpX3B0aHJ1ID0KKwkJb2Zmc2V0b2Yo
c3RydWN0IE1QSTJfUkFJRF9TQ1NJX0lPX1JFUVVFU1QsIFNHTCkvMTY7CisKKwlmdXNpb24tPmNo
YWluX29mZnNldF9pb19yZXF1ZXN0ID0KKwkJKE1FR0FfTVBJMl9SQUlEX0RFRkFVTFRfSU9fRlJB
TUVfU0laRSAtCisJCSBzaXplb2YodW5pb24gTVBJMl9TR0VfSU9fVU5JT04pKS8xNjsKKworCWZ1
c2lvbi0+bGFzdF9yZXBseV9pZHggPSAwOworCisJLyoKKwkgKiBBbGxvY2F0ZSBtZW1vcnkgZm9y
IGRlc2NyaXB0b3JzCisJICogQ3JlYXRlIGEgcG9vbCBvZiBjb21tYW5kcworCSAqLworCWlmICht
ZWdhc2FzX2FsbG9jX2NtZHMoaW5zdGFuY2UpKQorCQlnb3RvIGZhaWxfYWxsb2NfbWZpX2NtZHM7
CisJaWYgKG1lZ2FzYXNfYWxsb2NfY21kc19mdXNpb24oaW5zdGFuY2UpKQorCQlnb3RvIGZhaWxf
YWxsb2NfY21kczsKKworCWlmIChtZWdhc2FzX2lvY19pbml0X2Z1c2lvbihpbnN0YW5jZSkpCisJ
CWdvdG8gZmFpbF9pb2NfaW5pdDsKKworCWluc3RhbmNlLT5mbGFnX2llZWUgPSAxOworCisJZnVz
aW9uLT5tYXBfc3ogPSAgc2l6ZW9mKHN0cnVjdCBNUl9GV19SQUlEX01BUCkgKworCSAgKHNpemVv
ZihzdHJ1Y3QgTVJfTERfU1BBTl9NQVApICooTUFYX0xPR0lDQUxfRFJJVkVTIC0gMSkpOworCisJ
ZnVzaW9uLT5mYXN0X3BhdGhfaW8gPSAwOworCisJZm9yIChpID0gMDsgaSA8IDI7IGkrKykgewor
CQlmdXNpb24tPmxkX21hcFtpXSA9IGRtYV9hbGxvY19jb2hlcmVudCgmaW5zdGFuY2UtPnBkZXYt
PmRldiwKKwkJCQkJCSAgICAgICBmdXNpb24tPm1hcF9zeiwKKwkJCQkJCSAgICAgICAmZnVzaW9u
LT5sZF9tYXBfcGh5c1tpXSwKKwkJCQkJCSAgICAgICBHRlBfS0VSTkVMKTsKKwkJaWYgKCFmdXNp
b24tPmxkX21hcFtpXSkgeworCQkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBDb3VsZCBub3Qg
YWxsb2NhdGUgbWVtb3J5ICIKKwkJCSAgICAgICAiZm9yIG1hcCBpbmZvXG4iKTsKKwkJCWdvdG8g
ZmFpbF9tYXBfaW5mbzsKKwkJfQorCX0KKworCWlmICghbWVnYXNhc19nZXRfbWFwX2luZm8oaW5z
dGFuY2UpKQorCQltZWdhc2FzX3N5bmNfbWFwX2luZm8oaW5zdGFuY2UpOworCisJcmV0dXJuIDA7
CisKK2ZhaWxfYWxsb2NfY21kczoKK2ZhaWxfYWxsb2NfbWZpX2NtZHM6CitmYWlsX21hcF9pbmZv
OgorCWlmIChpID09IDEpCisJCWRtYV9mcmVlX2NvaGVyZW50KCZpbnN0YW5jZS0+cGRldi0+ZGV2
LCBmdXNpb24tPm1hcF9zeiwKKwkJCQkgIGZ1c2lvbi0+bGRfbWFwWzBdLCBmdXNpb24tPmxkX21h
cF9waHlzWzBdKTsKK2ZhaWxfaW9jX2luaXQ6CisJcmV0dXJuIDE7Cit9CisKKy8qKgorICogbWVn
YXNhc19maXJlX2NtZF9mdXNpb24gLQlTZW5kcyBjb21tYW5kIHRvIHRoZSBGVworICogQGZyYW1l
X3BoeXNfYWRkciA6CQlQaHlzaWNhbCBhZGRyZXNzIG9mIGNtZAorICogQGZyYW1lX2NvdW50IDoJ
CU51bWJlciBvZiBmcmFtZXMgZm9yIHRoZSBjb21tYW5kCisgKiBAcmVncyA6CQkJTUZJIHJlZ2lz
dGVyIHNldAorICovCit2b2lkCittZWdhc2FzX2ZpcmVfY21kX2Z1c2lvbihzdHJ1Y3QgbWVnYXNh
c19pbnN0YW5jZSAqaW5zdGFuY2UsCisJCQlkbWFfYWRkcl90IHJlcV9kZXNjX2xvLAorCQkJdTMy
IHJlcV9kZXNjX2hpLAorCQkJc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9tZW0gKnJl
Z3MpCit7CisJdW5zaWduZWQgbG9uZyBmbGFnczsKKworCXNwaW5fbG9ja19pcnFzYXZlKCZpbnN0
YW5jZS0+aGJhX2xvY2ssIGZsYWdzKTsKKworCXdyaXRlbChyZXFfZGVzY19sbywKKwkgICAgICAg
JihyZWdzKS0+aW5ib3VuZF9sb3dfcXVldWVfcG9ydCk7CisJd3JpdGVsKHJlcV9kZXNjX2hpLCAm
KHJlZ3MpLT5pbmJvdW5kX2hpZ2hfcXVldWVfcG9ydCk7CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9y
ZSgmaW5zdGFuY2UtPmhiYV9sb2NrLCBmbGFncyk7Cit9CisKKy8qKgorICogbWFwX2NtZF9zdGF0
dXMgLQlNYXBzIEZXIGNtZCBzdGF0dXMgdG8gT1MgY21kIHN0YXR1cworICogQGNtZCA6CQlQb2lu
dGVyIHRvIGNtZAorICogQHN0YXR1cyA6CQlzdGF0dXMgb2YgY21kIHJldHVybmVkIGJ5IEZXCisg
KiBAZXh0X3N0YXR1cyA6CWV4dCBzdGF0dXMgb2YgY21kIHJldHVybmVkIGJ5IEZXCisgKi8KKwor
dm9pZAorbWFwX2NtZF9zdGF0dXMoc3RydWN0IG1lZ2FzYXNfY21kX2Z1c2lvbiAqY21kLCB1OCBz
dGF0dXMsIHU4IGV4dF9zdGF0dXMpCit7CisKKwlzd2l0Y2ggKHN0YXR1cykgeworCisJY2FzZSBN
RklfU1RBVF9PSzoKKwkJY21kLT5zY21kLT5yZXN1bHQgPSBESURfT0sgPDwgMTY7CisJCWJyZWFr
OworCisJY2FzZSBNRklfU1RBVF9TQ1NJX0lPX0ZBSUxFRDoKKwljYXNlIE1GSV9TVEFUX0xEX0lO
SVRfSU5fUFJPR1JFU1M6CisJCWNtZC0+c2NtZC0+cmVzdWx0ID0gKERJRF9FUlJPUiA8PCAxNikg
fCBleHRfc3RhdHVzOworCQlicmVhazsKKworCWNhc2UgTUZJX1NUQVRfU0NTSV9ET05FX1dJVEhf
RVJST1I6CisKKwkJY21kLT5zY21kLT5yZXN1bHQgPSAoRElEX09LIDw8IDE2KSB8IGV4dF9zdGF0
dXM7CisJCWlmIChleHRfc3RhdHVzID09IFNBTV9TVEFUX0NIRUNLX0NPTkRJVElPTikgeworCQkJ
bWVtc2V0KGNtZC0+c2NtZC0+c2Vuc2VfYnVmZmVyLCAwLAorCQkJICAgICAgIFNDU0lfU0VOU0Vf
QlVGRkVSU0laRSk7CisJCQltZW1jcHkoY21kLT5zY21kLT5zZW5zZV9idWZmZXIsIGNtZC0+c2Vu
c2UsCisJCQkgICAgICAgU0NTSV9TRU5TRV9CVUZGRVJTSVpFKTsKKwkJCWNtZC0+c2NtZC0+cmVz
dWx0IHw9IERSSVZFUl9TRU5TRSA8PCAyNDsKKwkJfQorCQlicmVhazsKKworCWNhc2UgTUZJX1NU
QVRfTERfT0ZGTElORToKKwljYXNlIE1GSV9TVEFUX0RFVklDRV9OT1RfRk9VTkQ6CisJCWNtZC0+
c2NtZC0+cmVzdWx0ID0gRElEX0JBRF9UQVJHRVQgPDwgMTY7CisJCWJyZWFrOworCisJZGVmYXVs
dDoKKwkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IEZXIHN0YXR1cyAlI3hcbiIsIHN0YXR1
cyk7CisJCWNtZC0+c2NtZC0+cmVzdWx0ID0gRElEX0VSUk9SIDw8IDE2OworCQlicmVhazsKKwl9
Cit9CisKKy8qKgorICogbWVnYXNhc19tYWtlX3NnbF9mdXNpb24gLQlQcmVwYXJlcyAzMi1iaXQg
U0dMCisgKiBAaW5zdGFuY2U6CQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAqIEBzY3A6CQlTQ1NJIGNv
bW1hbmQgZnJvbSB0aGUgbWlkLWxheWVyCisgKiBAc2dsX3B0cjoJCVNHTCB0byBiZSBmaWxsZWQg
aW4KKyAqIEBjbWQ6CQljbWQgd2UgYXJlIHdvcmtpbmcgb24KKyAqCisgKiBJZiBzdWNjZXNzZnVs
LCB0aGlzIGZ1bmN0aW9uIHJldHVybnMgdGhlIG51bWJlciBvZiBTRyBlbGVtZW50cy4KKyAqLwor
c3RhdGljIGludAorbWVnYXNhc19tYWtlX3NnbF9mdXNpb24oc3RydWN0IG1lZ2FzYXNfaW5zdGFu
Y2UgKmluc3RhbmNlLAorCQkJc3RydWN0IHNjc2lfY21uZCAqc2NwLAorCQkJc3RydWN0IE1QSTI1
X0lFRUVfU0dFX0NIQUlONjQgKnNnbF9wdHIsCisJCQlzdHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9u
ICpjbWQpCit7CisJaW50IGksIHNnX3Byb2Nlc3NlZDsKKwlpbnQgc2dlX2NvdW50LCBzZ2VfaWR4
OworCXN0cnVjdCBzY2F0dGVybGlzdCAqb3Nfc2dsOworCXN0cnVjdCBmdXNpb25fY29udGV4dCAq
ZnVzaW9uOworCisJZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKKworCWNtZC0+aW9f
cmVxdWVzdC0+Q2hhaW5PZmZzZXQgPSAwOworCisJc2dlX2NvdW50ID0gc2NzaV9kbWFfbWFwKHNj
cCk7CisKKwlCVUdfT04oc2dlX2NvdW50IDwgMCk7CisKKwlpZiAoc2dlX2NvdW50ID4gaW5zdGFu
Y2UtPm1heF9udW1fc2dlIHx8ICFzZ2VfY291bnQpCisJCXJldHVybiBzZ2VfY291bnQ7CisKKwlp
ZiAoc2dlX2NvdW50ID4gZnVzaW9uLT5tYXhfc2dlX2luX21haW5fbXNnKSB7CisJCS8qIE9uZSBl
bGVtZW50IHRvIHN0b3JlIHRoZSBjaGFpbiBpbmZvICovCisJCXNnZV9pZHggPSBmdXNpb24tPm1h
eF9zZ2VfaW5fbWFpbl9tc2cgLSAxOworCX0gZWxzZQorCQlzZ2VfaWR4ID0gc2dlX2NvdW50Owor
CisJc2NzaV9mb3JfZWFjaF9zZyhzY3AsIG9zX3NnbCwgc2dlX2NvdW50LCBpKSB7CisJCXNnbF9w
dHItPkxlbmd0aCA9IHNnX2RtYV9sZW4ob3Nfc2dsKTsKKwkJc2dsX3B0ci0+QWRkcmVzcyA9IHNn
X2RtYV9hZGRyZXNzKG9zX3NnbCk7CisJCXNnbF9wdHItPkZsYWdzID0gMDsKKwkJc2dsX3B0cisr
OworCisJCXNnX3Byb2Nlc3NlZCA9IGkgKyAxOworCisJCWlmICgoc2dfcHJvY2Vzc2VkID09ICAo
ZnVzaW9uLT5tYXhfc2dlX2luX21haW5fbXNnIC0gMSkpICYmCisJCSAgICAoc2dlX2NvdW50ID4g
ZnVzaW9uLT5tYXhfc2dlX2luX21haW5fbXNnKSkgeworCisJCQlzdHJ1Y3QgTVBJMjVfSUVFRV9T
R0VfQ0hBSU42NCAqc2dfY2hhaW47CisJCQljbWQtPmlvX3JlcXVlc3QtPkNoYWluT2Zmc2V0ID0K
KwkJCQlmdXNpb24tPmNoYWluX29mZnNldF9pb19yZXF1ZXN0OworCQkJc2dfY2hhaW4gPSBzZ2xf
cHRyOworCQkJLyogUHJlcGFyZSBjaGFpbiBlbGVtZW50ICovCisJCQlzZ19jaGFpbi0+TmV4dENo
YWluT2Zmc2V0ID0gMDsKKwkJCXNnX2NoYWluLT5GbGFncyA9IChJRUVFX1NHRV9GTEFHU19DSEFJ
Tl9FTEVNRU5UIHwKKwkJCQkJICAgTVBJMl9JRUVFX1NHRV9GTEFHU19JT0NQTEJOVEFfQUREUik7
CisJCQlzZ19jaGFpbi0+TGVuZ3RoID0gIChzaXplb2YodW5pb24gTVBJMl9TR0VfSU9fVU5JT04p
CisJCQkJCSAgICAgKihzZ2VfY291bnQgLSBzZ19wcm9jZXNzZWQpKTsKKwkJCXNnX2NoYWluLT5B
ZGRyZXNzID0gY21kLT5zZ19mcmFtZV9waHlzX2FkZHI7CisKKwkJCXNnbF9wdHIgPQorCQkJICAo
c3RydWN0IE1QSTI1X0lFRUVfU0dFX0NIQUlONjQgKiljbWQtPnNnX2ZyYW1lOworCQl9CisJfQor
CisJcmV0dXJuIHNnZV9jb3VudDsKK30KKworLyoqCisgKiBtZWdhc2FzX3NldF9wZF9sYmEgLQlT
ZXRzIFBEIExCQQorICogQGNkYjoJCUNEQgorICogQGNkYl9sZW46CQljZGIgbGVuZ3RoCisgKiBA
c3RhcnRfYmxrOgkJU3RhcnQgYmxvY2sgb2YgSU8KKyAqCisgKiBVc2VkIHRvIHNldCB0aGUgUEQg
TEJBIGluIENEQiBmb3IgRlAgSU9zCisgKi8KK3ZvaWQKK21lZ2FzYXNfc2V0X3BkX2xiYShzdHJ1
Y3QgTVBJMl9SQUlEX1NDU0lfSU9fUkVRVUVTVCAqaW9fcmVxdWVzdCwgdTggY2RiX2xlbiwKKwkJ
ICAgc3RydWN0IElPX1JFUVVFU1RfSU5GTyAqaW9faW5mbywgc3RydWN0IHNjc2lfY21uZCAqc2Nw
LAorCQkgICBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICpsb2NhbF9tYXBfcHRyLCB1MzIgcmVm
X3RhZykKK3sKKwlzdHJ1Y3QgTVJfTERfUkFJRCAqcmFpZDsKKwl1MzIgbGQ7CisJdTY0IHN0YXJ0
X2JsayA9IGlvX2luZm8tPnBkQmxvY2s7CisJdTggKmNkYiA9IGlvX3JlcXVlc3QtPkNEQi5DREIz
MjsKKwl1MzIgbnVtX2Jsb2NrcyA9IGlvX2luZm8tPm51bUJsb2NrczsKKwl1OCBvcGNvZGUsIGZs
YWd2YWxzLCBncm91cG51bSwgY29udHJvbDsKKworCS8qIENoZWNrIGlmIFQxMCBQSSAoRElGKSBp
cyBlbmFibGVkIGZvciB0aGlzIExEICovCisJbGQgPSBNUl9UYXJnZXRJZFRvTGRHZXQoaW9faW5m
by0+bGRUZ3RJZCwgbG9jYWxfbWFwX3B0cik7CisJcmFpZCA9IE1SX0xkUmFpZEdldChsZCwgbG9j
YWxfbWFwX3B0cik7CisJaWYgKHJhaWQtPmNhcGFiaWxpdHkubGRQaU1vZGUgPT0gTVJfUFJPVF9J
TkZPX1RZUEVfQ09OVFJPTExFUikgeworCQltZW1zZXQoY2RiLCAwLCBzaXplb2YoaW9fcmVxdWVz
dC0+Q0RCLkNEQjMyKSk7CisJCWNkYlswXSA9ICBNRUdBU0FTX1NDU0lfVkFSSUFCTEVfTEVOR1RI
X0NNRDsKKwkJY2RiWzddID0gIE1FR0FTQVNfU0NTSV9BRERMX0NEQl9MRU47CisKKwkJaWYgKHNj
cC0+c2NfZGF0YV9kaXJlY3Rpb24gPT0gUENJX0RNQV9GUk9NREVWSUNFKQorCQkJY2RiWzldID0g
TUVHQVNBU19TQ1NJX1NFUlZJQ0VfQUNUSU9OX1JFQUQzMjsKKwkJZWxzZQorCQkJY2RiWzldID0g
TUVHQVNBU19TQ1NJX1NFUlZJQ0VfQUNUSU9OX1dSSVRFMzI7CisJCWNkYlsxMF0gPSBNRUdBU0FT
X1JEX1dSX1BST1RFQ1RfQ0hFQ0tfQUxMOworCisJCS8qIExCQSAqLworCQljZGJbMTJdID0gKHU4
KSgoc3RhcnRfYmxrID4+IDU2KSAmIDB4ZmYpOworCQljZGJbMTNdID0gKHU4KSgoc3RhcnRfYmxr
ID4+IDQ4KSAmIDB4ZmYpOworCQljZGJbMTRdID0gKHU4KSgoc3RhcnRfYmxrID4+IDQwKSAmIDB4
ZmYpOworCQljZGJbMTVdID0gKHU4KSgoc3RhcnRfYmxrID4+IDMyKSAmIDB4ZmYpOworCQljZGJb
MTZdID0gKHU4KSgoc3RhcnRfYmxrID4+IDI0KSAmIDB4ZmYpOworCQljZGJbMTddID0gKHU4KSgo
c3RhcnRfYmxrID4+IDE2KSAmIDB4ZmYpOworCQljZGJbMThdID0gKHU4KSgoc3RhcnRfYmxrID4+
IDgpICYgMHhmZik7CisJCWNkYlsxOV0gPSAodTgpKHN0YXJ0X2JsayAmIDB4ZmYpOworCisJCS8q
IExvZ2ljYWwgYmxvY2sgcmVmZXJlbmNlIHRhZyAqLworCQlpb19yZXF1ZXN0LT5DREIuRUVEUDMy
LlByaW1hcnlSZWZlcmVuY2VUYWcgPQorCQkJY3B1X3RvX2JlMzIocmVmX3RhZyk7CisJCWlvX3Jl
cXVlc3QtPkNEQi5FRURQMzIuUHJpbWFyeUFwcGxpY2F0aW9uVGFnTWFzayA9IDB4ZmZmZjsKKwor
CQlpb19yZXF1ZXN0LT5EYXRhTGVuZ3RoID0gbnVtX2Jsb2NrcyAqIDUxMjsKKwkJaW9fcmVxdWVz
dC0+SW9GbGFncyA9IDMyOyAvKiBTcGVjaWZ5IDMyLWJ5dGUgY2RiICovCisKKwkJLyogVHJhbnNm
ZXIgbGVuZ3RoICovCisJCWNkYlsyOF0gPSAodTgpKChudW1fYmxvY2tzID4+IDI0KSAmIDB4ZmYp
OworCQljZGJbMjldID0gKHU4KSgobnVtX2Jsb2NrcyA+PiAxNikgJiAweGZmKTsKKwkJY2RiWzMw
XSA9ICh1OCkoKG51bV9ibG9ja3MgPj4gOCkgJiAweGZmKTsKKwkJY2RiWzMxXSA9ICh1OCkobnVt
X2Jsb2NrcyAmIDB4ZmYpOworCisJCS8qIHNldCBTQ1NJIElPIEVFRFBGbGFncyAqLworCQlpZiAo
c2NwLT5zY19kYXRhX2RpcmVjdGlvbiA9PSBQQ0lfRE1BX0ZST01ERVZJQ0UpIHsKKwkJCWlvX3Jl
cXVlc3QtPkVFRFBGbGFncyA9CisJCQkJTVBJMl9TQ1NJSU9fRUVEUEZMQUdTX0lOQ19QUklfUkVG
VEFHICB8CisJCQkJTVBJMl9TQ1NJSU9fRUVEUEZMQUdTX0NIRUNLX1JFRlRBRyB8CisJCQkJTVBJ
Ml9TQ1NJSU9fRUVEUEZMQUdTX0NIRUNLX1JFTU9WRV9PUCB8CisJCQkJTVBJMl9TQ1NJSU9fRUVE
UEZMQUdTX0NIRUNLX0FQUFRBRyB8CisJCQkJTVBJMl9TQ1NJSU9fRUVEUEZMQUdTX0NIRUNLX0dV
QVJEOworCQl9IGVsc2UgeworCQkJaW9fcmVxdWVzdC0+RUVEUEZsYWdzID0KKwkJCQlNUEkyX1ND
U0lJT19FRURQRkxBR1NfSU5DX1BSSV9SRUZUQUcgfAorCQkJCU1QSTJfU0NTSUlPX0VFRFBGTEFH
U19JTlNFUlRfT1A7CisJCX0KKwkJaW9fcmVxdWVzdC0+Q29udHJvbCB8PSAoMHg0IDw8IDI2KTsK
KwkJaW9fcmVxdWVzdC0+RUVEUEJsb2NrU2l6ZSA9IE1FR0FTQVNfRUVEUEJMT0NLU0laRTsKKwl9
IGVsc2UgeworCQkvKiBTb21lIGRyaXZlcyBkb24ndCBzdXBwb3J0IDE2LzEyIGJ5dGUgQ0RCJ3Ms
IGNvbnZlcnQgdG8gMTAgKi8KKwkJaWYgKCgoY2RiX2xlbiA9PSAxMikgfHwgKGNkYl9sZW4gPT0g
MTYpKSAmJgorCQkgICAgKHN0YXJ0X2JsayA8PSAweGZmZmZmZmZmKSkgeworCQkJaWYgKGNkYl9s
ZW4gPT0gMTYpIHsKKwkJCQlvcGNvZGUgPSBjZGJbMF0gPT0gUkVBRF8xNiA/IFJFQURfMTAgOiBX
UklURV8xMDsKKwkJCQlmbGFndmFscyA9IGNkYlsxXTsKKwkJCQlncm91cG51bSA9IGNkYlsxNF07
CisJCQkJY29udHJvbCA9IGNkYlsxNV07CisJCQl9IGVsc2UgeworCQkJCW9wY29kZSA9IGNkYlsw
XSA9PSBSRUFEXzEyID8gUkVBRF8xMCA6IFdSSVRFXzEwOworCQkJCWZsYWd2YWxzID0gY2RiWzFd
OworCQkJCWdyb3VwbnVtID0gY2RiWzEwXTsKKwkJCQljb250cm9sID0gY2RiWzExXTsKKwkJCX0K
KworCQkJbWVtc2V0KGNkYiwgMCwgc2l6ZW9mKGlvX3JlcXVlc3QtPkNEQi5DREIzMikpOworCisJ
CQljZGJbMF0gPSBvcGNvZGU7CisJCQljZGJbMV0gPSBmbGFndmFsczsKKwkJCWNkYls2XSA9IGdy
b3VwbnVtOworCQkJY2RiWzldID0gY29udHJvbDsKKworCQkJLyogVHJhbnNmZXIgbGVuZ3RoICov
CisJCQljZGJbOF0gPSAodTgpKG51bV9ibG9ja3MgJiAweGZmKTsKKwkJCWNkYls3XSA9ICh1OCko
KG51bV9ibG9ja3MgPj4gOCkgJiAweGZmKTsKKworCQkJY2RiX2xlbiA9IDEwOworCQl9CisKKwkJ
LyogTm9ybWFsIGNhc2UsIGp1c3QgbG9hZCBMQkEgaGVyZSAqLworCQlzd2l0Y2ggKGNkYl9sZW4p
IHsKKwkJY2FzZSA2OgorCQl7CisJCQl1OCB2YWwgPSBjZGJbMV0gJiAweEUwOworCQkJY2RiWzNd
ID0gKHU4KShzdGFydF9ibGsgJiAweGZmKTsKKwkJCWNkYlsyXSA9ICh1OCkoKHN0YXJ0X2JsayA+
PiA4KSAmIDB4ZmYpOworCQkJY2RiWzFdID0gdmFsIHwgKCh1OCkoc3RhcnRfYmxrID4+IDE2KSAm
IDB4MWYpOworCQkJYnJlYWs7CisJCX0KKwkJY2FzZSAxMDoKKwkJCWNkYls1XSA9ICh1OCkoc3Rh
cnRfYmxrICYgMHhmZik7CisJCQljZGJbNF0gPSAodTgpKChzdGFydF9ibGsgPj4gOCkgJiAweGZm
KTsKKwkJCWNkYlszXSA9ICh1OCkoKHN0YXJ0X2JsayA+PiAxNikgJiAweGZmKTsKKwkJCWNkYlsy
XSA9ICh1OCkoKHN0YXJ0X2JsayA+PiAyNCkgJiAweGZmKTsKKwkJCWJyZWFrOworCQljYXNlIDEy
OgorCQkJY2RiWzVdICAgID0gKHU4KShzdGFydF9ibGsgJiAweGZmKTsKKwkJCWNkYls0XSAgICA9
ICh1OCkoKHN0YXJ0X2JsayA+PiA4KSAmIDB4ZmYpOworCQkJY2RiWzNdICAgID0gKHU4KSgoc3Rh
cnRfYmxrID4+IDE2KSAmIDB4ZmYpOworCQkJY2RiWzJdICAgID0gKHU4KSgoc3RhcnRfYmxrID4+
IDI0KSAmIDB4ZmYpOworCQkJYnJlYWs7CisJCWNhc2UgMTY6CisJCQljZGJbOV0gICAgPSAodTgp
KHN0YXJ0X2JsayAmIDB4ZmYpOworCQkJY2RiWzhdICAgID0gKHU4KSgoc3RhcnRfYmxrID4+IDgp
ICYgMHhmZik7CisJCQljZGJbN10gICAgPSAodTgpKChzdGFydF9ibGsgPj4gMTYpICYgMHhmZik7
CisJCQljZGJbNl0gICAgPSAodTgpKChzdGFydF9ibGsgPj4gMjQpICYgMHhmZik7CisJCQljZGJb
NV0gICAgPSAodTgpKChzdGFydF9ibGsgPj4gMzIpICYgMHhmZik7CisJCQljZGJbNF0gICAgPSAo
dTgpKChzdGFydF9ibGsgPj4gNDApICYgMHhmZik7CisJCQljZGJbM10gICAgPSAodTgpKChzdGFy
dF9ibGsgPj4gNDgpICYgMHhmZik7CisJCQljZGJbMl0gICAgPSAodTgpKChzdGFydF9ibGsgPj4g
NTYpICYgMHhmZik7CisJCQlicmVhazsKKwkJfQorCX0KK30KKworLyoqCisgKiBtZWdhc2FzX2J1
aWxkX2xkaW9fZnVzaW9uIC0JUHJlcGFyZXMgSU9zIHRvIGRldmljZXMKKyAqIEBpbnN0YW5jZToJ
CUFkYXB0ZXIgc29mdCBzdGF0ZQorICogQHNjcDoJCVNDU0kgY29tbWFuZAorICogQGNtZDoJCUNv
bW1hbmQgdG8gYmUgcHJlcGFyZWQKKyAqCisgKiBQcmVwYXJlcyB0aGUgaW9fcmVxdWVzdCBhbmQg
Y2hhaW4gZWxlbWVudHMgKHNnX2ZyYW1lKSBmb3IgSU8KKyAqIFRoZSBJTyBjYW4gYmUgZm9yIFBE
IChGYXN0IFBhdGgpIG9yIExECisgKi8KK3ZvaWQKK21lZ2FzYXNfYnVpbGRfbGRpb19mdXNpb24o
c3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAorCQkJICBzdHJ1Y3Qgc2NzaV9jbW5k
ICpzY3AsCisJCQkgIHN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24gKmNtZCkKK3sKKwl1OCBmcF9w
b3NzaWJsZTsKKwl1MzIgc3RhcnRfbGJhX2xvLCBzdGFydF9sYmFfaGksIGRldmljZV9pZDsKKwlz
dHJ1Y3QgTVBJMl9SQUlEX1NDU0lfSU9fUkVRVUVTVCAqaW9fcmVxdWVzdDsKKwl1bmlvbiBNRUdB
U0FTX1JFUVVFU1RfREVTQ1JJUFRPUl9VTklPTiAqcmVxX2Rlc2M7CisJc3RydWN0IElPX1JFUVVF
U1RfSU5GTyBpb19pbmZvOworCXN0cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uOworCXN0cnVj
dCBNUl9GV19SQUlEX01BUF9BTEwgKmxvY2FsX21hcF9wdHI7CisKKwlkZXZpY2VfaWQgPSBNRUdB
U0FTX0RFVl9JTkRFWChpbnN0YW5jZSwgc2NwKTsKKworCWZ1c2lvbiA9IGluc3RhbmNlLT5jdHJs
X2NvbnRleHQ7CisKKwlpb19yZXF1ZXN0ID0gY21kLT5pb19yZXF1ZXN0OworCWlvX3JlcXVlc3Qt
PlJhaWRDb250ZXh0LlZpcnR1YWxEaXNrVGd0SWQgPSBkZXZpY2VfaWQ7CisJaW9fcmVxdWVzdC0+
UmFpZENvbnRleHQuc3RhdHVzID0gMDsKKwlpb19yZXF1ZXN0LT5SYWlkQ29udGV4dC5leFN0YXR1
cyA9IDA7CisKKwlyZXFfZGVzYyA9ICh1bmlvbiBNRUdBU0FTX1JFUVVFU1RfREVTQ1JJUFRPUl9V
TklPTiAqKWNtZC0+cmVxdWVzdF9kZXNjOworCisJc3RhcnRfbGJhX2xvID0gMDsKKwlzdGFydF9s
YmFfaGkgPSAwOworCWZwX3Bvc3NpYmxlID0gMDsKKworCS8qCisJICogNi1ieXRlIFJFQUQoMHgw
OCkgb3IgV1JJVEUoMHgwQSkgY2RiCisJICovCisJaWYgKHNjcC0+Y21kX2xlbiA9PSA2KSB7CisJ
CWlvX3JlcXVlc3QtPkRhdGFMZW5ndGggPSAodTMyKSBzY3AtPmNtbmRbNF07CisJCXN0YXJ0X2xi
YV9sbyA9ICgodTMyKSBzY3AtPmNtbmRbMV0gPDwgMTYpIHwKKwkJCSgodTMyKSBzY3AtPmNtbmRb
Ml0gPDwgOCkgfCAodTMyKSBzY3AtPmNtbmRbM107CisKKwkJc3RhcnRfbGJhX2xvICY9IDB4MUZG
RkZGOworCX0KKworCS8qCisJICogMTAtYnl0ZSBSRUFEKDB4MjgpIG9yIFdSSVRFKDB4MkEpIGNk
YgorCSAqLworCWVsc2UgaWYgKHNjcC0+Y21kX2xlbiA9PSAxMCkgeworCQlpb19yZXF1ZXN0LT5E
YXRhTGVuZ3RoID0gKHUzMikgc2NwLT5jbW5kWzhdIHwKKwkJCSgodTMyKSBzY3AtPmNtbmRbN10g
PDwgOCk7CisJCXN0YXJ0X2xiYV9sbyA9ICgodTMyKSBzY3AtPmNtbmRbMl0gPDwgMjQpIHwKKwkJ
CSgodTMyKSBzY3AtPmNtbmRbM10gPDwgMTYpIHwKKwkJCSgodTMyKSBzY3AtPmNtbmRbNF0gPDwg
OCkgfCAodTMyKSBzY3AtPmNtbmRbNV07CisJfQorCisJLyoKKwkgKiAxMi1ieXRlIFJFQUQoMHhB
OCkgb3IgV1JJVEUoMHhBQSkgY2RiCisJICovCisJZWxzZSBpZiAoc2NwLT5jbWRfbGVuID09IDEy
KSB7CisJCWlvX3JlcXVlc3QtPkRhdGFMZW5ndGggPSAoKHUzMikgc2NwLT5jbW5kWzZdIDw8IDI0
KSB8CisJCQkoKHUzMikgc2NwLT5jbW5kWzddIDw8IDE2KSB8CisJCQkoKHUzMikgc2NwLT5jbW5k
WzhdIDw8IDgpIHwgKHUzMikgc2NwLT5jbW5kWzldOworCQlzdGFydF9sYmFfbG8gPSAoKHUzMikg
c2NwLT5jbW5kWzJdIDw8IDI0KSB8CisJCQkoKHUzMikgc2NwLT5jbW5kWzNdIDw8IDE2KSB8CisJ
CQkoKHUzMikgc2NwLT5jbW5kWzRdIDw8IDgpIHwgKHUzMikgc2NwLT5jbW5kWzVdOworCX0KKwor
CS8qCisJICogMTYtYnl0ZSBSRUFEKDB4ODgpIG9yIFdSSVRFKDB4OEEpIGNkYgorCSAqLworCWVs
c2UgaWYgKHNjcC0+Y21kX2xlbiA9PSAxNikgeworCQlpb19yZXF1ZXN0LT5EYXRhTGVuZ3RoID0g
KCh1MzIpIHNjcC0+Y21uZFsxMF0gPDwgMjQpIHwKKwkJCSgodTMyKSBzY3AtPmNtbmRbMTFdIDw8
IDE2KSB8CisJCQkoKHUzMikgc2NwLT5jbW5kWzEyXSA8PCA4KSB8ICh1MzIpIHNjcC0+Y21uZFsx
M107CisJCXN0YXJ0X2xiYV9sbyA9ICgodTMyKSBzY3AtPmNtbmRbNl0gPDwgMjQpIHwKKwkJCSgo
dTMyKSBzY3AtPmNtbmRbN10gPDwgMTYpIHwKKwkJCSgodTMyKSBzY3AtPmNtbmRbOF0gPDwgOCkg
fCAodTMyKSBzY3AtPmNtbmRbOV07CisKKwkJc3RhcnRfbGJhX2hpID0gKCh1MzIpIHNjcC0+Y21u
ZFsyXSA8PCAyNCkgfAorCQkJKCh1MzIpIHNjcC0+Y21uZFszXSA8PCAxNikgfAorCQkJKCh1MzIp
IHNjcC0+Y21uZFs0XSA8PCA4KSB8ICh1MzIpIHNjcC0+Y21uZFs1XTsKKwl9CisKKwltZW1zZXQo
JmlvX2luZm8sIDAsIHNpemVvZihzdHJ1Y3QgSU9fUkVRVUVTVF9JTkZPKSk7CisJaW9faW5mby5s
ZFN0YXJ0QmxvY2sgPSAoKHU2NClzdGFydF9sYmFfaGkgPDwgMzIpIHwgc3RhcnRfbGJhX2xvOwor
CWlvX2luZm8ubnVtQmxvY2tzID0gaW9fcmVxdWVzdC0+RGF0YUxlbmd0aDsKKwlpb19pbmZvLmxk
VGd0SWQgPSBkZXZpY2VfaWQ7CisKKwlpZiAoc2NwLT5zY19kYXRhX2RpcmVjdGlvbiA9PSBQQ0lf
RE1BX0ZST01ERVZJQ0UpCisJCWlvX2luZm8uaXNSZWFkID0gMTsKKworCWxvY2FsX21hcF9wdHIg
PSBmdXNpb24tPmxkX21hcFsoaW5zdGFuY2UtPm1hcF9pZCAmIDEpXTsKKworCWlmICgoTVJfVGFy
Z2V0SWRUb0xkR2V0KGRldmljZV9pZCwgbG9jYWxfbWFwX3B0cikgPj0KKwkgICAgIE1BWF9MT0dJ
Q0FMX0RSSVZFUykgfHwgKCFmdXNpb24tPmZhc3RfcGF0aF9pbykpIHsKKwkJaW9fcmVxdWVzdC0+
UmFpZENvbnRleHQucmVnTG9ja0ZsYWdzICA9IDA7CisJCWZwX3Bvc3NpYmxlID0gMDsKKwl9IGVs
c2UgeworCQlpZiAoTVJfQnVpbGRSYWlkQ29udGV4dCgmaW9faW5mbywgJmlvX3JlcXVlc3QtPlJh
aWRDb250ZXh0LAorCQkJCQlsb2NhbF9tYXBfcHRyKSkKKwkJCWZwX3Bvc3NpYmxlID0gaW9faW5m
by5mcE9rRm9ySW87CisJfQorCisJaWYgKGZwX3Bvc3NpYmxlKSB7CisJCW1lZ2FzYXNfc2V0X3Bk
X2xiYShpb19yZXF1ZXN0LCBzY3AtPmNtZF9sZW4sICZpb19pbmZvLCBzY3AsCisJCQkJICAgbG9j
YWxfbWFwX3B0ciwgc3RhcnRfbGJhX2xvKTsKKwkJaW9fcmVxdWVzdC0+RGF0YUxlbmd0aCA9IHNj
c2lfYnVmZmxlbihzY3ApOworCQlpb19yZXF1ZXN0LT5GdW5jdGlvbiA9IE1QSTJfRlVOQ1RJT05f
U0NTSV9JT19SRVFVRVNUOworCQljbWQtPnJlcXVlc3RfZGVzYy0+U0NTSUlPLlJlcXVlc3RGbGFn
cyA9CisJCQkoTVBJMl9SRVFfREVTQ1JJUFRfRkxBR1NfSElHSF9QUklPUklUWQorCQkJIDw8IE1F
R0FTQVNfUkVRX0RFU0NSSVBUX0ZMQUdTX1RZUEVfU0hJRlQpOworCQlpZiAoKGZ1c2lvbi0+bG9h
ZF9iYWxhbmNlX2luZm9bZGV2aWNlX2lkXS5sb2FkQmFsYW5jZUZsYWcpICYmCisJCSAgICAoaW9f
aW5mby5pc1JlYWQpKSB7CisJCQlpb19pbmZvLmRldkhhbmRsZSA9CisJCQkJZ2V0X3VwZGF0ZWRf
ZGV2X2hhbmRsZSgKKwkJCQkJJmZ1c2lvbi0+bG9hZF9iYWxhbmNlX2luZm9bZGV2aWNlX2lkXSwK
KwkJCQkJJmlvX2luZm8pOworCQkJc2NwLT5TQ3AuU3RhdHVzIHw9IE1FR0FTQVNfTE9BRF9CQUxB
TkNFX0ZMQUc7CisJCX0gZWxzZQorCQkJc2NwLT5TQ3AuU3RhdHVzICY9IH5NRUdBU0FTX0xPQURf
QkFMQU5DRV9GTEFHOworCQljbWQtPnJlcXVlc3RfZGVzYy0+U0NTSUlPLkRldkhhbmRsZSA9IGlv
X2luZm8uZGV2SGFuZGxlOworCQlpb19yZXF1ZXN0LT5EZXZIYW5kbGUgPSBpb19pbmZvLmRldkhh
bmRsZTsKKwl9IGVsc2UgeworCQlpb19yZXF1ZXN0LT5SYWlkQ29udGV4dC50aW1lb3V0VmFsdWUg
PQorCQkJbG9jYWxfbWFwX3B0ci0+cmFpZE1hcC5mcFBkSW9UaW1lb3V0U2VjOworCQlpb19yZXF1
ZXN0LT5GdW5jdGlvbiA9IE1FR0FTQVNfTVBJMl9GVU5DVElPTl9MRF9JT19SRVFVRVNUOworCQlp
b19yZXF1ZXN0LT5EZXZIYW5kbGUgPSBkZXZpY2VfaWQ7CisJCWNtZC0+cmVxdWVzdF9kZXNjLT5T
Q1NJSU8uUmVxdWVzdEZsYWdzID0KKwkJCShNRUdBU0FTX1JFUV9ERVNDUklQVF9GTEFHU19MRF9J
TworCQkJIDw8IE1FR0FTQVNfUkVRX0RFU0NSSVBUX0ZMQUdTX1RZUEVfU0hJRlQpOworCX0gLyog
Tm90IEZQICovCit9CisKKy8qKgorICogbWVnYXNhc19idWlsZF9kY2RiX2Z1c2lvbiAtCVByZXBh
cmVzIElPcyB0byBkZXZpY2VzCisgKiBAaW5zdGFuY2U6CQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAq
IEBzY3A6CQlTQ1NJIGNvbW1hbmQKKyAqIEBjbWQ6CQlDb21tYW5kIHRvIGJlIHByZXBhcmVkCisg
KgorICogUHJlcGFyZXMgdGhlIGlvX3JlcXVlc3QgZnJhbWUgZm9yIG5vbi1pbyBjbWRzCisgKi8K
K3N0YXRpYyB2b2lkCittZWdhc2FzX2J1aWxkX2RjZGJfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX2lu
c3RhbmNlICppbnN0YW5jZSwKKwkJCSAgc3RydWN0IHNjc2lfY21uZCAqc2NtZCwKKwkJCSAgc3Ry
dWN0IG1lZ2FzYXNfY21kX2Z1c2lvbiAqY21kKQoreworCXUzMiBkZXZpY2VfaWQ7CisJc3RydWN0
IE1QSTJfUkFJRF9TQ1NJX0lPX1JFUVVFU1QgKmlvX3JlcXVlc3Q7CisJdTE2IHBkX2luZGV4ID0g
MDsKKwlzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICpsb2NhbF9tYXBfcHRyOworCXN0cnVjdCBm
dXNpb25fY29udGV4dCAqZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKKworCWlvX3Jl
cXVlc3QgPSBjbWQtPmlvX3JlcXVlc3Q7CisJZGV2aWNlX2lkID0gTUVHQVNBU19ERVZfSU5ERVgo
aW5zdGFuY2UsIHNjbWQpOworCXBkX2luZGV4ID0gKHNjbWQtPmRldmljZS0+Y2hhbm5lbCAqIE1F
R0FTQVNfTUFYX0RFVl9QRVJfQ0hBTk5FTCkKKwkJK3NjbWQtPmRldmljZS0+aWQ7CisJbG9jYWxf
bWFwX3B0ciA9IGZ1c2lvbi0+bGRfbWFwWyhpbnN0YW5jZS0+bWFwX2lkICYgMSldOworCisJLyog
Q2hlY2sgaWYgdGhpcyBpcyBhIHN5c3RlbSBQRCBJL08gKi8KKwlpZiAoKGluc3RhbmNlLT5wZF9s
aXN0W3BkX2luZGV4XS5kcml2ZVN0YXRlID09IE1SX1BEX1NUQVRFX1NZU1RFTSkgJiYKKwkgICAg
KGluc3RhbmNlLT5wZF9saXN0W3BkX2luZGV4XS5kcml2ZVR5cGUgPT0gVFlQRV9ESVNLKSkgewor
CQlpb19yZXF1ZXN0LT5GdW5jdGlvbiA9IDA7CisJCWlvX3JlcXVlc3QtPkRldkhhbmRsZSA9CisJ
CQlsb2NhbF9tYXBfcHRyLT5yYWlkTWFwLmRldkhuZGxJbmZvW2RldmljZV9pZF0uY3VyRGV2SGRs
OworCQlpb19yZXF1ZXN0LT5SYWlkQ29udGV4dC50aW1lb3V0VmFsdWUgPQorCQkJbG9jYWxfbWFw
X3B0ci0+cmFpZE1hcC5mcFBkSW9UaW1lb3V0U2VjOworCQlpb19yZXF1ZXN0LT5SYWlkQ29udGV4
dC5yZWdMb2NrRmxhZ3MgPSAwOworCQlpb19yZXF1ZXN0LT5SYWlkQ29udGV4dC5yZWdMb2NrUm93
TEJBID0gMDsKKwkJaW9fcmVxdWVzdC0+UmFpZENvbnRleHQucmVnTG9ja0xlbmd0aCA9IDA7CisJ
CWlvX3JlcXVlc3QtPlJhaWRDb250ZXh0LlJBSURGbGFncyA9CisJCQlNUl9SQUlEX0ZMQUdTX0lP
X1NVQl9UWVBFX1NZU1RFTV9QRCA8PAorCQkJTVJfUkFJRF9DVFhfUkFJRF9GTEFHU19JT19TVUJf
VFlQRV9TSElGVDsKKwkJY21kLT5yZXF1ZXN0X2Rlc2MtPlNDU0lJTy5SZXF1ZXN0RmxhZ3MgPQor
CQkJKE1QSTJfUkVRX0RFU0NSSVBUX0ZMQUdTX0hJR0hfUFJJT1JJVFkgPDwKKwkJCSBNRUdBU0FT
X1JFUV9ERVNDUklQVF9GTEFHU19UWVBFX1NISUZUKTsKKwl9IGVsc2UgeworCQlpb19yZXF1ZXN0
LT5GdW5jdGlvbiAgPSBNRUdBU0FTX01QSTJfRlVOQ1RJT05fTERfSU9fUkVRVUVTVDsKKwkJaW9f
cmVxdWVzdC0+RGV2SGFuZGxlID0gZGV2aWNlX2lkOworCQljbWQtPnJlcXVlc3RfZGVzYy0+U0NT
SUlPLlJlcXVlc3RGbGFncyA9CisJCQkoTVBJMl9SRVFfREVTQ1JJUFRfRkxBR1NfU0NTSV9JTyA8
PAorCQkJIE1FR0FTQVNfUkVRX0RFU0NSSVBUX0ZMQUdTX1RZUEVfU0hJRlQpOworCX0KKwlpb19y
ZXF1ZXN0LT5SYWlkQ29udGV4dC5WaXJ0dWFsRGlza1RndElkID0gZGV2aWNlX2lkOworCWlvX3Jl
cXVlc3QtPkxVTlswXSA9IHNjbWQtPmRldmljZS0+bHVuOworCWlvX3JlcXVlc3QtPkRhdGFMZW5n
dGggPSBzY3NpX2J1ZmZsZW4oc2NtZCk7Cit9CisKKy8qKgorICogbWVnYXNhc19idWlsZF9pb19m
dXNpb24gLQlQcmVwYXJlcyBJT3MgdG8gZGV2aWNlcworICogQGluc3RhbmNlOgkJQWRhcHRlciBz
b2Z0IHN0YXRlCisgKiBAc2NwOgkJU0NTSSBjb21tYW5kCisgKiBAY21kOgkJQ29tbWFuZCB0byBi
ZSBwcmVwYXJlZAorICoKKyAqIEludm9rZXMgaGVscGVyIGZ1bmN0aW9ucyB0byBwcmVwYXJlIHJl
cXVlc3QgZnJhbWVzCisgKiBhbmQgc2V0cyBmbGFncyBhcHByb3ByaWF0ZSBmb3IgSU8vTm9uLUlP
IGNtZAorICovCitpbnQKK21lZ2FzYXNfYnVpbGRfaW9fZnVzaW9uKHN0cnVjdCBtZWdhc2FzX2lu
c3RhbmNlICppbnN0YW5jZSwKKwkJCXN0cnVjdCBzY3NpX2NtbmQgKnNjcCwKKwkJCXN0cnVjdCBt
ZWdhc2FzX2NtZF9mdXNpb24gKmNtZCkKK3sKKwl1MzIgZGV2aWNlX2lkLCBzZ2VfY291bnQ7CisJ
c3RydWN0IE1QSTJfUkFJRF9TQ1NJX0lPX1JFUVVFU1QgKmlvX3JlcXVlc3QgPSBjbWQtPmlvX3Jl
cXVlc3Q7CisKKwlkZXZpY2VfaWQgPSBNRUdBU0FTX0RFVl9JTkRFWChpbnN0YW5jZSwgc2NwKTsK
KworCS8qIFplcm8gb3V0IHNvbWUgZmllbGRzIHNvIHRoZXkgZG9uJ3QgZ2V0IHJldXNlZCAqLwor
CWlvX3JlcXVlc3QtPkxVTlswXSA9IDA7CisJaW9fcmVxdWVzdC0+Q0RCLkVFRFAzMi5QcmltYXJ5
UmVmZXJlbmNlVGFnID0gMDsKKwlpb19yZXF1ZXN0LT5DREIuRUVEUDMyLlByaW1hcnlBcHBsaWNh
dGlvblRhZ01hc2sgPSAwOworCWlvX3JlcXVlc3QtPkVFRFBGbGFncyA9IDA7CisJaW9fcmVxdWVz
dC0+Q29udHJvbCA9IDA7CisJaW9fcmVxdWVzdC0+RUVEUEJsb2NrU2l6ZSA9IDA7CisJaW9fcmVx
dWVzdC0+SW9GbGFncyA9IDA7CisJaW9fcmVxdWVzdC0+UmFpZENvbnRleHQuUkFJREZsYWdzID0g
MDsKKworCW1lbWNweShpb19yZXF1ZXN0LT5DREIuQ0RCMzIsIHNjcC0+Y21uZCwgc2NwLT5jbWRf
bGVuKTsKKwkvKgorCSAqIEp1c3QgdGhlIENEQiBsZW5ndGgscmVzdCBvZiB0aGUgRmxhZ3MgYXJl
IHplcm8KKwkgKiBUaGlzIHdpbGwgYmUgbW9kaWZpZWQgZm9yIEZQIGluIGJ1aWxkX2xkaW9fZnVz
aW9uCisJICovCisJaW9fcmVxdWVzdC0+SW9GbGFncyA9IHNjcC0+Y21kX2xlbjsKKworCWlmICht
ZWdhc2FzX2lzX2xkaW8oc2NwKSkKKwkJbWVnYXNhc19idWlsZF9sZGlvX2Z1c2lvbihpbnN0YW5j
ZSwgc2NwLCBjbWQpOworCWVsc2UKKwkJbWVnYXNhc19idWlsZF9kY2RiX2Z1c2lvbihpbnN0YW5j
ZSwgc2NwLCBjbWQpOworCisJLyoKKwkgKiBDb25zdHJ1Y3QgU0dMCisJICovCisKKwlzZ2VfY291
bnQgPQorCQltZWdhc2FzX21ha2Vfc2dsX2Z1c2lvbihpbnN0YW5jZSwgc2NwLAorCQkJCQkoc3Ry
dWN0IE1QSTI1X0lFRUVfU0dFX0NIQUlONjQgKikKKwkJCQkJJmlvX3JlcXVlc3QtPlNHTCwgY21k
KTsKKworCWlmIChzZ2VfY291bnQgPiBpbnN0YW5jZS0+bWF4X251bV9zZ2UpIHsKKwkJcHJpbnRr
KEtFUk5fRVJSICJtZWdhc2FzOiBFcnJvci4gc2dlX2NvdW50ICgweCV4KSBleGNlZWRzICIKKwkJ
ICAgICAgICJtYXggKDB4JXgpIGFsbG93ZWRcbiIsIHNnZV9jb3VudCwKKwkJICAgICAgIGluc3Rh
bmNlLT5tYXhfbnVtX3NnZSk7CisJCXJldHVybiAxOworCX0KKworCWlvX3JlcXVlc3QtPlJhaWRD
b250ZXh0Lm51bVNHRSA9IHNnZV9jb3VudDsKKworCWlvX3JlcXVlc3QtPlNHTEZsYWdzID0gTVBJ
Ml9TR0VfRkxBR1NfNjRfQklUX0FERFJFU1NJTkc7CisKKwlpZiAoc2NwLT5zY19kYXRhX2RpcmVj
dGlvbiA9PSBQQ0lfRE1BX1RPREVWSUNFKQorCQlpb19yZXF1ZXN0LT5Db250cm9sIHw9IE1QSTJf
U0NTSUlPX0NPTlRST0xfV1JJVEU7CisJZWxzZSBpZiAoc2NwLT5zY19kYXRhX2RpcmVjdGlvbiA9
PSBQQ0lfRE1BX0ZST01ERVZJQ0UpCisJCWlvX3JlcXVlc3QtPkNvbnRyb2wgfD0gTVBJMl9TQ1NJ
SU9fQ09OVFJPTF9SRUFEOworCisJaW9fcmVxdWVzdC0+U0dMT2Zmc2V0MCA9CisJCW9mZnNldG9m
KHN0cnVjdCBNUEkyX1JBSURfU0NTSV9JT19SRVFVRVNULCBTR0wpIC8gNDsKKworCWlvX3JlcXVl
c3QtPlNlbnNlQnVmZmVyTG93QWRkcmVzcyA9IGNtZC0+c2Vuc2VfcGh5c19hZGRyOworCWlvX3Jl
cXVlc3QtPlNlbnNlQnVmZmVyTGVuZ3RoID0gU0NTSV9TRU5TRV9CVUZGRVJTSVpFOworCisJY21k
LT5zY21kID0gc2NwOworCXNjcC0+U0NwLnB0ciA9IChjaGFyICopY21kOworCisJcmV0dXJuIDA7
Cit9CisKK3VuaW9uIE1FR0FTQVNfUkVRVUVTVF9ERVNDUklQVE9SX1VOSU9OICoKK21lZ2FzYXNf
Z2V0X3JlcXVlc3RfZGVzY3JpcHRvcihzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2Us
IHUxNiBpbmRleCkKK3sKKwl1OCAqcDsKKwlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lvbjsK
KworCWlmIChpbmRleCA+PSBpbnN0YW5jZS0+bWF4X2Z3X2NtZHMpIHsKKwkJcHJpbnRrKEtFUk5f
RVJSICJtZWdhc2FzOiBJbnZhbGlkIFNNSUQgKDB4JXgpcmVxdWVzdCBmb3IgIgorCQkgICAgICAg
ImRlc2NyaXB0b3JcbiIsIGluZGV4KTsKKwkJcmV0dXJuIE5VTEw7CisJfQorCWZ1c2lvbiA9IGlu
c3RhbmNlLT5jdHJsX2NvbnRleHQ7CisJcCA9IGZ1c2lvbi0+cmVxX2ZyYW1lc19kZXNjCisJCStz
aXplb2YodW5pb24gTUVHQVNBU19SRVFVRVNUX0RFU0NSSVBUT1JfVU5JT04pICppbmRleDsKKwor
CXJldHVybiAodW5pb24gTUVHQVNBU19SRVFVRVNUX0RFU0NSSVBUT1JfVU5JT04gKilwOworfQor
CisvKioKKyAqIG1lZ2FzYXNfYnVpbGRfYW5kX2lzc3VlX2NtZF9mdXNpb24gLU1haW4gcm91dGlu
ZSBmb3IgYnVpbGRpbmcgYW5kCisgKiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBpc3N1aW5nIG5vbiBJT0NUTCBjbWQKKyAqIEBpbnN0YW5jZToJCQlBZGFwdGVyIHNvZnQgc3Rh
dGUKKyAqIEBzY21kOgkJCXBvaW50ZXIgdG8gc2NzaSBjbWQgZnJvbSBPUworICovCitzdGF0aWMg
dTMyCittZWdhc2FzX2J1aWxkX2FuZF9pc3N1ZV9jbWRfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX2lu
c3RhbmNlICppbnN0YW5jZSwKKwkJCQkgICBzdHJ1Y3Qgc2NzaV9jbW5kICpzY21kKQoreworCXN0
cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24gKmNtZDsKKwl1bmlvbiBNRUdBU0FTX1JFUVVFU1RfREVT
Q1JJUFRPUl9VTklPTiAqcmVxX2Rlc2M7CisJdTMyIGluZGV4OworCXN0cnVjdCBmdXNpb25fY29u
dGV4dCAqZnVzaW9uOworCisJZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKKworCWNt
ZCA9IG1lZ2FzYXNfZ2V0X2NtZF9mdXNpb24oaW5zdGFuY2UpOworCWlmICghY21kKQorCQlyZXR1
cm4gU0NTSV9NTFFVRVVFX0hPU1RfQlVTWTsKKworCWluZGV4ID0gY21kLT5pbmRleDsKKworCXJl
cV9kZXNjID0gbWVnYXNhc19nZXRfcmVxdWVzdF9kZXNjcmlwdG9yKGluc3RhbmNlLCBpbmRleC0x
KTsKKwlpZiAoIXJlcV9kZXNjKQorCQlyZXR1cm4gMTsKKworCXJlcV9kZXNjLT5Xb3JkcyA9IDA7
CisJY21kLT5yZXF1ZXN0X2Rlc2MgPSByZXFfZGVzYzsKKwljbWQtPnJlcXVlc3RfZGVzYy0+V29y
ZHMgPSAwOworCisJaWYgKG1lZ2FzYXNfYnVpbGRfaW9fZnVzaW9uKGluc3RhbmNlLCBzY21kLCBj
bWQpKSB7CisJCW1lZ2FzYXNfcmV0dXJuX2NtZF9mdXNpb24oaW5zdGFuY2UsIGNtZCk7CisJCXBy
aW50ayhLRVJOX0VSUiAibWVnYXNhczogRXJyb3IgYnVpbGRpbmcgY29tbWFuZC5cbiIpOworCQlj
bWQtPnJlcXVlc3RfZGVzYyA9IE5VTEw7CisJCXJldHVybiAxOworCX0KKworCXJlcV9kZXNjID0g
Y21kLT5yZXF1ZXN0X2Rlc2M7CisJcmVxX2Rlc2MtPlNDU0lJTy5TTUlEID0gaW5kZXg7CisKKwlp
ZiAoY21kLT5pb19yZXF1ZXN0LT5DaGFpbk9mZnNldCAhPSAwICYmCisJICAgIGNtZC0+aW9fcmVx
dWVzdC0+Q2hhaW5PZmZzZXQgIT0gMHhGKQorCQlwcmludGsoS0VSTl9FUlIgIm1lZ2FzYXM6IFRo
ZSBjaGFpbiBvZmZzZXQgdmFsdWUgaXMgbm90ICIKKwkJICAgICAgICJjb3JyZWN0IDogJXhcbiIs
IGNtZC0+aW9fcmVxdWVzdC0+Q2hhaW5PZmZzZXQpOworCisJLyoKKwkgKiBJc3N1ZSB0aGUgY29t
bWFuZCB0byB0aGUgRlcKKwkgKi8KKwlhdG9taWNfaW5jKCZpbnN0YW5jZS0+Zndfb3V0c3RhbmRp
bmcpOworCisJaW5zdGFuY2UtPmluc3RhbmNldC0+ZmlyZV9jbWQoaW5zdGFuY2UsCisJCQkJICAg
ICAgcmVxX2Rlc2MtPnUubG93LCByZXFfZGVzYy0+dS5oaWdoLAorCQkJCSAgICAgIGluc3RhbmNl
LT5yZWdfc2V0KTsKKworCXJldHVybiAwOworfQorCisvKioKKyAqIGNvbXBsZXRlX2NtZF9mdXNp
b24gLQlDb21wbGV0ZXMgY29tbWFuZAorICogQGluc3RhbmNlOgkJCUFkYXB0ZXIgc29mdCBzdGF0
ZQorICogQ29tcGxldGVzIGFsbCBjb21tYW5kcyB0aGF0IGlzIGluIHJlcGx5IGRlc2NyaXB0b3Ig
cXVldWUKKyAqLworaW50Citjb21wbGV0ZV9jbWRfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX2luc3Rh
bmNlICppbnN0YW5jZSkKK3sKKwl1bmlvbiBNUEkyX1JFUExZX0RFU0NSSVBUT1JTX1VOSU9OICpk
ZXNjOworCXN0cnVjdCBNUEkyX1NDU0lfSU9fU1VDQ0VTU19SRVBMWV9ERVNDUklQVE9SICpyZXBs
eV9kZXNjOworCXN0cnVjdCBNUEkyX1JBSURfU0NTSV9JT19SRVFVRVNUICpzY3NpX2lvX3JlcTsK
KwlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lvbjsKKwlzdHJ1Y3QgbWVnYXNhc19jbWQgKmNt
ZF9tZmk7CisJc3RydWN0IG1lZ2FzYXNfY21kX2Z1c2lvbiAqY21kX2Z1c2lvbjsKKwl1MTYgc21p
ZCwgbnVtX2NvbXBsZXRlZDsKKwl1OCByZXBseV9kZXNjcmlwdF90eXBlLCBhcm07CisJdTMyIHN0
YXR1cywgZXh0U3RhdHVzLCBkZXZpY2VfaWQ7CisJdW5pb24gZGVzY192YWx1ZSBkX3ZhbDsKKwlz
dHJ1Y3QgTERfTE9BRF9CQUxBTkNFX0lORk8gKmxiaW5mbzsKKworCWZ1c2lvbiA9IGluc3RhbmNl
LT5jdHJsX2NvbnRleHQ7CisKKwlpZiAoaW5zdGFuY2UtPmFkcHJlY292ZXJ5ID09IE1FR0FTQVNf
SFdfQ1JJVElDQUxfRVJST1IpCisJCXJldHVybiBJUlFfSEFORExFRDsKKworCWRlc2MgPSBmdXNp
b24tPnJlcGx5X2ZyYW1lc19kZXNjOworCWRlc2MgKz0gZnVzaW9uLT5sYXN0X3JlcGx5X2lkeDsK
KworCXJlcGx5X2Rlc2MgPSAoc3RydWN0IE1QSTJfU0NTSV9JT19TVUNDRVNTX1JFUExZX0RFU0NS
SVBUT1IgKilkZXNjOworCisJZF92YWwud29yZCA9IGRlc2MtPldvcmRzOworCisJcmVwbHlfZGVz
Y3JpcHRfdHlwZSA9IHJlcGx5X2Rlc2MtPlJlcGx5RmxhZ3MgJgorCQlNUEkyX1JQWV9ERVNDUklQ
VF9GTEFHU19UWVBFX01BU0s7CisKKwlpZiAocmVwbHlfZGVzY3JpcHRfdHlwZSA9PSBNUEkyX1JQ
WV9ERVNDUklQVF9GTEFHU19VTlVTRUQpCisJCXJldHVybiBJUlFfTk9ORTsKKworCWRfdmFsLndv
cmQgPSBkZXNjLT5Xb3JkczsKKworCW51bV9jb21wbGV0ZWQgPSAwOworCisJd2hpbGUgKChkX3Zh
bC51LmxvdyAhPSBVSU5UX01BWCkgJiYgKGRfdmFsLnUuaGlnaCAhPSBVSU5UX01BWCkpIHsKKwkJ
c21pZCA9IHJlcGx5X2Rlc2MtPlNNSUQ7CisKKwkJY21kX2Z1c2lvbiA9IGZ1c2lvbi0+Y21kX2xp
c3Rbc21pZCAtIDFdOworCisJCXNjc2lfaW9fcmVxID0KKwkJCShzdHJ1Y3QgTVBJMl9SQUlEX1ND
U0lfSU9fUkVRVUVTVCAqKQorCQkgIGNtZF9mdXNpb24tPmlvX3JlcXVlc3Q7CisKKwkJaWYgKGNt
ZF9mdXNpb24tPnNjbWQpCisJCQljbWRfZnVzaW9uLT5zY21kLT5TQ3AucHRyID0gTlVMTDsKKwor
CQlzdGF0dXMgPSBzY3NpX2lvX3JlcS0+UmFpZENvbnRleHQuc3RhdHVzOworCQlleHRTdGF0dXMg
PSBzY3NpX2lvX3JlcS0+UmFpZENvbnRleHQuZXhTdGF0dXM7CisKKwkJc3dpdGNoIChzY3NpX2lv
X3JlcS0+RnVuY3Rpb24pIHsKKwkJY2FzZSBNUEkyX0ZVTkNUSU9OX1NDU0lfSU9fUkVRVUVTVDog
IC8qRmFzdCBQYXRoIElPLiovCisJCQkvKiBVcGRhdGUgbG9hZCBiYWxhbmNpbmcgaW5mbyAqLwor
CQkJZGV2aWNlX2lkID0gTUVHQVNBU19ERVZfSU5ERVgoaW5zdGFuY2UsCisJCQkJCQkgICAgICBj
bWRfZnVzaW9uLT5zY21kKTsKKwkJCWxiaW5mbyA9ICZmdXNpb24tPmxvYWRfYmFsYW5jZV9pbmZv
W2RldmljZV9pZF07CisJCQlpZiAoY21kX2Z1c2lvbi0+c2NtZC0+U0NwLlN0YXR1cyAmCisJCQkg
ICAgTUVHQVNBU19MT0FEX0JBTEFOQ0VfRkxBRykgeworCQkJCWFybSA9IGxiaW5mby0+cmFpZDFE
ZXZIYW5kbGVbMF0gPT0KKwkJCQkJY21kX2Z1c2lvbi0+aW9fcmVxdWVzdC0+RGV2SGFuZGxlID8g
MCA6CisJCQkJCTE7CisJCQkJYXRvbWljX2RlYygmbGJpbmZvLT5zY3NpX3BlbmRpbmdfY21kc1th
cm1dKTsKKwkJCQljbWRfZnVzaW9uLT5zY21kLT5TQ3AuU3RhdHVzICY9CisJCQkJCX5NRUdBU0FT
X0xPQURfQkFMQU5DRV9GTEFHOworCQkJfQorCQkJaWYgKHJlcGx5X2Rlc2NyaXB0X3R5cGUgPT0K
KwkJCSAgICBNUEkyX1JQWV9ERVNDUklQVF9GTEFHU19TQ1NJX0lPX1NVQ0NFU1MpIHsKKwkJCQlp
ZiAobWVnYXNhc19kYmdfbHZsID09IDUpCisJCQkJCXByaW50ayhLRVJOX0VSUiAiXG5tZWdhc2Fz
OiBGQVNUIFBhdGggIgorCQkJCQkgICAgICAgIklPIFN1Y2Nlc3NcbiIpOworCQkJfQorCQkJLyog
RmFsbCB0aHJ1IGFuZCBjb21wbGV0ZSBJTyAqLworCQljYXNlIE1FR0FTQVNfTVBJMl9GVU5DVElP
Tl9MRF9JT19SRVFVRVNUOiAvKiBMRC1JTyBQYXRoICovCisJCQkvKiBNYXAgdGhlIEZXIENtZCBT
dGF0dXMgKi8KKwkJCW1hcF9jbWRfc3RhdHVzKGNtZF9mdXNpb24sIHN0YXR1cywgZXh0U3RhdHVz
KTsKKwkJCXNjc2lfZG1hX3VubWFwKGNtZF9mdXNpb24tPnNjbWQpOworCQkJY21kX2Z1c2lvbi0+
c2NtZC0+c2NzaV9kb25lKGNtZF9mdXNpb24tPnNjbWQpOworCQkJc2NzaV9pb19yZXEtPlJhaWRD
b250ZXh0LnN0YXR1cyA9IDA7CisJCQlzY3NpX2lvX3JlcS0+UmFpZENvbnRleHQuZXhTdGF0dXMg
PSAwOworCQkJbWVnYXNhc19yZXR1cm5fY21kX2Z1c2lvbihpbnN0YW5jZSwgY21kX2Z1c2lvbik7
CisJCQlhdG9taWNfZGVjKCZpbnN0YW5jZS0+Zndfb3V0c3RhbmRpbmcpOworCisJCQlicmVhazsK
KwkJY2FzZSBNRUdBU0FTX01QSTJfRlVOQ1RJT05fUEFTU1RIUlVfSU9fUkVRVUVTVDogLypNRkkg
Y29tbWFuZCAqLworCQkJY21kX21maSA9IGluc3RhbmNlLT5jbWRfbGlzdFtjbWRfZnVzaW9uLT5z
eW5jX2NtZF9pZHhdOworCQkJbWVnYXNhc19jb21wbGV0ZV9jbWQoaW5zdGFuY2UsIGNtZF9tZmks
IERJRF9PSyk7CisJCQljbWRfZnVzaW9uLT5mbGFncyA9IDA7CisJCQltZWdhc2FzX3JldHVybl9j
bWRfZnVzaW9uKGluc3RhbmNlLCBjbWRfZnVzaW9uKTsKKworCQkJYnJlYWs7CisJCX0KKworCQlm
dXNpb24tPmxhc3RfcmVwbHlfaWR4Kys7CisJCWlmIChmdXNpb24tPmxhc3RfcmVwbHlfaWR4ID49
IGZ1c2lvbi0+cmVwbHlfcV9kZXB0aCkKKwkJCWZ1c2lvbi0+bGFzdF9yZXBseV9pZHggPSAwOwor
CisJCWRlc2MtPldvcmRzID0gVUxMT05HX01BWDsKKwkJbnVtX2NvbXBsZXRlZCsrOworCisJCS8q
IEdldCB0aGUgbmV4dCByZXBseSBkZXNjcmlwdG9yICovCisJCWlmICghZnVzaW9uLT5sYXN0X3Jl
cGx5X2lkeCkKKwkJCWRlc2MgPSBmdXNpb24tPnJlcGx5X2ZyYW1lc19kZXNjOworCQllbHNlCisJ
CQlkZXNjKys7CisKKwkJcmVwbHlfZGVzYyA9CisJCSAgKHN0cnVjdCBNUEkyX1NDU0lfSU9fU1VD
Q0VTU19SRVBMWV9ERVNDUklQVE9SICopZGVzYzsKKworCQlkX3ZhbC53b3JkID0gZGVzYy0+V29y
ZHM7CisKKwkJcmVwbHlfZGVzY3JpcHRfdHlwZSA9IHJlcGx5X2Rlc2MtPlJlcGx5RmxhZ3MgJgor
CQkJTVBJMl9SUFlfREVTQ1JJUFRfRkxBR1NfVFlQRV9NQVNLOworCisJCWlmIChyZXBseV9kZXNj
cmlwdF90eXBlID09IE1QSTJfUlBZX0RFU0NSSVBUX0ZMQUdTX1VOVVNFRCkKKwkJCWJyZWFrOwor
CX0KKworCWlmICghbnVtX2NvbXBsZXRlZCkKKwkJcmV0dXJuIElSUV9OT05FOworCisJd21iKCk7
CisJd3JpdGVsKGZ1c2lvbi0+bGFzdF9yZXBseV9pZHgsCisJICAgICAgICZpbnN0YW5jZS0+cmVn
X3NldC0+cmVwbHlfcG9zdF9ob3N0X2luZGV4KTsKKworCXJldHVybiBJUlFfSEFORExFRDsKK30K
KworLyoqCisgKiBtZWdhc2FzX2NvbXBsZXRlX2NtZF9kcGNfZnVzaW9uIC0JQ29tcGxldGVzIGNv
bW1hbmQKKyAqIEBpbnN0YW5jZToJCQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAqCisgKiBUYXNrbGV0
IHRvIGNvbXBsZXRlIGNtZHMKKyAqLwordm9pZAorbWVnYXNhc19jb21wbGV0ZV9jbWRfZHBjX2Z1
c2lvbih1bnNpZ25lZCBsb25nIGluc3RhbmNlX2FkZHIpCit7CisJc3RydWN0IG1lZ2FzYXNfaW5z
dGFuY2UgKmluc3RhbmNlID0KKwkJKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICopaW5zdGFuY2Vf
YWRkcjsKKwl1bnNpZ25lZCBsb25nIGZsYWdzOworCisJLyogSWYgd2UgaGF2ZSBhbHJlYWR5IGRl
Y2xhcmVkIGFkYXB0ZXIgZGVhZCwgZG9ub3QgY29tcGxldGUgY21kcyAqLworCXNwaW5fbG9ja19p
cnFzYXZlKCZpbnN0YW5jZS0+aGJhX2xvY2ssIGZsYWdzKTsKKwlpZiAoaW5zdGFuY2UtPmFkcHJl
Y292ZXJ5ID09IE1FR0FTQVNfSFdfQ1JJVElDQUxfRVJST1IpIHsKKwkJc3Bpbl91bmxvY2tfaXJx
cmVzdG9yZSgmaW5zdGFuY2UtPmhiYV9sb2NrLCBmbGFncyk7CisJCXJldHVybjsKKwl9CisJc3Bp
bl91bmxvY2tfaXJxcmVzdG9yZSgmaW5zdGFuY2UtPmhiYV9sb2NrLCBmbGFncyk7CisKKwlzcGlu
X2xvY2tfaXJxc2F2ZSgmaW5zdGFuY2UtPmNvbXBsZXRpb25fbG9jaywgZmxhZ3MpOworCWNvbXBs
ZXRlX2NtZF9mdXNpb24oaW5zdGFuY2UpOworCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJmluc3Rh
bmNlLT5jb21wbGV0aW9uX2xvY2ssIGZsYWdzKTsKK30KKworLyoqCisgKiBtZWdhc2FzX2lzcl9m
dXNpb24gLSBpc3IgZW50cnkgcG9pbnQKKyAqLworaXJxcmV0dXJuX3QgbWVnYXNhc19pc3JfZnVz
aW9uKGludCBpcnEsIHZvaWQgKmRldnApCit7CisJc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmlu
c3RhbmNlID0gKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICopZGV2cDsKKwl1MzIgbWZpU3RhdHVz
LCBmd19zdGF0ZTsKKworCWlmICghaW5zdGFuY2UtPm1zaV9mbGFnKSB7CisJCW1maVN0YXR1cyA9
IGluc3RhbmNlLT5pbnN0YW5jZXQtPmNsZWFyX2ludHIoaW5zdGFuY2UtPnJlZ19zZXQpOworCQlp
ZiAoIW1maVN0YXR1cykKKwkJCXJldHVybiBJUlFfTk9ORTsKKwl9CisKKwkvKiBJZiB3ZSBhcmUg
cmVzZXR0aW5nLCBiYWlsICovCisJaWYgKHRlc3RfYml0KE1FR0FTQVNfRlVTSU9OX0lOX1JFU0VU
LCAmaW5zdGFuY2UtPnJlc2V0X2ZsYWdzKSkKKwkJcmV0dXJuIElSUV9IQU5ETEVEOworCisJaWYg
KCFjb21wbGV0ZV9jbWRfZnVzaW9uKGluc3RhbmNlKSkgeworCQkvKiBJZiB3ZSBkaWRuJ3QgY29t
cGxldGUgYW55IGNvbW1hbmRzLCBjaGVjayBmb3IgRlcgZmF1bHQgKi8KKwkJZndfc3RhdGUgPSBp
bnN0YW5jZS0+aW5zdGFuY2V0LT5yZWFkX2Z3X3N0YXR1c19yZWcoCisJCQlpbnN0YW5jZS0+cmVn
X3NldCkgJiBNRklfU1RBVEVfTUFTSzsKKwkJaWYgKGZ3X3N0YXRlID09IE1GSV9TVEFURV9GQVVM
VCkKKwkJCXNjaGVkdWxlX3dvcmsoJmluc3RhbmNlLT53b3JrX2luaXQpOworCX0KKworCXJldHVy
biBJUlFfSEFORExFRDsKK30KKworLyoqCisgKiBidWlsZF9tcHRfbWZpX3Bhc3NfdGhydSAtIGJ1
aWxkcyBhIGNtZCBmbyBNRkkgUGFzcyB0aHJ1CisgKiBAaW5zdGFuY2U6CQkJQWRhcHRlciBzb2Z0
IHN0YXRlCisgKiBtZmlfY21kOgkJCW1lZ2FzYXNfY21kIHBvaW50ZXIKKyAqCisgKi8KK3U4Citi
dWlsZF9tcHRfbWZpX3Bhc3NfdGhydShzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2Us
CisJCQlzdHJ1Y3QgbWVnYXNhc19jbWQgKm1maV9jbWQpCit7CisJc3RydWN0IE1QSTI1X0lFRUVf
U0dFX0NIQUlONjQgKm1waTI1X2llZWVfY2hhaW47CisJc3RydWN0IE1QSTJfUkFJRF9TQ1NJX0lP
X1JFUVVFU1QgKmlvX3JlcTsKKwlzdHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9uICpjbWQ7CisJc3Ry
dWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb247CisJc3RydWN0IG1lZ2FzYXNfaGVhZGVyICpmcmFt
ZV9oZHIgPSAmbWZpX2NtZC0+ZnJhbWUtPmhkcjsKKworCWNtZCA9IG1lZ2FzYXNfZ2V0X2NtZF9m
dXNpb24oaW5zdGFuY2UpOworCWlmICghY21kKQorCQlyZXR1cm4gMTsKKworCS8qICBTYXZlIHRo
ZSBzbWlkLiBUbyBiZSB1c2VkIGZvciByZXR1cm5pbmcgdGhlIGNtZCAqLworCW1maV9jbWQtPmNv
bnRleHQuc21pZCA9IGNtZC0+aW5kZXg7CisKKwljbWQtPnN5bmNfY21kX2lkeCA9IG1maV9jbWQt
PmluZGV4OworCisJLyoKKwkgKiBGb3IgY21kcyB3aGVyZSB0aGUgZmxhZyBpcyBzZXQsIHN0b3Jl
IHRoZSBmbGFnIGFuZCBjaGVjaworCSAqIG9uIGNvbXBsZXRpb24uIEZvciBjbWRzIHdpdGggdGhp
cyBmbGFnLCBkb24ndCBjYWxsCisJICogbWVnYXNhc19jb21wbGV0ZV9jbWQKKwkgKi8KKworCWlm
IChmcmFtZV9oZHItPmZsYWdzICYgTUZJX0ZSQU1FX0RPTlRfUE9TVF9JTl9SRVBMWV9RVUVVRSkK
KwkJY21kLT5mbGFncyA9IE1GSV9GUkFNRV9ET05UX1BPU1RfSU5fUkVQTFlfUVVFVUU7CisKKwlm
dXNpb24gPSBpbnN0YW5jZS0+Y3RybF9jb250ZXh0OworCWlvX3JlcSA9IGNtZC0+aW9fcmVxdWVz
dDsKKwltcGkyNV9pZWVlX2NoYWluID0KKwkgIChzdHJ1Y3QgTVBJMjVfSUVFRV9TR0VfQ0hBSU42
NCAqKSZpb19yZXEtPlNHTC5JZWVlQ2hhaW47CisKKwlpb19yZXEtPkZ1bmN0aW9uICAgID0gTUVH
QVNBU19NUEkyX0ZVTkNUSU9OX1BBU1NUSFJVX0lPX1JFUVVFU1Q7CisJaW9fcmVxLT5TR0xPZmZz
ZXQwICA9IG9mZnNldG9mKHN0cnVjdCBNUEkyX1JBSURfU0NTSV9JT19SRVFVRVNULAorCQkJCSAg
ICAgICBTR0wpIC8gNDsKKwlpb19yZXEtPkNoYWluT2Zmc2V0ID0gZnVzaW9uLT5jaGFpbl9vZmZz
ZXRfbWZpX3B0aHJ1OworCisJbXBpMjVfaWVlZV9jaGFpbi0+QWRkcmVzcyA9IG1maV9jbWQtPmZy
YW1lX3BoeXNfYWRkcjsKKworCW1waTI1X2llZWVfY2hhaW4tPkZsYWdzID0gSUVFRV9TR0VfRkxB
R1NfQ0hBSU5fRUxFTUVOVCB8CisJCU1QSTJfSUVFRV9TR0VfRkxBR1NfSU9DUExCTlRBX0FERFI7
CisKKwltcGkyNV9pZWVlX2NoYWluLT5MZW5ndGggPSBNRUdBU0FTX01BWF9TWl9DSEFJTl9GUkFN
RTsKKworCXJldHVybiAwOworfQorCisvKioKKyAqIGJ1aWxkX21wdF9jbWQgLSBDYWxscyBoZWxw
ZXIgZnVuY3Rpb24gdG8gYnVpbGQgYSBjbWQgTUZJIFBhc3MgdGhydSBjbWQKKyAqIEBpbnN0YW5j
ZToJCQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAqIEBjbWQ6CQkJbWZpIGNtZCB0byBidWlsZAorICoK
KyAqLwordW5pb24gTUVHQVNBU19SRVFVRVNUX0RFU0NSSVBUT1JfVU5JT04gKgorYnVpbGRfbXB0
X2NtZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIHN0cnVjdCBtZWdhc2FzX2Nt
ZCAqY21kKQoreworCXVuaW9uIE1FR0FTQVNfUkVRVUVTVF9ERVNDUklQVE9SX1VOSU9OICpyZXFf
ZGVzYzsKKwl1MTYgaW5kZXg7CisKKwlpZiAoYnVpbGRfbXB0X21maV9wYXNzX3RocnUoaW5zdGFu
Y2UsIGNtZCkpIHsKKwkJcHJpbnRrKEtFUk5fRVJSICJDb3VsZG4ndCBidWlsZCBNRkkgcGFzcyB0
aHJ1IGNtZFxuIik7CisJCXJldHVybiBOVUxMOworCX0KKworCWluZGV4ID0gY21kLT5jb250ZXh0
LnNtaWQ7CisKKwlyZXFfZGVzYyA9IG1lZ2FzYXNfZ2V0X3JlcXVlc3RfZGVzY3JpcHRvcihpbnN0
YW5jZSwgaW5kZXggLSAxKTsKKworCWlmICghcmVxX2Rlc2MpCisJCXJldHVybiBOVUxMOworCisJ
cmVxX2Rlc2MtPldvcmRzID0gMDsKKwlyZXFfZGVzYy0+U0NTSUlPLlJlcXVlc3RGbGFncyA9IChN
UEkyX1JFUV9ERVNDUklQVF9GTEFHU19TQ1NJX0lPIDw8CisJCQkJCSBNRUdBU0FTX1JFUV9ERVND
UklQVF9GTEFHU19UWVBFX1NISUZUKTsKKworCXJlcV9kZXNjLT5TQ1NJSU8uU01JRCA9IGluZGV4
OworCisJcmV0dXJuIHJlcV9kZXNjOworfQorCisvKioKKyAqIG1lZ2FzYXNfaXNzdWVfZGNtZF9m
dXNpb24gLSBJc3N1ZXMgYSBNRkkgUGFzcyB0aHJ1IGNtZAorICogQGluc3RhbmNlOgkJCUFkYXB0
ZXIgc29mdCBzdGF0ZQorICogQGNtZDoJCQltZmkgY21kIHBvaW50ZXIKKyAqCisgKi8KK3ZvaWQK
K21lZ2FzYXNfaXNzdWVfZGNtZF9mdXNpb24oc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3Rh
bmNlLAorCQkJICBzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZCkKK3sKKwl1bmlvbiBNRUdBU0FTX1JF
UVVFU1RfREVTQ1JJUFRPUl9VTklPTiAqcmVxX2Rlc2M7CisJdW5pb24gZGVzY192YWx1ZSBkX3Zh
bDsKKworCXJlcV9kZXNjID0gYnVpbGRfbXB0X2NtZChpbnN0YW5jZSwgY21kKTsKKwlpZiAoIXJl
cV9kZXNjKSB7CisJCXByaW50ayhLRVJOX0VSUiAiQ291bGRuJ3QgaXNzdWUgTUZJIHBhc3MgdGhy
dSBjbWRcbiIpOworCQlyZXR1cm47CisJfQorCWRfdmFsLndvcmQgPSByZXFfZGVzYy0+V29yZHM7
CisKKwlpbnN0YW5jZS0+aW5zdGFuY2V0LT5maXJlX2NtZChpbnN0YW5jZSwgcmVxX2Rlc2MtPnUu
bG93LAorCQkJCSAgICAgIHJlcV9kZXNjLT51LmhpZ2gsIGluc3RhbmNlLT5yZWdfc2V0KTsKK30K
KworLyoqCisgKiBtZWdhc2FzX3JlbGVhc2VfZnVzaW9uIC0JUmV2ZXJzZXMgdGhlIEZXIGluaXRp
YWxpemF0aW9uCisgKiBAaW50YW5jZToJCQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAqLwordm9pZAor
bWVnYXNhc19yZWxlYXNlX2Z1c2lvbihzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2Up
Cit7CisJbWVnYXNhc19mcmVlX2NtZHMoaW5zdGFuY2UpOworCW1lZ2FzYXNfZnJlZV9jbWRzX2Z1
c2lvbihpbnN0YW5jZSk7CisKKwlpb3VubWFwKGluc3RhbmNlLT5yZWdfc2V0KTsKKworCXBjaV9y
ZWxlYXNlX3NlbGVjdGVkX3JlZ2lvbnMoaW5zdGFuY2UtPnBkZXYsIGluc3RhbmNlLT5iYXIpOwor
fQorCisvKioKKyAqIG1lZ2FzYXNfcmVhZF9md19zdGF0dXNfcmVnX2Z1c2lvbiAtIHJldHVybnMg
dGhlIGN1cnJlbnQgRlcgc3RhdHVzIHZhbHVlCisgKiBAcmVnczoJCQlNRkkgcmVnaXN0ZXIgc2V0
CisgKi8KK3N0YXRpYyB1MzIKK21lZ2FzYXNfcmVhZF9md19zdGF0dXNfcmVnX2Z1c2lvbihzdHJ1
Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVncykKK3sKKwlyZXR1cm4gcmVhZGwo
JihyZWdzKS0+b3V0Ym91bmRfc2NyYXRjaF9wYWQpOworfQorCisvKioKKyAqIG1lZ2FzYXNfYWRw
X3Jlc2V0X2Z1c2lvbiAtCUZvciBjb250cm9sbGVyIHJlc2V0CisgKiBAcmVnczoJCQkJTUZJIHJl
Z2lzdGVyIHNldAorICovCitzdGF0aWMgaW50CittZWdhc2FzX2FkcF9yZXNldF9mdXNpb24oc3Ry
dWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAorCQkJIHN0cnVjdCBtZWdhc2FzX3JlZ2lz
dGVyX3NldCBfX2lvbWVtICpyZWdzKQoreworCXJldHVybiAwOworfQorCisvKioKKyAqIG1lZ2Fz
YXNfY2hlY2tfcmVzZXRfZnVzaW9uIC0JRm9yIGNvbnRyb2xsZXIgcmVzZXQgY2hlY2sKKyAqIEBy
ZWdzOgkJCQlNRkkgcmVnaXN0ZXIgc2V0CisgKi8KK3N0YXRpYyBpbnQKK21lZ2FzYXNfY2hlY2tf
cmVzZXRfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKKwkJCSAgIHN0
cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdzKQoreworCXJldHVybiAwOwor
fQorCisvKiBUaGlzIGZ1bmN0aW9uIHdhaXRzIGZvciBvdXRzdGFuZGluZyBjb21tYW5kcyBvbiBm
dXNpb24gdG8gY29tcGxldGUgKi8KK2ludCBtZWdhc2FzX3dhaXRfZm9yX291dHN0YW5kaW5nX2Z1
c2lvbihzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCit7CisJaW50IGksIG91dHN0
YW5kaW5nLCByZXR2YWwgPSAwOworCXUzMiBmd19zdGF0ZSwgd2FpdF90aW1lID0gTUVHQVNBU19S
RVNFVF9XQUlUX1RJTUU7CisKKwlmb3IgKGkgPSAwOyBpIDwgd2FpdF90aW1lOyBpKyspIHsKKwkJ
LyogQ2hlY2sgaWYgZmlybXdhcmUgaXMgaW4gZmF1bHQgc3RhdGUgKi8KKwkJZndfc3RhdGUgPSBp
bnN0YW5jZS0+aW5zdGFuY2V0LT5yZWFkX2Z3X3N0YXR1c19yZWcoCisJCQlpbnN0YW5jZS0+cmVn
X3NldCkgJiBNRklfU1RBVEVfTUFTSzsKKwkJaWYgKGZ3X3N0YXRlID09IE1GSV9TVEFURV9GQVVM
VCkgeworCQkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXNhczogRm91bmQgRlcgaW4gRkFVTFQg
c3RhdGUsIgorCQkJICAgICAgICIgd2lsbCByZXNldCBhZGFwdGVyLlxuIik7CisJCQlyZXR2YWwg
PSAxOworCQkJZ290byBvdXQ7CisJCX0KKworCQlvdXRzdGFuZGluZyA9IGF0b21pY19yZWFkKCZp
bnN0YW5jZS0+Zndfb3V0c3RhbmRpbmcpOworCQlpZiAoIW91dHN0YW5kaW5nKQorCQkJZ290byBv
dXQ7CisKKwkJaWYgKCEoaSAlIE1FR0FTQVNfUkVTRVRfTk9USUNFX0lOVEVSVkFMKSkgeworCQkJ
cHJpbnRrKEtFUk5fTk9USUNFICJtZWdhc2FzOiBbJTJkXXdhaXRpbmcgZm9yICVkICIKKwkJCSAg
ICAgICAiY29tbWFuZHMgdG8gY29tcGxldGVcbiIsIGksIG91dHN0YW5kaW5nKTsKKwkJCW1lZ2Fz
YXNfY29tcGxldGVfY21kX2RwY19mdXNpb24oCisJCQkJKHVuc2lnbmVkIGxvbmcpaW5zdGFuY2Up
OworCQl9CisJCW1zbGVlcCgxMDAwKTsKKwl9CisKKwlpZiAoYXRvbWljX3JlYWQoJmluc3RhbmNl
LT5md19vdXRzdGFuZGluZykpIHsKKwkJcHJpbnRrKCJtZWdhcmFpZF9zYXM6IHBlbmRpbmcgY29t
bWFuZHMgcmVtYWluIGFmdGVyIHdhaXRpbmcsICIKKwkJICAgICAgICJ3aWxsIHJlc2V0IGFkYXB0
ZXIuXG4iKTsKKwkJcmV0dmFsID0gMTsKKwl9CitvdXQ6CisJcmV0dXJuIHJldHZhbDsKK30KKwor
dm9pZCAgbWVnYXNhc19yZXNldF9yZXBseV9kZXNjKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICpp
bnN0YW5jZSkKK3sKKwlpbnQgaTsKKwlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lvbjsKKwl1
bmlvbiBNUEkyX1JFUExZX0RFU0NSSVBUT1JTX1VOSU9OICpyZXBseV9kZXNjOworCisJZnVzaW9u
ID0gaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKKwlmdXNpb24tPmxhc3RfcmVwbHlfaWR4ID0gMDsK
KwlyZXBseV9kZXNjID0gZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzYzsKKwlmb3IgKGkgPSAwIDsg
aSA8IGZ1c2lvbi0+cmVwbHlfcV9kZXB0aDsgaSsrLCByZXBseV9kZXNjKyspCisJCXJlcGx5X2Rl
c2MtPldvcmRzID0gVUxMT05HX01BWDsKK30KKworLyogQ29yZSBmdXNpb24gcmVzZXQgZnVuY3Rp
b24gKi8KK2ludCBtZWdhc2FzX3Jlc2V0X2Z1c2lvbihzdHJ1Y3Qgc2NzaV9jbW5kICpzY21kKQor
eworCWludCByZXR2YWwgPSBTVUNDRVNTLCBpLCBqLCByZXRyeSA9IDA7CisJc3RydWN0IG1lZ2Fz
YXNfaW5zdGFuY2UgKmluc3RhbmNlOworCXN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24gKmNtZF9m
dXNpb247CisJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb247CisJc3RydWN0IG1lZ2FzYXNf
Y21kICpjbWRfbWZpOworCXVuaW9uIE1FR0FTQVNfUkVRVUVTVF9ERVNDUklQVE9SX1VOSU9OICpy
ZXFfZGVzYzsKKwl1MzIgaG9zdF9kaWFnLCBhYnNfc3RhdGU7CisKKwlpbnN0YW5jZSA9IChzdHJ1
Y3QgbWVnYXNhc19pbnN0YW5jZSAqKXNjbWQtPmRldmljZS0+aG9zdC0+aG9zdGRhdGE7CisJZnVz
aW9uID0gaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKKworCW11dGV4X2xvY2soJmluc3RhbmNlLT5y
ZXNldF9tdXRleCk7CisJc2V0X2JpdChNRUdBU0FTX0ZVU0lPTl9JTl9SRVNFVCwgJmluc3RhbmNl
LT5yZXNldF9mbGFncyk7CisJaW5zdGFuY2UtPmFkcHJlY292ZXJ5ID0gTUVHQVNBU19BRFBSRVNF
VF9TTV9JTkZBVUxUOworCWluc3RhbmNlLT5pbnN0YW5jZXQtPmRpc2FibGVfaW50cihpbnN0YW5j
ZS0+cmVnX3NldCk7CisJbXNsZWVwKDEwMDApOworCisJaWYgKGluc3RhbmNlLT5hZHByZWNvdmVy
eSA9PSBNRUdBU0FTX0hXX0NSSVRJQ0FMX0VSUk9SKSB7CisJCXByaW50ayhLRVJOX1dBUk5JTkcg
Im1lZ2FyYWlkX3NhczogSGFyZHdhcmUgY3JpdGljYWwgZXJyb3IsICIKKwkJICAgICAgICJyZXR1
cm5pbmcgRkFJTEVELlxuIik7CisJCXJldHZhbCA9IEZBSUxFRDsKKwkJZ290byBvdXQ7CisJfQor
CisJLyogRmlyc3QgdHJ5IHdhaXRpbmcgZm9yIGNvbW1hbmRzIHRvIGNvbXBsZXRlICovCisJaWYg
KG1lZ2FzYXNfd2FpdF9mb3Jfb3V0c3RhbmRpbmdfZnVzaW9uKGluc3RhbmNlKSkgeworCQlwcmlu
dGsoS0VSTl9XQVJOSU5HICJtZWdhcmFpZF9zYXM6IHJlc2V0dGluZyBmdXNpb24gIgorCQkgICAg
ICAgImFkYXB0ZXIuXG4iKTsKKwkJLyogTm93IHJldHVybiBjb21tYW5kcyBiYWNrIHRvIHRoZSBP
UyAqLworCQlmb3IgKGkgPSAwIDsgaSA8IGluc3RhbmNlLT5tYXhfZndfY21kczsgaSsrKSB7CisJ
CQljbWRfZnVzaW9uID0gZnVzaW9uLT5jbWRfbGlzdFtpXTsKKwkJCWlmIChjbWRfZnVzaW9uLT5z
Y21kKSB7CisJCQkJc2NzaV9kbWFfdW5tYXAoY21kX2Z1c2lvbi0+c2NtZCk7CisJCQkJY21kX2Z1
c2lvbi0+c2NtZC0+cmVzdWx0ID0gKERJRF9SRVNFVCA8PCAxNik7CisJCQkJY21kX2Z1c2lvbi0+
c2NtZC0+c2NzaV9kb25lKGNtZF9mdXNpb24tPnNjbWQpOworCQkJCW1lZ2FzYXNfcmV0dXJuX2Nt
ZF9mdXNpb24oaW5zdGFuY2UsIGNtZF9mdXNpb24pOworCQkJCWF0b21pY19kZWMoJmluc3RhbmNl
LT5md19vdXRzdGFuZGluZyk7CisJCQl9CisJCX0KKworCQlpZiAoaW5zdGFuY2UtPmRpc2FibGVP
bmxpbmVDdHJsUmVzZXQgPT0gMSkgeworCQkJLyogUmVzZXQgbm90IHN1cHBvcnRlZCwga2lsbCBh
ZGFwdGVyICovCisJCQlwcmludGsoS0VSTl9XQVJOSU5HICJtZWdhcmFpZF9zYXM6IFJlc2V0IG5v
dCBzdXBwb3J0ZWQiCisJCQkgICAgICAgIiwga2lsbGluZyBhZGFwdGVyLlxuIik7CisJCQltZWdh
cmFpZF9zYXNfa2lsbF9oYmEoaW5zdGFuY2UpOworCQkJaW5zdGFuY2UtPmFkcHJlY292ZXJ5ID0g
TUVHQVNBU19IV19DUklUSUNBTF9FUlJPUjsKKwkJCXJldHZhbCA9IEZBSUxFRDsKKwkJCWdvdG8g
b3V0OworCQl9CisKKwkJLyogTm93IHRyeSB0byByZXNldCB0aGUgY2hpcCAqLworCQlmb3IgKGkg
PSAwOyBpIDwgTUVHQVNBU19GVVNJT05fTUFYX1JFU0VUX1RSSUVTOyBpKyspIHsKKwkJCXdyaXRl
bChNUEkyX1dSU0VRX0ZMVVNIX0tFWV9WQUxVRSwKKwkJCSAgICAgICAmaW5zdGFuY2UtPnJlZ19z
ZXQtPmZ1c2lvbl9zZXFfb2Zmc2V0KTsKKwkJCXdyaXRlbChNUEkyX1dSU0VRXzFTVF9LRVlfVkFM
VUUsCisJCQkgICAgICAgJmluc3RhbmNlLT5yZWdfc2V0LT5mdXNpb25fc2VxX29mZnNldCk7CisJ
CQl3cml0ZWwoTVBJMl9XUlNFUV8yTkRfS0VZX1ZBTFVFLAorCQkJICAgICAgICZpbnN0YW5jZS0+
cmVnX3NldC0+ZnVzaW9uX3NlcV9vZmZzZXQpOworCQkJd3JpdGVsKE1QSTJfV1JTRVFfM1JEX0tF
WV9WQUxVRSwKKwkJCSAgICAgICAmaW5zdGFuY2UtPnJlZ19zZXQtPmZ1c2lvbl9zZXFfb2Zmc2V0
KTsKKwkJCXdyaXRlbChNUEkyX1dSU0VRXzRUSF9LRVlfVkFMVUUsCisJCQkgICAgICAgJmluc3Rh
bmNlLT5yZWdfc2V0LT5mdXNpb25fc2VxX29mZnNldCk7CisJCQl3cml0ZWwoTVBJMl9XUlNFUV81
VEhfS0VZX1ZBTFVFLAorCQkJICAgICAgICZpbnN0YW5jZS0+cmVnX3NldC0+ZnVzaW9uX3NlcV9v
ZmZzZXQpOworCQkJd3JpdGVsKE1QSTJfV1JTRVFfNlRIX0tFWV9WQUxVRSwKKwkJCSAgICAgICAm
aW5zdGFuY2UtPnJlZ19zZXQtPmZ1c2lvbl9zZXFfb2Zmc2V0KTsKKworCQkJLyogQ2hlY2sgdGhh
dCB0aGUgZGlhZyB3cml0ZSBlbmFibGUgKERSV0UpIGJpdCBpcyBvbiAqLworCQkJaG9zdF9kaWFn
ID0gcmVhZGwoJmluc3RhbmNlLT5yZWdfc2V0LT5mdXNpb25faG9zdF9kaWFnKTsKKwkJCXdoaWxl
ICghKGhvc3RfZGlhZyAmIEhPU1RfRElBR19XUklURV9FTkFCTEUpKSB7CisJCQkJbXNsZWVwKDEw
MCk7CisJCQkJaG9zdF9kaWFnID0KKwkJCQlyZWFkbCgmaW5zdGFuY2UtPnJlZ19zZXQtPmZ1c2lv
bl9ob3N0X2RpYWcpOworCQkJCWlmIChyZXRyeSsrID09IDEwMCkgeworCQkJCQlwcmludGsoS0VS
Tl9XQVJOSU5HICJtZWdhcmFpZF9zYXM6ICIKKwkJCQkJICAgICAgICJIb3N0IGRpYWcgdW5sb2Nr
IGZhaWxlZCFcbiIpOworCQkJCQlicmVhazsKKwkJCQl9CisJCQl9CisJCQlpZiAoIShob3N0X2Rp
YWcgJiBIT1NUX0RJQUdfV1JJVEVfRU5BQkxFKSkKKwkJCQljb250aW51ZTsKKworCQkJLyogU2Vu
ZCBjaGlwIHJlc2V0IGNvbW1hbmQgKi8KKwkJCXdyaXRlbChob3N0X2RpYWcgfCBIT1NUX0RJQUdf
UkVTRVRfQURBUFRFUiwKKwkJCSAgICAgICAmaW5zdGFuY2UtPnJlZ19zZXQtPmZ1c2lvbl9ob3N0
X2RpYWcpOworCQkJbXNsZWVwKDMwMDApOworCisJCQkvKiBNYWtlIHN1cmUgcmVzZXQgYWRhcHRl
ciBiaXQgaXMgY2xlYXJlZCAqLworCQkJaG9zdF9kaWFnID0gcmVhZGwoJmluc3RhbmNlLT5yZWdf
c2V0LT5mdXNpb25faG9zdF9kaWFnKTsKKwkJCXJldHJ5ID0gMDsKKwkJCXdoaWxlIChob3N0X2Rp
YWcgJiBIT1NUX0RJQUdfUkVTRVRfQURBUFRFUikgeworCQkJCW1zbGVlcCgxMDApOworCQkJCWhv
c3RfZGlhZyA9CisJCQkJcmVhZGwoJmluc3RhbmNlLT5yZWdfc2V0LT5mdXNpb25faG9zdF9kaWFn
KTsKKwkJCQlpZiAocmV0cnkrKyA9PSAxMDAwKSB7CisJCQkJCXByaW50ayhLRVJOX1dBUk5JTkcg
Im1lZ2FyYWlkX3NhczogIgorCQkJCQkgICAgICAgIkRpYWcgcmVzZXQgYWRhcHRlciBuZXZlciAi
CisJCQkJCSAgICAgICAiY2xlYXJlZCFcbiIpOworCQkJCQlicmVhazsKKwkJCQl9CisJCQl9CisJ
CQlpZiAoaG9zdF9kaWFnICYgSE9TVF9ESUFHX1JFU0VUX0FEQVBURVIpCisJCQkJY29udGludWU7
CisKKwkJCWFic19zdGF0ZSA9CisJCQkJaW5zdGFuY2UtPmluc3RhbmNldC0+cmVhZF9md19zdGF0
dXNfcmVnKAorCQkJCQlpbnN0YW5jZS0+cmVnX3NldCk7CisJCQlyZXRyeSA9IDA7CisKKwkJCXdo
aWxlICgoYWJzX3N0YXRlIDw9IE1GSV9TVEFURV9GV19JTklUKSAmJgorCQkJICAgICAgIChyZXRy
eSsrIDwgMTAwMCkpIHsKKwkJCQltc2xlZXAoMTAwKTsKKwkJCQlhYnNfc3RhdGUgPQorCQkJCWlu
c3RhbmNlLT5pbnN0YW5jZXQtPnJlYWRfZndfc3RhdHVzX3JlZygKKwkJCQkJaW5zdGFuY2UtPnJl
Z19zZXQpOworCQkJfQorCQkJaWYgKGFic19zdGF0ZSA8PSBNRklfU1RBVEVfRldfSU5JVCkgewor
CQkJCXByaW50ayhLRVJOX1dBUk5JTkcgIm1lZ2FyYWlkX3NhczogZmlybXdhcmUgIgorCQkJCSAg
ICAgICAic3RhdGUgPCBNRklfU1RBVEVfRldfSU5JVCwgc3RhdGUgPSAiCisJCQkJICAgICAgICIw
eCV4XG4iLCBhYnNfc3RhdGUpOworCQkJCWNvbnRpbnVlOworCQkJfQorCisJCQkvKiBXYWl0IGZv
ciBGVyB0byBiZWNvbWUgcmVhZHkgKi8KKwkJCWlmIChtZWdhc2FzX3RyYW5zaXRpb25fdG9fcmVh
ZHkoaW5zdGFuY2UpKSB7CisJCQkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXJhaWRfc2FzOiBG
YWlsZWQgdG8gIgorCQkJCSAgICAgICAidHJhbnNpdGlvbiBjb250cm9sbGVyIHRvIHJlYWR5Llxu
Iik7CisJCQkJY29udGludWU7CisJCQl9CisKKwkJCW1lZ2FzYXNfcmVzZXRfcmVwbHlfZGVzYyhp
bnN0YW5jZSk7CisJCQlpZiAobWVnYXNhc19pb2NfaW5pdF9mdXNpb24oaW5zdGFuY2UpKSB7CisJ
CQkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXJhaWRfc2FzOiAiCisJCQkJICAgICAgICJtZWdh
c2FzX2lvY19pbml0X2Z1c2lvbigpIGZhaWxlZCFcbiIpOworCQkJCWNvbnRpbnVlOworCQkJfQor
CisJCQlpbnN0YW5jZS0+aW5zdGFuY2V0LT5lbmFibGVfaW50cihpbnN0YW5jZS0+cmVnX3NldCk7
CisJCQlpbnN0YW5jZS0+YWRwcmVjb3ZlcnkgPSBNRUdBU0FTX0hCQV9PUEVSQVRJT05BTDsKKwor
CQkJLyogUmUtZmlyZSBtYW5hZ2VtZW50IGNvbW1hbmRzICovCisJCQlmb3IgKGogPSAwIDsgaiA8
IGluc3RhbmNlLT5tYXhfZndfY21kczsgaisrKSB7CisJCQkJY21kX2Z1c2lvbiA9IGZ1c2lvbi0+
Y21kX2xpc3Rbal07CisJCQkJaWYgKGNtZF9mdXNpb24tPnN5bmNfY21kX2lkeCAhPQorCQkJCSAg
ICAodTMyKVVMT05HX01BWCkgeworCQkJCQljbWRfbWZpID0KKwkJCQkJaW5zdGFuY2UtPgorCQkJ
CQljbWRfbGlzdFtjbWRfZnVzaW9uLT5zeW5jX2NtZF9pZHhdOworCQkJCQlpZiAoY21kX21maS0+
ZnJhbWUtPmRjbWQub3Bjb2RlID09CisJCQkJCSAgICBNUl9EQ01EX0xEX01BUF9HRVRfSU5GTykg
eworCQkJCQkJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNlLAorCQkJCQkJCQkgICBjbWRfbWZp
KTsKKwkJCQkJCW1lZ2FzYXNfcmV0dXJuX2NtZF9mdXNpb24oCisJCQkJCQkJaW5zdGFuY2UsIGNt
ZF9mdXNpb24pOworCQkJCQl9IGVsc2UgIHsKKwkJCQkJCXJlcV9kZXNjID0KKwkJCQkJCW1lZ2Fz
YXNfZ2V0X3JlcXVlc3RfZGVzY3JpcHRvcigKKwkJCQkJCQlpbnN0YW5jZSwKKwkJCQkJCQljbWRf
bWZpLT5jb250ZXh0LnNtaWQKKwkJCQkJCQktMSk7CisJCQkJCQlpZiAoIXJlcV9kZXNjKQorCQkJ
CQkJCXByaW50ayhLRVJOX1dBUk5JTkcKKwkJCQkJCQkgICAgICAgInJlcV9kZXNjIE5VTEwiCisJ
CQkJCQkJICAgICAgICJcbiIpOworCQkJCQkJZWxzZSB7CisJCQkJCQkJaW5zdGFuY2UtPmluc3Rh
bmNldC0+CisJCQkJCQkJZmlyZV9jbWQoaW5zdGFuY2UsCisJCQkJCQkJCSByZXFfZGVzYy0+CisJ
CQkJCQkJCSB1LmxvdywKKwkJCQkJCQkJIHJlcV9kZXNjLT4KKwkJCQkJCQkJIHUuaGlnaCwKKwkJ
CQkJCQkJIGluc3RhbmNlLT4KKwkJCQkJCQkJIHJlZ19zZXQpOworCQkJCQkJfQorCQkJCQl9CisJ
CQkJfQorCQkJfQorCisJCQkvKiBSZXNldCBsb2FkIGJhbGFuY2UgaW5mbyAqLworCQkJbWVtc2V0
KGZ1c2lvbi0+bG9hZF9iYWxhbmNlX2luZm8sIDAsCisJCQkgICAgICAgc2l6ZW9mKHN0cnVjdCBM
RF9MT0FEX0JBTEFOQ0VfSU5GTykKKwkJCSAgICAgICAqTUFYX0xPR0lDQUxfRFJJVkVTKTsKKwor
CQkJaWYgKCFtZWdhc2FzX2dldF9tYXBfaW5mbyhpbnN0YW5jZSkpCisJCQkJbWVnYXNhc19zeW5j
X21hcF9pbmZvKGluc3RhbmNlKTsKKworCQkJLyogQWRhcHRlciByZXNldCBjb21wbGV0ZWQgc3Vj
Y2Vzc2Z1bGx5ICovCisJCQlwcmludGsoS0VSTl9XQVJOSU5HICJtZWdhcmFpZF9zYXM6IFJlc2V0
ICIKKwkJCSAgICAgICAic3VjY2Vzc2Z1bC5cbiIpOworCQkJcmV0dmFsID0gU1VDQ0VTUzsKKwkJ
CWdvdG8gb3V0OworCQl9CisJCS8qIFJlc2V0IGZhaWxlZCwga2lsbCB0aGUgYWRhcHRlciAqLwor
CQlwcmludGsoS0VSTl9XQVJOSU5HICJtZWdhcmFpZF9zYXM6IFJlc2V0IGZhaWxlZCwga2lsbGlu
ZyAiCisJCSAgICAgICAiYWRhcHRlci5cbiIpOworCQltZWdhcmFpZF9zYXNfa2lsbF9oYmEoaW5z
dGFuY2UpOworCQlyZXR2YWwgPSBGQUlMRUQ7CisJfSBlbHNlIHsKKwkJaW5zdGFuY2UtPmluc3Rh
bmNldC0+ZW5hYmxlX2ludHIoaW5zdGFuY2UtPnJlZ19zZXQpOworCQlpbnN0YW5jZS0+YWRwcmVj
b3ZlcnkgPSBNRUdBU0FTX0hCQV9PUEVSQVRJT05BTDsKKwl9CitvdXQ6CisJY2xlYXJfYml0KE1F
R0FTQVNfRlVTSU9OX0lOX1JFU0VULCAmaW5zdGFuY2UtPnJlc2V0X2ZsYWdzKTsKKwltdXRleF91
bmxvY2soJmluc3RhbmNlLT5yZXNldF9tdXRleCk7CisJcmV0dXJuIHJldHZhbDsKK30KKworLyog
RnVzaW9uIE9DUiB3b3JrIHF1ZXVlICovCit2b2lkIG1lZ2FzYXNfZnVzaW9uX29jcl93cShzdHJ1
Y3Qgd29ya19zdHJ1Y3QgKndvcmspCit7CisJc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3Rh
bmNlID0KKwkJY29udGFpbmVyX29mKHdvcmssIHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlLCB3b3Jr
X2luaXQpOworCisJaW5zdGFuY2UtPnNjbWQuZGV2aWNlID0gJmluc3RhbmNlLT5kZXY7CisJaW5z
dGFuY2UtPmRldi5ob3N0ID0gaW5zdGFuY2UtPmhvc3Q7CisJbWVnYXNhc19yZXNldF9mdXNpb24o
Jmluc3RhbmNlLT5zY21kKTsKK30KKworc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2VfdGVtcGxhdGUg
bWVnYXNhc19pbnN0YW5jZV90ZW1wbGF0ZV9mdXNpb24gPSB7CisJLmZpcmVfY21kID0gbWVnYXNh
c19maXJlX2NtZF9mdXNpb24sCisJLmVuYWJsZV9pbnRyID0gbWVnYXNhc19lbmFibGVfaW50cl9m
dXNpb24sCisJLmRpc2FibGVfaW50ciA9IG1lZ2FzYXNfZGlzYWJsZV9pbnRyX2Z1c2lvbiwKKwku
Y2xlYXJfaW50ciA9IG1lZ2FzYXNfY2xlYXJfaW50cl9mdXNpb24sCisJLnJlYWRfZndfc3RhdHVz
X3JlZyA9IG1lZ2FzYXNfcmVhZF9md19zdGF0dXNfcmVnX2Z1c2lvbiwKKwkuYWRwX3Jlc2V0ID0g
bWVnYXNhc19hZHBfcmVzZXRfZnVzaW9uLAorCS5jaGVja19yZXNldCA9IG1lZ2FzYXNfY2hlY2tf
cmVzZXRfZnVzaW9uLAorCS5zZXJ2aWNlX2lzciA9IG1lZ2FzYXNfaXNyX2Z1c2lvbiwKKwkudGFz
a2xldCA9IG1lZ2FzYXNfY29tcGxldGVfY21kX2RwY19mdXNpb24sCisJLmluaXRfYWRhcHRlciA9
IG1lZ2FzYXNfaW5pdF9hZGFwdGVyX2Z1c2lvbiwKKwkuYnVpbGRfYW5kX2lzc3VlX2NtZCA9IG1l
Z2FzYXNfYnVpbGRfYW5kX2lzc3VlX2NtZF9mdXNpb24sCisJLmlzc3VlX2RjbWQgPSBtZWdhc2Fz
X2lzc3VlX2RjbWRfZnVzaW9uLAorfTsKZGlmZiAtTmF1ciBsaW51eC0yLjYuMzctcmM1Lm9sZC9k
cml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5oIGxpbnV4LTIuNi4zNy1y
YzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmgKLS0tIGxp
bnV4LTIuNi4zNy1yYzUub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVz
aW9uLmgJMTk2OS0xMi0zMSAxNjowMDowMC4wMDAwMDAwMDAgLTA4MDAKKysrIGxpbnV4LTIuNi4z
Ny1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmgJMjAx
MC0xMi0yMSAxMTowNDowNy4wMDAwMDAwMDAgLTA4MDAKQEAgLTAsMCArMSw2OTUgQEAKKy8qCisg
KiAgTGludXggTWVnYVJBSUQgZHJpdmVyIGZvciBTQVMgYmFzZWQgUkFJRCBjb250cm9sbGVycwor
ICoKKyAqICBDb3B5cmlnaHQgKGMpIDIwMDktMjAxMSAgTFNJIENvcnBvcmF0aW9uLgorICoKKyAq
ICBUaGlzIHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQg
YW5kL29yCisgKiAgbW9kaWZ5IGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwg
UHVibGljIExpY2Vuc2UKKyAqICBhcyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91
bmRhdGlvbjsgZWl0aGVyIHZlcnNpb24gMgorICogIG9mIHRoZSBMaWNlbnNlLCBvciAoYXQgeW91
ciBvcHRpb24pIGFueSBsYXRlciB2ZXJzaW9uLgorICoKKyAqICBUaGlzIHByb2dyYW0gaXMgZGlz
dHJpYnV0ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwKKyAqICBidXQgV0lU
SE9VVCBBTlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgor
ICogIE1FUkNIQU5UQUJJTElUWSBvciBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4g
IFNlZSB0aGUKKyAqICBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxz
LgorICoKKyAqICBZb3Ugc2hvdWxkIGhhdmUgcmVjZWl2ZWQgYSBjb3B5IG9mIHRoZSBHTlUgR2Vu
ZXJhbCBQdWJsaWMgTGljZW5zZQorICogIGFsb25nIHdpdGggdGhpcyBwcm9ncmFtOyBpZiBub3Qs
IHdyaXRlIHRvIHRoZSBGcmVlIFNvZnR3YXJlCisgKiAgRm91bmRhdGlvbiwgSW5jLiwgNTkgVGVt
cGxlIFBsYWNlLCBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEgMDIxMTEtMTMwNyBVU0EKKyAqCisgKiAg
RklMRTogbWVnYXJhaWRfc2FzX2Z1c2lvbi5oCisgKgorICogIEF1dGhvcnM6IExTSSBDb3Jwb3Jh
dGlvbgorICogICAgICAgICAgIE1hbm9qIEpvc2UKKyAqICAgICAgICAgICBTdW1hbnQgUGF0cm8K
KyAqCisgKiAgU2VuZCBmZWVkYmFjayB0bzogPG1lZ2FyYWlkbGludXhAbHNpLmNvbT4KKyAqCisg
KiAgTWFpbCB0bzogTFNJIENvcnBvcmF0aW9uLCAxNjIxIEJhcmJlciBMYW5lLCBNaWxwaXRhcywg
Q0EgOTUwMzUKKyAqICAgICBBVFROOiBMaW51eHJhaWQKKyAqLworCisjaWZuZGVmIF9NRUdBUkFJ
RF9TQVNfRlVTSU9OX0hfCisjZGVmaW5lIF9NRUdBUkFJRF9TQVNfRlVTSU9OX0hfCisKKy8qIEZ1
c2lvbiBkZWZpbmVzICovCisjZGVmaW5lIE1FR0FTQVNfTUFYX1NaX0NIQUlOX0ZSQU1FIDEwMjQK
KyNkZWZpbmUgTUZJX0ZVU0lPTl9FTkFCTEVfSU5URVJSVVBUX01BU0sgKDB4MDAwMDAwMDkpCisj
ZGVmaW5lIE1FR0FfTVBJMl9SQUlEX0RFRkFVTFRfSU9fRlJBTUVfU0laRSAyNTYKKyNkZWZpbmUg
TUVHQVNBU19NUEkyX0ZVTkNUSU9OX1BBU1NUSFJVX0lPX1JFUVVFU1QgICAweEYwCisjZGVmaW5l
IE1FR0FTQVNfTVBJMl9GVU5DVElPTl9MRF9JT19SRVFVRVNUICAgICAgICAgMHhGMQorI2RlZmlu
ZSBNRUdBU0FTX0xPQURfQkFMQU5DRV9GTEFHCQkgICAgMHgxCisjZGVmaW5lIE1FR0FTQVNfRENN
RF9NQk9YX1BFTkRfRkxBRwkJICAgIDB4MQorI2RlZmluZSBIT1NUX0RJQUdfV1JJVEVfRU5BQkxF
CQkJICAgIDB4ODAKKyNkZWZpbmUgSE9TVF9ESUFHX1JFU0VUX0FEQVBURVIJCQkgICAgMHg0Cisj
ZGVmaW5lIE1FR0FTQVNfRlVTSU9OX01BWF9SRVNFVF9UUklFUwkJICAgIDMKKworLyogVDEwIFBJ
IGRlZmluZXMgKi8KKyNkZWZpbmUgTVJfUFJPVF9JTkZPX1RZUEVfQ09OVFJPTExFUiAgICAgICAg
ICAgICAgICAweDgKKyNkZWZpbmUgTUVHQVNBU19TQ1NJX1ZBUklBQkxFX0xFTkdUSF9DTUQgICAg
ICAgICAgICAweDdmCisjZGVmaW5lIE1FR0FTQVNfU0NTSV9TRVJWSUNFX0FDVElPTl9SRUFEMzIg
ICAgICAgICAgMHg5CisjZGVmaW5lIE1FR0FTQVNfU0NTSV9TRVJWSUNFX0FDVElPTl9XUklURTMy
ICAgICAgICAgMHhCCisjZGVmaW5lIE1FR0FTQVNfU0NTSV9BRERMX0NEQl9MRU4gICAgICAgICAg
ICAgICAgICAgMHgxOAorI2RlZmluZSBNRUdBU0FTX1JEX1dSX1BST1RFQ1RfQ0hFQ0tfQUxMCQkg
ICAgMHgyMAorI2RlZmluZSBNRUdBU0FTX1JEX1dSX1BST1RFQ1RfQ0hFQ0tfTk9ORQkgICAgMHg2
MAorI2RlZmluZSBNRUdBU0FTX0VFRFBCTE9DS1NJWkUJCQkgICAgNTEyCisKKy8qCisgKiBSYWlk
IGNvbnRleHQgZmxhZ3MKKyAqLworCisjZGVmaW5lIE1SX1JBSURfQ1RYX1JBSURfRkxBR1NfSU9f
U1VCX1RZUEVfU0hJRlQgICAweDQKKyNkZWZpbmUgTVJfUkFJRF9DVFhfUkFJRF9GTEFHU19JT19T
VUJfVFlQRV9NQVNLICAgIDB4MzAKK2VudW0gTVJfUkFJRF9GTEFHU19JT19TVUJfVFlQRSB7CisJ
TVJfUkFJRF9GTEFHU19JT19TVUJfVFlQRV9OT05FID0gMCwKKwlNUl9SQUlEX0ZMQUdTX0lPX1NV
Ql9UWVBFX1NZU1RFTV9QRCA9IDEsCit9OworCisvKgorICogUmVxdWVzdCBkZXNjcmlwdG9yIHR5
cGVzCisgKi8KKyNkZWZpbmUgTUVHQVNBU19SRVFfREVTQ1JJUFRfRkxBR1NfTERfSU8gICAgICAg
ICAgIDB4NworI2RlZmluZSBNRUdBU0FTX1JFUV9ERVNDUklQVF9GTEFHU19NRkEgICAgICAgICAg
ICAgMHgxCisKKyNkZWZpbmUgTUVHQVNBU19SRVFfREVTQ1JJUFRfRkxBR1NfVFlQRV9TSElGVCAg
ICAgIDEKKworI2RlZmluZSBNRUdBU0FTX0ZQX0NNRF9MRU4JMTYKKyNkZWZpbmUgTUVHQVNBU19G
VVNJT05fSU5fUkVTRVQgMAorCisvKgorICogUmFpZCBDb250ZXh0IHN0cnVjdHVyZSB3aGljaCBk
ZXNjcmliZXMgTWVnYVJBSUQgc3BlY2lmaWMgSU8gUGFyYW1lbnRlcnMKKyAqIFRoaXMgcmVzaWRl
cyBhdCBvZmZzZXQgMHg2MCB3aGVyZSB0aGUgU0dMIG5vcm1hbGx5IHN0YXJ0cyBpbiBNUFQgSU8g
RnJhbWVzCisgKi8KKworc3RydWN0IFJBSURfQ09OVEVYVCB7CisJdTE2ICAgICByZXN2ZDA7CisJ
dTE2ICAgICB0aW1lb3V0VmFsdWU7CisJdTggICAgICByZWdMb2NrRmxhZ3M7CisJdTggICAgICBy
ZXN2ZDE7CisJdTE2ICAgICBWaXJ0dWFsRGlza1RndElkOworCXU2NCAgICAgcmVnTG9ja1Jvd0xC
QTsKKwl1MzIgICAgIHJlZ0xvY2tMZW5ndGg7CisJdTE2ICAgICBuZXh0TE1JZDsKKwl1OCAgICAg
IGV4U3RhdHVzOworCXU4ICAgICAgc3RhdHVzOworCXU4ICAgICAgUkFJREZsYWdzOworCXU4ICAg
ICAgbnVtU0dFOworCXUxNgljb25maWdTZXFOdW07CisJdTggICAgICBzcGFuQXJtOworCXU4ICAg
ICAgcmVzdmQyWzNdOworfTsKKworI2RlZmluZSBSQUlEX0NUWF9TUEFOQVJNX0FSTV9TSElGVAko
MCkKKyNkZWZpbmUgUkFJRF9DVFhfU1BBTkFSTV9BUk1fTUFTSwkoMHgxZikKKworI2RlZmluZSBS
QUlEX0NUWF9TUEFOQVJNX1NQQU5fU0hJRlQJKDUpCisjZGVmaW5lIFJBSURfQ1RYX1NQQU5BUk1f
U1BBTl9NQVNLCSgweEUwKQorCisvKgorICogZGVmaW5lIHJlZ2lvbiBsb2NrIHR5cGVzCisgKi8K
K2VudW0gUkVHSU9OX1RZUEUgeworCVJFR0lPTl9UWVBFX1VOVVNFRCAgICAgICA9IDAsCisJUkVH
SU9OX1RZUEVfU0hBUkVEX1JFQUQgID0gMSwKKwlSRUdJT05fVFlQRV9TSEFSRURfV1JJVEUgPSAy
LAorCVJFR0lPTl9UWVBFX0VYQ0xVU0lWRSAgICA9IDMsCit9OworCisvKiBNUEkyIGRlZmluZXMg
Ki8KKyNkZWZpbmUgTVBJMl9GVU5DVElPTl9JT0NfSU5JVCAgICAgICAgICAgICAgKDB4MDIpIC8q
IElPQyBJbml0ICovCisjZGVmaW5lIE1QSTJfV0hPSU5JVF9IT1NUX0RSSVZFUiAgICAgICAgICAg
ICgweDA0KQorI2RlZmluZSBNUEkyX1ZFUlNJT05fTUFKT1IgICAgICAgICAgICAgICAgICAoMHgw
MikKKyNkZWZpbmUgTVBJMl9WRVJTSU9OX01JTk9SICAgICAgICAgICAgICAgICAgKDB4MDApCisj
ZGVmaW5lIE1QSTJfVkVSU0lPTl9NQUpPUl9NQVNLICAgICAgICAgICAgICgweEZGMDApCisjZGVm
aW5lIE1QSTJfVkVSU0lPTl9NQUpPUl9TSElGVCAgICAgICAgICAgICg4KQorI2RlZmluZSBNUEky
X1ZFUlNJT05fTUlOT1JfTUFTSyAgICAgICAgICAgICAoMHgwMEZGKQorI2RlZmluZSBNUEkyX1ZF
UlNJT05fTUlOT1JfU0hJRlQgICAgICAgICAgICAoMCkKKyNkZWZpbmUgTVBJMl9WRVJTSU9OICgo
TVBJMl9WRVJTSU9OX01BSk9SIDw8IE1QSTJfVkVSU0lPTl9NQUpPUl9TSElGVCkgfCBcCisJCSAg
ICAgIE1QSTJfVkVSU0lPTl9NSU5PUikKKyNkZWZpbmUgTVBJMl9IRUFERVJfVkVSU0lPTl9VTklU
ICAgICAgICAgICAgKDB4MTApCisjZGVmaW5lIE1QSTJfSEVBREVSX1ZFUlNJT05fREVWICAgICAg
ICAgICAgICgweDAwKQorI2RlZmluZSBNUEkyX0hFQURFUl9WRVJTSU9OX1VOSVRfTUFTSyAgICAg
ICAoMHhGRjAwKQorI2RlZmluZSBNUEkyX0hFQURFUl9WRVJTSU9OX1VOSVRfU0hJRlQgICAgICAo
OCkKKyNkZWZpbmUgTVBJMl9IRUFERVJfVkVSU0lPTl9ERVZfTUFTSyAgICAgICAgKDB4MDBGRikK
KyNkZWZpbmUgTVBJMl9IRUFERVJfVkVSU0lPTl9ERVZfU0hJRlQgICAgICAgKDApCisjZGVmaW5l
IE1QSTJfSEVBREVSX1ZFUlNJT04gKChNUEkyX0hFQURFUl9WRVJTSU9OX1VOSVQgPDwgOCkgfCBc
CisJCQkgICAgIE1QSTJfSEVBREVSX1ZFUlNJT05fREVWKQorI2RlZmluZSBNUEkyX0lFRUVfU0dF
X0ZMQUdTX0lPQ1BMQk5UQV9BRERSICAgICAgKDB4MDMpCisjZGVmaW5lIE1QSTJfU0NTSUlPX0VF
RFBGTEFHU19JTkNfUFJJX1JFRlRBRyAgICAgICAgKDB4ODAwMCkKKyNkZWZpbmUgTVBJMl9TQ1NJ
SU9fRUVEUEZMQUdTX0NIRUNLX1JFRlRBRyAgICAgICAgICAoMHgwNDAwKQorI2RlZmluZSBNUEky
X1NDU0lJT19FRURQRkxBR1NfQ0hFQ0tfUkVNT1ZFX09QICAgICAgICgweDAwMDMpCisjZGVmaW5l
IE1QSTJfU0NTSUlPX0VFRFBGTEFHU19DSEVDS19BUFBUQUcgICAgICAgICAgKDB4MDIwMCkKKyNk
ZWZpbmUgTVBJMl9TQ1NJSU9fRUVEUEZMQUdTX0NIRUNLX0dVQVJEICAgICAgICAgICAoMHgwMTAw
KQorI2RlZmluZSBNUEkyX1NDU0lJT19FRURQRkxBR1NfSU5TRVJUX09QICAgICAgICAgICAgICgw
eDAwMDQpCisjZGVmaW5lIE1QSTJfRlVOQ1RJT05fU0NTSV9JT19SRVFVRVNUICAgICAgICAgICAg
ICAgKDB4MDApIC8qIFNDU0kgSU8gKi8KKyNkZWZpbmUgTVBJMl9SRVFfREVTQ1JJUFRfRkxBR1Nf
SElHSF9QUklPUklUWSAgICAgICAgICAgKDB4MDYpCisjZGVmaW5lIE1QSTJfUkVRX0RFU0NSSVBU
X0ZMQUdTX1NDU0lfSU8gICAgICAgICAgICAgICAgICgweDAwKQorI2RlZmluZSBNUEkyX1NHRV9G
TEFHU182NF9CSVRfQUREUkVTU0lORyAgICAgICAgKDB4MDIpCisjZGVmaW5lIE1QSTJfU0NTSUlP
X0NPTlRST0xfV1JJVEUgICAgICAgICAgICAgICAoMHgwMTAwMDAwMCkKKyNkZWZpbmUgTVBJMl9T
Q1NJSU9fQ09OVFJPTF9SRUFEICAgICAgICAgICAgICAgICgweDAyMDAwMDAwKQorI2RlZmluZSBN
UEkyX1JFUV9ERVNDUklQVF9GTEFHU19UWVBFX01BU0sgICAgICAgKDB4MEUpCisjZGVmaW5lIE1Q
STJfUlBZX0RFU0NSSVBUX0ZMQUdTX1VOVVNFRCAgICAgICAgICAoMHgwRikKKyNkZWZpbmUgTVBJ
Ml9SUFlfREVTQ1JJUFRfRkxBR1NfU0NTSV9JT19TVUNDRVNTICgweDAwKQorI2RlZmluZSBNUEky
X1JQWV9ERVNDUklQVF9GTEFHU19UWVBFX01BU0sgICAgICAgKDB4MEYpCisjZGVmaW5lIE1QSTJf
V1JTRVFfRkxVU0hfS0VZX1ZBTFVFICAgICAgICAgICAgICAoMHgwKQorI2RlZmluZSBNUEkyX1dS
SVRFX1NFUVVFTkNFX09GRlNFVCAgICAgICAgICAgICAgKDB4MDAwMDAwMDQpCisjZGVmaW5lIE1Q
STJfV1JTRVFfMVNUX0tFWV9WQUxVRSAgICAgICAgICAgICAgICAoMHhGKQorI2RlZmluZSBNUEky
X1dSU0VRXzJORF9LRVlfVkFMVUUgICAgICAgICAgICAgICAgKDB4NCkKKyNkZWZpbmUgTVBJMl9X
UlNFUV8zUkRfS0VZX1ZBTFVFICAgICAgICAgICAgICAgICgweEIpCisjZGVmaW5lIE1QSTJfV1JT
RVFfNFRIX0tFWV9WQUxVRSAgICAgICAgICAgICAgICAoMHgyKQorI2RlZmluZSBNUEkyX1dSU0VR
XzVUSF9LRVlfVkFMVUUgICAgICAgICAgICAgICAgKDB4NykKKyNkZWZpbmUgTVBJMl9XUlNFUV82
VEhfS0VZX1ZBTFVFICAgICAgICAgICAgICAgICgweEQpCisKK3N0cnVjdCBNUEkyNV9JRUVFX1NH
RV9DSEFJTjY0IHsKKwl1NjQgICAgICAgICAgICAgICAgICAgICBBZGRyZXNzOworCXUzMiAgICAg
ICAgICAgICAgICAgICAgIExlbmd0aDsKKwl1MTYgICAgICAgICAgICAgICAgICAgICBSZXNlcnZl
ZDE7CisJdTggICAgICAgICAgICAgICAgICAgICAgTmV4dENoYWluT2Zmc2V0OworCXU4ICAgICAg
ICAgICAgICAgICAgICAgIEZsYWdzOworfTsKKworc3RydWN0IE1QSTJfU0dFX1NJTVBMRV9VTklP
TiB7CisJdTMyICAgICAgICAgICAgICAgICAgICAgRmxhZ3NMZW5ndGg7CisJdW5pb24geworCQl1
MzIgICAgICAgICAgICAgICAgIEFkZHJlc3MzMjsKKwkJdTY0ICAgICAgICAgICAgICAgICBBZGRy
ZXNzNjQ7CisJfSB1OworfTsKKworc3RydWN0IE1QSTJfU0NTSV9JT19DREJfRUVEUDMyIHsKKwl1
OCAgICAgICAgICAgICAgICAgICAgICBDREJbMjBdOyAgICAgICAgICAgICAgICAgICAgLyogMHgw
MCAqLworCXUzMiAgICAgICAgICAgICAgICAgICAgIFByaW1hcnlSZWZlcmVuY2VUYWc7ICAgICAg
ICAvKiAweDE0ICovCisJdTE2ICAgICAgICAgICAgICAgICAgICAgUHJpbWFyeUFwcGxpY2F0aW9u
VGFnOyAgICAgIC8qIDB4MTggKi8KKwl1MTYgICAgICAgICAgICAgICAgICAgICBQcmltYXJ5QXBw
bGljYXRpb25UYWdNYXNrOyAgLyogMHgxQSAqLworCXUzMiAgICAgICAgICAgICAgICAgICAgIFRy
YW5zZmVyTGVuZ3RoOyAgICAgICAgICAgICAvKiAweDFDICovCit9OworCitzdHJ1Y3QgTVBJMl9T
R0VfQ0hBSU5fVU5JT04geworCXUxNiAgICAgICAgICAgICAgICAgICAgIExlbmd0aDsKKwl1OCAg
ICAgICAgICAgICAgICAgICAgICBOZXh0Q2hhaW5PZmZzZXQ7CisJdTggICAgICAgICAgICAgICAg
ICAgICAgRmxhZ3M7CisJdW5pb24geworCQl1MzIgICAgICAgICAgICAgICAgIEFkZHJlc3MzMjsK
KwkJdTY0ICAgICAgICAgICAgICAgICBBZGRyZXNzNjQ7CisJfSB1OworfTsKKworc3RydWN0IE1Q
STJfSUVFRV9TR0VfU0lNUExFMzIgeworCXUzMiAgICAgICAgICAgICAgICAgICAgIEFkZHJlc3M7
CisJdTMyICAgICAgICAgICAgICAgICAgICAgRmxhZ3NMZW5ndGg7Cit9OworCitzdHJ1Y3QgTVBJ
Ml9JRUVFX1NHRV9DSEFJTjMyIHsKKwl1MzIgICAgICAgICAgICAgICAgICAgICBBZGRyZXNzOwor
CXUzMiAgICAgICAgICAgICAgICAgICAgIEZsYWdzTGVuZ3RoOworfTsKKworc3RydWN0IE1QSTJf
SUVFRV9TR0VfU0lNUExFNjQgeworCXU2NCAgICAgICAgICAgICAgICAgICAgIEFkZHJlc3M7CisJ
dTMyICAgICAgICAgICAgICAgICAgICAgTGVuZ3RoOworCXUxNiAgICAgICAgICAgICAgICAgICAg
IFJlc2VydmVkMTsKKwl1OCAgICAgICAgICAgICAgICAgICAgICBSZXNlcnZlZDI7CisJdTggICAg
ICAgICAgICAgICAgICAgICAgRmxhZ3M7Cit9OworCitzdHJ1Y3QgTVBJMl9JRUVFX1NHRV9DSEFJ
TjY0IHsKKwl1NjQgICAgICAgICAgICAgICAgICAgICBBZGRyZXNzOworCXUzMiAgICAgICAgICAg
ICAgICAgICAgIExlbmd0aDsKKwl1MTYgICAgICAgICAgICAgICAgICAgICBSZXNlcnZlZDE7CisJ
dTggICAgICAgICAgICAgICAgICAgICAgUmVzZXJ2ZWQyOworCXU4ICAgICAgICAgICAgICAgICAg
ICAgIEZsYWdzOworfTsKKwordW5pb24gTVBJMl9JRUVFX1NHRV9TSU1QTEVfVU5JT04geworCXN0
cnVjdCBNUEkyX0lFRUVfU0dFX1NJTVBMRTMyICBTaW1wbGUzMjsKKwlzdHJ1Y3QgTVBJMl9JRUVF
X1NHRV9TSU1QTEU2NCAgU2ltcGxlNjQ7Cit9OworCit1bmlvbiBNUEkyX0lFRUVfU0dFX0NIQUlO
X1VOSU9OIHsKKwlzdHJ1Y3QgTVBJMl9JRUVFX1NHRV9DSEFJTjMyICAgQ2hhaW4zMjsKKwlzdHJ1
Y3QgTVBJMl9JRUVFX1NHRV9DSEFJTjY0ICAgQ2hhaW42NDsKK307CisKK3VuaW9uIE1QSTJfU0dF
X0lPX1VOSU9OIHsKKwlzdHJ1Y3QgTVBJMl9TR0VfU0lNUExFX1VOSU9OICAgICAgIE1waVNpbXBs
ZTsKKwlzdHJ1Y3QgTVBJMl9TR0VfQ0hBSU5fVU5JT04gICAgICAgIE1waUNoYWluOworCXVuaW9u
IE1QSTJfSUVFRV9TR0VfU0lNUExFX1VOSU9OICBJZWVlU2ltcGxlOworCXVuaW9uIE1QSTJfSUVF
RV9TR0VfQ0hBSU5fVU5JT04gICBJZWVlQ2hhaW47Cit9OworCit1bmlvbiBNUEkyX1NDU0lfSU9f
Q0RCX1VOSU9OIHsKKwl1OCAgICAgICAgICAgICAgICAgICAgICBDREIzMlszMl07CisJc3RydWN0
IE1QSTJfU0NTSV9JT19DREJfRUVEUDMyIEVFRFAzMjsKKwlzdHJ1Y3QgTVBJMl9TR0VfU0lNUExF
X1VOSU9OIFNHRTsKK307CisKKy8qCisgKiBSQUlEIFNDU0kgSU8gUmVxdWVzdCBNZXNzYWdlCisg
KiBUb3RhbCBTR0UgY291bnQgd2lsbCBiZSBvbmUgbGVzcyB0aGFuICBfTVBJMl9TQ1NJX0lPX1JF
UVVFU1QKKyAqLworc3RydWN0IE1QSTJfUkFJRF9TQ1NJX0lPX1JFUVVFU1QgeworCXUxNiAgICAg
ICAgICAgICAgICAgICAgIERldkhhbmRsZTsgICAgICAgICAgICAgICAgICAgICAgLyogMHgwMCAq
LworCXU4ICAgICAgICAgICAgICAgICAgICAgIENoYWluT2Zmc2V0OyAgICAgICAgICAgICAgICAg
ICAgLyogMHgwMiAqLworCXU4ICAgICAgICAgICAgICAgICAgICAgIEZ1bmN0aW9uOyAgICAgICAg
ICAgICAgICAgICAgICAgLyogMHgwMyAqLworCXUxNiAgICAgICAgICAgICAgICAgICAgIFJlc2Vy
dmVkMTsgICAgICAgICAgICAgICAgICAgICAgLyogMHgwNCAqLworCXU4ICAgICAgICAgICAgICAg
ICAgICAgIFJlc2VydmVkMjsgICAgICAgICAgICAgICAgICAgICAgLyogMHgwNiAqLworCXU4ICAg
ICAgICAgICAgICAgICAgICAgIE1zZ0ZsYWdzOyAgICAgICAgICAgICAgICAgICAgICAgLyogMHgw
NyAqLworCXU4ICAgICAgICAgICAgICAgICAgICAgIFZQX0lEOyAgICAgICAgICAgICAgICAgICAg
ICAgICAgLyogMHgwOCAqLworCXU4ICAgICAgICAgICAgICAgICAgICAgIFZGX0lEOyAgICAgICAg
ICAgICAgICAgICAgICAgICAgLyogMHgwOSAqLworCXUxNiAgICAgICAgICAgICAgICAgICAgIFJl
c2VydmVkMzsgICAgICAgICAgICAgICAgICAgICAgLyogMHgwQSAqLworCXUzMiAgICAgICAgICAg
ICAgICAgICAgIFNlbnNlQnVmZmVyTG93QWRkcmVzczsgICAgICAgICAgLyogMHgwQyAqLworCXUx
NiAgICAgICAgICAgICAgICAgICAgIFNHTEZsYWdzOyAgICAgICAgICAgICAgICAgICAgICAgLyog
MHgxMCAqLworCXU4ICAgICAgICAgICAgICAgICAgICAgIFNlbnNlQnVmZmVyTGVuZ3RoOyAgICAg
ICAgICAgICAgLyogMHgxMiAqLworCXU4ICAgICAgICAgICAgICAgICAgICAgIFJlc2VydmVkNDsg
ICAgICAgICAgICAgICAgICAgICAgLyogMHgxMyAqLworCXU4ICAgICAgICAgICAgICAgICAgICAg
IFNHTE9mZnNldDA7ICAgICAgICAgICAgICAgICAgICAgLyogMHgxNCAqLworCXU4ICAgICAgICAg
ICAgICAgICAgICAgIFNHTE9mZnNldDE7ICAgICAgICAgICAgICAgICAgICAgLyogMHgxNSAqLwor
CXU4ICAgICAgICAgICAgICAgICAgICAgIFNHTE9mZnNldDI7ICAgICAgICAgICAgICAgICAgICAg
LyogMHgxNiAqLworCXU4ICAgICAgICAgICAgICAgICAgICAgIFNHTE9mZnNldDM7ICAgICAgICAg
ICAgICAgICAgICAgLyogMHgxNyAqLworCXUzMiAgICAgICAgICAgICAgICAgICAgIFNraXBDb3Vu
dDsgICAgICAgICAgICAgICAgICAgICAgLyogMHgxOCAqLworCXUzMiAgICAgICAgICAgICAgICAg
ICAgIERhdGFMZW5ndGg7ICAgICAgICAgICAgICAgICAgICAgLyogMHgxQyAqLworCXUzMiAgICAg
ICAgICAgICAgICAgICAgIEJpZGlyZWN0aW9uYWxEYXRhTGVuZ3RoOyAgICAgICAgLyogMHgyMCAq
LworCXUxNiAgICAgICAgICAgICAgICAgICAgIElvRmxhZ3M7ICAgICAgICAgICAgICAgICAgICAg
ICAgLyogMHgyNCAqLworCXUxNiAgICAgICAgICAgICAgICAgICAgIEVFRFBGbGFnczsgICAgICAg
ICAgICAgICAgICAgICAgLyogMHgyNiAqLworCXUzMiAgICAgICAgICAgICAgICAgICAgIEVFRFBC
bG9ja1NpemU7ICAgICAgICAgICAgICAgICAgLyogMHgyOCAqLworCXUzMiAgICAgICAgICAgICAg
ICAgICAgIFNlY29uZGFyeVJlZmVyZW5jZVRhZzsgICAgICAgICAgLyogMHgyQyAqLworCXUxNiAg
ICAgICAgICAgICAgICAgICAgIFNlY29uZGFyeUFwcGxpY2F0aW9uVGFnOyAgICAgICAgLyogMHgz
MCAqLworCXUxNiAgICAgICAgICAgICAgICAgICAgIEFwcGxpY2F0aW9uVGFnVHJhbnNsYXRpb25N
YXNrOyAgLyogMHgzMiAqLworCXU4ICAgICAgICAgICAgICAgICAgICAgIExVTls4XTsgICAgICAg
ICAgICAgICAgICAgICAgICAgLyogMHgzNCAqLworCXUzMiAgICAgICAgICAgICAgICAgICAgIENv
bnRyb2w7ICAgICAgICAgICAgICAgICAgICAgICAgLyogMHgzQyAqLworCXVuaW9uIE1QSTJfU0NT
SV9JT19DREJfVU5JT04gIENEQjsJCQkvKiAweDQwICovCisJc3RydWN0IFJBSURfQ09OVEVYVAlS
YWlkQ29udGV4dDsgICAgICAgICAgICAgICAgICAgIC8qIDB4NjAgKi8KKwl1bmlvbiBNUEkyX1NH
RV9JT19VTklPTiAgICAgICBTR0w7CQkJLyogMHg4MCAqLworfTsKKworLyoKKyAqIE1QVCBSQUlE
IE1GQSBJTyBEZXNjcmlwdG9yLgorICovCitzdHJ1Y3QgTUVHQVNBU19SQUlEX01GQV9JT19SRVFV
RVNUX0RFU0NSSVBUT1IgeworCXUzMiAgICAgUmVxdWVzdEZsYWdzOjg7CisJdTMyICAgICBNZXNz
YWdlQWRkcmVzczE6MjQ7IC8qIGJpdHMgMzE6OCovCisJdTMyICAgICBNZXNzYWdlQWRkcmVzczI7
ICAgICAgLyogYml0cyA2MTozMiAqLworfTsKKworLyogRGVmYXVsdCBSZXF1ZXN0IERlc2NyaXB0
b3IgKi8KK3N0cnVjdCBNUEkyX0RFRkFVTFRfUkVRVUVTVF9ERVNDUklQVE9SIHsKKwl1OCAgICAg
ICAgICAgICAgUmVxdWVzdEZsYWdzOyAgICAgICAgICAgICAgIC8qIDB4MDAgKi8KKwl1OCAgICAg
ICAgICAgICAgTVNJeEluZGV4OyAgICAgICAgICAgICAgICAgIC8qIDB4MDEgKi8KKwl1MTYgICAg
ICAgICAgICAgU01JRDsgICAgICAgICAgICAgICAgICAgICAgIC8qIDB4MDIgKi8KKwl1MTYgICAg
ICAgICAgICAgTE1JRDsgICAgICAgICAgICAgICAgICAgICAgIC8qIDB4MDQgKi8KKwl1MTYgICAg
ICAgICAgICAgRGVzY3JpcHRvclR5cGVEZXBlbmRlbnQ7ICAgIC8qIDB4MDYgKi8KK307CisKKy8q
IEhpZ2ggUHJpb3JpdHkgUmVxdWVzdCBEZXNjcmlwdG9yICovCitzdHJ1Y3QgTVBJMl9ISUdIX1BS
SU9SSVRZX1JFUVVFU1RfREVTQ1JJUFRPUiB7CisJdTggICAgICAgICAgICAgIFJlcXVlc3RGbGFn
czsgICAgICAgICAgICAgICAvKiAweDAwICovCisJdTggICAgICAgICAgICAgIE1TSXhJbmRleDsg
ICAgICAgICAgICAgICAgICAvKiAweDAxICovCisJdTE2ICAgICAgICAgICAgIFNNSUQ7ICAgICAg
ICAgICAgICAgICAgICAgICAvKiAweDAyICovCisJdTE2ICAgICAgICAgICAgIExNSUQ7ICAgICAg
ICAgICAgICAgICAgICAgICAvKiAweDA0ICovCisJdTE2ICAgICAgICAgICAgIFJlc2VydmVkMTsg
ICAgICAgICAgICAgICAgICAvKiAweDA2ICovCit9OworCisvKiBTQ1NJIElPIFJlcXVlc3QgRGVz
Y3JpcHRvciAqLworc3RydWN0IE1QSTJfU0NTSV9JT19SRVFVRVNUX0RFU0NSSVBUT1IgeworCXU4
ICAgICAgICAgICAgICBSZXF1ZXN0RmxhZ3M7ICAgICAgICAgICAgICAgLyogMHgwMCAqLworCXU4
ICAgICAgICAgICAgICBNU0l4SW5kZXg7ICAgICAgICAgICAgICAgICAgLyogMHgwMSAqLworCXUx
NiAgICAgICAgICAgICBTTUlEOyAgICAgICAgICAgICAgICAgICAgICAgLyogMHgwMiAqLworCXUx
NiAgICAgICAgICAgICBMTUlEOyAgICAgICAgICAgICAgICAgICAgICAgLyogMHgwNCAqLworCXUx
NiAgICAgICAgICAgICBEZXZIYW5kbGU7ICAgICAgICAgICAgICAgICAgLyogMHgwNiAqLworfTsK
KworLyogU0NTSSBUYXJnZXQgUmVxdWVzdCBEZXNjcmlwdG9yICovCitzdHJ1Y3QgTVBJMl9TQ1NJ
X1RBUkdFVF9SRVFVRVNUX0RFU0NSSVBUT1IgeworCXU4ICAgICAgICAgICAgICBSZXF1ZXN0Rmxh
Z3M7ICAgICAgICAgICAgICAgLyogMHgwMCAqLworCXU4ICAgICAgICAgICAgICBNU0l4SW5kZXg7
ICAgICAgICAgICAgICAgICAgLyogMHgwMSAqLworCXUxNiAgICAgICAgICAgICBTTUlEOyAgICAg
ICAgICAgICAgICAgICAgICAgLyogMHgwMiAqLworCXUxNiAgICAgICAgICAgICBMTUlEOyAgICAg
ICAgICAgICAgICAgICAgICAgLyogMHgwNCAqLworCXUxNiAgICAgICAgICAgICBJb0luZGV4OyAg
ICAgICAgICAgICAgICAgICAgLyogMHgwNiAqLworfTsKKworLyogUkFJRCBBY2NlbGVyYXRvciBS
ZXF1ZXN0IERlc2NyaXB0b3IgKi8KK3N0cnVjdCBNUEkyX1JBSURfQUNDRUxfUkVRVUVTVF9ERVND
UklQVE9SIHsKKwl1OCAgICAgICAgICAgICAgUmVxdWVzdEZsYWdzOyAgICAgICAgICAgICAgIC8q
IDB4MDAgKi8KKwl1OCAgICAgICAgICAgICAgTVNJeEluZGV4OyAgICAgICAgICAgICAgICAgIC8q
IDB4MDEgKi8KKwl1MTYgICAgICAgICAgICAgU01JRDsgICAgICAgICAgICAgICAgICAgICAgIC8q
IDB4MDIgKi8KKwl1MTYgICAgICAgICAgICAgTE1JRDsgICAgICAgICAgICAgICAgICAgICAgIC8q
IDB4MDQgKi8KKwl1MTYgICAgICAgICAgICAgUmVzZXJ2ZWQ7ICAgICAgICAgICAgICAgICAgIC8q
IDB4MDYgKi8KK307CisKKy8qIHVuaW9uIG9mIFJlcXVlc3QgRGVzY3JpcHRvcnMgKi8KK3VuaW9u
IE1FR0FTQVNfUkVRVUVTVF9ERVNDUklQVE9SX1VOSU9OIHsKKwlzdHJ1Y3QgTVBJMl9ERUZBVUxU
X1JFUVVFU1RfREVTQ1JJUFRPUiAgICAgICAgICAgICBEZWZhdWx0OworCXN0cnVjdCBNUEkyX0hJ
R0hfUFJJT1JJVFlfUkVRVUVTVF9ERVNDUklQVE9SICAgICAgIEhpZ2hQcmlvcml0eTsKKwlzdHJ1
Y3QgTVBJMl9TQ1NJX0lPX1JFUVVFU1RfREVTQ1JJUFRPUiAgICAgICAgICAgICBTQ1NJSU87CisJ
c3RydWN0IE1QSTJfU0NTSV9UQVJHRVRfUkVRVUVTVF9ERVNDUklQVE9SICAgICAgICAgU0NTSVRh
cmdldDsKKwlzdHJ1Y3QgTVBJMl9SQUlEX0FDQ0VMX1JFUVVFU1RfREVTQ1JJUFRPUiAgICAgICAg
ICBSQUlEQWNjZWxlcmF0b3I7CisJc3RydWN0IE1FR0FTQVNfUkFJRF9NRkFfSU9fUkVRVUVTVF9E
RVNDUklQVE9SICAgICAgTUZBSW87CisJdW5pb24geworCQlzdHJ1Y3QgeworCQkJdTMyIGxvdzsK
KwkJCXUzMiBoaWdoOworCQl9IHU7CisJCXU2NCBXb3JkczsKKwl9OworfTsKKworLyogRGVmYXVs
dCBSZXBseSBEZXNjcmlwdG9yICovCitzdHJ1Y3QgTVBJMl9ERUZBVUxUX1JFUExZX0RFU0NSSVBU
T1IgeworCXU4ICAgICAgICAgICAgICBSZXBseUZsYWdzOyAgICAgICAgICAgICAgICAgLyogMHgw
MCAqLworCXU4ICAgICAgICAgICAgICBNU0l4SW5kZXg7ICAgICAgICAgICAgICAgICAgLyogMHgw
MSAqLworCXUxNiAgICAgICAgICAgICBEZXNjcmlwdG9yVHlwZURlcGVuZGVudDE7ICAgLyogMHgw
MiAqLworCXUzMiAgICAgICAgICAgICBEZXNjcmlwdG9yVHlwZURlcGVuZGVudDI7ICAgLyogMHgw
NCAqLworfTsKKworLyogQWRkcmVzcyBSZXBseSBEZXNjcmlwdG9yICovCitzdHJ1Y3QgTVBJMl9B
RERSRVNTX1JFUExZX0RFU0NSSVBUT1IgeworCXU4ICAgICAgICAgICAgICBSZXBseUZsYWdzOyAg
ICAgICAgICAgICAgICAgLyogMHgwMCAqLworCXU4ICAgICAgICAgICAgICBNU0l4SW5kZXg7ICAg
ICAgICAgICAgICAgICAgLyogMHgwMSAqLworCXUxNiAgICAgICAgICAgICBTTUlEOyAgICAgICAg
ICAgICAgICAgICAgICAgLyogMHgwMiAqLworCXUzMiAgICAgICAgICAgICBSZXBseUZyYW1lQWRk
cmVzczsgICAgICAgICAgLyogMHgwNCAqLworfTsKKworLyogU0NTSSBJTyBTdWNjZXNzIFJlcGx5
IERlc2NyaXB0b3IgKi8KK3N0cnVjdCBNUEkyX1NDU0lfSU9fU1VDQ0VTU19SRVBMWV9ERVNDUklQ
VE9SIHsKKwl1OCAgICAgICAgICAgICAgUmVwbHlGbGFnczsgICAgICAgICAgICAgICAgIC8qIDB4
MDAgKi8KKwl1OCAgICAgICAgICAgICAgTVNJeEluZGV4OyAgICAgICAgICAgICAgICAgIC8qIDB4
MDEgKi8KKwl1MTYgICAgICAgICAgICAgU01JRDsgICAgICAgICAgICAgICAgICAgICAgIC8qIDB4
MDIgKi8KKwl1MTYgICAgICAgICAgICAgVGFza1RhZzsgICAgICAgICAgICAgICAgICAgIC8qIDB4
MDQgKi8KKwl1MTYgICAgICAgICAgICAgUmVzZXJ2ZWQxOyAgICAgICAgICAgICAgICAgIC8qIDB4
MDYgKi8KK307CisKKy8qIFRhcmdldEFzc2lzdCBTdWNjZXNzIFJlcGx5IERlc2NyaXB0b3IgKi8K
K3N0cnVjdCBNUEkyX1RBUkdFVEFTU0lTVF9TVUNDRVNTX1JFUExZX0RFU0NSSVBUT1IgeworCXU4
ICAgICAgICAgICAgICBSZXBseUZsYWdzOyAgICAgICAgICAgICAgICAgLyogMHgwMCAqLworCXU4
ICAgICAgICAgICAgICBNU0l4SW5kZXg7ICAgICAgICAgICAgICAgICAgLyogMHgwMSAqLworCXUx
NiAgICAgICAgICAgICBTTUlEOyAgICAgICAgICAgICAgICAgICAgICAgLyogMHgwMiAqLworCXU4
ICAgICAgICAgICAgICBTZXF1ZW5jZU51bWJlcjsgICAgICAgICAgICAgLyogMHgwNCAqLworCXU4
ICAgICAgICAgICAgICBSZXNlcnZlZDE7ICAgICAgICAgICAgICAgICAgLyogMHgwNSAqLworCXUx
NiAgICAgICAgICAgICBJb0luZGV4OyAgICAgICAgICAgICAgICAgICAgLyogMHgwNiAqLworfTsK
KworLyogVGFyZ2V0IENvbW1hbmQgQnVmZmVyIFJlcGx5IERlc2NyaXB0b3IgKi8KK3N0cnVjdCBN
UEkyX1RBUkdFVF9DT01NQU5EX0JVRkZFUl9SRVBMWV9ERVNDUklQVE9SIHsKKwl1OCAgICAgICAg
ICAgICAgUmVwbHlGbGFnczsgICAgICAgICAgICAgICAgIC8qIDB4MDAgKi8KKwl1OCAgICAgICAg
ICAgICAgTVNJeEluZGV4OyAgICAgICAgICAgICAgICAgIC8qIDB4MDEgKi8KKwl1OCAgICAgICAg
ICAgICAgVlBfSUQ7ICAgICAgICAgICAgICAgICAgICAgIC8qIDB4MDIgKi8KKwl1OCAgICAgICAg
ICAgICAgRmxhZ3M7ICAgICAgICAgICAgICAgICAgICAgIC8qIDB4MDMgKi8KKwl1MTYgICAgICAg
ICAgICAgSW5pdGlhdG9yRGV2SGFuZGxlOyAgICAgICAgIC8qIDB4MDQgKi8KKwl1MTYgICAgICAg
ICAgICAgSW9JbmRleDsgICAgICAgICAgICAgICAgICAgIC8qIDB4MDYgKi8KK307CisKKy8qIFJB
SUQgQWNjZWxlcmF0b3IgU3VjY2VzcyBSZXBseSBEZXNjcmlwdG9yICovCitzdHJ1Y3QgTVBJMl9S
QUlEX0FDQ0VMRVJBVE9SX1NVQ0NFU1NfUkVQTFlfREVTQ1JJUFRPUiB7CisJdTggICAgICAgICAg
ICAgIFJlcGx5RmxhZ3M7ICAgICAgICAgICAgICAgICAvKiAweDAwICovCisJdTggICAgICAgICAg
ICAgIE1TSXhJbmRleDsgICAgICAgICAgICAgICAgICAvKiAweDAxICovCisJdTE2ICAgICAgICAg
ICAgIFNNSUQ7ICAgICAgICAgICAgICAgICAgICAgICAvKiAweDAyICovCisJdTMyICAgICAgICAg
ICAgIFJlc2VydmVkOyAgICAgICAgICAgICAgICAgICAvKiAweDA0ICovCit9OworCisvKiB1bmlv
biBvZiBSZXBseSBEZXNjcmlwdG9ycyAqLwordW5pb24gTVBJMl9SRVBMWV9ERVNDUklQVE9SU19V
TklPTiB7CisJc3RydWN0IE1QSTJfREVGQVVMVF9SRVBMWV9ERVNDUklQVE9SICAgICAgICAgICAg
ICAgICAgIERlZmF1bHQ7CisJc3RydWN0IE1QSTJfQUREUkVTU19SRVBMWV9ERVNDUklQVE9SICAg
ICAgICAgICAgICAgICAgIEFkZHJlc3NSZXBseTsKKwlzdHJ1Y3QgTVBJMl9TQ1NJX0lPX1NVQ0NF
U1NfUkVQTFlfREVTQ1JJUFRPUiAgICAgICAgICAgU0NTSUlPU3VjY2VzczsKKwlzdHJ1Y3QgTVBJ
Ml9UQVJHRVRBU1NJU1RfU1VDQ0VTU19SRVBMWV9ERVNDUklQVE9SIFRhcmdldEFzc2lzdFN1Y2Nl
c3M7CisJc3RydWN0IE1QSTJfVEFSR0VUX0NPTU1BTkRfQlVGRkVSX1JFUExZX0RFU0NSSVBUT1Ig
VGFyZ2V0Q29tbWFuZEJ1ZmZlcjsKKwlzdHJ1Y3QgTVBJMl9SQUlEX0FDQ0VMRVJBVE9SX1NVQ0NF
U1NfUkVQTFlfREVTQ1JJUFRPUgorCVJBSURBY2NlbGVyYXRvclN1Y2Nlc3M7CisJdTY0ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgV29yZHM7Cit9OworCisvKiBJ
T0NJbml0IFJlcXVlc3QgbWVzc2FnZSAqLworc3RydWN0IE1QSTJfSU9DX0lOSVRfUkVRVUVTVCB7
CisJdTggICAgICAgICAgICAgICAgICAgICAgV2hvSW5pdDsgICAgICAgICAgICAgICAgICAgICAg
ICAvKiAweDAwICovCisJdTggICAgICAgICAgICAgICAgICAgICAgUmVzZXJ2ZWQxOyAgICAgICAg
ICAgICAgICAgICAgICAvKiAweDAxICovCisJdTggICAgICAgICAgICAgICAgICAgICAgQ2hhaW5P
ZmZzZXQ7ICAgICAgICAgICAgICAgICAgICAvKiAweDAyICovCisJdTggICAgICAgICAgICAgICAg
ICAgICAgRnVuY3Rpb247ICAgICAgICAgICAgICAgICAgICAgICAvKiAweDAzICovCisJdTE2ICAg
ICAgICAgICAgICAgICAgICAgUmVzZXJ2ZWQyOyAgICAgICAgICAgICAgICAgICAgICAvKiAweDA0
ICovCisJdTggICAgICAgICAgICAgICAgICAgICAgUmVzZXJ2ZWQzOyAgICAgICAgICAgICAgICAg
ICAgICAvKiAweDA2ICovCisJdTggICAgICAgICAgICAgICAgICAgICAgTXNnRmxhZ3M7ICAgICAg
ICAgICAgICAgICAgICAgICAvKiAweDA3ICovCisJdTggICAgICAgICAgICAgICAgICAgICAgVlBf
SUQ7ICAgICAgICAgICAgICAgICAgICAgICAgICAvKiAweDA4ICovCisJdTggICAgICAgICAgICAg
ICAgICAgICAgVkZfSUQ7ICAgICAgICAgICAgICAgICAgICAgICAgICAvKiAweDA5ICovCisJdTE2
ICAgICAgICAgICAgICAgICAgICAgUmVzZXJ2ZWQ0OyAgICAgICAgICAgICAgICAgICAgICAvKiAw
eDBBICovCisJdTE2ICAgICAgICAgICAgICAgICAgICAgTXNnVmVyc2lvbjsgICAgICAgICAgICAg
ICAgICAgICAvKiAweDBDICovCisJdTE2ICAgICAgICAgICAgICAgICAgICAgSGVhZGVyVmVyc2lv
bjsgICAgICAgICAgICAgICAgICAvKiAweDBFICovCisJdTMyICAgICAgICAgICAgICAgICAgICAg
UmVzZXJ2ZWQ1OyAgICAgICAgICAgICAgICAgICAgICAvKiAweDEwICovCisJdTE2ICAgICAgICAg
ICAgICAgICAgICAgUmVzZXJ2ZWQ2OyAgICAgICAgICAgICAgICAgICAgICAvKiAweDE0ICovCisJ
dTggICAgICAgICAgICAgICAgICAgICAgUmVzZXJ2ZWQ3OyAgICAgICAgICAgICAgICAgICAgICAv
KiAweDE2ICovCisJdTggICAgICAgICAgICAgICAgICAgICAgSG9zdE1TSXhWZWN0b3JzOyAgICAg
ICAgICAgICAgICAvKiAweDE3ICovCisJdTE2ICAgICAgICAgICAgICAgICAgICAgUmVzZXJ2ZWQ4
OyAgICAgICAgICAgICAgICAgICAgICAvKiAweDE4ICovCisJdTE2ICAgICAgICAgICAgICAgICAg
ICAgU3lzdGVtUmVxdWVzdEZyYW1lU2l6ZTsgICAgICAgICAvKiAweDFBICovCisJdTE2ICAgICAg
ICAgICAgICAgICAgICAgUmVwbHlEZXNjcmlwdG9yUG9zdFF1ZXVlRGVwdGg7ICAvKiAweDFDICov
CisJdTE2ICAgICAgICAgICAgICAgICAgICAgUmVwbHlGcmVlUXVldWVEZXB0aDsgICAgICAgICAg
ICAvKiAweDFFICovCisJdTMyICAgICAgICAgICAgICAgICAgICAgU2Vuc2VCdWZmZXJBZGRyZXNz
SGlnaDsgICAgICAgICAvKiAweDIwICovCisJdTMyICAgICAgICAgICAgICAgICAgICAgU3lzdGVt
UmVwbHlBZGRyZXNzSGlnaDsgICAgICAgICAvKiAweDI0ICovCisJdTY0ICAgICAgICAgICAgICAg
ICAgICAgU3lzdGVtUmVxdWVzdEZyYW1lQmFzZUFkZHJlc3M7ICAvKiAweDI4ICovCisJdTY0ICAg
ICAgICAgICAgICAgICAgICAgUmVwbHlEZXNjcmlwdG9yUG9zdFF1ZXVlQWRkcmVzczsvKiAweDMw
ICovCisJdTY0ICAgICAgICAgICAgICAgICAgICAgUmVwbHlGcmVlUXVldWVBZGRyZXNzOyAgICAg
ICAgICAvKiAweDM4ICovCisJdTY0ICAgICAgICAgICAgICAgICAgICAgVGltZVN0YW1wOyAgICAg
ICAgICAgICAgICAgICAgICAvKiAweDQwICovCit9OworCisvKiBtcnByaXYgZGVmaW5lcyAqLwor
I2RlZmluZSBNUl9QRF9JTlZBTElEIDB4RkZGRgorI2RlZmluZSBNQVhfU1BBTl9ERVBUSCA4Cisj
ZGVmaW5lIE1BWF9SQUlETUFQX1NQQU5fREVQVEggKE1BWF9TUEFOX0RFUFRIKQorI2RlZmluZSBN
QVhfUk9XX1NJWkUgMzIKKyNkZWZpbmUgTUFYX1JBSURNQVBfUk9XX1NJWkUgKE1BWF9ST1dfU0la
RSkKKyNkZWZpbmUgTUFYX0xPR0lDQUxfRFJJVkVTIDY0CisjZGVmaW5lIE1BWF9SQUlETUFQX0xP
R0lDQUxfRFJJVkVTIChNQVhfTE9HSUNBTF9EUklWRVMpCisjZGVmaW5lIE1BWF9SQUlETUFQX1ZJ
RVdTIChNQVhfTE9HSUNBTF9EUklWRVMpCisjZGVmaW5lIE1BWF9BUlJBWVMgMTI4CisjZGVmaW5l
IE1BWF9SQUlETUFQX0FSUkFZUyAoTUFYX0FSUkFZUykKKyNkZWZpbmUgTUFYX1BIWVNJQ0FMX0RF
VklDRVMgMjU2CisjZGVmaW5lIE1BWF9SQUlETUFQX1BIWVNJQ0FMX0RFVklDRVMgKE1BWF9QSFlT
SUNBTF9ERVZJQ0VTKQorI2RlZmluZSBNUl9EQ01EX0xEX01BUF9HRVRfSU5GTyAgICAgICAgICAg
ICAweDAzMDBlMTAxCisKK3N0cnVjdCBNUl9ERVZfSEFORExFX0lORk8geworCXUxNiAgICAgY3Vy
RGV2SGRsOworCXU4ICAgICAgdmFsaWRIYW5kbGVzOworCXU4ICAgICAgcmVzZXJ2ZWQ7CisJdTE2
ICAgICBkZXZIYW5kbGVbMl07Cit9OworCitzdHJ1Y3QgTVJfQVJSQVlfSU5GTyB7CisJdTE2ICAg
ICAgcGRbTUFYX1JBSURNQVBfUk9XX1NJWkVdOworfTsKKworc3RydWN0IE1SX1FVQURfRUxFTUVO
VCB7CisJdTY0ICAgICBsb2dTdGFydDsKKwl1NjQgICAgIGxvZ0VuZDsKKwl1NjQgICAgIG9mZnNl
dEluU3BhbjsKKwl1MzIgICAgIGRpZmY7CisJdTMyICAgICByZXNlcnZlZDE7Cit9OworCitzdHJ1
Y3QgTVJfU1BBTl9JTkZPIHsKKwl1MzIgICAgICAgICAgICAgbm9FbGVtZW50czsKKwl1MzIgICAg
ICAgICAgICAgcmVzZXJ2ZWQxOworCXN0cnVjdCBNUl9RVUFEX0VMRU1FTlQgcXVhZFtNQVhfUkFJ
RE1BUF9TUEFOX0RFUFRIXTsKK307CisKK3N0cnVjdCBNUl9MRF9TUEFOIHsKKwl1NjQgICAgICBz
dGFydEJsazsKKwl1NjQgICAgICBudW1CbGtzOworCXUxNiAgICAgIGFycmF5UmVmOworCXU4ICAg
ICAgIHJlc2VydmVkWzZdOworfTsKKworc3RydWN0IE1SX1NQQU5fQkxPQ0tfSU5GTyB7CisJdTY0
ICAgICAgICAgIG51bV9yb3dzOworCXN0cnVjdCBNUl9MRF9TUEFOICAgc3BhbjsKKwlzdHJ1Y3Qg
TVJfU1BBTl9JTkZPIGJsb2NrX3NwYW5faW5mbzsKK307CisKK3N0cnVjdCBNUl9MRF9SQUlEIHsK
KwlzdHJ1Y3QgeworCQl1MzIgICAgIGZwQ2FwYWJsZToxOworCQl1MzIgICAgIHJlc2VydmVkNToz
OworCQl1MzIgICAgIGxkUGlNb2RlOjQ7CisJCXUzMiAgICAgcGRQaU1vZGU6NDsKKwkJdTMyICAg
ICBlbmNyeXB0aW9uVHlwZTo4OworCQl1MzIgICAgIGZwV3JpdGVDYXBhYmxlOjE7CisJCXUzMiAg
ICAgZnBSZWFkQ2FwYWJsZToxOworCQl1MzIgICAgIGZwV3JpdGVBY3Jvc3NTdHJpcGU6MTsKKwkJ
dTMyICAgICBmcFJlYWRBY3Jvc3NTdHJpcGU6MTsKKwkJdTMyICAgICByZXNlcnZlZDQ6ODsKKwl9
IGNhcGFiaWxpdHk7CisJdTMyICAgICByZXNlcnZlZDY7CisJdTY0ICAgICBzaXplOworCXU4ICAg
ICAgc3BhbkRlcHRoOworCXU4ICAgICAgbGV2ZWw7CisJdTggICAgICBzdHJpcGVTaGlmdDsKKwl1
OCAgICAgIHJvd1NpemU7CisJdTggICAgICByb3dEYXRhU2l6ZTsKKwl1OCAgICAgIHdyaXRlTW9k
ZTsKKwl1OCAgICAgIFBSTDsKKwl1OCAgICAgIFNSTDsKKwl1MTYgICAgIHRhcmdldElkOworCXU4
ICAgICAgbGRTdGF0ZTsKKwl1OCAgICAgIHJlZ1R5cGVSZXFPbldyaXRlOworCXU4ICAgICAgbW9k
RmFjdG9yOworCXU4ICAgICAgcmVzZXJ2ZWQyWzFdOworCXUxNiAgICAgc2VxTnVtOworCisJc3Ry
dWN0IHsKKwkJdTMyIGxkU3luY1JlcXVpcmVkOjE7CisJCXUzMiByZXNlcnZlZDozMTsKKwl9IGZs
YWdzOworCisJdTggICAgICByZXNlcnZlZDNbMHg1Q107Cit9OworCitzdHJ1Y3QgTVJfTERfU1BB
Tl9NQVAgeworCXN0cnVjdCBNUl9MRF9SQUlEICAgICAgICAgIGxkUmFpZDsKKwl1OCAgICAgICAg
ICAgICAgICAgIGRhdGFBcm1NYXBbTUFYX1JBSURNQVBfUk9XX1NJWkVdOworCXN0cnVjdCBNUl9T
UEFOX0JMT0NLX0lORk8gIHNwYW5CbG9ja1tNQVhfUkFJRE1BUF9TUEFOX0RFUFRIXTsKK307CisK
K3N0cnVjdCBNUl9GV19SQUlEX01BUCB7CisJdTMyICAgICAgICAgICAgICAgICB0b3RhbFNpemU7
CisJdW5pb24geworCQlzdHJ1Y3QgeworCQkJdTMyICAgICAgICAgbWF4TGQ7CisJCQl1MzIgICAg
ICAgICBtYXhTcGFuRGVwdGg7CisJCQl1MzIgICAgICAgICBtYXhSb3dTaXplOworCQkJdTMyICAg
ICAgICAgbWF4UGRDb3VudDsKKwkJCXUzMiAgICAgICAgIG1heEFycmF5czsKKwkJfSB2YWxpZGF0
aW9uSW5mbzsKKwkJdTMyICAgICAgICAgICAgIHZlcnNpb25bNV07CisJCXUzMiAgICAgICAgICAg
ICByZXNlcnZlZDFbNV07CisJfTsKKworCXUzMiAgICAgICAgICAgICAgICAgbGRDb3VudDsKKwl1
MzIgICAgICAgICAgICAgICAgIFJlc2VydmVkMTsKKwl1OCAgICAgICAgICAgICAgICAgIGxkVGd0
SWRUb0xkW01BWF9SQUlETUFQX0xPR0lDQUxfRFJJVkVTKworCQkJCQlNQVhfUkFJRE1BUF9WSUVX
U107CisJdTggICAgICAgICAgICAgICAgICBmcFBkSW9UaW1lb3V0U2VjOworCXU4ICAgICAgICAg
ICAgICAgICAgcmVzZXJ2ZWQyWzddOworCXN0cnVjdCBNUl9BUlJBWV9JTkZPICAgICAgIGFyTWFw
SW5mb1tNQVhfUkFJRE1BUF9BUlJBWVNdOworCXN0cnVjdCBNUl9ERVZfSEFORExFX0lORk8gIGRl
dkhuZGxJbmZvW01BWF9SQUlETUFQX1BIWVNJQ0FMX0RFVklDRVNdOworCXN0cnVjdCBNUl9MRF9T
UEFOX01BUCAgICAgIGxkU3Bhbk1hcFsxXTsKK307CisKK3N0cnVjdCBJT19SRVFVRVNUX0lORk8g
eworCXU2NCBsZFN0YXJ0QmxvY2s7CisJdTMyIG51bUJsb2NrczsKKwl1MTYgbGRUZ3RJZDsKKwl1
OCBpc1JlYWQ7CisJdTE2IGRldkhhbmRsZTsKKwl1NjQgcGRCbG9jazsKKwl1OCBmcE9rRm9ySW87
Cit9OworCitzdHJ1Y3QgTVJfTERfVEFSR0VUX1NZTkMgeworCXU4ICB0YXJnZXRJZDsKKwl1OCAg
cmVzZXJ2ZWQ7CisJdTE2IHNlcU51bTsKK307CisKKyNkZWZpbmUgSUVFRV9TR0VfRkxBR1NfQURE
Ul9NQVNLICAgICAgICAgICAgKDB4MDMpCisjZGVmaW5lIElFRUVfU0dFX0ZMQUdTX1NZU1RFTV9B
RERSICAgICAgICAgICgweDAwKQorI2RlZmluZSBJRUVFX1NHRV9GTEFHU19JT0NERFJfQUREUiAg
ICAgICAgICAoMHgwMSkKKyNkZWZpbmUgSUVFRV9TR0VfRkxBR1NfSU9DUExCX0FERFIgICAgICAg
ICAgKDB4MDIpCisjZGVmaW5lIElFRUVfU0dFX0ZMQUdTX0lPQ1BMQk5UQV9BRERSICAgICAgICgw
eDAzKQorI2RlZmluZSBJRUVFX1NHRV9GTEFHU19DSEFJTl9FTEVNRU5UICAgICAgICAoMHg4MCkK
KyNkZWZpbmUgSUVFRV9TR0VfRkxBR1NfRU5EX09GX0xJU1QgICAgICAgICAgKDB4NDApCisKK3N0
cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldDsKK3N0cnVjdCBtZWdhc2FzX2luc3RhbmNlOworCit1
bmlvbiBkZXNjX3dvcmQgeworCXU2NCB3b3JkOworCXN0cnVjdCB7CisJCXUzMiBsb3c7CisJCXUz
MiBoaWdoOworCX0gdTsKK307CisKK3N0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24geworCXN0cnVj
dCBNUEkyX1JBSURfU0NTSV9JT19SRVFVRVNUCSppb19yZXF1ZXN0OworCWRtYV9hZGRyX3QJCQlp
b19yZXF1ZXN0X3BoeXNfYWRkcjsKKworCXVuaW9uIE1QSTJfU0dFX0lPX1VOSU9OCSpzZ19mcmFt
ZTsKKwlkbWFfYWRkcl90CQlzZ19mcmFtZV9waHlzX2FkZHI7CisKKwl1OCAqc2Vuc2U7CisJZG1h
X2FkZHJfdCBzZW5zZV9waHlzX2FkZHI7CisKKwlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7CisJc3Ry
dWN0IHNjc2lfY21uZCAqc2NtZDsKKwlzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2U7
CisKKwl1OCByZXRyeV9mb3JfZndfcmVzZXQ7CisJdW5pb24gTUVHQVNBU19SRVFVRVNUX0RFU0NS
SVBUT1JfVU5JT04gICpyZXF1ZXN0X2Rlc2M7CisKKwkvKgorCSAqIENvbnRleHQgZm9yIGEgTUZJ
IGZyYW1lLgorCSAqIFVzZWQgdG8gZ2V0IHRoZSBtZmkgY21kIGZyb20gbGlzdCB3aGVuIGEgTUZJ
IGNtZCBpcyBjb21wbGV0ZWQKKwkgKi8KKwl1MzIgc3luY19jbWRfaWR4OworCXUzMiBpbmRleDsK
Kwl1OCBmbGFnczsKK307CisKK3N0cnVjdCBMRF9MT0FEX0JBTEFOQ0VfSU5GTyB7CisJdTgJbG9h
ZEJhbGFuY2VGbGFnOworCXU4CXJlc2VydmVkMTsKKwl1MTYgICAgIHJhaWQxRGV2SGFuZGxlWzJd
OworCWF0b21pY190ICAgICBzY3NpX3BlbmRpbmdfY21kc1syXTsKKwl1NjQgICAgIGxhc3RfYWNj
ZXNzZWRfYmxvY2tbMl07Cit9OworCitzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMIHsKKwlzdHJ1
Y3QgTVJfRldfUkFJRF9NQVAgcmFpZE1hcDsKKwlzdHJ1Y3QgTVJfTERfU1BBTl9NQVAgbGRTcGFu
TWFwW01BWF9MT0dJQ0FMX0RSSVZFUyAtIDFdOworfSBfX2F0dHJpYnV0ZV9fICgocGFja2VkKSk7
CisKK3N0cnVjdCBmdXNpb25fY29udGV4dCB7CisJc3RydWN0IG1lZ2FzYXNfY21kX2Z1c2lvbiAq
KmNtZF9saXN0OworCXN0cnVjdCBsaXN0X2hlYWQgY21kX3Bvb2w7CisKKwlzcGlubG9ja190IGNt
ZF9wb29sX2xvY2s7CisKKwlkbWFfYWRkcl90IHJlcV9mcmFtZXNfZGVzY19waHlzOworCXU4ICpy
ZXFfZnJhbWVzX2Rlc2M7CisKKwlzdHJ1Y3QgZG1hX3Bvb2wgKmlvX3JlcXVlc3RfZnJhbWVzX3Bv
b2w7CisJZG1hX2FkZHJfdCBpb19yZXF1ZXN0X2ZyYW1lc19waHlzOworCXU4ICppb19yZXF1ZXN0
X2ZyYW1lczsKKworCXN0cnVjdCBkbWFfcG9vbCAqc2dfZG1hX3Bvb2w7CisJc3RydWN0IGRtYV9w
b29sICpzZW5zZV9kbWFfcG9vbDsKKworCWRtYV9hZGRyX3QgcmVwbHlfZnJhbWVzX2Rlc2NfcGh5
czsKKwl1bmlvbiBNUEkyX1JFUExZX0RFU0NSSVBUT1JTX1VOSU9OICpyZXBseV9mcmFtZXNfZGVz
YzsKKwlzdHJ1Y3QgZG1hX3Bvb2wgKnJlcGx5X2ZyYW1lc19kZXNjX3Bvb2w7CisKKwl1MTYgbGFz
dF9yZXBseV9pZHg7CisKKwl1MzIgcmVwbHlfcV9kZXB0aDsKKwl1MzIgcmVxdWVzdF9hbGxvY19z
ejsKKwl1MzIgcmVwbHlfYWxsb2Nfc3o7CisJdTMyIGlvX2ZyYW1lc19hbGxvY19zejsKKworCXUx
NgltYXhfc2dlX2luX21haW5fbXNnOworCXUxNgltYXhfc2dlX2luX2NoYWluOworCisJdTgJY2hh
aW5fb2Zmc2V0X2lvX3JlcXVlc3Q7CisJdTgJY2hhaW5fb2Zmc2V0X21maV9wdGhydTsKKworCXN0
cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKmxkX21hcFsyXTsKKwlkbWFfYWRkcl90IGxkX21hcF9w
aHlzWzJdOworCisJdTMyIG1hcF9zejsKKwl1OCBmYXN0X3BhdGhfaW87CisJc3RydWN0IExEX0xP
QURfQkFMQU5DRV9JTkZPIGxvYWRfYmFsYW5jZV9pbmZvW01BWF9MT0dJQ0FMX0RSSVZFU107Cit9
OworCit1bmlvbiBkZXNjX3ZhbHVlIHsKKwl1NjQgd29yZDsKKwlzdHJ1Y3QgeworCQl1MzIgbG93
OworCQl1MzIgaGlnaDsKKwl9IHU7Cit9OworCisjZW5kaWYgLyogX01FR0FSQUlEX1NBU19GVVNJ
T05fSF8gKi8KZGlmZiAtTmF1ciBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVn
YXJhaWQvbWVnYXJhaWRfc2FzLmggbGludXgtMi42LjM3LXJjNS5uZXcvZHJpdmVycy9zY3NpL21l
Z2FyYWlkL21lZ2FyYWlkX3Nhcy5oCi0tLSBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Nj
c2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxMC0xMi0yMSAxMDowNjoyNy4wMDAwMDAwMDAg
LTA4MDAKKysrIGxpbnV4LTIuNi4zNy1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXMuaAkyMDEwLTEyLTIxIDExOjA0OjA5LjAwMDAwMDAwMCAtMDgwMApAQCAtMzMsOSAr
MzMsOSBAQAogLyoKICAqIE1lZ2FSQUlEIFNBUyBEcml2ZXIgbWV0YSBkYXRhCiAgKi8KLSNkZWZp
bmUgTUVHQVNBU19WRVJTSU9OCQkJIjAwLjAwLjA0LjMxLXJjMSIKLSNkZWZpbmUgTUVHQVNBU19S
RUxEQVRFCQkJIk1heSAzLCAyMDEwIgotI2RlZmluZSBNRUdBU0FTX0VYVF9WRVJTSU9OCQkiTW9u
LiBNYXkgMywgMTE6NDE6NTEgUFNUIDIwMTAiCisjZGVmaW5lIE1FR0FTQVNfVkVSU0lPTgkJCQki
MDAuMDAuMDUuMjktcmMxIgorI2RlZmluZSBNRUdBU0FTX1JFTERBVEUJCQkJIkRlYy4gNywgMjAx
MCIKKyNkZWZpbmUgTUVHQVNBU19FWFRfVkVSU0lPTgkJCSJUdWUuIERlYy4gNyAxNzowMDowMCBQ
RFQgMjAxMCIKIAogLyoKICAqIERldmljZSBJRHMKQEAgLTQ3LDYgKzQ3LDcgQEAKICNkZWZpbmUJ
UENJX0RFVklDRV9JRF9MU0lfU0FTMDA3OUdFTjIJCTB4MDA3OQogI2RlZmluZQlQQ0lfREVWSUNF
X0lEX0xTSV9TQVMwMDczU0tJTk5ZCQkweDAwNzMKICNkZWZpbmUJUENJX0RFVklDRV9JRF9MU0lf
U0FTMDA3MVNLSU5OWQkJMHgwMDcxCisjZGVmaW5lCVBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTgkJ
MHgwMDViCiAKIC8qCiAgKiA9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09CkBA
IC00MzYsNyArNDM3LDYgQEAKIAkqIEFkZCBwcm9wZXJ0aWVzIHRoYXQgY2FuIGJlIGNvbnRyb2xs
ZWQgYnkKIAkqIGEgYml0IGluIHRoZSBmb2xsb3dpbmcgc3RydWN0dXJlLgogCSovCi0KIAlzdHJ1
Y3QgewogCQl1MzIgICAgIGNvcHlCYWNrRGlzYWJsZWQgICAgICAgICAgICA6IDE7CiAJCXUzMiAg
ICAgU01BUlRlckVuYWJsZWQgICAgICAgICAgICAgIDogMTsKQEAgLTcxNiw2ICs3MTYsNyBAQAog
I2RlZmluZSBNRUdBU0FTX0RFRkFVTFRfSU5JVF9JRAkJCS0xCiAjZGVmaW5lIE1FR0FTQVNfTUFY
X0xVTgkJCQk4CiAjZGVmaW5lIE1FR0FTQVNfTUFYX0xECQkJCTY0CisjZGVmaW5lIE1FR0FTQVNf
REVGQVVMVF9DTURfUEVSX0xVTgkJMTI4CiAjZGVmaW5lIE1FR0FTQVNfTUFYX1BEICAgICAgICAg
ICAgICAgICAgICAgICAgICAoTUVHQVNBU19NQVhfUERfQ0hBTk5FTFMgKiBcCiAJCQkJCQlNRUdB
U0FTX01BWF9ERVZfUEVSX0NIQU5ORUwpCiAjZGVmaW5lIE1FR0FTQVNfTUFYX0xEX0lEUwkJCShN
RUdBU0FTX01BWF9MRF9DSEFOTkVMUyAqIFwKQEAgLTc4NCw3ICs3ODUsMTAgQEAKICovCiAgCiBz
dHJ1Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgewotCXUzMiAJcmVzZXJ2ZWRfMFs0XTsJCQkvKjAw
MDBoKi8KKwl1MzIJZG9vcmJlbGw7ICAgICAgICAgICAgICAgICAgICAgICAvKjAwMDBoKi8KKwl1
MzIJZnVzaW9uX3NlcV9vZmZzZXQ7CQkvKjAwMDRoKi8KKwl1MzIJZnVzaW9uX2hvc3RfZGlhZzsJ
CS8qMDAwOGgqLworCXUzMglyZXNlcnZlZF8wMTsJCQkvKjAwMENoKi8KIAogCXUzMiAJaW5ib3Vu
ZF9tc2dfMDsJCQkvKjAwMTBoKi8KIAl1MzIgCWluYm91bmRfbXNnXzE7CQkJLyowMDE0aCovCkBA
IC04MDQsMTUgKzgwOCwxOCBAQAogCXUzMiAJaW5ib3VuZF9xdWV1ZV9wb3J0OwkJLyowMDQwaCov
CiAJdTMyIAlvdXRib3VuZF9xdWV1ZV9wb3J0OwkJLyowMDQ0aCovCiAKLQl1MzIgCXJlc2VydmVk
XzJbMjJdOwkJCS8qMDA0OGgqLworCXUzMglyZXNlcnZlZF8yWzldOwkJCS8qMDA0OGgqLworCXUz
MglyZXBseV9wb3N0X2hvc3RfaW5kZXg7CQkvKjAwNkNoKi8KKwl1MzIJcmVzZXJ2ZWRfMl8yWzEy
XTsJCS8qMDA3MGgqLwogCiAJdTMyIAlvdXRib3VuZF9kb29yYmVsbF9jbGVhcjsJLyowMEEwaCov
CiAKIAl1MzIgCXJlc2VydmVkXzNbM107CQkJLyowMEE0aCovCiAKIAl1MzIgCW91dGJvdW5kX3Nj
cmF0Y2hfcGFkIDsJCS8qMDBCMGgqLworCXUzMglvdXRib3VuZF9zY3JhdGNoX3BhZF8yOyAgICAg
ICAgIC8qMDBCNGgqLwogCi0JdTMyIAlyZXNlcnZlZF80WzNdOwkJCS8qMDBCNGgqLworCXUzMgly
ZXNlcnZlZF80WzJdOwkJCS8qMDBCOGgqLwogCiAJdTMyIAlpbmJvdW5kX2xvd19xdWV1ZV9wb3J0
IDsJLyowMEMwaCovCiAKQEAgLTEyODcsNiArMTI5NCw5IEBACiAKIAl1MTYgbWF4X251bV9zZ2U7
CiAJdTE2IG1heF9md19jbWRzOworCS8qIEZvciBGdXNpb24gaXRzIG51bSBJT0NUTCBjbWRzLCBm
b3Igb3RoZXJzIE1GSSBiYXNlZCBpdHMKKwkgICBtYXhfZndfY21kcyAqLworCXUxNiBtYXhfbWZp
X2NtZHM7CiAJdTMyIG1heF9zZWN0b3JzX3Blcl9yZXE7CiAJc3RydWN0IG1lZ2FzYXNfYWVuX2V2
ZW50ICpldjsKIApAQCAtMTMzNiw5ICsxMzQ2LDE3IEBACiAJc3RydWN0IHRpbWVyX2xpc3QgaW9f
Y29tcGxldGlvbl90aW1lcjsKIAlzdHJ1Y3QgbGlzdF9oZWFkIGludGVybmFsX3Jlc2V0X3BlbmRp
bmdfcTsKIAorCS8qIFB0ciB0byBoYmEgc3BlY2ZpYyBpbmZvcm1hdGlvbiAqLworCXZvaWQgKmN0
cmxfY29udGV4dDsKIAl1OAltc2lfZmxhZzsKIAlzdHJ1Y3QgbXNpeF9lbnRyeSBtc2l4ZW50cnk7
CisJdTY0IG1hcF9pZDsKKwlzdHJ1Y3QgbWVnYXNhc19jbWQgKm1hcF91cGRhdGVfY21kOwogCXVu
c2lnbmVkIGxvbmcgYmFyOworCWxvbmcgcmVzZXRfZmxhZ3M7CisJc3RydWN0IG11dGV4IHJlc2V0
X211dGV4OworCXN0cnVjdCBzY3NpX2NtbmQgc2NtZDsKKwlzdHJ1Y3Qgc2NzaV9kZXZpY2UgZGV2
OwogfTsKIAogZW51bSB7CkBAIC0xMzk3LDcgKzE0MTUsMTMgQEAKIAlzdHJ1Y3QgbGlzdF9oZWFk
IGxpc3Q7CiAJc3RydWN0IHNjc2lfY21uZCAqc2NtZDsKIAlzdHJ1Y3QgbWVnYXNhc19pbnN0YW5j
ZSAqaW5zdGFuY2U7Ci0JdTMyIGZyYW1lX2NvdW50OworCXVuaW9uIHsKKwkJc3RydWN0IHsKKwkJ
CXUxNiBzbWlkOworCQkJdTE2IHJlc3ZkOworCQl9IGNvbnRleHQ7CisJCXUzMiBmcmFtZV9jb3Vu
dDsKKwl9OwogfTsKIAogI2RlZmluZSBNQVhfTUdNVF9BREFQVEVSUwkJMTAyNAo=
--00163630ffe327cf3d0497f08362--
