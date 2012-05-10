From: James Smart <james.smart@emulex.com>
Subject: [PATCH 04/20] lpfc 8.3.31: Fix initiator sending flogi after acking
 flogi from target
Date: Wed, 9 May 2012 21:16:42 -0400
Message-ID: <1336612612.1996.33.camel@ogier>
Reply-To: james.smart@emulex.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:27878 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752350Ab2EJBRM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 9 May 2012 21:17:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix initiator sending flogi after acking flogi from target.


Signed-off-by: Alex Iannicelli <alex.iannicelli@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_els.c     |   28 +++++++++++++++++++++++++---
 lpfc_hbadisc.c |    2 +-
 2 files changed, 26 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
--- a/drivers/scsi/lpfc/lpfc_els.c	2012-05-06 13:15:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_els.c	2012-05-07 10:01:03.000000000 -0400
@@ -3803,10 +3803,11 @@ lpfc_els_rsp_acc(struct lpfc_vport *vpor
 	/* Xmit ELS ACC response tag <ulpIoTag> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "0128 Xmit ELS ACC response tag x%x, XRI: x%x, "
-			 "DID: x%x, nlp_flag: x%x nlp_state: x%x RPI: x%x\n",
+			 "DID: x%x, nlp_flag: x%x nlp_state: x%x RPI: x%x "
+			 "fc_flag x%x\n",
 			 elsiocb->iotag, elsiocb->iocb.ulpContext,
 			 ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
-			 ndlp->nlp_rpi);
+			 ndlp->nlp_rpi, vport->fc_flag);
 	if (ndlp->nlp_flag & NLP_LOGO_ACC) {
 		spin_lock_irq(shost->host_lock);
 		ndlp->nlp_flag &= ~NLP_LOGO_ACC;
@@ -4976,7 +4977,10 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vp
 			spin_lock_irq(shost->host_lock);
 			vport->fc_flag |= FC_PT2PT_PLOGI;
 			spin_unlock_irq(shost->host_lock);
-		}
+			vport->fc_myDID = PT2PT_LocalID;
+		} else
+			vport->fc_myDID = PT2PT_RemoteID;
+		vport->port_state = LPFC_FLOGI;
 		spin_lock_irq(shost->host_lock);
 		vport->fc_flag |= FC_PT2PT;
 		vport->fc_flag &= ~(FC_FABRIC | FC_PUBLIC_LOOP);
@@ -4995,7 +4999,25 @@ lpfc_els_rcv_flogi(struct lpfc_vport *vp
 	/* Send back ACC */
 	lpfc_els_rsp_acc(vport, ELS_CMD_PLOGI, cmdiocb, ndlp, NULL);
 
+	if (!(vport->fc_flag & FC_PT2PT_PLOGI)) {
+		mbox = mempool_alloc(phba->mbox_mem_pool, GFP_KERNEL);
+		if (!mbox)
+			goto fail;
+
+		lpfc_config_link(phba, mbox);
+
+		mbox->mbox_cmpl = lpfc_sli_def_mbox_cmpl;
+		mbox->vport = vport;
+		rc = lpfc_sli_issue_mbox(phba, mbox, MBX_NOWAIT);
+		if (rc == MBX_NOT_FINISHED) {
+			mempool_free(mbox, phba->mbox_mem_pool);
+			goto fail;
+		}
+	}
+
 	return 0;
+fail:
+	return 1;
 }
 
 /**
diff -upNr a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-05-06 13:15:39.000000000 -0400
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c	2012-05-07 10:01:03.000000000 -0400
@@ -1094,7 +1094,7 @@ lpfc_mbx_cmpl_local_config_link(struct l
 	/* Start discovery by sending a FLOGI. port_state is identically
 	 * LPFC_FLOGI while waiting for FLOGI cmpl
 	 */
-	if (vport->port_state != LPFC_FLOGI)
+	if (vport->port_state != LPFC_FLOGI || vport->fc_flag & FC_PT2PT_PLOGI)
 		lpfc_initial_flogi(vport);
 	return;
 



