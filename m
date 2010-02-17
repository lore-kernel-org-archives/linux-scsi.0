From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 08/11] zfcp: Rename sysfs_device attribute to dev in zfcp_unit and zfcp_port
Date: Wed, 17 Feb 2010 11:18:56 +0100
Message-ID: <20100217102018.932281000@de.ibm.com>
References: <20100217101848.662299000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:60054 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752223Ab0BQKUY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 05:20:24 -0500
Content-Disposition: inline; filename=708-zfcp-sysfs-attrib.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Kernel code uses dev as short name for the struct device. Rename the
sysfs_device in zfcp_unit and zfcp_port to match this convention.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c   |   54 ++++++++++++++++++-----------------------
 drivers/s390/scsi/zfcp_ccw.c   |    8 ++----
 drivers/s390/scsi/zfcp_def.h   |    6 ++--
 drivers/s390/scsi/zfcp_erp.c   |   14 +++++-----
 drivers/s390/scsi/zfcp_fc.c    |   23 ++++++++---------
 drivers/s390/scsi/zfcp_fsf.c   |   14 +++++-----
 drivers/s390/scsi/zfcp_scsi.c  |   18 ++++++-------
 drivers/s390/scsi/zfcp_sysfs.c |   37 ++++++++++++----------------
 8 files changed, 81 insertions(+), 93 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2010-02-16 09:43:29.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2010-02-16 09:43:31.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * Module interface and handling of zfcp data structures.
  *
- * Copyright IBM Corporation 2002, 2009
+ * Copyright IBM Corporation 2002, 2010
  */
 
 /*
@@ -81,7 +81,7 @@ static void __init zfcp_init_device_conf
 	flush_work(&unit->scsi_work);
 
 out_unit:
-	put_device(&port->sysfs_device);
+	put_device(&port->dev);
 out_port:
 	zfcp_ccw_adapter_put(adapter);
 out_ccw_device:
@@ -226,7 +226,7 @@ struct zfcp_unit *zfcp_get_unit_by_lun(s
 	read_lock_irqsave(&port->unit_list_lock, flags);
 	list_for_each_entry(unit, &port->unit_list, list)
 		if (unit->fcp_lun == fcp_lun) {
-			if (!get_device(&unit->sysfs_device))
+			if (!get_device(&unit->dev))
 				unit = NULL;
 			read_unlock_irqrestore(&port->unit_list_lock, flags);
 			return unit;
@@ -251,7 +251,7 @@ struct zfcp_port *zfcp_get_port_by_wwpn(
 	read_lock_irqsave(&adapter->port_list_lock, flags);
 	list_for_each_entry(port, &adapter->port_list, list)
 		if (port->wwpn == wwpn) {
-			if (!get_device(&port->sysfs_device))
+			if (!get_device(&port->dev))
 				port = NULL;
 			read_unlock_irqrestore(&adapter->port_list_lock, flags);
 			return port;
@@ -269,10 +269,9 @@ struct zfcp_port *zfcp_get_port_by_wwpn(
  */
 static void zfcp_unit_release(struct device *dev)
 {
-	struct zfcp_unit *unit = container_of(dev, struct zfcp_unit,
-					      sysfs_device);
+	struct zfcp_unit *unit = container_of(dev, struct zfcp_unit, dev);
 
-	put_device(&unit->port->sysfs_device);
+	put_device(&unit->port->dev);
 	kfree(unit);
 }
 
@@ -289,11 +288,11 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 	struct zfcp_unit *unit;
 	int retval = -ENOMEM;
 
-	get_device(&port->sysfs_device);
+	get_device(&port->dev);
 
 	unit = zfcp_get_unit_by_lun(port, fcp_lun);
 	if (unit) {
-		put_device(&unit->sysfs_device);
+		put_device(&unit->dev);
 		retval = -EEXIST;
 		goto err_out;
 	}
@@ -304,10 +303,10 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 
 	unit->port = port;
 	unit->fcp_lun = fcp_lun;
-	unit->sysfs_device.parent = &port->sysfs_device;
-	unit->sysfs_device.release = zfcp_unit_release;
+	unit->dev.parent = &port->dev;
+	unit->dev.release = zfcp_unit_release;
 
-	if (dev_set_name(&unit->sysfs_device, "0x%016llx",
+	if (dev_set_name(&unit->dev, "0x%016llx",
 			 (unsigned long long) fcp_lun)) {
 		kfree(unit);
 		goto err_out;
@@ -324,13 +323,12 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 	unit->latencies.cmd.channel.min = 0xFFFFFFFF;
 	unit->latencies.cmd.fabric.min = 0xFFFFFFFF;
 
-	if (device_register(&unit->sysfs_device)) {
-		put_device(&unit->sysfs_device);
+	if (device_register(&unit->dev)) {
+		put_device(&unit->dev);
 		goto err_out;
 	}
 
-	if (sysfs_create_group(&unit->sysfs_device.kobj,
-			       &zfcp_sysfs_unit_attrs))
+	if (sysfs_create_group(&unit->dev.kobj, &zfcp_sysfs_unit_attrs))
 		goto err_out_put;
 
 	write_lock_irq(&port->unit_list_lock);
@@ -342,9 +340,9 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 	return unit;
 
 err_out_put:
-	device_unregister(&unit->sysfs_device);
+	device_unregister(&unit->dev);
 err_out:
-	put_device(&port->sysfs_device);
+	put_device(&port->dev);
 	return ERR_PTR(retval);
 }
 
@@ -610,8 +608,7 @@ void zfcp_device_unregister(struct devic
 
 static void zfcp_port_release(struct device *dev)
 {
-	struct zfcp_port *port = container_of(dev, struct zfcp_port,
-					      sysfs_device);
+	struct zfcp_port *port = container_of(dev, struct zfcp_port, dev);
 
 	zfcp_ccw_adapter_put(port->adapter);
 	kfree(port);
@@ -639,7 +636,7 @@ struct zfcp_port *zfcp_port_enqueue(stru
 
 	port = zfcp_get_port_by_wwpn(adapter, wwpn);
 	if (port) {
-		put_device(&port->sysfs_device);
+		put_device(&port->dev);
 		retval = -EEXIST;
 		goto err_out;
 	}
@@ -659,22 +656,21 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	port->d_id = d_id;
 	port->wwpn = wwpn;
 	port->rport_task = RPORT_NONE;
-	port->sysfs_device.parent = &adapter->ccw_device->dev;
-	port->sysfs_device.release = zfcp_port_release;
+	port->dev.parent = &adapter->ccw_device->dev;
+	port->dev.release = zfcp_port_release;
 
-	if (dev_set_name(&port->sysfs_device, "0x%016llx",
-			 (unsigned long long)wwpn)) {
+	if (dev_set_name(&port->dev, "0x%016llx", (unsigned long long)wwpn)) {
 		kfree(port);
 		goto err_out;
 	}
 	retval = -EINVAL;
 
-	if (device_register(&port->sysfs_device)) {
-		put_device(&port->sysfs_device);
+	if (device_register(&port->dev)) {
+		put_device(&port->dev);
 		goto err_out;
 	}
 
-	if (sysfs_create_group(&port->sysfs_device.kobj,
+	if (sysfs_create_group(&port->dev.kobj,
 			       &zfcp_sysfs_port_attrs))
 		goto err_out_put;
 
@@ -687,7 +683,7 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	return port;
 
 err_out_put:
-	device_unregister(&port->sysfs_device);
+	device_unregister(&port->dev);
 err_out:
 	zfcp_ccw_adapter_put(adapter);
 	return ERR_PTR(retval);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ccw.c linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c
--- linux-2.6/drivers/s390/scsi/zfcp_ccw.c	2010-02-16 09:43:29.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ccw.c	2010-02-16 09:43:31.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * Registration and callback for the s390 common I/O layer.
  *
- * Copyright IBM Corporation 2002, 2009
+ * Copyright IBM Corporation 2002, 2010
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -123,12 +123,10 @@ static void zfcp_ccw_remove(struct ccw_d
 	zfcp_ccw_adapter_put(adapter); /* put from zfcp_ccw_adapter_by_cdev */
 
 	list_for_each_entry_safe(unit, u, &unit_remove_lh, list)
-		zfcp_device_unregister(&unit->sysfs_device,
-				       &zfcp_sysfs_unit_attrs);
+		zfcp_device_unregister(&unit->dev, &zfcp_sysfs_unit_attrs);
 
 	list_for_each_entry_safe(port, p, &port_remove_lh, list)
-		zfcp_device_unregister(&port->sysfs_device,
-				       &zfcp_sysfs_port_attrs);
+		zfcp_device_unregister(&port->dev, &zfcp_sysfs_port_attrs);
 
 	zfcp_adapter_unregister(adapter);
 }
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2010-02-16 09:43:29.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2010-02-16 09:43:31.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * Global definitions for the zfcp device driver.
  *
- * Copyright IBM Corporation 2002, 2009
+ * Copyright IBM Corporation 2002, 2010
  */
 
 #ifndef ZFCP_DEF_H
@@ -237,7 +237,7 @@ struct zfcp_adapter {
 };
 
 struct zfcp_port {
-	struct device          sysfs_device;   /* sysfs device */
+	struct device          dev;
 	struct fc_rport        *rport;         /* rport of fc transport class */
 	struct list_head       list;	       /* list of remote ports */
 	struct zfcp_adapter    *adapter;       /* adapter used to access port */
@@ -259,7 +259,7 @@ struct zfcp_port {
 };
 
 struct zfcp_unit {
-	struct device          sysfs_device;   /* sysfs device */
+	struct device          dev;
 	struct list_head       list;	       /* list of logical units */
 	struct zfcp_port       *port;	       /* remote port of unit */
 	atomic_t	       status;	       /* status of this logical unit */
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2010-02-16 09:43:29.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2010-02-16 09:43:31.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * Error Recovery Procedures (ERP).
  *
- * Copyright IBM Corporation 2002, 2009
+ * Copyright IBM Corporation 2002, 2010
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -175,7 +175,7 @@ static struct zfcp_erp_action *zfcp_erp_
 
 	switch (need) {
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		if (!get_device(&unit->sysfs_device))
+		if (!get_device(&unit->dev))
 			return NULL;
 		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &unit->status);
 		erp_action = &unit->erp_action;
@@ -185,7 +185,7 @@ static struct zfcp_erp_action *zfcp_erp_
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
-		if (!get_device(&port->sysfs_device))
+		if (!get_device(&port->dev))
 			return NULL;
 		zfcp_erp_action_dismiss_port(port);
 		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &port->status);
@@ -1181,19 +1181,19 @@ static void zfcp_erp_action_cleanup(stru
 	switch (act->action) {
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
 		if ((result == ZFCP_ERP_SUCCEEDED) && !unit->device) {
-			get_device(&unit->sysfs_device);
+			get_device(&unit->dev);
 			if (scsi_queue_work(unit->port->adapter->scsi_host,
 					    &unit->scsi_work) <= 0)
-				put_device(&unit->sysfs_device);
+				put_device(&unit->dev);
 		}
-		put_device(&unit->sysfs_device);
+		put_device(&unit->dev);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
 		if (result == ZFCP_ERP_SUCCEEDED)
 			zfcp_scsi_schedule_rport_register(port);
-		put_device(&port->sysfs_device);
+		put_device(&port->dev);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2010-02-16 09:43:05.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2010-02-16 09:43:31.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * Fibre Channel related functions for the zfcp device driver.
  *
- * Copyright IBM Corporation 2008, 2009
+ * Copyright IBM Corporation 2008, 2010
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -316,7 +316,7 @@ void zfcp_fc_port_did_lookup(struct work
 
 	zfcp_erp_port_reopen(port, 0, "fcgpn_3", NULL);
 out:
-	put_device(&port->sysfs_device);
+	put_device(&port->dev);
 }
 
 /**
@@ -325,9 +325,9 @@ out:
  */
 void zfcp_fc_trigger_did_lookup(struct zfcp_port *port)
 {
-	get_device(&port->sysfs_device);
+	get_device(&port->dev);
 	if (!queue_work(port->adapter->work_queue, &port->gid_pn_work))
-		put_device(&port->sysfs_device);
+		put_device(&port->dev);
 }
 
 /**
@@ -389,7 +389,7 @@ static void zfcp_fc_adisc_handler(void *
 	zfcp_scsi_schedule_rport_register(port);
  out:
 	atomic_clear_mask(ZFCP_STATUS_PORT_LINK_TEST, &port->status);
-	put_device(&port->sysfs_device);
+	put_device(&port->dev);
 	kmem_cache_free(zfcp_data.adisc_cache, adisc);
 }
 
@@ -436,7 +436,7 @@ void zfcp_fc_link_test_work(struct work_
 		container_of(work, struct zfcp_port, test_link_work);
 	int retval;
 
-	get_device(&port->sysfs_device);
+	get_device(&port->dev);
 	port->rport_task = RPORT_DEL;
 	zfcp_scsi_rport_work(&port->rport_work);
 
@@ -455,7 +455,7 @@ void zfcp_fc_link_test_work(struct work_
 	zfcp_erp_port_forced_reopen(port, 0, "fcltwk1", NULL);
 
 out:
-	put_device(&port->sysfs_device);
+	put_device(&port->dev);
 }
 
 /**
@@ -468,9 +468,9 @@ out:
  */
 void zfcp_fc_test_link(struct zfcp_port *port)
 {
-	get_device(&port->sysfs_device);
+	get_device(&port->dev);
 	if (!queue_work(port->adapter->work_queue, &port->test_link_work))
-		put_device(&port->sysfs_device);
+		put_device(&port->dev);
 }
 
 static void zfcp_free_sg_env(struct zfcp_fc_gpn_ft *gpn_ft, int buf_num)
@@ -617,8 +617,7 @@ static int zfcp_fc_eval_gpn_ft(struct zf
 
 	list_for_each_entry_safe(port, tmp, &remove_lh, list) {
 		zfcp_erp_port_shutdown(port, 0, "fcegpf2", NULL);
-		zfcp_device_unregister(&port->sysfs_device,
-				       &zfcp_sysfs_port_attrs);
+		zfcp_device_unregister(&port->dev, &zfcp_sysfs_port_attrs);
 	}
 
 	return ret;
@@ -731,7 +730,7 @@ static int zfcp_fc_exec_els_job(struct f
 			return -EINVAL;
 
 		d_id = port->d_id;
-		put_device(&port->sysfs_device);
+		put_device(&port->dev);
 	} else
 		d_id = ntoh24(job->request->rqst_data.h_els.port_id);
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2010-02-16 09:43:31.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2010-02-16 09:43:31.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * Implementation of FSF commands.
  *
- * Copyright IBM Corporation 2002, 2009
+ * Copyright IBM Corporation 2002, 2010
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -1471,7 +1471,7 @@ static void zfcp_fsf_open_port_handler(s
 	}
 
 out:
-	put_device(&port->sysfs_device);
+	put_device(&port->dev);
 }
 
 /**
@@ -1509,14 +1509,14 @@ int zfcp_fsf_open_port(struct zfcp_erp_a
 	req->data = port;
 	req->erp_action = erp_action;
 	erp_action->fsf_req_id = req->req_id;
-	get_device(&port->sysfs_device);
+	get_device(&port->dev);
 
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);
 	if (retval) {
 		zfcp_fsf_req_free(req);
 		erp_action->fsf_req_id = 0;
-		put_device(&port->sysfs_device);
+		put_device(&port->dev);
 	}
 out:
 	spin_unlock_bh(&qdio->req_q_lock);
@@ -2261,7 +2261,7 @@ skip_fsfstatus:
 	else {
 		zfcp_fsf_send_fcp_command_task_handler(req);
 		req->unit = NULL;
-		put_device(&unit->sysfs_device);
+		put_device(&unit->dev);
 	}
 }
 
@@ -2299,7 +2299,7 @@ int zfcp_fsf_send_fcp_command_task(struc
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	get_device(&unit->sysfs_device);
+	get_device(&unit->dev);
 	req->unit = unit;
 	req->data = scsi_cmnd;
 	req->handler = zfcp_fsf_send_fcp_command_handler;
@@ -2356,7 +2356,7 @@ int zfcp_fsf_send_fcp_command_task(struc
 	goto out;
 
 failed_scsi_cmnd:
-	put_device(&unit->sysfs_device);
+	put_device(&unit->dev);
 	zfcp_fsf_req_free(req);
 	scsi_cmnd->host_scribble = NULL;
 out:
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2010-02-16 09:43:30.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2010-02-16 09:43:31.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * Interface to Linux SCSI midlayer.
  *
- * Copyright IBM Corporation 2002, 2009
+ * Copyright IBM Corporation 2002, 2010
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -44,7 +44,7 @@ static void zfcp_scsi_slave_destroy(stru
 {
 	struct zfcp_unit *unit = (struct zfcp_unit *) sdpnt->hostdata;
 	unit->device = NULL;
-	put_device(&unit->sysfs_device);
+	put_device(&unit->dev);
 }
 
 static int zfcp_scsi_slave_configure(struct scsi_device *sdp)
@@ -511,7 +511,7 @@ static void zfcp_scsi_terminate_rport_io
 
 	if (port) {
 		zfcp_erp_port_reopen(port, 0, "sctrpi1", NULL);
-		put_device(&port->sysfs_device);
+		put_device(&port->dev);
 	}
 }
 
@@ -553,23 +553,23 @@ static void zfcp_scsi_rport_block(struct
 
 void zfcp_scsi_schedule_rport_register(struct zfcp_port *port)
 {
-	get_device(&port->sysfs_device);
+	get_device(&port->dev);
 	port->rport_task = RPORT_ADD;
 
 	if (!queue_work(port->adapter->work_queue, &port->rport_work))
-		put_device(&port->sysfs_device);
+		put_device(&port->dev);
 }
 
 void zfcp_scsi_schedule_rport_block(struct zfcp_port *port)
 {
-	get_device(&port->sysfs_device);
+	get_device(&port->dev);
 	port->rport_task = RPORT_DEL;
 
 	if (port->rport && queue_work(port->adapter->work_queue,
 				      &port->rport_work))
 		return;
 
-	put_device(&port->sysfs_device);
+	put_device(&port->dev);
 }
 
 void zfcp_scsi_schedule_rports_block(struct zfcp_adapter *adapter)
@@ -598,7 +598,7 @@ void zfcp_scsi_rport_work(struct work_st
 		}
 	}
 
-	put_device(&port->sysfs_device);
+	put_device(&port->dev);
 }
 
 
@@ -616,7 +616,7 @@ void zfcp_scsi_scan(struct work_struct *
 				 scsilun_to_int((struct scsi_lun *)
 						&unit->fcp_lun), 0);
 
-	put_device(&unit->sysfs_device);
+	put_device(&unit->dev);
 }
 
 struct fc_function_template zfcp_transport_functions = {
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_sysfs.c linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c
--- linux-2.6/drivers/s390/scsi/zfcp_sysfs.c	2010-02-16 09:43:05.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c	2010-02-16 09:43:31.000000000 +0100
@@ -3,7 +3,7 @@
  *
  * sysfs attributes.
  *
- * Copyright IBM Corporation 2008, 2009
+ * Copyright IBM Corporation 2008, 2010
  */
 
 #define KMSG_COMPONENT "zfcp"
@@ -19,8 +19,7 @@ static ssize_t zfcp_sysfs_##_feat##_##_n
 						   struct device_attribute *at,\
 						   char *buf)		       \
 {									       \
-	struct _feat_def *_feat = container_of(dev, struct _feat_def,	       \
-					       sysfs_device);		       \
+	struct _feat_def *_feat = container_of(dev, struct _feat_def, dev);    \
 									       \
 	return sprintf(buf, _format, _value);				       \
 }									       \
@@ -87,8 +86,7 @@ static ssize_t zfcp_sysfs_##_feat##_fail
 						struct device_attribute *attr, \
 						char *buf)		       \
 {									       \
-	struct _feat_def *_feat = container_of(dev, struct _feat_def,	       \
-					       sysfs_device);		       \
+	struct _feat_def *_feat = container_of(dev, struct _feat_def, dev);    \
 									       \
 	if (atomic_read(&_feat->status) & ZFCP_STATUS_COMMON_ERP_FAILED)       \
 		return sprintf(buf, "1\n");				       \
@@ -99,12 +97,11 @@ static ssize_t zfcp_sysfs_##_feat##_fail
 						 struct device_attribute *attr,\
 						 const char *buf, size_t count)\
 {									       \
-	struct _feat_def *_feat = container_of(dev, struct _feat_def,	       \
-					       sysfs_device);		       \
+	struct _feat_def *_feat = container_of(dev, struct _feat_def, dev);    \
 	unsigned long val;						       \
 	int retval = 0;							       \
 									       \
-	if (!(_feat && get_device(&_feat->sysfs_device)))		       \
+	if (!(_feat && get_device(&_feat->dev)))			       \
 		return -EBUSY;						       \
 									       \
 	if (strict_strtoul(buf, 0, &val) || val != 0) {			       \
@@ -118,7 +115,7 @@ static ssize_t zfcp_sysfs_##_feat##_fail
 				  _reopen_id, NULL);			       \
 	zfcp_erp_wait(_adapter);					       \
 out:									       \
-	put_device(&_feat->sysfs_device);				       \
+	put_device(&_feat->dev);					       \
 	return retval ? retval : (ssize_t) count;			       \
 }									       \
 static ZFCP_DEV_ATTR(_feat, failed, S_IWUSR | S_IRUGO,			       \
@@ -224,10 +221,10 @@ static ssize_t zfcp_sysfs_port_remove_st
 	list_del(&port->list);
 	write_unlock_irq(&adapter->port_list_lock);
 
-	put_device(&port->sysfs_device);
+	put_device(&port->dev);
 
 	zfcp_erp_port_shutdown(port, 0, "syprs_1", NULL);
-	zfcp_device_unregister(&port->sysfs_device, &zfcp_sysfs_port_attrs);
+	zfcp_device_unregister(&port->dev, &zfcp_sysfs_port_attrs);
  out:
 	zfcp_ccw_adapter_put(adapter);
 	return retval ? retval : (ssize_t) count;
@@ -258,13 +255,12 @@ static ssize_t zfcp_sysfs_unit_add_store
 					 struct device_attribute *attr,
 					 const char *buf, size_t count)
 {
-	struct zfcp_port *port = container_of(dev, struct zfcp_port,
-					      sysfs_device);
+	struct zfcp_port *port = container_of(dev, struct zfcp_port, dev);
 	struct zfcp_unit *unit;
 	u64 fcp_lun;
 	int retval = -EINVAL;
 
-	if (!(port && get_device(&port->sysfs_device)))
+	if (!(port && get_device(&port->dev)))
 		return -EBUSY;
 
 	if (strict_strtoull(buf, 0, (unsigned long long *) &fcp_lun))
@@ -280,7 +276,7 @@ static ssize_t zfcp_sysfs_unit_add_store
 	zfcp_erp_wait(unit->port->adapter);
 	flush_work(&unit->scsi_work);
 out:
-	put_device(&port->sysfs_device);
+	put_device(&port->dev);
 	return retval ? retval : (ssize_t) count;
 }
 static DEVICE_ATTR(unit_add, S_IWUSR, NULL, zfcp_sysfs_unit_add_store);
@@ -289,13 +285,12 @@ static ssize_t zfcp_sysfs_unit_remove_st
 					    struct device_attribute *attr,
 					    const char *buf, size_t count)
 {
-	struct zfcp_port *port = container_of(dev, struct zfcp_port,
-					      sysfs_device);
+	struct zfcp_port *port = container_of(dev, struct zfcp_port, dev);
 	struct zfcp_unit *unit;
 	u64 fcp_lun;
 	int retval = -EINVAL;
 
-	if (!(port && get_device(&port->sysfs_device)))
+	if (!(port && get_device(&port->dev)))
 		return -EBUSY;
 
 	if (strict_strtoull(buf, 0, (unsigned long long *) &fcp_lun))
@@ -314,12 +309,12 @@ static ssize_t zfcp_sysfs_unit_remove_st
 	list_del(&unit->list);
 	write_unlock_irq(&port->unit_list_lock);
 
-	put_device(&unit->sysfs_device);
+	put_device(&unit->dev);
 
 	zfcp_erp_unit_shutdown(unit, 0, "syurs_1", NULL);
-	zfcp_device_unregister(&unit->sysfs_device, &zfcp_sysfs_unit_attrs);
+	zfcp_device_unregister(&unit->dev, &zfcp_sysfs_unit_attrs);
 out:
-	put_device(&port->sysfs_device);
+	put_device(&port->dev);
 	return retval ? retval : (ssize_t) count;
 }
 static DEVICE_ATTR(unit_remove, S_IWUSR, NULL, zfcp_sysfs_unit_remove_store);

