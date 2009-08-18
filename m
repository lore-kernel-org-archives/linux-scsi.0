From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 07/27] zfcp: Implicitly close all wka ports
Date: Tue, 18 Aug 2009 15:43:12 +0200
Message-ID: <20090818135029.664135000@de.ibm.com>
References: <20090818134305.841868000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:56312 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007AbZHRNuj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2009 09:50:39 -0400
Content-Disposition: inline; filename=708-zfcp-close-wka-ports.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

An adapter shutdown implicitly closes all open ports. Make sure to
mark all WKA ports as offline, not only the directory server. Also
make sure that no pending wka port work is running when the adapter is
being removed.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |    1 +
 drivers/s390/scsi/zfcp_erp.c |    2 +-
 drivers/s390/scsi/zfcp_ext.h |    4 +---
 drivers/s390/scsi/zfcp_fc.c  |   11 ++++++++++-
 4 files changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:29:05.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-08-17 11:29:13.000000000 +0200
@@ -555,6 +555,7 @@ void zfcp_adapter_dequeue(struct zfcp_ad
 
 	cancel_work_sync(&adapter->scan_work);
 	cancel_work_sync(&adapter->stat_work);
+	zfcp_fc_wka_ports_force_offline(adapter->gs);
 	zfcp_adapter_scsi_unregister(adapter);
 	sysfs_remove_group(&adapter->ccw_device->dev.kobj,
 			   &zfcp_sysfs_adapter_attrs);
--- a/drivers/s390/scsi/zfcp_erp.c	2009-08-17 11:28:54.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-08-17 11:29:13.000000000 +0200
@@ -714,7 +714,7 @@ static void zfcp_erp_adapter_strategy_cl
 	zfcp_qdio_close(adapter);
 	zfcp_fsf_req_dismiss_all(adapter);
 	adapter->fsf_req_seq_no = 0;
-	zfcp_fc_wka_port_force_offline(&adapter->gs->ds);
+	zfcp_fc_wka_ports_force_offline(adapter->gs);
 	/* all ports and units are closed */
 	zfcp_erp_modify_adapter_status(adapter, "erascl1", NULL,
 				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
--- a/drivers/s390/scsi/zfcp_ext.h	2009-08-17 11:29:09.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-08-17 11:29:13.000000000 +0200
@@ -104,12 +104,10 @@ extern int zfcp_fc_ns_gid_pn(struct zfcp
 extern void zfcp_fc_plogi_evaluate(struct zfcp_port *, struct fsf_plogi *);
 extern void zfcp_test_link(struct zfcp_port *);
 extern void zfcp_fc_link_test_work(struct work_struct *);
-extern void zfcp_fc_wka_port_force_offline(struct zfcp_wka_port *);
+extern void zfcp_fc_wka_ports_force_offline(struct zfcp_wka_ports *);
 extern void zfcp_fc_wka_ports_init(struct zfcp_adapter *);
 extern int zfcp_fc_execute_els_fc_job(struct fc_bsg_job *);
 extern int zfcp_fc_execute_ct_fc_job(struct fc_bsg_job *);
-extern void zfcp_fc_wka_port_force_offline(struct zfcp_wka_port *);
-
 
 /* zfcp_fsf.c */
 extern int zfcp_fsf_open_port(struct zfcp_erp_action *);
--- a/drivers/s390/scsi/zfcp_fc.c	2009-08-17 11:29:12.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-08-17 11:29:13.000000000 +0200
@@ -132,7 +132,7 @@ static void zfcp_fc_wka_port_init(struct
 	INIT_DELAYED_WORK(&wka_port->work, zfcp_wka_port_offline);
 }
 
-void zfcp_fc_wka_port_force_offline(struct zfcp_wka_port *wka)
+static void zfcp_fc_wka_port_force_offline(struct zfcp_wka_port *wka)
 {
 	cancel_delayed_work_sync(&wka->work);
 	mutex_lock(&wka->mutex);
@@ -140,6 +140,15 @@ void zfcp_fc_wka_port_force_offline(stru
 	mutex_unlock(&wka->mutex);
 }
 
+void zfcp_fc_wka_ports_force_offline(struct zfcp_wka_ports *gs)
+{
+	zfcp_fc_wka_port_force_offline(&gs->ms);
+	zfcp_fc_wka_port_force_offline(&gs->ts);
+	zfcp_fc_wka_port_force_offline(&gs->ds);
+	zfcp_fc_wka_port_force_offline(&gs->as);
+	zfcp_fc_wka_port_force_offline(&gs->ks);
+}
+
 void zfcp_fc_wka_ports_init(struct zfcp_adapter *adapter)
 {
 	struct zfcp_wka_ports *gs = adapter->gs;

