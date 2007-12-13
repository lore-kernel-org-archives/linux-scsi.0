From: michaelc@cs.wisc.edu
Subject: [PATCH 08/24] iscsi class: Use our own workq instead of common system one.
Date: Thu, 13 Dec 2007 12:43:27 -0600
Message-ID: <119757143673-git-send-email-michaelc@cs.wisc.edu>
References: <11975714233983-git-send-email-michaelc@cs.wisc.edu>
 <1197571428957-git-send-email-michaelc@cs.wisc.edu>
 <11975714291290-git-send-email-michaelc@cs.wisc.edu>
 <11975714303190-git-send-email-michaelc@cs.wisc.edu>
 <11975714323427-git-send-email-michaelc@cs.wisc.edu>
 <11975714333916-git-send-email-michaelc@cs.wisc.edu>
 <11975714342353-git-send-email-michaelc@cs.wisc.edu>
 <1197571435692-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47017 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759212AbXLMSoA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Dec 2007 13:44:00 -0500
In-Reply-To: <1197571435692-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

There is just too much going on through the common workq and
something like a scsi device removal through sysfs affects
how long it will take to recover the transport, mark it as
failed, or shut it down gracefully.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 75d3069..9cc2cc8 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -50,6 +50,7 @@ struct iscsi_internal {
 };
 
 static atomic_t iscsi_session_nr; /* sysfs session id for next new session */
+static struct workqueue_struct *iscsi_eh_timer_workq;
 
 /*
  * list of registered transports and lock that must
@@ -252,7 +253,7 @@ static void session_recovery_timedout(struct work_struct *work)
 void iscsi_unblock_session(struct iscsi_cls_session *session)
 {
 	if (!cancel_delayed_work(&session->recovery_work))
-		flush_scheduled_work();
+		flush_workqueue(iscsi_eh_timer_workq);
 	scsi_target_unblock(&session->dev);
 }
 EXPORT_SYMBOL_GPL(iscsi_unblock_session);
@@ -260,8 +261,8 @@ EXPORT_SYMBOL_GPL(iscsi_unblock_session);
 void iscsi_block_session(struct iscsi_cls_session *session)
 {
 	scsi_target_block(&session->dev);
-	schedule_delayed_work(&session->recovery_work,
-			     session->recovery_tmo * HZ);
+	queue_delayed_work(iscsi_eh_timer_workq, &session->recovery_work,
+			   session->recovery_tmo * HZ);
 }
 EXPORT_SYMBOL_GPL(iscsi_block_session);
 
@@ -357,7 +358,7 @@ void iscsi_remove_session(struct iscsi_cls_session *session)
 	struct iscsi_host *ihost = shost->shost_data;
 
 	if (!cancel_delayed_work(&session->recovery_work))
-		flush_scheduled_work();
+		flush_workqueue(iscsi_eh_timer_workq);
 
 	mutex_lock(&ihost->mutex);
 	list_del(&session->host_list);
@@ -1521,8 +1522,14 @@ static __init int iscsi_transport_init(void)
 		goto unregister_session_class;
 	}
 
+	iscsi_eh_timer_workq = create_singlethread_workqueue("iscsi_eh");
+	if (!iscsi_eh_timer_workq)
+		goto release_nls;
+
 	return 0;
 
+release_nls:
+	sock_release(nls->sk_socket);
 unregister_session_class:
 	transport_class_unregister(&iscsi_session_class);
 unregister_conn_class:
@@ -1536,6 +1543,7 @@ unregister_transport_class:
 
 static void __exit iscsi_transport_exit(void)
 {
+	destroy_workqueue(iscsi_eh_timer_workq);
 	sock_release(nls->sk_socket);
 	transport_class_unregister(&iscsi_connection_class);
 	transport_class_unregister(&iscsi_session_class);
-- 
1.5.1.2

