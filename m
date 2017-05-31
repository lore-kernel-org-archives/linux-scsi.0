From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 14/15] lpfc: Fix vports not logging into target
Date: Tue, 30 May 2017 23:04:38 -0700
Message-ID: <20170531060439.2073-15-jsmart2021@gmail.com>
References: <20170531060439.2073-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:36517 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdEaGFM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 31 May 2017 02:05:12 -0400
Received: by mail-qk0-f193.google.com with SMTP id y128so733726qka.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2017 23:05:12 -0700 (PDT)
In-Reply-To: <20170531060439.2073-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

vports cannot login to target.

For vports, lpfc_nodelist is allocated for targets only on
completion of GFF_ID command. Driver checks if lpfc_nodelist
exists for target before sending GFF_ID. So, GFF_ID and
PLOGI are not sent.

As mentioned by the comment in lpfc_prep_node_fc4type() routine,
do not send GFF_ID only if this NPortID is previously identified
as FCP target. Send GFF_ID if it is a newly identified remote
port from GID_FT response.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index f2cd19c6c2df..2853a6d352f8 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -503,26 +503,23 @@ lpfc_prep_node_fc4type(struct lpfc_vport *vport, uint32_t Did, uint8_t fc4_type)
 				Did, vport->fc_flag, vport->fc_rscn_id_cnt);
 
 			/*
-			 * This NPortID was previously a FCP target,
+			 * This NPortID was previously a FCP/NVMe target,
 			 * Don't even bother to send GFF_ID.
 			 */
 			ndlp = lpfc_findnode_did(vport, Did);
-			if (ndlp && NLP_CHK_NODE_ACT(ndlp))
-				ndlp->nlp_fc4_type = fc4_type;
-
-			if (ndlp && NLP_CHK_NODE_ACT(ndlp)) {
-				ndlp->nlp_fc4_type = fc4_type;
-
-				if (ndlp->nlp_type & NLP_FCP_TARGET)
-					lpfc_setup_disc_node(vport, Did);
-
-				else if (lpfc_ns_cmd(vport, SLI_CTNS_GFF_ID,
-							0, Did) == 0)
-					vport->num_disc_nodes++;
-
-				else
-					lpfc_setup_disc_node(vport, Did);
-			}
+			if (ndlp && NLP_CHK_NODE_ACT(ndlp) &&
+			    (ndlp->nlp_type &
+			    (NLP_FCP_TARGET | NLP_NVME_TARGET))) {
+				if (fc4_type == FC_TYPE_FCP)
+					ndlp->nlp_fc4_type |= NLP_FC4_FCP;
+				if (fc4_type == FC_TYPE_NVME)
+					ndlp->nlp_fc4_type |= NLP_FC4_NVME;
+				lpfc_setup_disc_node(vport, Did);
+			} else if (lpfc_ns_cmd(vport, SLI_CTNS_GFF_ID,
+				   0, Did) == 0)
+				vport->num_disc_nodes++;
+			else
+				lpfc_setup_disc_node(vport, Did);
 		} else {
 			lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_CT,
 				"Skip2 GID_FTrsp: did:x%x flg:x%x cnt:%d",
-- 
2.11.0
