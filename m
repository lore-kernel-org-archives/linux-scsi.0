From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 04/12] be2iscsi: Maintain same ITT across login
Date: Wed, 30 Jun 2010 05:28:41 +0530
Message-ID: <20100629235830.GA20213@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:35294 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752824Ab0F3AHe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2010 20:07:34 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

  This patch ensures that the same ITT is maintained across
all login pdu's

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_iscsi.c |    4 +++
 drivers/scsi/be2iscsi/be_main.c  |   41 +++++++++++++++++++++++++++++++++----
 drivers/scsi/be2iscsi/be_main.h  |    1 +
 3 files changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index d9321ee..49e3718 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -277,6 +277,10 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
 		if (session->max_burst > 262144)
 			session->max_burst = 262144;
 		break;
+	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
+		if ((conn->max_xmit_dlength > 65536) ||
+		    (conn->max_xmit_dlength == 0))
+			conn->max_xmit_dlength = 65536;
 	default:
 		return 0;
 	}
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index d5ece74..811a788 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3434,14 +3434,12 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		return -ENOMEM;
 	io_task->bhs_pa.u.a64.address = paddr;
 	io_task->libiscsi_itt = (itt_t)task->itt;
-	io_task->pwrb_handle = alloc_wrb_handle(phba,
-						beiscsi_conn->beiscsi_conn_cid -
-						phba->fw_config.iscsi_cid_start
-						);
 	io_task->conn = beiscsi_conn;
 
 	task->hdr = (struct iscsi_hdr *)&io_task->cmd_bhs->iscsi_hdr;
 	task->hdr_max = sizeof(struct be_cmd_bhs);
+	io_task->psgl_handle = NULL;
+	io_task->psgl_handle = NULL;
 
 	if (task->sc) {
 		spin_lock(&phba->io_sgl_lock);
@@ -3449,6 +3447,11 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		spin_unlock(&phba->io_sgl_lock);
 		if (!io_task->psgl_handle)
 			goto free_hndls;
+		io_task->pwrb_handle = alloc_wrb_handle(phba,
+					beiscsi_conn->beiscsi_conn_cid -
+					phba->fw_config.iscsi_cid_start);
+		if (!io_task->pwrb_handle)
+			goto free_io_hndls;
 	} else {
 		io_task->scsi_cmnd = NULL;
 		if ((opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGIN) {
@@ -3463,9 +3466,20 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 				beiscsi_conn->login_in_progress = 1;
 				beiscsi_conn->plogin_sgl_handle =
 							io_task->psgl_handle;
+				io_task->pwrb_handle =
+					alloc_wrb_handle(phba,
+					beiscsi_conn->beiscsi_conn_cid -
+					phba->fw_config.iscsi_cid_start);
+				if (!io_task->pwrb_handle)
+					goto free_io_hndls;
+				beiscsi_conn->plogin_wrb_handle =
+							io_task->pwrb_handle;
+
 			} else {
 				io_task->psgl_handle =
 						beiscsi_conn->plogin_sgl_handle;
+				io_task->pwrb_handle =
+						beiscsi_conn->plogin_wrb_handle;
 			}
 		} else {
 			spin_lock(&phba->mgmt_sgl_lock);
@@ -3473,6 +3487,13 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 			spin_unlock(&phba->mgmt_sgl_lock);
 			if (!io_task->psgl_handle)
 				goto free_hndls;
+			io_task->pwrb_handle =
+					alloc_wrb_handle(phba,
+					beiscsi_conn->beiscsi_conn_cid -
+					phba->fw_config.iscsi_cid_start);
+			if (!io_task->pwrb_handle)
+				goto free_mgmt_hndls;
+
 		}
 	}
 	itt = (itt_t) cpu_to_be32(((unsigned int)io_task->pwrb_handle->
@@ -3483,12 +3504,22 @@ static int beiscsi_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 	io_task->cmd_bhs->iscsi_hdr.itt = itt;
 	return 0;
 
+free_io_hndls:
+	spin_lock(&phba->io_sgl_lock);
+	free_io_sgl_handle(phba, io_task->psgl_handle);
+	spin_unlock(&phba->io_sgl_lock);
+	goto free_hndls;
+free_mgmt_hndls:
+	spin_lock(&phba->mgmt_sgl_lock);
+	free_mgmt_sgl_handle(phba, io_task->psgl_handle);
+	spin_unlock(&phba->mgmt_sgl_lock);
 free_hndls:
 	phwi_ctrlr = phba->phwi_ctrlr;
 	pwrb_context = &phwi_ctrlr->wrb_context[
 			beiscsi_conn->beiscsi_conn_cid -
 			phba->fw_config.iscsi_cid_start];
-	free_wrb_handle(phba, pwrb_context, io_task->pwrb_handle);
+	if (io_task->pwrb_handle)
+		free_wrb_handle(phba, pwrb_context, io_task->pwrb_handle);
 	io_task->pwrb_handle = NULL;
 	pci_pool_free(beiscsi_sess->bhs_pool, io_task->cmd_bhs,
 		      io_task->bhs_pa.u.a64.address);
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index 05ad76e..08996d0 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -359,6 +359,7 @@ struct beiscsi_conn {
 	u32 beiscsi_conn_cid;
 	struct beiscsi_endpoint *ep;
 	unsigned short login_in_progress;
+	struct wrb_handle *plogin_wrb_handle;
 	struct sgl_handle *plogin_sgl_handle;
 	struct beiscsi_session *beiscsi_sess;
 	struct iscsi_task *task;
-- 
1.6.5.2

