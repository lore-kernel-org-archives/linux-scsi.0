From: michaelc@cs.wisc.edu
Subject: [PATCH 2/19] iscsi class: export hw address
Date: Wed, 30 May 2007 12:57:08 -0500
Message-ID: <11805478472375-git-send-email-michaelc@cs.wisc.edu>
References: <11805478452886-git-send-email-michaelc@cs.wisc.edu> <11805478461587-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51604 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753714AbXE3R5o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2007 13:57:44 -0400
In-Reply-To: <11805478461587-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Add hw address sysfs file.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/scsi_transport_iscsi.c |   35 +++++++++++++++++++++++++++++++++--
 include/scsi/iscsi_if.h             |    8 ++++++++
 include/scsi/scsi_transport_iscsi.h |    5 ++++-
 3 files changed, 45 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 4fbd8e1..1ba98d2 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -32,7 +32,7 @@ #include <scsi/iscsi_if.h>
 
 #define ISCSI_SESSION_ATTRS 11
 #define ISCSI_CONN_ATTRS 11
-#define ISCSI_HOST_ATTRS 0
+#define ISCSI_HOST_ATTRS 1
 #define ISCSI_TRANSPORT_VERSION "2.0-724"
 
 struct iscsi_internal {
@@ -1197,6 +1197,25 @@ static ISCSI_CLASS_ATTR(priv_sess, field
 			NULL)
 iscsi_priv_session_attr(recovery_tmo, "%d");
 
+/*
+ * iSCSI host attrs
+ */
+#define iscsi_host_attr_show(param)					\
+static ssize_t								\
+show_host_param_##param(struct class_device *cdev, char *buf)		\
+{									\
+	struct Scsi_Host *shost = transport_class_to_shost(cdev);	\
+	struct iscsi_internal *priv = to_iscsi_internal(shost->transportt); \
+	return priv->iscsi_transport->get_host_param(shost, param, buf); \
+}
+
+#define iscsi_host_attr(field, param)					\
+	iscsi_host_attr_show(param)					\
+static ISCSI_CLASS_ATTR(host, field, S_IRUGO, show_host_param_##param,	\
+			NULL);
+
+iscsi_host_attr(hwaddress, ISCSI_HOST_PARAM_HWADDRESS);
+
 #define SETUP_PRIV_SESSION_RD_ATTR(field)				\
 do {									\
 	priv->session_attrs[count] = &class_device_attr_priv_sess_##field; \
@@ -1220,6 +1239,14 @@ do {									\
 	}								\
 } while (0)
 
+#define SETUP_HOST_RD_ATTR(field, param_flag)				\
+do {									\
+	if (tt->host_param_mask & param_flag) {				\
+		priv->host_attrs[count] = &class_device_attr_host_##field; \
+		count++;						\
+	}								\
+} while (0)
+
 static int iscsi_session_match(struct attribute_container *cont,
 			   struct device *dev)
 {
@@ -1321,9 +1348,13 @@ iscsi_register_transport(struct iscsi_tr
 	priv->t.host_attrs.ac.class = &iscsi_host_class.class;
 	priv->t.host_attrs.ac.match = iscsi_host_match;
 	priv->t.host_size = sizeof(struct iscsi_host);
-	priv->host_attrs[0] = NULL;
 	transport_container_register(&priv->t.host_attrs);
 
+	SETUP_HOST_RD_ATTR(hwaddress, ISCSI_HOST_HWADDRESS);
+	BUG_ON(count > ISCSI_HOST_ATTRS);
+	priv->host_attrs[count] = NULL;
+	count = 0;
+
 	/* connection parameters */
 	priv->conn_cont.ac.attrs = &priv->conn_attrs[0];
 	priv->conn_cont.ac.class = &iscsi_connection_class.class;
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 55ebf03..fba2117 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -250,6 +250,14 @@ #define ISCSI_SESS_RECOVERY_TMO		(1 << I
 #define ISCSI_CONN_PORT			(1 << ISCSI_PARAM_CONN_PORT)
 #define ISCSI_CONN_ADDRESS		(1 << ISCSI_PARAM_CONN_ADDRESS)
 
+/* iSCSI HBA params */
+enum iscsi_host_param {
+	ISCSI_HOST_PARAM_HWADDRESS,
+	ISCSI_HOST_PARAM_MAX,
+};
+
+#define ISCSI_HOST_HWADDRESS		(1 << ISCSI_HOST_PARAM_HWADDRESS)
+
 #define iscsi_ptr(_handle) ((void*)(unsigned long)_handle)
 #define iscsi_handle(_ptr) ((uint64_t)(unsigned long)_ptr)
 #define hostdata_session(_hostdata) (iscsi_ptr(*(unsigned long *)_hostdata))
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index d5c218d..e962c53 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -79,7 +79,8 @@ struct iscsi_transport {
 	char *name;
 	unsigned int caps;
 	/* LLD sets this to indicate what values it can export to sysfs */
-	unsigned int param_mask;
+	uint64_t param_mask;
+	uint64_t host_param_mask;
 	struct scsi_host_template *host_template;
 	/* LLD connection data size */
 	int conndata_size;
@@ -105,6 +106,8 @@ struct iscsi_transport {
 			       enum iscsi_param param, char *buf);
 	int (*get_session_param) (struct iscsi_cls_session *session,
 				  enum iscsi_param param, char *buf);
+	int (*get_host_param) (struct Scsi_Host *shost,
+				enum iscsi_host_param param, char *buf);
 	int (*send_pdu) (struct iscsi_cls_conn *conn, struct iscsi_hdr *hdr,
 			 char *data, uint32_t data_size);
 	void (*get_stats) (struct iscsi_cls_conn *conn,
-- 
1.4.1.1

