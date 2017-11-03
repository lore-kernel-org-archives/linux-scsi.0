From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 12/17] lpfc: correct port registrations with nvme_fc
Date: Fri,  3 Nov 2017 15:56:23 -0700
Message-ID: <20171103225628.24716-13-jsmart2021@gmail.com>
References: <20171103225628.24716-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:48087 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756073AbdKCW4t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2017 18:56:49 -0400
Received: by mail-qt0-f196.google.com with SMTP id z50so5066778qtj.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Nov 2017 15:56:49 -0700 (PDT)
In-Reply-To: <20171103225628.24716-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

The driver currently registers any remote port that has NVME support.
It should only be registering target ports.

Register only target ports.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 20 ++++++++++++--------
 drivers/scsi/lpfc/lpfc_nvme.c    |  3 ++-
 2 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 4577330313c0..ffceebf420f4 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4176,12 +4176,14 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 		if (ndlp->nlp_fc4_type & NLP_FC4_NVME) {
 			vport->phba->nport_event_cnt++;
-			if (vport->phba->nvmet_support == 0)
-				/* Start devloss */
-				lpfc_nvme_unregister_port(vport, ndlp);
-			else
+			if (vport->phba->nvmet_support == 0) {
+				/* Start devloss if target. */
+				if (ndlp->nlp_type & NLP_NVME_TARGET)
+					lpfc_nvme_unregister_port(vport, ndlp);
+			} else {
 				/* NVMET has no upcall. */
 				lpfc_nlp_put(ndlp);
+			}
 		}
 	}
 
@@ -4205,11 +4207,13 @@ lpfc_nlp_state_cleanup(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		    ndlp->nlp_fc4_type & NLP_FC4_NVME) {
 			if (vport->phba->nvmet_support == 0) {
 				/* Register this rport with the transport.
-				 * Initiators take the NDLP ref count in
-				 * the register.
+				 * Only NVME Target Rports are registered with
+				 * the transport.
 				 */
-				vport->phba->nport_event_cnt++;
-				lpfc_nvme_register_port(vport, ndlp);
+				if (ndlp->nlp_type & NLP_NVME_TARGET) {
+					vport->phba->nport_event_cnt++;
+					lpfc_nvme_register_port(vport, ndlp);
+				}
 			} else {
 				/* Just take an NDLP ref count since the
 				 * target does not register rports.
diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index db1ed426f7e6..d3ada630b427 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -2473,7 +2473,8 @@ lpfc_nvme_unregister_port(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp)
 	/* Sanity check ndlp type.  Only call for NVME ports. Don't
 	 * clear any rport state until the transport calls back.
 	 */
-	if (ndlp->nlp_type & (NLP_NVME_TARGET | NLP_NVME_INITIATOR)) {
+
+	if (ndlp->nlp_type & NLP_NVME_TARGET) {
 		init_completion(&rport->rport_unreg_done);
 
 		/* No concern about the role change on the nvme remoteport.
-- 
2.13.1
