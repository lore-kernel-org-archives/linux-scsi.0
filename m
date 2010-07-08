From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 6/9] zfcp: Register SCSI devices after successful fc_remote_port_add
Date: Thu, 08 Jul 2010 09:53:07 +0200
Message-ID: <20100708080110.645616000@de.ibm.com>
References: <20100708075301.347904000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:50666 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111Ab0GHIBN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 04:01:13 -0400
Content-Disposition: inline; filename=712-zfcp-remove-port-add.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When the successful return of an adisc is the final step to set the
port online, the registration of SCSI devices might be omitted. SCSI
devices that have been removed before (due to a short dev_loss_tmo
setting) might not be attached again.

The problem is that the registration of SCSI devices is done only
after erp has finished. The correct place would be after the call to
fc_remote_port_add to mimick the scan in the FC transport class.

Change the registration of SCSI devices to be triggered after the
fc_remote_port_add call. For the initial inquiry command to succeed,
the unit must also be open. If the unit reopen is still pending, the
inquiry command to the LUN will be deferred with DID_IMM_RETRY, so
there is no harm from this approach.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c   |    2 +-
 drivers/s390/scsi/zfcp_erp.c   |    6 ------
 drivers/s390/scsi/zfcp_ext.h   |    3 ++-
 drivers/s390/scsi/zfcp_scsi.c  |   37 +++++++++++++++++++++++++++++--------
 drivers/s390/scsi/zfcp_sysfs.c |    2 +-
 5 files changed, 33 insertions(+), 17 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -314,7 +314,7 @@ struct zfcp_unit *zfcp_unit_enqueue(stru
 	}
 	retval = -EINVAL;
 
-	INIT_WORK(&unit->scsi_work, zfcp_scsi_scan);
+	INIT_WORK(&unit->scsi_work, zfcp_scsi_scan_work);
 
 	spin_lock_init(&unit->latencies.lock);
 	unit->latencies.write.channel.min = 0xFFFFFFFF;
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -1192,12 +1192,6 @@ static void zfcp_erp_action_cleanup(stru
 
 	switch (act->action) {
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		if ((result == ZFCP_ERP_SUCCEEDED) && !unit->device) {
-			get_device(&unit->dev);
-			if (scsi_queue_work(unit->port->adapter->scsi_host,
-					    &unit->scsi_work) <= 0)
-				put_device(&unit->dev);
-		}
 		put_device(&unit->dev);
 		break;
 
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -159,7 +159,8 @@ extern void zfcp_scsi_rport_work(struct 
 extern void zfcp_scsi_schedule_rport_register(struct zfcp_port *);
 extern void zfcp_scsi_schedule_rport_block(struct zfcp_port *);
 extern void zfcp_scsi_schedule_rports_block(struct zfcp_adapter *);
-extern void zfcp_scsi_scan(struct work_struct *);
+extern void zfcp_scsi_scan(struct zfcp_unit *);
+extern void zfcp_scsi_scan_work(struct work_struct *);
 
 /* zfcp_sysfs.c */
 extern struct attribute_group zfcp_sysfs_unit_attrs;
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -524,6 +524,20 @@ static void zfcp_scsi_terminate_rport_io
 	}
 }
 
+static void zfcp_scsi_queue_unit_register(struct zfcp_port *port)
+{
+	struct zfcp_unit *unit;
+
+	read_lock_irq(&port->unit_list_lock);
+	list_for_each_entry(unit, &port->unit_list, list) {
+		get_device(&unit->dev);
+		if (scsi_queue_work(port->adapter->scsi_host,
+				    &unit->scsi_work) <= 0)
+			put_device(&unit->dev);
+	}
+	read_unlock_irq(&port->unit_list_lock);
+}
+
 static void zfcp_scsi_rport_register(struct zfcp_port *port)
 {
 	struct fc_rport_identifiers ids;
@@ -548,6 +562,8 @@ static void zfcp_scsi_rport_register(str
 	rport->maxframe_size = port->maxframe_size;
 	rport->supported_classes = port->supported_classes;
 	port->rport = rport;
+
+	zfcp_scsi_queue_unit_register(port);
 }
 
 static void zfcp_scsi_rport_block(struct zfcp_port *port)
@@ -610,21 +626,26 @@ void zfcp_scsi_rport_work(struct work_st
 	put_device(&port->dev);
 }
 
-
-void zfcp_scsi_scan(struct work_struct *work)
+/**
+ * zfcp_scsi_scan - Register LUN with SCSI midlayer
+ * @unit: The LUN/unit to register
+ */
+void zfcp_scsi_scan(struct zfcp_unit *unit)
 {
-	struct zfcp_unit *unit = container_of(work, struct zfcp_unit,
-					      scsi_work);
-	struct fc_rport *rport;
-
-	flush_work(&unit->port->rport_work);
-	rport = unit->port->rport;
+	struct fc_rport *rport = unit->port->rport;
 
 	if (rport && rport->port_state == FC_PORTSTATE_ONLINE)
 		scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
 				 scsilun_to_int((struct scsi_lun *)
 						&unit->fcp_lun), 0);
+}
+
+void zfcp_scsi_scan_work(struct work_struct *work)
+{
+	struct zfcp_unit *unit = container_of(work, struct zfcp_unit,
+					      scsi_work);
 
+	zfcp_scsi_scan(unit);
 	put_device(&unit->dev);
 }
 
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -275,7 +275,7 @@ static ssize_t zfcp_sysfs_unit_add_store
 
 	zfcp_erp_unit_reopen(unit, 0, "syuas_1", NULL);
 	zfcp_erp_wait(unit->port->adapter);
-	flush_work(&unit->scsi_work);
+	zfcp_scsi_scan(unit);
 out:
 	put_device(&port->dev);
 	return retval ? retval : (ssize_t) count;

