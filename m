From: Jayamohan Kallickal <jayamohank@gmail.com>
Subject: [PATCH V2 11/18] be2iscsi : Fix the NOP-In handling code path
Date: Fri,  5 Apr 2013 20:38:31 -0700
Message-ID: <1365219519-3457-11-git-send-email-jayamohan.kallickal@emulex.com>
References: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f48.google.com ([209.85.210.48]:40110 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1163204Ab3DFDjE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Apr 2013 23:39:04 -0400
Received: by mail-da0-f48.google.com with SMTP id p8so1826386dan.21
        for <linux-scsi@vger.kernel.org>; Fri, 05 Apr 2013 20:39:04 -0700 (PDT)
In-Reply-To: <1365219519-3457-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, Minh Tran <minhduc.tran@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

 When target send a NOP-IN with valid TTT, driver issues a NOP-OUT
 and the task was not freed from driver. The task list available for
 the session used to run out, and as no more task list were available
 no more iSCSI commands were exchanged on that session.
 This patches fixed the issue, by calling iscsi_put_task.

Signed-off-by: Minh Tran <minhduc.tran@emulex.com>
Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    3 ++-
 drivers/scsi/be2iscsi/be_main.c  |   21 ++++++++-------------
 drivers/scsi/be2iscsi/be_main.h  |    3 ++-
 3 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index a4eb610..118089f 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -1005,7 +1005,8 @@ static void beiscsi_free_ep(struct beiscsi_endpoint *beiscsi_ep)
 
 	beiscsi_conn = beiscsi_ep->conn;
 	if (beiscsi_conn->login_in_progress) {
-		beiscsi_free_mgmt_task_handles(beiscsi_conn);
+		beiscsi_free_mgmt_task_handles(beiscsi_conn,
+					       beiscsi_conn->task);
 		beiscsi_conn->login_in_progress = 0;
 	}
 }
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index ff89b4c..a60a43d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1367,8 +1367,6 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 	struct hwi_controller *phwi_ctrlr;
 	struct iscsi_task *task;
 	struct beiscsi_io_task *io_task;
-	struct iscsi_conn *conn = beiscsi_conn->conn;
-	struct iscsi_session *session = conn->session;
 	uint16_t wrb_index, cid;
 
 	phwi_ctrlr = phba->phwi_ctrlr;
@@ -1390,12 +1388,8 @@ hwi_complete_drvr_msgs(struct beiscsi_conn *beiscsi_conn,
 	task = pwrb_handle->pio_handle;
 
 	io_task = task->dd_data;
-	spin_lock_bh(&phba->mgmt_sgl_lock);
-	free_mgmt_sgl_handle(phba, io_task->psgl_handle);
-	spin_unlock_bh(&phba->mgmt_sgl_lock);
-	spin_lock_bh(&session->lock);
-	free_wrb_handle(phba, pwrb_context, pwrb_handle);
-	spin_unlock_bh(&session->lock);
+	memset(io_task->pwrb_handle->pwrb, 0, sizeof(struct iscsi_wrb));
+	iscsi_put_task(task);
 }
 
 static void
@@ -4073,11 +4067,13 @@ static void beiscsi_clean_port(struct beiscsi_hba *phba)
 /**
  * beiscsi_free_mgmt_task_handles()- Free driver CXN resources
  * @beiscsi_conn: ptr to the conn to be cleaned up
+ * @task: ptr to iscsi_task resource to be freed.
  *
  * Free driver mgmt resources binded to CXN.
  **/
 void
-beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn)
+beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn,
+				struct iscsi_task *task)
 {
 	struct beiscsi_io_task *io_task;
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
@@ -4088,7 +4084,7 @@ beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn)
 	pwrb_context = &phwi_ctrlr->wrb_context
 		       [beiscsi_conn->beiscsi_conn_cid
 		       - phba->fw_config.iscsi_cid_start];
-	io_task = beiscsi_conn->task->dd_data;
+	io_task = task->dd_data;
 
 	if (io_task->pwrb_handle) {
 		memset(io_task->pwrb_handle->pwrb, 0,
@@ -4102,8 +4098,8 @@ beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn)
 		spin_lock_bh(&phba->mgmt_sgl_lock);
 		free_mgmt_sgl_handle(phba,
 				     io_task->psgl_handle);
-		spin_unlock_bh(&phba->mgmt_sgl_lock);
 		io_task->psgl_handle = NULL;
+		spin_unlock_bh(&phba->mgmt_sgl_lock);
 	}
 
 	if (io_task->mtask_addr)
@@ -4153,7 +4149,7 @@ static void beiscsi_cleanup_task(struct iscsi_task *task)
 		}
 	} else {
 		if (!beiscsi_conn->login_in_progress)
-			beiscsi_free_mgmt_task_handles(beiscsi_conn);
+			beiscsi_free_mgmt_task_handles(beiscsi_conn, task);
 	}
 }
 
@@ -4381,7 +4377,6 @@ int beiscsi_iotask_v2(struct iscsi_task *task, struct scatterlist *sg,
 	unsigned int doorbell = 0;
 
 	pwrb = io_task->pwrb_handle->pwrb;
-	memset(pwrb, 0, sizeof(*pwrb));
 
 	io_task->cmd_bhs->iscsi_hdr.exp_statsn = 0;
 	io_task->bhs_len = sizeof(struct be_cmd_bhs);
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 3c5df92..ac4ef34 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -753,7 +753,8 @@ void
 free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle);
 
 void beiscsi_process_all_cqs(struct work_struct *work);
-void beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn);
+void beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn,
+				     struct iscsi_task *task);
 
 static inline bool beiscsi_error(struct beiscsi_hba *phba)
 {
-- 
1.7.10.4

