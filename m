From: James Smart <james.smart@emulex.com>
Subject: [PATCH 06/21] lpfc 8.3.33: Fix scsi_eh escalation panic by checking
 the proper return status
Date: Fri, 3 Aug 2012 12:34:54 -0400
Message-ID: <1344011694.6110.31.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:40311 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab2HCQfA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Aug 2012 12:35:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix scsi_eh escalation panic by checking the proper return status


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2012-07-22 11:35:20.453631868 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2012-07-22 11:35:20.648631862 -0400
@@ -4414,7 +4414,7 @@ lpfc_abort_handler(struct scsi_cmnd *cmn
 	DECLARE_WAIT_QUEUE_HEAD_ONSTACK(waitq);
 
 	status = fc_block_scsi_eh(cmnd);
-	if (status)
+	if (status != 0 && status != SUCCESS)
 		return status;
 
 	spin_lock_irq(&phba->hbalock);
@@ -4769,7 +4769,7 @@ lpfc_device_reset_handler(struct scsi_cm
 	}
 	pnode = rdata->pnode;
 	status = fc_block_scsi_eh(cmnd);
-	if (status)
+	if (status != 0 && status != SUCCESS)
 		return status;
 
 	status = lpfc_chk_tgt_mapped(vport, cmnd);
@@ -4836,7 +4836,7 @@ lpfc_target_reset_handler(struct scsi_cm
 	}
 	pnode = rdata->pnode;
 	status = fc_block_scsi_eh(cmnd);
-	if (status)
+	if (status != 0 && status != SUCCESS)
 		return status;
 
 	status = lpfc_chk_tgt_mapped(vport, cmnd);
@@ -4904,7 +4904,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd
 		sizeof(scsi_event), (char *)&scsi_event, LPFC_NL_VENDOR_ID);
 
 	status = fc_block_scsi_eh(cmnd);
-	if (status)
+	if (status != 0 && status != SUCCESS)
 		return status;
 
 	/*



