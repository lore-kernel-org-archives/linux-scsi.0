From: michaelc@cs.wisc.edu
Subject: [PATCH 06/25] iscsi: remove session/conn_data_size from iscsi_transport
Date: Wed, 21 May 2008 15:54:01 -0500
Message-ID: <1211403260-5487-7-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45282 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936989AbYEUUyc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:32 -0400
In-Reply-To: <1211403260-5487-6-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This removes the session and conn data_size fields from the iscsi_transport.
Just pass in the value like with host allocation. This patch also makes
it so the LLD iscsi_conn data is allocated with the iscsi_cls_conn.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   16 +++-------------
 drivers/scsi/iscsi_tcp.c                 |   19 +++++--------------
 drivers/scsi/libiscsi.c                  |   15 ++++++++++-----
 drivers/scsi/qla4xxx/ql4_os.c            |    7 +++----
 drivers/scsi/scsi_transport_iscsi.c      |   24 ++++++++++++------------
 include/scsi/libiscsi.h                  |    8 ++++----
 include/scsi/scsi_transport_iscsi.h      |    9 +++------
 7 files changed, 40 insertions(+), 58 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 62e35e5..9b34946 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -279,7 +279,7 @@ iscsi_iser_conn_create(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 	struct iscsi_cls_conn *cls_conn;
 	struct iscsi_iser_conn *iser_conn;
 
-	cls_conn = iscsi_conn_setup(cls_session, conn_idx);
+	cls_conn = iscsi_conn_setup(cls_session, sizeof(*iser_conn), conn_idx);
 	if (!cls_conn)
 		return NULL;
 	conn = cls_conn->dd_data;
@@ -290,10 +290,7 @@ iscsi_iser_conn_create(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 	 */
 	conn->max_recv_dlength = 128;
 
-	iser_conn = kzalloc(sizeof(*iser_conn), GFP_KERNEL);
-	if (!iser_conn)
-		goto conn_alloc_fail;
-
+	iser_conn = conn->dd_data;
 	/* currently this is the only field which need to be initiated */
 	rwlock_init(&iser_conn->lock);
 
@@ -301,10 +298,6 @@ iscsi_iser_conn_create(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 	iser_conn->iscsi_conn = conn;
 
 	return cls_conn;
-
-conn_alloc_fail:
-	iscsi_conn_teardown(cls_conn);
-	return NULL;
 }
 
 static void
@@ -313,10 +306,9 @@ iscsi_iser_conn_destroy(struct iscsi_cls_conn *cls_conn)
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_iser_conn *iser_conn = conn->dd_data;
 
-	iscsi_conn_teardown(cls_conn);
 	if (iser_conn->ib_conn)
 		iser_conn->ib_conn->iser_conn = NULL;
-	kfree(iser_conn);
+	iscsi_conn_teardown(cls_conn);
 }
 
 static int
@@ -619,8 +611,6 @@ static struct iscsi_transport iscsi_iser_transport = {
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
 				  ISCSI_HOST_NETDEV_NAME |
 				  ISCSI_HOST_INITIATOR_NAME,
-	.conndata_size		= sizeof(struct iscsi_conn),
-	.sessiondata_size	= sizeof(struct iscsi_session),
 	/* session management */
 	.create_session         = iscsi_iser_session_create,
 	.destroy_session        = iscsi_iser_session_destroy,
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index e19d92f..dfaf9fa 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1490,7 +1490,7 @@ iscsi_tcp_conn_create(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 	struct iscsi_cls_conn *cls_conn;
 	struct iscsi_tcp_conn *tcp_conn;
 
-	cls_conn = iscsi_conn_setup(cls_session, conn_idx);
+	cls_conn = iscsi_conn_setup(cls_session, sizeof(*tcp_conn), conn_idx);
 	if (!cls_conn)
 		return NULL;
 	conn = cls_conn->dd_data;
@@ -1500,18 +1500,14 @@ iscsi_tcp_conn_create(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 	 */
 	conn->max_recv_dlength = ISCSI_DEF_MAX_RECV_SEG_LEN;
 
-	tcp_conn = kzalloc(sizeof(*tcp_conn), GFP_KERNEL);
-	if (!tcp_conn)
-		goto tcp_conn_alloc_fail;
-
-	conn->dd_data = tcp_conn;
+	tcp_conn = conn->dd_data;
 	tcp_conn->iscsi_conn = conn;
 
 	tcp_conn->tx_hash.tfm = crypto_alloc_hash("crc32c", 0,
 						  CRYPTO_ALG_ASYNC);
 	tcp_conn->tx_hash.flags = 0;
 	if (IS_ERR(tcp_conn->tx_hash.tfm))
-		goto free_tcp_conn;
+		goto free_conn;
 
 	tcp_conn->rx_hash.tfm = crypto_alloc_hash("crc32c", 0,
 						  CRYPTO_ALG_ASYNC);
@@ -1523,14 +1519,12 @@ iscsi_tcp_conn_create(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 
 free_tx_tfm:
 	crypto_free_hash(tcp_conn->tx_hash.tfm);
-free_tcp_conn:
+free_conn:
 	iscsi_conn_printk(KERN_ERR, conn,
 			  "Could not create connection due to crc32c "
 			  "loading error. Make sure the crc32c "
 			  "module is built as a module or into the "
 			  "kernel\n");
-	kfree(tcp_conn);
-tcp_conn_alloc_fail:
 	iscsi_conn_teardown(cls_conn);
 	return NULL;
 }
@@ -1563,14 +1557,13 @@ iscsi_tcp_conn_destroy(struct iscsi_cls_conn *cls_conn)
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 
 	iscsi_tcp_release_conn(conn);
-	iscsi_conn_teardown(cls_conn);
 
 	if (tcp_conn->tx_hash.tfm)
 		crypto_free_hash(tcp_conn->tx_hash.tfm);
 	if (tcp_conn->rx_hash.tfm)
 		crypto_free_hash(tcp_conn->rx_hash.tfm);
 
-	kfree(tcp_conn);
+	iscsi_conn_teardown(cls_conn);
 }
 
 static void
@@ -1983,8 +1976,6 @@ static struct iscsi_transport iscsi_tcp_transport = {
 	.host_param_mask	= ISCSI_HOST_HWADDRESS | ISCSI_HOST_IPADDRESS |
 				  ISCSI_HOST_INITIATOR_NAME |
 				  ISCSI_HOST_NETDEV_NAME,
-	.conndata_size		= sizeof(struct iscsi_conn),
-	.sessiondata_size	= sizeof(struct iscsi_session),
 	/* session management */
 	.create_session		= iscsi_tcp_session_create,
 	.destroy_session	= iscsi_tcp_session_destroy,
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 73c37c0..784a935 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1867,7 +1867,8 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 		cmds_max = ISCSI_DEF_XMIT_CMDS_MAX;
 	}
 
-	cls_session = iscsi_alloc_session(shost, iscsit);
+	cls_session = iscsi_alloc_session(shost, iscsit,
+					  sizeof(struct iscsi_session));
 	if (!cls_session)
 		return NULL;
 	session = cls_session->dd_data;
@@ -1968,22 +1969,26 @@ EXPORT_SYMBOL_GPL(iscsi_session_teardown);
 /**
  * iscsi_conn_setup - create iscsi_cls_conn and iscsi_conn
  * @cls_session: iscsi_cls_session
+ * @dd_size: private driver data size
  * @conn_idx: cid
- **/
+ */
 struct iscsi_cls_conn *
-iscsi_conn_setup(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
+iscsi_conn_setup(struct iscsi_cls_session *cls_session, int dd_size,
+		 uint32_t conn_idx)
 {
 	struct iscsi_session *session = cls_session->dd_data;
 	struct iscsi_conn *conn;
 	struct iscsi_cls_conn *cls_conn;
 	char *data;
 
-	cls_conn = iscsi_create_conn(cls_session, conn_idx);
+	cls_conn = iscsi_create_conn(cls_session, sizeof(*conn) + dd_size,
+				     conn_idx);
 	if (!cls_conn)
 		return NULL;
 	conn = cls_conn->dd_data;
-	memset(conn, 0, sizeof(*conn));
+	memset(conn, 0, sizeof(*conn) + dd_size);
 
+	conn->dd_data = cls_conn->dd_data + sizeof(*conn);
 	conn->session = session;
 	conn->cls_conn = cls_conn;
 	conn->c_stage = ISCSI_CONN_INITIAL_STAGE;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 6c6ee0f..5822dd5 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -113,8 +113,6 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
 				  ISCSI_HOST_IPADDRESS |
 				  ISCSI_HOST_INITIATOR_NAME,
-	.sessiondata_size	= sizeof(struct ddb_entry),
-
 	.tgt_dscvr		= qla4xxx_tgt_dscvr,
 	.get_conn_param		= qla4xxx_conn_get_param,
 	.get_session_param	= qla4xxx_sess_get_param,
@@ -274,7 +272,7 @@ int qla4xxx_add_sess(struct ddb_entry *ddb_entry)
 		return err;
 	}
 
-	ddb_entry->conn = iscsi_create_conn(ddb_entry->sess, 0);
+	ddb_entry->conn = iscsi_create_conn(ddb_entry->sess, 0, 0);
 	if (!ddb_entry->conn) {
 		iscsi_remove_session(ddb_entry->sess);
 		DEBUG2(printk(KERN_ERR "Could not add connection.\n"));
@@ -291,7 +289,8 @@ struct ddb_entry *qla4xxx_alloc_sess(struct scsi_qla_host *ha)
 	struct ddb_entry *ddb_entry;
 	struct iscsi_cls_session *sess;
 
-	sess = iscsi_alloc_session(ha->host, &qla4xxx_iscsi_transport);
+	sess = iscsi_alloc_session(ha->host, &qla4xxx_iscsi_transport,
+				   sizeof(struct ddb_entry));
 	if (!sess)
 		return NULL;
 
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 6fdaa2e..6b8516a 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -483,12 +483,12 @@ static int iscsi_unbind_session(struct iscsi_cls_session *session)
 }
 
 struct iscsi_cls_session *
-iscsi_alloc_session(struct Scsi_Host *shost,
-		    struct iscsi_transport *transport)
+iscsi_alloc_session(struct Scsi_Host *shost, struct iscsi_transport *transport,
+		    int dd_size)
 {
 	struct iscsi_cls_session *session;
 
-	session = kzalloc(sizeof(*session) + transport->sessiondata_size,
+	session = kzalloc(sizeof(*session) + dd_size,
 			  GFP_KERNEL);
 	if (!session)
 		return NULL;
@@ -510,7 +510,7 @@ iscsi_alloc_session(struct Scsi_Host *shost,
 	session->dev.parent = &shost->shost_gendev;
 	session->dev.release = iscsi_session_release;
 	device_initialize(&session->dev);
-	if (transport->sessiondata_size)
+	if (dd_size)
 		session->dd_data = &session[1];
 	return session;
 }
@@ -558,18 +558,18 @@ EXPORT_SYMBOL_GPL(iscsi_add_session);
  * iscsi_create_session - create iscsi class session
  * @shost: scsi host
  * @transport: iscsi transport
+ * @dd_size: private driver data size
  * @target_id: which target
  *
  * This can be called from a LLD or iscsi_transport.
  */
 struct iscsi_cls_session *
-iscsi_create_session(struct Scsi_Host *shost,
-		     struct iscsi_transport *transport,
-		     unsigned int target_id)
+iscsi_create_session(struct Scsi_Host *shost, struct iscsi_transport *transport,
+		     int dd_size, unsigned int target_id)
 {
 	struct iscsi_cls_session *session;
 
-	session = iscsi_alloc_session(shost, transport);
+	session = iscsi_alloc_session(shost, transport, dd_size);
 	if (!session)
 		return NULL;
 
@@ -671,6 +671,7 @@ EXPORT_SYMBOL_GPL(iscsi_destroy_session);
 /**
  * iscsi_create_conn - create iscsi class connection
  * @session: iscsi cls session
+ * @dd_size: private driver data size
  * @cid: connection id
  *
  * This can be called from a LLD or iscsi_transport. The connection
@@ -683,18 +684,17 @@ EXPORT_SYMBOL_GPL(iscsi_destroy_session);
  * non-zero.
  */
 struct iscsi_cls_conn *
-iscsi_create_conn(struct iscsi_cls_session *session, uint32_t cid)
+iscsi_create_conn(struct iscsi_cls_session *session, int dd_size, uint32_t cid)
 {
 	struct iscsi_transport *transport = session->transport;
 	struct iscsi_cls_conn *conn;
 	unsigned long flags;
 	int err;
 
-	conn = kzalloc(sizeof(*conn) + transport->conndata_size, GFP_KERNEL);
+	conn = kzalloc(sizeof(*conn) + dd_size, GFP_KERNEL);
 	if (!conn)
 		return NULL;
-
-	if (transport->conndata_size)
+	if (dd_size)
 		conn->dd_data = &conn[1];
 
 	INIT_LIST_HEAD(&conn->conn_list);
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 9a26d71..4e1c14f 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -313,8 +313,6 @@ struct iscsi_host {
 	char			local_address[ISCSI_ADDRESS_BUF_LEN];
 };
 
-#define iscsi_host_priv(_shost) \
-	(shost_priv(_shost) + sizeof(struct iscsi_host))
 /*
  * scsi host template
  */
@@ -325,10 +323,12 @@ extern int iscsi_eh_device_reset(struct scsi_cmnd *sc);
 extern int iscsi_queuecommand(struct scsi_cmnd *sc,
 			      void (*done)(struct scsi_cmnd *));
 
-
 /*
  * iSCSI host helpers.
  */
+#define iscsi_host_priv(_shost) \
+	(shost_priv(_shost) + sizeof(struct iscsi_host))
+
 extern int iscsi_host_set_param(struct Scsi_Host *shost,
 				enum iscsi_host_param param, char *buf,
 				int buflen);
@@ -360,7 +360,7 @@ extern int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
  * connection management
  */
 extern struct iscsi_cls_conn *iscsi_conn_setup(struct iscsi_cls_session *,
-					       uint32_t);
+					       int, uint32_t);
 extern void iscsi_conn_teardown(struct iscsi_cls_conn *);
 extern int iscsi_conn_start(struct iscsi_cls_conn *);
 extern void iscsi_conn_stop(struct iscsi_cls_conn *, int);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 761f62d..4028f12 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -83,10 +83,6 @@ struct iscsi_transport {
 	/* LLD sets this to indicate what values it can export to sysfs */
 	uint64_t param_mask;
 	uint64_t host_param_mask;
-	/* LLD connection data size */
-	int conndata_size;
-	/* LLD session data size */
-	int sessiondata_size;
 	struct iscsi_cls_session *(*create_session) (struct Scsi_Host *shost,
 					uint16_t cmds_max, uint16_t qdepth,
 					uint32_t sn, uint32_t *hn);
@@ -222,19 +218,20 @@ extern void iscsi_host_for_each_session(struct Scsi_Host *shost,
 
 extern int iscsi_session_chkready(struct iscsi_cls_session *session);
 extern struct iscsi_cls_session *iscsi_alloc_session(struct Scsi_Host *shost,
-					struct iscsi_transport *transport);
+				struct iscsi_transport *transport, int dd_size);
 extern int iscsi_add_session(struct iscsi_cls_session *session,
 			     unsigned int target_id);
 extern int iscsi_session_event(struct iscsi_cls_session *session,
 			       enum iscsi_uevent_e event);
 extern struct iscsi_cls_session *iscsi_create_session(struct Scsi_Host *shost,
 						struct iscsi_transport *t,
+						int dd_size,
 						unsigned int target_id);
 extern void iscsi_remove_session(struct iscsi_cls_session *session);
 extern void iscsi_free_session(struct iscsi_cls_session *session);
 extern int iscsi_destroy_session(struct iscsi_cls_session *session);
 extern struct iscsi_cls_conn *iscsi_create_conn(struct iscsi_cls_session *sess,
-					    uint32_t cid);
+						int dd_size, uint32_t cid);
 extern int iscsi_destroy_conn(struct iscsi_cls_conn *conn);
 extern void iscsi_unblock_session(struct iscsi_cls_session *session);
 extern void iscsi_block_session(struct iscsi_cls_session *session);
-- 
1.5.4.1

