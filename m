From: bo yang <bo.yang@lsi.com>
Subject: [PATCH 1/6] scsi: megaraid_sas - add hibernation support
Date: Wed, 07 Nov 2007 12:09:50 -0500
Message-ID: <1194455390.5862.4.camel@dhcp-75-884.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:33296 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbXKIUyq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Nov 2007 15:54:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@SteelEye.com, akpm@osdl.org, linux-kernel@vger.kernel.org, bo.yang@lsil.com, sumant.patro@lsi.com

Adding hibernation support. suspend, resume routine implemented.

Signed-off-by: Bo Yang <bo.yang@lsi.com>

---
 drivers/scsi/megaraid/megaraid_sas.c |  302 +++++++++++++++++++------
 drivers/scsi/megaraid/megaraid_sas.h |    1
 2 files changed, 233 insertions(+), 70 deletions(-)

diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.c	2007-11-07 01:37:18.129310512 -0500
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.c	2007-11-07 01:36:25.261347664 -0500
@@ -1803,6 +1803,81 @@ static void megasas_complete_cmd_dpc(uns
 }
 
 /**
+ * megasas_issue_init_mfi -	Initializes the FW
+ * @instance:		Adapter soft state
+ *
+ * Issues the INIT MFI cmd
+ */
+static int
+megasas_issue_init_mfi(struct megasas_instance *instance)
+{
+	u32 context;
+
+	struct megasas_cmd *cmd;
+
+	struct megasas_init_frame *init_frame;
+	struct megasas_init_queue_info *initq_info;
+	dma_addr_t init_frame_h;
+	dma_addr_t initq_info_h;
+
+	/*
+	 * Prepare a init frame. Note the init frame points to queue info
+	 * structure. Each frame has SGL allocated after first 64 bytes. For
+	 * this frame - since we don't need any SGL - we use SGL's space as
+	 * queue info structure
+	 *
+	 * We will not get a NULL command below. We just created the pool.
+	 */
+	cmd = megasas_get_cmd(instance);
+
+	init_frame = (struct megasas_init_frame *)cmd->frame;
+	initq_info = (struct megasas_init_queue_info *)
+		((unsigned long)init_frame + 64);
+
+	init_frame_h = cmd->frame_phys_addr;
+	initq_info_h = init_frame_h + 64;
+
+	context = init_frame->context;
+	memset(init_frame, 0, MEGAMFI_FRAME_SIZE);
+	memset(initq_info, 0, sizeof(struct megasas_init_queue_info));
+	init_frame->context = context;
+
+	initq_info->reply_queue_entries = instance->max_fw_cmds + 1;
+	initq_info->reply_queue_start_phys_addr_lo = instance->reply_queue_h;
+
+	initq_info->producer_index_phys_addr_lo = instance->producer_h;
+	initq_info->consumer_index_phys_addr_lo = instance->consumer_h;
+
+	init_frame->cmd = MFI_CMD_INIT;
+	init_frame->cmd_status = 0xFF;
+	init_frame->queue_info_new_phys_addr_lo = initq_info_h;
+
+	init_frame->data_xfer_len = sizeof(struct megasas_init_queue_info);
+
+	/*
+	 * disable the intr before firing the init frame to FW
+	 */
+	instance->instancet->disable_intr(instance->reg_set);
+
+	/*
+	 * Issue the init frame in polled mode
+	 */
+
+	if (megasas_issue_polled(instance, cmd)) {
+		printk(KERN_ERR "megasas: Failed to init firmware\n");
+		megasas_return_cmd(instance, cmd);
+		goto fail_fw_init;
+	}
+
+	megasas_return_cmd(instance, cmd);
+
+	return 0;
+
+fail_fw_init:
+	return -EINVAL;
+}
+
+/**
  * megasas_init_mfi -	Initializes the FW
  * @instance:		Adapter soft state
  *
@@ -1815,15 +1890,7 @@ static int megasas_init_mfi(struct megas
 	u32 max_sectors_1;
 	u32 max_sectors_2;
 	struct megasas_register_set __iomem *reg_set;
-
-	struct megasas_cmd *cmd;
 	struct megasas_ctrl_info *ctrl_info;
-
-	struct megasas_init_frame *init_frame;
-	struct megasas_init_queue_info *initq_info;
-	dma_addr_t init_frame_h;
-	dma_addr_t initq_info_h;
-
 	/*
 	 * Map the message registers
 	 */
@@ -1900,52 +1967,8 @@ static int megasas_init_mfi(struct megas
 		goto fail_reply_queue;
 	}
 
-	/*
-	 * Prepare a init frame. Note the init frame points to queue info
-	 * structure. Each frame has SGL allocated after first 64 bytes. For
-	 * this frame - since we don't need any SGL - we use SGL's space as
-	 * queue info structure
-	 *
-	 * We will not get a NULL command below. We just created the pool.
-	 */
-	cmd = megasas_get_cmd(instance);
-
-	init_frame = (struct megasas_init_frame *)cmd->frame;
-	initq_info = (struct megasas_init_queue_info *)
-	    ((unsigned long)init_frame + 64);
-
-	init_frame_h = cmd->frame_phys_addr;
-	initq_info_h = init_frame_h + 64;
-
-	memset(init_frame, 0, MEGAMFI_FRAME_SIZE);
-	memset(initq_info, 0, sizeof(struct megasas_init_queue_info));
-
-	initq_info->reply_queue_entries = instance->max_fw_cmds + 1;
-	initq_info->reply_queue_start_phys_addr_lo = instance->reply_queue_h;
-
-	initq_info->producer_index_phys_addr_lo = instance->producer_h;
-	initq_info->consumer_index_phys_addr_lo = instance->consumer_h;
-
-	init_frame->cmd = MFI_CMD_INIT;
-	init_frame->cmd_status = 0xFF;
-	init_frame->queue_info_new_phys_addr_lo = initq_info_h;
-
-	init_frame->data_xfer_len = sizeof(struct megasas_init_queue_info);
-
-	/*
-	 * disable the intr before firing the init frame to FW
-	 */
-	instance->instancet->disable_intr(instance->reg_set);
-
-	/*
-	 * Issue the init frame in polled mode
-	 */
-	if (megasas_issue_polled(instance, cmd)) {
-		printk(KERN_DEBUG "megasas: Failed to init firmware\n");
+	if (megasas_issue_init_mfi(instance))
 		goto fail_fw_init;
-	}
-
-	megasas_return_cmd(instance, cmd);
 
 	ctrl_info = kmalloc(sizeof(struct megasas_ctrl_info), GFP_KERNEL);
 
@@ -1981,7 +2004,6 @@ static int megasas_init_mfi(struct megas
 	return 0;
 
       fail_fw_init:
-	megasas_return_cmd(instance, cmd);
 
 	pci_free_consistent(instance->pdev, reply_q_sz,
 			    instance->reply_queue, instance->reply_queue_h);
@@ -2263,6 +2285,28 @@ static int megasas_io_attach(struct mega
 	return 0;
 }
 
+static int
+megasas_set_dma_mask(struct pci_dev *pdev)
+{
+	/*
+	 * All our contollers are capable of performing 64-bit DMA
+	 */
+	if (IS_DMA64) {
+		if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) != 0) {
+
+			if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0)
+				goto fail_set_dma_mask;
+		}
+	} else {
+		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0)
+			goto fail_set_dma_mask;
+	}
+	return 0;
+
+fail_set_dma_mask:
+	return 1;
+}
+
 /**
  * megasas_probe_one -	PCI hotplug entry point
  * @pdev:		PCI device structure
@@ -2296,19 +2340,8 @@ megasas_probe_one(struct pci_dev *pdev, 
 
 	pci_set_master(pdev);
 
-	/*
-	 * All our contollers are capable of performing 64-bit DMA
-	 */
-	if (IS_DMA64) {
-		if (pci_set_dma_mask(pdev, DMA_64BIT_MASK) != 0) {
-
-			if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0)
-				goto fail_set_dma_mask;
-		}
-	} else {
-		if (pci_set_dma_mask(pdev, DMA_32BIT_MASK) != 0)
-			goto fail_set_dma_mask;
-	}
+	if (megasas_set_dma_mask(pdev))
+		goto fail_set_dma_mask;
 
 	host = scsi_host_alloc(&megasas_template,
 			       sizeof(struct megasas_instance));
@@ -2490,8 +2523,10 @@ static void megasas_flush_cache(struct m
 /**
  * megasas_shutdown_controller -	Instructs FW to shutdown the controller
  * @instance:				Adapter soft state
+ * @opcode:				Shutdown/Hibernate
  */
-static void megasas_shutdown_controller(struct megasas_instance *instance)
+static void megasas_shutdown_controller(struct megasas_instance *instance,
+					u32 opcode)
 {
 	struct megasas_cmd *cmd;
 	struct megasas_dcmd_frame *dcmd;
@@ -2514,7 +2549,7 @@ static void megasas_shutdown_controller(
 	dcmd->flags = MFI_FRAME_DIR_NONE;
 	dcmd->timeout = 0;
 	dcmd->data_xfer_len = 0;
-	dcmd->opcode = MR_DCMD_CTRL_SHUTDOWN;
+	dcmd->opcode = opcode;
 
 	megasas_issue_blocked_cmd(instance, cmd);
 
@@ -2524,6 +2559,131 @@ static void megasas_shutdown_controller(
 }
 
 /**
+ * megasas_suspend -    driver suspend entry point
+ * @pdev:               PCI device structure
+ * @state:		PCI power state to suspend routine
+ */
+static int __devinit
+megasas_suspend(struct pci_dev *pdev, pm_message_t state)
+{
+	struct Scsi_Host *host;
+	struct megasas_instance *instance;
+
+	instance = pci_get_drvdata(pdev);
+	host = instance->host;
+
+	megasas_flush_cache(instance);
+	megasas_shutdown_controller(instance, MR_DCMD_HIBERNATE_SHUTDOWN);
+	tasklet_kill(&instance->isr_tasklet);
+
+	pci_set_drvdata(instance->pdev, instance);
+	instance->instancet->disable_intr(instance->reg_set);
+	free_irq(instance->pdev->irq, instance);
+
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+
+	pci_set_power_state(pdev, pci_choose_state(pdev, state));
+
+	return 0;
+}
+
+/**
+ * megasas_resume-      driver resume entry point
+ * @pdev:               PCI device structure
+ */
+static int __devinit
+megasas_resume(struct pci_dev *pdev)
+{
+	int rval;
+	struct Scsi_Host *host;
+	struct megasas_instance *instance;
+
+	instance = pci_get_drvdata(pdev);
+	host = instance->host;
+	pci_set_power_state(pdev, PCI_D0);
+	pci_enable_wake(pdev, PCI_D0, 0);
+	pci_restore_state(pdev);
+
+	/*
+	 * PCI prepping: enable device set bus mastering and dma mask
+	 */
+	rval = pci_enable_device(pdev);
+
+	if (rval) {
+		printk(KERN_ERR "megasas: Enable device failed\n");
+		return rval;
+	}
+
+	pci_set_master(pdev);
+
+	if (megasas_set_dma_mask(pdev))
+		goto fail_set_dma_mask;
+
+	/*
+	 * Initialize MFI Firmware
+	 */
+
+	*instance->producer = 0;
+	*instance->consumer = 0;
+
+	atomic_set(&instance->fw_outstanding, 0);
+
+	/*
+	 * We expect the FW state to be READY
+	 */
+	if (megasas_transition_to_ready(instance))
+		goto fail_ready_state;
+
+	if (megasas_issue_init_mfi(instance))
+		goto fail_init_mfi;
+
+	tasklet_init(&instance->isr_tasklet, megasas_complete_cmd_dpc,
+			(unsigned long)instance);
+
+	/*
+	 * Register IRQ
+	 */
+	if (request_irq(pdev->irq, megasas_isr, IRQF_SHARED,
+		"megasas", instance)) {
+		printk(KERN_ERR "megasas: Failed to register IRQ\n");
+		goto fail_irq;
+	}
+
+	instance->instancet->enable_intr(instance->reg_set);
+
+	/*
+	 * Initiate AEN (Asynchronous Event Notification)
+	 */
+	if (megasas_start_aen(instance))
+		printk(KERN_ERR "megasas: Start AEN failed\n");
+
+	return 0;
+
+fail_irq:
+fail_init_mfi:
+	if (instance->evt_detail)
+		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
+				instance->evt_detail,
+				instance->evt_detail_h);
+
+	if (instance->producer)
+		pci_free_consistent(pdev, sizeof(u32), instance->producer,
+				instance->producer_h);
+	if (instance->consumer)
+		pci_free_consistent(pdev, sizeof(u32), instance->consumer,
+				instance->consumer_h);
+	scsi_host_put(host);
+
+fail_set_dma_mask:
+fail_ready_state:
+
+	pci_disable_device(pdev);
+
+	return -ENODEV;
+}
+
+/**
  * megasas_detach_one -	PCI hot"un"plug entry point
  * @pdev:		PCI device structure
  */
@@ -2538,7 +2698,7 @@ static void megasas_detach_one(struct pc
 
 	scsi_remove_host(instance->host);
 	megasas_flush_cache(instance);
-	megasas_shutdown_controller(instance);
+	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
 	tasklet_kill(&instance->isr_tasklet);
 
 	/*
@@ -2977,6 +3137,8 @@ static struct pci_driver megasas_pci_dri
 	.id_table = megasas_pci_table,
 	.probe = megasas_probe_one,
 	.remove = __devexit_p(megasas_detach_one),
+	.suspend = megasas_suspend,
+	.resume = megasas_resume,
 	.shutdown = megasas_shutdown,
 };
 
diff -rupN linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.h linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.h
--- linux-2.6.22_orig/drivers/scsi/megaraid/megaraid_sas.h	2007-11-07 01:31:40.236678000 -0500
+++ linux-2.6.22_new/drivers/scsi/megaraid/megaraid_sas.h	2007-11-07 01:34:31.530637360 -0500
@@ -117,6 +117,7 @@
 #define MR_FLUSH_DISK_CACHE			0x02
 
 #define MR_DCMD_CTRL_SHUTDOWN			0x01050000
+#define MR_DCMD_HIBERNATE_SHUTDOWN		0x01060000
 #define MR_ENABLE_DRIVE_SPINDOWN		0x01
 
 #define MR_DCMD_CTRL_EVENT_GET_INFO		0x01040100

