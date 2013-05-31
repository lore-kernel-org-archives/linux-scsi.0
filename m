From: James Smart <james.smart@emulex.com>
Subject: [PATCH 13/17] lpfc 8.3.40: Fixed system panic due to unsafe walking
 and deleting linked list
Date: Fri, 31 May 2013 17:05:17 -0400
Message-ID: <1370034317.17258.35.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:5805 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab3EaVLv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 May 2013 17:11:51 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed system panic due to unsafe walking and deleting linked list


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_scsi.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-05-31 10:58:17.946057631 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-05-31 10:58:26.205057820 -0400
@@ -1166,13 +1166,14 @@ lpfc_get_scsi_buf_s3(struct lpfc_hba *ph
 static struct lpfc_scsi_buf*
 lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
-	struct lpfc_scsi_buf *lpfc_cmd ;
+	struct lpfc_scsi_buf *lpfc_cmd, *lpfc_cmd_next;
 	unsigned long gflag = 0;
 	unsigned long pflag = 0;
 	int found = 0;
 
 	spin_lock_irqsave(&phba->scsi_buf_list_get_lock, gflag);
-	list_for_each_entry(lpfc_cmd, &phba->lpfc_scsi_buf_list_get, list) {
+	list_for_each_entry_safe(lpfc_cmd, lpfc_cmd_next,
+				 &phba->lpfc_scsi_buf_list_get, list) {
 		if (lpfc_test_rrq_active(phba, ndlp,
 					 lpfc_cmd->cur_iocbq.sli4_lxritag))
 			continue;
@@ -1186,8 +1187,8 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *ph
 			    &phba->lpfc_scsi_buf_list_get);
 		INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
 		spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, pflag);
-		list_for_each_entry(lpfc_cmd, &phba->lpfc_scsi_buf_list_get,
-				    list) {
+		list_for_each_entry_safe(lpfc_cmd, lpfc_cmd_next,
+					 &phba->lpfc_scsi_buf_list_get, list) {
 			if (lpfc_test_rrq_active(
 				phba, ndlp, lpfc_cmd->cur_iocbq.sli4_lxritag))
 				continue;



