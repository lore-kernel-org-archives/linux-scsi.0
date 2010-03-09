From: michaelc@cs.wisc.edu
Subject: [PATCH 1/1] libiscsi: Fix recovery slowdown regression
Date: Tue,  9 Mar 2010 14:14:51 -0600
Message-ID: <1268165691-7815-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754484Ab0CIULk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 9 Mar 2010 15:11:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We could be failing/stopping a connection due to libiscsi starting
recovery/cleanup, but the xmit path or scsi eh thread path
could be dropping the connection at the same time.

As a result the session->state gets set to failed instead of in
recovery. We end up not blocking the session
and so the replacement timeout never gets started and we only end up
failing the IO when scsi_softirq_done sees that the
cmd has been running for (cmd->allowed + 1) * rq->timeout secs.

We used to fail the IO right away so users are seeing a long
delay when using dm-multipath. This problem was added in
2.6.28.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 685eaec..7688b8f 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3087,14 +3087,15 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 		session->state = ISCSI_STATE_TERMINATE;
 	else if (conn->stop_stage != STOP_CONN_RECOVER)
 		session->state = ISCSI_STATE_IN_RECOVERY;
+
+	old_stop_stage = conn->stop_stage;
+	conn->stop_stage = flag;
 	spin_unlock_bh(&session->lock);
 
 	del_timer_sync(&conn->transport_timer);
 	iscsi_suspend_tx(conn);
 
 	spin_lock_bh(&session->lock);
-	old_stop_stage = conn->stop_stage;
-	conn->stop_stage = flag;
 	conn->c_stage = ISCSI_CONN_STOPPED;
 	spin_unlock_bh(&session->lock);
 
-- 
1.6.6.1

