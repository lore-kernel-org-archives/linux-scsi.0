From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 04/17] be2iscsi:Freeing of WRB and SGL Handle in cleanup
 task
Date: Wed, 18 Apr 2012 03:06:00 -0500
Message-ID: <4F8E75E8.6010309@cs.wisc.edu>
References: <1333514512-21799-1-git-send-email-michaelc@cs.wisc.edu> <1333514512-21799-5-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090801090102010308000309"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:58274 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751396Ab2DRIGJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Apr 2012 04:06:09 -0400
In-Reply-To: <1333514512-21799-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>

This is a multi-part message in MIME format.
--------------090801090102010308000309
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 04/03/2012 11:41 PM, michaelc@cs.wisc.edu wrote:
> From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> 
>  The WRB and SGL Handle allocated for Login task were not freed
>  back to the pool after the login process was done. This code
>  releases the WRB and SGL Handle after the login process.
> 

This patch had some issues. Please use the attached version instead.

--------------090801090102010308000309
Content-Type: text/x-patch;
 name="0004-be2iscsi-Freeing-of-WRB-and-SGL-Handle-in-cleanup-ta.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0004-be2iscsi-Freeing-of-WRB-and-SGL-Handle-in-cleanup-ta.pa";
 filename*1="tch"

>From aaa195e9ff55abdcc9b785262b3d5932ad5d7439 Mon Sep 17 00:00:00 2001
From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
Date: Wed, 18 Apr 2012 02:48:19 -0400
Subject: [PATCH 04/17] be2iscsi: Freeing of WRB and SGL Handle in cleanup task v2

 The WRB and SGL Handle allocated for Login task were not freed
 back to the pool after the login process was done. This code
 releases the WRB and SGL Handle after the login process.

v2:
- Fix up locking so bh calls are not done when not needed.
- Make beiscsi_cleanup_task static.

Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
[various fixes]
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_main.c |  107 ++++++++++++++++++++++----------------
 1 files changed, 62 insertions(+), 45 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 23344c8..185cf39 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1252,9 +1252,9 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 	task = pwrb_handle->pio_handle;
 
 	io_task = task->dd_data;
-	spin_lock(&phba->mgmt_sgl_lock);
+	spin_lock_bh(&phba->mgmt_sgl_lock);
 	free_mgmt_sgl_handle(phba, io_task->psgl_handle);
-	spin_unlock(&phba->mgmt_sgl_lock);
+	spin_unlock_bh(&phba->mgmt_sgl_lock);
 	spin_lock_bh(&session->lock);
 	free_wrb_handle(phba, pwrb_context, pwrb_handle);
 	spin_unlock_bh(&session->lock);
@@ -3693,6 +3693,57 @@ static void beiscsi_clean_port(struct beiscsi_hba *phba)
 	kfree(phba->ep_array);
 }
 
+static void beiscsi_cleanup_task(struct iscsi_task *task)
+{
+	struct beiscsi_io_task *io_task = task->dd_data;
+	struct iscsi_conn *conn = task->conn;
+	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	struct beiscsi_hba *phba = beiscsi_conn->phba;
+	struct beiscsi_session *beiscsi_sess = beiscsi_conn->beiscsi_sess;
+	struct hwi_wrb_context *pwrb_context;
+	struct hwi_controller *phwi_ctrlr;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	pwrb_context = &phwi_ctrlr->wrb_context[beiscsi_conn->beiscsi_conn_cid
+			- phba->fw_config.iscsi_cid_start];
+
+	if (io_task->cmd_bhs) {
+		pci_pool_free(beiscsi_sess->bhs_pool, io_task->cmd_bhs,
+			      io_task->bhs_pa.u.a64.address);
+		io_task->cmd_bhs = NULL;
+	}
+
+	if (task->sc) {
+		if (io_task->pwrb_handle) {
+			free_wrb_handle(phba, pwrb_context,
+					io_task->pwrb_handle);
+			io_task->pwrb_handle = NULL;
+		}
+
+		if (io_task->psgl_handle) {
+			spin_lock(&phba->io_sgl_lock);
+			free_io_sgl_handle(phba, io_task->psgl_handle);
+			spin_unlock(&phba->io_sgl_lock);
+			io_task->psgl_handle = NULL;
+		}
+	} else {
+		if (!beiscsi_conn->login_in_progress) {
+			if (io_task->pwrb_handle) {
+				free_wrb_handle(phba, pwrb_context,
+						io_task->pwrb_handle);
+				io_task->pwrb_handle = NULL;
+			}
+			if (io_task->psgl_handle) {
+				spin_lock(&phba->mgmt_sgl_lock);
+				free_mgmt_sgl_handle(phba,
+						     io_task->psgl_handle);
+				spin_unlock(&phba->mgmt_sgl_lock);
+				io_task->psgl_handle = NULL;
+			}
+		}
+	}
+}
+
 void
 beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 			   struct beiscsi_offload_params *params)
@@ -3701,12 +3752,19 @@ beiscsi_offload_connection(struct beiscsi_conn *beiscsi_conn,
 	struct iscsi_target_context_update_wrb *pwrb = NULL;
 	struct be_mem_descriptor *mem_descr;
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
+	struct iscsi_task *task = beiscsi_conn->task;
+	struct iscsi_session *session = task->conn->session;
 	u32 doorbell = 0;
 
 	/*
 	 * We can always use 0 here because it is reserved by libiscsi for
 	 * login/startup related tasks.
 	 */
+	beiscsi_conn->login_in_progress = 0;
+	spin_lock_bh(&session->lock);
+	beiscsi_cleanup_task(task);
+	spin_unlock_bh(&session->lock);
+
 	pwrb_handle = alloc_wrb_handle(phba, (beiscsi_conn->beiscsi_conn_cid -
 				       phba->fw_config.iscsi_cid_start));
 	pwrb = (struct iscsi_target_context_update_wrb *)pwrb_handle->pwrb;
@@ -3862,6 +3920,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 				io_task->pwrb_handle =
 						beiscsi_conn->plogin_wrb_handle;
 			}
+			beiscsi_conn->task = task;
 		} else {
 			spin_lock(&phba->mgmt_sgl_lock);
 			io_task->psgl_handle = alloc_mgmt_sgl_handle(phba);
@@ -3904,53 +3963,11 @@ free_hndls:
 	io_task->pwrb_handle = NULL;
 	pci_pool_free(beiscsi_sess->bhs_pool, io_task->cmd_bhs,
 		      io_task->bhs_pa.u.a64.address);
+	io_task->cmd_bhs = NULL;
 	SE_DEBUG(DBG_LVL_1, "Alloc of SGL_ICD Failed\n");
 	return -ENOMEM;
 }
 
-static void beiscsi_cleanup_task(struct iscsi_task *task)
-{
-	struct beiscsi_io_task *io_task = task->dd_data;
-	struct iscsi_conn *conn = task->conn;
-	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
-	struct beiscsi_hba *phba = beiscsi_conn->phba;
-	struct beiscsi_session *beiscsi_sess = beiscsi_conn->beiscsi_sess;
-	struct hwi_wrb_context *pwrb_context;
-	struct hwi_controller *phwi_ctrlr;
-
-	phwi_ctrlr = phba->phwi_ctrlr;
-	pwrb_context = &phwi_ctrlr->wrb_context[beiscsi_conn->beiscsi_conn_cid
-			- phba->fw_config.iscsi_cid_start];
-	if (io_task->pwrb_handle) {
-		free_wrb_handle(phba, pwrb_context, io_task->pwrb_handle);
-		io_task->pwrb_handle = NULL;
-	}
-
-	if (io_task->cmd_bhs) {
-		pci_pool_free(beiscsi_sess->bhs_pool, io_task->cmd_bhs,
-			      io_task->bhs_pa.u.a64.address);
-	}
-
-	if (task->sc) {
-		if (io_task->psgl_handle) {
-			spin_lock(&phba->io_sgl_lock);
-			free_io_sgl_handle(phba, io_task->psgl_handle);
-			spin_unlock(&phba->io_sgl_lock);
-			io_task->psgl_handle = NULL;
-		}
-	} else {
-		if (task->hdr &&
-		   ((task->hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN))
-			return;
-		if (io_task->psgl_handle) {
-			spin_lock(&phba->mgmt_sgl_lock);
-			free_mgmt_sgl_handle(phba, io_task->psgl_handle);
-			spin_unlock(&phba->mgmt_sgl_lock);
-			io_task->psgl_handle = NULL;
-		}
-	}
-}
-
 static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 			  unsigned int num_sg, unsigned int xferlen,
 			  unsigned int writedir)
-- 
1.7.1


--------------090801090102010308000309--
