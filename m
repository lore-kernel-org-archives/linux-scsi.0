From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 15/18] [PATCH] zfcp: Block FC transport rports early on errors
Date: Mon, 02 Mar 2009 13:09:08 +0100
Message-ID: <20090302121004.041349000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.29.155]:54195 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbZCBMLF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:11:05 -0500
Content-Disposition: inline; filename=rport.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Use the I/O blocking mechanism in the FC transport class to allow
faster failovers for multipathing:
- Call fc_remote_port_delete early to set the rport to BLOCKED.
- Check the rport status in queuecommand with fc_remote_portchkready
  to no longer accept new I/O for this port and fail the I/O with the
  appropriate scsi_cmnd result.
- Implement the terminate_rport_io handler to abort all pending I/O
  requests
- Return SCSI commands with DID_TRANSPORT_DISRUPTED while erp is
  running.
- When updating the remote port status, check for late changes and
  update the remote ports status accordingly.

Acked-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
--- a/drivers/s390/scsi/zfcp_erp.c	2009-03-02 09:59:28.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-03-02 09:59:28.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * Error Recovery Procedures (ERP).
  *
- * Copyright IBM Corporation 2002, 2008
+ * Copyright IBM Corporation 2002, 2009
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -240,6 +240,7 @@ static int _zfcp_erp_adapter_reopen(stru
 				    int clear_mask, char *id, void *ref)
 {
 	zfcp_erp_adapter_block(adapter, clear_mask);
+	zfcp_scsi_schedule_rports_block(adapter);
 
 	/* ensure propagation of failed status to new devices */
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_ERP_FAILED) {
@@ -322,6 +323,7 @@ static void _zfcp_erp_port_forced_reopen
 					 int clear, char *id, void *ref)
 {
 	zfcp_erp_port_block(port, clear);
+	zfcp_scsi_schedule_rport_block(port);
 
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_ERP_FAILED)
 		return;
@@ -353,6 +355,7 @@ static int _zfcp_erp_port_reopen(struct 
 				 void *ref)
 {
 	zfcp_erp_port_block(port, clear);
+	zfcp_scsi_schedule_rport_block(port);
 
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_ERP_FAILED) {
 		/* ensure propagation of failed status to new devices */
@@ -1211,37 +1214,6 @@ static void zfcp_erp_schedule_work(struc
 	queue_work(zfcp_data.work_queue, &p->work);
 }
 
-static void zfcp_erp_rport_register(struct zfcp_port *port)
-{
-	struct fc_rport_identifiers ids;
-	ids.node_name = port->wwnn;
-	ids.port_name = port->wwpn;
-	ids.port_id = port->d_id;
-	ids.roles = FC_RPORT_ROLE_FCP_TARGET;
-	port->rport = fc_remote_port_add(port->adapter->scsi_host, 0, &ids);
-	if (!port->rport) {
-		dev_err(&port->adapter->ccw_device->dev,
-			"Registering port 0x%016Lx failed\n",
-			(unsigned long long)port->wwpn);
-		return;
-	}
-
-	scsi_target_unblock(&port->rport->dev);
-	port->rport->maxframe_size = port->maxframe_size;
-	port->rport->supported_classes = port->supported_classes;
-}
-
-static void zfcp_erp_rports_del(struct zfcp_adapter *adapter)
-{
-	struct zfcp_port *port;
-	list_for_each_entry(port, &adapter->port_list_head, list) {
-		if (!port->rport)
-			continue;
-		fc_remote_port_delete(port->rport);
-		port->rport = NULL;
-	}
-}
-
 static void zfcp_erp_action_cleanup(struct zfcp_erp_action *act, int result)
 {
 	struct zfcp_adapter *adapter = act->adapter;
@@ -1250,8 +1222,8 @@ static void zfcp_erp_action_cleanup(stru
 
 	switch (act->action) {
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		if ((result == ZFCP_ERP_SUCCEEDED) &&
-		    !unit->device && port->rport) {
+		flush_work(&port->rport_work);
+		if ((result == ZFCP_ERP_SUCCEEDED) && !unit->device) {
 			if (!(atomic_read(&unit->status) &
 			      ZFCP_STATUS_UNIT_SCSI_WORK_PENDING))
 				zfcp_erp_schedule_work(unit);
@@ -1261,23 +1233,17 @@ static void zfcp_erp_action_cleanup(stru
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
-		if ((result == ZFCP_ERP_SUCCEEDED) && !port->rport)
-			zfcp_erp_rport_register(port);
-		if ((result != ZFCP_ERP_SUCCEEDED) && port->rport) {
-			fc_remote_port_delete(port->rport);
-			port->rport = NULL;
-		}
+		if (result == ZFCP_ERP_SUCCEEDED)
+			zfcp_scsi_schedule_rport_register(port);
 		zfcp_port_put(port);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
-		if (result != ZFCP_ERP_SUCCEEDED) {
-			unregister_service_level(&adapter->service_level);
-			zfcp_erp_rports_del(adapter);
-		} else {
+		if (result == ZFCP_ERP_SUCCEEDED) {
 			register_service_level(&adapter->service_level);
 			schedule_work(&adapter->scan_work);
-		}
+		} else
+			unregister_service_level(&adapter->service_level);
 		zfcp_adapter_put(adapter);
 		break;
 	}
--- a/drivers/s390/scsi/zfcp_aux.c	2009-03-02 09:59:28.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-03-02 09:59:28.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * Module interface and handling of zfcp data structures.
  *
- * Copyright IBM Corporation 2002, 2008
+ * Copyright IBM Corporation 2002, 2009
  */
 
 /*
@@ -606,10 +606,12 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	INIT_LIST_HEAD(&port->unit_list_head);
 	INIT_WORK(&port->gid_pn_work, zfcp_erp_port_strategy_open_lookup);
 	INIT_WORK(&port->test_link_work, zfcp_fc_link_test_work);
+	INIT_WORK(&port->rport_work, zfcp_scsi_rport_work);
 
 	port->adapter = adapter;
 	port->d_id = d_id;
 	port->wwpn = wwpn;
+	port->rport_task = RPORT_NONE;
 
 	/* mark port unusable as long as sysfs registration is not complete */
 	atomic_set_mask(status | ZFCP_STATUS_COMMON_REMOVE, &port->status);
--- a/drivers/s390/scsi/zfcp_def.h	2009-03-02 09:59:28.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2009-03-02 09:59:28.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * Global definitions for the zfcp device driver.
  *
- * Copyright IBM Corporation 2002, 2008
+ * Copyright IBM Corporation 2002, 2009
  */
 
 #ifndef ZFCP_DEF_H
@@ -512,6 +512,8 @@ struct zfcp_port {
 	u32                    supported_classes;
 	struct work_struct     gid_pn_work;
 	struct work_struct     test_link_work;
+	struct work_struct     rport_work;
+	enum { RPORT_NONE, RPORT_ADD, RPORT_DEL }  rport_task;
 };
 
 struct zfcp_unit {
--- a/drivers/s390/scsi/zfcp_ext.h	2009-03-02 09:59:28.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-03-02 09:59:28.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * External function declarations.
  *
- * Copyright IBM Corporation 2002, 2008
+ * Copyright IBM Corporation 2002, 2009
  */
 
 #ifndef ZFCP_EXT_H
@@ -154,6 +154,10 @@ extern int zfcp_adapter_scsi_register(st
 extern void zfcp_adapter_scsi_unregister(struct zfcp_adapter *);
 extern char *zfcp_get_fcp_sns_info_ptr(struct fcp_rsp_iu *);
 extern struct fc_function_template zfcp_transport_functions;
+extern void zfcp_scsi_rport_work(struct work_struct *);
+extern void zfcp_scsi_schedule_rport_register(struct zfcp_port *);
+extern void zfcp_scsi_schedule_rport_block(struct zfcp_port *);
+extern void zfcp_scsi_schedule_rports_block(struct zfcp_adapter *);
 
 /* zfcp_sysfs.c */
 extern struct attribute_group zfcp_sysfs_unit_attrs;
--- a/drivers/s390/scsi/zfcp_fc.c	2009-03-02 09:59:28.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-03-02 09:59:28.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * Fibre Channel related functions for the zfcp device driver.
  *
- * Copyright IBM Corporation 2008
+ * Copyright IBM Corporation 2008, 2009
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -376,10 +376,14 @@ static void zfcp_fc_adisc_handler(unsign
 		port->wwnn = ls_adisc->wwnn;
 
 	if ((port->wwpn != ls_adisc->wwpn) ||
-	    !(atomic_read(&port->status) & ZFCP_STATUS_COMMON_OPEN))
+	    !(atomic_read(&port->status) & ZFCP_STATUS_COMMON_OPEN)) {
 		zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED,
 				     "fcadh_2", NULL);
+		goto out;
+	}
 
+	/* port is good, unblock rport without going through erp */
+	zfcp_scsi_schedule_rport_register(port);
  out:
 	zfcp_port_put(port);
 	kfree(adisc);
@@ -423,14 +427,23 @@ void zfcp_fc_link_test_work(struct work_
 		container_of(work, struct zfcp_port, test_link_work);
 	int retval;
 
+	if (!(atomic_read(&port->status) & ZFCP_STATUS_COMMON_UNBLOCKED)) {
+		zfcp_port_put(port);
+		return; /* port erp is running and will update rport status */
+	}
+
+	zfcp_port_get(port);
+	port->rport_task = RPORT_DEL;
+	zfcp_scsi_rport_work(&port->rport_work);
+
 	retval = zfcp_fc_adisc(port);
 	if (retval == 0)
 		return;
 
 	/* send of ADISC was not possible */
+	zfcp_erp_port_forced_reopen(port, 0, "fcltwk1", NULL);
+
 	zfcp_port_put(port);
-	if (retval != -EBUSY)
-		zfcp_erp_port_forced_reopen(port, 0, "fcltwk1", NULL);
 }
 
 /**
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-03-02 09:59:28.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-03-02 09:59:28.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * Implementation of FSF commands.
  *
- * Copyright IBM Corporation 2002, 2008
+ * Copyright IBM Corporation 2002, 2009
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -177,6 +177,7 @@ static void zfcp_fsf_link_down_info_eval
 		return;
 
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED, &adapter->status);
+	zfcp_scsi_schedule_rports_block(adapter);
 
 	if (!link_down)
 		goto out;
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-03-02 09:59:28.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-03-02 09:59:28.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * Interface to Linux SCSI midlayer.
  *
- * Copyright IBM Corporation 2002, 2008
+ * Copyright IBM Corporation 2002, 2009
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -57,8 +57,8 @@ static int zfcp_scsi_queuecommand(struct
 {
 	struct zfcp_unit *unit;
 	struct zfcp_adapter *adapter;
-	int    status;
-	int    ret;
+	int    status, scsi_result, ret;
+	struct fc_rport *rport = starget_to_rport(scsi_target(scpnt->device));
 
 	/* reset the status for this request */
 	scpnt->result = 0;
@@ -80,6 +80,14 @@ static int zfcp_scsi_queuecommand(struct
 		return 0;
 	}
 
+	scsi_result = fc_remote_port_chkready(rport);
+	if (unlikely(scsi_result)) {
+		scpnt->result = scsi_result;
+		zfcp_scsi_dbf_event_result("fail", 4, adapter, scpnt, NULL);
+		scpnt->scsi_done(scpnt);
+		return 0;
+	}
+
 	status = atomic_read(&unit->status);
 	if (unlikely((status & ZFCP_STATUS_COMMON_ERP_FAILED) ||
 		     !(status & ZFCP_STATUS_COMMON_RUNNING))) {
@@ -473,6 +481,109 @@ static void zfcp_set_rport_dev_loss_tmo(
 	rport->dev_loss_tmo = timeout;
 }
 
+/**
+ * zfcp_scsi_dev_loss_tmo_callbk - Free any reference to rport
+ * @rport: The rport that is about to be deleted.
+ */
+static void zfcp_scsi_dev_loss_tmo_callbk(struct fc_rport *rport)
+{
+	struct zfcp_port *port = rport->dd_data;
+
+	write_lock_irq(&zfcp_data.config_lock);
+	port->rport = NULL;
+	write_unlock_irq(&zfcp_data.config_lock);
+}
+
+/**
+ * zfcp_scsi_terminate_rport_io - Terminate all I/O on a rport
+ * @rport: The FC rport where to teminate I/O
+ *
+ * Abort all pending SCSI commands for a port by closing the
+ * port. Using a reopen for avoids a conflict with a shutdown
+ * overwriting a reopen.
+ */
+static void zfcp_scsi_terminate_rport_io(struct fc_rport *rport)
+{
+	struct zfcp_port *port = rport->dd_data;
+
+	zfcp_erp_port_reopen(port, 0, "sctrpi1", NULL);
+}
+
+static void zfcp_scsi_rport_register(struct zfcp_port *port)
+{
+	struct fc_rport_identifiers ids;
+	struct fc_rport *rport;
+
+	ids.node_name = port->wwnn;
+	ids.port_name = port->wwpn;
+	ids.port_id = port->d_id;
+	ids.roles = FC_RPORT_ROLE_FCP_TARGET;
+
+	rport = fc_remote_port_add(port->adapter->scsi_host, 0, &ids);
+	if (!rport) {
+		dev_err(&port->adapter->ccw_device->dev,
+			"Registering port 0x%016Lx failed\n",
+			(unsigned long long)port->wwpn);
+		return;
+	}
+
+	rport->dd_data = port;
+	rport->maxframe_size = port->maxframe_size;
+	rport->supported_classes = port->supported_classes;
+	port->rport = rport;
+}
+
+static void zfcp_scsi_rport_block(struct zfcp_port *port)
+{
+	if (port->rport)
+		fc_remote_port_delete(port->rport);
+}
+
+void zfcp_scsi_schedule_rport_register(struct zfcp_port *port)
+{
+	zfcp_port_get(port);
+	port->rport_task = RPORT_ADD;
+
+	if (!queue_work(zfcp_data.work_queue, &port->rport_work))
+		zfcp_port_put(port);
+}
+
+void zfcp_scsi_schedule_rport_block(struct zfcp_port *port)
+{
+	zfcp_port_get(port);
+	port->rport_task = RPORT_DEL;
+
+	if (!queue_work(zfcp_data.work_queue, &port->rport_work))
+		zfcp_port_put(port);
+}
+
+void zfcp_scsi_schedule_rports_block(struct zfcp_adapter *adapter)
+{
+	struct zfcp_port *port;
+
+	list_for_each_entry(port, &adapter->port_list_head, list)
+		zfcp_scsi_schedule_rport_block(port);
+}
+
+void zfcp_scsi_rport_work(struct work_struct *work)
+{
+	struct zfcp_port *port = container_of(work, struct zfcp_port,
+					      rport_work);
+
+	while (port->rport_task) {
+		if (port->rport_task == RPORT_ADD) {
+			port->rport_task = RPORT_NONE;
+			zfcp_scsi_rport_register(port);
+		} else {
+			port->rport_task = RPORT_NONE;
+			zfcp_scsi_rport_block(port);
+		}
+	}
+
+	zfcp_port_put(port);
+}
+
+
 struct fc_function_template zfcp_transport_functions = {
 	.show_starget_port_id = 1,
 	.show_starget_port_name = 1,
@@ -491,6 +602,8 @@ struct fc_function_template zfcp_transpo
 	.reset_fc_host_stats = zfcp_reset_fc_host_stats,
 	.set_rport_dev_loss_tmo = zfcp_set_rport_dev_loss_tmo,
 	.get_host_port_state = zfcp_get_host_port_state,
+	.dev_loss_tmo_callbk = zfcp_scsi_dev_loss_tmo_callbk,
+	.terminate_rport_io = zfcp_scsi_terminate_rport_io,
 	.show_host_port_state = 1,
 	/* no functions registered for following dynamic attributes but
 	   directly set by LLDD */

