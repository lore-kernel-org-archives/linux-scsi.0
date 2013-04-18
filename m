From: James Smart <james.smart@emulex.com>
Subject: [PATCH 16/22] lpfc 8.3.39: Fixed system panic during EEH recovery
 due to midlayer acting on outstanding I/O
Date: Wed, 17 Apr 2013 20:18:47 -0400
Message-ID: <1366244327.1513.17.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:15685 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935682Ab3DRASt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:18:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed system panic during EEH recovery due to midlayer acting on outstanding I/O


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |   12 ++++++------
 lpfc_sli.c  |    4 ++++
 2 files changed, 10 insertions(+), 6 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-04-15 18:51:49.209075552 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-04-15 18:52:05.751075929 -0400
@@ -9314,15 +9314,15 @@ lpfc_sli_prep_dev_for_reset(struct lpfc_
 	/* Block all SCSI devices' I/Os on the host */
 	lpfc_scsi_dev_block(phba);
 
+	/* Flush all driver's outstanding SCSI I/Os as we are to reset */
+	lpfc_sli_flush_fcp_rings(phba);
+
 	/* stop all timers */
 	lpfc_stop_hba_timers(phba);
 
 	/* Disable interrupt and pci device */
 	lpfc_sli_disable_intr(phba);
 	pci_disable_device(phba->pcidev);
-
-	/* Flush all driver's outstanding SCSI I/Os as we are to reset */
-	lpfc_sli_flush_fcp_rings(phba);
 }
 
 /**
@@ -10067,6 +10067,9 @@ lpfc_sli4_prep_dev_for_reset(struct lpfc
 	/* Block all SCSI devices' I/Os on the host */
 	lpfc_scsi_dev_block(phba);
 
+	/* Flush all driver's outstanding SCSI I/Os as we are to reset */
+	lpfc_sli_flush_fcp_rings(phba);
+
 	/* stop all timers */
 	lpfc_stop_hba_timers(phba);
 
@@ -10074,9 +10077,6 @@ lpfc_sli4_prep_dev_for_reset(struct lpfc
 	lpfc_sli4_disable_intr(phba);
 	lpfc_sli4_queue_destroy(phba);
 	pci_disable_device(phba->pcidev);
-
-	/* Flush all driver's outstanding SCSI I/Os as we are to reset */
-	lpfc_sli_flush_fcp_rings(phba);
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-04-15 18:51:49.194075552 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-04-15 18:52:09.844076022 -0400
@@ -8452,10 +8452,14 @@ __lpfc_sli_issue_iocb_s4(struct lpfc_hba
 
 	if ((piocb->iocb_flag & LPFC_IO_FCP) ||
 		(piocb->iocb_flag & LPFC_USE_FCPWQIDX)) {
+		if (unlikely(!phba->sli4_hba.fcp_wq))
+			return IOCB_ERROR;
 		if (lpfc_sli4_wq_put(phba->sli4_hba.fcp_wq[piocb->fcp_wqidx],
 				     &wqe))
 			return IOCB_ERROR;
 	} else {
+		if (unlikely(!phba->sli4_hba.els_wq))
+			return IOCB_ERROR;
 		if (lpfc_sli4_wq_put(phba->sli4_hba.els_wq, &wqe))
 			return IOCB_ERROR;
 	}



