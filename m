From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 4/9] iscsi: convert iscsi_tcp to new set/get param fns
Date: Wed, 28 Jun 2006 12:00:26 -0500
Message-ID: <1151514026.11553.50.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:29875 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751426AbWF1RDJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 13:03:09 -0400
Received: from [192.168.0.7] (c-69-180-139-167.hsd1.mn.comcast.net [69.180.139.167])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k5SH2mHp019943
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2006 12:03:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Convert iscsi_tcp to new lib functions.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index b4743a9..848fb2a 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -2130,19 +2130,21 @@ iscsi_r2tpool_free(struct iscsi_session 
 
 static int
 iscsi_conn_set_param(struct iscsi_cls_conn *cls_conn, enum iscsi_param param,
-		     uint32_t value)
+		     char *buf, int buflen)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_session *session = conn->session;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
+	int value;
 
 	switch(param) {
 	case ISCSI_PARAM_MAX_RECV_DLENGTH: {
 		char *saveptr = tcp_conn->data;
 		gfp_t flags = GFP_KERNEL;
 
+		sscanf(buf, "%d", &value);
 		if (tcp_conn->data_size >= value) {
-			conn->max_recv_dlength = value;
+			iscsi_set_param(cls_conn, param, buf, buflen);
 			break;
 		}
 
@@ -2165,15 +2167,12 @@ iscsi_conn_set_param(struct iscsi_cls_co
 		else
 			free_pages((unsigned long)saveptr,
 				   get_order(tcp_conn->data_size));
-		conn->max_recv_dlength = value;
+		iscsi_set_param(cls_conn, param, buf, buflen);
 		tcp_conn->data_size = value;
-		}
-		break;
-	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
-		conn->max_xmit_dlength =  value;
 		break;
+		}
 	case ISCSI_PARAM_HDRDGST_EN:
-		conn->hdrdgst_en = value;
+		iscsi_set_param(cls_conn, param, buf, buflen);
 		tcp_conn->hdr_size = sizeof(struct iscsi_hdr);
 		if (conn->hdrdgst_en) {
 			tcp_conn->hdr_size += sizeof(__u32);
@@ -2197,7 +2196,7 @@ iscsi_conn_set_param(struct iscsi_cls_co
 		}
 		break;
 	case ISCSI_PARAM_DATADGST_EN:
-		conn->datadgst_en = value;
+		iscsi_set_param(cls_conn, param, buf, buflen);
 		if (conn->datadgst_en) {
 			if (!tcp_conn->data_tx_tfm)
 				tcp_conn->data_tx_tfm =
@@ -2220,121 +2219,36 @@ iscsi_conn_set_param(struct iscsi_cls_co
 		tcp_conn->sendpage = conn->datadgst_en ?
 			sock_no_sendpage : tcp_conn->sock->ops->sendpage;
 		break;
-	case ISCSI_PARAM_INITIAL_R2T_EN:
-		session->initial_r2t_en = value;
-		break;
 	case ISCSI_PARAM_MAX_R2T:
+		sscanf(buf, "%d", &value);
 		if (session->max_r2t == roundup_pow_of_two(value))
 			break;
 		iscsi_r2tpool_free(session);
-		session->max_r2t = value;
+		iscsi_set_param(cls_conn, param, buf, buflen);
 		if (session->max_r2t & (session->max_r2t - 1))
 			session->max_r2t = roundup_pow_of_two(session->max_r2t);
 		if (iscsi_r2tpool_alloc(session))
 			return -ENOMEM;
 		break;
-	case ISCSI_PARAM_IMM_DATA_EN:
-		session->imm_data_en = value;
-		break;
-	case ISCSI_PARAM_FIRST_BURST:
-		session->first_burst = value;
-		break;
-	case ISCSI_PARAM_MAX_BURST:
-		session->max_burst = value;
-		break;
-	case ISCSI_PARAM_PDU_INORDER_EN:
-		session->pdu_inorder_en = value;
-		break;
-	case ISCSI_PARAM_DATASEQ_INORDER_EN:
-		session->dataseq_inorder_en = value;
-		break;
-	case ISCSI_PARAM_ERL:
-		session->erl = value;
-		break;
-	case ISCSI_PARAM_IFMARKER_EN:
-		BUG_ON(value);
-		session->ifmarker_en = value;
-		break;
-	case ISCSI_PARAM_OFMARKER_EN:
-		BUG_ON(value);
-		session->ofmarker_en = value;
-		break;
-	case ISCSI_PARAM_EXP_STATSN:
-		conn->exp_statsn = value;
-		break;
-	default:
-		break;
-	}
-
-	return 0;
-}
-
-static int
-iscsi_session_get_param(struct iscsi_cls_session *cls_session,
-			enum iscsi_param param, uint32_t *value)
-{
-	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
-	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
-
-	switch(param) {
-	case ISCSI_PARAM_INITIAL_R2T_EN:
-		*value = session->initial_r2t_en;
-		break;
-	case ISCSI_PARAM_MAX_R2T:
-		*value = session->max_r2t;
-		break;
-	case ISCSI_PARAM_IMM_DATA_EN:
-		*value = session->imm_data_en;
-		break;
-	case ISCSI_PARAM_FIRST_BURST:
-		*value = session->first_burst;
-		break;
-	case ISCSI_PARAM_MAX_BURST:
-		*value = session->max_burst;
-		break;
-	case ISCSI_PARAM_PDU_INORDER_EN:
-		*value = session->pdu_inorder_en;
-		break;
-	case ISCSI_PARAM_DATASEQ_INORDER_EN:
-		*value = session->dataseq_inorder_en;
-		break;
-	case ISCSI_PARAM_ERL:
-		*value = session->erl;
-		break;
-	case ISCSI_PARAM_IFMARKER_EN:
-		*value = session->ifmarker_en;
-		break;
-	case ISCSI_PARAM_OFMARKER_EN:
-		*value = session->ofmarker_en;
-		break;
 	default:
-		return -EINVAL;
+		return iscsi_set_param(cls_conn, param, buf, buflen);
 	}
 
 	return 0;
 }
 
 static int
-iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
-		     enum iscsi_param param, uint32_t *value)
+iscsi_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
+			 enum iscsi_param param, char *buf)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct inet_sock *inet;
+	struct ipv6_pinfo *np;
+	struct sock *sk;
+	int len;
 
 	switch(param) {
-	case ISCSI_PARAM_MAX_RECV_DLENGTH:
-		*value = conn->max_recv_dlength;
-		break;
-	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
-		*value = conn->max_xmit_dlength;
-		break;
-	case ISCSI_PARAM_HDRDGST_EN:
-		*value = conn->hdrdgst_en;
-		break;
-	case ISCSI_PARAM_DATADGST_EN:
-		*value = conn->datadgst_en;
-		break;
 	case ISCSI_PARAM_CONN_PORT:
 		mutex_lock(&conn->xmitmutex);
 		if (!tcp_conn->sock) {
@@ -2343,30 +2257,9 @@ iscsi_conn_get_param(struct iscsi_cls_co
 		}
 
 		inet = inet_sk(tcp_conn->sock->sk);
-		*value = be16_to_cpu(inet->dport);
+		len = sprintf(buf, "%hu\n", be16_to_cpu(inet->dport));
 		mutex_unlock(&conn->xmitmutex);
-	case ISCSI_PARAM_EXP_STATSN:
-		*value = conn->exp_statsn;
 		break;
-	default:
-		return -EINVAL;
-	}
-
-	return 0;
-}
-
-static int
-iscsi_conn_get_str_param(struct iscsi_cls_conn *cls_conn,
-			 enum iscsi_param param, char *buf)
-{
-	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
-	struct sock *sk;
-	struct inet_sock *inet;
-	struct ipv6_pinfo *np;
-	int len = 0;
-
-	switch (param) {
 	case ISCSI_PARAM_CONN_ADDRESS:
 		mutex_lock(&conn->xmitmutex);
 		if (!tcp_conn->sock) {
@@ -2388,7 +2281,7 @@ iscsi_conn_get_str_param(struct iscsi_cl
 		mutex_unlock(&conn->xmitmutex);
 		break;
 	default:
-		return -EINVAL;
+		return iscsi_conn_get_param(cls_conn, param, buf);
 	}
 
 	return len;
@@ -2501,7 +2394,11 @@ static struct iscsi_transport iscsi_tcp_
 				  ISCSI_ERL |
 				  ISCSI_CONN_PORT |
 				  ISCSI_CONN_ADDRESS |
-				  ISCSI_EXP_STATSN,
+				  ISCSI_EXP_STATSN |
+				  ISCSI_PERSISTENT_PORT |
+				  ISCSI_PERSISTENT_ADDRESS |
+				  ISCSI_TARGET_NAME |
+				  ISCSI_TPGT,
 	.host_template		= &iscsi_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
 	.max_conn		= 1,
@@ -2514,8 +2411,7 @@ static struct iscsi_transport iscsi_tcp_
 	.bind_conn		= iscsi_tcp_conn_bind,
 	.destroy_conn		= iscsi_tcp_conn_destroy,
 	.set_param		= iscsi_conn_set_param,
-	.get_conn_param		= iscsi_conn_get_param,
-	.get_conn_str_param	= iscsi_conn_get_str_param,
+	.get_conn_param		= iscsi_tcp_conn_get_param,
 	.get_session_param	= iscsi_session_get_param,
 	.start_conn		= iscsi_conn_start,
 	.stop_conn		= iscsi_conn_stop,


