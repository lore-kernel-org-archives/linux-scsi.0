From: Tomas Henzl <thenzl@redhat.com>
Subject: [PATCH v2] [SCSI] mpt2sas: fix for driver fails EEH, recovery from
 injected pci bus error
Date: Tue, 18 Dec 2012 14:45:30 +0100
Message-ID: <50D0737A.1070607@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:12020 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796Ab2LRNpi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Dec 2012 08:45:38 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@kernel.org>, "Reddy, Sreekanth" <Sreekanth.Reddy@lsi.com>, nagalakshmi.nandigama@lsi.com, "JBottomley@Parallels.com" <JBottomley@Parallels.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

This patch stops the driver to invoke kthread (which remove the dead ioc)
for some time while EEH recovery has started.

V2 adds a 'non_operational_loop' reset.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@lsi.com>
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/mpt2sas/mpt2sas_base.c | 19 ++++++++++++++++++-
 drivers/scsi/mpt2sas/mpt2sas_base.h |  1 +
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
index 6102ef2..b5d316f 100644
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
@@ -193,6 +207,8 @@ _base_fault_reset_work(struct work_struct *work)
 		return; /* don't rearm timer */
 	}
 
+	ioc->non_operational_loop = 0;
+
 	if ((doorbell & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
 		rc = mpt2sas_base_hard_reset_handler(ioc, CAN_SLEEP,
 		    FORCE_BIG_HAMMER);
@@ -4376,6 +4392,7 @@ mpt2sas_base_attach(struct MPT2SAS_ADAPTER *ioc)
 	if (missing_delay[0] != -1 && missing_delay[1] != -1)
 		_base_update_missing_delay(ioc, missing_delay[0],
 		    missing_delay[1]);
+	ioc->non_operational_loop = 0;
 
 	return 0;
 
diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.h b/drivers/scsi/mpt2sas/mpt2sas_base.h
index b6dd3a5..f69bbe2 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_base.h
+++ b/drivers/scsi/mpt2sas/mpt2sas_base.h
@@ -835,6 +835,7 @@ struct MPT2SAS_ADAPTER {
 	u16		cpu_msix_table_sz;
 	u32		ioc_reset_count;
 	MPT2SAS_FLUSH_RUNNING_CMDS schedule_dead_ioc_flush_running_cmds;
+	u32             non_operational_loop;
 
 	/* internal commands, callback index */
 	u8		scsi_io_cb_idx;
-- 
1.7.11.7


