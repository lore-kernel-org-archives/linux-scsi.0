From: michaelc@cs.wisc.edu
Subject: [PATCH 09/14] iscsi lib: have lib create work queue for transmitting IO
Date: Thu,  5 Mar 2009 14:46:03 -0600
Message-ID: <12362859763502-git-send-email-michaelc@cs.wisc.edu>
References: <12362859683749-git-send-email-michaelc@cs.wisc.edu>
 <12362859693831-git-send-email-michaelc@cs.wisc.edu>
 <12362859702687-git-send-email-michaelc@cs.wisc.edu>
 <123628597367-git-send-email-michaelc@cs.wisc.edu>
 <12362859734023-git-send-email-michaelc@cs.wisc.edu>
 <12362859743025-git-send-email-michaelc@cs.wisc.edu>
 <12362859742776-git-send-email-michaelc@cs.wisc.edu>
 <12362859754088-git-send-email-michaelc@cs.wisc.edu>
 <1236285975607-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:52816 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754934AbZCEUqV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Mar 2009 15:46:21 -0500
In-Reply-To: <1236285975607-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

We were using the shost work queue which ended up being
a little akward since all iscsi hosts need a thread for
scanning, but only drivers hooked into libiscsi need
a workqueue for transmitting. So this patch moves the
xmit workqueue to the lib.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/infiniband/ulp/iser/iscsi_iser.c     |    2 +-
 drivers/infiniband/ulp/iser/iser_initiator.c |    2 +-
 drivers/scsi/cxgb3i/cxgb3i_iscsi.c           |    2 +-
 drivers/scsi/cxgb3i/cxgb3i_pdu.c             |    2 +-
 drivers/scsi/iscsi_tcp.c                     |    4 +-
 drivers/scsi/libiscsi.c                      |   45 ++++++++++++++++++++-----
 include/scsi/libiscsi.h                      |    7 +++-
 7 files changed, 48 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
index 5f79c0a..a50cd53 100644
--- a/drivers/infiniband/ulp/iser/iscsi_iser.c
+++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
@@ -404,7 +404,7 @@ iscsi_iser_session_create(struct iscsi_endpoint *ep,
 	struct Scsi_Host *shost;
 	struct iser_conn *ib_conn;
 
-	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, ISER_DEF_CMD_PER_LUN);
+	shost = iscsi_host_alloc(&iscsi_iser_sht, 0, ISER_DEF_CMD_PER_LUN, 1);
 	if (!shost)
 		return NULL;
 	shost->transportt = iscsi_iser_scsi_transport;
diff --git a/drivers/infiniband/ulp/iser/iser_initiator.c b/drivers/infiniband/ulp/iser/iser_initiator.c
index e209cb8..9de6402 100644
--- a/drivers/infiniband/ulp/iser/iser_initiator.c
+++ b/drivers/infiniband/ulp/iser/iser_initiator.c
@@ -661,7 +661,7 @@ void iser_snd_completion(struct iser_desc *tx_desc)
 
 	if (resume_tx) {
 		iser_dbg("%ld resuming tx\n",jiffies);
-		scsi_queue_work(conn->session->host, &conn->xmitwork);
+		iscsi_conn_queue_work(conn);
 	}
 
 	if (tx_desc->type == ISCSI_TX_CONTROL) {
diff --git a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
index fa2a44f..f6ed9c6 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_iscsi.c
@@ -171,7 +171,7 @@ struct cxgb3i_hba *cxgb3i_hba_host_add(struct cxgb3i_adapter *snic,
 
 	shost = iscsi_host_alloc(&cxgb3i_host_template,
 				 sizeof(struct cxgb3i_hba),
-				 CXGB3I_SCSI_QDEPTH_DFLT);
+				 CXGB3I_SCSI_QDEPTH_DFLT, 1);
 	if (!shost) {
 		cxgb3i_log_info("iscsi_host_alloc failed.\n");
 		return NULL;
diff --git a/drivers/scsi/cxgb3i/cxgb3i_pdu.c b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
index 17115c2..7eebc9a 100644
--- a/drivers/scsi/cxgb3i/cxgb3i_pdu.c
+++ b/drivers/scsi/cxgb3i/cxgb3i_pdu.c
@@ -479,7 +479,7 @@ void cxgb3i_conn_tx_open(struct s3_conn *c3cn)
 	cxgb3i_tx_debug("cn 0x%p.\n", c3cn);
 	if (conn) {
 		cxgb3i_tx_debug("cn 0x%p, cid %d.\n", c3cn, conn->id);
-		scsi_queue_work(conn->session->host, &conn->xmitwork);
+		iscsi_conn_queue_work(conn);
 	}
 }
 
diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
index 9c2e527..79a706a 100644
--- a/drivers/scsi/iscsi_tcp.c
+++ b/drivers/scsi/iscsi_tcp.c
@@ -166,7 +166,7 @@ static void iscsi_sw_tcp_write_space(struct sock *sk)
 
 	tcp_sw_conn->old_write_space(sk);
 	ISCSI_SW_TCP_DBG(conn, "iscsi_write_space\n");
-	scsi_queue_work(conn->session->host, &conn->xmitwork);
+	iscsi_conn_queue_work(conn);
 }
 
 static void iscsi_sw_tcp_conn_set_callbacks(struct iscsi_conn *conn)
@@ -777,7 +777,7 @@ iscsi_sw_tcp_session_create(struct iscsi_endpoint *ep, uint16_t cmds_max,
 		return NULL;
 	}
 
-	shost = iscsi_host_alloc(&iscsi_sw_tcp_sht, 0, qdepth);
+	shost = iscsi_host_alloc(&iscsi_sw_tcp_sht, 0, qdepth, 1);
 	if (!shost)
 		return NULL;
 	shost->transportt = iscsi_sw_tcp_scsi_transport;
diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index a5168a6..ff89154 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -76,6 +76,15 @@ static int iscsi_sna_lte(u32 n1, u32 n2)
 			    (n1 > n2 && (n2 - n1 < SNA32_CHECK)));
 }
 
+inline void iscsi_conn_queue_work(struct iscsi_conn *conn)
+{
+	struct Scsi_Host *shost = conn->session->host;
+	struct iscsi_host *ihost = shost_priv(shost);
+
+	queue_work(ihost->workq, &conn->xmitwork);
+}
+EXPORT_SYMBOL_GPL(iscsi_conn_queue_work);
+
 void
 iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
 {
@@ -103,8 +112,7 @@ iscsi_update_cmdsn(struct iscsi_session *session, struct iscsi_nopin *hdr)
 		if (!list_empty(&session->leadconn->xmitqueue) ||
 		    !list_empty(&session->leadconn->mgmtqueue)) {
 			if (!(session->tt->caps & CAP_DATA_PATH_OFFLOAD))
-				scsi_queue_work(session->host,
-						&session->leadconn->xmitwork);
+				iscsi_conn_queue_work(session->leadconn);
 		}
 	}
 }
@@ -586,7 +594,7 @@ __iscsi_conn_send_pdu(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			goto free_task;
 
 	} else
-		scsi_queue_work(conn->session->host, &conn->xmitwork);
+		iscsi_conn_queue_work(conn);
 
 	return task;
 
@@ -1160,7 +1168,7 @@ void iscsi_requeue_task(struct iscsi_task *task)
 	struct iscsi_conn *conn = task->conn;
 
 	list_move_tail(&task->running, &conn->requeue);
-	scsi_queue_work(conn->session->host, &conn->xmitwork);
+	iscsi_conn_queue_work(conn);
 }
 EXPORT_SYMBOL_GPL(iscsi_requeue_task);
 
@@ -1413,7 +1421,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 			goto prepd_reject;
 		}
 	} else
-		scsi_queue_work(session->host, &conn->xmitwork);
+		iscsi_conn_queue_work(conn);
 
 	session->queued_cmdsn++;
 	spin_unlock(&session->lock);
@@ -1631,9 +1639,12 @@ static void fail_all_commands(struct iscsi_conn *conn, unsigned lun,
 
 void iscsi_suspend_tx(struct iscsi_conn *conn)
 {
+	struct Scsi_Host *shost = conn->session->host;
+	struct iscsi_host *ihost = shost_priv(shost);
+
 	set_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	if (!(conn->session->tt->caps & CAP_DATA_PATH_OFFLOAD))
-		scsi_flush_work(conn->session->host);
+		flush_workqueue(ihost->workq);
 }
 EXPORT_SYMBOL_GPL(iscsi_suspend_tx);
 
@@ -1641,7 +1652,7 @@ static void iscsi_start_tx(struct iscsi_conn *conn)
 {
 	clear_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx);
 	if (!(conn->session->tt->caps & CAP_DATA_PATH_OFFLOAD))
-		scsi_queue_work(conn->session->host, &conn->xmitwork);
+		iscsi_conn_queue_work(conn);
 }
 
 static enum blk_eh_timer_return iscsi_eh_cmd_timed_out(struct scsi_cmnd *scmd)
@@ -2046,12 +2057,14 @@ EXPORT_SYMBOL_GPL(iscsi_host_add);
  * @sht: scsi host template
  * @dd_data_size: driver host data size
  * @qdepth: default device queue depth
+ * @xmit_can_sleep: bool indicating if LLD will queue IO from a work queue
  *
  * This should be called by partial offload and software iscsi drivers.
  * To access the driver specific memory use the iscsi_host_priv() macro.
  */
 struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
-				   int dd_data_size, uint16_t qdepth)
+				   int dd_data_size, uint16_t qdepth,
+				   bool xmit_can_sleep)
 {
 	struct Scsi_Host *shost;
 	struct iscsi_host *ihost;
@@ -2063,13 +2076,25 @@ struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
 	if (qdepth == 0)
 		qdepth = ISCSI_DEF_CMD_PER_LUN;
 	shost->cmd_per_lun = qdepth;
-
 	ihost = shost_priv(shost);
+
+	if (xmit_can_sleep) {
+		snprintf(ihost->workq_name, sizeof(ihost->workq_name),
+			"iscsi_q_%d", shost->host_no);
+		ihost->workq = create_singlethread_workqueue(ihost->workq_name);
+		if (!ihost->workq)
+			goto free_host;
+	}
+
 	spin_lock_init(&ihost->lock);
 	ihost->state = ISCSI_HOST_SETUP;
 	ihost->num_sessions = 0;
 	init_waitqueue_head(&ihost->session_removal_wq);
 	return shost;
+
+free_host:
+	scsi_host_put(shost);
+	return NULL;
 }
 EXPORT_SYMBOL_GPL(iscsi_host_alloc);
 
@@ -2101,6 +2126,8 @@ void iscsi_host_remove(struct Scsi_Host *shost)
 		flush_signals(current);
 
 	scsi_remove_host(shost);
+	if (ihost->workq)
+		destroy_workqueue(ihost->workq);
 }
 EXPORT_SYMBOL_GPL(iscsi_host_remove);
 
diff --git a/include/scsi/libiscsi.h b/include/scsi/libiscsi.h
index 898de4a..b0b8a69 100644
--- a/include/scsi/libiscsi.h
+++ b/include/scsi/libiscsi.h
@@ -318,6 +318,9 @@ struct iscsi_host {
 	spinlock_t		lock;
 	int			num_sessions;
 	int			state;
+
+	struct workqueue_struct	*workq;
+	char			workq_name[20];
 };
 
 /*
@@ -343,7 +346,8 @@ extern int iscsi_host_get_param(struct Scsi_Host *shost,
 				enum iscsi_host_param param, char *buf);
 extern int iscsi_host_add(struct Scsi_Host *shost, struct device *pdev);
 extern struct Scsi_Host *iscsi_host_alloc(struct scsi_host_template *sht,
-					  int dd_data_size, uint16_t qdepth);
+					  int dd_data_size, uint16_t qdepth,
+					  bool xmit_can_sleep);
 extern void iscsi_host_remove(struct Scsi_Host *shost);
 extern void iscsi_host_free(struct Scsi_Host *shost);
 
@@ -379,6 +383,7 @@ extern void iscsi_session_failure(struct iscsi_cls_session *cls_session,
 extern int iscsi_conn_get_param(struct iscsi_cls_conn *cls_conn,
 				enum iscsi_param param, char *buf);
 extern void iscsi_suspend_tx(struct iscsi_conn *conn);
+extern void iscsi_conn_queue_work(struct iscsi_conn *conn);
 
 #define iscsi_conn_printk(prefix, _c, fmt, a...) \
 	iscsi_cls_conn_printk(prefix, ((struct iscsi_conn *)_c)->cls_conn, \
-- 
1.6.0.6

