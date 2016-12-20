From: Hannes Reinecke <hare@suse.de>
Subject: [PATCHv2] mpt3sas: switch to pci_alloc_irq_vectors
Date: Tue, 20 Dec 2016 14:27:01 +0100
Message-ID: <1482240421-14847-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60552 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762158AbcLTN1G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Dec 2016 08:27:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Cleanup the MSI-X handling allowing us to use
the PCI-layer provided vector allocation.

Signed-off-by: Hannes Reinecke <hare@suse.com>

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index a1a5ceb..75149f0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1129,7 +1129,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 		/* TMs are on msix_index == 0 */
 		if (reply_q->msix_index == 0)
 			continue;
-		synchronize_irq(reply_q->vector);
+		synchronize_irq(pci_irq_vector(ioc->pdev, reply_q->msix_index));
 	}
 }
 
@@ -1818,11 +1818,8 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 
 	list_for_each_entry_safe(reply_q, next, &ioc->reply_queue_list, list) {
 		list_del(&reply_q->list);
-		if (smp_affinity_enable) {
-			irq_set_affinity_hint(reply_q->vector, NULL);
-			free_cpumask_var(reply_q->affinity_hint);
-		}
-		free_irq(reply_q->vector, reply_q);
+		free_irq(pci_irq_vector(ioc->pdev, reply_q->msix_index),
+			 reply_q);
 		kfree(reply_q);
 	}
 }
@@ -1831,13 +1828,13 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
  * _base_request_irq - request irq
  * @ioc: per adapter object
  * @index: msix index into vector table
- * @vector: irq vector
  *
  * Inserting respective reply_queue into the list.
  */
 static int
-_base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index, u32 vector)
+_base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index)
 {
+	struct pci_dev *pdev = ioc->pdev;
 	struct adapter_reply_queue *reply_q;
 	int r;
 
@@ -1849,14 +1846,6 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	}
 	reply_q->ioc = ioc;
 	reply_q->msix_index = index;
-	reply_q->vector = vector;
-
-	if (smp_affinity_enable) {
-		if (!zalloc_cpumask_var(&reply_q->affinity_hint, GFP_KERNEL)) {
-			kfree(reply_q);
-			return -ENOMEM;
-		}
-	}
 
 	atomic_set(&reply_q->busy, 0);
 	if (ioc->msix_enable)
@@ -1865,12 +1854,11 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	else
 		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d",
 		    ioc->driver_name, ioc->id);
-	r = request_irq(vector, _base_interrupt, IRQF_SHARED, reply_q->name,
-	    reply_q);
+	r = request_irq(pci_irq_vector(pdev, index), _base_interrupt,
+			IRQF_SHARED, reply_q->name, reply_q);
 	if (r) {
 		pr_err(MPT3SAS_FMT "unable to allocate interrupt %d!\n",
-		    reply_q->name, vector);
-		free_cpumask_var(reply_q->affinity_hint);
+		       reply_q->name, pci_irq_vector(pdev, index));
 		kfree(reply_q);
 		return -EBUSY;
 	}
@@ -1892,7 +1880,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 static void
 _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 {
-	unsigned int cpu, nr_cpus, nr_msix, index = 0;
+	unsigned int cpu, nr_msix;
 	struct adapter_reply_queue *reply_q;
 
 	if (!_base_is_controller_msix_enabled(ioc))
@@ -1900,38 +1888,21 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 
 	memset(ioc->cpu_msix_table, 0, ioc->cpu_msix_table_sz);
 
-	nr_cpus = num_online_cpus();
 	nr_msix = ioc->reply_queue_count = min(ioc->reply_queue_count,
 					       ioc->facts.MaxMSIxVectors);
 	if (!nr_msix)
 		return;
-
-	cpu = cpumask_first(cpu_online_mask);
-
 	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
-
-		unsigned int i, group = nr_cpus / nr_msix;
-
-		if (cpu >= nr_cpus)
-			break;
-
-		if (index < nr_cpus % nr_msix)
-			group++;
-
-		for (i = 0 ; i < group ; i++) {
-			ioc->cpu_msix_table[cpu] = index;
-			if (smp_affinity_enable)
-				cpumask_or(reply_q->affinity_hint,
-				   reply_q->affinity_hint, get_cpu_mask(cpu));
-			cpu = cpumask_next(cpu, cpu_online_mask);
+		const cpumask_t *mask = pci_irq_get_affinity(ioc->pdev,
+						      reply_q->msix_index);
+		if (!mask) {
+			pr_warn(MPT3SAS_FMT "no affinity for msi %x\n",
+				ioc->name, reply_q->msix_index);
+			continue;
 		}
-		if (smp_affinity_enable)
-			if (irq_set_affinity_hint(reply_q->vector,
-					   reply_q->affinity_hint))
-				dinitprintk(ioc, pr_info(MPT3SAS_FMT
-				 "Err setting affinity hint to irq vector %d\n",
-				 ioc->name, reply_q->vector));
-		index++;
+
+		for_each_cpu(cpu, mask)
+			ioc->cpu_msix_table[cpu] = reply_q->msix_index;
 	}
 }
 
@@ -1957,10 +1928,10 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 static int
 _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 {
-	struct msix_entry *entries, *a;
 	int r;
 	int i;
 	u8 try_msix = 0;
+	unsigned int irq_flags = PCI_IRQ_MSIX;
 
 	if (msix_disable == -1 || msix_disable == 0)
 		try_msix = 1;
@@ -1972,7 +1943,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 		goto try_ioapic;
 
 	ioc->reply_queue_count = min_t(int, ioc->cpu_count,
-	    ioc->msix_vector_count);
+		ioc->msix_vector_count);
 
 	printk(MPT3SAS_FMT "MSI-X vectors supported: %d, no of cores"
 	  ": %d, max_msix_vectors: %d\n", ioc->name, ioc->msix_vector_count,
@@ -1991,46 +1962,42 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	if (ioc->msix_vector_count < ioc->cpu_count)
 		smp_affinity_enable = 0;
 
-	entries = kcalloc(ioc->reply_queue_count, sizeof(struct msix_entry),
-	    GFP_KERNEL);
-	if (!entries) {
-		dfailprintk(ioc, pr_info(MPT3SAS_FMT
-			"kcalloc failed @ at %s:%d/%s() !!!\n",
-			ioc->name, __FILE__, __LINE__, __func__));
-		goto try_ioapic;
-	}
-
-	for (i = 0, a = entries; i < ioc->reply_queue_count; i++, a++)
-		a->entry = i;
+	if (smp_affinity_enable)
+		irq_flags |= PCI_IRQ_AFFINITY;
 
-	r = pci_enable_msix_exact(ioc->pdev, entries, ioc->reply_queue_count);
-	if (r) {
+	r = pci_alloc_irq_vectors(ioc->pdev, 1, ioc->msix_vector_count,
+				  irq_flags);
+	if (r < 0) {
 		dfailprintk(ioc, pr_info(MPT3SAS_FMT
-			"pci_enable_msix_exact failed (r=%d) !!!\n",
+			"pci_alloc_irq_vectors failed (r=%d) !!!\n",
 			ioc->name, r));
-		kfree(entries);
 		goto try_ioapic;
 	}
 
 	ioc->msix_enable = 1;
-	for (i = 0, a = entries; i < ioc->reply_queue_count; i++, a++) {
-		r = _base_request_irq(ioc, i, a->vector);
+	ioc->msix_vector_count = r;
+	for (i = 0; i < ioc->msix_vector_count; i++) {
+		r = _base_request_irq(ioc, i);
 		if (r) {
 			_base_free_irq(ioc);
 			_base_disable_msix(ioc);
-			kfree(entries);
 			goto try_ioapic;
 		}
 	}
 
-	kfree(entries);
 	return 0;
 
 /* failback to io_apic interrupt routing */
  try_ioapic:
 
 	ioc->reply_queue_count = 1;
-	r = _base_request_irq(ioc, 0, ioc->pdev->irq);
+	r = pci_alloc_irq_vectors(ioc->pdev, 1, 1, PCI_IRQ_LEGACY);
+	if (r < 0) {
+		dfailprintk(ioc, pr_info(MPT3SAS_FMT
+			"pci_alloc_irq_vector(legacy) failed (r=%d) !!!\n",
+			ioc->name, r));
+	} else
+		r = _base_request_irq(ioc, 0);
 
 	return r;
 }
@@ -2201,7 +2168,8 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	list_for_each_entry(reply_q, &ioc->reply_queue_list, list)
 		pr_info(MPT3SAS_FMT "%s: IRQ %d\n",
 		    reply_q->name,  ((ioc->msix_enable) ? "PCI-MSI-X enabled" :
-		    "IO-APIC enabled"), reply_q->vector);
+		    "IO-APIC enabled"),
+		    pci_irq_vector(ioc->pdev, reply_q->msix_index));
 
 	pr_info(MPT3SAS_FMT "iomem(0x%016llx), mapped(0x%p), size(%d)\n",
 	    ioc->name, (unsigned long long)chip_phys, ioc->chip, memap_sz);
@@ -5245,7 +5213,8 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 		    sizeof(resource_size_t *), GFP_KERNEL);
 		if (!ioc->reply_post_host_index) {
 			dfailprintk(ioc, pr_info(MPT3SAS_FMT "allocation "
-				"for cpu_msix_table failed!!!\n", ioc->name));
+				"for reply_post_host_index failed!!!\n",
+				ioc->name));
 			r = -ENOMEM;
 			goto out_free_resources;
 		}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 3e71bc1..1187e66 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -716,12 +716,10 @@ struct _event_ack_list {
 struct adapter_reply_queue {
 	struct MPT3SAS_ADAPTER	*ioc;
 	u8			msix_index;
-	unsigned int		vector;
 	u32			reply_post_host_index;
 	Mpi2ReplyDescriptorsUnion_t *reply_post_free;
 	char			name[MPT_NAME_LENGTH];
 	atomic_t		busy;
-	cpumask_var_t		affinity_hint;
 	struct list_head	list;
 };
 
