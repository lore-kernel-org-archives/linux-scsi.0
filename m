From: James Smart <james.smart@emulex.com>
Subject: [PATCH 17/22] lpfc 8.3.39: Fixed iocb flags not being reset for
 scsi commands
Date: Wed, 17 Apr 2013 20:19:00 -0400
Message-ID: <1366244340.1513.18.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:24331 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935682Ab3DRATC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Apr 2013 20:19:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed iocb flags not being reset for scsi commands.


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    2 ++
 1 file changed, 2 insertions(+)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-04-15 18:26:46.934041346 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-04-15 18:26:51.610041452 -0400
@@ -1215,6 +1215,7 @@ lpfc_release_scsi_buf_s3(struct lpfc_hba
 
 	spin_lock_irqsave(&phba->scsi_buf_list_put_lock, iflag);
 	psb->pCmd = NULL;
+	psb->cur_iocbq.iocb_flag = LPFC_IO_FCP;
 	list_add_tail(&psb->list, &phba->lpfc_scsi_buf_list_put);
 	spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, iflag);
 }
@@ -1248,6 +1249,7 @@ lpfc_release_scsi_buf_s4(struct lpfc_hba
 					iflag);
 	} else {
 		psb->pCmd = NULL;
+		psb->cur_iocbq.iocb_flag = LPFC_IO_FCP;
 		spin_lock_irqsave(&phba->scsi_buf_list_put_lock, iflag);
 		list_add_tail(&psb->list, &phba->lpfc_scsi_buf_list_put);
 		spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, iflag);



