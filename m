From: Jayamohan Kallickal <jayamohank@serverengines.com>
Subject: [PATCH 4/7] be2iscsi: cleans up abort handling V2
Date: Sat, 20 Feb 2010 08:03:56 +0530
Message-ID: <20100220023346.GA13665@serverengines.com>
Reply-To: Jayamohan Kalickal <jayamohank@serverengines.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from segment-124-30.sify.net ([124.30.166.146]:53510 "EHLO
	akhaparde.serverengines.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755787Ab0BTCdz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Feb 2010 21:33:55 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@suse.de, michaelc@cs.wisc.edu

 This patch cleans up abort handling when TMF is sent

Signed-off-by: Jayamohan Kallickal <jayamohank@serverengines.com>
---
 drivers/scsi/be2iscsi/be_main.c |   62 +++++++--------------------------------
 1 files changed, 11 insertions(+), 51 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index eab31a5..aee3734 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -1063,14 +1063,18 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 	case HWH_TYPE_IO:
 	case HWH_TYPE_IO_RD:
 		if ((task->hdr->opcode & ISCSI_OPCODE_MASK) ==
-		    ISCSI_OP_NOOP_OUT) {
+		     ISCSI_OP_NOOP_OUT)
 			be_complete_nopin_resp(beiscsi_conn, task, psol);
-		} else
+		else
 			be_complete_io(beiscsi_conn, task, psol);
 		break;
 
 	case HWH_TYPE_LOGOUT:
-		be_complete_logout(beiscsi_conn, task, psol);
+		if ((task->hdr->opcode & ISCSI_OPCODE_MASK) == ISCSI_OP_LOGOUT)
+			be_complete_logout(beiscsi_conn, task, psol);
+		else
+			be_complete_tmf(beiscsi_conn, task, psol);
+
 		break;
 
 	case HWH_TYPE_LOGIN:
@@ -1079,10 +1083,6 @@ static void hwi_complete_cmd(struct beiscsi_conn *beiscsi_conn,
 			 "- Solicited path \n");
 		break;
 
-	case HWH_TYPE_TMF:
-		be_complete_tmf(beiscsi_conn, task, psol);
-		break;
-
 	case HWH_TYPE_NOP:
 		be_complete_nopin_resp(beiscsi_conn, task, psol);
 		break;
@@ -3593,19 +3593,13 @@ static int beiscsi_iotask(struct iscsi_task *task, struct scatterlist *sg,
 
 static int beiscsi_mtask(struct iscsi_task *task)
 {
-	struct beiscsi_io_task *aborted_io_task, *io_task = task->dd_data;
+	struct beiscsi_io_task *io_task = task->dd_data;
 	struct iscsi_conn *conn = task->conn;
 	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
 	struct beiscsi_hba *phba = beiscsi_conn->phba;
-	struct iscsi_session *session;
 	struct iscsi_wrb *pwrb = NULL;
-	struct hwi_controller *phwi_ctrlr;
-	struct hwi_wrb_context *pwrb_context;
-	struct wrb_handle *pwrb_handle;
 	unsigned int doorbell = 0;
-	struct invalidate_command_table *inv_tbl;
-	struct iscsi_task *aborted_task;
-	unsigned int i, cid, tag, num_invalidate;
+	unsigned int cid;
 
 	cid = beiscsi_conn->beiscsi_conn_cid;
 	pwrb = io_task->pwrb_handle->pwrb;
@@ -3616,6 +3610,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		      io_task->pwrb_handle->wrb_index);
 	AMAP_SET_BITS(struct amap_iscsi_wrb, sgl_icd_idx, pwrb,
 		      io_task->psgl_handle->sgl_index);
+
 	switch (task->hdr->opcode & ISCSI_OPCODE_MASK) {
 	case ISCSI_OP_LOGIN:
 		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
@@ -3640,36 +3635,6 @@ static int beiscsi_mtask(struct iscsi_task *task)
 		hwi_write_buffer(pwrb, task);
 		break;
 	case ISCSI_OP_SCSI_TMFUNC:
-		session = conn->session;
-		i = ((struct iscsi_tm *)task->hdr)->rtt;
-		phwi_ctrlr = phba->phwi_ctrlr;
-		pwrb_context = &phwi_ctrlr->wrb_context[cid -
-					    phba->fw_config.iscsi_cid_start];
-		pwrb_handle = pwrb_context->pwrb_handle_basestd[be32_to_cpu(i)
-								>> 16];
-		aborted_task = pwrb_handle->pio_handle;
-		 if (!aborted_task)
-			return 0;
-
-		aborted_io_task = aborted_task->dd_data;
-		if (!aborted_io_task->scsi_cmnd)
-			return 0;
-
-		inv_tbl = phba->inv_tbl;
-		memset(inv_tbl, 0x0, sizeof(*inv_tbl));
-		inv_tbl->cid = cid;
-		inv_tbl->icd = aborted_io_task->psgl_handle->sgl_index;
-		num_invalidate = 1;
-		tag = mgmt_invalidate_icds(phba, inv_tbl, num_invalidate, cid);
-		if (!tag) {
-			shost_printk(KERN_WARNING, phba->shost,
-				     "mgmt_invalidate_icds could not be"
-				     " submitted\n");
-		} else {
-			wait_event_interruptible(phba->ctrl.mcc_wait[tag],
-						 phba->ctrl.mcc_numtag[tag]);
-			free_mcc_tag(&phba->ctrl, tag);
-		}
 		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
 			      INI_TMF_CMD);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
@@ -3678,7 +3643,7 @@ static int beiscsi_mtask(struct iscsi_task *task)
 	case ISCSI_OP_LOGOUT:
 		AMAP_SET_BITS(struct amap_iscsi_wrb, dmsg, pwrb, 0);
 		AMAP_SET_BITS(struct amap_iscsi_wrb, type, pwrb,
-				HWH_TYPE_LOGOUT);
+			      HWH_TYPE_LOGOUT);
 		hwi_write_buffer(pwrb, task);
 		break;
 
@@ -3704,17 +3669,12 @@ static int beiscsi_mtask(struct iscsi_task *task)
 
 static int beiscsi_task_xmit(struct iscsi_task *task)
 {
-	struct iscsi_conn *conn = task->conn;
 	struct beiscsi_io_task *io_task = task->dd_data;
 	struct scsi_cmnd *sc = task->sc;
-	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
 	struct scatterlist *sg;
 	int num_sg;
 	unsigned int  writedir = 0, xferlen = 0;
 
-	SE_DEBUG(DBG_LVL_4, "\n cid=%d In beiscsi_task_xmit task=%p conn=%p \t"
-		 "beiscsi_conn=%p \n", beiscsi_conn->beiscsi_conn_cid,
-		 task, conn, beiscsi_conn);
 	if (!sc)
 		return beiscsi_mtask(task);
 
-- 
1.6.4

