From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 10/15] lpfc 8.2.8 : Add support for PCI-EEH permanent
	disabling
Date: Sun, 24 Aug 2008 21:50:11 -0400
Message-ID: <1219629011.7890.39.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:52504 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbYHYBuI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Aug 2008 21:50:08 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id m7P1o7IK019991
	for <linux-scsi@vger.kernel.org>; Sun, 24 Aug 2008 18:50:08 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Add support for PCI-EEH permanent-disabling a device via lpfc_pci_remove_one()


 Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_crtn.h    |    2 +
 lpfc_hbadisc.c |    2 -
 lpfc_init.c    |    9 +++++++-
 lpfc_scsi.c    |   29 +++++++++++++++++++++++++
 lpfc_sli.c     |   64 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 103 insertions(+), 3 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_crtn.h b/drivers/scsi/lpfc/lpfc_crtn.h
--- a/drivers/scsi/lpfc/lpfc_crtn.h	2008-08-24 20:43:45.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_crtn.h	2008-08-24 20:47:07.000000000 -0400
@@ -199,6 +199,7 @@ int lpfc_sli_issue_iocb(struct lpfc_hba 
 			struct lpfc_iocbq *, uint32_t);
 void lpfc_sli_pcimem_bcopy(void *, void *, uint32_t);
 void lpfc_sli_abort_iocb_ring(struct lpfc_hba *, struct lpfc_sli_ring *);
+void lpfc_sli_flush_fcp_rings(struct lpfc_hba *);
 int lpfc_sli_ringpostbuf_put(struct lpfc_hba *, struct lpfc_sli_ring *,
 			     struct lpfc_dmabuf *);
 struct lpfc_dmabuf *lpfc_sli_ringpostbuf_get(struct lpfc_hba *,
@@ -290,6 +291,7 @@ void lpfc_unblock_fabric_iocbs(struct lp
 void lpfc_adjust_queue_depth(struct lpfc_hba *);
 void lpfc_ramp_down_queue_handler(struct lpfc_hba *);
 void lpfc_ramp_up_queue_handler(struct lpfc_hba *);
+void lpfc_scsi_dev_block(struct lpfc_hba *);
 
 #define ScsiResult(host_code, scsi_code) (((host_code) << 16) | scsi_code)
 #define HBA_EVENT_RSCN                   5
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-08-24 20:45:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2008-08-24 20:47:07.000000000 -0400
@@ -245,8 +245,6 @@ lpfc_dev_loss_tmo_handler(struct lpfc_no
 		lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
 				    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 	}
-	if (vport->load_flag & FC_UNLOADING)
-		warn_on = 0;
 
 	if (warn_on) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_DISCOVERY,
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2008-08-24 20:45:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2008-08-24 20:47:07.000000000 -0400
@@ -2661,8 +2661,15 @@ static pci_ers_result_t lpfc_io_error_de
 	struct lpfc_sli *psli = &phba->sli;
 	struct lpfc_sli_ring  *pring;
 
-	if (state == pci_channel_io_perm_failure)
+	if (state == pci_channel_io_perm_failure) {
+		lpfc_printf_log(phba, KERN_ERR, LOG_INIT,
+				"0472 PCI channel I/O permanent failure\n");
+		/* Block all SCSI devices' I/Os on the host */
+		lpfc_scsi_dev_block(phba);
+		/* Clean up all driver's outstanding SCSI I/Os */
+		lpfc_sli_flush_fcp_rings(phba);
 		return PCI_ERS_RESULT_DISCONNECT;
+	}
 
 	pci_disable_device(pdev);
 	/*
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2008-08-24 20:44:33.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2008-08-24 20:47:07.000000000 -0400
@@ -183,6 +183,35 @@ lpfc_ramp_up_queue_handler(struct lpfc_h
 	atomic_set(&phba->num_cmd_success, 0);
 }
 
+/**
+ * lpfc_scsi_dev_block: set all scsi hosts to block state.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function walks vport list and set each SCSI host to block state
+ * by invoking fc_remote_port_delete() routine. This function is invoked
+ * with EEH when device's PCI slot has been permanently disabled.
+ **/
+void
+lpfc_scsi_dev_block(struct lpfc_hba *phba)
+{
+	struct lpfc_vport **vports;
+	struct Scsi_Host  *shost;
+	struct scsi_device *sdev;
+	struct fc_rport *rport;
+	int i;
+
+	vports = lpfc_create_vport_work_array(phba);
+	if (vports != NULL)
+		for (i = 0; i <= phba->max_vpi && vports[i] != NULL; i++) {
+			shost = lpfc_shost_from_vport(vports[i]);
+			shost_for_each_device(sdev, shost) {
+				rport = starget_to_rport(scsi_target(sdev));
+				fc_remote_port_delete(rport);
+			}
+		}
+	lpfc_destroy_vport_work_array(phba, vports);
+}
+
 /*
  * This routine allocates a scsi buffer, which contains all the necessary
  * information needed to initiate a SCSI I/O.  The non-DMAable buffer region
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2008-08-24 20:45:48.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2008-08-24 20:47:07.000000000 -0400
@@ -2377,6 +2377,70 @@ lpfc_sli_abort_iocb_ring(struct lpfc_hba
 }
 
 /**
+ * lpfc_sli_flush_fcp_rings: flush all iocbs in the fcp ring.
+ * @phba: Pointer to HBA context object.
+ *
+ * This function flushes all iocbs in the fcp ring and frees all the iocb
+ * objects in txq and txcmplq. This function will not issue abort iocbs
+ * for all the iocb commands in txcmplq, they will just be returned with
+ * IOERR_SLI_DOWN. This function is invoked with EEH when device's PCI
+ * slot has been permanently disabled.
+ **/
+void
+lpfc_sli_flush_fcp_rings(struct lpfc_hba *phba)
+{
+	LIST_HEAD(txq);
+	LIST_HEAD(txcmplq);
+	struct lpfc_iocbq *iocb;
+	IOCB_t *cmd = NULL;
+	struct lpfc_sli *psli = &phba->sli;
+	struct lpfc_sli_ring  *pring;
+
+	/* Currently, only one fcp ring */
+	pring = &psli->ring[psli->fcp_ring];
+
+	spin_lock_irq(&phba->hbalock);
+	/* Retrieve everything on txq */
+	list_splice_init(&pring->txq, &txq);
+	pring->txq_cnt = 0;
+
+	/* Retrieve everything on the txcmplq */
+	list_splice_init(&pring->txcmplq, &txcmplq);
+	pring->txcmplq_cnt = 0;
+	spin_unlock_irq(&phba->hbalock);
+
+	/* Flush the txq */
+	while (!list_empty(&txq)) {
+		iocb = list_get_first(&txq, struct lpfc_iocbq, list);
+		cmd = &iocb->iocb;
+		list_del_init(&iocb->list);
+
+		if (!iocb->iocb_cmpl)
+			lpfc_sli_release_iocbq(phba, iocb);
+		else {
+			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
+			cmd->un.ulpWord[4] = IOERR_SLI_DOWN;
+			(iocb->iocb_cmpl) (phba, iocb, iocb);
+		}
+	}
+
+	/* Flush the txcmpq */
+	while (!list_empty(&txcmplq)) {
+		iocb = list_get_first(&txcmplq, struct lpfc_iocbq, list);
+		cmd = &iocb->iocb;
+		list_del_init(&iocb->list);
+
+		if (!iocb->iocb_cmpl)
+			lpfc_sli_release_iocbq(phba, iocb);
+		else {
+			cmd->ulpStatus = IOSTAT_LOCAL_REJECT;
+			cmd->un.ulpWord[4] = IOERR_SLI_DOWN;
+			(iocb->iocb_cmpl) (phba, iocb, iocb);
+		}
+	}
+}
+
+/**
  * lpfc_sli_brdready: Check for host status bits.
  * @phba: Pointer to HBA context object.
  * @mask: Bit mask to be checked.


