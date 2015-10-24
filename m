From: Punit Vara <punitvara@gmail.com>
Subject: [PATCH v2 1/2] scsi: lpfc: Use kzalloc instead of kmalloc
Date: Sat, 24 Oct 2015 12:36:56 +0530
Message-ID: <1445670416-3705-1-git-send-email-punitvara@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@odin.com
Cc: don.brace@pmcs.com, storagedev@pmcs.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, mrochs@linux.vnet.ibm.com, Punit Vara <punitvara@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patch is to the lpfc_els.c which resolves following warning
reported by coccicheck:

WARNING: kzalloc should be used for rdp_context, instead of
kmalloc/memset

Signed-off-by: Punit Vara <punitvara@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 36bf58b..9729ab1 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4990,13 +4990,12 @@ lpfc_els_rcv_rdp(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	if (RDP_NPORT_ID_SIZE !=
 			be32_to_cpu(rdp_req->nport_id_desc.length))
 		goto rjt_logerr;
-	rdp_context = kmalloc(sizeof(struct lpfc_rdp_context), GFP_KERNEL);
+	rdp_context = kzalloc(sizeof(struct lpfc_rdp_context), GFP_KERNEL);
 	if (!rdp_context) {
 		rjt_err = LSRJT_UNABLE_TPC;
 		goto error;
 	}
 
-	memset(rdp_context, 0, sizeof(struct lpfc_rdp_context));
 	cmd = &cmdiocb->iocb;
 	rdp_context->ndlp = lpfc_nlp_get(ndlp);
 	rdp_context->ox_id = cmd->unsli3.rcvsli3.ox_id;
-- 
2.5.3
