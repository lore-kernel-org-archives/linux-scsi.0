From: michaelc@cs.wisc.edu
Subject: [PATCH 03/13] iser: convert iser to new alloc_pdu api
Date: Tue,  2 Dec 2008 00:32:06 -0600
Message-ID: <1228199536-12595-4-git-send-email-michaelc@cs.wisc.edu>
References: <1228199536-12595-1-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-2-git-send-email-michaelc@cs.wisc.edu>
 <1228199536-12595-3-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52400 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbYLBGcW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Dec 2008 01:32:22 -0500
In-Reply-To: <1228199536-12595-3-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This just converts iser to new alloc_pdu api. It still
preallocates the pdu, so there is no difference.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |   48 +++++++++++++------------
 drivers/infiniband/ulp/iser/iser_initiator.c |    5 +--
 2 files changed, 27 insertions(+), 26 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 1e5b644..78bf5e4 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -119,6 +119,14 @@ error:
 	iscsi_conn_failure(conn, rc);
 }
 
+static int iscsi_iser_pdu_alloc(struct iscsi_task *task)
+{
+	struct iscsi_iser_task *iser_task = task->dd_data;
+
+	task->hdr = (struct iscsi_hdr *)&iser_task->desc.iscsi_header;
+	task->hdr_max = sizeof(iser_task->desc.iscsi_header);
+	return 0;
+}
 
 /**
  * iscsi_iser_task_init - Initialize task
@@ -180,25 +188,26 @@ static int
 iscsi_iser_task_xmit_unsol_data(struct iscsi_conn *conn,
 				 struct iscsi_task *task)
 {
-	struct iscsi_data  hdr;
+	struct iscsi_r2t_info *r2t = &task->unsol_r2t;
+	struct iscsi_data hdr;
 	int error = 0;
 
 	/* Send data-out PDUs while there's still unsolicited data to send */
-	while (task->unsol_count > 0) {
-		iscsi_prep_unsolicit_data_pdu(task, &hdr);
+	while (iscsi_task_has_unsol_data(task)) {
+		iscsi_prep_data_out_pdu(task, r2t, &hdr);
 		debug_scsi("Sending data-out: itt 0x%x, data count %d\n",
-			   hdr.itt, task->data_count);
+			   hdr.itt, r2t->data_count);
 
 		/* the buffer description has been passed with the command */
 		/* Send the command */
 		error = iser_send_data_out(conn, task, &hdr);
 		if (error) {
-			task->unsol_datasn--;
+			r2t->datasn--;
 			goto iscsi_iser_task_xmit_unsol_data_exit;
 		}
-		task->unsol_count -= task->data_count;
+		r2t->sent += r2t->data_count;
 		debug_scsi("Need to send %d more as data-out PDUs\n",
-			   task->unsol_count);
+			   r2t->data_length - r2t->sent);
 	}
 
 iscsi_iser_task_xmit_unsol_data_exit:
@@ -220,7 +229,7 @@ iscsi_iser_task_xmit(struct iscsi_task *task)
 
 		debug_scsi("cmd [itt %x total %d imm %d unsol_data %d\n",
 			   task->itt, scsi_bufflen(task->sc),
-			   task->imm_count, task->unsol_count);
+			   task->imm_count, task->unsol_r2t.data_length);
 	}
 
 	debug_scsi("task deq [cid %d itt 0x%x]\n",
@@ -235,7 +244,7 @@ iscsi_iser_task_xmit(struct iscsi_task *task)
 	}
 
 	/* Send unsolicited data-out PDU(s) if necessary */
-	if (task->unsol_count)
+	if (iscsi_task_has_unsol_data(task))
 		error = iscsi_iser_task_xmit_unsol_data(conn, task);
 
  iscsi_iser_task_xmit_exit:
@@ -244,13 +253,15 @@ iscsi_iser_task_xmit(struct iscsi_task *task)
 	return error;
 }
 
-static void
-iscsi_iser_cleanup_task(struct iscsi_conn *conn, struct iscsi_task *task)
+static void iscsi_iser_cleanup_task(struct iscsi_task *task)
 {
 	struct iscsi_iser_task *iser_task = task->dd_data;
 
-	/* mgmt tasks do not need special cleanup */
-	if (!task->sc)
+	/*
+	 * mgmt tasks do not need special cleanup and we do not
+	 * allocate anything in the init task callout
+	 */
+	if (!task->sc || task->state == ISCSI_TASK_PENDING)
 		return;
 
 	if (iser_task->status == ISER_TASK_STATUS_STARTED) {
@@ -391,9 +402,6 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
 	struct Scsi_Host *shost;
-	int i;
-	struct iscsi_task *task;
-	struct iscsi_iser_task *iser_task;
 	struct iser_conn *ib_conn;
 
 	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, ISCSI_MAX_CMD_PER_LUN);
@@ -430,13 +438,6 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	session = cls_session->dd_data;
 
 	shost->can_queue = session->scsi_cmds_max;
-	/* libiscsi setup itts, data and pool so just set desc fields */
-	for (i = 0; i < session->cmds_max; i++) {
-		task = session->cmds[i];
-		iser_task = task->dd_data;
-		task->hdr = (struct iscsi_cmd *)&iser_task->desc.iscsi_header;
-		task->hdr_max = sizeof(iser_task->desc.iscsi_header);
-	}
 	return cls_session;
 
 remove_host:
@@ -652,6 +653,7 @@ static struct iscsi_transport iscsi_iser_transport = {
 	.init_task		= iscsi_iser_task_init,
 	.xmit_task		= iscsi_iser_task_xmit,
 	.cleanup_task		= iscsi_iser_cleanup_task,
+	.alloc_pdu		= iscsi_iser_pdu_alloc,
 	/* recovery */
 	.session_recovery_timedout = iscsi_session_recovery_timedout,
 
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index cdd2831..284b485 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -323,8 +323,7 @@ int iser_send_command(struct iscsi_conn *conn,
 	unsigned long edtl;
 	int err = 0;
 	struct iser_data_buf *data_buf;
-
-	struct iscsi_cmd *hdr =  task->hdr;
+	struct iscsi_cmd *hdr =  (struct iscsi_cmd *)task->hdr;
 	struct scsi_cmnd *sc  =  task->sc;
 
 	if (!iser_conn_state_comp(iser_conn->ib_conn, ISER_CONN_UP)) {
@@ -363,7 +362,7 @@ int iser_send_command(struct iscsi_conn *conn,
 		err = iser_prepare_write_cmd(task,
 					     task->imm_count,
 				             task->imm_count +
-					     task->unsol_count,
+					     task->unsol_r2t.data_length,
 					     edtl);
 		if (err)
 			goto send_command_error;
-- 
1.5.6.5

