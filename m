From: Mike Christie <michaelc@cs.wisc.edu>
Subject: [PATCH 2/5] iscsi: add sysfs attrs for uspace sync up
Date: Thu, 06 Apr 2006 21:13:36 -0500
Message-ID: <1144376016.11062.20.camel@max>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:55470 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S932287AbWDGCOw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2006 22:14:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com

For iscsi boot when going from initramfs to the real root we
need to stop the userpsace iscsi daemon. To later restart it
iscsid needs to be able to rebuild itself and part of that
process is matching a session running the kernel with the
iscsid representation. To do this the attached patch
adds several required iscsi values. If the LLD does not provide
them becuase, login is done in userspace, then the transport
class and userspace set ths up for the LLD.


Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>


diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 6ecb4ba..32b499c 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -3536,7 +3536,7 @@ iscsi_session_get_param(struct iscsi_cls
 		*value = session->ofmarker_en;
 		break;
 	default:
-		return ISCSI_ERR_PARAM_NOT_FOUND;
+		return -EINVAL;
 	}
 
 	return 0;
@@ -3547,6 +3547,7 @@ iscsi_conn_get_param(struct iscsi_cls_co
 		     enum iscsi_param param, uint32_t *value)
 {
 	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct inet_sock *inet;
 
 	switch(param) {
 	case ISCSI_PARAM_MAX_RECV_DLENGTH:
@@ -3561,13 +3562,61 @@ iscsi_conn_get_param(struct iscsi_cls_co
 	case ISCSI_PARAM_DATADGST_EN:
 		*value = conn->datadgst_en;
 		break;
+	case ISCSI_PARAM_CONN_PORT:
+		mutex_lock(&conn->xmitmutex);
+		if (!conn->sock) {
+			mutex_unlock(&conn->xmitmutex);
+			return -EINVAL;
+		}
+
+		inet = inet_sk(conn->sock->sk);
+		*value = be16_to_cpu(inet->dport); 
+		mutex_unlock(&conn->xmitmutex);
 	default:
-		return ISCSI_ERR_PARAM_NOT_FOUND;
+		return -EINVAL;
 	}
 
 	return 0;
 }
 
+static int
+iscsi_conn_get_str_param(struct iscsi_cls_conn *cls_conn,
+			 enum iscsi_param param, char *buf)
+{
+	struct iscsi_conn *conn = cls_conn->dd_data;
+	struct sock *sk;
+	struct inet_sock *inet;
+	struct ipv6_pinfo *np;
+	int len = 0;
+
+	switch (param) {
+	case ISCSI_PARAM_CONN_ADDRESS:
+		mutex_lock(&conn->xmitmutex);
+		if (!conn->sock) {
+			mutex_unlock(&conn->xmitmutex);
+			return -EINVAL;
+		}
+
+		sk = conn->sock->sk;
+		if (sk->sk_family == PF_INET) {
+			inet = inet_sk(sk);
+			len = sprintf(buf, "%u.%u.%u.%u\n",
+				      NIPQUAD(inet->daddr));
+		} else {
+			np = inet6_sk(sk);
+			len = sprintf(buf,
+				"%04x:%04x:%04x:%04x:%04x:%04x:%04x:%04x\n",
+				NIP6(np->daddr));
+		}
+		mutex_unlock(&conn->xmitmutex);
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return len;
+}
+
 static void
 iscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *stats)
 {
@@ -3610,6 +3659,20 @@ static struct iscsi_transport iscsi_tcp_
 	.name			= "tcp",
 	.caps			= CAP_RECOVERY_L0 | CAP_MULTI_R2T | CAP_HDRDGST
 				  | CAP_DATADGST,
+	.param_mask		= ISCSI_MAX_RECV_DLENGTH |
+				  ISCSI_MAX_XMIT_DLENGTH |
+				  ISCSI_HDRDGST_EN |
+				  ISCSI_DATADGST_EN |
+				  ISCSI_INITIAL_R2T_EN |
+				  ISCSI_MAX_R2T |
+				  ISCSI_IMM_DATA_EN |
+				  ISCSI_FIRST_BURST |
+				  ISCSI_MAX_BURST |
+				  ISCSI_PDU_INORDER_EN |
+				  ISCSI_DATASEQ_INORDER_EN |
+				  ISCSI_ERL |
+				  ISCSI_CONN_PORT |
+				  ISCSI_CONN_ADDRESS,
 	.host_template		= &iscsi_sht,
 	.hostdata_size		= sizeof(struct iscsi_session),
 	.conndata_size		= sizeof(struct iscsi_conn),
@@ -3622,6 +3685,7 @@ static struct iscsi_transport iscsi_tcp_
 	.destroy_conn		= iscsi_conn_destroy,
 	.set_param		= iscsi_conn_set_param,
 	.get_conn_param		= iscsi_conn_get_param,
+	.get_conn_str_param	= iscsi_conn_get_str_param,
 	.get_session_param	= iscsi_session_get_param,
 	.start_conn		= iscsi_conn_start,
 	.stop_conn		= iscsi_conn_stop,
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 10ff0f0..811bc8a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -31,21 +31,13 @@
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/iscsi_if.h>
 
-#define ISCSI_SESSION_ATTRS 8
-#define ISCSI_CONN_ATTRS 6
+#define ISCSI_SESSION_ATTRS 10
+#define ISCSI_CONN_ATTRS 10
 
 struct iscsi_internal {
 	struct scsi_transport_template t;
 	struct iscsi_transport *iscsi_transport;
 	struct list_head list;
-	/*
-	 * based on transport capabilities, at register time we set these
-	 * bits to tell the transport class it wants attributes displayed
-	 * in sysfs or that it can support different iSCSI Data-Path
-	 * capabilities
-	 */
-	uint32_t param_mask;
-
 	struct class_device cdev;
 	/*
 	 * We do not have any private or other attrs.
@@ -223,6 +215,7 @@ static void iscsi_session_release(struct
 
 	shost = iscsi_session_to_shost(session);
 	scsi_host_put(shost);
+	kfree(session->targetname);
 	kfree(session);
 	module_put(transport->owner);
 }
@@ -304,6 +297,7 @@ static void iscsi_conn_release(struct de
 	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev);
 	struct device *parent = conn->dev.parent;
 
+	kfree(conn->persistent_address);
 	kfree(conn);
 	put_device(parent);
 }
@@ -870,6 +864,67 @@ iscsi_if_destroy_conn(struct iscsi_trans
 	return 0;
 }
 
+static void
+iscsi_copy_param(struct iscsi_uevent *ev, uint32_t *value, char *data)
+{
+	if (ev->u.set_param.len != sizeof(uint32_t))
+		BUG();
+	memcpy(value, data, min_t(uint32_t, sizeof(uint32_t),
+		ev->u.set_param.len));
+}
+
+static int
+iscsi_set_param(struct iscsi_transport *transport, struct iscsi_uevent *ev)
+{
+	char *data = (char*)ev + sizeof(*ev);
+	struct iscsi_cls_conn *conn;
+	struct iscsi_cls_session *session;
+	int err = 0;
+	uint32_t value = 0;
+
+	session = iscsi_session_lookup(ev->u.set_param.sid);
+	conn = iscsi_conn_lookup(ev->u.set_param.sid, ev->u.set_param.cid);
+	if (!conn || !session)
+		return -EINVAL;
+
+	switch (ev->u.set_param.param) {
+	case ISCSI_PARAM_TARGET_NAME:
+		/* this should not change between logins */
+		if (session->targetname)
+			return 0;
+
+		session->targetname = kstrdup(data, GFP_KERNEL);
+		if (!session->targetname)
+			return -ENOMEM;
+		break;
+	case ISCSI_PARAM_TPGT:
+		iscsi_copy_param(ev, &value, data);
+		session->tpgt = value;
+		break;
+	case ISCSI_PARAM_PERSISTENT_PORT:
+		iscsi_copy_param(ev, &value, data);
+		conn->persistent_port = value;
+		break;
+	case ISCSI_PARAM_PERSISTENT_ADDRESS:
+		/*
+		 * this is the address returned in discovery so it should
+		 * not change between logins.
+		 */
+		if (conn->persistent_address)
+			return 0;
+
+		conn->persistent_address = kstrdup(data, GFP_KERNEL);
+		if (!conn->persistent_address)
+			return -ENOMEM;
+		break;
+	default:
+		iscsi_copy_param(ev, &value, data);
+		err = transport->set_param(conn, ev->u.set_param.param, value);
+	}
+
+	return err;
+}
+
 static int
 iscsi_if_recv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 {
@@ -917,12 +972,7 @@ iscsi_if_recv_msg(struct sk_buff *skb, s
 			err = -EINVAL;
 		break;
 	case ISCSI_UEVENT_SET_PARAM:
-		conn = iscsi_conn_lookup(ev->u.set_param.sid, ev->u.set_param.cid);
-		if (conn)
-			ev->r.retcode =	transport->set_param(conn,
-				ev->u.set_param.param, ev->u.set_param.value);
-		else
-			err = -EINVAL;
+		err = iscsi_set_param(transport, ev);
 		break;
 	case ISCSI_UEVENT_START_CONN:
 		conn = iscsi_conn_lookup(ev->u.start_conn.sid, ev->u.start_conn.cid);
@@ -1028,6 +1078,10 @@ free_skb:
 #define iscsi_cdev_to_conn(_cdev) \
 	iscsi_dev_to_conn(_cdev->dev)
 
+#define ISCSI_CLASS_ATTR(_prefix,_name,_mode,_show,_store)		\
+struct class_device_attribute class_device_attr_##_prefix##_##_name =	\
+	__ATTR(_name,_mode,_show,_store)
+
 /*
  * iSCSI connection attrs
  */
@@ -1045,7 +1099,8 @@ show_conn_int_param_##param(struct class
 
 #define iscsi_conn_int_attr(field, param, format)			\
 	iscsi_conn_int_attr_show(param, format)				\
-static CLASS_DEVICE_ATTR(field, S_IRUGO, show_conn_int_param_##param, NULL);
+static ISCSI_CLASS_ATTR(conn, field, S_IRUGO, show_conn_int_param_##param, \
+			NULL);
 
 iscsi_conn_int_attr(max_recv_dlength, ISCSI_PARAM_MAX_RECV_DLENGTH, "%u");
 iscsi_conn_int_attr(max_xmit_dlength, ISCSI_PARAM_MAX_XMIT_DLENGTH, "%u");
@@ -1053,6 +1108,25 @@ iscsi_conn_int_attr(header_digest, ISCSI
 iscsi_conn_int_attr(data_digest, ISCSI_PARAM_DATADGST_EN, "%d");
 iscsi_conn_int_attr(ifmarker, ISCSI_PARAM_IFMARKER_EN, "%d");
 iscsi_conn_int_attr(ofmarker, ISCSI_PARAM_OFMARKER_EN, "%d");
+iscsi_conn_int_attr(persistent_port, ISCSI_PARAM_PERSISTENT_PORT, "%d");
+iscsi_conn_int_attr(port, ISCSI_PARAM_CONN_PORT, "%d");
+
+#define iscsi_conn_str_attr_show(param)					\
+static ssize_t								\
+show_conn_str_param_##param(struct class_device *cdev, char *buf)	\
+{									\
+	struct iscsi_cls_conn *conn = iscsi_cdev_to_conn(cdev);		\
+	struct iscsi_transport *t = conn->transport;			\
+	return t->get_conn_str_param(conn, param, buf);			\
+}
+
+#define iscsi_conn_str_attr(field, param)				\
+	iscsi_conn_str_attr_show(param)					\
+static ISCSI_CLASS_ATTR(conn, field, S_IRUGO, show_conn_str_param_##param, \
+			NULL);
+
+iscsi_conn_str_attr(persistent_address, ISCSI_PARAM_PERSISTENT_ADDRESS);
+iscsi_conn_str_attr(address, ISCSI_PARAM_CONN_ADDRESS);
 
 #define iscsi_cdev_to_session(_cdev) \
 	iscsi_dev_to_session(_cdev->dev)
@@ -1074,7 +1148,8 @@ show_session_int_param_##param(struct cl
 
 #define iscsi_session_int_attr(field, param, format)			\
 	iscsi_session_int_attr_show(param, format)			\
-static CLASS_DEVICE_ATTR(field, S_IRUGO, show_session_int_param_##param, NULL);
+static ISCSI_CLASS_ATTR(sess, field, S_IRUGO, show_session_int_param_##param, \
+			NULL);
 
 iscsi_session_int_attr(initial_r2t, ISCSI_PARAM_INITIAL_R2T_EN, "%d");
 iscsi_session_int_attr(max_outstanding_r2t, ISCSI_PARAM_MAX_R2T, "%hu");
@@ -1084,18 +1159,88 @@ iscsi_session_int_attr(max_burst_len, IS
 iscsi_session_int_attr(data_pdu_in_order, ISCSI_PARAM_PDU_INORDER_EN, "%d");
 iscsi_session_int_attr(data_seq_in_order, ISCSI_PARAM_DATASEQ_INORDER_EN, "%d");
 iscsi_session_int_attr(erl, ISCSI_PARAM_ERL, "%d");
+iscsi_session_int_attr(tpgt, ISCSI_PARAM_TPGT, "%d");
+
+#define iscsi_session_str_attr_show(param)				\
+static ssize_t								\
+show_session_str_param_##param(struct class_device *cdev, char *buf)	\
+{									\
+	struct iscsi_cls_session *session = iscsi_cdev_to_session(cdev); \
+	struct iscsi_transport *t = session->transport;			\
+	return t->get_session_str_param(session, param, buf);		\
+}
+
+#define iscsi_session_str_attr(field, param)				\
+	iscsi_session_str_attr_show(param)				\
+static ISCSI_CLASS_ATTR(sess, field, S_IRUGO, show_session_str_param_##param, \
+			NULL);
+
+iscsi_session_str_attr(targetname, ISCSI_PARAM_TARGET_NAME);
 
-#define SETUP_SESSION_RD_ATTR(field, param)				\
-	if (priv->param_mask & (1 << param)) {				\
-		priv->session_attrs[count] = &class_device_attr_##field;\
+/*
+ * Private session and conn attrs. userspace uses several iscsi values
+ * to identify each session between reboots. Some of these values may not
+ * be present in the iscsi_transport/LLD driver becuase userspace handles
+ * login (and failback for login redirect) so for these type of drivers
+ * the class manages the attrs and values for the iscsi_transport/LLD
+ */ 
+#define iscsi_priv_session_attr_show(field, format)			\
+static ssize_t								\
+show_priv_session_##field(struct class_device *cdev, char *buf)	\
+{									\
+	struct iscsi_cls_session *session = iscsi_cdev_to_session(cdev); \
+	return sprintf(buf, format"\n", session->field);		\
+}
+
+#define iscsi_priv_session_attr(field, format)				\
+	iscsi_priv_session_attr_show(field, format)			\
+static ISCSI_CLASS_ATTR(priv_sess, field, S_IRUGO, show_priv_session_##field, \
+			NULL)
+iscsi_priv_session_attr(targetname, "%s");
+iscsi_priv_session_attr(tpgt, "%d");
+
+#define iscsi_priv_conn_attr_show(field, format)			\
+static ssize_t								\
+show_priv_conn_##field(struct class_device *cdev, char *buf)		\
+{									\
+	struct iscsi_cls_conn *conn = iscsi_cdev_to_conn(cdev);		\
+	return sprintf(buf, format"\n", conn->field);			\
+}
+
+#define iscsi_priv_conn_attr(field, format)				\
+	iscsi_priv_conn_attr_show(field, format)			\
+static ISCSI_CLASS_ATTR(priv_conn, field, S_IRUGO, show_priv_conn_##field, \
+			NULL)
+iscsi_priv_conn_attr(persistent_address, "%s");
+iscsi_priv_conn_attr(persistent_port, "%d");
+
+#define SETUP_PRIV_SESSION_RD_ATTR(field)				\
+do {									\
+	priv->session_attrs[count] = &class_device_attr_priv_sess_##field; \
+	count++;							\
+} while (0)
+
+#define SETUP_SESSION_RD_ATTR(field, param_flag)			\
+do {									\
+	if (tt->param_mask & param_flag) {				\
+		priv->session_attrs[count] = &class_device_attr_sess_##field; \
 		count++;						\
-	}
+	}								\
+} while (0)
 
-#define SETUP_CONN_RD_ATTR(field, param)				\
-	if (priv->param_mask & (1 << param)) {				\
-		priv->conn_attrs[count] = &class_device_attr_##field;	\
+#define SETUP_PRIV_CONN_RD_ATTR(field)					\
+do {									\
+	priv->conn_attrs[count] = &class_device_attr_priv_conn_##field; \
+	count++;							\
+} while (0)
+
+#define SETUP_CONN_RD_ATTR(field, param_flag)				\
+do {									\
+	if (tt->param_mask & param_flag) {				\
+		priv->conn_attrs[count] = &class_device_attr_conn_##field; \
 		count++;						\
-	}
+	}								\
+} while (0)
 
 static int iscsi_session_match(struct attribute_container *cont,
 			   struct device *dev)
@@ -1173,31 +1318,30 @@ iscsi_register_transport(struct iscsi_tr
 	if (err)
 		goto unregister_cdev;
 
-	/* setup parameters mask */
-	priv->param_mask = 0xFFFFFFFF;
-	if (!(tt->caps & CAP_MULTI_R2T))
-		priv->param_mask &= ~(1 << ISCSI_PARAM_MAX_R2T);
-	if (!(tt->caps & CAP_HDRDGST))
-		priv->param_mask &= ~(1 << ISCSI_PARAM_HDRDGST_EN);
-	if (!(tt->caps & CAP_DATADGST))
-		priv->param_mask &= ~(1 << ISCSI_PARAM_DATADGST_EN);
-	if (!(tt->caps & CAP_MARKERS)) {
-		priv->param_mask &= ~(1 << ISCSI_PARAM_IFMARKER_EN);
-		priv->param_mask &= ~(1 << ISCSI_PARAM_OFMARKER_EN);
-	}
-
 	/* connection parameters */
 	priv->conn_cont.ac.attrs = &priv->conn_attrs[0];
 	priv->conn_cont.ac.class = &iscsi_connection_class.class;
 	priv->conn_cont.ac.match = iscsi_conn_match;
 	transport_container_register(&priv->conn_cont);
 
-	SETUP_CONN_RD_ATTR(max_recv_dlength, ISCSI_PARAM_MAX_RECV_DLENGTH);
-	SETUP_CONN_RD_ATTR(max_xmit_dlength, ISCSI_PARAM_MAX_XMIT_DLENGTH);
-	SETUP_CONN_RD_ATTR(header_digest, ISCSI_PARAM_HDRDGST_EN);
-	SETUP_CONN_RD_ATTR(data_digest, ISCSI_PARAM_DATADGST_EN);
-	SETUP_CONN_RD_ATTR(ifmarker, ISCSI_PARAM_IFMARKER_EN);
-	SETUP_CONN_RD_ATTR(ofmarker, ISCSI_PARAM_OFMARKER_EN);
+	SETUP_CONN_RD_ATTR(max_recv_dlength, ISCSI_MAX_RECV_DLENGTH);
+	SETUP_CONN_RD_ATTR(max_xmit_dlength, ISCSI_MAX_XMIT_DLENGTH);
+	SETUP_CONN_RD_ATTR(header_digest, ISCSI_HDRDGST_EN);
+	SETUP_CONN_RD_ATTR(data_digest, ISCSI_DATADGST_EN);
+	SETUP_CONN_RD_ATTR(ifmarker, ISCSI_IFMARKER_EN);
+	SETUP_CONN_RD_ATTR(ofmarker, ISCSI_OFMARKER_EN);
+	SETUP_CONN_RD_ATTR(address, ISCSI_CONN_ADDRESS);
+	SETUP_CONN_RD_ATTR(port, ISCSI_CONN_PORT);
+
+	if (tt->param_mask & ISCSI_PERSISTENT_ADDRESS)
+		SETUP_CONN_RD_ATTR(persistent_address, ISCSI_PERSISTENT_ADDRESS);
+	else
+		SETUP_PRIV_CONN_RD_ATTR(persistent_address);
+
+	if (tt->param_mask & ISCSI_PERSISTENT_PORT)
+		SETUP_CONN_RD_ATTR(persistent_port, ISCSI_PERSISTENT_PORT);
+	else
+		SETUP_PRIV_CONN_RD_ATTR(persistent_port);
 
 	BUG_ON(count > ISCSI_CONN_ATTRS);
 	priv->conn_attrs[count] = NULL;
@@ -1209,14 +1353,24 @@ iscsi_register_transport(struct iscsi_tr
 	priv->session_cont.ac.match = iscsi_session_match;
 	transport_container_register(&priv->session_cont);
 
-	SETUP_SESSION_RD_ATTR(initial_r2t, ISCSI_PARAM_INITIAL_R2T_EN);
-	SETUP_SESSION_RD_ATTR(max_outstanding_r2t, ISCSI_PARAM_MAX_R2T);
-	SETUP_SESSION_RD_ATTR(immediate_data, ISCSI_PARAM_IMM_DATA_EN);
-	SETUP_SESSION_RD_ATTR(first_burst_len, ISCSI_PARAM_FIRST_BURST);
-	SETUP_SESSION_RD_ATTR(max_burst_len, ISCSI_PARAM_MAX_BURST);
-	SETUP_SESSION_RD_ATTR(data_pdu_in_order, ISCSI_PARAM_PDU_INORDER_EN);
-	SETUP_SESSION_RD_ATTR(data_seq_in_order,ISCSI_PARAM_DATASEQ_INORDER_EN)
-	SETUP_SESSION_RD_ATTR(erl, ISCSI_PARAM_ERL);
+	SETUP_SESSION_RD_ATTR(initial_r2t, ISCSI_INITIAL_R2T_EN);
+	SETUP_SESSION_RD_ATTR(max_outstanding_r2t, ISCSI_MAX_R2T);
+	SETUP_SESSION_RD_ATTR(immediate_data, ISCSI_IMM_DATA_EN);
+	SETUP_SESSION_RD_ATTR(first_burst_len, ISCSI_FIRST_BURST);
+	SETUP_SESSION_RD_ATTR(max_burst_len, ISCSI_MAX_BURST);
+	SETUP_SESSION_RD_ATTR(data_pdu_in_order, ISCSI_PDU_INORDER_EN);
+	SETUP_SESSION_RD_ATTR(data_seq_in_order, ISCSI_DATASEQ_INORDER_EN);
+	SETUP_SESSION_RD_ATTR(erl, ISCSI_ERL);
+
+	if (tt->param_mask & ISCSI_TARGET_NAME)
+		SETUP_SESSION_RD_ATTR(targetname, ISCSI_TARGET_NAME);
+	else
+		SETUP_PRIV_SESSION_RD_ATTR(targetname);
+
+	if (tt->param_mask & ISCSI_TPGT)
+		SETUP_SESSION_RD_ATTR(tpgt, ISCSI_TPGT);
+	else
+		SETUP_PRIV_SESSION_RD_ATTR(tpgt);
 
 	BUG_ON(count > ISCSI_SESSION_ATTRS);
 	priv->session_attrs[count] = NULL;
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 01ad50f..774ad54 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -86,7 +86,7 @@ struct iscsi_uevent {
 			uint32_t	sid;
 			uint32_t	cid;
 			uint32_t	param; /* enum iscsi_param */
-			uint32_t	value;
+			uint32_t	len;
 		} set_param;
 		struct msg_start_conn {
 			uint32_t	sid;
@@ -155,22 +155,54 @@ enum iscsi_err {
  * iSCSI Parameters (RFC3720)
  */
 enum iscsi_param {
-	ISCSI_PARAM_MAX_RECV_DLENGTH	= 0,
-	ISCSI_PARAM_MAX_XMIT_DLENGTH	= 1,
-	ISCSI_PARAM_HDRDGST_EN		= 2,
-	ISCSI_PARAM_DATADGST_EN		= 3,
-	ISCSI_PARAM_INITIAL_R2T_EN	= 4,
-	ISCSI_PARAM_MAX_R2T		= 5,
-	ISCSI_PARAM_IMM_DATA_EN		= 6,
-	ISCSI_PARAM_FIRST_BURST		= 7,
-	ISCSI_PARAM_MAX_BURST		= 8,
-	ISCSI_PARAM_PDU_INORDER_EN	= 9,
-	ISCSI_PARAM_DATASEQ_INORDER_EN	= 10,
-	ISCSI_PARAM_ERL			= 11,
-	ISCSI_PARAM_IFMARKER_EN		= 12,
-	ISCSI_PARAM_OFMARKER_EN		= 13,
+	/* passed in using netlink set param */
+	ISCSI_PARAM_MAX_RECV_DLENGTH,
+	ISCSI_PARAM_MAX_XMIT_DLENGTH,
+	ISCSI_PARAM_HDRDGST_EN,
+	ISCSI_PARAM_DATADGST_EN,
+	ISCSI_PARAM_INITIAL_R2T_EN,
+	ISCSI_PARAM_MAX_R2T,
+	ISCSI_PARAM_IMM_DATA_EN,
+	ISCSI_PARAM_FIRST_BURST,
+	ISCSI_PARAM_MAX_BURST,
+	ISCSI_PARAM_PDU_INORDER_EN,
+	ISCSI_PARAM_DATASEQ_INORDER_EN,
+	ISCSI_PARAM_ERL,
+	ISCSI_PARAM_IFMARKER_EN,
+	ISCSI_PARAM_OFMARKER_EN,
+	ISCSI_PARAM_TARGET_NAME,
+	ISCSI_PARAM_TPGT,
+	ISCSI_PARAM_PERSISTENT_ADDRESS,
+	ISCSI_PARAM_PERSISTENT_PORT,
+
+	/* pased in through bind conn using transport_fd */
+	ISCSI_PARAM_CONN_PORT,
+	ISCSI_PARAM_CONN_ADDRESS,
+
+	/* must always be last */
+	ISCSI_PARAM_MAX,
 };
-#define ISCSI_PARAM_MAX			14
+
+#define ISCSI_MAX_RECV_DLENGTH		(1 << ISCSI_PARAM_MAX_RECV_DLENGTH)
+#define ISCSI_MAX_XMIT_DLENGTH		(1 << ISCSI_PARAM_MAX_XMIT_DLENGTH)
+#define ISCSI_HDRDGST_EN		(1 << ISCSI_PARAM_HDRDGST_EN)
+#define ISCSI_DATADGST_EN		(1 << ISCSI_PARAM_DATADGST_EN)
+#define ISCSI_INITIAL_R2T_EN		(1 << ISCSI_PARAM_INITIAL_R2T_EN)
+#define ISCSI_MAX_R2T			(1 << ISCSI_PARAM_MAX_R2T)
+#define ISCSI_IMM_DATA_EN		(1 << ISCSI_PARAM_IMM_DATA_EN)
+#define ISCSI_FIRST_BURST		(1 << ISCSI_PARAM_FIRST_BURST)
+#define ISCSI_MAX_BURST			(1 << ISCSI_PARAM_MAX_BURST)
+#define ISCSI_PDU_INORDER_EN		(1 << ISCSI_PARAM_PDU_INORDER_EN)
+#define ISCSI_DATASEQ_INORDER_EN	(1 << ISCSI_PARAM_DATASEQ_INORDER_EN)
+#define ISCSI_ERL			(1 << ISCSI_PARAM_ERL)
+#define ISCSI_IFMARKER_EN		(1 << ISCSI_PARAM_IFMARKER_EN)
+#define ISCSI_OFMARKER_EN		(1 << ISCSI_PARAM_OFMARKER_EN)
+#define ISCSI_TARGET_NAME		(1 << ISCSI_PARAM_TARGET_NAME)
+#define ISCSI_TPGT			(1 << ISCSI_PARAM_TPGT)
+#define ISCSI_PERSISTENT_ADDRESS	(1 << ISCSI_PARAM_PERSISTENT_ADDRESS)
+#define ISCSI_PERSISTENT_PORT		(1 << ISCSI_PARAM_PERSISTENT_PORT)
+#define ISCSI_CONN_PORT			(1 << ISCSI_PARAM_CONN_PORT)
+#define ISCSI_CONN_ADDRESS		(1 << ISCSI_PARAM_CONN_ADDRESS)
 
 #define iscsi_ptr(_handle) ((void*)(unsigned long)_handle)
 #define iscsi_handle(_ptr) ((uint64_t)(unsigned long)_ptr)
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 631463c..4b20064 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -53,11 +53,11 @@ struct iscsi_transport {
 	struct module *owner;
 	char *name;
 	unsigned int caps;
+	/* LLD sets this to indicate what values it can export to sysfs */
+	unsigned int param_mask;
 	struct scsi_host_template *host_template;
 	/* LLD session/scsi_host data size */
 	int hostdata_size;
-	/* LLD iscsi_host data size */
-	int ihostdata_size;
 	/* LLD connection data size */
 	int conndata_size;
 	/* LLD session data size */
@@ -79,10 +79,13 @@ struct iscsi_transport {
 	int (*set_param) (struct iscsi_cls_conn *conn, enum iscsi_param param,
 			  uint32_t value);
 	int (*get_conn_param) (struct iscsi_cls_conn *conn,
-			       enum iscsi_param param,
-			       uint32_t *value);
+			       enum iscsi_param param, uint32_t *value);
 	int (*get_session_param) (struct iscsi_cls_session *session,
 				  enum iscsi_param param, uint32_t *value);
+	int (*get_conn_str_param) (struct iscsi_cls_conn *conn,
+				   enum iscsi_param param, char *buf);
+	int (*get_session_str_param) (struct iscsi_cls_session *session,
+				      enum iscsi_param param, char *buf);
 	int (*send_pdu) (struct iscsi_cls_conn *conn, struct iscsi_hdr *hdr,
 			 char *data, uint32_t data_size);
 	void (*get_stats) (struct iscsi_cls_conn *conn,
@@ -107,6 +110,14 @@ struct iscsi_cls_conn {
 	void *dd_data;			/* LLD private data */
 	struct iscsi_transport *transport;
 	uint32_t cid;			/* connection id */
+
+	/* portal/group values we got during discovery */
+	char *persistent_address;
+	int persistent_port;
+	/* portal/group values we are currently using */
+	char *address;
+	int port;
+
 	int active;			/* must be accessed with the connlock */
 	struct device dev;		/* sysfs transport/container device */
 	struct mempool_zone *z_error;
@@ -120,6 +131,11 @@ struct iscsi_cls_conn {
 struct iscsi_cls_session {
 	struct list_head sess_list;		/* item in session_list */
 	struct iscsi_transport *transport;
+
+	/* iSCSI values used as unique id by userspace. */
+	char *targetname;
+	int tpgt;
+
 	int sid;				/* session id */
 	void *dd_data;				/* LLD private data */
 	struct device dev;	/* sysfs transport/container device */


