From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 09/11] Fix crash in lpfc_sli_ringtxcmpl_put when nvmet gets an abort request.
Date: Thu, 15 Jun 2017 22:56:49 -0700
Message-ID: <20170616055651.9674-10-jsmart2021@gmail.com>
References: <20170616055651.9674-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f193.google.com ([209.85.216.193]:34404 "EHLO
        mail-qt0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750983AbdFPF5T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jun 2017 01:57:19 -0400
Received: by mail-qt0-f193.google.com with SMTP id o21so7937152qtb.1
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2017 22:57:19 -0700 (PDT)
In-Reply-To: <20170616055651.9674-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

When running nvme detach-ns /dev/nvme0n1 -n 1 command,
the nvmet lpfc driver crashes with this stack dump:

kernel BUG at /root/NVME/lpfc_8.4/lpfc_sli.c:1393!
invalid opcode: 0000 [#1] SMP
Workqueue: nvmet-fc-cpu0 nvmet_fc_do_work_on_cpu [nvmet_fc]
 lpfc_sli4_issue_wqe+0x357/0x440 [lpfc]
 lpfc_nvmet_xmt_fcp_abort+0x36b/0x5c0 [lpfc]
 nvmet_fc_abort_op+0x30/0x50 [nvmet_fc]
 nvmet_fc_do_work_on_cpu+0xd9/0x130 [nvmet_fc]
 process_one_work+0x14e/0x410
 worker_thread+0x116/0x490
 kthread+0xc7/0xe0
 ret_from_fork+0x3f/0x70

Crash is due to an uninitialized iocbq->vport pointer.

Explicitly set the iocbq->vport field to phba->pport in
lpfc_nvmet_sol_fcp_issue_abort as it does all abort iocbq
initialization in the routine.  Using phba->pport is ok because
target does not support NPIV instances.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index 5fb29735e236..7dc061a14f95 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -2523,6 +2523,7 @@ lpfc_nvmet_sol_fcp_issue_abort(struct lpfc_hba *phba,
 	abts_wqeq->iocb_cmpl = 0;
 	abts_wqeq->iocb_flag |= LPFC_IO_NVME;
 	abts_wqeq->context2 = ctxp;
+	abts_wqeq->vport = phba->pport;
 	rc = lpfc_sli4_issue_wqe(phba, LPFC_FCP_RING, abts_wqeq);
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 	if (rc == WQE_SUCCESS) {
-- 
2.11.0
