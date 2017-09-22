From: James Smart <jsmart2021@gmail.com>
Subject: [PATCH 17/19] lpfc: Extend RDP support
Date: Thu, 21 Sep 2017 23:17:39 -0700
Message-ID: <20170922061741.12347-18-jsmart2021@gmail.com>
References: <20170922061741.12347-1-jsmart2021@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:36354 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751842AbdIVGSM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Sep 2017 02:18:12 -0400
Received: by mail-pf0-f196.google.com with SMTP id f84so88372pfj.3
        for <linux-scsi@vger.kernel.org>; Thu, 21 Sep 2017 23:18:12 -0700 (PDT)
In-Reply-To: <20170922061741.12347-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Dick Kennedy <dick.kennedy@broadcom.com>, James Smart <james.smart@broadcom.com>

From: Dick Kennedy <dick.kennedy@broadcom.com>

Support RDP and Multiple Frames

If the remote Nport is not logged in, the driver would not populate
all the descriptors in the RDP response payload. Doing so would create
a payload length that requires multiple frames due to exceeding the
default rx buffer size without an explicit login. Currently FC-LS
explicitly states the RDP response must be a single frame sequence.
Thus we did not violate the standard.

Recently, a modification to FC-LS was accepted which allows
multi-frame sequences and all vendors have indicated they are
interoperable with the change. As such, extend RDP support with the
additional fields and send a multi-frame sequence.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 3ebf6ccba6e6..b14f7c5653cd 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -5394,10 +5394,6 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 					(len + pcmd), vport, ndlp);
 	len += lpfc_rdp_res_fec_desc((struct fc_fec_rdp_desc *)(len + pcmd),
 			&rdp_context->link_stat);
-	/* Check if nport is logged, BZ190632 */
-	if (!(ndlp->nlp_flag & NLP_RPI_REGISTERED))
-		goto lpfc_skip_descriptor;
-
 	len += lpfc_rdp_res_bbc_desc((struct fc_rdp_bbc_desc *)(len + pcmd),
 				     &rdp_context->link_stat, vport);
 	len += lpfc_rdp_res_oed_temp_desc(phba,
@@ -5418,7 +5414,6 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 	len += lpfc_rdp_res_opd_desc((struct fc_rdp_opd_sfp_desc *)(len + pcmd),
 				     rdp_context->page_a0, vport);
 
-lpfc_skip_descriptor:
 	rdp_res->length = cpu_to_be32(len - 8);
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 
@@ -5540,7 +5535,6 @@ lpfc_els_rcv_rdp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	pcmd = (struct lpfc_dmabuf *) cmdiocb->context2;
 	rdp_req = (struct fc_rdp_req_frame *) pcmd->virt;
 
-
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "2422 ELS RDP Request "
 			 "dec len %d tag x%x port_id %d len %d\n",
@@ -5549,12 +5543,6 @@ lpfc_els_rcv_rdp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 			 be32_to_cpu(rdp_req->nport_id_desc.nport_id),
 			 be32_to_cpu(rdp_req->nport_id_desc.length));
 
-	if (!(ndlp->nlp_flag & NLP_RPI_REGISTERED) &&
-	    !phba->cfg_enable_SmartSAN) {
-		rjt_err = LSRJT_UNABLE_TPC;
-		rjt_expl = LSEXP_PORT_LOGIN_REQ;
-		goto error;
-	}
 	if (sizeof(struct fc_rdp_nport_desc) !=
 			be32_to_cpu(rdp_req->rdp_des_length))
 		goto rjt_logerr;
-- 
2.13.1
