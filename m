From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/9] iscsi: fixup set/get param functions
Date: Wed, 28 Jun 2006 12:00:23 -0500
Message-ID: <1151514024.11553.47.camel@madmax>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:27827 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751460AbWF1RCQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Jun 2006 13:02:16 -0400
Received: from [192.168.0.7] (c-69-180-139-167.hsd1.mn.comcast.net [69.180.139.167])
	(authenticated bits=0)
	by sabe.cs.wisc.edu (8.13.6/8.13.6) with ESMTP id k5SH1sk8019922
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NO)
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2006 12:02:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Reduce duplication in the software iscsi_transport modules by
adding a libiscsi function to handle the common grunt work.

This also has the drivers return specifc -EXXX values for different
errors so userspace can finally handle them in a sane way.

Also just pass the sysfs buffers to the drivers so HW iscsi can
get/set its string values, like targetname, and initiatorname.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 2673a11..7c76a98 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1697,6 +1697,185 @@ int iscsi_conn_bind(struct iscsi_cls_ses
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_bind);
 
+
+int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
+		    enum iscsi_param param, char *buf, int buflen)
+{
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct iscsi_session *session = conn->session;
+	uint32_t value;
+
+	switch(param) {
+	case ISCSI_PARAM_MAX_RECV_DLENGTH:
+		sscanf(buf, "%d", &conn->max_recv_dlength);
+		break;
+	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
+		sscanf(buf, "%d", &conn->max_xmit_dlength);
+		break;
+	case ISCSI_PARAM_HDRDGST_EN:
+		sscanf(buf, "%d", &conn->hdrdgst_en);
+		break;
+	case ISCSI_PARAM_DATADGST_EN:
+		sscanf(buf, "%d", &conn->datadgst_en);
+		break;
+	case ISCSI_PARAM_INITIAL_R2T_EN:
+		sscanf(buf, "%d", &session->initial_r2t_en);
+		break;
+	case ISCSI_PARAM_MAX_R2T:
+		sscanf(buf, "%d", &session->max_r2t);
+		break;
+	case ISCSI_PARAM_IMM_DATA_EN:
+		sscanf(buf, "%d", &session->imm_data_en);
+		break;
+	case ISCSI_PARAM_FIRST_BURST:
+		sscanf(buf, "%d", &session->first_burst);
+		break;
+	case ISCSI_PARAM_MAX_BURST:
+		sscanf(buf, "%d", &session->max_burst);
+		break;
+	case ISCSI_PARAM_PDU_INORDER_EN:
+		sscanf(buf, "%d", &session->pdu_inorder_en);
+		break;
+	case ISCSI_PARAM_DATASEQ_INORDER_EN:
+		sscanf(buf, "%d", &session->dataseq_inorder_en);
+		break;
+	case ISCSI_PARAM_ERL:
+		sscanf(buf, "%d", &session->erl);
+		break;
+	case ISCSI_PARAM_IFMARKER_EN:
+		sscanf(buf, "%d", &value);
+		BUG_ON(value);
+		break;
+	case ISCSI_PARAM_OFMARKER_EN:
+		sscanf(buf, "%d", &value);
+		BUG_ON(value);
+		break;
+	case ISCSI_PARAM_EXP_STATSN:
+		sscanf(buf, "%u", &conn->exp_statsn);
+		break;
+	case ISCSI_PARAM_TARGET_NAME:
+		/* this should not change between logins */
+		if (session->targetname)
+			break;
+
+		session->targetname = kstrdup(buf, GFP_KERNEL);
+		if (!session->targetname)
+			return -ENOMEM;
+		break;
+	case ISCSI_PARAM_TPGT:
+		sscanf(buf, "%d", &session->tpgt);
+		break;
+	case ISCSI_PARAM_PERSISTENT_PORT:
+		sscanf(buf, "%d", &conn->persistent_port);
+		break;
+	case ISCSI_PARAM_PERSISTENT_ADDRESS:
+		/*
+		 * this is the address returned in discovery so it should
+		 * not change between logins.
+		 */
+		if (conn->persistent_address)
+			break;
+
+		conn->persistent_address = kstrdup(buf, GFP_KERNEL);
+		if (!conn->persistent_address)
+			return -ENOMEM;
+		break;
+	default:
+		return -ENOSYS;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(iscsi_set_param);
+
+int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
+			    enum iscsi_param param, char *buf)
+{
+	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
+	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
+	int len;
+
+	switch(param) {
+	case ISCSI_PARAM_INITIAL_R2T_EN:
+		len = sprintf(buf, "%d\n", session->initial_r2t_en);
+		break;
+	case ISCSI_PARAM_MAX_R2T:
+		len = sprintf(buf, "%hu\n", session->max_r2t);
+		break;
+	case ISCSI_PARAM_IMM_DATA_EN:
+		len = sprintf(buf, "%d\n", session->imm_data_en);
+		break;
+	case ISCSI_PARAM_FIRST_BURST:
+		len = sprintf(buf, "%u\n", session->first_burst);
+		break;
+	case ISCSI_PARAM_MAX_BURST:
+		len = sprintf(buf, "%u\n", session->max_burst);
+		break;
+	case ISCSI_PARAM_PDU_INORDER_EN:
+		len = sprintf(buf, "%d\n", session->pdu_inorder_en);
+		break;
+	case ISCSI_PARAM_DATASEQ_INORDER_EN:
+		len = sprintf(buf, "%d\n", session->dataseq_inorder_en);
+		break;
+	case ISCSI_PARAM_ERL:
+		len = sprintf(buf, "%d\n", session->erl);
+		break;
+	case ISCSI_PARAM_TARGET_NAME:
+		len = sprintf(buf, "%s\n", session->targetname);
+		break;
+	case ISCSI_PARAM_TPGT:
+		len = sprintf(buf, "%d\n", session->tpgt);
+		break;
+	default:
+		return -ENOSYS;
+	}
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(iscsi_session_get_param);
+
+int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
+			 enum iscsi_param param, char *buf)
+{
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	int len;
+
+	switch(param) {
+	case ISCSI_PARAM_MAX_RECV_DLENGTH:
+		len = sprintf(buf, "%u\n", conn->max_recv_dlength);
+		break;
+	case ISCSI_PARAM_MAX_XMIT_DLENGTH:
+		len = sprintf(buf, "%u\n", conn->max_xmit_dlength);
+		break;
+	case ISCSI_PARAM_HDRDGST_EN:
+		len = sprintf(buf, "%d\n", conn->hdrdgst_en);
+		break;
+	case ISCSI_PARAM_DATADGST_EN:
+		len = sprintf(buf, "%d\n", conn->datadgst_en);
+		break;
+	case ISCSI_PARAM_IFMARKER_EN:
+		len = sprintf(buf, "%d\n", conn->ifmarker_en);
+		break;
+	case ISCSI_PARAM_OFMARKER_EN:
+		len = sprintf(buf, "%d\n", conn->ofmarker_en);
+		break;
+	case ISCSI_PARAM_EXP_STATSN:
+		len = sprintf(buf, "%u\n", conn->exp_statsn);
+		break;
+	case ISCSI_PARAM_PERSISTENT_PORT:
+		len = sprintf(buf, "%d\n", conn->persistent_port);
+		break;
+	case ISCSI_PARAM_PERSISTENT_ADDRESS:
+		len = sprintf(buf, "%s\n", conn->persistent_address);
+		break;
+	default:
+		return -ENOSYS;
+	}
+
+	return len;
+}
+EXPORT_SYMBOL_GPL(iscsi_conn_get_param);
+
 MODULE_AUTHOR("Mike Christie");
 MODULE_DESCRIPTION("iSCSI library functions");
 MODULE_LICENSE("GPL");
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 99e76d4..147c854 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -233,7 +233,6 @@ static void iscsi_session_release(struct
 
 	shost = iscsi_session_to_shost(session);
 	scsi_host_put(shost);
-	kfree(session->targetname);
 	kfree(session);
 	module_put(transport->owner);
 }
@@ -388,7 +387,6 @@ static void iscsi_conn_release(struct de
 	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev);
 	struct device *parent = conn->dev.parent;
 
-	kfree(conn->persistent_address);
 	kfree(conn);
 	put_device(parent);
 }
@@ -877,23 +875,13 @@ iscsi_if_destroy_conn(struct iscsi_trans
 	return 0;
 }
 
-static void
-iscsi_copy_param(struct iscsi_uevent *ev, uint32_t *value, char *data)
-{
-	if (ev->u.set_param.len != sizeof(uint32_t))
-		BUG();
-	memcpy(value, data, min_t(uint32_t, sizeof(uint32_t),
-		ev->u.set_param.len));
-}
-
 static int
 iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
 {
 	char *data = (char*)ev + sizeof(*ev);
 	struct iscsi_cls_conn *conn;
 	struct iscsi_cls_session *session;
-	int err = 0;
-	uint32_t value = 0;
+	int err = 0, value = 0;
 
 	session = iscsi_session_lookup(ev->u.set_param.sid);
 	conn = iscsi_conn_lookup(ev->u.set_param.sid, ev->u.set_param.cid);
@@ -902,42 +890,13 @@ iscsi_set_param(struct iscsi_transport *
 
 	switch (ev->u.set_param.param) {
 	case ISCSI_PARAM_SESS_RECOVERY_TMO:
-		iscsi_copy_param(ev, &value, data);
+		sscanf(data, "%d", &value);
 		if (value != 0)
 			session->recovery_tmo = value;
 		break;
-	case ISCSI_PARAM_TARGET_NAME:
-		/* this should not change between logins */
-		if (session->targetname)
-			return 0;
-
-		session->targetname = kstrdup(data, GFP_KERNEL);
-		if (!session->targetname)
-			return -ENOMEM;
-		break;
-	case ISCSI_PARAM_TPGT:
-		iscsi_copy_param(ev, &value, data);
-		session->tpgt = value;
-		break;
-	case ISCSI_PARAM_PERSISTENT_PORT:
-		iscsi_copy_param(ev, &value, data);
-		conn->persistent_port = value;
-		break;
-	case ISCSI_PARAM_PERSISTENT_ADDRESS:
-		/*
-		 * this is the address returned in discovery so it should
-		 * not change between logins.
-		 */
-		if (conn->persistent_address)
-			return 0;
-
-		conn->persistent_address = kstrdup(data, GFP_KERNEL);
-		if (!conn->persistent_address)
-			return -ENOMEM;
-		break;
 	default:
-		iscsi_copy_param(ev, &value, data);
-		err = transport->set_param(conn, ev->u.set_param.param, value);
+		err = transport->set_param(conn, ev->u.set_param.param,
+					   data, ev->u.set_param.len);
 	}
 
 	return err;
@@ -1165,49 +1124,31 @@ struct class_device_attribute class_devi
 /*
  * iSCSI connection attrs
  */
-#define iscsi_conn_int_attr_show(param, format)				\
+#define iscsi_conn_attr_show(param)					\
 static ssize_t								\
-show_conn_int_param_##param(struct class_device *cdev, char *buf)	\
+show_conn_param_##param(struct class_device *cdev, char *buf)		\
 {									\
-	uint32_t value = 0;						\
 	struct iscsi_cls_conn *conn = iscsi_cdev_to_conn(cdev);		\
 	struct iscsi_transport *t = conn->transport;			\
-									\
-	t->get_conn_param(conn, param, &value);				\
-	return snprintf(buf, 20, format"\n", value);			\
+	return t->get_conn_param(conn, param, buf);			\
 }
 
-#define iscsi_conn_int_attr(field, param, format)			\
-	iscsi_conn_int_attr_show(param, format)				\
-static ISCSI_CLASS_ATTR(conn, field, S_IRUGO, show_conn_int_param_##param, \
+#define iscsi_conn_attr(field, param)					\
+	iscsi_conn_attr_show(param)					\
+static ISCSI_CLASS_ATTR(conn, field, S_IRUGO, show_conn_param_##param,	\
 			NULL);
 
-iscsi_conn_int_attr(max_recv_dlength, ISCSI_PARAM_MAX_RECV_DLENGTH, "%u");
-iscsi_conn_int_attr(max_xmit_dlength, ISCSI_PARAM_MAX_XMIT_DLENGTH, "%u");
-iscsi_conn_int_attr(header_digest, ISCSI_PARAM_HDRDGST_EN, "%d");
-iscsi_conn_int_attr(data_digest, ISCSI_PARAM_DATADGST_EN, "%d");
-iscsi_conn_int_attr(ifmarker, ISCSI_PARAM_IFMARKER_EN, "%d");
-iscsi_conn_int_attr(ofmarker, ISCSI_PARAM_OFMARKER_EN, "%d");
-iscsi_conn_int_attr(persistent_port, ISCSI_PARAM_PERSISTENT_PORT, "%d");
-iscsi_conn_int_attr(port, ISCSI_PARAM_CONN_PORT, "%d");
-iscsi_conn_int_attr(exp_statsn, ISCSI_PARAM_EXP_STATSN, "%u");
-
-#define iscsi_conn_str_attr_show(param)					\
-static ssize_t								\
-show_conn_str_param_##param(struct class_device *cdev, char *buf)	\
-{									\
-	struct iscsi_cls_conn *conn = iscsi_cdev_to_conn(cdev);		\
-	struct iscsi_transport *t = conn->transport;			\
-	return t->get_conn_str_param(conn, param, buf);			\
-}
-
-#define iscsi_conn_str_attr(field, param)				\
-	iscsi_conn_str_attr_show(param)					\
-static ISCSI_CLASS_ATTR(conn, field, S_IRUGO, show_conn_str_param_##param, \
-			NULL);
-
-iscsi_conn_str_attr(persistent_address, ISCSI_PARAM_PERSISTENT_ADDRESS);
-iscsi_conn_str_attr(address, ISCSI_PARAM_CONN_ADDRESS);
+iscsi_conn_attr(max_recv_dlength, ISCSI_PARAM_MAX_RECV_DLENGTH);
+iscsi_conn_attr(max_xmit_dlength, ISCSI_PARAM_MAX_XMIT_DLENGTH);
+iscsi_conn_attr(header_digest, ISCSI_PARAM_HDRDGST_EN);
+iscsi_conn_attr(data_digest, ISCSI_PARAM_DATADGST_EN);
+iscsi_conn_attr(ifmarker, ISCSI_PARAM_IFMARKER_EN);
+iscsi_conn_attr(ofmarker, ISCSI_PARAM_OFMARKER_EN);
+iscsi_conn_attr(persistent_port, ISCSI_PARAM_PERSISTENT_PORT);
+iscsi_conn_attr(port, ISCSI_PARAM_CONN_PORT);
+iscsi_conn_attr(exp_statsn, ISCSI_PARAM_EXP_STATSN);
+iscsi_conn_attr(persistent_address, ISCSI_PARAM_PERSISTENT_ADDRESS);
+iscsi_conn_attr(address, ISCSI_PARAM_CONN_ADDRESS);
 
 #define iscsi_cdev_to_session(_cdev) \
 	iscsi_dev_to_session(_cdev->dev)
@@ -1215,61 +1156,36 @@ #define iscsi_cdev_to_session(_cdev) \
 /*
  * iSCSI session attrs
  */
-#define iscsi_session_int_attr_show(param, format)			\
-static ssize_t								\
-show_session_int_param_##param(struct class_device *cdev, char *buf)	\
-{									\
-	uint32_t value = 0;						\
-	struct iscsi_cls_session *session = iscsi_cdev_to_session(cdev);	\
-	struct iscsi_transport *t = session->transport;			\
-									\
-	t->get_session_param(session, param, &value);			\
-	return snprintf(buf, 20, format"\n", value);			\
-}
-
-#define iscsi_session_int_attr(field, param, format)			\
-	iscsi_session_int_attr_show(param, format)			\
-static ISCSI_CLASS_ATTR(sess, field, S_IRUGO, show_session_int_param_##param, \
-			NULL);
-
-iscsi_session_int_attr(initial_r2t, ISCSI_PARAM_INITIAL_R2T_EN, "%d");
-iscsi_session_int_attr(max_outstanding_r2t, ISCSI_PARAM_MAX_R2T, "%hu");
-iscsi_session_int_attr(immediate_data, ISCSI_PARAM_IMM_DATA_EN, "%d");
-iscsi_session_int_attr(first_burst_len, ISCSI_PARAM_FIRST_BURST, "%u");
-iscsi_session_int_attr(max_burst_len, ISCSI_PARAM_MAX_BURST, "%u");
-iscsi_session_int_attr(data_pdu_in_order, ISCSI_PARAM_PDU_INORDER_EN, "%d");
-iscsi_session_int_attr(data_seq_in_order, ISCSI_PARAM_DATASEQ_INORDER_EN, "%d");
-iscsi_session_int_attr(erl, ISCSI_PARAM_ERL, "%d");
-iscsi_session_int_attr(tpgt, ISCSI_PARAM_TPGT, "%d");
-
-#define iscsi_session_str_attr_show(param)				\
+#define iscsi_session_attr_show(param)					\
 static ssize_t								\
-show_session_str_param_##param(struct class_device *cdev, char *buf)	\
+show_session_param_##param(struct class_device *cdev, char *buf)	\
 {									\
 	struct iscsi_cls_session *session = iscsi_cdev_to_session(cdev); \
 	struct iscsi_transport *t = session->transport;			\
-	return t->get_session_str_param(session, param, buf);		\
+	return t->get_session_param(session, param, buf);		\
 }
 
-#define iscsi_session_str_attr(field, param)				\
-	iscsi_session_str_attr_show(param)				\
-static ISCSI_CLASS_ATTR(sess, field, S_IRUGO, show_session_str_param_##param, \
+#define iscsi_session_attr(field, param)				\
+	iscsi_session_attr_show(param)					\
+static ISCSI_CLASS_ATTR(sess, field, S_IRUGO, show_session_param_##param, \
 			NULL);
 
-iscsi_session_str_attr(targetname, ISCSI_PARAM_TARGET_NAME);
+iscsi_session_attr(targetname, ISCSI_PARAM_TARGET_NAME);
+iscsi_session_attr(initial_r2t, ISCSI_PARAM_INITIAL_R2T_EN);
+iscsi_session_attr(max_outstanding_r2t, ISCSI_PARAM_MAX_R2T);
+iscsi_session_attr(immediate_data, ISCSI_PARAM_IMM_DATA_EN);
+iscsi_session_attr(first_burst_len, ISCSI_PARAM_FIRST_BURST);
+iscsi_session_attr(max_burst_len, ISCSI_PARAM_MAX_BURST);
+iscsi_session_attr(data_pdu_in_order, ISCSI_PARAM_PDU_INORDER_EN);
+iscsi_session_attr(data_seq_in_order, ISCSI_PARAM_DATASEQ_INORDER_EN);
+iscsi_session_attr(erl, ISCSI_PARAM_ERL);
+iscsi_session_attr(tpgt, ISCSI_PARAM_TPGT);
 
-/*
- * Private session and conn attrs. userspace uses several iscsi values
- * to identify each session between reboots. Some of these values may not
- * be present in the iscsi_transport/LLD driver becuase userspace handles
- * login (and failback for login redirect) so for these type of drivers
- * the class manages the attrs and values for the iscsi_transport/LLD
- */
 #define iscsi_priv_session_attr_show(field, format)			\
 static ssize_t								\
-show_priv_session_##field(struct class_device *cdev, char *buf)	\
+show_priv_session_##field(struct class_device *cdev, char *buf)		\
 {									\
-	struct iscsi_cls_session *session = iscsi_cdev_to_session(cdev); \
+	struct iscsi_cls_session *session = iscsi_cdev_to_session(cdev);\
 	return sprintf(buf, format"\n", session->field);		\
 }
 
@@ -1277,31 +1193,15 @@ #define iscsi_priv_session_attr(field, f
 	iscsi_priv_session_attr_show(field, format)			\
 static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO, show_priv_session_##field, \
 			NULL)
-iscsi_priv_session_attr(targetname, "%s");
-iscsi_priv_session_attr(tpgt, "%d");
 iscsi_priv_session_attr(recovery_tmo, "%d");
 
-#define iscsi_priv_conn_attr_show(field, format)			\
-static ssize_t								\
-show_priv_conn_##field(struct class_device *cdev, char *buf)		\
-{									\
-	struct iscsi_cls_conn *conn = iscsi_cdev_to_conn(cdev);		\
-	return sprintf(buf, format"\n", conn->field);			\
-}
-
-#define iscsi_priv_conn_attr(field, format)				\
-	iscsi_priv_conn_attr_show(field, format)			\
-static ISCSI_CLASS_ATTR(priv_conn, field, S_IRUGO, show_priv_conn_##field, \
-			NULL)
-iscsi_priv_conn_attr(persistent_address, "%s");
-iscsi_priv_conn_attr(persistent_port, "%d");
-
 #define SETUP_PRIV_SESSION_RD_ATTR(field)				\
 do {									\
 	priv->session_attrs[count] = &class_device_attr_priv_sess_##field; \
 	count++;							\
 } while (0)
 
+
 #define SETUP_SESSION_RD_ATTR(field, param_flag)			\
 do {									\
 	if (tt->param_mask & param_flag) {				\
@@ -1310,12 +1210,6 @@ do {									\
 	}								\
 } while (0)
 
-#define SETUP_PRIV_CONN_RD_ATTR(field)					\
-do {									\
-	priv->conn_attrs[count] = &class_device_attr_priv_conn_##field; \
-	count++;							\
-} while (0)
-
 #define SETUP_CONN_RD_ATTR(field, param_flag)				\
 do {									\
 	if (tt->param_mask & param_flag) {				\
@@ -1442,16 +1336,8 @@ iscsi_register_transport(struct iscsi_tr
 	SETUP_CONN_RD_ATTR(address, ISCSI_CONN_ADDRESS);
 	SETUP_CONN_RD_ATTR(port, ISCSI_CONN_PORT);
 	SETUP_CONN_RD_ATTR(exp_statsn, ISCSI_EXP_STATSN);
-
-	if (tt->param_mask & ISCSI_PERSISTENT_ADDRESS)
-		SETUP_CONN_RD_ATTR(persistent_address, ISCSI_PERSISTENT_ADDRESS);
-	else
-		SETUP_PRIV_CONN_RD_ATTR(persistent_address);
-
-	if (tt->param_mask & ISCSI_PERSISTENT_PORT)
-		SETUP_CONN_RD_ATTR(persistent_port, ISCSI_PERSISTENT_PORT);
-	else
-		SETUP_PRIV_CONN_RD_ATTR(persistent_port);
+	SETUP_CONN_RD_ATTR(persistent_address, ISCSI_PERSISTENT_ADDRESS);
+	SETUP_CONN_RD_ATTR(persistent_port, ISCSI_PERSISTENT_PORT);
 
 	BUG_ON(count > ISCSI_CONN_ATTRS);
 	priv->conn_attrs[count] = NULL;
@@ -1471,18 +1357,10 @@ iscsi_register_transport(struct iscsi_tr
 	SETUP_SESSION_RD_ATTR(data_pdu_in_order, ISCSI_PDU_INORDER_EN);
 	SETUP_SESSION_RD_ATTR(data_seq_in_order, ISCSI_DATASEQ_INORDER_EN);
 	SETUP_SESSION_RD_ATTR(erl, ISCSI_ERL);
+	SETUP_SESSION_RD_ATTR(targetname, ISCSI_TARGET_NAME);
+	SETUP_SESSION_RD_ATTR(tpgt, ISCSI_TPGT);
 	SETUP_PRIV_SESSION_RD_ATTR(recovery_tmo);
 
-	if (tt->param_mask & ISCSI_TARGET_NAME)
-		SETUP_SESSION_RD_ATTR(targetname, ISCSI_TARGET_NAME);
-	else
-		SETUP_PRIV_SESSION_RD_ATTR(targetname);
-
-	if (tt->param_mask & ISCSI_TPGT)
-		SETUP_SESSION_RD_ATTR(tpgt, ISCSI_TPGT);
-	else
-		SETUP_PRIV_SESSION_RD_ATTR(tpgt);
-
 	BUG_ON(count > ISCSI_SESSION_ATTRS);
 	priv->session_attrs[count] = NULL;
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index cbf7e58..ba27608 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -157,6 +157,11 @@ struct iscsi_conn {
 	int			max_xmit_dlength; /* target_max_recv_dsl */
 	int			hdrdgst_en;
 	int			datadgst_en;
+	int			ifmarker_en;
+	int			ofmarker_en;
+	/* values userspace uses to id a conn */
+	int			persistent_port;
+	char			*persistent_address;
 
 	/* MIB-statistics */
 	uint64_t		txdata_octets;
@@ -196,8 +201,8 @@ struct iscsi_session {
 	int			pdu_inorder_en;
 	int			dataseq_inorder_en;
 	int			erl;
-	int			ifmarker_en;
-	int			ofmarker_en;
+	int			tpgt;
+	char			*targetname;
 
 	/* control data */
 	struct iscsi_transport	*tt;
@@ -240,6 +245,10 @@ iscsi_session_setup(struct iscsi_transpo
 extern void iscsi_session_teardown(struct iscsi_cls_session *);
 extern struct iscsi_session *class_to_transport_session(struct iscsi_cls_session *);
 extern void iscsi_session_recovery_timedout(struct iscsi_cls_session *);
+extern int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
+			   enum iscsi_param param, char *buf, int buflen);
+extern int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
+				   enum iscsi_param param, char *buf);
 
 #define session_to_cls(_sess) \
 	hostdata_session(_sess->host->hostdata)
@@ -255,6 +264,8 @@ extern void iscsi_conn_stop(struct iscsi
 extern int iscsi_conn_bind(struct iscsi_cls_session *, struct iscsi_cls_conn *,
 			   int);
 extern void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err);
+extern int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
+				enum iscsi_param param, char *buf);
 
 /*
  * pdu and task processing
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index b95151a..0539705 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -34,6 +34,7 @@ struct iscsi_cls_conn;
 struct iscsi_conn;
 struct iscsi_cmd_task;
 struct iscsi_mgmt_task;
+struct sockaddr;
 
 /**
  * struct iscsi_transport - iSCSI Transport template
@@ -46,7 +47,12 @@ struct iscsi_mgmt_task;
  * @bind_conn:		associate this connection with existing iSCSI session
  *			and specified transport descriptor
  * @destroy_conn:	destroy inactive iSCSI connection
- * @set_param:		set iSCSI Data-Path operational parameter
+ * @set_param:		set iSCSI parameter. Return 0 on success, -ENODATA
+ *			when param is not supported, and a -Exx value on other
+ *			error.
+ * @get_param		get iSCSI parameter. Must return number of bytes
+ *			copied to buffer on success, -ENODATA when param
+ *			is not supported, and a -Exx value on other error
  * @start_conn:		set connection to be operational
  * @stop_conn:		suspend/recover/terminate connection
  * @send_pdu:		send iSCSI PDU, Login, Logout, NOP-Out, Reject, Text.
@@ -97,15 +103,11 @@ struct iscsi_transport {
 	void (*stop_conn) (struct iscsi_cls_conn *conn, int flag);
 	void (*destroy_conn) (struct iscsi_cls_conn *conn);
 	int (*set_param) (struct iscsi_cls_conn *conn, enum iscsi_param param,
-			  uint32_t value);
+			  char *buf, int buflen);
 	int (*get_conn_param) (struct iscsi_cls_conn *conn,
-			       enum iscsi_param param, uint32_t *value);
+			       enum iscsi_param param, char *buf);
 	int (*get_session_param) (struct iscsi_cls_session *session,
-				  enum iscsi_param param, uint32_t *value);
-	int (*get_conn_str_param) (struct iscsi_cls_conn *conn,
-				   enum iscsi_param param, char *buf);
-	int (*get_session_str_param) (struct iscsi_cls_session *session,
-				      enum iscsi_param param, char *buf);
+				  enum iscsi_param param, char *buf);
 	int (*send_pdu) (struct iscsi_cls_conn *conn, struct iscsi_hdr *hdr,
 			 char *data, uint32_t data_size);
 	void (*get_stats) (struct iscsi_cls_conn *conn,
@@ -157,13 +159,6 @@ struct iscsi_cls_conn {
 	struct iscsi_transport *transport;
 	uint32_t cid;			/* connection id */
 
-	/* portal/group values we got during discovery */
-	char *persistent_address;
-	int persistent_port;
-	/* portal/group values we are currently using */
-	char *address;
-	int port;
-
 	int active;			/* must be accessed with the connlock */
 	struct device dev;		/* sysfs transport/container device */
 	struct mempool_zone *z_error;
@@ -187,10 +182,6 @@ struct iscsi_cls_session {
 	struct list_head host_list;
 	struct iscsi_transport *transport;
 
-	/* iSCSI values used as unique id by userspace. */
-	char *targetname;
-	int tpgt;
-
 	/* recovery fields */
 	int recovery_tmo;
 	struct work_struct recovery_work;


