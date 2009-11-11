From: michaelc@cs.wisc.edu
Subject: [PATCH 5/7] iscsi class: modify handling of replacement timeout
Date: Wed, 11 Nov 2009 16:34:34 -0600
Message-ID: <1257978876-2742-6-git-send-email-michaelc@cs.wisc.edu>
References: <1257978876-2742-1-git-send-email-michaelc@cs.wisc.edu>
 <1257978876-2742-2-git-send-email-michaelc@cs.wisc.edu>
 <1257978876-2742-3-git-send-email-michaelc@cs.wisc.edu>
 <1257978876-2742-4-git-send-email-michaelc@cs.wisc.edu>
 <1257978876-2742-5-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60212 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759506AbZKKWex (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Nov 2009 17:34:53 -0500
In-Reply-To: <1257978876-2742-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch modifies the replacement/recovery_timeout so it works
more like the fc fast io fail tmo.

If userspace tries to set the replacement/recovery_timeout to less than
zero, we will turn off the forced recovery cleanup.

If userspace sets the value to 0 then we will force the recovery
cleanup immediately.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index dc04ca1..ea3892e 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -627,8 +627,10 @@ static void __iscsi_block_session(struct work_struct *work)
 	spin_unlock_irqrestore(&session->lock, flags);
 	scsi_target_block(&session->dev);
 	ISCSI_DBG_TRANS_SESSION(session, "Completed SCSI target blocking\n");
-	queue_delayed_work(iscsi_eh_timer_workq, &session->recovery_work,
-			   session->recovery_tmo * HZ);
+	if (session->recovery_tmo >= 0)
+		queue_delayed_work(iscsi_eh_timer_workq,
+				   &session->recovery_work,
+				   session->recovery_tmo * HZ);
 }
 
 void iscsi_block_session(struct iscsi_cls_session *session)
@@ -1348,8 +1350,7 @@ iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 	switch (ev->u.set_param.param) {
 	case ISCSI_PARAM_SESS_RECOVERY_TMO:
 		sscanf(data, "%d", &value);
-		if (value != 0)
-			session->recovery_tmo = value;
+		session->recovery_tmo = value;
 		break;
 	default:
 		err = transport->set_param(conn, ev->u.set_param.param,
-- 
1.6.2.2

