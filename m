From: James Smart <james.smart@emulex.com>
Subject: [PATCH 3/13] lpfc 8.3.41: Fixed Receive Queue varied frame size
 handling
Date: Mon, 15 Jul 2013 18:32:28 -0400
Message-ID: <1373927548.15647.20.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:4522 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758307Ab3GOWcd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jul 2013 18:32:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed Receive Queue varied frame size handling 


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |   36 ++++++++++++++++++++++++------------
 1 file changed, 24 insertions(+), 12 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-07-15 07:15:08.819055628 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-07-15 07:15:14.692055763 -0400
@@ -14703,14 +14703,20 @@ lpfc_prep_seq(struct lpfc_vport *vport,
 		first_iocbq->iocb.unsli3.rcvsli3.vpi =
 			vport->phba->vpi_ids[vport->vpi];
 		/* put the first buffer into the first IOCBq */
+		tot_len = bf_get(lpfc_rcqe_length,
+				       &seq_dmabuf->cq_event.cqe.rcqe_cmpl);
+
 		first_iocbq->context2 = &seq_dmabuf->dbuf;
 		first_iocbq->context3 = NULL;
 		first_iocbq->iocb.ulpBdeCount = 1;
-		first_iocbq->iocb.un.cont64[0].tus.f.bdeSize =
+		if (tot_len > LPFC_DATA_BUF_SIZE)
+			first_iocbq->iocb.un.cont64[0].tus.f.bdeSize =
 							LPFC_DATA_BUF_SIZE;
+		else
+			first_iocbq->iocb.un.cont64[0].tus.f.bdeSize = tot_len;
+
 		first_iocbq->iocb.un.rcvels.remoteID = sid;
-		tot_len = bf_get(lpfc_rcqe_length,
-				       &seq_dmabuf->cq_event.cqe.rcqe_cmpl);
+
 		first_iocbq->iocb.unsli3.rcvsli3.acc_len = tot_len;
 	}
 	iocbq = first_iocbq;
@@ -14726,14 +14732,17 @@ lpfc_prep_seq(struct lpfc_vport *vport,
 		if (!iocbq->context3) {
 			iocbq->context3 = d_buf;
 			iocbq->iocb.ulpBdeCount++;
-			pbde = (struct ulp_bde64 *)
-					&iocbq->iocb.unsli3.sli3Words[4];
-			pbde->tus.f.bdeSize = LPFC_DATA_BUF_SIZE;
-
 			/* We need to get the size out of the right CQE */
 			hbq_buf = container_of(d_buf, struct hbq_dmabuf, dbuf);
 			len = bf_get(lpfc_rcqe_length,
 				       &hbq_buf->cq_event.cqe.rcqe_cmpl);
+			pbde = (struct ulp_bde64 *)
+					&iocbq->iocb.unsli3.sli3Words[4];
+			if (len > LPFC_DATA_BUF_SIZE)
+				pbde->tus.f.bdeSize = LPFC_DATA_BUF_SIZE;
+			else
+				pbde->tus.f.bdeSize = len;
+
 			iocbq->iocb.unsli3.rcvsli3.acc_len += len;
 			tot_len += len;
 		} else {
@@ -14748,16 +14757,19 @@ lpfc_prep_seq(struct lpfc_vport *vport,
 				lpfc_in_buf_free(vport->phba, d_buf);
 				continue;
 			}
+			/* We need to get the size out of the right CQE */
+			hbq_buf = container_of(d_buf, struct hbq_dmabuf, dbuf);
+			len = bf_get(lpfc_rcqe_length,
+				       &hbq_buf->cq_event.cqe.rcqe_cmpl);
 			iocbq->context2 = d_buf;
 			iocbq->context3 = NULL;
 			iocbq->iocb.ulpBdeCount = 1;
-			iocbq->iocb.un.cont64[0].tus.f.bdeSize =
+			if (len > LPFC_DATA_BUF_SIZE)
+				iocbq->iocb.un.cont64[0].tus.f.bdeSize =
 							LPFC_DATA_BUF_SIZE;
+			else
+				iocbq->iocb.un.cont64[0].tus.f.bdeSize = len;
 
-			/* We need to get the size out of the right CQE */
-			hbq_buf = container_of(d_buf, struct hbq_dmabuf, dbuf);
-			len = bf_get(lpfc_rcqe_length,
-				       &hbq_buf->cq_event.cqe.rcqe_cmpl);
 			tot_len += len;
 			iocbq->iocb.unsli3.rcvsli3.acc_len = tot_len;
 




