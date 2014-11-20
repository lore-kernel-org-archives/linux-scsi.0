From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH 09/22] [SCSI] mpt2sas, mpt3sas: Added a support to set cpu affinity for each MSIX vector enabled by the HBA
Date: Thu, 20 Nov 2014 12:35:42 +0530
Message-ID: <1416467155-16869-10-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og102.obsmtp.com ([64.18.2.157]:55764 "EHLO
	exprod7og102.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbaKTHMU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Nov 2014 02:12:20 -0500
Received: by mail-pa0-f52.google.com with SMTP id eu11so1990060pac.11
        for <linux-scsi@vger.kernel.org>; Wed, 19 Nov 2014 23:12:18 -0800 (PST)
In-Reply-To: <1416467155-16869-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>

Added a support to set cpu affinity mask for each MSIX vector enabled by the HBA,
So that by runnig the irqbalancer, interrupts can be balanced among the cpus.

Change_set:
1. Call the API irq_set_affinity_hint for each MSIX vector to affiniate it with avalibale online cpus at driver inilization time.
2. At the driver unload time, call this same API to release the cpu affinity mask for each MSIx vector by providing the NULL value in cpumask argument.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c | 11 +++++++++++
 drivers/scsi/mpt3sas/mpt3sas_base.c | 11 +++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index f10ee41..7286cd2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -1301,6 +1301,7 @@ _base_free_irq(struct MPT2SAS_ADAPTER *ioc)
 	list_for_each_entry_safe(reply_q, next, &ioc->reply_queue_list, list) {
 		list_del(&reply_q->list);
 		synchronize_irq(reply_q->vector);
+		irq_set_affinity_hint(reply_q->vector, NULL);
 		free_irq(reply_q->vector, reply_q);
 		kfree(reply_q);
 	}
@@ -1419,6 +1420,7 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	int r;
 	int i;
 	u8 try_msix = 0;
+	int cpu;
 
 	if (msix_disable == -1 || msix_disable == 0)
 		try_msix = 1;
@@ -1467,6 +1469,7 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 	}
 
 	ioc->msix_enable = 1;
+	cpu = cpumask_first(cpu_online_mask);
 	for (i = 0, a = entries; i < ioc->reply_queue_count; i++, a++) {
 		r = _base_request_irq(ioc, i, a->vector);
 		if (r) {
@@ -1475,6 +1478,14 @@ _base_enable_msix(struct MPT2SAS_ADAPTER *ioc)
 			kfree(entries);
 			goto try_ioapic;
 		}
+		dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
+			"cpu %d affinity hint for vector %d\n",
+			 ioc->name,  cpu, a->vector));
+		if (irq_set_affinity_hint(a->vector, get_cpu_mask(cpu)))
+			dinitprintk(ioc, printk(MPT2SAS_INFO_FMT
+				"error setting affinity hint for cpu %d\n",
+				ioc->name,  cpu));
+		cpu = cpumask_next(cpu, cpu_online_mask);
 	}
 
 	kfree(entries);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index ce18ad2..d9f1943 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1585,6 +1585,7 @@ _base_free_irq(struct MPT3SAS_ADAPTER *ioc)
 	list_for_each_entry_safe(reply_q, next, &ioc->reply_queue_list, list) {
 		list_del(&reply_q->list);
 		synchronize_irq(reply_q->vector);
+		irq_set_affinity_hint(reply_q->vector, NULL);
 		free_irq(reply_q->vector, reply_q);
 		kfree(reply_q);
 	}
@@ -1703,6 +1704,7 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	int r;
 	int i;
 	u8 try_msix = 0;
+	int cpu;
 
 	if (msix_disable == -1 || msix_disable == 0)
 		try_msix = 1;
@@ -1752,6 +1754,7 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 	}
 
 	ioc->msix_enable = 1;
+	cpu = cpumask_first(cpu_online_mask);
 	for (i = 0, a = entries; i < ioc->reply_queue_count; i++, a++) {
 		r = _base_request_irq(ioc, i, a->vector);
 		if (r) {
@@ -1760,6 +1763,14 @@ _base_enable_msix(struct MPT3SAS_ADAPTER *ioc)
 			kfree(entries);
 			goto try_ioapic;
 		}
+		dinitprintk(ioc, pr_info(MPT3SAS_FMT
+		    "cpu %d affinity hint for vector %d\n",
+		     ioc->name,  cpu, a->vector));
+		if (irq_set_affinity_hint(a->vector, get_cpu_mask(cpu)))
+			dinitprintk(ioc, pr_info(MPT3SAS_FMT
+			     "error setting affinity hint for cpu %d\n",
+			     ioc->name,  cpu));
+		cpu = cpumask_next(cpu, cpu_online_mask);
 	}
 
 	kfree(entries);
-- 
2.0.2

