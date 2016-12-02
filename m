From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] mpt3sas: switch to pci_alloc_irq_vectors
Date: Fri,  2 Dec 2016 12:53:27 +0100
Message-ID: <1480679607-79306-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55848 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752144AbcLBLxa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 2 Dec 2016 06:53:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Sathya Prakash <sathya.prakash@broadcom.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Cleanup the MSI-X handling allowing us to use
the PCI-layer provided vector allocation.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  | 167 +++++++----------------------------
 drivers/scsi/mpt3sas/mpt3sas_base.h  |   6 --
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   9 ++
 3 files changed, 42 insertions(+), 140 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index f00ef88..0d93cb0 100644
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
 
@@ -1818,11 +1818,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 
 	list_for_each_entry_safe(reply_q, next, &ioc->reply_queue_list, list) {
 		list_del(&reply_q->list);
-		if (smp_affinity_enable) {
-			irq_set_affinity_hint(reply_q->vector, NULL);
-			free_cpumask_var(reply_q->affinity_hint);
-		}
-		free_irq(reply_q->vector, reply_q);
+		free_irq(pci_irq_vector(ioc->pdev, reply_q->msix_index), reply_q);
 		kfree(reply_q);
 	}
 }
@@ -1831,13 +1827,13 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
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
 
@@ -1849,14 +1845,6 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
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
@@ -1865,12 +1853,11 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
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
@@ -1881,61 +1868,6 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 }
 
 /**
- * _base_assign_reply_queues - assigning msix index for each cpu
- * @ioc: per adapter object
- *
- * The enduser would need to set the affinity via /proc/irq/#/smp_affinity
- *
- * It would nice if we could call irq_set_affinity, however it is not
- * an exported symbol
- */
-static void
-_base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
-{
-	unsigned int cpu, nr_cpus, nr_msix, index = 0;
-	struct adapter_reply_queue *reply_q;
-
-	if (!_base_is_controller_msix_enabled(ioc))
-		return;
-
-	memset(ioc->cpu_msix_table, 0, ioc->cpu_msix_table_sz);
-
-	nr_cpus = num_online_cpus();
-	nr_msix = ioc->reply_queue_count = min(ioc->reply_queue_count,
-					       ioc->facts.MaxMSIxVectors);
-	if (!nr_msix)
-		return;
-
-	cpu = cpumask_first(cpu_online_mask);
-
-	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
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
-		}
-		if (smp_affinity_enable)
-			if (irq_set_affinity_hint(reply_q->vector,
-					   reply_q->affinity_hint))
-				dinitprintk(ioc, pr_info(MPT3SAS_FMT
-				 "Err setting affinity hint to irq vector %d\n",
-				 ioc->name, reply_q->vector));
-		index++;
-	}
-}
-
-/**
  * _base_disable_msix - disables msix
  * @ioc: per adapter object
  *
@@ -1957,7 +1889,6 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 static int
 _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 {
-	struct msix_entry *entries, *a;
 	int r;
 	int i, local_max_msix_vectors;
 	u8 try_msix = 0;
@@ -1971,9 +1902,6 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	if (_base_check_enable_msix(ioc) != 0)
 		goto try_ioapic;
 
-	ioc->reply_queue_count = min_t(int, ioc->cpu_count,
-	    ioc->msix_vector_count);
-
 	printk(MPT3SAS_FMT "MSI-X vectors supported: %d, no of cores"
 	  ": %d, max_msix_vectors: %d\n", ioc->name, ioc->msix_vector_count,
 	  ioc->cpu_count, max_msix_vectors);
@@ -1984,55 +1912,44 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 		local_max_msix_vectors = max_msix_vectors;
 
 	if (local_max_msix_vectors > 0) {
-		ioc->reply_queue_count = min_t(int, local_max_msix_vectors,
+		ioc->msix_vector_count = min_t(int, local_max_msix_vectors,
 			ioc->reply_queue_count);
-		ioc->msix_vector_count = ioc->reply_queue_count;
 	} else if (local_max_msix_vectors == 0)
 		goto try_ioapic;
 
-	if (ioc->msix_vector_count < ioc->cpu_count)
-		smp_affinity_enable = 0;
-
-	entries = kcalloc(ioc->reply_queue_count, sizeof(struct msix_entry),
-	    GFP_KERNEL);
-	if (!entries) {
+	r = pci_alloc_irq_vectors(ioc->pdev, 1, ioc->msix_vector_count,
+				  PCI_IRQ_MSIX | PCI_IRQ_AFFINITY);
+	if (r < 0) {
 		dfailprintk(ioc, pr_info(MPT3SAS_FMT
-			"kcalloc failed @ at %s:%d/%s() !!!\n",
-			ioc->name, __FILE__, __LINE__, __func__));
-		goto try_ioapic;
-	}
-
-	for (i = 0, a = entries; i < ioc->reply_queue_count; i++, a++)
-		a->entry = i;
-
-	r = pci_enable_msix_exact(ioc->pdev, entries, ioc->reply_queue_count);
-	if (r) {
-		dfailprintk(ioc, pr_info(MPT3SAS_FMT
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
 
-	ioc->reply_queue_count = 1;
-	r = _base_request_irq(ioc, 0, ioc->pdev->irq);
+	ioc->msix_vector_count = 1;
+	r = pci_alloc_irq_vectors(ioc->pdev, 1, 1, PCI_IRQ_LEGACY);
+	if (r < 0) {
+		dfailprintk(ioc, pr_info(MPT3SAS_FMT
+			"pci_alloc_irq_vector(legacy) failed (r=%d) !!!\n",
+			ioc->name, r));
+	} else
+		r = _base_request_irq(ioc, 0);
 
 	return r;
 }
@@ -2193,7 +2110,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 		ioc->reply_post_host_index[0] = (resource_size_t __iomem *)
 		    &ioc->chip->ReplyPostHostIndex;
 
-		for (i = 1; i < ioc->cpu_msix_table_sz; i++)
+		for (i = 1; i < ioc->reply_queue_count; i++)
 			ioc->reply_post_host_index[i] =
 			(resource_size_t __iomem *)
 			((u8 __iomem *)&ioc->chip->Doorbell + (0x4000 + ((i - 1)
@@ -2203,7 +2120,8 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	list_for_each_entry(reply_q, &ioc->reply_queue_list, list)
 		pr_info(MPT3SAS_FMT "%s: IRQ %d\n",
 		    reply_q->name,  ((ioc->msix_enable) ? "PCI-MSI-X enabled" :
-		    "IO-APIC enabled"), reply_q->vector);
+		    "IO-APIC enabled"),
+		    pci_irq_vector(ioc->pdev, reply_q->msix_index));
 
 	pr_info(MPT3SAS_FMT "iomem(0x%016llx), mapped(0x%p), size(%d)\n",
 	    ioc->name, (unsigned long long)chip_phys, ioc->chip, memap_sz);
@@ -2274,10 +2192,10 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	return ioc->reply + (phys_addr - (u32)ioc->reply_dma);
 }
 
-static inline u8
+static inline u16
 _base_get_msix_index(struct MPT3SAS_ADAPTER *ioc)
 {
-	return ioc->cpu_msix_table[raw_smp_processor_id()];
+	return pci_irq_get_affinity_vector(ioc->pdev, raw_smp_processor_id());
 }
 
 /**
@@ -4506,7 +4424,7 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	mpi_request.HeaderVersion = cpu_to_le16(MPI2_HEADER_VERSION);
 
 	if (_base_is_controller_msix_enabled(ioc))
-		mpi_request.HostMSIxVectors = ioc->reply_queue_count;
+		mpi_request.HostMSIxVectors = ioc->msix_vector_count;
 	mpi_request.SystemRequestFrameSize = cpu_to_le16(ioc->request_sz/4);
 	mpi_request.ReplyDescriptorPostQueueDepth =
 	    cpu_to_le16(ioc->reply_post_queue_depth);
@@ -5192,10 +5110,6 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	    ioc->reply_sz)
 		ioc->reply_free[i] = cpu_to_le32(reply_address);
 
-	/* initialize reply queues */
-	if (ioc->is_driver_loading)
-		_base_assign_reply_queues(ioc);
-
 	/* initialize Reply Post Free Queue */
 	index = 0;
 	reply_post_free_contig = ioc->reply_post[0].reply_post_free;
@@ -5313,32 +5227,19 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 {
 	int r, i;
-	int cpu_id, last_cpu_id = 0;
 
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
 	    __func__));
 
-	/* setup cpu_msix_table */
+	ioc->reply_queue_count = num_possible_cpus();
 	ioc->cpu_count = num_online_cpus();
-	for_each_online_cpu(cpu_id)
-		last_cpu_id = cpu_id;
-	ioc->cpu_msix_table_sz = last_cpu_id + 1;
-	ioc->cpu_msix_table = kzalloc(ioc->cpu_msix_table_sz, GFP_KERNEL);
-	ioc->reply_queue_count = 1;
-	if (!ioc->cpu_msix_table) {
-		dfailprintk(ioc, pr_info(MPT3SAS_FMT
-			"allocation for cpu_msix_table failed!!!\n",
-			ioc->name));
-		r = -ENOMEM;
-		goto out_free_resources;
-	}
-
 	if (ioc->is_warpdrive) {
-		ioc->reply_post_host_index = kcalloc(ioc->cpu_msix_table_sz,
+		ioc->reply_post_host_index = kcalloc(ioc->reply_queue_count,
 		    sizeof(resource_size_t *), GFP_KERNEL);
 		if (!ioc->reply_post_host_index) {
 			dfailprintk(ioc, pr_info(MPT3SAS_FMT "allocation "
-				"for cpu_msix_table failed!!!\n", ioc->name));
+				"for reply_post_host_index failed!!!\n",
+				ioc->name));
 			r = -ENOMEM;
 			goto out_free_resources;
 		}
@@ -5531,7 +5432,6 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	mpt3sas_base_free_resources(ioc);
 	_base_release_memory_pools(ioc);
 	pci_set_drvdata(ioc->pdev, NULL);
-	kfree(ioc->cpu_msix_table);
 	if (ioc->is_warpdrive)
 		kfree(ioc->reply_post_host_index);
 	kfree(ioc->pd_handles);
@@ -5574,7 +5474,6 @@ static int mpt3sas_remove_dead_ioc_func(void *arg)
 	mpt3sas_base_free_resources(ioc);
 	_base_release_memory_pools(ioc);
 	pci_set_drvdata(ioc->pdev, NULL);
-	kfree(ioc->cpu_msix_table);
 	if (ioc->is_warpdrive)
 		kfree(ioc->reply_post_host_index);
 	kfree(ioc->pd_handles);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 8de0eda..5095abc 100644
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
 
@@ -835,8 +833,6 @@ struct reply_post_struct {
  * @start_scan_failed: means port enable failed, return's the ioc_status
  * @msix_enable: flag indicating msix is enabled
  * @msix_vector_count: number msix vectors
- * @cpu_msix_table: table for mapping cpus to msix index
- * @cpu_msix_table_sz: table size
  * @schedule_dead_ioc_flush_running_cmds: callback to flush pending commands
  * @scsi_io_cb_idx: shost generated commands
  * @tm_cb_idx: task management commands
@@ -1002,8 +998,6 @@ struct MPT3SAS_ADAPTER {
 
 	u8		msix_enable;
 	u16		msix_vector_count;
-	u8		*cpu_msix_table;
-	u16		cpu_msix_table_sz;
 	resource_size_t __iomem **reply_post_host_index;
 	u32		ioc_reset_count;
 	MPT3SAS_FLUSH_RUNNING_CMDS schedule_dead_ioc_flush_running_cmds;
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 981be7b..62b8840 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -54,6 +54,7 @@
 #include <linux/interrupt.h>
 #include <linux/aer.h>
 #include <linux/raid_class.h>
+#include <linux/blk-mq-pci.h>
 #include <asm/unaligned.h>
 
 #include "mpt3sas_base.h"
@@ -8540,6 +8541,13 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	return 1;
 }
 
+static int scsih_map_queues(struct Scsi_Host *shost)
+{
+	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
+
+	return blk_mq_pci_map_queues(&shost->tag_set, ioc->pdev, 0);
+}
+
 /* shost template for SAS 2.0 HBA devices */
 static struct scsi_host_template mpt2sas_driver_template = {
 	.module				= THIS_MODULE,
@@ -8553,6 +8561,7 @@ static void sas_device_make_active(struct MPT3SAS_ADAPTER *ioc,
 	.slave_destroy			= scsih_slave_destroy,
 	.scan_finished			= scsih_scan_finished,
 	.scan_start			= scsih_scan_start,
+	.map_queues			= scsih_map_queues,
 	.change_queue_depth		= scsih_change_queue_depth,
 	.eh_abort_handler		= scsih_abort,
 	.eh_device_reset_handler	= scsih_dev_reset,
-- 
1.8.5.6

