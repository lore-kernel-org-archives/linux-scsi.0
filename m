From: adam radford <aradford@gmail.com>
Subject: [PATCH 8/10] megaraid_sas: Add multiple MSI-X vector/multiple reply
 queue support
Date: Sat, 8 Oct 2011 18:15:13 -0700
Message-ID: <CAHtARFHqcciVUFN2FAt0eAfdW184spbHfSzQ+UOTpij7BF9e9Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=0016e64c393a02037d04aed3687b
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62149 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1JIBPO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Oct 2011 21:15:14 -0400
Received: by mail-wy0-f174.google.com with SMTP id 34so4924347wyg.19
        for <linux-scsi@vger.kernel.org>; Sat, 08 Oct 2011 18:15:13 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Bo.Yang@lsi.com

--0016e64c393a02037d04aed3687b
Content-Type: text/plain; charset=ISO-8859-1

James/linux-scsi,

The following patch for megaraid_sas adds multiple MSI-X vector and
multiple reply queue support.

Signed-off-by: Adam Radford <aradford@gmail.com>

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_base.c	2011-10-08
15:28:51.698330861 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_base.c	2011-10-08
15:18:29.354267547 -0700
@@ -2536,7 +2536,7 @@
 						instance->reg_set)
 						) == 0) {
 		/* Hardware may not set outbound_intr_status in MSI-X mode */
-		if (!instance->msi_flag)
+		if (!instance->msix_vectors)
 			return IRQ_NONE;
 	}

@@ -2594,16 +2594,14 @@
  */
 static irqreturn_t megasas_isr(int irq, void *devp)
 {
-	struct megasas_instance *instance;
+	struct megasas_irq_context *irq_context = devp;
+	struct megasas_instance *instance = irq_context->instance;
 	unsigned long flags;
 	irqreturn_t	rc;

-	if (atomic_read(
-		&(((struct megasas_instance *)devp)->fw_reset_no_pci_access)))
+	if (atomic_read(&instance->fw_reset_no_pci_access))
 		return IRQ_HANDLED;

-	instance = (struct megasas_instance *)devp;
-
 	spin_lock_irqsave(&instance->hba_lock, flags);
 	rc =  megasas_deplete_reply_queue(instance, DID_OK);
 	spin_unlock_irqrestore(&instance->hba_lock, flags);
@@ -3488,6 +3486,7 @@
 	struct megasas_register_set __iomem *reg_set;
 	struct megasas_ctrl_info *ctrl_info;
 	unsigned long bar_list;
+	int i;

 	/* Find first memory bar */
 	bar_list = pci_select_bars(instance->pdev, IORESOURCE_MEM);
@@ -3541,9 +3540,33 @@
 	/* Check if MSI-X is supported while in ready state */
 	msix_enable = (instance->instancet->read_fw_status_reg(reg_set) &
 		       0x4000000) >> 0x1a;
-	if (msix_enable && !msix_disable &&
-	    !pci_enable_msix(instance->pdev, &instance->msixentry, 1))
-		instance->msi_flag = 1;
+	if (msix_enable && !msix_disable) {
+		/* Check max MSI-X vectors */
+		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
+		    (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER)) {
+			instance->msix_vectors = (readl(&instance->reg_set->
+							outbound_scratch_pad_2
+							  ) & 0x1F) + 1;
+		} else
+			instance->msix_vectors = 1;
+		/* Don't bother allocating more MSI-X vectors than cpus */
+		instance->msix_vectors = min(instance->msix_vectors,
+					     (unsigned int)num_online_cpus());
+		for (i = 0; i < instance->msix_vectors; i++)
+			instance->msixentry[i].entry = i;
+		i = pci_enable_msix(instance->pdev, instance->msixentry,
+				    instance->msix_vectors);
+		if (i >= 0) {
+			if (i) {
+				if (!pci_enable_msix(instance->pdev,
+						     instance->msixentry, i))
+					instance->msix_vectors = i;
+				else
+					instance->msix_vectors = 0;
+			}
+		} else
+			instance->msix_vectors = 0;
+	}

 	/* Get operational params, sge flags, send init cmd to controller */
 	if (instance->instancet->init_adapter(instance))
@@ -3958,7 +3981,7 @@
 static int __devinit
 megasas_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	int rval, pos;
+	int rval, pos, i, j;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 	u16 control = 0;
@@ -4126,11 +4149,32 @@
 	/*
 	 * Register IRQ
 	 */
-	if (request_irq(instance->msi_flag ? instance->msixentry.vector :
-			pdev->irq, instance->instancet->service_isr,
-			IRQF_SHARED, "megasas", instance)) {
-		printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
-		goto fail_irq;
+	if (instance->msix_vectors) {
+		for (i = 0 ; i < instance->msix_vectors; i++) {
+			instance->irq_context[i].instance = instance;
+			instance->irq_context[i].MSIxIndex = i;
+			if (request_irq(instance->msixentry[i].vector,
+					instance->instancet->service_isr, 0,
+					"megasas",
+					&instance->irq_context[i])) {
+				printk(KERN_DEBUG "megasas: Failed to "
+				       "register IRQ for vector %d.\n", i);
+				for (j = 0 ; j < i ; j++)
+					free_irq(
+						instance->msixentry[j].vector,
+						&instance->irq_context[j]);
+				goto fail_irq;
+			}
+		}
+	} else {
+		instance->irq_context[0].instance = instance;
+		instance->irq_context[0].MSIxIndex = 0;
+		if (request_irq(pdev->irq, instance->instancet->service_isr,
+				IRQF_SHARED, "megasas",
+				&instance->irq_context[0])) {
+			printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
+			goto fail_irq;
+		}
 	}

 	instance->instancet->enable_intr(instance->reg_set);
@@ -4174,8 +4218,12 @@

 	pci_set_drvdata(pdev, NULL);
 	instance->instancet->disable_intr(instance->reg_set);
-	free_irq(instance->msi_flag ? instance->msixentry.vector :
-		 instance->pdev->irq, instance);
+	if (instance->msix_vectors)
+		for (i = 0 ; i < instance->msix_vectors; i++)
+			free_irq(instance->msixentry[i].vector,
+				 &instance->irq_context[i]);
+	else
+		free_irq(instance->pdev->irq, &instance->irq_context[0]);
 fail_irq:
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
 	    (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER))
@@ -4183,7 +4231,7 @@
 	else
 		megasas_release_mfi(instance);
       fail_init_mfi:
-	if (instance->msi_flag)
+	if (instance->msix_vectors)
 		pci_disable_msix(instance->pdev);
       fail_alloc_dma_buf:
 	if (instance->evt_detail)
@@ -4299,6 +4347,7 @@
 {
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
+	int i;

 	instance = pci_get_drvdata(pdev);
 	host = instance->host;
@@ -4322,9 +4371,14 @@

 	pci_set_drvdata(instance->pdev, instance);
 	instance->instancet->disable_intr(instance->reg_set);
-	free_irq(instance->msi_flag ? instance->msixentry.vector :
-		 instance->pdev->irq, instance);
-	if (instance->msi_flag)
+
+	if (instance->msix_vectors)
+		for (i = 0 ; i < instance->msix_vectors; i++)
+			free_irq(instance->msixentry[i].vector,
+				 &instance->irq_context[i]);
+	else
+		free_irq(instance->pdev->irq, &instance->irq_context[0]);
+	if (instance->msix_vectors)
 		pci_disable_msix(instance->pdev);

 	pci_save_state(pdev);
@@ -4342,7 +4396,7 @@
 static int
 megasas_resume(struct pci_dev *pdev)
 {
-	int rval;
+	int rval, i, j;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;

@@ -4380,8 +4434,9 @@
 		goto fail_ready_state;

 	/* Now re-enable MSI-X */
-	if (instance->msi_flag)
-		pci_enable_msix(instance->pdev, &instance->msixentry, 1);
+	if (instance->msix_vectors)
+		pci_enable_msix(instance->pdev, instance->msixentry,
+				instance->msix_vectors);

 	switch (instance->pdev->device) {
 	case PCI_DEVICE_ID_LSI_FUSION:
@@ -4411,11 +4466,32 @@
 	/*
 	 * Register IRQ
 	 */
-	if (request_irq(instance->msi_flag ? instance->msixentry.vector :
-			pdev->irq, instance->instancet->service_isr,
-			IRQF_SHARED, "megasas", instance)) {
-		printk(KERN_ERR "megasas: Failed to register IRQ\n");
-		goto fail_irq;
+	if (instance->msix_vectors) {
+		for (i = 0 ; i < instance->msix_vectors; i++) {
+			instance->irq_context[i].instance = instance;
+			instance->irq_context[i].MSIxIndex = i;
+			if (request_irq(instance->msixentry[i].vector,
+					instance->instancet->service_isr, 0,
+					"megasas",
+					&instance->irq_context[i])) {
+				printk(KERN_DEBUG "megasas: Failed to "
+				       "register IRQ for vector %d.\n", i);
+				for (j = 0 ; j < i ; j++)
+					free_irq(
+						instance->msixentry[j].vector,
+						&instance->irq_context[j]);
+				goto fail_irq;
+			}
+		}
+	} else {
+		instance->irq_context[0].instance = instance;
+		instance->irq_context[0].MSIxIndex = 0;
+		if (request_irq(pdev->irq, instance->instancet->service_isr,
+				IRQF_SHARED, "megasas",
+				&instance->irq_context[0])) {
+			printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
+			goto fail_irq;
+		}
 	}

 	instance->instancet->enable_intr(instance->reg_set);
@@ -4512,9 +4588,13 @@

 	instance->instancet->disable_intr(instance->reg_set);

-	free_irq(instance->msi_flag ? instance->msixentry.vector :
-		 instance->pdev->irq, instance);
-	if (instance->msi_flag)
+	if (instance->msix_vectors)
+		for (i = 0 ; i < instance->msix_vectors; i++)
+			free_irq(instance->msixentry[i].vector,
+				 &instance->irq_context[i]);
+	else
+		free_irq(instance->pdev->irq, &instance->irq_context[0]);
+	if (instance->msix_vectors)
 		pci_disable_msix(instance->pdev);

 	switch (instance->pdev->device) {
@@ -4560,14 +4640,20 @@
  */
 static void megasas_shutdown(struct pci_dev *pdev)
 {
+	int i;
 	struct megasas_instance *instance = pci_get_drvdata(pdev);
+
 	instance->unload = 1;
 	megasas_flush_cache(instance);
 	megasas_shutdown_controller(instance, MR_DCMD_CTRL_SHUTDOWN);
 	instance->instancet->disable_intr(instance->reg_set);
-	free_irq(instance->msi_flag ? instance->msixentry.vector :
-		 instance->pdev->irq, instance);
-	if (instance->msi_flag)
+	if (instance->msix_vectors)
+		for (i = 0 ; i < instance->msix_vectors; i++)
+			free_irq(instance->msixentry[i].vector,
+				 &instance->irq_context[i]);
+	else
+		free_irq(instance->pdev->irq, &instance->irq_context[0]);
+	if (instance->msix_vectors)
 		pci_disable_msix(instance->pdev);
 }

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-10-08
15:28:51.699330817 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.c	2011-10-08
15:28:31.213333058 -0700
@@ -385,7 +385,7 @@
 int
 megasas_alloc_cmds_fusion(struct megasas_instance *instance)
 {
-	int i, j;
+	int i, j, count;
 	u32 max_cmd, io_frames_sz;
 	struct fusion_context *fusion;
 	struct megasas_cmd_fusion *cmd;
@@ -409,9 +409,10 @@
 		goto fail_req_desc;
 	}

+	count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
 	fusion->reply_frames_desc_pool =
 		pci_pool_create("reply_frames pool", instance->pdev,
-				fusion->reply_alloc_sz, 16, 0);
+				fusion->reply_alloc_sz * count, 16, 0);

 	if (!fusion->reply_frames_desc_pool) {
 		printk(KERN_ERR "megasas; Could not allocate memory for "
@@ -430,7 +431,7 @@
 	}

 	reply_desc = fusion->reply_frames_desc;
-	for (i = 0; i < fusion->reply_q_depth; i++, reply_desc++)
+	for (i = 0; i < fusion->reply_q_depth * count; i++, reply_desc++)
 		reply_desc->Words = ULLONG_MAX;

 	io_frames_sz = fusion->io_frames_alloc_sz;
@@ -633,7 +634,9 @@
 		fusion->reply_frames_desc_phys;
 	IOCInitMessage->SystemRequestFrameBaseAddress =
 		fusion->io_request_frames_phys;
-
+	/* Set to 0 for none or 1 MSI-X vectors */
+	IOCInitMessage->HostMSIxVectors = (instance->msix_vectors > 0 ?
+					   instance->msix_vectors : 0);
 	init_frame = (struct megasas_init_frame *)cmd->frame;
 	memset(init_frame, 0, MEGAMFI_FRAME_SIZE);

@@ -877,7 +880,7 @@
 	struct megasas_register_set __iomem *reg_set;
 	struct fusion_context *fusion;
 	u32 max_cmd;
-	int i = 0;
+	int i = 0, count;

 	fusion = instance->ctrl_context;

@@ -929,7 +932,9 @@
 		(MEGA_MPI2_RAID_DEFAULT_IO_FRAME_SIZE -
 		 sizeof(union MPI2_SGE_IO_UNION))/16;

-	fusion->last_reply_idx = 0;
+	count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
+	for (i = 0 ; i < count; i++)
+		fusion->last_reply_idx[i] = 0;

 	/*
 	 * Allocate memory for descriptors
@@ -1421,6 +1426,12 @@
 			fp_possible = io_info.fpOkForIo;
 	}

+	/* Use smp_processor_id() for now until cmd->request->cpu is CPU
+	   id by default, not CPU group id, otherwise all MSI-X queues won't
+	   be utilized */
+	cmd->request_desc->SCSIIO.MSIxIndex = instance->msix_vectors ?
+		smp_processor_id() % instance->msix_vectors : 0;
+
 	if (fp_possible) {
 		megasas_set_pd_lba(io_request, scp->cmd_len, &io_info, scp,
 				   local_map_ptr, start_lba_lo);
@@ -1691,7 +1702,7 @@
  * Completes all commands that is in reply descriptor queue
  */
 int
-complete_cmd_fusion(struct megasas_instance *instance)
+complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 {
 	union MPI2_REPLY_DESCRIPTORS_UNION *desc;
 	struct MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR *reply_desc;
@@ -1711,7 +1722,9 @@
 		return IRQ_HANDLED;

 	desc = fusion->reply_frames_desc;
-	desc += fusion->last_reply_idx;
+	desc += ((MSIxIndex * fusion->reply_alloc_sz)/
+		 sizeof(union MPI2_REPLY_DESCRIPTORS_UNION)) +
+		fusion->last_reply_idx[MSIxIndex];

 	reply_desc = (struct MPI2_SCSI_IO_SUCCESS_REPLY_DESCRIPTOR *)desc;

@@ -1784,16 +1797,19 @@
 			break;
 		}

-		fusion->last_reply_idx++;
-		if (fusion->last_reply_idx >= fusion->reply_q_depth)
-			fusion->last_reply_idx = 0;
+		fusion->last_reply_idx[MSIxIndex]++;
+		if (fusion->last_reply_idx[MSIxIndex] >=
+		    fusion->reply_q_depth)
+			fusion->last_reply_idx[MSIxIndex] = 0;

 		desc->Words = ULLONG_MAX;
 		num_completed++;

 		/* Get the next reply descriptor */
-		if (!fusion->last_reply_idx)
-			desc = fusion->reply_frames_desc;
+		if (!fusion->last_reply_idx[MSIxIndex])
+			desc = fusion->reply_frames_desc +
+				((MSIxIndex * fusion->reply_alloc_sz)/
+				 sizeof(union MPI2_REPLY_DESCRIPTORS_UNION));
 		else
 			desc++;

@@ -1813,7 +1829,7 @@
 		return IRQ_NONE;

 	wmb();
-	writel(fusion->last_reply_idx,
+	writel((MSIxIndex << 24) | fusion->last_reply_idx[MSIxIndex],
 	       &instance->reg_set->reply_post_host_index);
 	megasas_check_and_restore_queue_depth(instance);
 	return IRQ_HANDLED;
@@ -1831,6 +1847,9 @@
 	struct megasas_instance *instance =
 		(struct megasas_instance *)instance_addr;
 	unsigned long flags;
+	u32 count, MSIxIndex;
+
+	count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;

 	/* If we have already declared adapter dead, donot complete cmds */
 	spin_lock_irqsave(&instance->hba_lock, flags);
@@ -1841,7 +1860,8 @@
 	spin_unlock_irqrestore(&instance->hba_lock, flags);

 	spin_lock_irqsave(&instance->completion_lock, flags);
-	complete_cmd_fusion(instance);
+	for (MSIxIndex = 0 ; MSIxIndex < count; MSIxIndex++)
+		complete_cmd_fusion(instance, MSIxIndex);
 	spin_unlock_irqrestore(&instance->completion_lock, flags);
 }

@@ -1850,10 +1870,11 @@
  */
 irqreturn_t megasas_isr_fusion(int irq, void *devp)
 {
-	struct megasas_instance *instance = (struct megasas_instance *)devp;
+	struct megasas_irq_context *irq_context = devp;
+	struct megasas_instance *instance = irq_context->instance;
 	u32 mfiStatus, fw_state;

-	if (!instance->msi_flag) {
+	if (!instance->msix_vectors) {
 		mfiStatus = instance->instancet->clear_intr(instance->reg_set);
 		if (!mfiStatus)
 			return IRQ_NONE;
@@ -1865,7 +1886,7 @@
 		return IRQ_HANDLED;
 	}

-	if (!complete_cmd_fusion(instance)) {
+	if (!complete_cmd_fusion(instance, irq_context->MSIxIndex)) {
 		instance->instancet->clear_intr(instance->reg_set);
 		/* If we didn't complete any commands, check for FW fault */
 		fw_state = instance->instancet->read_fw_status_reg(
@@ -2081,14 +2102,16 @@

 void  megasas_reset_reply_desc(struct megasas_instance *instance)
 {
-	int i;
+	int i, count;
 	struct fusion_context *fusion;
 	union MPI2_REPLY_DESCRIPTORS_UNION *reply_desc;

 	fusion = instance->ctrl_context;
-	fusion->last_reply_idx = 0;
+	count = instance->msix_vectors > 0 ? instance->msix_vectors : 1;
+	for (i = 0 ; i < count ; i++)
+		fusion->last_reply_idx[i] = 0;
 	reply_desc = fusion->reply_frames_desc;
-	for (i = 0 ; i < fusion->reply_q_depth; i++, reply_desc++)
+	for (i = 0 ; i < fusion->reply_q_depth * count; i++, reply_desc++)
 		reply_desc->Words = ULLONG_MAX;
 }

diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.h
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.h
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas_fusion.h	2011-10-08
15:28:51.699330817 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas_fusion.h	2011-10-08
15:07:04.816269266 -0700
@@ -43,6 +43,7 @@
 #define HOST_DIAG_WRITE_ENABLE			    0x80
 #define HOST_DIAG_RESET_ADAPTER			    0x4
 #define MEGASAS_FUSION_MAX_RESET_TRIES		    3
+#define MAX_MSIX_QUEUES_FUSION			    16

 /* Invader defines */
 #define MPI2_TYPE_CUDA				    0x2
@@ -673,7 +674,7 @@
 	union MPI2_REPLY_DESCRIPTORS_UNION *reply_frames_desc;
 	struct dma_pool *reply_frames_desc_pool;

-	u16 last_reply_idx;
+	u16 last_reply_idx[MAX_MSIX_QUEUES_FUSION];

 	u32 reply_q_depth;
 	u32 request_alloc_sz;
diff -Naur scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h
scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h
--- scsi-misc-2.6/drivers/scsi/megaraid/megaraid_sas.h	2011-10-08
15:28:51.700330765 -0700
+++ scsi-misc-2.6.new/drivers/scsi/megaraid/megaraid_sas.h	2011-10-08
15:09:19.378268539 -0700
@@ -757,6 +757,7 @@
 #define MEGASAS_INT_CMDS			32
 #define MEGASAS_SKINNY_INT_CMDS			5

+#define MEGASAS_MAX_MSIX_QUEUES			16
 /*
  * FW can accept both 32 and 64 bit SGLs. We want to allocate 32/64 bit
  * SGLs based on the size of dma_addr_t
@@ -1278,6 +1279,11 @@
 	struct megasas_instance *instance;
 };

+struct megasas_irq_context {
+	struct megasas_instance *instance;
+	u32 MSIxIndex;
+};
+
 struct megasas_instance {

 	u32 *producer;
@@ -1351,8 +1357,9 @@

 	/* Ptr to hba specific information */
 	void *ctrl_context;
-	u8	msi_flag;
-	struct msix_entry msixentry;
+	unsigned int msix_vectors;
+	struct msix_entry msixentry[MEGASAS_MAX_MSIX_QUEUES];
+	struct megasas_irq_context irq_context[MEGASAS_MAX_MSIX_QUEUES];
 	u64 map_id;
 	struct megasas_cmd *map_update_cmd;
 	unsigned long bar;

--0016e64c393a02037d04aed3687b
Content-Type: application/octet-stream; name="megaraid_sas.patch8"
Content-Disposition: attachment; filename="megaraid_sas.patch8"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gtjc39ff0

ZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9z
YXNfYmFzZS5jIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfYmFzZS5jCi0tLSBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdh
cmFpZF9zYXNfYmFzZS5jCTIwMTEtMTAtMDggMTU6Mjg6NTEuNjk4MzMwODYxIC0wNzAwCisrKyBz
Y3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzX2Jhc2Uu
YwkyMDExLTEwLTA4IDE1OjE4OjI5LjM1NDI2NzU0NyAtMDcwMApAQCAtMjUzNiw3ICsyNTM2LDcg
QEAKIAkJCQkJCWluc3RhbmNlLT5yZWdfc2V0KQogCQkJCQkJKSA9PSAwKSB7CiAJCS8qIEhhcmR3
YXJlIG1heSBub3Qgc2V0IG91dGJvdW5kX2ludHJfc3RhdHVzIGluIE1TSS1YIG1vZGUgKi8KLQkJ
aWYgKCFpbnN0YW5jZS0+bXNpX2ZsYWcpCisJCWlmICghaW5zdGFuY2UtPm1zaXhfdmVjdG9ycykK
IAkJCXJldHVybiBJUlFfTk9ORTsKIAl9CiAKQEAgLTI1OTQsMTYgKzI1OTQsMTQgQEAKICAqLwog
c3RhdGljIGlycXJldHVybl90IG1lZ2FzYXNfaXNyKGludCBpcnEsIHZvaWQgKmRldnApCiB7Ci0J
c3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlOworCXN0cnVjdCBtZWdhc2FzX2lycV9j
b250ZXh0ICppcnFfY29udGV4dCA9IGRldnA7CisJc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmlu
c3RhbmNlID0gaXJxX2NvbnRleHQtPmluc3RhbmNlOwogCXVuc2lnbmVkIGxvbmcgZmxhZ3M7CiAJ
aXJxcmV0dXJuX3QJcmM7CiAKLQlpZiAoYXRvbWljX3JlYWQoCi0JCSYoKChzdHJ1Y3QgbWVnYXNh
c19pbnN0YW5jZSAqKWRldnApLT5md19yZXNldF9ub19wY2lfYWNjZXNzKSkpCisJaWYgKGF0b21p
Y19yZWFkKCZpbnN0YW5jZS0+ZndfcmVzZXRfbm9fcGNpX2FjY2VzcykpCiAJCXJldHVybiBJUlFf
SEFORExFRDsKIAotCWluc3RhbmNlID0gKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICopZGV2cDsK
LQogCXNwaW5fbG9ja19pcnFzYXZlKCZpbnN0YW5jZS0+aGJhX2xvY2ssIGZsYWdzKTsKIAlyYyA9
ICBtZWdhc2FzX2RlcGxldGVfcmVwbHlfcXVldWUoaW5zdGFuY2UsIERJRF9PSyk7CiAJc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgmaW5zdGFuY2UtPmhiYV9sb2NrLCBmbGFncyk7CkBAIC0zNDg4LDYg
KzM0ODYsNyBAQAogCXN0cnVjdCBtZWdhc2FzX3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdfc2V0
OwogCXN0cnVjdCBtZWdhc2FzX2N0cmxfaW5mbyAqY3RybF9pbmZvOwogCXVuc2lnbmVkIGxvbmcg
YmFyX2xpc3Q7CisJaW50IGk7CiAKIAkvKiBGaW5kIGZpcnN0IG1lbW9yeSBiYXIgKi8KIAliYXJf
bGlzdCA9IHBjaV9zZWxlY3RfYmFycyhpbnN0YW5jZS0+cGRldiwgSU9SRVNPVVJDRV9NRU0pOwpA
QCAtMzU0MSw5ICszNTQwLDMzIEBACiAJLyogQ2hlY2sgaWYgTVNJLVggaXMgc3VwcG9ydGVkIHdo
aWxlIGluIHJlYWR5IHN0YXRlICovCiAJbXNpeF9lbmFibGUgPSAoaW5zdGFuY2UtPmluc3RhbmNl
dC0+cmVhZF9md19zdGF0dXNfcmVnKHJlZ19zZXQpICYKIAkJICAgICAgIDB4NDAwMDAwMCkgPj4g
MHgxYTsKLQlpZiAobXNpeF9lbmFibGUgJiYgIW1zaXhfZGlzYWJsZSAmJgotCSAgICAhcGNpX2Vu
YWJsZV9tc2l4KGluc3RhbmNlLT5wZGV2LCAmaW5zdGFuY2UtPm1zaXhlbnRyeSwgMSkpCi0JCWlu
c3RhbmNlLT5tc2lfZmxhZyA9IDE7CisJaWYgKG1zaXhfZW5hYmxlICYmICFtc2l4X2Rpc2FibGUp
IHsKKwkJLyogQ2hlY2sgbWF4IE1TSS1YIHZlY3RvcnMgKi8KKwkJaWYgKChpbnN0YW5jZS0+cGRl
di0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTikgfHwKKwkJICAgIChpbnN0YW5j
ZS0+cGRldi0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfTFNJX0lOVkFERVIpKSB7CisJCQlpbnN0
YW5jZS0+bXNpeF92ZWN0b3JzID0gKHJlYWRsKCZpbnN0YW5jZS0+cmVnX3NldC0+CisJCQkJCQkJ
b3V0Ym91bmRfc2NyYXRjaF9wYWRfMgorCQkJCQkJCSAgKSAmIDB4MUYpICsgMTsKKwkJfSBlbHNl
CisJCQlpbnN0YW5jZS0+bXNpeF92ZWN0b3JzID0gMTsKKwkJLyogRG9uJ3QgYm90aGVyIGFsbG9j
YXRpbmcgbW9yZSBNU0ktWCB2ZWN0b3JzIHRoYW4gY3B1cyAqLworCQlpbnN0YW5jZS0+bXNpeF92
ZWN0b3JzID0gbWluKGluc3RhbmNlLT5tc2l4X3ZlY3RvcnMsCisJCQkJCSAgICAgKHVuc2lnbmVk
IGludCludW1fb25saW5lX2NwdXMoKSk7CisJCWZvciAoaSA9IDA7IGkgPCBpbnN0YW5jZS0+bXNp
eF92ZWN0b3JzOyBpKyspCisJCQlpbnN0YW5jZS0+bXNpeGVudHJ5W2ldLmVudHJ5ID0gaTsKKwkJ
aSA9IHBjaV9lbmFibGVfbXNpeChpbnN0YW5jZS0+cGRldiwgaW5zdGFuY2UtPm1zaXhlbnRyeSwK
KwkJCQkgICAgaW5zdGFuY2UtPm1zaXhfdmVjdG9ycyk7CisJCWlmIChpID49IDApIHsKKwkJCWlm
IChpKSB7CisJCQkJaWYgKCFwY2lfZW5hYmxlX21zaXgoaW5zdGFuY2UtPnBkZXYsCisJCQkJCQkg
ICAgIGluc3RhbmNlLT5tc2l4ZW50cnksIGkpKQorCQkJCQlpbnN0YW5jZS0+bXNpeF92ZWN0b3Jz
ID0gaTsKKwkJCQllbHNlCisJCQkJCWluc3RhbmNlLT5tc2l4X3ZlY3RvcnMgPSAwOworCQkJfQor
CQl9IGVsc2UKKwkJCWluc3RhbmNlLT5tc2l4X3ZlY3RvcnMgPSAwOworCX0KIAogCS8qIEdldCBv
cGVyYXRpb25hbCBwYXJhbXMsIHNnZSBmbGFncywgc2VuZCBpbml0IGNtZCB0byBjb250cm9sbGVy
ICovCiAJaWYgKGluc3RhbmNlLT5pbnN0YW5jZXQtPmluaXRfYWRhcHRlcihpbnN0YW5jZSkpCkBA
IC0zOTU4LDcgKzM5ODEsNyBAQAogc3RhdGljIGludCBfX2RldmluaXQKIG1lZ2FzYXNfcHJvYmVf
b25lKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1Y3QgcGNpX2RldmljZV9pZCAqaWQp
CiB7Ci0JaW50IHJ2YWwsIHBvczsKKwlpbnQgcnZhbCwgcG9zLCBpLCBqOwogCXN0cnVjdCBTY3Np
X0hvc3QgKmhvc3Q7CiAJc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmluc3RhbmNlOwogCXUxNiBj
b250cm9sID0gMDsKQEAgLTQxMjYsMTEgKzQxNDksMzIgQEAKIAkvKgogCSAqIFJlZ2lzdGVyIElS
UQogCSAqLwotCWlmIChyZXF1ZXN0X2lycShpbnN0YW5jZS0+bXNpX2ZsYWcgPyBpbnN0YW5jZS0+
bXNpeGVudHJ5LnZlY3RvciA6Ci0JCQlwZGV2LT5pcnEsIGluc3RhbmNlLT5pbnN0YW5jZXQtPnNl
cnZpY2VfaXNyLAotCQkJSVJRRl9TSEFSRUQsICJtZWdhc2FzIiwgaW5zdGFuY2UpKSB7Ci0JCXBy
aW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBGYWlsZWQgdG8gcmVnaXN0ZXIgSVJRXG4iKTsKLQkJ
Z290byBmYWlsX2lycTsKKwlpZiAoaW5zdGFuY2UtPm1zaXhfdmVjdG9ycykgeworCQlmb3IgKGkg
PSAwIDsgaSA8IGluc3RhbmNlLT5tc2l4X3ZlY3RvcnM7IGkrKykgeworCQkJaW5zdGFuY2UtPmly
cV9jb250ZXh0W2ldLmluc3RhbmNlID0gaW5zdGFuY2U7CisJCQlpbnN0YW5jZS0+aXJxX2NvbnRl
eHRbaV0uTVNJeEluZGV4ID0gaTsKKwkJCWlmIChyZXF1ZXN0X2lycShpbnN0YW5jZS0+bXNpeGVu
dHJ5W2ldLnZlY3RvciwKKwkJCQkJaW5zdGFuY2UtPmluc3RhbmNldC0+c2VydmljZV9pc3IsIDAs
CisJCQkJCSJtZWdhc2FzIiwKKwkJCQkJJmluc3RhbmNlLT5pcnFfY29udGV4dFtpXSkpIHsKKwkJ
CQlwcmludGsoS0VSTl9ERUJVRyAibWVnYXNhczogRmFpbGVkIHRvICIKKwkJCQkgICAgICAgInJl
Z2lzdGVyIElSUSBmb3IgdmVjdG9yICVkLlxuIiwgaSk7CisJCQkJZm9yIChqID0gMCA7IGogPCBp
IDsgaisrKQorCQkJCQlmcmVlX2lycSgKKwkJCQkJCWluc3RhbmNlLT5tc2l4ZW50cnlbal0udmVj
dG9yLAorCQkJCQkJJmluc3RhbmNlLT5pcnFfY29udGV4dFtqXSk7CisJCQkJZ290byBmYWlsX2ly
cTsKKwkJCX0KKwkJfQorCX0gZWxzZSB7CisJCWluc3RhbmNlLT5pcnFfY29udGV4dFswXS5pbnN0
YW5jZSA9IGluc3RhbmNlOworCQlpbnN0YW5jZS0+aXJxX2NvbnRleHRbMF0uTVNJeEluZGV4ID0g
MDsKKwkJaWYgKHJlcXVlc3RfaXJxKHBkZXYtPmlycSwgaW5zdGFuY2UtPmluc3RhbmNldC0+c2Vy
dmljZV9pc3IsCisJCQkJSVJRRl9TSEFSRUQsICJtZWdhc2FzIiwKKwkJCQkmaW5zdGFuY2UtPmly
cV9jb250ZXh0WzBdKSkgeworCQkJcHJpbnRrKEtFUk5fREVCVUcgIm1lZ2FzYXM6IEZhaWxlZCB0
byByZWdpc3RlciBJUlFcbiIpOworCQkJZ290byBmYWlsX2lycTsKKwkJfQogCX0KIAogCWluc3Rh
bmNlLT5pbnN0YW5jZXQtPmVuYWJsZV9pbnRyKGluc3RhbmNlLT5yZWdfc2V0KTsKQEAgLTQxNzQs
OCArNDIxOCwxMiBAQAogCiAJcGNpX3NldF9kcnZkYXRhKHBkZXYsIE5VTEwpOwogCWluc3RhbmNl
LT5pbnN0YW5jZXQtPmRpc2FibGVfaW50cihpbnN0YW5jZS0+cmVnX3NldCk7Ci0JZnJlZV9pcnEo
aW5zdGFuY2UtPm1zaV9mbGFnID8gaW5zdGFuY2UtPm1zaXhlbnRyeS52ZWN0b3IgOgotCQkgaW5z
dGFuY2UtPnBkZXYtPmlycSwgaW5zdGFuY2UpOworCWlmIChpbnN0YW5jZS0+bXNpeF92ZWN0b3Jz
KQorCQlmb3IgKGkgPSAwIDsgaSA8IGluc3RhbmNlLT5tc2l4X3ZlY3RvcnM7IGkrKykKKwkJCWZy
ZWVfaXJxKGluc3RhbmNlLT5tc2l4ZW50cnlbaV0udmVjdG9yLAorCQkJCSAmaW5zdGFuY2UtPmly
cV9jb250ZXh0W2ldKTsKKwllbHNlCisJCWZyZWVfaXJxKGluc3RhbmNlLT5wZGV2LT5pcnEsICZp
bnN0YW5jZS0+aXJxX2NvbnRleHRbMF0pOwogZmFpbF9pcnE6CiAJaWYgKChpbnN0YW5jZS0+cGRl
di0+ZGV2aWNlID09IFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTikgfHwKIAkgICAgKGluc3RhbmNl
LT5wZGV2LT5kZXZpY2UgPT0gUENJX0RFVklDRV9JRF9MU0lfSU5WQURFUikpCkBAIC00MTgzLDcg
KzQyMzEsNyBAQAogCWVsc2UKIAkJbWVnYXNhc19yZWxlYXNlX21maShpbnN0YW5jZSk7CiAgICAg
ICBmYWlsX2luaXRfbWZpOgotCWlmIChpbnN0YW5jZS0+bXNpX2ZsYWcpCisJaWYgKGluc3RhbmNl
LT5tc2l4X3ZlY3RvcnMpCiAJCXBjaV9kaXNhYmxlX21zaXgoaW5zdGFuY2UtPnBkZXYpOwogICAg
ICAgZmFpbF9hbGxvY19kbWFfYnVmOgogCWlmIChpbnN0YW5jZS0+ZXZ0X2RldGFpbCkKQEAgLTQy
OTksNiArNDM0Nyw3IEBACiB7CiAJc3RydWN0IFNjc2lfSG9zdCAqaG9zdDsKIAlzdHJ1Y3QgbWVn
YXNhc19pbnN0YW5jZSAqaW5zdGFuY2U7CisJaW50IGk7CiAKIAlpbnN0YW5jZSA9IHBjaV9nZXRf
ZHJ2ZGF0YShwZGV2KTsKIAlob3N0ID0gaW5zdGFuY2UtPmhvc3Q7CkBAIC00MzIyLDkgKzQzNzEs
MTQgQEAKIAogCXBjaV9zZXRfZHJ2ZGF0YShpbnN0YW5jZS0+cGRldiwgaW5zdGFuY2UpOwogCWlu
c3RhbmNlLT5pbnN0YW5jZXQtPmRpc2FibGVfaW50cihpbnN0YW5jZS0+cmVnX3NldCk7Ci0JZnJl
ZV9pcnEoaW5zdGFuY2UtPm1zaV9mbGFnID8gaW5zdGFuY2UtPm1zaXhlbnRyeS52ZWN0b3IgOgot
CQkgaW5zdGFuY2UtPnBkZXYtPmlycSwgaW5zdGFuY2UpOwotCWlmIChpbnN0YW5jZS0+bXNpX2Zs
YWcpCisKKwlpZiAoaW5zdGFuY2UtPm1zaXhfdmVjdG9ycykKKwkJZm9yIChpID0gMCA7IGkgPCBp
bnN0YW5jZS0+bXNpeF92ZWN0b3JzOyBpKyspCisJCQlmcmVlX2lycShpbnN0YW5jZS0+bXNpeGVu
dHJ5W2ldLnZlY3RvciwKKwkJCQkgJmluc3RhbmNlLT5pcnFfY29udGV4dFtpXSk7CisJZWxzZQor
CQlmcmVlX2lycShpbnN0YW5jZS0+cGRldi0+aXJxLCAmaW5zdGFuY2UtPmlycV9jb250ZXh0WzBd
KTsKKwlpZiAoaW5zdGFuY2UtPm1zaXhfdmVjdG9ycykKIAkJcGNpX2Rpc2FibGVfbXNpeChpbnN0
YW5jZS0+cGRldik7CiAKIAlwY2lfc2F2ZV9zdGF0ZShwZGV2KTsKQEAgLTQzNDIsNyArNDM5Niw3
IEBACiBzdGF0aWMgaW50CiBtZWdhc2FzX3Jlc3VtZShzdHJ1Y3QgcGNpX2RldiAqcGRldikKIHsK
LQlpbnQgcnZhbDsKKwlpbnQgcnZhbCwgaSwgajsKIAlzdHJ1Y3QgU2NzaV9Ib3N0ICpob3N0Owog
CXN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZTsKIApAQCAtNDM4MCw4ICs0NDM0LDkg
QEAKIAkJZ290byBmYWlsX3JlYWR5X3N0YXRlOwogCiAJLyogTm93IHJlLWVuYWJsZSBNU0ktWCAq
LwotCWlmIChpbnN0YW5jZS0+bXNpX2ZsYWcpCi0JCXBjaV9lbmFibGVfbXNpeChpbnN0YW5jZS0+
cGRldiwgJmluc3RhbmNlLT5tc2l4ZW50cnksIDEpOworCWlmIChpbnN0YW5jZS0+bXNpeF92ZWN0
b3JzKQorCQlwY2lfZW5hYmxlX21zaXgoaW5zdGFuY2UtPnBkZXYsIGluc3RhbmNlLT5tc2l4ZW50
cnksCisJCQkJaW5zdGFuY2UtPm1zaXhfdmVjdG9ycyk7CiAKIAlzd2l0Y2ggKGluc3RhbmNlLT5w
ZGV2LT5kZXZpY2UpIHsKIAljYXNlIFBDSV9ERVZJQ0VfSURfTFNJX0ZVU0lPTjoKQEAgLTQ0MTEs
MTEgKzQ0NjYsMzIgQEAKIAkvKgogCSAqIFJlZ2lzdGVyIElSUQogCSAqLwotCWlmIChyZXF1ZXN0
X2lycShpbnN0YW5jZS0+bXNpX2ZsYWcgPyBpbnN0YW5jZS0+bXNpeGVudHJ5LnZlY3RvciA6Ci0J
CQlwZGV2LT5pcnEsIGluc3RhbmNlLT5pbnN0YW5jZXQtPnNlcnZpY2VfaXNyLAotCQkJSVJRRl9T
SEFSRUQsICJtZWdhc2FzIiwgaW5zdGFuY2UpKSB7Ci0JCXByaW50ayhLRVJOX0VSUiAibWVnYXNh
czogRmFpbGVkIHRvIHJlZ2lzdGVyIElSUVxuIik7Ci0JCWdvdG8gZmFpbF9pcnE7CisJaWYgKGlu
c3RhbmNlLT5tc2l4X3ZlY3RvcnMpIHsKKwkJZm9yIChpID0gMCA7IGkgPCBpbnN0YW5jZS0+bXNp
eF92ZWN0b3JzOyBpKyspIHsKKwkJCWluc3RhbmNlLT5pcnFfY29udGV4dFtpXS5pbnN0YW5jZSA9
IGluc3RhbmNlOworCQkJaW5zdGFuY2UtPmlycV9jb250ZXh0W2ldLk1TSXhJbmRleCA9IGk7CisJ
CQlpZiAocmVxdWVzdF9pcnEoaW5zdGFuY2UtPm1zaXhlbnRyeVtpXS52ZWN0b3IsCisJCQkJCWlu
c3RhbmNlLT5pbnN0YW5jZXQtPnNlcnZpY2VfaXNyLCAwLAorCQkJCQkibWVnYXNhcyIsCisJCQkJ
CSZpbnN0YW5jZS0+aXJxX2NvbnRleHRbaV0pKSB7CisJCQkJcHJpbnRrKEtFUk5fREVCVUcgIm1l
Z2FzYXM6IEZhaWxlZCB0byAiCisJCQkJICAgICAgICJyZWdpc3RlciBJUlEgZm9yIHZlY3RvciAl
ZC5cbiIsIGkpOworCQkJCWZvciAoaiA9IDAgOyBqIDwgaSA7IGorKykKKwkJCQkJZnJlZV9pcnEo
CisJCQkJCQlpbnN0YW5jZS0+bXNpeGVudHJ5W2pdLnZlY3RvciwKKwkJCQkJCSZpbnN0YW5jZS0+
aXJxX2NvbnRleHRbal0pOworCQkJCWdvdG8gZmFpbF9pcnE7CisJCQl9CisJCX0KKwl9IGVsc2Ug
eworCQlpbnN0YW5jZS0+aXJxX2NvbnRleHRbMF0uaW5zdGFuY2UgPSBpbnN0YW5jZTsKKwkJaW5z
dGFuY2UtPmlycV9jb250ZXh0WzBdLk1TSXhJbmRleCA9IDA7CisJCWlmIChyZXF1ZXN0X2lycShw
ZGV2LT5pcnEsIGluc3RhbmNlLT5pbnN0YW5jZXQtPnNlcnZpY2VfaXNyLAorCQkJCUlSUUZfU0hB
UkVELCAibWVnYXNhcyIsCisJCQkJJmluc3RhbmNlLT5pcnFfY29udGV4dFswXSkpIHsKKwkJCXBy
aW50ayhLRVJOX0RFQlVHICJtZWdhc2FzOiBGYWlsZWQgdG8gcmVnaXN0ZXIgSVJRXG4iKTsKKwkJ
CWdvdG8gZmFpbF9pcnE7CisJCX0KIAl9CiAKIAlpbnN0YW5jZS0+aW5zdGFuY2V0LT5lbmFibGVf
aW50cihpbnN0YW5jZS0+cmVnX3NldCk7CkBAIC00NTEyLDkgKzQ1ODgsMTMgQEAKIAogCWluc3Rh
bmNlLT5pbnN0YW5jZXQtPmRpc2FibGVfaW50cihpbnN0YW5jZS0+cmVnX3NldCk7CiAKLQlmcmVl
X2lycShpbnN0YW5jZS0+bXNpX2ZsYWcgPyBpbnN0YW5jZS0+bXNpeGVudHJ5LnZlY3RvciA6Ci0J
CSBpbnN0YW5jZS0+cGRldi0+aXJxLCBpbnN0YW5jZSk7Ci0JaWYgKGluc3RhbmNlLT5tc2lfZmxh
ZykKKwlpZiAoaW5zdGFuY2UtPm1zaXhfdmVjdG9ycykKKwkJZm9yIChpID0gMCA7IGkgPCBpbnN0
YW5jZS0+bXNpeF92ZWN0b3JzOyBpKyspCisJCQlmcmVlX2lycShpbnN0YW5jZS0+bXNpeGVudHJ5
W2ldLnZlY3RvciwKKwkJCQkgJmluc3RhbmNlLT5pcnFfY29udGV4dFtpXSk7CisJZWxzZQorCQlm
cmVlX2lycShpbnN0YW5jZS0+cGRldi0+aXJxLCAmaW5zdGFuY2UtPmlycV9jb250ZXh0WzBdKTsK
KwlpZiAoaW5zdGFuY2UtPm1zaXhfdmVjdG9ycykKIAkJcGNpX2Rpc2FibGVfbXNpeChpbnN0YW5j
ZS0+cGRldik7CiAKIAlzd2l0Y2ggKGluc3RhbmNlLT5wZGV2LT5kZXZpY2UpIHsKQEAgLTQ1NjAs
MTQgKzQ2NDAsMjAgQEAKICAqLwogc3RhdGljIHZvaWQgbWVnYXNhc19zaHV0ZG93bihzdHJ1Y3Qg
cGNpX2RldiAqcGRldikKIHsKKwlpbnQgaTsKIAlzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5z
dGFuY2UgPSBwY2lfZ2V0X2RydmRhdGEocGRldik7CisKIAlpbnN0YW5jZS0+dW5sb2FkID0gMTsK
IAltZWdhc2FzX2ZsdXNoX2NhY2hlKGluc3RhbmNlKTsKIAltZWdhc2FzX3NodXRkb3duX2NvbnRy
b2xsZXIoaW5zdGFuY2UsIE1SX0RDTURfQ1RSTF9TSFVURE9XTik7CiAJaW5zdGFuY2UtPmluc3Rh
bmNldC0+ZGlzYWJsZV9pbnRyKGluc3RhbmNlLT5yZWdfc2V0KTsKLQlmcmVlX2lycShpbnN0YW5j
ZS0+bXNpX2ZsYWcgPyBpbnN0YW5jZS0+bXNpeGVudHJ5LnZlY3RvciA6Ci0JCSBpbnN0YW5jZS0+
cGRldi0+aXJxLCBpbnN0YW5jZSk7Ci0JaWYgKGluc3RhbmNlLT5tc2lfZmxhZykKKwlpZiAoaW5z
dGFuY2UtPm1zaXhfdmVjdG9ycykKKwkJZm9yIChpID0gMCA7IGkgPCBpbnN0YW5jZS0+bXNpeF92
ZWN0b3JzOyBpKyspCisJCQlmcmVlX2lycShpbnN0YW5jZS0+bXNpeGVudHJ5W2ldLnZlY3RvciwK
KwkJCQkgJmluc3RhbmNlLT5pcnFfY29udGV4dFtpXSk7CisJZWxzZQorCQlmcmVlX2lycShpbnN0
YW5jZS0+cGRldi0+aXJxLCAmaW5zdGFuY2UtPmlycV9jb250ZXh0WzBdKTsKKwlpZiAoaW5zdGFu
Y2UtPm1zaXhfdmVjdG9ycykKIAkJcGNpX2Rpc2FibGVfbXNpeChpbnN0YW5jZS0+cGRldik7CiB9
CiAKZGlmZiAtTmF1ciBzY3NpLW1pc2MtMi42L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXNfZnVzaW9uLmMgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21l
Z2FyYWlkX3Nhc19mdXNpb24uYwotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJh
aWQvbWVnYXJhaWRfc2FzX2Z1c2lvbi5jCTIwMTEtMTAtMDggMTU6Mjg6NTEuNjk5MzMwODE3IC0w
NzAwCisrKyBzY3NpLW1pc2MtMi42Lm5ldy9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJhaWRf
c2FzX2Z1c2lvbi5jCTIwMTEtMTAtMDggMTU6Mjg6MzEuMjEzMzMzMDU4IC0wNzAwCkBAIC0zODUs
NyArMzg1LDcgQEAKIGludAogbWVnYXNhc19hbGxvY19jbWRzX2Z1c2lvbihzdHJ1Y3QgbWVnYXNh
c19pbnN0YW5jZSAqaW5zdGFuY2UpCiB7Ci0JaW50IGksIGo7CisJaW50IGksIGosIGNvdW50Owog
CXUzMiBtYXhfY21kLCBpb19mcmFtZXNfc3o7CiAJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNp
b247CiAJc3RydWN0IG1lZ2FzYXNfY21kX2Z1c2lvbiAqY21kOwpAQCAtNDA5LDkgKzQwOSwxMCBA
QAogCQlnb3RvIGZhaWxfcmVxX2Rlc2M7CiAJfQogCisJY291bnQgPSBpbnN0YW5jZS0+bXNpeF92
ZWN0b3JzID4gMCA/IGluc3RhbmNlLT5tc2l4X3ZlY3RvcnMgOiAxOwogCWZ1c2lvbi0+cmVwbHlf
ZnJhbWVzX2Rlc2NfcG9vbCA9CiAJCXBjaV9wb29sX2NyZWF0ZSgicmVwbHlfZnJhbWVzIHBvb2wi
LCBpbnN0YW5jZS0+cGRldiwKLQkJCQlmdXNpb24tPnJlcGx5X2FsbG9jX3N6LCAxNiwgMCk7CisJ
CQkJZnVzaW9uLT5yZXBseV9hbGxvY19zeiAqIGNvdW50LCAxNiwgMCk7CiAKIAlpZiAoIWZ1c2lv
bi0+cmVwbHlfZnJhbWVzX2Rlc2NfcG9vbCkgewogCQlwcmludGsoS0VSTl9FUlIgIm1lZ2FzYXM7
IENvdWxkIG5vdCBhbGxvY2F0ZSBtZW1vcnkgZm9yICIKQEAgLTQzMCw3ICs0MzEsNyBAQAogCX0K
IAogCXJlcGx5X2Rlc2MgPSBmdXNpb24tPnJlcGx5X2ZyYW1lc19kZXNjOwotCWZvciAoaSA9IDA7
IGkgPCBmdXNpb24tPnJlcGx5X3FfZGVwdGg7IGkrKywgcmVwbHlfZGVzYysrKQorCWZvciAoaSA9
IDA7IGkgPCBmdXNpb24tPnJlcGx5X3FfZGVwdGggKiBjb3VudDsgaSsrLCByZXBseV9kZXNjKysp
CiAJCXJlcGx5X2Rlc2MtPldvcmRzID0gVUxMT05HX01BWDsKIAogCWlvX2ZyYW1lc19zeiA9IGZ1
c2lvbi0+aW9fZnJhbWVzX2FsbG9jX3N6OwpAQCAtNjMzLDcgKzYzNCw5IEBACiAJCWZ1c2lvbi0+
cmVwbHlfZnJhbWVzX2Rlc2NfcGh5czsKIAlJT0NJbml0TWVzc2FnZS0+U3lzdGVtUmVxdWVzdEZy
YW1lQmFzZUFkZHJlc3MgPQogCQlmdXNpb24tPmlvX3JlcXVlc3RfZnJhbWVzX3BoeXM7Ci0KKwkv
KiBTZXQgdG8gMCBmb3Igbm9uZSBvciAxIE1TSS1YIHZlY3RvcnMgKi8KKwlJT0NJbml0TWVzc2Fn
ZS0+SG9zdE1TSXhWZWN0b3JzID0gKGluc3RhbmNlLT5tc2l4X3ZlY3RvcnMgPiAwID8KKwkJCQkJ
ICAgaW5zdGFuY2UtPm1zaXhfdmVjdG9ycyA6IDApOwogCWluaXRfZnJhbWUgPSAoc3RydWN0IG1l
Z2FzYXNfaW5pdF9mcmFtZSAqKWNtZC0+ZnJhbWU7CiAJbWVtc2V0KGluaXRfZnJhbWUsIDAsIE1F
R0FNRklfRlJBTUVfU0laRSk7CiAKQEAgLTg3Nyw3ICs4ODAsNyBAQAogCXN0cnVjdCBtZWdhc2Fz
X3JlZ2lzdGVyX3NldCBfX2lvbWVtICpyZWdfc2V0OwogCXN0cnVjdCBmdXNpb25fY29udGV4dCAq
ZnVzaW9uOwogCXUzMiBtYXhfY21kOwotCWludCBpID0gMDsKKwlpbnQgaSA9IDAsIGNvdW50Owog
CiAJZnVzaW9uID0gaW5zdGFuY2UtPmN0cmxfY29udGV4dDsKIApAQCAtOTI5LDcgKzkzMiw5IEBA
CiAJCShNRUdBX01QSTJfUkFJRF9ERUZBVUxUX0lPX0ZSQU1FX1NJWkUgLQogCQkgc2l6ZW9mKHVu
aW9uIE1QSTJfU0dFX0lPX1VOSU9OKSkvMTY7CiAKLQlmdXNpb24tPmxhc3RfcmVwbHlfaWR4ID0g
MDsKKwljb3VudCA9IGluc3RhbmNlLT5tc2l4X3ZlY3RvcnMgPiAwID8gaW5zdGFuY2UtPm1zaXhf
dmVjdG9ycyA6IDE7CisJZm9yIChpID0gMCA7IGkgPCBjb3VudDsgaSsrKQorCQlmdXNpb24tPmxh
c3RfcmVwbHlfaWR4W2ldID0gMDsKIAogCS8qCiAJICogQWxsb2NhdGUgbWVtb3J5IGZvciBkZXNj
cmlwdG9ycwpAQCAtMTQyMSw2ICsxNDI2LDEyIEBACiAJCQlmcF9wb3NzaWJsZSA9IGlvX2luZm8u
ZnBPa0ZvcklvOwogCX0KIAorCS8qIFVzZSBzbXBfcHJvY2Vzc29yX2lkKCkgZm9yIG5vdyB1bnRp
bCBjbWQtPnJlcXVlc3QtPmNwdSBpcyBDUFUKKwkgICBpZCBieSBkZWZhdWx0LCBub3QgQ1BVIGdy
b3VwIGlkLCBvdGhlcndpc2UgYWxsIE1TSS1YIHF1ZXVlcyB3b24ndAorCSAgIGJlIHV0aWxpemVk
ICovCisJY21kLT5yZXF1ZXN0X2Rlc2MtPlNDU0lJTy5NU0l4SW5kZXggPSBpbnN0YW5jZS0+bXNp
eF92ZWN0b3JzID8KKwkJc21wX3Byb2Nlc3Nvcl9pZCgpICUgaW5zdGFuY2UtPm1zaXhfdmVjdG9y
cyA6IDA7CisKIAlpZiAoZnBfcG9zc2libGUpIHsKIAkJbWVnYXNhc19zZXRfcGRfbGJhKGlvX3Jl
cXVlc3QsIHNjcC0+Y21kX2xlbiwgJmlvX2luZm8sIHNjcCwKIAkJCQkgICBsb2NhbF9tYXBfcHRy
LCBzdGFydF9sYmFfbG8pOwpAQCAtMTY5MSw3ICsxNzAyLDcgQEAKICAqIENvbXBsZXRlcyBhbGwg
Y29tbWFuZHMgdGhhdCBpcyBpbiByZXBseSBkZXNjcmlwdG9yIHF1ZXVlCiAgKi8KIGludAotY29t
cGxldGVfY21kX2Z1c2lvbihzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UpCitjb21w
bGV0ZV9jbWRfZnVzaW9uKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSwgdTMyIE1T
SXhJbmRleCkKIHsKIAl1bmlvbiBNUEkyX1JFUExZX0RFU0NSSVBUT1JTX1VOSU9OICpkZXNjOwog
CXN0cnVjdCBNUEkyX1NDU0lfSU9fU1VDQ0VTU19SRVBMWV9ERVNDUklQVE9SICpyZXBseV9kZXNj
OwpAQCAtMTcxMSw3ICsxNzIyLDkgQEAKIAkJcmV0dXJuIElSUV9IQU5ETEVEOwogCiAJZGVzYyA9
IGZ1c2lvbi0+cmVwbHlfZnJhbWVzX2Rlc2M7Ci0JZGVzYyArPSBmdXNpb24tPmxhc3RfcmVwbHlf
aWR4OworCWRlc2MgKz0gKChNU0l4SW5kZXggKiBmdXNpb24tPnJlcGx5X2FsbG9jX3N6KS8KKwkJ
IHNpemVvZih1bmlvbiBNUEkyX1JFUExZX0RFU0NSSVBUT1JTX1VOSU9OKSkgKworCQlmdXNpb24t
Pmxhc3RfcmVwbHlfaWR4W01TSXhJbmRleF07CiAKIAlyZXBseV9kZXNjID0gKHN0cnVjdCBNUEky
X1NDU0lfSU9fU1VDQ0VTU19SRVBMWV9ERVNDUklQVE9SICopZGVzYzsKIApAQCAtMTc4NCwxNiAr
MTc5NywxOSBAQAogCQkJYnJlYWs7CiAJCX0KIAotCQlmdXNpb24tPmxhc3RfcmVwbHlfaWR4Kys7
Ci0JCWlmIChmdXNpb24tPmxhc3RfcmVwbHlfaWR4ID49IGZ1c2lvbi0+cmVwbHlfcV9kZXB0aCkK
LQkJCWZ1c2lvbi0+bGFzdF9yZXBseV9pZHggPSAwOworCQlmdXNpb24tPmxhc3RfcmVwbHlfaWR4
W01TSXhJbmRleF0rKzsKKwkJaWYgKGZ1c2lvbi0+bGFzdF9yZXBseV9pZHhbTVNJeEluZGV4XSA+
PQorCQkgICAgZnVzaW9uLT5yZXBseV9xX2RlcHRoKQorCQkJZnVzaW9uLT5sYXN0X3JlcGx5X2lk
eFtNU0l4SW5kZXhdID0gMDsKIAogCQlkZXNjLT5Xb3JkcyA9IFVMTE9OR19NQVg7CiAJCW51bV9j
b21wbGV0ZWQrKzsKIAogCQkvKiBHZXQgdGhlIG5leHQgcmVwbHkgZGVzY3JpcHRvciAqLwotCQlp
ZiAoIWZ1c2lvbi0+bGFzdF9yZXBseV9pZHgpCi0JCQlkZXNjID0gZnVzaW9uLT5yZXBseV9mcmFt
ZXNfZGVzYzsKKwkJaWYgKCFmdXNpb24tPmxhc3RfcmVwbHlfaWR4W01TSXhJbmRleF0pCisJCQlk
ZXNjID0gZnVzaW9uLT5yZXBseV9mcmFtZXNfZGVzYyArCisJCQkJKChNU0l4SW5kZXggKiBmdXNp
b24tPnJlcGx5X2FsbG9jX3N6KS8KKwkJCQkgc2l6ZW9mKHVuaW9uIE1QSTJfUkVQTFlfREVTQ1JJ
UFRPUlNfVU5JT04pKTsKIAkJZWxzZQogCQkJZGVzYysrOwogCkBAIC0xODEzLDcgKzE4MjksNyBA
QAogCQlyZXR1cm4gSVJRX05PTkU7CiAKIAl3bWIoKTsKLQl3cml0ZWwoZnVzaW9uLT5sYXN0X3Jl
cGx5X2lkeCwKKwl3cml0ZWwoKE1TSXhJbmRleCA8PCAyNCkgfCBmdXNpb24tPmxhc3RfcmVwbHlf
aWR4W01TSXhJbmRleF0sCiAJICAgICAgICZpbnN0YW5jZS0+cmVnX3NldC0+cmVwbHlfcG9zdF9o
b3N0X2luZGV4KTsKIAltZWdhc2FzX2NoZWNrX2FuZF9yZXN0b3JlX3F1ZXVlX2RlcHRoKGluc3Rh
bmNlKTsKIAlyZXR1cm4gSVJRX0hBTkRMRUQ7CkBAIC0xODMxLDYgKzE4NDcsOSBAQAogCXN0cnVj
dCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSA9CiAJCShzdHJ1Y3QgbWVnYXNhc19pbnN0YW5j
ZSAqKWluc3RhbmNlX2FkZHI7CiAJdW5zaWduZWQgbG9uZyBmbGFnczsKKwl1MzIgY291bnQsIE1T
SXhJbmRleDsKKworCWNvdW50ID0gaW5zdGFuY2UtPm1zaXhfdmVjdG9ycyA+IDAgPyBpbnN0YW5j
ZS0+bXNpeF92ZWN0b3JzIDogMTsKIAogCS8qIElmIHdlIGhhdmUgYWxyZWFkeSBkZWNsYXJlZCBh
ZGFwdGVyIGRlYWQsIGRvbm90IGNvbXBsZXRlIGNtZHMgKi8KIAlzcGluX2xvY2tfaXJxc2F2ZSgm
aW5zdGFuY2UtPmhiYV9sb2NrLCBmbGFncyk7CkBAIC0xODQxLDcgKzE4NjAsOCBAQAogCXNwaW5f
dW5sb2NrX2lycXJlc3RvcmUoJmluc3RhbmNlLT5oYmFfbG9jaywgZmxhZ3MpOwogCiAJc3Bpbl9s
b2NrX2lycXNhdmUoJmluc3RhbmNlLT5jb21wbGV0aW9uX2xvY2ssIGZsYWdzKTsKLQljb21wbGV0
ZV9jbWRfZnVzaW9uKGluc3RhbmNlKTsKKwlmb3IgKE1TSXhJbmRleCA9IDAgOyBNU0l4SW5kZXgg
PCBjb3VudDsgTVNJeEluZGV4KyspCisJCWNvbXBsZXRlX2NtZF9mdXNpb24oaW5zdGFuY2UsIE1T
SXhJbmRleCk7CiAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmaW5zdGFuY2UtPmNvbXBsZXRpb25f
bG9jaywgZmxhZ3MpOwogfQogCkBAIC0xODUwLDEwICsxODcwLDExIEBACiAgKi8KIGlycXJldHVy
bl90IG1lZ2FzYXNfaXNyX2Z1c2lvbihpbnQgaXJxLCB2b2lkICpkZXZwKQogewotCXN0cnVjdCBt
ZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSA9IChzdHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqKWRl
dnA7CisJc3RydWN0IG1lZ2FzYXNfaXJxX2NvbnRleHQgKmlycV9jb250ZXh0ID0gZGV2cDsKKwlz
dHJ1Y3QgbWVnYXNhc19pbnN0YW5jZSAqaW5zdGFuY2UgPSBpcnFfY29udGV4dC0+aW5zdGFuY2U7
CiAJdTMyIG1maVN0YXR1cywgZndfc3RhdGU7CiAKLQlpZiAoIWluc3RhbmNlLT5tc2lfZmxhZykg
eworCWlmICghaW5zdGFuY2UtPm1zaXhfdmVjdG9ycykgewogCQltZmlTdGF0dXMgPSBpbnN0YW5j
ZS0+aW5zdGFuY2V0LT5jbGVhcl9pbnRyKGluc3RhbmNlLT5yZWdfc2V0KTsKIAkJaWYgKCFtZmlT
dGF0dXMpCiAJCQlyZXR1cm4gSVJRX05PTkU7CkBAIC0xODY1LDcgKzE4ODYsNyBAQAogCQlyZXR1
cm4gSVJRX0hBTkRMRUQ7CiAJfQogCi0JaWYgKCFjb21wbGV0ZV9jbWRfZnVzaW9uKGluc3RhbmNl
KSkgeworCWlmICghY29tcGxldGVfY21kX2Z1c2lvbihpbnN0YW5jZSwgaXJxX2NvbnRleHQtPk1T
SXhJbmRleCkpIHsKIAkJaW5zdGFuY2UtPmluc3RhbmNldC0+Y2xlYXJfaW50cihpbnN0YW5jZS0+
cmVnX3NldCk7CiAJCS8qIElmIHdlIGRpZG4ndCBjb21wbGV0ZSBhbnkgY29tbWFuZHMsIGNoZWNr
IGZvciBGVyBmYXVsdCAqLwogCQlmd19zdGF0ZSA9IGluc3RhbmNlLT5pbnN0YW5jZXQtPnJlYWRf
Zndfc3RhdHVzX3JlZygKQEAgLTIwODEsMTQgKzIxMDIsMTYgQEAKIAogdm9pZCAgbWVnYXNhc19y
ZXNldF9yZXBseV9kZXNjKHN0cnVjdCBtZWdhc2FzX2luc3RhbmNlICppbnN0YW5jZSkKIHsKLQlp
bnQgaTsKKwlpbnQgaSwgY291bnQ7CiAJc3RydWN0IGZ1c2lvbl9jb250ZXh0ICpmdXNpb247CiAJ
dW5pb24gTVBJMl9SRVBMWV9ERVNDUklQVE9SU19VTklPTiAqcmVwbHlfZGVzYzsKIAogCWZ1c2lv
biA9IGluc3RhbmNlLT5jdHJsX2NvbnRleHQ7Ci0JZnVzaW9uLT5sYXN0X3JlcGx5X2lkeCA9IDA7
CisJY291bnQgPSBpbnN0YW5jZS0+bXNpeF92ZWN0b3JzID4gMCA/IGluc3RhbmNlLT5tc2l4X3Zl
Y3RvcnMgOiAxOworCWZvciAoaSA9IDAgOyBpIDwgY291bnQgOyBpKyspCisJCWZ1c2lvbi0+bGFz
dF9yZXBseV9pZHhbaV0gPSAwOwogCXJlcGx5X2Rlc2MgPSBmdXNpb24tPnJlcGx5X2ZyYW1lc19k
ZXNjOwotCWZvciAoaSA9IDAgOyBpIDwgZnVzaW9uLT5yZXBseV9xX2RlcHRoOyBpKyssIHJlcGx5
X2Rlc2MrKykKKwlmb3IgKGkgPSAwIDsgaSA8IGZ1c2lvbi0+cmVwbHlfcV9kZXB0aCAqIGNvdW50
OyBpKyssIHJlcGx5X2Rlc2MrKykKIAkJcmVwbHlfZGVzYy0+V29yZHMgPSBVTExPTkdfTUFYOwog
fQogCmRpZmYgLU5hdXIgc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Njc2kvbWVnYXJhaWQvbWVnYXJh
aWRfc2FzX2Z1c2lvbi5oIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9t
ZWdhcmFpZF9zYXNfZnVzaW9uLmgKLS0tIHNjc2ktbWlzYy0yLjYvZHJpdmVycy9zY3NpL21lZ2Fy
YWlkL21lZ2FyYWlkX3Nhc19mdXNpb24uaAkyMDExLTEwLTA4IDE1OjI4OjUxLjY5OTMzMDgxNyAt
MDcwMAorKysgc2NzaS1taXNjLTIuNi5uZXcvZHJpdmVycy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlk
X3Nhc19mdXNpb24uaAkyMDExLTEwLTA4IDE1OjA3OjA0LjgxNjI2OTI2NiAtMDcwMApAQCAtNDMs
NiArNDMsNyBAQAogI2RlZmluZSBIT1NUX0RJQUdfV1JJVEVfRU5BQkxFCQkJICAgIDB4ODAKICNk
ZWZpbmUgSE9TVF9ESUFHX1JFU0VUX0FEQVBURVIJCQkgICAgMHg0CiAjZGVmaW5lIE1FR0FTQVNf
RlVTSU9OX01BWF9SRVNFVF9UUklFUwkJICAgIDMKKyNkZWZpbmUgTUFYX01TSVhfUVVFVUVTX0ZV
U0lPTgkJCSAgICAxNgogCiAvKiBJbnZhZGVyIGRlZmluZXMgKi8KICNkZWZpbmUgTVBJMl9UWVBF
X0NVREEJCQkJICAgIDB4MgpAQCAtNjczLDcgKzY3NCw3IEBACiAJdW5pb24gTVBJMl9SRVBMWV9E
RVNDUklQVE9SU19VTklPTiAqcmVwbHlfZnJhbWVzX2Rlc2M7CiAJc3RydWN0IGRtYV9wb29sICpy
ZXBseV9mcmFtZXNfZGVzY19wb29sOwogCi0JdTE2IGxhc3RfcmVwbHlfaWR4OworCXUxNiBsYXN0
X3JlcGx5X2lkeFtNQVhfTVNJWF9RVUVVRVNfRlVTSU9OXTsKIAogCXUzMiByZXBseV9xX2RlcHRo
OwogCXUzMiByZXF1ZXN0X2FsbG9jX3N6OwpkaWZmIC1OYXVyIHNjc2ktbWlzYy0yLjYvZHJpdmVy
cy9zY3NpL21lZ2FyYWlkL21lZ2FyYWlkX3Nhcy5oIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMv
c2NzaS9tZWdhcmFpZC9tZWdhcmFpZF9zYXMuaAotLS0gc2NzaS1taXNjLTIuNi9kcml2ZXJzL3Nj
c2kvbWVnYXJhaWQvbWVnYXJhaWRfc2FzLmgJMjAxMS0xMC0wOCAxNToyODo1MS43MDAzMzA3NjUg
LTA3MDAKKysrIHNjc2ktbWlzYy0yLjYubmV3L2RyaXZlcnMvc2NzaS9tZWdhcmFpZC9tZWdhcmFp
ZF9zYXMuaAkyMDExLTEwLTA4IDE1OjA5OjE5LjM3ODI2ODUzOSAtMDcwMApAQCAtNzU3LDYgKzc1
Nyw3IEBACiAjZGVmaW5lIE1FR0FTQVNfSU5UX0NNRFMJCQkzMgogI2RlZmluZSBNRUdBU0FTX1NL
SU5OWV9JTlRfQ01EUwkJCTUKIAorI2RlZmluZSBNRUdBU0FTX01BWF9NU0lYX1FVRVVFUwkJCTE2
CiAvKgogICogRlcgY2FuIGFjY2VwdCBib3RoIDMyIGFuZCA2NCBiaXQgU0dMcy4gV2Ugd2FudCB0
byBhbGxvY2F0ZSAzMi82NCBiaXQKICAqIFNHTHMgYmFzZWQgb24gdGhlIHNpemUgb2YgZG1hX2Fk
ZHJfdApAQCAtMTI3OCw2ICsxMjc5LDExIEBACiAJc3RydWN0IG1lZ2FzYXNfaW5zdGFuY2UgKmlu
c3RhbmNlOwogfTsKIAorc3RydWN0IG1lZ2FzYXNfaXJxX2NvbnRleHQgeworCXN0cnVjdCBtZWdh
c2FzX2luc3RhbmNlICppbnN0YW5jZTsKKwl1MzIgTVNJeEluZGV4OworfTsKKwogc3RydWN0IG1l
Z2FzYXNfaW5zdGFuY2UgewogCiAJdTMyICpwcm9kdWNlcjsKQEAgLTEzNTEsOCArMTM1Nyw5IEBA
CiAKIAkvKiBQdHIgdG8gaGJhIHNwZWNpZmljIGluZm9ybWF0aW9uICovCiAJdm9pZCAqY3RybF9j
b250ZXh0OwotCXU4CW1zaV9mbGFnOwotCXN0cnVjdCBtc2l4X2VudHJ5IG1zaXhlbnRyeTsKKwl1
bnNpZ25lZCBpbnQgbXNpeF92ZWN0b3JzOworCXN0cnVjdCBtc2l4X2VudHJ5IG1zaXhlbnRyeVtN
RUdBU0FTX01BWF9NU0lYX1FVRVVFU107CisJc3RydWN0IG1lZ2FzYXNfaXJxX2NvbnRleHQgaXJx
X2NvbnRleHRbTUVHQVNBU19NQVhfTVNJWF9RVUVVRVNdOwogCXU2NCBtYXBfaWQ7CiAJc3RydWN0
IG1lZ2FzYXNfY21kICptYXBfdXBkYXRlX2NtZDsKIAl1bnNpZ25lZCBsb25nIGJhcjsK
--0016e64c393a02037d04aed3687b--
