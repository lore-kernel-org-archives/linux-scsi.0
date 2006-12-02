From: James Smart <James.Smart@Emulex.Com>
Subject: [PATCH 3/9] lpfc 8.1.11 :  Fix Memory leaks
Date: Sat, 02 Dec 2006 13:34:28 -0500
Message-ID: <1165084468.27443.24.camel@localhost.localdomain>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:55767 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1163042AbWLBQHE
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Dec 2006 11:07:04 -0500
Received: from xbl3.ad.emulex.com (xbl3.ma.emulex.com [138.239.73.12])
	by emulex.emulex.com (8.13.6/8.13.6) with ESMTP id kB2G71ah009324
	for <linux-scsi@vger.kernel.org>; Sat, 2 Dec 2006 08:07:04 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix Memory leaks associated with mbox cmds READ_LA, READ_SPARAM, REG_LOGIN

Signed-off-by: James Smart <James.Smart@emulex.com>


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2006-12-02 11:57:07.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_els.c	2006-12-02 11:59:51.000000000 -0500
@@ -243,6 +243,7 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_h
 		struct serv_parm *sp, IOCB_t *irsp)
 {
 	LPFC_MBOXQ_t *mbox;
+	struct lpfc_dmabuf *mp;
 	int rc;
 
 	spin_lock_irq(phba->host->host_lock);
@@ -307,10 +308,14 @@ lpfc_cmpl_els_flogi_fabric(struct lpfc_h
 
 	rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT | MBX_STOP_IOCB);
 	if (rc == MBX_NOT_FINISHED)
-		goto fail_free_mbox;
+		goto fail_issue_reg_login;
 
 	return 0;
 
+ fail_issue_reg_login:
+	mp = (struct lpfc_dmabuf *) mbox->context1;
+	lpfc_mbuf_free(phba, mp->virt, mp->phys);
+	kfree(mp);
  fail_free_mbox:
 	mempool_free(mbox, phba->mbox_mem_pool);
  fail:
@@ -1857,6 +1862,7 @@ lpfc_cmpl_els_acc(struct lpfc_hba * phba
 	IOCB_t *irsp;
 	struct lpfc_nodelist *ndlp;
 	LPFC_MBOXQ_t *mbox = NULL;
+	struct lpfc_dmabuf *mp;
 
 	irsp = &rspiocb->iocb;
 
@@ -1868,6 +1874,11 @@ lpfc_cmpl_els_acc(struct lpfc_hba * phba
 	/* Check to see if link went down during discovery */
 	if ((lpfc_els_chk_latt(phba)) || !ndlp) {
 		if (mbox) {
+			mp = (struct lpfc_dmabuf *) mbox->context1;
+			if (mp) {
+				lpfc_mbuf_free(phba, mp->virt, mp->phys);
+				kfree(mp);
+			}
 			mempool_free( mbox, phba->mbox_mem_pool);
 		}
 		goto out;
@@ -1899,9 +1910,7 @@ lpfc_cmpl_els_acc(struct lpfc_hba * phba
 			}
 			/* NOTE: we should have messages for unsuccessful
 			   reglogin */
-			mempool_free( mbox, phba->mbox_mem_pool);
 		} else {
-			mempool_free( mbox, phba->mbox_mem_pool);
 			/* Do not call NO_LIST for lpfc_els_abort'ed ELS cmds */
 			if (!((irsp->ulpStatus == IOSTAT_LOCAL_REJECT) &&
 			      ((irsp->un.ulpWord[4] == IOERR_SLI_ABORTED) ||
@@ -1913,6 +1922,12 @@ lpfc_cmpl_els_acc(struct lpfc_hba * phba
 				}
 			}
 		}
+		mp = (struct lpfc_dmabuf *) mbox->context1;
+		if (mp) {
+			lpfc_mbuf_free(phba, mp->virt, mp->phys);
+			kfree(mp);
+		}
+		mempool_free(mbox, phba->mbox_mem_pool);
 	}
 out:
 	if (ndlp) {
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2006-12-02 11:57:07.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2006-12-02 11:59:51.000000000 -0500
@@ -715,6 +715,9 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 {
 	int i;
 	LPFC_MBOXQ_t *sparam_mbox, *cfglink_mbox;
+	struct lpfc_dmabuf *mp;
+	int rc;
+
 	sparam_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 	cfglink_mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
 
@@ -793,16 +796,27 @@ lpfc_mbx_process_link_up(struct lpfc_hba
 	if (sparam_mbox) {
 		lpfc_read_sparam(phba, sparam_mbox);
 		sparam_mbox->mbox_cmpl = lpfc_mbx_cmpl_read_sparam;
-		lpfc_sli_issue_mbox(phba, sparam_mbox,
+		rc = lpfc_sli_issue_mbox(phba, sparam_mbox,
 						(MBX_NOWAIT | MBX_STOP_IOCB));
+		if (rc == MBX_NOT_FINISHED) {
+			mp = (struct lpfc_dmabuf *) sparam_mbox->context1;
+			lpfc_mbuf_free(phba, mp->virt, mp->phys);
+			kfree(mp);
+			mempool_free(sparam_mbox, phba->mbox_mem_pool);
+			if (cfglink_mbox)
+				mempool_free(cfglink_mbox, phba->mbox_mem_pool);
+			return;
+		}
 	}
 
 	if (cfglink_mbox) {
 		phba->hba_state = LPFC_LOCAL_CFG_LINK;
 		lpfc_config_link(phba, cfglink_mbox);
 		cfglink_mbox->mbox_cmpl = lpfc_mbx_cmpl_local_config_link;
-		lpfc_sli_issue_mbox(phba, cfglink_mbox,
+		rc = lpfc_sli_issue_mbox(phba, cfglink_mbox,
 						(MBX_NOWAIT | MBX_STOP_IOCB));
+		if (rc == MBX_NOT_FINISHED)
+			mempool_free(cfglink_mbox, phba->mbox_mem_pool);
 	}
 }
 
diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2006-12-02 11:57:08.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_init.c	2006-12-02 11:59:51.000000000 -0500
@@ -611,7 +611,7 @@ lpfc_handle_latt(struct lpfc_hba * phba)
 	pmb->mbox_cmpl = lpfc_mbx_cmpl_read_la;
 	rc = lpfc_sli_issue_mbox (phba, pmb, (MBX_NOWAIT | MBX_STOP_IOCB));
 	if (rc == MBX_NOT_FINISHED)
-		goto lpfc_handle_latt_free_mp;
+		goto lpfc_handle_latt_free_mbuf;
 
 	/* Clear Link Attention in HA REG */
 	spin_lock_irq(phba->host->host_lock);
@@ -621,6 +621,8 @@ lpfc_handle_latt(struct lpfc_hba * phba)
 
 	return;
 
+lpfc_handle_latt_free_mbuf:
+	lpfc_mbuf_free(phba, mp->virt, mp->phys);
 lpfc_handle_latt_free_mp:
 	kfree(mp);
 lpfc_handle_latt_free_pmb:
diff -upNr a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c	2006-12-02 11:53:07.000000000 -0500
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c	2006-12-02 11:59:51.000000000 -0500
@@ -739,7 +739,7 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 			    uint32_t evt)
 {
 	struct lpfc_iocbq *cmdiocb, *rspiocb;
-	struct lpfc_dmabuf *pcmd, *prsp;
+	struct lpfc_dmabuf *pcmd, *prsp, *mp;
 	uint32_t *lp;
 	IOCB_t *irsp;
 	struct serv_parm *sp;
@@ -829,6 +829,9 @@ lpfc_cmpl_plogi_plogi_issue(struct lpfc_
 				      NLP_REGLOGIN_LIST);
 			return ndlp->nlp_state;
 		}
+		mp = (struct lpfc_dmabuf *)mbox->context1;
+		lpfc_mbuf_free(phba, mp->virt, mp->phys);
+		kfree(mp);
 		mempool_free(mbox, phba->mbox_mem_pool);
 	} else {
 		mempool_free(mbox, phba->mbox_mem_pool);


