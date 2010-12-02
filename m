From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/7] zfcp: Redesign of the debug tracing for recovery actions.
Date: Thu, 02 Dec 2010 15:16:12 +0100
Message-ID: <20101202141918.788234832@de.ibm.com>
References: <20101202141611.976946976@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:41476 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757813Ab0LBOT1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Dec 2010 09:19:27 -0500
Content-Disposition: inline; filename=701-zfcp-debug-tracing-recovery.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, maier@linux.vnet.ibm.com, Swen schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The tracing environment of the zfcp LLD has become very bulky and hard
to maintain. Small changes involve a large modification process which
is error-prone and not effective.  This patch is the first of a set to
redesign the zfcp tracing to a more straight-forward and easy to
extend scheme.  It removes all interpretation and visualization parts
and focuses on bare logging of the information.

This patch deals with all trace records of the zfcp error recovery.

Signed-off-by: Swen schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_dbf.c |  283 ++++++++++---------------------------------
 drivers/s390/scsi/zfcp_dbf.h |  104 +++++++++------
 drivers/s390/scsi/zfcp_erp.c |   31 +---
 drivers/s390/scsi/zfcp_ext.h |   12 -
 4 files changed, 142 insertions(+), 288 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c
+++ b/drivers/s390/scsi/zfcp_dbf.c
@@ -50,11 +50,6 @@ static void zfcp_dbf_tag(char **p, const
 	*p += sprintf(*p, "\n");
 }
 
-static void zfcp_dbf_outs(char **buf, const char *s1, const char *s2)
-{
-	*buf += sprintf(*buf, "%-24s%s\n", s1, s2);
-}
-
 static void zfcp_dbf_out(char **buf, const char *s, const char *format, ...)
 {
 	va_list arg;
@@ -439,241 +434,96 @@ static struct debug_view zfcp_dbf_hba_vi
 	.format_proc = zfcp_dbf_hba_view_format,
 };
 
-static const char *zfcp_dbf_rec_tags[] = {
-	[ZFCP_REC_DBF_ID_THREAD] = "thread",
-	[ZFCP_REC_DBF_ID_TARGET] = "target",
-	[ZFCP_REC_DBF_ID_TRIGGER] = "trigger",
-	[ZFCP_REC_DBF_ID_ACTION] = "action",
-};
-
-static int zfcp_dbf_rec_view_format(debug_info_t *id, struct debug_view *view,
-				    char *buf, const char *_rec)
+static void zfcp_dbf_set_common(struct zfcp_dbf_rec *rec,
+				struct zfcp_adapter *adapter,
+				struct zfcp_port *port,
+				struct scsi_device *sdev)
 {
-	struct zfcp_dbf_rec_record *r = (struct zfcp_dbf_rec_record *)_rec;
-	char *p = buf;
-	char hint[ZFCP_DBF_ID_SIZE + 1];
-
-	memcpy(hint, r->id2, ZFCP_DBF_ID_SIZE);
-	hint[ZFCP_DBF_ID_SIZE] = 0;
-	zfcp_dbf_outs(&p, "tag", zfcp_dbf_rec_tags[r->id]);
-	zfcp_dbf_outs(&p, "hint", hint);
-	switch (r->id) {
-	case ZFCP_REC_DBF_ID_THREAD:
-		zfcp_dbf_out(&p, "total", "%d", r->u.thread.total);
-		zfcp_dbf_out(&p, "ready", "%d", r->u.thread.ready);
-		zfcp_dbf_out(&p, "running", "%d", r->u.thread.running);
-		break;
-	case ZFCP_REC_DBF_ID_TARGET:
-		zfcp_dbf_out(&p, "reference", "0x%016Lx", r->u.target.ref);
-		zfcp_dbf_out(&p, "status", "0x%08x", r->u.target.status);
-		zfcp_dbf_out(&p, "erp_count", "%d", r->u.target.erp_count);
-		zfcp_dbf_out(&p, "d_id", "0x%06x", r->u.target.d_id);
-		zfcp_dbf_out(&p, "wwpn", "0x%016Lx", r->u.target.wwpn);
-		zfcp_dbf_out(&p, "fcp_lun", "0x%016Lx", r->u.target.fcp_lun);
-		break;
-	case ZFCP_REC_DBF_ID_TRIGGER:
-		zfcp_dbf_out(&p, "reference", "0x%016Lx", r->u.trigger.ref);
-		zfcp_dbf_out(&p, "erp_action", "0x%016Lx", r->u.trigger.action);
-		zfcp_dbf_out(&p, "requested", "%d", r->u.trigger.want);
-		zfcp_dbf_out(&p, "executed", "%d", r->u.trigger.need);
-		zfcp_dbf_out(&p, "wwpn", "0x%016Lx", r->u.trigger.wwpn);
-		zfcp_dbf_out(&p, "fcp_lun", "0x%016Lx", r->u.trigger.fcp_lun);
-		zfcp_dbf_out(&p, "adapter_status", "0x%08x", r->u.trigger.as);
-		zfcp_dbf_out(&p, "port_status", "0x%08x", r->u.trigger.ps);
-		zfcp_dbf_out(&p, "lun_status", "0x%08x", r->u.trigger.ls);
-		break;
-	case ZFCP_REC_DBF_ID_ACTION:
-		zfcp_dbf_out(&p, "erp_action", "0x%016Lx", r->u.action.action);
-		zfcp_dbf_out(&p, "fsf_req", "0x%016Lx", r->u.action.fsf_req);
-		zfcp_dbf_out(&p, "status", "0x%08Lx", r->u.action.status);
-		zfcp_dbf_out(&p, "step", "0x%08Lx", r->u.action.step);
-		break;
+	rec->adapter_status = atomic_read(&adapter->status);
+	if (port) {
+		rec->port_status = atomic_read(&port->status);
+		rec->wwpn = port->wwpn;
+		rec->d_id = port->d_id;
+	}
+	if (sdev) {
+		rec->lun_status = atomic_read(&sdev_to_zfcp(sdev)->status);
+		rec->lun = zfcp_scsi_dev_lun(sdev);
 	}
-	p += sprintf(p, "\n");
-	return p - buf;
 }
 
-static struct debug_view zfcp_dbf_rec_view = {
-	.name = "structured",
-	.header_proc = zfcp_dbf_view_header,
-	.format_proc = zfcp_dbf_rec_view_format,
-};
-
 /**
- * zfcp_dbf_rec_thread - trace event related to recovery thread operation
- * @id2: identifier for event
- * @dbf: reference to dbf structure
- * This function assumes that the caller is holding erp_lock.
- */
-void zfcp_dbf_rec_thread(char *id2, struct zfcp_dbf *dbf)
+ * zfcp_dbf_rec_trig - trace event related to triggered recovery
+ * @tag: identifier for event
+ * @adapter: adapter on which the erp_action should run
+ * @port: remote port involved in the erp_action
+ * @sdev: scsi device involved in the erp_action
+ * @want: wanted erp_action
+ * @need: required erp_action
+ *
+ * The adapter->erp_lock has to be held.
+ */
+void zfcp_dbf_rec_trig(char *tag, struct zfcp_adapter *adapter,
+		       struct zfcp_port *port, struct scsi_device *sdev,
+		       u8 want, u8 need)
 {
-	struct zfcp_adapter *adapter = dbf->adapter;
-	struct zfcp_dbf_rec_record *r = &dbf->rec_buf;
-	unsigned long flags = 0;
+	struct zfcp_dbf *dbf = adapter->dbf;
+	struct zfcp_dbf_rec *rec = &dbf->rec_buf;
 	struct list_head *entry;
-	unsigned ready = 0, running = 0, total;
-
-	list_for_each(entry, &adapter->erp_ready_head)
-		ready++;
-	list_for_each(entry, &adapter->erp_running_head)
-		running++;
-	total = adapter->erp_total_count;
-
-	spin_lock_irqsave(&dbf->rec_lock, flags);
-	memset(r, 0, sizeof(*r));
-	r->id = ZFCP_REC_DBF_ID_THREAD;
-	memcpy(r->id2, id2, ZFCP_DBF_ID_SIZE);
-	r->u.thread.total = total;
-	r->u.thread.ready = ready;
-	r->u.thread.running = running;
-	debug_event(dbf->rec, 6, r, sizeof(*r));
-	spin_unlock_irqrestore(&dbf->rec_lock, flags);
-}
-
-/**
- * zfcp_dbf_rec_thread - trace event related to recovery thread operation
- * @id2: identifier for event
- * @adapter: adapter
- * This function assumes that the caller does not hold erp_lock.
- */
-void zfcp_dbf_rec_thread_lock(char *id2, struct zfcp_dbf *dbf)
-{
-	struct zfcp_adapter *adapter = dbf->adapter;
-	unsigned long flags;
-
-	read_lock_irqsave(&adapter->erp_lock, flags);
-	zfcp_dbf_rec_thread(id2, dbf);
-	read_unlock_irqrestore(&adapter->erp_lock, flags);
-}
-
-static void zfcp_dbf_rec_target(char *id2, void *ref, struct zfcp_dbf *dbf,
-				atomic_t *status, atomic_t *erp_count, u64 wwpn,
-				u32 d_id, u64 fcp_lun)
-{
-	struct zfcp_dbf_rec_record *r = &dbf->rec_buf;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dbf->rec_lock, flags);
-	memset(r, 0, sizeof(*r));
-	r->id = ZFCP_REC_DBF_ID_TARGET;
-	memcpy(r->id2, id2, ZFCP_DBF_ID_SIZE);
-	r->u.target.ref = (unsigned long)ref;
-	r->u.target.status = atomic_read(status);
-	r->u.target.wwpn = wwpn;
-	r->u.target.d_id = d_id;
-	r->u.target.fcp_lun = fcp_lun;
-	r->u.target.erp_count = atomic_read(erp_count);
-	debug_event(dbf->rec, 3, r, sizeof(*r));
-	spin_unlock_irqrestore(&dbf->rec_lock, flags);
-}
+	memset(rec, 0, sizeof(*rec));
 
-/**
- * zfcp_dbf_rec_adapter - trace event for adapter state change
- * @id: identifier for trigger of state change
- * @ref: additional reference (e.g. request)
- * @dbf: reference to dbf structure
- */
-void zfcp_dbf_rec_adapter(char *id, void *ref, struct zfcp_dbf *dbf)
-{
-	struct zfcp_adapter *adapter = dbf->adapter;
+	rec->id = ZFCP_DBF_REC_TRIG;
+	memcpy(rec->tag, tag, ZFCP_DBF_TAG_LEN);
+	zfcp_dbf_set_common(rec, adapter, port, sdev);
 
-	zfcp_dbf_rec_target(id, ref, dbf, &adapter->status,
-			    &adapter->erp_counter, 0, 0,
-			    ZFCP_DBF_INVALID_LUN);
-}
+	list_for_each(entry, &adapter->erp_ready_head)
+		rec->u.trig.ready++;
 
-/**
- * zfcp_dbf_rec_port - trace event for port state change
- * @id: identifier for trigger of state change
- * @ref: additional reference (e.g. request)
- * @port: port
- */
-void zfcp_dbf_rec_port(char *id, void *ref, struct zfcp_port *port)
-{
-	struct zfcp_dbf *dbf = port->adapter->dbf;
+	list_for_each(entry, &adapter->erp_running_head)
+		rec->u.trig.running++;
 
-	zfcp_dbf_rec_target(id, ref, dbf, &port->status,
-			    &port->erp_counter, port->wwpn, port->d_id,
-			    ZFCP_DBF_INVALID_LUN);
-}
+	rec->u.trig.want = want;
+	rec->u.trig.need = need;
 
-/**
- * zfcp_dbf_rec_lun - trace event for LUN state change
- * @id: identifier for trigger of state change
- * @ref: additional reference (e.g. request)
- * @sdev: SCSI device
- */
-void zfcp_dbf_rec_lun(char *id, void *ref, struct scsi_device *sdev)
-{
-	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
-	struct zfcp_port *port = zfcp_sdev->port;
-	struct zfcp_dbf *dbf = port->adapter->dbf;
-
-	zfcp_dbf_rec_target(id, ref, dbf, &zfcp_sdev->status,
-			    &zfcp_sdev->erp_counter, port->wwpn, port->d_id,
-			    zfcp_scsi_dev_lun(sdev));
+	debug_event(dbf->rec, 1, rec, sizeof(*rec));
+	spin_unlock_irqrestore(&dbf->rec_lock, flags);
 }
 
+
 /**
- * zfcp_dbf_rec_trigger - trace event for triggered error recovery
- * @id2: identifier for error recovery trigger
- * @ref: additional reference (e.g. request)
- * @want: originally requested error recovery action
- * @need: error recovery action actually initiated
- * @action: address of error recovery action struct
- * @adapter: adapter
- * @port: port
- * @sdev: SCSI device
+ * zfcp_dbf_rec_run - trace event related to running recovery
+ * @tag: identifier for event
+ * @erp: erp_action running
  */
-void zfcp_dbf_rec_trigger(char *id2, void *ref, u8 want, u8 need, void *action,
-			  struct zfcp_adapter *adapter, struct zfcp_port *port,
-			  struct scsi_device *sdev)
+void zfcp_dbf_rec_run(char *tag, struct zfcp_erp_action *erp)
 {
-	struct zfcp_dbf *dbf = adapter->dbf;
-	struct zfcp_dbf_rec_record *r = &dbf->rec_buf;
+	struct zfcp_dbf *dbf = erp->adapter->dbf;
+	struct zfcp_dbf_rec *rec = &dbf->rec_buf;
 	unsigned long flags;
 
 	spin_lock_irqsave(&dbf->rec_lock, flags);
-	memset(r, 0, sizeof(*r));
-	r->id = ZFCP_REC_DBF_ID_TRIGGER;
-	memcpy(r->id2, id2, ZFCP_DBF_ID_SIZE);
-	r->u.trigger.ref = (unsigned long)ref;
-	r->u.trigger.want = want;
-	r->u.trigger.need = need;
-	r->u.trigger.action = (unsigned long)action;
-	r->u.trigger.as = atomic_read(&adapter->status);
-	if (port) {
-		r->u.trigger.ps = atomic_read(&port->status);
-		r->u.trigger.wwpn = port->wwpn;
-	}
-	if (sdev)
-		r->u.trigger.ls = atomic_read(&sdev_to_zfcp(sdev)->status);
-	r->u.trigger.fcp_lun = sdev ? zfcp_scsi_dev_lun(sdev) :
-				      ZFCP_DBF_INVALID_LUN;
-	debug_event(dbf->rec, action ? 1 : 4, r, sizeof(*r));
-	spin_unlock_irqrestore(&dbf->rec_lock, flags);
-}
+	memset(rec, 0, sizeof(*rec));
 
-/**
- * zfcp_dbf_rec_action - trace event showing progress of recovery action
- * @id2: identifier
- * @erp_action: error recovery action struct pointer
- */
-void zfcp_dbf_rec_action(char *id2, struct zfcp_erp_action *erp_action)
-{
-	struct zfcp_dbf *dbf = erp_action->adapter->dbf;
-	struct zfcp_dbf_rec_record *r = &dbf->rec_buf;
-	unsigned long flags;
+	rec->id = ZFCP_DBF_REC_RUN;
+	memcpy(rec->tag, tag, ZFCP_DBF_TAG_LEN);
+	zfcp_dbf_set_common(rec, erp->adapter, erp->port, erp->sdev);
+
+	rec->u.run.fsf_req_id = erp->fsf_req_id;
+	rec->u.run.rec_status = erp->status;
+	rec->u.run.rec_step = erp->step;
+	rec->u.run.rec_action = erp->action;
+
+	if (erp->sdev)
+		rec->u.run.rec_count =
+			atomic_read(&sdev_to_zfcp(erp->sdev)->erp_counter);
+	else if (erp->port)
+		rec->u.run.rec_count = atomic_read(&erp->port->erp_counter);
+	else
+		rec->u.run.rec_count = atomic_read(&erp->adapter->erp_counter);
 
-	spin_lock_irqsave(&dbf->rec_lock, flags);
-	memset(r, 0, sizeof(*r));
-	r->id = ZFCP_REC_DBF_ID_ACTION;
-	memcpy(r->id2, id2, ZFCP_DBF_ID_SIZE);
-	r->u.action.action = (unsigned long)erp_action;
-	r->u.action.status = erp_action->status;
-	r->u.action.step = erp_action->step;
-	r->u.action.fsf_req = erp_action->fsf_req_id;
-	debug_event(dbf->rec, 5, r, sizeof(*r));
+	debug_event(dbf->rec, 1, rec, sizeof(*rec));
 	spin_unlock_irqrestore(&dbf->rec_lock, flags);
 }
 
@@ -1019,8 +869,7 @@ int zfcp_dbf_adapter_register(struct zfc
 
 	/* debug feature area which records recovery activity */
 	sprintf(dbf_name, "zfcp_%s_rec", dev_name(&adapter->ccw_device->dev));
-	dbf->rec = zfcp_dbf_reg(dbf_name, 3, &zfcp_dbf_rec_view,
-				sizeof(struct zfcp_dbf_rec_record));
+	dbf->rec = zfcp_dbf_reg(dbf_name, 3, NULL, sizeof(struct zfcp_dbf_rec));
 	if (!dbf->rec)
 		goto err_out;
 
--- a/drivers/s390/scsi/zfcp_dbf.h
+++ b/drivers/s390/scsi/zfcp_dbf.h
@@ -27,6 +27,7 @@
 #include "zfcp_fsf.h"
 #include "zfcp_def.h"
 
+#define ZFCP_DBF_TAG_LEN       7
 #define ZFCP_DBF_TAG_SIZE      4
 #define ZFCP_DBF_ID_SIZE       7
 
@@ -40,57 +41,72 @@ struct zfcp_dbf_dump {
 	u8 data[];		/* dump data */
 } __attribute__ ((packed));
 
-struct zfcp_dbf_rec_record_thread {
-	u32 total;
+/**
+ * struct zfcp_dbf_rec_trigger - trace record for triggered recovery action
+ * @ready: number of ready recovery actions
+ * @running: number of running recovery actions
+ * @want: wanted recovery action
+ * @need: needed recovery action
+ */
+struct zfcp_dbf_rec_trigger {
 	u32 ready;
 	u32 running;
-};
-
-struct zfcp_dbf_rec_record_target {
-	u64 ref;
-	u32 status;
-	u32 d_id;
-	u64 wwpn;
-	u64 fcp_lun;
-	u32 erp_count;
-};
-
-struct zfcp_dbf_rec_record_trigger {
 	u8 want;
 	u8 need;
-	u32 as;
-	u32 ps;
-	u32 ls;
-	u64 ref;
-	u64 action;
-	u64 wwpn;
-	u64 fcp_lun;
-};
+} __packed;
 
-struct zfcp_dbf_rec_record_action {
-	u32 status;
-	u32 step;
-	u64 action;
-	u64 fsf_req;
-};
-
-struct zfcp_dbf_rec_record {
+/**
+ * struct zfcp_dbf_rec_running - trace record for running recovery
+ * @fsf_req_id: request id for fsf requests
+ * @rec_status: status of the fsf request
+ * @rec_step: current step of the recovery action
+ * rec_count: recovery counter
+ */
+struct zfcp_dbf_rec_running {
+	u64 fsf_req_id;
+	u32 rec_status;
+	u16 rec_step;
+	u8 rec_action;
+	u8 rec_count;
+} __packed;
+
+/**
+ * enum zfcp_dbf_rec_id - recovery trace record id
+ * @ZFCP_DBF_REC_TRIG: triggered recovery identifier
+ * @ZFCP_DBF_REC_RUN: running recovery identifier
+ */
+enum zfcp_dbf_rec_id {
+	ZFCP_DBF_REC_TRIG	= 1,
+	ZFCP_DBF_REC_RUN	= 2,
+};
+
+/**
+ * struct zfcp_dbf_rec - trace record for error recovery actions
+ * @id: unique number of recovery record type
+ * @tag: identifier string specifying the location of initiation
+ * @lun: logical unit number
+ * @wwpn: word wide port number
+ * @d_id: destination ID
+ * @adapter_status: current status of the adapter
+ * @port_status: current status of the port
+ * @lun_status: current status of the lun
+ * @u.trig: structure zfcp_dbf_rec_trigger
+ * @u.run: structure zfcp_dbf_rec_running
+ */
+struct zfcp_dbf_rec {
 	u8 id;
-	char id2[7];
+	char tag[ZFCP_DBF_TAG_LEN];
+	u64 lun;
+	u64 wwpn;
+	u32 d_id;
+	u32 adapter_status;
+	u32 port_status;
+	u32 lun_status;
 	union {
-		struct zfcp_dbf_rec_record_action action;
-		struct zfcp_dbf_rec_record_thread thread;
-		struct zfcp_dbf_rec_record_target target;
-		struct zfcp_dbf_rec_record_trigger trigger;
+		struct zfcp_dbf_rec_trigger trig;
+		struct zfcp_dbf_rec_running run;
 	} u;
-};
-
-enum {
-	ZFCP_REC_DBF_ID_ACTION,
-	ZFCP_REC_DBF_ID_THREAD,
-	ZFCP_REC_DBF_ID_TARGET,
-	ZFCP_REC_DBF_ID_TRIGGER,
-};
+} __packed;
 
 struct zfcp_dbf_hba_record_response {
 	u32 fsf_command;
@@ -232,7 +248,7 @@ struct zfcp_dbf {
 	spinlock_t			hba_lock;
 	spinlock_t			san_lock;
 	spinlock_t			scsi_lock;
-	struct zfcp_dbf_rec_record	rec_buf;
+	struct zfcp_dbf_rec		rec_buf;
 	struct zfcp_dbf_hba_record	hba_buf;
 	struct zfcp_dbf_san_record	san_buf;
 	struct zfcp_dbf_scsi_record	scsi_buf;
--- a/drivers/s390/scsi/zfcp_erp.c
+++ b/drivers/s390/scsi/zfcp_erp.c
@@ -76,9 +76,9 @@ static void zfcp_erp_action_ready(struct
 	struct zfcp_adapter *adapter = act->adapter;
 
 	list_move(&act->list, &act->adapter->erp_ready_head);
-	zfcp_dbf_rec_action("erardy1", act);
+	zfcp_dbf_rec_run("erardy1", act);
 	wake_up(&adapter->erp_ready_wq);
-	zfcp_dbf_rec_thread("erardy2", adapter->dbf);
+	zfcp_dbf_rec_run("erardy2", act);
 }
 
 static void zfcp_erp_action_dismiss(struct zfcp_erp_action *act)
@@ -239,7 +239,7 @@ static int zfcp_erp_action_enqueue(int w
 				   char *id, void *ref, u32 act_status)
 {
 	int retval = 1, need;
-	struct zfcp_erp_action *act = NULL;
+	struct zfcp_erp_action *act;
 
 	if (!adapter->erp_thread)
 		return -EIO;
@@ -255,10 +255,9 @@ static int zfcp_erp_action_enqueue(int w
 	++adapter->erp_total_count;
 	list_add_tail(&act->list, &adapter->erp_ready_head);
 	wake_up(&adapter->erp_ready_wq);
-	zfcp_dbf_rec_thread("eracte1", adapter->dbf);
 	retval = 0;
  out:
-	zfcp_dbf_rec_trigger(id, ref, want, need, act, adapter, port, sdev);
+	zfcp_dbf_rec_trig(id, adapter, port, sdev, want, need);
 	return retval;
 }
 
@@ -490,14 +489,14 @@ static int status_change_set(unsigned lo
 static void zfcp_erp_adapter_unblock(struct zfcp_adapter *adapter)
 {
 	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status))
-		zfcp_dbf_rec_adapter("eraubl1", NULL, adapter->dbf);
+		zfcp_dbf_rec_run("eraubl1", &adapter->erp_action);
 	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status);
 }
 
 static void zfcp_erp_port_unblock(struct zfcp_port *port)
 {
 	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &port->status))
-		zfcp_dbf_rec_port("erpubl1", NULL, port);
+		zfcp_dbf_rec_run("erpubl1", &port->erp_action);
 	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &port->status);
 }
 
@@ -506,14 +505,14 @@ static void zfcp_erp_lun_unblock(struct
 	struct zfcp_scsi_dev *zfcp_sdev = sdev_to_zfcp(sdev);
 
 	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &zfcp_sdev->status))
-		zfcp_dbf_rec_lun("erlubl1", NULL, sdev);
+		zfcp_dbf_rec_run("erlubl1", &sdev_to_zfcp(sdev)->erp_action);
 	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &zfcp_sdev->status);
 }
 
 static void zfcp_erp_action_to_running(struct zfcp_erp_action *erp_action)
 {
 	list_move(&erp_action->list, &erp_action->adapter->erp_running_head);
-	zfcp_dbf_rec_action("erator1", erp_action);
+	zfcp_dbf_rec_run("erator1", erp_action);
 }
 
 static void zfcp_erp_strategy_check_fsfreq(struct zfcp_erp_action *act)
@@ -530,11 +529,11 @@ static void zfcp_erp_strategy_check_fsfr
 		if (act->status & (ZFCP_STATUS_ERP_DISMISSED |
 				   ZFCP_STATUS_ERP_TIMEDOUT)) {
 			req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
-			zfcp_dbf_rec_action("erscf_1", act);
+			zfcp_dbf_rec_run("erscf_1", act);
 			req->erp_action = NULL;
 		}
 		if (act->status & ZFCP_STATUS_ERP_TIMEDOUT)
-			zfcp_dbf_rec_action("erscf_2", act);
+			zfcp_dbf_rec_run("erscf_2", act);
 		if (req->status & ZFCP_STATUS_FSFREQ_DISMISSED)
 			act->fsf_req_id = 0;
 	} else
@@ -693,10 +692,8 @@ static int zfcp_erp_adapter_strat_fsf_xc
 			return ZFCP_ERP_FAILED;
 		}
 
-		zfcp_dbf_rec_thread_lock("erasfx1", adapter->dbf);
 		wait_event(adapter->erp_ready_wq,
 			   !list_empty(&adapter->erp_ready_head));
-		zfcp_dbf_rec_thread_lock("erasfx2", adapter->dbf);
 		if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT)
 			break;
 
@@ -735,10 +732,10 @@ static int zfcp_erp_adapter_strategy_ope
 	if (ret)
 		return ZFCP_ERP_FAILED;
 
-	zfcp_dbf_rec_thread_lock("erasox1", adapter->dbf);
+	zfcp_dbf_rec_run("erasox1", act);
 	wait_event(adapter->erp_ready_wq,
 		   !list_empty(&adapter->erp_ready_head));
-	zfcp_dbf_rec_thread_lock("erasox2", adapter->dbf);
+	zfcp_dbf_rec_run("erasox2", act);
 	if (act->status & ZFCP_STATUS_ERP_TIMEDOUT)
 		return ZFCP_ERP_FAILED;
 
@@ -1206,7 +1203,7 @@ static void zfcp_erp_action_dequeue(stru
 	}
 
 	list_del(&erp_action->list);
-	zfcp_dbf_rec_action("eractd1", erp_action);
+	zfcp_dbf_rec_run("eractd1", erp_action);
 
 	switch (erp_action->action) {
 	case ZFCP_ERP_ACTION_REOPEN_LUN:
@@ -1357,11 +1354,9 @@ static int zfcp_erp_thread(void *data)
 	unsigned long flags;
 
 	for (;;) {
-		zfcp_dbf_rec_thread_lock("erthrd1", adapter->dbf);
 		wait_event_interruptible(adapter->erp_ready_wq,
 			   !list_empty(&adapter->erp_ready_head) ||
 			   kthread_should_stop());
-		zfcp_dbf_rec_thread_lock("erthrd2", adapter->dbf);
 
 		if (kthread_should_stop())
 			break;
--- a/drivers/s390/scsi/zfcp_ext.h
+++ b/drivers/s390/scsi/zfcp_ext.h
@@ -46,15 +46,9 @@ extern void zfcp_cfdc_adapter_access_cha
 /* zfcp_dbf.c */
 extern int zfcp_dbf_adapter_register(struct zfcp_adapter *);
 extern void zfcp_dbf_adapter_unregister(struct zfcp_dbf *);
-extern void zfcp_dbf_rec_thread(char *, struct zfcp_dbf *);
-extern void zfcp_dbf_rec_thread_lock(char *, struct zfcp_dbf *);
-extern void zfcp_dbf_rec_adapter(char *, void *, struct zfcp_dbf *);
-extern void zfcp_dbf_rec_port(char *, void *, struct zfcp_port *);
-extern void zfcp_dbf_rec_lun(char *, void *, struct scsi_device *);
-extern void zfcp_dbf_rec_trigger(char *, void *, u8, u8, void *,
-				 struct zfcp_adapter *, struct zfcp_port *,
-				 struct scsi_device *);
-extern void zfcp_dbf_rec_action(char *, struct zfcp_erp_action *);
+extern void zfcp_dbf_rec_trig(char *, struct zfcp_adapter *,
+			      struct zfcp_port *, struct scsi_device *, u8, u8);
+extern void zfcp_dbf_rec_run(char *, struct zfcp_erp_action *);
 extern void _zfcp_dbf_hba_fsf_response(const char *, int, struct zfcp_fsf_req *,
 				       struct zfcp_dbf *);
 extern void _zfcp_dbf_hba_fsf_unsol(const char *, int level, struct zfcp_dbf *,

