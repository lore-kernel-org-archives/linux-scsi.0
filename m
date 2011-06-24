From: michaelc@cs.wisc.edu
Subject: [PATCH 4/4] libiscsi_tcp: fix LLD data allocation
Date: Fri, 24 Jun 2011 15:11:55 -0500
Message-ID: <1308946315-9240-5-git-send-email-michaelc@cs.wisc.edu>
References: <1308946315-9240-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:62683 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126Ab1FXUKO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 24 Jun 2011 16:10:14 -0400
In-Reply-To: <1308946315-9240-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Have libiscsi_tcp have upper layers allocate the LLD data
along with the iscsi_cls_conn struct, so it is refcounted.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi_tcp.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index e98ae33..09b232f 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1084,7 +1084,8 @@ iscsi_tcp_conn_setup(struct iscsi_cls_session *cls_session, int dd_data_size,
 	struct iscsi_cls_conn *cls_conn;
 	struct iscsi_tcp_conn *tcp_conn;
 
-	cls_conn = iscsi_conn_setup(cls_session, sizeof(*tcp_conn), conn_idx);
+	cls_conn = iscsi_conn_setup(cls_session,
+				    sizeof(*tcp_conn) + dd_data_size, conn_idx);
 	if (!cls_conn)
 		return NULL;
 	conn = cls_conn->dd_data;
@@ -1096,22 +1097,13 @@ iscsi_tcp_conn_setup(struct iscsi_cls_session *cls_session, int dd_data_size,
 
 	tcp_conn = conn->dd_data;
 	tcp_conn->iscsi_conn = conn;
-
-	tcp_conn->dd_data = kzalloc(dd_data_size, GFP_KERNEL);
-	if (!tcp_conn->dd_data) {
-		iscsi_conn_teardown(cls_conn);
-		return NULL;
-	}
+	tcp_conn->dd_data = conn->dd_data + sizeof(*tcp_conn);
 	return cls_conn;
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_conn_setup);
 
 void iscsi_tcp_conn_teardown(struct iscsi_cls_conn *cls_conn)
 {
-	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-
-	kfree(tcp_conn->dd_data);
 	iscsi_conn_teardown(cls_conn);
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_conn_teardown);
-- 
1.7.2.3

