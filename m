From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 01/07] [SCSI] mpt2sas : Better handling DEAD IOC (PCI-E
 LInk down) error condition
Date: Thu, 1 Dec 2011 07:42:04 +0530
Message-ID: <201112010918.pB19IXlE017973@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:37637 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751622Ab1LAJSh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Dec 2011 04:18:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, kashyap.desai@lsi.com, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: JBottomley@parallels.com

Better handling DEAD IOC (PCI-E LInk down) error condition
Detection of Dead IOC has been done in fault_reset_work thread.

If IOC Doorbell is 0xFFFFFFFF, it will be detected as non-operation/DEAD IOC.
When a DEAD IOC is detected, the code is modified to remove that IOC and 
all its attached devices from OS. 
The PCI layer API pci_remove_bus_device() is called to remove the dead IOC.


Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 54b70ae..6c0d8f6 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -58,6 +58,7 @@
 #include <linux/sort.h>
 #include <linux/io.h>
 #include <linux/time.h>
+#include <linux/kthread.h>
 #include <linux/aer.h>
 
 #include "mpt2sas_base.h"
@@ -121,10 +122,34 @@ _scsih_set_fwfault_debug(const char *val, struct kernel_param *kp)
 		ioc->fwfault_debug = mpt2sas_fwfault_debug;
 	return 0;
 }
+
 module_param_call(mpt2sas_fwfault_debug, _scsih_set_fwfault_debug,
     param_get_int, &mpt2sas_fwfault_debug, 0644);
 
 /**
+ *  mpt2sas_remove_dead_ioc_func - kthread context to remove dead ioc
+ * @arg: input argument, used to derive ioc
+ *
+ * Return 0 if controller is removed from pci subsystem.
+ * Return -1 for other case.
+ */
+static int mpt2sas_remove_dead_ioc_func(void *arg)
+{
+		struct MPT2SAS_ADAPTER *ioc = (struct MPT2SAS_ADAPTER *)arg;
+		struct pci_dev *pdev;
+
+		if ((ioc == NULL))
+			return -1;
+
+		pdev = ioc->pdev;
+		if ((pdev == NULL))
+			return -1;
+		pci_remove_bus_device(pdev);
+		return 0;
+}
+
+
+/**
  * _base_fault_reset_work - workq handling ioc fault conditions
  * @work: input argument, used to derive ioc
  * Context: sleep.
@@ -139,6 +164,7 @@ _base_fault_reset_work(struct work_struct *work)
 	unsigned long	 flags;
 	u32 doorbell;
 	int rc;
+	struct task_struct *p;
 
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
 	if (ioc->shost_recovery)
@@ -146,6 +172,39 @@ _base_fault_reset_work(struct work_struct *work)
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 
 	doorbell = mpt2sas_base_get_iocstate(ioc, 0);
+	if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_MASK) {
+		printk(MPT2SAS_INFO_FMT "%s : SAS host is non-operational !!!!\n",
+			ioc->name, __func__);
+
+		/*
+		 * Call _scsih_flush_pending_cmds callback so that we flush all
+		 * pending commands back to OS. This call is required to aovid
+		 * deadlock at block layer. Dead IOC will fail to do diag reset,
+		 * and this call is safe since dead ioc will never return any
+		 * command back from HW.
+		 */
+		ioc->schedule_dead_ioc_flush_running_cmds(ioc);
+		/*
+		 * Set remove_host flag early since kernel thread will
+		 * take some time to execute.
+		 */
+		ioc->remove_host = 1;
+		/*Remove the Dead Host */
+		p = kthread_run(mpt2sas_remove_dead_ioc_func, ioc,
+		    "mpt2sas_dead_ioc_%d", ioc->id);
+		if (IS_ERR(p)) {
+			printk(MPT2SAS_ERR_FMT
+			"%s: Running mpt2sas_dead_ioc thread failed !!!!\n",
+			ioc->name, __func__);
+		} else {
+		    printk(MPT2SAS_ERR_FMT
+			"%s: Running mpt2sas_dead_ioc thread success !!!!\n",
+			ioc->name, __func__);
+		}
+
+		return; /* don't rearm timer */
+	}
+
 	if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
 		rc = mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 		    FORCE_BIG_HAMMER);
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 3c3babc..61e5b24 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -623,6 +623,7 @@ enum mutex_type {
 	TM_MUTEX_ON = 1,
 };
 
+typedef void (*MPT2SAS_FLUSH_RUNNING_CMDS)(struct MPT2SAS_ADAPTER *ioc);
 /**
  * struct MPT2SAS_ADAPTER - per adapter struct
  * @list: ioc_list
@@ -665,6 +666,7 @@ enum mutex_type {
  * @msix_vector_count: number msix vectors
  * @cpu_msix_table: table for mapping cpus to msix index
  * @cpu_msix_table_sz: table size
+ * @schedule_dead_ioc_flush_running_cmds: callback to flush pending commands
  * @scsi_io_cb_idx: shost generated commands
  * @tm_cb_idx: task management commands
  * @scsih_cb_idx: scsih internal commands
@@ -816,6 +818,7 @@ struct MPT2SAS_ADAPTER {
 	resource_size_t	**reply_post_host_index;
 	u16		cpu_msix_table_sz;
 	u32		ioc_reset_count;
+	MPT2SAS_FLUSH_RUNNING_CMDS schedule_dead_ioc_flush_running_cmds;
 
 	/* internal commands, callback index */
 	u8		scsi_io_cb_idx;
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 341240f..447a769 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -7924,6 +7924,7 @@ _scsih_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	ioc->tm_tr_volume_cb_idx = tm_tr_volume_cb_idx;
 	ioc->tm_sas_control_cb_idx = tm_sas_control_cb_idx;
 	ioc->logging_level = logging_level;
+	ioc->schedule_dead_ioc_flush_running_cmds = &_scsih_flush_running_cmds;
 	/* misc semaphores and spin locks */
 	mutex_init(&ioc->reset_in_progress_mutex);
 	spin_lock_init(&ioc->ioc_reset_in_progress_lock);
