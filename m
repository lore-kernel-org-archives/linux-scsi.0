From: michaelc@cs.wisc.edu
Subject: [PATCH 17/17] be2iscsi: fix null ptr ref in conn get param
Date: Wed, 16 Feb 2011 15:04:41 -0600
Message-ID: <1297890281-9076-18-git-send-email-michaelc@cs.wisc.edu>
References: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48042 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754377Ab1BPVEn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Feb 2011 16:04:43 -0500
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p1GL4gqG027099
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:42 -0500
Received: from meanminna.corp.redhat.com (vpn-11-254.rdu.redhat.com [10.11.11.254])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p1GL4Tt6004636
	for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2011 16:04:42 -0500
In-Reply-To: <1297890281-9076-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Mike Christie <michaelc@cs.wisc.edu>

The ep_disconnect function could be freeing the ep
while beiscsi_conn_get_param is running. This has
the driver use the get ep param callback instead
of the get conn param to fix this.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_iscsi.c |   18 +++++-------------
 drivers/scsi/be2iscsi/be_iscsi.h |    4 ++--
 drivers/scsi/be2iscsi/be_main.c  |    3 ++-
 3 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index eaaa881..868cc55 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -210,28 +210,20 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 }
 
 /**
- * beiscsi_conn_get_param - get the iscsi parameter
- * @cls_conn: pointer to iscsi cls conn
+ * beiscsi_ep_get_param - get the iscsi parameter
+ * @ep: pointer to iscsi ep
  * @param: parameter type identifier
  * @buf: buffer pointer
  *
  * returns iscsi parameter
  */
-int beiscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
+int beiscsi_ep_get_param(struct iscsi_endpoint *ep,
 			   enum iscsi_param param, char *buf)
 {
-	struct beiscsi_endpoint *beiscsi_ep;
-	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	struct beiscsi_endpoint *beiscsi_ep = ep->dd_data;
 	int len = 0;
 
 	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_get_param, param= %d\n", param);
-	beiscsi_ep = beiscsi_conn->ep;
-	if (!beiscsi_ep) {
-		SE_DEBUG(DBG_LVL_1,
-			 "In beiscsi_conn_get_param , no beiscsi_ep\n");
-		return -ENODEV;
-	}
 
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
@@ -244,7 +236,7 @@ int beiscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 			len = sprintf(buf, "%pI6\n", &beiscsi_ep->dst6_addr);
 		break;
 	default:
-		return iscsi_conn_get_param(cls_conn, param, buf);
+		return -ENOSYS;
 	}
 	return len;
 }
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index 8950a70..9c53279 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -48,8 +48,8 @@ int beiscsi_conn_bind(struct iscsi_cls_session *cls_session,
 		      struct iscsi_cls_conn *cls_conn,
 		      uint64_t transport_fd, int is_leading);
 
-int beiscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
-			   enum iscsi_param param, char *buf);
+int beiscsi_ep_get_param(struct iscsi_endpoint *ep, enum iscsi_param param,
+			 char *buf);
 
 int beiscsi_get_host_param(struct Scsi_Host *shost,
 			   enum iscsi_host_param param, char *buf);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 79cefbe..bd50145 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4384,7 +4384,7 @@ struct iscsi_transport beiscsi_iscsi_transport = {
 	.bind_conn = beiscsi_conn_bind,
 	.destroy_conn = iscsi_conn_teardown,
 	.set_param = beiscsi_set_param,
-	.get_conn_param = beiscsi_conn_get_param,
+	.get_conn_param = iscsi_conn_get_param,
 	.get_session_param = iscsi_session_get_param,
 	.get_host_param = beiscsi_get_host_param,
 	.start_conn = beiscsi_conn_start,
@@ -4395,6 +4395,7 @@ struct iscsi_transport beiscsi_iscsi_transport = {
 	.alloc_pdu = beiscsi_alloc_pdu,
 	.parse_pdu_itt = beiscsi_parse_pdu,
 	.get_stats = beiscsi_conn_get_stats,
+	.get_ep_param = beiscsi_ep_get_param,
 	.ep_connect = beiscsi_ep_connect,
 	.ep_poll = beiscsi_ep_poll,
 	.ep_disconnect = beiscsi_ep_disconnect,
-- 
1.7.2.3

