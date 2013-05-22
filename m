From: <Sumit.Saxena@lsi.com>
Subject: [PATCH 09/12] megaraid_sas : Add support for Extended MSI-x
 vectors for 12Gb/s controller
Date: Wed, 22 May 2013 12:34:14 +0530
Message-ID: <201305221234.r4MCYUNV012885@cosmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe002.messaging.microsoft.com ([216.32.181.182]:36880
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752813Ab3EVMei (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 May 2013 08:34:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: jbottomley@parallels.com, kashyap.desai@lsi.com, aradford@gmail.com

Add support for Extended MSI-x vectors for Invader and Fury(12Gb/s HBA).

This Driver will use more than 8 MSI-x support provided by Invader/Fury max upto 128 MSI-x.


Signed-off-by: Sumit Saxena <sumit.saxena@lsi.com>
Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 474f79f..d430618 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -786,7 +786,7 @@ struct megasas_ctrl_info {
 #define MEGASAS_INT_CMDS			32
 #define MEGASAS_SKINNY_INT_CMDS			5
 
-#define MEGASAS_MAX_MSIX_QUEUES			16
+#define MEGASAS_MAX_MSIX_QUEUES			128
 /*
  * FW can accept both 32 and 64 bit SGLs. We want to allocate 32/64 bit
  * SGLs based on the size of dma_addr_t
@@ -811,6 +811,11 @@ struct megasas_ctrl_info {
 #define MFI_1068_PCSR_OFFSET			0x84
 #define MFI_1068_FW_HANDSHAKE_OFFSET		0x64
 #define MFI_1068_FW_READY			0xDDDD0000
+
+#define MR_MAX_REPLY_QUEUES_OFFSET              0X0000001F
+#define MR_MAX_REPLY_QUEUES_EXT_OFFSET          0X003FC000
+#define MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT    14
+#define MR_MAX_MSIX_REG_ARRAY                   16
 /*
 * register set for both 1068 and 1078 controllers
 * structure extended for 1078 registers
@@ -920,6 +925,15 @@ union megasas_sgl_frame {
 
 } __attribute__ ((packed));
 
+typedef union _MFI_CAPABILITIES {
+	struct {
+		u32     support_fp_remote_lun:1;
+		u32     support_additional_msix:1;
+		u32     reserved:30;
+	} mfi_capabilities;
+	u32     reg;
+} MFI_CAPABILITIES;
+
 struct megasas_init_frame {
 
 	u8 cmd;			/*00h */
@@ -927,7 +941,7 @@ struct megasas_init_frame {
 	u8 cmd_status;		/*02h */
 
 	u8 reserved_1;		/*03h */
-	u32 reserved_2;		/*04h */
+	MFI_CAPABILITIES driver_operations; /*04h*/
 
 	u32 context;		/*08h */
 	u32 pad_0;		/*0Ch */
@@ -1324,7 +1338,7 @@ struct megasas_instance {
 
 	unsigned long base_addr;
 	struct megasas_register_set __iomem *reg_set;
-
+	u32 *reply_post_host_index_addr[MR_MAX_MSIX_REG_ARRAY];
 	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
 	u8     ld_ids[MEGASAS_MAX_LD_IDS];
 	s8 init_id;
@@ -1393,6 +1407,7 @@ struct megasas_instance {
 	long reset_flags;
 	struct mutex reset_mutex;
 	int throttlequeuedepth;
+	u8 mask_interrupts;
 };
 
 enum {
@@ -1408,8 +1423,8 @@ struct megasas_instance_template {
 	void (*fire_cmd)(struct megasas_instance *, dma_addr_t, \
 		u32, struct megasas_register_set __iomem *);
 
-	void (*enable_intr)(struct megasas_register_set __iomem *) ;
-	void (*disable_intr)(struct megasas_register_set __iomem *);
+	void (*enable_intr)(struct megasas_instance *) ;
+	void (*disable_intr)(struct megasas_instance *);
 
 	int (*clear_intr)(struct megasas_register_set __iomem *);
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index cef4fd1..5c66e71 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -244,8 +244,10 @@ megasas_return_cmd(struct megasas_instance *instance, struct megasas_cmd *cmd)
  * @regs:			MFI register set
  */
 static inline void
-megasas_enable_intr_xscale(struct megasas_register_set __iomem * regs)
+megasas_enable_intr_xscale(struct megasas_instance *instance)
 {
+	struct megasas_register_set __iomem *regs;
+	regs = instance->reg_set;
 	writel(0, &(regs)->outbound_intr_mask);
 
 	/* Dummy readl to force pci flush */
@@ -257,9 +259,11 @@ megasas_enable_intr_xscale(struct megasas_register_set __iomem * regs)
  * @regs:			MFI register set
  */
 static inline void
-megasas_disable_intr_xscale(struct megasas_register_set __iomem * regs)
+megasas_disable_intr_xscale(struct megasas_instance *instance)
 {
+	struct megasas_register_set __iomem *regs;
 	u32 mask = 0x1f;
+	regs = instance->reg_set;
 	writel(mask, &regs->outbound_intr_mask);
 	/* Dummy readl to force pci flush */
 	readl(&regs->outbound_intr_mask);
@@ -413,8 +417,10 @@ static struct megasas_instance_template megasas_instance_template_xscale = {
  * @regs:			MFI register set
  */
 static inline void
-megasas_enable_intr_ppc(struct megasas_register_set __iomem * regs)
+megasas_enable_intr_ppc(struct megasas_instance *instance)
 {
+	struct megasas_register_set __iomem *regs;
+	regs = instance->reg_set;
 	writel(0xFFFFFFFF, &(regs)->outbound_doorbell_clear);
 
 	writel(~0x80000000, &(regs)->outbound_intr_mask);
@@ -428,9 +434,11 @@ megasas_enable_intr_ppc(struct megasas_register_set __iomem * regs)
  * @regs:			MFI register set
  */
 static inline void
-megasas_disable_intr_ppc(struct megasas_register_set __iomem * regs)
+megasas_disable_intr_ppc(struct megasas_instance *instance)
 {
+	struct megasas_register_set __iomem *regs;
 	u32 mask = 0xFFFFFFFF;
+	regs = instance->reg_set;
 	writel(mask, &regs->outbound_intr_mask);
 	/* Dummy readl to force pci flush */
 	readl(&regs->outbound_intr_mask);
@@ -531,8 +539,10 @@ static struct megasas_instance_template megasas_instance_template_ppc = {
  * @regs:			MFI register set
  */
 static inline void
-megasas_enable_intr_skinny(struct megasas_register_set __iomem *regs)
+megasas_enable_intr_skinny(struct megasas_instance *instance)
 {
+	struct megasas_register_set __iomem *regs;
+	regs = instance->reg_set;
 	writel(0xFFFFFFFF, &(regs)->outbound_intr_mask);
 
 	writel(~MFI_SKINNY_ENABLE_INTERRUPT_MASK, &(regs)->outbound_intr_mask);
@@ -546,9 +556,11 @@ megasas_enable_intr_skinny(struct megasas_register_set __iomem *regs)
  * @regs:			MFI register set
  */
 static inline void
-megasas_disable_intr_skinny(struct megasas_register_set __iomem *regs)
+megasas_disable_intr_skinny(struct megasas_instance *instance)
 {
+	struct megasas_register_set __iomem *regs;
 	u32 mask = 0xFFFFFFFF;
+	regs = instance->reg_set;
 	writel(mask, &regs->outbound_intr_mask);
 	/* Dummy readl to force pci flush */
 	readl(&regs->outbound_intr_mask);
@@ -666,8 +678,10 @@ static struct megasas_instance_template megasas_instance_template_skinny = {
  * @regs:                      MFI register set
  */
 static inline void
-megasas_enable_intr_gen2(struct megasas_register_set __iomem *regs)
+megasas_enable_intr_gen2(struct megasas_instance *instance)
 {
+	struct megasas_register_set __iomem *regs;
+	regs = instance->reg_set;
 	writel(0xFFFFFFFF, &(regs)->outbound_doorbell_clear);
 
 	/* write ~0x00000005 (4 & 1) to the intr mask*/
@@ -682,9 +696,11 @@ megasas_enable_intr_gen2(struct megasas_register_set __iomem *regs)
  * @regs:                      MFI register set
  */
 static inline void
-megasas_disable_intr_gen2(struct megasas_register_set __iomem *regs)
+megasas_disable_intr_gen2(struct megasas_instance *instance)
 {
+	struct megasas_register_set __iomem *regs;
 	u32 mask = 0xFFFFFFFF;
+	regs = instance->reg_set;
 	writel(mask, &regs->outbound_intr_mask);
 	/* Dummy readl to force pci flush */
 	readl(&regs->outbound_intr_mask);
@@ -1707,7 +1723,7 @@ void megasas_do_ocr(struct megasas_instance *instance)
 	(instance->pdev->device == PCI_DEVICE_ID_LSI_VERDE_ZCR)) {
 		*instance->consumer     = MEGASAS_ADPRESET_INPROG_SIGN;
 	}
-	instance->instancet->disable_intr(instance->reg_set);
+	instance->instancet->disable_intr(instance);
 	instance->adprecovery   = MEGASAS_ADPRESET_SM_INFAULT;
 	instance->issuepend_done = 0;
 
@@ -2490,7 +2506,7 @@ process_fw_state_change_wq(struct work_struct *work)
 		printk(KERN_NOTICE "megaraid_sas: FW detected to be in fault"
 					"state, restarting it...\n");
 
-		instance->instancet->disable_intr(instance->reg_set);
+		instance->instancet->disable_intr(instance);
 		atomic_set(&instance->fw_outstanding, 0);
 
 		atomic_set(&instance->fw_reset_no_pci_access, 1);
@@ -2531,7 +2547,7 @@ process_fw_state_change_wq(struct work_struct *work)
 		spin_lock_irqsave(&instance->hba_lock, flags);
 		instance->adprecovery	= MEGASAS_HBA_OPERATIONAL;
 		spin_unlock_irqrestore(&instance->hba_lock, flags);
-		instance->instancet->enable_intr(instance->reg_set);
+		instance->instancet->enable_intr(instance);
 
 		megasas_issue_pending_cmds_again(instance);
 		instance->issuepend_done = 1;
@@ -2594,7 +2610,7 @@ megasas_deplete_reply_queue(struct megasas_instance *instance,
 			}
 
 
-			instance->instancet->disable_intr(instance->reg_set);
+			instance->instancet->disable_intr(instance);
 			instance->adprecovery	= MEGASAS_ADPRESET_SM_INFAULT;
 			instance->issuepend_done = 0;
 
@@ -2728,7 +2744,7 @@ megasas_transition_to_ready(struct megasas_instance *instance, int ocr)
 			/*
 			 * Bring it to READY state; assuming max wait 10 secs
 			 */
-			instance->instancet->disable_intr(instance->reg_set);
+			instance->instancet->disable_intr(instance);
 			if ((instance->pdev->device ==
 				PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
 				(instance->pdev->device ==
@@ -3374,7 +3390,7 @@ megasas_issue_init_mfi(struct megasas_instance *instance)
 	/*
 	 * disable the intr before firing the init frame to FW
 	 */
-	instance->instancet->disable_intr(instance->reg_set);
+	instance->instancet->disable_intr(instance);
 
 	/*
 	 * Issue the init frame in polled mode
@@ -3481,11 +3497,11 @@ static int megasas_init_fw(struct megasas_instance *instance)
 {
 	u32 max_sectors_1;
 	u32 max_sectors_2;
-	u32 tmp_sectors, msix_enable;
+	u32 tmp_sectors, msix_enable, scratch_pad_2;
 	struct megasas_register_set __iomem *reg_set;
 	struct megasas_ctrl_info *ctrl_info;
 	unsigned long bar_list;
-	int i;
+	int i, loop, fw_msix_count = 0;
 
 	/* Find first memory bar */
 	bar_list = pci_select_bars(instance->pdev, IORESOURCE_MEM);
@@ -3537,21 +3553,49 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	if (megasas_transition_to_ready(instance, 0))
 		goto fail_ready_state;
 
+	/*
+	 * MSI-X host index 0 is common for all adapter.
+	 * It is used for all MPT based Adapters.
+	 */
+	instance->reply_post_host_index_addr[0] =
+		(u32 *)((u8 *)instance->reg_set +
+		MPI2_REPLY_POST_HOST_INDEX_OFFSET);
+
 	/* Check if MSI-X is supported while in ready state */
 	msix_enable = (instance->instancet->read_fw_status_reg(reg_set) &
 		       0x4000000) >> 0x1a;
 	if (msix_enable && !msix_disable) {
+		scratch_pad_2 = readl
+			(&instance->reg_set->outbound_scratch_pad_2);
 		/* Check max MSI-X vectors */
-		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
-			(instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
-			(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
-			instance->msix_vectors = (readl(&instance->reg_set->
-							outbound_scratch_pad_2
-							  ) & 0x1F) + 1;
+		if (instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) {
+			instance->msix_vectors = (scratch_pad_2
+				& MR_MAX_REPLY_QUEUES_OFFSET) + 1;
+			fw_msix_count = instance->msix_vectors;
 			if (msix_vectors)
 				instance->msix_vectors =
 					min(msix_vectors,
 					    instance->msix_vectors);
+		} else if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER)
+			|| (instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
+			/* Invader/Fury supports more than 8 MSI-X */
+			instance->msix_vectors = ((scratch_pad_2
+				& MR_MAX_REPLY_QUEUES_EXT_OFFSET)
+				>> MR_MAX_REPLY_QUEUES_EXT_OFFSET_SHIFT) + 1;
+			fw_msix_count = instance->msix_vectors;
+			/* Save 1-15 reply post index address to local memory
+			 * Index 0 is already saved from reg offset
+			 * MPI2_REPLY_POST_HOST_INDEX_OFFSET
+			 */
+			for (loop = 1; loop < MR_MAX_MSIX_REG_ARRAY; loop++) {
+				instance->reply_post_host_index_addr[loop] =
+					(u32 *)((u8 *)instance->reg_set +
+					MPI2_SUP_REPLY_POST_HOST_INDEX_OFFSET
+					+ (loop * 0x10));
+			}
+			if (msix_vectors)
+				instance->msix_vectors = min(msix_vectors,
+					instance->msix_vectors);
 		} else
 			instance->msix_vectors = 1;
 		/* Don't bother allocating more MSI-X vectors than cpus */
@@ -3571,6 +3615,12 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			}
 		} else
 			instance->msix_vectors = 0;
+
+		dev_info(&instance->pdev->dev, "[scsi%d]: FW supports"
+			"<%d> MSIX vector,Online CPUs: <%d>,"
+			"Current MSIX <%d>\n", instance->host->host_no,
+			fw_msix_count, (unsigned int)num_online_cpus(),
+			instance->msix_vectors);
 	}
 
 	/* Get operational params, sge flags, send init cmd to controller */
@@ -4166,6 +4216,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	if (megasas_init_fw(instance))
 		goto fail_init_mfi;
 
+retry_irq_register:
 	/*
 	 * Register IRQ
 	 */
@@ -4183,7 +4234,9 @@ static int megasas_probe_one(struct pci_dev *pdev,
 					free_irq(
 						instance->msixentry[j].vector,
 						&instance->irq_context[j]);
-				goto fail_irq;
+				/* Retry irq register for IO_APIC */
+				instance->msix_vectors = 0;
+				goto retry_irq_register;
 			}
 		}
 	} else {
@@ -4197,7 +4250,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		}
 	}
 
-	instance->instancet->enable_intr(instance->reg_set);
+	instance->instancet->enable_intr(instance);
 
 	/*
 	 * Store instance in PCI softstate
@@ -4237,7 +4290,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	megasas_mgmt_info.max_index--;
 
 	pci_set_drvdata(pdev, NULL);
-	instance->instancet->disable_intr(instance->reg_set);
+	instance->instancet->disable_intr(instance);
 	if (instance->msix_vectors)
 		for (i = 0 ; i < instance->msix_vectors; i++)
 			free_irq(instance->msixentry[i].vector,
@@ -4387,7 +4440,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 	tasklet_kill(&instance->isr_tasklet);
 
 	pci_set_drvdata(instance->pdev, instance);
-	instance->instancet->disable_intr(instance->reg_set);
+	instance->instancet->disable_intr(instance);
 
 	if (instance->msix_vectors)
 		for (i = 0 ; i < instance->msix_vectors; i++)
@@ -4512,7 +4565,7 @@ megasas_resume(struct pci_dev *pdev)
 		}
 	}
 
-	instance->instancet->enable_intr(instance->reg_set);
+	instance->instancet->enable_intr(instance);
 	instance->unload = 0;
 
 	/*
@@ -4594,7 +4647,7 @@ static void megasas_detach_one(struct pci_dev *pdev)
 
 	pci_set_drvdata(instance->pdev, NULL);
 
-	instance->instancet->disable_intr(instance->reg_set);
+	instance->instancet->disable_intr(instance);
 
 	if (instance->msix_vectors)
 		for (i = 0 ; i < instance->msix_vectors; i++)
@@ -4654,7 +4707,7 @@ static void megasas_shutdown(struct pci_dev *pdev)
 	instance->unload = 1;
 	megasas_flush_cache(instance);
 	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
-	instance->instancet->disable_intr(instance->reg_set);
+	instance->instancet->disable_intr(instance);
 	if (instance->msix_vectors)
 		for (i = 0 ; i < instance->msix_vectors; i++)
 			free_irq(instance->msixentry[i].vector,
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index c60f478..748b8ac 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -101,8 +101,10 @@ extern int resetwaittime;
  * @regs:			MFI register set
  */
 void
-megasas_enable_intr_fusion(struct megasas_register_set __iomem *regs)
+megasas_enable_intr_fusion(struct megasas_instance *instance)
 {
+	struct megasas_register_set __iomem *regs;
+	regs = instance->reg_set;
 	/* For Thunderbolt/Invader also clear intr on enable */
 	writel(~0, &regs->outbound_intr_status);
 	readl(&regs->outbound_intr_status);
@@ -111,6 +113,7 @@ megasas_enable_intr_fusion(struct megasas_register_set __iomem *regs)
 
 	/* Dummy readl to force pci flush */
 	readl(&regs->outbound_intr_mask);
+	instance->mask_interrupts = 0;
 }
 
 /**
@@ -118,10 +121,13 @@ megasas_enable_intr_fusion(struct megasas_register_set __iomem *regs)
  * @regs:			 MFI register set
  */
 void
-megasas_disable_intr_fusion(struct megasas_register_set __iomem *regs)
+megasas_disable_intr_fusion(struct megasas_instance *instance)
 {
 	u32 mask = 0xFFFFFFFF;
 	u32 status;
+	struct megasas_register_set __iomem *regs;
+	regs = instance->reg_set;
+	instance->mask_interrupts = 1;
 
 	writel(mask, &regs->outbound_intr_mask);
 	/* Dummy readl to force pci flush */
@@ -643,6 +649,12 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	init_frame->cmd	= MFI_CMD_INIT;
 	init_frame->cmd_status = 0xFF;
 
+	/* driver support Extended MSIX */
+	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
+		(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
+		init_frame->driver_operations.
+			mfi_capabilities.support_additional_msix = 1;
+
 	init_frame->queue_info_new_phys_addr_lo = ioc_init_handle;
 	init_frame->data_xfer_len = sizeof(struct MPI2_IOC_INIT_REQUEST);
 
@@ -657,7 +669,7 @@ megasas_ioc_init_fusion(struct megasas_instance *instance)
 	/*
 	 * disable the intr before firing the init frame
 	 */
-	instance->instancet->disable_intr(instance->reg_set);
+	instance->instancet->disable_intr(instance);
 
 	for (i = 0; i < (10 * 1000); i += 20) {
 		if (readl(&instance->reg_set->doorbell) & 1)
@@ -1911,8 +1923,15 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 		return IRQ_NONE;
 
 	wmb();
-	writel((MSIxIndex << 24) | fusion->last_reply_idx[MSIxIndex],
-	       &instance->reg_set->reply_post_host_index);
+	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
+		(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
+		writel(((MSIxIndex & 0x7) << 24) |
+			fusion->last_reply_idx[MSIxIndex],
+			instance->reply_post_host_index_addr[MSIxIndex/8]);
+	else
+		writel((MSIxIndex << 24) |
+			fusion->last_reply_idx[MSIxIndex],
+			instance->reply_post_host_index_addr[0]);
 	megasas_check_and_restore_queue_depth(instance);
 	return IRQ_HANDLED;
 }
@@ -1954,6 +1973,9 @@ irqreturn_t megasas_isr_fusion(int irq, void *devp)
 	struct megasas_instance *instance = irq_context->instance;
 	u32 mfiStatus, fw_state;
 
+	if (instance->mask_interrupts)
+		return IRQ_NONE;
+
 	if (!instance->msix_vectors) {
 		mfiStatus = instance->instancet->clear_intr(instance->reg_set);
 		if (!mfiStatus)
@@ -2219,7 +2241,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost)
 	mutex_lock(&instance->reset_mutex);
 	set_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
 	instance->adprecovery = MEGASAS_ADPRESET_SM_INFAULT;
-	instance->instancet->disable_intr(instance->reg_set);
+	instance->instancet->disable_intr(instance);
 	msleep(1000);
 
 	/* First try waiting for commands to complete */
@@ -2343,7 +2365,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost)
 
 			clear_bit(MEGASAS_FUSION_IN_RESET,
 				  &instance->reset_flags);
-			instance->instancet->enable_intr(instance->reg_set);
+			instance->instancet->enable_intr(instance);
 			instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
 
 			/* Re-fire management commands */
@@ -2405,7 +2427,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost)
 		retval = FAILED;
 	} else {
 		clear_bit(MEGASAS_FUSION_IN_RESET, &instance->reset_flags);
-		instance->instancet->enable_intr(instance->reg_set);
+		instance->instancet->enable_intr(instance);
 		instance->adprecovery = MEGASAS_HBA_OPERATIONAL;
 	}
 out:
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.h b/drivers/scsi/megaraid/megaraid_sas_fusion.h
index f68a3cd..004c18e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.h
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.h
@@ -43,7 +43,7 @@
 #define HOST_DIAG_WRITE_ENABLE			    0x80
 #define HOST_DIAG_RESET_ADAPTER			    0x4
 #define MEGASAS_FUSION_MAX_RESET_TRIES		    3
-#define MAX_MSIX_QUEUES_FUSION			    16
+#define MAX_MSIX_QUEUES_FUSION			    128
 
 /* Invader defines */
 #define MPI2_TYPE_CUDA				    0x2
@@ -62,6 +62,9 @@
 #define MEGASAS_RD_WR_PROTECT_CHECK_ALL		    0x20
 #define MEGASAS_RD_WR_PROTECT_CHECK_NONE	    0x60
 
+#define MPI2_SUP_REPLY_POST_HOST_INDEX_OFFSET   (0x0000030C)
+#define MPI2_REPLY_POST_HOST_INDEX_OFFSET	(0x0000006C)
+
 /*
  * Raid context flags
  */

