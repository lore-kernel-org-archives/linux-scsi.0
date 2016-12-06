From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: RE: [PATCH] megaraid_sas: switch to pci_alloc_irq_vectors
Date: Tue, 6 Dec 2016 19:11:42 +0530
Message-ID: <e52146c76fc211be9739a81f5678ca68@mail.gmail.com>
References: <1480679543-79236-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33448 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751752AbcLFNlo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2016 08:41:44 -0500
Received: by mail-oi0-f48.google.com with SMTP id w63so378035479oiw.0
        for <linux-scsi@vger.kernel.org>; Tue, 06 Dec 2016 05:41:44 -0800 (PST)
In-Reply-To: <1480679543-79236-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Sasikumar PC <sasikumar.pc@broadcom.com>

>-----Original Message-----
>From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>owner@vger.kernel.org] On Behalf Of Hannes Reinecke
>Sent: Friday, December 02, 2016 5:22 PM
>To: Martin K. Petersen
>Cc: Christoph Hellwig; James Bottomley; Sathya Prakash; linux-
>scsi@vger.kernel.org; Hannes Reinecke; Hannes Reinecke
>Subject: [PATCH] megaraid_sas: switch to pci_alloc_irq_vectors
>
>Signed-off-by: Hannes Reinecke <hare@suse.com>
>---
> drivers/scsi/megaraid/megaraid_sas.h      |  1 -
> drivers/scsi/megaraid/megaraid_sas_base.c | 78
+++++++++++++++----------------
> 2 files changed, 38 insertions(+), 41 deletions(-)
>
>diff --git a/drivers/scsi/megaraid/megaraid_sas.h
>b/drivers/scsi/megaraid/megaraid_sas.h
>index 74c7b44..757ddda 100644
>--- a/drivers/scsi/megaraid/megaraid_sas.h
>+++ b/drivers/scsi/megaraid/megaraid_sas.h
>@@ -2120,7 +2120,6 @@ struct megasas_instance {
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
>index 5462676..692f40a 100644
>--- a/drivers/scsi/megaraid/megaraid_sas_base.c
>+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
>@@ -4837,7 +4837,7 @@ int megasas_set_crash_dump_params(struct
>megasas_instance *instance,  }
>
> /*
>- * megasas_setup_irqs_msix -		register legacy interrupts.
>+ * megasas_setup_irqs_ioapic -		register legacy
interrupts.
>  * @instance:				Adapter soft state
>  *
>  * Do not enable interrupt, only setup ISRs.
>@@ -4852,8 +4852,9 @@ int megasas_set_crash_dump_params(struct
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
>@@ -4874,28 +4875,23 @@ int megasas_set_crash_dump_params(struct
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
>@@ -4903,14 +4899,6 @@ int megasas_set_crash_dump_params(struct
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
>@@ -4927,14 +4915,12 @@ int megasas_set_crash_dump_params(struct
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
>@@ -5092,6 +5078,8 @@ static int megasas_init_fw(struct megasas_instance
>*instance)
> 	msix_enable = (instance->instancet->read_fw_status_reg(reg_set) &
> 		       0x4000000) >> 0x1a;
> 	if (msix_enable && !msix_disable) {
>+		int irq_flags = PCI_IRQ_MSIX;
>+
> 		scratch_pad_2 = readl
> 			(&instance->reg_set->outbound_scratch_pad_2);
> 		/* Check max MSI-X vectors */
>@@ -5128,15 +5116,18 @@ static int megasas_init_fw(struct
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
-5307,10
>+5298,11 @@ static int megasas_init_fw(struct megasas_instance *instance)
>
> fail_get_pd_list:
> 	instance->instancet->disable_intr(instance);
>-	megasas_destroy_irqs(instance);
> fail_init_adapter:
>+	megasas_destroy_irqs(instance);
>+fail_setup_irqs:
> 	if (instance->msix_vectors)
>-		pci_disable_msix(instance->pdev);
>+		pci_free_irq_vectors(instance->pdev);
> 	instance->msix_vectors = 0;
> fail_ready_state:
> 	kfree(instance->ctrl_info);
>@@ -5579,7 +5571,6 @@ static int megasas_io_attach(struct
megasas_instance
>*instance)
> 	/*
> 	 * Export parameters required by SCSI mid-layer
> 	 */
>-	host->irq = instance->pdev->irq;
> 	host->unique_id = instance->unique_id;
> 	host->can_queue = instance->max_scsi_cmds;
> 	host->this_id = instance->init_id;
>@@ -5942,7 +5933,7 @@ static int megasas_probe_one(struct pci_dev *pdev,
> 	else
> 		megasas_release_mfi(instance);
> 	if (instance->msix_vectors)
>-		pci_disable_msix(instance->pdev);
>+		pci_free_irq_vectors(instance->pdev);
> fail_init_mfi:
> fail_alloc_dma_buf:
> 	if (instance->evt_detail)
>@@ -6100,7 +6091,7 @@ static void megasas_shutdown_controller(struct
>megasas_instance *instance,
> 	megasas_destroy_irqs(instance);
>
> 	if (instance->msix_vectors)
>-		pci_disable_msix(instance->pdev);
>+		pci_free_irq_vectors(instance->pdev);
>
> 	pci_save_state(pdev);
> 	pci_disable_device(pdev);
>@@ -6120,6 +6111,7 @@ static void megasas_shutdown_controller(struct
>megasas_instance *instance,
> 	int rval;
> 	struct Scsi_Host *host;
> 	struct megasas_instance *instance;
>+	int irq_flags = PCI_IRQ_LEGACY;
>
> 	instance = pci_get_drvdata(pdev);
> 	host = instance->host;
>@@ -6155,9 +6147,15 @@ static void megasas_shutdown_controller(struct
>megasas_instance *instance,
> 		goto fail_ready_state;
>
> 	/* Now re-enable MSI-X */
>-	if (instance->msix_vectors &&
>-	    pci_enable_msix_exact(instance->pdev, instance->msixentry,
>-				  instance->msix_vectors))
>+	if (instance->msix_vectors) {
>+		irq_flags = PCI_IRQ_MSIX;
>+		if (smp_affinity_enable)
>+		    irq_flags |= PCI_IRQ_AFFINITY;
>+	}
>+	rval = pci_alloc_irq_vectors(instance->pdev, 1,
>+				     instance->msix_vectors ?
>+				     instance->msix_vectors : 1,
irq_flags);
>+	if (rval < 0)
> 		goto fail_reenable_msix;
>
> 	if (instance->ctrl_context) {
>@@ -6330,7 +6328,7 @@ static void megasas_detach_one(struct pci_dev
*pdev)
> 	megasas_destroy_irqs(instance);
>
> 	if (instance->msix_vectors)
>-		pci_disable_msix(instance->pdev);
>+		pci_free_irq_vectors(instance->pdev);
>
> 	if (instance->ctrl_context) {
> 		megasas_release_fusion(instance);
>@@ -6425,7 +6423,7 @@ static void megasas_shutdown(struct pci_dev *pdev)
> 	megasas_destroy_irqs(instance);
>
> 	if (instance->msix_vectors)
>-		pci_disable_msix(instance->pdev);
>+		pci_free_irq_vectors(instance->pdev);
> }
>
Looks good to me. There are few patches for megaraid_sas pending posted by
Sasikumar so either you have to rebase this patch once Sasi's patches are
committed
Or Sasi has to rebase his patches once this patch are applied. If you are
ok,  then I can post this patch once Sasi's patches are committed.

Acked by: Sumit Saxena<sumit.saxena@broadcom.com>

> /**
>--
>1.8.5.6
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of
>a message to majordomo@vger.kernel.org More majordomo info at
>http://vger.kernel.org/majordomo-info.html
