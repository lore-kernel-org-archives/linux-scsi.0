From: Suganath prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: [mpt3sas driver V1 6/10] mpt3sas: Added smp_affinity_enable module  parameter.
Date: Mon,  8 Feb 2016 22:13:39 +0530
Message-ID: <1454949819-10985-1-git-send-email-suganath-prabu.subramani@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:32802 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206AbcBHQnu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2016 11:43:50 -0500
Received: by mail-pa0-f52.google.com with SMTP id cy9so76200955pac.0
        for <linux-scsi@vger.kernel.org>; Mon, 08 Feb 2016 08:43:50 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, krishnaraddi.mankani@avagotech.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@avagotech.com, chaitra.basappa@avagotech.com, sreekanth.reddy@avagotech.com

Module parameter to enable/disable configuring
affinity hint for msix vector.
SMP affinity feature can be enabled/disabled by setting
module parameter "smp_affinity_enable" to 1/0.
By default this feature is enabled. (smp_affinity_enable = 1 enabled).

Signed-off-by: Suganath prabu Subramani <suganath-prabu.subramani@avagotech.com>
Signed-off-by: Chaitra P B <chaitra.basappa@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 37 ++++++++++++++++++++++++++-----------
 1 file changed, 26 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 31838d9a..582ba4b 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -83,6 +83,10 @@ static int msix_disable = -1;
 module_param(msix_disable, int, 0);
 MODULE_PARM_DESC(msix_disable, " disable msix routed interrupts (default=0)");
 
+static int smp_affinity_enable = 1;
+module_param(smp_affinity_enable, int, S_IRUGO);
+MODULE_PARM_DESC(smp_affinity_enable, "SMP affinity feature enable/disbale Default: enable(1)");
+
 static int max_msix_vectors = -1;
 module_param(max_msix_vectors, int, 0);
 MODULE_PARM_DESC(max_msix_vectors,
@@ -1812,8 +1816,10 @@ _base_free_irq(struct MPT3SAS_ADAPTER *ioc)
 
 	list_for_each_entry_safe(reply_q, next, &ioc->reply_queue_list, list) {
 		list_del(&reply_q->list);
-		irq_set_affinity_hint(reply_q->vector, NULL);
-		free_cpumask_var(reply_q->affinity_hint);
+		if (smp_affinity_enable) {
+			irq_set_affinity_hint(reply_q->vector, NULL);
+			free_cpumask_var(reply_q->affinity_hint);
+		}
 		synchronize_irq(reply_q->vector);
 		free_irq(reply_q->vector, reply_q);
 		kfree(reply_q);
@@ -1844,9 +1850,13 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index, u32 vector)
 	reply_q->msix_index = index;
 	reply_q->vector = vector;
 
-	if (!alloc_cpumask_var(&reply_q->affinity_hint, GFP_KERNEL))
-		return -ENOMEM;
-	cpumask_clear(reply_q->affinity_hint);
+	if (smp_affinity_enable) {
+		if (!zalloc_cpumask_var(&reply_q->affinity_hint, GFP_KERNEL)) {
+			kfree(reply_q);
+			return -ENOMEM;
+		}
+		cpumask_clear(reply_q->affinity_hint);
+	}
 
 	atomic_set(&reply_q->busy, 0);
 	if (ioc->msix_enable)
@@ -1861,6 +1871,7 @@ _base_request_irq(struct MPT3SAS_ADAPTER *ioc, u8 index, u32 vector)
 		pr_err(MPT3SAS_FMT "unable to allocate interrupt %d!\n",
 		    reply_q->name, vector);
 		kfree(reply_q);
+		free_cpumask_var(reply_q->affinity_hint);
 		return -EBUSY;
 	}
 
@@ -1909,16 +1920,17 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 
 		for (i = 0 ; i < group ; i++) {
 			ioc->cpu_msix_table[cpu] = index;
-			cpumask_or(reply_q->affinity_hint,
+			if (smp_affinity_enable)
+				cpumask_or(reply_q->affinity_hint,
 				   reply_q->affinity_hint, get_cpu_mask(cpu));
 			cpu = cpumask_next(cpu, cpu_online_mask);
 		}
-
-		if (irq_set_affinity_hint(reply_q->vector,
+		if (smp_affinity_enable)
+			if (irq_set_affinity_hint(reply_q->vector,
 					   reply_q->affinity_hint))
-			dinitprintk(ioc, pr_info(MPT3SAS_FMT
-			    "error setting affinity hint for irq vector %d\n",
-			    ioc->name, reply_q->vector));
+				dinitprintk(ioc, pr_info(MPT3SAS_FMT
+				 "Err setting affinity hint to irq vector %d\n",
+				 ioc->name, reply_q->vector));
 		index++;
 	}
 }
@@ -1976,6 +1988,9 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	} else if (max_msix_vectors == 0)
 		goto try_ioapic;
 
+	if (ioc->msix_vector_count < ioc->cpu_count)
+		smp_affinity_enable = 0;
+
 	entries = kcalloc(ioc->reply_queue_count, sizeof(struct msix_entry),
 	    GFP_KERNEL);
 	if (!entries) {
-- 
1.8.3.1

