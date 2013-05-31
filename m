From: James Smart <james.smart@emulex.com>
Subject: [PATCH 5/17] lpfc 8.3.40: Fix inconsistent list removal causes
 crash.
Date: Fri, 31 May 2013 17:04:01 -0400
Message-ID: <1370034241.17258.27.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5786 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755263Ab3EaVKe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 17:10:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix inconsistent list removal causes crash.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_sli.c |   18 ------------------
 1 file changed, 18 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-05-31 10:58:14.126057545 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-05-31 10:58:16.738057604 -0400
@@ -1011,17 +1011,6 @@ __lpfc_sli_release_iocbq_s4(struct lpfc_
 	else
 		sglq = __lpfc_clear_active_sglq(phba, iocbq->sli4_lxritag);
 
-	/*
-	** This should have been removed from the txcmplq before calling
-	** iocbq_release. The normal completion
-	** path should have already done the list_del_init.
-	*/
-	if (unlikely(!list_empty(&iocbq->list))) {
-		if (iocbq->iocb_flag & LPFC_IO_ON_TXCMPLQ)
-			iocbq->iocb_flag &= ~LPFC_IO_ON_TXCMPLQ;
-		list_del_init(&iocbq->list);
-	}
-
 
 	if (sglq)  {
 		if ((iocbq->iocb_flag & LPFC_EXCHANGE_BUSY) &&
@@ -1070,13 +1059,6 @@ __lpfc_sli_release_iocbq_s3(struct lpfc_
 {
 	size_t start_clean = offsetof(struct lpfc_iocbq, iocb);
 
-	/*
-	** This should have been removed from the txcmplq before calling
-	** iocbq_release. The normal completion
-	** path should have already done the list_del_init.
-	*/
-	if (unlikely(!list_empty(&iocbq->list)))
-		list_del_init(&iocbq->list);
 
 	/*
 	 * Clean all volatile data fields, preserve iotag and node struct.



