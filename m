From: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Subject: [PATCH] [SCSI] mpt2sas: fix for driver fails EEH recovery from
 injected pci bus error
Date: Tue, 18 Dec 2012 03:28:18 +0530
Message-ID: <20121217215818.GA12490@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:42831 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900Ab2LQK7w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Dec 2012 05:59:52 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@kernel.org, sreekanth.reddy@lsi.com, Nagalakshmi.Nandigama@lsi.com, JBottomley@Parallels.com
Cc: linux-scsi@vger.kernel.org, sathya.prakash@lsi.com

This patch stops the driver to invoke kthread (which remove the dead ioc)
for some time while EEH recovery has started.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index ffd85c5..2349531 100755
--- a/drivers/scsi/mpt2sas/mpt2sas_base.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
@@ -155,7 +155,7 @@ _base_fault_reset_work(struct work_struct *work)
 	struct task_struct *p;
 
 	spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock, flags);
-	if (ioc->shost_recovery)
+	if (ioc->shost_recovery || ioc->pci_error_recovery)
 		goto rearm_timer;
 	spin_unlock_irqrestore(&ioc->ioc_reset_in_progress_lock, flags);
 
@@ -164,6 +164,20 @@ _base_fault_reset_work(struct work_struct *work)
 		printk(MPT2SAS_INFO_FMT "%s : SAS host is non-operational !!!!\n",
 			ioc->name, __func__);
 
+		/* It may be possible that EEH recovery can resolve some of
+		 * pci bus failure issues rather removing the dead ioc function
+		 * by considering controller is in a non-operational state. So
+		 * here priority is given to the EEH recovery. If it doesn't
+		 * not resolve this issue, mpt2sas driver will consider this
+		 * controller to non-operational state and remove the dead ioc
+		 * function.
+		 */
+		if (ioc->non_operational_loop++ < 5) {
+			spin_lock_irqsave(&ioc->ioc_reset_in_progress_lock,
+							 flags);
+			goto rearm_timer;
+		}
+
 		/*
 		 * Call _scsih_flush_pending_cmds callback so that we flush all
 		 * pending commands back to OS. This call is required to aovid
@@ -4386,6 +4400,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	if (missing_delay[0] != -1 && missing_delay[1] != -1)
 		_base_update_missing_delay(ioc, missing_delay[0],
 		    missing_delay[1]);
+	ioc->non_operational_loop = 0;
 
 	return 0;
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index 543d8d6..c6ee7aa 100755
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -835,6 +835,7 @@ struct MPT2SAS_ADAPTER {
 	u16		cpu_msix_table_sz;
 	u32		ioc_reset_count;
 	MPT2SAS_FLUSH_RUNNING_CMDS schedule_dead_ioc_flush_running_cmds;
+	u32             non_operational_loop;
 
 	/* internal commands, callback index */
 	u8		scsi_io_cb_idx;
