From: adam radford <aradford@gmail.com>
Subject: [PATCH 6-10/11]: REPOST2: megaraid_sas: Add 9565/9285 specific code
Date: Tue, 21 Dec 2010 13:34:31 -0800
Message-ID: <AANLkTinb1uYtH8+2xO+Wa=0yYuhLmN8giUz6N95iG6az@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016363b8520f20a800497f26660
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51109 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752689Ab0LUVed (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Dec 2010 16:34:33 -0500
Received: by qwa26 with SMTP id 26so4453754qwa.19
        for <linux-scsi@vger.kernel.org>; Tue, 21 Dec 2010 13:34:32 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016363b8520f20a800497f26660
Content-Type: text/plain; charset=ISO-8859-1

James/Linux-scsi,

REPOST2 to fix megasas_reset_fusion() to take struct Scsi_Host *
(Requested by Christoph Hellwig).

Add MegaRAID 9265/9285 specific code to megaraid_sas_base.c.
Add MegaRAID 9265/9285 specific functions: megaraid_sas_fusion.c
Add MegaRAID 9265/9285 megaraid_sas_fusion.h header.
Add MegaRAID 9265/9285 FastPath code.
Add MegaRAID 9265/9285 specific code to megaraid_sas.h.

Signed-off-by: Adam Radford <aradford@gmail.com>

Note: This patch has been included in-line below, and also as an
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
13:18:44.000000000 -0800
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
+int megasas_reset_fusion(struct Scsi_Host *shost);
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
+		ret = megasas_reset_fusion(scmd->device->host);
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
13:18:48.000000000 -0800
@@ -0,0 +1,2248 @@
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
+int megasas_reset_fusion(struct Scsi_Host *shost)
+{
+	int retval = SUCCESS, i, j, retry = 0;
+	struct megasas_instance *instance;
+	struct megasas_cmd_fusion *cmd_fusion;
+	struct fusion_context *fusion;
+	struct megasas_cmd *cmd_mfi;
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	u32 host_diag, abs_state;
+
+	instance = (struct megasas_instance *)shost->hostdata;
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
+	megasas_reset_fusion(instance->host);
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
13:18:51.000000000 -0800
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

@@ -1336,9 +1346,15 @@
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
 };

 enum {
@@ -1397,7 +1413,13 @@
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

--0016363b8520f20a800497f26660
Content-Type: application/octet-stream; name="megaraid_sas.patch6thru10"
Content-Disposition: attachment; filename="megaraid_sas.patch6thru10"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_ghzb5ndf0

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
cy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19iYXNlLmMJMjAxMC0xMi0yMSAxMzoxODo0NC4w
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
TkZPICpsYkluZm8pOworaW50IG1lZ2FzYXNfcmVzZXRfZnVzaW9uKHN0cnVjdCBTY3NpX0hvc3Qg
KnNob3N0KTsKK3ZvaWQgbWVnYXNhc19mdXNpb25fb2NyX3dxKHN0cnVjdCB3b3JrX3N0cnVjdCAq
d29yayk7CiAKIHZvaWQKIG1lZ2FzYXNfaXNzdWVfZGNtZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5j
ZSAqaW5zdGFuY2UsIHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kKQpAQCAtMTUyLDcgKzE3Myw3IEBA
CiAgKgogICogUmV0dXJucyBhIGZyZWUgY29tbWFuZCBmcm9tIHRoZSBwb29sCiAgKi8KLXN0YXRp
YyBzdHJ1Y3QgbWVnYXNhc19jbWQgKm1lZ2FzYXNfZ2V0X2NtZChzdHJ1Y3QgbWVnYXNhc19pbnN0
YW5jZQorc3RydWN0IG1lZ2FzYXNfY21kICptZWdhc2FzX2dldF9jbWQoc3RydWN0IG1lZ2FzYXNf
aW5zdGFuY2UKIAkJCQkJCSAgKmluc3RhbmNlKQogewogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CkBA
IC0xNzcsNyArMTk4LDcgQEAKICAqIEBpbnN0YW5jZToJCUFkYXB0ZXIgc29mdCBzdGF0ZQogICog
QGNtZDoJCUNvbW1hbmQgcGFja2V0IHRvIGJlIHJldHVybmVkIHRvIGZyZWUgY29tbWFuZCBwb29s
CiAgKi8KLXN0YXRpYyBpbmxpbmUgdm9pZAoraW5saW5lIHZvaWQKIG1lZ2FzYXNfcmV0dXJuX2Nt
ZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIHN0cnVjdCBtZWdhc2FzX2NtZCAq
Y21kKQogewogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CkBAIC0xODUsNiArMjA2LDcgQEAKIAlzcGlu
X2xvY2tfaXJxc2F2ZSgmaW5zdGFuY2UtPmNtZF9wb29sX2xvY2ssIGZsYWdzKTsKIAogCWNtZC0+
c2NtZCA9IE5VTEw7CisJY21kLT5mcmFtZV9jb3VudCA9IDA7CiAJbGlzdF9hZGRfdGFpbCgmY21k
LT5saXN0LCAmaW5zdGFuY2UtPmNtZF9wb29sKTsKIAogCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUo
Jmluc3RhbmNlLT5jbWRfcG9vbF9sb2NrLCBmbGFncyk7CkBAIC03OTYsNiArODE4LDExIEBACiAq
ICAgICAgIHNwZWNpZmljIHRvIGdlbjIgKGRldmljZWlkIDogMHg3OCwgMHg3OSkgY29udHJvbGxl
cnMKICovCiAKKy8qCisgKiBUZW1wbGF0ZSBhZGRlZCBmb3IgVEIgKEZ1c2lvbikKKyAqLworZXh0
ZXJuIHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlX3RlbXBsYXRlIG1lZ2FzYXNfaW5zdGFuY2VfdGVt
cGxhdGVfZnVzaW9uOworCiAvKioKICAqIG1lZ2FzYXNfaXNzdWVfcG9sbGVkIC0JSXNzdWVzIGEg
cG9sbGluZyBjb21tYW5kCiAgKiBAaW5zdGFuY2U6CQkJQWRhcHRlciBzb2Z0IHN0YXRlCkBAIC04
MDMsMTEgKzgzMCw5IEBACiAgKgogICogRm9yIHBvbGxpbmcsIE1GSSByZXF1aXJlcyB0aGUgY21k
X3N0YXR1cyB0byBiZSBzZXQgdG8gMHhGRiBiZWZvcmUgcG9zdGluZy4KICAqLwotc3RhdGljIGlu
dAoraW50CiBtZWdhc2FzX2lzc3VlX3BvbGxlZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5z
dGFuY2UsIHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kKQogewotCWludCBpOwotCXUzMiBtc2VjcyA9
IE1GSV9QT0xMX1RJTUVPVVRfU0VDUyAqIDEwMDA7CiAKIAlzdHJ1Y3QgbWVnYXNhc19oZWFkZXIg
KmZyYW1lX2hkciA9ICZjbWQtPmZyYW1lLT5oZHI7CiAKQEAgLTgxNywyMSArODQyLDEyIEBACiAJ
LyoKIAkgKiBJc3N1ZSB0aGUgZnJhbWUgdXNpbmcgaW5ib3VuZCBxdWV1ZSBwb3J0CiAJICovCi0J
aW5zdGFuY2UtPmluc3RhbmNldC0+ZmlyZV9jbWQoaW5zdGFuY2UsCi0JCQljbWQtPmZyYW1lX3Bo
eXNfYWRkciwgMCwgaW5zdGFuY2UtPnJlZ19zZXQpOworCWluc3RhbmNlLT5pbnN0YW5jZXQtPmlz
c3VlX2RjbWQoaW5zdGFuY2UsIGNtZCk7CiAKIAkvKgogCSAqIFdhaXQgZm9yIGNtZF9zdGF0dXMg
dG8gY2hhbmdlCiAJICovCi0JZm9yIChpID0gMDsgKGkgPCBtc2VjcykgJiYgKGZyYW1lX2hkci0+
Y21kX3N0YXR1cyA9PSAweGZmKTsgaSsrKSB7Ci0JCXJtYigpOwotCQltc2xlZXAoMSk7Ci0JfQot
Ci0JaWYgKGZyYW1lX2hkci0+Y21kX3N0YXR1cyA9PSAweGZmKQotCQlyZXR1cm4gLUVUSU1FOwot
Ci0JcmV0dXJuIDA7CisJcmV0dXJuIHdhaXRfYW5kX3BvbGwoaW5zdGFuY2UsIGNtZCk7CiB9CiAK
IC8qKgpAQCAtODQ5LDggKzg2NSw3IEBACiB7CiAJY21kLT5jbWRfc3RhdHVzID0gRU5PREFUQTsK
IAotCWluc3RhbmNlLT5pbnN0YW5jZXQtPmZpcmVfY21kKGluc3RhbmNlLAotCQkJY21kLT5mcmFt
ZV9waHlzX2FkZHIsIDAsIGluc3RhbmNlLT5yZWdfc2V0KTsKKwlpbnN0YW5jZS0+aW5zdGFuY2V0
LT5pc3N1ZV9kY21kKGluc3RhbmNlLCBjbWQpOwogCiAJd2FpdF9ldmVudChpbnN0YW5jZS0+aW50
X2NtZF93YWl0X3EsIGNtZC0+Y21kX3N0YXR1cyAhPSBFTk9EQVRBKTsKIApAQCAtODk0LDggKzkw
OSw3IEBACiAJY21kLT5zeW5jX2NtZCA9IDE7CiAJY21kLT5jbWRfc3RhdHVzID0gMHhGRjsKIAot
CWluc3RhbmNlLT5pbnN0YW5jZXQtPmZpcmVfY21kKGluc3RhbmNlLAotCQkJY21kLT5mcmFtZV9w
aHlzX2FkZHIsIDAsIGluc3RhbmNlLT5yZWdfc2V0KTsKKwlpbnN0YW5jZS0+aW5zdGFuY2V0LT5p
c3N1ZV9kY21kKGluc3RhbmNlLCBjbWQpOwogCiAJLyoKIAkgKiBXYWl0IGZvciB0aGlzIGNtZCB0
byBjb21wbGV0ZQpAQCAtMTI5MSw3ICsxMzA1LDcgQEAKICAqIENhbGxlZCBieSBtZWdhc2FzX3F1
ZXVlX2NvbW1hbmQgdG8gZmluZCBvdXQgaWYgdGhlIGNvbW1hbmQgdG8gYmUgcXVldWVkCiAgKiBp
cyBhIGxvZ2ljYWwgZHJpdmUgY29tbWFuZAkKICAqLwotc3RhdGljIGlubGluZSBpbnQgbWVnYXNh
c19pc19sZGlvKHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkKK2lubGluZSBpbnQgbWVnYXNhc19pc19s
ZGlvKHN0cnVjdCBzY3NpX2NtbmQgKmNtZCkKIHsKIAlpZiAoIU1FR0FTQVNfSVNfTE9HSUNBTChj
bWQpKQogCQlyZXR1cm4gMDsKQEAgLTE1NTEsMTUgKzE1NjUsNDQgQEAKIAlyZXR1cm4gMDsKIH0K
IAotc3RhdGljIHZvaWQgbWVnYXJhaWRfc2FzX2tpbGxfaGJhKHN0cnVjdCBtZWdhc2FzX2luc3Rh
bmNlICppbnN0YW5jZSkKK3ZvaWQgbWVnYXJhaWRfc2FzX2tpbGxfaGJhKHN0cnVjdCBtZWdhc2Fz
X2luc3RhbmNlICppbnN0YW5jZSkKIHsKIAlpZiAoKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0g
UENJX0RFVklDRV9JRF9MU0lfU0FTMDA3M1NLSU5OWSkgfHwKLQkJKGluc3RhbmNlLT5wZGV2LT5k
ZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lfU0FTMDA3MVNLSU5OWSkpIHsKLQkJd3JpdGVsKE1G
SV9TVE9QX0FEUCwKLQkJCSZpbnN0YW5jZS0+cmVnX3NldC0+cmVzZXJ2ZWRfMFswXSk7CisJICAg
IChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfTFNJX1NBUzAwNzFTS0lO
TlkpIHx8CisJICAgIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfTFNJ
X0ZVU0lPTikpIHsKKwkJd3JpdGVsKE1GSV9TVE9QX0FEUCwgJmluc3RhbmNlLT5yZWdfc2V0LT5k
b29yYmVsbCk7CiAJfSBlbHNlIHsKLQkJd3JpdGVsKE1GSV9TVE9QX0FEUCwKLQkJCSZpbnN0YW5j
ZS0+cmVnX3NldC0+aW5ib3VuZF9kb29yYmVsbCk7CisJCXdyaXRlbChNRklfU1RPUF9BRFAsICZp
bnN0YW5jZS0+cmVnX3NldC0+aW5ib3VuZF9kb29yYmVsbCk7CisJfQorfQorCisgLyoqCisgICog
bWVnYXNhc19jaGVja19hbmRfcmVzdG9yZV9xdWV1ZV9kZXB0aCAtIENoZWNrIGlmIHF1ZXVlIGRl
cHRoIG5lZWRzIHRvIGJlCisgICoJCQkJCXJlc3RvcmVkIHRvIG1heCB2YWx1ZQorICAqIEBpbnN0
YW5jZToJCQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAgKgorICAqLwordm9pZAorbWVnYXNhc19jaGVj
a19hbmRfcmVzdG9yZV9xdWV1ZV9kZXB0aChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFu
Y2UpCit7CisJdW5zaWduZWQgbG9uZyBmbGFnczsKKwlpZiAoaW5zdGFuY2UtPmZsYWcgJiBNRUdB
U0FTX0ZXX0JVU1kKKwkJJiYgdGltZV9hZnRlcihqaWZmaWVzLCBpbnN0YW5jZS0+bGFzdF90aW1l
ICsgNSAqIEhaKQorCQkmJiBhdG9taWNfcmVhZCgmaW5zdGFuY2UtPmZ3X291dHN0YW5kaW5nKSA8
IDE3KSB7CisKKwkJc3Bpbl9sb2NrX2lycXNhdmUoaW5zdGFuY2UtPmhvc3QtPmhvc3RfbG9jaywg
ZmxhZ3MpOworCQlpbnN0YW5jZS0+ZmxhZyAmPSB+TUVHQVNBU19GV19CVVNZOworCQlpZiAoKGlu
c3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0KKwkJCVBDSV9ERVZJQ0VfSURfTFNJX1NBUzAwNzNTS0lO
TlkpIHx8CisJCQkoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PQorCQkJUENJX0RFVklDRV9JRF9M
U0lfU0FTMDA3MVNLSU5OWSkpIHsKKwkJCWluc3RhbmNlLT5ob3N0LT5jYW5fcXVldWUgPQorCQkJ
CWluc3RhbmNlLT5tYXhfZndfY21kcyAtIE1FR0FTQVNfU0tJTk5ZX0lOVF9DTURTOworCQl9IGVs
c2UKKwkJCWluc3RhbmNlLT5ob3N0LT5jYW5fcXVldWUgPQorCQkJCWluc3RhbmNlLT5tYXhfZndf
Y21kcyAtIE1FR0FTQVNfSU5UX0NNRFM7CisKKwkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShpbnN0
YW5jZS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7CiAJfQogfQogCkBAIC0xNjEzLDI0ICsxNjU2
LDcgQEAKIAkvKgogCSAqIENoZWNrIGlmIHdlIGNhbiByZXN0b3JlIGNhbl9xdWV1ZQogCSAqLwot
CWlmIChpbnN0YW5jZS0+ZmxhZyAmIE1FR0FTQVNfRldfQlVTWQotCQkmJiB0aW1lX2FmdGVyKGpp
ZmZpZXMsIGluc3RhbmNlLT5sYXN0X3RpbWUgKyA1ICogSFopCi0JCSYmIGF0b21pY19yZWFkKCZp
bnN0YW5jZS0+Zndfb3V0c3RhbmRpbmcpIDwgMTcpIHsKLQotCQlzcGluX2xvY2tfaXJxc2F2ZShp
bnN0YW5jZS0+aG9zdC0+aG9zdF9sb2NrLCBmbGFncyk7Ci0JCWluc3RhbmNlLT5mbGFnICY9IH5N
RUdBU0FTX0ZXX0JVU1k7Ci0JCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PQotCQkJUENJ
X0RFVklDRV9JRF9MU0lfU0FTMDA3M1NLSU5OWSkgfHwKLQkJCShpbnN0YW5jZS0+cGRldi0+ZGV2
aWNlID09Ci0JCQlQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDcxU0tJTk5ZKSkgewotCQkJaW5zdGFu
Y2UtPmhvc3QtPmNhbl9xdWV1ZSA9Ci0JCQkJaW5zdGFuY2UtPm1heF9md19jbWRzIC0gTUVHQVNB
U19TS0lOTllfSU5UX0NNRFM7Ci0JCX0gZWxzZQotCQkJaW5zdGFuY2UtPmhvc3QtPmNhbl9xdWV1
ZSA9Ci0JCQkJaW5zdGFuY2UtPm1heF9md19jbWRzIC0gTUVHQVNBU19JTlRfQ01EUzsKLQotCQlz
cGluX3VubG9ja19pcnFyZXN0b3JlKGluc3RhbmNlLT5ob3N0LT5ob3N0X2xvY2ssIGZsYWdzKTsK
LQl9CisJbWVnYXNhc19jaGVja19hbmRfcmVzdG9yZV9xdWV1ZV9kZXB0aChpbnN0YW5jZSk7CiB9
CiAKIHN0YXRpYyB2b2lkCkBAIC0xODA4LDcgKzE4MzQsNyBAQAogCQkJKGluc3RhbmNlLT5wZGV2
LT5kZXZpY2UgPT0KIAkJCVBDSV9ERVZJQ0VfSURfTFNJX1NBUzAwNzFTS0lOTlkpKSB7CiAJCQl3
cml0ZWwoTUZJX1NUT1BfQURQLAotCQkJCSZpbnN0YW5jZS0+cmVnX3NldC0+cmVzZXJ2ZWRfMFsw
XSk7CisJCQkJJmluc3RhbmNlLT5yZWdfc2V0LT5kb29yYmVsbCk7CiAJCX0gZWxzZSB7CiAJCQl3
cml0ZWwoTUZJX1NUT1BfQURQLAogCQkJCSZpbnN0YW5jZS0+cmVnX3NldC0+aW5ib3VuZF9kb29y
YmVsbCk7CkBAIC0xOTEyLDExICsxOTM4LDE2IEBACiBzdGF0aWMgaW50IG1lZ2FzYXNfcmVzZXRf
YnVzX2hvc3Qoc3RydWN0IHNjc2lfY21uZCAqc2NtZCkKIHsKIAlpbnQgcmV0OworCXN0cnVjdCBt
ZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZTsKKwlpbnN0YW5jZSA9IChzdHJ1Y3QgbWVnYXNhc19p
bnN0YW5jZSAqKXNjbWQtPmRldmljZS0+aG9zdC0+aG9zdGRhdGE7CiAKIAkvKgogCSAqIEZpcnN0
IHdhaXQgZm9yIGFsbCBjb21tYW5kcyB0byBjb21wbGV0ZQogCSAqLwotCXJldCA9IG1lZ2FzYXNf
Z2VuZXJpY19yZXNldChzY21kKTsKKwlpZiAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lf
REVWSUNFX0lEX0xTSV9GVVNJT04pCisJCXJldCA9IG1lZ2FzYXNfcmVzZXRfZnVzaW9uKHNjbWQt
PmRldmljZS0+aG9zdCk7CisJZWxzZQorCQlyZXQgPSBtZWdhc2FzX2dlbmVyaWNfcmVzZXQoc2Nt
ZCk7CiAKIAlyZXR1cm4gcmV0OwogfQpAQCAtMjA4NiwxMyArMjExNywxNCBAQAogICogCQkJCWFu
IGFsdGVybmF0ZSBzdGF0dXMgKGFzIGluIHRoZSBjYXNlIG9mIGFib3J0ZWQKICAqIAkJCQljb21t
YW5kcykKICAqLwotc3RhdGljIHZvaWQKK3ZvaWQKIG1lZ2FzYXNfY29tcGxldGVfY21kKHN0cnVj
dCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwgc3RydWN0IG1lZ2FzYXNfY21kICpjbWQsCiAJ
CSAgICAgdTggYWx0X3N0YXR1cykKIHsKIAlpbnQgZXhjZXB0aW9uID0gMDsKIAlzdHJ1Y3QgbWVn
YXNhc19oZWFkZXIgKmhkciA9ICZjbWQtPmZyYW1lLT5oZHI7CiAJdW5zaWduZWQgbG9uZyBmbGFn
czsKKwlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lvbiA9IGluc3RhbmNlLT5jdHJsX2NvbnRl
eHQ7CiAKIAkvKiBmbGFnIGZvciB0aGUgcmV0cnkgcmVzZXQgKi8KIAljbWQtPnJldHJ5X2Zvcl9m
d19yZXNldCA9IDA7CkBAIC0yMTg1LDYgKzIyMTcsMzcgQEAKIAljYXNlIE1GSV9DTURfU01QOgog
CWNhc2UgTUZJX0NNRF9TVFA6CiAJY2FzZSBNRklfQ01EX0RDTUQ6CisJCS8qIENoZWNrIGZvciBM
RCBtYXAgdXBkYXRlICovCisJCWlmICgoY21kLT5mcmFtZS0+ZGNtZC5vcGNvZGUgPT0gTVJfRENN
RF9MRF9NQVBfR0VUX0lORk8pICYmCisJCSAgICAoY21kLT5mcmFtZS0+ZGNtZC5tYm94LmJbMV0g
PT0gMSkpIHsKKwkJCXNwaW5fbG9ja19pcnFzYXZlKGluc3RhbmNlLT5ob3N0LT5ob3N0X2xvY2ss
IGZsYWdzKTsKKwkJCWlmIChjbWQtPmZyYW1lLT5oZHIuY21kX3N0YXR1cyAhPSAwKSB7CisJCQkJ
aWYgKGNtZC0+ZnJhbWUtPmhkci5jbWRfc3RhdHVzICE9CisJCQkJICAgIE1GSV9TVEFUX05PVF9G
T1VORCkKKwkJCQkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXNhczogbWFwIHN5bmMiCisJCQkJ
CSAgICAgICAiZmFpbGVkLCBzdGF0dXMgPSAweCV4LlxuIiwKKwkJCQkJICAgICAgIGNtZC0+ZnJh
bWUtPmhkci5jbWRfc3RhdHVzKTsKKwkJCQllbHNlIHsKKwkJCQkJbWVnYXNhc19yZXR1cm5fY21k
KGluc3RhbmNlLCBjbWQpOworCQkJCQlzcGluX3VubG9ja19pcnFyZXN0b3JlKAorCQkJCQkJaW5z
dGFuY2UtPmhvc3QtPmhvc3RfbG9jaywKKwkJCQkJCWZsYWdzKTsKKwkJCQkJYnJlYWs7CisJCQkJ
fQorCQkJfSBlbHNlCisJCQkJaW5zdGFuY2UtPm1hcF9pZCsrOworCQkJbWVnYXNhc19yZXR1cm5f
Y21kKGluc3RhbmNlLCBjbWQpOworCQkJaWYgKE1SX1ZhbGlkYXRlTWFwSW5mbygKKwkJCQkgICAg
ZnVzaW9uLT5sZF9tYXBbKGluc3RhbmNlLT5tYXBfaWQgJiAxKV0sCisJCQkJICAgIGZ1c2lvbi0+
bG9hZF9iYWxhbmNlX2luZm8pKQorCQkJCWZ1c2lvbi0+ZmFzdF9wYXRoX2lvID0gMTsKKwkJCWVs
c2UKKwkJCQlmdXNpb24tPmZhc3RfcGF0aF9pbyA9IDA7CisJCQltZWdhc2FzX3N5bmNfbWFwX2lu
Zm8oaW5zdGFuY2UpOworCQkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZShpbnN0YW5jZS0+aG9zdC0+
aG9zdF9sb2NrLAorCQkJCQkgICAgICAgZmxhZ3MpOworCQkJYnJlYWs7CisJCX0KIAkJaWYgKGNt
ZC0+ZnJhbWUtPmRjbWQub3Bjb2RlID09IE1SX0RDTURfQ1RSTF9FVkVOVF9HRVRfSU5GTyB8fAog
CQkJY21kLT5mcmFtZS0+ZGNtZC5vcGNvZGUgPT0gTVJfRENNRF9DVFJMX0VWRU5UX0dFVCkgewog
CQkJc3Bpbl9sb2NrX2lycXNhdmUoJnBvbGxfYWVuX2xvY2ssIGZsYWdzKTsKQEAgLTI1MjMsNyAr
MjU4Niw3IEBACiAgKiBzdGF0ZXMsIGRyaXZlciBtdXN0IHRha2Ugc3RlcHMgdG8gYnJpbmcgaXQg
dG8gcmVhZHkgc3RhdGUuIE90aGVyd2lzZSwgaXQKICAqIGhhcyB0byB3YWl0IGZvciB0aGUgcmVh
ZHkgc3RhdGUuCiAgKi8KLXN0YXRpYyBpbnQKK2ludAogbWVnYXNhc190cmFuc2l0aW9uX3RvX3Jl
YWR5KHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlKiBpbnN0YW5jZSkKIHsKIAlpbnQgaTsKQEAgLTI1
NTcsMTEgKzI2MjAsMTIgQEAKIAkJCWlmICgoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PQogCQkJ
CVBDSV9ERVZJQ0VfSURfTFNJX1NBUzAwNzNTS0lOTlkpIHx8CiAJCQkJKGluc3RhbmNlLT5wZGV2
LT5kZXZpY2UgPT0KLQkJCQlQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDcxU0tJTk5ZKSkgewotCisJ
CQkJIFBDSV9ERVZJQ0VfSURfTFNJX1NBUzAwNzFTS0lOTlkpIHx8CisJCQkJKGluc3RhbmNlLT5w
ZGV2LT5kZXZpY2UgPT0KKwkJCQkgUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OKSkgewogCQkJCXdy
aXRlbCgKIAkJCQkgIE1GSV9JTklUX0NMRUFSX0hBTkRTSEFLRXxNRklfSU5JVF9IT1RQTFVHLAot
CQkJCSAgJmluc3RhbmNlLT5yZWdfc2V0LT5yZXNlcnZlZF8wWzBdKTsKKwkJCQkgICZpbnN0YW5j
ZS0+cmVnX3NldC0+ZG9vcmJlbGwpOwogCQkJfSBlbHNlIHsKIAkJCQl3cml0ZWwoCiAJCQkJICAg
IE1GSV9JTklUX0NMRUFSX0hBTkRTSEFLRXxNRklfSU5JVF9IT1RQTFVHLApAQCAtMjU3NCwxMSAr
MjYzOCwxMyBAQAogCiAJCWNhc2UgTUZJX1NUQVRFX0JPT1RfTUVTU0FHRV9QRU5ESU5HOgogCQkJ
aWYgKChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09Ci0JCQkJUENJX0RFVklDRV9JRF9MU0lfU0FT
MDA3M1NLSU5OWSkgfHwKLQkJCShpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09Ci0JCQkJUENJX0RF
VklDRV9JRF9MU0lfU0FTMDA3MVNLSU5OWSkpIHsKKwkJCSAgICAgUENJX0RFVklDRV9JRF9MU0lf
U0FTMDA3M1NLSU5OWSkgfHwKKwkJCQkoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PQorCQkJCSBQ
Q0lfREVWSUNFX0lEX0xTSV9TQVMwMDcxU0tJTk5ZKSB8fAorCQkJICAgIChpbnN0YW5jZS0+cGRl
di0+ZGV2aWNlID09CisJCQkgICAgIFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTikpIHsKIAkJCQl3
cml0ZWwoTUZJX0lOSVRfSE9UUExVRywKLQkJCQkmaW5zdGFuY2UtPnJlZ19zZXQtPnJlc2VydmVk
XzBbMF0pOworCQkJCSAgICAgICAmaW5zdGFuY2UtPnJlZ19zZXQtPmRvb3JiZWxsKTsKIAkJCX0g
ZWxzZQogCQkJCXdyaXRlbChNRklfSU5JVF9IT1RQTFVHLAogCQkJCQkmaW5zdGFuY2UtPnJlZ19z
ZXQtPmluYm91bmRfZG9vcmJlbGwpOwpAQCAtMjU5NSw5ICsyNjYxLDIzIEBACiAJCQlpZiAoKGlu
c3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0KIAkJCQlQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDczU0tJ
Tk5ZKSB8fAogCQkJCShpbnN0YW5jZS0+cGRldi0+ZGV2aWNlID09Ci0JCQkJUENJX0RFVklDRV9J
RF9MU0lfU0FTMDA3MVNLSU5OWSkpIHsKKwkJCQlQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDcxU0tJ
Tk5ZKSAgfHwKKwkJCQkoaW5zdGFuY2UtPnBkZXYtPmRldmljZQorCQkJCQk9PSBQQ0lfREVWSUNF
X0lEX0xTSV9GVVNJT04pKSB7CiAJCQkJd3JpdGVsKE1GSV9SRVNFVF9GTEFHUywKLQkJCQkJJmlu
c3RhbmNlLT5yZWdfc2V0LT5yZXNlcnZlZF8wWzBdKTsKKwkJCQkJJmluc3RhbmNlLT5yZWdfc2V0
LT5kb29yYmVsbCk7CisJCQkJaWYgKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UgPT0KKwkJCQkgICAg
UENJX0RFVklDRV9JRF9MU0lfRlVTSU9OKSB7CisJCQkJCWZvciAoaSA9IDA7IGkgPCAoMTAgKiAx
MDAwKTsgaSArPSAyMCkgeworCQkJCQkJaWYgKHJlYWRsKAorCQkJCQkJCSAgICAmaW5zdGFuY2Ut
PgorCQkJCQkJCSAgICByZWdfc2V0LT4KKwkJCQkJCQkgICAgZG9vcmJlbGwpICYgMSkKKwkJCQkJ
CQltc2xlZXAoMjApOworCQkJCQkJZWxzZQorCQkJCQkJCWJyZWFrOworCQkJCQl9CisJCQkJfQog
CQkJfSBlbHNlCiAJCQkJd3JpdGVsKE1GSV9SRVNFVF9GTEFHUywKIAkJCQkJJmluc3RhbmNlLT5y
ZWdfc2V0LT5pbmJvdW5kX2Rvb3JiZWxsKTsKQEAgLTI2ODEsNyArMjc2MSw3IEBACiBzdGF0aWMg
dm9pZCBtZWdhc2FzX3RlYXJkb3duX2ZyYW1lX3Bvb2woc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2Ug
Kmluc3RhbmNlKQogewogCWludCBpOwotCXUzMiBtYXhfY21kID0gaW5zdGFuY2UtPm1heF9md19j
bWRzOworCXUzMiBtYXhfY21kID0gaW5zdGFuY2UtPm1heF9tZmlfY21kczsKIAlzdHJ1Y3QgbWVn
YXNhc19jbWQgKmNtZDsKIAogCWlmICghaW5zdGFuY2UtPmZyYW1lX2RtYV9wb29sKQpAQCAtMjcz
Miw3ICsyODEyLDcgQEAKIAl1MzIgZnJhbWVfY291bnQ7CiAJc3RydWN0IG1lZ2FzYXNfY21kICpj
bWQ7CiAKLQltYXhfY21kID0gaW5zdGFuY2UtPm1heF9md19jbWRzOworCW1heF9jbWQgPSBpbnN0
YW5jZS0+bWF4X21maV9jbWRzOwogCiAJLyoKIAkgKiBTaXplIG9mIG91ciBmcmFtZSBpcyA2NCBi
eXRlcyBmb3IgTUZJIGZyYW1lLCBmb2xsb3dlZCBieSBtYXggU0cKQEAgLTI4MTksMTQgKzI4OTks
MTUgQEAKICAqIG1lZ2FzYXNfZnJlZV9jbWRzIC0JRnJlZSBhbGwgdGhlIGNtZHMgaW4gdGhlIGZy
ZWUgY21kIHBvb2wKICAqIEBpbnN0YW5jZToJCUFkYXB0ZXIgc29mdCBzdGF0ZQogICovCi1zdGF0
aWMgdm9pZCBtZWdhc2FzX2ZyZWVfY21kcyhzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFu
Y2UpCit2b2lkIG1lZ2FzYXNfZnJlZV9jbWRzKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0
YW5jZSkKIHsKIAlpbnQgaTsKIAkvKiBGaXJzdCBmcmVlIHRoZSBNRkkgZnJhbWUgcG9vbCAqLwog
CW1lZ2FzYXNfdGVhcmRvd25fZnJhbWVfcG9vbChpbnN0YW5jZSk7CiAKIAkvKiBGcmVlIGFsbCB0
aGUgY29tbWFuZHMgaW4gdGhlIGNtZF9saXN0ICovCi0JZm9yIChpID0gMDsgaSA8IGluc3RhbmNl
LT5tYXhfZndfY21kczsgaSsrKQorCWZvciAoaSA9IDA7IGkgPCBpbnN0YW5jZS0+bWF4X21maV9j
bWRzOyBpKyspCisKIAkJa2ZyZWUoaW5zdGFuY2UtPmNtZF9saXN0W2ldKTsKIAogCS8qIEZyZWUg
dGhlIGNtZF9saXN0IGJ1ZmZlciBpdHNlbGYgKi8KQEAgLTI4NTQsMTQgKzI5MzUsMTQgQEAKICAq
IFRoaXMgYXJyYXkgaXMgdXNlZCBvbmx5IHRvIGxvb2sgdXAgdGhlIG1lZ2FzYXNfY21kIGdpdmVu
IHRoZSBjb250ZXh0LiBUaGUKICAqIGZyZWUgY29tbWFuZHMgdGhlbXNlbHZlcyBhcmUgbWFpbnRh
aW5lZCBpbiBhIGxpbmtlZCBsaXN0IGNhbGxlZCBjbWRfcG9vbC4KICAqLwotc3RhdGljIGludCBt
ZWdhc2FzX2FsbG9jX2NtZHMoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKQoraW50
IG1lZ2FzYXNfYWxsb2NfY21kcyhzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCiB7
CiAJaW50IGk7CiAJaW50IGo7CiAJdTMyIG1heF9jbWQ7CiAJc3RydWN0IG1lZ2FzYXNfY21kICpj
bWQ7CiAKLQltYXhfY21kID0gaW5zdGFuY2UtPm1heF9md19jbWRzOworCW1heF9jbWQgPSBpbnN0
YW5jZS0+bWF4X21maV9jbWRzOwogCiAJLyoKIAkgKiBpbnN0YW5jZS0+Y21kX2xpc3QgaXMgYW4g
YXJyYXkgb2Ygc3RydWN0IG1lZ2FzYXNfY21kIHBvaW50ZXJzLgpAQCAtMjg3NSw2ICsyOTU2LDcg
QEAKIAkJcmV0dXJuIC1FTk9NRU07CiAJfQogCisJbWVtc2V0KGluc3RhbmNlLT5jbWRfbGlzdCwg
MCwgc2l6ZW9mKHN0cnVjdCBtZWdhc2FzX2NtZCAqKSAqbWF4X2NtZCk7CiAKIAlmb3IgKGkgPSAw
OyBpIDwgbWF4X2NtZDsgaSsrKSB7CiAJCWluc3RhbmNlLT5jbWRfbGlzdFtpXSA9IGttYWxsb2Mo
c2l6ZW9mKHN0cnVjdCBtZWdhc2FzX2NtZCksCkBAIC0zMjg4LDYgKzMzNzAsNyBAQAogCSAqIGRv
ZXMgbm90IGV4Y2VlZCBtYXggY21kcyB0aGF0IHRoZSBGVyBjYW4gc3VwcG9ydAogCSAqLwogCWlu
c3RhbmNlLT5tYXhfZndfY21kcyA9IGluc3RhbmNlLT5tYXhfZndfY21kcy0xOworCWluc3RhbmNl
LT5tYXhfbWZpX2NtZHMgPSBpbnN0YW5jZS0+bWF4X2Z3X2NtZHM7CiAJaW5zdGFuY2UtPm1heF9u
dW1fc2dlID0gKGluc3RhbmNlLT5pbnN0YW5jZXQtPnJlYWRfZndfc3RhdHVzX3JlZyhyZWdfc2V0
KSAmIDB4RkYwMDAwKSA+PiAKIAkJCQkJMHgxMDsKIAkvKgpAQCAtMzM4MSw2ICszNDY0LDkgQEAK
IAlyZWdfc2V0ID0gaW5zdGFuY2UtPnJlZ19zZXQ7CiAKIAlzd2l0Y2ggKGluc3RhbmNlLT5wZGV2
LT5kZXZpY2UpIHsKKwljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTjoKKwkJaW5zdGFuY2Ut
Pmluc3RhbmNldCA9ICZtZWdhc2FzX2luc3RhbmNlX3RlbXBsYXRlX2Z1c2lvbjsKKwkJYnJlYWs7
CiAJY2FzZSBQQ0lfREVWSUNFX0lEX0xTSV9TQVMxMDc4UjoKIAljYXNlIFBDSV9ERVZJQ0VfSURf
TFNJX1NBUzEwNzhERToKIAkJaW5zdGFuY2UtPmluc3RhbmNldCA9ICZtZWdhc2FzX2luc3RhbmNl
X3RlbXBsYXRlX3BwYzsKQEAgLTM0ODIsOSArMzU2OCwxMCBAQAogICovCiBzdGF0aWMgdm9pZCBt
ZWdhc2FzX3JlbGVhc2VfbWZpKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKIHsK
LQl1MzIgcmVwbHlfcV9zeiA9IHNpemVvZih1MzIpICogKGluc3RhbmNlLT5tYXhfZndfY21kcyAr
IDEpOworCXUzMiByZXBseV9xX3N6ID0gc2l6ZW9mKHUzMikgKihpbnN0YW5jZS0+bWF4X21maV9j
bWRzICsgMSk7CiAKLQlwY2lfZnJlZV9jb25zaXN0ZW50KGluc3RhbmNlLT5wZGV2LCByZXBseV9x
X3N6LAorCWlmIChpbnN0YW5jZS0+cmVwbHlfcXVldWUpCisJCXBjaV9mcmVlX2NvbnNpc3RlbnQo
aW5zdGFuY2UtPnBkZXYsIHJlcGx5X3Ffc3osCiAJCQkgICAgaW5zdGFuY2UtPnJlcGx5X3F1ZXVl
LCBpbnN0YW5jZS0+cmVwbHlfcXVldWVfaCk7CiAKIAltZWdhc2FzX2ZyZWVfY21kcyhpbnN0YW5j
ZSk7CkBAIC0zNjc4LDggKzM3NjUsNyBAQAogCS8qCiAJICogSXNzdWUgdGhlIGFlbiByZWdpc3Ry
YXRpb24gZnJhbWUKIAkgKi8KLQlpbnN0YW5jZS0+aW5zdGFuY2V0LT5maXJlX2NtZChpbnN0YW5j
ZSwKLQkJCWNtZC0+ZnJhbWVfcGh5c19hZGRyLCAwLCBpbnN0YW5jZS0+cmVnX3NldCk7CisJaW5z
dGFuY2UtPmluc3RhbmNldC0+aXNzdWVfZGNtZChpbnN0YW5jZSwgY21kKTsKIAogCXJldHVybiAw
OwogfQpAQCAtMzc1NiwxMiArMzg0MiwxOCBAQAogCX0KIAogCWhvc3QtPm1heF9zZWN0b3JzID0g
aW5zdGFuY2UtPm1heF9zZWN0b3JzX3Blcl9yZXE7Ci0JaG9zdC0+Y21kX3Blcl9sdW4gPSAxMjg7
CisJaG9zdC0+Y21kX3Blcl9sdW4gPSBNRUdBU0FTX0RFRkFVTFRfQ01EX1BFUl9MVU47CiAJaG9z
dC0+bWF4X2NoYW5uZWwgPSBNRUdBU0FTX01BWF9DSEFOTkVMUyAtIDE7CiAJaG9zdC0+bWF4X2lk
ID0gTUVHQVNBU19NQVhfREVWX1BFUl9DSEFOTkVMOwogCWhvc3QtPm1heF9sdW4gPSBNRUdBU0FT
X01BWF9MVU47CiAJaG9zdC0+bWF4X2NtZF9sZW4gPSAxNjsKIAorCS8qIEZ1c2lvbiBvbmx5IHN1
cHBvcnRzIGhvc3QgcmVzZXQgKi8KKwlpZiAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lf
REVWSUNFX0lEX0xTSV9GVVNJT04pIHsKKwkJaG9zdC0+aG9zdHQtPmVoX2RldmljZV9yZXNldF9o
YW5kbGVyID0gTlVMTDsKKwkJaG9zdC0+aG9zdHQtPmVoX2J1c19yZXNldF9oYW5kbGVyID0gTlVM
TDsKKwl9CisKIAkvKgogCSAqIE5vdGlmeSB0aGUgbWlkLWxheWVyIGFib3V0IHRoZSBuZXcgY29u
dHJvbGxlcgogCSAqLwpAQCAtMzg0NiwyMCArMzkzOCw0NSBAQAogCWluc3RhbmNlID0gKHN0cnVj
dCBtZWdhc2FzX2luc3RhbmNlICopaG9zdC0+aG9zdGRhdGE7CiAJbWVtc2V0KGluc3RhbmNlLCAw
LCBzaXplb2YoKmluc3RhbmNlKSk7CiAJYXRvbWljX3NldCggJmluc3RhbmNlLT5md19yZXNldF9u
b19wY2lfYWNjZXNzLCAwICk7CisJaW5zdGFuY2UtPnBkZXYgPSBwZGV2OwogCi0JaW5zdGFuY2Ut
PnByb2R1Y2VyID0gcGNpX2FsbG9jX2NvbnNpc3RlbnQocGRldiwgc2l6ZW9mKHUzMiksCi0JCQkJ
CQkgICZpbnN0YW5jZS0+cHJvZHVjZXJfaCk7Ci0JaW5zdGFuY2UtPmNvbnN1bWVyID0gcGNpX2Fs
bG9jX2NvbnNpc3RlbnQocGRldiwgc2l6ZW9mKHUzMiksCi0JCQkJCQkgICZpbnN0YW5jZS0+Y29u
c3VtZXJfaCk7CisJc3dpdGNoIChpbnN0YW5jZS0+cGRldi0+ZGV2aWNlKSB7CisJY2FzZSBQQ0lf
REVWSUNFX0lEX0xTSV9GVVNJT046CisJeworCQlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lv
bjsKKworCQlpbnN0YW5jZS0+Y3RybF9jb250ZXh0ID0KKwkJCWt6YWxsb2Moc2l6ZW9mKHN0cnVj
dCBmdXNpb25fY29udGV4dCksIEdGUF9LRVJORUwpOworCQlpZiAoIWluc3RhbmNlLT5jdHJsX2Nv
bnRleHQpIHsKKwkJCXByaW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBGYWlsZWQgdG8gYWxsb2Nh
dGUgIgorCQkJICAgICAgICJtZW1vcnkgZm9yIEZ1c2lvbiBjb250ZXh0IGluZm9cbiIpOworCQkJ
Z290byBmYWlsX2FsbG9jX2RtYV9idWY7CisJCX0KKwkJZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxf
Y29udGV4dDsKKwkJSU5JVF9MSVNUX0hFQUQoJmZ1c2lvbi0+Y21kX3Bvb2wpOworCQlzcGluX2xv
Y2tfaW5pdCgmZnVzaW9uLT5jbWRfcG9vbF9sb2NrKTsKKwl9CisJYnJlYWs7CisJZGVmYXVsdDog
LyogRm9yIGFsbCBvdGhlciBzdXBwb3J0ZWQgY29udHJvbGxlcnMgKi8KKworCQlpbnN0YW5jZS0+
cHJvZHVjZXIgPQorCQkJcGNpX2FsbG9jX2NvbnNpc3RlbnQocGRldiwgc2l6ZW9mKHUzMiksCisJ
CQkJCSAgICAgJmluc3RhbmNlLT5wcm9kdWNlcl9oKTsKKwkJaW5zdGFuY2UtPmNvbnN1bWVyID0K
KwkJCXBjaV9hbGxvY19jb25zaXN0ZW50KHBkZXYsIHNpemVvZih1MzIpLAorCQkJCQkgICAgICZp
bnN0YW5jZS0+Y29uc3VtZXJfaCk7CisKKwkJaWYgKCFpbnN0YW5jZS0+cHJvZHVjZXIgfHwgIWlu
c3RhbmNlLT5jb25zdW1lcikgeworCQkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IEZhaWxl
ZCB0byBhbGxvY2F0ZSIKKwkJCSAgICAgICAibWVtb3J5IGZvciBwcm9kdWNlciwgY29uc3VtZXJc
biIpOworCQkJZ290byBmYWlsX2FsbG9jX2RtYV9idWY7CisJCX0KIAotCWlmICghaW5zdGFuY2Ut
PnByb2R1Y2VyIHx8ICFpbnN0YW5jZS0+Y29uc3VtZXIpIHsKLQkJcHJpbnRrKEtFUk5fREVCVUcg
Im1lZ2FzYXM6IEZhaWxlZCB0byBhbGxvY2F0ZSBtZW1vcnkgZm9yICIKLQkJICAgICAgICJwcm9k
dWNlciwgY29uc3VtZXJcbiIpOwotCQlnb3RvIGZhaWxfYWxsb2NfZG1hX2J1ZjsKKwkJKmluc3Rh
bmNlLT5wcm9kdWNlciA9IDA7CisJCSppbnN0YW5jZS0+Y29uc3VtZXIgPSAwOworCQlicmVhazsK
IAl9CiAKLQkqaW5zdGFuY2UtPnByb2R1Y2VyID0gMDsKLQkqaW5zdGFuY2UtPmNvbnN1bWVyID0g
MDsKIAltZWdhc2FzX3BvbGxfd2FpdF9hZW4gPSAwOwogCWluc3RhbmNlLT5mbGFnX2llZWUgPSAw
OwogCWluc3RhbmNlLT5ldiA9IE5VTEw7CkBAIC0zODk1LDExICs0MDEyLDExIEBACiAJc3Bpbl9s
b2NrX2luaXQoJnBvbGxfYWVuX2xvY2spOwogCiAJbXV0ZXhfaW5pdCgmaW5zdGFuY2UtPmFlbl9t
dXRleCk7CisJbXV0ZXhfaW5pdCgmaW5zdGFuY2UtPnJlc2V0X211dGV4KTsKIAogCS8qCiAJICog
SW5pdGlhbGl6ZSBQQ0kgcmVsYXRlZCBhbmQgbWlzYyBwYXJhbWV0ZXJzCiAJICovCi0JaW5zdGFu
Y2UtPnBkZXYgPSBwZGV2OwogCWluc3RhbmNlLT5ob3N0ID0gaG9zdDsKIAlpbnN0YW5jZS0+dW5p
cXVlX2lkID0gcGRldi0+YnVzLT5udW1iZXIgPDwgOCB8IHBkZXYtPmRldmZuOwogCWluc3RhbmNl
LT5pbml0X2lkID0gTUVHQVNBU19ERUZBVUxUX0lOSVRfSUQ7CkBAIC0zOTE3LDcgKzQwMzQsMTAg
QEAKIAlpbnN0YW5jZS0+bGFzdF90aW1lID0gMDsKIAlpbnN0YW5jZS0+ZGlzYWJsZU9ubGluZUN0
cmxSZXNldCA9IDE7CiAKLQlJTklUX1dPUksoJmluc3RhbmNlLT53b3JrX2luaXQsIHByb2Nlc3Nf
Zndfc3RhdGVfY2hhbmdlX3dxKTsKKwlpZiAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSA9PSBQQ0lf
REVWSUNFX0lEX0xTSV9GVVNJT04pCisJCUlOSVRfV09SSygmaW5zdGFuY2UtPndvcmtfaW5pdCwg
bWVnYXNhc19mdXNpb25fb2NyX3dxKTsKKwllbHNlCisJCUlOSVRfV09SSygmaW5zdGFuY2UtPndv
cmtfaW5pdCwgcHJvY2Vzc19md19zdGF0ZV9jaGFuZ2Vfd3EpOwogCiAJLyoKIAkgKiBJbml0aWFs
aXplIE1GSSBGaXJtd2FyZQpAQCAtNDAwMCw2ICs0MTIwLDggQEAKIAkJcGNpX2ZyZWVfY29uc2lz
dGVudChwZGV2LCBzaXplb2YodTMyKSwgaW5zdGFuY2UtPnByb2R1Y2VyLAogCQkJCSAgICBpbnN0
YW5jZS0+cHJvZHVjZXJfaCk7CiAJCW1lZ2FzYXNfcmVsZWFzZV9tZmkoaW5zdGFuY2UpOworCX0g
ZWxzZSB7CisJCW1lZ2FzYXNfcmVsZWFzZV9mdXNpb24oaW5zdGFuY2UpOwogCX0KIAlpZiAoaW5z
dGFuY2UtPmNvbnN1bWVyKQogCQlwY2lfZnJlZV9jb25zaXN0ZW50KHBkZXYsIHNpemVvZih1MzIp
LCBpbnN0YW5jZS0+Y29uc3VtZXIsCkBAIC00MDcyLDcgKzQxOTQsOSBAQAogCiAJaWYgKGluc3Rh
bmNlLT5hZW5fY21kKQogCQltZWdhc2FzX2lzc3VlX2Jsb2NrZWRfYWJvcnRfY21kKGluc3RhbmNl
LCBpbnN0YW5jZS0+YWVuX2NtZCk7Ci0KKwlpZiAoaW5zdGFuY2UtPm1hcF91cGRhdGVfY21kKQor
CQltZWdhc2FzX2lzc3VlX2Jsb2NrZWRfYWJvcnRfY21kKGluc3RhbmNlLAorCQkJCQkJaW5zdGFu
Y2UtPm1hcF91cGRhdGVfY21kKTsKIAlkY21kID0gJmNtZC0+ZnJhbWUtPmRjbWQ7CiAKIAltZW1z
ZXQoZGNtZC0+bWJveC5iLCAwLCBNRklfTUJPWF9TSVpFKTsKQEAgLTQxNzcsOSArNDMwMSw2IEBA
CiAJICogSW5pdGlhbGl6ZSBNRkkgRmlybXdhcmUKIAkgKi8KIAotCSppbnN0YW5jZS0+cHJvZHVj
ZXIgPSAwOwotCSppbnN0YW5jZS0+Y29uc3VtZXIgPSAwOwotCiAJYXRvbWljX3NldCgmaW5zdGFu
Y2UtPmZ3X291dHN0YW5kaW5nLCAwKTsKIAogCS8qCkBAIC00MTg4LDExICs0MzA5LDI5IEBACiAJ
aWYgKG1lZ2FzYXNfdHJhbnNpdGlvbl90b19yZWFkeShpbnN0YW5jZSkpCiAJCWdvdG8gZmFpbF9y
ZWFkeV9zdGF0ZTsKIAotCWlmIChtZWdhc2FzX2lzc3VlX2luaXRfbWZpKGluc3RhbmNlKSkKLQkJ
Z290byBmYWlsX2luaXRfbWZpOworCXN3aXRjaCAoaW5zdGFuY2UtPnBkZXYtPmRldmljZSkgewor
CWNhc2UgUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OOgorCXsKKwkJbWVnYXNhc19yZXNldF9yZXBs
eV9kZXNjKGluc3RhbmNlKTsKKwkJaWYgKG1lZ2FzYXNfaW9jX2luaXRfZnVzaW9uKGluc3RhbmNl
KSkgeworCQkJbWVnYXNhc19mcmVlX2NtZHMoaW5zdGFuY2UpOworCQkJbWVnYXNhc19mcmVlX2Nt
ZHNfZnVzaW9uKGluc3RhbmNlKTsKKwkJCWdvdG8gZmFpbF9pbml0X21maTsKKwkJfQorCQlpZiAo
IW1lZ2FzYXNfZ2V0X21hcF9pbmZvKGluc3RhbmNlKSkKKwkJCW1lZ2FzYXNfc3luY19tYXBfaW5m
byhpbnN0YW5jZSk7CisJfQorCWJyZWFrOworCWRlZmF1bHQ6CisJCSppbnN0YW5jZS0+cHJvZHVj
ZXIgPSAwOworCQkqaW5zdGFuY2UtPmNvbnN1bWVyID0gMDsKKwkJaWYgKG1lZ2FzYXNfaXNzdWVf
aW5pdF9tZmkoaW5zdGFuY2UpKQorCQkJZ290byBmYWlsX2luaXRfbWZpOworCQlicmVhazsKKwl9
CiAKLQl0YXNrbGV0X2luaXQoJmluc3RhbmNlLT5pc3JfdGFza2xldCwgbWVnYXNhc19jb21wbGV0
ZV9jbWRfZHBjLAotCQkJKHVuc2lnbmVkIGxvbmcpaW5zdGFuY2UpOworCXRhc2tsZXRfaW5pdCgm
aW5zdGFuY2UtPmlzcl90YXNrbGV0LCBpbnN0YW5jZS0+aW5zdGFuY2V0LT50YXNrbGV0LAorCQkg
ICAgICh1bnNpZ25lZCBsb25nKWluc3RhbmNlKTsKIAogCS8qIE5vdyByZS1lbmFibGUgTVNJLVgg
Ki8KIAlpZiAoaW5zdGFuY2UtPm1zaV9mbGFnKQpAQCAtNDI2MSwxMCArNDQwMCwxMiBAQAogCWlu
dCBpOwogCXN0cnVjdCBTY3NpX0hvc3QgKmhvc3Q7CiAJc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2Ug
Kmluc3RhbmNlOworCXN0cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uOwogCiAJaW5zdGFuY2Ug
PSBwY2lfZ2V0X2RydmRhdGEocGRldik7CiAJaW5zdGFuY2UtPnVubG9hZCA9IDE7CiAJaG9zdCA9
IGluc3RhbmNlLT5ob3N0OworCWZ1c2lvbiA9IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CiAKIAlp
ZiAocG9sbF9tb2RlX2lvKQogCQlkZWxfdGltZXJfc3luYygmaW5zdGFuY2UtPmlvX2NvbXBsZXRp
b25fdGltZXIpOwpAQCAtNDMwNiwxNiArNDQ0NywzMiBAQAogCWlmIChpbnN0YW5jZS0+bXNpX2Zs
YWcpCiAJCXBjaV9kaXNhYmxlX21zaXgoaW5zdGFuY2UtPnBkZXYpOwogCi0JbWVnYXNhc19yZWxl
YXNlX21maShpbnN0YW5jZSk7Ci0KLQlwY2lfZnJlZV9jb25zaXN0ZW50KHBkZXYsIHNpemVvZihz
dHJ1Y3QgbWVnYXNhc19ldnRfZGV0YWlsKSwKLQkJCSAgICBpbnN0YW5jZS0+ZXZ0X2RldGFpbCwg
aW5zdGFuY2UtPmV2dF9kZXRhaWxfaCk7Ci0KLQlwY2lfZnJlZV9jb25zaXN0ZW50KHBkZXYsIHNp
emVvZih1MzIpLCBpbnN0YW5jZS0+cHJvZHVjZXIsCi0JCQkgICAgaW5zdGFuY2UtPnByb2R1Y2Vy
X2gpOwotCi0JcGNpX2ZyZWVfY29uc2lzdGVudChwZGV2LCBzaXplb2YodTMyKSwgaW5zdGFuY2Ut
PmNvbnN1bWVyLAotCQkJICAgIGluc3RhbmNlLT5jb25zdW1lcl9oKTsKKwlzd2l0Y2ggKGluc3Rh
bmNlLT5wZGV2LT5kZXZpY2UpIHsKKwljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTjoKKwkJ
bWVnYXNhc19yZWxlYXNlX2Z1c2lvbihpbnN0YW5jZSk7CisJCWZvciAoaSA9IDA7IGkgPCAyIDsg
aSsrKQorCQkJaWYgKGZ1c2lvbi0+bGRfbWFwW2ldKQorCQkJCWRtYV9mcmVlX2NvaGVyZW50KCZp
bnN0YW5jZS0+cGRldi0+ZGV2LAorCQkJCQkJICBmdXNpb24tPm1hcF9zeiwKKwkJCQkJCSAgZnVz
aW9uLT5sZF9tYXBbaV0sCisJCQkJCQkgIGZ1c2lvbi0+CisJCQkJCQkgIGxkX21hcF9waHlzW2ld
KTsKKwkJa2ZyZWUoaW5zdGFuY2UtPmN0cmxfY29udGV4dCk7CisJCWJyZWFrOworCWRlZmF1bHQ6
CisJCW1lZ2FzYXNfcmVsZWFzZV9tZmkoaW5zdGFuY2UpOworCQlwY2lfZnJlZV9jb25zaXN0ZW50
KHBkZXYsCisJCQkJICAgIHNpemVvZihzdHJ1Y3QgbWVnYXNhc19ldnRfZGV0YWlsKSwKKwkJCQkg
ICAgaW5zdGFuY2UtPmV2dF9kZXRhaWwsCisJCQkJICAgIGluc3RhbmNlLT5ldnRfZGV0YWlsX2gp
OworCQlwY2lfZnJlZV9jb25zaXN0ZW50KHBkZXYsIHNpemVvZih1MzIpLAorCQkJCSAgICBpbnN0
YW5jZS0+cHJvZHVjZXIsCisJCQkJICAgIGluc3RhbmNlLT5wcm9kdWNlcl9oKTsKKwkJcGNpX2Zy
ZWVfY29uc2lzdGVudChwZGV2LCBzaXplb2YodTMyKSwKKwkJCQkgICAgaW5zdGFuY2UtPmNvbnN1
bWVyLAorCQkJCSAgICBpbnN0YW5jZS0+Y29uc3VtZXJfaCk7CisJCWJyZWFrOworCX0KIAogCXNj
c2lfaG9zdF9wdXQoaG9zdCk7CiAKQEAgLTUwNzksNiArNTIzNiw3IEBACiAJCQlicmVhazsKIAkJ
Y2FzZSBNUl9FVlRfQ1RSTF9IT1NUX0JVU19TQ0FOX1JFUVVFU1RFRDoKIAkJY2FzZSBNUl9FVlRf
Rk9SRUlHTl9DRkdfSU1QT1JURUQ6CisJCWNhc2UgTVJfRVZUX0xEX1NUQVRFX0NIQU5HRToKIAkJ
CWRvc2NhbiA9IDE7CiAJCQlicmVhazsKIAkJZGVmYXVsdDoKZGlmZiAtTmF1ciBsaW51eC0yLjYu
MzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2ZwLmMgbGludXgt
Mi42LjM3LXJjNS5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mcC5jCi0t
LSBsaW51eC0yLjYuMzctcmM1Lm9sZC9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2Fz
X2ZwLmMJMTk2OS0xMi0zMSAxNjowMDowMC4wMDAwMDAwMDAgLTA4MDAKKysrIGxpbnV4LTIuNi4z
Ny1yYzUubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnAuYwkyMDEwLTEy
LTIxIDExOjA0OjA4LjAwMDAwMDAwMCAtMDgwMApAQCAtMCwwICsxLDUxNiBAQAorLyoKKyAqICBM
aW51eCBNZWdhUkFJRCBkcml2ZXIgZm9yIFNBUyBiYXNlZCBSQUlEIGNvbnRyb2xsZXJzCisgKgor
ICogIENvcHlyaWdodCAoYykgMjAwOS0yMDExICBMU0kgQ29ycG9yYXRpb24uCisgKgorICogIFRo
aXMgcHJvZ3JhbSBpcyBmcmVlIHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQv
b3IKKyAqICBtb2RpZnkgaXQgdW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJs
aWMgTGljZW5zZQorICogIGFzIHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0
aW9uOyBlaXRoZXIgdmVyc2lvbiAyCisgKiAgb2YgdGhlIExpY2Vuc2UsIG9yIChhdCB5b3VyIG9w
dGlvbikgYW55IGxhdGVyIHZlcnNpb24uCisgKgorICogIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmli
dXRlZCBpbiB0aGUgaG9wZSB0aGF0IGl0IHdpbGwgYmUgdXNlZnVsLAorICogIGJ1dCBXSVRIT1VU
IEFOWSBXQVJSQU5UWTsgd2l0aG91dCBldmVuIHRoZSBpbXBsaWVkIHdhcnJhbnR5IG9mCisgKiAg
TUVSQ0hBTlRBQklMSVRZIG9yIEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2Vl
IHRoZQorICogIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlIGZvciBtb3JlIGRldGFpbHMuCisg
KgorICogIFlvdSBzaG91bGQgaGF2ZSByZWNlaXZlZCBhIGNvcHkgb2YgdGhlIEdOVSBHZW5lcmFs
IFB1YmxpYyBMaWNlbnNlCisgKiAgYWxvbmcgd2l0aCB0aGlzIHByb2dyYW07IGlmIG5vdCwgd3Jp
dGUgdG8gdGhlIEZyZWUgU29mdHdhcmUKKyAqICBGb3VuZGF0aW9uLCBJbmMuLCA1OSBUZW1wbGUg
UGxhY2UsIFN1aXRlIDMzMCwgQm9zdG9uLCBNQSAwMjExMS0xMzA3IFVTQQorICoKKyAqICBGSUxF
OiBtZWdhcmFpZF9zYXNfZnAuYworICoKKyAqICBBdXRob3JzOiBMU0kgQ29ycG9yYXRpb24KKyAq
ICAgICAgICAgICBTdW1hbnQgUGF0cm8KKyAqICAgICAgICAgICBWYXJhZCBUYWxhbWFja2kKKyAq
ICAgICAgICAgICBNYW5vaiBKb3NlCisgKgorICogIFNlbmQgZmVlZGJhY2sgdG86IDxtZWdhcmFp
ZGxpbnV4QGxzaS5jb20+CisgKgorICogIE1haWwgdG86IExTSSBDb3Jwb3JhdGlvbiwgMTYyMSBC
YXJiZXIgTGFuZSwgTWlscGl0YXMsIENBIDk1MDM1CisgKiAgICAgQVRUTjogTGludXhyYWlkCisg
Ki8KKworI2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgorI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+
CisjaW5jbHVkZSA8bGludXgvcGNpLmg+CisjaW5jbHVkZSA8bGludXgvbGlzdC5oPgorI2luY2x1
ZGUgPGxpbnV4L21vZHVsZXBhcmFtLmg+CisjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+CisjaW5j
bHVkZSA8bGludXgvc3BpbmxvY2suaD4KKyNpbmNsdWRlIDxsaW51eC9pbnRlcnJ1cHQuaD4KKyNp
bmNsdWRlIDxsaW51eC9kZWxheS5oPgorI2luY2x1ZGUgPGxpbnV4L3NtcF9sb2NrLmg+CisjaW5j
bHVkZSA8bGludXgvdWlvLmg+CisjaW5jbHVkZSA8bGludXgvdWFjY2Vzcy5oPgorI2luY2x1ZGUg
PGxpbnV4L2ZzLmg+CisjaW5jbHVkZSA8bGludXgvY29tcGF0Lmg+CisjaW5jbHVkZSA8bGludXgv
YmxrZGV2Lmg+CisjaW5jbHVkZSA8bGludXgvcG9sbC5oPgorCisjaW5jbHVkZSA8c2NzaS9zY3Np
Lmg+CisjaW5jbHVkZSA8c2NzaS9zY3NpX2NtbmQuaD4KKyNpbmNsdWRlIDxzY3NpL3Njc2lfZGV2
aWNlLmg+CisjaW5jbHVkZSA8c2NzaS9zY3NpX2hvc3QuaD4KKworI2luY2x1ZGUgIm1lZ2FyYWlk
X3Nhc19mdXNpb24uaCIKKyNpbmNsdWRlIDxhc20vZGl2NjQuaD4KKworI2RlZmluZSBBQlNfRElG
RihhLCBiKSAgICgoKGEpID4gKGIpKSA/ICgoYSkgLSAoYikpIDogKChiKSAtIChhKSkpCisjZGVm
aW5lIE1SX0xEX1NUQVRFX09QVElNQUwgMworI2RlZmluZSBGQUxTRSAwCisjZGVmaW5lIFRSVUUg
MQorCisvKiBQcm90b3R5cGVzICovCit2b2lkCittcl91cGRhdGVfbG9hZF9iYWxhbmNlX3BhcmFt
cyhzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXAsCisJCQkgICAgICBzdHJ1Y3QgTERfTE9B
RF9CQUxBTkNFX0lORk8gKmxiSW5mbyk7CisKK3UzMiBtZWdhX21vZDY0KHU2NCBkaXZpZGVuZCwg
dTMyIGRpdmlzb3IpCit7CisJdTY0IGQ7CisJdTMyIHJlbWFpbmRlcjsKKworCWlmICghZGl2aXNv
cikKKwkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzIDogRElWSVNPUiBpcyB6ZXJvLCBpbiBkaXYg
Zm5cbiIpOworCWQgPSBkaXZpZGVuZDsKKwlyZW1haW5kZXIgPSBkb19kaXYoZCwgZGl2aXNvcik7
CisJcmV0dXJuIHJlbWFpbmRlcjsKK30KKworLyoqCisgKiBAcGFyYW0gZGl2aWRlbmQgICAgOiBE
aXZpZGVuZAorICogQHBhcmFtIGRpdmlzb3IgICAgOiBEaXZpc29yCisgKgorICogQHJldHVybiBx
dW90aWVudAorICoqLwordTY0IG1lZ2FfZGl2NjRfMzIodWludDY0X3QgZGl2aWRlbmQsIHVpbnQz
Ml90IGRpdmlzb3IpCit7CisJdTMyIHJlbWFpbmRlcjsKKwl1NjQgZDsKKworCWlmICghZGl2aXNv
cikKKwkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzIDogRElWSVNPUiBpcyB6ZXJvIGluIG1vZCBm
blxuIik7CisKKwlkID0gZGl2aWRlbmQ7CisJcmVtYWluZGVyID0gZG9fZGl2KGQsIGRpdmlzb3Ip
OworCisJcmV0dXJuIGQ7Cit9CisKK3N0cnVjdCBNUl9MRF9SQUlEICpNUl9MZFJhaWRHZXQodTMy
IGxkLCBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApCit7CisJcmV0dXJuICZtYXAtPnJh
aWRNYXAubGRTcGFuTWFwW2xkXS5sZFJhaWQ7Cit9CisKK3N0YXRpYyBzdHJ1Y3QgTVJfU1BBTl9C
TE9DS19JTkZPICpNUl9MZFNwYW5JbmZvR2V0KHUzMiBsZCwKKwkJCQkJCSAgIHN0cnVjdCBNUl9G
V19SQUlEX01BUF9BTEwKKwkJCQkJCSAgICptYXApCit7CisJcmV0dXJuICZtYXAtPnJhaWRNYXAu
bGRTcGFuTWFwW2xkXS5zcGFuQmxvY2tbMF07Cit9CisKK3N0YXRpYyB1OCBNUl9MZERhdGFBcm1H
ZXQodTMyIGxkLCB1MzIgYXJtSWR4LCBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApCit7
CisJcmV0dXJuIG1hcC0+cmFpZE1hcC5sZFNwYW5NYXBbbGRdLmRhdGFBcm1NYXBbYXJtSWR4XTsK
K30KKworc3RhdGljIHUxNiBNUl9BclBkR2V0KHUzMiBhciwgdTMyIGFybSwgc3RydWN0IE1SX0ZX
X1JBSURfTUFQX0FMTCAqbWFwKQoreworCXJldHVybiBtYXAtPnJhaWRNYXAuYXJNYXBJbmZvW2Fy
XS5wZFthcm1dOworfQorCitzdGF0aWMgdTE2IE1SX0xkU3BhbkFycmF5R2V0KHUzMiBsZCwgdTMy
IHNwYW4sIHN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKm1hcCkKK3sKKwlyZXR1cm4gbWFwLT5y
YWlkTWFwLmxkU3Bhbk1hcFtsZF0uc3BhbkJsb2NrW3NwYW5dLnNwYW4uYXJyYXlSZWY7Cit9CisK
K3N0YXRpYyB1MTYgTVJfUGREZXZIYW5kbGVHZXQodTMyIHBkLCBzdHJ1Y3QgTVJfRldfUkFJRF9N
QVBfQUxMICptYXApCit7CisJcmV0dXJuIG1hcC0+cmFpZE1hcC5kZXZIbmRsSW5mb1twZF0uY3Vy
RGV2SGRsOworfQorCit1MTYgTVJfR2V0TERUZ3RJZCh1MzIgbGQsIHN0cnVjdCBNUl9GV19SQUlE
X01BUF9BTEwgKm1hcCkKK3sKKwlyZXR1cm4gbWFwLT5yYWlkTWFwLmxkU3Bhbk1hcFtsZF0ubGRS
YWlkLnRhcmdldElkOworfQorCit1MTYgTVJfVGFyZ2V0SWRUb0xkR2V0KHUzMiBsZFRndElkLCBz
dHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApCit7CisJcmV0dXJuIG1hcC0+cmFpZE1hcC5s
ZFRndElkVG9MZFtsZFRndElkXTsKK30KKworc3RhdGljIHN0cnVjdCBNUl9MRF9TUEFOICpNUl9M
ZFNwYW5QdHJHZXQodTMyIGxkLCB1MzIgc3BhbiwKKwkJCQkJICBzdHJ1Y3QgTVJfRldfUkFJRF9N
QVBfQUxMICptYXApCit7CisJcmV0dXJuICZtYXAtPnJhaWRNYXAubGRTcGFuTWFwW2xkXS5zcGFu
QmxvY2tbc3Bhbl0uc3BhbjsKK30KKworLyoKKyAqIFRoaXMgZnVuY3Rpb24gd2lsbCB2YWxpZGF0
ZSBNYXAgaW5mbyBkYXRhIHByb3ZpZGVkIGJ5IEZXCisgKi8KK3U4IE1SX1ZhbGlkYXRlTWFwSW5m
byhzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXAsCisJCSAgICAgIHN0cnVjdCBMRF9MT0FE
X0JBTEFOQ0VfSU5GTyAqbGJJbmZvKQoreworCXN0cnVjdCBNUl9GV19SQUlEX01BUCAqcEZ3UmFp
ZE1hcCA9ICZtYXAtPnJhaWRNYXA7CisKKwlpZiAocEZ3UmFpZE1hcC0+dG90YWxTaXplICE9CisJ
ICAgIChzaXplb2Yoc3RydWN0IE1SX0ZXX1JBSURfTUFQKSAtc2l6ZW9mKHN0cnVjdCBNUl9MRF9T
UEFOX01BUCkgKworCSAgICAgKHNpemVvZihzdHJ1Y3QgTVJfTERfU1BBTl9NQVApICpwRndSYWlk
TWFwLT5sZENvdW50KSkpIHsKKwkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBtYXAgaW5mbyBz
dHJ1Y3R1cmUgc2l6ZSAweCV4IGlzIG5vdCBtYXRjaGluZyB3aXRoIGxkIGNvdW50XG4iLAorCQkg
ICAgICAgKHVuc2lnbmVkIGludCkoKHNpemVvZihzdHJ1Y3QgTVJfRldfUkFJRF9NQVApIC0KKwkJ
CQkgICAgICAgc2l6ZW9mKHN0cnVjdCBNUl9MRF9TUEFOX01BUCkpICsKKwkJCQkgICAgICAoc2l6
ZW9mKHN0cnVjdCBNUl9MRF9TUEFOX01BUCkgKgorCQkJCSAgICAgICBwRndSYWlkTWFwLT5sZENv
dW50KSkpOworCQlwcmludGsoS0VSTl9FUlIgIm1lZ2FzYXM6IHNwYW4gbWFwICV4LCBwRndSYWlk
TWFwLT50b3RhbFNpemUgIgorCQkgICAgICAgIjogJXhcbiIsICh1bnNpZ25lZCBpbnQpc2l6ZW9m
KHN0cnVjdCBNUl9MRF9TUEFOX01BUCksCisJCSAgICAgICBwRndSYWlkTWFwLT50b3RhbFNpemUp
OworCQlyZXR1cm4gMDsKKwl9CisKKwltcl91cGRhdGVfbG9hZF9iYWxhbmNlX3BhcmFtcyhtYXAs
IGxiSW5mbyk7CisKKwlyZXR1cm4gMTsKK30KKwordTMyIE1SX0dldFNwYW5CbG9jayh1MzIgbGQs
IHU2NCByb3csIHU2NCAqc3Bhbl9ibGssCisJCSAgICBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxM
ICptYXAsIGludCAqZGl2X2Vycm9yKQoreworCXN0cnVjdCBNUl9TUEFOX0JMT0NLX0lORk8gKnBT
cGFuQmxvY2sgPSBNUl9MZFNwYW5JbmZvR2V0KGxkLCBtYXApOworCXN0cnVjdCBNUl9RVUFEX0VM
RU1FTlQgICAgKnF1YWQ7CisJc3RydWN0IE1SX0xEX1JBSUQgICAgICAgICAqcmFpZCA9IE1SX0xk
UmFpZEdldChsZCwgbWFwKTsKKwl1MzIgICAgICAgICAgICAgICAgc3BhbiwgajsKKworCWZvciAo
c3BhbiA9IDA7IHNwYW4gPCByYWlkLT5zcGFuRGVwdGg7IHNwYW4rKywgcFNwYW5CbG9jaysrKSB7
CisKKwkJZm9yIChqID0gMDsgaiA8IHBTcGFuQmxvY2stPmJsb2NrX3NwYW5faW5mby5ub0VsZW1l
bnRzOyBqKyspIHsKKwkJCXF1YWQgPSAmcFNwYW5CbG9jay0+YmxvY2tfc3Bhbl9pbmZvLnF1YWRb
al07CisKKwkJCWlmIChxdWFkLT5kaWZmID09IDApIHsKKwkJCQkqZGl2X2Vycm9yID0gMTsKKwkJ
CQlyZXR1cm4gc3BhbjsKKwkJCX0KKwkJCWlmIChxdWFkLT5sb2dTdGFydCA8PSByb3cgICYmICBy
b3cgPD0gcXVhZC0+bG9nRW5kICAmJgorCQkJICAgIChtZWdhX21vZDY0KHJvdy1xdWFkLT5sb2dT
dGFydCwgcXVhZC0+ZGlmZikpID09IDApIHsKKwkJCQlpZiAoc3Bhbl9ibGsgIT0gTlVMTCkgewor
CQkJCQl1NjQgIGJsaywgZGVidWdCbGs7CisJCQkJCWJsayA9CisJCQkJCQltZWdhX2RpdjY0XzMy
KAorCQkJCQkJCShyb3ctcXVhZC0+bG9nU3RhcnQpLAorCQkJCQkJCXF1YWQtPmRpZmYpOworCQkJ
CQlkZWJ1Z0JsayA9IGJsazsKKworCQkJCQlibGsgPSAoYmxrICsgcXVhZC0+b2Zmc2V0SW5TcGFu
KSA8PAorCQkJCQkJcmFpZC0+c3RyaXBlU2hpZnQ7CisJCQkJCSpzcGFuX2JsayA9IGJsazsKKwkJ
CQl9CisJCQkJcmV0dXJuIHNwYW47CisJCQl9CisJCX0KKwl9CisJcmV0dXJuIHNwYW47Cit9CisK
Ky8qCisqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioKKyoKKyogVGhpcyByb3V0aW5lIGNhbGN1bGF0ZXMg
dGhlIGFybSwgc3BhbiBhbmQgYmxvY2sgZm9yIHRoZSBzcGVjaWZpZWQgc3RyaXBlIGFuZAorKiBy
ZWZlcmVuY2UgaW4gc3RyaXBlLgorKgorKiBJbnB1dHMgOgorKgorKiAgICBsZCAgIC0gTG9naWNh
bCBkcml2ZSBudW1iZXIKKyogICAgc3RyaXBSb3cgICAgICAgIC0gU3RyaXBlIG51bWJlcgorKiAg
ICBzdHJpcFJlZiAgICAtIFJlZmVyZW5jZSBpbiBzdHJpcGUKKyoKKyogT3V0cHV0cyA6CisqCisq
ICAgIHNwYW4gICAgICAgICAgLSBTcGFuIG51bWJlcgorKiAgICBibG9jayAgICAgICAgIC0gQWJz
b2x1dGUgQmxvY2sgbnVtYmVyIGluIHRoZSBwaHlzaWNhbCBkaXNrCisqLwordTggTVJfR2V0UGh5
UGFyYW1zKHUzMiBsZCwgdTY0IHN0cmlwUm93LCB1MTYgc3RyaXBSZWYsIHU2NCAqcGRCbG9jaywK
KwkJICAgdTE2ICpwRGV2SGFuZGxlLCBzdHJ1Y3QgUkFJRF9DT05URVhUICpwUkFJRF9Db250ZXh0
LAorCQkgICBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApCit7CisJc3RydWN0IE1SX0xE
X1JBSUQgICpyYWlkID0gTVJfTGRSYWlkR2V0KGxkLCBtYXApOworCXUzMiAgICAgICAgIHBkLCBh
clJlZjsKKwl1OCAgICAgICAgICBwaHlzQXJtLCBzcGFuOworCXU2NCAgICAgICAgIHJvdzsKKwl1
OAkgICAgcmV0dmFsID0gVFJVRTsKKwlpbnQJICAgIGVycm9yX2NvZGUgPSAwOworCisJcm93ID0g
IG1lZ2FfZGl2NjRfMzIoc3RyaXBSb3csIHJhaWQtPnJvd0RhdGFTaXplKTsKKworCWlmIChyYWlk
LT5sZXZlbCA9PSA2KSB7CisJCS8qIGxvZ2ljYWwgYXJtIHdpdGhpbiByb3cgKi8KKwkJdTMyIGxv
Z0FybSA9ICBtZWdhX21vZDY0KHN0cmlwUm93LCByYWlkLT5yb3dEYXRhU2l6ZSk7CisJCXUzMiBy
b3dNb2QsIGFybVEsIGFybTsKKworCQlpZiAocmFpZC0+cm93U2l6ZSA9PSAwKQorCQkJcmV0dXJu
IEZBTFNFOworCQkvKiBnZXQgbG9naWNhbCByb3cgbW9kICovCisJCXJvd01vZCA9IG1lZ2FfbW9k
NjQocm93LCByYWlkLT5yb3dTaXplKTsKKwkJYXJtUSA9IHJhaWQtPnJvd1NpemUtMS1yb3dNb2Q7
IC8qIGluZGV4IG9mIFEgZHJpdmUgKi8KKwkJYXJtID0gYXJtUSsxK2xvZ0FybTsgLyogZGF0YSBh
bHdheXMgbG9naWNhbGx5IGZvbGxvd3MgUSAqLworCQlpZiAoYXJtID49IHJhaWQtPnJvd1NpemUp
IC8qIGhhbmRsZSB3cmFwIGNvbmRpdGlvbiAqLworCQkJYXJtIC09IHJhaWQtPnJvd1NpemU7CisJ
CXBoeXNBcm0gPSAodTgpYXJtOworCX0gZWxzZSAgeworCQlpZiAocmFpZC0+bW9kRmFjdG9yID09
IDApCisJCQlyZXR1cm4gRkFMU0U7CisJCXBoeXNBcm0gPSBNUl9MZERhdGFBcm1HZXQobGQsICBt
ZWdhX21vZDY0KHN0cmlwUm93LAorCQkJCQkJCSAgcmFpZC0+bW9kRmFjdG9yKSwKKwkJCQkJICBt
YXApOworCX0KKworCWlmIChyYWlkLT5zcGFuRGVwdGggPT0gMSkgeworCQlzcGFuID0gMDsKKwkJ
KnBkQmxvY2sgPSByb3cgPDwgcmFpZC0+c3RyaXBlU2hpZnQ7CisJfSBlbHNlIHsKKwkJc3BhbiA9
ICh1OClNUl9HZXRTcGFuQmxvY2sobGQsIHJvdywgcGRCbG9jaywgbWFwLCAmZXJyb3JfY29kZSk7
CisJCWlmIChlcnJvcl9jb2RlID09IDEpCisJCQlyZXR1cm4gRkFMU0U7CisJfQorCisJLyogR2V0
IHRoZSBhcnJheSBvbiB3aGljaCB0aGlzIHNwYW4gaXMgcHJlc2VudCAqLworCWFyUmVmICAgICAg
ID0gTVJfTGRTcGFuQXJyYXlHZXQobGQsIHNwYW4sIG1hcCk7CisJcGQgICAgICAgICAgPSBNUl9B
clBkR2V0KGFyUmVmLCBwaHlzQXJtLCBtYXApOyAvKiBHZXQgdGhlIHBkICovCisKKwlpZiAocGQg
IT0gTVJfUERfSU5WQUxJRCkKKwkJLyogR2V0IGRldiBoYW5kbGUgZnJvbSBQZC4gKi8KKwkJKnBE
ZXZIYW5kbGUgPSBNUl9QZERldkhhbmRsZUdldChwZCwgbWFwKTsKKwllbHNlIHsKKwkJKnBEZXZI
YW5kbGUgPSBNUl9QRF9JTlZBTElEOyAvKiBzZXQgZGV2IGhhbmRsZSBhcyBpbnZhbGlkLiAqLwor
CQlpZiAocmFpZC0+bGV2ZWwgPj0gNSkKKwkJCXBSQUlEX0NvbnRleHQtPnJlZ0xvY2tGbGFncyA9
IFJFR0lPTl9UWVBFX0VYQ0xVU0lWRTsKKwkJZWxzZSBpZiAocmFpZC0+bGV2ZWwgPT0gMSkgewor
CQkJLyogR2V0IGFsdGVybmF0ZSBQZC4gKi8KKwkJCXBkID0gTVJfQXJQZEdldChhclJlZiwgcGh5
c0FybSArIDEsIG1hcCk7CisJCQlpZiAocGQgIT0gTVJfUERfSU5WQUxJRCkKKwkJCQkvKiBHZXQg
ZGV2IGhhbmRsZSBmcm9tIFBkICovCisJCQkJKnBEZXZIYW5kbGUgPSBNUl9QZERldkhhbmRsZUdl
dChwZCwgbWFwKTsKKwkJfQorCQlyZXR2YWwgPSBGQUxTRTsKKwl9CisKKwkqcGRCbG9jayArPSBz
dHJpcFJlZiArIE1SX0xkU3BhblB0ckdldChsZCwgc3BhbiwgbWFwKS0+c3RhcnRCbGs7CisJcFJB
SURfQ29udGV4dC0+c3BhbkFybSA9IChzcGFuIDw8IFJBSURfQ1RYX1NQQU5BUk1fU1BBTl9TSElG
VCkgfAorCQlwaHlzQXJtOworCXJldHVybiByZXR2YWw7Cit9CisKKy8qCisqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioKKyoKKyogTVJfQnVpbGRSYWlkQ29udGV4dCBmdW5jdGlvbgorKgorKiBUaGlzIGZ1
bmN0aW9uIHdpbGwgaW5pdGlhdGUgY29tbWFuZCBwcm9jZXNzaW5nLiAgVGhlIHN0YXJ0L2VuZCBy
b3cgYW5kIHN0cmlwCisqIGluZm9ybWF0aW9uIGlzIGNhbGN1bGF0ZWQgdGhlbiB0aGUgbG9jayBp
cyBhY3F1aXJlZC4KKyogVGhpcyBmdW5jdGlvbiB3aWxsIHJldHVybiAwIGlmIHJlZ2lvbiBsb2Nr
IHdhcyBhY3F1aXJlZCBPUiByZXR1cm4gbnVtIHN0cmlwcworKi8KK3U4CitNUl9CdWlsZFJhaWRD
b250ZXh0KHN0cnVjdCBJT19SRVFVRVNUX0lORk8gKmlvX2luZm8sCisJCSAgICBzdHJ1Y3QgUkFJ
RF9DT05URVhUICpwUkFJRF9Db250ZXh0LAorCQkgICAgc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FM
TCAqbWFwKQoreworCXN0cnVjdCBNUl9MRF9SQUlEICAqcmFpZDsKKwl1MzIgICAgICAgICBsZCwg
c3RyaXBTaXplLCBzdHJpcGVfbWFzazsKKwl1NjQgICAgICAgICBlbmRMYmEsIGVuZFN0cmlwLCBl
bmRSb3csIHN0YXJ0X3Jvdywgc3RhcnRfc3RyaXA7CisJdTY0ICAgICAgICAgcmVnU3RhcnQ7CisJ
dTMyICAgICAgICAgcmVnU2l6ZTsKKwl1OCAgICAgICAgICBudW1fc3RyaXBzLCBudW1Sb3dzOwor
CXUxNiAgICAgICAgIHJlZl9pbl9zdGFydF9zdHJpcGUsIHJlZl9pbl9lbmRfc3RyaXBlOworCXU2
NCAgICAgICAgIGxkU3RhcnRCbG9jazsKKwl1MzIgICAgICAgICBudW1CbG9ja3MsIGxkVGd0SWQ7
CisJdTggICAgICAgICAgaXNSZWFkOworCXU4CSAgICByZXR2YWwgPSAwOworCisJbGRTdGFydEJs
b2NrID0gaW9faW5mby0+bGRTdGFydEJsb2NrOworCW51bUJsb2NrcyA9IGlvX2luZm8tPm51bUJs
b2NrczsKKwlsZFRndElkID0gaW9faW5mby0+bGRUZ3RJZDsKKwlpc1JlYWQgPSBpb19pbmZvLT5p
c1JlYWQ7CisKKwlsZCA9IE1SX1RhcmdldElkVG9MZEdldChsZFRndElkLCBtYXApOworCXJhaWQg
PSBNUl9MZFJhaWRHZXQobGQsIG1hcCk7CisKKwlzdHJpcFNpemUgPSAxIDw8IHJhaWQtPnN0cmlw
ZVNoaWZ0OworCXN0cmlwZV9tYXNrID0gc3RyaXBTaXplLTE7CisJLyoKKwkgKiBjYWxjdWxhdGUg
c3RhcnRpbmcgcm93IGFuZCBzdHJpcGUsIGFuZCBudW1iZXIgb2Ygc3RyaXBzIGFuZCByb3dzCisJ
ICovCisJc3RhcnRfc3RyaXAgICAgICAgICA9IGxkU3RhcnRCbG9jayA+PiByYWlkLT5zdHJpcGVT
aGlmdDsKKwlyZWZfaW5fc3RhcnRfc3RyaXBlID0gKHUxNikobGRTdGFydEJsb2NrICYgc3RyaXBl
X21hc2spOworCWVuZExiYSAgICAgICAgICAgICAgPSBsZFN0YXJ0QmxvY2sgKyBudW1CbG9ja3Mg
LSAxOworCXJlZl9pbl9lbmRfc3RyaXBlICAgPSAodTE2KShlbmRMYmEgJiBzdHJpcGVfbWFzayk7
CisJZW5kU3RyaXAgICAgICAgICAgICA9IGVuZExiYSA+PiByYWlkLT5zdHJpcGVTaGlmdDsKKwlu
dW1fc3RyaXBzICAgICAgICAgID0gKHU4KShlbmRTdHJpcCAtIHN0YXJ0X3N0cmlwICsgMSk7IC8q
IEVuZCBzdHJpcCAqLworCWlmIChyYWlkLT5yb3dEYXRhU2l6ZSA9PSAwKQorCQlyZXR1cm4gRkFM
U0U7CisJc3RhcnRfcm93ICAgICAgICAgICA9ICBtZWdhX2RpdjY0XzMyKHN0YXJ0X3N0cmlwLCBy
YWlkLT5yb3dEYXRhU2l6ZSk7CisJZW5kUm93ICAgICAgICAgICAgICA9ICBtZWdhX2RpdjY0XzMy
KGVuZFN0cmlwLCByYWlkLT5yb3dEYXRhU2l6ZSk7CisJbnVtUm93cyAgICAgICAgICAgICA9ICh1
OCkoZW5kUm93IC0gc3RhcnRfcm93ICsgMSk7CisKKwkvKgorCSAqIGNhbGN1bGF0ZSByZWdpb24g
aW5mby4KKwkgKi8KKworCS8qIGFzc3VtZSByZWdpb24gaXMgYXQgdGhlIHN0YXJ0IG9mIHRoZSBm
aXJzdCByb3cgKi8KKwlyZWdTdGFydCAgICAgICAgICAgID0gc3RhcnRfcm93IDw8IHJhaWQtPnN0
cmlwZVNoaWZ0OworCS8qIGFzc3VtZSB0aGlzIElPIG5lZWRzIHRoZSBmdWxsIHJvdyAtIHdlJ2xs
IGFkanVzdCBpZiBub3QgdHJ1ZSAqLworCXJlZ1NpemUgICAgICAgICAgICAgPSBzdHJpcFNpemU7
CisKKwkvKiBJZiBJTyBzcGFucyBtb3JlIHRoYW4gMSBzdHJpcCwgZnAgaXMgbm90IHBvc3NpYmxl
CisJICAgRlAgaXMgbm90IHBvc3NpYmxlIGZvciB3cml0ZXMgb24gbm9uLTAgcmFpZCBsZXZlbHMK
KwkgICBGUCBpcyBub3QgcG9zc2libGUgaWYgTEQgaXMgbm90IGNhcGFibGUgKi8KKwlpZiAobnVt
X3N0cmlwcyA+IDEgfHwgKCFpc1JlYWQgJiYgcmFpZC0+bGV2ZWwgIT0gMCkgfHwKKwkgICAgIXJh
aWQtPmNhcGFiaWxpdHkuZnBDYXBhYmxlKSB7CisJCWlvX2luZm8tPmZwT2tGb3JJbyA9IEZBTFNF
OworCX0gZWxzZSB7CisJCWlvX2luZm8tPmZwT2tGb3JJbyA9IFRSVUU7CisJfQorCisJaWYgKG51
bVJvd3MgPT0gMSkgeworCQkvKiBzaW5nbGUtc3RyaXAgSU9zIGNhbiBhbHdheXMgbG9jayBvbmx5
IHRoZSBkYXRhIG5lZWRlZCAqLworCQlpZiAobnVtX3N0cmlwcyA9PSAxKSB7CisJCQlyZWdTdGFy
dCArPSByZWZfaW5fc3RhcnRfc3RyaXBlOworCQkJcmVnU2l6ZSA9IG51bUJsb2NrczsKKwkJfQor
CQkvKiBtdWx0aS1zdHJpcCBJT3MgYWx3YXlzIG5lZWQgdG8gZnVsbCBzdHJpcGUgbG9ja2VkICov
CisJfSBlbHNlIHsKKwkJaWYgKHN0YXJ0X3N0cmlwID09IChzdGFydF9yb3cgKyAxKSAqIHJhaWQt
PnJvd0RhdGFTaXplIC0gMSkgeworCQkJLyogSWYgdGhlIHN0YXJ0IHN0cmlwIGlzIHRoZSBsYXN0
IGluIHRoZSBzdGFydCByb3cgKi8KKwkJCXJlZ1N0YXJ0ICs9IHJlZl9pbl9zdGFydF9zdHJpcGU7
CisJCQlyZWdTaXplID0gc3RyaXBTaXplIC0gcmVmX2luX3N0YXJ0X3N0cmlwZTsKKwkJCS8qIGlu
aXRpYWxpemUgY291bnQgdG8gc2VjdG9ycyBmcm9tIHN0YXJ0cmVmIHRvIGVuZAorCQkJICAgb2Yg
c3RyaXAgKi8KKwkJfQorCisJCWlmIChudW1Sb3dzID4gMikKKwkJCS8qIEFkZCBjb21wbGV0ZSBy
b3dzIGluIHRoZSBtaWRkbGUgb2YgdGhlIHRyYW5zZmVyICovCisJCQlyZWdTaXplICs9IChudW1S
b3dzLTIpIDw8IHJhaWQtPnN0cmlwZVNoaWZ0OworCisJCS8qIGlmIElPIGVuZHMgd2l0aGluIGZp
cnN0IHN0cmlwIG9mIGxhc3Qgcm93ICovCisJCWlmIChlbmRTdHJpcCA9PSBlbmRSb3cqcmFpZC0+
cm93RGF0YVNpemUpCisJCQlyZWdTaXplICs9IHJlZl9pbl9lbmRfc3RyaXBlKzE7CisJCWVsc2UK
KwkJCXJlZ1NpemUgKz0gc3RyaXBTaXplOworCX0KKworCXBSQUlEX0NvbnRleHQtPnRpbWVvdXRW
YWx1ZSAgICAgPSBtYXAtPnJhaWRNYXAuZnBQZElvVGltZW91dFNlYzsKKwlwUkFJRF9Db250ZXh0
LT5yZWdMb2NrRmxhZ3MgICAgID0gKGlzUmVhZCkgPyBSRUdJT05fVFlQRV9TSEFSRURfUkVBRCA6
CisJCXJhaWQtPnJlZ1R5cGVSZXFPbldyaXRlOworCXBSQUlEX0NvbnRleHQtPlZpcnR1YWxEaXNr
VGd0SWQgPSByYWlkLT50YXJnZXRJZDsKKwlwUkFJRF9Db250ZXh0LT5yZWdMb2NrUm93TEJBICAg
ID0gcmVnU3RhcnQ7CisJcFJBSURfQ29udGV4dC0+cmVnTG9ja0xlbmd0aCAgICA9IHJlZ1NpemU7
CisJcFJBSURfQ29udGV4dC0+Y29uZmlnU2VxTnVtCT0gcmFpZC0+c2VxTnVtOworCisJLypHZXQg
UGh5IFBhcmFtcyBvbmx5IGlmIEZQIGNhcGFibGUsIG9yIGVsc2UgbGVhdmUgaXQgdG8gTVIgZmly
bXdhcmUKKwkgIHRvIGRvIHRoZSBjYWxjdWxhdGlvbi4qLworCWlmIChpb19pbmZvLT5mcE9rRm9y
SW8pIHsKKwkJcmV0dmFsID0gTVJfR2V0UGh5UGFyYW1zKGxkLCBzdGFydF9zdHJpcCwgcmVmX2lu
X3N0YXJ0X3N0cmlwZSwKKwkJCQkJICZpb19pbmZvLT5wZEJsb2NrLAorCQkJCQkgJmlvX2luZm8t
PmRldkhhbmRsZSwgcFJBSURfQ29udGV4dCwKKwkJCQkJIG1hcCk7CisJCS8qIElmIElPIG9uIGFu
IGludmFsaWQgUGQsIHRoZW4gRlAgaSBzbm90IHBvc3NpYmxlICovCisJCWlmIChpb19pbmZvLT5k
ZXZIYW5kbGUgPT0gTVJfUERfSU5WQUxJRCkKKwkJCWlvX2luZm8tPmZwT2tGb3JJbyA9IEZBTFNF
OworCQlyZXR1cm4gcmV0dmFsOworCX0gZWxzZSBpZiAoaXNSZWFkKSB7CisJCXVpbnQgc3RyaXBJ
ZHg7CisJCWZvciAoc3RyaXBJZHggPSAwOyBzdHJpcElkeCA8IG51bV9zdHJpcHM7IHN0cmlwSWR4
KyspIHsKKwkJCWlmICghTVJfR2V0UGh5UGFyYW1zKGxkLCBzdGFydF9zdHJpcCArIHN0cmlwSWR4
LAorCQkJCQkgICAgIHJlZl9pbl9zdGFydF9zdHJpcGUsCisJCQkJCSAgICAgJmlvX2luZm8tPnBk
QmxvY2ssCisJCQkJCSAgICAgJmlvX2luZm8tPmRldkhhbmRsZSwKKwkJCQkJICAgICBwUkFJRF9D
b250ZXh0LCBtYXApKQorCQkJCXJldHVybiBUUlVFOworCQl9CisJfQorCXJldHVybiBUUlVFOwor
fQorCit2b2lkCittcl91cGRhdGVfbG9hZF9iYWxhbmNlX3BhcmFtcyhzdHJ1Y3QgTVJfRldfUkFJ
RF9NQVBfQUxMICptYXAsCisJCQkgICAgICBzdHJ1Y3QgTERfTE9BRF9CQUxBTkNFX0lORk8gKmxi
SW5mbykKK3sKKwlpbnQgbGRDb3VudDsKKwl1MTYgbGQ7CisJc3RydWN0IE1SX0xEX1JBSUQgKnJh
aWQ7CisKKwlmb3IgKGxkQ291bnQgPSAwOyBsZENvdW50IDwgTUFYX0xPR0lDQUxfRFJJVkVTOyBs
ZENvdW50KyspIHsKKwkJbGQgPSBNUl9UYXJnZXRJZFRvTGRHZXQobGRDb3VudCwgbWFwKTsKKwkJ
aWYgKGxkID49IE1BWF9MT0dJQ0FMX0RSSVZFUykgeworCQkJbGJJbmZvW2xkQ291bnRdLmxvYWRC
YWxhbmNlRmxhZyA9IDA7CisJCQljb250aW51ZTsKKwkJfQorCisJCXJhaWQgPSBNUl9MZFJhaWRH
ZXQobGQsIG1hcCk7CisKKwkJLyogVHdvIGRyaXZlIE9wdGltYWwgUkFJRCAxICovCisJCWlmICgo
cmFpZC0+bGV2ZWwgPT0gMSkgICYmICAocmFpZC0+cm93U2l6ZSA9PSAyKSAmJgorCQkgICAgKHJh
aWQtPnNwYW5EZXB0aCA9PSAxKSAmJiByYWlkLT5sZFN0YXRlID09CisJCSAgICBNUl9MRF9TVEFU
RV9PUFRJTUFMKSB7CisJCQl1MzIgcGQsIGFyUmVmOworCisJCQlsYkluZm9bbGRDb3VudF0ubG9h
ZEJhbGFuY2VGbGFnID0gMTsKKworCQkJLyogR2V0IHRoZSBhcnJheSBvbiB3aGljaCB0aGlzIHNw
YW4gaXMgcHJlc2VudCAqLworCQkJYXJSZWYgPSBNUl9MZFNwYW5BcnJheUdldChsZCwgMCwgbWFw
KTsKKworCQkJLyogR2V0IHRoZSBQZCAqLworCQkJcGQgPSBNUl9BclBkR2V0KGFyUmVmLCAwLCBt
YXApOworCQkJLyogR2V0IGRldiBoYW5kbGUgZnJvbSBQZCAqLworCQkJbGJJbmZvW2xkQ291bnRd
LnJhaWQxRGV2SGFuZGxlWzBdID0KKwkJCQlNUl9QZERldkhhbmRsZUdldChwZCwgbWFwKTsKKwkJ
CS8qIEdldCB0aGUgUGQgKi8KKwkJCXBkID0gTVJfQXJQZEdldChhclJlZiwgMSwgbWFwKTsKKwor
CQkJLyogR2V0IHRoZSBkZXYgaGFuZGxlIGZyb20gUGQgKi8KKwkJCWxiSW5mb1tsZENvdW50XS5y
YWlkMURldkhhbmRsZVsxXSA9CisJCQkJTVJfUGREZXZIYW5kbGVHZXQocGQsIG1hcCk7CisJCX0g
ZWxzZQorCQkJbGJJbmZvW2xkQ291bnRdLmxvYWRCYWxhbmNlRmxhZyA9IDA7CisJfQorfQorCit1
OCBtZWdhc2FzX2dldF9iZXN0X2FybShzdHJ1Y3QgTERfTE9BRF9CQUxBTkNFX0lORk8gKmxiSW5m
bywgdTggYXJtLCB1NjQgYmxvY2ssCisJCQl1MzIgY291bnQpCit7CisJdTE2ICAgICBwZW5kMCwg
cGVuZDE7CisJdTY0ICAgICBkaWZmMCwgZGlmZjE7CisJdTggICAgICBiZXN0QXJtOworCisJLyog
Z2V0IHRoZSBwZW5kaW5nIGNtZHMgZm9yIHRoZSBkYXRhIGFuZCBtaXJyb3IgYXJtcyAqLworCXBl
bmQwID0gYXRvbWljX3JlYWQoJmxiSW5mby0+c2NzaV9wZW5kaW5nX2NtZHNbMF0pOworCXBlbmQx
ID0gYXRvbWljX3JlYWQoJmxiSW5mby0+c2NzaV9wZW5kaW5nX2NtZHNbMV0pOworCisJLyogRGV0
ZXJtaW5lIHRoZSBkaXNrIHdob3NlIGhlYWQgaXMgbmVhcmVyIHRvIHRoZSByZXEuIGJsb2NrICov
CisJZGlmZjAgPSBBQlNfRElGRihibG9jaywgbGJJbmZvLT5sYXN0X2FjY2Vzc2VkX2Jsb2NrWzBd
KTsKKwlkaWZmMSA9IEFCU19ESUZGKGJsb2NrLCBsYkluZm8tPmxhc3RfYWNjZXNzZWRfYmxvY2tb
MV0pOworCWJlc3RBcm0gPSAoZGlmZjAgPD0gZGlmZjEgPyAwIDogMSk7CisKKwlpZiAoKGJlc3RB
cm0gPT0gYXJtICYmIHBlbmQwID4gcGVuZDEgKyAxNikgIHx8CisJICAgIChiZXN0QXJtICE9IGFy
bSAmJiBwZW5kMSA+IHBlbmQwICsgMTYpKQorCQliZXN0QXJtIF49IDE7CisKKwkvKiBVcGRhdGUg
dGhlIGxhc3QgYWNjZXNzZWQgYmxvY2sgb24gdGhlIGNvcnJlY3QgcGQgKi8KKwlsYkluZm8tPmxh
c3RfYWNjZXNzZWRfYmxvY2tbYmVzdEFybV0gPSBibG9jayArIGNvdW50IC0gMTsKKworCXJldHVy
biBiZXN0QXJtOworfQorCit1MTYgZ2V0X3VwZGF0ZWRfZGV2X2hhbmRsZShzdHJ1Y3QgTERfTE9B
RF9CQUxBTkNFX0lORk8gKmxiSW5mbywKKwkJCSAgIHN0cnVjdCBJT19SRVFVRVNUX0lORk8gKmlv
X2luZm8pCit7CisJdTggYXJtLCBvbGRfYXJtOworCXUxNiBkZXZIYW5kbGU7CisKKwlvbGRfYXJt
ID0gbGJJbmZvLT5yYWlkMURldkhhbmRsZVswXSA9PSBpb19pbmZvLT5kZXZIYW5kbGUgPyAwIDog
MTsKKworCS8qIGdldCBiZXN0IG5ldyBhcm0gKi8KKwlhcm0gID0gbWVnYXNhc19nZXRfYmVzdF9h
cm0obGJJbmZvLCBvbGRfYXJtLCBpb19pbmZvLT5sZFN0YXJ0QmxvY2ssCisJCQkJICAgIGlvX2lu
Zm8tPm51bUJsb2Nrcyk7CisJZGV2SGFuZGxlID0gbGJJbmZvLT5yYWlkMURldkhhbmRsZVthcm1d
OworCWF0b21pY19pbmMoJmxiSW5mby0+c2NzaV9wZW5kaW5nX2NtZHNbYXJtXSk7CisKKwlyZXR1
cm4gZGV2SGFuZGxlOworfQpkaWZmIC1OYXVyIGxpbnV4LTIuNi4zNy1yYzUub2xkL2RyaXZlcnMv
c2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXNfZnVzaW9uLmMgbGludXgtMi42LjM3LXJjNS5uZXcv
ZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uYwotLS0gbGludXgtMi42
LjM3LXJjNS5vbGQvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uYwkx
OTY5LTEyLTMxIDE2OjAwOjAwLjAwMDAwMDAwMCAtMDgwMAorKysgbGludXgtMi42LjM3LXJjNS5u
ZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uYwkyMDEwLTEyLTIx
IDEzOjE4OjQ4LjAwMDAwMDAwMCAtMDgwMApAQCAtMCwwICsxLDIyNDggQEAKKy8qCisgKiAgTGlu
dXggTWVnYVJBSUQgZHJpdmVyIGZvciBTQVMgYmFzZWQgUkFJRCBjb250cm9sbGVycworICoKKyAq
ICBDb3B5cmlnaHQgKGMpIDIwMDktMjAxMSAgTFNJIENvcnBvcmF0aW9uLgorICoKKyAqICBUaGlz
IHByb2dyYW0gaXMgZnJlZSBzb2Z0d2FyZTsgeW91IGNhbiByZWRpc3RyaWJ1dGUgaXQgYW5kL29y
CisgKiAgbW9kaWZ5IGl0IHVuZGVyIHRoZSB0ZXJtcyBvZiB0aGUgR05VIEdlbmVyYWwgUHVibGlj
IExpY2Vuc2UKKyAqICBhcyBwdWJsaXNoZWQgYnkgdGhlIEZyZWUgU29mdHdhcmUgRm91bmRhdGlv
bjsgZWl0aGVyIHZlcnNpb24gMgorICogIG9mIHRoZSBMaWNlbnNlLCBvciAoYXQgeW91ciBvcHRp
b24pIGFueSBsYXRlciB2ZXJzaW9uLgorICoKKyAqICBUaGlzIHByb2dyYW0gaXMgZGlzdHJpYnV0
ZWQgaW4gdGhlIGhvcGUgdGhhdCBpdCB3aWxsIGJlIHVzZWZ1bCwKKyAqICBidXQgV0lUSE9VVCBB
TlkgV0FSUkFOVFk7IHdpdGhvdXQgZXZlbiB0aGUgaW1wbGllZCB3YXJyYW50eSBvZgorICogIE1F
UkNIQU5UQUJJTElUWSBvciBGSVRORVNTIEZPUiBBIFBBUlRJQ1VMQVIgUFVSUE9TRS4gIFNlZSB0
aGUKKyAqICBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZSBmb3IgbW9yZSBkZXRhaWxzLgorICoK
KyAqICBZb3Ugc2hvdWxkIGhhdmUgcmVjZWl2ZWQgYSBjb3B5IG9mIHRoZSBHTlUgR2VuZXJhbCBQ
dWJsaWMgTGljZW5zZQorICogIGFsb25nIHdpdGggdGhpcyBwcm9ncmFtOyBpZiBub3QsIHdyaXRl
IHRvIHRoZSBGcmVlIFNvZnR3YXJlCisgKiAgRm91bmRhdGlvbiwgSW5jLiwgNTkgVGVtcGxlIFBs
YWNlLCBTdWl0ZSAzMzAsIEJvc3RvbiwgTUEgMDIxMTEtMTMwNyBVU0EKKyAqCisgKiAgRklMRTog
bWVnYXJhaWRfc2FzX2Z1c2lvbi5jCisgKgorICogIEF1dGhvcnM6IExTSSBDb3Jwb3JhdGlvbgor
ICogICAgICAgICAgIFN1bWFudCBQYXRybworICogICAgICAgICAgIEFkYW0gUmFkZm9yZCA8bGlu
dXhyYWlkQGxzaS5jb20+CisgKgorICogIFNlbmQgZmVlZGJhY2sgdG86IDxtZWdhcmFpZGxpbnV4
QGxzaS5jb20+CisgKgorICogIE1haWwgdG86IExTSSBDb3Jwb3JhdGlvbiwgMTYyMSBCYXJiZXIg
TGFuZSwgTWlscGl0YXMsIENBIDk1MDM1CisgKiAgICAgQVRUTjogTGludXhyYWlkCisgKi8KKwor
I2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgorI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+CisjaW5j
bHVkZSA8bGludXgvcGNpLmg+CisjaW5jbHVkZSA8bGludXgvbGlzdC5oPgorI2luY2x1ZGUgPGxp
bnV4L21vZHVsZXBhcmFtLmg+CisjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+CisjaW5jbHVkZSA8
bGludXgvc3BpbmxvY2suaD4KKyNpbmNsdWRlIDxsaW51eC9pbnRlcnJ1cHQuaD4KKyNpbmNsdWRl
IDxsaW51eC9kZWxheS5oPgorI2luY2x1ZGUgPGxpbnV4L3NtcF9sb2NrLmg+CisjaW5jbHVkZSA8
bGludXgvdWlvLmg+CisjaW5jbHVkZSA8bGludXgvdWFjY2Vzcy5oPgorI2luY2x1ZGUgPGxpbnV4
L2ZzLmg+CisjaW5jbHVkZSA8bGludXgvY29tcGF0Lmg+CisjaW5jbHVkZSA8bGludXgvYmxrZGV2
Lmg+CisjaW5jbHVkZSA8bGludXgvbXV0ZXguaD4KKyNpbmNsdWRlIDxsaW51eC9wb2xsLmg+CisK
KyNpbmNsdWRlIDxzY3NpL3Njc2kuaD4KKyNpbmNsdWRlIDxzY3NpL3Njc2lfY21uZC5oPgorI2lu
Y2x1ZGUgPHNjc2kvc2NzaV9kZXZpY2UuaD4KKyNpbmNsdWRlIDxzY3NpL3Njc2lfaG9zdC5oPgor
CisjaW5jbHVkZSAibWVnYXJhaWRfc2FzX2Z1c2lvbi5oIgorI2luY2x1ZGUgIm1lZ2FyYWlkX3Nh
cy5oIgorCitleHRlcm4gdm9pZCBtZWdhc2FzX2ZyZWVfY21kcyhzdHJ1Y3QgbWVnYXNhc19pbnN0
YW5jZSAqaW5zdGFuY2UpOworZXh0ZXJuIHN0cnVjdCBtZWdhc2FzX2NtZCAqbWVnYXNhc19nZXRf
Y21kKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlCisJCQkJCSAgICppbnN0YW5jZSk7CitleHRlcm4g
dm9pZAorbWVnYXNhc19jb21wbGV0ZV9jbWQoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3Rh
bmNlLAorCQkgICAgIHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kLCB1OCBhbHRfc3RhdHVzKTsKK2lu
dCBtZWdhc2FzX2lzX2xkaW8oc3RydWN0IHNjc2lfY21uZCAqY21kKTsKK2ludAord2FpdF9hbmRf
cG9sbChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIHN0cnVjdCBtZWdhc2FzX2Nt
ZCAqY21kKTsKKwordm9pZAorbWVnYXNhc19yZXR1cm5fY21kKHN0cnVjdCBtZWdhc2FzX2luc3Rh
bmNlICppbnN0YW5jZSwgc3RydWN0IG1lZ2FzYXNfY21kICpjbWQpOworaW50IG1lZ2FzYXNfYWxs
b2NfY21kcyhzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpOworaW50CittZWdhc2Fz
X2NsZWFyX2ludHJfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpy
ZWdzKTsKK2ludAorbWVnYXNhc19pc3N1ZV9wb2xsZWQoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2Ug
Kmluc3RhbmNlLAorCQkgICAgIHN0cnVjdCBtZWdhc2FzX2NtZCAqY21kKTsKKwordTgKK01SX0J1
aWxkUmFpZENvbnRleHQoc3RydWN0IElPX1JFUVVFU1RfSU5GTyAqaW9faW5mbywKKwkJICAgIHN0
cnVjdCBSQUlEX0NPTlRFWFQgKnBSQUlEX0NvbnRleHQsCisJCSAgICBzdHJ1Y3QgTVJfRldfUkFJ
RF9NQVBfQUxMICptYXApOwordTE2IE1SX1RhcmdldElkVG9MZEdldCh1MzIgbGRUZ3RJZCwgc3Ry
dWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwKTsKK3N0cnVjdCBNUl9MRF9SQUlEICpNUl9MZFJh
aWRHZXQodTMyIGxkLCBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICptYXApOworCit1MTYgTVJf
R2V0TERUZ3RJZCh1MzIgbGQsIHN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKm1hcCk7Cit1OCBN
Ul9WYWxpZGF0ZU1hcEluZm8oc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FMTCAqbWFwLAorCQkgICAg
ICBzdHJ1Y3QgTERfTE9BRF9CQUxBTkNFX0lORk8gKmxiSW5mbyk7Cit1MTYgZ2V0X3VwZGF0ZWRf
ZGV2X2hhbmRsZShzdHJ1Y3QgTERfTE9BRF9CQUxBTkNFX0lORk8gKmxiSW5mbywKKwkJCSAgIHN0
cnVjdCBJT19SRVFVRVNUX0lORk8gKmluX2luZm8pOworaW50IG1lZ2FzYXNfdHJhbnNpdGlvbl90
b19yZWFkeShzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpOwordm9pZCBtZWdhcmFp
ZF9zYXNfa2lsbF9oYmEoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKTsKKworZXh0
ZXJuIHUzMiBtZWdhc2FzX2RiZ19sdmw7CisKKy8qKgorICogbWVnYXNhc19lbmFibGVfaW50cl9m
dXNpb24gLQlFbmFibGVzIGludGVycnVwdHMKKyAqIEByZWdzOgkJCU1GSSByZWdpc3RlciBzZXQK
KyAqLwordm9pZAorbWVnYXNhc19lbmFibGVfaW50cl9mdXNpb24oc3RydWN0IG1lZ2FzYXNfcmVn
aXN0ZXJfc2V0IF9faW9tZW0gKnJlZ3MpCit7CisJd3JpdGVsKH5NRklfRlVTSU9OX0VOQUJMRV9J
TlRFUlJVUFRfTUFTSywgJihyZWdzKS0+b3V0Ym91bmRfaW50cl9tYXNrKTsKKworCS8qIER1bW15
IHJlYWRsIHRvIGZvcmNlIHBjaSBmbHVzaCAqLworCXJlYWRsKCZyZWdzLT5vdXRib3VuZF9pbnRy
X21hc2spOworfQorCisvKioKKyAqIG1lZ2FzYXNfZGlzYWJsZV9pbnRyX2Z1c2lvbiAtIERpc2Fi
bGVzIGludGVycnVwdAorICogQHJlZ3M6CQkJIE1GSSByZWdpc3RlciBzZXQKKyAqLwordm9pZAor
bWVnYXNhc19kaXNhYmxlX2ludHJfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBf
X2lvbWVtICpyZWdzKQoreworCXUzMiBtYXNrID0gMHhGRkZGRkZGRjsKKwl1MzIgc3RhdHVzOwor
CisJd3JpdGVsKG1hc2ssICZyZWdzLT5vdXRib3VuZF9pbnRyX21hc2spOworCS8qIER1bW15IHJl
YWRsIHRvIGZvcmNlIHBjaSBmbHVzaCAqLworCXN0YXR1cyA9IHJlYWRsKCZyZWdzLT5vdXRib3Vu
ZF9pbnRyX21hc2spOworfQorCitpbnQKK21lZ2FzYXNfY2xlYXJfaW50cl9mdXNpb24oc3RydWN0
IG1lZ2FzYXNfcmVnaXN0ZXJfc2V0IF9faW9tZW0gKnJlZ3MpCit7CisJdTMyIHN0YXR1czsKKwkv
KgorCSAqIENoZWNrIGlmIGl0IGlzIG91ciBpbnRlcnJ1cHQKKwkgKi8KKwlzdGF0dXMgPSByZWFk
bCgmcmVncy0+b3V0Ym91bmRfaW50cl9zdGF0dXMpOworCisJaWYgKHN0YXR1cyAmIDEpIHsKKwkJ
d3JpdGVsKHN0YXR1cywgJnJlZ3MtPm91dGJvdW5kX2ludHJfc3RhdHVzKTsKKwkJcmVhZGwoJnJl
Z3MtPm91dGJvdW5kX2ludHJfc3RhdHVzKTsKKwkJcmV0dXJuIDE7CisJfQorCWlmICghKHN0YXR1
cyAmIE1GSV9GVVNJT05fRU5BQkxFX0lOVEVSUlVQVF9NQVNLKSkKKwkJcmV0dXJuIDA7CisKKwkv
KgorCSAqIGR1bW15IHJlYWQgdG8gZmx1c2ggUENJCisJICovCisJcmVhZGwoJnJlZ3MtPm91dGJv
dW5kX2ludHJfc3RhdHVzKTsKKworCXJldHVybiAxOworfQorCisvKioKKyAqIG1lZ2FzYXNfZ2V0
X2NtZF9mdXNpb24gLQlHZXQgYSBjb21tYW5kIGZyb20gdGhlIGZyZWUgcG9vbAorICogQGluc3Rh
bmNlOgkJQWRhcHRlciBzb2Z0IHN0YXRlCisgKgorICogUmV0dXJucyBhIGZyZWUgY29tbWFuZCBm
cm9tIHRoZSBwb29sCisgKi8KK3N0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24gKm1lZ2FzYXNfZ2V0
X2NtZF9mdXNpb24oc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UKKwkJCQkJCSAgKmluc3RhbmNlKQor
eworCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CisJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb24g
PQorCQkoc3RydWN0IGZ1c2lvbl9jb250ZXh0ICopaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKKwlz
dHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9uICpjbWQgPSBOVUxMOworCisJc3Bpbl9sb2NrX2lycXNh
dmUoJmZ1c2lvbi0+Y21kX3Bvb2xfbG9jaywgZmxhZ3MpOworCisJaWYgKCFsaXN0X2VtcHR5KCZm
dXNpb24tPmNtZF9wb29sKSkgeworCQljbWQgPSBsaXN0X2VudHJ5KCgmZnVzaW9uLT5jbWRfcG9v
bCktPm5leHQsCisJCQkJIHN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24sIGxpc3QpOworCQlsaXN0
X2RlbF9pbml0KCZjbWQtPmxpc3QpOworCX0gZWxzZSB7CisJCXByaW50ayhLRVJOX0VSUiAibWVn
YXNhczogQ29tbWFuZCBwb29sIChmdXNpb24pIGVtcHR5IVxuIik7CisJfQorCisJc3Bpbl91bmxv
Y2tfaXJxcmVzdG9yZSgmZnVzaW9uLT5jbWRfcG9vbF9sb2NrLCBmbGFncyk7CisJcmV0dXJuIGNt
ZDsKK30KKworLyoqCisgKiBtZWdhc2FzX3JldHVybl9jbWRfZnVzaW9uIC0JUmV0dXJuIGEgY21k
IHRvIGZyZWUgY29tbWFuZCBwb29sCisgKiBAaW5zdGFuY2U6CQlBZGFwdGVyIHNvZnQgc3RhdGUK
KyAqIEBjbWQ6CQlDb21tYW5kIHBhY2tldCB0byBiZSByZXR1cm5lZCB0byBmcmVlIGNvbW1hbmQg
cG9vbAorICovCitzdGF0aWMgaW5saW5lIHZvaWQKK21lZ2FzYXNfcmV0dXJuX2NtZF9mdXNpb24o
c3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAorCQkJICBzdHJ1Y3QgbWVnYXNhc19j
bWRfZnVzaW9uICpjbWQpCit7CisJdW5zaWduZWQgbG9uZyBmbGFnczsKKwlzdHJ1Y3QgZnVzaW9u
X2NvbnRleHQgKmZ1c2lvbiA9CisJCShzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKilpbnN0YW5jZS0+
Y3RybF9jb250ZXh0OworCisJc3Bpbl9sb2NrX2lycXNhdmUoJmZ1c2lvbi0+Y21kX3Bvb2xfbG9j
aywgZmxhZ3MpOworCisJY21kLT5zY21kID0gTlVMTDsKKwljbWQtPnN5bmNfY21kX2lkeCA9ICh1
MzIpVUxPTkdfTUFYOworCWxpc3RfYWRkX3RhaWwoJmNtZC0+bGlzdCwgJmZ1c2lvbi0+Y21kX3Bv
b2wpOworCisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZnVzaW9uLT5jbWRfcG9vbF9sb2NrLCBm
bGFncyk7Cit9CisKKy8qKgorICogbWVnYXNhc190ZWFyZG93bl9mcmFtZV9wb29sX2Z1c2lvbiAt
CURlc3Ryb3kgdGhlIGNtZCBmcmFtZSBETUEgcG9vbAorICogQGluc3RhbmNlOgkJCQlBZGFwdGVy
IHNvZnQgc3RhdGUKKyAqLworc3RhdGljIHZvaWQgbWVnYXNhc190ZWFyZG93bl9mcmFtZV9wb29s
X2Z1c2lvbigKKwlzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCit7CisJaW50IGk7
CisJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb24gPSBpbnN0YW5jZS0+Y3RybF9jb250ZXh0
OworCisJdTE2IG1heF9jbWQgPSBpbnN0YW5jZS0+bWF4X2Z3X2NtZHM7CisKKwlzdHJ1Y3QgbWVn
YXNhc19jbWRfZnVzaW9uICpjbWQ7CisKKwlpZiAoIWZ1c2lvbi0+c2dfZG1hX3Bvb2wgfHwgIWZ1
c2lvbi0+c2Vuc2VfZG1hX3Bvb2wpIHsKKwkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBkbWEg
cG9vbCBpcyBudWxsLiBTRyBQb29sICVwLCAiCisJCSAgICAgICAic2Vuc2UgcG9vbCA6ICVwXG4i
LCBmdXNpb24tPnNnX2RtYV9wb29sLAorCQkgICAgICAgZnVzaW9uLT5zZW5zZV9kbWFfcG9vbCk7
CisJCXJldHVybjsKKwl9CisKKwkvKgorCSAqIFJldHVybiBhbGwgZnJhbWVzIHRvIHBvb2wKKwkg
Ki8KKwlmb3IgKGkgPSAwOyBpIDwgbWF4X2NtZDsgaSsrKSB7CisKKwkJY21kID0gZnVzaW9uLT5j
bWRfbGlzdFtpXTsKKworCQlpZiAoY21kLT5zZ19mcmFtZSkKKwkJCXBjaV9wb29sX2ZyZWUoZnVz
aW9uLT5zZ19kbWFfcG9vbCwgY21kLT5zZ19mcmFtZSwKKwkJCQkgICAgICBjbWQtPnNnX2ZyYW1l
X3BoeXNfYWRkcik7CisKKwkJaWYgKGNtZC0+c2Vuc2UpCisJCQlwY2lfcG9vbF9mcmVlKGZ1c2lv
bi0+c2Vuc2VfZG1hX3Bvb2wsIGNtZC0+c2Vuc2UsCisJCQkJICAgICAgY21kLT5zZW5zZV9waHlz
X2FkZHIpOworCX0KKworCS8qCisJICogTm93IGRlc3Ryb3kgdGhlIHBvb2wgaXRzZWxmCisJICov
CisJcGNpX3Bvb2xfZGVzdHJveShmdXNpb24tPnNnX2RtYV9wb29sKTsKKwlwY2lfcG9vbF9kZXN0
cm95KGZ1c2lvbi0+c2Vuc2VfZG1hX3Bvb2wpOworCisJZnVzaW9uLT5zZ19kbWFfcG9vbCA9IE5V
TEw7CisJZnVzaW9uLT5zZW5zZV9kbWFfcG9vbCA9IE5VTEw7Cit9CisKKy8qKgorICogbWVnYXNh
c19mcmVlX2NtZHNfZnVzaW9uIC0JRnJlZSBhbGwgdGhlIGNtZHMgaW4gdGhlIGZyZWUgY21kIHBv
b2wKKyAqIEBpbnN0YW5jZToJCUFkYXB0ZXIgc29mdCBzdGF0ZQorICovCit2b2lkCittZWdhc2Fz
X2ZyZWVfY21kc19mdXNpb24oc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKQorewor
CWludCBpOworCXN0cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxf
Y29udGV4dDsKKworCXUzMiBtYXhfY21kcywgcmVxX3N6LCByZXBseV9zeiwgaW9fZnJhbWVzX3N6
OworCisKKwlyZXFfc3ogPSBmdXNpb24tPnJlcXVlc3RfYWxsb2Nfc3o7CisJcmVwbHlfc3ogPSBm
dXNpb24tPnJlcGx5X2FsbG9jX3N6OworCWlvX2ZyYW1lc19zeiA9IGZ1c2lvbi0+aW9fZnJhbWVz
X2FsbG9jX3N6OworCisJbWF4X2NtZHMgPSBpbnN0YW5jZS0+bWF4X2Z3X2NtZHM7CisKKwkvKiBG
cmVlIGRlc2NyaXB0b3JzIGFuZCByZXF1ZXN0IEZyYW1lcyBtZW1vcnkgKi8KKwlpZiAoZnVzaW9u
LT5yZXFfZnJhbWVzX2Rlc2MpCisJCWRtYV9mcmVlX2NvaGVyZW50KCZpbnN0YW5jZS0+cGRldi0+
ZGV2LCByZXFfc3osCisJCQkJICBmdXNpb24tPnJlcV9mcmFtZXNfZGVzYywKKwkJCQkgIGZ1c2lv
bi0+cmVxX2ZyYW1lc19kZXNjX3BoeXMpOworCisJaWYgKGZ1c2lvbi0+cmVwbHlfZnJhbWVzX2Rl
c2MpIHsKKwkJcGNpX3Bvb2xfZnJlZShmdXNpb24tPnJlcGx5X2ZyYW1lc19kZXNjX3Bvb2wsCisJ
CQkgICAgICBmdXNpb24tPnJlcGx5X2ZyYW1lc19kZXNjLAorCQkJICAgICAgZnVzaW9uLT5yZXBs
eV9mcmFtZXNfZGVzY19waHlzKTsKKwkJcGNpX3Bvb2xfZGVzdHJveShmdXNpb24tPnJlcGx5X2Zy
YW1lc19kZXNjX3Bvb2wpOworCX0KKworCWlmIChmdXNpb24tPmlvX3JlcXVlc3RfZnJhbWVzKSB7
CisJCXBjaV9wb29sX2ZyZWUoZnVzaW9uLT5pb19yZXF1ZXN0X2ZyYW1lc19wb29sLAorCQkJICAg
ICAgZnVzaW9uLT5pb19yZXF1ZXN0X2ZyYW1lcywKKwkJCSAgICAgIGZ1c2lvbi0+aW9fcmVxdWVz
dF9mcmFtZXNfcGh5cyk7CisJCXBjaV9wb29sX2Rlc3Ryb3koZnVzaW9uLT5pb19yZXF1ZXN0X2Zy
YW1lc19wb29sKTsKKwl9CisKKwkvKiBGcmVlIHRoZSBGdXNpb24gZnJhbWUgcG9vbCAqLworCW1l
Z2FzYXNfdGVhcmRvd25fZnJhbWVfcG9vbF9mdXNpb24oaW5zdGFuY2UpOworCisJLyogRnJlZSBh
bGwgdGhlIGNvbW1hbmRzIGluIHRoZSBjbWRfbGlzdCAqLworCWZvciAoaSA9IDA7IGkgPCBtYXhf
Y21kczsgaSsrKQorCQlrZnJlZShmdXNpb24tPmNtZF9saXN0W2ldKTsKKworCS8qIEZyZWUgdGhl
IGNtZF9saXN0IGJ1ZmZlciBpdHNlbGYgKi8KKwlrZnJlZShmdXNpb24tPmNtZF9saXN0KTsKKwlm
dXNpb24tPmNtZF9saXN0ID0gTlVMTDsKKworCUlOSVRfTElTVF9IRUFEKCZmdXNpb24tPmNtZF9w
b29sKTsKK30KKworLyoqCisgKiBtZWdhc2FzX2NyZWF0ZV9mcmFtZV9wb29sX2Z1c2lvbiAtCUNy
ZWF0ZXMgRE1BIHBvb2wgZm9yIGNtZCBmcmFtZXMKKyAqIEBpbnN0YW5jZToJCQlBZGFwdGVyIHNv
ZnQgc3RhdGUKKyAqCisgKi8KK3N0YXRpYyBpbnQgbWVnYXNhc19jcmVhdGVfZnJhbWVfcG9vbF9m
dXNpb24oc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlKQoreworCWludCBpOworCXUz
MiBtYXhfY21kOworCXN0cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uOworCXN0cnVjdCBtZWdh
c2FzX2NtZF9mdXNpb24gKmNtZDsKKwl1MzIgdG90YWxfc3pfY2hhaW5fZnJhbWU7CisKKwlmdXNp
b24gPSBpbnN0YW5jZS0+Y3RybF9jb250ZXh0OworCW1heF9jbWQgPSBpbnN0YW5jZS0+bWF4X2Z3
X2NtZHM7CisKKwl0b3RhbF9zel9jaGFpbl9mcmFtZSA9IE1FR0FTQVNfTUFYX1NaX0NIQUlOX0ZS
QU1FOworCisJLyoKKwkgKiBVc2UgRE1BIHBvb2wgZmFjaWxpdHkgcHJvdmlkZWQgYnkgUENJIGxh
eWVyCisJICovCisKKwlmdXNpb24tPnNnX2RtYV9wb29sID0gcGNpX3Bvb2xfY3JlYXRlKCJtZWdh
c2FzIHNnIHBvb2wgZnVzaW9uIiwKKwkJCQkJICAgICAgaW5zdGFuY2UtPnBkZXYsCisJCQkJCSAg
ICAgIHRvdGFsX3N6X2NoYWluX2ZyYW1lLCA0LAorCQkJCQkgICAgICAwKTsKKwlpZiAoIWZ1c2lv
bi0+c2dfZG1hX3Bvb2wpIHsKKwkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IGZhaWxlZCB0
byBzZXR1cCByZXF1ZXN0IHBvb2wgIgorCQkgICAgICAgImZ1c2lvblxuIik7CisJCXJldHVybiAt
RU5PTUVNOworCX0KKwlmdXNpb24tPnNlbnNlX2RtYV9wb29sID0gcGNpX3Bvb2xfY3JlYXRlKCJt
ZWdhc2FzIHNlbnNlIHBvb2wgZnVzaW9uIiwKKwkJCQkJCSBpbnN0YW5jZS0+cGRldiwKKwkJCQkJ
CSBTQ1NJX1NFTlNFX0JVRkZFUlNJWkUsIDY0LCAwKTsKKworCWlmICghZnVzaW9uLT5zZW5zZV9k
bWFfcG9vbCkgeworCQlwcmludGsoS0VSTl9ERUJVRyAibWVnYXNhczogZmFpbGVkIHRvIHNldHVw
IHNlbnNlIHBvb2wgIgorCQkgICAgICAgImZ1c2lvblxuIik7CisJCXBjaV9wb29sX2Rlc3Ryb3ko
ZnVzaW9uLT5zZ19kbWFfcG9vbCk7CisJCWZ1c2lvbi0+c2dfZG1hX3Bvb2wgPSBOVUxMOworCQly
ZXR1cm4gLUVOT01FTTsKKwl9CisKKwkvKgorCSAqIEFsbG9jYXRlIGFuZCBhdHRhY2ggYSBmcmFt
ZSB0byBlYWNoIG9mIHRoZSBjb21tYW5kcyBpbiBjbWRfbGlzdAorCSAqLworCWZvciAoaSA9IDA7
IGkgPCBtYXhfY21kOyBpKyspIHsKKworCQljbWQgPSBmdXNpb24tPmNtZF9saXN0W2ldOworCisJ
CWNtZC0+c2dfZnJhbWUgPSBwY2lfcG9vbF9hbGxvYyhmdXNpb24tPnNnX2RtYV9wb29sLAorCQkJ
CQkgICAgICAgR0ZQX0tFUk5FTCwKKwkJCQkJICAgICAgICZjbWQtPnNnX2ZyYW1lX3BoeXNfYWRk
cik7CisKKwkJY21kLT5zZW5zZSA9IHBjaV9wb29sX2FsbG9jKGZ1c2lvbi0+c2Vuc2VfZG1hX3Bv
b2wsCisJCQkJCSAgICBHRlBfS0VSTkVMLCAmY21kLT5zZW5zZV9waHlzX2FkZHIpOworCQkvKgor
CQkgKiBtZWdhc2FzX3RlYXJkb3duX2ZyYW1lX3Bvb2xfZnVzaW9uKCkgdGFrZXMgY2FyZSBvZiBm
cmVlaW5nCisJCSAqIHdoYXRldmVyIGhhcyBiZWVuIGFsbG9jYXRlZAorCQkgKi8KKwkJaWYgKCFj
bWQtPnNnX2ZyYW1lIHx8ICFjbWQtPnNlbnNlKSB7CisJCQlwcmludGsoS0VSTl9ERUJVRyAibWVn
YXNhczogcGNpX3Bvb2xfYWxsb2MgZmFpbGVkXG4iKTsKKwkJCW1lZ2FzYXNfdGVhcmRvd25fZnJh
bWVfcG9vbF9mdXNpb24oaW5zdGFuY2UpOworCQkJcmV0dXJuIC1FTk9NRU07CisJCX0KKwl9CisJ
cmV0dXJuIDA7Cit9CisKKy8qKgorICogbWVnYXNhc19hbGxvY19jbWRzX2Z1c2lvbiAtCUFsbG9j
YXRlcyB0aGUgY29tbWFuZCBwYWNrZXRzCisgKiBAaW5zdGFuY2U6CQlBZGFwdGVyIHNvZnQgc3Rh
dGUKKyAqCisgKgorICogRWFjaCBmcmFtZSBoYXMgYSAzMi1iaXQgZmllbGQgY2FsbGVkIGNvbnRl
eHQuIFRoaXMgY29udGV4dCBpcyB1c2VkIHRvIGdldAorICogYmFjayB0aGUgbWVnYXNhc19jbWRf
ZnVzaW9uIGZyb20gdGhlIGZyYW1lIHdoZW4gYSBmcmFtZSBnZXRzIGNvbXBsZXRlZAorICogSW4g
dGhpcyBkcml2ZXIsIHRoZSAzMiBiaXQgdmFsdWVzIGFyZSB0aGUgaW5kaWNlcyBpbnRvIGFuIGFy
cmF5IGNtZF9saXN0LgorICogVGhpcyBhcnJheSBpcyB1c2VkIG9ubHkgdG8gbG9vayB1cCB0aGUg
bWVnYXNhc19jbWRfZnVzaW9uIGdpdmVuIHRoZSBjb250ZXh0LgorICogVGhlIGZyZWUgY29tbWFu
ZHMgdGhlbXNlbHZlcyBhcmUgbWFpbnRhaW5lZCBpbiBhIGxpbmtlZCBsaXN0IGNhbGxlZCBjbWRf
cG9vbC4KKyAqCisgKiBjbWRzIGFyZSBmb3JtZWQgaW4gdGhlIGlvX3JlcXVlc3QgYW5kIHNnX2Zy
YW1lIG1lbWJlcnMgb2YgdGhlCisgKiBtZWdhc2FzX2NtZF9mdXNpb24uIFRoZSBjb250ZXh0IGZp
ZWxkIGlzIHVzZWQgdG8gZ2V0IGEgcmVxdWVzdCBkZXNjcmlwdG9yCisgKiBhbmQgaXMgdXNlZCBh
cyBTTUlEIG9mIHRoZSBjbWQuCisgKiBTTUlEIHZhbHVlIHJhbmdlIGlzIGZyb20gMSB0byBtYXhf
ZndfY21kcy4KKyAqLworaW50CittZWdhc2FzX2FsbG9jX2NtZHNfZnVzaW9uKHN0cnVjdCBtZWdh
c2FzX2luc3RhbmNlICppbnN0YW5jZSkKK3sKKwlpbnQgaSwgajsKKwl1MzIgbWF4X2NtZCwgaW9f
ZnJhbWVzX3N6OworCXN0cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uOworCXN0cnVjdCBtZWdh
c2FzX2NtZF9mdXNpb24gKmNtZDsKKwl1bmlvbiBNUEkyX1JFUExZX0RFU0NSSVBUT1JTX1VOSU9O
ICpyZXBseV9kZXNjOworCXUzMiBvZmZzZXQ7CisJZG1hX2FkZHJfdCBpb19yZXFfYmFzZV9waHlz
OworCXU4ICppb19yZXFfYmFzZTsKKworCWZ1c2lvbiA9IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7
CisKKwltYXhfY21kID0gaW5zdGFuY2UtPm1heF9md19jbWRzOworCisJZnVzaW9uLT5yZXFfZnJh
bWVzX2Rlc2MgPQorCQlkbWFfYWxsb2NfY29oZXJlbnQoJmluc3RhbmNlLT5wZGV2LT5kZXYsCisJ
CQkJICAgZnVzaW9uLT5yZXF1ZXN0X2FsbG9jX3N6LAorCQkJCSAgICZmdXNpb24tPnJlcV9mcmFt
ZXNfZGVzY19waHlzLCBHRlBfS0VSTkVMKTsKKworCWlmICghZnVzaW9uLT5yZXFfZnJhbWVzX2Rl
c2MpIHsKKwkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOyBDb3VsZCBub3QgYWxsb2NhdGUgbWVt
b3J5IGZvciAiCisJCSAgICAgICAicmVxdWVzdF9mcmFtZXNcbiIpOworCQlnb3RvIGZhaWxfcmVx
X2Rlc2M7CisJfQorCisJZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzY19wb29sID0KKwkJcGNpX3Bv
b2xfY3JlYXRlKCJyZXBseV9mcmFtZXMgcG9vbCIsIGluc3RhbmNlLT5wZGV2LAorCQkJCWZ1c2lv
bi0+cmVwbHlfYWxsb2Nfc3osIDE2LCAwKTsKKworCWlmICghZnVzaW9uLT5yZXBseV9mcmFtZXNf
ZGVzY19wb29sKSB7CisJCXByaW50ayhLRVJOX0VSUiAibWVnYXNhczsgQ291bGQgbm90IGFsbG9j
YXRlIG1lbW9yeSBmb3IgIgorCQkgICAgICAgInJlcGx5X2ZyYW1lIHBvb2xcbiIpOworCQlnb3Rv
IGZhaWxfcmVwbHlfZGVzYzsKKwl9CisKKwlmdXNpb24tPnJlcGx5X2ZyYW1lc19kZXNjID0KKwkJ
cGNpX3Bvb2xfYWxsb2MoZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzY19wb29sLCBHRlBfS0VSTkVM
LAorCQkJICAgICAgICZmdXNpb24tPnJlcGx5X2ZyYW1lc19kZXNjX3BoeXMpOworCWlmICghZnVz
aW9uLT5yZXBseV9mcmFtZXNfZGVzYykgeworCQlwcmludGsoS0VSTl9FUlIgIm1lZ2FzYXM7IENv
dWxkIG5vdCBhbGxvY2F0ZSBtZW1vcnkgZm9yICIKKwkJICAgICAgICJyZXBseV9mcmFtZSBwb29s
XG4iKTsKKwkJcGNpX3Bvb2xfZGVzdHJveShmdXNpb24tPnJlcGx5X2ZyYW1lc19kZXNjX3Bvb2wp
OworCQlnb3RvIGZhaWxfcmVwbHlfZGVzYzsKKwl9CisKKwlyZXBseV9kZXNjID0gZnVzaW9uLT5y
ZXBseV9mcmFtZXNfZGVzYzsKKwlmb3IgKGkgPSAwOyBpIDwgZnVzaW9uLT5yZXBseV9xX2RlcHRo
OyBpKyssIHJlcGx5X2Rlc2MrKykKKwkJcmVwbHlfZGVzYy0+V29yZHMgPSBVTExPTkdfTUFYOwor
CisJaW9fZnJhbWVzX3N6ID0gZnVzaW9uLT5pb19mcmFtZXNfYWxsb2Nfc3o7CisKKwlmdXNpb24t
PmlvX3JlcXVlc3RfZnJhbWVzX3Bvb2wgPQorCQlwY2lfcG9vbF9jcmVhdGUoImlvX3JlcXVlc3Rf
ZnJhbWVzIHBvb2wiLCBpbnN0YW5jZS0+cGRldiwKKwkJCQlmdXNpb24tPmlvX2ZyYW1lc19hbGxv
Y19zeiwgMTYsIDApOworCisJaWYgKCFmdXNpb24tPmlvX3JlcXVlc3RfZnJhbWVzX3Bvb2wpIHsK
KwkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBDb3VsZCBub3QgYWxsb2NhdGUgbWVtb3J5IGZv
ciAiCisJCSAgICAgICAiaW9fcmVxdWVzdF9mcmFtZSBwb29sXG4iKTsKKwkJZ290byBmYWlsX2lv
X2ZyYW1lczsKKwl9CisKKwlmdXNpb24tPmlvX3JlcXVlc3RfZnJhbWVzID0KKwkJcGNpX3Bvb2xf
YWxsb2MoZnVzaW9uLT5pb19yZXF1ZXN0X2ZyYW1lc19wb29sLCBHRlBfS0VSTkVMLAorCQkJICAg
ICAgICZmdXNpb24tPmlvX3JlcXVlc3RfZnJhbWVzX3BoeXMpOworCWlmICghZnVzaW9uLT5pb19y
ZXF1ZXN0X2ZyYW1lcykgeworCQlwcmludGsoS0VSTl9FUlIgIm1lZ2FzYXM6IENvdWxkIG5vdCBh
bGxvY2F0ZSBtZW1vcnkgZm9yICIKKwkJICAgICAgICJpb19yZXF1ZXN0X2ZyYW1lcyBmcmFtZXNc
biIpOworCQlwY2lfcG9vbF9kZXN0cm95KGZ1c2lvbi0+aW9fcmVxdWVzdF9mcmFtZXNfcG9vbCk7
CisJCWdvdG8gZmFpbF9pb19mcmFtZXM7CisJfQorCisJLyoKKwkgKiBmdXNpb24tPmNtZF9saXN0
IGlzIGFuIGFycmF5IG9mIHN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24gcG9pbnRlcnMuCisJICog
QWxsb2NhdGUgdGhlIGR5bmFtaWMgYXJyYXkgZmlyc3QgYW5kIHRoZW4gYWxsb2NhdGUgaW5kaXZp
ZHVhbAorCSAqIGNvbW1hbmRzLgorCSAqLworCWZ1c2lvbi0+Y21kX2xpc3QgPSBrbWFsbG9jKHNp
emVvZihzdHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9uICopCisJCQkJICAgKm1heF9jbWQsIEdGUF9L
RVJORUwpOworCisJaWYgKCFmdXNpb24tPmNtZF9saXN0KSB7CisJCXByaW50ayhLRVJOX0RFQlVH
ICJtZWdhc2FzOiBvdXQgb2YgbWVtb3J5LiBDb3VsZCBub3QgYWxsb2MgIgorCQkgICAgICAgIm1l
bW9yeSBmb3IgY21kX2xpc3RfZnVzaW9uXG4iKTsKKwkJZ290byBmYWlsX2NtZF9saXN0OworCX0K
KworCW1lbXNldChmdXNpb24tPmNtZF9saXN0LCAwLCBzaXplb2Yoc3RydWN0IG1lZ2FzYXNfY21k
X2Z1c2lvbiAqKQorCSAgICAgICAqbWF4X2NtZCk7CisKKwltYXhfY21kID0gaW5zdGFuY2UtPm1h
eF9md19jbWRzOworCWZvciAoaSA9IDA7IGkgPCBtYXhfY21kOyBpKyspIHsKKwkJZnVzaW9uLT5j
bWRfbGlzdFtpXSA9IGttYWxsb2Moc2l6ZW9mKHN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24pLAor
CQkJCQkgICAgICBHRlBfS0VSTkVMKTsKKwkJaWYgKCFmdXNpb24tPmNtZF9saXN0W2ldKSB7CisJ
CQlwcmludGsoS0VSTl9FUlIgIkNvdWxkIG5vdCBhbGxvYyBjbWQgbGlzdCBmdXNpb25cbiIpOwor
CisJCQlmb3IgKGogPSAwOyBqIDwgaTsgaisrKQorCQkJCWtmcmVlKGZ1c2lvbi0+Y21kX2xpc3Rb
al0pOworCisJCQlrZnJlZShmdXNpb24tPmNtZF9saXN0KTsKKwkJCWZ1c2lvbi0+Y21kX2xpc3Qg
PSBOVUxMOworCQkJZ290byBmYWlsX2NtZF9saXN0OworCQl9CisJfQorCisJLyogVGhlIGZpcnN0
IDI1NiBieXRlcyAoU01JRCAwKSBpcyBub3QgdXNlZC4gRG9uJ3QgYWRkIHRvIGNtZCBsaXN0ICov
CisJaW9fcmVxX2Jhc2UgPSBmdXNpb24tPmlvX3JlcXVlc3RfZnJhbWVzICsKKwkJTUVHQV9NUEky
X1JBSURfREVGQVVMVF9JT19GUkFNRV9TSVpFOworCWlvX3JlcV9iYXNlX3BoeXMgPSBmdXNpb24t
PmlvX3JlcXVlc3RfZnJhbWVzX3BoeXMgKworCQlNRUdBX01QSTJfUkFJRF9ERUZBVUxUX0lPX0ZS
QU1FX1NJWkU7CisKKwkvKgorCSAqIEFkZCBhbGwgdGhlIGNvbW1hbmRzIHRvIGNvbW1hbmQgcG9v
bCAoZnVzaW9uLT5jbWRfcG9vbCkKKwkgKi8KKworCS8qIFNNSUQgMCBpcyByZXNlcnZlZC4gU2V0
IFNNSUQvaW5kZXggZnJvbSAxICovCisJZm9yIChpID0gMDsgaSA8IG1heF9jbWQ7IGkrKykgewor
CQljbWQgPSBmdXNpb24tPmNtZF9saXN0W2ldOworCQlvZmZzZXQgPSBNRUdBX01QSTJfUkFJRF9E
RUZBVUxUX0lPX0ZSQU1FX1NJWkUgKiBpOworCQltZW1zZXQoY21kLCAwLCBzaXplb2Yoc3RydWN0
IG1lZ2FzYXNfY21kX2Z1c2lvbikpOworCQljbWQtPmluZGV4ID0gaSArIDE7CisJCWNtZC0+c2Nt
ZCA9IE5VTEw7CisJCWNtZC0+c3luY19jbWRfaWR4ID0gKHUzMilVTE9OR19NQVg7IC8qIFNldCB0
byBJbnZhbGlkICovCisJCWNtZC0+aW5zdGFuY2UgPSBpbnN0YW5jZTsKKwkJY21kLT5pb19yZXF1
ZXN0ID0KKwkJCShzdHJ1Y3QgTVBJMl9SQUlEX1NDU0lfSU9fUkVRVUVTVCAqKQorCQkgIChpb19y
ZXFfYmFzZSArIG9mZnNldCk7CisJCW1lbXNldChjbWQtPmlvX3JlcXVlc3QsIDAsCisJCSAgICAg
ICBzaXplb2Yoc3RydWN0IE1QSTJfUkFJRF9TQ1NJX0lPX1JFUVVFU1QpKTsKKwkJY21kLT5pb19y
ZXF1ZXN0X3BoeXNfYWRkciA9IGlvX3JlcV9iYXNlX3BoeXMgKyBvZmZzZXQ7CisKKwkJbGlzdF9h
ZGRfdGFpbCgmY21kLT5saXN0LCAmZnVzaW9uLT5jbWRfcG9vbCk7CisJfQorCisJLyoKKwkgKiBD
cmVhdGUgYSBmcmFtZSBwb29sIGFuZCBhc3NpZ24gb25lIGZyYW1lIHRvIGVhY2ggY21kCisJICov
CisJaWYgKG1lZ2FzYXNfY3JlYXRlX2ZyYW1lX3Bvb2xfZnVzaW9uKGluc3RhbmNlKSkgeworCQlw
cmludGsoS0VSTl9ERUJVRyAibWVnYXNhczogRXJyb3IgY3JlYXRpbmcgZnJhbWUgRE1BIHBvb2xc
biIpOworCQltZWdhc2FzX2ZyZWVfY21kc19mdXNpb24oaW5zdGFuY2UpOworCQlnb3RvIGZhaWxf
cmVxX2Rlc2M7CisJfQorCisJcmV0dXJuIDA7CisKK2ZhaWxfY21kX2xpc3Q6CisJcGNpX3Bvb2xf
ZnJlZShmdXNpb24tPmlvX3JlcXVlc3RfZnJhbWVzX3Bvb2wsIGZ1c2lvbi0+aW9fcmVxdWVzdF9m
cmFtZXMsCisJCSAgICAgIGZ1c2lvbi0+aW9fcmVxdWVzdF9mcmFtZXNfcGh5cyk7CisJcGNpX3Bv
b2xfZGVzdHJveShmdXNpb24tPmlvX3JlcXVlc3RfZnJhbWVzX3Bvb2wpOworZmFpbF9pb19mcmFt
ZXM6CisJZG1hX2ZyZWVfY29oZXJlbnQoJmluc3RhbmNlLT5wZGV2LT5kZXYsIGZ1c2lvbi0+cmVx
dWVzdF9hbGxvY19zeiwKKwkJCSAgZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzYywKKwkJCSAgZnVz
aW9uLT5yZXBseV9mcmFtZXNfZGVzY19waHlzKTsKKwlwY2lfcG9vbF9mcmVlKGZ1c2lvbi0+cmVw
bHlfZnJhbWVzX2Rlc2NfcG9vbCwKKwkJICAgICAgZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzYywK
KwkJICAgICAgZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzY19waHlzKTsKKwlwY2lfcG9vbF9kZXN0
cm95KGZ1c2lvbi0+cmVwbHlfZnJhbWVzX2Rlc2NfcG9vbCk7CisKK2ZhaWxfcmVwbHlfZGVzYzoK
KwlkbWFfZnJlZV9jb2hlcmVudCgmaW5zdGFuY2UtPnBkZXYtPmRldiwgZnVzaW9uLT5yZXF1ZXN0
X2FsbG9jX3N6LAorCQkJICBmdXNpb24tPnJlcV9mcmFtZXNfZGVzYywKKwkJCSAgZnVzaW9uLT5y
ZXFfZnJhbWVzX2Rlc2NfcGh5cyk7CitmYWlsX3JlcV9kZXNjOgorCXJldHVybiAtRU5PTUVNOwor
fQorCisvKioKKyAqIHdhaXRfYW5kX3BvbGwgLQlJc3N1ZXMgYSBwb2xsaW5nIGNvbW1hbmQKKyAq
IEBpbnN0YW5jZToJCQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAqIEBjbWQ6CQkJQ29tbWFuZCBwYWNr
ZXQgdG8gYmUgaXNzdWVkCisgKgorICogRm9yIHBvbGxpbmcsIE1GSSByZXF1aXJlcyB0aGUgY21k
X3N0YXR1cyB0byBiZSBzZXQgdG8gMHhGRiBiZWZvcmUgcG9zdGluZy4KKyAqLworaW50Cit3YWl0
X2FuZF9wb2xsKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwgc3RydWN0IG1lZ2Fz
YXNfY21kICpjbWQpCit7CisJaW50IGk7CisJc3RydWN0IG1lZ2FzYXNfaGVhZGVyICpmcmFtZV9o
ZHIgPSAmY21kLT5mcmFtZS0+aGRyOworCisJdTMyIG1zZWNzID0gTUZJX1BPTExfVElNRU9VVF9T
RUNTICogMTAwMDsKKworCS8qCisJICogV2FpdCBmb3IgY21kX3N0YXR1cyB0byBjaGFuZ2UKKwkg
Ki8KKwlmb3IgKGkgPSAwOyAoaSA8IG1zZWNzKSAmJiAoZnJhbWVfaGRyLT5jbWRfc3RhdHVzID09
IDB4ZmYpOyBpICs9IDIwKSB7CisJCXJtYigpOworCQltc2xlZXAoMjApOworCX0KKworCWlmIChm
cmFtZV9oZHItPmNtZF9zdGF0dXMgPT0gMHhmZikKKwkJcmV0dXJuIC1FVElNRTsKKworCXJldHVy
biAwOworfQorCisvKioKKyAqIG1lZ2FzYXNfaW9jX2luaXRfZnVzaW9uIC0JSW5pdGlhbGl6ZXMg
dGhlIEZXCisgKiBAaW5zdGFuY2U6CQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAqCisgKiBJc3N1ZXMg
dGhlIElPQyBJbml0IGNtZAorICovCitpbnQKK21lZ2FzYXNfaW9jX2luaXRfZnVzaW9uKHN0cnVj
dCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKK3sKKwlzdHJ1Y3QgbWVnYXNhc19pbml0X2Zy
YW1lICppbml0X2ZyYW1lOworCXN0cnVjdCBNUEkyX0lPQ19JTklUX1JFUVVFU1QgKklPQ0luaXRN
ZXNzYWdlOworCWRtYV9hZGRyX3QJaW9jX2luaXRfaGFuZGxlOworCXUzMiBjb250ZXh0OworCXN0
cnVjdCBtZWdhc2FzX2NtZCAqY21kOworCXU4IHJldDsKKwlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQg
KmZ1c2lvbjsKKwl1bmlvbiBNRUdBU0FTX1JFUVVFU1RfREVTQ1JJUFRPUl9VTklPTiAqcmVxX2Rl
c2M7CisJaW50IGk7CisJc3RydWN0IG1lZ2FzYXNfaGVhZGVyICpmcmFtZV9oZHI7CisKKwlmdXNp
b24gPSBpbnN0YW5jZS0+Y3RybF9jb250ZXh0OworCisJY21kID0gbWVnYXNhc19nZXRfY21kKGlu
c3RhbmNlKTsKKworCWlmICghY21kKSB7CisJCXByaW50ayhLRVJOX0VSUiAiQ291bGQgbm90IGFs
bG9jYXRlIGNtZCBmb3IgSU5JVCBGcmFtZVxuIik7CisJCXJldCA9IDE7CisJCWdvdG8gZmFpbF9n
ZXRfY21kOworCX0KKworCUlPQ0luaXRNZXNzYWdlID0KKwkgIGRtYV9hbGxvY19jb2hlcmVudCgm
aW5zdGFuY2UtPnBkZXYtPmRldiwKKwkJCSAgICAgc2l6ZW9mKHN0cnVjdCBNUEkyX0lPQ19JTklU
X1JFUVVFU1QpLAorCQkJICAgICAmaW9jX2luaXRfaGFuZGxlLCBHRlBfS0VSTkVMKTsKKworCWlm
ICghSU9DSW5pdE1lc3NhZ2UpIHsKKwkJcHJpbnRrKEtFUk5fRVJSICJDb3VsZCBub3QgYWxsb2Nh
dGUgbWVtb3J5IGZvciAiCisJCSAgICAgICAiSU9DSW5pdE1lc3NhZ2VcbiIpOworCQlyZXQgPSAx
OworCQlnb3RvIGZhaWxfZndfaW5pdDsKKwl9CisKKwltZW1zZXQoSU9DSW5pdE1lc3NhZ2UsIDAs
IHNpemVvZihzdHJ1Y3QgTVBJMl9JT0NfSU5JVF9SRVFVRVNUKSk7CisKKwlJT0NJbml0TWVzc2Fn
ZS0+RnVuY3Rpb24gPSBNUEkyX0ZVTkNUSU9OX0lPQ19JTklUOworCUlPQ0luaXRNZXNzYWdlLT5X
aG9Jbml0CT0gTVBJMl9XSE9JTklUX0hPU1RfRFJJVkVSOworCUlPQ0luaXRNZXNzYWdlLT5Nc2dW
ZXJzaW9uID0gTVBJMl9WRVJTSU9OOworCUlPQ0luaXRNZXNzYWdlLT5IZWFkZXJWZXJzaW9uID0g
TVBJMl9IRUFERVJfVkVSU0lPTjsKKwlJT0NJbml0TWVzc2FnZS0+U3lzdGVtUmVxdWVzdEZyYW1l
U2l6ZSA9CisJCU1FR0FfTVBJMl9SQUlEX0RFRkFVTFRfSU9fRlJBTUVfU0laRSAvIDQ7CisKKwlJ
T0NJbml0TWVzc2FnZS0+UmVwbHlEZXNjcmlwdG9yUG9zdFF1ZXVlRGVwdGggPSBmdXNpb24tPnJl
cGx5X3FfZGVwdGg7CisJSU9DSW5pdE1lc3NhZ2UtPlJlcGx5RGVzY3JpcHRvclBvc3RRdWV1ZUFk
ZHJlc3MJPQorCQlmdXNpb24tPnJlcGx5X2ZyYW1lc19kZXNjX3BoeXM7CisJSU9DSW5pdE1lc3Nh
Z2UtPlN5c3RlbVJlcXVlc3RGcmFtZUJhc2VBZGRyZXNzID0KKwkJZnVzaW9uLT5pb19yZXF1ZXN0
X2ZyYW1lc19waHlzOworCisJaW5pdF9mcmFtZSA9IChzdHJ1Y3QgbWVnYXNhc19pbml0X2ZyYW1l
ICopY21kLT5mcmFtZTsKKwltZW1zZXQoaW5pdF9mcmFtZSwgMCwgTUVHQU1GSV9GUkFNRV9TSVpF
KTsKKworCWZyYW1lX2hkciA9ICZjbWQtPmZyYW1lLT5oZHI7CisJY29udGV4dCA9IGluaXRfZnJh
bWUtPmNvbnRleHQ7CisJaW5pdF9mcmFtZS0+Y29udGV4dCA9IGNvbnRleHQ7CisKKwlmcmFtZV9o
ZHItPmNtZF9zdGF0dXMgPSAweEZGOworCWZyYW1lX2hkci0+ZmxhZ3MgfD0gTUZJX0ZSQU1FX0RP
TlRfUE9TVF9JTl9SRVBMWV9RVUVVRTsKKworCWluaXRfZnJhbWUtPmNtZAk9IE1GSV9DTURfSU5J
VDsKKwlpbml0X2ZyYW1lLT5jbWRfc3RhdHVzID0gMHhGRjsKKworCWluaXRfZnJhbWUtPnF1ZXVl
X2luZm9fbmV3X3BoeXNfYWRkcl9sbyA9IGlvY19pbml0X2hhbmRsZTsKKwlpbml0X2ZyYW1lLT5k
YXRhX3hmZXJfbGVuID0gc2l6ZW9mKHN0cnVjdCBNUEkyX0lPQ19JTklUX1JFUVVFU1QpOworCisJ
cmVxX2Rlc2MgPQorCSAgKHVuaW9uIE1FR0FTQVNfUkVRVUVTVF9ERVNDUklQVE9SX1VOSU9OICop
ZnVzaW9uLT5yZXFfZnJhbWVzX2Rlc2M7CisKKwlyZXFfZGVzYy0+V29yZHMgPSBjbWQtPmZyYW1l
X3BoeXNfYWRkcjsKKwlyZXFfZGVzYy0+TUZBSW8uUmVxdWVzdEZsYWdzID0KKwkJKE1FR0FTQVNf
UkVRX0RFU0NSSVBUX0ZMQUdTX01GQSA8PAorCQkgTUVHQVNBU19SRVFfREVTQ1JJUFRfRkxBR1Nf
VFlQRV9TSElGVCk7CisKKwkvKgorCSAqIGRpc2FibGUgdGhlIGludHIgYmVmb3JlIGZpcmluZyB0
aGUgaW5pdCBmcmFtZQorCSAqLworCWluc3RhbmNlLT5pbnN0YW5jZXQtPmRpc2FibGVfaW50cihp
bnN0YW5jZS0+cmVnX3NldCk7CisKKwlmb3IgKGkgPSAwOyBpIDwgKDEwICogMTAwMCk7IGkgKz0g
MjApIHsKKwkJaWYgKHJlYWRsKCZpbnN0YW5jZS0+cmVnX3NldC0+ZG9vcmJlbGwpICYgMSkKKwkJ
CW1zbGVlcCgyMCk7CisJCWVsc2UKKwkJCWJyZWFrOworCX0KKworCWluc3RhbmNlLT5pbnN0YW5j
ZXQtPmZpcmVfY21kKGluc3RhbmNlLCByZXFfZGVzYy0+dS5sb3csCisJCQkJICAgICAgcmVxX2Rl
c2MtPnUuaGlnaCwgaW5zdGFuY2UtPnJlZ19zZXQpOworCisJd2FpdF9hbmRfcG9sbChpbnN0YW5j
ZSwgY21kKTsKKworCWZyYW1lX2hkciA9ICZjbWQtPmZyYW1lLT5oZHI7CisJaWYgKGZyYW1lX2hk
ci0+Y21kX3N0YXR1cyAhPSAwKSB7CisJCXJldCA9IDE7CisJCWdvdG8gZmFpbF9md19pbml0Owor
CX0KKwlwcmludGsoS0VSTl9FUlIgIm1lZ2FzYXM6SU9DIEluaXQgY21kIHN1Y2Nlc3NcbiIpOwor
CisJcmV0ID0gMDsKKworZmFpbF9md19pbml0OgorCW1lZ2FzYXNfcmV0dXJuX2NtZChpbnN0YW5j
ZSwgY21kKTsKKwlpZiAoSU9DSW5pdE1lc3NhZ2UpCisJCWRtYV9mcmVlX2NvaGVyZW50KCZpbnN0
YW5jZS0+cGRldi0+ZGV2LAorCQkJCSAgc2l6ZW9mKHN0cnVjdCBNUEkyX0lPQ19JTklUX1JFUVVF
U1QpLAorCQkJCSAgSU9DSW5pdE1lc3NhZ2UsIGlvY19pbml0X2hhbmRsZSk7CitmYWlsX2dldF9j
bWQ6CisJcmV0dXJuIHJldDsKK30KKworLyoKKyAqIG1lZ2FzYXNfcmV0dXJuX2NtZF9mb3Jfc21p
ZCAtCVJldHVybnMgYSBjbWRfZnVzaW9uIGZvciBhIFNNSUQKKyAqIEBpbnN0YW5jZToJCQkJQWRh
cHRlciBzb2Z0IHN0YXRlCisgKgorICovCit2b2lkCittZWdhc2FzX3JldHVybl9jbWRfZm9yX3Nt
aWQoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLCB1MTYgc21pZCkKK3sKKwlzdHJ1
Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lvbjsKKwlzdHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9uICpj
bWQ7CisKKwlmdXNpb24gPSBpbnN0YW5jZS0+Y3RybF9jb250ZXh0OworCWNtZCA9IGZ1c2lvbi0+
Y21kX2xpc3Rbc21pZCAtIDFdOworCW1lZ2FzYXNfcmV0dXJuX2NtZF9mdXNpb24oaW5zdGFuY2Us
IGNtZCk7Cit9CisKKy8qCisgKiBtZWdhc2FzX2dldF9sZF9tYXBfaW5mbyAtCVJldHVybnMgRlcn
cyBsZF9tYXAgc3RydWN0dXJlCisgKiBAaW5zdGFuY2U6CQkJCUFkYXB0ZXIgc29mdCBzdGF0ZQor
ICogQHBlbmQ6CQkJCVBlbmQgdGhlIGNvbW1hbmQgb3Igbm90CisgKiBJc3N1ZXMgYW4gaW50ZXJu
YWwgY29tbWFuZCAoRENNRCkgdG8gZ2V0IHRoZSBGVydzIGNvbnRyb2xsZXIgUEQKKyAqIGxpc3Qg
c3RydWN0dXJlLiAgVGhpcyBpbmZvcm1hdGlvbiBpcyBtYWlubHkgdXNlZCB0byBmaW5kIG91dCBT
WVNURU0KKyAqIHN1cHBvcnRlZCBieSB0aGUgRlcuCisgKi8KK3N0YXRpYyBpbnQKK21lZ2FzYXNf
Z2V0X2xkX21hcF9pbmZvKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKK3sKKwlp
bnQgcmV0ID0gMDsKKwlzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZDsKKwlzdHJ1Y3QgbWVnYXNhc19k
Y21kX2ZyYW1lICpkY21kOworCXN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKmNpOworCWRtYV9h
ZGRyX3QgY2lfaCA9IDA7CisJdTMyIHNpemVfbWFwX2luZm87CisJc3RydWN0IGZ1c2lvbl9jb250
ZXh0ICpmdXNpb247CisKKwljbWQgPSBtZWdhc2FzX2dldF9jbWQoaW5zdGFuY2UpOworCisJaWYg
KCFjbWQpIHsKKwkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IEZhaWxlZCB0byBnZXQgY21k
IGZvciBtYXAgaW5mby5cbiIpOworCQlyZXR1cm4gLUVOT01FTTsKKwl9CisKKwlmdXNpb24gPSBp
bnN0YW5jZS0+Y3RybF9jb250ZXh0OworCisJaWYgKCFmdXNpb24pIHsKKwkJbWVnYXNhc19yZXR1
cm5fY21kKGluc3RhbmNlLCBjbWQpOworCQlyZXR1cm4gMTsKKwl9CisKKwlkY21kID0gJmNtZC0+
ZnJhbWUtPmRjbWQ7CisKKwlzaXplX21hcF9pbmZvID0gc2l6ZW9mKHN0cnVjdCBNUl9GV19SQUlE
X01BUCkgKworCQkoc2l6ZW9mKHN0cnVjdCBNUl9MRF9TUEFOX01BUCkgKihNQVhfTE9HSUNBTF9E
UklWRVMgLSAxKSk7CisKKwljaSA9IGZ1c2lvbi0+bGRfbWFwWyhpbnN0YW5jZS0+bWFwX2lkICYg
MSldOworCWNpX2ggPSBmdXNpb24tPmxkX21hcF9waHlzWyhpbnN0YW5jZS0+bWFwX2lkICYgMSld
OworCisJaWYgKCFjaSkgeworCQlwcmludGsoS0VSTl9ERUJVRyAiRmFpbGVkIHRvIGFsbG9jIG1l
bSBmb3IgbGRfbWFwX2luZm9cbiIpOworCQltZWdhc2FzX3JldHVybl9jbWQoaW5zdGFuY2UsIGNt
ZCk7CisJCXJldHVybiAtRU5PTUVNOworCX0KKworCW1lbXNldChjaSwgMCwgc2l6ZW9mKCpjaSkp
OworCW1lbXNldChkY21kLT5tYm94LmIsIDAsIE1GSV9NQk9YX1NJWkUpOworCisJZGNtZC0+Y21k
ID0gTUZJX0NNRF9EQ01EOworCWRjbWQtPmNtZF9zdGF0dXMgPSAweEZGOworCWRjbWQtPnNnZV9j
b3VudCA9IDE7CisJZGNtZC0+ZmxhZ3MgPSBNRklfRlJBTUVfRElSX1JFQUQ7CisJZGNtZC0+dGlt
ZW91dCA9IDA7CisJZGNtZC0+cGFkXzAgPSAwOworCWRjbWQtPmRhdGFfeGZlcl9sZW4gPSBzaXpl
X21hcF9pbmZvOworCWRjbWQtPm9wY29kZSA9IE1SX0RDTURfTERfTUFQX0dFVF9JTkZPOworCWRj
bWQtPnNnbC5zZ2UzMlswXS5waHlzX2FkZHIgPSBjaV9oOworCWRjbWQtPnNnbC5zZ2UzMlswXS5s
ZW5ndGggPSBzaXplX21hcF9pbmZvOworCisJaWYgKCFtZWdhc2FzX2lzc3VlX3BvbGxlZChpbnN0
YW5jZSwgY21kKSkKKwkJcmV0ID0gMDsKKwllbHNlIHsKKwkJcHJpbnRrKEtFUk5fRVJSICJtZWdh
c2FzOiBHZXQgTEQgTWFwIEluZm8gRmFpbGVkXG4iKTsKKwkJcmV0ID0gLTE7CisJfQorCisJbWVn
YXNhc19yZXR1cm5fY21kKGluc3RhbmNlLCBjbWQpOworCisJcmV0dXJuIHJldDsKK30KKwordTgK
K21lZ2FzYXNfZ2V0X21hcF9pbmZvKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkK
K3sKKwlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lvbiA9IGluc3RhbmNlLT5jdHJsX2NvbnRl
eHQ7CisKKwlmdXNpb24tPmZhc3RfcGF0aF9pbyA9IDA7CisJaWYgKCFtZWdhc2FzX2dldF9sZF9t
YXBfaW5mbyhpbnN0YW5jZSkpIHsKKwkJaWYgKE1SX1ZhbGlkYXRlTWFwSW5mbyhmdXNpb24tPmxk
X21hcFsoaW5zdGFuY2UtPm1hcF9pZCAmIDEpXSwKKwkJCQkgICAgICAgZnVzaW9uLT5sb2FkX2Jh
bGFuY2VfaW5mbykpIHsKKwkJCWZ1c2lvbi0+ZmFzdF9wYXRoX2lvID0gMTsKKwkJCXJldHVybiAw
OworCQl9CisJfQorCXJldHVybiAxOworfQorCisvKgorICogbWVnYXNhc19zeW5jX21hcF9pbmZv
IC0JUmV0dXJucyBGVydzIGxkX21hcCBzdHJ1Y3R1cmUKKyAqIEBpbnN0YW5jZToJCQkJQWRhcHRl
ciBzb2Z0IHN0YXRlCisgKgorICogSXNzdWVzIGFuIGludGVybmFsIGNvbW1hbmQgKERDTUQpIHRv
IGdldCB0aGUgRlcncyBjb250cm9sbGVyIFBECisgKiBsaXN0IHN0cnVjdHVyZS4gIFRoaXMgaW5m
b3JtYXRpb24gaXMgbWFpbmx5IHVzZWQgdG8gZmluZCBvdXQgU1lTVEVNCisgKiBzdXBwb3J0ZWQg
YnkgdGhlIEZXLgorICovCitpbnQKK21lZ2FzYXNfc3luY19tYXBfaW5mbyhzdHJ1Y3QgbWVnYXNh
c19pbnN0YW5jZSAqaW5zdGFuY2UpCit7CisJaW50IHJldCA9IDAsIGk7CisJc3RydWN0IG1lZ2Fz
YXNfY21kICpjbWQ7CisJc3RydWN0IG1lZ2FzYXNfZGNtZF9mcmFtZSAqZGNtZDsKKwl1MzIgc2l6
ZV9zeW5jX2luZm8sIG51bV9sZHM7CisJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb247CisJ
c3RydWN0IE1SX0xEX1RBUkdFVF9TWU5DICpjaSA9IE5VTEw7CisJc3RydWN0IE1SX0ZXX1JBSURf
TUFQX0FMTCAqbWFwOworCXN0cnVjdCBNUl9MRF9SQUlEICAqcmFpZDsKKwlzdHJ1Y3QgTVJfTERf
VEFSR0VUX1NZTkMgKmxkX3N5bmM7CisJZG1hX2FkZHJfdCBjaV9oID0gMDsKKwl1MzIgc2l6ZV9t
YXBfaW5mbzsKKworCWNtZCA9IG1lZ2FzYXNfZ2V0X2NtZChpbnN0YW5jZSk7CisKKwlpZiAoIWNt
ZCkgeworCQlwcmludGsoS0VSTl9ERUJVRyAibWVnYXNhczogRmFpbGVkIHRvIGdldCBjbWQgZm9y
IHN5bmMiCisJCSAgICAgICAiaW5mby5cbiIpOworCQlyZXR1cm4gLUVOT01FTTsKKwl9CisKKwlm
dXNpb24gPSBpbnN0YW5jZS0+Y3RybF9jb250ZXh0OworCisJaWYgKCFmdXNpb24pIHsKKwkJbWVn
YXNhc19yZXR1cm5fY21kKGluc3RhbmNlLCBjbWQpOworCQlyZXR1cm4gMTsKKwl9CisKKwltYXAg
PSBmdXNpb24tPmxkX21hcFtpbnN0YW5jZS0+bWFwX2lkICYgMV07CisKKwludW1fbGRzID0gbWFw
LT5yYWlkTWFwLmxkQ291bnQ7CisKKwlkY21kID0gJmNtZC0+ZnJhbWUtPmRjbWQ7CisKKwlzaXpl
X3N5bmNfaW5mbyA9IHNpemVvZihzdHJ1Y3QgTVJfTERfVEFSR0VUX1NZTkMpICpudW1fbGRzOwor
CisJbWVtc2V0KGRjbWQtPm1ib3guYiwgMCwgTUZJX01CT1hfU0laRSk7CisKKwljaSA9IChzdHJ1
Y3QgTVJfTERfVEFSR0VUX1NZTkMgKikKKwkgIGZ1c2lvbi0+bGRfbWFwWyhpbnN0YW5jZS0+bWFw
X2lkIC0gMSkgJiAxXTsKKwltZW1zZXQoY2ksIDAsIHNpemVvZihzdHJ1Y3QgTVJfRldfUkFJRF9N
QVBfQUxMKSk7CisKKwljaV9oID0gZnVzaW9uLT5sZF9tYXBfcGh5c1soaW5zdGFuY2UtPm1hcF9p
ZCAtIDEpICYgMV07CisKKwlsZF9zeW5jID0gKHN0cnVjdCBNUl9MRF9UQVJHRVRfU1lOQyAqKWNp
OworCisJZm9yIChpID0gMDsgaSA8IG51bV9sZHM7IGkrKywgbGRfc3luYysrKSB7CisJCXJhaWQg
PSBNUl9MZFJhaWRHZXQoaSwgbWFwKTsKKwkJbGRfc3luYy0+dGFyZ2V0SWQgPSBNUl9HZXRMRFRn
dElkKGksIG1hcCk7CisJCWxkX3N5bmMtPnNlcU51bSA9IHJhaWQtPnNlcU51bTsKKwl9CisKKwlz
aXplX21hcF9pbmZvID0gc2l6ZW9mKHN0cnVjdCBNUl9GV19SQUlEX01BUCkgKworCQkoc2l6ZW9m
KHN0cnVjdCBNUl9MRF9TUEFOX01BUCkgKihNQVhfTE9HSUNBTF9EUklWRVMgLSAxKSk7CisKKwlk
Y21kLT5jbWQgPSBNRklfQ01EX0RDTUQ7CisJZGNtZC0+Y21kX3N0YXR1cyA9IDB4RkY7CisJZGNt
ZC0+c2dlX2NvdW50ID0gMTsKKwlkY21kLT5mbGFncyA9IE1GSV9GUkFNRV9ESVJfV1JJVEU7CisJ
ZGNtZC0+dGltZW91dCA9IDA7CisJZGNtZC0+cGFkXzAgPSAwOworCWRjbWQtPmRhdGFfeGZlcl9s
ZW4gPSBzaXplX21hcF9pbmZvOworCWRjbWQtPm1ib3guYlswXSA9IG51bV9sZHM7CisJZGNtZC0+
bWJveC5iWzFdID0gTUVHQVNBU19EQ01EX01CT1hfUEVORF9GTEFHOworCWRjbWQtPm9wY29kZSA9
IE1SX0RDTURfTERfTUFQX0dFVF9JTkZPOworCWRjbWQtPnNnbC5zZ2UzMlswXS5waHlzX2FkZHIg
PSBjaV9oOworCWRjbWQtPnNnbC5zZ2UzMlswXS5sZW5ndGggPSBzaXplX21hcF9pbmZvOworCisJ
aW5zdGFuY2UtPm1hcF91cGRhdGVfY21kID0gY21kOworCisJaW5zdGFuY2UtPmluc3RhbmNldC0+
aXNzdWVfZGNtZChpbnN0YW5jZSwgY21kKTsKKworCXJldHVybiByZXQ7Cit9CisKKy8qKgorICog
bWVnYXNhc19pbml0X2FkYXB0ZXJfZnVzaW9uIC0JSW5pdGlhbGl6ZXMgdGhlIEZXCisgKiBAaW5z
dGFuY2U6CQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAqCisgKiBUaGlzIGlzIHRoZSBtYWluIGZ1bmN0
aW9uIGZvciBpbml0aWFsaXppbmcgZmlybXdhcmUuCisgKi8KK3UzMgorbWVnYXNhc19pbml0X2Fk
YXB0ZXJfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKK3sKKwlzdHJ1
Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVnX3NldDsKKwlzdHJ1Y3QgZnVzaW9u
X2NvbnRleHQgKmZ1c2lvbjsKKwl1MzIgbWF4X2NtZDsKKwlpbnQgaSA9IDA7CisKKwlmdXNpb24g
PSBpbnN0YW5jZS0+Y3RybF9jb250ZXh0OworCisJcmVnX3NldCA9IGluc3RhbmNlLT5yZWdfc2V0
OworCisJLyoKKwkgKiBHZXQgdmFyaW91cyBvcGVyYXRpb25hbCBwYXJhbWV0ZXJzIGZyb20gc3Rh
dHVzIHJlZ2lzdGVyCisJICovCisJaW5zdGFuY2UtPm1heF9md19jbWRzID0KKwkJaW5zdGFuY2Ut
Pmluc3RhbmNldC0+cmVhZF9md19zdGF0dXNfcmVnKHJlZ19zZXQpICYgMHgwMEZGRkY7CisJaW5z
dGFuY2UtPm1heF9md19jbWRzID0gbWluKGluc3RhbmNlLT5tYXhfZndfY21kcywgKHUxNikxMDA4
KTsKKworCS8qCisJICogUmVkdWNlIHRoZSBtYXggc3VwcG9ydGVkIGNtZHMgYnkgMS4gVGhpcyBp
cyB0byBlbnN1cmUgdGhhdCB0aGUKKwkgKiByZXBseV9xX3N6ICgxIG1vcmUgdGhhbiB0aGUgbWF4
IGNtZCB0aGF0IGRyaXZlciBtYXkgc2VuZCkKKwkgKiBkb2VzIG5vdCBleGNlZWQgbWF4IGNtZHMg
dGhhdCB0aGUgRlcgY2FuIHN1cHBvcnQKKwkgKi8KKwlpbnN0YW5jZS0+bWF4X2Z3X2NtZHMgPSBp
bnN0YW5jZS0+bWF4X2Z3X2NtZHMtMTsKKwkvKiBPbmx5IGludGVybmFsIGNtZHMgKERDTUQpIG5l
ZWQgdG8gaGF2ZSBNRkkgZnJhbWVzICovCisJaW5zdGFuY2UtPm1heF9tZmlfY21kcyA9IE1FR0FT
QVNfSU5UX0NNRFM7CisKKwltYXhfY21kID0gaW5zdGFuY2UtPm1heF9md19jbWRzOworCisJZnVz
aW9uLT5yZXBseV9xX2RlcHRoID0gKChtYXhfY21kICsgMSArIDE1KS8xNikqMTY7CisKKwlmdXNp
b24tPnJlcXVlc3RfYWxsb2Nfc3ogPQorCQlzaXplb2YodW5pb24gTUVHQVNBU19SRVFVRVNUX0RF
U0NSSVBUT1JfVU5JT04pICptYXhfY21kOworCWZ1c2lvbi0+cmVwbHlfYWxsb2Nfc3ogPSBzaXpl
b2YodW5pb24gTVBJMl9SRVBMWV9ERVNDUklQVE9SU19VTklPTikKKwkJKihmdXNpb24tPnJlcGx5
X3FfZGVwdGgpOworCWZ1c2lvbi0+aW9fZnJhbWVzX2FsbG9jX3N6ID0gTUVHQV9NUEkyX1JBSURf
REVGQVVMVF9JT19GUkFNRV9TSVpFICsKKwkJKE1FR0FfTVBJMl9SQUlEX0RFRkFVTFRfSU9fRlJB
TUVfU0laRSAqCisJCSAobWF4X2NtZCArIDEpKTsgLyogRXh0cmEgMSBmb3IgU01JRCAwICovCisK
KwlmdXNpb24tPm1heF9zZ2VfaW5fbWFpbl9tc2cgPQorCSAgKE1FR0FfTVBJMl9SQUlEX0RFRkFV
TFRfSU9fRlJBTUVfU0laRSAtCisJICAgb2Zmc2V0b2Yoc3RydWN0IE1QSTJfUkFJRF9TQ1NJX0lP
X1JFUVVFU1QsIFNHTCkpLzE2OworCisJZnVzaW9uLT5tYXhfc2dlX2luX2NoYWluID0KKwkJTUVH
QVNBU19NQVhfU1pfQ0hBSU5fRlJBTUUgLyBzaXplb2YodW5pb24gTVBJMl9TR0VfSU9fVU5JT04p
OworCisJaW5zdGFuY2UtPm1heF9udW1fc2dlID0gZnVzaW9uLT5tYXhfc2dlX2luX21haW5fbXNn
ICsKKwkJZnVzaW9uLT5tYXhfc2dlX2luX2NoYWluIC0gMjsKKworCS8qIFVzZWQgZm9yIHBhc3Mg
dGhydSBNRkkgZnJhbWUgKERDTUQpICovCisJZnVzaW9uLT5jaGFpbl9vZmZzZXRfbWZpX3B0aHJ1
ID0KKwkJb2Zmc2V0b2Yoc3RydWN0IE1QSTJfUkFJRF9TQ1NJX0lPX1JFUVVFU1QsIFNHTCkvMTY7
CisKKwlmdXNpb24tPmNoYWluX29mZnNldF9pb19yZXF1ZXN0ID0KKwkJKE1FR0FfTVBJMl9SQUlE
X0RFRkFVTFRfSU9fRlJBTUVfU0laRSAtCisJCSBzaXplb2YodW5pb24gTVBJMl9TR0VfSU9fVU5J
T04pKS8xNjsKKworCWZ1c2lvbi0+bGFzdF9yZXBseV9pZHggPSAwOworCisJLyoKKwkgKiBBbGxv
Y2F0ZSBtZW1vcnkgZm9yIGRlc2NyaXB0b3JzCisJICogQ3JlYXRlIGEgcG9vbCBvZiBjb21tYW5k
cworCSAqLworCWlmIChtZWdhc2FzX2FsbG9jX2NtZHMoaW5zdGFuY2UpKQorCQlnb3RvIGZhaWxf
YWxsb2NfbWZpX2NtZHM7CisJaWYgKG1lZ2FzYXNfYWxsb2NfY21kc19mdXNpb24oaW5zdGFuY2Up
KQorCQlnb3RvIGZhaWxfYWxsb2NfY21kczsKKworCWlmIChtZWdhc2FzX2lvY19pbml0X2Z1c2lv
bihpbnN0YW5jZSkpCisJCWdvdG8gZmFpbF9pb2NfaW5pdDsKKworCWluc3RhbmNlLT5mbGFnX2ll
ZWUgPSAxOworCisJZnVzaW9uLT5tYXBfc3ogPSAgc2l6ZW9mKHN0cnVjdCBNUl9GV19SQUlEX01B
UCkgKworCSAgKHNpemVvZihzdHJ1Y3QgTVJfTERfU1BBTl9NQVApICooTUFYX0xPR0lDQUxfRFJJ
VkVTIC0gMSkpOworCisJZnVzaW9uLT5mYXN0X3BhdGhfaW8gPSAwOworCisJZm9yIChpID0gMDsg
aSA8IDI7IGkrKykgeworCQlmdXNpb24tPmxkX21hcFtpXSA9IGRtYV9hbGxvY19jb2hlcmVudCgm
aW5zdGFuY2UtPnBkZXYtPmRldiwKKwkJCQkJCSAgICAgICBmdXNpb24tPm1hcF9zeiwKKwkJCQkJ
CSAgICAgICAmZnVzaW9uLT5sZF9tYXBfcGh5c1tpXSwKKwkJCQkJCSAgICAgICBHRlBfS0VSTkVM
KTsKKwkJaWYgKCFmdXNpb24tPmxkX21hcFtpXSkgeworCQkJcHJpbnRrKEtFUk5fRVJSICJtZWdh
c2FzOiBDb3VsZCBub3QgYWxsb2NhdGUgbWVtb3J5ICIKKwkJCSAgICAgICAiZm9yIG1hcCBpbmZv
XG4iKTsKKwkJCWdvdG8gZmFpbF9tYXBfaW5mbzsKKwkJfQorCX0KKworCWlmICghbWVnYXNhc19n
ZXRfbWFwX2luZm8oaW5zdGFuY2UpKQorCQltZWdhc2FzX3N5bmNfbWFwX2luZm8oaW5zdGFuY2Up
OworCisJcmV0dXJuIDA7CisKK2ZhaWxfYWxsb2NfY21kczoKK2ZhaWxfYWxsb2NfbWZpX2NtZHM6
CitmYWlsX21hcF9pbmZvOgorCWlmIChpID09IDEpCisJCWRtYV9mcmVlX2NvaGVyZW50KCZpbnN0
YW5jZS0+cGRldi0+ZGV2LCBmdXNpb24tPm1hcF9zeiwKKwkJCQkgIGZ1c2lvbi0+bGRfbWFwWzBd
LCBmdXNpb24tPmxkX21hcF9waHlzWzBdKTsKK2ZhaWxfaW9jX2luaXQ6CisJcmV0dXJuIDE7Cit9
CisKKy8qKgorICogbWVnYXNhc19maXJlX2NtZF9mdXNpb24gLQlTZW5kcyBjb21tYW5kIHRvIHRo
ZSBGVworICogQGZyYW1lX3BoeXNfYWRkciA6CQlQaHlzaWNhbCBhZGRyZXNzIG9mIGNtZAorICog
QGZyYW1lX2NvdW50IDoJCU51bWJlciBvZiBmcmFtZXMgZm9yIHRoZSBjb21tYW5kCisgKiBAcmVn
cyA6CQkJTUZJIHJlZ2lzdGVyIHNldAorICovCit2b2lkCittZWdhc2FzX2ZpcmVfY21kX2Z1c2lv
bihzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsCisJCQlkbWFfYWRkcl90IHJlcV9k
ZXNjX2xvLAorCQkJdTMyIHJlcV9kZXNjX2hpLAorCQkJc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJf
c2V0IF9faW9tZW0gKnJlZ3MpCit7CisJdW5zaWduZWQgbG9uZyBmbGFnczsKKworCXNwaW5fbG9j
a19pcnFzYXZlKCZpbnN0YW5jZS0+aGJhX2xvY2ssIGZsYWdzKTsKKworCXdyaXRlbChyZXFfZGVz
Y19sbywKKwkgICAgICAgJihyZWdzKS0+aW5ib3VuZF9sb3dfcXVldWVfcG9ydCk7CisJd3JpdGVs
KHJlcV9kZXNjX2hpLCAmKHJlZ3MpLT5pbmJvdW5kX2hpZ2hfcXVldWVfcG9ydCk7CisJc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgmaW5zdGFuY2UtPmhiYV9sb2NrLCBmbGFncyk7Cit9CisKKy8qKgor
ICogbWFwX2NtZF9zdGF0dXMgLQlNYXBzIEZXIGNtZCBzdGF0dXMgdG8gT1MgY21kIHN0YXR1cwor
ICogQGNtZCA6CQlQb2ludGVyIHRvIGNtZAorICogQHN0YXR1cyA6CQlzdGF0dXMgb2YgY21kIHJl
dHVybmVkIGJ5IEZXCisgKiBAZXh0X3N0YXR1cyA6CWV4dCBzdGF0dXMgb2YgY21kIHJldHVybmVk
IGJ5IEZXCisgKi8KKwordm9pZAorbWFwX2NtZF9zdGF0dXMoc3RydWN0IG1lZ2FzYXNfY21kX2Z1
c2lvbiAqY21kLCB1OCBzdGF0dXMsIHU4IGV4dF9zdGF0dXMpCit7CisKKwlzd2l0Y2ggKHN0YXR1
cykgeworCisJY2FzZSBNRklfU1RBVF9PSzoKKwkJY21kLT5zY21kLT5yZXN1bHQgPSBESURfT0sg
PDwgMTY7CisJCWJyZWFrOworCisJY2FzZSBNRklfU1RBVF9TQ1NJX0lPX0ZBSUxFRDoKKwljYXNl
IE1GSV9TVEFUX0xEX0lOSVRfSU5fUFJPR1JFU1M6CisJCWNtZC0+c2NtZC0+cmVzdWx0ID0gKERJ
RF9FUlJPUiA8PCAxNikgfCBleHRfc3RhdHVzOworCQlicmVhazsKKworCWNhc2UgTUZJX1NUQVRf
U0NTSV9ET05FX1dJVEhfRVJST1I6CisKKwkJY21kLT5zY21kLT5yZXN1bHQgPSAoRElEX09LIDw8
IDE2KSB8IGV4dF9zdGF0dXM7CisJCWlmIChleHRfc3RhdHVzID09IFNBTV9TVEFUX0NIRUNLX0NP
TkRJVElPTikgeworCQkJbWVtc2V0KGNtZC0+c2NtZC0+c2Vuc2VfYnVmZmVyLCAwLAorCQkJICAg
ICAgIFNDU0lfU0VOU0VfQlVGRkVSU0laRSk7CisJCQltZW1jcHkoY21kLT5zY21kLT5zZW5zZV9i
dWZmZXIsIGNtZC0+c2Vuc2UsCisJCQkgICAgICAgU0NTSV9TRU5TRV9CVUZGRVJTSVpFKTsKKwkJ
CWNtZC0+c2NtZC0+cmVzdWx0IHw9IERSSVZFUl9TRU5TRSA8PCAyNDsKKwkJfQorCQlicmVhazsK
KworCWNhc2UgTUZJX1NUQVRfTERfT0ZGTElORToKKwljYXNlIE1GSV9TVEFUX0RFVklDRV9OT1Rf
Rk9VTkQ6CisJCWNtZC0+c2NtZC0+cmVzdWx0ID0gRElEX0JBRF9UQVJHRVQgPDwgMTY7CisJCWJy
ZWFrOworCisJZGVmYXVsdDoKKwkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IEZXIHN0YXR1
cyAlI3hcbiIsIHN0YXR1cyk7CisJCWNtZC0+c2NtZC0+cmVzdWx0ID0gRElEX0VSUk9SIDw8IDE2
OworCQlicmVhazsKKwl9Cit9CisKKy8qKgorICogbWVnYXNhc19tYWtlX3NnbF9mdXNpb24gLQlQ
cmVwYXJlcyAzMi1iaXQgU0dMCisgKiBAaW5zdGFuY2U6CQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAq
IEBzY3A6CQlTQ1NJIGNvbW1hbmQgZnJvbSB0aGUgbWlkLWxheWVyCisgKiBAc2dsX3B0cjoJCVNH
TCB0byBiZSBmaWxsZWQgaW4KKyAqIEBjbWQ6CQljbWQgd2UgYXJlIHdvcmtpbmcgb24KKyAqCisg
KiBJZiBzdWNjZXNzZnVsLCB0aGlzIGZ1bmN0aW9uIHJldHVybnMgdGhlIG51bWJlciBvZiBTRyBl
bGVtZW50cy4KKyAqLworc3RhdGljIGludAorbWVnYXNhc19tYWtlX3NnbF9mdXNpb24oc3RydWN0
IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAorCQkJc3RydWN0IHNjc2lfY21uZCAqc2NwLAor
CQkJc3RydWN0IE1QSTI1X0lFRUVfU0dFX0NIQUlONjQgKnNnbF9wdHIsCisJCQlzdHJ1Y3QgbWVn
YXNhc19jbWRfZnVzaW9uICpjbWQpCit7CisJaW50IGksIHNnX3Byb2Nlc3NlZDsKKwlpbnQgc2dl
X2NvdW50LCBzZ2VfaWR4OworCXN0cnVjdCBzY2F0dGVybGlzdCAqb3Nfc2dsOworCXN0cnVjdCBm
dXNpb25fY29udGV4dCAqZnVzaW9uOworCisJZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxfY29udGV4
dDsKKworCWNtZC0+aW9fcmVxdWVzdC0+Q2hhaW5PZmZzZXQgPSAwOworCisJc2dlX2NvdW50ID0g
c2NzaV9kbWFfbWFwKHNjcCk7CisKKwlCVUdfT04oc2dlX2NvdW50IDwgMCk7CisKKwlpZiAoc2dl
X2NvdW50ID4gaW5zdGFuY2UtPm1heF9udW1fc2dlIHx8ICFzZ2VfY291bnQpCisJCXJldHVybiBz
Z2VfY291bnQ7CisKKwlpZiAoc2dlX2NvdW50ID4gZnVzaW9uLT5tYXhfc2dlX2luX21haW5fbXNn
KSB7CisJCS8qIE9uZSBlbGVtZW50IHRvIHN0b3JlIHRoZSBjaGFpbiBpbmZvICovCisJCXNnZV9p
ZHggPSBmdXNpb24tPm1heF9zZ2VfaW5fbWFpbl9tc2cgLSAxOworCX0gZWxzZQorCQlzZ2VfaWR4
ID0gc2dlX2NvdW50OworCisJc2NzaV9mb3JfZWFjaF9zZyhzY3AsIG9zX3NnbCwgc2dlX2NvdW50
LCBpKSB7CisJCXNnbF9wdHItPkxlbmd0aCA9IHNnX2RtYV9sZW4ob3Nfc2dsKTsKKwkJc2dsX3B0
ci0+QWRkcmVzcyA9IHNnX2RtYV9hZGRyZXNzKG9zX3NnbCk7CisJCXNnbF9wdHItPkZsYWdzID0g
MDsKKwkJc2dsX3B0cisrOworCisJCXNnX3Byb2Nlc3NlZCA9IGkgKyAxOworCisJCWlmICgoc2df
cHJvY2Vzc2VkID09ICAoZnVzaW9uLT5tYXhfc2dlX2luX21haW5fbXNnIC0gMSkpICYmCisJCSAg
ICAoc2dlX2NvdW50ID4gZnVzaW9uLT5tYXhfc2dlX2luX21haW5fbXNnKSkgeworCisJCQlzdHJ1
Y3QgTVBJMjVfSUVFRV9TR0VfQ0hBSU42NCAqc2dfY2hhaW47CisJCQljbWQtPmlvX3JlcXVlc3Qt
PkNoYWluT2Zmc2V0ID0KKwkJCQlmdXNpb24tPmNoYWluX29mZnNldF9pb19yZXF1ZXN0OworCQkJ
c2dfY2hhaW4gPSBzZ2xfcHRyOworCQkJLyogUHJlcGFyZSBjaGFpbiBlbGVtZW50ICovCisJCQlz
Z19jaGFpbi0+TmV4dENoYWluT2Zmc2V0ID0gMDsKKwkJCXNnX2NoYWluLT5GbGFncyA9IChJRUVF
X1NHRV9GTEFHU19DSEFJTl9FTEVNRU5UIHwKKwkJCQkJICAgTVBJMl9JRUVFX1NHRV9GTEFHU19J
T0NQTEJOVEFfQUREUik7CisJCQlzZ19jaGFpbi0+TGVuZ3RoID0gIChzaXplb2YodW5pb24gTVBJ
Ml9TR0VfSU9fVU5JT04pCisJCQkJCSAgICAgKihzZ2VfY291bnQgLSBzZ19wcm9jZXNzZWQpKTsK
KwkJCXNnX2NoYWluLT5BZGRyZXNzID0gY21kLT5zZ19mcmFtZV9waHlzX2FkZHI7CisKKwkJCXNn
bF9wdHIgPQorCQkJICAoc3RydWN0IE1QSTI1X0lFRUVfU0dFX0NIQUlONjQgKiljbWQtPnNnX2Zy
YW1lOworCQl9CisJfQorCisJcmV0dXJuIHNnZV9jb3VudDsKK30KKworLyoqCisgKiBtZWdhc2Fz
X3NldF9wZF9sYmEgLQlTZXRzIFBEIExCQQorICogQGNkYjoJCUNEQgorICogQGNkYl9sZW46CQlj
ZGIgbGVuZ3RoCisgKiBAc3RhcnRfYmxrOgkJU3RhcnQgYmxvY2sgb2YgSU8KKyAqCisgKiBVc2Vk
IHRvIHNldCB0aGUgUEQgTEJBIGluIENEQiBmb3IgRlAgSU9zCisgKi8KK3ZvaWQKK21lZ2FzYXNf
c2V0X3BkX2xiYShzdHJ1Y3QgTVBJMl9SQUlEX1NDU0lfSU9fUkVRVUVTVCAqaW9fcmVxdWVzdCwg
dTggY2RiX2xlbiwKKwkJICAgc3RydWN0IElPX1JFUVVFU1RfSU5GTyAqaW9faW5mbywgc3RydWN0
IHNjc2lfY21uZCAqc2NwLAorCQkgICBzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICpsb2NhbF9t
YXBfcHRyLCB1MzIgcmVmX3RhZykKK3sKKwlzdHJ1Y3QgTVJfTERfUkFJRCAqcmFpZDsKKwl1MzIg
bGQ7CisJdTY0IHN0YXJ0X2JsayA9IGlvX2luZm8tPnBkQmxvY2s7CisJdTggKmNkYiA9IGlvX3Jl
cXVlc3QtPkNEQi5DREIzMjsKKwl1MzIgbnVtX2Jsb2NrcyA9IGlvX2luZm8tPm51bUJsb2NrczsK
Kwl1OCBvcGNvZGUsIGZsYWd2YWxzLCBncm91cG51bSwgY29udHJvbDsKKworCS8qIENoZWNrIGlm
IFQxMCBQSSAoRElGKSBpcyBlbmFibGVkIGZvciB0aGlzIExEICovCisJbGQgPSBNUl9UYXJnZXRJ
ZFRvTGRHZXQoaW9faW5mby0+bGRUZ3RJZCwgbG9jYWxfbWFwX3B0cik7CisJcmFpZCA9IE1SX0xk
UmFpZEdldChsZCwgbG9jYWxfbWFwX3B0cik7CisJaWYgKHJhaWQtPmNhcGFiaWxpdHkubGRQaU1v
ZGUgPT0gTVJfUFJPVF9JTkZPX1RZUEVfQ09OVFJPTExFUikgeworCQltZW1zZXQoY2RiLCAwLCBz
aXplb2YoaW9fcmVxdWVzdC0+Q0RCLkNEQjMyKSk7CisJCWNkYlswXSA9ICBNRUdBU0FTX1NDU0lf
VkFSSUFCTEVfTEVOR1RIX0NNRDsKKwkJY2RiWzddID0gIE1FR0FTQVNfU0NTSV9BRERMX0NEQl9M
RU47CisKKwkJaWYgKHNjcC0+c2NfZGF0YV9kaXJlY3Rpb24gPT0gUENJX0RNQV9GUk9NREVWSUNF
KQorCQkJY2RiWzldID0gTUVHQVNBU19TQ1NJX1NFUlZJQ0VfQUNUSU9OX1JFQUQzMjsKKwkJZWxz
ZQorCQkJY2RiWzldID0gTUVHQVNBU19TQ1NJX1NFUlZJQ0VfQUNUSU9OX1dSSVRFMzI7CisJCWNk
YlsxMF0gPSBNRUdBU0FTX1JEX1dSX1BST1RFQ1RfQ0hFQ0tfQUxMOworCisJCS8qIExCQSAqLwor
CQljZGJbMTJdID0gKHU4KSgoc3RhcnRfYmxrID4+IDU2KSAmIDB4ZmYpOworCQljZGJbMTNdID0g
KHU4KSgoc3RhcnRfYmxrID4+IDQ4KSAmIDB4ZmYpOworCQljZGJbMTRdID0gKHU4KSgoc3RhcnRf
YmxrID4+IDQwKSAmIDB4ZmYpOworCQljZGJbMTVdID0gKHU4KSgoc3RhcnRfYmxrID4+IDMyKSAm
IDB4ZmYpOworCQljZGJbMTZdID0gKHU4KSgoc3RhcnRfYmxrID4+IDI0KSAmIDB4ZmYpOworCQlj
ZGJbMTddID0gKHU4KSgoc3RhcnRfYmxrID4+IDE2KSAmIDB4ZmYpOworCQljZGJbMThdID0gKHU4
KSgoc3RhcnRfYmxrID4+IDgpICYgMHhmZik7CisJCWNkYlsxOV0gPSAodTgpKHN0YXJ0X2JsayAm
IDB4ZmYpOworCisJCS8qIExvZ2ljYWwgYmxvY2sgcmVmZXJlbmNlIHRhZyAqLworCQlpb19yZXF1
ZXN0LT5DREIuRUVEUDMyLlByaW1hcnlSZWZlcmVuY2VUYWcgPQorCQkJY3B1X3RvX2JlMzIocmVm
X3RhZyk7CisJCWlvX3JlcXVlc3QtPkNEQi5FRURQMzIuUHJpbWFyeUFwcGxpY2F0aW9uVGFnTWFz
ayA9IDB4ZmZmZjsKKworCQlpb19yZXF1ZXN0LT5EYXRhTGVuZ3RoID0gbnVtX2Jsb2NrcyAqIDUx
MjsKKwkJaW9fcmVxdWVzdC0+SW9GbGFncyA9IDMyOyAvKiBTcGVjaWZ5IDMyLWJ5dGUgY2RiICov
CisKKwkJLyogVHJhbnNmZXIgbGVuZ3RoICovCisJCWNkYlsyOF0gPSAodTgpKChudW1fYmxvY2tz
ID4+IDI0KSAmIDB4ZmYpOworCQljZGJbMjldID0gKHU4KSgobnVtX2Jsb2NrcyA+PiAxNikgJiAw
eGZmKTsKKwkJY2RiWzMwXSA9ICh1OCkoKG51bV9ibG9ja3MgPj4gOCkgJiAweGZmKTsKKwkJY2Ri
WzMxXSA9ICh1OCkobnVtX2Jsb2NrcyAmIDB4ZmYpOworCisJCS8qIHNldCBTQ1NJIElPIEVFRFBG
bGFncyAqLworCQlpZiAoc2NwLT5zY19kYXRhX2RpcmVjdGlvbiA9PSBQQ0lfRE1BX0ZST01ERVZJ
Q0UpIHsKKwkJCWlvX3JlcXVlc3QtPkVFRFBGbGFncyA9CisJCQkJTVBJMl9TQ1NJSU9fRUVEUEZM
QUdTX0lOQ19QUklfUkVGVEFHICB8CisJCQkJTVBJMl9TQ1NJSU9fRUVEUEZMQUdTX0NIRUNLX1JF
RlRBRyB8CisJCQkJTVBJMl9TQ1NJSU9fRUVEUEZMQUdTX0NIRUNLX1JFTU9WRV9PUCB8CisJCQkJ
TVBJMl9TQ1NJSU9fRUVEUEZMQUdTX0NIRUNLX0FQUFRBRyB8CisJCQkJTVBJMl9TQ1NJSU9fRUVE
UEZMQUdTX0NIRUNLX0dVQVJEOworCQl9IGVsc2UgeworCQkJaW9fcmVxdWVzdC0+RUVEUEZsYWdz
ID0KKwkJCQlNUEkyX1NDU0lJT19FRURQRkxBR1NfSU5DX1BSSV9SRUZUQUcgfAorCQkJCU1QSTJf
U0NTSUlPX0VFRFBGTEFHU19JTlNFUlRfT1A7CisJCX0KKwkJaW9fcmVxdWVzdC0+Q29udHJvbCB8
PSAoMHg0IDw8IDI2KTsKKwkJaW9fcmVxdWVzdC0+RUVEUEJsb2NrU2l6ZSA9IE1FR0FTQVNfRUVE
UEJMT0NLU0laRTsKKwl9IGVsc2UgeworCQkvKiBTb21lIGRyaXZlcyBkb24ndCBzdXBwb3J0IDE2
LzEyIGJ5dGUgQ0RCJ3MsIGNvbnZlcnQgdG8gMTAgKi8KKwkJaWYgKCgoY2RiX2xlbiA9PSAxMikg
fHwgKGNkYl9sZW4gPT0gMTYpKSAmJgorCQkgICAgKHN0YXJ0X2JsayA8PSAweGZmZmZmZmZmKSkg
eworCQkJaWYgKGNkYl9sZW4gPT0gMTYpIHsKKwkJCQlvcGNvZGUgPSBjZGJbMF0gPT0gUkVBRF8x
NiA/IFJFQURfMTAgOiBXUklURV8xMDsKKwkJCQlmbGFndmFscyA9IGNkYlsxXTsKKwkJCQlncm91
cG51bSA9IGNkYlsxNF07CisJCQkJY29udHJvbCA9IGNkYlsxNV07CisJCQl9IGVsc2UgeworCQkJ
CW9wY29kZSA9IGNkYlswXSA9PSBSRUFEXzEyID8gUkVBRF8xMCA6IFdSSVRFXzEwOworCQkJCWZs
YWd2YWxzID0gY2RiWzFdOworCQkJCWdyb3VwbnVtID0gY2RiWzEwXTsKKwkJCQljb250cm9sID0g
Y2RiWzExXTsKKwkJCX0KKworCQkJbWVtc2V0KGNkYiwgMCwgc2l6ZW9mKGlvX3JlcXVlc3QtPkNE
Qi5DREIzMikpOworCisJCQljZGJbMF0gPSBvcGNvZGU7CisJCQljZGJbMV0gPSBmbGFndmFsczsK
KwkJCWNkYls2XSA9IGdyb3VwbnVtOworCQkJY2RiWzldID0gY29udHJvbDsKKworCQkJLyogVHJh
bnNmZXIgbGVuZ3RoICovCisJCQljZGJbOF0gPSAodTgpKG51bV9ibG9ja3MgJiAweGZmKTsKKwkJ
CWNkYls3XSA9ICh1OCkoKG51bV9ibG9ja3MgPj4gOCkgJiAweGZmKTsKKworCQkJY2RiX2xlbiA9
IDEwOworCQl9CisKKwkJLyogTm9ybWFsIGNhc2UsIGp1c3QgbG9hZCBMQkEgaGVyZSAqLworCQlz
d2l0Y2ggKGNkYl9sZW4pIHsKKwkJY2FzZSA2OgorCQl7CisJCQl1OCB2YWwgPSBjZGJbMV0gJiAw
eEUwOworCQkJY2RiWzNdID0gKHU4KShzdGFydF9ibGsgJiAweGZmKTsKKwkJCWNkYlsyXSA9ICh1
OCkoKHN0YXJ0X2JsayA+PiA4KSAmIDB4ZmYpOworCQkJY2RiWzFdID0gdmFsIHwgKCh1OCkoc3Rh
cnRfYmxrID4+IDE2KSAmIDB4MWYpOworCQkJYnJlYWs7CisJCX0KKwkJY2FzZSAxMDoKKwkJCWNk
Yls1XSA9ICh1OCkoc3RhcnRfYmxrICYgMHhmZik7CisJCQljZGJbNF0gPSAodTgpKChzdGFydF9i
bGsgPj4gOCkgJiAweGZmKTsKKwkJCWNkYlszXSA9ICh1OCkoKHN0YXJ0X2JsayA+PiAxNikgJiAw
eGZmKTsKKwkJCWNkYlsyXSA9ICh1OCkoKHN0YXJ0X2JsayA+PiAyNCkgJiAweGZmKTsKKwkJCWJy
ZWFrOworCQljYXNlIDEyOgorCQkJY2RiWzVdICAgID0gKHU4KShzdGFydF9ibGsgJiAweGZmKTsK
KwkJCWNkYls0XSAgICA9ICh1OCkoKHN0YXJ0X2JsayA+PiA4KSAmIDB4ZmYpOworCQkJY2RiWzNd
ICAgID0gKHU4KSgoc3RhcnRfYmxrID4+IDE2KSAmIDB4ZmYpOworCQkJY2RiWzJdICAgID0gKHU4
KSgoc3RhcnRfYmxrID4+IDI0KSAmIDB4ZmYpOworCQkJYnJlYWs7CisJCWNhc2UgMTY6CisJCQlj
ZGJbOV0gICAgPSAodTgpKHN0YXJ0X2JsayAmIDB4ZmYpOworCQkJY2RiWzhdICAgID0gKHU4KSgo
c3RhcnRfYmxrID4+IDgpICYgMHhmZik7CisJCQljZGJbN10gICAgPSAodTgpKChzdGFydF9ibGsg
Pj4gMTYpICYgMHhmZik7CisJCQljZGJbNl0gICAgPSAodTgpKChzdGFydF9ibGsgPj4gMjQpICYg
MHhmZik7CisJCQljZGJbNV0gICAgPSAodTgpKChzdGFydF9ibGsgPj4gMzIpICYgMHhmZik7CisJ
CQljZGJbNF0gICAgPSAodTgpKChzdGFydF9ibGsgPj4gNDApICYgMHhmZik7CisJCQljZGJbM10g
ICAgPSAodTgpKChzdGFydF9ibGsgPj4gNDgpICYgMHhmZik7CisJCQljZGJbMl0gICAgPSAodTgp
KChzdGFydF9ibGsgPj4gNTYpICYgMHhmZik7CisJCQlicmVhazsKKwkJfQorCX0KK30KKworLyoq
CisgKiBtZWdhc2FzX2J1aWxkX2xkaW9fZnVzaW9uIC0JUHJlcGFyZXMgSU9zIHRvIGRldmljZXMK
KyAqIEBpbnN0YW5jZToJCUFkYXB0ZXIgc29mdCBzdGF0ZQorICogQHNjcDoJCVNDU0kgY29tbWFu
ZAorICogQGNtZDoJCUNvbW1hbmQgdG8gYmUgcHJlcGFyZWQKKyAqCisgKiBQcmVwYXJlcyB0aGUg
aW9fcmVxdWVzdCBhbmQgY2hhaW4gZWxlbWVudHMgKHNnX2ZyYW1lKSBmb3IgSU8KKyAqIFRoZSBJ
TyBjYW4gYmUgZm9yIFBEIChGYXN0IFBhdGgpIG9yIExECisgKi8KK3ZvaWQKK21lZ2FzYXNfYnVp
bGRfbGRpb19mdXNpb24oc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAorCQkJICBz
dHJ1Y3Qgc2NzaV9jbW5kICpzY3AsCisJCQkgIHN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24gKmNt
ZCkKK3sKKwl1OCBmcF9wb3NzaWJsZTsKKwl1MzIgc3RhcnRfbGJhX2xvLCBzdGFydF9sYmFfaGks
IGRldmljZV9pZDsKKwlzdHJ1Y3QgTVBJMl9SQUlEX1NDU0lfSU9fUkVRVUVTVCAqaW9fcmVxdWVz
dDsKKwl1bmlvbiBNRUdBU0FTX1JFUVVFU1RfREVTQ1JJUFRPUl9VTklPTiAqcmVxX2Rlc2M7CisJ
c3RydWN0IElPX1JFUVVFU1RfSU5GTyBpb19pbmZvOworCXN0cnVjdCBmdXNpb25fY29udGV4dCAq
ZnVzaW9uOworCXN0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgKmxvY2FsX21hcF9wdHI7CisKKwlk
ZXZpY2VfaWQgPSBNRUdBU0FTX0RFVl9JTkRFWChpbnN0YW5jZSwgc2NwKTsKKworCWZ1c2lvbiA9
IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CisKKwlpb19yZXF1ZXN0ID0gY21kLT5pb19yZXF1ZXN0
OworCWlvX3JlcXVlc3QtPlJhaWRDb250ZXh0LlZpcnR1YWxEaXNrVGd0SWQgPSBkZXZpY2VfaWQ7
CisJaW9fcmVxdWVzdC0+UmFpZENvbnRleHQuc3RhdHVzID0gMDsKKwlpb19yZXF1ZXN0LT5SYWlk
Q29udGV4dC5leFN0YXR1cyA9IDA7CisKKwlyZXFfZGVzYyA9ICh1bmlvbiBNRUdBU0FTX1JFUVVF
U1RfREVTQ1JJUFRPUl9VTklPTiAqKWNtZC0+cmVxdWVzdF9kZXNjOworCisJc3RhcnRfbGJhX2xv
ID0gMDsKKwlzdGFydF9sYmFfaGkgPSAwOworCWZwX3Bvc3NpYmxlID0gMDsKKworCS8qCisJICog
Ni1ieXRlIFJFQUQoMHgwOCkgb3IgV1JJVEUoMHgwQSkgY2RiCisJICovCisJaWYgKHNjcC0+Y21k
X2xlbiA9PSA2KSB7CisJCWlvX3JlcXVlc3QtPkRhdGFMZW5ndGggPSAodTMyKSBzY3AtPmNtbmRb
NF07CisJCXN0YXJ0X2xiYV9sbyA9ICgodTMyKSBzY3AtPmNtbmRbMV0gPDwgMTYpIHwKKwkJCSgo
dTMyKSBzY3AtPmNtbmRbMl0gPDwgOCkgfCAodTMyKSBzY3AtPmNtbmRbM107CisKKwkJc3RhcnRf
bGJhX2xvICY9IDB4MUZGRkZGOworCX0KKworCS8qCisJICogMTAtYnl0ZSBSRUFEKDB4MjgpIG9y
IFdSSVRFKDB4MkEpIGNkYgorCSAqLworCWVsc2UgaWYgKHNjcC0+Y21kX2xlbiA9PSAxMCkgewor
CQlpb19yZXF1ZXN0LT5EYXRhTGVuZ3RoID0gKHUzMikgc2NwLT5jbW5kWzhdIHwKKwkJCSgodTMy
KSBzY3AtPmNtbmRbN10gPDwgOCk7CisJCXN0YXJ0X2xiYV9sbyA9ICgodTMyKSBzY3AtPmNtbmRb
Ml0gPDwgMjQpIHwKKwkJCSgodTMyKSBzY3AtPmNtbmRbM10gPDwgMTYpIHwKKwkJCSgodTMyKSBz
Y3AtPmNtbmRbNF0gPDwgOCkgfCAodTMyKSBzY3AtPmNtbmRbNV07CisJfQorCisJLyoKKwkgKiAx
Mi1ieXRlIFJFQUQoMHhBOCkgb3IgV1JJVEUoMHhBQSkgY2RiCisJICovCisJZWxzZSBpZiAoc2Nw
LT5jbWRfbGVuID09IDEyKSB7CisJCWlvX3JlcXVlc3QtPkRhdGFMZW5ndGggPSAoKHUzMikgc2Nw
LT5jbW5kWzZdIDw8IDI0KSB8CisJCQkoKHUzMikgc2NwLT5jbW5kWzddIDw8IDE2KSB8CisJCQko
KHUzMikgc2NwLT5jbW5kWzhdIDw8IDgpIHwgKHUzMikgc2NwLT5jbW5kWzldOworCQlzdGFydF9s
YmFfbG8gPSAoKHUzMikgc2NwLT5jbW5kWzJdIDw8IDI0KSB8CisJCQkoKHUzMikgc2NwLT5jbW5k
WzNdIDw8IDE2KSB8CisJCQkoKHUzMikgc2NwLT5jbW5kWzRdIDw8IDgpIHwgKHUzMikgc2NwLT5j
bW5kWzVdOworCX0KKworCS8qCisJICogMTYtYnl0ZSBSRUFEKDB4ODgpIG9yIFdSSVRFKDB4OEEp
IGNkYgorCSAqLworCWVsc2UgaWYgKHNjcC0+Y21kX2xlbiA9PSAxNikgeworCQlpb19yZXF1ZXN0
LT5EYXRhTGVuZ3RoID0gKCh1MzIpIHNjcC0+Y21uZFsxMF0gPDwgMjQpIHwKKwkJCSgodTMyKSBz
Y3AtPmNtbmRbMTFdIDw8IDE2KSB8CisJCQkoKHUzMikgc2NwLT5jbW5kWzEyXSA8PCA4KSB8ICh1
MzIpIHNjcC0+Y21uZFsxM107CisJCXN0YXJ0X2xiYV9sbyA9ICgodTMyKSBzY3AtPmNtbmRbNl0g
PDwgMjQpIHwKKwkJCSgodTMyKSBzY3AtPmNtbmRbN10gPDwgMTYpIHwKKwkJCSgodTMyKSBzY3At
PmNtbmRbOF0gPDwgOCkgfCAodTMyKSBzY3AtPmNtbmRbOV07CisKKwkJc3RhcnRfbGJhX2hpID0g
KCh1MzIpIHNjcC0+Y21uZFsyXSA8PCAyNCkgfAorCQkJKCh1MzIpIHNjcC0+Y21uZFszXSA8PCAx
NikgfAorCQkJKCh1MzIpIHNjcC0+Y21uZFs0XSA8PCA4KSB8ICh1MzIpIHNjcC0+Y21uZFs1XTsK
Kwl9CisKKwltZW1zZXQoJmlvX2luZm8sIDAsIHNpemVvZihzdHJ1Y3QgSU9fUkVRVUVTVF9JTkZP
KSk7CisJaW9faW5mby5sZFN0YXJ0QmxvY2sgPSAoKHU2NClzdGFydF9sYmFfaGkgPDwgMzIpIHwg
c3RhcnRfbGJhX2xvOworCWlvX2luZm8ubnVtQmxvY2tzID0gaW9fcmVxdWVzdC0+RGF0YUxlbmd0
aDsKKwlpb19pbmZvLmxkVGd0SWQgPSBkZXZpY2VfaWQ7CisKKwlpZiAoc2NwLT5zY19kYXRhX2Rp
cmVjdGlvbiA9PSBQQ0lfRE1BX0ZST01ERVZJQ0UpCisJCWlvX2luZm8uaXNSZWFkID0gMTsKKwor
CWxvY2FsX21hcF9wdHIgPSBmdXNpb24tPmxkX21hcFsoaW5zdGFuY2UtPm1hcF9pZCAmIDEpXTsK
KworCWlmICgoTVJfVGFyZ2V0SWRUb0xkR2V0KGRldmljZV9pZCwgbG9jYWxfbWFwX3B0cikgPj0K
KwkgICAgIE1BWF9MT0dJQ0FMX0RSSVZFUykgfHwgKCFmdXNpb24tPmZhc3RfcGF0aF9pbykpIHsK
KwkJaW9fcmVxdWVzdC0+UmFpZENvbnRleHQucmVnTG9ja0ZsYWdzICA9IDA7CisJCWZwX3Bvc3Np
YmxlID0gMDsKKwl9IGVsc2UgeworCQlpZiAoTVJfQnVpbGRSYWlkQ29udGV4dCgmaW9faW5mbywg
JmlvX3JlcXVlc3QtPlJhaWRDb250ZXh0LAorCQkJCQlsb2NhbF9tYXBfcHRyKSkKKwkJCWZwX3Bv
c3NpYmxlID0gaW9faW5mby5mcE9rRm9ySW87CisJfQorCisJaWYgKGZwX3Bvc3NpYmxlKSB7CisJ
CW1lZ2FzYXNfc2V0X3BkX2xiYShpb19yZXF1ZXN0LCBzY3AtPmNtZF9sZW4sICZpb19pbmZvLCBz
Y3AsCisJCQkJICAgbG9jYWxfbWFwX3B0ciwgc3RhcnRfbGJhX2xvKTsKKwkJaW9fcmVxdWVzdC0+
RGF0YUxlbmd0aCA9IHNjc2lfYnVmZmxlbihzY3ApOworCQlpb19yZXF1ZXN0LT5GdW5jdGlvbiA9
IE1QSTJfRlVOQ1RJT05fU0NTSV9JT19SRVFVRVNUOworCQljbWQtPnJlcXVlc3RfZGVzYy0+U0NT
SUlPLlJlcXVlc3RGbGFncyA9CisJCQkoTVBJMl9SRVFfREVTQ1JJUFRfRkxBR1NfSElHSF9QUklP
UklUWQorCQkJIDw8IE1FR0FTQVNfUkVRX0RFU0NSSVBUX0ZMQUdTX1RZUEVfU0hJRlQpOworCQlp
ZiAoKGZ1c2lvbi0+bG9hZF9iYWxhbmNlX2luZm9bZGV2aWNlX2lkXS5sb2FkQmFsYW5jZUZsYWcp
ICYmCisJCSAgICAoaW9faW5mby5pc1JlYWQpKSB7CisJCQlpb19pbmZvLmRldkhhbmRsZSA9CisJ
CQkJZ2V0X3VwZGF0ZWRfZGV2X2hhbmRsZSgKKwkJCQkJJmZ1c2lvbi0+bG9hZF9iYWxhbmNlX2lu
Zm9bZGV2aWNlX2lkXSwKKwkJCQkJJmlvX2luZm8pOworCQkJc2NwLT5TQ3AuU3RhdHVzIHw9IE1F
R0FTQVNfTE9BRF9CQUxBTkNFX0ZMQUc7CisJCX0gZWxzZQorCQkJc2NwLT5TQ3AuU3RhdHVzICY9
IH5NRUdBU0FTX0xPQURfQkFMQU5DRV9GTEFHOworCQljbWQtPnJlcXVlc3RfZGVzYy0+U0NTSUlP
LkRldkhhbmRsZSA9IGlvX2luZm8uZGV2SGFuZGxlOworCQlpb19yZXF1ZXN0LT5EZXZIYW5kbGUg
PSBpb19pbmZvLmRldkhhbmRsZTsKKwl9IGVsc2UgeworCQlpb19yZXF1ZXN0LT5SYWlkQ29udGV4
dC50aW1lb3V0VmFsdWUgPQorCQkJbG9jYWxfbWFwX3B0ci0+cmFpZE1hcC5mcFBkSW9UaW1lb3V0
U2VjOworCQlpb19yZXF1ZXN0LT5GdW5jdGlvbiA9IE1FR0FTQVNfTVBJMl9GVU5DVElPTl9MRF9J
T19SRVFVRVNUOworCQlpb19yZXF1ZXN0LT5EZXZIYW5kbGUgPSBkZXZpY2VfaWQ7CisJCWNtZC0+
cmVxdWVzdF9kZXNjLT5TQ1NJSU8uUmVxdWVzdEZsYWdzID0KKwkJCShNRUdBU0FTX1JFUV9ERVND
UklQVF9GTEFHU19MRF9JTworCQkJIDw8IE1FR0FTQVNfUkVRX0RFU0NSSVBUX0ZMQUdTX1RZUEVf
U0hJRlQpOworCX0gLyogTm90IEZQICovCit9CisKKy8qKgorICogbWVnYXNhc19idWlsZF9kY2Ri
X2Z1c2lvbiAtCVByZXBhcmVzIElPcyB0byBkZXZpY2VzCisgKiBAaW5zdGFuY2U6CQlBZGFwdGVy
IHNvZnQgc3RhdGUKKyAqIEBzY3A6CQlTQ1NJIGNvbW1hbmQKKyAqIEBjbWQ6CQlDb21tYW5kIHRv
IGJlIHByZXBhcmVkCisgKgorICogUHJlcGFyZXMgdGhlIGlvX3JlcXVlc3QgZnJhbWUgZm9yIG5v
bi1pbyBjbWRzCisgKi8KK3N0YXRpYyB2b2lkCittZWdhc2FzX2J1aWxkX2RjZGJfZnVzaW9uKHN0
cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKKwkJCSAgc3RydWN0IHNjc2lfY21uZCAq
c2NtZCwKKwkJCSAgc3RydWN0IG1lZ2FzYXNfY21kX2Z1c2lvbiAqY21kKQoreworCXUzMiBkZXZp
Y2VfaWQ7CisJc3RydWN0IE1QSTJfUkFJRF9TQ1NJX0lPX1JFUVVFU1QgKmlvX3JlcXVlc3Q7CisJ
dTE2IHBkX2luZGV4ID0gMDsKKwlzdHJ1Y3QgTVJfRldfUkFJRF9NQVBfQUxMICpsb2NhbF9tYXBf
cHRyOworCXN0cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxfY29u
dGV4dDsKKworCWlvX3JlcXVlc3QgPSBjbWQtPmlvX3JlcXVlc3Q7CisJZGV2aWNlX2lkID0gTUVH
QVNBU19ERVZfSU5ERVgoaW5zdGFuY2UsIHNjbWQpOworCXBkX2luZGV4ID0gKHNjbWQtPmRldmlj
ZS0+Y2hhbm5lbCAqIE1FR0FTQVNfTUFYX0RFVl9QRVJfQ0hBTk5FTCkKKwkJK3NjbWQtPmRldmlj
ZS0+aWQ7CisJbG9jYWxfbWFwX3B0ciA9IGZ1c2lvbi0+bGRfbWFwWyhpbnN0YW5jZS0+bWFwX2lk
ICYgMSldOworCisJLyogQ2hlY2sgaWYgdGhpcyBpcyBhIHN5c3RlbSBQRCBJL08gKi8KKwlpZiAo
KGluc3RhbmNlLT5wZF9saXN0W3BkX2luZGV4XS5kcml2ZVN0YXRlID09IE1SX1BEX1NUQVRFX1NZ
U1RFTSkgJiYKKwkgICAgKGluc3RhbmNlLT5wZF9saXN0W3BkX2luZGV4XS5kcml2ZVR5cGUgPT0g
VFlQRV9ESVNLKSkgeworCQlpb19yZXF1ZXN0LT5GdW5jdGlvbiA9IDA7CisJCWlvX3JlcXVlc3Qt
PkRldkhhbmRsZSA9CisJCQlsb2NhbF9tYXBfcHRyLT5yYWlkTWFwLmRldkhuZGxJbmZvW2Rldmlj
ZV9pZF0uY3VyRGV2SGRsOworCQlpb19yZXF1ZXN0LT5SYWlkQ29udGV4dC50aW1lb3V0VmFsdWUg
PQorCQkJbG9jYWxfbWFwX3B0ci0+cmFpZE1hcC5mcFBkSW9UaW1lb3V0U2VjOworCQlpb19yZXF1
ZXN0LT5SYWlkQ29udGV4dC5yZWdMb2NrRmxhZ3MgPSAwOworCQlpb19yZXF1ZXN0LT5SYWlkQ29u
dGV4dC5yZWdMb2NrUm93TEJBID0gMDsKKwkJaW9fcmVxdWVzdC0+UmFpZENvbnRleHQucmVnTG9j
a0xlbmd0aCA9IDA7CisJCWlvX3JlcXVlc3QtPlJhaWRDb250ZXh0LlJBSURGbGFncyA9CisJCQlN
Ul9SQUlEX0ZMQUdTX0lPX1NVQl9UWVBFX1NZU1RFTV9QRCA8PAorCQkJTVJfUkFJRF9DVFhfUkFJ
RF9GTEFHU19JT19TVUJfVFlQRV9TSElGVDsKKwkJY21kLT5yZXF1ZXN0X2Rlc2MtPlNDU0lJTy5S
ZXF1ZXN0RmxhZ3MgPQorCQkJKE1QSTJfUkVRX0RFU0NSSVBUX0ZMQUdTX0hJR0hfUFJJT1JJVFkg
PDwKKwkJCSBNRUdBU0FTX1JFUV9ERVNDUklQVF9GTEFHU19UWVBFX1NISUZUKTsKKwl9IGVsc2Ug
eworCQlpb19yZXF1ZXN0LT5GdW5jdGlvbiAgPSBNRUdBU0FTX01QSTJfRlVOQ1RJT05fTERfSU9f
UkVRVUVTVDsKKwkJaW9fcmVxdWVzdC0+RGV2SGFuZGxlID0gZGV2aWNlX2lkOworCQljbWQtPnJl
cXVlc3RfZGVzYy0+U0NTSUlPLlJlcXVlc3RGbGFncyA9CisJCQkoTVBJMl9SRVFfREVTQ1JJUFRf
RkxBR1NfU0NTSV9JTyA8PAorCQkJIE1FR0FTQVNfUkVRX0RFU0NSSVBUX0ZMQUdTX1RZUEVfU0hJ
RlQpOworCX0KKwlpb19yZXF1ZXN0LT5SYWlkQ29udGV4dC5WaXJ0dWFsRGlza1RndElkID0gZGV2
aWNlX2lkOworCWlvX3JlcXVlc3QtPkxVTlswXSA9IHNjbWQtPmRldmljZS0+bHVuOworCWlvX3Jl
cXVlc3QtPkRhdGFMZW5ndGggPSBzY3NpX2J1ZmZsZW4oc2NtZCk7Cit9CisKKy8qKgorICogbWVn
YXNhc19idWlsZF9pb19mdXNpb24gLQlQcmVwYXJlcyBJT3MgdG8gZGV2aWNlcworICogQGluc3Rh
bmNlOgkJQWRhcHRlciBzb2Z0IHN0YXRlCisgKiBAc2NwOgkJU0NTSSBjb21tYW5kCisgKiBAY21k
OgkJQ29tbWFuZCB0byBiZSBwcmVwYXJlZAorICoKKyAqIEludm9rZXMgaGVscGVyIGZ1bmN0aW9u
cyB0byBwcmVwYXJlIHJlcXVlc3QgZnJhbWVzCisgKiBhbmQgc2V0cyBmbGFncyBhcHByb3ByaWF0
ZSBmb3IgSU8vTm9uLUlPIGNtZAorICovCitpbnQKK21lZ2FzYXNfYnVpbGRfaW9fZnVzaW9uKHN0
cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKKwkJCXN0cnVjdCBzY3NpX2NtbmQgKnNj
cCwKKwkJCXN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24gKmNtZCkKK3sKKwl1MzIgZGV2aWNlX2lk
LCBzZ2VfY291bnQ7CisJc3RydWN0IE1QSTJfUkFJRF9TQ1NJX0lPX1JFUVVFU1QgKmlvX3JlcXVl
c3QgPSBjbWQtPmlvX3JlcXVlc3Q7CisKKwlkZXZpY2VfaWQgPSBNRUdBU0FTX0RFVl9JTkRFWChp
bnN0YW5jZSwgc2NwKTsKKworCS8qIFplcm8gb3V0IHNvbWUgZmllbGRzIHNvIHRoZXkgZG9uJ3Qg
Z2V0IHJldXNlZCAqLworCWlvX3JlcXVlc3QtPkxVTlswXSA9IDA7CisJaW9fcmVxdWVzdC0+Q0RC
LkVFRFAzMi5QcmltYXJ5UmVmZXJlbmNlVGFnID0gMDsKKwlpb19yZXF1ZXN0LT5DREIuRUVEUDMy
LlByaW1hcnlBcHBsaWNhdGlvblRhZ01hc2sgPSAwOworCWlvX3JlcXVlc3QtPkVFRFBGbGFncyA9
IDA7CisJaW9fcmVxdWVzdC0+Q29udHJvbCA9IDA7CisJaW9fcmVxdWVzdC0+RUVEUEJsb2NrU2l6
ZSA9IDA7CisJaW9fcmVxdWVzdC0+SW9GbGFncyA9IDA7CisJaW9fcmVxdWVzdC0+UmFpZENvbnRl
eHQuUkFJREZsYWdzID0gMDsKKworCW1lbWNweShpb19yZXF1ZXN0LT5DREIuQ0RCMzIsIHNjcC0+
Y21uZCwgc2NwLT5jbWRfbGVuKTsKKwkvKgorCSAqIEp1c3QgdGhlIENEQiBsZW5ndGgscmVzdCBv
ZiB0aGUgRmxhZ3MgYXJlIHplcm8KKwkgKiBUaGlzIHdpbGwgYmUgbW9kaWZpZWQgZm9yIEZQIGlu
IGJ1aWxkX2xkaW9fZnVzaW9uCisJICovCisJaW9fcmVxdWVzdC0+SW9GbGFncyA9IHNjcC0+Y21k
X2xlbjsKKworCWlmIChtZWdhc2FzX2lzX2xkaW8oc2NwKSkKKwkJbWVnYXNhc19idWlsZF9sZGlv
X2Z1c2lvbihpbnN0YW5jZSwgc2NwLCBjbWQpOworCWVsc2UKKwkJbWVnYXNhc19idWlsZF9kY2Ri
X2Z1c2lvbihpbnN0YW5jZSwgc2NwLCBjbWQpOworCisJLyoKKwkgKiBDb25zdHJ1Y3QgU0dMCisJ
ICovCisKKwlzZ2VfY291bnQgPQorCQltZWdhc2FzX21ha2Vfc2dsX2Z1c2lvbihpbnN0YW5jZSwg
c2NwLAorCQkJCQkoc3RydWN0IE1QSTI1X0lFRUVfU0dFX0NIQUlONjQgKikKKwkJCQkJJmlvX3Jl
cXVlc3QtPlNHTCwgY21kKTsKKworCWlmIChzZ2VfY291bnQgPiBpbnN0YW5jZS0+bWF4X251bV9z
Z2UpIHsKKwkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBFcnJvci4gc2dlX2NvdW50ICgweCV4
KSBleGNlZWRzICIKKwkJICAgICAgICJtYXggKDB4JXgpIGFsbG93ZWRcbiIsIHNnZV9jb3VudCwK
KwkJICAgICAgIGluc3RhbmNlLT5tYXhfbnVtX3NnZSk7CisJCXJldHVybiAxOworCX0KKworCWlv
X3JlcXVlc3QtPlJhaWRDb250ZXh0Lm51bVNHRSA9IHNnZV9jb3VudDsKKworCWlvX3JlcXVlc3Qt
PlNHTEZsYWdzID0gTVBJMl9TR0VfRkxBR1NfNjRfQklUX0FERFJFU1NJTkc7CisKKwlpZiAoc2Nw
LT5zY19kYXRhX2RpcmVjdGlvbiA9PSBQQ0lfRE1BX1RPREVWSUNFKQorCQlpb19yZXF1ZXN0LT5D
b250cm9sIHw9IE1QSTJfU0NTSUlPX0NPTlRST0xfV1JJVEU7CisJZWxzZSBpZiAoc2NwLT5zY19k
YXRhX2RpcmVjdGlvbiA9PSBQQ0lfRE1BX0ZST01ERVZJQ0UpCisJCWlvX3JlcXVlc3QtPkNvbnRy
b2wgfD0gTVBJMl9TQ1NJSU9fQ09OVFJPTF9SRUFEOworCisJaW9fcmVxdWVzdC0+U0dMT2Zmc2V0
MCA9CisJCW9mZnNldG9mKHN0cnVjdCBNUEkyX1JBSURfU0NTSV9JT19SRVFVRVNULCBTR0wpIC8g
NDsKKworCWlvX3JlcXVlc3QtPlNlbnNlQnVmZmVyTG93QWRkcmVzcyA9IGNtZC0+c2Vuc2VfcGh5
c19hZGRyOworCWlvX3JlcXVlc3QtPlNlbnNlQnVmZmVyTGVuZ3RoID0gU0NTSV9TRU5TRV9CVUZG
RVJTSVpFOworCisJY21kLT5zY21kID0gc2NwOworCXNjcC0+U0NwLnB0ciA9IChjaGFyICopY21k
OworCisJcmV0dXJuIDA7Cit9CisKK3VuaW9uIE1FR0FTQVNfUkVRVUVTVF9ERVNDUklQVE9SX1VO
SU9OICoKK21lZ2FzYXNfZ2V0X3JlcXVlc3RfZGVzY3JpcHRvcihzdHJ1Y3QgbWVnYXNhc19pbnN0
YW5jZSAqaW5zdGFuY2UsIHUxNiBpbmRleCkKK3sKKwl1OCAqcDsKKwlzdHJ1Y3QgZnVzaW9uX2Nv
bnRleHQgKmZ1c2lvbjsKKworCWlmIChpbmRleCA+PSBpbnN0YW5jZS0+bWF4X2Z3X2NtZHMpIHsK
KwkJcHJpbnRrKEtFUk5fRVJSICJtZWdhc2FzOiBJbnZhbGlkIFNNSUQgKDB4JXgpcmVxdWVzdCBm
b3IgIgorCQkgICAgICAgImRlc2NyaXB0b3JcbiIsIGluZGV4KTsKKwkJcmV0dXJuIE5VTEw7CisJ
fQorCWZ1c2lvbiA9IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CisJcCA9IGZ1c2lvbi0+cmVxX2Zy
YW1lc19kZXNjCisJCStzaXplb2YodW5pb24gTUVHQVNBU19SRVFVRVNUX0RFU0NSSVBUT1JfVU5J
T04pICppbmRleDsKKworCXJldHVybiAodW5pb24gTUVHQVNBU19SRVFVRVNUX0RFU0NSSVBUT1Jf
VU5JT04gKilwOworfQorCisvKioKKyAqIG1lZ2FzYXNfYnVpbGRfYW5kX2lzc3VlX2NtZF9mdXNp
b24gLU1haW4gcm91dGluZSBmb3IgYnVpbGRpbmcgYW5kCisgKiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBpc3N1aW5nIG5vbiBJT0NUTCBjbWQKKyAqIEBpbnN0YW5jZToJCQlB
ZGFwdGVyIHNvZnQgc3RhdGUKKyAqIEBzY21kOgkJCXBvaW50ZXIgdG8gc2NzaSBjbWQgZnJvbSBP
UworICovCitzdGF0aWMgdTMyCittZWdhc2FzX2J1aWxkX2FuZF9pc3N1ZV9jbWRfZnVzaW9uKHN0
cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwKKwkJCQkgICBzdHJ1Y3Qgc2NzaV9jbW5k
ICpzY21kKQoreworCXN0cnVjdCBtZWdhc2FzX2NtZF9mdXNpb24gKmNtZDsKKwl1bmlvbiBNRUdB
U0FTX1JFUVVFU1RfREVTQ1JJUFRPUl9VTklPTiAqcmVxX2Rlc2M7CisJdTMyIGluZGV4OworCXN0
cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uOworCisJZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxf
Y29udGV4dDsKKworCWNtZCA9IG1lZ2FzYXNfZ2V0X2NtZF9mdXNpb24oaW5zdGFuY2UpOworCWlm
ICghY21kKQorCQlyZXR1cm4gU0NTSV9NTFFVRVVFX0hPU1RfQlVTWTsKKworCWluZGV4ID0gY21k
LT5pbmRleDsKKworCXJlcV9kZXNjID0gbWVnYXNhc19nZXRfcmVxdWVzdF9kZXNjcmlwdG9yKGlu
c3RhbmNlLCBpbmRleC0xKTsKKwlpZiAoIXJlcV9kZXNjKQorCQlyZXR1cm4gMTsKKworCXJlcV9k
ZXNjLT5Xb3JkcyA9IDA7CisJY21kLT5yZXF1ZXN0X2Rlc2MgPSByZXFfZGVzYzsKKwljbWQtPnJl
cXVlc3RfZGVzYy0+V29yZHMgPSAwOworCisJaWYgKG1lZ2FzYXNfYnVpbGRfaW9fZnVzaW9uKGlu
c3RhbmNlLCBzY21kLCBjbWQpKSB7CisJCW1lZ2FzYXNfcmV0dXJuX2NtZF9mdXNpb24oaW5zdGFu
Y2UsIGNtZCk7CisJCXByaW50ayhLRVJOX0VSUiAibWVnYXNhczogRXJyb3IgYnVpbGRpbmcgY29t
bWFuZC5cbiIpOworCQljbWQtPnJlcXVlc3RfZGVzYyA9IE5VTEw7CisJCXJldHVybiAxOworCX0K
KworCXJlcV9kZXNjID0gY21kLT5yZXF1ZXN0X2Rlc2M7CisJcmVxX2Rlc2MtPlNDU0lJTy5TTUlE
ID0gaW5kZXg7CisKKwlpZiAoY21kLT5pb19yZXF1ZXN0LT5DaGFpbk9mZnNldCAhPSAwICYmCisJ
ICAgIGNtZC0+aW9fcmVxdWVzdC0+Q2hhaW5PZmZzZXQgIT0gMHhGKQorCQlwcmludGsoS0VSTl9F
UlIgIm1lZ2FzYXM6IFRoZSBjaGFpbiBvZmZzZXQgdmFsdWUgaXMgbm90ICIKKwkJICAgICAgICJj
b3JyZWN0IDogJXhcbiIsIGNtZC0+aW9fcmVxdWVzdC0+Q2hhaW5PZmZzZXQpOworCisJLyoKKwkg
KiBJc3N1ZSB0aGUgY29tbWFuZCB0byB0aGUgRlcKKwkgKi8KKwlhdG9taWNfaW5jKCZpbnN0YW5j
ZS0+Zndfb3V0c3RhbmRpbmcpOworCisJaW5zdGFuY2UtPmluc3RhbmNldC0+ZmlyZV9jbWQoaW5z
dGFuY2UsCisJCQkJICAgICAgcmVxX2Rlc2MtPnUubG93LCByZXFfZGVzYy0+dS5oaWdoLAorCQkJ
CSAgICAgIGluc3RhbmNlLT5yZWdfc2V0KTsKKworCXJldHVybiAwOworfQorCisvKioKKyAqIGNv
bXBsZXRlX2NtZF9mdXNpb24gLQlDb21wbGV0ZXMgY29tbWFuZAorICogQGluc3RhbmNlOgkJCUFk
YXB0ZXIgc29mdCBzdGF0ZQorICogQ29tcGxldGVzIGFsbCBjb21tYW5kcyB0aGF0IGlzIGluIHJl
cGx5IGRlc2NyaXB0b3IgcXVldWUKKyAqLworaW50Citjb21wbGV0ZV9jbWRfZnVzaW9uKHN0cnVj
dCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKK3sKKwl1bmlvbiBNUEkyX1JFUExZX0RFU0NS
SVBUT1JTX1VOSU9OICpkZXNjOworCXN0cnVjdCBNUEkyX1NDU0lfSU9fU1VDQ0VTU19SRVBMWV9E
RVNDUklQVE9SICpyZXBseV9kZXNjOworCXN0cnVjdCBNUEkyX1JBSURfU0NTSV9JT19SRVFVRVNU
ICpzY3NpX2lvX3JlcTsKKwlzdHJ1Y3QgZnVzaW9uX2NvbnRleHQgKmZ1c2lvbjsKKwlzdHJ1Y3Qg
bWVnYXNhc19jbWQgKmNtZF9tZmk7CisJc3RydWN0IG1lZ2FzYXNfY21kX2Z1c2lvbiAqY21kX2Z1
c2lvbjsKKwl1MTYgc21pZCwgbnVtX2NvbXBsZXRlZDsKKwl1OCByZXBseV9kZXNjcmlwdF90eXBl
LCBhcm07CisJdTMyIHN0YXR1cywgZXh0U3RhdHVzLCBkZXZpY2VfaWQ7CisJdW5pb24gZGVzY192
YWx1ZSBkX3ZhbDsKKwlzdHJ1Y3QgTERfTE9BRF9CQUxBTkNFX0lORk8gKmxiaW5mbzsKKworCWZ1
c2lvbiA9IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7CisKKwlpZiAoaW5zdGFuY2UtPmFkcHJlY292
ZXJ5ID09IE1FR0FTQVNfSFdfQ1JJVElDQUxfRVJST1IpCisJCXJldHVybiBJUlFfSEFORExFRDsK
KworCWRlc2MgPSBmdXNpb24tPnJlcGx5X2ZyYW1lc19kZXNjOworCWRlc2MgKz0gZnVzaW9uLT5s
YXN0X3JlcGx5X2lkeDsKKworCXJlcGx5X2Rlc2MgPSAoc3RydWN0IE1QSTJfU0NTSV9JT19TVUND
RVNTX1JFUExZX0RFU0NSSVBUT1IgKilkZXNjOworCisJZF92YWwud29yZCA9IGRlc2MtPldvcmRz
OworCisJcmVwbHlfZGVzY3JpcHRfdHlwZSA9IHJlcGx5X2Rlc2MtPlJlcGx5RmxhZ3MgJgorCQlN
UEkyX1JQWV9ERVNDUklQVF9GTEFHU19UWVBFX01BU0s7CisKKwlpZiAocmVwbHlfZGVzY3JpcHRf
dHlwZSA9PSBNUEkyX1JQWV9ERVNDUklQVF9GTEFHU19VTlVTRUQpCisJCXJldHVybiBJUlFfTk9O
RTsKKworCWRfdmFsLndvcmQgPSBkZXNjLT5Xb3JkczsKKworCW51bV9jb21wbGV0ZWQgPSAwOwor
CisJd2hpbGUgKChkX3ZhbC51LmxvdyAhPSBVSU5UX01BWCkgJiYgKGRfdmFsLnUuaGlnaCAhPSBV
SU5UX01BWCkpIHsKKwkJc21pZCA9IHJlcGx5X2Rlc2MtPlNNSUQ7CisKKwkJY21kX2Z1c2lvbiA9
IGZ1c2lvbi0+Y21kX2xpc3Rbc21pZCAtIDFdOworCisJCXNjc2lfaW9fcmVxID0KKwkJCShzdHJ1
Y3QgTVBJMl9SQUlEX1NDU0lfSU9fUkVRVUVTVCAqKQorCQkgIGNtZF9mdXNpb24tPmlvX3JlcXVl
c3Q7CisKKwkJaWYgKGNtZF9mdXNpb24tPnNjbWQpCisJCQljbWRfZnVzaW9uLT5zY21kLT5TQ3Au
cHRyID0gTlVMTDsKKworCQlzdGF0dXMgPSBzY3NpX2lvX3JlcS0+UmFpZENvbnRleHQuc3RhdHVz
OworCQlleHRTdGF0dXMgPSBzY3NpX2lvX3JlcS0+UmFpZENvbnRleHQuZXhTdGF0dXM7CisKKwkJ
c3dpdGNoIChzY3NpX2lvX3JlcS0+RnVuY3Rpb24pIHsKKwkJY2FzZSBNUEkyX0ZVTkNUSU9OX1ND
U0lfSU9fUkVRVUVTVDogIC8qRmFzdCBQYXRoIElPLiovCisJCQkvKiBVcGRhdGUgbG9hZCBiYWxh
bmNpbmcgaW5mbyAqLworCQkJZGV2aWNlX2lkID0gTUVHQVNBU19ERVZfSU5ERVgoaW5zdGFuY2Us
CisJCQkJCQkgICAgICBjbWRfZnVzaW9uLT5zY21kKTsKKwkJCWxiaW5mbyA9ICZmdXNpb24tPmxv
YWRfYmFsYW5jZV9pbmZvW2RldmljZV9pZF07CisJCQlpZiAoY21kX2Z1c2lvbi0+c2NtZC0+U0Nw
LlN0YXR1cyAmCisJCQkgICAgTUVHQVNBU19MT0FEX0JBTEFOQ0VfRkxBRykgeworCQkJCWFybSA9
IGxiaW5mby0+cmFpZDFEZXZIYW5kbGVbMF0gPT0KKwkJCQkJY21kX2Z1c2lvbi0+aW9fcmVxdWVz
dC0+RGV2SGFuZGxlID8gMCA6CisJCQkJCTE7CisJCQkJYXRvbWljX2RlYygmbGJpbmZvLT5zY3Np
X3BlbmRpbmdfY21kc1thcm1dKTsKKwkJCQljbWRfZnVzaW9uLT5zY21kLT5TQ3AuU3RhdHVzICY9
CisJCQkJCX5NRUdBU0FTX0xPQURfQkFMQU5DRV9GTEFHOworCQkJfQorCQkJaWYgKHJlcGx5X2Rl
c2NyaXB0X3R5cGUgPT0KKwkJCSAgICBNUEkyX1JQWV9ERVNDUklQVF9GTEFHU19TQ1NJX0lPX1NV
Q0NFU1MpIHsKKwkJCQlpZiAobWVnYXNhc19kYmdfbHZsID09IDUpCisJCQkJCXByaW50ayhLRVJO
X0VSUiAiXG5tZWdhc2FzOiBGQVNUIFBhdGggIgorCQkJCQkgICAgICAgIklPIFN1Y2Nlc3NcbiIp
OworCQkJfQorCQkJLyogRmFsbCB0aHJ1IGFuZCBjb21wbGV0ZSBJTyAqLworCQljYXNlIE1FR0FT
QVNfTVBJMl9GVU5DVElPTl9MRF9JT19SRVFVRVNUOiAvKiBMRC1JTyBQYXRoICovCisJCQkvKiBN
YXAgdGhlIEZXIENtZCBTdGF0dXMgKi8KKwkJCW1hcF9jbWRfc3RhdHVzKGNtZF9mdXNpb24sIHN0
YXR1cywgZXh0U3RhdHVzKTsKKwkJCXNjc2lfZG1hX3VubWFwKGNtZF9mdXNpb24tPnNjbWQpOwor
CQkJY21kX2Z1c2lvbi0+c2NtZC0+c2NzaV9kb25lKGNtZF9mdXNpb24tPnNjbWQpOworCQkJc2Nz
aV9pb19yZXEtPlJhaWRDb250ZXh0LnN0YXR1cyA9IDA7CisJCQlzY3NpX2lvX3JlcS0+UmFpZENv
bnRleHQuZXhTdGF0dXMgPSAwOworCQkJbWVnYXNhc19yZXR1cm5fY21kX2Z1c2lvbihpbnN0YW5j
ZSwgY21kX2Z1c2lvbik7CisJCQlhdG9taWNfZGVjKCZpbnN0YW5jZS0+Zndfb3V0c3RhbmRpbmcp
OworCisJCQlicmVhazsKKwkJY2FzZSBNRUdBU0FTX01QSTJfRlVOQ1RJT05fUEFTU1RIUlVfSU9f
UkVRVUVTVDogLypNRkkgY29tbWFuZCAqLworCQkJY21kX21maSA9IGluc3RhbmNlLT5jbWRfbGlz
dFtjbWRfZnVzaW9uLT5zeW5jX2NtZF9pZHhdOworCQkJbWVnYXNhc19jb21wbGV0ZV9jbWQoaW5z
dGFuY2UsIGNtZF9tZmksIERJRF9PSyk7CisJCQljbWRfZnVzaW9uLT5mbGFncyA9IDA7CisJCQlt
ZWdhc2FzX3JldHVybl9jbWRfZnVzaW9uKGluc3RhbmNlLCBjbWRfZnVzaW9uKTsKKworCQkJYnJl
YWs7CisJCX0KKworCQlmdXNpb24tPmxhc3RfcmVwbHlfaWR4Kys7CisJCWlmIChmdXNpb24tPmxh
c3RfcmVwbHlfaWR4ID49IGZ1c2lvbi0+cmVwbHlfcV9kZXB0aCkKKwkJCWZ1c2lvbi0+bGFzdF9y
ZXBseV9pZHggPSAwOworCisJCWRlc2MtPldvcmRzID0gVUxMT05HX01BWDsKKwkJbnVtX2NvbXBs
ZXRlZCsrOworCisJCS8qIEdldCB0aGUgbmV4dCByZXBseSBkZXNjcmlwdG9yICovCisJCWlmICgh
ZnVzaW9uLT5sYXN0X3JlcGx5X2lkeCkKKwkJCWRlc2MgPSBmdXNpb24tPnJlcGx5X2ZyYW1lc19k
ZXNjOworCQllbHNlCisJCQlkZXNjKys7CisKKwkJcmVwbHlfZGVzYyA9CisJCSAgKHN0cnVjdCBN
UEkyX1NDU0lfSU9fU1VDQ0VTU19SRVBMWV9ERVNDUklQVE9SICopZGVzYzsKKworCQlkX3ZhbC53
b3JkID0gZGVzYy0+V29yZHM7CisKKwkJcmVwbHlfZGVzY3JpcHRfdHlwZSA9IHJlcGx5X2Rlc2Mt
PlJlcGx5RmxhZ3MgJgorCQkJTVBJMl9SUFlfREVTQ1JJUFRfRkxBR1NfVFlQRV9NQVNLOworCisJ
CWlmIChyZXBseV9kZXNjcmlwdF90eXBlID09IE1QSTJfUlBZX0RFU0NSSVBUX0ZMQUdTX1VOVVNF
RCkKKwkJCWJyZWFrOworCX0KKworCWlmICghbnVtX2NvbXBsZXRlZCkKKwkJcmV0dXJuIElSUV9O
T05FOworCisJd21iKCk7CisJd3JpdGVsKGZ1c2lvbi0+bGFzdF9yZXBseV9pZHgsCisJICAgICAg
ICZpbnN0YW5jZS0+cmVnX3NldC0+cmVwbHlfcG9zdF9ob3N0X2luZGV4KTsKKworCXJldHVybiBJ
UlFfSEFORExFRDsKK30KKworLyoqCisgKiBtZWdhc2FzX2NvbXBsZXRlX2NtZF9kcGNfZnVzaW9u
IC0JQ29tcGxldGVzIGNvbW1hbmQKKyAqIEBpbnN0YW5jZToJCQlBZGFwdGVyIHNvZnQgc3RhdGUK
KyAqCisgKiBUYXNrbGV0IHRvIGNvbXBsZXRlIGNtZHMKKyAqLwordm9pZAorbWVnYXNhc19jb21w
bGV0ZV9jbWRfZHBjX2Z1c2lvbih1bnNpZ25lZCBsb25nIGluc3RhbmNlX2FkZHIpCit7CisJc3Ry
dWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlID0KKwkJKHN0cnVjdCBtZWdhc2FzX2luc3Rh
bmNlICopaW5zdGFuY2VfYWRkcjsKKwl1bnNpZ25lZCBsb25nIGZsYWdzOworCisJLyogSWYgd2Ug
aGF2ZSBhbHJlYWR5IGRlY2xhcmVkIGFkYXB0ZXIgZGVhZCwgZG9ub3QgY29tcGxldGUgY21kcyAq
LworCXNwaW5fbG9ja19pcnFzYXZlKCZpbnN0YW5jZS0+aGJhX2xvY2ssIGZsYWdzKTsKKwlpZiAo
aW5zdGFuY2UtPmFkcHJlY292ZXJ5ID09IE1FR0FTQVNfSFdfQ1JJVElDQUxfRVJST1IpIHsKKwkJ
c3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaW5zdGFuY2UtPmhiYV9sb2NrLCBmbGFncyk7CisJCXJl
dHVybjsKKwl9CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaW5zdGFuY2UtPmhiYV9sb2NrLCBm
bGFncyk7CisKKwlzcGluX2xvY2tfaXJxc2F2ZSgmaW5zdGFuY2UtPmNvbXBsZXRpb25fbG9jaywg
ZmxhZ3MpOworCWNvbXBsZXRlX2NtZF9mdXNpb24oaW5zdGFuY2UpOworCXNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoJmluc3RhbmNlLT5jb21wbGV0aW9uX2xvY2ssIGZsYWdzKTsKK30KKworLyoqCisg
KiBtZWdhc2FzX2lzcl9mdXNpb24gLSBpc3IgZW50cnkgcG9pbnQKKyAqLworaXJxcmV0dXJuX3Qg
bWVnYXNhc19pc3JfZnVzaW9uKGludCBpcnEsIHZvaWQgKmRldnApCit7CisJc3RydWN0IG1lZ2Fz
YXNfaW5zdGFuY2UgKmluc3RhbmNlID0gKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICopZGV2cDsK
Kwl1MzIgbWZpU3RhdHVzLCBmd19zdGF0ZTsKKworCWlmICghaW5zdGFuY2UtPm1zaV9mbGFnKSB7
CisJCW1maVN0YXR1cyA9IGluc3RhbmNlLT5pbnN0YW5jZXQtPmNsZWFyX2ludHIoaW5zdGFuY2Ut
PnJlZ19zZXQpOworCQlpZiAoIW1maVN0YXR1cykKKwkJCXJldHVybiBJUlFfTk9ORTsKKwl9CisK
KwkvKiBJZiB3ZSBhcmUgcmVzZXR0aW5nLCBiYWlsICovCisJaWYgKHRlc3RfYml0KE1FR0FTQVNf
RlVTSU9OX0lOX1JFU0VULCAmaW5zdGFuY2UtPnJlc2V0X2ZsYWdzKSkKKwkJcmV0dXJuIElSUV9I
QU5ETEVEOworCisJaWYgKCFjb21wbGV0ZV9jbWRfZnVzaW9uKGluc3RhbmNlKSkgeworCQkvKiBJ
ZiB3ZSBkaWRuJ3QgY29tcGxldGUgYW55IGNvbW1hbmRzLCBjaGVjayBmb3IgRlcgZmF1bHQgKi8K
KwkJZndfc3RhdGUgPSBpbnN0YW5jZS0+aW5zdGFuY2V0LT5yZWFkX2Z3X3N0YXR1c19yZWcoCisJ
CQlpbnN0YW5jZS0+cmVnX3NldCkgJiBNRklfU1RBVEVfTUFTSzsKKwkJaWYgKGZ3X3N0YXRlID09
IE1GSV9TVEFURV9GQVVMVCkKKwkJCXNjaGVkdWxlX3dvcmsoJmluc3RhbmNlLT53b3JrX2luaXQp
OworCX0KKworCXJldHVybiBJUlFfSEFORExFRDsKK30KKworLyoqCisgKiBidWlsZF9tcHRfbWZp
X3Bhc3NfdGhydSAtIGJ1aWxkcyBhIGNtZCBmbyBNRkkgUGFzcyB0aHJ1CisgKiBAaW5zdGFuY2U6
CQkJQWRhcHRlciBzb2Z0IHN0YXRlCisgKiBtZmlfY21kOgkJCW1lZ2FzYXNfY21kIHBvaW50ZXIK
KyAqCisgKi8KK3U4CitidWlsZF9tcHRfbWZpX3Bhc3NfdGhydShzdHJ1Y3QgbWVnYXNhc19pbnN0
YW5jZSAqaW5zdGFuY2UsCisJCQlzdHJ1Y3QgbWVnYXNhc19jbWQgKm1maV9jbWQpCit7CisJc3Ry
dWN0IE1QSTI1X0lFRUVfU0dFX0NIQUlONjQgKm1waTI1X2llZWVfY2hhaW47CisJc3RydWN0IE1Q
STJfUkFJRF9TQ1NJX0lPX1JFUVVFU1QgKmlvX3JlcTsKKwlzdHJ1Y3QgbWVnYXNhc19jbWRfZnVz
aW9uICpjbWQ7CisJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb247CisJc3RydWN0IG1lZ2Fz
YXNfaGVhZGVyICpmcmFtZV9oZHIgPSAmbWZpX2NtZC0+ZnJhbWUtPmhkcjsKKworCWNtZCA9IG1l
Z2FzYXNfZ2V0X2NtZF9mdXNpb24oaW5zdGFuY2UpOworCWlmICghY21kKQorCQlyZXR1cm4gMTsK
KworCS8qICBTYXZlIHRoZSBzbWlkLiBUbyBiZSB1c2VkIGZvciByZXR1cm5pbmcgdGhlIGNtZCAq
LworCW1maV9jbWQtPmNvbnRleHQuc21pZCA9IGNtZC0+aW5kZXg7CisKKwljbWQtPnN5bmNfY21k
X2lkeCA9IG1maV9jbWQtPmluZGV4OworCisJLyoKKwkgKiBGb3IgY21kcyB3aGVyZSB0aGUgZmxh
ZyBpcyBzZXQsIHN0b3JlIHRoZSBmbGFnIGFuZCBjaGVjaworCSAqIG9uIGNvbXBsZXRpb24uIEZv
ciBjbWRzIHdpdGggdGhpcyBmbGFnLCBkb24ndCBjYWxsCisJICogbWVnYXNhc19jb21wbGV0ZV9j
bWQKKwkgKi8KKworCWlmIChmcmFtZV9oZHItPmZsYWdzICYgTUZJX0ZSQU1FX0RPTlRfUE9TVF9J
Tl9SRVBMWV9RVUVVRSkKKwkJY21kLT5mbGFncyA9IE1GSV9GUkFNRV9ET05UX1BPU1RfSU5fUkVQ
TFlfUVVFVUU7CisKKwlmdXNpb24gPSBpbnN0YW5jZS0+Y3RybF9jb250ZXh0OworCWlvX3JlcSA9
IGNtZC0+aW9fcmVxdWVzdDsKKwltcGkyNV9pZWVlX2NoYWluID0KKwkgIChzdHJ1Y3QgTVBJMjVf
SUVFRV9TR0VfQ0hBSU42NCAqKSZpb19yZXEtPlNHTC5JZWVlQ2hhaW47CisKKwlpb19yZXEtPkZ1
bmN0aW9uICAgID0gTUVHQVNBU19NUEkyX0ZVTkNUSU9OX1BBU1NUSFJVX0lPX1JFUVVFU1Q7CisJ
aW9fcmVxLT5TR0xPZmZzZXQwICA9IG9mZnNldG9mKHN0cnVjdCBNUEkyX1JBSURfU0NTSV9JT19S
RVFVRVNULAorCQkJCSAgICAgICBTR0wpIC8gNDsKKwlpb19yZXEtPkNoYWluT2Zmc2V0ID0gZnVz
aW9uLT5jaGFpbl9vZmZzZXRfbWZpX3B0aHJ1OworCisJbXBpMjVfaWVlZV9jaGFpbi0+QWRkcmVz
cyA9IG1maV9jbWQtPmZyYW1lX3BoeXNfYWRkcjsKKworCW1waTI1X2llZWVfY2hhaW4tPkZsYWdz
ID0gSUVFRV9TR0VfRkxBR1NfQ0hBSU5fRUxFTUVOVCB8CisJCU1QSTJfSUVFRV9TR0VfRkxBR1Nf
SU9DUExCTlRBX0FERFI7CisKKwltcGkyNV9pZWVlX2NoYWluLT5MZW5ndGggPSBNRUdBU0FTX01B
WF9TWl9DSEFJTl9GUkFNRTsKKworCXJldHVybiAwOworfQorCisvKioKKyAqIGJ1aWxkX21wdF9j
bWQgLSBDYWxscyBoZWxwZXIgZnVuY3Rpb24gdG8gYnVpbGQgYSBjbWQgTUZJIFBhc3MgdGhydSBj
bWQKKyAqIEBpbnN0YW5jZToJCQlBZGFwdGVyIHNvZnQgc3RhdGUKKyAqIEBjbWQ6CQkJbWZpIGNt
ZCB0byBidWlsZAorICoKKyAqLwordW5pb24gTUVHQVNBU19SRVFVRVNUX0RFU0NSSVBUT1JfVU5J
T04gKgorYnVpbGRfbXB0X2NtZChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UsIHN0
cnVjdCBtZWdhc2FzX2NtZCAqY21kKQoreworCXVuaW9uIE1FR0FTQVNfUkVRVUVTVF9ERVNDUklQ
VE9SX1VOSU9OICpyZXFfZGVzYzsKKwl1MTYgaW5kZXg7CisKKwlpZiAoYnVpbGRfbXB0X21maV9w
YXNzX3RocnUoaW5zdGFuY2UsIGNtZCkpIHsKKwkJcHJpbnRrKEtFUk5fRVJSICJDb3VsZG4ndCBi
dWlsZCBNRkkgcGFzcyB0aHJ1IGNtZFxuIik7CisJCXJldHVybiBOVUxMOworCX0KKworCWluZGV4
ID0gY21kLT5jb250ZXh0LnNtaWQ7CisKKwlyZXFfZGVzYyA9IG1lZ2FzYXNfZ2V0X3JlcXVlc3Rf
ZGVzY3JpcHRvcihpbnN0YW5jZSwgaW5kZXggLSAxKTsKKworCWlmICghcmVxX2Rlc2MpCisJCXJl
dHVybiBOVUxMOworCisJcmVxX2Rlc2MtPldvcmRzID0gMDsKKwlyZXFfZGVzYy0+U0NTSUlPLlJl
cXVlc3RGbGFncyA9IChNUEkyX1JFUV9ERVNDUklQVF9GTEFHU19TQ1NJX0lPIDw8CisJCQkJCSBN
RUdBU0FTX1JFUV9ERVNDUklQVF9GTEFHU19UWVBFX1NISUZUKTsKKworCXJlcV9kZXNjLT5TQ1NJ
SU8uU01JRCA9IGluZGV4OworCisJcmV0dXJuIHJlcV9kZXNjOworfQorCisvKioKKyAqIG1lZ2Fz
YXNfaXNzdWVfZGNtZF9mdXNpb24gLSBJc3N1ZXMgYSBNRkkgUGFzcyB0aHJ1IGNtZAorICogQGlu
c3RhbmNlOgkJCUFkYXB0ZXIgc29mdCBzdGF0ZQorICogQGNtZDoJCQltZmkgY21kIHBvaW50ZXIK
KyAqCisgKi8KK3ZvaWQKK21lZ2FzYXNfaXNzdWVfZGNtZF9mdXNpb24oc3RydWN0IG1lZ2FzYXNf
aW5zdGFuY2UgKmluc3RhbmNlLAorCQkJICBzdHJ1Y3QgbWVnYXNhc19jbWQgKmNtZCkKK3sKKwl1
bmlvbiBNRUdBU0FTX1JFUVVFU1RfREVTQ1JJUFRPUl9VTklPTiAqcmVxX2Rlc2M7CisJdW5pb24g
ZGVzY192YWx1ZSBkX3ZhbDsKKworCXJlcV9kZXNjID0gYnVpbGRfbXB0X2NtZChpbnN0YW5jZSwg
Y21kKTsKKwlpZiAoIXJlcV9kZXNjKSB7CisJCXByaW50ayhLRVJOX0VSUiAiQ291bGRuJ3QgaXNz
dWUgTUZJIHBhc3MgdGhydSBjbWRcbiIpOworCQlyZXR1cm47CisJfQorCWRfdmFsLndvcmQgPSBy
ZXFfZGVzYy0+V29yZHM7CisKKwlpbnN0YW5jZS0+aW5zdGFuY2V0LT5maXJlX2NtZChpbnN0YW5j
ZSwgcmVxX2Rlc2MtPnUubG93LAorCQkJCSAgICAgIHJlcV9kZXNjLT51LmhpZ2gsIGluc3RhbmNl
LT5yZWdfc2V0KTsKK30KKworLyoqCisgKiBtZWdhc2FzX3JlbGVhc2VfZnVzaW9uIC0JUmV2ZXJz
ZXMgdGhlIEZXIGluaXRpYWxpemF0aW9uCisgKiBAaW50YW5jZToJCQlBZGFwdGVyIHNvZnQgc3Rh
dGUKKyAqLwordm9pZAorbWVnYXNhc19yZWxlYXNlX2Z1c2lvbihzdHJ1Y3QgbWVnYXNhc19pbnN0
YW5jZSAqaW5zdGFuY2UpCit7CisJbWVnYXNhc19mcmVlX2NtZHMoaW5zdGFuY2UpOworCW1lZ2Fz
YXNfZnJlZV9jbWRzX2Z1c2lvbihpbnN0YW5jZSk7CisKKwlpb3VubWFwKGluc3RhbmNlLT5yZWdf
c2V0KTsKKworCXBjaV9yZWxlYXNlX3NlbGVjdGVkX3JlZ2lvbnMoaW5zdGFuY2UtPnBkZXYsIGlu
c3RhbmNlLT5iYXIpOworfQorCisvKioKKyAqIG1lZ2FzYXNfcmVhZF9md19zdGF0dXNfcmVnX2Z1
c2lvbiAtIHJldHVybnMgdGhlIGN1cnJlbnQgRlcgc3RhdHVzIHZhbHVlCisgKiBAcmVnczoJCQlN
RkkgcmVnaXN0ZXIgc2V0CisgKi8KK3N0YXRpYyB1MzIKK21lZ2FzYXNfcmVhZF9md19zdGF0dXNf
cmVnX2Z1c2lvbihzdHJ1Y3QgbWVnYXNhc19yZWdpc3Rlcl9zZXQgX19pb21lbSAqcmVncykKK3sK
KwlyZXR1cm4gcmVhZGwoJihyZWdzKS0+b3V0Ym91bmRfc2NyYXRjaF9wYWQpOworfQorCisvKioK
KyAqIG1lZ2FzYXNfYWRwX3Jlc2V0X2Z1c2lvbiAtCUZvciBjb250cm9sbGVyIHJlc2V0CisgKiBA
cmVnczoJCQkJTUZJIHJlZ2lzdGVyIHNldAorICovCitzdGF0aWMgaW50CittZWdhc2FzX2FkcF9y
ZXNldF9mdXNpb24oc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlLAorCQkJIHN0cnVj
dCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdzKQoreworCXJldHVybiAwOworfQor
CisvKioKKyAqIG1lZ2FzYXNfY2hlY2tfcmVzZXRfZnVzaW9uIC0JRm9yIGNvbnRyb2xsZXIgcmVz
ZXQgY2hlY2sKKyAqIEByZWdzOgkJCQlNRkkgcmVnaXN0ZXIgc2V0CisgKi8KK3N0YXRpYyBpbnQK
K21lZ2FzYXNfY2hlY2tfcmVzZXRfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0
YW5jZSwKKwkJCSAgIHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdzKQor
eworCXJldHVybiAwOworfQorCisvKiBUaGlzIGZ1bmN0aW9uIHdhaXRzIGZvciBvdXRzdGFuZGlu
ZyBjb21tYW5kcyBvbiBmdXNpb24gdG8gY29tcGxldGUgKi8KK2ludCBtZWdhc2FzX3dhaXRfZm9y
X291dHN0YW5kaW5nX2Z1c2lvbihzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCit7
CisJaW50IGksIG91dHN0YW5kaW5nLCByZXR2YWwgPSAwOworCXUzMiBmd19zdGF0ZSwgd2FpdF90
aW1lID0gTUVHQVNBU19SRVNFVF9XQUlUX1RJTUU7CisKKwlmb3IgKGkgPSAwOyBpIDwgd2FpdF90
aW1lOyBpKyspIHsKKwkJLyogQ2hlY2sgaWYgZmlybXdhcmUgaXMgaW4gZmF1bHQgc3RhdGUgKi8K
KwkJZndfc3RhdGUgPSBpbnN0YW5jZS0+aW5zdGFuY2V0LT5yZWFkX2Z3X3N0YXR1c19yZWcoCisJ
CQlpbnN0YW5jZS0+cmVnX3NldCkgJiBNRklfU1RBVEVfTUFTSzsKKwkJaWYgKGZ3X3N0YXRlID09
IE1GSV9TVEFURV9GQVVMVCkgeworCQkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXNhczogRm91
bmQgRlcgaW4gRkFVTFQgc3RhdGUsIgorCQkJICAgICAgICIgd2lsbCByZXNldCBhZGFwdGVyLlxu
Iik7CisJCQlyZXR2YWwgPSAxOworCQkJZ290byBvdXQ7CisJCX0KKworCQlvdXRzdGFuZGluZyA9
IGF0b21pY19yZWFkKCZpbnN0YW5jZS0+Zndfb3V0c3RhbmRpbmcpOworCQlpZiAoIW91dHN0YW5k
aW5nKQorCQkJZ290byBvdXQ7CisKKwkJaWYgKCEoaSAlIE1FR0FTQVNfUkVTRVRfTk9USUNFX0lO
VEVSVkFMKSkgeworCQkJcHJpbnRrKEtFUk5fTk9USUNFICJtZWdhc2FzOiBbJTJkXXdhaXRpbmcg
Zm9yICVkICIKKwkJCSAgICAgICAiY29tbWFuZHMgdG8gY29tcGxldGVcbiIsIGksIG91dHN0YW5k
aW5nKTsKKwkJCW1lZ2FzYXNfY29tcGxldGVfY21kX2RwY19mdXNpb24oCisJCQkJKHVuc2lnbmVk
IGxvbmcpaW5zdGFuY2UpOworCQl9CisJCW1zbGVlcCgxMDAwKTsKKwl9CisKKwlpZiAoYXRvbWlj
X3JlYWQoJmluc3RhbmNlLT5md19vdXRzdGFuZGluZykpIHsKKwkJcHJpbnRrKCJtZWdhcmFpZF9z
YXM6IHBlbmRpbmcgY29tbWFuZHMgcmVtYWluIGFmdGVyIHdhaXRpbmcsICIKKwkJICAgICAgICJ3
aWxsIHJlc2V0IGFkYXB0ZXIuXG4iKTsKKwkJcmV0dmFsID0gMTsKKwl9CitvdXQ6CisJcmV0dXJu
IHJldHZhbDsKK30KKwordm9pZCAgbWVnYXNhc19yZXNldF9yZXBseV9kZXNjKHN0cnVjdCBtZWdh
c2FzX2luc3RhbmNlICppbnN0YW5jZSkKK3sKKwlpbnQgaTsKKwlzdHJ1Y3QgZnVzaW9uX2NvbnRl
eHQgKmZ1c2lvbjsKKwl1bmlvbiBNUEkyX1JFUExZX0RFU0NSSVBUT1JTX1VOSU9OICpyZXBseV9k
ZXNjOworCisJZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKKwlmdXNpb24tPmxhc3Rf
cmVwbHlfaWR4ID0gMDsKKwlyZXBseV9kZXNjID0gZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzYzsK
Kwlmb3IgKGkgPSAwIDsgaSA8IGZ1c2lvbi0+cmVwbHlfcV9kZXB0aDsgaSsrLCByZXBseV9kZXNj
KyspCisJCXJlcGx5X2Rlc2MtPldvcmRzID0gVUxMT05HX01BWDsKK30KKworLyogQ29yZSBmdXNp
b24gcmVzZXQgZnVuY3Rpb24gKi8KK2ludCBtZWdhc2FzX3Jlc2V0X2Z1c2lvbihzdHJ1Y3QgU2Nz
aV9Ib3N0ICpzaG9zdCkKK3sKKwlpbnQgcmV0dmFsID0gU1VDQ0VTUywgaSwgaiwgcmV0cnkgPSAw
OworCXN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZTsKKwlzdHJ1Y3QgbWVnYXNhc19j
bWRfZnVzaW9uICpjbWRfZnVzaW9uOworCXN0cnVjdCBmdXNpb25fY29udGV4dCAqZnVzaW9uOwor
CXN0cnVjdCBtZWdhc2FzX2NtZCAqY21kX21maTsKKwl1bmlvbiBNRUdBU0FTX1JFUVVFU1RfREVT
Q1JJUFRPUl9VTklPTiAqcmVxX2Rlc2M7CisJdTMyIGhvc3RfZGlhZywgYWJzX3N0YXRlOworCisJ
aW5zdGFuY2UgPSAoc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKilzaG9zdC0+aG9zdGRhdGE7CisJ
ZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKKworCW11dGV4X2xvY2soJmluc3RhbmNl
LT5yZXNldF9tdXRleCk7CisJc2V0X2JpdChNRUdBU0FTX0ZVU0lPTl9JTl9SRVNFVCwgJmluc3Rh
bmNlLT5yZXNldF9mbGFncyk7CisJaW5zdGFuY2UtPmFkcHJlY292ZXJ5ID0gTUVHQVNBU19BRFBS
RVNFVF9TTV9JTkZBVUxUOworCWluc3RhbmNlLT5pbnN0YW5jZXQtPmRpc2FibGVfaW50cihpbnN0
YW5jZS0+cmVnX3NldCk7CisJbXNsZWVwKDEwMDApOworCisJaWYgKGluc3RhbmNlLT5hZHByZWNv
dmVyeSA9PSBNRUdBU0FTX0hXX0NSSVRJQ0FMX0VSUk9SKSB7CisJCXByaW50ayhLRVJOX1dBUk5J
TkcgIm1lZ2FyYWlkX3NhczogSGFyZHdhcmUgY3JpdGljYWwgZXJyb3IsICIKKwkJICAgICAgICJy
ZXR1cm5pbmcgRkFJTEVELlxuIik7CisJCXJldHZhbCA9IEZBSUxFRDsKKwkJZ290byBvdXQ7CisJ
fQorCisJLyogRmlyc3QgdHJ5IHdhaXRpbmcgZm9yIGNvbW1hbmRzIHRvIGNvbXBsZXRlICovCisJ
aWYgKG1lZ2FzYXNfd2FpdF9mb3Jfb3V0c3RhbmRpbmdfZnVzaW9uKGluc3RhbmNlKSkgeworCQlw
cmludGsoS0VSTl9XQVJOSU5HICJtZWdhcmFpZF9zYXM6IHJlc2V0dGluZyBmdXNpb24gIgorCQkg
ICAgICAgImFkYXB0ZXIuXG4iKTsKKwkJLyogTm93IHJldHVybiBjb21tYW5kcyBiYWNrIHRvIHRo
ZSBPUyAqLworCQlmb3IgKGkgPSAwIDsgaSA8IGluc3RhbmNlLT5tYXhfZndfY21kczsgaSsrKSB7
CisJCQljbWRfZnVzaW9uID0gZnVzaW9uLT5jbWRfbGlzdFtpXTsKKwkJCWlmIChjbWRfZnVzaW9u
LT5zY21kKSB7CisJCQkJc2NzaV9kbWFfdW5tYXAoY21kX2Z1c2lvbi0+c2NtZCk7CisJCQkJY21k
X2Z1c2lvbi0+c2NtZC0+cmVzdWx0ID0gKERJRF9SRVNFVCA8PCAxNik7CisJCQkJY21kX2Z1c2lv
bi0+c2NtZC0+c2NzaV9kb25lKGNtZF9mdXNpb24tPnNjbWQpOworCQkJCW1lZ2FzYXNfcmV0dXJu
X2NtZF9mdXNpb24oaW5zdGFuY2UsIGNtZF9mdXNpb24pOworCQkJCWF0b21pY19kZWMoJmluc3Rh
bmNlLT5md19vdXRzdGFuZGluZyk7CisJCQl9CisJCX0KKworCQlpZiAoaW5zdGFuY2UtPmRpc2Fi
bGVPbmxpbmVDdHJsUmVzZXQgPT0gMSkgeworCQkJLyogUmVzZXQgbm90IHN1cHBvcnRlZCwga2ls
bCBhZGFwdGVyICovCisJCQlwcmludGsoS0VSTl9XQVJOSU5HICJtZWdhcmFpZF9zYXM6IFJlc2V0
IG5vdCBzdXBwb3J0ZWQiCisJCQkgICAgICAgIiwga2lsbGluZyBhZGFwdGVyLlxuIik7CisJCQlt
ZWdhcmFpZF9zYXNfa2lsbF9oYmEoaW5zdGFuY2UpOworCQkJaW5zdGFuY2UtPmFkcHJlY292ZXJ5
ID0gTUVHQVNBU19IV19DUklUSUNBTF9FUlJPUjsKKwkJCXJldHZhbCA9IEZBSUxFRDsKKwkJCWdv
dG8gb3V0OworCQl9CisKKwkJLyogTm93IHRyeSB0byByZXNldCB0aGUgY2hpcCAqLworCQlmb3Ig
KGkgPSAwOyBpIDwgTUVHQVNBU19GVVNJT05fTUFYX1JFU0VUX1RSSUVTOyBpKyspIHsKKwkJCXdy
aXRlbChNUEkyX1dSU0VRX0ZMVVNIX0tFWV9WQUxVRSwKKwkJCSAgICAgICAmaW5zdGFuY2UtPnJl
Z19zZXQtPmZ1c2lvbl9zZXFfb2Zmc2V0KTsKKwkJCXdyaXRlbChNUEkyX1dSU0VRXzFTVF9LRVlf
VkFMVUUsCisJCQkgICAgICAgJmluc3RhbmNlLT5yZWdfc2V0LT5mdXNpb25fc2VxX29mZnNldCk7
CisJCQl3cml0ZWwoTVBJMl9XUlNFUV8yTkRfS0VZX1ZBTFVFLAorCQkJICAgICAgICZpbnN0YW5j
ZS0+cmVnX3NldC0+ZnVzaW9uX3NlcV9vZmZzZXQpOworCQkJd3JpdGVsKE1QSTJfV1JTRVFfM1JE
X0tFWV9WQUxVRSwKKwkJCSAgICAgICAmaW5zdGFuY2UtPnJlZ19zZXQtPmZ1c2lvbl9zZXFfb2Zm
c2V0KTsKKwkJCXdyaXRlbChNUEkyX1dSU0VRXzRUSF9LRVlfVkFMVUUsCisJCQkgICAgICAgJmlu
c3RhbmNlLT5yZWdfc2V0LT5mdXNpb25fc2VxX29mZnNldCk7CisJCQl3cml0ZWwoTVBJMl9XUlNF
UV81VEhfS0VZX1ZBTFVFLAorCQkJICAgICAgICZpbnN0YW5jZS0+cmVnX3NldC0+ZnVzaW9uX3Nl
cV9vZmZzZXQpOworCQkJd3JpdGVsKE1QSTJfV1JTRVFfNlRIX0tFWV9WQUxVRSwKKwkJCSAgICAg
ICAmaW5zdGFuY2UtPnJlZ19zZXQtPmZ1c2lvbl9zZXFfb2Zmc2V0KTsKKworCQkJLyogQ2hlY2sg
dGhhdCB0aGUgZGlhZyB3cml0ZSBlbmFibGUgKERSV0UpIGJpdCBpcyBvbiAqLworCQkJaG9zdF9k
aWFnID0gcmVhZGwoJmluc3RhbmNlLT5yZWdfc2V0LT5mdXNpb25faG9zdF9kaWFnKTsKKwkJCXdo
aWxlICghKGhvc3RfZGlhZyAmIEhPU1RfRElBR19XUklURV9FTkFCTEUpKSB7CisJCQkJbXNsZWVw
KDEwMCk7CisJCQkJaG9zdF9kaWFnID0KKwkJCQlyZWFkbCgmaW5zdGFuY2UtPnJlZ19zZXQtPmZ1
c2lvbl9ob3N0X2RpYWcpOworCQkJCWlmIChyZXRyeSsrID09IDEwMCkgeworCQkJCQlwcmludGso
S0VSTl9XQVJOSU5HICJtZWdhcmFpZF9zYXM6ICIKKwkJCQkJICAgICAgICJIb3N0IGRpYWcgdW5s
b2NrIGZhaWxlZCFcbiIpOworCQkJCQlicmVhazsKKwkJCQl9CisJCQl9CisJCQlpZiAoIShob3N0
X2RpYWcgJiBIT1NUX0RJQUdfV1JJVEVfRU5BQkxFKSkKKwkJCQljb250aW51ZTsKKworCQkJLyog
U2VuZCBjaGlwIHJlc2V0IGNvbW1hbmQgKi8KKwkJCXdyaXRlbChob3N0X2RpYWcgfCBIT1NUX0RJ
QUdfUkVTRVRfQURBUFRFUiwKKwkJCSAgICAgICAmaW5zdGFuY2UtPnJlZ19zZXQtPmZ1c2lvbl9o
b3N0X2RpYWcpOworCQkJbXNsZWVwKDMwMDApOworCisJCQkvKiBNYWtlIHN1cmUgcmVzZXQgYWRh
cHRlciBiaXQgaXMgY2xlYXJlZCAqLworCQkJaG9zdF9kaWFnID0gcmVhZGwoJmluc3RhbmNlLT5y
ZWdfc2V0LT5mdXNpb25faG9zdF9kaWFnKTsKKwkJCXJldHJ5ID0gMDsKKwkJCXdoaWxlIChob3N0
X2RpYWcgJiBIT1NUX0RJQUdfUkVTRVRfQURBUFRFUikgeworCQkJCW1zbGVlcCgxMDApOworCQkJ
CWhvc3RfZGlhZyA9CisJCQkJcmVhZGwoJmluc3RhbmNlLT5yZWdfc2V0LT5mdXNpb25faG9zdF9k
aWFnKTsKKwkJCQlpZiAocmV0cnkrKyA9PSAxMDAwKSB7CisJCQkJCXByaW50ayhLRVJOX1dBUk5J
TkcgIm1lZ2FyYWlkX3NhczogIgorCQkJCQkgICAgICAgIkRpYWcgcmVzZXQgYWRhcHRlciBuZXZl
ciAiCisJCQkJCSAgICAgICAiY2xlYXJlZCFcbiIpOworCQkJCQlicmVhazsKKwkJCQl9CisJCQl9
CisJCQlpZiAoaG9zdF9kaWFnICYgSE9TVF9ESUFHX1JFU0VUX0FEQVBURVIpCisJCQkJY29udGlu
dWU7CisKKwkJCWFic19zdGF0ZSA9CisJCQkJaW5zdGFuY2UtPmluc3RhbmNldC0+cmVhZF9md19z
dGF0dXNfcmVnKAorCQkJCQlpbnN0YW5jZS0+cmVnX3NldCk7CisJCQlyZXRyeSA9IDA7CisKKwkJ
CXdoaWxlICgoYWJzX3N0YXRlIDw9IE1GSV9TVEFURV9GV19JTklUKSAmJgorCQkJICAgICAgIChy
ZXRyeSsrIDwgMTAwMCkpIHsKKwkJCQltc2xlZXAoMTAwKTsKKwkJCQlhYnNfc3RhdGUgPQorCQkJ
CWluc3RhbmNlLT5pbnN0YW5jZXQtPnJlYWRfZndfc3RhdHVzX3JlZygKKwkJCQkJaW5zdGFuY2Ut
PnJlZ19zZXQpOworCQkJfQorCQkJaWYgKGFic19zdGF0ZSA8PSBNRklfU1RBVEVfRldfSU5JVCkg
eworCQkJCXByaW50ayhLRVJOX1dBUk5JTkcgIm1lZ2FyYWlkX3NhczogZmlybXdhcmUgIgorCQkJ
CSAgICAgICAic3RhdGUgPCBNRklfU1RBVEVfRldfSU5JVCwgc3RhdGUgPSAiCisJCQkJICAgICAg
ICIweCV4XG4iLCBhYnNfc3RhdGUpOworCQkJCWNvbnRpbnVlOworCQkJfQorCisJCQkvKiBXYWl0
IGZvciBGVyB0byBiZWNvbWUgcmVhZHkgKi8KKwkJCWlmIChtZWdhc2FzX3RyYW5zaXRpb25fdG9f
cmVhZHkoaW5zdGFuY2UpKSB7CisJCQkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXJhaWRfc2Fz
OiBGYWlsZWQgdG8gIgorCQkJCSAgICAgICAidHJhbnNpdGlvbiBjb250cm9sbGVyIHRvIHJlYWR5
LlxuIik7CisJCQkJY29udGludWU7CisJCQl9CisKKwkJCW1lZ2FzYXNfcmVzZXRfcmVwbHlfZGVz
YyhpbnN0YW5jZSk7CisJCQlpZiAobWVnYXNhc19pb2NfaW5pdF9mdXNpb24oaW5zdGFuY2UpKSB7
CisJCQkJcHJpbnRrKEtFUk5fV0FSTklORyAibWVnYXJhaWRfc2FzOiAiCisJCQkJICAgICAgICJt
ZWdhc2FzX2lvY19pbml0X2Z1c2lvbigpIGZhaWxlZCFcbiIpOworCQkJCWNvbnRpbnVlOworCQkJ
fQorCisJCQlpbnN0YW5jZS0+aW5zdGFuY2V0LT5lbmFibGVfaW50cihpbnN0YW5jZS0+cmVnX3Nl
dCk7CisJCQlpbnN0YW5jZS0+YWRwcmVjb3ZlcnkgPSBNRUdBU0FTX0hCQV9PUEVSQVRJT05BTDsK
KworCQkJLyogUmUtZmlyZSBtYW5hZ2VtZW50IGNvbW1hbmRzICovCisJCQlmb3IgKGogPSAwIDsg
aiA8IGluc3RhbmNlLT5tYXhfZndfY21kczsgaisrKSB7CisJCQkJY21kX2Z1c2lvbiA9IGZ1c2lv
bi0+Y21kX2xpc3Rbal07CisJCQkJaWYgKGNtZF9mdXNpb24tPnN5bmNfY21kX2lkeCAhPQorCQkJ
CSAgICAodTMyKVVMT05HX01BWCkgeworCQkJCQljbWRfbWZpID0KKwkJCQkJaW5zdGFuY2UtPgor
CQkJCQljbWRfbGlzdFtjbWRfZnVzaW9uLT5zeW5jX2NtZF9pZHhdOworCQkJCQlpZiAoY21kX21m
aS0+ZnJhbWUtPmRjbWQub3Bjb2RlID09CisJCQkJCSAgICBNUl9EQ01EX0xEX01BUF9HRVRfSU5G
TykgeworCQkJCQkJbWVnYXNhc19yZXR1cm5fY21kKGluc3RhbmNlLAorCQkJCQkJCQkgICBjbWRf
bWZpKTsKKwkJCQkJCW1lZ2FzYXNfcmV0dXJuX2NtZF9mdXNpb24oCisJCQkJCQkJaW5zdGFuY2Us
IGNtZF9mdXNpb24pOworCQkJCQl9IGVsc2UgIHsKKwkJCQkJCXJlcV9kZXNjID0KKwkJCQkJCW1l
Z2FzYXNfZ2V0X3JlcXVlc3RfZGVzY3JpcHRvcigKKwkJCQkJCQlpbnN0YW5jZSwKKwkJCQkJCQlj
bWRfbWZpLT5jb250ZXh0LnNtaWQKKwkJCQkJCQktMSk7CisJCQkJCQlpZiAoIXJlcV9kZXNjKQor
CQkJCQkJCXByaW50ayhLRVJOX1dBUk5JTkcKKwkJCQkJCQkgICAgICAgInJlcV9kZXNjIE5VTEwi
CisJCQkJCQkJICAgICAgICJcbiIpOworCQkJCQkJZWxzZSB7CisJCQkJCQkJaW5zdGFuY2UtPmlu
c3RhbmNldC0+CisJCQkJCQkJZmlyZV9jbWQoaW5zdGFuY2UsCisJCQkJCQkJCSByZXFfZGVzYy0+
CisJCQkJCQkJCSB1LmxvdywKKwkJCQkJCQkJIHJlcV9kZXNjLT4KKwkJCQkJCQkJIHUuaGlnaCwK
KwkJCQkJCQkJIGluc3RhbmNlLT4KKwkJCQkJCQkJIHJlZ19zZXQpOworCQkJCQkJfQorCQkJCQl9
CisJCQkJfQorCQkJfQorCisJCQkvKiBSZXNldCBsb2FkIGJhbGFuY2UgaW5mbyAqLworCQkJbWVt
c2V0KGZ1c2lvbi0+bG9hZF9iYWxhbmNlX2luZm8sIDAsCisJCQkgICAgICAgc2l6ZW9mKHN0cnVj
dCBMRF9MT0FEX0JBTEFOQ0VfSU5GTykKKwkJCSAgICAgICAqTUFYX0xPR0lDQUxfRFJJVkVTKTsK
KworCQkJaWYgKCFtZWdhc2FzX2dldF9tYXBfaW5mbyhpbnN0YW5jZSkpCisJCQkJbWVnYXNhc19z
eW5jX21hcF9pbmZvKGluc3RhbmNlKTsKKworCQkJLyogQWRhcHRlciByZXNldCBjb21wbGV0ZWQg
c3VjY2Vzc2Z1bGx5ICovCisJCQlwcmludGsoS0VSTl9XQVJOSU5HICJtZWdhcmFpZF9zYXM6IFJl
c2V0ICIKKwkJCSAgICAgICAic3VjY2Vzc2Z1bC5cbiIpOworCQkJcmV0dmFsID0gU1VDQ0VTUzsK
KwkJCWdvdG8gb3V0OworCQl9CisJCS8qIFJlc2V0IGZhaWxlZCwga2lsbCB0aGUgYWRhcHRlciAq
LworCQlwcmludGsoS0VSTl9XQVJOSU5HICJtZWdhcmFpZF9zYXM6IFJlc2V0IGZhaWxlZCwga2ls
bGluZyAiCisJCSAgICAgICAiYWRhcHRlci5cbiIpOworCQltZWdhcmFpZF9zYXNfa2lsbF9oYmEo
aW5zdGFuY2UpOworCQlyZXR2YWwgPSBGQUlMRUQ7CisJfSBlbHNlIHsKKwkJaW5zdGFuY2UtPmlu
c3RhbmNldC0+ZW5hYmxlX2ludHIoaW5zdGFuY2UtPnJlZ19zZXQpOworCQlpbnN0YW5jZS0+YWRw
cmVjb3ZlcnkgPSBNRUdBU0FTX0hCQV9PUEVSQVRJT05BTDsKKwl9CitvdXQ6CisJY2xlYXJfYml0
KE1FR0FTQVNfRlVTSU9OX0lOX1JFU0VULCAmaW5zdGFuY2UtPnJlc2V0X2ZsYWdzKTsKKwltdXRl
eF91bmxvY2soJmluc3RhbmNlLT5yZXNldF9tdXRleCk7CisJcmV0dXJuIHJldHZhbDsKK30KKwor
LyogRnVzaW9uIE9DUiB3b3JrIHF1ZXVlICovCit2b2lkIG1lZ2FzYXNfZnVzaW9uX29jcl93cShz
dHJ1Y3Qgd29ya19zdHJ1Y3QgKndvcmspCit7CisJc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmlu
c3RhbmNlID0KKwkJY29udGFpbmVyX29mKHdvcmssIHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlLCB3
b3JrX2luaXQpOworCisJbWVnYXNhc19yZXNldF9mdXNpb24oaW5zdGFuY2UtPmhvc3QpOworfQor
CitzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZV90ZW1wbGF0ZSBtZWdhc2FzX2luc3RhbmNlX3RlbXBs
YXRlX2Z1c2lvbiA9IHsKKwkuZmlyZV9jbWQgPSBtZWdhc2FzX2ZpcmVfY21kX2Z1c2lvbiwKKwku
ZW5hYmxlX2ludHIgPSBtZWdhc2FzX2VuYWJsZV9pbnRyX2Z1c2lvbiwKKwkuZGlzYWJsZV9pbnRy
ID0gbWVnYXNhc19kaXNhYmxlX2ludHJfZnVzaW9uLAorCS5jbGVhcl9pbnRyID0gbWVnYXNhc19j
bGVhcl9pbnRyX2Z1c2lvbiwKKwkucmVhZF9md19zdGF0dXNfcmVnID0gbWVnYXNhc19yZWFkX2Z3
X3N0YXR1c19yZWdfZnVzaW9uLAorCS5hZHBfcmVzZXQgPSBtZWdhc2FzX2FkcF9yZXNldF9mdXNp
b24sCisJLmNoZWNrX3Jlc2V0ID0gbWVnYXNhc19jaGVja19yZXNldF9mdXNpb24sCisJLnNlcnZp
Y2VfaXNyID0gbWVnYXNhc19pc3JfZnVzaW9uLAorCS50YXNrbGV0ID0gbWVnYXNhc19jb21wbGV0
ZV9jbWRfZHBjX2Z1c2lvbiwKKwkuaW5pdF9hZGFwdGVyID0gbWVnYXNhc19pbml0X2FkYXB0ZXJf
ZnVzaW9uLAorCS5idWlsZF9hbmRfaXNzdWVfY21kID0gbWVnYXNhc19idWlsZF9hbmRfaXNzdWVf
Y21kX2Z1c2lvbiwKKwkuaXNzdWVfZGNtZCA9IG1lZ2FzYXNfaXNzdWVfZGNtZF9mdXNpb24sCit9
OwpkaWZmIC1OYXVyIGxpbnV4LTIuNi4zNy1yYzUub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfZnVzaW9uLmggbGludXgtMi42LjM3LXJjNS5uZXcvZHJpdmVycy9zY3NpL21l
Z2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uaAotLS0gbGludXgtMi42LjM3LXJjNS5vbGQvZHJp
dmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uaAkxOTY5LTEyLTMxIDE2OjAw
OjAwLjAwMDAwMDAwMCAtMDgwMAorKysgbGludXgtMi42LjM3LXJjNS5uZXcvZHJpdmVycy9zY3Np
L21lZ2FyYWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uaAkyMDEwLTEyLTIxIDExOjA0OjA3LjAwMDAw
MDAwMCAtMDgwMApAQCAtMCwwICsxLDY5NSBAQAorLyoKKyAqICBMaW51eCBNZWdhUkFJRCBkcml2
ZXIgZm9yIFNBUyBiYXNlZCBSQUlEIGNvbnRyb2xsZXJzCisgKgorICogIENvcHlyaWdodCAoYykg
MjAwOS0yMDExICBMU0kgQ29ycG9yYXRpb24uCisgKgorICogIFRoaXMgcHJvZ3JhbSBpcyBmcmVl
IHNvZnR3YXJlOyB5b3UgY2FuIHJlZGlzdHJpYnV0ZSBpdCBhbmQvb3IKKyAqICBtb2RpZnkgaXQg
dW5kZXIgdGhlIHRlcm1zIG9mIHRoZSBHTlUgR2VuZXJhbCBQdWJsaWMgTGljZW5zZQorICogIGFz
IHB1Ymxpc2hlZCBieSB0aGUgRnJlZSBTb2Z0d2FyZSBGb3VuZGF0aW9uOyBlaXRoZXIgdmVyc2lv
biAyCisgKiAgb2YgdGhlIExpY2Vuc2UsIG9yIChhdCB5b3VyIG9wdGlvbikgYW55IGxhdGVyIHZl
cnNpb24uCisgKgorICogIFRoaXMgcHJvZ3JhbSBpcyBkaXN0cmlidXRlZCBpbiB0aGUgaG9wZSB0
aGF0IGl0IHdpbGwgYmUgdXNlZnVsLAorICogIGJ1dCBXSVRIT1VUIEFOWSBXQVJSQU5UWTsgd2l0
aG91dCBldmVuIHRoZSBpbXBsaWVkIHdhcnJhbnR5IG9mCisgKiAgTUVSQ0hBTlRBQklMSVRZIG9y
IEZJVE5FU1MgRk9SIEEgUEFSVElDVUxBUiBQVVJQT1NFLiAgU2VlIHRoZQorICogIEdOVSBHZW5l
cmFsIFB1YmxpYyBMaWNlbnNlIGZvciBtb3JlIGRldGFpbHMuCisgKgorICogIFlvdSBzaG91bGQg
aGF2ZSByZWNlaXZlZCBhIGNvcHkgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBMaWNlbnNlCisg
KiAgYWxvbmcgd2l0aCB0aGlzIHByb2dyYW07IGlmIG5vdCwgd3JpdGUgdG8gdGhlIEZyZWUgU29m
dHdhcmUKKyAqICBGb3VuZGF0aW9uLCBJbmMuLCA1OSBUZW1wbGUgUGxhY2UsIFN1aXRlIDMzMCwg
Qm9zdG9uLCBNQSAwMjExMS0xMzA3IFVTQQorICoKKyAqICBGSUxFOiBtZWdhcmFpZF9zYXNfZnVz
aW9uLmgKKyAqCisgKiAgQXV0aG9yczogTFNJIENvcnBvcmF0aW9uCisgKiAgICAgICAgICAgTWFu
b2ogSm9zZQorICogICAgICAgICAgIFN1bWFudCBQYXRybworICoKKyAqICBTZW5kIGZlZWRiYWNr
IHRvOiA8bWVnYXJhaWRsaW51eEBsc2kuY29tPgorICoKKyAqICBNYWlsIHRvOiBMU0kgQ29ycG9y
YXRpb24sIDE2MjEgQmFyYmVyIExhbmUsIE1pbHBpdGFzLCBDQSA5NTAzNQorICogICAgIEFUVE46
IExpbnV4cmFpZAorICovCisKKyNpZm5kZWYgX01FR0FSQUlEX1NBU19GVVNJT05fSF8KKyNkZWZp
bmUgX01FR0FSQUlEX1NBU19GVVNJT05fSF8KKworLyogRnVzaW9uIGRlZmluZXMgKi8KKyNkZWZp
bmUgTUVHQVNBU19NQVhfU1pfQ0hBSU5fRlJBTUUgMTAyNAorI2RlZmluZSBNRklfRlVTSU9OX0VO
QUJMRV9JTlRFUlJVUFRfTUFTSyAoMHgwMDAwMDAwOSkKKyNkZWZpbmUgTUVHQV9NUEkyX1JBSURf
REVGQVVMVF9JT19GUkFNRV9TSVpFIDI1NgorI2RlZmluZSBNRUdBU0FTX01QSTJfRlVOQ1RJT05f
UEFTU1RIUlVfSU9fUkVRVUVTVCAgIDB4RjAKKyNkZWZpbmUgTUVHQVNBU19NUEkyX0ZVTkNUSU9O
X0xEX0lPX1JFUVVFU1QgICAgICAgICAweEYxCisjZGVmaW5lIE1FR0FTQVNfTE9BRF9CQUxBTkNF
X0ZMQUcJCSAgICAweDEKKyNkZWZpbmUgTUVHQVNBU19EQ01EX01CT1hfUEVORF9GTEFHCQkgICAg
MHgxCisjZGVmaW5lIEhPU1RfRElBR19XUklURV9FTkFCTEUJCQkgICAgMHg4MAorI2RlZmluZSBI
T1NUX0RJQUdfUkVTRVRfQURBUFRFUgkJCSAgICAweDQKKyNkZWZpbmUgTUVHQVNBU19GVVNJT05f
TUFYX1JFU0VUX1RSSUVTCQkgICAgMworCisvKiBUMTAgUEkgZGVmaW5lcyAqLworI2RlZmluZSBN
Ul9QUk9UX0lORk9fVFlQRV9DT05UUk9MTEVSICAgICAgICAgICAgICAgIDB4OAorI2RlZmluZSBN
RUdBU0FTX1NDU0lfVkFSSUFCTEVfTEVOR1RIX0NNRCAgICAgICAgICAgIDB4N2YKKyNkZWZpbmUg
TUVHQVNBU19TQ1NJX1NFUlZJQ0VfQUNUSU9OX1JFQUQzMiAgICAgICAgICAweDkKKyNkZWZpbmUg
TUVHQVNBU19TQ1NJX1NFUlZJQ0VfQUNUSU9OX1dSSVRFMzIgICAgICAgICAweEIKKyNkZWZpbmUg
TUVHQVNBU19TQ1NJX0FERExfQ0RCX0xFTiAgICAgICAgICAgICAgICAgICAweDE4CisjZGVmaW5l
IE1FR0FTQVNfUkRfV1JfUFJPVEVDVF9DSEVDS19BTEwJCSAgICAweDIwCisjZGVmaW5lIE1FR0FT
QVNfUkRfV1JfUFJPVEVDVF9DSEVDS19OT05FCSAgICAweDYwCisjZGVmaW5lIE1FR0FTQVNfRUVE
UEJMT0NLU0laRQkJCSAgICA1MTIKKworLyoKKyAqIFJhaWQgY29udGV4dCBmbGFncworICovCisK
KyNkZWZpbmUgTVJfUkFJRF9DVFhfUkFJRF9GTEFHU19JT19TVUJfVFlQRV9TSElGVCAgIDB4NAor
I2RlZmluZSBNUl9SQUlEX0NUWF9SQUlEX0ZMQUdTX0lPX1NVQl9UWVBFX01BU0sgICAgMHgzMAor
ZW51bSBNUl9SQUlEX0ZMQUdTX0lPX1NVQl9UWVBFIHsKKwlNUl9SQUlEX0ZMQUdTX0lPX1NVQl9U
WVBFX05PTkUgPSAwLAorCU1SX1JBSURfRkxBR1NfSU9fU1VCX1RZUEVfU1lTVEVNX1BEID0gMSwK
K307CisKKy8qCisgKiBSZXF1ZXN0IGRlc2NyaXB0b3IgdHlwZXMKKyAqLworI2RlZmluZSBNRUdB
U0FTX1JFUV9ERVNDUklQVF9GTEFHU19MRF9JTyAgICAgICAgICAgMHg3CisjZGVmaW5lIE1FR0FT
QVNfUkVRX0RFU0NSSVBUX0ZMQUdTX01GQSAgICAgICAgICAgICAweDEKKworI2RlZmluZSBNRUdB
U0FTX1JFUV9ERVNDUklQVF9GTEFHU19UWVBFX1NISUZUICAgICAgMQorCisjZGVmaW5lIE1FR0FT
QVNfRlBfQ01EX0xFTgkxNgorI2RlZmluZSBNRUdBU0FTX0ZVU0lPTl9JTl9SRVNFVCAwCisKKy8q
CisgKiBSYWlkIENvbnRleHQgc3RydWN0dXJlIHdoaWNoIGRlc2NyaWJlcyBNZWdhUkFJRCBzcGVj
aWZpYyBJTyBQYXJhbWVudGVycworICogVGhpcyByZXNpZGVzIGF0IG9mZnNldCAweDYwIHdoZXJl
IHRoZSBTR0wgbm9ybWFsbHkgc3RhcnRzIGluIE1QVCBJTyBGcmFtZXMKKyAqLworCitzdHJ1Y3Qg
UkFJRF9DT05URVhUIHsKKwl1MTYgICAgIHJlc3ZkMDsKKwl1MTYgICAgIHRpbWVvdXRWYWx1ZTsK
Kwl1OCAgICAgIHJlZ0xvY2tGbGFnczsKKwl1OCAgICAgIHJlc3ZkMTsKKwl1MTYgICAgIFZpcnR1
YWxEaXNrVGd0SWQ7CisJdTY0ICAgICByZWdMb2NrUm93TEJBOworCXUzMiAgICAgcmVnTG9ja0xl
bmd0aDsKKwl1MTYgICAgIG5leHRMTUlkOworCXU4ICAgICAgZXhTdGF0dXM7CisJdTggICAgICBz
dGF0dXM7CisJdTggICAgICBSQUlERmxhZ3M7CisJdTggICAgICBudW1TR0U7CisJdTE2CWNvbmZp
Z1NlcU51bTsKKwl1OCAgICAgIHNwYW5Bcm07CisJdTggICAgICByZXN2ZDJbM107Cit9OworCisj
ZGVmaW5lIFJBSURfQ1RYX1NQQU5BUk1fQVJNX1NISUZUCSgwKQorI2RlZmluZSBSQUlEX0NUWF9T
UEFOQVJNX0FSTV9NQVNLCSgweDFmKQorCisjZGVmaW5lIFJBSURfQ1RYX1NQQU5BUk1fU1BBTl9T
SElGVAkoNSkKKyNkZWZpbmUgUkFJRF9DVFhfU1BBTkFSTV9TUEFOX01BU0sJKDB4RTApCisKKy8q
CisgKiBkZWZpbmUgcmVnaW9uIGxvY2sgdHlwZXMKKyAqLworZW51bSBSRUdJT05fVFlQRSB7CisJ
UkVHSU9OX1RZUEVfVU5VU0VEICAgICAgID0gMCwKKwlSRUdJT05fVFlQRV9TSEFSRURfUkVBRCAg
PSAxLAorCVJFR0lPTl9UWVBFX1NIQVJFRF9XUklURSA9IDIsCisJUkVHSU9OX1RZUEVfRVhDTFVT
SVZFICAgID0gMywKK307CisKKy8qIE1QSTIgZGVmaW5lcyAqLworI2RlZmluZSBNUEkyX0ZVTkNU
SU9OX0lPQ19JTklUICAgICAgICAgICAgICAoMHgwMikgLyogSU9DIEluaXQgKi8KKyNkZWZpbmUg
TVBJMl9XSE9JTklUX0hPU1RfRFJJVkVSICAgICAgICAgICAgKDB4MDQpCisjZGVmaW5lIE1QSTJf
VkVSU0lPTl9NQUpPUiAgICAgICAgICAgICAgICAgICgweDAyKQorI2RlZmluZSBNUEkyX1ZFUlNJ
T05fTUlOT1IgICAgICAgICAgICAgICAgICAoMHgwMCkKKyNkZWZpbmUgTVBJMl9WRVJTSU9OX01B
Sk9SX01BU0sgICAgICAgICAgICAgKDB4RkYwMCkKKyNkZWZpbmUgTVBJMl9WRVJTSU9OX01BSk9S
X1NISUZUICAgICAgICAgICAgKDgpCisjZGVmaW5lIE1QSTJfVkVSU0lPTl9NSU5PUl9NQVNLICAg
ICAgICAgICAgICgweDAwRkYpCisjZGVmaW5lIE1QSTJfVkVSU0lPTl9NSU5PUl9TSElGVCAgICAg
ICAgICAgICgwKQorI2RlZmluZSBNUEkyX1ZFUlNJT04gKChNUEkyX1ZFUlNJT05fTUFKT1IgPDwg
TVBJMl9WRVJTSU9OX01BSk9SX1NISUZUKSB8IFwKKwkJICAgICAgTVBJMl9WRVJTSU9OX01JTk9S
KQorI2RlZmluZSBNUEkyX0hFQURFUl9WRVJTSU9OX1VOSVQgICAgICAgICAgICAoMHgxMCkKKyNk
ZWZpbmUgTVBJMl9IRUFERVJfVkVSU0lPTl9ERVYgICAgICAgICAgICAgKDB4MDApCisjZGVmaW5l
IE1QSTJfSEVBREVSX1ZFUlNJT05fVU5JVF9NQVNLICAgICAgICgweEZGMDApCisjZGVmaW5lIE1Q
STJfSEVBREVSX1ZFUlNJT05fVU5JVF9TSElGVCAgICAgICg4KQorI2RlZmluZSBNUEkyX0hFQURF
Ul9WRVJTSU9OX0RFVl9NQVNLICAgICAgICAoMHgwMEZGKQorI2RlZmluZSBNUEkyX0hFQURFUl9W
RVJTSU9OX0RFVl9TSElGVCAgICAgICAoMCkKKyNkZWZpbmUgTVBJMl9IRUFERVJfVkVSU0lPTiAo
KE1QSTJfSEVBREVSX1ZFUlNJT05fVU5JVCA8PCA4KSB8IFwKKwkJCSAgICAgTVBJMl9IRUFERVJf
VkVSU0lPTl9ERVYpCisjZGVmaW5lIE1QSTJfSUVFRV9TR0VfRkxBR1NfSU9DUExCTlRBX0FERFIg
ICAgICAoMHgwMykKKyNkZWZpbmUgTVBJMl9TQ1NJSU9fRUVEUEZMQUdTX0lOQ19QUklfUkVGVEFH
ICAgICAgICAoMHg4MDAwKQorI2RlZmluZSBNUEkyX1NDU0lJT19FRURQRkxBR1NfQ0hFQ0tfUkVG
VEFHICAgICAgICAgICgweDA0MDApCisjZGVmaW5lIE1QSTJfU0NTSUlPX0VFRFBGTEFHU19DSEVD
S19SRU1PVkVfT1AgICAgICAgKDB4MDAwMykKKyNkZWZpbmUgTVBJMl9TQ1NJSU9fRUVEUEZMQUdT
X0NIRUNLX0FQUFRBRyAgICAgICAgICAoMHgwMjAwKQorI2RlZmluZSBNUEkyX1NDU0lJT19FRURQ
RkxBR1NfQ0hFQ0tfR1VBUkQgICAgICAgICAgICgweDAxMDApCisjZGVmaW5lIE1QSTJfU0NTSUlP
X0VFRFBGTEFHU19JTlNFUlRfT1AgICAgICAgICAgICAgKDB4MDAwNCkKKyNkZWZpbmUgTVBJMl9G
VU5DVElPTl9TQ1NJX0lPX1JFUVVFU1QgICAgICAgICAgICAgICAoMHgwMCkgLyogU0NTSSBJTyAq
LworI2RlZmluZSBNUEkyX1JFUV9ERVNDUklQVF9GTEFHU19ISUdIX1BSSU9SSVRZICAgICAgICAg
ICAoMHgwNikKKyNkZWZpbmUgTVBJMl9SRVFfREVTQ1JJUFRfRkxBR1NfU0NTSV9JTyAgICAgICAg
ICAgICAgICAgKDB4MDApCisjZGVmaW5lIE1QSTJfU0dFX0ZMQUdTXzY0X0JJVF9BRERSRVNTSU5H
ICAgICAgICAoMHgwMikKKyNkZWZpbmUgTVBJMl9TQ1NJSU9fQ09OVFJPTF9XUklURSAgICAgICAg
ICAgICAgICgweDAxMDAwMDAwKQorI2RlZmluZSBNUEkyX1NDU0lJT19DT05UUk9MX1JFQUQgICAg
ICAgICAgICAgICAgKDB4MDIwMDAwMDApCisjZGVmaW5lIE1QSTJfUkVRX0RFU0NSSVBUX0ZMQUdT
X1RZUEVfTUFTSyAgICAgICAoMHgwRSkKKyNkZWZpbmUgTVBJMl9SUFlfREVTQ1JJUFRfRkxBR1Nf
VU5VU0VEICAgICAgICAgICgweDBGKQorI2RlZmluZSBNUEkyX1JQWV9ERVNDUklQVF9GTEFHU19T
Q1NJX0lPX1NVQ0NFU1MgKDB4MDApCisjZGVmaW5lIE1QSTJfUlBZX0RFU0NSSVBUX0ZMQUdTX1RZ
UEVfTUFTSyAgICAgICAoMHgwRikKKyNkZWZpbmUgTVBJMl9XUlNFUV9GTFVTSF9LRVlfVkFMVUUg
ICAgICAgICAgICAgICgweDApCisjZGVmaW5lIE1QSTJfV1JJVEVfU0VRVUVOQ0VfT0ZGU0VUICAg
ICAgICAgICAgICAoMHgwMDAwMDAwNCkKKyNkZWZpbmUgTVBJMl9XUlNFUV8xU1RfS0VZX1ZBTFVF
ICAgICAgICAgICAgICAgICgweEYpCisjZGVmaW5lIE1QSTJfV1JTRVFfMk5EX0tFWV9WQUxVRSAg
ICAgICAgICAgICAgICAoMHg0KQorI2RlZmluZSBNUEkyX1dSU0VRXzNSRF9LRVlfVkFMVUUgICAg
ICAgICAgICAgICAgKDB4QikKKyNkZWZpbmUgTVBJMl9XUlNFUV80VEhfS0VZX1ZBTFVFICAgICAg
ICAgICAgICAgICgweDIpCisjZGVmaW5lIE1QSTJfV1JTRVFfNVRIX0tFWV9WQUxVRSAgICAgICAg
ICAgICAgICAoMHg3KQorI2RlZmluZSBNUEkyX1dSU0VRXzZUSF9LRVlfVkFMVUUgICAgICAgICAg
ICAgICAgKDB4RCkKKworc3RydWN0IE1QSTI1X0lFRUVfU0dFX0NIQUlONjQgeworCXU2NCAgICAg
ICAgICAgICAgICAgICAgIEFkZHJlc3M7CisJdTMyICAgICAgICAgICAgICAgICAgICAgTGVuZ3Ro
OworCXUxNiAgICAgICAgICAgICAgICAgICAgIFJlc2VydmVkMTsKKwl1OCAgICAgICAgICAgICAg
ICAgICAgICBOZXh0Q2hhaW5PZmZzZXQ7CisJdTggICAgICAgICAgICAgICAgICAgICAgRmxhZ3M7
Cit9OworCitzdHJ1Y3QgTVBJMl9TR0VfU0lNUExFX1VOSU9OIHsKKwl1MzIgICAgICAgICAgICAg
ICAgICAgICBGbGFnc0xlbmd0aDsKKwl1bmlvbiB7CisJCXUzMiAgICAgICAgICAgICAgICAgQWRk
cmVzczMyOworCQl1NjQgICAgICAgICAgICAgICAgIEFkZHJlc3M2NDsKKwl9IHU7Cit9OworCitz
dHJ1Y3QgTVBJMl9TQ1NJX0lPX0NEQl9FRURQMzIgeworCXU4ICAgICAgICAgICAgICAgICAgICAg
IENEQlsyMF07ICAgICAgICAgICAgICAgICAgICAvKiAweDAwICovCisJdTMyICAgICAgICAgICAg
ICAgICAgICAgUHJpbWFyeVJlZmVyZW5jZVRhZzsgICAgICAgIC8qIDB4MTQgKi8KKwl1MTYgICAg
ICAgICAgICAgICAgICAgICBQcmltYXJ5QXBwbGljYXRpb25UYWc7ICAgICAgLyogMHgxOCAqLwor
CXUxNiAgICAgICAgICAgICAgICAgICAgIFByaW1hcnlBcHBsaWNhdGlvblRhZ01hc2s7ICAvKiAw
eDFBICovCisJdTMyICAgICAgICAgICAgICAgICAgICAgVHJhbnNmZXJMZW5ndGg7ICAgICAgICAg
ICAgIC8qIDB4MUMgKi8KK307CisKK3N0cnVjdCBNUEkyX1NHRV9DSEFJTl9VTklPTiB7CisJdTE2
ICAgICAgICAgICAgICAgICAgICAgTGVuZ3RoOworCXU4ICAgICAgICAgICAgICAgICAgICAgIE5l
eHRDaGFpbk9mZnNldDsKKwl1OCAgICAgICAgICAgICAgICAgICAgICBGbGFnczsKKwl1bmlvbiB7
CisJCXUzMiAgICAgICAgICAgICAgICAgQWRkcmVzczMyOworCQl1NjQgICAgICAgICAgICAgICAg
IEFkZHJlc3M2NDsKKwl9IHU7Cit9OworCitzdHJ1Y3QgTVBJMl9JRUVFX1NHRV9TSU1QTEUzMiB7
CisJdTMyICAgICAgICAgICAgICAgICAgICAgQWRkcmVzczsKKwl1MzIgICAgICAgICAgICAgICAg
ICAgICBGbGFnc0xlbmd0aDsKK307CisKK3N0cnVjdCBNUEkyX0lFRUVfU0dFX0NIQUlOMzIgewor
CXUzMiAgICAgICAgICAgICAgICAgICAgIEFkZHJlc3M7CisJdTMyICAgICAgICAgICAgICAgICAg
ICAgRmxhZ3NMZW5ndGg7Cit9OworCitzdHJ1Y3QgTVBJMl9JRUVFX1NHRV9TSU1QTEU2NCB7CisJ
dTY0ICAgICAgICAgICAgICAgICAgICAgQWRkcmVzczsKKwl1MzIgICAgICAgICAgICAgICAgICAg
ICBMZW5ndGg7CisJdTE2ICAgICAgICAgICAgICAgICAgICAgUmVzZXJ2ZWQxOworCXU4ICAgICAg
ICAgICAgICAgICAgICAgIFJlc2VydmVkMjsKKwl1OCAgICAgICAgICAgICAgICAgICAgICBGbGFn
czsKK307CisKK3N0cnVjdCBNUEkyX0lFRUVfU0dFX0NIQUlONjQgeworCXU2NCAgICAgICAgICAg
ICAgICAgICAgIEFkZHJlc3M7CisJdTMyICAgICAgICAgICAgICAgICAgICAgTGVuZ3RoOworCXUx
NiAgICAgICAgICAgICAgICAgICAgIFJlc2VydmVkMTsKKwl1OCAgICAgICAgICAgICAgICAgICAg
ICBSZXNlcnZlZDI7CisJdTggICAgICAgICAgICAgICAgICAgICAgRmxhZ3M7Cit9OworCit1bmlv
biBNUEkyX0lFRUVfU0dFX1NJTVBMRV9VTklPTiB7CisJc3RydWN0IE1QSTJfSUVFRV9TR0VfU0lN
UExFMzIgIFNpbXBsZTMyOworCXN0cnVjdCBNUEkyX0lFRUVfU0dFX1NJTVBMRTY0ICBTaW1wbGU2
NDsKK307CisKK3VuaW9uIE1QSTJfSUVFRV9TR0VfQ0hBSU5fVU5JT04geworCXN0cnVjdCBNUEky
X0lFRUVfU0dFX0NIQUlOMzIgICBDaGFpbjMyOworCXN0cnVjdCBNUEkyX0lFRUVfU0dFX0NIQUlO
NjQgICBDaGFpbjY0OworfTsKKwordW5pb24gTVBJMl9TR0VfSU9fVU5JT04geworCXN0cnVjdCBN
UEkyX1NHRV9TSU1QTEVfVU5JT04gICAgICAgTXBpU2ltcGxlOworCXN0cnVjdCBNUEkyX1NHRV9D
SEFJTl9VTklPTiAgICAgICAgTXBpQ2hhaW47CisJdW5pb24gTVBJMl9JRUVFX1NHRV9TSU1QTEVf
VU5JT04gIEllZWVTaW1wbGU7CisJdW5pb24gTVBJMl9JRUVFX1NHRV9DSEFJTl9VTklPTiAgIEll
ZWVDaGFpbjsKK307CisKK3VuaW9uIE1QSTJfU0NTSV9JT19DREJfVU5JT04geworCXU4ICAgICAg
ICAgICAgICAgICAgICAgIENEQjMyWzMyXTsKKwlzdHJ1Y3QgTVBJMl9TQ1NJX0lPX0NEQl9FRURQ
MzIgRUVEUDMyOworCXN0cnVjdCBNUEkyX1NHRV9TSU1QTEVfVU5JT04gU0dFOworfTsKKworLyoK
KyAqIFJBSUQgU0NTSSBJTyBSZXF1ZXN0IE1lc3NhZ2UKKyAqIFRvdGFsIFNHRSBjb3VudCB3aWxs
IGJlIG9uZSBsZXNzIHRoYW4gIF9NUEkyX1NDU0lfSU9fUkVRVUVTVAorICovCitzdHJ1Y3QgTVBJ
Ml9SQUlEX1NDU0lfSU9fUkVRVUVTVCB7CisJdTE2ICAgICAgICAgICAgICAgICAgICAgRGV2SGFu
ZGxlOyAgICAgICAgICAgICAgICAgICAgICAvKiAweDAwICovCisJdTggICAgICAgICAgICAgICAg
ICAgICAgQ2hhaW5PZmZzZXQ7ICAgICAgICAgICAgICAgICAgICAvKiAweDAyICovCisJdTggICAg
ICAgICAgICAgICAgICAgICAgRnVuY3Rpb247ICAgICAgICAgICAgICAgICAgICAgICAvKiAweDAz
ICovCisJdTE2ICAgICAgICAgICAgICAgICAgICAgUmVzZXJ2ZWQxOyAgICAgICAgICAgICAgICAg
ICAgICAvKiAweDA0ICovCisJdTggICAgICAgICAgICAgICAgICAgICAgUmVzZXJ2ZWQyOyAgICAg
ICAgICAgICAgICAgICAgICAvKiAweDA2ICovCisJdTggICAgICAgICAgICAgICAgICAgICAgTXNn
RmxhZ3M7ICAgICAgICAgICAgICAgICAgICAgICAvKiAweDA3ICovCisJdTggICAgICAgICAgICAg
ICAgICAgICAgVlBfSUQ7ICAgICAgICAgICAgICAgICAgICAgICAgICAvKiAweDA4ICovCisJdTgg
ICAgICAgICAgICAgICAgICAgICAgVkZfSUQ7ICAgICAgICAgICAgICAgICAgICAgICAgICAvKiAw
eDA5ICovCisJdTE2ICAgICAgICAgICAgICAgICAgICAgUmVzZXJ2ZWQzOyAgICAgICAgICAgICAg
ICAgICAgICAvKiAweDBBICovCisJdTMyICAgICAgICAgICAgICAgICAgICAgU2Vuc2VCdWZmZXJM
b3dBZGRyZXNzOyAgICAgICAgICAvKiAweDBDICovCisJdTE2ICAgICAgICAgICAgICAgICAgICAg
U0dMRmxhZ3M7ICAgICAgICAgICAgICAgICAgICAgICAvKiAweDEwICovCisJdTggICAgICAgICAg
ICAgICAgICAgICAgU2Vuc2VCdWZmZXJMZW5ndGg7ICAgICAgICAgICAgICAvKiAweDEyICovCisJ
dTggICAgICAgICAgICAgICAgICAgICAgUmVzZXJ2ZWQ0OyAgICAgICAgICAgICAgICAgICAgICAv
KiAweDEzICovCisJdTggICAgICAgICAgICAgICAgICAgICAgU0dMT2Zmc2V0MDsgICAgICAgICAg
ICAgICAgICAgICAvKiAweDE0ICovCisJdTggICAgICAgICAgICAgICAgICAgICAgU0dMT2Zmc2V0
MTsgICAgICAgICAgICAgICAgICAgICAvKiAweDE1ICovCisJdTggICAgICAgICAgICAgICAgICAg
ICAgU0dMT2Zmc2V0MjsgICAgICAgICAgICAgICAgICAgICAvKiAweDE2ICovCisJdTggICAgICAg
ICAgICAgICAgICAgICAgU0dMT2Zmc2V0MzsgICAgICAgICAgICAgICAgICAgICAvKiAweDE3ICov
CisJdTMyICAgICAgICAgICAgICAgICAgICAgU2tpcENvdW50OyAgICAgICAgICAgICAgICAgICAg
ICAvKiAweDE4ICovCisJdTMyICAgICAgICAgICAgICAgICAgICAgRGF0YUxlbmd0aDsgICAgICAg
ICAgICAgICAgICAgICAvKiAweDFDICovCisJdTMyICAgICAgICAgICAgICAgICAgICAgQmlkaXJl
Y3Rpb25hbERhdGFMZW5ndGg7ICAgICAgICAvKiAweDIwICovCisJdTE2ICAgICAgICAgICAgICAg
ICAgICAgSW9GbGFnczsgICAgICAgICAgICAgICAgICAgICAgICAvKiAweDI0ICovCisJdTE2ICAg
ICAgICAgICAgICAgICAgICAgRUVEUEZsYWdzOyAgICAgICAgICAgICAgICAgICAgICAvKiAweDI2
ICovCisJdTMyICAgICAgICAgICAgICAgICAgICAgRUVEUEJsb2NrU2l6ZTsgICAgICAgICAgICAg
ICAgICAvKiAweDI4ICovCisJdTMyICAgICAgICAgICAgICAgICAgICAgU2Vjb25kYXJ5UmVmZXJl
bmNlVGFnOyAgICAgICAgICAvKiAweDJDICovCisJdTE2ICAgICAgICAgICAgICAgICAgICAgU2Vj
b25kYXJ5QXBwbGljYXRpb25UYWc7ICAgICAgICAvKiAweDMwICovCisJdTE2ICAgICAgICAgICAg
ICAgICAgICAgQXBwbGljYXRpb25UYWdUcmFuc2xhdGlvbk1hc2s7ICAvKiAweDMyICovCisJdTgg
ICAgICAgICAgICAgICAgICAgICAgTFVOWzhdOyAgICAgICAgICAgICAgICAgICAgICAgICAvKiAw
eDM0ICovCisJdTMyICAgICAgICAgICAgICAgICAgICAgQ29udHJvbDsgICAgICAgICAgICAgICAg
ICAgICAgICAvKiAweDNDICovCisJdW5pb24gTVBJMl9TQ1NJX0lPX0NEQl9VTklPTiAgQ0RCOwkJ
CS8qIDB4NDAgKi8KKwlzdHJ1Y3QgUkFJRF9DT05URVhUCVJhaWRDb250ZXh0OyAgICAgICAgICAg
ICAgICAgICAgLyogMHg2MCAqLworCXVuaW9uIE1QSTJfU0dFX0lPX1VOSU9OICAgICAgIFNHTDsJ
CQkvKiAweDgwICovCit9OworCisvKgorICogTVBUIFJBSUQgTUZBIElPIERlc2NyaXB0b3IuCisg
Ki8KK3N0cnVjdCBNRUdBU0FTX1JBSURfTUZBX0lPX1JFUVVFU1RfREVTQ1JJUFRPUiB7CisJdTMy
ICAgICBSZXF1ZXN0RmxhZ3M6ODsKKwl1MzIgICAgIE1lc3NhZ2VBZGRyZXNzMToyNDsgLyogYml0
cyAzMTo4Ki8KKwl1MzIgICAgIE1lc3NhZ2VBZGRyZXNzMjsgICAgICAvKiBiaXRzIDYxOjMyICov
Cit9OworCisvKiBEZWZhdWx0IFJlcXVlc3QgRGVzY3JpcHRvciAqLworc3RydWN0IE1QSTJfREVG
QVVMVF9SRVFVRVNUX0RFU0NSSVBUT1IgeworCXU4ICAgICAgICAgICAgICBSZXF1ZXN0RmxhZ3M7
ICAgICAgICAgICAgICAgLyogMHgwMCAqLworCXU4ICAgICAgICAgICAgICBNU0l4SW5kZXg7ICAg
ICAgICAgICAgICAgICAgLyogMHgwMSAqLworCXUxNiAgICAgICAgICAgICBTTUlEOyAgICAgICAg
ICAgICAgICAgICAgICAgLyogMHgwMiAqLworCXUxNiAgICAgICAgICAgICBMTUlEOyAgICAgICAg
ICAgICAgICAgICAgICAgLyogMHgwNCAqLworCXUxNiAgICAgICAgICAgICBEZXNjcmlwdG9yVHlw
ZURlcGVuZGVudDsgICAgLyogMHgwNiAqLworfTsKKworLyogSGlnaCBQcmlvcml0eSBSZXF1ZXN0
IERlc2NyaXB0b3IgKi8KK3N0cnVjdCBNUEkyX0hJR0hfUFJJT1JJVFlfUkVRVUVTVF9ERVNDUklQ
VE9SIHsKKwl1OCAgICAgICAgICAgICAgUmVxdWVzdEZsYWdzOyAgICAgICAgICAgICAgIC8qIDB4
MDAgKi8KKwl1OCAgICAgICAgICAgICAgTVNJeEluZGV4OyAgICAgICAgICAgICAgICAgIC8qIDB4
MDEgKi8KKwl1MTYgICAgICAgICAgICAgU01JRDsgICAgICAgICAgICAgICAgICAgICAgIC8qIDB4
MDIgKi8KKwl1MTYgICAgICAgICAgICAgTE1JRDsgICAgICAgICAgICAgICAgICAgICAgIC8qIDB4
MDQgKi8KKwl1MTYgICAgICAgICAgICAgUmVzZXJ2ZWQxOyAgICAgICAgICAgICAgICAgIC8qIDB4
MDYgKi8KK307CisKKy8qIFNDU0kgSU8gUmVxdWVzdCBEZXNjcmlwdG9yICovCitzdHJ1Y3QgTVBJ
Ml9TQ1NJX0lPX1JFUVVFU1RfREVTQ1JJUFRPUiB7CisJdTggICAgICAgICAgICAgIFJlcXVlc3RG
bGFnczsgICAgICAgICAgICAgICAvKiAweDAwICovCisJdTggICAgICAgICAgICAgIE1TSXhJbmRl
eDsgICAgICAgICAgICAgICAgICAvKiAweDAxICovCisJdTE2ICAgICAgICAgICAgIFNNSUQ7ICAg
ICAgICAgICAgICAgICAgICAgICAvKiAweDAyICovCisJdTE2ICAgICAgICAgICAgIExNSUQ7ICAg
ICAgICAgICAgICAgICAgICAgICAvKiAweDA0ICovCisJdTE2ICAgICAgICAgICAgIERldkhhbmRs
ZTsgICAgICAgICAgICAgICAgICAvKiAweDA2ICovCit9OworCisvKiBTQ1NJIFRhcmdldCBSZXF1
ZXN0IERlc2NyaXB0b3IgKi8KK3N0cnVjdCBNUEkyX1NDU0lfVEFSR0VUX1JFUVVFU1RfREVTQ1JJ
UFRPUiB7CisJdTggICAgICAgICAgICAgIFJlcXVlc3RGbGFnczsgICAgICAgICAgICAgICAvKiAw
eDAwICovCisJdTggICAgICAgICAgICAgIE1TSXhJbmRleDsgICAgICAgICAgICAgICAgICAvKiAw
eDAxICovCisJdTE2ICAgICAgICAgICAgIFNNSUQ7ICAgICAgICAgICAgICAgICAgICAgICAvKiAw
eDAyICovCisJdTE2ICAgICAgICAgICAgIExNSUQ7ICAgICAgICAgICAgICAgICAgICAgICAvKiAw
eDA0ICovCisJdTE2ICAgICAgICAgICAgIElvSW5kZXg7ICAgICAgICAgICAgICAgICAgICAvKiAw
eDA2ICovCit9OworCisvKiBSQUlEIEFjY2VsZXJhdG9yIFJlcXVlc3QgRGVzY3JpcHRvciAqLwor
c3RydWN0IE1QSTJfUkFJRF9BQ0NFTF9SRVFVRVNUX0RFU0NSSVBUT1IgeworCXU4ICAgICAgICAg
ICAgICBSZXF1ZXN0RmxhZ3M7ICAgICAgICAgICAgICAgLyogMHgwMCAqLworCXU4ICAgICAgICAg
ICAgICBNU0l4SW5kZXg7ICAgICAgICAgICAgICAgICAgLyogMHgwMSAqLworCXUxNiAgICAgICAg
ICAgICBTTUlEOyAgICAgICAgICAgICAgICAgICAgICAgLyogMHgwMiAqLworCXUxNiAgICAgICAg
ICAgICBMTUlEOyAgICAgICAgICAgICAgICAgICAgICAgLyogMHgwNCAqLworCXUxNiAgICAgICAg
ICAgICBSZXNlcnZlZDsgICAgICAgICAgICAgICAgICAgLyogMHgwNiAqLworfTsKKworLyogdW5p
b24gb2YgUmVxdWVzdCBEZXNjcmlwdG9ycyAqLwordW5pb24gTUVHQVNBU19SRVFVRVNUX0RFU0NS
SVBUT1JfVU5JT04geworCXN0cnVjdCBNUEkyX0RFRkFVTFRfUkVRVUVTVF9ERVNDUklQVE9SICAg
ICAgICAgICAgIERlZmF1bHQ7CisJc3RydWN0IE1QSTJfSElHSF9QUklPUklUWV9SRVFVRVNUX0RF
U0NSSVBUT1IgICAgICAgSGlnaFByaW9yaXR5OworCXN0cnVjdCBNUEkyX1NDU0lfSU9fUkVRVUVT
VF9ERVNDUklQVE9SICAgICAgICAgICAgIFNDU0lJTzsKKwlzdHJ1Y3QgTVBJMl9TQ1NJX1RBUkdF
VF9SRVFVRVNUX0RFU0NSSVBUT1IgICAgICAgICBTQ1NJVGFyZ2V0OworCXN0cnVjdCBNUEkyX1JB
SURfQUNDRUxfUkVRVUVTVF9ERVNDUklQVE9SICAgICAgICAgIFJBSURBY2NlbGVyYXRvcjsKKwlz
dHJ1Y3QgTUVHQVNBU19SQUlEX01GQV9JT19SRVFVRVNUX0RFU0NSSVBUT1IgICAgICBNRkFJbzsK
Kwl1bmlvbiB7CisJCXN0cnVjdCB7CisJCQl1MzIgbG93OworCQkJdTMyIGhpZ2g7CisJCX0gdTsK
KwkJdTY0IFdvcmRzOworCX07Cit9OworCisvKiBEZWZhdWx0IFJlcGx5IERlc2NyaXB0b3IgKi8K
K3N0cnVjdCBNUEkyX0RFRkFVTFRfUkVQTFlfREVTQ1JJUFRPUiB7CisJdTggICAgICAgICAgICAg
IFJlcGx5RmxhZ3M7ICAgICAgICAgICAgICAgICAvKiAweDAwICovCisJdTggICAgICAgICAgICAg
IE1TSXhJbmRleDsgICAgICAgICAgICAgICAgICAvKiAweDAxICovCisJdTE2ICAgICAgICAgICAg
IERlc2NyaXB0b3JUeXBlRGVwZW5kZW50MTsgICAvKiAweDAyICovCisJdTMyICAgICAgICAgICAg
IERlc2NyaXB0b3JUeXBlRGVwZW5kZW50MjsgICAvKiAweDA0ICovCit9OworCisvKiBBZGRyZXNz
IFJlcGx5IERlc2NyaXB0b3IgKi8KK3N0cnVjdCBNUEkyX0FERFJFU1NfUkVQTFlfREVTQ1JJUFRP
UiB7CisJdTggICAgICAgICAgICAgIFJlcGx5RmxhZ3M7ICAgICAgICAgICAgICAgICAvKiAweDAw
ICovCisJdTggICAgICAgICAgICAgIE1TSXhJbmRleDsgICAgICAgICAgICAgICAgICAvKiAweDAx
ICovCisJdTE2ICAgICAgICAgICAgIFNNSUQ7ICAgICAgICAgICAgICAgICAgICAgICAvKiAweDAy
ICovCisJdTMyICAgICAgICAgICAgIFJlcGx5RnJhbWVBZGRyZXNzOyAgICAgICAgICAvKiAweDA0
ICovCit9OworCisvKiBTQ1NJIElPIFN1Y2Nlc3MgUmVwbHkgRGVzY3JpcHRvciAqLworc3RydWN0
IE1QSTJfU0NTSV9JT19TVUNDRVNTX1JFUExZX0RFU0NSSVBUT1IgeworCXU4ICAgICAgICAgICAg
ICBSZXBseUZsYWdzOyAgICAgICAgICAgICAgICAgLyogMHgwMCAqLworCXU4ICAgICAgICAgICAg
ICBNU0l4SW5kZXg7ICAgICAgICAgICAgICAgICAgLyogMHgwMSAqLworCXUxNiAgICAgICAgICAg
ICBTTUlEOyAgICAgICAgICAgICAgICAgICAgICAgLyogMHgwMiAqLworCXUxNiAgICAgICAgICAg
ICBUYXNrVGFnOyAgICAgICAgICAgICAgICAgICAgLyogMHgwNCAqLworCXUxNiAgICAgICAgICAg
ICBSZXNlcnZlZDE7ICAgICAgICAgICAgICAgICAgLyogMHgwNiAqLworfTsKKworLyogVGFyZ2V0
QXNzaXN0IFN1Y2Nlc3MgUmVwbHkgRGVzY3JpcHRvciAqLworc3RydWN0IE1QSTJfVEFSR0VUQVNT
SVNUX1NVQ0NFU1NfUkVQTFlfREVTQ1JJUFRPUiB7CisJdTggICAgICAgICAgICAgIFJlcGx5Rmxh
Z3M7ICAgICAgICAgICAgICAgICAvKiAweDAwICovCisJdTggICAgICAgICAgICAgIE1TSXhJbmRl
eDsgICAgICAgICAgICAgICAgICAvKiAweDAxICovCisJdTE2ICAgICAgICAgICAgIFNNSUQ7ICAg
ICAgICAgICAgICAgICAgICAgICAvKiAweDAyICovCisJdTggICAgICAgICAgICAgIFNlcXVlbmNl
TnVtYmVyOyAgICAgICAgICAgICAvKiAweDA0ICovCisJdTggICAgICAgICAgICAgIFJlc2VydmVk
MTsgICAgICAgICAgICAgICAgICAvKiAweDA1ICovCisJdTE2ICAgICAgICAgICAgIElvSW5kZXg7
ICAgICAgICAgICAgICAgICAgICAvKiAweDA2ICovCit9OworCisvKiBUYXJnZXQgQ29tbWFuZCBC
dWZmZXIgUmVwbHkgRGVzY3JpcHRvciAqLworc3RydWN0IE1QSTJfVEFSR0VUX0NPTU1BTkRfQlVG
RkVSX1JFUExZX0RFU0NSSVBUT1IgeworCXU4ICAgICAgICAgICAgICBSZXBseUZsYWdzOyAgICAg
ICAgICAgICAgICAgLyogMHgwMCAqLworCXU4ICAgICAgICAgICAgICBNU0l4SW5kZXg7ICAgICAg
ICAgICAgICAgICAgLyogMHgwMSAqLworCXU4ICAgICAgICAgICAgICBWUF9JRDsgICAgICAgICAg
ICAgICAgICAgICAgLyogMHgwMiAqLworCXU4ICAgICAgICAgICAgICBGbGFnczsgICAgICAgICAg
ICAgICAgICAgICAgLyogMHgwMyAqLworCXUxNiAgICAgICAgICAgICBJbml0aWF0b3JEZXZIYW5k
bGU7ICAgICAgICAgLyogMHgwNCAqLworCXUxNiAgICAgICAgICAgICBJb0luZGV4OyAgICAgICAg
ICAgICAgICAgICAgLyogMHgwNiAqLworfTsKKworLyogUkFJRCBBY2NlbGVyYXRvciBTdWNjZXNz
IFJlcGx5IERlc2NyaXB0b3IgKi8KK3N0cnVjdCBNUEkyX1JBSURfQUNDRUxFUkFUT1JfU1VDQ0VT
U19SRVBMWV9ERVNDUklQVE9SIHsKKwl1OCAgICAgICAgICAgICAgUmVwbHlGbGFnczsgICAgICAg
ICAgICAgICAgIC8qIDB4MDAgKi8KKwl1OCAgICAgICAgICAgICAgTVNJeEluZGV4OyAgICAgICAg
ICAgICAgICAgIC8qIDB4MDEgKi8KKwl1MTYgICAgICAgICAgICAgU01JRDsgICAgICAgICAgICAg
ICAgICAgICAgIC8qIDB4MDIgKi8KKwl1MzIgICAgICAgICAgICAgUmVzZXJ2ZWQ7ICAgICAgICAg
ICAgICAgICAgIC8qIDB4MDQgKi8KK307CisKKy8qIHVuaW9uIG9mIFJlcGx5IERlc2NyaXB0b3Jz
ICovCit1bmlvbiBNUEkyX1JFUExZX0RFU0NSSVBUT1JTX1VOSU9OIHsKKwlzdHJ1Y3QgTVBJMl9E
RUZBVUxUX1JFUExZX0RFU0NSSVBUT1IgICAgICAgICAgICAgICAgICAgRGVmYXVsdDsKKwlzdHJ1
Y3QgTVBJMl9BRERSRVNTX1JFUExZX0RFU0NSSVBUT1IgICAgICAgICAgICAgICAgICAgQWRkcmVz
c1JlcGx5OworCXN0cnVjdCBNUEkyX1NDU0lfSU9fU1VDQ0VTU19SRVBMWV9ERVNDUklQVE9SICAg
ICAgICAgICBTQ1NJSU9TdWNjZXNzOworCXN0cnVjdCBNUEkyX1RBUkdFVEFTU0lTVF9TVUNDRVNT
X1JFUExZX0RFU0NSSVBUT1IgVGFyZ2V0QXNzaXN0U3VjY2VzczsKKwlzdHJ1Y3QgTVBJMl9UQVJH
RVRfQ09NTUFORF9CVUZGRVJfUkVQTFlfREVTQ1JJUFRPUiBUYXJnZXRDb21tYW5kQnVmZmVyOwor
CXN0cnVjdCBNUEkyX1JBSURfQUNDRUxFUkFUT1JfU1VDQ0VTU19SRVBMWV9ERVNDUklQVE9SCisJ
UkFJREFjY2VsZXJhdG9yU3VjY2VzczsKKwl1NjQgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBXb3JkczsKK307CisKKy8qIElPQ0luaXQgUmVxdWVzdCBtZXNzYWdl
ICovCitzdHJ1Y3QgTVBJMl9JT0NfSU5JVF9SRVFVRVNUIHsKKwl1OCAgICAgICAgICAgICAgICAg
ICAgICBXaG9Jbml0OyAgICAgICAgICAgICAgICAgICAgICAgIC8qIDB4MDAgKi8KKwl1OCAgICAg
ICAgICAgICAgICAgICAgICBSZXNlcnZlZDE7ICAgICAgICAgICAgICAgICAgICAgIC8qIDB4MDEg
Ki8KKwl1OCAgICAgICAgICAgICAgICAgICAgICBDaGFpbk9mZnNldDsgICAgICAgICAgICAgICAg
ICAgIC8qIDB4MDIgKi8KKwl1OCAgICAgICAgICAgICAgICAgICAgICBGdW5jdGlvbjsgICAgICAg
ICAgICAgICAgICAgICAgIC8qIDB4MDMgKi8KKwl1MTYgICAgICAgICAgICAgICAgICAgICBSZXNl
cnZlZDI7ICAgICAgICAgICAgICAgICAgICAgIC8qIDB4MDQgKi8KKwl1OCAgICAgICAgICAgICAg
ICAgICAgICBSZXNlcnZlZDM7ICAgICAgICAgICAgICAgICAgICAgIC8qIDB4MDYgKi8KKwl1OCAg
ICAgICAgICAgICAgICAgICAgICBNc2dGbGFnczsgICAgICAgICAgICAgICAgICAgICAgIC8qIDB4
MDcgKi8KKwl1OCAgICAgICAgICAgICAgICAgICAgICBWUF9JRDsgICAgICAgICAgICAgICAgICAg
ICAgICAgIC8qIDB4MDggKi8KKwl1OCAgICAgICAgICAgICAgICAgICAgICBWRl9JRDsgICAgICAg
ICAgICAgICAgICAgICAgICAgIC8qIDB4MDkgKi8KKwl1MTYgICAgICAgICAgICAgICAgICAgICBS
ZXNlcnZlZDQ7ICAgICAgICAgICAgICAgICAgICAgIC8qIDB4MEEgKi8KKwl1MTYgICAgICAgICAg
ICAgICAgICAgICBNc2dWZXJzaW9uOyAgICAgICAgICAgICAgICAgICAgIC8qIDB4MEMgKi8KKwl1
MTYgICAgICAgICAgICAgICAgICAgICBIZWFkZXJWZXJzaW9uOyAgICAgICAgICAgICAgICAgIC8q
IDB4MEUgKi8KKwl1MzIgICAgICAgICAgICAgICAgICAgICBSZXNlcnZlZDU7ICAgICAgICAgICAg
ICAgICAgICAgIC8qIDB4MTAgKi8KKwl1MTYgICAgICAgICAgICAgICAgICAgICBSZXNlcnZlZDY7
ICAgICAgICAgICAgICAgICAgICAgIC8qIDB4MTQgKi8KKwl1OCAgICAgICAgICAgICAgICAgICAg
ICBSZXNlcnZlZDc7ICAgICAgICAgICAgICAgICAgICAgIC8qIDB4MTYgKi8KKwl1OCAgICAgICAg
ICAgICAgICAgICAgICBIb3N0TVNJeFZlY3RvcnM7ICAgICAgICAgICAgICAgIC8qIDB4MTcgKi8K
Kwl1MTYgICAgICAgICAgICAgICAgICAgICBSZXNlcnZlZDg7ICAgICAgICAgICAgICAgICAgICAg
IC8qIDB4MTggKi8KKwl1MTYgICAgICAgICAgICAgICAgICAgICBTeXN0ZW1SZXF1ZXN0RnJhbWVT
aXplOyAgICAgICAgIC8qIDB4MUEgKi8KKwl1MTYgICAgICAgICAgICAgICAgICAgICBSZXBseURl
c2NyaXB0b3JQb3N0UXVldWVEZXB0aDsgIC8qIDB4MUMgKi8KKwl1MTYgICAgICAgICAgICAgICAg
ICAgICBSZXBseUZyZWVRdWV1ZURlcHRoOyAgICAgICAgICAgIC8qIDB4MUUgKi8KKwl1MzIgICAg
ICAgICAgICAgICAgICAgICBTZW5zZUJ1ZmZlckFkZHJlc3NIaWdoOyAgICAgICAgIC8qIDB4MjAg
Ki8KKwl1MzIgICAgICAgICAgICAgICAgICAgICBTeXN0ZW1SZXBseUFkZHJlc3NIaWdoOyAgICAg
ICAgIC8qIDB4MjQgKi8KKwl1NjQgICAgICAgICAgICAgICAgICAgICBTeXN0ZW1SZXF1ZXN0RnJh
bWVCYXNlQWRkcmVzczsgIC8qIDB4MjggKi8KKwl1NjQgICAgICAgICAgICAgICAgICAgICBSZXBs
eURlc2NyaXB0b3JQb3N0UXVldWVBZGRyZXNzOy8qIDB4MzAgKi8KKwl1NjQgICAgICAgICAgICAg
ICAgICAgICBSZXBseUZyZWVRdWV1ZUFkZHJlc3M7ICAgICAgICAgIC8qIDB4MzggKi8KKwl1NjQg
ICAgICAgICAgICAgICAgICAgICBUaW1lU3RhbXA7ICAgICAgICAgICAgICAgICAgICAgIC8qIDB4
NDAgKi8KK307CisKKy8qIG1ycHJpdiBkZWZpbmVzICovCisjZGVmaW5lIE1SX1BEX0lOVkFMSUQg
MHhGRkZGCisjZGVmaW5lIE1BWF9TUEFOX0RFUFRIIDgKKyNkZWZpbmUgTUFYX1JBSURNQVBfU1BB
Tl9ERVBUSCAoTUFYX1NQQU5fREVQVEgpCisjZGVmaW5lIE1BWF9ST1dfU0laRSAzMgorI2RlZmlu
ZSBNQVhfUkFJRE1BUF9ST1dfU0laRSAoTUFYX1JPV19TSVpFKQorI2RlZmluZSBNQVhfTE9HSUNB
TF9EUklWRVMgNjQKKyNkZWZpbmUgTUFYX1JBSURNQVBfTE9HSUNBTF9EUklWRVMgKE1BWF9MT0dJ
Q0FMX0RSSVZFUykKKyNkZWZpbmUgTUFYX1JBSURNQVBfVklFV1MgKE1BWF9MT0dJQ0FMX0RSSVZF
UykKKyNkZWZpbmUgTUFYX0FSUkFZUyAxMjgKKyNkZWZpbmUgTUFYX1JBSURNQVBfQVJSQVlTIChN
QVhfQVJSQVlTKQorI2RlZmluZSBNQVhfUEhZU0lDQUxfREVWSUNFUyAyNTYKKyNkZWZpbmUgTUFY
X1JBSURNQVBfUEhZU0lDQUxfREVWSUNFUyAoTUFYX1BIWVNJQ0FMX0RFVklDRVMpCisjZGVmaW5l
IE1SX0RDTURfTERfTUFQX0dFVF9JTkZPICAgICAgICAgICAgIDB4MDMwMGUxMDEKKworc3RydWN0
IE1SX0RFVl9IQU5ETEVfSU5GTyB7CisJdTE2ICAgICBjdXJEZXZIZGw7CisJdTggICAgICB2YWxp
ZEhhbmRsZXM7CisJdTggICAgICByZXNlcnZlZDsKKwl1MTYgICAgIGRldkhhbmRsZVsyXTsKK307
CisKK3N0cnVjdCBNUl9BUlJBWV9JTkZPIHsKKwl1MTYgICAgICBwZFtNQVhfUkFJRE1BUF9ST1df
U0laRV07Cit9OworCitzdHJ1Y3QgTVJfUVVBRF9FTEVNRU5UIHsKKwl1NjQgICAgIGxvZ1N0YXJ0
OworCXU2NCAgICAgbG9nRW5kOworCXU2NCAgICAgb2Zmc2V0SW5TcGFuOworCXUzMiAgICAgZGlm
ZjsKKwl1MzIgICAgIHJlc2VydmVkMTsKK307CisKK3N0cnVjdCBNUl9TUEFOX0lORk8geworCXUz
MiAgICAgICAgICAgICBub0VsZW1lbnRzOworCXUzMiAgICAgICAgICAgICByZXNlcnZlZDE7CisJ
c3RydWN0IE1SX1FVQURfRUxFTUVOVCBxdWFkW01BWF9SQUlETUFQX1NQQU5fREVQVEhdOworfTsK
Kworc3RydWN0IE1SX0xEX1NQQU4geworCXU2NCAgICAgIHN0YXJ0QmxrOworCXU2NCAgICAgIG51
bUJsa3M7CisJdTE2ICAgICAgYXJyYXlSZWY7CisJdTggICAgICAgcmVzZXJ2ZWRbNl07Cit9Owor
CitzdHJ1Y3QgTVJfU1BBTl9CTE9DS19JTkZPIHsKKwl1NjQgICAgICAgICAgbnVtX3Jvd3M7CisJ
c3RydWN0IE1SX0xEX1NQQU4gICBzcGFuOworCXN0cnVjdCBNUl9TUEFOX0lORk8gYmxvY2tfc3Bh
bl9pbmZvOworfTsKKworc3RydWN0IE1SX0xEX1JBSUQgeworCXN0cnVjdCB7CisJCXUzMiAgICAg
ZnBDYXBhYmxlOjE7CisJCXUzMiAgICAgcmVzZXJ2ZWQ1OjM7CisJCXUzMiAgICAgbGRQaU1vZGU6
NDsKKwkJdTMyICAgICBwZFBpTW9kZTo0OworCQl1MzIgICAgIGVuY3J5cHRpb25UeXBlOjg7CisJ
CXUzMiAgICAgZnBXcml0ZUNhcGFibGU6MTsKKwkJdTMyICAgICBmcFJlYWRDYXBhYmxlOjE7CisJ
CXUzMiAgICAgZnBXcml0ZUFjcm9zc1N0cmlwZToxOworCQl1MzIgICAgIGZwUmVhZEFjcm9zc1N0
cmlwZToxOworCQl1MzIgICAgIHJlc2VydmVkNDo4OworCX0gY2FwYWJpbGl0eTsKKwl1MzIgICAg
IHJlc2VydmVkNjsKKwl1NjQgICAgIHNpemU7CisJdTggICAgICBzcGFuRGVwdGg7CisJdTggICAg
ICBsZXZlbDsKKwl1OCAgICAgIHN0cmlwZVNoaWZ0OworCXU4ICAgICAgcm93U2l6ZTsKKwl1OCAg
ICAgIHJvd0RhdGFTaXplOworCXU4ICAgICAgd3JpdGVNb2RlOworCXU4ICAgICAgUFJMOworCXU4
ICAgICAgU1JMOworCXUxNiAgICAgdGFyZ2V0SWQ7CisJdTggICAgICBsZFN0YXRlOworCXU4ICAg
ICAgcmVnVHlwZVJlcU9uV3JpdGU7CisJdTggICAgICBtb2RGYWN0b3I7CisJdTggICAgICByZXNl
cnZlZDJbMV07CisJdTE2ICAgICBzZXFOdW07CisKKwlzdHJ1Y3QgeworCQl1MzIgbGRTeW5jUmVx
dWlyZWQ6MTsKKwkJdTMyIHJlc2VydmVkOjMxOworCX0gZmxhZ3M7CisKKwl1OCAgICAgIHJlc2Vy
dmVkM1sweDVDXTsKK307CisKK3N0cnVjdCBNUl9MRF9TUEFOX01BUCB7CisJc3RydWN0IE1SX0xE
X1JBSUQgICAgICAgICAgbGRSYWlkOworCXU4ICAgICAgICAgICAgICAgICAgZGF0YUFybU1hcFtN
QVhfUkFJRE1BUF9ST1dfU0laRV07CisJc3RydWN0IE1SX1NQQU5fQkxPQ0tfSU5GTyAgc3BhbkJs
b2NrW01BWF9SQUlETUFQX1NQQU5fREVQVEhdOworfTsKKworc3RydWN0IE1SX0ZXX1JBSURfTUFQ
IHsKKwl1MzIgICAgICAgICAgICAgICAgIHRvdGFsU2l6ZTsKKwl1bmlvbiB7CisJCXN0cnVjdCB7
CisJCQl1MzIgICAgICAgICBtYXhMZDsKKwkJCXUzMiAgICAgICAgIG1heFNwYW5EZXB0aDsKKwkJ
CXUzMiAgICAgICAgIG1heFJvd1NpemU7CisJCQl1MzIgICAgICAgICBtYXhQZENvdW50OworCQkJ
dTMyICAgICAgICAgbWF4QXJyYXlzOworCQl9IHZhbGlkYXRpb25JbmZvOworCQl1MzIgICAgICAg
ICAgICAgdmVyc2lvbls1XTsKKwkJdTMyICAgICAgICAgICAgIHJlc2VydmVkMVs1XTsKKwl9Owor
CisJdTMyICAgICAgICAgICAgICAgICBsZENvdW50OworCXUzMiAgICAgICAgICAgICAgICAgUmVz
ZXJ2ZWQxOworCXU4ICAgICAgICAgICAgICAgICAgbGRUZ3RJZFRvTGRbTUFYX1JBSURNQVBfTE9H
SUNBTF9EUklWRVMrCisJCQkJCU1BWF9SQUlETUFQX1ZJRVdTXTsKKwl1OCAgICAgICAgICAgICAg
ICAgIGZwUGRJb1RpbWVvdXRTZWM7CisJdTggICAgICAgICAgICAgICAgICByZXNlcnZlZDJbN107
CisJc3RydWN0IE1SX0FSUkFZX0lORk8gICAgICAgYXJNYXBJbmZvW01BWF9SQUlETUFQX0FSUkFZ
U107CisJc3RydWN0IE1SX0RFVl9IQU5ETEVfSU5GTyAgZGV2SG5kbEluZm9bTUFYX1JBSURNQVBf
UEhZU0lDQUxfREVWSUNFU107CisJc3RydWN0IE1SX0xEX1NQQU5fTUFQICAgICAgbGRTcGFuTWFw
WzFdOworfTsKKworc3RydWN0IElPX1JFUVVFU1RfSU5GTyB7CisJdTY0IGxkU3RhcnRCbG9jazsK
Kwl1MzIgbnVtQmxvY2tzOworCXUxNiBsZFRndElkOworCXU4IGlzUmVhZDsKKwl1MTYgZGV2SGFu
ZGxlOworCXU2NCBwZEJsb2NrOworCXU4IGZwT2tGb3JJbzsKK307CisKK3N0cnVjdCBNUl9MRF9U
QVJHRVRfU1lOQyB7CisJdTggIHRhcmdldElkOworCXU4ICByZXNlcnZlZDsKKwl1MTYgc2VxTnVt
OworfTsKKworI2RlZmluZSBJRUVFX1NHRV9GTEFHU19BRERSX01BU0sgICAgICAgICAgICAoMHgw
MykKKyNkZWZpbmUgSUVFRV9TR0VfRkxBR1NfU1lTVEVNX0FERFIgICAgICAgICAgKDB4MDApCisj
ZGVmaW5lIElFRUVfU0dFX0ZMQUdTX0lPQ0REUl9BRERSICAgICAgICAgICgweDAxKQorI2RlZmlu
ZSBJRUVFX1NHRV9GTEFHU19JT0NQTEJfQUREUiAgICAgICAgICAoMHgwMikKKyNkZWZpbmUgSUVF
RV9TR0VfRkxBR1NfSU9DUExCTlRBX0FERFIgICAgICAgKDB4MDMpCisjZGVmaW5lIElFRUVfU0dF
X0ZMQUdTX0NIQUlOX0VMRU1FTlQgICAgICAgICgweDgwKQorI2RlZmluZSBJRUVFX1NHRV9GTEFH
U19FTkRfT0ZfTElTVCAgICAgICAgICAoMHg0MCkKKworc3RydWN0IG1lZ2FzYXNfcmVnaXN0ZXJf
c2V0Oworc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2U7CisKK3VuaW9uIGRlc2Nfd29yZCB7CisJdTY0
IHdvcmQ7CisJc3RydWN0IHsKKwkJdTMyIGxvdzsKKwkJdTMyIGhpZ2g7CisJfSB1OworfTsKKwor
c3RydWN0IG1lZ2FzYXNfY21kX2Z1c2lvbiB7CisJc3RydWN0IE1QSTJfUkFJRF9TQ1NJX0lPX1JF
UVVFU1QJKmlvX3JlcXVlc3Q7CisJZG1hX2FkZHJfdAkJCWlvX3JlcXVlc3RfcGh5c19hZGRyOwor
CisJdW5pb24gTVBJMl9TR0VfSU9fVU5JT04JKnNnX2ZyYW1lOworCWRtYV9hZGRyX3QJCXNnX2Zy
YW1lX3BoeXNfYWRkcjsKKworCXU4ICpzZW5zZTsKKwlkbWFfYWRkcl90IHNlbnNlX3BoeXNfYWRk
cjsKKworCXN0cnVjdCBsaXN0X2hlYWQgbGlzdDsKKwlzdHJ1Y3Qgc2NzaV9jbW5kICpzY21kOwor
CXN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZTsKKworCXU4IHJldHJ5X2Zvcl9md19y
ZXNldDsKKwl1bmlvbiBNRUdBU0FTX1JFUVVFU1RfREVTQ1JJUFRPUl9VTklPTiAgKnJlcXVlc3Rf
ZGVzYzsKKworCS8qCisJICogQ29udGV4dCBmb3IgYSBNRkkgZnJhbWUuCisJICogVXNlZCB0byBn
ZXQgdGhlIG1maSBjbWQgZnJvbSBsaXN0IHdoZW4gYSBNRkkgY21kIGlzIGNvbXBsZXRlZAorCSAq
LworCXUzMiBzeW5jX2NtZF9pZHg7CisJdTMyIGluZGV4OworCXU4IGZsYWdzOworfTsKKworc3Ry
dWN0IExEX0xPQURfQkFMQU5DRV9JTkZPIHsKKwl1OAlsb2FkQmFsYW5jZUZsYWc7CisJdTgJcmVz
ZXJ2ZWQxOworCXUxNiAgICAgcmFpZDFEZXZIYW5kbGVbMl07CisJYXRvbWljX3QgICAgIHNjc2lf
cGVuZGluZ19jbWRzWzJdOworCXU2NCAgICAgbGFzdF9hY2Nlc3NlZF9ibG9ja1syXTsKK307CisK
K3N0cnVjdCBNUl9GV19SQUlEX01BUF9BTEwgeworCXN0cnVjdCBNUl9GV19SQUlEX01BUCByYWlk
TWFwOworCXN0cnVjdCBNUl9MRF9TUEFOX01BUCBsZFNwYW5NYXBbTUFYX0xPR0lDQUxfRFJJVkVT
IC0gMV07Cit9IF9fYXR0cmlidXRlX18gKChwYWNrZWQpKTsKKworc3RydWN0IGZ1c2lvbl9jb250
ZXh0IHsKKwlzdHJ1Y3QgbWVnYXNhc19jbWRfZnVzaW9uICoqY21kX2xpc3Q7CisJc3RydWN0IGxp
c3RfaGVhZCBjbWRfcG9vbDsKKworCXNwaW5sb2NrX3QgY21kX3Bvb2xfbG9jazsKKworCWRtYV9h
ZGRyX3QgcmVxX2ZyYW1lc19kZXNjX3BoeXM7CisJdTggKnJlcV9mcmFtZXNfZGVzYzsKKworCXN0
cnVjdCBkbWFfcG9vbCAqaW9fcmVxdWVzdF9mcmFtZXNfcG9vbDsKKwlkbWFfYWRkcl90IGlvX3Jl
cXVlc3RfZnJhbWVzX3BoeXM7CisJdTggKmlvX3JlcXVlc3RfZnJhbWVzOworCisJc3RydWN0IGRt
YV9wb29sICpzZ19kbWFfcG9vbDsKKwlzdHJ1Y3QgZG1hX3Bvb2wgKnNlbnNlX2RtYV9wb29sOwor
CisJZG1hX2FkZHJfdCByZXBseV9mcmFtZXNfZGVzY19waHlzOworCXVuaW9uIE1QSTJfUkVQTFlf
REVTQ1JJUFRPUlNfVU5JT04gKnJlcGx5X2ZyYW1lc19kZXNjOworCXN0cnVjdCBkbWFfcG9vbCAq
cmVwbHlfZnJhbWVzX2Rlc2NfcG9vbDsKKworCXUxNiBsYXN0X3JlcGx5X2lkeDsKKworCXUzMiBy
ZXBseV9xX2RlcHRoOworCXUzMiByZXF1ZXN0X2FsbG9jX3N6OworCXUzMiByZXBseV9hbGxvY19z
ejsKKwl1MzIgaW9fZnJhbWVzX2FsbG9jX3N6OworCisJdTE2CW1heF9zZ2VfaW5fbWFpbl9tc2c7
CisJdTE2CW1heF9zZ2VfaW5fY2hhaW47CisKKwl1OAljaGFpbl9vZmZzZXRfaW9fcmVxdWVzdDsK
Kwl1OAljaGFpbl9vZmZzZXRfbWZpX3B0aHJ1OworCisJc3RydWN0IE1SX0ZXX1JBSURfTUFQX0FM
TCAqbGRfbWFwWzJdOworCWRtYV9hZGRyX3QgbGRfbWFwX3BoeXNbMl07CisKKwl1MzIgbWFwX3N6
OworCXU4IGZhc3RfcGF0aF9pbzsKKwlzdHJ1Y3QgTERfTE9BRF9CQUxBTkNFX0lORk8gbG9hZF9i
YWxhbmNlX2luZm9bTUFYX0xPR0lDQUxfRFJJVkVTXTsKK307CisKK3VuaW9uIGRlc2NfdmFsdWUg
eworCXU2NCB3b3JkOworCXN0cnVjdCB7CisJCXUzMiBsb3c7CisJCXUzMiBoaWdoOworCX0gdTsK
K307CisKKyNlbmRpZiAvKiBfTUVHQVJBSURfU0FTX0ZVU0lPTl9IXyAqLwpkaWZmIC1OYXVyIGxp
bnV4LTIuNi4zNy1yYzUub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaCBs
aW51eC0yLjYuMzctcmM1Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgK
LS0tIGxpbnV4LTIuNi4zNy1yYzUub2xkL2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXMuaAkyMDEwLTEyLTIxIDEwOjA2OjI3LjAwMDAwMDAwMCAtMDgwMAorKysgbGludXgtMi42LjM3
LXJjNS5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oCTIwMTAtMTItMjEg
MTM6MTg6NTEuMDAwMDAwMDAwIC0wODAwCkBAIC0zMyw5ICszMyw5IEBACiAvKgogICogTWVnYVJB
SUQgU0FTIERyaXZlciBtZXRhIGRhdGEKICAqLwotI2RlZmluZSBNRUdBU0FTX1ZFUlNJT04JCQki
MDAuMDAuMDQuMzEtcmMxIgotI2RlZmluZSBNRUdBU0FTX1JFTERBVEUJCQkiTWF5IDMsIDIwMTAi
Ci0jZGVmaW5lIE1FR0FTQVNfRVhUX1ZFUlNJT04JCSJNb24uIE1heSAzLCAxMTo0MTo1MSBQU1Qg
MjAxMCIKKyNkZWZpbmUgTUVHQVNBU19WRVJTSU9OCQkJCSIwMC4wMC4wNS4yOS1yYzEiCisjZGVm
aW5lIE1FR0FTQVNfUkVMREFURQkJCQkiRGVjLiA3LCAyMDEwIgorI2RlZmluZSBNRUdBU0FTX0VY
VF9WRVJTSU9OCQkJIlR1ZS4gRGVjLiA3IDE3OjAwOjAwIFBEVCAyMDEwIgogCiAvKgogICogRGV2
aWNlIElEcwpAQCAtNDcsNiArNDcsNyBAQAogI2RlZmluZQlQQ0lfREVWSUNFX0lEX0xTSV9TQVMw
MDc5R0VOMgkJMHgwMDc5CiAjZGVmaW5lCVBDSV9ERVZJQ0VfSURfTFNJX1NBUzAwNzNTS0lOTlkJ
CTB4MDA3MwogI2RlZmluZQlQQ0lfREVWSUNFX0lEX0xTSV9TQVMwMDcxU0tJTk5ZCQkweDAwNzEK
KyNkZWZpbmUJUENJX0RFVklDRV9JRF9MU0lfRlVTSU9OCQkweDAwNWIKIAogLyoKICAqID09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT0KQEAgLTQzNiw3ICs0MzcsNiBAQAogCSog
QWRkIHByb3BlcnRpZXMgdGhhdCBjYW4gYmUgY29udHJvbGxlZCBieQogCSogYSBiaXQgaW4gdGhl
IGZvbGxvd2luZyBzdHJ1Y3R1cmUuCiAJKi8KLQogCXN0cnVjdCB7CiAJCXUzMiAgICAgY29weUJh
Y2tEaXNhYmxlZCAgICAgICAgICAgIDogMTsKIAkJdTMyICAgICBTTUFSVGVyRW5hYmxlZCAgICAg
ICAgICAgICAgOiAxOwpAQCAtNzE2LDYgKzcxNiw3IEBACiAjZGVmaW5lIE1FR0FTQVNfREVGQVVM
VF9JTklUX0lECQkJLTEKICNkZWZpbmUgTUVHQVNBU19NQVhfTFVOCQkJCTgKICNkZWZpbmUgTUVH
QVNBU19NQVhfTEQJCQkJNjQKKyNkZWZpbmUgTUVHQVNBU19ERUZBVUxUX0NNRF9QRVJfTFVOCQkx
MjgKICNkZWZpbmUgTUVHQVNBU19NQVhfUEQgICAgICAgICAgICAgICAgICAgICAgICAgIChNRUdB
U0FTX01BWF9QRF9DSEFOTkVMUyAqIFwKIAkJCQkJCU1FR0FTQVNfTUFYX0RFVl9QRVJfQ0hBTk5F
TCkKICNkZWZpbmUgTUVHQVNBU19NQVhfTERfSURTCQkJKE1FR0FTQVNfTUFYX0xEX0NIQU5ORUxT
ICogXApAQCAtNzg0LDcgKzc4NSwxMCBAQAogKi8KICAKIHN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVy
X3NldCB7Ci0JdTMyIAlyZXNlcnZlZF8wWzRdOwkJCS8qMDAwMGgqLworCXUzMglkb29yYmVsbDsg
ICAgICAgICAgICAgICAgICAgICAgIC8qMDAwMGgqLworCXUzMglmdXNpb25fc2VxX29mZnNldDsJ
CS8qMDAwNGgqLworCXUzMglmdXNpb25faG9zdF9kaWFnOwkJLyowMDA4aCovCisJdTMyCXJlc2Vy
dmVkXzAxOwkJCS8qMDAwQ2gqLwogCiAJdTMyIAlpbmJvdW5kX21zZ18wOwkJCS8qMDAxMGgqLwog
CXUzMiAJaW5ib3VuZF9tc2dfMTsJCQkvKjAwMTRoKi8KQEAgLTgwNCwxNSArODA4LDE4IEBACiAJ
dTMyIAlpbmJvdW5kX3F1ZXVlX3BvcnQ7CQkvKjAwNDBoKi8KIAl1MzIgCW91dGJvdW5kX3F1ZXVl
X3BvcnQ7CQkvKjAwNDRoKi8KIAotCXUzMiAJcmVzZXJ2ZWRfMlsyMl07CQkJLyowMDQ4aCovCisJ
dTMyCXJlc2VydmVkXzJbOV07CQkJLyowMDQ4aCovCisJdTMyCXJlcGx5X3Bvc3RfaG9zdF9pbmRl
eDsJCS8qMDA2Q2gqLworCXUzMglyZXNlcnZlZF8yXzJbMTJdOwkJLyowMDcwaCovCiAKIAl1MzIg
CW91dGJvdW5kX2Rvb3JiZWxsX2NsZWFyOwkvKjAwQTBoKi8KIAogCXUzMiAJcmVzZXJ2ZWRfM1sz
XTsJCQkvKjAwQTRoKi8KIAogCXUzMiAJb3V0Ym91bmRfc2NyYXRjaF9wYWQgOwkJLyowMEIwaCov
CisJdTMyCW91dGJvdW5kX3NjcmF0Y2hfcGFkXzI7ICAgICAgICAgLyowMEI0aCovCiAKLQl1MzIg
CXJlc2VydmVkXzRbM107CQkJLyowMEI0aCovCisJdTMyCXJlc2VydmVkXzRbMl07CQkJLyowMEI4
aCovCiAKIAl1MzIgCWluYm91bmRfbG93X3F1ZXVlX3BvcnQgOwkvKjAwQzBoKi8KIApAQCAtMTI4
Nyw2ICsxMjk0LDkgQEAKIAogCXUxNiBtYXhfbnVtX3NnZTsKIAl1MTYgbWF4X2Z3X2NtZHM7CisJ
LyogRm9yIEZ1c2lvbiBpdHMgbnVtIElPQ1RMIGNtZHMsIGZvciBvdGhlcnMgTUZJIGJhc2VkIGl0
cworCSAgIG1heF9md19jbWRzICovCisJdTE2IG1heF9tZmlfY21kczsKIAl1MzIgbWF4X3NlY3Rv
cnNfcGVyX3JlcTsKIAlzdHJ1Y3QgbWVnYXNhc19hZW5fZXZlbnQgKmV2OwogCkBAIC0xMzM2LDkg
KzEzNDYsMTUgQEAKIAlzdHJ1Y3QgdGltZXJfbGlzdCBpb19jb21wbGV0aW9uX3RpbWVyOwogCXN0
cnVjdCBsaXN0X2hlYWQgaW50ZXJuYWxfcmVzZXRfcGVuZGluZ19xOwogCisJLyogUHRyIHRvIGhi
YSBzcGVjZmljIGluZm9ybWF0aW9uICovCisJdm9pZCAqY3RybF9jb250ZXh0OwogCXU4CW1zaV9m
bGFnOwogCXN0cnVjdCBtc2l4X2VudHJ5IG1zaXhlbnRyeTsKKwl1NjQgbWFwX2lkOworCXN0cnVj
dCBtZWdhc2FzX2NtZCAqbWFwX3VwZGF0ZV9jbWQ7CiAJdW5zaWduZWQgbG9uZyBiYXI7CisJbG9u
ZyByZXNldF9mbGFnczsKKwlzdHJ1Y3QgbXV0ZXggcmVzZXRfbXV0ZXg7CiB9OwogCiBlbnVtIHsK
QEAgLTEzOTcsNyArMTQxMywxMyBAQAogCXN0cnVjdCBsaXN0X2hlYWQgbGlzdDsKIAlzdHJ1Y3Qg
c2NzaV9jbW5kICpzY21kOwogCXN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZTsKLQl1
MzIgZnJhbWVfY291bnQ7CisJdW5pb24geworCQlzdHJ1Y3QgeworCQkJdTE2IHNtaWQ7CisJCQl1
MTYgcmVzdmQ7CisJCX0gY29udGV4dDsKKwkJdTMyIGZyYW1lX2NvdW50OworCX07CiB9OwogCiAj
ZGVmaW5lIE1BWF9NR01UX0FEQVBURVJTCQkxMDI0Cg==
--0016363b8520f20a800497f26660--
