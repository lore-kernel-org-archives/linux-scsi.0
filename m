From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH 1/5] megaraid_sas: switch to pci_alloc_irq_vectors
Date: Fri, 11 Nov 2016 17:02:24 +0530
Message-ID: <7d5dca7d9f030cb76de03d90a8b02340@mail.gmail.com>
References: <1478857492-4581-1-git-send-email-hare@suse.de> <1478857492-4581-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f172.google.com ([209.85.161.172]:33986 "EHLO
        mail-yw0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751057AbcKKLc0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Nov 2016 06:32:26 -0500
Received: by mail-yw0-f172.google.com with SMTP id t125so8407855ywc.1
        for <linux-scsi@vger.kernel.org>; Fri, 11 Nov 2016 03:32:26 -0800 (PST)
In-Reply-To: <1478857492-4581-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>-----Original Message-----
>From: Hannes Reinecke [mailto:hare@suse.de]
>Sent: Friday, November 11, 2016 3:15 PM
>To: Martin K. Petersen
>Cc: Christoph Hellwig; James Bottomley; Sumit Saxena; linux-
>scsi@vger.kernel.org; Hannes Reinecke; Hannes Reinecke
>Subject: [PATCH 1/5] megaraid_sas: switch to pci_alloc_irq_vectors
>
>Cleanup the MSI-X handling allowing us to use the PCI-layer provided
vector
>allocation.
>
>Signed-off-by: Hannes Reinecke <hare@suse.com>
>---
> drivers/scsi/megaraid/megaraid_sas.h      |  1 -
> drivers/scsi/megaraid/megaraid_sas_base.c | 63
++++++++++++++-----------------
> 2 files changed, 29 insertions(+), 35 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>b/drivers/scsi/megaraid/megaraid_sas.h
>index ca86c88..8f1d2b4 100644
>--- a/drivers/scsi/megaraid/megaraid_sas.h
>+++ b/drivers/scsi/megaraid/megaraid_sas.h
>@@ -2118,7 +2118,6 @@ struct megasas_instance {
> 	u32 ctrl_context_pages;
> 	struct megasas_ctrl_info *ctrl_info;
> 	unsigned int msix_vectors;
>-	struct msix_entry msixentry[MEGASAS_MAX_MSIX_QUEUES];
> 	struct megasas_irq_context
>irq_context[MEGASAS_MAX_MSIX_QUEUES];
> 	u64 map_id;
> 	u64 pd_seq_map_id;
>diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
>b/drivers/scsi/megaraid/megaraid_sas_base.c
>index 3236632..e7e3efd 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -4843,7 +4843,7 @@ int megasas_set_crash_dump_params(struct
>megasas_instance *instance,  }
>
> /*
>- * megasas_setup_irqs_msix -		register legacy interrupts.
>+ * megasas_setup_irqs_ioapic -		register legacy
interrupts.
>  * @instance:				Adapter soft state
>  *
>  * Do not enable interrupt, only setup ISRs.
>@@ -4858,8 +4858,9 @@ int megasas_set_crash_dump_params(struct
>megasas_instance *instance,
> 	pdev = instance->pdev;
> 	instance->irq_context[0].instance = instance;
> 	instance->irq_context[0].MSIxIndex = 0;
>-	if (request_irq(pdev->irq, instance->instancet->service_isr,
>-		IRQF_SHARED, "megasas", &instance->irq_context[0])) {
>+	if (request_irq(pci_irq_vector(pdev, 0),
>+			instance->instancet->service_isr, IRQF_SHARED,
>+			"megasas", &instance->irq_context[0])) {
> 		dev_err(&instance->pdev->dev,
> 				"Failed to register IRQ from %s %d\n",
> 				__func__, __LINE__);
>@@ -4880,28 +4881,23 @@ int megasas_set_crash_dump_params(struct
>megasas_instance *instance,  static int  megasas_setup_irqs_msix(struct
>megasas_instance *instance, u8 is_probe)  {
>-	int i, j, cpu;
>+	int i, j;
> 	struct pci_dev *pdev;
>
> 	pdev = instance->pdev;
>
> 	/* Try MSI-x */
>-	cpu = cpumask_first(cpu_online_mask);
> 	for (i = 0; i < instance->msix_vectors; i++) {
> 		instance->irq_context[i].instance = instance;
> 		instance->irq_context[i].MSIxIndex = i;
>-		if (request_irq(instance->msixentry[i].vector,
>+		if (request_irq(pci_irq_vector(pdev, i),
> 			instance->instancet->service_isr, 0, "megasas",
> 			&instance->irq_context[i])) {
> 			dev_err(&instance->pdev->dev,
> 				"Failed to register IRQ for vector %d.\n",
i);
>-			for (j = 0; j < i; j++) {
>-				if (smp_affinity_enable)
>-					irq_set_affinity_hint(
>-
instance->msixentry[j].vector,
>NULL);
>-				free_irq(instance->msixentry[j].vector,
>-					&instance->irq_context[j]);
>-			}
>+			for (j = 0; j < i; j++)
>+				free_irq(pci_irq_vector(pdev, j),
>+					 &instance->irq_context[j]);
> 			/* Retry irq register for IO_APIC*/
> 			instance->msix_vectors = 0;
> 			if (is_probe)
>@@ -4909,14 +4905,6 @@ int megasas_set_crash_dump_params(struct
>megasas_instance *instance,
> 			else
> 				return -1;
> 		}
>-		if (smp_affinity_enable) {
>-			if
(irq_set_affinity_hint(instance->msixentry[i].vector,
>-				get_cpu_mask(cpu)))
>-				dev_err(&instance->pdev->dev,
>-					"Failed to set affinity hint"
>-					" for cpu %d\n", cpu);
>-			cpu = cpumask_next(cpu, cpu_online_mask);
>-		}
> 	}
> 	return 0;
> }
>@@ -4933,14 +4921,12 @@ int megasas_set_crash_dump_params(struct
>megasas_instance *instance,
>
> 	if (instance->msix_vectors)
> 		for (i = 0; i < instance->msix_vectors; i++) {
>-			if (smp_affinity_enable)
>-				irq_set_affinity_hint(
>-					instance->msixentry[i].vector,
NULL);
>-			free_irq(instance->msixentry[i].vector,
>+			free_irq(pci_irq_vector(instance->pdev, i),
> 				 &instance->irq_context[i]);
> 		}
> 	else
>-		free_irq(instance->pdev->irq, &instance->irq_context[0]);
>+		free_irq(pci_irq_vector(instance->pdev, 0),
>+			 &instance->irq_context[0]);
> }
>
> /**
>@@ -5018,6 +5004,7 @@ static int megasas_init_fw(struct megasas_instance
>*instance)
> 	int i, loop, fw_msix_count = 0;
> 	struct IOV_111 *iovPtr;
> 	struct fusion_context *fusion;
>+	int irq_flags = PCI_IRQ_MSIX;
>
> 	fusion = instance->ctrl_context;
>
>@@ -5134,15 +5121,18 @@ static int megasas_init_fw(struct
megasas_instance
>*instance)
> 		/* Don't bother allocating more MSI-X vectors than cpus */
> 		instance->msix_vectors = min(instance->msix_vectors,
> 					     (unsigned
int)num_online_cpus());
>-		for (i = 0; i < instance->msix_vectors; i++)
>-			instance->msixentry[i].entry = i;
>-		i = pci_enable_msix_range(instance->pdev,
instance->msixentry,
>-					  1, instance->msix_vectors);
>+		if (smp_affinity_enable)
>+			irq_flags |= PCI_IRQ_AFFINITY;
>+		i = pci_alloc_irq_vectors(instance->pdev, 1,
>+					  instance->msix_vectors,
irq_flags);
> 		if (i > 0)
> 			instance->msix_vectors = i;
> 		else
> 			instance->msix_vectors = 0;
> 	}
>+	i = pci_alloc_irq_vectors(instance->pdev, 1, 1, PCI_IRQ_LEGACY);
>+	if (i < 0)
>+		goto fail_setup_irqs;
>
> 	dev_info(&instance->pdev->dev,
> 		"firmware supports msix\t: (%d)", fw_msix_count); @@
-5587,7
>+5577,6 @@ static int megasas_io_attach(struct megasas_instance
*instance)
> 	/*
> 	 * Export parameters required by SCSI mid-layer
> 	 */
>-	host->irq = instance->pdev->irq;
> 	host->unique_id = instance->unique_id;
> 	host->can_queue = instance->max_scsi_cmds;
> 	host->this_id = instance->init_id;
>@@ -6128,6 +6117,7 @@ static void megasas_shutdown_controller(struct
>megasas_instance *instance,
> 	int rval;
> 	struct Scsi_Host *host;
> 	struct megasas_instance *instance;
>+	int irq_flags = PCI_IRQ_LEGACY;
>
> 	instance = pci_get_drvdata(pdev);
> 	host = instance->host;
>@@ -6163,9 +6153,14 @@ static void megasas_shutdown_controller(struct
>megasas_instance *instance,
> 		goto fail_ready_state;
>
> 	/* Now re-enable MSI-X */
>-	if (instance->msix_vectors &&
>-	    pci_enable_msix_exact(instance->pdev, instance->msixentry,
>-				  instance->msix_vectors))
>+	if (instance->msix_vectors)
>+		irq_flags = PCI_IRQ_MSIX;
>+	if (smp_affinity_enable)
>+		irq_flags |= PCI_IRQ_AFFINITY;
>+	rval = pci_alloc_irq_vectors(instance->pdev, 1,
>+				     instance->msix_vectors ?
>+				     instance->msix_vectors : 1,
irq_flags);
>+	if (rval < 0)
If smp_affinity_enable parameter is set to 1(which is default) and legacy
interrupts are setup, then here driver will pass irq_flags set to
(PCI_IRQ_LEGACY | PCI_IRQ_AFFINITY) while calling function
pci_alloc_irq_vectors().
Should not driver set PCI_IRQ_AFFINITY only for MSI-x interrupts? Setting
PCI_IRQ_AFFINITY for legacy interrupts may restrict all interrupts
completion to single CPU(because IRQ affinity will be set) as there will
be single IRQ for legacy interrupts ?

> 		goto fail_reenable_msix;
>
> 	if (instance->ctrl_context) {
>--
>1.8.5.6
