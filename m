From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 1/5] megaraid_sas : Code optimization and refactoring
Date: Fri, 27 Mar 2015 17:25:17 +0530
Message-ID: <201503271156.t2RBum1Y032249@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0064.outbound.protection.outlook.com ([207.46.100.64]:52352
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752788AbbC0MKP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Mar 2015 08:10:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

This patch has code optimization and refactoring in below areas-

1) Created separate functions for sysPD IOs and non Read Write LDIOs.
2) Added function for refiring MFI commands in controller reset path.
3) Enabling interrupt immediately after adapter's initialization.
4) Added function for setting up IRQs.
5) Modified few prints for better logging.
6) Modified few macros not to pass unused parameters.
7) Move internal commands and SCSI commands reservation in adapter's sepcific functions.

Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>

---
 drivers/scsi/megaraid/megaraid_sas.h        |   10 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  292 ++++++++++++-------------
 drivers/scsi/megaraid/megaraid_sas_fusion.c |  316 +++++++++++++++------------
 3 files changed, 321 insertions(+), 297 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 14e5c7c..bdcf2b6 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1864,9 +1864,13 @@ struct megasas_instance_template {
 #define MEGASAS_IS_LOGICAL(scp)						\
 	(scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1
 
-#define MEGASAS_DEV_INDEX(inst, scp)					\
-	((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) + 	\
-	scp->device->id
+#define MEGASAS_DEV_INDEX(scp)						\
+	(((scp->device->channel % 2) * MEGASAS_MAX_DEV_PER_CHANNEL) +	\
+	scp->device->id)
+
+#define MEGASAS_PD_INDEX(scp)						\
+	((scp->device->channel * MEGASAS_MAX_DEV_PER_CHANNEL) +		\
+	scp->device->id)
 
 struct megasas_cmd {
 
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 890637f..a949f44 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -1196,7 +1196,7 @@ megasas_build_dcdb(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	struct megasas_pthru_frame *pthru;
 
 	is_logical = MEGASAS_IS_LOGICAL(scp);
-	device_id = MEGASAS_DEV_INDEX(instance, scp);
+	device_id = MEGASAS_DEV_INDEX(scp);
 	pthru = (struct megasas_pthru_frame *)cmd->frame;
 
 	if (scp->sc_data_direction == PCI_DMA_TODEVICE)
@@ -1294,7 +1294,7 @@ megasas_build_ldio(struct megasas_instance *instance, struct scsi_cmnd *scp,
 	u16 flags = 0;
 	struct megasas_io_frame *ldio;
 
-	device_id = MEGASAS_DEV_INDEX(instance, scp);
+	device_id = MEGASAS_DEV_INDEX(scp);
 	ldio = (struct megasas_io_frame *)cmd->frame;
 
 	if (scp->sc_data_direction == PCI_DMA_TODEVICE)
@@ -4091,12 +4091,11 @@ static void megasas_update_ext_vd_details(struct megasas_instance *instance)
 		instance->fw_supported_vd_count = MAX_LOGICAL_DRIVES;
 		instance->fw_supported_pd_count = MAX_PHYSICAL_DEVICES;
 	}
-	dev_info(&instance->pdev->dev, "Firmware supports %d VD %d PD\n",
-		instance->fw_supported_vd_count,
-		instance->fw_supported_pd_count);
-	dev_info(&instance->pdev->dev, "Driver supports %d VD  %d PD\n",
-		instance->drv_supported_vd_count,
-		instance->drv_supported_pd_count);
+
+	dev_info(&instance->pdev->dev,
+		"firmware type\t: %s\n",
+		instance->supportmax256vd ? "Extended VD(240 VD)firmware" :
+		"Legacy(64 VD) firmware");
 
 	old_map_sz =  sizeof(struct MR_FW_RAID_MAP) +
 				(sizeof(struct MR_LD_SPAN_MAP) *
@@ -4354,6 +4353,21 @@ megasas_init_adapter_mfi(struct megasas_instance *instance)
 	instance->max_num_sge = (instance->instancet->read_fw_status_reg(reg_set) & 0xFF0000) >>
 					0x10;
 	/*
+	 * For MFI skinny adapters, MEGASAS_SKINNY_INT_CMDS commands
+	 * are reserved for IOCTL + driver's internal DCMDs.
+	 */
+	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
+		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
+		instance->max_scsi_cmds = (instance->max_fw_cmds -
+			MEGASAS_SKINNY_INT_CMDS);
+		sema_init(&instance->ioctl_sem, MEGASAS_SKINNY_INT_CMDS);
+	} else {
+		instance->max_scsi_cmds = (instance->max_fw_cmds -
+			MEGASAS_INT_CMDS);
+		sema_init(&instance->ioctl_sem, (MEGASAS_INT_CMDS - 5));
+	}
+
+	/*
 	 * Create a pool of commands
 	 */
 	if (megasas_alloc_cmds(instance))
@@ -4415,6 +4429,72 @@ fail_alloc_cmds:
 }
 
 /**
+ * megasas_setup_irqs -	register interrupt with IRQ sub system.
+ * @instance:				Adapter soft state
+ * @is_probe:				Driver probe check
+ *
+ * Do not enable interrupt, only setup ISRs.
+ *
+ * Return 0 on success.
+ */
+static int
+megasas_setup_irqs(struct megasas_instance *instance, u8 is_probe)
+{
+	int i, j, cpu;
+	struct pci_dev *pdev;
+
+	pdev = instance->pdev;
+
+try_io_apic:
+	if (!instance->msix_vectors) {
+		instance->irq_context[0].instance = instance;
+		instance->irq_context[0].MSIxIndex = 0;
+		if (request_irq(pdev->irq, instance->instancet->service_isr,
+			IRQF_SHARED, "megasas", &instance->irq_context[0])) {
+			dev_err(&instance->pdev->dev,
+					"Failed to register IRQ from %s %d\n",
+					__func__, __LINE__);
+			return -1;
+		}
+		return 0;
+	}
+	/* Try MSI-x */
+	cpu = cpumask_first(cpu_online_mask);
+	for (i = 0; i < instance->msix_vectors; i++) {
+		instance->irq_context[i].instance = instance;
+		instance->irq_context[i].MSIxIndex = i;
+		if (request_irq(instance->msixentry[i].vector,
+			instance->instancet->service_isr, 0, "megasas",
+			&instance->irq_context[i])) {
+			dev_err(&instance->pdev->dev,
+				"Failed to register IRQ for vector %d.\n", i);
+			for (j = 0; j < i; j++) {
+				if (smp_affinity_enable)
+					irq_set_affinity_hint(
+						instance->msixentry[j].vector, NULL);
+				free_irq(instance->msixentry[j].vector,
+					&instance->irq_context[j]);
+			}
+			/* Retry irq register for IO_APIC*/
+			instance->msix_vectors = 0;
+			if (is_probe)
+				goto try_io_apic;
+			else
+				return -1;
+		}
+		if (smp_affinity_enable) {
+			if (irq_set_affinity_hint(instance->msixentry[i].vector,
+				get_cpu_mask(cpu)))
+				dev_err(&instance->pdev->dev,
+					"Failed to set affinity hint"
+					" for cpu %d\n", cpu);
+			cpu = cpumask_next(cpu, cpu_online_mask);
+		}
+	}
+	return 0;
+}
+
+/**
  * megasas_init_fw -	Initializes the FW
  * @instance:		Adapter soft state
  *
@@ -4552,11 +4632,14 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		else
 			instance->msix_vectors = 0;
 
-		dev_info(&instance->pdev->dev, "[scsi%d]: FW supports"
-			"<%d> MSIX vector,Online CPUs: <%d>,"
-			"Current MSIX <%d>\n", instance->host->host_no,
-			fw_msix_count, (unsigned int)num_online_cpus(),
-			instance->msix_vectors);
+		dev_info(&instance->pdev->dev,
+			"firmware supports msix\t: (%d)", fw_msix_count);
+		dev_info(&instance->pdev->dev,
+			"current msix/online cpus\t: (%d/%d)\n",
+			instance->msix_vectors, (unsigned int)num_online_cpus());
+
+		if (megasas_setup_irqs(instance, 1))
+			goto fail_setup_irqs;
 	}
 
 	instance->ctrl_info = kzalloc(sizeof(struct megasas_ctrl_info),
@@ -4573,6 +4656,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	/* Get operational params, sge flags, send init cmd to controller */
 	if (instance->instancet->init_adapter(instance))
 		goto fail_init_adapter;
+	instance->instancet->enable_intr(instance);
 
 	printk(KERN_ERR "megasas: INIT adapter done\n");
 
@@ -4584,7 +4668,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		(MEGASAS_MAX_PD * sizeof(struct megasas_pd_list)));
 	if (megasas_get_pd_list(instance) < 0) {
 		printk(KERN_ERR "megasas: failed to get PD list\n");
-		goto fail_init_adapter;
+		goto fail_get_pd_list;
 	}
 
 	memset(instance->ld_ids, 0xff, MEGASAS_MAX_LD_IDS);
@@ -4628,9 +4712,6 @@ static int megasas_init_fw(struct megasas_instance *instance)
 		ctrl_info->adapterOperations2.supportUnevenSpans;
 	if (instance->UnevenSpanSupport) {
 		struct fusion_context *fusion = instance->ctrl_context;
-
-		dev_info(&instance->pdev->dev, "FW supports: "
-		"UnevenSpanSupport=%x\n", instance->UnevenSpanSupport);
 		if (MR_ValidateMapInfo(instance))
 			fusion->fast_path_io = 1;
 		else
@@ -4657,13 +4738,11 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	instance->crash_dump_drv_support =
 		(instance->crash_dump_fw_support &&
 		instance->crash_dump_buf);
-	if (instance->crash_dump_drv_support) {
-		dev_info(&instance->pdev->dev, "Firmware Crash dump "
-			"feature is supported\n");
+	if (instance->crash_dump_drv_support)
 		megasas_set_crash_dump_params(instance,
 			MR_CRASH_BUF_TURN_OFF);
 
-	} else {
+	else {
 		if (instance->crash_dump_buf)
 			pci_free_consistent(instance->pdev,
 				CRASH_DMA_BUF_SIZE,
@@ -4674,37 +4753,27 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 	instance->secure_jbod_support =
 		ctrl_info->adapterOperations3.supportSecurityonJBOD;
-	if (instance->secure_jbod_support)
-		dev_info(&instance->pdev->dev, "Firmware supports Secure JBOD\n");
+
+	dev_info(&instance->pdev->dev,
+		"pci id\t\t: (0x%04x)/(0x%04x)/(0x%04x)/(0x%04x)\n",
+		le16_to_cpu(ctrl_info->pci.vendor_id),
+		le16_to_cpu(ctrl_info->pci.device_id),
+		le16_to_cpu(ctrl_info->pci.sub_vendor_id),
+		le16_to_cpu(ctrl_info->pci.sub_device_id));
+	dev_info(&instance->pdev->dev, "unevenspan support	: %s\n",
+		instance->UnevenSpanSupport ? "yes" : "no");
+	dev_info(&instance->pdev->dev, "disable ocr		: %s\n",
+		instance->disableOnlineCtrlReset ? "yes" : "no");
+	dev_info(&instance->pdev->dev, "firmware crash dump	: %s\n",
+		instance->crash_dump_drv_support ? "yes" : "no");
+	dev_info(&instance->pdev->dev, "secure jbod		: %s\n",
+		instance->secure_jbod_support ? "yes" : "no");
+
 	instance->max_sectors_per_req = instance->max_num_sge *
 						PAGE_SIZE / 512;
 	if (tmp_sectors && (instance->max_sectors_per_req > tmp_sectors))
 		instance->max_sectors_per_req = tmp_sectors;
 
-	/*
-	 * 1. For fusion adapters, 3 commands for IOCTL and 5 commands
-	 *    for driver's internal DCMDs.
-	 * 2. For MFI skinny adapters, 5 commands for IOCTL + driver's
-	 *    internal DCMDs.
-	 * 3. For rest of MFI adapters, 27 commands reserved for IOCTLs
-	 *    and 5 commands for drivers's internal DCMD.
-	 */
-	if (instance->ctrl_context) {
-		instance->max_scsi_cmds = instance->max_fw_cmds -
-					(MEGASAS_FUSION_INTERNAL_CMDS +
-					MEGASAS_FUSION_IOCTL_CMDS);
-		sema_init(&instance->ioctl_sem, MEGASAS_FUSION_IOCTL_CMDS);
-	} else if ((instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0073SKINNY) ||
-		(instance->pdev->device == PCI_DEVICE_ID_LSI_SAS0071SKINNY)) {
-		instance->max_scsi_cmds = instance->max_fw_cmds -
-						MEGASAS_SKINNY_INT_CMDS;
-		sema_init(&instance->ioctl_sem, MEGASAS_SKINNY_INT_CMDS);
-	} else {
-		instance->max_scsi_cmds = instance->max_fw_cmds -
-						MEGASAS_INT_CMDS;
-		sema_init(&instance->ioctl_sem, (MEGASAS_INT_CMDS - 5));
-	}
-
 	/* Check for valid throttlequeuedepth module parameter */
 	if (throttlequeuedepth &&
 			throttlequeuedepth <= instance->max_scsi_cmds)
@@ -4733,7 +4802,22 @@ static int megasas_init_fw(struct megasas_instance *instance)
 
 	return 0;
 
+fail_get_pd_list:
+	instance->instancet->disable_intr(instance);
 fail_init_adapter:
+	if (instance->msix_vectors)
+		for (i = 0; i < instance->msix_vectors; i++) {
+			if (smp_affinity_enable)
+				irq_set_affinity_hint(
+					instance->msixentry[i].vector, NULL);
+			free_irq(instance->msixentry[i].vector, &instance->irq_context[i]);
+		}
+	else
+		free_irq(instance->pdev->irq, &instance->irq_context[0]);
+fail_setup_irqs:
+	if (instance->msix_vectors)
+		pci_disable_msix(instance->pdev);
+	instance->msix_vectors = 0;
 fail_ready_state:
 	kfree(instance->ctrl_info);
 	instance->ctrl_info = NULL;
@@ -5106,7 +5190,7 @@ fail_set_dma_mask:
 static int megasas_probe_one(struct pci_dev *pdev,
 			     const struct pci_device_id *id)
 {
-	int rval, pos, i, j, cpu;
+	int rval, pos, i;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 	u16 control = 0;
@@ -5129,16 +5213,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 	}
 
 	/*
-	 * Announce PCI information
-	 */
-	printk(KERN_INFO "megasas: %#4.04x:%#4.04x:%#4.04x:%#4.04x: ",
-	       pdev->vendor, pdev->device, pdev->subsystem_vendor,
-	       pdev->subsystem_device);
-
-	printk("bus %d:slot %d:func %d\n",
-	       pdev->bus->number, PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
-
-	/*
 	 * PCI prepping: enable device set bus mastering and dma mask
 	 */
 	rval = pci_enable_device_mem(pdev);
@@ -5315,55 +5389,6 @@ static int megasas_probe_one(struct pci_dev *pdev,
 		}
 	}
 
-retry_irq_register:
-	/*
-	 * Register IRQ
-	 */
-	if (instance->msix_vectors) {
-		cpu = cpumask_first(cpu_online_mask);
-		for (i = 0; i < instance->msix_vectors; i++) {
-			instance->irq_context[i].instance = instance;
-			instance->irq_context[i].MSIxIndex = i;
-			if (request_irq(instance->msixentry[i].vector,
-					instance->instancet->service_isr, 0,
-					"megasas",
-					&instance->irq_context[i])) {
-				printk(KERN_DEBUG "megasas: Failed to "
-				       "register IRQ for vector %d.\n", i);
-				for (j = 0; j < i; j++) {
-					if (smp_affinity_enable)
-						irq_set_affinity_hint(
-							instance->msixentry[j].vector, NULL);
-					free_irq(
-						instance->msixentry[j].vector,
-						&instance->irq_context[j]);
-				}
-				/* Retry irq register for IO_APIC */
-				instance->msix_vectors = 0;
-				goto retry_irq_register;
-			}
-			if (smp_affinity_enable) {
-				if (irq_set_affinity_hint(instance->msixentry[i].vector,
-					get_cpu_mask(cpu)))
-					dev_err(&instance->pdev->dev,
-						"Error setting affinity hint "
-						"for cpu %d\n", cpu);
-				cpu = cpumask_next(cpu, cpu_online_mask);
-			}
-		}
-	} else {
-		instance->irq_context[0].instance = instance;
-		instance->irq_context[0].MSIxIndex = 0;
-		if (request_irq(pdev->irq, instance->instancet->service_isr,
-				IRQF_SHARED, "megasas",
-				&instance->irq_context[0])) {
-			printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
-			goto fail_irq;
-		}
-	}
-
-	instance->instancet->enable_intr(instance);
-
 	/*
 	 * Store instance in PCI softstate
 	 */
@@ -5420,7 +5445,7 @@ retry_irq_register:
 		}
 	else
 		free_irq(instance->pdev->irq, &instance->irq_context[0]);
-fail_irq:
+
 	if ((instance->pdev->device == PCI_DEVICE_ID_LSI_FUSION) ||
 	    (instance->pdev->device == PCI_DEVICE_ID_LSI_PLASMA) ||
 	    (instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
@@ -5428,9 +5453,9 @@ fail_irq:
 		megasas_release_fusion(instance);
 	else
 		megasas_release_mfi(instance);
-      fail_init_mfi:
 	if (instance->msix_vectors)
 		pci_disable_msix(instance->pdev);
+      fail_init_mfi:
       fail_alloc_dma_buf:
 	if (instance->evt_detail)
 		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
@@ -5611,7 +5636,7 @@ megasas_suspend(struct pci_dev *pdev, pm_message_t state)
 static int
 megasas_resume(struct pci_dev *pdev)
 {
-	int rval, i, j, cpu;
+	int rval;
 	struct Scsi_Host *host;
 	struct megasas_instance *instance;
 
@@ -5681,50 +5706,8 @@ megasas_resume(struct pci_dev *pdev)
 	tasklet_init(&instance->isr_tasklet, instance->instancet->tasklet,
 		     (unsigned long)instance);
 
-	/*
-	 * Register IRQ
-	 */
-	if (instance->msix_vectors) {
-		cpu = cpumask_first(cpu_online_mask);
-		for (i = 0 ; i < instance->msix_vectors; i++) {
-			instance->irq_context[i].instance = instance;
-			instance->irq_context[i].MSIxIndex = i;
-			if (request_irq(instance->msixentry[i].vector,
-					instance->instancet->service_isr, 0,
-					"megasas",
-					&instance->irq_context[i])) {
-				printk(KERN_DEBUG "megasas: Failed to "
-				       "register IRQ for vector %d.\n", i);
-				for (j = 0; j < i; j++) {
-					if (smp_affinity_enable)
-						irq_set_affinity_hint(
-							instance->msixentry[j].vector, NULL);
-					free_irq(
-						instance->msixentry[j].vector,
-						&instance->irq_context[j]);
-				}
-				goto fail_irq;
-			}
-
-			if (smp_affinity_enable) {
-				if (irq_set_affinity_hint(instance->msixentry[i].vector,
-					get_cpu_mask(cpu)))
-					dev_err(&instance->pdev->dev, "Error "
-						"setting affinity hint for cpu "
-						"%d\n", cpu);
-				cpu = cpumask_next(cpu, cpu_online_mask);
-			}
-		}
-	} else {
-		instance->irq_context[0].instance = instance;
-		instance->irq_context[0].MSIxIndex = 0;
-		if (request_irq(pdev->irq, instance->instancet->service_isr,
-				IRQF_SHARED, "megasas",
-				&instance->irq_context[0])) {
-			printk(KERN_DEBUG "megasas: Failed to register IRQ\n");
-			goto fail_irq;
-		}
-	}
+	if (megasas_setup_irqs(instance, 0))
+		goto fail_init_mfi;
 
 	/* Re-launch SR-IOV heartbeat timer */
 	if (instance->requestorId) {
@@ -5748,7 +5731,6 @@ megasas_resume(struct pci_dev *pdev)
 
 	return 0;
 
-fail_irq:
 fail_init_mfi:
 	if (instance->evt_detail)
 		pci_free_consistent(pdev, sizeof(struct megasas_evt_detail),
diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 675b5e7..3cd1d5f 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1061,6 +1061,15 @@ megasas_init_adapter_fusion(struct megasas_instance *instance)
 		fusion->last_reply_idx[i] = 0;
 
 	/*
+	 * For fusion adapters, 3 commands for IOCTL and 5 commands
+	 * for driver's internal DCMDs.
+	 */
+	instance->max_scsi_cmds = instance->max_fw_cmds -
+				(MEGASAS_FUSION_INTERNAL_CMDS +
+				MEGASAS_FUSION_IOCTL_CMDS);
+	sema_init(&instance->ioctl_sem, MEGASAS_FUSION_IOCTL_CMDS);
+
+	/*
 	 * Allocate memory for descriptors
 	 * Create a pool of commands
 	 */
@@ -1497,7 +1506,7 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
 	u8 *raidLUN;
 
-	device_id = MEGASAS_DEV_INDEX(instance, scp);
+	device_id = MEGASAS_DEV_INDEX(scp);
 
 	fusion = instance->ctrl_context;
 
@@ -1650,23 +1659,19 @@ megasas_build_ldio_fusion(struct megasas_instance *instance,
 }
 
 /**
- * megasas_build_dcdb_fusion -	Prepares IOs to devices
+ * megasas_build_ld_nonrw_fusion - prepares non rw ios for virtual disk
  * @instance:		Adapter soft state
  * @scp:		SCSI command
  * @cmd:		Command to be prepared
  *
- * Prepares the io_request frame for non-io cmds
+ * Prepares the io_request frame for non-rw io cmds for vd.
  */
-static void
-megasas_build_dcdb_fusion(struct megasas_instance *instance,
-			  struct scsi_cmnd *scmd,
-			  struct megasas_cmd_fusion *cmd)
+static void megasas_build_ld_nonrw_fusion(struct megasas_instance *instance,
+			  struct scsi_cmnd *scmd, struct megasas_cmd_fusion *cmd)
 {
 	u32 device_id;
 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
 	u16 pd_index = 0;
-	u16 os_timeout_value;
-	u16 timeout_limit;
 	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
 	struct fusion_context *fusion = instance->ctrl_context;
 	u8                          span, physArm;
@@ -1674,94 +1679,48 @@ megasas_build_dcdb_fusion(struct megasas_instance *instance,
 	u32                         ld, arRef, pd;
 	struct MR_LD_RAID                  *raid;
 	struct RAID_CONTEXT                *pRAID_Context;
+	u8 fp_possible = 1;
 
 	io_request = cmd->io_request;
-	device_id = MEGASAS_DEV_INDEX(instance, scmd);
-	pd_index = (scmd->device->channel * MEGASAS_MAX_DEV_PER_CHANNEL)
-		+scmd->device->id;
+	device_id = MEGASAS_DEV_INDEX(scmd);
+	pd_index = MEGASAS_PD_INDEX(scmd);
 	local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
-
 	io_request->DataLength = cpu_to_le32(scsi_bufflen(scmd));
+	/* get RAID_Context pointer */
+	pRAID_Context = &io_request->RaidContext;
+	/* Check with FW team */
+	pRAID_Context->VirtualDiskTgtId = cpu_to_le16(device_id);
+	pRAID_Context->regLockRowLBA    = 0;
+	pRAID_Context->regLockLength    = 0;
 
-	if (scmd->device->channel < MEGASAS_MAX_PD_CHANNELS &&
-	    instance->pd_list[pd_index].driveState == MR_PD_STATE_SYSTEM) {
-		if (fusion->fast_path_io)
-			io_request->DevHandle =
-			local_map_ptr->raidMap.devHndlInfo[device_id].curDevHdl;
-		io_request->RaidContext.RAIDFlags =
-			MR_RAID_FLAGS_IO_SUB_TYPE_SYSTEM_PD
-			<< MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT;
-		cmd->request_desc->SCSIIO.DevHandle = io_request->DevHandle;
-		cmd->request_desc->SCSIIO.MSIxIndex =
-			instance->msix_vectors ? smp_processor_id() % instance->msix_vectors : 0;
-		os_timeout_value = scmd->request->timeout / HZ;
-
-		if (instance->secure_jbod_support &&
-			(megasas_cmd_type(scmd) == NON_READ_WRITE_SYSPDIO)) {
-			/* system pd firmware path */
-			io_request->Function  =
-				MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
-			cmd->request_desc->SCSIIO.RequestFlags =
-				(MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
-				MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
-			io_request->RaidContext.timeoutValue =
-				cpu_to_le16(os_timeout_value);
-		} else {
-			/* system pd Fast Path */
-			io_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
-			io_request->RaidContext.regLockFlags = 0;
-			io_request->RaidContext.regLockRowLBA = 0;
-			io_request->RaidContext.regLockLength = 0;
-			timeout_limit = (scmd->device->type == TYPE_DISK) ?
-					255 : 0xFFFF;
-			io_request->RaidContext.timeoutValue =
-				cpu_to_le16((os_timeout_value > timeout_limit) ?
-				timeout_limit : os_timeout_value);
-		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
-			(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY))
-			io_request->IoFlags |=
-			cpu_to_le16(MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH);
-
-			cmd->request_desc->SCSIIO.RequestFlags =
-				(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY <<
-				MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
-		}
-	} else {
-		if (scmd->device->channel < MEGASAS_MAX_PD_CHANNELS)
-			goto NonFastPath;
-
-		/*
-		 * For older firmware, Driver should not access ldTgtIdToLd
-		 * beyond index 127 and for Extended VD firmware, ldTgtIdToLd
-		 * should not go beyond 255.
-		 */
-
-		if ((!fusion->fast_path_io) ||
-			(device_id >= instance->fw_supported_vd_count))
-			goto NonFastPath;
+	if (fusion->fast_path_io && (
+		device_id < instance->fw_supported_vd_count)) {
 
 		ld = MR_TargetIdToLdGet(device_id, local_map_ptr);
-
 		if (ld >= instance->fw_supported_vd_count)
-			goto NonFastPath;
+			fp_possible = 0;
 
 		raid = MR_LdRaidGet(ld, local_map_ptr);
-
-		/* check if this LD is FP capable */
 		if (!(raid->capability.fpNonRWCapable))
-			/* not FP capable, send as non-FP */
-			goto NonFastPath;
+			fp_possible = 0;
+	} else
+		fp_possible = 0;
 
-		/* get RAID_Context pointer */
-		pRAID_Context = &io_request->RaidContext;
+	if (!fp_possible) {
+		io_request->Function  = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
+		io_request->DevHandle = cpu_to_le16(device_id);
+		io_request->LUN[1] = scmd->device->lun;
+		pRAID_Context->timeoutValue =
+			cpu_to_le16 (scmd->request->timeout / HZ);
+		cmd->request_desc->SCSIIO.RequestFlags =
+			(MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
+			MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+	} else {
 
 		/* set RAID context values */
-		pRAID_Context->regLockFlags     = REGION_TYPE_SHARED_READ;
-		pRAID_Context->timeoutValue     = cpu_to_le16(raid->fpIoTimeoutForLd);
-		pRAID_Context->VirtualDiskTgtId = cpu_to_le16(device_id);
-		pRAID_Context->regLockRowLBA    = 0;
-		pRAID_Context->regLockLength    = 0;
-		pRAID_Context->configSeqNum     = raid->seqNum;
+		pRAID_Context->configSeqNum = raid->seqNum;
+		pRAID_Context->regLockFlags = REGION_TYPE_SHARED_READ;
+		pRAID_Context->timeoutValue = cpu_to_le16(raid->fpIoTimeoutForLd);
 
 		/* get the DevHandle for the PD (since this is
 		   fpNonRWCapable, this is a single disk RAID0) */
@@ -1773,7 +1732,7 @@ megasas_build_dcdb_fusion(struct megasas_instance *instance,
 		/* build request descriptor */
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY <<
-			 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+			MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
 		cmd->request_desc->SCSIIO.DevHandle = devHandle;
 
 		/* populate the LUN field */
@@ -1782,18 +1741,87 @@ megasas_build_dcdb_fusion(struct megasas_instance *instance,
 		/* build the raidScsiIO structure */
 		io_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
 		io_request->DevHandle = devHandle;
+	}
+}
 
-		return;
+/**
+ * megasas_build_syspd_fusion - prepares rw/non-rw ios for syspd
+ * @instance:		Adapter soft state
+ * @scp:		SCSI command
+ * @cmd:		Command to be prepared
+ * @fp_possible:	parameter to detect fast path or firmware path io.
+ *
+ * Prepares the io_request frame for rw/non-rw io cmds for syspds
+ */
+static void
+megasas_build_syspd_fusion(struct megasas_instance *instance,
+	struct scsi_cmnd *scmd, struct megasas_cmd_fusion *cmd, u8 fp_possible)
+{
+	u32 device_id;
+	struct MPI2_RAID_SCSI_IO_REQUEST *io_request;
+	u16 pd_index = 0;
+	u16 os_timeout_value;
+	u16 timeout_limit;
+	struct MR_DRV_RAID_MAP_ALL *local_map_ptr;
+	struct RAID_CONTEXT	*pRAID_Context;
+	struct fusion_context *fusion = instance->ctrl_context;
+
+	device_id = MEGASAS_DEV_INDEX(scmd);
+	pd_index = MEGASAS_PD_INDEX(scmd);
+	os_timeout_value = scmd->request->timeout / HZ;
 
-NonFastPath:
+	io_request = cmd->io_request;
+	/* get RAID_Context pointer */
+	pRAID_Context = &io_request->RaidContext;
+	io_request->DataLength = cpu_to_le32(scsi_bufflen(scmd));
+	io_request->LUN[1] = scmd->device->lun;
+	pRAID_Context->RAIDFlags = MR_RAID_FLAGS_IO_SUB_TYPE_SYSTEM_PD
+		<< MR_RAID_CTX_RAID_FLAGS_IO_SUB_TYPE_SHIFT;
+
+	pRAID_Context->VirtualDiskTgtId = cpu_to_le16(device_id);
+	pRAID_Context->configSeqNum = 0;
+	local_map_ptr = fusion->ld_drv_map[(instance->map_id & 1)];
+	io_request->DevHandle =
+		local_map_ptr->raidMap.devHndlInfo[device_id].curDevHdl;
+
+	cmd->request_desc->SCSIIO.DevHandle = io_request->DevHandle;
+	cmd->request_desc->SCSIIO.MSIxIndex =
+		instance->msix_vectors ?
+		(smp_processor_id() % instance->msix_vectors) : 0;
+
+
+	if (!fp_possible) {
+		/* system pd firmware path */
 		io_request->Function  = MEGASAS_MPI2_FUNCTION_LD_IO_REQUEST;
-		io_request->DevHandle = cpu_to_le16(device_id);
 		cmd->request_desc->SCSIIO.RequestFlags =
 			(MPI2_REQ_DESCRIPT_FLAGS_SCSI_IO <<
-			 MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+				MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+		pRAID_Context->timeoutValue = cpu_to_le16(os_timeout_value);
+	} else {
+		/* system pd Fast Path */
+		io_request->Function = MPI2_FUNCTION_SCSI_IO_REQUEST;
+		pRAID_Context->regLockFlags = 0;
+		pRAID_Context->regLockRowLBA = 0;
+		pRAID_Context->regLockLength = 0;
+		timeout_limit = (scmd->device->type == TYPE_DISK) ?
+				255 : 0xFFFF;
+		pRAID_Context->timeoutValue =
+			cpu_to_le16((os_timeout_value > timeout_limit) ?
+			timeout_limit : os_timeout_value);
+		if ((instance->pdev->device == PCI_DEVICE_ID_LSI_INVADER) ||
+			(instance->pdev->device == PCI_DEVICE_ID_LSI_FURY)) {
+			cmd->request_desc->SCSIIO.RequestFlags |=
+				(MEGASAS_REQ_DESCRIPT_FLAGS_NO_LOCK <<
+				MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
+			pRAID_Context->Type = MPI2_TYPE_CUDA;
+			pRAID_Context->nseg = 0x1;
+			io_request->IoFlags |=
+				cpu_to_le16(MPI25_SAS_DEVICE0_FLAGS_ENABLED_FAST_PATH);
+		}
+		cmd->request_desc->SCSIIO.RequestFlags =
+			(MPI2_REQ_DESCRIPT_FLAGS_HIGH_PRIORITY <<
+				MEGASAS_REQ_DESCRIPT_FLAGS_TYPE_SHIFT);
 	}
-	io_request->RaidContext.VirtualDiskTgtId = cpu_to_le16(device_id);
-	int_to_scsilun(scmd->device->lun, (struct scsi_lun *)io_request->LUN);
 }
 
 /**
@@ -1810,11 +1838,10 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 			struct scsi_cmnd *scp,
 			struct megasas_cmd_fusion *cmd)
 {
-	u32 device_id, sge_count;
+	u32 sge_count;
+	u8  cmd_type;
 	struct MPI2_RAID_SCSI_IO_REQUEST *io_request = cmd->io_request;
 
-	device_id = MEGASAS_DEV_INDEX(instance, scp);
-
 	/* Zero out some fields so they don't get reused */
 	memset(io_request->LUN, 0x0, 8);
 	io_request->CDB.EEDP32.PrimaryReferenceTag = 0;
@@ -1834,10 +1861,24 @@ megasas_build_io_fusion(struct megasas_instance *instance,
 	 */
 	io_request->IoFlags = cpu_to_le16(scp->cmd_len);
 
-	if (megasas_cmd_type(scp) == READ_WRITE_LDIO)
+	switch (cmd_type = megasas_cmd_type(scp)) {
+	case READ_WRITE_LDIO:
 		megasas_build_ldio_fusion(instance, scp, cmd);
-	else
-		megasas_build_dcdb_fusion(instance, scp, cmd);
+		break;
+	case NON_READ_WRITE_LDIO:
+		megasas_build_ld_nonrw_fusion(instance, scp, cmd);
+		break;
+	case READ_WRITE_SYSPDIO:
+	case NON_READ_WRITE_SYSPDIO:
+		if (instance->secure_jbod_support &&
+			(cmd_type == NON_READ_WRITE_SYSPDIO))
+			megasas_build_syspd_fusion(instance, scp, cmd, 0);
+		else
+			megasas_build_syspd_fusion(instance, scp, cmd, 1);
+		break;
+	default:
+		break;
+	}
 
 	/*
 	 * Construct SGL
@@ -2013,8 +2054,7 @@ complete_cmd_fusion(struct megasas_instance *instance, u32 MSIxIndex)
 		switch (scsi_io_req->Function) {
 		case MPI2_FUNCTION_SCSI_IO_REQUEST:  /*Fast Path IO.*/
 			/* Update load balancing info */
-			device_id = MEGASAS_DEV_INDEX(instance,
-						      cmd_fusion->scmd);
+			device_id = MEGASAS_DEV_INDEX(cmd_fusion->scmd);
 			lbinfo = &fusion->load_balance_info[device_id];
 			if (cmd_fusion->scmd->SCp.Status &
 			    MEGASAS_LOAD_BALANCE_FLAG) {
@@ -2508,6 +2548,43 @@ void  megasas_reset_reply_desc(struct megasas_instance *instance)
 		reply_desc->Words = ULLONG_MAX;
 }
 
+/*
+ * megasas_refire_mgmt_cmd :	Re-fire management commands
+ * @instance:				Controller's soft instance
+*/
+void megasas_refire_mgmt_cmd(struct megasas_instance *instance)
+{
+	int j;
+	struct megasas_cmd_fusion *cmd_fusion;
+	struct fusion_context *fusion;
+	struct megasas_cmd *cmd_mfi;
+	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
+	u16 smid;
+
+	fusion = instance->ctrl_context;
+
+	/* Re-fire management commands.
+	 * Do not traverse complet MPT frame pool. Start from max_scsi_cmds.
+	 */
+	for (j = instance->max_scsi_cmds ; j < instance->max_fw_cmds; j++) {
+		cmd_fusion = fusion->cmd_list[j];
+		cmd_mfi = instance->cmd_list[cmd_fusion->sync_cmd_idx];
+		smid = le16_to_cpu(cmd_mfi->context.smid);
+
+		if (!smid)
+			continue;
+		req_desc = megasas_get_request_descriptor
+					(instance, smid - 1);
+		if (req_desc && (cmd_mfi->frame->dcmd.opcode !=
+				cpu_to_le32(MR_DCMD_LD_MAP_GET_INFO))) {
+			instance->instancet->fire_cmd(instance,
+				req_desc->u.low, req_desc->u.high,
+				instance->reg_set);
+		} else
+			megasas_return_cmd(instance, cmd_mfi);
+	}
+}
+
 /* Check for a second path that is currently UP */
 int megasas_check_mpio_paths(struct megasas_instance *instance,
 	struct scsi_cmnd *scmd)
@@ -2535,12 +2612,10 @@ out:
 /* Core fusion reset function */
 int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 {
-	int retval = SUCCESS, i, j, retry = 0, convert = 0;
+	int retval = SUCCESS, i, retry = 0, convert = 0;
 	struct megasas_instance *instance;
 	struct megasas_cmd_fusion *cmd_fusion;
 	struct fusion_context *fusion;
-	struct megasas_cmd *cmd_mfi;
-	union MEGASAS_REQUEST_DESCRIPTOR_UNION *req_desc;
 	u32 host_diag, abs_state, status_reg, reset_adapter;
 	u32 io_timeout_in_crash_mode = 0;
 
@@ -2787,44 +2862,7 @@ int megasas_reset_fusion(struct Scsi_Host *shost, int iotimeout)
 				continue;
 			}
 
-			/* Re-fire management commands */
-			for (j = 0 ; j < instance->max_fw_cmds; j++) {
-				cmd_fusion = fusion->cmd_list[j];
-				if (cmd_fusion->sync_cmd_idx !=
-				    (u32)ULONG_MAX) {
-					cmd_mfi =
-					instance->
-					cmd_list[cmd_fusion->sync_cmd_idx];
-					if (cmd_mfi->frame->dcmd.opcode ==
-					    cpu_to_le32(MR_DCMD_LD_MAP_GET_INFO)) {
-						megasas_return_mfi_mpt_pthr(instance, cmd_mfi, cmd_fusion);
-					} else  {
-						req_desc =
-						megasas_get_request_descriptor(
-							instance,
-							cmd_mfi->context.smid
-							-1);
-						if (!req_desc) {
-							printk(KERN_WARNING
-							       "req_desc NULL"
-							       " for scsi%d\n",
-								instance->host->host_no);
-							/* Return leaked MPT
-							   frame */
-							megasas_return_cmd_fusion(instance, cmd_fusion);
-						} else {
-							instance->instancet->
-							fire_cmd(instance,
-								 req_desc->
-								 u.low,
-								 req_desc->
-								 u.high,
-								 instance->
-								 reg_set);
-						}
-					}
-				}
-			}
+			megasas_refire_mgmt_cmd(instance);
 
 			if (megasas_get_ctrl_info(instance)) {
 				dev_info(&instance->pdev->dev,
-- 
1.7.1

