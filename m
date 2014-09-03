From: James Smart <james.smart@emulex.com>
Subject: [PATCH 15/19] lpfc 10.4.8000.0: Fixed crash from page fault caused
 by use after rport delete
Date: Wed, 3 Sep 2014 12:57:43 -0400
Message-ID: <1409763463.12357.15.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:47654 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932380AbaICQ5v (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Sep 2014 12:57:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed crash from page fault caused by use after rport delete

Signed-off-by: James Smart <james.smart@emulex.com>
Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 2d929a5..310507d 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -150,6 +150,17 @@ lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
 
 		/* If the WWPN of the rport and ndlp don't match, ignore it */
 		if (rport->port_name != wwn_to_u64(ndlp->nlp_portname.u.wwn)) {
+			lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE,
+				"6789 rport name %lx != node port name %lx",
+				(unsigned long)rport->port_name,
+				(unsigned long)wwn_to_u64(
+						ndlp->nlp_portname.u.wwn));
+			put_node = rdata->pnode != NULL;
+			put_rport = ndlp->rport != NULL;
+			rdata->pnode = NULL;
+			ndlp->rport = NULL;
+			if (put_node)
+				lpfc_nlp_put(ndlp);
 			put_device(&rport->dev);
 			return;
 		}
@@ -285,6 +296,7 @@ lpfc_dev_loss_tmo_handler(struct lpfc_nodelist *ndlp)
 	if (ndlp->nlp_sid != NLP_NO_SID) {
 		warn_on = 1;
 		/* flush the target */
+		ndlp->nlp_add_flag &= ~NLP_IN_DEV_LOSS;
 		lpfc_sli_abort_iocb(vport, &phba->sli.ring[phba->sli.fcp_ring],
 				    ndlp->nlp_sid, 0, LPFC_CTX_TGT);
 	}
-- 
1.7.11.7




