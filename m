From: michaelc@cs.wisc.edu
Subject: [PATCH 06/13] libiscsi: fix nop response/reply and session cleanup race
Date: Wed, 13 May 2009 17:57:43 -0500
Message-ID: <12422554731307-git-send-email-michaelc@cs.wisc.edu>
References: <12422554702856-git-send-email-michaelc@cs.wisc.edu>
 <12422554711659-git-send-email-michaelc@cs.wisc.edu>
 <12422554711865-git-send-email-michaelc@cs.wisc.edu>
 <1242255472240-git-send-email-michaelc@cs.wisc.edu>
 <12422554724154-git-send-email-michaelc@cs.wisc.edu>
 <12422554733484-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:51832 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762119AbZEMW5z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2009 18:57:55 -0400
In-Reply-To: <12422554733484-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If we are responding to a nop from the target by sending our nop,
and the session is getting torn down, then iscsi_start_session_recovery
could set the conn stop bits while the recv path is sending the nop
response and we will hit the bug ons in __iscsi_conn_send_pdu.

This has us check the state in __iscsi_conn_send_pdu and fail all
incoming mgmt IO if we are  not logged in and if the pdu is not login
related. It also changes the ordering of the setting of conn stop state
bits so they are set after the session state is set (both are set under
the session lock).

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 047543c..212fe20 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -546,6 +546,9 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 		 */
 		task = conn->login_task;
 	else {
+		if (session->state != ISCSI_STATE_LOGGED_IN)
+			return NULL;
+
 		BUG_ON(conn->c_stage == ISCSI_CONN_INITIAL_STAGE);
 		BUG_ON(conn->c_stage == ISCSI_CONN_STOPPED);
 
@@ -2566,8 +2569,6 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 {
 	int old_stop_stage;
 
-	del_timer_sync(&conn->transport_timer);
-
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
 	if (conn->stop_stage == STOP_CONN_TERM) {
@@ -2585,13 +2586,17 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 		session->state = ISCSI_STATE_TERMINATE;
 	else if (conn->stop_stage != STOP_CONN_RECOVER)
 		session->state = ISCSI_STATE_IN_RECOVERY;
+	spin_unlock_bh(&session->lock);
 
+	del_timer_sync(&conn->transport_timer);
+	iscsi_suspend_tx(conn);
+
+	spin_lock_bh(&session->lock);
 	old_stop_stage = conn->stop_stage;
 	conn->stop_stage = flag;
 	conn->c_stage = ISCSI_CONN_STOPPED;
 	spin_unlock_bh(&session->lock);
 
-	iscsi_suspend_tx(conn);
 	/*
 	 * for connection level recovery we should not calculate
 	 * header digest. conn->hdr_size used for optimization
-- 
1.5.2.1

