From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 6/7] lpfc 8.1.5 : Misc small fixes
Date: Sat, 15 Apr 2006 11:53:20 -0400
Message-ID: <1145116401.3795.5.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:41651 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1030279AbWDOPxX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Apr 2006 11:53:23 -0400
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.12.10/8.12.10) with ESMTP id k3FFrLrf011047
	for <linux-scsi@vger.kernel.org>; Sat, 15 Apr 2006 08:53:22 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Contains the following misc fixes:
 - Fix build warnings
 - Race condition in lpfc_workq_post_event() could corrupt phba->work_list.
 - nlp_sid was not being initialized properly
 - Fix some RSCN handling during the re-discovery after Link Up event.

Signed-off-by: James Smart <James.Smart@emulex.com>

diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2006-04-15 11:08:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2006-04-15 11:08:39.000000000 -0400
@@ -2511,7 +2511,7 @@ lpfc_els_rcv_rscn(struct lpfc_hba * phba
 	/* If we are about to begin discovery, just ACC the RSCN.
 	 * Discovery processing will satisfy it.
 	 */
-	if (phba->hba_state < LPFC_NS_QRY) {
+	if (phba->hba_state <= LPFC_NS_QRY) {
 		lpfc_els_rsp_acc(phba, ELS_CMD_ACC, cmdiocb, ndlp, NULL,
 								newnode);
 		return 0;
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2006-04-15 11:08:27.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2006-04-15 11:08:39.000000000 -0400
@@ -311,8 +311,8 @@ lpfc_workq_post_event(struct lpfc_hba * 
 	evtp->evt_arg2  = arg2;
 	evtp->evt       = evt;
 
-	list_add_tail(&evtp->evt_listp, &phba->work_list);
 	spin_lock_irq(phba->host->host_lock);
+	list_add_tail(&evtp->evt_listp, &phba->work_list);
 	if (phba->work_wait)
 		wake_up(phba->work_wait);
 	spin_unlock_irq(phba->host->host_lock);
@@ -1071,10 +1071,6 @@ lpfc_register_remote_port(struct lpfc_hb
 	/* initialize static port data */
 	rport->maxframe_size = ndlp->nlp_maxframe;
 	rport->supported_classes = ndlp->nlp_class_sup;
-	if ((rport->scsi_target_id != -1) &&
-		(rport->scsi_target_id < MAX_FCP_TARGET)) {
-		ndlp->nlp_sid = rport->scsi_target_id;
-	}
 	rdata = rport->dd_data;
 	rdata->pnode = ndlp;
 
@@ -1087,6 +1083,10 @@ lpfc_register_remote_port(struct lpfc_hb
 	if (rport_ids.roles !=  FC_RPORT_ROLE_UNKNOWN)
 		fc_remote_port_rolechg(rport, rport_ids.roles);
 
+	if ((rport->scsi_target_id != -1) &&
+		(rport->scsi_target_id < MAX_FCP_TARGET)) {
+		ndlp->nlp_sid = rport->scsi_target_id;
+	}
 
 	return;
 }
@@ -1905,10 +1905,8 @@ lpfc_setup_disc_node(struct lpfc_hba * p
 			 */
 			if (ndlp->nlp_flag & NLP_DELAY_TMO)
 				lpfc_cancel_retry_delay_tmo(phba, ndlp);
-		} else {
-			ndlp->nlp_flag &= ~NLP_NPR_2B_DISC;
+		} else
 			ndlp = NULL;
-		}
 	} else {
 		flg = ndlp->nlp_flag & NLP_LIST_MASK;
 		if ((flg == NLP_ADISC_LIST) || (flg == NLP_PLOGI_LIST))
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2006-04-15 11:08:08.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2006-04-15 11:08:39.000000000 -0400
@@ -795,7 +795,7 @@ lpfc_get_hba_model_desc(struct lpfc_hba 
 		int    max_speed;
 		char * ports;
 		char * bus;
-	} m;
+	} m = {"<Unknown>", 0, "", ""};
 
 	pci_read_config_byte(phba->pcidev, PCI_HEADER_TYPE, &hdrtype);
 	ports = (hdrtype == 0x80) ? "2-port " : "";


