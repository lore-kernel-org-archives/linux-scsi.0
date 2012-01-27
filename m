From: michaelc@cs.wisc.edu
Subject: [PATCH 2/3] libiscsi_tcp: fix max_r2t manipulation
Date: Thu, 26 Jan 2012 21:13:10 -0600
Message-ID: <1327633991-2615-3-git-send-email-michaelc@cs.wisc.edu>
References: <1327633991-2615-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab2A0DEt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jan 2012 22:04:49 -0500
In-Reply-To: <1327633991-2615-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>, xi.wang@gmail.com

From: Mike Christie <michaelc@cs.wisc.edu>

Problem description from Xi Wang:
A large max_r2t could lead to integer overflow in subsequent call to
iscsi_tcp_r2tpool_alloc(), allocating a smaller buffer than expected
and leading to out-of-bounds write.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
cc: xi.wang@gmail.com

---
 drivers/scsi/cxgbi/libcxgbi.c |   13 ++-----------
 drivers/scsi/iscsi_tcp.c      |   13 +------------
 drivers/scsi/libiscsi.c       |    2 +-
 drivers/scsi/libiscsi_tcp.c   |   18 ++++++++++++++++++
 include/scsi/libiscsi.h       |    2 +-
 include/scsi/libiscsi_tcp.h   |    2 +-
 6 files changed, 24 insertions(+), 26 deletions(-)

diff --git a/drivers/scsi/cxgbi/libcxgbi.c b/drivers/scsi/cxgbi/libcxgbi.c
index d3ff9cd..e6e6aa9 100644
--- a/drivers/scsi/cxgbi/libcxgbi.c
+++ b/drivers/scsi/cxgbi/libcxgbi.c
@@ -2148,11 +2148,10 @@ int cxgbi_set_conn_param(struct iscsi_cls_conn *cls_conn,
 			enum iscsi_param param, char *buf, int buflen)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct cxgbi_conn *cconn = tcp_conn->dd_data;
 	struct cxgbi_sock *csk = cconn->cep->csk;
-	int value, err = 0;
+	int err;
 
 	log_debug(1 << CXGBI_DBG_ISCSI,
 		"cls_conn 0x%p, param %d, buf(%d) %s.\n",
@@ -2174,15 +2173,7 @@ int cxgbi_set_conn_param(struct iscsi_cls_conn *cls_conn,
 							conn->datadgst_en, 0);
 		break;
 	case ISCSI_PARAM_MAX_R2T:
-		sscanf(buf, "%d", &value);
-		if (value <= 0 || !is_power_of_2(value))
-			return -EINVAL;
-		if (session->max_r2t == value)
-			break;
-		iscsi_tcp_r2tpool_free(session);
-		err = iscsi_set_param(cls_conn, param, buf, buflen);
-		if (!err && iscsi_tcp_r2tpool_alloc(session))
-			return -ENOMEM;
+		return iscsi_tcp_set_max_r2t(conn, buf);
 	case ISCSI_PARAM_MAX_RECV_DLENGTH:
 		err = iscsi_set_param(cls_conn, param, buf, buflen);
 		if (!err)
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index db47158..453a740 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -684,10 +684,8 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
 				       int buflen)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct iscsi_sw_tcp_conn *tcp_sw_conn = tcp_conn->dd_data;
-	int value;
 
 	switch(param) {
 	case ISCSI_PARAM_HDRDGST_EN:
@@ -699,16 +697,7 @@ static int iscsi_sw_tcp_conn_set_param(struct iscsi_cls_conn *cls_conn,
 			sock_no_sendpage : tcp_sw_conn->sock->ops->sendpage;
 		break;
 	case ISCSI_PARAM_MAX_R2T:
-		sscanf(buf, "%d", &value);
-		if (value <= 0 || !is_power_of_2(value))
-			return -EINVAL;
-		if (session->max_r2t == value)
-			break;
-		iscsi_tcp_r2tpool_free(session);
-		iscsi_set_param(cls_conn, param, buf, buflen);
-		if (iscsi_tcp_r2tpool_alloc(session))
-			return -ENOMEM;
-		break;
+		return iscsi_tcp_set_max_r2t(conn, buf);
 	default:
 		return iscsi_set_param(cls_conn, param, buf, buflen);
 	}
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 143bbe4..911a4a9 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -3200,7 +3200,7 @@ int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 		sscanf(buf, "%d", &session->initial_r2t_en);
 		break;
 	case ISCSI_PARAM_MAX_R2T:
-		sscanf(buf, "%d", &session->max_r2t);
+		sscanf(buf, "%hu", &session->max_r2t);
 		break;
 	case ISCSI_PARAM_IMM_DATA_EN:
 		sscanf(buf, "%d", &session->imm_data_en);
diff --git a/drivers/scsi/libiscsi_tcp.c b/drivers/scsi/libiscsi_tcp.c
index 5715a3d..24f812d 100644
--- a/drivers/scsi/libiscsi_tcp.c
+++ b/drivers/scsi/libiscsi_tcp.c
@@ -1170,6 +1170,24 @@ void iscsi_tcp_r2tpool_free(struct iscsi_session *session)
 }
 EXPORT_SYMBOL_GPL(iscsi_tcp_r2tpool_free);
 
+int iscsi_tcp_set_max_r2t(struct iscsi_conn *conn, char*buf)
+{
+	struct iscsi_session *session = conn->session;
+	unsigned short r2ts = 0;
+
+	sscanf(buf, "%hu", &r2ts);
+	if (session->max_r2t == r2ts)
+		return 0;
+
+	if (!r2ts || !is_power_of_2(r2ts))
+		return -EINVAL;
+
+	session->max_r2t = r2ts;
+	iscsi_tcp_r2tpool_free(session);
+	return iscsi_tcp_r2tpool_alloc(session);
+}
+EXPORT_SYMBOL_GPL(iscsi_tcp_set_max_r2t);
+
 void iscsi_tcp_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 			      struct iscsi_stats *stats)
 {
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index cedcff3..a84c1ad 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -268,7 +268,7 @@ struct iscsi_session {
 	int			lu_reset_timeout;
 	int			tgt_reset_timeout;
 	int			initial_r2t_en;
-	unsigned		max_r2t;
+	unsigned short		max_r2t;
 	int			imm_data_en;
 	unsigned		first_burst;
 	unsigned		max_burst;
diff --git a/include/scsi/libiscsi_tcp.h b/include/scsi/libiscsi_tcp.h
index ac0cc1d..215469a 100644
--- a/include/scsi/libiscsi_tcp.h
+++ b/include/scsi/libiscsi_tcp.h
@@ -128,7 +128,7 @@ extern void iscsi_tcp_conn_teardown(struct iscsi_cls_conn *cls_conn);
 /* misc helpers */
 extern int iscsi_tcp_r2tpool_alloc(struct iscsi_session *session);
 extern void iscsi_tcp_r2tpool_free(struct iscsi_session *session);
-
+extern int iscsi_tcp_set_max_r2t(struct iscsi_conn *conn, char *buf);
 extern void iscsi_tcp_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 				     struct iscsi_stats *stats);
 #endif /* LIBISCSI_TCP_H */
-- 
1.7.6

