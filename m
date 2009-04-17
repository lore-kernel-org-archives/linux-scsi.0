From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 04/15] zfcp: Dont block zfcp_wq with scan
Date: Fri, 17 Apr 2009 15:08:04 +0200
Message-ID: <20090417131122.352227000@de.ibm.com>
References: <20090417130800.923944000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:38872 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258AbZDQNL1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 09:11:27 -0400
Content-Disposition: inline; filename=scsi-work.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

When running the scsi_scan from the zfcp workqueue and the target
device does not respond, the zfcp workqueue can block until the
scsi_scan hits a timeout. Move the work to the scsi host workqueue,
since this one is also used for the scan from the SCSI midlayer.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c  |    5 +---
 drivers/s390/scsi/zfcp_def.h  |    2 -
 drivers/s390/scsi/zfcp_erp.c  |   50 +++---------------------------------------
 drivers/s390/scsi/zfcp_ext.h  |    1 
 drivers/s390/scsi/zfcp_scsi.c |   17 ++++++++++++++
 5 files changed, 25 insertions(+), 50 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-04-17 15:03:21.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-04-17 15:03:35.000000000 +0200
@@ -97,9 +97,7 @@ static void __init zfcp_init_device_conf
 	ccw_device_set_online(adapter->ccw_device);
 
 	zfcp_erp_wait(adapter);
-	wait_event(adapter->erp_done_wqh,
-		   !(atomic_read(&unit->status) &
-				ZFCP_STATUS_UNIT_SCSI_WORK_PENDING));
+	flush_work(&unit->scsi_work);
 
 	down(&zfcp_data.config_sema);
 	zfcp_unit_put(unit);
@@ -279,6 +277,7 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 
 	atomic_set(&unit->refcount, 0);
 	init_waitqueue_head(&unit->remove_wq);
+	INIT_WORK(&unit->scsi_work, zfcp_scsi_scan);
 
 	unit->port = port;
 	unit->fcp_lun = fcp_lun;
--- a/drivers/s390/scsi/zfcp_def.h	2009-04-17 15:03:21.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_def.h	2009-04-17 15:03:35.000000000 +0200
@@ -255,7 +255,6 @@ enum zfcp_wka_status {
 /* logical unit status */
 #define ZFCP_STATUS_UNIT_SHARED			0x00000004
 #define ZFCP_STATUS_UNIT_READONLY		0x00000008
-#define ZFCP_STATUS_UNIT_SCSI_WORK_PENDING	0x00000020
 
 /* FSF request status (this does not have a common part) */
 #define ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT	0x00000002
@@ -530,6 +529,7 @@ struct zfcp_unit {
 	struct zfcp_erp_action erp_action;     /* pending error recovery */
         atomic_t               erp_counter;
 	struct zfcp_latencies	latencies;
+	struct work_struct	scsi_work;
 };
 
 /* FSF request */
--- a/drivers/s390/scsi/zfcp_erp.c	2009-04-17 15:03:21.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-04-17 15:03:35.000000000 +0200
@@ -1176,48 +1176,6 @@ static void zfcp_erp_action_dequeue(stru
 	}
 }
 
-struct zfcp_erp_add_work {
-	struct zfcp_unit  *unit;
-	struct work_struct work;
-};
-
-static void zfcp_erp_scsi_scan(struct work_struct *work)
-{
-	struct zfcp_erp_add_work *p =
-		container_of(work, struct zfcp_erp_add_work, work);
-	struct zfcp_unit *unit = p->unit;
-	struct fc_rport *rport = unit->port->rport;
-
-	if (rport && rport->port_state == FC_PORTSTATE_ONLINE)
-		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
-			 scsilun_to_int((struct scsi_lun *)&unit->fcp_lun), 0);
-	atomic_clear_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
-	zfcp_unit_put(unit);
-	wake_up(&unit->port->adapter->erp_done_wqh);
-	kfree(p);
-}
-
-static void zfcp_erp_schedule_work(struct zfcp_unit *unit)
-{
-	struct zfcp_erp_add_work *p;
-
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
-	if (!p) {
-		dev_err(&unit->port->adapter->ccw_device->dev,
-			"Registering unit 0x%016Lx on port 0x%016Lx failed\n",
-			(unsigned long long)unit->fcp_lun,
-			(unsigned long long)unit->port->wwpn);
-		return;
-	}
-
-	zfcp_unit_get(unit);
-	atomic_set_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
-	INIT_WORK(&p->work, zfcp_erp_scsi_scan);
-	p->unit = unit;
-	if (!queue_work(zfcp_data.work_queue, &p->work))
-		zfcp_unit_put(unit);
-}
-
 static void zfcp_erp_action_cleanup(struct zfcp_erp_action *act, int result)
 {
 	struct zfcp_adapter *adapter = act->adapter;
@@ -1226,11 +1184,11 @@ static void zfcp_erp_action_cleanup(stru
 
 	switch (act->action) {
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		flush_work(&port->rport_work);
 		if ((result == ZFCP_ERP_SUCCEEDED) && !unit->device) {
-			if (!(atomic_read(&unit->status) &
-			      ZFCP_STATUS_UNIT_SCSI_WORK_PENDING))
-				zfcp_erp_schedule_work(unit);
+			zfcp_unit_get(unit);
+			if (scsi_queue_work(unit->port->adapter->scsi_host,
+					    &unit->scsi_work) <= 0)
+				zfcp_unit_put(unit);
 		}
 		zfcp_unit_put(unit);
 		break;
--- a/drivers/s390/scsi/zfcp_ext.h	2009-04-17 15:03:21.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-04-17 15:03:35.000000000 +0200
@@ -158,6 +158,7 @@ extern void zfcp_scsi_rport_work(struct 
 extern void zfcp_scsi_schedule_rport_register(struct zfcp_port *);
 extern void zfcp_scsi_schedule_rport_block(struct zfcp_port *);
 extern void zfcp_scsi_schedule_rports_block(struct zfcp_adapter *);
+extern void zfcp_scsi_scan(struct work_struct *);
 
 /* zfcp_sysfs.c */
 extern struct attribute_group zfcp_sysfs_unit_attrs;
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-04-17 15:03:21.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-04-17 15:03:35.000000000 +0200
@@ -583,6 +583,23 @@ void zfcp_scsi_rport_work(struct work_st
 }
 
 
+void zfcp_scsi_scan(struct work_struct *work)
+{
+	struct zfcp_unit *unit = container_of(work, struct zfcp_unit,
+					      scsi_work);
+	struct fc_rport *rport;
+
+	flush_work(&unit->port->rport_work);
+	rport = unit->port->rport;
+
+	if (rport && rport->port_state == FC_PORTSTATE_ONLINE)
+		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
+				 scsilun_to_int((struct scsi_lun *)
+						&unit->fcp_lun), 0);
+
+	zfcp_unit_put(unit);
+}
+
 struct fc_function_template zfcp_transport_functions = {
 	.show_starget_port_id = 1,
 	.show_starget_port_name = 1,

