From: Joe Lawrence <Joe.Lawrence@stratus.com>
Subject: [PATCH 1/2] mptfusion, mpt2sas, mpt3sas: Don't remove dead IOC PCI
 device
Date: Mon, 4 Mar 2013 10:55:58 -0500 (EST)
Message-ID: <alpine.DEB.2.02.1303041052420.1736@jlaw-desktop.mno.stratus.com>
References: <alpine.DEB.2.02.1303041046230.1736@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailhub.stratus.com ([134.111.1.18]:53826 "EHLO
	mailhub5.stratus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754493Ab3CDQAt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Mar 2013 11:00:49 -0500
In-Reply-To: <alpine.DEB.2.02.1303041046230.1736@jlaw-desktop.mno.stratus.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: DL-MPTFusionLinux@lsi.com, support@lsi.com, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Bjorn Helgaas <bhelgaas@google.com>

Device removal/addition is a PCI core function, not an HBA function.
Calling pci_stop_and_remove_bus_device() from a SCSI LLD may introduce
device removal races with PCI hotplug.  Remove these calls from mptfusion,
mpt2sas, and mpt3sas, but leave remaining dead IOC code in place that
flushes outstanding commands and sets IOC state.

Signed-off-by: Joe Lawrence <joe.lawrence@stratus.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>
Cc: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Cc: support@lsi.com
Cc: DL-MPTFusionLinux@lsi.com
Cc: linux-scsi@vger.kernel.org
---
 drivers/message/fusion/mptbase.c    | 41 +-----------------------------------
 drivers/scsi/mpt2sas/mpt2sas_base.c | 42 ++-----------------------------------
 drivers/scsi/mpt3sas/mpt3sas_base.c | 40 ++---------------------------------
 3 files changed, 5 insertions(+), 118 deletions(-)

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index fb69baa..28a421d 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -63,7 +63,6 @@
 #ifdef CONFIG_MTRR
 #include <asm/mtrr.h>
 #endif
-#include <linux/kthread.h>
 #include <scsi/scsi_host.h>
 
 #include "mptbase.h"
@@ -328,31 +327,6 @@ mpt_is_discovery_complete(MPT_ADAPTER *ioc)
 
 
 /**
- *  mpt_remove_dead_ioc_func - kthread context to remove dead ioc
- * @arg: input argument, used to derive ioc
- *
- * Return 0 if controller is removed from pci subsystem.
- * Return -1 for other case.
- */
-static int mpt_remove_dead_ioc_func(void *arg)
-{
-	MPT_ADAPTER *ioc = (MPT_ADAPTER *)arg;
-	struct pci_dev *pdev;
-
-	if ((ioc == NULL))
-		return -1;
-
-	pdev = ioc->pcidev;
-	if ((pdev == NULL))
-		return -1;
-
-	pci_stop_and_remove_bus_device(pdev);
-	return 0;
-}
-
-
-
-/**
  *	mpt_fault_reset_work - work performed on workq after ioc fault
  *	@work: input argument, used to derive ioc
  *
@@ -366,7 +340,6 @@ mpt_fault_reset_work(struct work_struct *work)
 	int		 rc;
 	unsigned long	 flags;
 	MPT_SCSI_HOST	*hd;
-	struct task_struct *p;
 
 	if (ioc->ioc_reset_in_progress || !ioc->active)
 		goto out;
@@ -380,25 +353,13 @@ mpt_fault_reset_work(struct work_struct *work)
 		/*
 		 * Call mptscsih_flush_pending_cmds callback so that we
 		 * flush all pending commands back to OS.
-		 * This call is required to aovid deadlock at block layer.
+		 * This call is required to avoid deadlock at block layer.
 		 * Dead IOC will fail to do diag reset,and this call is safe
 		 * since dead ioc will never return any command back from HW.
 		 */
 		hd = shost_priv(ioc->sh);
 		ioc->schedule_dead_ioc_flush_running_cmds(hd);
 
-		/*Remove the Dead Host */
-		p = kthread_run(mpt_remove_dead_ioc_func, ioc,
-				"mpt_dead_ioc_%d", ioc->id);
-		if (IS_ERR(p))	{
-			printk(MYIOC_s_ERR_FMT
-				"%s: Running mpt_dead_ioc thread failed !\n",
-				ioc->name, __func__);
-		} else {
-			printk(MYIOC_s_WARN_FMT
-				"%s: Running mpt_dead_ioc thread success !\n",
-				ioc->name, __func__);
-		}
 		return; /* don't rearm timer */
 	}
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index ffd85c5..a97d10c 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -57,7 +57,6 @@
 #include <linux/sort.h>
 #include <linux/io.h>
 #include <linux/time.h>
-#include <linux/kthread.h>
 #include <linux/aer.h>
 
 #include "mpt2sas_base.h"
@@ -115,29 +114,6 @@ module_param_call(mpt2sas_fwfault_debug, _scsih_set_fwfault_debug,
     param_get_int, &mpt2sas_fwfault_debug, 0644);
 
 /**
- *  mpt2sas_remove_dead_ioc_func - kthread context to remove dead ioc
- * @arg: input argument, used to derive ioc
- *
- * Return 0 if controller is removed from pci subsystem.
- * Return -1 for other case.
- */
-static int mpt2sas_remove_dead_ioc_func(void *arg)
-{
-		struct MPT2SAS_ADAPTER *ioc = (struct MPT2SAS_ADAPTER *)arg;
-		struct pci_dev *pdev;
-
-		if ((ioc == NULL))
-			return -1;
-
-		pdev = ioc->pdev;
-		if ((pdev == NULL))
-			return -1;
-		pci_stop_and_remove_bus_device(pdev);
-		return 0;
-}
-
-
-/**
  * _base_fault_reset_work - workq handling ioc fault conditions
  * @work: input argument, used to derive ioc
  * Context: sleep.
@@ -152,7 +128,6 @@ _base_fault_reset_work(struct work_struct *work)
 	unsigned long	 flags;
 	u32 doorbell;
 	int rc;
-	struct task_struct *p;
 
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
 	if (ioc->shost_recovery)
@@ -166,29 +141,16 @@ _base_fault_reset_work(struct work_struct *work)
 
 		/*
 		 * Call _scsih_flush_pending_cmds callback so that we flush all
-		 * pending commands back to OS. This call is required to aovid
+		 * pending commands back to OS. This call is required to avoid
 		 * deadlock at block layer. Dead IOC will fail to do diag reset,
 		 * and this call is safe since dead ioc will never return any
 		 * command back from HW.
 		 */
 		ioc->schedule_dead_ioc_flush_running_cmds(ioc);
 		/*
-		 * Set remove_host flag early since kernel thread will
-		 * take some time to execute.
+		 * Indicate to scsi callbacks that the host has been removed.
 		 */
 		ioc->remove_host = 1;
-		/*Remove the Dead Host */
-		p = kthread_run(mpt2sas_remove_dead_ioc_func, ioc,
-		    "mpt2sas_dead_ioc_%d", ioc->id);
-		if (IS_ERR(p)) {
-			printk(MPT2SAS_ERR_FMT
-			"%s: Running mpt2sas_dead_ioc thread failed !!!!\n",
-			ioc->name, __func__);
-		} else {
-		    printk(MPT2SAS_ERR_FMT
-			"%s: Running mpt2sas_dead_ioc thread success !!!!\n",
-			ioc->name, __func__);
-		}
 
 		return; /* don't rearm timer */
 	}
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 04f8010..24fd122 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -57,7 +57,6 @@
 #include <linux/dma-mapping.h>
 #include <linux/io.h>
 #include <linux/time.h>
-#include <linux/kthread.h>
 #include <linux/aer.h>
 
 
@@ -111,28 +110,6 @@ module_param_call(mpt3sas_fwfault_debug, _scsih_set_fwfault_debug,
 	param_get_int, &mpt3sas_fwfault_debug, 0644);
 
 /**
- *  mpt3sas_remove_dead_ioc_func - kthread context to remove dead ioc
- * @arg: input argument, used to derive ioc
- *
- * Return 0 if controller is removed from pci subsystem.
- * Return -1 for other case.
- */
-static int mpt3sas_remove_dead_ioc_func(void *arg)
-{
-	struct MPT3SAS_ADAPTER *ioc = (struct MPT3SAS_ADAPTER *)arg;
-	struct pci_dev *pdev;
-
-	if ((ioc == NULL))
-		return -1;
-
-	pdev = ioc->pdev;
-	if ((pdev == NULL))
-		return -1;
-	pci_stop_and_remove_bus_device(pdev);
-	return 0;
-}
-
-/**
  * _base_fault_reset_work - workq handling ioc fault conditions
  * @work: input argument, used to derive ioc
  * Context: sleep.
@@ -147,7 +124,6 @@ _base_fault_reset_work(struct work_struct *work)
 	unsigned long	 flags;
 	u32 doorbell;
 	int rc;
-	struct task_struct *p;
 
 
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
@@ -162,28 +138,16 @@ _base_fault_reset_work(struct work_struct *work)
 
 		/*
 		 * Call _scsih_flush_pending_cmds callback so that we flush all
-		 * pending commands back to OS. This call is required to aovid
+		 * pending commands back to OS. This call is required to avoid
 		 * deadlock at block layer. Dead IOC will fail to do diag reset,
 		 * and this call is safe since dead ioc will never return any
 		 * command back from HW.
 		 */
 		ioc->schedule_dead_ioc_flush_running_cmds(ioc);
 		/*
-		 * Set remove_host flag early since kernel thread will
-		 * take some time to execute.
+		 * Indicate to scsi callbacks that the host has been removed.
 		 */
 		ioc->remove_host = 1;
-		/*Remove the Dead Host */
-		p = kthread_run(mpt3sas_remove_dead_ioc_func, ioc,
-		    "mpt3sas_dead_ioc_%d", ioc->id);
-		if (IS_ERR(p))
-			pr_err(MPT3SAS_FMT
-			"%s: Running mpt3sas_dead_ioc thread failed !!!!\n",
-			ioc->name, __func__);
-		else
-			pr_err(MPT3SAS_FMT
-			"%s: Running mpt3sas_dead_ioc thread success !!!!\n",
-			ioc->name, __func__);
 		return; /* don't rearm timer */
 	}
 
-- 
1.8.1.2

