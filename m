From: Karen Xie <kxie@chelsio.com>
Subject: [PATCH 1/2 2.6.29-rc] libiscsi - change iscsi_session_failure() to take iscsi_session pointer
Date: Tue, 24 Feb 2009 17:28:14 -0800
Message-ID: <200902250128.n1P1SEcp007738@localhost.localdomain>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stargate.chelsio.com ([12.22.49.110]:6237 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753640AbZBYBYm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Feb 2009 20:24:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
Cc: michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com, kxie@chelsio.com

[PATCH 1/2 2.6.29-rc] libiscsi - change iscsi_session_failure() to take iscsi_session pointer

From: Karen Xie <kxie@chelsio.com>

change iscsi_session_failure() to take a pointer to iscsi_session instead of iscsi_cls_session.

Signed-off-by: Mike Christie<michaelc@cs.wisc.edu>
Signed-off-by: Karen Xie <kxie@chelsio.com>
---

 drivers/scsi/libiscsi.c |    5 ++---
 include/scsi/libiscsi.h |    2 +-
 2 files changed, 3 insertions(+), 4 deletions(-)


diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 809d32d..5ad87e8 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1034,10 +1034,9 @@ struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt)
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
@@ -2043,7 +2042,7 @@ EXPORT_SYMBOL_GPL(iscsi_host_alloc);
 
 static void iscsi_notify_host_removed(struct iscsi_cls_session *cls_session)
 {
-	iscsi_session_failure(cls_session, ISCSI_ERR_INVALID_HOST);
+	iscsi_session_failure(cls_session->dd_data, ISCSI_ERR_INVALID_HOST);
 }
 
 /**
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 7360e19..07c3cd3 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -382,7 +382,7 @@ extern void iscsi_conn_stop(struct iscsi_cls_conn *, int);
 extern int iscsi_conn_bind(struct iscsi_cls_session *, struct iscsi_cls_conn *,
 			   int);
 extern void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err);
-extern void iscsi_session_failure(struct iscsi_cls_session *cls_session,
+extern void iscsi_session_failure(struct iscsi_session *session,
 				  enum iscsi_err err);
 extern int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 				enum iscsi_param param, char *buf);
