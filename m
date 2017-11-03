From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 11/17] lpfc: Linux LPFC driver does not process all RSCNs
Date: Fri,  3 Nov 2017 15:56:22 -0700
Message-ID: <20171103225628.24716-12-jsmart2021@gmail.com>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:51905 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756128AbdKCW4s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2017 18:56:48 -0400
Received: by mail-qk0-f196.google.com with SMTP id n66so446496qki.8
        for <linux-scsi@vger.kernel.org>; Fri, 03 Nov 2017 15:56:48 -0700 (PDT)
In-Reply-To: <20171103225628.24716-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

During RSCN storms, the driver does not rediscover some targets.
The driver marks some RSCN as to be handled after the ones it's
working on. The driver missed processing some deferred RSCN.

Move where the driver checks for deferred RSCNs and initiate
deferred RSCN handling if the flag was set. Also revise nport state
within the RSCN confirm routine. Add some state data to a possible
debug print to aid future debugging.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c      | 19 +++++++++++++++++++
 drivers/scsi/lpfc/lpfc_els.c     |  4 +---
 drivers/scsi/lpfc/lpfc_hbadisc.c |  9 +++++++--
 3 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 33417681f5d4..0990f81524cd 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -685,6 +685,25 @@ lpfc_cmpl_ct_cmd_gid_ft(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			lpfc_els_flush_rscn(vport);
 		goto out;
 	}
+
+	spin_lock_irq(shost->host_lock);
+	if (vport->fc_flag & FC_RSCN_DEFERRED) {
+		vport->fc_flag &= ~FC_RSCN_DEFERRED;
+		spin_unlock_irq(shost->host_lock);
+
+		/*
+		 * Skip processing the NS response
+		 * Re-issue the NS cmd
+		 */
+		lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
+				 "0151 Process Deferred RSCN Data: x%x x%x\n",
+				 vport->fc_flag, vport->fc_rscn_id_cnt);
+		lpfc_els_handle_rscn(vport);
+
+		goto out;
+	}
+	spin_unlock_irq(shost->host_lock);
+
 	if (irsp->ulpStatus) {
 		/* Check for retry */
 		if (vport->fc_ns_retry < LPFC_MAX_NS_RETRY) {
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index a708d80cb609..5cfa73e8fe40 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1681,6 +1681,7 @@ lpfc_plogi_confirm_nport(struct lpfc_hba *phba, uint32_t *prsp,
 
 		/* Two ndlps cannot have the same did on the nodelist */
 		ndlp->nlp_DID = keepDID;
+		lpfc_nlp_set_state(vport, ndlp, keep_nlp_state);
 		if (phba->sli_rev == LPFC_SLI_REV4 &&
 		    active_rrqs_xri_bitmap)
 			memcpy(ndlp->active_rrqs_xri_bitmap,
@@ -6183,9 +6184,6 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 		lpfc_els_rsp_acc(vport, ELS_CMD_ACC, cmdiocb, ndlp, NULL);
 		/* send RECOVERY event for ALL nodes that match RSCN payload */
 		lpfc_rscn_recovery_check(vport);
-		spin_lock_irq(shost->host_lock);
-		vport->fc_flag &= ~FC_RSCN_DEFERRED;
-		spin_unlock_irq(shost->host_lock);
 		return 0;
 	}
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_UNSOL,
diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 3468257bda02..4577330313c0 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -5832,14 +5832,19 @@ static struct lpfc_nodelist *
 __lpfc_find_node(struct lpfc_vport *vport, node_filter filter, void *param)
 {
 	struct lpfc_nodelist *ndlp;
+	uint32_t data1;
 
 	list_for_each_entry(ndlp, &vport->fc_nodes, nlp_listp) {
 		if (filter(ndlp, param)) {
+			data1 = (((uint32_t) ndlp->nlp_state << 24) |
+				 ((uint32_t) ndlp->nlp_xri << 16) |
+				 ((uint32_t) ndlp->nlp_type << 8) |
+				 ((uint32_t) ndlp->nlp_rpi & 0xff));
 			lpfc_printf_vlog(vport, KERN_INFO, LOG_NODE,
 					 "3185 FIND node filter %p DID "
-					 "Data: x%p x%x x%x\n",
+					 "Data: x%p x%x x%x x%x\n",
 					 filter, ndlp, ndlp->nlp_DID,
-					 ndlp->nlp_flag);
+					 ndlp->nlp_flag, data1);
 			return ndlp;
 		}
 	}
-- 
2.13.1
