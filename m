From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 5/7] zfcp: Redesign of the debug tracing final cleanup.
Date: Thu, 02 Dec 2010 15:16:16 +0100
Message-ID: <20101202141919.417424269@de.ibm.com>
References: <20101202141611.976946976@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:57276 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757737Ab0LBOT1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2010 09:19:27 -0500
Content-Disposition: inline; filename=705-zfcp-debug-tracing.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, maier@linux.vnet.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

This patch is the final cleanup of the redesign from the zfcp tracing.
Structures and elements which were used by multiple areas of the
former debug tracing are now changed to the new scheme.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c   |    5 --
 drivers/s390/scsi/zfcp_ccw.c   |   14 ++---
 drivers/s390/scsi/zfcp_cfdc.c  |    8 +--
 drivers/s390/scsi/zfcp_dbf.c   |   70 +++++++++++++++--------------
 drivers/s390/scsi/zfcp_dbf.h   |   25 ++++++++--
 drivers/s390/scsi/zfcp_erp.c   |   97 +++++++++++++++++++----------------------
 drivers/s390/scsi/zfcp_ext.h   |   18 +++----
 drivers/s390/scsi/zfcp_fc.c    |   18 +++----
 drivers/s390/scsi/zfcp_fsf.c   |   85 ++++++++++++++++-------------------
 drivers/s390/scsi/zfcp_qdio.c  |    6 +-
 drivers/s390/scsi/zfcp_scsi.c  |    6 +-
 drivers/s390/scsi/zfcp_sysfs.c |    9 +--
 12 files changed, 180 insertions(+), 181 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c
+++ b/drivers/s390/scsi/zfcp_aux.c
@@ -311,8 +311,7 @@ int zfcp_status_read_refill(struct zfcp_
 		if (zfcp_fsf_status_read(adapter->qdio)) {
 			if (atomic_read(&adapter->stat_miss) >=
 			    adapter->stat_read_buf_num) {
-				zfcp_erp_adapter_reopen(adapter, 0, "axsref1",
-							NULL);
+				zfcp_erp_adapter_reopen(adapter, 0, "axsref1");
 				return 1;
 			}
 			break;
@@ -459,7 +458,7 @@ void zfcp_adapter_unregister(struct zfcp
 	sysfs_remove_group(&cdev->dev.kobj, &zfcp_sysfs_adapter_attrs);
 
 	zfcp_erp_thread_kill(adapter);
-	zfcp_dbf_adapter_unregister(adapter->dbf);
+	zfcp_dbf_adapter_unregister(adapter);
 	zfcp_qdio_destroy(adapter->qdio);
 
 	zfcp_ccw_adapter_put(adapter); /* final put to release */
--- a/drivers/s390/scsi/zfcp_ccw.c
+++ b/drivers/s390/scsi/zfcp_ccw.c
@@ -48,7 +48,7 @@ static int zfcp_ccw_activate(struct ccw_
 
 	zfcp_erp_set_adapter_status(adapter, ZFCP_STATUS_COMMON_RUNNING);
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
-				"ccresu2", NULL);
+				"ccresu2");
 	zfcp_erp_wait(adapter);
 	flush_work(&adapter->scan_work);
 
@@ -182,7 +182,7 @@ static int zfcp_ccw_set_offline(struct c
 	if (!adapter)
 		return 0;
 
-	zfcp_erp_adapter_shutdown(adapter, 0, "ccsoff1", NULL);
+	zfcp_erp_adapter_shutdown(adapter, 0, "ccsoff1");
 	zfcp_erp_wait(adapter);
 
 	zfcp_ccw_adapter_put(adapter);
@@ -207,24 +207,24 @@ static int zfcp_ccw_notify(struct ccw_de
 	switch (event) {
 	case CIO_GONE:
 		dev_warn(&cdev->dev, "The FCP device has been detached\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, "ccnoti1", NULL);
+		zfcp_erp_adapter_shutdown(adapter, 0, "ccnoti1");
 		break;
 	case CIO_NO_PATH:
 		dev_warn(&cdev->dev,
 			 "The CHPID for the FCP device is offline\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, "ccnoti2", NULL);
+		zfcp_erp_adapter_shutdown(adapter, 0, "ccnoti2");
 		break;
 	case CIO_OPER:
 		dev_info(&cdev->dev, "The FCP device is operational again\n");
 		zfcp_erp_set_adapter_status(adapter,
 					    ZFCP_STATUS_COMMON_RUNNING);
 		zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
-					"ccnoti4", NULL);
+					"ccnoti4");
 		break;
 	case CIO_BOXED:
 		dev_warn(&cdev->dev, "The FCP device did not respond within "
 				     "the specified time\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, "ccnoti5", NULL);
+		zfcp_erp_adapter_shutdown(adapter, 0, "ccnoti5");
 		break;
 	}
 
@@ -243,7 +243,7 @@ static void zfcp_ccw_shutdown(struct ccw
 	if (!adapter)
 		return;
 
-	zfcp_erp_adapter_shutdown(adapter, 0, "ccshut1", NULL);
+	zfcp_erp_adapter_shutdown(adapter, 0, "ccshut1");
 	zfcp_erp_wait(adapter);
 	zfcp_erp_thread_kill(adapter);
 
--- a/drivers/s390/scsi/zfcp_cfdc.c
+++ b/drivers/s390/scsi/zfcp_cfdc.c
@@ -288,7 +288,7 @@ void zfcp_cfdc_adapter_access_changed(st
 		    (status & ZFCP_STATUS_COMMON_ACCESS_BOXED))
 			zfcp_erp_port_reopen(port,
 					     ZFCP_STATUS_COMMON_ERP_FAILED,
-					     "cfaac_1", NULL);
+					     "cfaac_1");
 	}
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 
@@ -299,7 +299,7 @@ void zfcp_cfdc_adapter_access_changed(st
 		    (status & ZFCP_STATUS_COMMON_ACCESS_BOXED))
 			zfcp_erp_lun_reopen(sdev,
 					    ZFCP_STATUS_COMMON_ERP_FAILED,
-					    "cfaac_2", NULL);
+					    "cfaac_2");
 	}
 }
 
@@ -426,7 +426,7 @@ int zfcp_cfdc_open_lun_eval(struct scsi_
 			zfcp_scsi_dev_lun(sdev),
 			(unsigned long long)zfcp_sdev->port->wwpn);
 		zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_ERP_FAILED);
-		zfcp_erp_lun_shutdown(sdev, 0, "fsouh_6", NULL);
+		zfcp_erp_lun_shutdown(sdev, 0, "fsouh_6");
 		return -EACCES;
 	}
 
@@ -437,7 +437,7 @@ int zfcp_cfdc_open_lun_eval(struct scsi_
 			zfcp_scsi_dev_lun(sdev),
 			(unsigned long long)zfcp_sdev->port->wwpn);
 		zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_ERP_FAILED);
-		zfcp_erp_lun_shutdown(sdev, 0, "fsosh_8", NULL);
+		zfcp_erp_lun_shutdown(sdev, 0, "fsosh_8");
 		return -EACCES;
 	}
 
--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -377,26 +377,37 @@ void zfcp_dbf_scsi(char *tag, struct scs
 		}
 	}
 
-	debug_event(adapter->dbf->scsi, 1, rec, sizeof(*rec));
+	debug_event(dbf->scsi, 1, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->scsi_lock, flags);
 }
 
-static debug_info_t *zfcp_dbf_reg(const char *name, int level,
-				  struct debug_view *view, int size)
+static debug_info_t *zfcp_dbf_reg(const char *name, int size, int rec_size)
 {
 	struct debug_info *d;
 
-	d = debug_register(name, dbfsize, level, size);
+	d = debug_register(name, size, 1, rec_size);
 	if (!d)
 		return NULL;
 
 	debug_register_view(d, &debug_hex_ascii_view);
-	debug_register_view(d, view);
-	debug_set_level(d, level);
+	debug_set_level(d, 3);
 
 	return d;
 }
 
+static void zfcp_dbf_unregister(struct zfcp_dbf *dbf)
+{
+	if (!dbf)
+		return;
+
+	debug_unregister(dbf->scsi);
+	debug_unregister(dbf->san);
+	debug_unregister(dbf->hba);
+	debug_unregister(dbf->pay);
+	debug_unregister(dbf->rec);
+	kfree(dbf);
+}
+
 /**
  * zfcp_adapter_debug_register - registers debug feature for an adapter
  * @adapter: pointer to adapter for which debug features should be registered
@@ -404,15 +415,13 @@ static debug_info_t *zfcp_dbf_reg(const
  */
 int zfcp_dbf_adapter_register(struct zfcp_adapter *adapter)
 {
-	char dbf_name[DEBUG_MAX_NAME_LEN];
+	char name[DEBUG_MAX_NAME_LEN];
 	struct zfcp_dbf *dbf;
 
 	dbf = kzalloc(sizeof(struct zfcp_dbf), GFP_KERNEL);
 	if (!dbf)
 		return -ENOMEM;
 
-	dbf->adapter = adapter;
-
 	spin_lock_init(&dbf->pay_lock);
 	spin_lock_init(&dbf->hba_lock);
 	spin_lock_init(&dbf->san_lock);
@@ -420,59 +429,52 @@ int zfcp_dbf_adapter_register(struct zfc
 	spin_lock_init(&dbf->rec_lock);
 
 	/* debug feature area which records recovery activity */
-	sprintf(dbf_name, "zfcp_%s_rec", dev_name(&adapter->ccw_device->dev));
-	dbf->rec = zfcp_dbf_reg(dbf_name, 3, NULL, sizeof(struct zfcp_dbf_rec));
+	sprintf(name, "zfcp_%s_rec", dev_name(&adapter->ccw_device->dev));
+	dbf->rec = zfcp_dbf_reg(name, dbfsize, sizeof(struct zfcp_dbf_rec));
 	if (!dbf->rec)
 		goto err_out;
 
 	/* debug feature area which records HBA (FSF and QDIO) conditions */
-	sprintf(dbf_name, "zfcp_%s_hba", dev_name(&adapter->ccw_device->dev));
-	dbf->hba = zfcp_dbf_reg(dbf_name, 3, NULL, sizeof(struct zfcp_dbf_hba));
+	sprintf(name, "zfcp_%s_hba", dev_name(&adapter->ccw_device->dev));
+	dbf->hba = zfcp_dbf_reg(name, dbfsize, sizeof(struct zfcp_dbf_hba));
 	if (!dbf->hba)
 		goto err_out;
 
 	/* debug feature area which records payload info */
-	sprintf(dbf_name, "zfcp_%s_pay", dev_name(&adapter->ccw_device->dev));
-	dbf->pay = zfcp_dbf_reg(dbf_name, 3, NULL,
-				sizeof(struct zfcp_dbf_pay));
+	sprintf(name, "zfcp_%s_pay", dev_name(&adapter->ccw_device->dev));
+	dbf->pay = zfcp_dbf_reg(name, dbfsize * 2, sizeof(struct zfcp_dbf_pay));
 	if (!dbf->pay)
 		goto err_out;
 
 	/* debug feature area which records SAN command failures and recovery */
-	sprintf(dbf_name, "zfcp_%s_san", dev_name(&adapter->ccw_device->dev));
-	dbf->san = zfcp_dbf_reg(dbf_name, 3, NULL, sizeof(struct zfcp_dbf_san));
+	sprintf(name, "zfcp_%s_san", dev_name(&adapter->ccw_device->dev));
+	dbf->san = zfcp_dbf_reg(name, dbfsize, sizeof(struct zfcp_dbf_san));
 	if (!dbf->san)
 		goto err_out;
 
 	/* debug feature area which records SCSI command failures and recovery */
-	sprintf(dbf_name, "zfcp_%s_scsi", dev_name(&adapter->ccw_device->dev));
-	dbf->scsi = zfcp_dbf_reg(dbf_name, 3, NULL,
-				 sizeof(struct zfcp_dbf_scsi));
+	sprintf(name, "zfcp_%s_scsi", dev_name(&adapter->ccw_device->dev));
+	dbf->scsi = zfcp_dbf_reg(name, dbfsize, sizeof(struct zfcp_dbf_scsi));
 	if (!dbf->scsi)
 		goto err_out;
 
 	adapter->dbf = dbf;
-	return 0;
 
+	return 0;
 err_out:
-	zfcp_dbf_adapter_unregister(dbf);
+	zfcp_dbf_unregister(dbf);
 	return -ENOMEM;
 }
 
 /**
  * zfcp_adapter_debug_unregister - unregisters debug feature for an adapter
- * @dbf: pointer to dbf for which debug features should be unregistered
+ * @adapter: pointer to adapter for which debug features should be unregistered
  */
-void zfcp_dbf_adapter_unregister(struct zfcp_dbf *dbf)
+void zfcp_dbf_adapter_unregister(struct zfcp_adapter *adapter)
 {
-	if (!dbf)
-		return;
-	debug_unregister(dbf->scsi);
-	debug_unregister(dbf->san);
-	debug_unregister(dbf->hba);
-	debug_unregister(dbf->pay);
-	debug_unregister(dbf->rec);
-	dbf->adapter->dbf = NULL;
-	kfree(dbf);
+	struct zfcp_dbf *dbf = adapter->dbf;
+
+	adapter->dbf = NULL;
+	zfcp_dbf_unregister(dbf);
 }
 
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -14,8 +14,6 @@
 #include "zfcp_def.h"
 
 #define ZFCP_DBF_TAG_LEN       7
-#define ZFCP_DBF_TAG_SIZE      4
-#define ZFCP_DBF_ID_SIZE       7
 
 #define ZFCP_DBF_INVALID_LUN	0xFFFFFFFFFFFFFFFFull
 
@@ -233,13 +231,31 @@ struct zfcp_dbf_scsi {
  * @data: unformatted data
  */
 struct zfcp_dbf_pay {
+	u8 counter;
 	char area[ZFCP_DBF_TAG_LEN];
-	char counter;
 	u64 fsf_req_id;
 #define ZFCP_DBF_PAY_MAX_REC 0x100
 	char data[ZFCP_DBF_PAY_MAX_REC];
 } __packed;
 
+/**
+ * struct zfcp_dbf - main dbf trace structure
+ * @pay: reference to payload trace area
+ * @rec: reference to recovery trace area
+ * @hba: reference to hba trace area
+ * @san: reference to san trace area
+ * @scsi: reference to scsi trace area
+ * @pay_lock: lock protecting payload trace buffer
+ * @rec_lock: lock protecting recovery trace buffer
+ * @hba_lock: lock protecting hba trace buffer
+ * @san_lock: lock protecting san trace buffer
+ * @scsi_lock: lock protecting scsi trace buffer
+ * @pay_buf: pre-allocated buffer for payload
+ * @rec_buf: pre-allocated buffer for recovery
+ * @hba_buf: pre-allocated buffer for hba
+ * @san_buf: pre-allocated buffer for san
+ * @scsi_buf: pre-allocated buffer for scsi
+ */
 struct zfcp_dbf {
 	debug_info_t			*pay;
 	debug_info_t			*rec;
@@ -251,12 +267,11 @@ struct zfcp_dbf {
 	spinlock_t			hba_lock;
 	spinlock_t			san_lock;
 	spinlock_t			scsi_lock;
+	struct zfcp_dbf_pay		pay_buf;
 	struct zfcp_dbf_rec		rec_buf;
 	struct zfcp_dbf_hba		hba_buf;
 	struct zfcp_dbf_san		san_buf;
 	struct zfcp_dbf_scsi		scsi_buf;
-	struct zfcp_dbf_pay		pay_buf;
-	struct zfcp_adapter		*adapter;
 };
 
 static inline
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -236,7 +236,7 @@ static struct zfcp_erp_action *zfcp_erp_
 static int zfcp_erp_action_enqueue(int want, struct zfcp_adapter *adapter,
 				   struct zfcp_port *port,
 				   struct scsi_device *sdev,
-				   char *id, void *ref, u32 act_status)
+				   char *id, u32 act_status)
 {
 	int retval = 1, need;
 	struct zfcp_erp_action *act;
@@ -262,7 +262,7 @@ static int zfcp_erp_action_enqueue(int w
 }
 
 static int _zfcp_erp_adapter_reopen(struct zfcp_adapter *adapter,
-				    int clear_mask, char *id, void *ref)
+				    int clear_mask, char *id)
 {
 	zfcp_erp_adapter_block(adapter, clear_mask);
 	zfcp_scsi_schedule_rports_block(adapter);
@@ -274,7 +274,7 @@ static int _zfcp_erp_adapter_reopen(stru
 		return -EIO;
 	}
 	return zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_ADAPTER,
-				       adapter, NULL, NULL, id, ref, 0);
+				       adapter, NULL, NULL, id, 0);
 }
 
 /**
@@ -282,10 +282,8 @@ static int _zfcp_erp_adapter_reopen(stru
  * @adapter: Adapter to reopen.
  * @clear: Status flags to clear.
  * @id: Id for debug trace event.
- * @ref: Reference for debug trace event.
  */
-void zfcp_erp_adapter_reopen(struct zfcp_adapter *adapter, int clear,
-			     char *id, void *ref)
+void zfcp_erp_adapter_reopen(struct zfcp_adapter *adapter, int clear, char *id)
 {
 	unsigned long flags;
 
@@ -298,7 +296,7 @@ void zfcp_erp_adapter_reopen(struct zfcp
 					    ZFCP_STATUS_COMMON_ERP_FAILED);
 	else
 		zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_ADAPTER, adapter,
-					NULL, NULL, id, ref, 0);
+					NULL, NULL, id, 0);
 	write_unlock_irqrestore(&adapter->erp_lock, flags);
 }
 
@@ -307,13 +305,12 @@ void zfcp_erp_adapter_reopen(struct zfcp
  * @adapter: Adapter to shut down.
  * @clear: Status flags to clear.
  * @id: Id for debug trace event.
- * @ref: Reference for debug trace event.
  */
 void zfcp_erp_adapter_shutdown(struct zfcp_adapter *adapter, int clear,
-			       char *id, void *ref)
+			       char *id)
 {
 	int flags = ZFCP_STATUS_COMMON_RUNNING | ZFCP_STATUS_COMMON_ERP_FAILED;
-	zfcp_erp_adapter_reopen(adapter, clear | flags, id, ref);
+	zfcp_erp_adapter_reopen(adapter, clear | flags, id);
 }
 
 /**
@@ -321,13 +318,11 @@ void zfcp_erp_adapter_shutdown(struct zf
  * @port: Port to shut down.
  * @clear: Status flags to clear.
  * @id: Id for debug trace event.
- * @ref: Reference for debug trace event.
  */
-void zfcp_erp_port_shutdown(struct zfcp_port *port, int clear, char *id,
-			    void *ref)
+void zfcp_erp_port_shutdown(struct zfcp_port *port, int clear, char *id)
 {
 	int flags = ZFCP_STATUS_COMMON_RUNNING | ZFCP_STATUS_COMMON_ERP_FAILED;
-	zfcp_erp_port_reopen(port, clear | flags, id, ref);
+	zfcp_erp_port_reopen(port, clear | flags, id);
 }
 
 static void zfcp_erp_port_block(struct zfcp_port *port, int clear)
@@ -336,8 +331,8 @@ static void zfcp_erp_port_block(struct z
 				    ZFCP_STATUS_COMMON_UNBLOCKED | clear);
 }
 
-static void _zfcp_erp_port_forced_reopen(struct zfcp_port *port,
-					 int clear, char *id, void *ref)
+static void _zfcp_erp_port_forced_reopen(struct zfcp_port *port, int clear,
+					 char *id)
 {
 	zfcp_erp_port_block(port, clear);
 	zfcp_scsi_schedule_rport_block(port);
@@ -346,28 +341,26 @@ static void _zfcp_erp_port_forced_reopen
 		return;
 
 	zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_PORT_FORCED,
-				port->adapter, port, NULL, id, ref, 0);
+				port->adapter, port, NULL, id, 0);
 }
 
 /**
  * zfcp_erp_port_forced_reopen - Forced close of port and open again
  * @port: Port to force close and to reopen.
+ * @clear: Status flags to clear.
  * @id: Id for debug trace event.
- * @ref: Reference for debug trace event.
  */
-void zfcp_erp_port_forced_reopen(struct zfcp_port *port, int clear, char *id,
-				 void *ref)
+void zfcp_erp_port_forced_reopen(struct zfcp_port *port, int clear, char *id)
 {
 	unsigned long flags;
 	struct zfcp_adapter *adapter = port->adapter;
 
 	write_lock_irqsave(&adapter->erp_lock, flags);
-	_zfcp_erp_port_forced_reopen(port, clear, id, ref);
+	_zfcp_erp_port_forced_reopen(port, clear, id);
 	write_unlock_irqrestore(&adapter->erp_lock, flags);
 }
 
-static int _zfcp_erp_port_reopen(struct zfcp_port *port, int clear, char *id,
-				 void *ref)
+static int _zfcp_erp_port_reopen(struct zfcp_port *port, int clear, char *id)
 {
 	zfcp_erp_port_block(port, clear);
 	zfcp_scsi_schedule_rport_block(port);
@@ -379,24 +372,25 @@ static int _zfcp_erp_port_reopen(struct
 	}
 
 	return zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_PORT,
-				       port->adapter, port, NULL, id, ref, 0);
+				       port->adapter, port, NULL, id, 0);
 }
 
 /**
  * zfcp_erp_port_reopen - trigger remote port recovery
  * @port: port to recover
  * @clear_mask: flags in port status to be cleared
+ * @id: Id for debug trace event.
  *
  * Returns 0 if recovery has been triggered, < 0 if not.
  */
-int zfcp_erp_port_reopen(struct zfcp_port *port, int clear, char *id, void *ref)
+int zfcp_erp_port_reopen(struct zfcp_port *port, int clear, char *id)
 {
 	int retval;
 	unsigned long flags;
 	struct zfcp_adapter *adapter = port->adapter;
 
 	write_lock_irqsave(&adapter->erp_lock, flags);
-	retval = _zfcp_erp_port_reopen(port, clear, id, ref);
+	retval = _zfcp_erp_port_reopen(port, clear, id);
 	write_unlock_irqrestore(&adapter->erp_lock, flags);
 
 	return retval;
@@ -409,7 +403,7 @@ static void zfcp_erp_lun_block(struct sc
 }
 
 static void _zfcp_erp_lun_reopen(struct scsi_device *sdev, int clear, char *id,
-				 void *ref, u32 act_status)
+				 u32 act_status)
 {
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
@@ -420,17 +414,18 @@ static void _zfcp_erp_lun_reopen(struct
 		return;
 
 	zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_LUN, adapter,
-				zfcp_sdev->port, sdev, id, ref, act_status);
+				zfcp_sdev->port, sdev, id, act_status);
 }
 
 /**
  * zfcp_erp_lun_reopen - initiate reopen of a LUN
  * @sdev: SCSI device / LUN to be reopened
  * @clear_mask: specifies flags in LUN status to be cleared
+ * @id: Id for debug trace event.
+ *
  * Return: 0 on success, < 0 on error
  */
-void zfcp_erp_lun_reopen(struct scsi_device *sdev, int clear, char *id,
-			 void *ref)
+void zfcp_erp_lun_reopen(struct scsi_device *sdev, int clear, char *id)
 {
 	unsigned long flags;
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
@@ -438,7 +433,7 @@ void zfcp_erp_lun_reopen(struct scsi_dev
 	struct zfcp_adapter *adapter = port->adapter;
 
 	write_lock_irqsave(&adapter->erp_lock, flags);
-	_zfcp_erp_lun_reopen(sdev, clear, id, ref, 0);
+	_zfcp_erp_lun_reopen(sdev, clear, id, 0);
 	write_unlock_irqrestore(&adapter->erp_lock, flags);
 }
 
@@ -447,13 +442,11 @@ void zfcp_erp_lun_reopen(struct scsi_dev
  * @sdev: SCSI device / LUN to shut down.
  * @clear: Status flags to clear.
  * @id: Id for debug trace event.
- * @ref: Reference for debug trace event.
  */
-void zfcp_erp_lun_shutdown(struct scsi_device *sdev, int clear, char *id,
-			   void *ref)
+void zfcp_erp_lun_shutdown(struct scsi_device *sdev, int clear, char *id)
 {
 	int flags = ZFCP_STATUS_COMMON_RUNNING | ZFCP_STATUS_COMMON_ERP_FAILED;
-	zfcp_erp_lun_reopen(sdev, clear | flags, id, ref);
+	zfcp_erp_lun_reopen(sdev, clear | flags, id);
 }
 
 /**
@@ -475,7 +468,7 @@ void zfcp_erp_lun_shutdown_wait(struct s
 	int clear = ZFCP_STATUS_COMMON_RUNNING | ZFCP_STATUS_COMMON_ERP_FAILED;
 
 	write_lock_irqsave(&adapter->erp_lock, flags);
-	_zfcp_erp_lun_reopen(sdev, clear, id, NULL, ZFCP_STATUS_ERP_NO_REF);
+	_zfcp_erp_lun_reopen(sdev, clear, id, ZFCP_STATUS_ERP_NO_REF);
 	write_unlock_irqrestore(&adapter->erp_lock, flags);
 
 	zfcp_erp_wait(adapter);
@@ -584,40 +577,40 @@ static void zfcp_erp_strategy_memwait(st
 }
 
 static void _zfcp_erp_port_reopen_all(struct zfcp_adapter *adapter,
-				      int clear, char *id, void *ref)
+				      int clear, char *id)
 {
 	struct zfcp_port *port;
 
 	read_lock(&adapter->port_list_lock);
 	list_for_each_entry(port, &adapter->port_list, list)
-		_zfcp_erp_port_reopen(port, clear, id, ref);
+		_zfcp_erp_port_reopen(port, clear, id);
 	read_unlock(&adapter->port_list_lock);
 }
 
 static void _zfcp_erp_lun_reopen_all(struct zfcp_port *port, int clear,
-				     char *id, void *ref)
+				     char *id)
 {
 	struct scsi_device *sdev;
 
 	shost_for_each_device(sdev, port->adapter->scsi_host)
 		if (sdev_to_zfcp(sdev)->port == port)
-			_zfcp_erp_lun_reopen(sdev, clear, id, ref, 0);
+			_zfcp_erp_lun_reopen(sdev, clear, id, 0);
 }
 
 static void zfcp_erp_strategy_followup_failed(struct zfcp_erp_action *act)
 {
 	switch (act->action) {
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
-		_zfcp_erp_adapter_reopen(act->adapter, 0, "ersff_1", NULL);
+		_zfcp_erp_adapter_reopen(act->adapter, 0, "ersff_1");
 		break;
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
-		_zfcp_erp_port_forced_reopen(act->port, 0, "ersff_2", NULL);
+		_zfcp_erp_port_forced_reopen(act->port, 0, "ersff_2");
 		break;
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
-		_zfcp_erp_port_reopen(act->port, 0, "ersff_3", NULL);
+		_zfcp_erp_port_reopen(act->port, 0, "ersff_3");
 		break;
 	case ZFCP_ERP_ACTION_REOPEN_LUN:
-		_zfcp_erp_lun_reopen(act->sdev, 0, "ersff_4", NULL, 0);
+		_zfcp_erp_lun_reopen(act->sdev, 0, "ersff_4", 0);
 		break;
 	}
 }
@@ -626,13 +619,13 @@ static void zfcp_erp_strategy_followup_s
 {
 	switch (act->action) {
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
-		_zfcp_erp_port_reopen_all(act->adapter, 0, "ersfs_1", NULL);
+		_zfcp_erp_port_reopen_all(act->adapter, 0, "ersfs_1");
 		break;
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
-		_zfcp_erp_port_reopen(act->port, 0, "ersfs_2", NULL);
+		_zfcp_erp_port_reopen(act->port, 0, "ersfs_2");
 		break;
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
-		_zfcp_erp_lun_reopen_all(act->port, 0, "ersfs_3", NULL);
+		_zfcp_erp_lun_reopen_all(act->port, 0, "ersfs_3");
 		break;
 	}
 }
@@ -669,7 +662,7 @@ static void zfcp_erp_enqueue_ptp_port(st
 				 adapter->peer_d_id);
 	if (IS_ERR(port)) /* error or port already attached */
 		return;
-	_zfcp_erp_port_reopen(port, 0, "ereptp1", NULL);
+	_zfcp_erp_port_reopen(port, 0, "ereptp1");
 }
 
 static int zfcp_erp_adapter_strat_fsf_xconf(struct zfcp_erp_action *erp_action)
@@ -1163,7 +1156,7 @@ static int zfcp_erp_strategy_statechange
 		if (zfcp_erp_strat_change_det(&adapter->status, erp_status)) {
 			_zfcp_erp_adapter_reopen(adapter,
 						 ZFCP_STATUS_COMMON_ERP_FAILED,
-						 "ersscg1", NULL);
+						 "ersscg1");
 			return ZFCP_ERP_EXIT;
 		}
 		break;
@@ -1173,7 +1166,7 @@ static int zfcp_erp_strategy_statechange
 		if (zfcp_erp_strat_change_det(&port->status, erp_status)) {
 			_zfcp_erp_port_reopen(port,
 					      ZFCP_STATUS_COMMON_ERP_FAILED,
-					      "ersscg2", NULL);
+					      "ersscg2");
 			return ZFCP_ERP_EXIT;
 		}
 		break;
@@ -1183,7 +1176,7 @@ static int zfcp_erp_strategy_statechange
 		if (zfcp_erp_strat_change_det(&zfcp_sdev->status, erp_status)) {
 			_zfcp_erp_lun_reopen(sdev,
 					     ZFCP_STATUS_COMMON_ERP_FAILED,
-					     "ersscg3", NULL, 0);
+					     "ersscg3", 0);
 			return ZFCP_ERP_EXIT;
 		}
 		break;
@@ -1310,7 +1303,7 @@ static int zfcp_erp_strategy(struct zfcp
 			erp_action->status |= ZFCP_STATUS_ERP_LOWMEM;
 		}
 		if (adapter->erp_total_count == adapter->erp_low_mem_count)
-			_zfcp_erp_adapter_reopen(adapter, 0, "erstgy1", NULL);
+			_zfcp_erp_adapter_reopen(adapter, 0, "erstgy1");
 		else {
 			zfcp_erp_strategy_memwait(erp_action);
 			retval = ZFCP_ERP_CONTINUES;
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -45,7 +45,7 @@ extern void zfcp_cfdc_adapter_access_cha
 
 /* zfcp_dbf.c */
 extern int zfcp_dbf_adapter_register(struct zfcp_adapter *);
-extern void zfcp_dbf_adapter_unregister(struct zfcp_dbf *);
+extern void zfcp_dbf_adapter_unregister(struct zfcp_adapter *);
 extern void zfcp_dbf_rec_trig(char *, struct zfcp_adapter *,
 			      struct zfcp_port *, struct scsi_device *, u8, u8);
 extern void zfcp_dbf_rec_run(char *, struct zfcp_erp_action *);
@@ -61,19 +61,17 @@ extern void zfcp_dbf_scsi(char *, struct
 /* zfcp_erp.c */
 extern void zfcp_erp_set_adapter_status(struct zfcp_adapter *, u32);
 extern void zfcp_erp_clear_adapter_status(struct zfcp_adapter *, u32);
-extern void zfcp_erp_adapter_reopen(struct zfcp_adapter *, int, char *, void *);
-extern void zfcp_erp_adapter_shutdown(struct zfcp_adapter *, int, char *,
-				      void *);
+extern void zfcp_erp_adapter_reopen(struct zfcp_adapter *, int, char *);
+extern void zfcp_erp_adapter_shutdown(struct zfcp_adapter *, int, char *);
 extern void zfcp_erp_set_port_status(struct zfcp_port *, u32);
 extern void zfcp_erp_clear_port_status(struct zfcp_port *, u32);
-extern int  zfcp_erp_port_reopen(struct zfcp_port *, int, char *, void *);
-extern void zfcp_erp_port_shutdown(struct zfcp_port *, int, char *, void *);
-extern void zfcp_erp_port_forced_reopen(struct zfcp_port *, int, char *,
-					void *);
+extern int  zfcp_erp_port_reopen(struct zfcp_port *, int, char *);
+extern void zfcp_erp_port_shutdown(struct zfcp_port *, int, char *);
+extern void zfcp_erp_port_forced_reopen(struct zfcp_port *, int, char *);
 extern void zfcp_erp_set_lun_status(struct scsi_device *, u32);
 extern void zfcp_erp_clear_lun_status(struct scsi_device *, u32);
-extern void zfcp_erp_lun_reopen(struct scsi_device *, int, char *, void *);
-extern void zfcp_erp_lun_shutdown(struct scsi_device *, int, char *, void *);
+extern void zfcp_erp_lun_reopen(struct scsi_device *, int, char *);
+extern void zfcp_erp_lun_shutdown(struct scsi_device *, int, char *);
 extern void zfcp_erp_lun_shutdown_wait(struct scsi_device *, char *);
 extern int  zfcp_erp_thread_setup(struct zfcp_adapter *);
 extern void zfcp_erp_thread_kill(struct zfcp_adapter *);
--- a/drivers/s390/scsi/zfcp_fc.c
+++ b/drivers/s390/scsi/zfcp_fc.c
@@ -174,7 +174,7 @@ static void _zfcp_fc_incoming_rscn(struc
 		if (!port->d_id)
 			zfcp_erp_port_reopen(port,
 					     ZFCP_STATUS_COMMON_ERP_FAILED,
-					     "fcrscn1", NULL);
+					     "fcrscn1");
 	}
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
 }
@@ -215,7 +215,7 @@ static void zfcp_fc_incoming_wwpn(struct
 	read_lock_irqsave(&adapter->port_list_lock, flags);
 	list_for_each_entry(port, &adapter->port_list, list)
 		if (port->wwpn == wwpn) {
-			zfcp_erp_port_forced_reopen(port, 0, "fciwwp1", req);
+			zfcp_erp_port_forced_reopen(port, 0, "fciwwp1");
 			break;
 		}
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
@@ -360,7 +360,7 @@ void zfcp_fc_port_did_lookup(struct work
 	ret = zfcp_fc_ns_gid_pn(port);
 	if (ret) {
 		/* could not issue gid_pn for some reason */
-		zfcp_erp_adapter_reopen(port->adapter, 0, "fcgpn_1", NULL);
+		zfcp_erp_adapter_reopen(port->adapter, 0, "fcgpn_1");
 		goto out;
 	}
 
@@ -369,7 +369,7 @@ void zfcp_fc_port_did_lookup(struct work
 		goto out;
 	}
 
-	zfcp_erp_port_reopen(port, 0, "fcgpn_3", NULL);
+	zfcp_erp_port_reopen(port, 0, "fcgpn_3");
 out:
 	put_device(&port->dev);
 }
@@ -426,7 +426,7 @@ static void zfcp_fc_adisc_handler(void *
 	if (adisc->els.status) {
 		/* request rejected or timed out */
 		zfcp_erp_port_forced_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED,
-					    "fcadh_1", NULL);
+					    "fcadh_1");
 		goto out;
 	}
 
@@ -436,7 +436,7 @@ static void zfcp_fc_adisc_handler(void *
 	if ((port->wwpn != adisc_resp->adisc_wwpn) ||
 	    !(atomic_read(&port->status) & ZFCP_STATUS_COMMON_OPEN)) {
 		zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED,
-				     "fcadh_2", NULL);
+				     "fcadh_2");
 		goto out;
 	}
 
@@ -507,7 +507,7 @@ void zfcp_fc_link_test_work(struct work_
 
 	/* send of ADISC was not possible */
 	atomic_clear_mask(ZFCP_STATUS_PORT_LINK_TEST, &port->status);
-	zfcp_erp_port_forced_reopen(port, 0, "fcltwk1", NULL);
+	zfcp_erp_port_forced_reopen(port, 0, "fcltwk1");
 
 out:
 	put_device(&port->dev);
@@ -659,7 +659,7 @@ static int zfcp_fc_eval_gpn_ft(struct zf
 		port = zfcp_port_enqueue(adapter, acc->fp_wwpn,
 					 ZFCP_STATUS_COMMON_NOESC, d_id);
 		if (!IS_ERR(port))
-			zfcp_erp_port_reopen(port, 0, "fcegpf1", NULL);
+			zfcp_erp_port_reopen(port, 0, "fcegpf1");
 		else if (PTR_ERR(port) != -EEXIST)
 			ret = PTR_ERR(port);
 	}
@@ -671,7 +671,7 @@ static int zfcp_fc_eval_gpn_ft(struct zf
 	write_unlock_irqrestore(&adapter->port_list_lock, flags);
 
 	list_for_each_entry_safe(port, tmp, &remove_lh, list) {
-		zfcp_erp_port_shutdown(port, 0, "fcegpf2", NULL);
+		zfcp_erp_port_shutdown(port, 0, "fcegpf2");
 		zfcp_device_unregister(&port->dev, &zfcp_sysfs_port_attrs);
 	}
 
--- a/drivers/s390/scsi/zfcp_fsf.c
+++ b/drivers/s390/scsi/zfcp_fsf.c
@@ -23,7 +23,7 @@ static void zfcp_fsf_request_timeout_han
 	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
 	zfcp_qdio_siosl(adapter);
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
-				"fsrth_1", NULL);
+				"fsrth_1");
 }
 
 static void zfcp_fsf_start_timer(struct zfcp_fsf_req *fsf_req,
@@ -65,7 +65,7 @@ static void zfcp_fsf_class_not_supp(stru
 {
 	dev_err(&req->adapter->ccw_device->dev, "FCP device not "
 		"operational because of an unsupported FC class\n");
-	zfcp_erp_adapter_shutdown(req->adapter, 0, "fscns_1", req);
+	zfcp_erp_adapter_shutdown(req->adapter, 0, "fscns_1");
 	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 }
 
@@ -98,7 +98,7 @@ static void zfcp_fsf_status_read_port_cl
 	read_lock_irqsave(&adapter->port_list_lock, flags);
 	list_for_each_entry(port, &adapter->port_list, list)
 		if (port->d_id == d_id) {
-			zfcp_erp_port_reopen(port, 0, "fssrpc1", req);
+			zfcp_erp_port_reopen(port, 0, "fssrpc1");
 			break;
 		}
 	read_unlock_irqrestore(&adapter->port_list_lock, flags);
@@ -247,7 +247,7 @@ static void zfcp_fsf_status_read_handler
 		zfcp_erp_adapter_reopen(adapter,
 					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
 					ZFCP_STATUS_COMMON_ERP_FAILED,
-					"fssrh_2", req);
+					"fssrh_2");
 		zfcp_fc_enqueue_event(adapter, FCH_EVT_LINKUP, 0);
 
 		break;
@@ -287,7 +287,7 @@ static void zfcp_fsf_fsfstatus_qual_eval
 			"The FCP adapter reported a problem "
 			"that cannot be recovered\n");
 		zfcp_qdio_siosl(req->adapter);
-		zfcp_erp_adapter_shutdown(req->adapter, 0, "fsfsqe1", req);
+		zfcp_erp_adapter_shutdown(req->adapter, 0, "fsfsqe1");
 		break;
 	}
 	/* all non-return stats set FSFREQ_ERROR*/
@@ -304,7 +304,7 @@ static void zfcp_fsf_fsfstatus_eval(stru
 		dev_err(&req->adapter->ccw_device->dev,
 			"The FCP adapter does not recognize the command 0x%x\n",
 			req->qtcb->header.fsf_command);
-		zfcp_erp_adapter_shutdown(req->adapter, 0, "fsfse_1", req);
+		zfcp_erp_adapter_shutdown(req->adapter, 0, "fsfse_1");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
@@ -335,17 +335,17 @@ static void zfcp_fsf_protstatus_eval(str
 			"QTCB version 0x%x not supported by FCP adapter "
 			"(0x%x to 0x%x)\n", FSF_QTCB_CURRENT_VERSION,
 			psq->word[0], psq->word[1]);
-		zfcp_erp_adapter_shutdown(adapter, 0, "fspse_1", req);
+		zfcp_erp_adapter_shutdown(adapter, 0, "fspse_1");
 		break;
 	case FSF_PROT_ERROR_STATE:
 	case FSF_PROT_SEQ_NUMB_ERROR:
-		zfcp_erp_adapter_reopen(adapter, 0, "fspse_2", req);
+		zfcp_erp_adapter_reopen(adapter, 0, "fspse_2");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_PROT_UNSUPP_QTCB_TYPE:
 		dev_err(&adapter->ccw_device->dev,
 			"The QTCB type is not supported by the FCP adapter\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, "fspse_3", req);
+		zfcp_erp_adapter_shutdown(adapter, 0, "fspse_3");
 		break;
 	case FSF_PROT_HOST_CONNECTION_INITIALIZING:
 		atomic_set_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
@@ -355,12 +355,12 @@ static void zfcp_fsf_protstatus_eval(str
 		dev_err(&adapter->ccw_device->dev,
 			"0x%Lx is an ambiguous request identifier\n",
 			(unsigned long long)qtcb->bottom.support.req_handle);
-		zfcp_erp_adapter_shutdown(adapter, 0, "fspse_4", req);
+		zfcp_erp_adapter_shutdown(adapter, 0, "fspse_4");
 		break;
 	case FSF_PROT_LINK_DOWN:
 		zfcp_fsf_link_down_info_eval(req, &psq->link_down_info);
 		/* go through reopen to flush pending requests */
-		zfcp_erp_adapter_reopen(adapter, 0, "fspse_6", req);
+		zfcp_erp_adapter_reopen(adapter, 0, "fspse_6");
 		break;
 	case FSF_PROT_REEST_QUEUE:
 		/* All ports should be marked as ready to run again */
@@ -369,14 +369,14 @@ static void zfcp_fsf_protstatus_eval(str
 		zfcp_erp_adapter_reopen(adapter,
 					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
 					ZFCP_STATUS_COMMON_ERP_FAILED,
-					"fspse_8", req);
+					"fspse_8");
 		break;
 	default:
 		dev_err(&adapter->ccw_device->dev,
 			"0x%x is not a valid transfer protocol status\n",
 			qtcb->prefix.prot_status);
 		zfcp_qdio_siosl(adapter);
-		zfcp_erp_adapter_shutdown(adapter, 0, "fspse_9", req);
+		zfcp_erp_adapter_shutdown(adapter, 0, "fspse_9");
 	}
 	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 }
@@ -482,7 +482,7 @@ static int zfcp_fsf_exchange_config_eval
 		dev_err(&adapter->ccw_device->dev,
 			"Unknown or unsupported arbitrated loop "
 			"fibre channel topology detected\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, "fsece_1", req);
+		zfcp_erp_adapter_shutdown(adapter, 0, "fsece_1");
 		return -EIO;
 	}
 
@@ -518,7 +518,7 @@ static void zfcp_fsf_exchange_config_dat
 				"FCP adapter maximum QTCB size (%d bytes) "
 				"is too small\n",
 				bottom->max_qtcb_size);
-			zfcp_erp_adapter_shutdown(adapter, 0, "fsecdh1", req);
+			zfcp_erp_adapter_shutdown(adapter, 0, "fsecdh1");
 			return;
 		}
 		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
@@ -536,7 +536,7 @@ static void zfcp_fsf_exchange_config_dat
 			&qtcb->header.fsf_status_qual.link_down_info);
 		break;
 	default:
-		zfcp_erp_adapter_shutdown(adapter, 0, "fsecdh3", req);
+		zfcp_erp_adapter_shutdown(adapter, 0, "fsecdh3");
 		return;
 	}
 
@@ -552,14 +552,14 @@ static void zfcp_fsf_exchange_config_dat
 		dev_err(&adapter->ccw_device->dev,
 			"The FCP adapter only supports newer "
 			"control block versions\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, "fsecdh4", req);
+		zfcp_erp_adapter_shutdown(adapter, 0, "fsecdh4");
 		return;
 	}
 	if (FSF_QTCB_CURRENT_VERSION > bottom->high_qtcb_version) {
 		dev_err(&adapter->ccw_device->dev,
 			"The FCP adapter only supports older "
 			"control block versions\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, "fsecdh5", req);
+		zfcp_erp_adapter_shutdown(adapter, 0, "fsecdh5");
 	}
 }
 
@@ -700,7 +700,7 @@ static int zfcp_fsf_req_send(struct zfcp
 		del_timer(&req->timer);
 		/* lookup request again, list might have changed */
 		zfcp_reqlist_find_rm(adapter->req_list, req_id);
-		zfcp_erp_adapter_reopen(adapter, 0, "fsrs__1", req);
+		zfcp_erp_adapter_reopen(adapter, 0, "fsrs__1");
 		return -EIO;
 	}
 
@@ -777,14 +777,13 @@ static void zfcp_fsf_abort_fcp_command_h
 	case FSF_PORT_HANDLE_NOT_VALID:
 		if (fsq->word[0] == fsq->word[1]) {
 			zfcp_erp_adapter_reopen(zfcp_sdev->port->adapter, 0,
-						"fsafch1", req);
+						"fsafch1");
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		}
 		break;
 	case FSF_LUN_HANDLE_NOT_VALID:
 		if (fsq->word[0] == fsq->word[1]) {
-			zfcp_erp_port_reopen(zfcp_sdev->port, 0, "fsafch2",
-					     req);
+			zfcp_erp_port_reopen(zfcp_sdev->port, 0, "fsafch2");
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		}
 		break;
@@ -795,14 +794,13 @@ static void zfcp_fsf_abort_fcp_command_h
 		zfcp_erp_set_port_status(zfcp_sdev->port,
 					 ZFCP_STATUS_COMMON_ACCESS_BOXED);
 		zfcp_erp_port_reopen(zfcp_sdev->port,
-				     ZFCP_STATUS_COMMON_ERP_FAILED, "fsafch3",
-				     req);
+				     ZFCP_STATUS_COMMON_ERP_FAILED, "fsafch3");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_BOXED:
 		zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_ACCESS_BOXED);
 		zfcp_erp_lun_reopen(sdev, ZFCP_STATUS_COMMON_ERP_FAILED,
-				    "fsafch4", req);
+				    "fsafch4");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
                 break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
@@ -903,7 +901,7 @@ static void zfcp_fsf_send_ct_handler(str
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(adapter, 0, "fsscth1", req);
+		zfcp_erp_adapter_reopen(adapter, 0, "fsscth1");
 		/* fall through */
 	case FSF_GENERIC_COMMAND_REJECTED:
 	case FSF_PAYLOAD_SIZE_MISMATCH:
@@ -1449,7 +1447,7 @@ static void zfcp_fsf_close_port_handler(
 
 	switch (req->qtcb->header.fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(port->adapter, 0, "fscph_1", req);
+		zfcp_erp_adapter_reopen(port->adapter, 0, "fscph_1");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
@@ -1581,7 +1579,7 @@ static void zfcp_fsf_close_wka_port_hand
 
 	if (req->qtcb->header.fsf_status == FSF_PORT_HANDLE_NOT_VALID) {
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		zfcp_erp_adapter_reopen(wka_port->adapter, 0, "fscwph1", req);
+		zfcp_erp_adapter_reopen(wka_port->adapter, 0, "fscwph1");
 	}
 
 	wka_port->status = ZFCP_FC_WKA_PORT_OFFLINE;
@@ -1639,7 +1637,7 @@ static void zfcp_fsf_close_physical_port
 
 	switch (header->fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(port->adapter, 0, "fscpph1", req);
+		zfcp_erp_adapter_reopen(port->adapter, 0, "fscpph1");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ACCESS_DENIED:
@@ -1655,7 +1653,7 @@ static void zfcp_fsf_close_physical_port
 						  &sdev_to_zfcp(sdev)->status);
 		zfcp_erp_set_port_status(port, ZFCP_STATUS_COMMON_ACCESS_BOXED);
 		zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED,
-				     "fscpph2", req);
+				     "fscpph2");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
@@ -1744,7 +1742,7 @@ static void zfcp_fsf_open_lun_handler(st
 	switch (header->fsf_status) {
 
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(adapter, 0, "fsouh_1", req);
+		zfcp_erp_adapter_reopen(adapter, 0, "fsouh_1");
 		/* fall through */
 	case FSF_LUN_ALREADY_OPEN:
 		break;
@@ -1756,8 +1754,7 @@ static void zfcp_fsf_open_lun_handler(st
 		zfcp_erp_set_port_status(zfcp_sdev->port,
 					 ZFCP_STATUS_COMMON_ACCESS_BOXED);
 		zfcp_erp_port_reopen(zfcp_sdev->port,
-				     ZFCP_STATUS_COMMON_ERP_FAILED, "fsouh_2",
-				     req);
+				     ZFCP_STATUS_COMMON_ERP_FAILED, "fsouh_2");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_SHARING_VIOLATION:
@@ -1853,20 +1850,18 @@ static void zfcp_fsf_close_lun_handler(s
 
 	switch (req->qtcb->header.fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(zfcp_sdev->port->adapter, 0, "fscuh_1",
-					req);
+		zfcp_erp_adapter_reopen(zfcp_sdev->port->adapter, 0, "fscuh_1");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_HANDLE_NOT_VALID:
-		zfcp_erp_port_reopen(zfcp_sdev->port, 0, "fscuh_2", req);
+		zfcp_erp_port_reopen(zfcp_sdev->port, 0, "fscuh_2");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_PORT_BOXED:
 		zfcp_erp_set_port_status(zfcp_sdev->port,
 					 ZFCP_STATUS_COMMON_ACCESS_BOXED);
 		zfcp_erp_port_reopen(zfcp_sdev->port,
-				     ZFCP_STATUS_COMMON_ERP_FAILED, "fscuh_3",
-				     req);
+				     ZFCP_STATUS_COMMON_ERP_FAILED, "fscuh_3");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
@@ -2003,13 +1998,12 @@ static void zfcp_fsf_fcp_handler_common(
 	switch (header->fsf_status) {
 	case FSF_HANDLE_MISMATCH:
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(zfcp_sdev->port->adapter, 0, "fssfch1",
-					req);
+		zfcp_erp_adapter_reopen(zfcp_sdev->port->adapter, 0, "fssfch1");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_FCPLUN_NOT_VALID:
 	case FSF_LUN_HANDLE_NOT_VALID:
-		zfcp_erp_port_reopen(zfcp_sdev->port, 0, "fssfch2", req);
+		zfcp_erp_port_reopen(zfcp_sdev->port, 0, "fssfch2");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SERVICE_CLASS_NOT_SUPPORTED:
@@ -2027,7 +2021,7 @@ static void zfcp_fsf_fcp_handler_common(
 			(unsigned long long)zfcp_scsi_dev_lun(sdev),
 			(unsigned long long)zfcp_sdev->port->wwpn);
 		zfcp_erp_adapter_shutdown(zfcp_sdev->port->adapter, 0,
-					  "fssfch3", req);
+					  "fssfch3");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_CMND_LENGTH_NOT_VALID:
@@ -2038,21 +2032,20 @@ static void zfcp_fsf_fcp_handler_common(
 			(unsigned long long)zfcp_scsi_dev_lun(sdev),
 			(unsigned long long)zfcp_sdev->port->wwpn);
 		zfcp_erp_adapter_shutdown(zfcp_sdev->port->adapter, 0,
-					  "fssfch4", req);
+					  "fssfch4");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_PORT_BOXED:
 		zfcp_erp_set_port_status(zfcp_sdev->port,
 					 ZFCP_STATUS_COMMON_ACCESS_BOXED);
 		zfcp_erp_port_reopen(zfcp_sdev->port,
-				     ZFCP_STATUS_COMMON_ERP_FAILED, "fssfch5",
-				     req);
+				     ZFCP_STATUS_COMMON_ERP_FAILED, "fssfch5");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_BOXED:
 		zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_ACCESS_BOXED);
 		zfcp_erp_lun_reopen(sdev, ZFCP_STATUS_COMMON_ERP_FAILED,
-				    "fssfch6", req);
+				    "fssfch6");
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
--- a/drivers/s390/scsi/zfcp_qdio.c
+++ b/drivers/s390/scsi/zfcp_qdio.c
@@ -41,7 +41,7 @@ static void zfcp_qdio_handler_error(stru
 		zfcp_qdio_siosl(adapter);
 	zfcp_erp_adapter_reopen(adapter,
 				ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
-				ZFCP_STATUS_COMMON_ERP_FAILED, id, NULL);
+				ZFCP_STATUS_COMMON_ERP_FAILED, id);
 }
 
 static void zfcp_qdio_zero_sbals(struct qdio_buffer *sbal[], int first, int cnt)
@@ -114,7 +114,7 @@ static void zfcp_qdio_int_resp(struct cc
 	 * put SBALs back to response queue
 	 */
 	if (do_QDIO(cdev, QDIO_FLAG_SYNC_INPUT, 0, idx, count))
-		zfcp_erp_adapter_reopen(qdio->adapter, 0, "qdires2", NULL);
+		zfcp_erp_adapter_reopen(qdio->adapter, 0, "qdires2");
 }
 
 static struct qdio_buffer_element *
@@ -234,7 +234,7 @@ int zfcp_qdio_sbal_get(struct zfcp_qdio
 	if (!ret) {
 		atomic_inc(&qdio->req_q_full);
 		/* assume hanging outbound queue, try queue recovery */
-		zfcp_erp_adapter_reopen(qdio->adapter, 0, "qdsbg_1", NULL);
+		zfcp_erp_adapter_reopen(qdio->adapter, 0, "qdsbg_1");
 	}
 
 	spin_lock_irq(&qdio->req_q_lock);
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -154,7 +154,7 @@ static int zfcp_scsi_slave_alloc(struct
 	spin_lock_init(&zfcp_sdev->latencies.lock);
 
 	zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_RUNNING);
-	zfcp_erp_lun_reopen(sdev, 0, "scsla_1", NULL);
+	zfcp_erp_lun_reopen(sdev, 0, "scsla_1");
 	zfcp_erp_wait(port->adapter);
 
 	return 0;
@@ -278,7 +278,7 @@ static int zfcp_scsi_eh_host_reset_handl
 	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
 	int ret;
 
-	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1", scpnt);
+	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1");
 	zfcp_erp_wait(adapter);
 	ret = fc_block_scsi_eh(scpnt);
 	if (ret)
@@ -516,7 +516,7 @@ static void zfcp_scsi_terminate_rport_io
 	port = zfcp_get_port_by_wwpn(adapter, rport->port_name);
 
 	if (port) {
-		zfcp_erp_port_forced_reopen(port, 0, "sctrpi1", NULL);
+		zfcp_erp_port_forced_reopen(port, 0, "sctrpi1");
 		put_device(&port->dev);
 	}
 }
--- a/drivers/s390/scsi/zfcp_sysfs.c
+++ b/drivers/s390/scsi/zfcp_sysfs.c
@@ -105,8 +105,7 @@ static ssize_t zfcp_sysfs_port_failed_st
 		return -EINVAL;
 
 	zfcp_erp_set_port_status(port, ZFCP_STATUS_COMMON_RUNNING);
-	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, "sypfai2",
-			     NULL);
+	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, "sypfai2");
 	zfcp_erp_wait(port->adapter);
 
 	return count;
@@ -148,7 +147,7 @@ static ssize_t zfcp_sysfs_unit_failed_st
 	if (sdev) {
 		zfcp_erp_set_lun_status(sdev, ZFCP_STATUS_COMMON_RUNNING);
 		zfcp_erp_lun_reopen(sdev, ZFCP_STATUS_COMMON_ERP_FAILED,
-				    "syufai2", NULL);
+				    "syufai2");
 		zfcp_erp_wait(unit->port->adapter);
 	} else
 		zfcp_unit_scsi_scan(unit);
@@ -198,7 +197,7 @@ static ssize_t zfcp_sysfs_adapter_failed
 
 	zfcp_erp_set_adapter_status(adapter, ZFCP_STATUS_COMMON_RUNNING);
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
-				"syafai2", NULL);
+				"syafai2");
 	zfcp_erp_wait(adapter);
 out:
 	zfcp_ccw_adapter_put(adapter);
@@ -256,7 +255,7 @@ static ssize_t zfcp_sysfs_port_remove_st
 
 	put_device(&port->dev);
 
-	zfcp_erp_port_shutdown(port, 0, "syprs_1", NULL);
+	zfcp_erp_port_shutdown(port, 0, "syprs_1");
 	zfcp_device_unregister(&port->dev, &zfcp_sysfs_port_attrs);
  out:
 	zfcp_ccw_adapter_put(adapter);

