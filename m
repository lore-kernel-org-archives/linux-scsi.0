From: michaelc@cs.wisc.edu
Subject: [PATCH 11/14] libiscsi: pass session failure a session struct
Date: Thu,  5 Mar 2009 14:46:05 -0600
Message-ID: <12362859771239-git-send-email-michaelc@cs.wisc.edu>
References: <12362859683749-git-send-email-michaelc@cs.wisc.edu>
 <12362859693831-git-send-email-michaelc@cs.wisc.edu>
 <12362859702687-git-send-email-michaelc@cs.wisc.edu>
 <123628597367-git-send-email-michaelc@cs.wisc.edu>
 <12362859734023-git-send-email-michaelc@cs.wisc.edu>
 <12362859743025-git-send-email-michaelc@cs.wisc.edu>
 <12362859742776-git-send-email-michaelc@cs.wisc.edu>
 <12362859754088-git-send-email-michaelc@cs.wisc.edu>
 <1236285975607-git-send-email-michaelc@cs.wisc.edu>
 <12362859763502-git-send-email-michaelc@cs.wisc.edu>
 <12362859771656-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52833 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755122AbZCEUqW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 15:46:22 -0500
In-Reply-To: <12362859771656-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

The api for conn and session failures is akward because
one takes a conn from the lib and one takes a session
from the class. This syncs up the interfaces to use
structs from the lib.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c |    5 ++---
 include/scsi/libiscsi.h |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index d12f979..d070179 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1069,10 +1069,9 @@ struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt)
 }
 EXPORT_SYMBOL_GPL(iscsi_itt_to_ctask);
 
-void iscsi_session_failure(struct iscsi_cls_session *cls_session,
+void iscsi_session_failure(struct iscsi_session *session,
 			   enum iscsi_err err)
 {
-	struct iscsi_session *session = cls_session->dd_data;
 	struct iscsi_conn *conn;
 	struct device *dev;
 	unsigned long flags;
@@ -2097,7 +2096,7 @@ EXPORT_SYMBOL_GPL(iscsi_host_alloc);
 
 static void iscsi_notify_host_removed(struct iscsi_cls_session *cls_session)
 {
-	iscsi_session_failure(cls_session, ISCSI_ERR_INVALID_HOST);
+	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_INVALID_HOST);
 }
 
 /**
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 84eded9..7ffaed2 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -378,7 +378,7 @@ extern void iscsi_conn_stop(struct iscsi_cls_conn *, int);
 extern int iscsi_conn_bind(struct iscsi_cls_session *, struct iscsi_cls_conn *,
 			   int);
 extern void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err);
-extern void iscsi_session_failure(struct iscsi_cls_session *cls_session,
+extern void iscsi_session_failure(struct iscsi_session *session,
 				  enum iscsi_err err);
 extern int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 				enum iscsi_param param, char *buf);
-- 
1.6.0.6

