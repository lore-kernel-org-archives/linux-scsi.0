From: jayamohank@gmail.com
Subject: [PATCH 05/15] be2iscsi: Fix freeing CXN specific driver resources.
Date: Mon, 11 Mar 2013 21:39:35 -0700
Message-ID: <1363063186-4902-5-git-send-email-jayamohan.kallickal@emulex.com>
References: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:41176 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750714Ab3CLEkF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Mar 2013 00:40:05 -0400
Received: by mail-pb0-f41.google.com with SMTP id um15so4577618pbc.0
        for <linux-scsi@vger.kernel.org>; Mon, 11 Mar 2013 21:40:04 -0700 (PDT)
In-Reply-To: <1363063186-4902-1-git-send-email-jayamohan.kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu
Cc: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

From: "Jayamohan.Kallickal" <jayamohan.kallickal@emulex.com>

 Free CXN specific resource held by driver when login redirection
 or connection retry happens. Login redirection was failing
 because WRB/SGL were not allocated from the CID on which
 doorbell was rung.

Signed-off-by: John Soni Jose <sony.john-n@emulex.com>
Signed-off-by: Jayamohan.Kallickal <jayamohan.kallickal@emulex.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |   15 +++++++++
 drivers/scsi/be2iscsi/be_main.c  |   68 ++++++++++++++++++++++++++------------
 drivers/scsi/be2iscsi/be_main.h  |    1 +
 3 files changed, 62 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index 1097fa2..a4eb610 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -990,9 +990,24 @@ static void beiscsi_put_cid(struct beiscsi_hba *phba, unsigned short cid)
 static void beiscsi_free_ep(struct beiscsi_endpoint *beiscsi_ep)
 {
 	struct beiscsi_hba *phba = beiscsi_ep->phba;
+	struct beiscsi_conn *beiscsi_conn;
 
 	beiscsi_put_cid(phba, beiscsi_ep->ep_cid);
 	beiscsi_ep->phba = NULL;
+
+	/**
+	 * Check if any connection resource allocated by driver
+	 * is to be freed.This case occurs when target redirection
+	 * or connection retry is done.
+	 **/
+	if (!beiscsi_ep->conn)
+		return;
+
+	beiscsi_conn = beiscsi_ep->conn;
+	if (beiscsi_conn->login_in_progress) {
+		beiscsi_free_mgmt_task_handles(beiscsi_conn);
+		beiscsi_conn->login_in_progress = 0;
+	}
 }
 
 /**
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 72e4052..22882cb 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4066,6 +4066,49 @@ static void beiscsi_clean_port(struct beiscsi_hba *phba)
 }
 
 /**
+ * beiscsi_free_mgmt_task_handles()- Free driver CXN resources
+ * @beiscsi_conn: ptr to the conn to be cleaned up
+ *
+ * Free driver mgmt resources binded to CXN.
+ **/
+void
+beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn)
+{
+	struct beiscsi_io_task *io_task;
+	struct beiscsi_hba *phba = beiscsi_conn->phba;
+	struct hwi_wrb_context *pwrb_context;
+	struct hwi_controller *phwi_ctrlr;
+
+	phwi_ctrlr = phba->phwi_ctrlr;
+	pwrb_context = &phwi_ctrlr->wrb_context
+		       [beiscsi_conn->beiscsi_conn_cid
+		       - phba->fw_config.iscsi_cid_start];
+	io_task = beiscsi_conn->task->dd_data;
+
+	if (io_task->pwrb_handle) {
+		memset(io_task->pwrb_handle->pwrb, 0,
+		       sizeof(struct iscsi_wrb));
+		free_wrb_handle(phba, pwrb_context,
+				io_task->pwrb_handle);
+		io_task->pwrb_handle = NULL;
+	}
+
+	if (io_task->psgl_handle) {
+		spin_lock(&phba->mgmt_sgl_lock);
+		free_mgmt_sgl_handle(phba,
+				     io_task->psgl_handle);
+		spin_unlock(&phba->mgmt_sgl_lock);
+		io_task->psgl_handle = NULL;
+	}
+
+	if (io_task->mtask_addr)
+		pci_unmap_single(phba->pcidev,
+				 io_task->mtask_addr,
+				 io_task->mtask_data_count,
+				 PCI_DMA_TODEVICE);
+}
+
+/**
  * beiscsi_cleanup_task()- Free driver resources of the task
  * @task: ptr to the iscsi task
  *
@@ -4104,27 +4147,8 @@ static void beiscsi_cleanup_task(struct iscsi_task *task)
 			io_task->psgl_handle = NULL;
 		}
 	} else {
-		if (!beiscsi_conn->login_in_progress) {
-			if (io_task->pwrb_handle) {
-				free_wrb_handle(phba, pwrb_context,
-						io_task->pwrb_handle);
-				io_task->pwrb_handle = NULL;
-			}
-			if (io_task->psgl_handle) {
-				spin_lock(&phba->mgmt_sgl_lock);
-				free_mgmt_sgl_handle(phba,
-						     io_task->psgl_handle);
-				spin_unlock(&phba->mgmt_sgl_lock);
-				io_task->psgl_handle = NULL;
-			}
-			if (io_task->mtask_addr) {
-				pci_unmap_single(phba->pcidev,
-						 io_task->mtask_addr,
-						 io_task->mtask_data_count,
-						 PCI_DMA_TODEVICE);
-				io_task->mtask_addr = 0;
-			}
-		}
+		if (!beiscsi_conn->login_in_progress)
+			beiscsi_free_mgmt_task_handles(beiscsi_conn);
 	}
 }
 
@@ -4237,6 +4261,7 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	} else {
 		io_task->scsi_cmnd = NULL;
 		if ((opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN) {
+			beiscsi_conn->task = task;
 			if (!beiscsi_conn->login_in_progress) {
 				spin_lock(&phba->mgmt_sgl_lock);
 				io_task->psgl_handle = (struct sgl_handle *)
@@ -4279,7 +4304,6 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 				io_task->pwrb_handle =
 						beiscsi_conn->plogin_wrb_handle;
 			}
-			beiscsi_conn->task = task;
 		} else {
 			spin_lock(&phba->mgmt_sgl_lock);
 			io_task->psgl_handle = alloc_mgmt_sgl_handle(phba);
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index e53d087..b098b5b 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -749,6 +749,7 @@ void
 free_mgmt_sgl_handle(struct beiscsi_hba *phba, struct sgl_handle *psgl_handle);
 
 void beiscsi_process_all_cqs(struct work_struct *work);
+void beiscsi_free_mgmt_task_handles(struct beiscsi_conn *beiscsi_conn);
 
 static inline bool beiscsi_error(struct beiscsi_hba *phba)
 {
-- 
1.7.10.4

