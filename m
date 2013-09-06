From: James Smart <james.smart@emulex.com>
Subject: [PATCH 16/18] lpfc 8.3.42: Fixed inconsistent spin lock usage.
Date: Fri, 6 Sep 2013 12:22:38 -0400
Message-ID: <1378484558.14051.35.camel@myfc17>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:22370 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750750Ab3IFQXP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Sep 2013 12:23:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed inconsistent spin lock usage. 


Signed-off-by: James Smart <james.smart@emulex.com>

 ---

 lpfc_init.c |    8 ++++----
 lpfc_scsi.c |   26 ++++++++++++--------------
 2 files changed, 16 insertions(+), 18 deletions(-)


diff -upNr a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
--- a/drivers/scsi/lpfc/lpfc_init.c	2013-09-06 10:04:24.916058781 -0400
+++ b/drivers/scsi/lpfc/lpfc_init.c	2013-09-06 10:04:32.475058953 -0400
@@ -3031,10 +3031,10 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba
 			phba->sli4_hba.scsi_xri_max);
 
 	spin_lock_irq(&phba->scsi_buf_list_get_lock);
-	spin_lock_irq(&phba->scsi_buf_list_put_lock);
+	spin_lock(&phba->scsi_buf_list_put_lock);
 	list_splice_init(&phba->lpfc_scsi_buf_list_get, &scsi_sgl_list);
 	list_splice(&phba->lpfc_scsi_buf_list_put, &scsi_sgl_list);
-	spin_unlock_irq(&phba->scsi_buf_list_put_lock);
+	spin_unlock(&phba->scsi_buf_list_put_lock);
 	spin_unlock_irq(&phba->scsi_buf_list_get_lock);
 
 	if (phba->sli4_hba.scsi_xri_cnt > phba->sli4_hba.scsi_xri_max) {
@@ -3070,10 +3070,10 @@ lpfc_sli4_xri_sgl_update(struct lpfc_hba
 		psb->cur_iocbq.sli4_xritag = phba->sli4_hba.xri_ids[lxri];
 	}
 	spin_lock_irq(&phba->scsi_buf_list_get_lock);
-	spin_lock_irq(&phba->scsi_buf_list_put_lock);
+	spin_lock(&phba->scsi_buf_list_put_lock);
 	list_splice_init(&scsi_sgl_list, &phba->lpfc_scsi_buf_list_get);
 	INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
-	spin_unlock_irq(&phba->scsi_buf_list_put_lock);
+	spin_unlock(&phba->scsi_buf_list_put_lock);
 	spin_unlock_irq(&phba->scsi_buf_list_get_lock);
 
 	return 0;
diff -upNr a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
--- a/drivers/scsi/lpfc/lpfc_scsi.c	2013-09-06 10:04:28.751058869 -0400
+++ b/drivers/scsi/lpfc/lpfc_scsi.c	2013-09-06 10:04:32.486058953 -0400
@@ -926,10 +926,10 @@ lpfc_sli4_repost_scsi_sgl_list(struct lp
 
 	/* get all SCSI buffers need to repost to a local list */
 	spin_lock_irq(&phba->scsi_buf_list_get_lock);
-	spin_lock_irq(&phba->scsi_buf_list_put_lock);
+	spin_lock(&phba->scsi_buf_list_put_lock);
 	list_splice_init(&phba->lpfc_scsi_buf_list_get, &post_sblist);
 	list_splice(&phba->lpfc_scsi_buf_list_put, &post_sblist);
-	spin_unlock_irq(&phba->scsi_buf_list_put_lock);
+	spin_unlock(&phba->scsi_buf_list_put_lock);
 	spin_unlock_irq(&phba->scsi_buf_list_get_lock);
 
 	/* post the list of scsi buffer sgls to port if available */
@@ -1137,22 +1137,21 @@ lpfc_get_scsi_buf_s3(struct lpfc_hba *ph
 {
 	struct  lpfc_scsi_buf * lpfc_cmd = NULL;
 	struct list_head *scsi_buf_list_get = &phba->lpfc_scsi_buf_list_get;
-	unsigned long gflag = 0;
-	unsigned long pflag = 0;
+	unsigned long iflag = 0;
 
-	spin_lock_irqsave(&phba->scsi_buf_list_get_lock, gflag);
+	spin_lock_irqsave(&phba->scsi_buf_list_get_lock, iflag);
 	list_remove_head(scsi_buf_list_get, lpfc_cmd, struct lpfc_scsi_buf,
 			 list);
 	if (!lpfc_cmd) {
-		spin_lock_irqsave(&phba->scsi_buf_list_put_lock, pflag);
+		spin_lock(&phba->scsi_buf_list_put_lock);
 		list_splice(&phba->lpfc_scsi_buf_list_put,
 			    &phba->lpfc_scsi_buf_list_get);
 		INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
 		list_remove_head(scsi_buf_list_get, lpfc_cmd,
 				 struct lpfc_scsi_buf, list);
-		spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, pflag);
+		spin_unlock(&phba->scsi_buf_list_put_lock);
 	}
-	spin_unlock_irqrestore(&phba->scsi_buf_list_get_lock, gflag);
+	spin_unlock_irqrestore(&phba->scsi_buf_list_get_lock, iflag);
 	return  lpfc_cmd;
 }
 /**
@@ -1170,11 +1169,10 @@ static struct lpfc_scsi_buf*
 lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
 	struct lpfc_scsi_buf *lpfc_cmd, *lpfc_cmd_next;
-	unsigned long gflag = 0;
-	unsigned long pflag = 0;
+	unsigned long iflag = 0;
 	int found = 0;
 
-	spin_lock_irqsave(&phba->scsi_buf_list_get_lock, gflag);
+	spin_lock_irqsave(&phba->scsi_buf_list_get_lock, iflag);
 	list_for_each_entry_safe(lpfc_cmd, lpfc_cmd_next,
 				 &phba->lpfc_scsi_buf_list_get, list) {
 		if (lpfc_test_rrq_active(phba, ndlp,
@@ -1185,11 +1183,11 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *ph
 		break;
 	}
 	if (!found) {
-		spin_lock_irqsave(&phba->scsi_buf_list_put_lock, pflag);
+		spin_lock(&phba->scsi_buf_list_put_lock);
 		list_splice(&phba->lpfc_scsi_buf_list_put,
 			    &phba->lpfc_scsi_buf_list_get);
 		INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
-		spin_unlock_irqrestore(&phba->scsi_buf_list_put_lock, pflag);
+		spin_unlock(&phba->scsi_buf_list_put_lock);
 		list_for_each_entry_safe(lpfc_cmd, lpfc_cmd_next,
 					 &phba->lpfc_scsi_buf_list_get, list) {
 			if (lpfc_test_rrq_active(
@@ -1200,7 +1198,7 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *ph
 			break;
 		}
 	}
-	spin_unlock_irqrestore(&phba->scsi_buf_list_get_lock, gflag);
+	spin_unlock_irqrestore(&phba->scsi_buf_list_get_lock, iflag);
 	if (!found)
 		return NULL;
 	return  lpfc_cmd;



