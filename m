From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 02/28] be2iscsi: Replace _bh with _irqsave/irqrestore
Date: Thu, 21 Jul 2016 14:37:39 +0530
Message-ID: <1469092085-14311-3-git-send-email-jitendra.bhivare@broadcom.com>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:35891 "EHLO
	mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbcGUJIb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2016 05:08:31 -0400
Received: by mail-wm0-f47.google.com with SMTP id q128so14801080wma.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 02:08:31 -0700 (PDT)
In-Reply-To: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: mchristi@redhat.com, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 21
Pid: 13242, comm: flush-8:80 Tainted: G        W  -- ------------
2.6.32-573.el6.x86_64 #1
Call Trace:
<NMI>  [<ffffffff81537a84>] ? panic+0xa7/0x16f
[<ffffffff810149c9>] ? sched_clock+0x9/0x10
[<ffffffff810ed4bd>] ? watchdog_overflow_callback+0xcd/0xd0
[<ffffffff81124037>] ? __perf_event_overflow+0xa7/0x240
[<ffffffff8101dc54>] ? x86_perf_event_set_period+0xf4/0x180
[<ffffffff81124684>] ? perf_event_overflow+0x14/0x20
[<ffffffff81024a02>] ? intel_pmu_handle_irq+0x202/0x3f0
[<ffffffff8153cd89>] ? perf_event_nmi_handler+0x39/0xb0
[<ffffffff8153e845>] ? notifier_call_chain+0x55/0x80
[<ffffffff81389ba0>] ? scsi_done+0x0/0x60
[<ffffffff8153e8aa>] ? atomic_notifier_call_chain+0x1a/0x20
[<ffffffff810a788e>] ? notify_die+0x2e/0x30
[<ffffffff8153c503>] ? do_nmi+0x1c3/0x350
[<ffffffff8153bdc0>] ? nmi+0x20/0x30
[<ffffffff81389ba0>] ? scsi_done+0x0/0x60
[<ffffffff81389ba0>] ? scsi_done+0x0/0x60
[<ffffffff8153b62e>] ? _spin_lock+0x1e/0x30
<<EOE>>  [<ffffffffa00e2eaf>] ? iscsi_queuecommand+0x7f/0x4e0 [libiscsi]
[<ffffffff81389df5>] ? scsi_dispatch_cmd+0xe5/0x310
[<ffffffff813927be>] ? scsi_request_fn+0x5be/0x750
[<ffffffff81089bad>] ? del_timer+0x7d/0xe0
[<ffffffff81273542>] ? __generic_unplug_device+0x32/0x40
[<ffffffff8126e823>] ? elv_insert+0xd3/0x190
[<ffffffff8126e920>] ? __elv_add_request+0x40/0x90

In beiscsi_alloc_pdu, _bh versions of spin_lock are being used for
protecting SGLs and WRBs. _bh versions are needed as the function gets
invoked in process context and BLOCK_IOPOLL softirq.

In spin_unlock_bh, after releasing the lock and enabling BH, do_softirq
is called which executes till last SOFTIRQ.

beiscsi_alloc_pdu is called under session lock. Through block layer,
iSCSI stack in some cases send IOs with interrupts disabled. In such paths,
CPU will get stuck for a while for session lock with interrupts disabled
because in other CPU do_softirq is executing under session lock thus
causing hard lock up.

Use spin_lock_irqsave/spin_lock_irqrestore as the driver can't be sure
in all paths interrupts are enabled.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index f05e773..02d24d5 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1131,8 +1131,9 @@ beiscsi_process_async_pdu(struct beiscsi_conn *beiscsi_conn,
 static struct sgl_handle *alloc_io_sgl_handle(struct beiscsi_hba *phba)
 {
 	struct sgl_handle *psgl_handle;
+	unsigned long flags;
 
-	spin_lock_bh(&phba->io_sgl_lock);
+	spin_lock_irqsave(&phba->io_sgl_lock, flags);
 	if (phba->io_sgl_hndl_avbl) {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
 			    "BM_%d : In alloc_io_sgl_handle,"
@@ -1150,14 +1151,16 @@ static struct sgl_handle *alloc_io_sgl_handle(struct beiscsi_hba *phba)
 			phba->io_sgl_alloc_index++;
 	} else
 		psgl_handle = NULL;
-	spin_unlock_bh(&phba->io_sgl_lock);
+	spin_unlock_irqrestore(&phba->io_sgl_lock, flags);
 	return psgl_handle;
 }
 
 static void
 free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 {
-	spin_lock_bh(&phba->io_sgl_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&phba->io_sgl_lock, flags);
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
 		    "BM_%d : In free_,io_sgl_free_index=%d\n",
 		    phba->io_sgl_free_index);
@@ -1172,7 +1175,7 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 			     "value there=%p\n", phba->io_sgl_free_index,
 			     phba->io_sgl_hndl_base
 			     [phba->io_sgl_free_index]);
-		 spin_unlock_bh(&phba->io_sgl_lock);
+		 spin_unlock_irqrestore(&phba->io_sgl_lock, flags);
 		return;
 	}
 	phba->io_sgl_hndl_base[phba->io_sgl_free_index] = psgl_handle;
@@ -1181,7 +1184,7 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		phba->io_sgl_free_index = 0;
 	else
 		phba->io_sgl_free_index++;
-	spin_unlock_bh(&phba->io_sgl_lock);
+	spin_unlock_irqrestore(&phba->io_sgl_lock, flags);
 }
 
 static inline struct wrb_handle *
@@ -1189,15 +1192,16 @@ beiscsi_get_wrb_handle(struct hwi_wrb_context *pwrb_context,
 		       unsigned int wrbs_per_cxn)
 {
 	struct wrb_handle *pwrb_handle;
+	unsigned long flags;
 
-	spin_lock_bh(&pwrb_context->wrb_lock);
+	spin_lock_irqsave(&pwrb_context->wrb_lock, flags);
 	pwrb_handle = pwrb_context->pwrb_handle_base[pwrb_context->alloc_index];
 	pwrb_context->wrb_handles_available--;
 	if (pwrb_context->alloc_index == (wrbs_per_cxn - 1))
 		pwrb_context->alloc_index = 0;
 	else
 		pwrb_context->alloc_index++;
-	spin_unlock_bh(&pwrb_context->wrb_lock);
+	spin_unlock_irqrestore(&pwrb_context->wrb_lock, flags);
 
 	return pwrb_handle;
 }
@@ -1229,14 +1233,16 @@ beiscsi_put_wrb_handle(struct hwi_wrb_context *pwrb_context,
 		       struct wrb_handle *pwrb_handle,
 		       unsigned int wrbs_per_cxn)
 {
-	spin_lock_bh(&pwrb_context->wrb_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&pwrb_context->wrb_lock, flags);
 	pwrb_context->pwrb_handle_base[pwrb_context->free_index] = pwrb_handle;
 	pwrb_context->wrb_handles_available++;
 	if (pwrb_context->free_index == (wrbs_per_cxn - 1))
 		pwrb_context->free_index = 0;
 	else
 		pwrb_context->free_index++;
-	spin_unlock_bh(&pwrb_context->wrb_lock);
+	spin_unlock_irqrestore(&pwrb_context->wrb_lock, flags);
 }
 
 /**
@@ -1265,8 +1271,9 @@ free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,
 static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
 {
 	struct sgl_handle *psgl_handle;
+	unsigned long flags;
 
-	spin_lock_bh(&phba->mgmt_sgl_lock);
+	spin_lock_irqsave(&phba->mgmt_sgl_lock, flags);
 	if (phba->eh_sgl_hndl_avbl) {
 		psgl_handle = phba->eh_sgl_hndl_base[phba->eh_sgl_alloc_index];
 		phba->eh_sgl_hndl_base[phba->eh_sgl_alloc_index] = NULL;
@@ -1284,14 +1291,16 @@ static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
 			phba->eh_sgl_alloc_index++;
 	} else
 		psgl_handle = NULL;
-	spin_unlock_bh(&phba->mgmt_sgl_lock);
+	spin_unlock_irqrestore(&phba->mgmt_sgl_lock, flags);
 	return psgl_handle;
 }
 
 void
 free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 {
-	spin_lock_bh(&phba->mgmt_sgl_lock);
+	unsigned long flags;
+
+	spin_lock_irqsave(&phba->mgmt_sgl_lock, flags);
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
 		    "BM_%d : In  free_mgmt_sgl_handle,"
 		    "eh_sgl_free_index=%d\n",
@@ -1306,7 +1315,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 			    "BM_%d : Double Free in eh SGL ,"
 			    "eh_sgl_free_index=%d\n",
 			    phba->eh_sgl_free_index);
-		spin_unlock_bh(&phba->mgmt_sgl_lock);
+		spin_unlock_irqrestore(&phba->mgmt_sgl_lock, flags);
 		return;
 	}
 	phba->eh_sgl_hndl_base[phba->eh_sgl_free_index] = psgl_handle;
@@ -1316,7 +1325,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		phba->eh_sgl_free_index = 0;
 	else
 		phba->eh_sgl_free_index++;
-	spin_unlock_bh(&phba->mgmt_sgl_lock);
+	spin_unlock_irqrestore(&phba->mgmt_sgl_lock, flags);
 }
 
 static void
-- 
1.9.1

