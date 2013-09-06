From: James Smart <james.smart@emulex.com>
Subject: [PATCH 15/18] lpfc 8.3.42: Fix driver's abort loop functionality to
 skip IOs already getting aborted
Date: Fri, 6 Sep 2013 12:22:13 -0400
Message-ID: <1378484533.14051.34.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:22366 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753853Ab3IFQWv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:22:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix driver's abort loop functionality to skip IOs already getting aborted


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    3 +++
 lpfc_sli.c  |   12 +++++++++++-
 2 files changed, 14 insertions(+), 1 deletion(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-09-06 10:04:26.569058818 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-09-06 10:04:28.751058869 -0400
@@ -4886,6 +4886,9 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 		goto out_unlock;
 	}
 
+	/* Indicate the IO is being aborted by the driver. */
+	iocb->iocb_flag |= LPFC_DRIVER_ABORTED;
+
 	/*
 	 * The scsi command can not be in txq and it is in flight because the
 	 * pCmd is still pointig at the SCSI command we have to abort. There
diff -upNr a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
--- a/drivers/scsi/lpfc/lpfc_sli.c	2013-09-06 10:04:21.042058693 -0400
+++ b/drivers/scsi/lpfc/lpfc_sli.c	2013-09-06 10:04:28.756058870 -0400
@@ -9831,6 +9831,13 @@ lpfc_sli_abort_iocb(struct lpfc_vport *v
 					       abort_cmd) != 0)
 			continue;
 
+		/*
+		 * If the iocbq is already being aborted, don't take a second
+		 * action, but do count it.
+		 */
+		if (iocbq->iocb_flag & LPFC_DRIVER_ABORTED)
+			continue;
+
 		/* issue ABTS for this IOCB based on iotag */
 		abtsiocb = lpfc_sli_get_iocbq(phba);
 		if (abtsiocb == NULL) {
@@ -9838,6 +9845,9 @@ lpfc_sli_abort_iocb(struct lpfc_vport *v
 			continue;
 		}
 
+		/* indicate the IO is being aborted by the driver. */
+		iocbq->iocb_flag |= LPFC_DRIVER_ABORTED;
+
 		cmd = &iocbq->iocb;
 		abtsiocb->iocb.un.acxri.abortType = ABORT_TYPE_ABTS;
 		abtsiocb->iocb.un.acxri.abortContextTag = cmd->ulpContext;
@@ -9847,7 +9857,7 @@ lpfc_sli_abort_iocb(struct lpfc_vport *v
 			abtsiocb->iocb.un.acxri.abortIoTag = cmd->ulpIoTag;
 		abtsiocb->iocb.ulpLe = 1;
 		abtsiocb->iocb.ulpClass = cmd->ulpClass;
-		abtsiocb->vport = phba->pport;
+		abtsiocb->vport = vport;
 
 		/* ABTS WQE must go to the same WQ as the WQE to be aborted */
 		abtsiocb->fcp_wqidx = iocbq->fcp_wqidx;



