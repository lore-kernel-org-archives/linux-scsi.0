From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: RE: [PATCH 09/22] [SCSI] mpt2sas, mpt3sas: Added a support to set cpu affinity for each MSIX vector enabled by the HBA
Date: Wed,  7 Jan 2015 18:25:29 +0530
Message-ID: <1420635329-2268-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og120.obsmtp.com ([64.18.2.18]:60067 "EHLO
	exprod7og120.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006AbbAGMz4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2015 07:55:56 -0500
Received: by mail-pa0-f47.google.com with SMTP id kq14so4718385pab.6
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jan 2015 04:55:55 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@kernel.org, hch@infradead.org
Cc: linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Elliott@hp.com, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Martin,
I have kept yours CPUs affinity with reply queues logic as it is. I have just replaced
do while loop  with list_for_each_entry loop over reply queues and it doesn't yours 
CPUs affinity with reply queues logic, I am confident on it since I have tested this code
in veriour senarioes i.e when CPUs are non power of two, when CPUs are greater than
reply_ques etc and the things are working properly.

Robert:
In this patch I have replaced zalloc_cpumask_var() API with alloc_cpumask_var() API.

Added a support to set cpu affinity mask for each MSIX vector enabled by the HBA.
So that, running the irqbalancer will balance interrupts among the cpus.

Change_set:
1. Added affinity_hint varable of type cpumask_var_t in adapter_reply_queue
   structure. And allocated a memory for this varable by calling alloc_cpumask_var.
2. Call the API irq_set_affinity_hint for each MSIx vector to affiniate it
   with calculated cpus at driver inilization time.
3. While freeing the MSIX vector, call this same API to release the cpu affinity mask
   for each MSIx vector by providing the NULL value in cpumask argument.
4. then call the free_cpumask_var API to free the memory allocated in step 2.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c | 24 +++++++++++++++++++++---
 drivers/scsi/mpt2sas/mpt2sas_base.h |  1 +
 drivers/scsi/mpt3sas/mpt3sas_base.c | 24 +++++++++++++++++++++---
 drivers/scsi/mpt3sas/mpt3sas_base.h |  1 +
 4 files changed, 44 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 137862c..599606b 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1300,6 +1300,8 @@ _base_free_irq(struct MPT2SAS_ADAPTER *ioc)
 
 	list_for_each_entry_safe(reply_q, next, &ioc->reply_queue_list, list) {
 		list_del(&reply_q->list);
+		irq_set_affinity_hint(reply_q->vector, NULL);
+		free_cpumask_var(reply_q->affinity_hint);
 		synchronize_irq(reply_q->vector);
 		free_irq(reply_q->vector, reply_q);
 		kfree(reply_q);
@@ -1329,6 +1331,11 @@ _base_request_irq(struct MPT2SAS_ADAPTER *ioc, u8 index, u32 vector)
 	reply_q->ioc = ioc;
 	reply_q->msix_index = index;
 	reply_q->vector = vector;
+
+	if (!alloc_cpumask_var(&reply_q->affinity_hint, GFP_KERNEL))
+		return -ENOMEM;
+	cpumask_clear(reply_q->affinity_hint);
+
 	atomic_set(&reply_q->busy, 0);
 	if (ioc->msix_enable)
 		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d-msix%d",
@@ -1363,6 +1370,7 @@ static void
 _base_assign_reply_queues(struct MPT2SAS_ADAPTER *ioc)
 {
 	unsigned int cpu, nr_cpus, nr_msix, index = 0;
+	struct adapter_reply_queue *reply_q;
 
 	if (!_base_is_controller_msix_enabled(ioc))
 		return;
@@ -1377,20 +1385,30 @@ _base_assign_reply_queues(struct MPT2SAS_ADAPTER *ioc)
 
 	cpu = cpumask_first(cpu_online_mask);
 
-	do {
+	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
+
 		unsigned int i, group = nr_cpus / nr_msix;
 
+		if (cpu >= nr_cpus)
+			break;
+
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
index 72bffec..46e8d51 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -587,6 +587,7 @@ struct adapter_reply_queue {
 	Mpi2ReplyDescriptorsUnion_t *reply_post_free;
 	char			name[MPT_NAME_LENGTH];
 	atomic_t		busy;
+	cpumask_var_t		affinity_hint;
 	struct list_head	list;
 };
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 961bd9d..4f6fb88 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1584,6 +1584,8 @@ _base_free_irq(struct MPT3SAS_ADAPTER *ioc)
 
 	list_for_each_entry_safe(reply_q, next, &ioc->reply_queue_list, list) {
 		list_del(&reply_q->list);
+		irq_set_affinity_hint(reply_q->vector, NULL);
+		free_cpumask_var(reply_q->affinity_hint);
 		synchronize_irq(reply_q->vector);
 		free_irq(reply_q->vector, reply_q);
 		kfree(reply_q);
@@ -1613,6 +1615,11 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index, u32 vector)
 	reply_q->ioc = ioc;
 	reply_q->msix_index = index;
 	reply_q->vector = vector;
+
+	if (!alloc_cpumask_var(&reply_q->affinity_hint, GFP_KERNEL))
+		return -ENOMEM;
+	cpumask_clear(reply_q->affinity_hint);
+
 	atomic_set(&reply_q->busy, 0);
 	if (ioc->msix_enable)
 		snprintf(reply_q->name, MPT_NAME_LENGTH, "%s%d-msix%d",
@@ -1647,6 +1654,7 @@ static void
 _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 {
 	unsigned int cpu, nr_cpus, nr_msix, index = 0;
+	struct adapter_reply_queue *reply_q;
 
 	if (!_base_is_controller_msix_enabled(ioc))
 		return;
@@ -1661,20 +1669,30 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 
 	cpu = cpumask_first(cpu_online_mask);
 
-	do {
+	list_for_each_entry(reply_q, &ioc->reply_queue_list, list) {
+
 		unsigned int i, group = nr_cpus / nr_msix;
 
+		if (cpu >= nr_cpus)
+			break;
+
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
index 7e9f55b..afa8816 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -507,6 +507,7 @@ struct adapter_reply_queue {
 	Mpi2ReplyDescriptorsUnion_t *reply_post_free;
 	char			name[MPT_NAME_LENGTH];
 	atomic_t		busy;
+	cpumask_var_t		affinity_hint;
 	struct list_head	list;
 };
 
-- 
2.0.2

