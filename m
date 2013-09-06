From: James Smart <james.smart@emulex.com>
Subject: [PATCH 11/18] lpfc 8.3.42: Fixed driver iocbq structure's iocb_flag
 field running out of space
Date: Fri, 6 Sep 2013 12:20:51 -0400
Message-ID: <1378484451.14051.30.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:22348 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757576Ab3IFQV2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:21:28 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed driver iocbq structure's iocb_flag field running out of space


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_bsg.c |   14 +++++++-------
 lpfc_sli.h |    5 ++---
 2 files changed, 9 insertions(+), 10 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_bsg.c b/drivers/scsi/lpfc/lpfc_bsg.c
--- a/drivers/scsi/lpfc/lpfc_bsg.c	2013-09-06 10:04:12.343058495 -0400
+++ b/drivers/scsi/lpfc/lpfc_bsg.c	2013-09-06 10:04:19.543058659 -0400
@@ -319,7 +319,7 @@ lpfc_bsg_send_mgmt_cmd_cmp(struct lpfc_h
 
 	/* Close the timeout handler abort window */
 	spin_lock_irqsave(&phba->hbalock, flags);
-	cmdiocbq->iocb_aux_flag &= ~LPFC_IO_CMD_OUTSTANDING;
+	cmdiocbq->iocb_flag &= ~LPFC_IO_CMD_OUTSTANDING;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	iocb = &dd_data->context_un.iocb;
@@ -513,7 +513,7 @@ lpfc_bsg_send_mgmt_cmd(struct fc_bsg_job
 		/* make sure the I/O had not been completed yet */
 		if (cmdiocbq->iocb_flag & LPFC_IO_LIBDFC) {
 			/* open up abort window to timeout handler */
-			cmdiocbq->iocb_aux_flag |= LPFC_IO_CMD_OUTSTANDING;
+			cmdiocbq->iocb_flag |= LPFC_IO_CMD_OUTSTANDING;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return 0; /* done for now */
@@ -595,7 +595,7 @@ lpfc_bsg_rport_els_cmp(struct lpfc_hba *
 
 	/* Close the timeout handler abort window */
 	spin_lock_irqsave(&phba->hbalock, flags);
-	cmdiocbq->iocb_aux_flag &= ~LPFC_IO_CMD_OUTSTANDING;
+	cmdiocbq->iocb_flag &= ~LPFC_IO_CMD_OUTSTANDING;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	rsp = &rspiocbq->iocb;
@@ -748,7 +748,7 @@ lpfc_bsg_rport_els(struct fc_bsg_job *jo
 		/* make sure the I/O had not been completed/released */
 		if (cmdiocbq->iocb_flag & LPFC_IO_LIBDFC) {
 			/* open up abort window to timeout handler */
-			cmdiocbq->iocb_aux_flag |= LPFC_IO_CMD_OUTSTANDING;
+			cmdiocbq->iocb_flag |= LPFC_IO_CMD_OUTSTANDING;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return 0; /* done for now */
@@ -1404,7 +1404,7 @@ lpfc_issue_ct_rsp_cmp(struct lpfc_hba *p
 
 	/* Close the timeout handler abort window */
 	spin_lock_irqsave(&phba->hbalock, flags);
-	cmdiocbq->iocb_aux_flag &= ~LPFC_IO_CMD_OUTSTANDING;
+	cmdiocbq->iocb_flag &= ~LPFC_IO_CMD_OUTSTANDING;
 	spin_unlock_irqrestore(&phba->hbalock, flags);
 
 	ndlp = dd_data->context_un.iocb.ndlp;
@@ -1585,7 +1585,7 @@ lpfc_issue_ct_rsp(struct lpfc_hba *phba,
 		/* make sure the I/O had not been completed/released */
 		if (ctiocb->iocb_flag & LPFC_IO_LIBDFC) {
 			/* open up abort window to timeout handler */
-			ctiocb->iocb_aux_flag |= LPFC_IO_CMD_OUTSTANDING;
+			ctiocb->iocb_flag |= LPFC_IO_CMD_OUTSTANDING;
 		}
 		spin_unlock_irqrestore(&phba->hbalock, flags);
 		return 0; /* done for now */
@@ -5338,7 +5338,7 @@ lpfc_bsg_timeout(struct fc_bsg_job *job)
 
 		spin_lock_irqsave(&phba->hbalock, flags);
 		/* make sure the I/O abort window is still open */
-		if (!(cmdiocb->iocb_aux_flag & LPFC_IO_CMD_OUTSTANDING)) {
+		if (!(cmdiocb->iocb_flag & LPFC_IO_CMD_OUTSTANDING)) {
 			spin_unlock_irqrestore(&phba->hbalock, flags);
 			return -EAGAIN;
 		}
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.h b/drivers/scsi/lpfc/lpfc_sli.h
--- a/drivers/scsi/lpfc/lpfc_sli.h	2013-09-06 10:04:12.343058495 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.h	2013-09-06 10:04:19.544058659 -0400
@@ -58,7 +58,7 @@ struct lpfc_iocbq {
 
 	IOCB_t iocb;		/* IOCB cmd */
 	uint8_t retry;		/* retry counter for IOCB cmd - if needed */
-	uint16_t iocb_flag;
+	uint32_t iocb_flag;
 #define LPFC_IO_LIBDFC		1	/* libdfc iocb */
 #define LPFC_IO_WAKE		2	/* Synchronous I/O completed */
 #define LPFC_IO_WAKE_TMO	LPFC_IO_WAKE /* Synchronous I/O timed out */
@@ -73,12 +73,11 @@ struct lpfc_iocbq {
 #define LPFC_IO_DIF_PASS	0x400	/* T10 DIF IO pass-thru prot */
 #define LPFC_IO_DIF_STRIP	0x800	/* T10 DIF IO strip prot */
 #define LPFC_IO_DIF_INSERT	0x1000	/* T10 DIF IO insert prot */
+#define LPFC_IO_CMD_OUTSTANDING	0x2000 /* timeout handler abort window */
 
 #define LPFC_FIP_ELS_ID_MASK	0xc000	/* ELS_ID range 0-3, non-shifted mask */
 #define LPFC_FIP_ELS_ID_SHIFT	14
 
-	uint8_t iocb_aux_flag;
-#define LPFC_IO_CMD_OUTSTANDING	0x01 /* timeout handler abort window */
 	uint32_t drvrTimeout;	/* driver timeout in seconds */
 	uint32_t fcp_wqidx;	/* index to FCP work queue */
 	struct lpfc_vport *vport;/* virtual port pointer */



