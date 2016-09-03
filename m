From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] lpcf: Simplify code
Date: Sat,  3 Sep 2016 09:04:49 +0200
Message-ID: <1472886289-29756-1-git-send-email-christophe.jaillet@wanadoo.fr>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: james.smart@avagotech.com, dick.kennedy@avagotech.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org, Christophe JAILLET <christophe.jaillet@wanadoo.fr>
List-Id: linux-scsi@vger.kernel.org

Calling 'list_splice' followed by 'INIT_LIST_HEAD' is equivalent to
'list_splice_init'.

This has been spotted with the following coccinelle script:
/////
@@
expression y,z;
@@

-   list_splice(y,z);
-   INIT_LIST_HEAD(y);
+   list_splice_init(y,z);

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index d197aa176dee..90c26d27fd1f 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -978,9 +978,8 @@ lpfc_get_scsi_buf_s3(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 			 list);
 	if (!lpfc_cmd) {
 		spin_lock(&phba->scsi_buf_list_put_lock);
-		list_splice(&phba->lpfc_scsi_buf_list_put,
-			    &phba->lpfc_scsi_buf_list_get);
-		INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
+		list_splice_init(&phba->lpfc_scsi_buf_list_put,
+				 &phba->lpfc_scsi_buf_list_get);
 		list_remove_head(scsi_buf_list_get, lpfc_cmd,
 				 struct lpfc_scsi_buf, list);
 		spin_unlock(&phba->scsi_buf_list_put_lock);
@@ -1018,9 +1017,8 @@ lpfc_get_scsi_buf_s4(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 	}
 	if (!found) {
 		spin_lock(&phba->scsi_buf_list_put_lock);
-		list_splice(&phba->lpfc_scsi_buf_list_put,
-			    &phba->lpfc_scsi_buf_list_get);
-		INIT_LIST_HEAD(&phba->lpfc_scsi_buf_list_put);
+		list_splice_init(&phba->lpfc_scsi_buf_list_put,
+				 &phba->lpfc_scsi_buf_list_get);
 		spin_unlock(&phba->scsi_buf_list_put_lock);
 		list_for_each_entry_safe(lpfc_cmd, lpfc_cmd_next,
 					 &phba->lpfc_scsi_buf_list_get, list) {
-- 
2.7.4

