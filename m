From: michaelc@cs.wisc.edu
Subject: [PATCH 2/7] libiscsi: Support drivers initiating session removal
Date: Wed, 24 Sep 2008 11:46:10 -0500
Message-ID: <1222274775-8834-3-git-send-email-michaelc@cs.wisc.edu>
References: <1222274775-8834-1-git-send-email-michaelc@cs.wisc.edu>
 <1222274775-8834-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:53705 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbYIXQqa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Sep 2008 12:46:30 -0400
In-Reply-To: <1222274775-8834-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

If the driver knows when hardware is removed like with cxgb3i,
bnx2i, qla4xxx and iser then we will want to remove the sessions/devices
that are bound to that device before removing the host.

cxgb3i and in the future bnx2i will remove the host and that will
remove all the sessions on the hba. iser can call iscsi_kill_session
when it gets an event that indicates that a hca is removed.
And when qla4xxx is hooked in to the lib (it is only hooked into
the class right now) it can call iscsi remove host like the
partial offload card drivers.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c |    1 +
 drivers/scsi/iscsi_tcp.c                 |    1 +
 drivers/scsi/libiscsi.c                  |  107 +++++++++++++++++++++++++++--
 drivers/scsi/qla4xxx/ql4_os.c            |    2 +-
 drivers/scsi/scsi_transport_iscsi.c      |    6 +-
 include/scsi/iscsi_if.h                  |    1 +
 include/scsi/libiscsi.h                  |   13 ++++
 include/scsi/scsi_transport_iscsi.h      |    3 +-
 8 files changed, 121 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 5a1cf25..0474da1 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -378,6 +378,7 @@ static void iscsi_iser_session_destroy(struct iscsi_cls_session *cls_session)
 {
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 
+	iscsi_session_teardown(cls_session);
 	iscsi_host_remove(shost);
 	iscsi_host_free(shost);
 }
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index e960f00..752f428 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -1885,6 +1885,7 @@ static void iscsi_tcp_session_destroy(struct iscsi_cls_session *cls_session)
 	struct Scsi_Host *shost = iscsi_session_to_shost(cls_session);
 
 	iscsi_r2tpool_free(cls_session->dd_data);
+	iscsi_session_teardown(cls_session);
 
 	iscsi_host_remove(shost);
 	iscsi_host_free(shost);
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f9539af..3907818 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -983,6 +983,38 @@ struct iscsi_task *iscsi_itt_to_ctask(struct iscsi_conn *conn, itt_t itt)
 }
 EXPORT_SYMBOL_GPL(iscsi_itt_to_ctask);
 
+void iscsi_session_failure(struct iscsi_cls_session *cls_session,
+			   enum iscsi_err err)
+{
+	struct iscsi_session *session = cls_session->dd_data;
+	struct iscsi_conn *conn;
+	struct device *dev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&session->lock, flags);
+	conn = session->leadconn;
+	if (session->state == ISCSI_STATE_TERMINATE || !conn) {
+		spin_unlock_irqrestore(&session->lock, flags);
+		return;
+	}
+
+	dev = get_device(&conn->cls_conn->dev);
+	spin_unlock_irqrestore(&session->lock, flags);
+	if (!dev)
+	        return;
+	/*
+	 * if the host is being removed bypass the connection
+	 * recovery initialization because we are going to kill
+	 * the session.
+	 */
+	if (err == ISCSI_ERR_INVALID_HOST)
+		iscsi_conn_error_event(conn->cls_conn, err);
+	else
+		iscsi_conn_failure(conn, err);
+	put_device(dev);
+}
+EXPORT_SYMBOL_GPL(iscsi_session_failure);
+
 void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
 {
 	struct iscsi_session *session = conn->session;
@@ -997,9 +1029,10 @@ void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err)
 	if (conn->stop_stage == 0)
 		session->state = ISCSI_STATE_FAILED;
 	spin_unlock_irqrestore(&session->lock, flags);
+
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_rx);
-	iscsi_conn_error(conn->cls_conn, err);
+	iscsi_conn_error_event(conn->cls_conn, err);
 }
 EXPORT_SYMBOL_GPL(iscsi_conn_failure);
 
@@ -1905,6 +1938,7 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 				   int dd_data_size, uint16_t qdepth)
 {
 	struct Scsi_Host *shost;
+	struct iscsi_host *ihost;
 
 	shost = scsi_host_alloc(sht, sizeof(struct iscsi_host) + dd_data_size);
 	if (!shost)
@@ -1919,22 +1953,43 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 		qdepth = ISCSI_DEF_CMD_PER_LUN;
 	}
 	shost->cmd_per_lun = qdepth;
+
+	ihost = shost_priv(shost);
+	spin_lock_init(&ihost->lock);
+	ihost->state = ISCSI_HOST_SETUP;
+	ihost->num_sessions = 0;
+	init_waitqueue_head(&ihost->session_removal_wq);
 	return shost;
 }
 EXPORT_SYMBOL_GPL(iscsi_host_alloc);
 
+static void iscsi_notify_host_removed(struct iscsi_cls_session *cls_session)
+{
+	iscsi_session_failure(cls_session, ISCSI_ERR_INVALID_HOST);
+}
+
 /**
  * iscsi_host_remove - remove host and sessions
  * @shost: scsi host
  *
- * This will also remove any sessions attached to the host, but if userspace
- * is managing the session at the same time this will break. TODO: add
- * refcounting to the netlink iscsi interface so a rmmod or host hot unplug
- * does not remove the memory from under us.
+ * If there are any sessions left, this will initiate the removal and wait
+ * for the completion.
  */
 void iscsi_host_remove(struct Scsi_Host *shost)
 {
-	iscsi_host_for_each_session(shost, iscsi_session_teardown);
+	struct iscsi_host *ihost = shost_priv(shost);
+	unsigned long flags;
+
+	spin_lock_irqsave(&ihost->lock, flags);
+	ihost->state = ISCSI_HOST_REMOVED;
+	spin_unlock_irqrestore(&ihost->lock, flags);
+
+	iscsi_host_for_each_session(shost, iscsi_notify_host_removed);
+	wait_event_interruptible(ihost->session_removal_wq,
+				 ihost->num_sessions == 0);
+	if (signal_pending(current))
+		flush_signals(current);
+
 	scsi_remove_host(shost);
 }
 EXPORT_SYMBOL_GPL(iscsi_host_remove);
@@ -1950,6 +2005,27 @@ void iscsi_host_free(struct Scsi_Host *shost)
 }
 EXPORT_SYMBOL_GPL(iscsi_host_free);
 
+static void iscsi_host_dec_session_cnt(struct Scsi_Host *shost)
+{
+	struct iscsi_host *ihost = shost_priv(shost);
+	unsigned long flags;
+
+	shost = scsi_host_get(shost);
+	if (!shost) {
+		printk(KERN_ERR "Invalid state. Cannot notify host removal "
+		      "of session teardown event because host already "
+		      "removed.\n");
+		return;
+	}
+
+	spin_lock_irqsave(&ihost->lock, flags);
+	ihost->num_sessions--;
+	if (ihost->num_sessions == 0)
+		wake_up(&ihost->session_removal_wq);
+	spin_unlock_irqrestore(&ihost->lock, flags);
+	scsi_host_put(shost);
+}
+
 /**
  * iscsi_session_setup - create iscsi cls session and host and session
  * @iscsit: iscsi transport template
@@ -1970,9 +2046,19 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 		    uint16_t cmds_max, int cmd_task_size,
 		    uint32_t initial_cmdsn, unsigned int id)
 {
+	struct iscsi_host *ihost = shost_priv(shost);
 	struct iscsi_session *session;
 	struct iscsi_cls_session *cls_session;
 	int cmd_i, scsi_cmds, total_cmds = cmds_max;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ihost->lock, flags);
+	if (ihost->state == ISCSI_HOST_REMOVED) {
+		spin_unlock_irqrestore(&ihost->lock, flags);
+		return NULL;
+	}
+	ihost->num_sessions++;
+	spin_unlock_irqrestore(&ihost->lock, flags);
 
 	if (!total_cmds)
 		total_cmds = ISCSI_DEF_XMIT_CMDS_MAX;
@@ -1985,7 +2071,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 		printk(KERN_ERR "iscsi: invalid can_queue of %d. can_queue "
 		       "must be a power of two that is at least %d.\n",
 		       total_cmds, ISCSI_TOTAL_CMDS_MIN);
-		return NULL;
+		goto dec_session_count;
 	}
 
 	if (total_cmds > ISCSI_TOTAL_CMDS_MAX) {
@@ -2009,7 +2095,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 	cls_session = iscsi_alloc_session(shost, iscsit,
 					  sizeof(struct iscsi_session));
 	if (!cls_session)
-		return NULL;
+		goto dec_session_count;
 	session = cls_session->dd_data;
 	session->cls_session = cls_session;
 	session->host = shost;
@@ -2048,6 +2134,7 @@ iscsi_session_setup(struct iscsi_transport *iscsit, struct Scsi_Host *shost,
 
 	if (iscsi_add_session(cls_session, id))
 		goto cls_session_fail;
+
 	return cls_session;
 
 cls_session_fail:
@@ -2056,6 +2143,8 @@ module_get_fail:
 	iscsi_pool_free(&session->cmdpool);
 cmdpool_alloc_fail:
 	iscsi_free_session(cls_session);
+dec_session_count:
+	iscsi_host_dec_session_cnt(shost);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_session_setup);
@@ -2071,6 +2160,7 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 {
 	struct iscsi_session *session = cls_session->dd_data;
 	struct module *owner = cls_session->transport->owner;
+	struct Scsi_Host *shost = session->host;
 
 	iscsi_pool_free(&session->cmdpool);
 
@@ -2083,6 +2173,7 @@ void iscsi_session_teardown(struct iscsi_cls_session *cls_session)
 	kfree(session->ifacename);
 
 	iscsi_destroy_session(cls_session);
+	iscsi_host_dec_session_cnt(shost);
 	module_put(owner);
 }
 EXPORT_SYMBOL_GPL(iscsi_session_teardown);
diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index 4255b36..db7ea3b 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -353,7 +353,7 @@ void qla4xxx_mark_device_missing(struct scsi_qla_host *ha,
 		      ha->host_no, ddb_entry->bus, ddb_entry->target,
 		      ddb_entry->fw_ddb_index));
 	iscsi_block_session(ddb_entry->sess);
-	iscsi_conn_error(ddb_entry->conn, ISCSI_ERR_CONN_FAILED);
+	iscsi_conn_error_event(ddb_entry->conn, ISCSI_ERR_CONN_FAILED);
 }
 
 static struct srb* qla4xxx_get_new_srb(struct scsi_qla_host *ha,
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index cbaae48..f9e45f8 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -1010,7 +1010,7 @@ int iscsi_recv_pdu(struct iscsi_cls_conn *conn, struct iscsi_hdr *hdr,
 
 	skb = alloc_skb(len, GFP_ATOMIC);
 	if (!skb) {
-		iscsi_conn_error(conn, ISCSI_ERR_CONN_FAILED);
+		iscsi_conn_error_event(conn, ISCSI_ERR_CONN_FAILED);
 		iscsi_cls_conn_printk(KERN_ERR, conn, "can not deliver "
 				      "control PDU: OOM\n");
 		return -ENOMEM;
@@ -1031,7 +1031,7 @@ int iscsi_recv_pdu(struct iscsi_cls_conn *conn, struct iscsi_hdr *hdr,
 }
 EXPORT_SYMBOL_GPL(iscsi_recv_pdu);
 
-void iscsi_conn_error(struct iscsi_cls_conn *conn, enum iscsi_err error)
+void iscsi_conn_error_event(struct iscsi_cls_conn *conn, enum iscsi_err error)
 {
 	struct nlmsghdr	*nlh;
 	struct sk_buff	*skb;
@@ -1063,7 +1063,7 @@ void iscsi_conn_error(struct iscsi_cls_conn *conn, enum iscsi_err error)
 	iscsi_cls_conn_printk(KERN_INFO, conn, "detected conn error (%d)\n",
 			      error);
 }
-EXPORT_SYMBOL_GPL(iscsi_conn_error);
+EXPORT_SYMBOL_GPL(iscsi_conn_error_event);
 
 static int
 iscsi_if_send_reply(int pid, int seq, int type, int done, int multi,
diff --git a/include/scsi/iscsi_if.h b/include/scsi/iscsi_if.h
index 16be12f..f274d24 100644
--- a/include/scsi/iscsi_if.h
+++ b/include/scsi/iscsi_if.h
@@ -213,6 +213,7 @@ enum iscsi_err {
 	ISCSI_ERR_DATA_DGST		= ISCSI_ERR_BASE + 15,
 	ISCSI_ERR_PARAM_NOT_FOUND	= ISCSI_ERR_BASE + 16,
 	ISCSI_ERR_NO_SCSI_CMD		= ISCSI_ERR_BASE + 17,
+	ISCSI_ERR_INVALID_HOST		= ISCSI_ERR_BASE + 18,
 };
 
 /*
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 5e75bb7..7d8cd15 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -287,6 +287,11 @@ struct iscsi_session {
 	struct iscsi_pool	cmdpool;	/* PDU's pool */
 };
 
+enum {
+	ISCSI_HOST_SETUP,
+	ISCSI_HOST_REMOVED,
+};
+
 struct iscsi_host {
 	char			*initiatorname;
 	/* hw address or netdev iscsi connection is bound to */
@@ -295,6 +300,12 @@ struct iscsi_host {
 	/* local address */
 	int			local_port;
 	char			local_address[ISCSI_ADDRESS_BUF_LEN];
+
+	wait_queue_head_t	session_removal_wq;
+	/* protects sessions and state */
+	spinlock_t		lock;
+	int			num_sessions;
+	int			state;
 };
 
 /*
@@ -351,6 +362,8 @@ extern void iscsi_conn_stop(struct iscsi_cls_conn *, int);
 extern int iscsi_conn_bind(struct iscsi_cls_session *, struct iscsi_cls_conn *,
 			   int);
 extern void iscsi_conn_failure(struct iscsi_conn *conn, enum iscsi_err err);
+extern void iscsi_session_failure(struct iscsi_cls_session *cls_session,
+				  enum iscsi_err err);
 extern int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 				enum iscsi_param param, char *buf);
 extern void iscsi_suspend_tx(struct iscsi_conn *conn);
diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
index 8b6c91d..8749d4d 100644
--- a/include/scsi/scsi_transport_iscsi.h
+++ b/include/scsi/scsi_transport_iscsi.h
@@ -135,7 +135,8 @@ extern int iscsi_unregister_transport(struct iscsi_transport *tt);
 /*
  * control plane upcalls
  */
-extern void iscsi_conn_error(struct iscsi_cls_conn *conn, enum iscsi_err error);
+extern void iscsi_conn_error_event(struct iscsi_cls_conn *conn,
+				   enum iscsi_err error);
 extern int iscsi_recv_pdu(struct iscsi_cls_conn *conn, struct iscsi_hdr *hdr,
 			  char *data, uint32_t data_size);
 
-- 
1.5.4.1

