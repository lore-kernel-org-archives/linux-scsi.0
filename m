From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 06/12] zfcp: Use SCSI device data zfcp_scsi_dev instead of zfcp_unit
Date: Wed, 08 Sep 2010 14:39:55 +0200
Message-ID: <20100908124353.441135901@de.ibm.com>
References: <20100908123949.483410445@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:43204 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756324Ab0IHMn6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2010 08:43:58 -0400
Content-Disposition: inline; filename=705-zfcp-scsi-device-data.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

This is the large change to switch from using the data in
zfcp_unit to zfcp_scsi_dev. Keeping everything working requires doing
the switch in one piece. To ensure that no code keeps using the data
in zfcp_unit, this patch also removes the data from zfcp_unit that is
now being replaced with zfcp_scsi_dev.

For zfcp, the scsi_device together with zfcp_scsi_dev exist from the
call of slave_alloc to the call of slave_destroy. The data in
zfcp_scsi_dev is initialized in zfcp_scsi_slave_alloc and the LUN is
opened; the final shutdown for the LUN is run from slave_destroy.

Where the scsi_device or zfcp_scsi_dev is needed, the pointer to the
scsi_device is passed as function argument and inside the function
converted to the pointer to zfcp_scsi_dev; this avoids back and forth
conversion betweeen scsi_device and zfcp_scsi_dev.

While changing the function arguments from zfcp_unit to scsi_device,
the functions names are renamed form "unit" to "lun". This is to have
a seperation between zfcp_scsi_dev/LUN and the zfcp_unit; only code
referring to the remaining configuration information in zfcp_unit
struct uses "unit".

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c   |   28 +--
 drivers/s390/scsi/zfcp_dbf.h   |   12 -
 drivers/s390/scsi/zfcp_def.h   |   34 ++-
 drivers/s390/scsi/zfcp_erp.c   |  369 +++++++++++++++++++++--------------------
 drivers/s390/scsi/zfcp_ext.h   |   32 +--
 drivers/s390/scsi/zfcp_fsf.c   |  279 +++++++++++++++----------------
 drivers/s390/scsi/zfcp_scsi.c  |  116 +++++-------
 drivers/s390/scsi/zfcp_sysfs.c |   64 ++++---
 drivers/s390/scsi/zfcp_unit.c  |   11 -
 9 files changed, 480 insertions(+), 465 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.c linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.c	2010-09-08 08:49:06.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.c	2010-09-08 08:49:28.000000000 +0200
@@ -482,7 +482,7 @@ static int zfcp_dbf_rec_view_format(debu
 		zfcp_dbf_out(&p, "fcp_lun", "0x%016Lx", r->u.trigger.fcp_lun);
 		zfcp_dbf_out(&p, "adapter_status", "0x%08x", r->u.trigger.as);
 		zfcp_dbf_out(&p, "port_status", "0x%08x", r->u.trigger.ps);
-		zfcp_dbf_out(&p, "unit_status", "0x%08x", r->u.trigger.us);
+		zfcp_dbf_out(&p, "lun_status", "0x%08x", r->u.trigger.ls);
 		break;
 	case ZFCP_REC_DBF_ID_ACTION:
 		zfcp_dbf_out(&p, "erp_action", "0x%016Lx", r->u.action.action);
@@ -600,19 +600,20 @@ void zfcp_dbf_rec_port(char *id, void *r
 }
 
 /**
- * zfcp_dbf_rec_unit - trace event for unit state change
+ * zfcp_dbf_rec_lun - trace event for LUN state change
  * @id: identifier for trigger of state change
  * @ref: additional reference (e.g. request)
- * @unit: unit
+ * @sdev: SCSI device
  */
-void zfcp_dbf_rec_unit(char *id, void *ref, struct zfcp_unit *unit)
+void zfcp_dbf_rec_lun(char *id, void *ref, struct scsi_device *sdev)
 {
-	struct zfcp_port *port = unit->port;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_port *port = zfcp_sdev->port;
 	struct zfcp_dbf *dbf = port->adapter->dbf;
 
-	zfcp_dbf_rec_target(id, ref, dbf, &unit->status,
-				  &unit->erp_counter, port->wwpn, port->d_id,
-				  unit->fcp_lun);
+	zfcp_dbf_rec_target(id, ref, dbf, &zfcp_sdev->status,
+			    &zfcp_sdev->erp_counter, port->wwpn, port->d_id,
+			    zfcp_scsi_dev_lun(sdev));
 }
 
 /**
@@ -624,11 +625,11 @@ void zfcp_dbf_rec_unit(char *id, void *r
  * @action: address of error recovery action struct
  * @adapter: adapter
  * @port: port
- * @unit: unit
+ * @sdev: SCSI device
  */
 void zfcp_dbf_rec_trigger(char *id2, void *ref, u8 want, u8 need, void *action,
 			  struct zfcp_adapter *adapter, struct zfcp_port *port,
-			  struct zfcp_unit *unit)
+			  struct scsi_device *sdev)
 {
 	struct zfcp_dbf *dbf = adapter->dbf;
 	struct zfcp_dbf_rec_record *r = &dbf->rec_buf;
@@ -647,9 +648,10 @@ void zfcp_dbf_rec_trigger(char *id2, voi
 		r->u.trigger.ps = atomic_read(&port->status);
 		r->u.trigger.wwpn = port->wwpn;
 	}
-	if (unit)
-		r->u.trigger.us = atomic_read(&unit->status);
-	r->u.trigger.fcp_lun = unit ? unit->fcp_lun : ZFCP_DBF_INVALID_LUN;
+	if (sdev)
+		r->u.trigger.ls = atomic_read(&sdev_to_zfcp(sdev)->status);
+	r->u.trigger.fcp_lun = sdev ? zfcp_scsi_dev_lun(sdev) :
+				      ZFCP_DBF_INVALID_LUN;
 	debug_event(dbf->rec, action ? 1 : 4, r, sizeof(*r));
 	spin_unlock_irqrestore(&dbf->rec_lock, flags);
 }
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_dbf.h linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.h
--- linux-2.6/drivers/s390/scsi/zfcp_dbf.h	2010-09-08 08:49:06.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_dbf.h	2010-09-08 08:49:28.000000000 +0200
@@ -60,7 +60,7 @@ struct zfcp_dbf_rec_record_trigger {
 	u8 need;
 	u32 as;
 	u32 ps;
-	u32 us;
+	u32 ls;
 	u64 ref;
 	u64 action;
 	u64 wwpn;
@@ -350,16 +350,16 @@ void zfcp_dbf_scsi_abort(const char *tag
 /**
  * zfcp_dbf_scsi_devreset - trace event for Logical Unit or Target Reset
  * @tag: tag indicating success or failure of reset operation
+ * @scmnd: SCSI command which caused this error recovery
  * @flag: indicates type of reset (Target Reset, Logical Unit Reset)
- * @unit: unit that needs reset
- * @scsi_cmnd: SCSI command which caused this error recovery
  */
 static inline
-void zfcp_dbf_scsi_devreset(const char *tag, u8 flag, struct zfcp_unit *unit,
-			    struct scsi_cmnd *scsi_cmnd)
+void zfcp_dbf_scsi_devreset(const char *tag, struct scsi_cmnd *scmnd, u8 flag)
 {
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scmnd->device);
+
 	zfcp_dbf_scsi(flag == FCP_TMF_TGT_RESET ? "trst" : "lrst", tag, 1,
-			    unit->port->adapter->dbf, scsi_cmnd, NULL, 0);
+		      zfcp_sdev->port->adapter->dbf, scmnd, NULL, 0);
 }
 
 #endif /* ZFCP_DBF_H */
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2010-09-08 08:49:26.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2010-09-08 08:49:28.000000000 +0200
@@ -85,8 +85,8 @@ struct zfcp_reqlist;
 #define ZFCP_STATUS_PORT_LINK_TEST		0x00000002
 
 /* logical unit status */
-#define ZFCP_STATUS_UNIT_SHARED			0x00000004
-#define ZFCP_STATUS_UNIT_READONLY		0x00000008
+#define ZFCP_STATUS_LUN_SHARED			0x00000004
+#define ZFCP_STATUS_LUN_READONLY		0x00000008
 
 /* FSF request status (this does not have a common part) */
 #define ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT	0x00000002
@@ -118,7 +118,7 @@ struct zfcp_erp_action {
 	int action;	              /* requested action code */
 	struct zfcp_adapter *adapter; /* device which should be recovered */
 	struct zfcp_port *port;
-	struct zfcp_unit *unit;
+	struct scsi_device *sdev;
 	u32		status;	      /* recovery status */
 	u32 step;	              /* active step of this erp action */
 	unsigned long		fsf_req_id;
@@ -219,17 +219,23 @@ struct zfcp_port {
 	unsigned int		starget_id;
 };
 
+/**
+ * struct zfcp_unit - LUN configured via zfcp sysfs
+ * @dev: struct device for sysfs representation and reference counting
+ * @list: entry in LUN/unit list per zfcp_port
+ * @port: reference to zfcp_port where this LUN is configured
+ * @fcp_lun: 64 bit LUN value
+ * @scsi_work: for running scsi_scan_target
+ *
+ * This is the representation of a LUN that has been configured for
+ * usage. The main data here is the 64 bit LUN value, data for
+ * running I/O and recovery is in struct zfcp_scsi_dev.
+ */
 struct zfcp_unit {
-	struct device          dev;
-	struct list_head       list;	       /* list of logical units */
-	struct zfcp_port       *port;	       /* remote port of unit */
-	atomic_t	       status;	       /* status of this logical unit */
-	u64		       fcp_lun;	       /* own FCP_LUN */
-	u32		       handle;	       /* handle assigned by FSF */
-        struct scsi_device     *device;        /* scsi device struct pointer */
-	struct zfcp_erp_action erp_action;     /* pending error recovery */
-        atomic_t               erp_counter;
-	struct zfcp_latencies	latencies;
+	struct device		dev;
+	struct list_head	list;
+	struct zfcp_port	*port;
+	u64			fcp_lun;
 	struct work_struct	scsi_work;
 };
 
@@ -288,7 +294,6 @@ static inline u64 zfcp_scsi_dev_lun(stru
  * @erp_action: reference to erp action if request issued on behalf of ERP
  * @pool: reference to memory pool if used for this request
  * @issued: time when request was send (STCK)
- * @unit: reference to unit if this request is a SCSI request
  * @handler: handler which should be called to process response
  */
 struct zfcp_fsf_req {
@@ -306,7 +311,6 @@ struct zfcp_fsf_req {
 	struct zfcp_erp_action	*erp_action;
 	mempool_t		*pool;
 	unsigned long long	issued;
-	struct zfcp_unit	*unit;
 	void			(*handler)(struct zfcp_fsf_req *);
 };
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2010-09-08 08:49:28.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2010-09-08 08:49:28.000000000 +0200
@@ -30,12 +30,12 @@ enum zfcp_erp_steps {
 	ZFCP_ERP_STEP_PHYS_PORT_CLOSING	= 0x0010,
 	ZFCP_ERP_STEP_PORT_CLOSING	= 0x0100,
 	ZFCP_ERP_STEP_PORT_OPENING	= 0x0800,
-	ZFCP_ERP_STEP_UNIT_CLOSING	= 0x1000,
-	ZFCP_ERP_STEP_UNIT_OPENING	= 0x2000,
+	ZFCP_ERP_STEP_LUN_CLOSING	= 0x1000,
+	ZFCP_ERP_STEP_LUN_OPENING	= 0x2000,
 };
 
 enum zfcp_erp_act_type {
-	ZFCP_ERP_ACTION_REOPEN_UNIT        = 1,
+	ZFCP_ERP_ACTION_REOPEN_LUN         = 1,
 	ZFCP_ERP_ACTION_REOPEN_PORT	   = 2,
 	ZFCP_ERP_ACTION_REOPEN_PORT_FORCED = 3,
 	ZFCP_ERP_ACTION_REOPEN_ADAPTER     = 4,
@@ -89,24 +89,24 @@ static void zfcp_erp_action_dismiss(stru
 		zfcp_erp_action_ready(act);
 }
 
-static void zfcp_erp_action_dismiss_unit(struct zfcp_unit *unit)
+static void zfcp_erp_action_dismiss_lun(struct scsi_device *sdev)
 {
-	if (atomic_read(&unit->status) & ZFCP_STATUS_COMMON_ERP_INUSE)
-		zfcp_erp_action_dismiss(&unit->erp_action);
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+
+	if (atomic_read(&zfcp_sdev->status) & ZFCP_STATUS_COMMON_ERP_INUSE)
+		zfcp_erp_action_dismiss(&zfcp_sdev->erp_action);
 }
 
 static void zfcp_erp_action_dismiss_port(struct zfcp_port *port)
 {
-	struct zfcp_unit *unit;
+	struct scsi_device *sdev;
 
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_ERP_INUSE)
 		zfcp_erp_action_dismiss(&port->erp_action);
-	else {
-		read_lock(&port->unit_list_lock);
-		list_for_each_entry(unit, &port->unit_list, list)
-			zfcp_erp_action_dismiss_unit(unit);
-		read_unlock(&port->unit_list_lock);
-	}
+	else
+		shost_for_each_device(sdev, port->adapter->scsi_host)
+			if (sdev_to_zfcp(sdev)->port == port)
+				zfcp_erp_action_dismiss_lun(sdev);
 }
 
 static void zfcp_erp_action_dismiss_adapter(struct zfcp_adapter *adapter)
@@ -125,15 +125,17 @@ static void zfcp_erp_action_dismiss_adap
 
 static int zfcp_erp_required_act(int want, struct zfcp_adapter *adapter,
 				 struct zfcp_port *port,
-				 struct zfcp_unit *unit)
+				 struct scsi_device *sdev)
 {
 	int need = want;
-	int u_status, p_status, a_status;
+	int l_status, p_status, a_status;
+	struct zfcp_scsi_dev *zfcp_sdev;
 
 	switch (want) {
-	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		u_status = atomic_read(&unit->status);
-		if (u_status & ZFCP_STATUS_COMMON_ERP_INUSE)
+	case ZFCP_ERP_ACTION_REOPEN_LUN:
+		zfcp_sdev = sdev_to_zfcp(sdev);
+		l_status = atomic_read(&zfcp_sdev->status);
+		if (l_status & ZFCP_STATUS_COMMON_ERP_INUSE)
 			return 0;
 		p_status = atomic_read(&port->status);
 		if (!(p_status & ZFCP_STATUS_COMMON_RUNNING) ||
@@ -173,18 +175,22 @@ static int zfcp_erp_required_act(int wan
 static struct zfcp_erp_action *zfcp_erp_setup_act(int need, u32 act_status,
 						  struct zfcp_adapter *adapter,
 						  struct zfcp_port *port,
-						  struct zfcp_unit *unit)
+						  struct scsi_device *sdev)
 {
 	struct zfcp_erp_action *erp_action;
+	struct zfcp_scsi_dev *zfcp_sdev;
 
 	switch (need) {
-	case ZFCP_ERP_ACTION_REOPEN_UNIT:
+	case ZFCP_ERP_ACTION_REOPEN_LUN:
+		zfcp_sdev = sdev_to_zfcp(sdev);
 		if (!(act_status & ZFCP_STATUS_ERP_NO_REF))
-			if (!get_device(&unit->dev))
+			if (scsi_device_get(sdev))
 				return NULL;
-		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE, &unit->status);
-		erp_action = &unit->erp_action;
-		if (!(atomic_read(&unit->status) & ZFCP_STATUS_COMMON_RUNNING))
+		atomic_set_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
+				&zfcp_sdev->status);
+		erp_action = &zfcp_sdev->erp_action;
+		if (!(atomic_read(&zfcp_sdev->status) &
+		      ZFCP_STATUS_COMMON_RUNNING))
 			act_status |= ZFCP_STATUS_ERP_CLOSE_ONLY;
 		break;
 
@@ -216,7 +222,7 @@ static struct zfcp_erp_action *zfcp_erp_
 	memset(erp_action, 0, sizeof(struct zfcp_erp_action));
 	erp_action->adapter = adapter;
 	erp_action->port = port;
-	erp_action->unit = unit;
+	erp_action->sdev = sdev;
 	erp_action->action = need;
 	erp_action->status = act_status;
 
@@ -225,8 +231,8 @@ static struct zfcp_erp_action *zfcp_erp_
 
 static int zfcp_erp_action_enqueue(int want, struct zfcp_adapter *adapter,
 				   struct zfcp_port *port,
-				   struct zfcp_unit *unit, char *id, void *ref,
-				   u32 act_status)
+				   struct scsi_device *sdev,
+				   char *id, void *ref, u32 act_status)
 {
 	int retval = 1, need;
 	struct zfcp_erp_action *act = NULL;
@@ -234,11 +240,11 @@ static int zfcp_erp_action_enqueue(int w
 	if (!adapter->erp_thread)
 		return -EIO;
 
-	need = zfcp_erp_required_act(want, adapter, port, unit);
+	need = zfcp_erp_required_act(want, adapter, port, sdev);
 	if (!need)
 		goto out;
 
-	act = zfcp_erp_setup_act(need, act_status, adapter, port, unit);
+	act = zfcp_erp_setup_act(need, act_status, adapter, port, sdev);
 	if (!act)
 		goto out;
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING, &adapter->status);
@@ -248,7 +254,7 @@ static int zfcp_erp_action_enqueue(int w
 	zfcp_dbf_rec_thread("eracte1", adapter->dbf);
 	retval = 0;
  out:
-	zfcp_dbf_rec_trigger(id, ref, want, need, act, adapter, port, unit);
+	zfcp_dbf_rec_trigger(id, ref, want, need, act, adapter, port, sdev);
 	return retval;
 }
 
@@ -392,77 +398,81 @@ int zfcp_erp_port_reopen(struct zfcp_por
 	return retval;
 }
 
-static void zfcp_erp_unit_block(struct zfcp_unit *unit, int clear_mask)
+static void zfcp_erp_lun_block(struct scsi_device *sdev, int clear_mask)
 {
-	zfcp_erp_modify_unit_status(unit, "erublk1", NULL,
-				    ZFCP_STATUS_COMMON_UNBLOCKED | clear_mask,
-				    ZFCP_CLEAR);
+	zfcp_erp_modify_lun_status(sdev, "erlblk1", NULL,
+				   ZFCP_STATUS_COMMON_UNBLOCKED | clear_mask,
+				   ZFCP_CLEAR);
 }
 
-static void _zfcp_erp_unit_reopen(struct zfcp_unit *unit, int clear, char *id,
-				  void *ref, u32 act_status)
+static void _zfcp_erp_lun_reopen(struct scsi_device *sdev, int clear, char *id,
+				 void *ref, u32 act_status)
 {
-	struct zfcp_adapter *adapter = unit->port->adapter;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
 
-	zfcp_erp_unit_block(unit, clear);
+	zfcp_erp_lun_block(sdev, clear);
 
-	if (atomic_read(&unit->status) & ZFCP_STATUS_COMMON_ERP_FAILED)
+	if (atomic_read(&zfcp_sdev->status) & ZFCP_STATUS_COMMON_ERP_FAILED)
 		return;
 
-	zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_UNIT,
-				adapter, unit->port, unit, id, ref, act_status);
+	zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_LUN, adapter,
+				zfcp_sdev->port, sdev, id, ref, act_status);
 }
 
 /**
- * zfcp_erp_unit_reopen - initiate reopen of a unit
- * @unit: unit to be reopened
- * @clear_mask: specifies flags in unit status to be cleared
+ * zfcp_erp_lun_reopen - initiate reopen of a LUN
+ * @sdev: SCSI device / LUN to be reopened
+ * @clear_mask: specifies flags in LUN status to be cleared
  * Return: 0 on success, < 0 on error
  */
-void zfcp_erp_unit_reopen(struct zfcp_unit *unit, int clear, char *id,
-			  void *ref)
+void zfcp_erp_lun_reopen(struct scsi_device *sdev, int clear, char *id,
+			 void *ref)
 {
 	unsigned long flags;
-	struct zfcp_port *port = unit->port;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_port *port = zfcp_sdev->port;
 	struct zfcp_adapter *adapter = port->adapter;
 
 	write_lock_irqsave(&adapter->erp_lock, flags);
-	_zfcp_erp_unit_reopen(unit, clear, id, ref, 0);
+	_zfcp_erp_lun_reopen(sdev, clear, id, ref, 0);
 	write_unlock_irqrestore(&adapter->erp_lock, flags);
 }
 
 /**
- * zfcp_erp_unit_shutdown - Shutdown unit
- * @unit: Unit to shut down.
+ * zfcp_erp_lun_shutdown - Shutdown LUN
+ * @sdev: SCSI device / LUN to shut down.
  * @clear: Status flags to clear.
  * @id: Id for debug trace event.
  * @ref: Reference for debug trace event.
  */
-void zfcp_erp_unit_shutdown(struct zfcp_unit *unit, int clear, char *id,
-			    void *ref)
+void zfcp_erp_lun_shutdown(struct scsi_device *sdev, int clear, char *id,
+			   void *ref)
 {
 	int flags = ZFCP_STATUS_COMMON_RUNNING | ZFCP_STATUS_COMMON_ERP_FAILED;
-	zfcp_erp_unit_reopen(unit, clear | flags, id, ref);
+	zfcp_erp_lun_reopen(sdev, clear | flags, id, ref);
 }
 
 /**
- * zfcp_erp_unit_shutdown_wait - Shutdown unit and wait for erp completion
- * @unit: Unit to shut down.
+ * zfcp_erp_lun_shutdown_wait - Shutdown LUN and wait for erp completion
+ * @sdev: SCSI device / LUN to shut down.
  * @id: Id for debug trace event.
  *
- * Do not acquire a reference for the unit when creating the ERP
+ * Do not acquire a reference for the LUN when creating the ERP
  * action. It is safe, because this function waits for the ERP to
- * complete first.
+ * complete first. This allows to shutdown the LUN, even when the SCSI
+ * device is in the state SDEV_DEL when scsi_device_get will fail.
  */
-void zfcp_erp_unit_shutdown_wait(struct zfcp_unit *unit, char *id)
+void zfcp_erp_lun_shutdown_wait(struct scsi_device *sdev, char *id)
 {
 	unsigned long flags;
-	struct zfcp_port *port = unit->port;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_port *port = zfcp_sdev->port;
 	struct zfcp_adapter *adapter = port->adapter;
 	int clear = ZFCP_STATUS_COMMON_RUNNING | ZFCP_STATUS_COMMON_ERP_FAILED;
 
 	write_lock_irqsave(&adapter->erp_lock, flags);
-	_zfcp_erp_unit_reopen(unit, clear, id, NULL, ZFCP_STATUS_ERP_NO_REF);
+	_zfcp_erp_lun_reopen(sdev, clear, id, NULL, ZFCP_STATUS_ERP_NO_REF);
 	write_unlock_irqrestore(&adapter->erp_lock, flags);
 
 	zfcp_erp_wait(adapter);
@@ -492,11 +502,13 @@ static void zfcp_erp_port_unblock(struct
 	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &port->status);
 }
 
-static void zfcp_erp_unit_unblock(struct zfcp_unit *unit)
+static void zfcp_erp_lun_unblock(struct scsi_device *sdev)
 {
-	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &unit->status))
-		zfcp_dbf_rec_unit("eruubl1", NULL, unit);
-	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &unit->status);
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+
+	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &zfcp_sdev->status))
+		zfcp_dbf_rec_lun("erlubl1", NULL, sdev);
+	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &zfcp_sdev->status);
 }
 
 static void zfcp_erp_action_to_running(struct zfcp_erp_action *erp_action)
@@ -584,15 +596,14 @@ static void _zfcp_erp_port_reopen_all(st
 	read_unlock(&adapter->port_list_lock);
 }
 
-static void _zfcp_erp_unit_reopen_all(struct zfcp_port *port, int clear,
-				      char *id, void *ref)
+static void _zfcp_erp_lun_reopen_all(struct zfcp_port *port, int clear,
+				     char *id, void *ref)
 {
-	struct zfcp_unit *unit;
+	struct scsi_device *sdev;
 
-	read_lock(&port->unit_list_lock);
-	list_for_each_entry(unit, &port->unit_list, list)
-		_zfcp_erp_unit_reopen(unit, clear, id, ref, 0);
-	read_unlock(&port->unit_list_lock);
+	shost_for_each_device(sdev, port->adapter->scsi_host)
+		if (sdev_to_zfcp(sdev)->port == port)
+			_zfcp_erp_lun_reopen(sdev, clear, id, ref, 0);
 }
 
 static void zfcp_erp_strategy_followup_failed(struct zfcp_erp_action *act)
@@ -607,8 +618,8 @@ static void zfcp_erp_strategy_followup_f
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
 		_zfcp_erp_port_reopen(act->port, 0, "ersff_3", NULL);
 		break;
-	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		_zfcp_erp_unit_reopen(act->unit, 0, "ersff_4", NULL, 0);
+	case ZFCP_ERP_ACTION_REOPEN_LUN:
+		_zfcp_erp_lun_reopen(act->sdev, 0, "ersff_4", NULL, 0);
 		break;
 	}
 }
@@ -623,7 +634,7 @@ static void zfcp_erp_strategy_followup_s
 		_zfcp_erp_port_reopen(act->port, 0, "ersfs_2", NULL);
 		break;
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
-		_zfcp_erp_unit_reopen_all(act->port, 0, "ersfs_3", NULL);
+		_zfcp_erp_lun_reopen_all(act->port, 0, "ersfs_3", NULL);
 		break;
 	}
 }
@@ -767,7 +778,7 @@ static void zfcp_erp_adapter_strategy_cl
 	zfcp_fsf_req_dismiss_all(adapter);
 	adapter->fsf_req_seq_no = 0;
 	zfcp_fc_wka_ports_force_offline(adapter->gs);
-	/* all ports and units are closed */
+	/* all ports and LUNs are closed */
 	zfcp_erp_modify_adapter_status(adapter, "erascl1", NULL,
 				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
 
@@ -958,82 +969,86 @@ close_init_done:
 	return zfcp_erp_port_strategy_open_common(erp_action);
 }
 
-static void zfcp_erp_unit_strategy_clearstati(struct zfcp_unit *unit)
+static void zfcp_erp_lun_strategy_clearstati(struct scsi_device *sdev)
 {
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+
 	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
-			  ZFCP_STATUS_UNIT_SHARED |
-			  ZFCP_STATUS_UNIT_READONLY,
-			  &unit->status);
+			  ZFCP_STATUS_LUN_SHARED | ZFCP_STATUS_LUN_READONLY,
+			  &zfcp_sdev->status);
 }
 
-static int zfcp_erp_unit_strategy_close(struct zfcp_erp_action *erp_action)
+static int zfcp_erp_lun_strategy_close(struct zfcp_erp_action *erp_action)
 {
-	int retval = zfcp_fsf_close_unit(erp_action);
+	int retval = zfcp_fsf_close_lun(erp_action);
 	if (retval == -ENOMEM)
 		return ZFCP_ERP_NOMEM;
-	erp_action->step = ZFCP_ERP_STEP_UNIT_CLOSING;
+	erp_action->step = ZFCP_ERP_STEP_LUN_CLOSING;
 	if (retval)
 		return ZFCP_ERP_FAILED;
 	return ZFCP_ERP_CONTINUES;
 }
 
-static int zfcp_erp_unit_strategy_open(struct zfcp_erp_action *erp_action)
+static int zfcp_erp_lun_strategy_open(struct zfcp_erp_action *erp_action)
 {
-	int retval = zfcp_fsf_open_unit(erp_action);
+	int retval = zfcp_fsf_open_lun(erp_action);
 	if (retval == -ENOMEM)
 		return ZFCP_ERP_NOMEM;
-	erp_action->step = ZFCP_ERP_STEP_UNIT_OPENING;
+	erp_action->step = ZFCP_ERP_STEP_LUN_OPENING;
 	if (retval)
 		return  ZFCP_ERP_FAILED;
 	return ZFCP_ERP_CONTINUES;
 }
 
-static int zfcp_erp_unit_strategy(struct zfcp_erp_action *erp_action)
+static int zfcp_erp_lun_strategy(struct zfcp_erp_action *erp_action)
 {
-	struct zfcp_unit *unit = erp_action->unit;
+	struct scsi_device *sdev = erp_action->sdev;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 
 	switch (erp_action->step) {
 	case ZFCP_ERP_STEP_UNINITIALIZED:
-		zfcp_erp_unit_strategy_clearstati(unit);
-		if (atomic_read(&unit->status) & ZFCP_STATUS_COMMON_OPEN)
-			return zfcp_erp_unit_strategy_close(erp_action);
+		zfcp_erp_lun_strategy_clearstati(sdev);
+		if (atomic_read(&zfcp_sdev->status) & ZFCP_STATUS_COMMON_OPEN)
+			return zfcp_erp_lun_strategy_close(erp_action);
 		/* already closed, fall through */
-	case ZFCP_ERP_STEP_UNIT_CLOSING:
-		if (atomic_read(&unit->status) & ZFCP_STATUS_COMMON_OPEN)
+	case ZFCP_ERP_STEP_LUN_CLOSING:
+		if (atomic_read(&zfcp_sdev->status) & ZFCP_STATUS_COMMON_OPEN)
 			return ZFCP_ERP_FAILED;
 		if (erp_action->status & ZFCP_STATUS_ERP_CLOSE_ONLY)
 			return ZFCP_ERP_EXIT;
-		return zfcp_erp_unit_strategy_open(erp_action);
+		return zfcp_erp_lun_strategy_open(erp_action);
 
-	case ZFCP_ERP_STEP_UNIT_OPENING:
-		if (atomic_read(&unit->status) & ZFCP_STATUS_COMMON_OPEN)
+	case ZFCP_ERP_STEP_LUN_OPENING:
+		if (atomic_read(&zfcp_sdev->status) & ZFCP_STATUS_COMMON_OPEN)
 			return ZFCP_ERP_SUCCEEDED;
 	}
 	return ZFCP_ERP_FAILED;
 }
 
-static int zfcp_erp_strategy_check_unit(struct zfcp_unit *unit, int result)
+static int zfcp_erp_strategy_check_lun(struct scsi_device *sdev, int result)
 {
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+
 	switch (result) {
 	case ZFCP_ERP_SUCCEEDED :
-		atomic_set(&unit->erp_counter, 0);
-		zfcp_erp_unit_unblock(unit);
+		atomic_set(&zfcp_sdev->erp_counter, 0);
+		zfcp_erp_lun_unblock(sdev);
 		break;
 	case ZFCP_ERP_FAILED :
-		atomic_inc(&unit->erp_counter);
-		if (atomic_read(&unit->erp_counter) > ZFCP_MAX_ERPS) {
-			dev_err(&unit->port->adapter->ccw_device->dev,
-				"ERP failed for unit 0x%016Lx on "
+		atomic_inc(&zfcp_sdev->erp_counter);
+		if (atomic_read(&zfcp_sdev->erp_counter) > ZFCP_MAX_ERPS) {
+			dev_err(&zfcp_sdev->port->adapter->ccw_device->dev,
+				"ERP failed for LUN 0x%016Lx on "
 				"port 0x%016Lx\n",
-				(unsigned long long)unit->fcp_lun,
-				(unsigned long long)unit->port->wwpn);
-			zfcp_erp_unit_failed(unit, "erusck1", NULL);
+				(unsigned long long)zfcp_scsi_dev_lun(sdev),
+				(unsigned long long)zfcp_sdev->port->wwpn);
+			zfcp_erp_lun_failed(sdev, "ersckl1", NULL);
 		}
 		break;
 	}
 
-	if (atomic_read(&unit->status) & ZFCP_STATUS_COMMON_ERP_FAILED) {
-		zfcp_erp_unit_block(unit, 0);
+	if (atomic_read(&zfcp_sdev->status) & ZFCP_STATUS_COMMON_ERP_FAILED) {
+		zfcp_erp_lun_block(sdev, 0);
 		result = ZFCP_ERP_EXIT;
 	}
 	return result;
@@ -1101,12 +1116,12 @@ static int zfcp_erp_strategy_check_targe
 {
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	struct zfcp_port *port = erp_action->port;
-	struct zfcp_unit *unit = erp_action->unit;
+	struct scsi_device *sdev = erp_action->sdev;
 
 	switch (erp_action->action) {
 
-	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		result = zfcp_erp_strategy_check_unit(unit, result);
+	case ZFCP_ERP_ACTION_REOPEN_LUN:
+		result = zfcp_erp_strategy_check_lun(sdev, result);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
@@ -1141,7 +1156,8 @@ static int zfcp_erp_strategy_statechange
 	int action = act->action;
 	struct zfcp_adapter *adapter = act->adapter;
 	struct zfcp_port *port = act->port;
-	struct zfcp_unit *unit = act->unit;
+	struct scsi_device *sdev = act->sdev;
+	struct zfcp_scsi_dev *zfcp_sdev;
 	u32 erp_status = act->status;
 
 	switch (action) {
@@ -1164,11 +1180,12 @@ static int zfcp_erp_strategy_statechange
 		}
 		break;
 
-	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		if (zfcp_erp_strat_change_det(&unit->status, erp_status)) {
-			_zfcp_erp_unit_reopen(unit,
-					      ZFCP_STATUS_COMMON_ERP_FAILED,
-					      "ersscg3", NULL, 0);
+	case ZFCP_ERP_ACTION_REOPEN_LUN:
+		zfcp_sdev = sdev_to_zfcp(sdev);
+		if (zfcp_erp_strat_change_det(&zfcp_sdev->status, erp_status)) {
+			_zfcp_erp_lun_reopen(sdev,
+					     ZFCP_STATUS_COMMON_ERP_FAILED,
+					     "ersscg3", NULL, 0);
 			return ZFCP_ERP_EXIT;
 		}
 		break;
@@ -1179,6 +1196,7 @@ static int zfcp_erp_strategy_statechange
 static void zfcp_erp_action_dequeue(struct zfcp_erp_action *erp_action)
 {
 	struct zfcp_adapter *adapter = erp_action->adapter;
+	struct zfcp_scsi_dev *zfcp_sdev;
 
 	adapter->erp_total_count--;
 	if (erp_action->status & ZFCP_STATUS_ERP_LOWMEM) {
@@ -1190,9 +1208,10 @@ static void zfcp_erp_action_dequeue(stru
 	zfcp_dbf_rec_action("eractd1", erp_action);
 
 	switch (erp_action->action) {
-	case ZFCP_ERP_ACTION_REOPEN_UNIT:
+	case ZFCP_ERP_ACTION_REOPEN_LUN:
+		zfcp_sdev = sdev_to_zfcp(erp_action->sdev);
 		atomic_clear_mask(ZFCP_STATUS_COMMON_ERP_INUSE,
-				  &erp_action->unit->status);
+				  &zfcp_sdev->status);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
@@ -1212,12 +1231,12 @@ static void zfcp_erp_action_cleanup(stru
 {
 	struct zfcp_adapter *adapter = act->adapter;
 	struct zfcp_port *port = act->port;
-	struct zfcp_unit *unit = act->unit;
+	struct scsi_device *sdev = act->sdev;
 
 	switch (act->action) {
-	case ZFCP_ERP_ACTION_REOPEN_UNIT:
+	case ZFCP_ERP_ACTION_REOPEN_LUN:
 		if (!(act->status & ZFCP_STATUS_ERP_NO_REF))
-			put_device(&unit->dev);
+			scsi_device_put(sdev);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
@@ -1248,8 +1267,8 @@ static int zfcp_erp_strategy_do_action(s
 		return zfcp_erp_port_forced_strategy(erp_action);
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
 		return zfcp_erp_port_strategy(erp_action);
-	case ZFCP_ERP_ACTION_REOPEN_UNIT:
-		return zfcp_erp_unit_strategy(erp_action);
+	case ZFCP_ERP_ACTION_REOPEN_LUN:
+		return zfcp_erp_lun_strategy(erp_action);
 	}
 	return ZFCP_ERP_FAILED;
 }
@@ -1426,15 +1445,15 @@ void zfcp_erp_port_failed(struct zfcp_po
 }
 
 /**
- * zfcp_erp_unit_failed - Set unit status to failed.
- * @unit: Failed unit.
+ * zfcp_erp_lun_failed - Set LUN status to failed.
+ * @sdev: Failed SCSI device / LUN
  * @id: Event id for debug trace.
  * @ref: Reference for debug trace.
  */
-void zfcp_erp_unit_failed(struct zfcp_unit *unit, char *id, void *ref)
+void zfcp_erp_lun_failed(struct scsi_device *sdev, char *id, void *ref)
 {
-	zfcp_erp_modify_unit_status(unit, id, ref,
-				    ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
+	zfcp_erp_modify_lun_status(sdev, id, ref,
+				   ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
 }
 
 /**
@@ -1456,7 +1475,7 @@ void zfcp_erp_wait(struct zfcp_adapter *
  * @mask: status bits to change
  * @set_or_clear: ZFCP_SET or ZFCP_CLEAR
  *
- * Changes in common status bits are propagated to attached ports and units.
+ * Changes in common status bits are propagated to attached ports and LUNs.
  */
 void zfcp_erp_modify_adapter_status(struct zfcp_adapter *adapter, char *id,
 				    void *ref, u32 mask, int set_or_clear)
@@ -1494,13 +1513,12 @@ void zfcp_erp_modify_adapter_status(stru
  * @mask: status bits to change
  * @set_or_clear: ZFCP_SET or ZFCP_CLEAR
  *
- * Changes in common status bits are propagated to attached units.
+ * Changes in common status bits are propagated to attached LUNs.
  */
 void zfcp_erp_modify_port_status(struct zfcp_port *port, char *id, void *ref,
 				 u32 mask, int set_or_clear)
 {
-	struct zfcp_unit *unit;
-	unsigned long flags;
+	struct scsi_device *sdev;
 	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
 
 	if (set_or_clear == ZFCP_SET) {
@@ -1515,36 +1533,37 @@ void zfcp_erp_modify_port_status(struct
 			atomic_set(&port->erp_counter, 0);
 	}
 
-	if (common_mask) {
-		read_lock_irqsave(&port->unit_list_lock, flags);
-		list_for_each_entry(unit, &port->unit_list, list)
-			zfcp_erp_modify_unit_status(unit, id, ref, common_mask,
-						    set_or_clear);
-		read_unlock_irqrestore(&port->unit_list_lock, flags);
-	}
+	if (common_mask)
+		shost_for_each_device(sdev, port->adapter->scsi_host)
+			if (sdev_to_zfcp(sdev)->port == port)
+				zfcp_erp_modify_lun_status(sdev, id, ref,
+							   common_mask,
+							   set_or_clear);
 }
 
 /**
- * zfcp_erp_modify_unit_status - change unit status bits
- * @unit: unit to change the status bits
+ * zfcp_erp_modify_lun_status - change LUN status bits
+ * @sdev: SCSI device / LUN where to change the status bits
  * @id: id for the debug trace
  * @ref: reference for the debug trace
  * @mask: status bits to change
  * @set_or_clear: ZFCP_SET or ZFCP_CLEAR
  */
-void zfcp_erp_modify_unit_status(struct zfcp_unit *unit, char *id, void *ref,
-				 u32 mask, int set_or_clear)
+void zfcp_erp_modify_lun_status(struct scsi_device *sdev, char *id, void *ref,
+				u32 mask, int set_or_clear)
 {
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+
 	if (set_or_clear == ZFCP_SET) {
-		if (status_change_set(mask, &unit->status))
-			zfcp_dbf_rec_unit(id, ref, unit);
-		atomic_set_mask(mask, &unit->status);
+		if (status_change_set(mask, &zfcp_sdev->status))
+			zfcp_dbf_rec_lun(id, ref, sdev);
+		atomic_set_mask(mask, &zfcp_sdev->status);
 	} else {
-		if (status_change_clear(mask, &unit->status))
-			zfcp_dbf_rec_unit(id, ref, unit);
-		atomic_clear_mask(mask, &unit->status);
+		if (status_change_clear(mask, &zfcp_sdev->status))
+			zfcp_dbf_rec_lun(id, ref, sdev);
+		atomic_clear_mask(mask, &zfcp_sdev->status);
 		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED) {
-			atomic_set(&unit->erp_counter, 0);
+			atomic_set(&zfcp_sdev->erp_counter, 0);
 		}
 	}
 }
@@ -1563,16 +1582,16 @@ void zfcp_erp_port_boxed(struct zfcp_por
 }
 
 /**
- * zfcp_erp_unit_boxed - Mark unit as "boxed" and start ERP
- * @port: The "boxed" unit.
+ * zfcp_erp_lun_boxed - Mark LUN as "boxed" and start ERP
+ * @sdev: The "boxed" SCSI device / LUN.
  * @id: The debug trace id.
- * @id: Reference for the debug trace.
+ * @ref: Reference for the debug trace.
  */
-void zfcp_erp_unit_boxed(struct zfcp_unit *unit, char *id, void *ref)
+void zfcp_erp_lun_boxed(struct scsi_device *sdev, char *id, void *ref)
 {
-	zfcp_erp_modify_unit_status(unit, id, ref,
-				    ZFCP_STATUS_COMMON_ACCESS_BOXED, ZFCP_SET);
-	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
+	zfcp_erp_modify_lun_status(sdev, id, ref,
+				   ZFCP_STATUS_COMMON_ACCESS_BOXED, ZFCP_SET);
+	zfcp_erp_lun_reopen(sdev, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
 }
 
 /**
@@ -1582,7 +1601,7 @@ void zfcp_erp_unit_boxed(struct zfcp_uni
  * @ref: reference for debug trace
  *
  * Since the adapter has denied access, stop using the port and the
- * attached units.
+ * attached LUNs.
  */
 void zfcp_erp_port_access_denied(struct zfcp_port *port, char *id, void *ref)
 {
@@ -1592,44 +1611,44 @@ void zfcp_erp_port_access_denied(struct
 }
 
 /**
- * zfcp_erp_unit_access_denied - Adapter denied access to unit.
- * @unit: unit where access has been denied
+ * zfcp_erp_lun_access_denied - Adapter denied access to LUN.
+ * @sdev: SCSI device / LUN where access has been denied
  * @id: id for debug trace
  * @ref: reference for debug trace
  *
- * Since the adapter has denied access, stop using the unit.
+ * Since the adapter has denied access, stop using the LUN.
  */
-void zfcp_erp_unit_access_denied(struct zfcp_unit *unit, char *id, void *ref)
+void zfcp_erp_lun_access_denied(struct scsi_device *sdev, char *id, void *ref)
 {
-	zfcp_erp_modify_unit_status(unit, id, ref,
-				    ZFCP_STATUS_COMMON_ERP_FAILED |
-				    ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
+	zfcp_erp_modify_lun_status(sdev, id, ref,
+				   ZFCP_STATUS_COMMON_ERP_FAILED |
+				   ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
 }
 
-static void zfcp_erp_unit_access_changed(struct zfcp_unit *unit, char *id,
-					 void *ref)
+static void zfcp_erp_lun_access_changed(struct scsi_device *sdev, char *id,
+					void *ref)
 {
-	int status = atomic_read(&unit->status);
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	int status = atomic_read(&zfcp_sdev->status);
+
 	if (!(status & (ZFCP_STATUS_COMMON_ACCESS_DENIED |
 			ZFCP_STATUS_COMMON_ACCESS_BOXED)))
 		return;
 
-	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
+	zfcp_erp_lun_reopen(sdev, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
 }
 
 static void zfcp_erp_port_access_changed(struct zfcp_port *port, char *id,
 					 void *ref)
 {
-	struct zfcp_unit *unit;
-	unsigned long flags;
+	struct scsi_device *sdev;
 	int status = atomic_read(&port->status);
 
 	if (!(status & (ZFCP_STATUS_COMMON_ACCESS_DENIED |
 			ZFCP_STATUS_COMMON_ACCESS_BOXED))) {
-		read_lock_irqsave(&port->unit_list_lock, flags);
-		list_for_each_entry(unit, &port->unit_list, list)
-				    zfcp_erp_unit_access_changed(unit, id, ref);
-		read_unlock_irqrestore(&port->unit_list_lock, flags);
+		shost_for_each_device(sdev, port->adapter->scsi_host)
+			if (sdev_to_zfcp(sdev)->port == port)
+				zfcp_erp_lun_access_changed(sdev, id, ref);
 		return;
 	}
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_ext.h linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6/drivers/s390/scsi/zfcp_ext.h	2010-09-08 08:49:28.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_ext.h	2010-09-08 08:49:28.000000000 +0200
@@ -42,10 +42,10 @@ extern void zfcp_dbf_rec_thread(char *,
 extern void zfcp_dbf_rec_thread_lock(char *, struct zfcp_dbf *);
 extern void zfcp_dbf_rec_adapter(char *, void *, struct zfcp_dbf *);
 extern void zfcp_dbf_rec_port(char *, void *, struct zfcp_port *);
-extern void zfcp_dbf_rec_unit(char *, void *, struct zfcp_unit *);
+extern void zfcp_dbf_rec_lun(char *, void *, struct scsi_device *);
 extern void zfcp_dbf_rec_trigger(char *, void *, u8, u8, void *,
 				 struct zfcp_adapter *, struct zfcp_port *,
-				 struct zfcp_unit *);
+				 struct scsi_device *);
 extern void zfcp_dbf_rec_action(char *, struct zfcp_erp_action *);
 extern void _zfcp_dbf_hba_fsf_response(const char *, int, struct zfcp_fsf_req *,
 				       struct zfcp_dbf *);
@@ -76,20 +76,20 @@ extern void zfcp_erp_port_shutdown(struc
 extern void zfcp_erp_port_forced_reopen(struct zfcp_port *, int, char *,
 					void *);
 extern void zfcp_erp_port_failed(struct zfcp_port *, char *, void *);
-extern void zfcp_erp_modify_unit_status(struct zfcp_unit *, char *, void *, u32,
-					int);
-extern void zfcp_erp_unit_reopen(struct zfcp_unit *, int, char *, void *);
-extern void zfcp_erp_unit_shutdown(struct zfcp_unit *, int, char *, void *);
-extern void zfcp_erp_unit_shutdown_wait(struct zfcp_unit *, char *);
-extern void zfcp_erp_unit_failed(struct zfcp_unit *, char *, void *);
+extern void zfcp_erp_modify_lun_status(struct scsi_device *, char *, void *,
+				       u32, int);
+extern void zfcp_erp_lun_reopen(struct scsi_device *, int, char *, void *);
+extern void zfcp_erp_lun_shutdown(struct scsi_device *, int, char *, void *);
+extern void zfcp_erp_lun_shutdown_wait(struct scsi_device *, char *);
+extern void zfcp_erp_lun_failed(struct scsi_device *, char *, void *);
 extern int  zfcp_erp_thread_setup(struct zfcp_adapter *);
 extern void zfcp_erp_thread_kill(struct zfcp_adapter *);
 extern void zfcp_erp_wait(struct zfcp_adapter *);
 extern void zfcp_erp_notify(struct zfcp_erp_action *, unsigned long);
 extern void zfcp_erp_port_boxed(struct zfcp_port *, char *, void *);
-extern void zfcp_erp_unit_boxed(struct zfcp_unit *, char *, void *);
+extern void zfcp_erp_lun_boxed(struct scsi_device *, char *, void *);
 extern void zfcp_erp_port_access_denied(struct zfcp_port *, char *, void *);
-extern void zfcp_erp_unit_access_denied(struct zfcp_unit *, char *, void *);
+extern void zfcp_erp_lun_access_denied(struct scsi_device *, char *, void *);
 extern void zfcp_erp_adapter_access_changed(struct zfcp_adapter *, char *,
 					    void *);
 extern void zfcp_erp_timeout_handler(unsigned long);
@@ -117,8 +117,8 @@ extern int zfcp_fsf_open_wka_port(struct
 extern int zfcp_fsf_close_wka_port(struct zfcp_fc_wka_port *);
 extern int zfcp_fsf_close_port(struct zfcp_erp_action *);
 extern int zfcp_fsf_close_physical_port(struct zfcp_erp_action *);
-extern int zfcp_fsf_open_unit(struct zfcp_erp_action *);
-extern int zfcp_fsf_close_unit(struct zfcp_erp_action *);
+extern int zfcp_fsf_open_lun(struct zfcp_erp_action *);
+extern int zfcp_fsf_close_lun(struct zfcp_erp_action *);
 extern int zfcp_fsf_exchange_config_data(struct zfcp_erp_action *);
 extern int zfcp_fsf_exchange_config_data_sync(struct zfcp_qdio *,
 					      struct fsf_qtcb_bottom_config *);
@@ -134,12 +134,10 @@ extern int zfcp_fsf_send_ct(struct zfcp_
 			    mempool_t *, unsigned int);
 extern int zfcp_fsf_send_els(struct zfcp_adapter *, u32,
 			     struct zfcp_fsf_ct_els *, unsigned int);
-extern int zfcp_fsf_send_fcp_command_task(struct zfcp_unit *,
-					  struct scsi_cmnd *);
+extern int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *);
 extern void zfcp_fsf_req_free(struct zfcp_fsf_req *);
-extern struct zfcp_fsf_req *zfcp_fsf_send_fcp_ctm(struct zfcp_unit *, u8);
-extern struct zfcp_fsf_req *zfcp_fsf_abort_fcp_command(unsigned long,
-						       struct zfcp_unit *);
+extern struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *, u8);
+extern struct zfcp_fsf_req *zfcp_fsf_abort_fcp_cmnd(struct scsi_cmnd *);
 extern void zfcp_fsf_reqid_check(struct zfcp_qdio *, int);
 
 /* zfcp_qdio.c */
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2010-09-08 08:49:06.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2010-09-08 08:49:28.000000000 +0200
@@ -86,17 +86,19 @@ static void zfcp_fsf_access_denied_port(
 	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 }
 
-static void zfcp_fsf_access_denied_unit(struct zfcp_fsf_req *req,
-					struct zfcp_unit *unit)
+static void zfcp_fsf_access_denied_lun(struct zfcp_fsf_req *req,
+				       struct scsi_device *sdev)
 {
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 	dev_warn(&req->adapter->ccw_device->dev,
-		 "Access denied to unit 0x%016Lx on port 0x%016Lx\n",
-		 (unsigned long long)unit->fcp_lun,
-		 (unsigned long long)unit->port->wwpn);
+		 "Access denied to LUN 0x%016Lx on port 0x%016Lx\n",
+		 (unsigned long long)zfcp_scsi_dev_lun(sdev),
+		 (unsigned long long)zfcp_sdev->port->wwpn);
 	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[0]);
 	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[1]);
-	zfcp_erp_unit_access_denied(unit, "fsuad_1", req);
+	zfcp_erp_lun_access_denied(sdev, "fsadl_1", req);
 	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 }
 
@@ -811,7 +813,8 @@ out:
 
 static void zfcp_fsf_abort_fcp_command_handler(struct zfcp_fsf_req *req)
 {
-	struct zfcp_unit *unit = req->data;
+	struct scsi_device *sdev = req->data;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 	union fsf_status_qual *fsq = &req->qtcb->header.fsf_status_qual;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
@@ -820,14 +823,15 @@ static void zfcp_fsf_abort_fcp_command_h
 	switch (req->qtcb->header.fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
 		if (fsq->word[0] == fsq->word[1]) {
-			zfcp_erp_adapter_reopen(unit->port->adapter, 0,
+			zfcp_erp_adapter_reopen(zfcp_sdev->port->adapter, 0,
 						"fsafch1", req);
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		}
 		break;
 	case FSF_LUN_HANDLE_NOT_VALID:
 		if (fsq->word[0] == fsq->word[1]) {
-			zfcp_erp_port_reopen(unit->port, 0, "fsafch2", req);
+			zfcp_erp_port_reopen(zfcp_sdev->port, 0, "fsafch2",
+					     req);
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		}
 		break;
@@ -835,17 +839,17 @@ static void zfcp_fsf_abort_fcp_command_h
 		req->status |= ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED;
 		break;
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(unit->port, "fsafch3", req);
+		zfcp_erp_port_boxed(zfcp_sdev->port, "fsafch3", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_BOXED:
-		zfcp_erp_unit_boxed(unit, "fsafch4", req);
+		zfcp_erp_lun_boxed(sdev, "fsafch4", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
                 break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (fsq->word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			zfcp_fc_test_link(unit->port);
+			zfcp_fc_test_link(zfcp_sdev->port);
 			/* fall through */
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -859,17 +863,18 @@ static void zfcp_fsf_abort_fcp_command_h
 }
 
 /**
- * zfcp_fsf_abort_fcp_command - abort running SCSI command
- * @old_req_id: unsigned long
- * @unit: pointer to struct zfcp_unit
+ * zfcp_fsf_abort_fcp_cmnd - abort running SCSI command
+ * @scmnd: The SCSI command to abort
  * Returns: pointer to struct zfcp_fsf_req
  */
 
-struct zfcp_fsf_req *zfcp_fsf_abort_fcp_command(unsigned long old_req_id,
-						struct zfcp_unit *unit)
+struct zfcp_fsf_req *zfcp_fsf_abort_fcp_cmnd(struct scsi_cmnd *scmnd)
 {
 	struct zfcp_fsf_req *req = NULL;
-	struct zfcp_qdio *qdio = unit->port->adapter->qdio;
+	struct scsi_device *sdev = scmnd->device;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_qdio *qdio = zfcp_sdev->port->adapter->qdio;
+	unsigned long old_req_id = (unsigned long) scmnd->host_scribble;
 
 	spin_lock_bh(&qdio->req_q_lock);
 	if (zfcp_qdio_sbal_get(qdio))
@@ -882,16 +887,16 @@ struct zfcp_fsf_req *zfcp_fsf_abort_fcp_
 		goto out;
 	}
 
-	if (unlikely(!(atomic_read(&unit->status) &
+	if (unlikely(!(atomic_read(&zfcp_sdev->status) &
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		goto out_error_free;
 
 	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
-	req->data = unit;
+	req->data = zfcp_sdev;
 	req->handler = zfcp_fsf_abort_fcp_command_handler;
-	req->qtcb->header.lun_handle = unit->handle;
-	req->qtcb->header.port_handle = unit->port->handle;
+	req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;
+	req->qtcb->header.port_handle = zfcp_sdev->port->handle;
 	req->qtcb->bottom.support.req_handle = (u64) old_req_id;
 
 	zfcp_fsf_start_timer(req, ZFCP_SCSI_ER_TIMEOUT);
@@ -1666,7 +1671,7 @@ static void zfcp_fsf_close_physical_port
 {
 	struct zfcp_port *port = req->data;
 	struct fsf_qtcb_header *header = &req->qtcb->header;
-	struct zfcp_unit *unit;
+	struct scsi_device *sdev;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return;
@@ -1683,11 +1688,10 @@ static void zfcp_fsf_close_physical_port
 		/* can't use generic zfcp_erp_modify_port_status because
 		 * ZFCP_STATUS_COMMON_OPEN must not be reset for the port */
 		atomic_clear_mask(ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
-		read_lock(&port->unit_list_lock);
-		list_for_each_entry(unit, &port->unit_list, list)
-			atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
-					  &unit->status);
-		read_unlock(&port->unit_list_lock);
+		shost_for_each_device(sdev, port->adapter->scsi_host)
+			if (sdev_to_zfcp(sdev)->port == port)
+				atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
+						  &sdev_to_zfcp(sdev)->status);
 		zfcp_erp_port_boxed(port, "fscpph2", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -1705,11 +1709,10 @@ static void zfcp_fsf_close_physical_port
 		 * ZFCP_STATUS_COMMON_OPEN must not be reset for the port
 		 */
 		atomic_clear_mask(ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
-		read_lock(&port->unit_list_lock);
-		list_for_each_entry(unit, &port->unit_list, list)
-			atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
-					  &unit->status);
-		read_unlock(&port->unit_list_lock);
+		shost_for_each_device(sdev, port->adapter->scsi_host)
+			if (sdev_to_zfcp(sdev)->port == port)
+				atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN,
+						  &sdev_to_zfcp(sdev)->status);
 		break;
 	}
 }
@@ -1758,10 +1761,11 @@ out:
 	return retval;
 }
 
-static void zfcp_fsf_open_unit_handler(struct zfcp_fsf_req *req)
+static void zfcp_fsf_open_lun_handler(struct zfcp_fsf_req *req)
 {
 	struct zfcp_adapter *adapter = req->adapter;
-	struct zfcp_unit *unit = req->data;
+	struct scsi_device *sdev = req->data;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 	struct fsf_qtcb_bottom_support *bottom = &req->qtcb->bottom.support;
 	struct fsf_queue_designator *queue_designator =
@@ -1773,24 +1777,24 @@ static void zfcp_fsf_open_unit_handler(s
 
 	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
 			  ZFCP_STATUS_COMMON_ACCESS_BOXED |
-			  ZFCP_STATUS_UNIT_SHARED |
-			  ZFCP_STATUS_UNIT_READONLY,
-			  &unit->status);
+			  ZFCP_STATUS_LUN_SHARED |
+			  ZFCP_STATUS_LUN_READONLY,
+			  &zfcp_sdev->status);
 
 	switch (header->fsf_status) {
 
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0, "fsouh_1", req);
+		zfcp_erp_adapter_reopen(adapter, 0, "fsouh_1", req);
 		/* fall through */
 	case FSF_LUN_ALREADY_OPEN:
 		break;
 	case FSF_ACCESS_DENIED:
-		zfcp_fsf_access_denied_unit(req, unit);
-		atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
-		atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
+		zfcp_fsf_access_denied_lun(req, sdev);
+		atomic_clear_mask(ZFCP_STATUS_LUN_SHARED, &zfcp_sdev->status);
+		atomic_clear_mask(ZFCP_STATUS_LUN_READONLY, &zfcp_sdev->status);
 		break;
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(unit->port, "fsouh_2", req);
+		zfcp_erp_port_boxed(zfcp_sdev->port, "fsouh_2", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_SHARING_VIOLATION:
@@ -1798,25 +1802,25 @@ static void zfcp_fsf_open_unit_handler(s
 			dev_warn(&adapter->ccw_device->dev,
 				 "LUN 0x%Lx on port 0x%Lx is already in "
 				 "use by CSS%d, MIF Image ID %x\n",
-				 (unsigned long long)unit->fcp_lun,
-				 (unsigned long long)unit->port->wwpn,
+				 (unsigned long long)zfcp_scsi_dev_lun(sdev),
+				 (unsigned long long)zfcp_sdev->port->wwpn,
 				 queue_designator->cssid,
 				 queue_designator->hla);
 		else
 			zfcp_act_eval_err(adapter,
 					  header->fsf_status_qual.word[2]);
-		zfcp_erp_unit_access_denied(unit, "fsouh_3", req);
-		atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
-		atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
+		zfcp_erp_lun_access_denied(sdev, "fsolh_3", req);
+		atomic_clear_mask(ZFCP_STATUS_LUN_SHARED, &zfcp_sdev->status);
+		atomic_clear_mask(ZFCP_STATUS_LUN_READONLY, &zfcp_sdev->status);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_MAXIMUM_NUMBER_OF_LUNS_EXCEEDED:
 		dev_warn(&adapter->ccw_device->dev,
 			 "No handle is available for LUN "
 			 "0x%016Lx on port 0x%016Lx\n",
-			 (unsigned long long)unit->fcp_lun,
-			 (unsigned long long)unit->port->wwpn);
-		zfcp_erp_unit_failed(unit, "fsouh_4", req);
+			 (unsigned long long)zfcp_scsi_dev_lun(sdev),
+			 (unsigned long long)zfcp_sdev->port->wwpn);
+		zfcp_erp_lun_failed(sdev, "fsolh_4", req);
 		/* fall through */
 	case FSF_INVALID_COMMAND_OPTION:
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -1824,7 +1828,7 @@ static void zfcp_fsf_open_unit_handler(s
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (header->fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			zfcp_fc_test_link(unit->port);
+			zfcp_fc_test_link(zfcp_sdev->port);
 			/* fall through */
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -1833,8 +1837,8 @@ static void zfcp_fsf_open_unit_handler(s
 		break;
 
 	case FSF_GOOD:
-		unit->handle = header->lun_handle;
-		atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status);
+		zfcp_sdev->lun_handle = header->lun_handle;
+		atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &zfcp_sdev->status);
 
 		if (!(adapter->connection_features & FSF_FEATURE_NPIV_MODE) &&
 		    (adapter->adapter_features & FSF_FEATURE_LUN_SHARING) &&
@@ -1845,39 +1849,39 @@ static void zfcp_fsf_open_unit_handler(s
 					FSF_UNIT_ACCESS_OUTBOUND_TRANSFER);
 
 			if (!exclusive)
-		                atomic_set_mask(ZFCP_STATUS_UNIT_SHARED,
-						&unit->status);
+				atomic_set_mask(ZFCP_STATUS_LUN_SHARED,
+						&zfcp_sdev->status);
 
 			if (!readwrite) {
-                		atomic_set_mask(ZFCP_STATUS_UNIT_READONLY,
-						&unit->status);
+				atomic_set_mask(ZFCP_STATUS_LUN_READONLY,
+						&zfcp_sdev->status);
 				dev_info(&adapter->ccw_device->dev,
 					 "SCSI device at LUN 0x%016Lx on port "
 					 "0x%016Lx opened read-only\n",
-					 (unsigned long long)unit->fcp_lun,
-					 (unsigned long long)unit->port->wwpn);
+				    (unsigned long long)zfcp_scsi_dev_lun(sdev),
+				    (unsigned long long)zfcp_sdev->port->wwpn);
         		}
 
         		if (exclusive && !readwrite) {
 				dev_err(&adapter->ccw_device->dev,
 					"Exclusive read-only access not "
-					"supported (unit 0x%016Lx, "
+					"supported (LUN 0x%016Lx, "
 					"port 0x%016Lx)\n",
-					(unsigned long long)unit->fcp_lun,
-					(unsigned long long)unit->port->wwpn);
-				zfcp_erp_unit_failed(unit, "fsouh_5", req);
+				    (unsigned long long)zfcp_scsi_dev_lun(sdev),
+				    (unsigned long long)zfcp_sdev->port->wwpn);
+				zfcp_erp_lun_failed(sdev, "fsolh_5", req);
 				req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-				zfcp_erp_unit_shutdown(unit, 0, "fsouh_6", req);
+				zfcp_erp_lun_shutdown(sdev, 0, "fsolh_6", req);
         		} else if (!exclusive && readwrite) {
 				dev_err(&adapter->ccw_device->dev,
 					"Shared read-write access not "
-					"supported (unit 0x%016Lx, port "
+					"supported (LUN 0x%016Lx, port "
 					"0x%016Lx)\n",
-					(unsigned long long)unit->fcp_lun,
-					(unsigned long long)unit->port->wwpn);
-				zfcp_erp_unit_failed(unit, "fsouh_7", req);
+				    (unsigned long long)zfcp_scsi_dev_lun(sdev),
+				    (unsigned long long)zfcp_sdev->port->wwpn);
+				zfcp_erp_lun_failed(sdev, "fsolh_7", req);
 				req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-				zfcp_erp_unit_shutdown(unit, 0, "fsouh_8", req);
+				zfcp_erp_lun_shutdown(sdev, 0, "fsolh_8", req);
         		}
 		}
 		break;
@@ -1885,11 +1889,11 @@ static void zfcp_fsf_open_unit_handler(s
 }
 
 /**
- * zfcp_fsf_open_unit - open unit
+ * zfcp_fsf_open_lun - open LUN
  * @erp_action: pointer to struct zfcp_erp_action
  * Returns: 0 on success, error otherwise
  */
-int zfcp_fsf_open_unit(struct zfcp_erp_action *erp_action)
+int zfcp_fsf_open_lun(struct zfcp_erp_action *erp_action)
 {
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	struct zfcp_qdio *qdio = adapter->qdio;
@@ -1913,9 +1917,9 @@ int zfcp_fsf_open_unit(struct zfcp_erp_a
 	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	req->qtcb->header.port_handle = erp_action->port->handle;
-	req->qtcb->bottom.support.fcp_lun = erp_action->unit->fcp_lun;
-	req->handler = zfcp_fsf_open_unit_handler;
-	req->data = erp_action->unit;
+	req->qtcb->bottom.support.fcp_lun = zfcp_scsi_dev_lun(erp_action->sdev);
+	req->handler = zfcp_fsf_open_lun_handler;
+	req->data = erp_action->sdev;
 	req->erp_action = erp_action;
 	erp_action->fsf_req_id = req->req_id;
 
@@ -1933,30 +1937,32 @@ out:
 	return retval;
 }
 
-static void zfcp_fsf_close_unit_handler(struct zfcp_fsf_req *req)
+static void zfcp_fsf_close_lun_handler(struct zfcp_fsf_req *req)
 {
-	struct zfcp_unit *unit = req->data;
+	struct scsi_device *sdev = req->data;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
 		return;
 
 	switch (req->qtcb->header.fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0, "fscuh_1", req);
+		zfcp_erp_adapter_reopen(zfcp_sdev->port->adapter, 0, "fscuh_1",
+					req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_HANDLE_NOT_VALID:
-		zfcp_erp_port_reopen(unit->port, 0, "fscuh_2", req);
+		zfcp_erp_port_reopen(zfcp_sdev->port, 0, "fscuh_2", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(unit->port, "fscuh_3", req);
+		zfcp_erp_port_boxed(zfcp_sdev->port, "fscuh_3", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		switch (req->qtcb->header.fsf_status_qual.word[0]) {
 		case FSF_SQ_INVOKE_LINK_TEST_PROCEDURE:
-			zfcp_fc_test_link(unit->port);
+			zfcp_fc_test_link(zfcp_sdev->port);
 			/* fall through */
 		case FSF_SQ_ULP_DEPENDENT_ERP_REQUIRED:
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -1964,19 +1970,20 @@ static void zfcp_fsf_close_unit_handler(
 		}
 		break;
 	case FSF_GOOD:
-		atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status);
+		atomic_clear_mask(ZFCP_STATUS_COMMON_OPEN, &zfcp_sdev->status);
 		break;
 	}
 }
 
 /**
- * zfcp_fsf_close_unit - close zfcp unit
- * @erp_action: pointer to struct zfcp_unit
+ * zfcp_fsf_close_LUN - close LUN
+ * @erp_action: pointer to erp_action triggering the "close LUN"
  * Returns: 0 on success, error otherwise
  */
-int zfcp_fsf_close_unit(struct zfcp_erp_action *erp_action)
+int zfcp_fsf_close_lun(struct zfcp_erp_action *erp_action)
 {
 	struct zfcp_qdio *qdio = erp_action->adapter->qdio;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(erp_action->sdev);
 	struct zfcp_fsf_req *req;
 	int retval = -EIO;
 
@@ -1997,9 +2004,9 @@ int zfcp_fsf_close_unit(struct zfcp_erp_
 	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	req->qtcb->header.port_handle = erp_action->port->handle;
-	req->qtcb->header.lun_handle = erp_action->unit->handle;
-	req->handler = zfcp_fsf_close_unit_handler;
-	req->data = erp_action->unit;
+	req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;
+	req->handler = zfcp_fsf_close_lun_handler;
+	req->data = erp_action->sdev;
 	req->erp_action = erp_action;
 	erp_action->fsf_req_id = req->req_id;
 
@@ -2025,7 +2032,7 @@ static void zfcp_fsf_req_trace(struct zf
 {
 	struct fsf_qual_latency_info *lat_in;
 	struct latency_cont *lat = NULL;
-	struct zfcp_unit *unit = req->unit;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scsi->device);
 	struct zfcp_blk_drv_data blktrc;
 	int ticks = req->adapter->timer_ticks;
 
@@ -2048,24 +2055,24 @@ static void zfcp_fsf_req_trace(struct zf
 		case FSF_DATADIR_DIF_READ_STRIP:
 		case FSF_DATADIR_DIF_READ_CONVERT:
 		case FSF_DATADIR_READ:
-			lat = &unit->latencies.read;
+			lat = &zfcp_sdev->latencies.read;
 			break;
 		case FSF_DATADIR_DIF_WRITE_INSERT:
 		case FSF_DATADIR_DIF_WRITE_CONVERT:
 		case FSF_DATADIR_WRITE:
-			lat = &unit->latencies.write;
+			lat = &zfcp_sdev->latencies.write;
 			break;
 		case FSF_DATADIR_CMND:
-			lat = &unit->latencies.cmd;
+			lat = &zfcp_sdev->latencies.cmd;
 			break;
 		}
 
 		if (lat) {
-			spin_lock(&unit->latencies.lock);
+			spin_lock(&zfcp_sdev->latencies.lock);
 			zfcp_fsf_update_lat(&lat->channel, lat_in->channel_lat);
 			zfcp_fsf_update_lat(&lat->fabric, lat_in->fabric_lat);
 			lat->counter++;
-			spin_unlock(&unit->latencies.lock);
+			spin_unlock(&zfcp_sdev->latencies.lock);
 		}
 	}
 
@@ -2141,68 +2148,66 @@ static void zfcp_fsf_send_fcp_ctm_handle
 
 static void zfcp_fsf_send_fcp_command_handler(struct zfcp_fsf_req *req)
 {
-	struct zfcp_unit *unit;
+	struct scsi_cmnd *scmnd = req->data;
+	struct scsi_device *sdev = scmnd->device;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 	struct fsf_qtcb_header *header = &req->qtcb->header;
 
-	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT))
-		unit = req->data;
-	else
-		unit = req->unit;
-
 	if (unlikely(req->status & ZFCP_STATUS_FSFREQ_ERROR))
 		goto skip_fsfstatus;
 
 	switch (header->fsf_status) {
 	case FSF_HANDLE_MISMATCH:
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0, "fssfch1", req);
+		zfcp_erp_adapter_reopen(zfcp_sdev->port->adapter, 0, "fssfch1",
+					req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_FCPLUN_NOT_VALID:
 	case FSF_LUN_HANDLE_NOT_VALID:
-		zfcp_erp_port_reopen(unit->port, 0, "fssfch2", req);
+		zfcp_erp_port_reopen(zfcp_sdev->port, 0, "fssfch2", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SERVICE_CLASS_NOT_SUPPORTED:
 		zfcp_fsf_class_not_supp(req);
 		break;
 	case FSF_ACCESS_DENIED:
-		zfcp_fsf_access_denied_unit(req, unit);
+		zfcp_fsf_access_denied_lun(req, sdev);
 		break;
 	case FSF_DIRECTION_INDICATOR_NOT_VALID:
 		dev_err(&req->adapter->ccw_device->dev,
-			"Incorrect direction %d, unit 0x%016Lx on port "
+			"Incorrect direction %d, LUN 0x%016Lx on port "
 			"0x%016Lx closed\n",
 			req->qtcb->bottom.io.data_direction,
-			(unsigned long long)unit->fcp_lun,
-			(unsigned long long)unit->port->wwpn);
-		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, "fssfch3",
-					  req);
+			(unsigned long long)zfcp_scsi_dev_lun(sdev),
+			(unsigned long long)zfcp_sdev->port->wwpn);
+		zfcp_erp_adapter_shutdown(zfcp_sdev->port->adapter, 0,
+					  "fssfch3", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_CMND_LENGTH_NOT_VALID:
 		dev_err(&req->adapter->ccw_device->dev,
-			"Incorrect CDB length %d, unit 0x%016Lx on "
+			"Incorrect CDB length %d, LUN 0x%016Lx on "
 			"port 0x%016Lx closed\n",
 			req->qtcb->bottom.io.fcp_cmnd_length,
-			(unsigned long long)unit->fcp_lun,
-			(unsigned long long)unit->port->wwpn);
-		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, "fssfch4",
-					  req);
+			(unsigned long long)zfcp_scsi_dev_lun(sdev),
+			(unsigned long long)zfcp_sdev->port->wwpn);
+		zfcp_erp_adapter_shutdown(zfcp_sdev->port->adapter, 0,
+					  "fssfch4", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(unit->port, "fssfch5", req);
+		zfcp_erp_port_boxed(zfcp_sdev->port, "fssfch5", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_BOXED:
-		zfcp_erp_unit_boxed(unit, "fssfch6", req);
+		zfcp_erp_lun_boxed(sdev, "fssfch6", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		if (header->fsf_status_qual.word[0] ==
 		    FSF_SQ_INVOKE_LINK_TEST_PROCEDURE)
-			zfcp_fc_test_link(unit->port);
+			zfcp_fc_test_link(zfcp_sdev->port);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	}
@@ -2211,8 +2216,6 @@ skip_fsfstatus:
 		zfcp_fsf_send_fcp_ctm_handler(req);
 	else {
 		zfcp_fsf_send_fcp_command_task_handler(req);
-		req->unit = NULL;
-		put_device(&unit->dev);
 	}
 }
 
@@ -2255,22 +2258,22 @@ static int zfcp_fsf_set_data_dir(struct
 }
 
 /**
- * zfcp_fsf_send_fcp_command_task - initiate an FCP command (for a SCSI command)
- * @unit: unit where command is sent to
+ * zfcp_fsf_fcp_cmnd - initiate an FCP command (for a SCSI command)
  * @scsi_cmnd: scsi command to be sent
  */
-int zfcp_fsf_send_fcp_command_task(struct zfcp_unit *unit,
-				   struct scsi_cmnd *scsi_cmnd)
+int zfcp_fsf_fcp_cmnd(struct scsi_cmnd *scsi_cmnd)
 {
 	struct zfcp_fsf_req *req;
 	struct fcp_cmnd *fcp_cmnd;
 	unsigned int sbtype = SBAL_FLAGS0_TYPE_READ;
 	int real_bytes, retval = -EIO, dix_bytes = 0;
-	struct zfcp_adapter *adapter = unit->port->adapter;
+	struct scsi_device *sdev = scsi_cmnd->device;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
 	struct zfcp_qdio *qdio = adapter->qdio;
 	struct fsf_qtcb_bottom_io *io;
 
-	if (unlikely(!(atomic_read(&unit->status) &
+	if (unlikely(!(atomic_read(&zfcp_sdev->status) &
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		return -EBUSY;
 
@@ -2295,11 +2298,10 @@ int zfcp_fsf_send_fcp_command_task(struc
 
 	io = &req->qtcb->bottom.io;
 	req->status |= ZFCP_STATUS_FSFREQ_CLEANUP;
-	req->unit = unit;
 	req->data = scsi_cmnd;
 	req->handler = zfcp_fsf_send_fcp_command_handler;
-	req->qtcb->header.lun_handle = unit->handle;
-	req->qtcb->header.port_handle = unit->port->handle;
+	req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;
+	req->qtcb->header.port_handle = zfcp_sdev->port->handle;
 	io->service_class = FSF_CLASS_3;
 	io->fcp_cmnd_length = FCP_CMND_LEN;
 
@@ -2310,8 +2312,6 @@ int zfcp_fsf_send_fcp_command_task(struc
 
 	zfcp_fsf_set_data_dir(scsi_cmnd, &io->data_direction);
 
-	get_device(&unit->dev);
-
 	fcp_cmnd = (struct fcp_cmnd *) &req->qtcb->bottom.io.fcp_cmnd;
 	zfcp_fc_scsi_to_fcp(fcp_cmnd, scsi_cmnd);
 
@@ -2338,7 +2338,6 @@ int zfcp_fsf_send_fcp_command_task(struc
 	goto out;
 
 failed_scsi_cmnd:
-	put_device(&unit->dev);
 	zfcp_fsf_req_free(req);
 	scsi_cmnd->host_scribble = NULL;
 out:
@@ -2347,18 +2346,20 @@ out:
 }
 
 /**
- * zfcp_fsf_send_fcp_ctm - send SCSI task management command
- * @unit: pointer to struct zfcp_unit
+ * zfcp_fsf_fcp_task_mgmt - send SCSI task management command
+ * @scmnd: SCSI command to send the task management command for
  * @tm_flags: unsigned byte for task management flags
  * Returns: on success pointer to struct fsf_req, NULL otherwise
  */
-struct zfcp_fsf_req *zfcp_fsf_send_fcp_ctm(struct zfcp_unit *unit, u8 tm_flags)
+struct zfcp_fsf_req *zfcp_fsf_fcp_task_mgmt(struct scsi_cmnd *scmnd,
+					    u8 tm_flags)
 {
 	struct zfcp_fsf_req *req = NULL;
 	struct fcp_cmnd *fcp_cmnd;
-	struct zfcp_qdio *qdio = unit->port->adapter->qdio;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scmnd->device);
+	struct zfcp_qdio *qdio = zfcp_sdev->port->adapter->qdio;
 
-	if (unlikely(!(atomic_read(&unit->status) &
+	if (unlikely(!(atomic_read(&zfcp_sdev->status) &
 		       ZFCP_STATUS_COMMON_UNBLOCKED)))
 		return NULL;
 
@@ -2376,10 +2377,10 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 	}
 
 	req->status |= ZFCP_STATUS_FSFREQ_TASK_MANAGEMENT;
-	req->data = unit;
+	req->data = scmnd;
 	req->handler = zfcp_fsf_send_fcp_command_handler;
-	req->qtcb->header.lun_handle = unit->handle;
-	req->qtcb->header.port_handle = unit->port->handle;
+	req->qtcb->header.lun_handle = zfcp_sdev->lun_handle;
+	req->qtcb->header.port_handle = zfcp_sdev->port->handle;
 	req->qtcb->bottom.io.data_direction = FSF_DATADIR_CMND;
 	req->qtcb->bottom.io.service_class = FSF_CLASS_3;
 	req->qtcb->bottom.io.fcp_cmnd_length = FCP_CMND_LEN;
@@ -2387,7 +2388,7 @@ struct zfcp_fsf_req *zfcp_fsf_send_fcp_c
 	zfcp_qdio_set_sbale_last(qdio, &req->qdio_req);
 
 	fcp_cmnd = (struct fcp_cmnd *) &req->qtcb->bottom.io.fcp_cmnd;
-	zfcp_fc_fcp_tm(fcp_cmnd, unit->device, tm_flags);
+	zfcp_fc_fcp_tm(fcp_cmnd, scmnd->device, tm_flags);
 
 	zfcp_fsf_start_timer(req, ZFCP_SCSI_ER_TIMEOUT);
 	if (!zfcp_fsf_req_send(req))
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2010-09-08 08:49:27.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2010-09-08 08:49:28.000000000 +0200
@@ -49,11 +49,12 @@ static int zfcp_scsi_change_queue_depth(
 	return sdev->queue_depth;
 }
 
-static void zfcp_scsi_slave_destroy(struct scsi_device *sdpnt)
+static void zfcp_scsi_slave_destroy(struct scsi_device *sdev)
 {
-	struct zfcp_unit *unit = (struct zfcp_unit *) sdpnt->hostdata;
-	unit->device = NULL;
-	put_device(&unit->dev);
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
+
+	zfcp_erp_lun_shutdown_wait(sdev, "scssd_1");
+	put_device(&zfcp_sdev->port->dev);
 }
 
 static int zfcp_scsi_slave_configure(struct scsi_device *sdp)
@@ -78,23 +79,16 @@ static void zfcp_scsi_command_fail(struc
 static int zfcp_scsi_queuecommand(struct scsi_cmnd *scpnt,
 				  void (*done) (struct scsi_cmnd *))
 {
-	struct zfcp_unit *unit;
-	struct zfcp_adapter *adapter;
-	int    status, scsi_result, ret;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
+	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
 	struct fc_rport *rport = starget_to_rport(scsi_target(scpnt->device));
+	int    status, scsi_result, ret;
 
 	/* reset the status for this request */
 	scpnt->result = 0;
 	scpnt->host_scribble = NULL;
 	scpnt->scsi_done = done;
 
-	/*
-	 * figure out adapter and target device
-	 * (stored there by zfcp_scsi_slave_alloc)
-	 */
-	adapter = (struct zfcp_adapter *) scpnt->device->host->hostdata[0];
-	unit = scpnt->device->hostdata;
-
 	scsi_result = fc_remote_port_chkready(rport);
 	if (unlikely(scsi_result)) {
 		scpnt->result = scsi_result;
@@ -103,11 +97,11 @@ static int zfcp_scsi_queuecommand(struct
 		return 0;
 	}
 
-	status = atomic_read(&unit->status);
+	status = atomic_read(&zfcp_sdev->status);
 	if (unlikely(status & ZFCP_STATUS_COMMON_ERP_FAILED) &&
-		     !(atomic_read(&unit->port->status) &
+		     !(atomic_read(&zfcp_sdev->port->status) &
 		       ZFCP_STATUS_COMMON_ERP_FAILED)) {
-		/* only unit access denied, but port is good
+		/* only LUN access denied, but port is good
 		 * not covered by FC transport, have to fail here */
 		zfcp_scsi_command_fail(scpnt, DID_ERROR);
 		return 0;
@@ -115,8 +109,8 @@ static int zfcp_scsi_queuecommand(struct
 
 	if (unlikely(!(status & ZFCP_STATUS_COMMON_UNBLOCKED))) {
 		/* This could be either
-		 * open unit pending: this is temporary, will result in
-		 * 	open unit or ERP_FAILED, so retry command
+		 * open LUN pending: this is temporary, will result in
+		 *	open LUN or ERP_FAILED, so retry command
 		 * call to rport_delete pending: mimic retry from
 		 * 	fc_remote_port_chkready until rport is BLOCKED
 		 */
@@ -124,7 +118,7 @@ static int zfcp_scsi_queuecommand(struct
 		return 0;
 	}
 
-	ret = zfcp_fsf_send_fcp_command_task(unit, scpnt);
+	ret = zfcp_fsf_fcp_cmnd(scpnt);
 	if (unlikely(ret == -EBUSY))
 		return SCSI_MLQUEUE_DEVICE_BUSY;
 	else if (unlikely(ret < 0))
@@ -133,45 +127,42 @@ static int zfcp_scsi_queuecommand(struct
 	return ret;
 }
 
-static struct zfcp_unit *zfcp_unit_lookup(struct zfcp_adapter *adapter,
-					  unsigned int id, u64 lun)
+static int zfcp_scsi_slave_alloc(struct scsi_device *sdev)
 {
-	unsigned long flags;
+	struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
+	struct zfcp_adapter *adapter =
+		(struct zfcp_adapter *) sdev->host->hostdata[0];
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 	struct zfcp_port *port;
-	struct zfcp_unit *unit = NULL;
+	struct zfcp_unit *unit;
 
-	read_lock_irqsave(&adapter->port_list_lock, flags);
-	list_for_each_entry(port, &adapter->port_list, list) {
-		if (!port->rport || (id != port->rport->scsi_target_id))
-			continue;
-		unit = zfcp_unit_find(port, lun);
-		if (unit)
-			break;
+	port = zfcp_get_port_by_wwpn(adapter, rport->port_name);
+	if (!port)
+		return -ENXIO;
+
+	unit = zfcp_unit_find(port, zfcp_scsi_dev_lun(sdev));
+	if (unit)
+		put_device(&unit->dev);
+	else {
+		put_device(&port->dev);
+		return -ENXIO;
 	}
-	read_unlock_irqrestore(&adapter->port_list_lock, flags);
-
-	return unit;
-}
 
-static int zfcp_scsi_slave_alloc(struct scsi_device *sdp)
-{
-	struct zfcp_adapter *adapter;
-	struct zfcp_unit *unit;
-	u64 lun;
+	zfcp_sdev->port = port;
+	zfcp_sdev->latencies.write.channel.min = 0xFFFFFFFF;
+	zfcp_sdev->latencies.write.fabric.min = 0xFFFFFFFF;
+	zfcp_sdev->latencies.read.channel.min = 0xFFFFFFFF;
+	zfcp_sdev->latencies.read.fabric.min = 0xFFFFFFFF;
+	zfcp_sdev->latencies.cmd.channel.min = 0xFFFFFFFF;
+	zfcp_sdev->latencies.cmd.fabric.min = 0xFFFFFFFF;
+	spin_lock_init(&zfcp_sdev->latencies.lock);
+
+	zfcp_erp_modify_lun_status(sdev, "scsla_0", NULL,
+				   ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
+	zfcp_erp_lun_reopen(sdev, 0, "scsla_1", NULL);
+	zfcp_erp_wait(port->adapter);
 
-	adapter = (struct zfcp_adapter *) sdp->host->hostdata[0];
-	if (!adapter)
-		goto out;
-
-	int_to_scsilun(sdp->lun, (struct scsi_lun *)&lun);
-	unit = zfcp_unit_lookup(adapter, sdp->id, lun);
-	if (unit) {
-		sdp->hostdata = unit;
-		unit->device = sdp;
-		return 0;
-	}
-out:
-	return -ENXIO;
+	return 0;
 }
 
 static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *scpnt)
@@ -179,7 +170,6 @@ static int zfcp_scsi_eh_abort_handler(st
 	struct Scsi_Host *scsi_host = scpnt->device->host;
 	struct zfcp_adapter *adapter =
 		(struct zfcp_adapter *) scsi_host->hostdata[0];
-	struct zfcp_unit *unit = scpnt->device->hostdata;
 	struct zfcp_fsf_req *old_req, *abrt_req;
 	unsigned long flags;
 	unsigned long old_reqid = (unsigned long) scpnt->host_scribble;
@@ -203,7 +193,7 @@ static int zfcp_scsi_eh_abort_handler(st
 	write_unlock_irqrestore(&adapter->abort_lock, flags);
 
 	while (retry--) {
-		abrt_req = zfcp_fsf_abort_fcp_command(old_reqid, unit);
+		abrt_req = zfcp_fsf_abort_fcp_cmnd(scpnt);
 		if (abrt_req)
 			break;
 
@@ -238,14 +228,14 @@ static int zfcp_scsi_eh_abort_handler(st
 
 static int zfcp_task_mgmt_function(struct scsi_cmnd *scpnt, u8 tm_flags)
 {
-	struct zfcp_unit *unit = scpnt->device->hostdata;
-	struct zfcp_adapter *adapter = unit->port->adapter;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
+	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
 	struct zfcp_fsf_req *fsf_req = NULL;
 	int retval = SUCCESS, ret;
 	int retry = 3;
 
 	while (retry--) {
-		fsf_req = zfcp_fsf_send_fcp_ctm(unit, tm_flags);
+		fsf_req = zfcp_fsf_fcp_task_mgmt(scpnt, tm_flags);
 		if (fsf_req)
 			break;
 
@@ -256,7 +246,7 @@ static int zfcp_task_mgmt_function(struc
 
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING)) {
-			zfcp_dbf_scsi_devreset("nres", tm_flags, unit, scpnt);
+			zfcp_dbf_scsi_devreset("nres", scpnt, tm_flags);
 			return SUCCESS;
 		}
 	}
@@ -266,10 +256,10 @@ static int zfcp_task_mgmt_function(struc
 	wait_for_completion(&fsf_req->completion);
 
 	if (fsf_req->status & ZFCP_STATUS_FSFREQ_TMFUNCFAILED) {
-		zfcp_dbf_scsi_devreset("fail", tm_flags, unit, scpnt);
+		zfcp_dbf_scsi_devreset("fail", scpnt, tm_flags);
 		retval = FAILED;
 	} else
-		zfcp_dbf_scsi_devreset("okay", tm_flags, unit, scpnt);
+		zfcp_dbf_scsi_devreset("okay", scpnt, tm_flags);
 
 	zfcp_fsf_req_free(fsf_req);
 	return retval;
@@ -287,8 +277,8 @@ static int zfcp_scsi_eh_target_reset_han
 
 static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *scpnt)
 {
-	struct zfcp_unit *unit = scpnt->device->hostdata;
-	struct zfcp_adapter *adapter = unit->port->adapter;
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(scpnt->device);
+	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;
 	int ret;
 
 	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1", scpnt);
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_sysfs.c linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c
--- linux-2.6/drivers/s390/scsi/zfcp_sysfs.c	2010-09-08 08:49:28.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_sysfs.c	2010-09-08 08:49:28.000000000 +0200
@@ -68,19 +68,19 @@ ZFCP_DEFINE_ATTR(zfcp_port, port, access
 		  ZFCP_STATUS_COMMON_ACCESS_DENIED) != 0);
 
 ZFCP_DEFINE_ATTR(zfcp_unit, unit, status, "0x%08x\n",
-		 atomic_read(&unit->status));
+		 zfcp_unit_sdev_status(unit));
 ZFCP_DEFINE_ATTR(zfcp_unit, unit, in_recovery, "%d\n",
-		 (atomic_read(&unit->status) &
+		 (zfcp_unit_sdev_status(unit) &
 		  ZFCP_STATUS_COMMON_ERP_INUSE) != 0);
 ZFCP_DEFINE_ATTR(zfcp_unit, unit, access_denied, "%d\n",
-		 (atomic_read(&unit->status) &
+		 (zfcp_unit_sdev_status(unit) &
 		  ZFCP_STATUS_COMMON_ACCESS_DENIED) != 0);
 ZFCP_DEFINE_ATTR(zfcp_unit, unit, access_shared, "%d\n",
-		 (atomic_read(&unit->status) &
-		  ZFCP_STATUS_UNIT_SHARED) != 0);
+		 (zfcp_unit_sdev_status(unit) &
+		  ZFCP_STATUS_LUN_SHARED) != 0);
 ZFCP_DEFINE_ATTR(zfcp_unit, unit, access_readonly, "%d\n",
-		 (atomic_read(&unit->status) &
-		  ZFCP_STATUS_UNIT_READONLY) != 0);
+		 (zfcp_unit_sdev_status(unit) &
+		  ZFCP_STATUS_LUN_READONLY) != 0);
 
 static ssize_t zfcp_sysfs_port_failed_show(struct device *dev,
 					   struct device_attribute *attr,
@@ -121,11 +121,17 @@ static ssize_t zfcp_sysfs_unit_failed_sh
 					   char *buf)
 {
 	struct zfcp_unit *unit = container_of(dev, struct zfcp_unit, dev);
+	struct scsi_device *sdev;
+	unsigned int status, failed = 1;
 
-	if (atomic_read(&unit->status) & ZFCP_STATUS_COMMON_ERP_FAILED)
-		return sprintf(buf, "1\n");
+	sdev = zfcp_unit_sdev(unit);
+	if (sdev) {
+		status = atomic_read(&sdev_to_zfcp(sdev)->status);
+		failed = status & ZFCP_STATUS_COMMON_ERP_FAILED ? 1 : 0;
+		scsi_device_put(sdev);
+	}
 
-	return sprintf(buf, "0\n");
+	return sprintf(buf, "%d\n", failed);
 }
 
 static ssize_t zfcp_sysfs_unit_failed_store(struct device *dev,
@@ -134,15 +140,21 @@ static ssize_t zfcp_sysfs_unit_failed_st
 {
 	struct zfcp_unit *unit = container_of(dev, struct zfcp_unit, dev);
 	unsigned long val;
+	struct scsi_device *sdev;
 
 	if (strict_strtoul(buf, 0, &val) || val != 0)
 		return -EINVAL;
 
-	zfcp_erp_modify_unit_status(unit, "syufai1", NULL,
-				    ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
-	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED,
-			     "syufai2", NULL);
-	zfcp_erp_wait(unit->port->adapter);
+	sdev = zfcp_unit_sdev(unit);
+	if (sdev) {
+		zfcp_erp_modify_lun_status(sdev, "syufai1", NULL,
+					   ZFCP_STATUS_COMMON_RUNNING,
+					   ZFCP_SET);
+		zfcp_erp_lun_reopen(sdev, ZFCP_STATUS_COMMON_ERP_FAILED,
+				    "syufai2", NULL);
+		zfcp_erp_wait(unit->port->adapter);
+	} else
+		zfcp_unit_scsi_scan(unit);
 
 	return count;
 }
@@ -347,9 +359,9 @@ zfcp_sysfs_unit_##_name##_latency_show(s
 				       struct device_attribute *attr,	\
 				       char *buf) {			\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
-	struct zfcp_unit *unit = sdev->hostdata;			\
-	struct zfcp_latencies *lat = &unit->latencies;			\
-	struct zfcp_adapter *adapter = unit->port->adapter;		\
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);		\
+	struct zfcp_latencies *lat = &zfcp_sdev->latencies;		\
+	struct zfcp_adapter *adapter = zfcp_sdev->port->adapter;	\
 	unsigned long long fsum, fmin, fmax, csum, cmin, cmax, cc;	\
 									\
 	spin_lock_bh(&lat->lock);					\
@@ -378,8 +390,8 @@ zfcp_sysfs_unit_##_name##_latency_store(
 					const char *buf, size_t count)	\
 {									\
 	struct scsi_device *sdev = to_scsi_device(dev);			\
-	struct zfcp_unit *unit = sdev->hostdata;			\
-	struct zfcp_latencies *lat = &unit->latencies;			\
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);		\
+	struct zfcp_latencies *lat = &zfcp_sdev->latencies;		\
 	unsigned long flags;						\
 									\
 	spin_lock_irqsave(&lat->lock, flags);				\
@@ -407,26 +419,26 @@ static ssize_t zfcp_sysfs_scsi_##_name##
 					      struct device_attribute *attr,\
 					      char *buf)                 \
 {                                                                        \
-	struct scsi_device *sdev  = to_scsi_device(dev);		 \
-	struct zfcp_unit *unit = sdev->hostdata;			 \
+	struct scsi_device *sdev = to_scsi_device(dev);			 \
+	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);		 \
+	struct zfcp_port *port = zfcp_sdev->port;			 \
 									 \
 	return sprintf(buf, _format, _value);                            \
 }                                                                        \
 static DEVICE_ATTR(_name, S_IRUGO, zfcp_sysfs_scsi_##_name##_show, NULL);
 
 ZFCP_DEFINE_SCSI_ATTR(hba_id, "%s\n",
-		      dev_name(&unit->port->adapter->ccw_device->dev));
+		      dev_name(&port->adapter->ccw_device->dev));
 ZFCP_DEFINE_SCSI_ATTR(wwpn, "0x%016llx\n",
-		      (unsigned long long) unit->port->wwpn);
+		      (unsigned long long) port->wwpn);
 
 static ssize_t zfcp_sysfs_scsi_fcp_lun_show(struct device *dev,
 					    struct device_attribute *attr,
 					    char *buf)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct zfcp_unit *unit = sdev->hostdata;
 
-	return sprintf(buf, "0x%016llx\n", (unsigned long long) unit->fcp_lun);
+	return sprintf(buf, "0x%016llx\n", zfcp_scsi_dev_lun(sdev));
 }
 static DEVICE_ATTR(fcp_lun, S_IRUGO, zfcp_sysfs_scsi_fcp_lun_show, NULL);
 
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_unit.c linux-2.6-patched/drivers/s390/scsi/zfcp_unit.c
--- linux-2.6/drivers/s390/scsi/zfcp_unit.c	2010-09-08 08:49:27.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_unit.c	2010-09-08 08:49:28.000000000 +0200
@@ -134,14 +134,7 @@ int zfcp_unit_add(struct zfcp_port *port
 	unit->fcp_lun = fcp_lun;
 	unit->dev.parent = &port->dev;
 	unit->dev.release = zfcp_unit_release;
-	unit->latencies.write.channel.min = 0xFFFFFFFF;
-	unit->latencies.write.fabric.min = 0xFFFFFFFF;
-	unit->latencies.read.channel.min = 0xFFFFFFFF;
-	unit->latencies.read.fabric.min = 0xFFFFFFFF;
-	unit->latencies.cmd.channel.min = 0xFFFFFFFF;
-	unit->latencies.cmd.fabric.min = 0xFFFFFFFF;
 	INIT_WORK(&unit->scsi_work, zfcp_unit_scsi_scan_work);
-	spin_lock_init(&unit->latencies.lock);
 
 	if (dev_set_name(&unit->dev, "0x%016llx",
 			 (unsigned long long) fcp_lun)) {
@@ -165,9 +158,6 @@ int zfcp_unit_add(struct zfcp_port *port
 	list_add_tail(&unit->list, &port->unit_list);
 	write_unlock_irq(&port->unit_list_lock);
 
-	atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING, &unit->status);
-	zfcp_erp_unit_reopen(unit, 0, "syuas_1", NULL);
-	zfcp_erp_wait(unit->port->adapter);
 	zfcp_unit_scsi_scan(unit);
 
 	return 0;
@@ -248,7 +238,6 @@ int zfcp_unit_remove(struct zfcp_port *p
 
 	put_device(&unit->dev);
 
-	zfcp_erp_unit_shutdown(unit, 0, "unrem_1", NULL);
 	zfcp_device_unregister(&unit->dev, &zfcp_sysfs_unit_attrs);
 
 	return 0;

