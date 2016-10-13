From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 2/2] be2iscsi: Replace _bh with _irqsave/irqrestore
Date: Thu, 13 Oct 2016 12:08:49 +0530
Message-ID: <1476340729-8569-3-git-send-email-jitendra.bhivare@broadcom.com>
References: <1476340729-8569-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f170.google.com ([209.85.216.170]:33232 "EHLO
        mail-qt0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750822AbcJMGsq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Oct 2016 02:48:46 -0400
Received: by mail-qt0-f170.google.com with SMTP id s49so31949146qta.0
        for <linux-scsi@vger.kernel.org>; Wed, 12 Oct 2016 23:47:10 -0700 (PDT)
In-Reply-To: <1476340729-8569-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

[ 3843.132217] WARNING: CPU: 20 PID: 1227 at kernel/softirq.c:150 __local_bh_enable_ip+0x6b/0x90
[ 3843.142815] Modules linked in:
...
[ 3843.294328] CPU: 20 PID: 1227 Comm: kworker/20:1H Tainted: G            E   4.8.0-rc1+ #3
[ 3843.304944] Hardware name: Dell Inc. PowerEdge R720/0X6H47, BIOS 1.4.8 10/25/2012
[ 3843.314798] Workqueue: kblockd blk_timeout_work
[ 3843.321350]  0000000000000086 00000000a32f4533 ffff8802216d7bd8 ffffffff8135c3cf
[ 3843.331146]  0000000000000000 0000000000000000 ffff8802216d7c18 ffffffff8108d661
[ 3843.340918]  00000096216d7c50 0000000000000200 ffff8802d07cc828 ffff8801b3632550
[ 3843.350687] Call Trace:
[ 3843.354866]  [<ffffffff8135c3cf>] dump_stack+0x63/0x84
[ 3843.362061]  [<ffffffff8108d661>] __warn+0xd1/0xf0
[ 3843.368851]  [<ffffffff8108d79d>] warn_slowpath_null+0x1d/0x20
[ 3843.376791]  [<ffffffff810930eb>] __local_bh_enable_ip+0x6b/0x90
[ 3843.384903]  [<ffffffff816fe7be>] _raw_spin_unlock_bh+0x1e/0x20
[ 3843.392940]  [<ffffffffa085f710>] beiscsi_alloc_pdu+0x2f0/0x6e0 [be2iscsi]
[ 3843.402076]  [<ffffffffa06bc358>] __iscsi_conn_send_pdu+0xf8/0x370 [libiscsi]
[ 3843.411549]  [<ffffffffa06bc6fe>] iscsi_send_nopout+0xbe/0x110 [libiscsi]
[ 3843.420639]  [<ffffffffa06bd98b>] iscsi_eh_cmd_timed_out+0x29b/0x2b0 [libiscsi]
[ 3843.430339]  [<ffffffff814cd1de>] scsi_times_out+0x5e/0x250
[ 3843.438119]  [<ffffffff813374af>] blk_rq_timed_out+0x1f/0x60
[ 3843.446009]  [<ffffffff8133759d>] blk_timeout_work+0xad/0x150
[ 3843.454010]  [<ffffffff810a6642>] process_one_work+0x152/0x400
[ 3843.462114]  [<ffffffff810a6f35>] worker_thread+0x125/0x4b0
[ 3843.469961]  [<ffffffff810a6e10>] ? rescuer_thread+0x380/0x380
[ 3843.478116]  [<ffffffff810aca28>] kthread+0xd8/0xf0
[ 3843.485212]  [<ffffffff816fedff>] ret_from_fork+0x1f/0x40
[ 3843.492908]  [<ffffffff810ac950>] ? kthread_park+0x60/0x60
[ 3843.500715] ---[ end trace 57ec0a1d8f0dd3a0 ]---
[ 3852.328667] NMI watchdog: Watchdog detected hard LOCKUP on cpu 1Kernel panic - not syncing: Hard LOCKUP

blk_timeout_work takes queue_lock spin_lock with interrupts disabled
before invoking iscsi_eh_cmd_timed_out. This causes a WARN_ON_ONCE in
spin_unlock_bh for wrb_lock/io_sgl_lock/mgmt_sgl_lock.

CPU was kept busy in lot of bottom half work with interrupts disabled
thus causing hard lock up.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 68138a6..d9239c2 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -900,8 +900,9 @@ void hwi_ring_cq_db(struct beiscsi_hba *phba,
 static struct sgl_handle *alloc_io_sgl_handle(struct beiscsi_hba *phba)
 {
 	struct sgl_handle *psgl_handle;
+	unsigned long flags;
 
-	spin_lock_bh(&phba->io_sgl_lock);
+	spin_lock_irqsave(&phba->io_sgl_lock, flags);
 	if (phba->io_sgl_hndl_avbl) {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
 			    "BM_%d : In alloc_io_sgl_handle,"
@@ -919,14 +920,16 @@ static struct sgl_handle *alloc_io_sgl_handle(struct beiscsi_hba *phba)
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
@@ -941,7 +944,7 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 			     "value there=%p\n", phba->io_sgl_free_index,
 			     phba->io_sgl_hndl_base
 			     [phba->io_sgl_free_index]);
-		 spin_unlock_bh(&phba->io_sgl_lock);
+		 spin_unlock_irqrestore(&phba->io_sgl_lock, flags);
 		return;
 	}
 	phba->io_sgl_hndl_base[phba->io_sgl_free_index] = psgl_handle;
@@ -950,7 +953,7 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		phba->io_sgl_free_index = 0;
 	else
 		phba->io_sgl_free_index++;
-	spin_unlock_bh(&phba->io_sgl_lock);
+	spin_unlock_irqrestore(&phba->io_sgl_lock, flags);
 }
 
 static inline struct wrb_handle *
@@ -958,15 +961,16 @@ beiscsi_get_wrb_handle(struct hwi_wrb_context *pwrb_context,
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
 
 	if (pwrb_handle)
 		memset(pwrb_handle->pwrb, 0, sizeof(*pwrb_handle->pwrb));
@@ -1001,14 +1005,16 @@ beiscsi_put_wrb_handle(struct hwi_wrb_context *pwrb_context,
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
@@ -1037,8 +1043,9 @@ free_wrb_handle(struct beiscsi_hba *phba, struct hwi_wrb_context *pwrb_context,
 static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
 {
 	struct sgl_handle *psgl_handle;
+	unsigned long flags;
 
-	spin_lock_bh(&phba->mgmt_sgl_lock);
+	spin_lock_irqsave(&phba->mgmt_sgl_lock, flags);
 	if (phba->eh_sgl_hndl_avbl) {
 		psgl_handle = phba->eh_sgl_hndl_base[phba->eh_sgl_alloc_index];
 		phba->eh_sgl_hndl_base[phba->eh_sgl_alloc_index] = NULL;
@@ -1056,14 +1063,16 @@ static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
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
@@ -1078,7 +1087,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 			    "BM_%d : Double Free in eh SGL ,"
 			    "eh_sgl_free_index=%d\n",
 			    phba->eh_sgl_free_index);
-		spin_unlock_bh(&phba->mgmt_sgl_lock);
+		spin_unlock_irqrestore(&phba->mgmt_sgl_lock, flags);
 		return;
 	}
 	phba->eh_sgl_hndl_base[phba->eh_sgl_free_index] = psgl_handle;
@@ -1088,7 +1097,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		phba->eh_sgl_free_index = 0;
 	else
 		phba->eh_sgl_free_index++;
-	spin_unlock_bh(&phba->mgmt_sgl_lock);
+	spin_unlock_irqrestore(&phba->mgmt_sgl_lock, flags);
 }
 
 static void
-- 
2.7.4

