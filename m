From: michaelc@cs.wisc.edu
Subject: [PATCH 21/23] iscsi_tcp: hold lock during data rsp processing
Date: Tue,  4 Dec 2007 18:42:35 -0600
Message-ID: <1196815389832-git-send-email-michaelc@cs.wisc.edu>
References: <11968153574025-git-send-email-michaelc@cs.wisc.edu>
 <119681536472-git-send-email-michaelc@cs.wisc.edu>
 <11968153663560-git-send-email-michaelc@cs.wisc.edu>
 <11968153713324-git-send-email-michaelc@cs.wisc.edu>
 <11968153753743-git-send-email-michaelc@cs.wisc.edu>
 <11968153751098-git-send-email-michaelc@cs.wisc.edu>
 <1196815376111-git-send-email-michaelc@cs.wisc.edu>
 <1196815377131-git-send-email-michaelc@cs.wisc.edu>
 <11968153781126-git-send-email-michaelc@cs.wisc.edu>
 <1196815378769-git-send-email-michaelc@cs.wisc.edu>
 <11968153791438-git-send-email-michaelc@cs.wisc.edu>
 <11968153801823-git-send-email-michaelc@cs.wisc.edu>
 <11968153812001-git-send-email-michaelc@cs.wisc.edu>
 <1196815382808-git-send-email-michaelc@cs.wisc.edu>
 <11968153831244-git-send-email-michaelc@cs.wisc.edu>
 <11968153842186-git-send-email-michaelc@cs.wisc.edu>
 <11968153853971-git-send-email-michaelc@cs.wisc.edu>
 <1196815386656-git-send-email-michaelc@cs.wisc.edu>
 <11968153873372-git-send-email-michaelc@cs.wisc.edu>
 <11968153871693-git-send-email-michaelc@cs.wisc.edu>
 <11968153883385-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:42701 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751309AbXLEAnO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Dec 2007 19:43:14 -0500
In-Reply-To: <11968153883385-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

iscsi_data_rsp needs to hold the sesison lock when it calls
iscsi_update_cmdsn.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/iscsi_tcp.c |   14 ++++++--------
 1 files changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 84c4a50..edebdf2 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -641,13 +641,11 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	}
 
 	/* fill-in new R2T associated with the task */
-	spin_lock(&session->lock);
 	iscsi_update_cmdsn(session, (struct iscsi_nopin*)rhdr);
 
 	if (!ctask->sc || session->state != ISCSI_STATE_LOGGED_IN) {
 		printk(KERN_INFO "iscsi_tcp: dropping R2T itt %d in "
 		       "recovery...\n", ctask->itt);
-		spin_unlock(&session->lock);
 		return 0;
 	}
 
@@ -660,7 +658,6 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 		printk(KERN_ERR "iscsi_tcp: invalid R2T with zero data len\n");
 		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
-		spin_unlock(&session->lock);
 		return ISCSI_ERR_DATALEN;
 	}
 
@@ -676,7 +673,6 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 		       r2t->data_offset, scsi_bufflen(ctask->sc));
 		__kfifo_put(tcp_ctask->r2tpool.queue, (void*)&r2t,
 			    sizeof(void*));
-		spin_unlock(&session->lock);
 		return ISCSI_ERR_DATALEN;
 	}
 
@@ -690,8 +686,6 @@ iscsi_r2t_rsp(struct iscsi_conn *conn, struct iscsi_cmd_task *ctask)
 	conn->r2t_pdus_cnt++;
 
 	iscsi_requeue_ctask(ctask);
-	spin_unlock(&session->lock);
-
 	return 0;
 }
 
@@ -764,7 +758,9 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 	switch(opcode) {
 	case ISCSI_OP_SCSI_DATA_IN:
 		ctask = session->cmds[itt];
+		spin_lock(&conn->session->lock);
 		rc = iscsi_data_rsp(conn, ctask);
+		spin_unlock(&conn->session->lock);
 		if (rc)
 			return rc;
 		if (tcp_conn->in.datalen) {
@@ -806,9 +802,11 @@ iscsi_tcp_hdr_dissect(struct iscsi_conn *conn, struct iscsi_hdr *hdr)
 		ctask = session->cmds[itt];
 		if (ahslen)
 			rc = ISCSI_ERR_AHSLEN;
-		else if (ctask->sc->sc_data_direction == DMA_TO_DEVICE)
+		else if (ctask->sc->sc_data_direction == DMA_TO_DEVICE) {
+			spin_lock(&session->lock);
 			rc = iscsi_r2t_rsp(conn, ctask);
-		else
+			spin_unlock(&session->lock);
+		} else
 			rc = ISCSI_ERR_PROTO;
 		break;
 	case ISCSI_OP_LOGIN_RSP:
-- 
1.5.1.2

