From: michaelc@cs.wisc.edu
Subject: [PATCH 03/14] iser: have iser use its own logging
Date: Thu,  5 Mar 2009 14:45:57 -0600
Message-ID: <123628597367-git-send-email-michaelc@cs.wisc.edu>
References: <12362859683749-git-send-email-michaelc@cs.wisc.edu>
 <12362859693831-git-send-email-michaelc@cs.wisc.edu>
 <12362859702687-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52771 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754208AbZCEUqS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 15:46:18 -0500
In-Reply-To: <12362859702687-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

iser has its own logging inrfastrucutre. Convert it to use
it instead of libiscsi.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 1287639..4338f54 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -168,7 +168,7 @@ iscsi_iser_mtask_xmit(struct iscsi_conn *conn, struct iscsi_task *task)
 {
 	int error = 0;
 
-	debug_scsi("task deq [cid %d itt 0x%x]\n", conn->id, task->itt);
+	iser_dbg("task deq [cid %d itt 0x%x]\n", conn->id, task->itt);
 
 	error = iser_send_control(conn, task);
 
@@ -195,7 +195,7 @@ iscsi_iser_task_xmit_unsol_data(struct iscsi_conn *conn,
 	/* Send data-out PDUs while there's still unsolicited data to send */
 	while (iscsi_task_has_unsol_data(task)) {
 		iscsi_prep_data_out_pdu(task, r2t, &hdr);
-		debug_scsi("Sending data-out: itt 0x%x, data count %d\n",
+		iser_dbg("Sending data-out: itt 0x%x, data count %d\n",
 			   hdr.itt, r2t->data_count);
 
 		/* the buffer description has been passed with the command */
@@ -206,7 +206,7 @@ iscsi_iser_task_xmit_unsol_data(struct iscsi_conn *conn,
 			goto iscsi_iser_task_xmit_unsol_data_exit;
 		}
 		r2t->sent += r2t->data_count;
-		debug_scsi("Need to send %d more as data-out PDUs\n",
+		iser_dbg("Need to send %d more as data-out PDUs\n",
 			   r2t->data_length - r2t->sent);
 	}
 
@@ -227,12 +227,12 @@ iscsi_iser_task_xmit(struct iscsi_task *task)
 	if (task->sc->sc_data_direction == DMA_TO_DEVICE) {
 		BUG_ON(scsi_bufflen(task->sc) == 0);
 
-		debug_scsi("cmd [itt %x total %d imm %d unsol_data %d\n",
+		iser_dbg("cmd [itt %x total %d imm %d unsol_data %d\n",
 			   task->itt, scsi_bufflen(task->sc),
 			   task->imm_count, task->unsol_r2t.data_length);
 	}
 
-	debug_scsi("task deq [cid %d itt 0x%x]\n",
+	iser_dbg("task deq [cid %d itt 0x%x]\n",
 		   conn->id, task->itt);
 
 	/* Send the cmd PDU */
-- 
1.6.0.6

