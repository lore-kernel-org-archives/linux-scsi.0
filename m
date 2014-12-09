From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: RE: [PATCH 09/22] [SCSI] mpt2sas, mpt3sas: Added a support to set cpu affinity for each MSIX vector enabled by the HBA
Date: Tue,  9 Dec 2014 17:46:41 +0530
Message-ID: <1418127401-10090-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

> Wouldn't it be better to do this in _base_assign_reply_queues since
> we're already iterating there?

Hi Martin,

As per your suggestion, I modified this feature with below changes.

Added a support to set cpu affinity mask for each MSIX vector enabled by the HBA.
So that, runnig the irqbalancer will balance interrupts among the cpus.

Change_set:
1. Added affinity_hint varable of type cpumask_var_t in adapter_reply_queue
   structure. And allocated a memory for this varable by calling zalloc_cpumask_var.
2. Call the API irq_set_affinity_hint for each MSIx vector to affiniate it
   with calculated cpus at driver inilization time.
3. While freeing the MSIX vector, call this same API to release the cpu affinity mask
   for each MSIx vector by providing the NULL value in cpumask argument.
4. then call the free_cpumask_var API to free the memory allocated in step 2.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c |   23 ++++++++++++++++++++---
 drivers/scsi/mpt2sas/mpt2sas_base.h |    1 +
 drivers/scsi/mpt3sas/mpt3sas_base.c |   23 ++++++++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.h |    1 +
 4 files changed, 42 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 58e4521..c58df3d 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1296,6 +1296,8 @@ _base_free_irq(struct MPT2SAS_ADAPTER *ioc)
 
 	list_for_each_entry_safe(reply_q, next, &ioc->reply_queue_list, list) {
 		list_del(&reply_q->list);
+		irq_set_affinity_hint(reply_q->vector, NULL);
+		free_cpumask_var(reply_q->affinity_hint);
 		synchronize_irq(reply_q->vector);
 		free_irq(reply_q->vector, reply_q);
 		kfree(reply_q);
@@ -1325,6 +1327,10 @@ _base_request_irq(struct MPT2SAS_ADAPTER *ioc, u8 index, u32 vector)
 	reply_q->ioc = ioc;
 	reply_q->msix_index = index;
 	reply_q->vector = vector;
+
+	if (!zalloc_cpumask_var(&reply_q->affinity_hint, GFP_KERNEL))
+		return -ENOMEM;
+
 	atomic_set(&reply_q->busy, 0);
 	if (ioc->msix_enable)
 		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d-msix%d",
@@ -1359,6 +1365,7 @@ static void
 _base_assign_reply_queues(struct MPT2SAS_ADAPTER *ioc)
 {
 	unsigned int cpu, nr_cpus, nr_msix, index = 0;
+	struct adapter_reply_queue *reply_q;
 
 	if (!_base_is_controller_msix_enabled(ioc))
 		return;
@@ -1373,20 +1380,30 @@ _base_assign_reply_queues(struct MPT2SAS_ADAPTER *ioc)
 
 	cpu = cpumask_first(cpu_online_mask);
 
-	do {
+	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
+
 		unsigned int i, group = nr_cpus / nr_msix;
+
+		if (cpu >= nr_cpus)
+			break;
 
 		if (index < nr_cpus % nr_msix)
 			group++;
 
 		for (i = 0 ; i < group ; i++) {
 			ioc->cpu_msix_table[cpu] = index;
+			cpumask_or(reply_q->affinity_hint,
+				   reply_q->affinity_hint, get_cpu_mask(cpu));
 			cpu = cpumask_next(cpu, cpu_online_mask);
 		}
 
+		if (irq_set_affinity_hint(reply_q->vector,
+					   reply_q->affinity_hint))
+			dinitprintk(ioc, pr_info(MPT2SAS_FMT
+			    "error setting affinity hint for irq vector %d\n",
+			    ioc->name, reply_q->vector));
 		index++;
-
-	} while (cpu < nr_cpus);
+	}
 }
 
 /**
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 239f169..295f98c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -586,6 +586,7 @@ struct adapter_reply_queue {
 	Mpi2ReplyDescriptorsUnion_t *reply_post_free;
 	char			name[MPT_NAME_LENGTH];
 	atomic_t		busy;
+	cpumask_var_t		affinity_hint;
 	struct list_head	list;
 };
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 1560115..f0f8ba0 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1580,6 +1580,8 @@ _base_free_irq(struct MPT3SAS_ADAPTER *ioc)
 
 	list_for_each_entry_safe(reply_q, next, &ioc->reply_queue_list, list) {
 		list_del(&reply_q->list);
+		irq_set_affinity_hint(reply_q->vector, NULL);
+		free_cpumask_var(reply_q->affinity_hint);
 		synchronize_irq(reply_q->vector);
 		free_irq(reply_q->vector, reply_q);
 		kfree(reply_q);
@@ -1609,6 +1611,10 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index, u32 vector)
 	reply_q->ioc = ioc;
 	reply_q->msix_index = index;
 	reply_q->vector = vector;
+
+	if (!zalloc_cpumask_var(&reply_q->affinity_hint, GFP_KERNEL))
+		return -ENOMEM;
+
 	atomic_set(&reply_q->busy, 0);
 	if (ioc->msix_enable)
 		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d-msix%d",
@@ -1643,6 +1649,7 @@ static void
 _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 {
 	unsigned int cpu, nr_cpus, nr_msix, index = 0;
+	struct adapter_reply_queue *reply_q;
 
 	if (!_base_is_controller_msix_enabled(ioc))
 		return;
@@ -1657,20 +1664,30 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 
 	cpu = cpumask_first(cpu_online_mask);
 
-	do {
+	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
+
 		unsigned int i, group = nr_cpus / nr_msix;
+
+		if (cpu >= nr_cpus)
+			break;
 
 		if (index < nr_cpus % nr_msix)
 			group++;
 
 		for (i = 0 ; i < group ; i++) {
 			ioc->cpu_msix_table[cpu] = index;
+			cpumask_or(reply_q->affinity_hint,
+				   reply_q->affinity_hint, get_cpu_mask(cpu));
 			cpu = cpumask_next(cpu, cpu_online_mask);
 		}
 
+		if (irq_set_affinity_hint(reply_q->vector,
+					   reply_q->affinity_hint))
+			dinitprintk(ioc, pr_info(MPT3SAS_FMT
+			    "error setting affinity hint for irq vector %d\n",
+			    ioc->name, reply_q->vector));
 		index++;
-
-	} while (cpu < nr_cpus);
+	}
 }
 
 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 40926aa..fee37b7 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -506,6 +506,7 @@ struct adapter_reply_queue {
 	Mpi2ReplyDescriptorsUnion_t *reply_post_free;
 	char			name[MPT_NAME_LENGTH];
 	atomic_t		busy;
+	cpumask_var_t		affinity_hint;
 	struct list_head	list;
 };
 
-- 
1.7.1
