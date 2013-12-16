From: <vikas.chaudhary@qlogic.com>
Subject: [PATCH 18/24] qla4xxx: Updated print for device login, logout path
Date: Mon, 16 Dec 2013 06:49:48 -0500
Message-ID: <1387194594-29817-19-git-send-email-vikas.chaudhary@qlogic.com>
References: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:7912 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754299Ab3LPMXZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 07:23:25 -0500
In-Reply-To: <1387194594-29817-1-git-send-email-vikas.chaudhary@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, michaelc@cs.wisc.edu
Cc: linux-scsi@vger.kernel.org, vikas.chaudhary@qlogic.com, lalit.chandivade@qlogic.com

From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>

Signed-off-by: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
---
 drivers/scsi/qla4xxx/ql4_os.c | 59 +++++++++++++++++++++++++++++++------------
 1 file changed, 43 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index ce20c75..d0a8695 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -1670,16 +1670,13 @@ qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	struct sockaddr_in *addr;
 	struct sockaddr_in6 *addr6;
 
-	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
 	if (!shost) {
 		ret = -ENXIO;
-		printk(KERN_ERR "%s: shost is NULL\n",
-		       __func__);
+		pr_err("%s: shost is NULL\n", __func__);
 		return ERR_PTR(ret);
 	}
 
 	ha = iscsi_host_priv(shost);
-
 	ep = iscsi_create_endpoint(sizeof(struct qla_endpoint));
 	if (!ep) {
 		ret = -ENOMEM;
@@ -1699,6 +1696,9 @@ qla4xxx_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 		addr6 = (struct sockaddr_in6 *)&qla_ep->dst_addr;
 		DEBUG2(ql4_printk(KERN_INFO, ha, "%s: %pI6\n", __func__,
 				  (char *)&addr6->sin6_addr));
+	} else {
+		ql4_printk(KERN_WARNING, ha, "%s: Invalid endpoint\n",
+			   __func__);
 	}
 
 	qla_ep->host = shost;
@@ -1712,9 +1712,9 @@ static int qla4xxx_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 	struct scsi_qla_host *ha;
 	int ret = 0;
 
-	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
 	qla_ep = ep->dd_data;
 	ha = to_qla_host(qla_ep->host);
+	DEBUG2(pr_info_ratelimited("%s: host: %ld\n", __func__, ha->host_no));
 
 	if (adapter_up(ha) && !test_bit(AF_BUILD_DDB_LIST, &ha->flags))
 		ret = 1;
@@ -1724,7 +1724,13 @@ static int qla4xxx_ep_poll(struct iscsi_endpoint *ep, int timeout_ms)
 
 static void qla4xxx_ep_disconnect(struct iscsi_endpoint *ep)
 {
-	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	struct qla_endpoint *qla_ep;
+	struct scsi_qla_host *ha;
+
+	qla_ep = ep->dd_data;
+	ha = to_qla_host(qla_ep->host);
+	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: host: %ld\n", __func__,
+			  ha->host_no));
 	iscsi_destroy_endpoint(ep);
 }
 
@@ -1734,8 +1740,11 @@ static int qla4xxx_get_ep_param(struct iscsi_endpoint *ep,
 {
 	struct qla_endpoint *qla_ep = ep->dd_data;
 	struct sockaddr *dst_addr;
+	struct scsi_qla_host *ha;
 
-	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	ha = to_qla_host(qla_ep->host);
+	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: host: %ld\n", __func__,
+			  ha->host_no));
 
 	switch (param) {
 	case ISCSI_PARAM_CONN_PORT:
@@ -1766,13 +1775,13 @@ static void qla4xxx_conn_get_stats(struct iscsi_cls_conn *cls_conn,
 	int ret;
 	dma_addr_t iscsi_stats_dma;
 
-	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
-
 	cls_sess = iscsi_conn_to_session(cls_conn);
 	sess = cls_sess->dd_data;
 	ddb_entry = sess->dd_data;
 	ha = ddb_entry->ha;
 
+	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: host: %ld\n", __func__,
+			  ha->host_no));
 	stats_size = PAGE_ALIGN(sizeof(struct ql_iscsi_stats));
 	/* Allocate memory */
 	ql_iscsi_stats = dma_alloc_coherent(&ha->pdev->dev, stats_size,
@@ -3045,7 +3054,6 @@ qla4xxx_session_create(struct iscsi_endpoint *ep,
 	struct sockaddr *dst_addr;
 	int ret;
 
-	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
 	if (!ep) {
 		printk(KERN_ERR "qla4xxx: missing ep.\n");
 		return NULL;
@@ -3054,6 +3062,8 @@ qla4xxx_session_create(struct iscsi_endpoint *ep,
 	qla_ep = ep->dd_data;
 	dst_addr = (struct sockaddr *)&qla_ep->dst_addr;
 	ha = to_qla_host(qla_ep->host);
+	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: host: %ld\n", __func__,
+			  ha->host_no));
 
 	ret = qla4xxx_get_ddb_index(ha, &ddb_index);
 	if (ret == QLA_ERROR)
@@ -3093,10 +3103,11 @@ static void qla4xxx_session_destroy(struct iscsi_cls_session *cls_sess)
 	uint32_t ddb_state;
 	int ret;
 
-	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
 	sess = cls_sess->dd_data;
 	ddb_entry = sess->dd_data;
 	ha = ddb_entry->ha;
+	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: host: %ld\n", __func__,
+			  ha->host_no));
 
 	fw_ddb_entry = dma_alloc_coherent(&ha->pdev->dev, sizeof(*fw_ddb_entry),
 					  &fw_ddb_entry_dma, GFP_KERNEL);
@@ -3143,17 +3154,23 @@ qla4xxx_conn_create(struct iscsi_cls_session *cls_sess, uint32_t conn_idx)
 	struct iscsi_cls_conn *cls_conn;
 	struct iscsi_session *sess;
 	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
 
-	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
 	cls_conn = iscsi_conn_setup(cls_sess, sizeof(struct qla_conn),
 				    conn_idx);
-	if (!cls_conn)
+	if (!cls_conn) {
+		pr_info("%s: Can not create connection for conn_idx = %u\n",
+			__func__, conn_idx);
 		return NULL;
+	}
 
 	sess = cls_sess->dd_data;
 	ddb_entry = sess->dd_data;
 	ddb_entry->conn = cls_conn;
 
+	ha = ddb_entry->ha;
+	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: conn_idx = %u\n", __func__,
+			  conn_idx));
 	return cls_conn;
 }
 
@@ -3164,8 +3181,16 @@ static int qla4xxx_conn_bind(struct iscsi_cls_session *cls_session,
 	struct iscsi_conn *conn;
 	struct qla_conn *qla_conn;
 	struct iscsi_endpoint *ep;
+	struct ddb_entry *ddb_entry;
+	struct scsi_qla_host *ha;
+	struct iscsi_session *sess;
 
-	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
+	sess = cls_session->dd_data;
+	ddb_entry = sess->dd_data;
+	ha = ddb_entry->ha;
+
+	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: sid = %d, cid = %d\n", __func__,
+			  cls_session->sid, cls_conn->cid));
 
 	if (iscsi_conn_bind(cls_session, cls_conn, is_leading))
 		return -EINVAL;
@@ -3188,10 +3213,11 @@ static int qla4xxx_conn_start(struct iscsi_cls_conn *cls_conn)
 	int ret = 0;
 	int status = QLA_SUCCESS;
 
-	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
 	sess = cls_sess->dd_data;
 	ddb_entry = sess->dd_data;
 	ha = ddb_entry->ha;
+	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: sid = %d, cid = %d\n", __func__,
+			  cls_sess->sid, cls_conn->cid));
 
 	/* Check if we have  matching FW DDB, if yes then do not
 	 * login to this target. This could cause target to logout previous
@@ -3265,10 +3291,11 @@ static void qla4xxx_conn_destroy(struct iscsi_cls_conn *cls_conn)
 	struct ddb_entry *ddb_entry;
 	int options;
 
-	DEBUG2(printk(KERN_INFO "Func: %s\n", __func__));
 	sess = cls_sess->dd_data;
 	ddb_entry = sess->dd_data;
 	ha = ddb_entry->ha;
+	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: cid = %d\n", __func__,
+			  cls_conn->cid));
 
 	options = LOGOUT_OPTION_CLOSE_SESSION;
 	if (qla4xxx_session_logout_ddb(ha, ddb_entry, options) == QLA_ERROR)
-- 
1.8.2.GIT

