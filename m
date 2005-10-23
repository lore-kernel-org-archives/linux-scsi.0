From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC 3/2] HCIL driver update: lpfc
Date: Sun, 23 Oct 2005 16:12:32 -0400
Message-ID: <20051023201232.GA12931@havoc.gtf.org>
References: <20051023024104.GA20128@havoc.gtf.org> <20051023195128.GA12102@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:44519 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1750736AbVJWUMg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 16:12:36 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id 200F91C095A7
	for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2005 16:12:33 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9NKCWVx012954
	for linux-scsi@vger.kernel.org; Sun, 23 Oct 2005 16:12:32 -0400
Content-Disposition: inline
In-Reply-To: <20051023195128.GA12102@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Applied on top of the previous two driver update patches.

Since lpfc already uses dev_printk, we can simply drop references to
sdev->lun and sdev->id altogether.

DO NOT APPLY.

 drivers/scsi/lpfc/lpfc_scsi.c |   31 +++++++------------------------
 1 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index a162174..b1202a6 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -370,7 +370,6 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 	struct lpfc_nodelist *pnode = rdata->pnode;
 	struct scsi_cmnd *cmd = lpfc_cmd->pCmd;
 	unsigned long iflag;
-	char lunstr[SCSILUN_STR_LEN];
 
 	lpfc_cmd->result = pIocbOut->iocb.un.ulpWord[4];
 	lpfc_cmd->status = pIocbOut->iocb.ulpStatus;
@@ -383,10 +382,9 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 			lpfc_cmd->status = IOSTAT_DEFAULT;
 
 		lpfc_printf_log(phba, KERN_WARNING, LOG_FCP,
-				"%d:0729 FCP cmd x%x failed <%d/%s> status: "
+				"0729 FCP cmd x%x failed status: "
 				"x%x result: x%x Data: x%x x%x\n",
-				phba->brd_no, cmd->cmnd[0], sdev_id(cmd->device),
-				scsilun_to_str(&cmd->device->lun, lunstr),
+				cmd->cmnd[0],
 				lpfc_cmd->status,
 				lpfc_cmd->result, pIocbOut->iocb.ulpContext,
 				lpfc_cmd->cur_iocbq.iocb.ulpIoTag);
@@ -421,10 +419,8 @@ lpfc_scsi_cmd_iocb_cmpl(struct lpfc_hba 
 		uint32_t *lp = (uint32_t *)cmd->sense_buffer;
 
 		lpfc_printf_log(phba, KERN_INFO, LOG_FCP,
-				"%d:0710 Iodone <%d/%s> cmd %p, error x%x "
+				"0710 Iodone cmd %p, error x%x "
 				"SNS x%x x%x Data: x%x x%x\n",
-				phba->brd_no, sdev_id(cmd->device),
-				scsilun_to_str(&cmd->device->lun, lunstr),
 				cmd, cmd->result,
 				*lp, *(lp + 3), cmd->retries, cmd->resid);
 	}
@@ -540,7 +536,6 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 	struct scsi_device *scsi_dev = lpfc_cmd->pCmd->device;
 	struct lpfc_rport_data *rdata = scsi_dev->hostdata;
 	struct lpfc_nodelist *ndlp = rdata->pnode;
-	char lunstr[SCSILUN_STR_LEN];
 
 	if ((ndlp == 0) || (ndlp->nlp_state != NLP_STE_MAPPED_NODE)) {
 		return 0;
@@ -581,11 +576,8 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 		lpfc_printf_log(phba,
 				KERN_INFO,
 				LOG_FCP,
-				"%d:0703 Issue LUN Reset to TGT %d LUN %s "
+				"0703 Issue LUN Reset "
 				"Data: x%x x%x\n",
-				phba->brd_no,
-				sdev_id(scsi_dev),
-				scsilun_to_str(&scsi_dev->lun, lunstr),
 				ndlp->nlp_rpi, ndlp->nlp_flag);
 
 		break;
@@ -594,11 +586,8 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 		lpfc_printf_log(phba,
 				KERN_INFO,
 				LOG_FCP,
-				"%d:0701 Issue Abort Task Set to TGT %d LUN %s "
+				"0701 Issue Abort Task Set "
 				"Data: x%x x%x\n",
-				phba->brd_no,
-				sdev_id(scsi_dev),
-				scsilun_to_str(&scsi_dev->lun, lunstr),
 				ndlp->nlp_rpi, ndlp->nlp_flag);
 
 		break;
@@ -607,10 +596,8 @@ lpfc_scsi_prep_task_mgmt_cmd(struct lpfc
 		lpfc_printf_log(phba,
 				KERN_INFO,
 				LOG_FCP,
-				"%d:0702 Issue Target Reset to TGT %d "
+				"0702 Issue Target Reset "
 				"Data: x%x x%x\n",
-				phba->brd_no,
-				sdev_id(scsi_dev),
 				ndlp->nlp_rpi,
 				ndlp->nlp_flag);
 		break;
@@ -953,7 +940,6 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 	struct lpfc_nodelist *pnode = rdata->pnode;
 	int ret = FAILED;
 	int cnt, loopcnt;
-	char lunstr[SCSILUN_STR_LEN];
 
 	/*
 	 * If target is not in a MAPPED state, delay the reset until
@@ -1045,11 +1031,8 @@ __lpfc_reset_lun_handler(struct scsi_cmn
 
 out_free_scsi_buf:
 	lpfc_printf_log(phba, KERN_ERR, LOG_FCP,
-			"%d:0713 SCSI layer issued LUN reset (%d, %s) "
+			"0713 SCSI layer issued LUN reset "
 			"Data: x%x x%x x%x\n",
-			phba->brd_no,
-			sdev_id(lpfc_cmd->pCmd->device),
-			scsilun_to_str(&lpfc_cmd->pCmd->device->lun, lunstr),
 			ret, lpfc_cmd->status,
 			lpfc_cmd->result);
 	lpfc_free_scsi_buf(lpfc_cmd);
