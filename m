From: michaelc@cs.wisc.edu
Subject: [PATCH 11/13] libiscsi: check if iscsi host has work queue before queueing work
Date: Wed, 13 May 2009 17:57:48 -0500
Message-ID: <12422554764013-git-send-email-michaelc@cs.wisc.edu>
References: <12422554702856-git-send-email-michaelc@cs.wisc.edu>
 <12422554711659-git-send-email-michaelc@cs.wisc.edu>
 <12422554711865-git-send-email-michaelc@cs.wisc.edu>
 <1242255472240-git-send-email-michaelc@cs.wisc.edu>
 <12422554724154-git-send-email-michaelc@cs.wisc.edu>
 <12422554733484-git-send-email-michaelc@cs.wisc.edu>
 <12422554731307-git-send-email-michaelc@cs.wisc.edu>
 <12422554742374-git-send-email-michaelc@cs.wisc.edu>
 <12422554743206-git-send-email-michaelc@cs.wisc.edu>
 <12422554752623-git-send-email-michaelc@cs.wisc.edu>
 <12422554753201-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51873 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762123AbZEMW55 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 18:57:57 -0400
In-Reply-To: <12422554753201-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Instead of having libiscsi check if the offload bit is set, have
it check if the lld created a work queue. I think this is more
clear.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   21 +++++++++++----------
 1 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 57eb3af..dafa054 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -81,7 +81,8 @@ inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
 	struct Scsi_Host *shost = conn->session->host;
 	struct iscsi_host *ihost = shost_priv(shost);
 
-	queue_work(ihost->workq, &conn->xmitwork);
+	if (ihost->workq)
+		queue_work(ihost->workq, &conn->xmitwork);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_queue_work);
 
@@ -110,10 +111,8 @@ iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
 		 * xmit thread
 		 */
 		if (!list_empty(&session->leadconn->cmdqueue) ||
-		    !list_empty(&session->leadconn->mgmtqueue)) {
-			if (!(session->tt->caps & CAP_DATA_PATH_OFFLOAD))
-				iscsi_conn_queue_work(session->leadconn);
-		}
+		    !list_empty(&session->leadconn->mgmtqueue))
+			iscsi_conn_queue_work(session->leadconn);
 	}
 }
 EXPORT_SYMBOL_GPL(iscsi_update_cmdsn);
@@ -555,6 +554,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		      char *data, uint32_t data_size)
 {
 	struct iscsi_session *session = conn->session;
+	struct iscsi_host *ihost = shost_priv(session->host);
 	struct iscsi_task *task;
 	itt_t itt;
 
@@ -618,7 +618,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 						   task->conn->session->age);
 	}
 
-	if (session->tt->caps & CAP_DATA_PATH_OFFLOAD) {
+	if (!ihost->workq) {
 		if (iscsi_prep_mgmt_task(conn, task))
 			goto free_task;
 
@@ -1368,6 +1368,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 {
 	struct iscsi_cls_session *cls_session;
 	struct Scsi_Host *host;
+	struct iscsi_host *ihost;
 	int reason = 0;
 	struct iscsi_session *session;
 	struct iscsi_conn *conn;
@@ -1378,6 +1379,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	sc->SCp.ptr = NULL;
 
 	host = sc->device->host;
+	ihost = shost_priv(host);
 	spin_unlock(host->host_lock);
 
 	cls_session = starget_to_session(scsi_target(sc->device));
@@ -1440,7 +1442,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		goto reject;
 	}
 
-	if (session->tt->caps & CAP_DATA_PATH_OFFLOAD) {
+	if (!ihost->workq) {
 		reason = iscsi_prep_scsi_cmd_pdu(task);
 		if (reason) {
 			if (reason == -ENOMEM) {
@@ -1673,7 +1675,7 @@ void iscsi_suspend_tx(struct iscsi_conn *conn)
 	struct iscsi_host *ihost = shost_priv(shost);
 
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-	if (!(conn->session->tt->caps & CAP_DATA_PATH_OFFLOAD))
+	if (ihost->workq)
 		flush_workqueue(ihost->workq);
 }
 EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
@@ -1681,8 +1683,7 @@ EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 static void iscsi_start_tx(struct iscsi_conn *conn)
 {
 	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
-	if (!(conn->session->tt->caps & CAP_DATA_PATH_OFFLOAD))
-		iscsi_conn_queue_work(conn);
+	iscsi_conn_queue_work(conn);
 }
 
 /*
-- 
1.5.2.1

