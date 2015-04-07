From: James Smart <james.smart@emulex.com>
Subject: [PATCH v3 16/20] lpfc: Fix OS crash when running loopback test in applications
Date: Tue, 7 Apr 2015 15:07:25 -0400
Message-ID: <55242aed.W+U7mxXobbo/aF4z%james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:27592 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbbDGTIV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Apr 2015 15:08:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Fix OS crash when running loopback test in applications

Signed-off-by: Dick Kennedy <dick.kennedy@emulex.com>
Signed-off-by: James Smart <james.smart@emulex.com>
---
 drivers/scsi/lpfc/lpfc_bsg.c |  1 +
 drivers/scsi/lpfc/lpfc_sli.c | 12 ++++++++----
 drivers/scsi/lpfc/lpfc_sli.h |  1 +
 3 files changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
index 6b4cf31..a056666 100644
--- a/drivers/scsi/lpfc/lpfc_bsg.c
+++ b/drivers/scsi/lpfc/lpfc_bsg.c
@@ -3194,6 +3194,7 @@ lpfc_bsg_diag_loopback_run(struct fc_bsg_job *job)
 		cmd->unsli3.rcvsli3.ox_id = 0xffff;
 	}
 	cmdiocbq->iocb_flag |= LPFC_IO_LIBDFC;
+	cmdiocbq->iocb_flag |= LPFC_IO_LOOPBACK;
 	cmdiocbq->vport = phba->pport;
 	cmdiocbq->iocb_cmpl = NULL;
 	iocb_stat = lpfc_sli_issue_iocb_wait(phba, LPFC_ELS_RING, cmdiocbq,
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index c76c2a1..48919d0 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -918,12 +918,16 @@ __lpfc_sli_get_sglq(struct lpfc_hba *phba, struct lpfc_iocbq *piocbq)
 		lpfc_cmd = (struct lpfc_scsi_buf *) piocbq->context1;
 		ndlp = lpfc_cmd->rdata->pnode;
 	} else  if ((piocbq->iocb.ulpCommand == CMD_GEN_REQUEST64_CR) &&
-			!(piocbq->iocb_flag & LPFC_IO_LIBDFC))
+			!(piocbq->iocb_flag & LPFC_IO_LIBDFC)) {
 		ndlp = piocbq->context_un.ndlp;
-	else  if (piocbq->iocb_flag & LPFC_IO_LIBDFC)
-		ndlp = piocbq->context_un.ndlp;
-	else
+	} else  if (piocbq->iocb_flag & LPFC_IO_LIBDFC) {
+		if (piocbq->iocb_flag & LPFC_IO_LOOPBACK)
+			ndlp = NULL;
+		else
+			ndlp = piocbq->context_un.ndlp;
+	} else {
 		ndlp = piocbq->context1;
+	}
 
 	list_remove_head(lpfc_sgl_list, sglq, struct lpfc_sglq, list);
 	start_sglq = sglq;
diff --git a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
index 4a01452..e8f9381 100644
--- a/drivers/scsi/lpfc/lpfc_sli.h
+++ b/drivers/scsi/lpfc/lpfc_sli.h
@@ -80,6 +80,7 @@ struct lpfc_iocbq {
 
 #define LPFC_IO_OAS		0x10000 /* OAS FCP IO */
 #define LPFC_IO_FOF		0x20000 /* FOF FCP IO */
+#define LPFC_IO_LOOPBACK	0x40000 /* Loopback IO */
 
 	uint32_t drvrTimeout;	/* driver timeout in seconds */
 	uint32_t fcp_wqidx;	/* index to FCP work queue */
-- 
1.7.11.7

