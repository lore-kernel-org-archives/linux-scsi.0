From: michaelc@cs.wisc.edu
Subject: [PATCH] be2iscsi: fix disconnection cleanup
Date: Wed,  9 Jun 2010 03:30:08 -0500
Message-ID: <1276072208-6863-1-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755585Ab0FII2C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jun 2010 04:28:02 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch fixes 4 bugs in the connection connect/disconnect
cleanup path.

1. If beiscsi_open_conn fails beiscsi_free_ep was always being
called, and if beiscsi_open_conn failed because beiscsi_get_cid
failed then we would free an unallocated cid.

2. If beiscsi_ep_connect failed due to a beiscsi_open_conn failure
it was leaking iscsi_endpoints.

3. beiscsi_ep_disconnect was leaking iscsi_endpoints.
beiscsi_ep_disconnect should free the iscsi_endpoint. We cannot
do it in beiscsi_conn_stop because that is only called for
iscsi connection cleanup. If beiscsi_ep_connect returns
success, but then the poll function fails or the connect
times out then beiscsi_ep_disconnect will be called to clean
up the ep. The conn_stop callout will not be called in that path.

4. beiscsi_conn_stop was freeing the iscsi_endpoint then accessing
it a couple lines later.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/be2iscsi/be_iscsi.c |  121 +++++++++++++++++---------------------
 drivers/scsi/be2iscsi/be_iscsi.h |    2 -
 drivers/scsi/be2iscsi/be_main.c  |    2 +-
 3 files changed, 55 insertions(+), 70 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index c3928cb..8727555 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -442,6 +442,31 @@ static int beiscsi_get_cid(struct beiscsi_hba *phba)
 }
 
 /**
+ * beiscsi_put_cid - Free the cid
+ * @phba: The phba for which the cid is being freed
+ * @cid: The cid to free
+ */
+static void beiscsi_put_cid(struct beiscsi_hba *phba, unsigned short cid)
+{
+	phba->avlbl_cids++;
+	phba->cid_array[phba->cid_free++] = cid;
+	if (phba->cid_free == phba->params.cxns_per_ctrl)
+		phba->cid_free = 0;
+}
+
+/**
+ * beiscsi_free_ep - free endpoint
+ * @ep:	pointer to iscsi endpoint structure
+ */
+static void beiscsi_free_ep(struct beiscsi_endpoint *beiscsi_ep)
+{
+	struct beiscsi_hba *phba = beiscsi_ep->phba;
+
+	beiscsi_put_cid(phba, beiscsi_ep->ep_cid);
+	beiscsi_ep->phba = NULL;
+}
+
+/**
  * beiscsi_open_conn - Ask FW to open a TCP connection
  * @ep:	endpoint to be used
  * @src_addr: The source IP address
@@ -475,7 +500,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 	if (beiscsi_ep->ep_cid > (phba->fw_config.iscsi_cid_start +
 				  phba->params.cxns_per_ctrl * 2)) {
 		SE_DEBUG(DBG_LVL_1, "Failed in allocate iscsi cid\n");
-		return ret;
+		goto free_ep;
 	}
 
 	beiscsi_ep->cid_vld = 0;
@@ -496,7 +521,7 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 				    " status = %d extd_status = %d \n",
 				    status, extd_status);
 		free_mcc_tag(&phba->ctrl, tag);
-		return -1;
+		goto free_ep;
 	} else {
 		wrb = queue_get_wrb(mccq, wrb_num);
 		free_mcc_tag(&phba->ctrl, tag);
@@ -508,31 +533,10 @@ static int beiscsi_open_conn(struct iscsi_endpoint *ep,
 		SE_DEBUG(DBG_LVL_8, "mgmt_open_connection Success\n");
 	}
 	return 0;
-}
-
-/**
- * beiscsi_put_cid - Free the cid
- * @phba: The phba for which the cid is being freed
- * @cid: The cid to free
- */
-static void beiscsi_put_cid(struct beiscsi_hba *phba, unsigned short cid)
-{
-	phba->avlbl_cids++;
-	phba->cid_array[phba->cid_free++] = cid;
-	if (phba->cid_free == phba->params.cxns_per_ctrl)
-		phba->cid_free = 0;
-}
-
-/**
- * beiscsi_free_ep - free endpoint
- * @ep:	pointer to iscsi endpoint structure
- */
-static void beiscsi_free_ep(struct beiscsi_endpoint *beiscsi_ep)
-{
-	struct beiscsi_hba *phba = beiscsi_ep->phba;
 
-	beiscsi_put_cid(phba, beiscsi_ep->ep_cid);
-	beiscsi_ep->phba = NULL;
+free_ep:
+	beiscsi_free_ep(beiscsi_ep);
+	return -1;
 }
 
 /**
@@ -585,7 +589,7 @@ beiscsi_ep_connect(struct Scsi_Host *shost, struct sockaddr *dst_addr,
 	return ep;
 
 free_ep:
-	beiscsi_free_ep(beiscsi_ep);
+	iscsi_destroy_endpoint(ep);
 	return ERR_PTR(ret);
 }
 
@@ -632,30 +636,6 @@ static int beiscsi_close_conn(struct  beiscsi_endpoint *beiscsi_ep, int flag)
 }
 
 /**
- * beiscsi_ep_disconnect - Tears down the TCP connection
- * @ep:	endpoint to be used
- *
- * Tears down the TCP connection
- */
-void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
-{
-	struct beiscsi_conn *beiscsi_conn;
-	struct beiscsi_endpoint *beiscsi_ep;
-	struct beiscsi_hba *phba;
-
-	beiscsi_ep = ep->dd_data;
-	phba = beiscsi_ep->phba;
-	SE_DEBUG(DBG_LVL_8, "In beiscsi_ep_disconnect for ep_cid = %d\n",
-			     beiscsi_ep->ep_cid);
-
-	if (beiscsi_ep->conn) {
-		beiscsi_conn = beiscsi_ep->conn;
-		iscsi_suspend_queue(beiscsi_conn->conn);
-	}
-
-}
-
-/**
  * beiscsi_unbind_conn_to_cid - Unbind the beiscsi_conn from phba conn table
  * @phba: The phba instance
  * @cid: The cid to free
@@ -673,28 +653,35 @@ static int beiscsi_unbind_conn_to_cid(struct beiscsi_hba *phba,
 }
 
 /**
- * beiscsi_conn_stop - Invalidate and stop the connection
- * @cls_conn: pointer to get iscsi_conn
- * @flag: The type of connection closure
+ * beiscsi_ep_disconnect - Tears down the TCP connection
+ * @ep:	endpoint to be used
+ *
+ * Tears down the TCP connection
  */
-void beiscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
+void beiscsi_ep_disconnect(struct iscsi_endpoint *ep)
 {
-	struct iscsi_conn *conn = cls_conn->dd_data;
-	struct beiscsi_conn *beiscsi_conn = conn->dd_data;
+	struct beiscsi_conn *beiscsi_conn;
 	struct beiscsi_endpoint *beiscsi_ep;
-	struct iscsi_session *session = conn->session;
-	struct Scsi_Host *shost = iscsi_session_to_shost(session->cls_session);
-	struct beiscsi_hba *phba = iscsi_host_priv(shost);
+	struct beiscsi_hba *phba;
 	unsigned int tag;
 	unsigned short savecfg_flag = CMD_ISCSI_SESSION_SAVE_CFG_ON_FLASH;
 
-	beiscsi_ep = beiscsi_conn->ep;
-	if (!beiscsi_ep) {
-		SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_stop , no beiscsi_ep\n");
+	beiscsi_ep = ep->dd_data;
+	phba = beiscsi_ep->phba;
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_ep_disconnect for ep_cid = %d\n",
+			     beiscsi_ep->ep_cid);
+
+	if (!beiscsi_ep->conn) {
+		SE_DEBUG(DBG_LVL_8, "In beiscsi_ep_disconnect, no "
+			 "beiscsi_ep\n");
 		return;
 	}
-	SE_DEBUG(DBG_LVL_8, "In beiscsi_conn_stop  ep_cid = %d\n",
-			     beiscsi_ep->ep_cid);
+	beiscsi_conn = beiscsi_ep->conn;
+	iscsi_suspend_queue(beiscsi_conn->conn);
+	
+	SE_DEBUG(DBG_LVL_8, "In beiscsi_ep_disconnect ep_cid = %d\n",
+		 beiscsi_ep->ep_cid);
+
 	tag = mgmt_invalidate_connection(phba, beiscsi_ep,
 					    beiscsi_ep->ep_cid, 1,
 					    savecfg_flag);
@@ -707,9 +694,9 @@ void beiscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag)
 					 phba->ctrl.mcc_numtag[tag]);
 		free_mcc_tag(&phba->ctrl, tag);
 	}
+
 	beiscsi_close_conn(beiscsi_ep, CONNECTION_UPLOAD_GRACEFUL);
 	beiscsi_free_ep(beiscsi_ep);
-	iscsi_destroy_endpoint(beiscsi_ep->openiscsi_ep);
 	beiscsi_unbind_conn_to_cid(phba, beiscsi_ep->ep_cid);
-	iscsi_conn_stop(cls_conn, flag);
+	iscsi_destroy_endpoint(beiscsi_ep->openiscsi_ep);
 }
diff --git a/drivers/scsi/be2iscsi/be_iscsi.h b/drivers/scsi/be2iscsi/be_iscsi.h
index 1f512c2..870cdb2 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.h
+++ b/drivers/scsi/be2iscsi/be_iscsi.h
@@ -59,8 +59,6 @@ int beiscsi_set_param(struct iscsi_cls_conn *cls_conn,
 
 int beiscsi_conn_start(struct iscsi_cls_conn *cls_conn);
 
-void beiscsi_conn_stop(struct iscsi_cls_conn *cls_conn, int flag);
-
 struct iscsi_endpoint *beiscsi_ep_connect(struct Scsi_Host *shost,
 					  struct sockaddr *dst_addr,
 					  int non_blocking);
diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index dd5b105..8544145 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -3955,7 +3955,7 @@ struct iscsi_transport beiscsi_iscsi_transport = {
 	.get_session_param = iscsi_session_get_param,
 	.get_host_param = beiscsi_get_host_param,
 	.start_conn = beiscsi_conn_start,
-	.stop_conn = beiscsi_conn_stop,
+	.stop_conn = iscsi_conn_stop,
 	.send_pdu = iscsi_conn_send_pdu,
 	.xmit_task = beiscsi_task_xmit,
 	.cleanup_task = beiscsi_cleanup_task,
-- 
1.6.6.1

