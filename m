From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 09/17] lpfc: Fix RDP ACC being too long.
Date: Wed, 16 Dec 2015 18:12:00 -0500
Message-ID: <5671efc0.SB0qVbj8lP/LNAjA%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f45.google.com ([209.85.220.45]:34616 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755192AbbLPXMU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Dec 2015 18:12:20 -0500
Received: by mail-pa0-f45.google.com with SMTP id wq6so31093751pac.1
        for <linux-scsi@vger.kernel.org>; Wed, 16 Dec 2015 15:12:19 -0800 (PST)
Received: from myfc17 (cm-wififw.emulex.com. [138.239.220.50])
        by smtp.gmail.com with ESMTPSA id w62sm6875332pfi.48.2015.12.16.15.12.17
        for <linux-scsi@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 16 Dec 2015 15:12:18 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix RDP ACC being too long.

Signed-off-by: Dick Kennedy <dick.kennedy@avagotech.com>
Signed-off-by: James Smart <james.smart@avagotech.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index f7a2967..817cdfc 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4824,6 +4824,7 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 	struct lpfc_nodelist *ndlp = rdp_context->ndlp;
 	struct lpfc_vport *vport = ndlp->vport;
 	struct lpfc_iocbq *elsiocb;
+	struct ulp_bde64 *bpl;
 	IOCB_t *icmd;
 	uint8_t *pcmd;
 	struct ls_rjt *stat;
@@ -4833,6 +4834,8 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 
 	if (status != SUCCESS)
 		goto error;
+
+	/* This will change once we know the true size of the RDP payload */
 	cmdsize = sizeof(struct fc_rdp_res_frame);
 
 	elsiocb = lpfc_prep_els_iocb(vport, 0, cmdsize,
@@ -4874,6 +4877,13 @@ lpfc_els_rdp_cmpl(struct lpfc_hba *phba, struct lpfc_rdp_context *rdp_context,
 	rdp_res->length = cpu_to_be32(fec_size + RDP_DESC_PAYLOAD_SIZE);
 	elsiocb->iocb_cmpl = lpfc_cmpl_els_rsp;
 
+	/* Now that we know the true size of the payload, update the BPL */
+	bpl = (struct ulp_bde64 *)
+		(((struct lpfc_dmabuf *)(elsiocb->context3))->virt);
+	bpl->tus.f.bdeSize = (fec_size + RDP_DESC_PAYLOAD_SIZE + 8);
+	bpl->tus.f.bdeFlags = 0;
+	bpl->tus.w = le32_to_cpu(bpl->tus.w);
+
 	phba->fc_stat.elsXmitACC++;
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR)
-- 
1.7.11.7

