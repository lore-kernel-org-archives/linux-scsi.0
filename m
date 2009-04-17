From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 05/15] zfcp: Set WKA-port to offline on adapter deactivation
Date: Fri, 17 Apr 2009 15:08:05 +0200
Message-ID: <20090417131122.479956000@de.ibm.com>
References: <20090417130800.923944000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:43982 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbZDQNLY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 09:11:24 -0400
Content-Disposition: inline; filename=704.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The nameserver port might be in state online when the adapter is
offlined. On adapter reactivation the nameserver port is not
re-opened due to the PORT_ONLINE status. This results in an
unsuccessful recovery. In forcing the nameserver port status
to offline on all adapter offline events this issue is prevented.

Waiting for the reference count to drop to zero in
zfcp_wka_port_offline is not required, so remove it.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c |    3 ++-
 drivers/s390/scsi/zfcp_ccw.c |    1 -
 drivers/s390/scsi/zfcp_erp.c |    1 +
 drivers/s390/scsi/zfcp_ext.h |    1 +
 drivers/s390/scsi/zfcp_fc.c  |   15 ++++++++-------
 5 files changed, 12 insertions(+), 9 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-04-17 15:03:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-04-17 15:03:37.000000000 +0200
@@ -524,6 +524,8 @@ int zfcp_adapter_enqueue(struct ccw_devi
 
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
 
+	zfcp_fc_nameserver_init(adapter);
+
 	if (!zfcp_adapter_scsi_register(adapter))
 		return 0;
 
@@ -552,7 +554,6 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 
 	cancel_work_sync(&adapter->scan_work);
 	cancel_work_sync(&adapter->stat_work);
-	cancel_delayed_work_sync(&adapter->nsp.work);
 	zfcp_adapter_scsi_unregister(adapter);
 	sysfs_remove_group(&adapter->ccw_device->dev.kobj,
 			   &zfcp_sysfs_adapter_attrs);
--- a/drivers/s390/scsi/zfcp_ccw.c	2009-04-17 15:03:20.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ccw.c	2009-04-17 15:03:37.000000000 +0200
@@ -108,7 +108,6 @@ static int zfcp_ccw_set_online(struct cc
 	/* initialize request counter */
 	BUG_ON(!zfcp_reqlist_isempty(adapter));
 	adapter->req_no = 0;
-	zfcp_fc_nameserver_init(adapter);
 
 	zfcp_erp_modify_adapter_status(adapter, "ccsonl1", NULL,
 				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
--- a/drivers/s390/scsi/zfcp_erp.c	2009-04-17 15:03:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-04-17 15:03:37.000000000 +0200
@@ -719,6 +719,7 @@ static void zfcp_erp_adapter_strategy_cl
 	zfcp_qdio_close(adapter);
 	zfcp_fsf_req_dismiss_all(adapter);
 	adapter->fsf_req_seq_no = 0;
+	zfcp_fc_wka_port_force_offline(&adapter->nsp);
 	/* all ports and units are closed */
 	zfcp_erp_modify_adapter_status(adapter, "erascl1", NULL,
 				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
--- a/drivers/s390/scsi/zfcp_ext.h	2009-04-17 15:03:35.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-04-17 15:03:37.000000000 +0200
@@ -106,6 +106,7 @@ extern void zfcp_fc_plogi_evaluate(struc
 extern void zfcp_test_link(struct zfcp_port *);
 extern void zfcp_fc_link_test_work(struct work_struct *);
 extern void zfcp_fc_nameserver_init(struct zfcp_adapter *);
+extern void zfcp_fc_wka_port_force_offline(struct zfcp_wka_port *);
 
 /* zfcp_fsf.c */
 extern int zfcp_fsf_open_port(struct zfcp_erp_action *);
--- a/drivers/s390/scsi/zfcp_fc.c	2009-04-17 15:03:31.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-04-17 15:03:37.000000000 +0200
@@ -98,13 +98,6 @@ static void zfcp_wka_port_offline(struct
 	struct zfcp_wka_port *wka_port =
 			container_of(dw, struct zfcp_wka_port, work);
 
-	/* Don't wait forvever. If the wka_port is too busy take it offline
-	   through a new call later */
-	if (!wait_event_timeout(wka_port->completion_wq,
-				atomic_read(&wka_port->refcount) == 0,
-				HZ >> 1))
-		return;
-
 	mutex_lock(&wka_port->mutex);
 	if ((atomic_read(&wka_port->refcount) != 0) ||
 	    (wka_port->status != ZFCP_WKA_PORT_ONLINE))
@@ -142,6 +135,14 @@ void zfcp_fc_nameserver_init(struct zfcp
 	INIT_DELAYED_WORK(&wka_port->work, zfcp_wka_port_offline);
 }
 
+void zfcp_fc_wka_port_force_offline(struct zfcp_wka_port *wka)
+{
+	cancel_delayed_work_sync(&wka->work);
+	mutex_lock(&wka->mutex);
+	wka->status = ZFCP_WKA_PORT_OFFLINE;
+	mutex_unlock(&wka->mutex);
+}
+
 static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
 				   struct fcp_rscn_element *elem)
 {

