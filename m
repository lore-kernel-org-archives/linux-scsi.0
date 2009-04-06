From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/2] zfcp: Set WKA-port to offline on adapter deactivation
Date: Mon, 06 Apr 2009 18:31:46 +0200
Message-ID: <20090406163534.533486000@de.ibm.com>
References: <20090406163145.686874000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:56991 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855AbZDFQgF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 12:36:05 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate8.de.ibm.com (8.14.3/8.13.8) with ESMTP id n36GZZgf572866
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 16:35:35 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n36GZZLs4129008
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 18:35:35 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n36GZYGH026305
	for <linux-scsi@vger.kernel.org>; Mon, 6 Apr 2009 18:35:35 +0200
Content-Disposition: inline; filename=704-zfcp-wka-port.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Sven Schuetz <sven@linux.vnet.ibm.com>, James.Smart@Emulex.Com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The nameserver port might be in state online when the adapter is
offlined. On adapter reactivation the nameserver port is not
re-opened due to the PORT_ONLINE status. This results in an
unsuccessful recovery. In forcing the nameserver port status 
to offline on all adapter offline events this issue is prevented.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    3 ++-
 drivers/s390/scsi/zfcp_ccw.c |    1 -
 drivers/s390/scsi/zfcp_erp.c |    1 +
 drivers/s390/scsi/zfcp_ext.h |    1 +
 drivers/s390/scsi/zfcp_fc.c  |   16 ++++++++++------
 5 files changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-04-06 17:20:50.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-04-06 17:22:14.000000000 +0200
@@ -525,6 +525,8 @@ int zfcp_adapter_enqueue(struct ccw_devi
 
 	atomic_clear_mask(ZFCP_STATUS_COMMON_REMOVE, &adapter->status);
 
+	zfcp_fc_nameserver_init(adapter);
+
 	if (!zfcp_adapter_scsi_register(adapter))
 		return 0;
 
@@ -553,7 +555,6 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 
 	cancel_work_sync(&adapter->scan_work);
 	cancel_work_sync(&adapter->stat_work);
-	cancel_delayed_work_sync(&adapter->nsp.work);
 	zfcp_adapter_scsi_unregister(adapter);
 	sysfs_remove_group(&adapter->ccw_device->dev.kobj,
 			   &zfcp_sysfs_adapter_attrs);
--- a/drivers/s390/scsi/zfcp_ccw.c	2009-04-06 17:20:50.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ccw.c	2009-04-06 17:22:14.000000000 +0200
@@ -108,7 +108,6 @@ static int zfcp_ccw_set_online(struct cc
 	/* initialize request counter */
 	BUG_ON(!zfcp_reqlist_isempty(adapter));
 	adapter->req_no = 0;
-	zfcp_fc_nameserver_init(adapter);
 
 	zfcp_erp_modify_adapter_status(adapter, "ccsonl1", NULL,
 				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
--- a/drivers/s390/scsi/zfcp_erp.c	2009-04-06 17:07:10.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-04-06 17:22:14.000000000 +0200
@@ -719,6 +719,7 @@ static void zfcp_erp_adapter_strategy_cl
 	zfcp_qdio_close(adapter);
 	zfcp_fsf_req_dismiss_all(adapter);
 	adapter->fsf_req_seq_no = 0;
+	zfcp_fc_wka_port_force_offline(&adapter->nsp);
 	/* all ports and units are closed */
 	zfcp_erp_modify_adapter_status(adapter, "erascl1", NULL,
 				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
--- a/drivers/s390/scsi/zfcp_ext.h	2009-04-06 17:20:50.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-04-06 17:22:14.000000000 +0200
@@ -106,6 +106,7 @@ extern void zfcp_fc_plogi_evaluate(struc
 extern void zfcp_test_link(struct zfcp_port *);
 extern void zfcp_fc_link_test_work(struct work_struct *);
 extern void zfcp_fc_nameserver_init(struct zfcp_adapter *);
+extern void zfcp_fc_wka_port_force_offline(struct zfcp_wka_port *);
 
 /* zfcp_fsf.c */
 extern int zfcp_fsf_open_port(struct zfcp_erp_action *);
--- a/drivers/s390/scsi/zfcp_fc.c	2009-04-06 17:20:50.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-04-06 17:22:14.000000000 +0200
@@ -98,12 +98,8 @@ static void zfcp_wka_port_offline(struct
 	struct zfcp_wka_port *wka_port =
 			container_of(dw, struct zfcp_wka_port, work);
 
-	/* Don't wait forvever. If the wka_port is too busy take it offline
-	   through a new call later */
-	if (!wait_event_timeout(wka_port->completion_wq,
-				atomic_read(&wka_port->refcount) == 0,
-				HZ >> 1))
-		return;
+	wait_event(wka_port->completion_wq,
+		   atomic_read(&wka_port->refcount) == 0);
 
 	mutex_lock(&wka_port->mutex);
 	if ((atomic_read(&wka_port->refcount) != 0) ||
@@ -142,6 +138,14 @@ void zfcp_fc_nameserver_init(struct zfcp
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

