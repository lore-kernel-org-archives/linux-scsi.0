From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH] zfcp: updates for -bk
Date: Mon, 24 Jan 2005 10:46:29 +0100
Message-ID: <20050124094629.GA9404@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:6886 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP id S261322AbVAXJrJ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jan 2005 04:47:09 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id j0O9l8dt167250
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2005 09:47:08 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0O9m9CB169772
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2005 10:48:09 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.12.11) with ESMTP id j0O9l8QH001148
	for <linux-scsi@vger.kernel.org>; Mon, 24 Jan 2005 10:47:08 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi James,

could you please apply the patch below?

Thanks,
Heiko

From: Heiko Carstens <heiko.carstens@de.ibm.com>
From: Andreas Herrmann <aherrman@de.ibm.com>
From: Maxim Shchetynin <maxim@de.ibm.com>

zfcp changes:
 - revert kfree patch leftovers
 - don't call del_timer_sync() in interrupt context
 - correct residual count handling for data underruns
 - mark LUN as ACCESS_DENIED on status LUN_SHARING_VIOLATION

Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

diffstat:
 drivers/s390/scsi/zfcp_aux.c        |   37 ++++++++++++++++++++++--------------
 drivers/s390/scsi/zfcp_def.h        |   13 +-----------
 drivers/s390/scsi/zfcp_erp.c        |    6 ++---
 drivers/s390/scsi/zfcp_ext.h        |    2 -
 drivers/s390/scsi/zfcp_fsf.c        |   31 ++++++++++++++++--------------
 drivers/s390/scsi/zfcp_sysfs_port.c |    7 ++++--
 drivers/s390/scsi/zfcp_sysfs_unit.c |    7 ++++--
 7 files changed, 56 insertions(+), 47 deletions(-)

diff -urN a/drivers/s390/scsi/zfcp_aux.c b/drivers/s390/scsi/zfcp_aux.c
--- a/drivers/s390/scsi/zfcp_aux.c	2004-12-24 22:35:49.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_aux.c	2005-01-24 09:45:48.000000000 +0100
@@ -29,7 +29,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#define ZFCP_AUX_REVISION "$Revision: 1.145 $"
+#define ZFCP_AUX_REVISION "$Revision: 1.147 $"
 
 #include "zfcp_ext.h"
 
@@ -1099,9 +1099,9 @@
 }
 
 void
-zfcp_dummy_release(struct device *dev)
+zfcp_generic_services_release(struct device *dev)
 {
-	return;
+	kfree(dev);
 }
 
 /*
@@ -1119,6 +1119,7 @@
 {
 	int retval = 0;
 	struct zfcp_adapter *adapter;
+	struct device *gs;
 
 	/*
 	 * Note: It is safe to release the list_lock, as any list changes 
@@ -1195,13 +1196,19 @@
 	if (zfcp_sysfs_adapter_create_files(&ccw_device->dev))
 		goto sysfs_failed;
 
-	adapter->generic_services.parent = &adapter->ccw_device->dev;
-	adapter->generic_services.release = zfcp_dummy_release;
-	snprintf(adapter->generic_services.bus_id, BUS_ID_SIZE,
-		 "generic_services");
+	gs = kmalloc(sizeof(struct device), GFP_KERNEL);
+	if (!gs)
+		goto gs_failed;
+	memset(gs, 0, sizeof(struct device));
+
+	gs->parent = &adapter->ccw_device->dev;
+	gs->release = &zfcp_generic_services_release;
+	snprintf(gs->bus_id, BUS_ID_SIZE, "generic_services");
+
+	if (device_register(gs))
+		goto gs_free;
 
-	if (device_register(&adapter->generic_services))
-		goto generic_services_failed;
+	adapter->generic_services = gs;
 
 	/* put allocated adapter at list tail */
 	write_lock_irq(&zfcp_data.config_lock);
@@ -1213,7 +1220,9 @@
 
 	goto out;
 
- generic_services_failed:
+ gs_free:
+	kfree(gs);
+ gs_failed:
 	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
  sysfs_failed:
 	dev_set_drvdata(&ccw_device->dev, NULL);
@@ -1245,7 +1254,7 @@
 	int retval = 0;
 	unsigned long flags;
 
-	device_unregister(&adapter->generic_services);
+	device_unregister(adapter->generic_services);
 	zfcp_sysfs_adapter_remove_files(&adapter->ccw_device->dev);
 	dev_set_drvdata(&adapter->ccw_device->dev, NULL);
 	/* sanity check: no pending FSF requests */
@@ -1370,13 +1379,13 @@
 			return NULL;
 		}
 		port->d_id = d_id;
-		port->sysfs_device.parent = &adapter->generic_services;
+		port->sysfs_device.parent = adapter->generic_services;
 	} else {
 		snprintf(port->sysfs_device.bus_id,
 			 BUS_ID_SIZE, "0x%016llx", wwpn);
-	port->sysfs_device.parent = &adapter->ccw_device->dev;
+		port->sysfs_device.parent = &adapter->ccw_device->dev;
 	}
-	port->sysfs_device.release = zfcp_sysfs_port_release;
+	port->sysfs_device.release = &zfcp_sysfs_port_release;
 	dev_set_drvdata(&port->sysfs_device, port);
 
 	/* mark port unusable as long as sysfs registration is not complete */
diff -urN a/drivers/s390/scsi/zfcp_def.h b/drivers/s390/scsi/zfcp_def.h
--- a/drivers/s390/scsi/zfcp_def.h	2004-12-24 22:34:58.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2005-01-24 09:47:52.000000000 +0100
@@ -34,7 +34,7 @@
 #ifndef ZFCP_DEF_H
 #define ZFCP_DEF_H
 
-#define ZFCP_DEF_REVISION "$Revision: 1.111 $"
+#define ZFCP_DEF_REVISION "$Revision: 1.115 $"
 
 /*************************** INCLUDES *****************************************/
 
@@ -903,14 +903,9 @@
 	spinlock_t              dbf_lock;
 	struct zfcp_adapter_mempool	pool;      /* Adapter memory pools */
 	struct qdio_initialize  qdio_init_data;    /* for qdio_establish */
-	struct device           generic_services;  /* directory for WKA ports */
+	struct device           *generic_services; /* directory for WKA ports */
 };
 
-/*
- * the struct device sysfs_device must be at the beginning of this structure.
- * pointer to struct device is used to free port structure in release function
- * of the device. don't change!
- */
 struct zfcp_port {
 	struct device          sysfs_device;   /* sysfs device */
 	struct list_head       list;	       /* list of remote ports */
@@ -932,10 +927,6 @@
         atomic_t               erp_counter;
 };
 
-/* the struct device sysfs_device must be at the beginning of this structure.
- * pointer to struct device is used to free unit structure in release function
- * of the device. don't change!
- */
 struct zfcp_unit {
 	struct device          sysfs_device;   /* sysfs device */
 	struct list_head       list;	       /* list of logical units */
diff -urN a/drivers/s390/scsi/zfcp_erp.c b/drivers/s390/scsi/zfcp_erp.c
--- a/drivers/s390/scsi/zfcp_erp.c	2004-12-24 22:35:50.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2005-01-24 09:47:52.000000000 +0100
@@ -31,7 +31,7 @@
 
 #define ZFCP_LOG_AREA			ZFCP_LOG_AREA_ERP
 
-#define ZFCP_ERP_REVISION "$Revision: 1.85 $"
+#define ZFCP_ERP_REVISION "$Revision: 1.86 $"
 
 #include "zfcp_ext.h"
 
@@ -369,7 +369,7 @@
 		ZFCP_LOG_NORMAL("error: initiation of Send ELS failed for port "
 				"0x%08x on adapter %s\n", d_id,
 				zfcp_get_busid_by_adapter(adapter));
-		del_timer_sync(send_els->timer);
+		del_timer(send_els->timer);
 		goto freemem;
 	}
 
@@ -969,7 +969,7 @@
 		debug_event(adapter->erp_dbf, 2, &erp_action->action,
 			    sizeof (int));
 		if (!(set_mask & ZFCP_STATUS_ERP_TIMEDOUT))
-			del_timer_sync(&erp_action->timer);
+			del_timer(&erp_action->timer);
 		erp_action->status |= set_mask;
 		zfcp_erp_action_ready(erp_action);
 		retval = 0;
diff -urN a/drivers/s390/scsi/zfcp_ext.h b/drivers/s390/scsi/zfcp_ext.h
--- a/drivers/s390/scsi/zfcp_ext.h	2004-12-24 22:34:26.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ext.h	2005-01-24 09:45:48.000000000 +0100
@@ -32,7 +32,7 @@
 #ifndef ZFCP_EXT_H
 #define ZFCP_EXT_H
 
-#define ZFCP_EXT_REVISION "$Revision: 1.62 $"
+#define ZFCP_EXT_REVISION "$Revision: 1.63 $"
 
 #include "zfcp_def.h"
 
diff -urN a/drivers/s390/scsi/zfcp_fsf.c b/drivers/s390/scsi/zfcp_fsf.c
--- a/drivers/s390/scsi/zfcp_fsf.c	2004-12-24 22:35:23.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2005-01-24 09:47:52.000000000 +0100
@@ -30,7 +30,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#define ZFCP_FSF_C_REVISION "$Revision: 1.88 $"
+#define ZFCP_FSF_C_REVISION "$Revision: 1.91 $"
 
 #include "zfcp_ext.h"
 
@@ -3203,7 +3203,9 @@
 			      sizeof (union fsf_status_qual));
 		debug_text_event(adapter->erp_dbf, 2,
 				 "fsf_s_l_sh_vio");
-		zfcp_erp_unit_failed(unit);
+		zfcp_erp_unit_access_denied(unit);
+		atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
+		atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -4320,22 +4322,23 @@
 
 	/* check for underrun */
 	if (unlikely(fcp_rsp_iu->validity.bits.fcp_resid_under)) {
-		ZFCP_LOG_DEBUG("A data underrun was detected for a command. "
-			       "unit 0x%016Lx, port 0x%016Lx, adapter %s. "
-			       "The response data length is "
-			       "%d, the original length was %d.\n",
-			       unit->fcp_lun,
-			       unit->port->wwpn,
-			       zfcp_get_busid_by_unit(unit),
-			       fcp_rsp_iu->fcp_resid,
-			       (int) zfcp_get_fcp_dl(fcp_cmnd_iu));
+		ZFCP_LOG_INFO("A data underrun was detected for a command. "
+			      "unit 0x%016Lx, port 0x%016Lx, adapter %s. "
+			      "The response data length is "
+			      "%d, the original length was %d.\n",
+			      unit->fcp_lun,
+			      unit->port->wwpn,
+			      zfcp_get_busid_by_unit(unit),
+			      fcp_rsp_iu->fcp_resid,
+			      (int) zfcp_get_fcp_dl(fcp_cmnd_iu));
 		/*
 		 * It may not have been possible to send all data and the
 		 * underrun on send may already be in scpnt->resid, so it's add
 		 * not equals in the below statement.
 		 */
-		scpnt->resid += fcp_rsp_iu->fcp_resid;
-		ZFCP_LOG_TRACE("scpnt->resid=0x%x\n", scpnt->resid);
+		scpnt->resid = fcp_rsp_iu->fcp_resid;
+		if (scpnt->request_bufflen - scpnt->resid < scpnt->underflow)
+			scpnt->result |= DID_ERROR << 16;
 	}
 
  skip_fsfstatus:
@@ -5023,7 +5026,7 @@
 		 * timer might be expired (absolutely unlikely)
 		 */
 		if (timer)
-			del_timer_sync(timer);
+			del_timer(timer);
 		write_lock_irqsave(&adapter->fsf_req_list_lock, flags);
 		list_del(&fsf_req->list);
 		write_unlock_irqrestore(&adapter->fsf_req_list_lock, flags);
diff -urN a/drivers/s390/scsi/zfcp_sysfs_port.c b/drivers/s390/scsi/zfcp_sysfs_port.c
--- a/drivers/s390/scsi/zfcp_sysfs_port.c	2004-12-24 22:35:28.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_sysfs_port.c	2005-01-24 09:45:48.000000000 +0100
@@ -28,7 +28,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#define ZFCP_SYSFS_PORT_C_REVISION "$Revision: 1.47 $"
+#define ZFCP_SYSFS_PORT_C_REVISION "$Revision: 1.49 $"
 
 #include "zfcp_ext.h"
 
@@ -41,7 +41,10 @@
 void
 zfcp_sysfs_port_release(struct device *dev)
 {
-	kfree(dev);
+	struct zfcp_port *port;
+
+	port = dev_get_drvdata(dev);
+	kfree(port);
 }
 
 /**
diff -urN a/drivers/s390/scsi/zfcp_sysfs_unit.c b/drivers/s390/scsi/zfcp_sysfs_unit.c
--- a/drivers/s390/scsi/zfcp_sysfs_unit.c	2004-12-24 22:35:50.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_sysfs_unit.c	2005-01-24 09:45:48.000000000 +0100
@@ -28,7 +28,7 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
-#define ZFCP_SYSFS_UNIT_C_REVISION "$Revision: 1.30 $"
+#define ZFCP_SYSFS_UNIT_C_REVISION "$Revision: 1.33 $"
 
 #include "zfcp_ext.h"
 
@@ -41,7 +41,10 @@
 void
 zfcp_sysfs_unit_release(struct device *dev)
 {
-	kfree(dev);
+	struct zfcp_unit *unit;
+
+	unit = dev_get_drvdata(dev);
+	kfree(unit);
 }
 
 /**
