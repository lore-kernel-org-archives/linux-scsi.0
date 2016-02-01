From: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
Subject: [PATCH 11/12] be2iscsi: _bh for io_sgl_lock and mgmt_sgl_lock
Date: Mon,  1 Feb 2016 15:42:50 +0530
Message-ID: <1454321571-16167-12-git-send-email-jitendra.bhivare@avagotech.com>
References: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmrelayp1.emulex.com ([138.239.112.140]:54823 "EHLO
	CMRELAYP1.ad.emulex.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753174AbcBAKNg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2016 05:13:36 -0500
In-Reply-To: <1454321571-16167-1-git-send-email-jitendra.bhivare@avagotech.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jitendra Bhivare <jitendra.bhivare@avagotech.com>

Processing of mgmt and IO tasks are done in process context and sofitrqs.

Allocation and freeing of sgl_handles needs to be done under
spin_lock_bh/spin_unlock_bh and move the locks to the routines.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@avagotech.com>
---
 drivers/scsi/be2iscsi/be_main.c | 25 ++++++++++---------------
 1 file changed, 10 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 03265b6..fa2b589 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1132,6 +1132,7 @@ static struct sgl_handle *alloc_io_sgl_handle(struct beiscsi_hba *phba)
 {
 	struct sgl_handle *psgl_handle;
 
+	spin_lock_bh(&phba->io_sgl_lock);
 	if (phba->io_sgl_hndl_avbl) {
 		beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
 			    "BM_%d : In alloc_io_sgl_handle,"
@@ -1149,12 +1150,14 @@ static struct sgl_handle *alloc_io_sgl_handle(struct beiscsi_hba *phba)
 			phba->io_sgl_alloc_index++;
 	} else
 		psgl_handle = NULL;
+	spin_unlock_bh(&phba->io_sgl_lock);
 	return psgl_handle;
 }
 
 static void
 free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 {
+	spin_lock_bh(&phba->io_sgl_lock);
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_IO,
 		    "BM_%d : In free_,io_sgl_free_index=%d\n",
 		    phba->io_sgl_free_index);
@@ -1169,6 +1172,7 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 			     "value there=%p\n", phba->io_sgl_free_index,
 			     phba->io_sgl_hndl_base
 			     [phba->io_sgl_free_index]);
+		 spin_unlock_bh(&phba->io_sgl_lock);
 		return;
 	}
 	phba->io_sgl_hndl_base[phba->io_sgl_free_index] = psgl_handle;
@@ -1177,6 +1181,7 @@ free_io_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		phba->io_sgl_free_index = 0;
 	else
 		phba->io_sgl_free_index++;
+	spin_unlock_bh(&phba->io_sgl_lock);
 }
 
 static inline struct wrb_handle *
@@ -1257,6 +1262,7 @@ static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
 {
 	struct sgl_handle *psgl_handle;
 
+	spin_lock_bh(&phba->mgmt_sgl_lock);
 	if (phba->eh_sgl_hndl_avbl) {
 		psgl_handle = phba->eh_sgl_hndl_base[phba->eh_sgl_alloc_index];
 		phba->eh_sgl_hndl_base[phba->eh_sgl_alloc_index] = NULL;
@@ -1274,13 +1280,14 @@ static struct sgl_handle *alloc_mgmt_sgl_handle(struct beiscsi_hba *phba)
 			phba->eh_sgl_alloc_index++;
 	} else
 		psgl_handle = NULL;
+	spin_unlock_bh(&phba->mgmt_sgl_lock);
 	return psgl_handle;
 }
 
 void
 free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 {
-
+	spin_lock_bh(&phba->mgmt_sgl_lock);
 	beiscsi_log(phba, KERN_INFO, BEISCSI_LOG_CONFIG,
 		    "BM_%d : In  free_mgmt_sgl_handle,"
 		    "eh_sgl_free_index=%d\n",
@@ -1295,6 +1302,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 			    "BM_%d : Double Free in eh SGL ,"
 			    "eh_sgl_free_index=%d\n",
 			    phba->eh_sgl_free_index);
+		spin_unlock_bh(&phba->mgmt_sgl_lock);
 		return;
 	}
 	phba->eh_sgl_hndl_base[phba->eh_sgl_free_index] = psgl_handle;
@@ -1304,6 +1312,7 @@ free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle)
 		phba->eh_sgl_free_index = 0;
 	else
 		phba->eh_sgl_free_index++;
+	spin_unlock_bh(&phba->mgmt_sgl_lock);
 }
 
 static void
@@ -4616,11 +4625,9 @@ beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn,
 	}
 
 	if (io_task->psgl_handle) {
-		spin_lock_bh(&phba->mgmt_sgl_lock);
 		free_mgmt_sgl_handle(phba,
 				     io_task->psgl_handle);
 		io_task->psgl_handle = NULL;
-		spin_unlock_bh(&phba->mgmt_sgl_lock);
 	}
 
 	if (io_task->mtask_addr) {
@@ -4666,9 +4673,7 @@ static void beiscsi_cleanup_task(struct iscsi_task *task)
 		}
 
 		if (io_task->psgl_handle) {
-			spin_lock(&phba->io_sgl_lock);
 			free_io_sgl_handle(phba, io_task->psgl_handle);
-			spin_unlock(&phba->io_sgl_lock);
 			io_task->psgl_handle = NULL;
 		}
 
@@ -4784,9 +4789,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	io_task->pwrb_handle = NULL;
 
 	if (task->sc) {
-		spin_lock(&phba->io_sgl_lock);
 		io_task->psgl_handle = alloc_io_sgl_handle(phba);
-		spin_unlock(&phba->io_sgl_lock);
 		if (!io_task->psgl_handle) {
 			beiscsi_log(phba, KERN_ERR,
 				    BEISCSI_LOG_IO | BEISCSI_LOG_CONFIG,
@@ -4811,10 +4814,8 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		if ((opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN) {
 			beiscsi_conn->task = task;
 			if (!beiscsi_conn->login_in_progress) {
-				spin_lock(&phba->mgmt_sgl_lock);
 				io_task->psgl_handle = (struct sgl_handle *)
 						alloc_mgmt_sgl_handle(phba);
-				spin_unlock(&phba->mgmt_sgl_lock);
 				if (!io_task->psgl_handle) {
 					beiscsi_log(phba, KERN_ERR,
 						    BEISCSI_LOG_IO |
@@ -4853,9 +4854,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 						beiscsi_conn->plogin_wrb_handle;
 			}
 		} else {
-			spin_lock(&phba->mgmt_sgl_lock);
 			io_task->psgl_handle = alloc_mgmt_sgl_handle(phba);
-			spin_unlock(&phba->mgmt_sgl_lock);
 			if (!io_task->psgl_handle) {
 				beiscsi_log(phba, KERN_ERR,
 					    BEISCSI_LOG_IO |
@@ -4890,15 +4889,11 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	return 0;
 
 free_io_hndls:
-	spin_lock(&phba->io_sgl_lock);
 	free_io_sgl_handle(phba, io_task->psgl_handle);
-	spin_unlock(&phba->io_sgl_lock);
 	goto free_hndls;
 free_mgmt_hndls:
-	spin_lock(&phba->mgmt_sgl_lock);
 	free_mgmt_sgl_handle(phba, io_task->psgl_handle);
 	io_task->psgl_handle = NULL;
-	spin_unlock(&phba->mgmt_sgl_lock);
 free_hndls:
 	phwi_ctrlr = phba->phwi_ctrlr;
 	cri_index = BE_GET_CRI_FROM_CID(
-- 
2.5.0

