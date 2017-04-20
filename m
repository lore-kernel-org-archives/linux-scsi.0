From: jsmart2021@gmail.com
Subject: ["PATCH-v2" 03/22] Fix rejected nvme LS Req.
Date: Thu, 20 Apr 2017 15:04:29 -0700
Message-ID: <20170420220448.27095-4-jsmart2021@gmail.com>
References: <20170420220448.27095-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:34881 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S947788AbdDTWFC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 18:05:02 -0400
Received: by mail-oi0-f67.google.com with SMTP id m34so5011836oik.2
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2017 15:05:02 -0700 (PDT)
In-Reply-To: <20170420220448.27095-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com
Cc: James Smart <jsmart2021@gmail.com>, Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: James Smart <jsmart2021@gmail.com>

In this case, the NVME initiator is sending an LS REQ command on an NDLP
that is not MAPPED.  The FW rejects it.

The lpfc_nvme_ls_req routine checks for a NULL ndlp pointer
but does not check the NDLP state.  This allows the routine
to send an LS IO when the ndlp is disconnected.

Check the ndlp for NULL, actual node, Target and MAPPED
or Initiator and UNMAPPED. This avoids Fabric nodes getting
the Create Association or Create Connection commands.  Initiators
are free to Reject either Create.
Also some of the messages numbers in lpfc_nvme_ls_req were changed because
they were already used in other log messages.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index a39d72c..cbf3fe3 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -401,6 +401,7 @@ lpfc_nvme_ls_req(struct nvme_fc_local_port *pnvme_lport,
 	struct lpfc_nodelist *ndlp;
 	struct ulp_bde64 *bpl;
 	struct lpfc_dmabuf *bmp;
+	uint16_t ntype, nstate;
 
 	/* there are two dma buf in the request, actually there is one and
 	 * the second one is just the start address + cmd size.
@@ -417,11 +418,26 @@ lpfc_nvme_ls_req(struct nvme_fc_local_port *pnvme_lport,
 	vport = lport->vport;
 
 	ndlp = lpfc_findnode_did(vport, pnvme_rport->port_id);
-	if (!ndlp) {
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_NVME_DISC,
-				 "6043 Could not find node for DID %x\n",
+	if (!ndlp || !NLP_CHK_NODE_ACT(ndlp)) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE | LOG_NVME_IOERR,
+				 "6051 DID x%06x not an active rport.\n",
 				 pnvme_rport->port_id);
-		return 1;
+		return -ENODEV;
+	}
+
+	/* The remote node has to be a mapped nvme target or an
+	 * unmapped nvme initiator or it's an error.
+	 */
+	ntype = ndlp->nlp_type;
+	nstate = ndlp->nlp_state;
+	if ((ntype & NLP_NVME_TARGET && nstate != NLP_STE_MAPPED_NODE) ||
+	    (ntype & NLP_NVME_INITIATOR && nstate != NLP_STE_UNMAPPED_NODE)) {
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_NODE | LOG_NVME_IOERR,
+				 "6088 DID x%06x not ready for "
+				 "IO. State x%x, Type x%x\n",
+				 pnvme_rport->port_id,
+				 ndlp->nlp_state, ndlp->nlp_type);
+		return -ENODEV;
 	}
 	bmp = kmalloc(sizeof(struct lpfc_dmabuf), GFP_KERNEL);
 	if (!bmp) {
@@ -456,7 +472,7 @@ lpfc_nvme_ls_req(struct nvme_fc_local_port *pnvme_lport,
 
 	/* Expand print to include key fields. */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME_DISC,
-			 "6051 ENTER.  lport %p, rport %p lsreq%p rqstlen:%d "
+			 "6149 ENTER.  lport %p, rport %p lsreq%p rqstlen:%d "
 			 "rsplen:%d %pad %pad\n",
 			 pnvme_lport, pnvme_rport,
 			 pnvme_lsreq, pnvme_lsreq->rqstlen,
-- 
2.9.3
