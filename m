Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B531FA3743
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 08:09:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D617B214B2
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 08:09:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388079AbfKEII7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 03:08:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:40978 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387954AbfKEII6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 Nov 2019 03:08:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 99549ABD6;
        Tue,  5 Nov 2019 08:08:56 +0000 (UTC)
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Daniel Wagner <dwagner@suse.de>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH] scsi: lpfc: Move work items to a stack list
Date:   Tue,  5 Nov 2019 09:08:55 +0100
Message-Id: <20191105080855.16881-1-dwagner@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Move all work items to a list which lives on the stack while holding
the corresponding lock.

With this we avoid a race between testing if the list is empty and
extracting an element of the list. Although, the list_remove_head()
macro tests will return an NULL pointer if the list is empty the two
functions lpfc_sli_handle_slow_ring_event_s4() and
lpfc_sli4_els_xri_abort_event_proc() do not test the return element if
it's NULL.

Instead adding another test if the pointer is NULL just avoid this
access pattern by using the stack list. This also avoids toggling the
interrupts on/off for every item.

Fixes: 4f774513f7b3 ("[SCSI] lpfc 8.3.2 : Addition of SLI4 Interface - Queues")
Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Daniel Wagner <dwagner@suse.de>
---

Hi,

While trying to understand what's going on in the Oops below I figured
that it could be the result of the invalid pointer access. The patch
still needs testing by our customer but indepent of this I think the
patch fixes a real bug.

[  139.392029] general protection fault: 0000 [#1] SMP PTI
[  139.397862] CPU: 5 PID: 998 Comm: kworker/5:13 Tainted: G                   4.12.14-226.g94364da-default #1 SLE15-SP1 (unreleased)
[  139.410962] Hardware name: Dell Inc. PowerEdge R730/072T6D, BIOS 2.9.1 12/04/2018
[  139.419339] Workqueue: lpfc_wq lpfc_sli4_hba_process_cq [lpfc]
[  139.425847] task: ffff95c996051440 task.stack: ffffaa038601c000
[  139.432459] RIP: 0010:lpfc_set_rrq_active+0xa6/0x2a0 [lpfc]
[  139.438676] RSP: 0018:ffffaa038601fcf8 EFLAGS: 00010046
[  139.444504] RAX: 0000000000000292 RBX: ffff95c5a9a0a000 RCX: 000000000000ffff
[  139.452466] RDX: ffff95c5accbb7b8 RSI: 0064695f74726f70 RDI: ffff95c5a9a0b160
[  139.460427] RBP: ffff95c5a9a0b160 R08: 0000000000000001 R09: 0000000000000002
[  139.468389] R10: ffffaa038601fdd8 R11: 61c8864680b583eb R12: 0000000000000001
[  139.476350] R13: 000000000000ffff R14: 00000000000002bb R15: 0064695f74726f70
[  139.484311] FS:  0000000000000000(0000) GS:ffff95c9bfc80000(0000) knlGS:0000000000000000
[  139.493340] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  139.499749] CR2: 0000560354607098 CR3: 00000007a000a003 CR4: 00000000001606e0
[  139.507711] Call Trace:
[  139.510451]  lpfc_sli4_io_xri_aborted+0x1a7/0x250 [lpfc]
[  139.516386]  lpfc_sli4_sp_handle_abort_xri_wcqe.isra.56+0xa0/0x180 [lpfc]
[  139.523964]  ? __switch_to_asm+0x40/0x70
[  139.528338]  ? __switch_to_asm+0x34/0x70
[  139.532718]  ? lpfc_sli4_fp_handle_cqe+0xc3/0x450 [lpfc]
[  139.538649]  lpfc_sli4_fp_handle_cqe+0xc3/0x450 [lpfc]
[  139.544383]  ? __switch_to_asm+0x34/0x70
[  139.548762]  __lpfc_sli4_process_cq+0xea/0x220 [lpfc]
[  139.554393]  ? lpfc_sli4_sp_handle_abort_xri_wcqe.isra.56+0x180/0x180 [lpfc]
[  139.562557]  __lpfc_sli4_hba_process_cq+0x29/0xc0 [lpfc]
[  139.568486]  process_one_work+0x1da/0x400
[  139.572959]  worker_thread+0x2b/0x3f0
[  139.577044]  ? process_one_work+0x400/0x400
[  139.581710]  kthread+0x113/0x130
[  139.585310]  ? kthread_create_worker_on_cpu+0x50/0x50
[  139.590945]  ret_from_fork+0x35/0x40

Thanks,
Daniel

 drivers/scsi/lpfc/lpfc_sli.c | 32 ++++++++++++++++++++++----------
 1 file changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 294f041961a8..cbeb1f408ccc 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3903,16 +3903,16 @@ lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hba *phba,
 	struct lpfc_cq_event *cq_event;
 	unsigned long iflag;
 	int count = 0;
+	LIST_HEAD(work_list);
 
 	spin_lock_irqsave(&phba->hbalock, iflag);
 	phba->hba_flag &= ~HBA_SP_QUEUE_EVT;
+	list_splice_init(&phba->sli4_hba.sp_queue_event, &work_list);
 	spin_unlock_irqrestore(&phba->hbalock, iflag);
-	while (!list_empty(&phba->sli4_hba.sp_queue_event)) {
+	while (!list_empty(&work_list)) {
 		/* Get the response iocb from the head of work queue */
-		spin_lock_irqsave(&phba->hbalock, iflag);
-		list_remove_head(&phba->sli4_hba.sp_queue_event,
-				 cq_event, struct lpfc_cq_event, list);
-		spin_unlock_irqrestore(&phba->hbalock, iflag);
+		list_remove_head(&work_list, cq_event,
+				 struct lpfc_cq_event, list);
 
 		switch (bf_get(lpfc_wcqe_c_code, &cq_event->cqe.wcqe_cmpl)) {
 		case CQE_CODE_COMPL_WQE:
@@ -3941,6 +3941,17 @@ lpfc_sli_handle_slow_ring_event_s4(struct lpfc_hba *phba,
 		if (count == 64)
 			break;
 	}
+
+	/*
+	 * If the limit stops the processing of events, move the
+	 * remaining events back to the main event queue.
+	 */
+	spin_lock_irqsave(&phba->hbalock, iflag);
+	if (!list_empty(&work_list)) {
+		phba->hba_flag |= HBA_SP_QUEUE_EVT;
+		list_splice(&work_list, &phba->sli4_hba.sp_queue_event);
+	}
+	spin_unlock_irqrestore(&phba->hbalock, iflag);
 }
 
 /**
@@ -12877,18 +12888,19 @@ lpfc_sli_intr_handler(int irq, void *dev_id)
 void lpfc_sli4_els_xri_abort_event_proc(struct lpfc_hba *phba)
 {
 	struct lpfc_cq_event *cq_event;
+	LIST_HEAD(work_list);
 
 	/* First, declare the els xri abort event has been handled */
 	spin_lock_irq(&phba->hbalock);
 	phba->hba_flag &= ~ELS_XRI_ABORT_EVENT;
+	list_splice_init(&phba->sli4_hba.sp_els_xri_aborted_work_queue,
+			 &work_list);
 	spin_unlock_irq(&phba->hbalock);
 	/* Now, handle all the els xri abort events */
-	while (!list_empty(&phba->sli4_hba.sp_els_xri_aborted_work_queue)) {
+	while (!list_empty(&work_list)) {
 		/* Get the first event from the head of the event queue */
-		spin_lock_irq(&phba->hbalock);
-		list_remove_head(&phba->sli4_hba.sp_els_xri_aborted_work_queue,
-				 cq_event, struct lpfc_cq_event, list);
-		spin_unlock_irq(&phba->hbalock);
+		list_remove_head(&work_list, cq_event,
+				 struct lpfc_cq_event, list);
 		/* Notify aborted XRI for ELS work queue */
 		lpfc_sli4_els_xri_aborted(phba, &cq_event->cqe.wcqe_axri);
 		/* Free the event processed back to the free pool */
-- 
2.16.4

