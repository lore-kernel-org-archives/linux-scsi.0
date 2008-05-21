From: michaelc@cs.wisc.edu
Subject: [PATCH 04/25] iscsi: remove session and host binding in libiscsi
Date: Wed, 21 May 2008 15:53:59 -0500
Message-ID: <1211403260-5487-5-git-send-email-michaelc@cs.wisc.edu>
References: <1211403260-5487-1-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-2-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-3-git-send-email-michaelc@cs.wisc.edu>
 <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45183 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936152AbYEUUy1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 16:54:27 -0400
In-Reply-To: <1211403260-5487-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

bnx2i allocates a host per netdevice but will use libiscsi,
so this unbinds the session from the host in that code.

This will also be useful for the iser parent device dma settings
fixes.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |   74 ++++++++---
 drivers/scsi/iscsi_tcp.c                 |  102 ++++++++-------
 drivers/scsi/libiscsi.c                  |  213 +++++++++++++-----------------
 drivers/scsi/qla4xxx/ql4_os.c            |    1 -
 drivers/scsi/scsi_transport_iscsi.c      |    5 +-
 include/scsi/iscsi_if.h                  |    7 -
 include/scsi/libiscsi.h                  |   31 +++--
 include/scsi/scsi_transport_iscsi.h      |    8 +-
 8 files changed, 225 insertions(+), 216 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 32f5d5e..5a75004 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -74,6 +74,10 @@
 
 #include "iscsi_iser.h"
 
+static struct scsi_host_template iscsi_iser_sht;
+static struct iscsi_transport iscsi_iser_transport;
+static struct scsi_transport_template *iscsi_iser_scsi_transport;
+
 static unsigned int iscsi_max_lun = 512;
 module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
 
@@ -363,40 +367,64 @@ iscsi_iser_conn_start(struct iscsi_cls_conn *cls_conn)
 	return iscsi_conn_start(cls_conn);
 }
 
-static struct iscsi_transport iscsi_iser_transport;
+static void iscsi_iser_session_destroy(struct iscsi_cls_session *cls_session)
+{
+	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
+
+	iscsi_session_teardown(cls_session);
+	scsi_remove_host(shost);
+	iscsi_host_teardown(shost);
+	scsi_host_put(shost);
+}
 
 static struct iscsi_cls_session *
-iscsi_iser_session_create(struct iscsi_transport *iscsit,
-			 struct scsi_transport_template *scsit,
-			 struct Scsi_Host *shost,
-			 uint16_t cmds_max, uint16_t qdepth,
-			 uint32_t initial_cmdsn, uint32_t *hostno)
+iscsi_iser_session_create(struct Scsi_Host *shost,
+			  uint16_t cmds_max, uint16_t qdepth,
+			  uint32_t initial_cmdsn, uint32_t *hostno)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
 	int i;
-	uint32_t hn;
 	struct iscsi_cmd_task  *ctask;
 	struct iscsi_mgmt_task *mtask;
 	struct iscsi_iser_cmd_task *iser_ctask;
 	struct iser_desc *desc;
 
+	if (shost) {
+		printk(KERN_ERR "iscsi_tcp: invalid shost %d.\n",
+		       shost->host_no);
+		return NULL;
+	}
+
+	shost = scsi_host_alloc(&iscsi_iser_sht, 0);
+	if (!shost)
+		return NULL;
+	shost->transportt = iscsi_iser_scsi_transport;
+	shost->max_lun = iscsi_max_lun;
+	shost->max_id = 0;
+	shost->max_channel = 0;
+	shost->max_cmd_len = 16;
+
+	iscsi_host_setup(shost, qdepth);
+
+	if (scsi_add_host(shost, NULL))
+		goto free_host;
+	*hostno = shost->host_no;
+
 	/*
 	 * we do not support setting can_queue cmd_per_lun from userspace yet
 	 * because we preallocate so many resources
 	 */
-	cls_session = iscsi_session_setup(iscsit, scsit,
+	cls_session = iscsi_session_setup(&iscsi_iser_transport, shost,
 					  ISCSI_DEF_XMIT_CMDS_MAX,
-					  ISCSI_MAX_CMD_PER_LUN,
 					  sizeof(struct iscsi_iser_cmd_task),
 					  sizeof(struct iser_desc),
-					  initial_cmdsn, &hn);
+					  initial_cmdsn);
 	if (!cls_session)
-	return NULL;
-
-	*hostno = hn;
-	session = class_to_transport_session(cls_session);
+		goto remove_host;
+	session = cls_session->dd_data;
 
+	shost->can_queue = session->cmds_max;
 	/* libiscsi setup itts, data and pool so just set desc fields */
 	for (i = 0; i < session->cmds_max; i++) {
 		ctask      = session->cmds[i];
@@ -413,6 +441,13 @@ iscsi_iser_session_create(struct iscsi_transport *iscsit,
 	}
 
 	return cls_session;
+
+remove_host:
+	scsi_remove_host(shost);
+free_host:
+	iscsi_host_teardown(shost);
+	scsi_host_put(shost);
+	return NULL;
 }
 
 static int
@@ -589,12 +624,11 @@ static struct iscsi_transport iscsi_iser_transport = {
 	.host_param_mask	= ISCSI_HOST_HWADDRESS |
 				  ISCSI_HOST_NETDEV_NAME |
 				  ISCSI_HOST_INITIATOR_NAME,
-	.host_template          = &iscsi_iser_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
-	.max_lun                = ISCSI_ISER_MAX_LUN,
+	.sessiondata_size	= sizeof(struct iscsi_session),
 	/* session management */
 	.create_session         = iscsi_iser_session_create,
-	.destroy_session        = iscsi_session_teardown,
+	.destroy_session        = iscsi_iser_session_destroy,
 	/* connection management */
 	.create_conn            = iscsi_iser_conn_create,
 	.bind_conn              = iscsi_iser_conn_bind,
@@ -633,8 +667,6 @@ static int __init iser_init(void)
 		return -EINVAL;
 	}
 
-	iscsi_iser_transport.max_lun = iscsi_max_lun;
-
 	memset(&ig, 0, sizeof(struct iser_global));
 
 	ig.desc_cache = kmem_cache_create("iser_descriptors",
@@ -650,7 +682,9 @@ static int __init iser_init(void)
 	mutex_init(&ig.connlist_mutex);
 	INIT_LIST_HEAD(&ig.connlist);
 
-	if (!iscsi_register_transport(&iscsi_iser_transport)) {
+	iscsi_iser_scsi_transport = iscsi_register_transport(
+							&iscsi_iser_transport);
+	if (!iscsi_iser_scsi_transport) {
 		iser_err("iscsi_register_transport failed\n");
 		err = -EINVAL;
 		goto register_transport_failure;
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index aecadbd..8cdcaf3 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -64,6 +64,10 @@ MODULE_LICENSE("GPL");
 #define BUG_ON(expr)
 #endif
 
+static struct scsi_transport_template *iscsi_tcp_scsi_transport;
+static struct scsi_host_template iscsi_sht;
+static struct iscsi_transport iscsi_tcp_transport;
+
 static unsigned int iscsi_max_lun = 512;
 module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
 
@@ -1623,6 +1627,8 @@ iscsi_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 		    struct iscsi_cls_conn *cls_conn, uint64_t transport_eph,
 		    int is_leading)
 {
+	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
+	struct iscsi_host *ihost = shost_priv(shost);
 	struct iscsi_conn *conn = cls_conn->dd_data;
 	struct iscsi_tcp_conn *tcp_conn = conn->dd_data;
 	struct sock *sk;
@@ -1646,8 +1652,8 @@ iscsi_tcp_conn_bind(struct iscsi_cls_session *cls_session,
 	if (err)
 		goto free_socket;
 
-	err = iscsi_tcp_get_addr(conn, sock, conn->local_address,
-				&conn->local_port, kernel_getsockname);
+	err = iscsi_tcp_get_addr(conn, sock, ihost->local_address,
+				&ihost->local_port, kernel_getsockname);
 	if (err)
 		goto free_socket;
 
@@ -1821,29 +1827,6 @@ iscsi_tcp_conn_get_param(struct iscsi_cls_conn *cls_conn,
 	return len;
 }
 
-static int
-iscsi_tcp_host_get_param(struct Scsi_Host *shost, enum iscsi_host_param param,
-			 char *buf)
-{
-        struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
-	int len;
-
-	switch (param) {
-	case ISCSI_HOST_PARAM_IPADDRESS:
-		spin_lock_bh(&session->lock);
-		if (!session->leadconn)
-			len = -ENODEV;
-		else
-			len = sprintf(buf, "%s\n",
-				     session->leadconn->local_address);
-		spin_unlock_bh(&session->lock);
-		break;
-	default:
-		return iscsi_host_get_param(shost, param, buf);
-	}
-	return len;
-}
-
 static void
 iscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *stats)
 {
@@ -1869,26 +1852,44 @@ iscsi_conn_get_stats(struct iscsi_cls_conn *cls_conn, struct iscsi_stats *stats)
 }
 
 static struct iscsi_cls_session *
-iscsi_tcp_session_create(struct iscsi_transport *iscsit,
-			 struct scsi_transport_template *scsit,
-			 struct Scsi_Host *shost, uint16_t cmds_max,
+iscsi_tcp_session_create(struct Scsi_Host *shost, uint16_t cmds_max,
 			 uint16_t qdepth, uint32_t initial_cmdsn,
 			 uint32_t *hostno)
 {
 	struct iscsi_cls_session *cls_session;
 	struct iscsi_session *session;
-	uint32_t hn;
 	int cmd_i;
 
-	cls_session = iscsi_session_setup(iscsit, scsit, cmds_max, qdepth,
-					 sizeof(struct iscsi_tcp_cmd_task),
-					 sizeof(struct iscsi_tcp_mgmt_task),
-					 initial_cmdsn, &hn);
-	if (!cls_session)
+	if (shost) {
+		printk(KERN_ERR "iscsi_tcp: invalid shost %d.\n",
+		       shost->host_no);
+		return NULL;
+	}
+
+	shost = scsi_host_alloc(&iscsi_sht, sizeof(struct iscsi_host));
+	if (!shost)
 		return NULL;
-	*hostno = hn;
+	shost->transportt = iscsi_tcp_scsi_transport;
+	shost->max_lun = iscsi_max_lun;
+	shost->max_id = 0;
+	shost->max_channel = 0;
+	shost->max_cmd_len = 16;
+
+	iscsi_host_setup(shost, qdepth);
+
+	if (scsi_add_host(shost, NULL))
+		goto free_host;
+	*hostno = shost->host_no;
+
+	cls_session = iscsi_session_setup(&iscsi_tcp_transport, shost, cmds_max,
+					  sizeof(struct iscsi_tcp_cmd_task),
+					  sizeof(struct iscsi_tcp_mgmt_task),
+					  initial_cmdsn);
+	if (!cls_session)
+		goto remove_host;
+	session = cls_session->dd_data;
 
-	session = class_to_transport_session(cls_session);
+	shost->can_queue = session->cmds_max;
 	for (cmd_i = 0; cmd_i < session->cmds_max; cmd_i++) {
 		struct iscsi_cmd_task *ctask = session->cmds[cmd_i];
 		struct iscsi_tcp_cmd_task *tcp_ctask = ctask->dd_data;
@@ -1904,20 +1905,30 @@ iscsi_tcp_session_create(struct iscsi_transport *iscsit,
 		mtask->hdr = (struct iscsi_hdr *) &tcp_mtask->hdr;
 	}
 
-	if (iscsi_r2tpool_alloc(class_to_transport_session(cls_session)))
-		goto r2tpool_alloc_fail;
-
+	if (iscsi_r2tpool_alloc(session))
+		goto remove_session;
 	return cls_session;
 
-r2tpool_alloc_fail:
+remove_session:
 	iscsi_session_teardown(cls_session);
+remove_host:
+	scsi_remove_host(shost);
+free_host:
+	iscsi_host_teardown(shost);
+	scsi_host_put(shost);
 	return NULL;
 }
 
 static void iscsi_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 {
-	iscsi_r2tpool_free(class_to_transport_session(cls_session));
+	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
+
+	iscsi_r2tpool_free(cls_session->dd_data);
 	iscsi_session_teardown(cls_session);
+
+	scsi_remove_host(shost);
+	iscsi_host_teardown(shost);
+	scsi_host_put(shost);
 }
 
 static int iscsi_tcp_slave_configure(struct scsi_device *sdev)
@@ -1976,8 +1987,8 @@ static struct iscsi_transport iscsi_tcp_transport = {
 	.host_param_mask	= ISCSI_HOST_HWADDRESS | ISCSI_HOST_IPADDRESS |
 				  ISCSI_HOST_INITIATOR_NAME |
 				  ISCSI_HOST_NETDEV_NAME,
-	.host_template		= &iscsi_sht,
 	.conndata_size		= sizeof(struct iscsi_conn),
+	.sessiondata_size	= sizeof(struct iscsi_session),
 	/* session management */
 	.create_session		= iscsi_tcp_session_create,
 	.destroy_session	= iscsi_tcp_session_destroy,
@@ -1991,7 +2002,7 @@ static struct iscsi_transport iscsi_tcp_transport = {
 	.start_conn		= iscsi_conn_start,
 	.stop_conn		= iscsi_tcp_conn_stop,
 	/* iscsi host params */
-	.get_host_param		= iscsi_tcp_host_get_param,
+	.get_host_param		= iscsi_host_get_param,
 	.set_host_param		= iscsi_host_set_param,
 	/* IO */
 	.send_pdu		= iscsi_conn_send_pdu,
@@ -2013,9 +2024,10 @@ iscsi_tcp_init(void)
 		       iscsi_max_lun);
 		return -EINVAL;
 	}
-	iscsi_tcp_transport.max_lun = iscsi_max_lun;
 
-	if (!iscsi_register_transport(&iscsi_tcp_transport))
+	iscsi_tcp_scsi_transport = iscsi_register_transport(
+							&iscsi_tcp_transport);
+	if (!iscsi_tcp_scsi_transport)
 		return -ENODEV;
 
 	return 0;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 01a1a4d..64b1dd8 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -38,14 +38,6 @@
 #include <scsi/scsi_transport_iscsi.h>
 #include <scsi/libiscsi.h>
 
-struct iscsi_session *
-class_to_transport_session(struct iscsi_cls_session *cls_session)
-{
-	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
-	return iscsi_hostdata(shost->hostdata);
-}
-EXPORT_SYMBOL_GPL(class_to_transport_session);
-
 /* Serial Number Arithmetic, 32 bits, less than, RFC1982 */
 #define SNA32_CHECK 2147483648UL
 
@@ -1096,6 +1088,7 @@ enum {
 
 int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 {
+	struct iscsi_cls_session *cls_session;
 	struct Scsi_Host *host;
 	int reason = 0;
 	struct iscsi_session *session;
@@ -1109,10 +1102,11 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 	host = sc->device->host;
 	spin_unlock(host->host_lock);
 
-	session = iscsi_hostdata(host->hostdata);
+	cls_session = starget_to_session(scsi_target(sc->device));
+	session = cls_session->dd_data;
 	spin_lock(&session->lock);
 
-	reason = iscsi_session_chkready(session_to_cls(session));
+	reason = iscsi_session_chkready(cls_session);
 	if (reason) {
 		sc->result = reason;
 		goto fault;
@@ -1222,7 +1216,7 @@ EXPORT_SYMBOL_GPL(iscsi_change_queue_depth);
 
 void iscsi_session_recovery_timedout(struct iscsi_cls_session *cls_session)
 {
-	struct iscsi_session *session = class_to_transport_session(cls_session);
+	struct iscsi_session *session = cls_session->dd_data;
 
 	spin_lock_bh(&session->lock);
 	if (session->state != ISCSI_STATE_LOGGED_IN) {
@@ -1236,9 +1230,13 @@ EXPORT_SYMBOL_GPL(iscsi_session_recovery_timedout);
 
 int iscsi_eh_host_reset(struct scsi_cmnd *sc)
 {
-	struct Scsi_Host *host = sc->device->host;
-	struct iscsi_session *session = iscsi_hostdata(host->hostdata);
-	struct iscsi_conn *conn = session->leadconn;
+	struct iscsi_cls_session *cls_session;
+	struct iscsi_session *session;
+	struct iscsi_conn *conn;
+
+	cls_session = starget_to_session(scsi_target(sc->device));
+	session = cls_session->dd_data;
+	conn = session->leadconn;
 
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
@@ -1405,7 +1403,7 @@ static enum scsi_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *scmd)
 	enum scsi_eh_timer_return rc = EH_NOT_HANDLED;
 
 	cls_session = starget_to_session(scsi_target(scmd->device));
-	session = class_to_transport_session(cls_session);
+	session = cls_session->dd_data;
 
 	debug_scsi("scsi cmd %p timedout\n", scmd);
 
@@ -1507,13 +1505,16 @@ static void iscsi_prep_abort_task_pdu(struct iscsi_cmd_task *ctask,
 
 int iscsi_eh_abort(struct scsi_cmnd *sc)
 {
-	struct Scsi_Host *host = sc->device->host;
-	struct iscsi_session *session = iscsi_hostdata(host->hostdata);
+	struct iscsi_cls_session *cls_session;
+	struct iscsi_session *session;
 	struct iscsi_conn *conn;
 	struct iscsi_cmd_task *ctask;
 	struct iscsi_tm *hdr;
 	int rc, age;
 
+	cls_session = starget_to_session(scsi_target(sc->device));
+	session = cls_session->dd_data;
+
 	mutex_lock(&session->eh_mutex);
 	spin_lock_bh(&session->lock);
 	/*
@@ -1630,12 +1631,15 @@ static void iscsi_prep_lun_reset_pdu(struct scsi_cmnd *sc, struct iscsi_tm *hdr)
 
 int iscsi_eh_device_reset(struct scsi_cmnd *sc)
 {
-	struct Scsi_Host *host = sc->device->host;
-	struct iscsi_session *session = iscsi_hostdata(host->hostdata);
+	struct iscsi_cls_session *cls_session;
+	struct iscsi_session *session;
 	struct iscsi_conn *conn;
 	struct iscsi_tm *hdr;
 	int rc = FAILED;
 
+	cls_session = starget_to_session(scsi_target(sc->device));
+	session = cls_session->dd_data;
+
 	debug_scsi("LU Reset [sc %p lun %u]\n", sc, sc->device->lun);
 
 	mutex_lock(&session->eh_mutex);
@@ -1760,55 +1764,53 @@ void iscsi_pool_free(struct iscsi_pool *q)
 }
 EXPORT_SYMBOL_GPL(iscsi_pool_free);
 
-/*
- * iSCSI Session's hostdata organization:
- *
- *    *------------------* <== hostdata_session(host->hostdata)
- *    | ptr to class sess|
- *    |------------------| <== iscsi_hostdata(host->hostdata)
- *    | iscsi_session    |
- *    *------------------*
- */
+void iscsi_host_setup(struct Scsi_Host *shost, uint16_t qdepth)
+{
+	if (qdepth > ISCSI_MAX_CMD_PER_LUN || qdepth < 1) {
+		if (qdepth != 0)
+			printk(KERN_ERR "iscsi: invalid queue depth of %d. "
+			       "Queue depth must be between 1 and %d.\n",
+			       qdepth, ISCSI_MAX_CMD_PER_LUN);
+		qdepth = ISCSI_DEF_CMD_PER_LUN;
+	}
+
+	shost->transportt->create_work_queue = 1;
+	shost->transportt->eh_timed_out = iscsi_eh_cmd_timed_out;
+	shost->cmd_per_lun = qdepth;
+}
+EXPORT_SYMBOL_GPL(iscsi_host_setup);
 
-#define hostdata_privsize(_sz)	(sizeof(unsigned long) + _sz + \
-				 _sz % sizeof(unsigned long))
+void iscsi_host_teardown(struct Scsi_Host *shost)
+{
+	struct iscsi_host *ihost = shost_priv(shost);
 
-#define hostdata_session(_hostdata) (iscsi_ptr(*(unsigned long *)_hostdata))
+	kfree(ihost->netdev);
+	kfree(ihost->hwaddress);
+	kfree(ihost->initiatorname);
+}
+EXPORT_SYMBOL_GPL(iscsi_host_teardown);
 
 /**
  * iscsi_session_setup - create iscsi cls session and host and session
- * @scsit: scsi transport template
  * @iscsit: iscsi transport template
- * @cmds_max: scsi host can queue
- * @qdepth: scsi host cmds per lun
+ * @shost: scsi host
+ * @cmds_max: session can queue
  * @cmd_task_size: LLD ctask private data size
  * @mgmt_task_size: LLD mtask private data size
  * @initial_cmdsn: initial CmdSN
- * @hostno: host no allocated
  *
  * This can be used by software iscsi_transports that allocate
  * a session per scsi host.
- **/
+ */
 struct iscsi_cls_session *
-iscsi_session_setup(struct iscsi_transport *iscsit,
-		    struct scsi_transport_template *scsit,
-		    uint16_t cmds_max, uint16_t qdepth,
-		    int cmd_task_size, int mgmt_task_size,
-		    uint32_t initial_cmdsn, uint32_t *hostno)
+iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
+		    uint16_t cmds_max, int cmd_task_size, int mgmt_task_size,
+		    uint32_t initial_cmdsn)
 {
-	struct Scsi_Host *shost;
 	struct iscsi_session *session;
 	struct iscsi_cls_session *cls_session;
 	int cmd_i;
 
-	if (qdepth > ISCSI_MAX_CMD_PER_LUN || qdepth < 1) {
-		if (qdepth != 0)
-			printk(KERN_ERR "iscsi: invalid queue depth of %d. "
-			      "Queue depth must be between 1 and %d.\n",
-			      qdepth, ISCSI_MAX_CMD_PER_LUN);
-		qdepth = ISCSI_DEF_CMD_PER_LUN;
-	}
-
 	if (!is_power_of_2(cmds_max) || cmds_max >= ISCSI_MGMT_ITT_OFFSET ||
 	    cmds_max < 2) {
 		if (cmds_max != 0)
@@ -1819,25 +1821,11 @@ iscsi_session_setup(struct iscsi_transport *iscsit,
 		cmds_max = ISCSI_DEF_XMIT_CMDS_MAX;
 	}
 
-	shost = scsi_host_alloc(iscsit->host_template,
-				hostdata_privsize(sizeof(*session)));
-	if (!shost)
+	cls_session = iscsi_alloc_session(shost, iscsit);
+	if (!cls_session)
 		return NULL;
-
-	/* the iscsi layer takes one task for reserve */
-	shost->can_queue = cmds_max - 1;
-	shost->cmd_per_lun = qdepth;
-	shost->max_id = 1;
-	shost->max_channel = 0;
-	shost->max_lun = iscsit->max_lun;
-	shost->max_cmd_len = 16;
-	shost->transportt = scsit;
-	shost->transportt->create_work_queue = 1;
-	shost->transportt->eh_timed_out = iscsi_eh_cmd_timed_out;
-	*hostno = shost->host_no;
-
-	session = iscsi_hostdata(shost->hostdata);
-	memset(session, 0, sizeof(struct iscsi_session));
+	session = cls_session->dd_data;
+	session->cls_session = cls_session;
 	session->host = shost;
 	session->state = ISCSI_STATE_FREE;
 	session->fast_abort = 1;
@@ -1851,6 +1839,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit,
 	session->max_r2t = 1;
 	session->tt = iscsit;
 	mutex_init(&session->eh_mutex);
+	spin_lock_init(&session->lock);
 
 	/* initialize SCSI PDU commands pool */
 	if (iscsi_pool_init(&session->cmdpool, session->cmds_max,
@@ -1868,8 +1857,6 @@ iscsi_session_setup(struct iscsi_transport *iscsit,
 		INIT_LIST_HEAD(&ctask->running);
 	}
 
-	spin_lock_init(&session->lock);
-
 	/* initialize immediate command pool */
 	if (iscsi_pool_init(&session->mgmtpool, session->mgmtpool_max,
 			   (void***)&session->mgmt_cmds,
@@ -1887,49 +1874,37 @@ iscsi_session_setup(struct iscsi_transport *iscsit,
 		INIT_LIST_HEAD(&mtask->running);
 	}
 
-	if (scsi_add_host(shost, NULL))
-		goto add_host_fail;
-
 	if (!try_module_get(iscsit->owner))
-		goto cls_session_fail;
-
-	cls_session = iscsi_create_session(shost, iscsit, 0);
-	if (!cls_session)
-		goto module_put;
-	*(unsigned long*)shost->hostdata = (unsigned long)cls_session;
+		goto module_get_fail;
 
+	if (iscsi_add_session(cls_session, 0))
+		goto cls_session_fail;
 	return cls_session;
 
-module_put:
-	module_put(iscsit->owner);
 cls_session_fail:
-	scsi_remove_host(shost);
-add_host_fail:
+	module_put(iscsit->owner);
+module_get_fail:
 	iscsi_pool_free(&session->mgmtpool);
 mgmtpool_alloc_fail:
 	iscsi_pool_free(&session->cmdpool);
 cmdpool_alloc_fail:
-	scsi_host_put(shost);
+	iscsi_free_session(cls_session);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_session_setup);
 
 /**
  * iscsi_session_teardown - destroy session, host, and cls_session
- * shost: scsi host
+ * @cls_session: iscsi session
  *
- * This can be used by software iscsi_transports that allocate
- * a session per scsi host.
- **/
+ * The driver must have called iscsi_remove_session before
+ * calling this.
+ */
 void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 {
-	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
-	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
+	struct iscsi_session *session = cls_session->dd_data;
 	struct module *owner = cls_session->transport->owner;
 
-	iscsi_remove_session(cls_session);
-	scsi_remove_host(shost);
-
 	iscsi_pool_free(&session->mgmtpool);
 	iscsi_pool_free(&session->cmdpool);
 
@@ -1938,12 +1913,8 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	kfree(session->username);
 	kfree(session->username_in);
 	kfree(session->targetname);
-	kfree(session->netdev);
-	kfree(session->hwaddress);
-	kfree(session->initiatorname);
 
-	iscsi_free_session(cls_session);
-	scsi_host_put(shost);
+	iscsi_destroy_session(cls_session);
 	module_put(owner);
 }
 EXPORT_SYMBOL_GPL(iscsi_session_teardown);
@@ -1956,7 +1927,7 @@ EXPORT_SYMBOL_GPL(iscsi_session_teardown);
 struct iscsi_cls_conn *
 iscsi_conn_setup(struct iscsi_cls_session *cls_session, uint32_t conn_idx)
 {
-	struct iscsi_session *session = class_to_transport_session(cls_session);
+	struct iscsi_session *session = cls_session->dd_data;
 	struct iscsi_conn *conn;
 	struct iscsi_cls_conn *cls_conn;
 	char *data;
@@ -2140,7 +2111,7 @@ int iscsi_conn_start(struct iscsi_cls_conn *cls_conn)
 	}
 	spin_unlock_bh(&session->lock);
 
-	iscsi_unblock_session(session_to_cls(session));
+	iscsi_unblock_session(session->cls_session);
 	wake_up(&conn->ehwait);
 	return 0;
 }
@@ -2225,7 +2196,7 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 		if (session->state == ISCSI_STATE_IN_RECOVERY &&
 		    old_stop_stage != STOP_CONN_RECOVER) {
 			debug_scsi("blocking session\n");
-			iscsi_block_session(session_to_cls(session));
+			iscsi_block_session(session->cls_session);
 		}
 	}
 
@@ -2260,7 +2231,7 @@ EXPORT_SYMBOL_GPL(iscsi_conn_stop);
 int iscsi_conn_bind(struct iscsi_cls_session *cls_session,
 		    struct iscsi_cls_conn *cls_conn, int is_leading)
 {
-	struct iscsi_session *session = class_to_transport_session(cls_session);
+	struct iscsi_session *session = cls_session->dd_data;
 	struct iscsi_conn *conn = cls_conn->dd_data;
 
 	spin_lock_bh(&session->lock);
@@ -2410,8 +2381,7 @@ EXPORT_SYMBOL_GPL(iscsi_set_param);
 int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 			    enum iscsi_param param, char *buf)
 {
-	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
-	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
+	struct iscsi_session *session = cls_session->dd_data;
 	int len;
 
 	switch(param) {
@@ -2525,29 +2495,34 @@ EXPORT_SYMBOL_GPL(iscsi_conn_get_param);
 int iscsi_host_get_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 			 char *buf)
 {
-	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
+	struct iscsi_host *ihost = shost_priv(shost);
 	int len;
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_NETDEV_NAME:
-		if (!session->netdev)
+		if (!ihost->netdev)
 			len = sprintf(buf, "%s\n", "default");
 		else
-			len = sprintf(buf, "%s\n", session->netdev);
+			len = sprintf(buf, "%s\n", ihost->netdev);
 		break;
 	case ISCSI_HOST_PARAM_HWADDRESS:
-		if (!session->hwaddress)
+		if (!ihost->hwaddress)
 			len = sprintf(buf, "%s\n", "default");
 		else
-			len = sprintf(buf, "%s\n", session->hwaddress);
+			len = sprintf(buf, "%s\n", ihost->hwaddress);
 		break;
 	case ISCSI_HOST_PARAM_INITIATOR_NAME:
-		if (!session->initiatorname)
+		if (!ihost->initiatorname)
 			len = sprintf(buf, "%s\n", "unknown");
 		else
-			len = sprintf(buf, "%s\n", session->initiatorname);
+			len = sprintf(buf, "%s\n", ihost->initiatorname);
 		break;
-
+	case ISCSI_HOST_PARAM_IPADDRESS:
+		if (!strlen(ihost->local_address))
+			len = sprintf(buf, "%s\n", "unknown");
+		else
+			len = sprintf(buf, "%s\n",
+				      ihost->local_address);
 	default:
 		return -ENOSYS;
 	}
@@ -2559,20 +2534,20 @@ EXPORT_SYMBOL_GPL(iscsi_host_get_param);
 int iscsi_host_set_param(struct Scsi_Host *shost, enum iscsi_host_param param,
 			 char *buf, int buflen)
 {
-	struct iscsi_session *session = iscsi_hostdata(shost->hostdata);
+	struct iscsi_host *ihost = shost_priv(shost);
 
 	switch (param) {
 	case ISCSI_HOST_PARAM_NETDEV_NAME:
-		if (!session->netdev)
-			session->netdev = kstrdup(buf, GFP_KERNEL);
+		if (!ihost->netdev)
+			ihost->netdev = kstrdup(buf, GFP_KERNEL);
 		break;
 	case ISCSI_HOST_PARAM_HWADDRESS:
-		if (!session->hwaddress)
-			session->hwaddress = kstrdup(buf, GFP_KERNEL);
+		if (!ihost->hwaddress)
+			ihost->hwaddress = kstrdup(buf, GFP_KERNEL);
 		break;
 	case ISCSI_HOST_PARAM_INITIATOR_NAME:
-		if (!session->initiatorname)
-			session->initiatorname = kstrdup(buf, GFP_KERNEL);
+		if (!ihost->initiatorname)
+			ihost->initiatorname = kstrdup(buf, GFP_KERNEL);
 		break;
 	default:
 		return -ENOSYS;
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 0c78694..6c6ee0f 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -114,7 +114,6 @@ static struct iscsi_transport qla4xxx_iscsi_transport = {
 				  ISCSI_HOST_IPADDRESS |
 				  ISCSI_HOST_INITIATOR_NAME,
 	.sessiondata_size	= sizeof(struct ddb_entry),
-	.host_template		= &qla4xxx_driver_template,
 
 	.tgt_dscvr		= qla4xxx_tgt_dscvr,
 	.get_conn_param		= qla4xxx_conn_get_param,
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 5577a60..9c00a15 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -101,12 +101,10 @@ show_transport_##name(struct device *dev, 				\
 static DEVICE_ATTR(name, S_IRUGO, show_transport_##name, NULL);
 
 show_transport_attr(caps, "0x%x");
-show_transport_attr(max_lun, "%d");
 
 static struct attribute *iscsi_transport_attrs[] = {
 	&dev_attr_handle.attr,
 	&dev_attr_caps.attr,
-	&dev_attr_max_lun.attr,
 	NULL,
 };
 
@@ -1034,8 +1032,7 @@ iscsi_if_create_session(struct iscsi_internal *priv, struct iscsi_uevent *ev,
 		}
 	}
 
-	session = transport->create_session(transport, &priv->t, shost,
-					    cmds_max, queue_depth,
+	session = transport->create_session(shost, cmds_max, queue_depth,
 					    initial_cmdsn, &host_no);
 	if (shost)
 		scsi_host_put(shost);
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 1883c85..801a677 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -310,13 +310,6 @@ enum iscsi_host_param {
 
 #define iscsi_ptr(_handle) ((void*)(unsigned long)_handle)
 #define iscsi_handle(_ptr) ((uint64_t)(unsigned long)_ptr)
-#define hostdata_session(_hostdata) (iscsi_ptr(*(unsigned long *)_hostdata))
-
-/**
- * iscsi_hostdata - get LLD hostdata from scsi_host
- * @_hostdata: pointer to scsi host's hostdata
- **/
-#define iscsi_hostdata(_hostdata) ((void*)_hostdata + sizeof(unsigned long))
 
 /*
  * These flags presents iSCSI Data-Path capabilities.
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index f24cf02..8a6271c 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -209,9 +209,6 @@ struct iscsi_conn {
 	/* remote portal currently connected to */
 	int			portal_port;
 	char			portal_address[ISCSI_ADDRESS_BUF_LEN];
-	/* local address */
-	int			local_port;
-	char			local_address[ISCSI_ADDRESS_BUF_LEN];
 
 	/* MIB-statistics */
 	uint64_t		txdata_octets;
@@ -247,6 +244,7 @@ enum {
 };
 
 struct iscsi_session {
+	struct iscsi_cls_session *cls_session;
 	/*
 	 * Syncs up the scsi eh thread with the iscsi eh thread when sending
 	 * task management functions. This must be taken before the session
@@ -282,10 +280,6 @@ struct iscsi_session {
 	char			*password;
 	char			*password_in;
 	char			*targetname;
-	char			*initiatorname;
-	/* hw address or netdev iscsi connection is bound to */
-	char			*hwaddress;
-	char			*netdev;
 	/* control data */
 	struct iscsi_transport	*tt;
 	struct Scsi_Host	*host;
@@ -307,6 +301,16 @@ struct iscsi_session {
 	struct iscsi_pool	mgmtpool;	/* Mgmt PDU's pool */
 };
 
+struct iscsi_host {
+	char			*initiatorname;
+	/* hw address or netdev iscsi connection is bound to */
+	char			*hwaddress;
+	char			*netdev;
+	/* local address */
+	int			local_port;
+	char			local_address[ISCSI_ADDRESS_BUF_LEN];
+};
+
 /*
  * scsi host template
  */
@@ -326,27 +330,24 @@ extern int iscsi_host_set_param(struct Scsi_Host *shost,
 				int buflen);
 extern int iscsi_host_get_param(struct Scsi_Host *shost,
 				enum iscsi_host_param param, char *buf);
+extern void iscsi_host_setup(struct Scsi_Host *shost, uint16_t qdepth);
+extern void iscsi_host_teardown(struct Scsi_Host *shost);
 
 /*
  * session management
  */
 extern struct iscsi_cls_session *
-iscsi_session_setup(struct iscsi_transport *, struct scsi_transport_template *,
-		    uint16_t, uint16_t, int, int, uint32_t, uint32_t *);
+iscsi_session_setup(struct iscsi_transport *, struct Scsi_Host *shost,
+		    uint16_t, int, int, uint32_t);
 extern void iscsi_session_teardown(struct iscsi_cls_session *);
-extern struct iscsi_session *class_to_transport_session(struct iscsi_cls_session *);
 extern void iscsi_session_recovery_timedout(struct iscsi_cls_session *);
 extern int iscsi_set_param(struct iscsi_cls_conn *cls_conn,
 			   enum iscsi_param param, char *buf, int buflen);
 extern int iscsi_session_get_param(struct iscsi_cls_session *cls_session,
 				   enum iscsi_param param, char *buf);
 
-#define session_to_cls(_sess) \
-	hostdata_session(_sess->host->hostdata)
-
 #define iscsi_session_printk(prefix, _sess, fmt, a...)	\
-	iscsi_cls_session_printk(prefix,		\
-		(struct iscsi_cls_session *)session_to_cls(_sess), fmt, ##a)
+	iscsi_cls_session_printk(prefix, _sess->cls_session, fmt, ##a)
 
 /*
  * connection management
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 7287022..702eda2 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -83,15 +83,13 @@ struct iscsi_transport {
 	/* LLD sets this to indicate what values it can export to sysfs */
 	uint64_t param_mask;
 	uint64_t host_param_mask;
-	struct scsi_host_template *host_template;
 	/* LLD connection data size */
 	int conndata_size;
 	/* LLD session data size */
 	int sessiondata_size;
-	int max_lun;
-	struct iscsi_cls_session *(*create_session) (struct iscsi_transport *it,
-		struct scsi_transport_template *t, struct Scsi_Host *shost,
-		uint16_t cmds_max, uint16_t qdepth, uint32_t sn, uint32_t *hn);
+	struct iscsi_cls_session *(*create_session) (struct Scsi_Host *shost,
+					uint16_t cmds_max, uint16_t qdepth,
+					uint32_t sn, uint32_t *hn);
 	void (*destroy_session) (struct iscsi_cls_session *session);
 	struct iscsi_cls_conn *(*create_conn) (struct iscsi_cls_session *sess,
 				uint32_t cid);
-- 
1.5.4.1

