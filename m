From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 13/15] lpfc 8.1.7 : Add lpfc_sli_flush_mbox_queue() function
Date: Thu, 06 Jul 2006 15:50:43 -0400
Message-ID: <1152215443.23158.30.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:32140 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1750785AbWGFTu2
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 Jul 2006 15:50:28 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id k66JoQk8006992
	for <linux-scsi@vger.kernel.org>; Thu, 6 Jul 2006 12:50:27 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Add lpfc_sli_flush_mbox_queue() function and use it in lpfc_offline() call
to avoid deadlock on thread block.

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2006-07-05 14:49:02.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2006-07-06 15:07:40.000000000 -0400
@@ -147,6 +147,7 @@ int lpfc_sli_hba_setup(struct lpfc_hba *
 int lpfc_sli_hba_down(struct lpfc_hba *);
 int lpfc_sli_issue_mbox(struct lpfc_hba *, LPFC_MBOXQ_t *, uint32_t);
 int lpfc_sli_handle_mb_event(struct lpfc_hba *);
+int lpfc_sli_flush_mbox_queue(struct lpfc_hba *);
 int lpfc_sli_handle_slow_ring_event(struct lpfc_hba *,
 				    struct lpfc_sli_ring *, uint32_t);
 void lpfc_sli_def_mbox_cmpl(struct lpfc_hba *, LPFC_MBOXQ_t *);
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2006-07-06 15:01:03.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2006-07-06 15:07:40.000000000 -0400
@@ -1353,6 +1353,7 @@ lpfc_offline(struct lpfc_hba * phba)
 	psli = &phba->sli;
 
 	lpfc_linkdown(phba);
+	lpfc_sli_flush_mbox_queue(phba);
 
 	for (i = 0; i < psli->num_rings; i++) {
 		pring = &psli->ring[i];
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2006-07-06 14:46:13.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2006-07-06 15:07:40.000000000 -0400
@@ -578,7 +578,7 @@ lpfc_sli_handle_mb_event(struct lpfc_hba
 			/* Stray Mailbox Interrupt, mbxCommand <cmd> mbxStatus
 			   <status> */
 			lpfc_printf_log(phba,
-					KERN_ERR,
+					KERN_WARNING,
 					LOG_MBOX | LOG_SLI,
 					"%d:0304 Stray Mailbox Interrupt "
 					"mbxCommand x%x mbxStatus x%x\n",
@@ -3085,6 +3085,24 @@ lpfc_sli_issue_mbox_wait(struct lpfc_hba
 	return retval;
 }
 
+int
+lpfc_sli_flush_mbox_queue(struct lpfc_hba * phba)
+{
+	int i = 0;
+
+	while (phba->sli.sli_flag & LPFC_SLI_MBOX_ACTIVE && !phba->stopped) {
+		if (i++ > LPFC_MBOX_TMO * 1000)
+			return 1;
+
+		if (lpfc_sli_handle_mb_event(phba) == 0)
+			i = 0;
+
+		msleep(1);
+	}
+
+	return (phba->sli.sli_flag & LPFC_SLI_MBOX_ACTIVE) ? 1 : 0;
+}
+
 irqreturn_t
 lpfc_intr_handler(int irq, void *dev_id, struct pt_regs * regs)
 {


