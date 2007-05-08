From: Swen Schillig <swen@vnet.ibm.com>
Subject: [PATCH 2/5] zfcp: Fix deadlock between zfcp ERP and SCSI
Date: Tue, 8 May 2007 11:16:52 +0200
Message-ID: <200705081116.53021.swen@vnet.ibm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:53092 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965805AbXEHJOP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 May 2007 05:14:15 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The SCSI stack requires low level drivers to register and
unregister devices. For zfcp this leads to the situation where
zfcp calls the SCSI stack, the SCSI tries to scan the new device
and the scan SCSI command fails. This would require the zfcp erp,
but the erp thread is already blocked in the register call.

The fix is to make sure that the calls from the ERP thread to
the SCSI stack do not block the ERP thread. In detail:
1) Use a workqueue to avoid blocking of the scsi_scan_target calls.
2) When removing a unit make sure that no scsi_scan_target call is
   pending.
3) Replace scsi_flush_work with scsi_target_unblock. This avoids
   blocking and has the same result.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c  |    2 +
 drivers/s390/scsi/zfcp_def.h  |    5 +++
 drivers/s390/scsi/zfcp_erp.c  |   64 +++++++++++++++++++++++++++++++++++++++---
 drivers/s390/scsi/zfcp_scsi.c |    5 +++
 4 files changed, 72 insertions(+), 4 deletions(-)

--- linux-2.6.orig/drivers/s390/scsi/zfcp_aux.c	2007-05-07 13:56:57.000000000 +0200
+++ linux-2.6/drivers/s390/scsi/zfcp_aux.c	2007-05-07 15:50:19.000000000 +0200
@@ -913,6 +913,8 @@
 	unit->sysfs_device.release = zfcp_sysfs_unit_release;
 	dev_set_drvdata(&unit->sysfs_device, unit);

+	init_waitqueue_head(&unit->scsi_scan_wq);
+
 	/* mark unit unusable as long as sysfs registration is not complete */
 	atomic_set_mask(ZFCP_STATUS_COMMON_REMOVE, &unit->status);

--- linux-2.6.orig/drivers/s390/scsi/zfcp_def.h	2007-04-26 14:53:13.000000000 +0200
+++ linux-2.6/drivers/s390/scsi/zfcp_def.h	2007-05-07 15:54:46.000000000 +0200
@@ -637,6 +637,7 @@
 #define ZFCP_STATUS_UNIT_SHARED			0x00000004
 #define ZFCP_STATUS_UNIT_READONLY		0x00000008
 #define ZFCP_STATUS_UNIT_REGISTERED		0x00000010
+#define ZFCP_STATUS_UNIT_SCSI_WORK_PENDING	0x00000020

 /* FSF request status (this does not have a common part) */
 #define ZFCP_STATUS_FSFREQ_NOT_INIT		0x00000000
@@ -980,6 +981,10 @@
         struct scsi_device     *device;        /* scsi device struct pointer */
 	struct zfcp_erp_action erp_action;     /* pending error recovery */
         atomic_t               erp_counter;
+	wait_queue_head_t      scsi_scan_wq;   /* can be used to wait until
+						  all scsi_scan_target
+						  requests have been
+						  completed. */
 };

 /* FSF request */
--- linux-2.6.orig/drivers/s390/scsi/zfcp_erp.c	2007-05-07 13:56:57.000000000 +0200
+++ linux-2.6/drivers/s390/scsi/zfcp_erp.c	2007-05-07 15:50:19.000000000 +0200
@@ -1591,6 +1591,62 @@
 	return result;
 }

+struct zfcp_erp_add_work {
+	struct zfcp_unit  *unit;
+	struct work_struct work;
+};
+
+/**
+ * zfcp_erp_scsi_scan
+ * @data: pointer to a struct zfcp_erp_add_work
+ *
+ * Registers a logical unit with the SCSI stack.
+ */
+static void zfcp_erp_scsi_scan(struct work_struct *work)
+{
+	struct zfcp_erp_add_work *p =
+		container_of(work, struct zfcp_erp_add_work, work);
+	struct zfcp_unit *unit = p->unit;
+	struct fc_rport *rport = unit->port->rport;
+	scsi_scan_target(&rport->dev, 0, rport->scsi_target_id,
+			 unit->scsi_lun, 0);
+	atomic_clear_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
+	wake_up(&unit->scsi_scan_wq);
+	zfcp_unit_put(unit);
+	kfree(p);
+}
+
+/**
+ * zfcp_erp_schedule_work
+ * @unit: pointer to unit which should be registered with SCSI stack
+ *
+ * Schedules work which registers a unit with the SCSI stack
+ */
+static void
+zfcp_erp_schedule_work(struct zfcp_unit *unit)
+{
+	struct zfcp_erp_add_work *p;
+
+	p = kmalloc(sizeof(*p), GFP_KERNEL);
+	if (!p) {
+		ZFCP_LOG_NORMAL("error: Out of resources. Could not register "
+				"the FCP-LUN 0x%Lx connected to "
+				"the port with WWPN 0x%Lx connected to "
+				"the adapter %s with the SCSI stack.\n",
+				unit->fcp_lun,
+				unit->port->wwpn,
+				zfcp_get_busid_by_unit(unit));
+		return;
+	}
+
+	zfcp_unit_get(unit);
+	memset(p, 0, sizeof(*p));
+	atomic_set_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING, &unit->status);
+	INIT_WORK(&p->work, zfcp_erp_scsi_scan);
+	p->unit = unit;
+	schedule_work(&p->work);
+}
+
 /*
  * function:	
  *
@@ -3092,9 +3148,9 @@
 		    && port->rport) {
 			atomic_set_mask(ZFCP_STATUS_UNIT_REGISTERED,
 					&unit->status);
- 			scsi_scan_target(&port->rport->dev, 0,
-					 port->rport->scsi_target_id,
-					 unit->scsi_lun, 0);
+			if (atomic_test_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING,
+					     &unit->status) == 0)
+				zfcp_erp_schedule_work(unit);
 		}
 		zfcp_unit_put(unit);
 		break;
@@ -3121,7 +3177,7 @@
 						zfcp_get_busid_by_port(port),
 						port->wwpn);
 			else {
-				scsi_flush_work(adapter->scsi_host);
+				scsi_target_unblock(&port->rport->dev);
 				port->rport->maxframe_size = port->maxframe_size;
 				port->rport->supported_classes =
 					port->supported_classes;
--- linux-2.6.orig/drivers/s390/scsi/zfcp_scsi.c	2007-04-26 14:53:13.000000000 +0200
+++ linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2007-05-07 15:50:19.000000000 +0200
@@ -22,6 +22,7 @@
 #define ZFCP_LOG_AREA			ZFCP_LOG_AREA_SCSI

 #include "zfcp_ext.h"
+#include <asm/atomic.h>

 static void zfcp_scsi_slave_destroy(struct scsi_device *sdp);
 static int zfcp_scsi_slave_alloc(struct scsi_device *sdp);
@@ -179,6 +180,10 @@
 	struct zfcp_unit *unit = (struct zfcp_unit *) sdpnt->hostdata;

 	if (unit) {
+		zfcp_erp_wait(unit->port->adapter);
+		wait_event(unit->scsi_scan_wq,
+			   atomic_test_mask(ZFCP_STATUS_UNIT_SCSI_WORK_PENDING,
+					    &unit->status) == 0);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_REGISTERED, &unit->status);
 		sdpnt->hostdata = NULL;
 		unit->device = NULL;


-------------------------------------------------------
