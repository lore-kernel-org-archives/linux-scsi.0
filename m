From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 08/18] [PATCH] zfcp: Send ELS ADISC from workqueue
Date: Mon, 02 Mar 2009 13:09:01 +0100
Message-ID: <20090302121003.072370000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:34898 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758749AbZCBMKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:10:07 -0500
Content-Disposition: inline; filename=707-zfcp-els-adisc.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Issue ELS ADISC requests from workqueue. This allows the link test
request to be sent when the request queue is full due to I/O load for
other remote ports. It also simplifies request queue locking,
zfcp_fsf_send_fcp_command_task is now the only function that has
interrupts disabled from the caller. This is also a prereq for the FC
passthrough support that issues ELS requests from userspace.

Acked-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    1 +
 drivers/s390/scsi/zfcp_def.h |    1 +
 drivers/s390/scsi/zfcp_ext.h |    1 +
 drivers/s390/scsi/zfcp_fc.c  |   28 ++++++++++++++++++----------
 drivers/s390/scsi/zfcp_fsf.c |   18 ++++++------------
 5 files changed, 27 insertions(+), 22 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-03-02 12:42:24.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-03-02 12:42:33.000000000 +0100
@@ -604,6 +604,7 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	init_waitqueue_head(&port->remove_wq);
 	INIT_LIST_HEAD(&port->unit_list_head);
 	INIT_WORK(&port->gid_pn_work, zfcp_erp_port_strategy_open_lookup);
+	INIT_WORK(&port->test_link_work, zfcp_fc_link_test_work);
 
 	port->adapter = adapter;
 	port->d_id = d_id;
--- a/drivers/s390/scsi/zfcp_def.h	2009-03-02 12:42:30.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2009-03-02 12:42:33.000000000 +0100
@@ -513,6 +513,7 @@ struct zfcp_port {
 	u32                    maxframe_size;
 	u32                    supported_classes;
 	struct work_struct     gid_pn_work;
+	struct work_struct     test_link_work;
 };
 
 struct zfcp_unit {
--- a/drivers/s390/scsi/zfcp_ext.h	2009-03-02 12:42:30.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-03-02 12:42:33.000000000 +0100
@@ -101,6 +101,7 @@ extern void zfcp_fc_incoming_els(struct 
 extern int zfcp_fc_ns_gid_pn(struct zfcp_erp_action *);
 extern void zfcp_fc_plogi_evaluate(struct zfcp_port *, struct fsf_plogi *);
 extern void zfcp_test_link(struct zfcp_port *);
+extern void zfcp_fc_link_test_work(struct work_struct *);
 extern void zfcp_fc_nameserver_init(struct zfcp_adapter *);
 
 /* zfcp_fsf.c */
--- a/drivers/s390/scsi/zfcp_fc.c	2009-03-02 12:42:22.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-03-02 12:42:33.000000000 +0100
@@ -421,19 +421,12 @@ static int zfcp_fc_adisc(struct zfcp_por
 	return zfcp_fsf_send_els(&adisc->els);
 }
 
-/**
- * zfcp_test_link - lightweight link test procedure
- * @port: port to be tested
- *
- * Test status of a link to a remote port using the ELS command ADISC.
- * If there is a problem with the remote port, error recovery steps
- * will be triggered.
- */
-void zfcp_test_link(struct zfcp_port *port)
+void zfcp_fc_link_test_work(struct work_struct *work)
 {
+	struct zfcp_port *port =
+		container_of(work, struct zfcp_port, test_link_work);
 	int retval;
 
-	zfcp_port_get(port);
 	retval = zfcp_fc_adisc(port);
 	if (retval == 0)
 		return;
@@ -444,6 +437,21 @@ void zfcp_test_link(struct zfcp_port *po
 		zfcp_erp_port_forced_reopen(port, 0, 65, NULL);
 }
 
+/**
+ * zfcp_test_link - lightweight link test procedure
+ * @port: port to be tested
+ *
+ * Test status of a link to a remote port using the ELS command ADISC.
+ * If there is a problem with the remote port, error recovery steps
+ * will be triggered.
+ */
+void zfcp_test_link(struct zfcp_port *port)
+{
+	zfcp_port_get(port);
+	if (!queue_work(zfcp_data.work_queue, &port->test_link_work))
+		zfcp_port_put(port);
+}
+
 static void zfcp_free_sg_env(struct zfcp_gpn_ft *gpn_ft, int buf_num)
 {
 	struct scatterlist *sg = &gpn_ft->sg_req;
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-03-02 12:42:30.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-03-02 12:42:33.000000000 +0100
@@ -647,14 +647,6 @@ static void zfcp_fsf_exchange_port_data_
 	}
 }
 
-static int zfcp_fsf_sbal_available(struct zfcp_adapter *adapter)
-{
-	if (atomic_read(&adapter->req_q.count) > 0)
-		return 1;
-	atomic_inc(&adapter->qdio_outb_full);
-	return 0;
-}
-
 static int zfcp_fsf_req_sbal_get(struct zfcp_adapter *adapter)
 	__releases(&adapter->req_q_lock)
 	__acquires(&adapter->req_q_lock)
@@ -1177,8 +1169,8 @@ int zfcp_fsf_send_els(struct zfcp_send_e
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		return -EBUSY;
 
-	spin_lock(&adapter->req_q_lock);
-	if (!zfcp_fsf_sbal_available(adapter))
+	spin_lock_bh(&adapter->req_q_lock);
+	if (zfcp_fsf_req_sbal_get(adapter))
 		goto out;
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_SEND_ELS,
 				  ZFCP_REQ_AUTO_CLEANUP, NULL);
@@ -1211,7 +1203,7 @@ int zfcp_fsf_send_els(struct zfcp_send_e
 failed_send:
 	zfcp_fsf_req_free(req);
 out:
-	spin_unlock(&adapter->req_q_lock);
+	spin_unlock_bh(&adapter->req_q_lock);
 	return ret;
 }
 
@@ -2325,8 +2317,10 @@ int zfcp_fsf_send_fcp_command_task(struc
 		return -EBUSY;
 
 	spin_lock(&adapter->req_q_lock);
-	if (!zfcp_fsf_sbal_available(adapter))
+	if (atomic_read(&adapter->req_q.count) <= 0) {
+		atomic_inc(&adapter->qdio_outb_full);
 		goto out;
+	}
 	req = zfcp_fsf_req_create(adapter, FSF_QTCB_FCP_CMND,
 				  ZFCP_REQ_AUTO_CLEANUP,
 				  adapter->pool.fsf_req_scsi);

