From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 08/11] zfcp: Add traces for state changes.
Date: Thu, 27 Mar 2008 14:22:02 +0100
Message-ID: <20080327133028.840759000@de.ibm.com>
References: <20080327132154.826339000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:9322 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758142AbYC0Nad (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2008 09:30:33 -0400
Content-Disposition: inline; filename=zfcp_rec_dbf_record_target.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

This patch writes a trace record which provides information about state
changes for adapters, ports and units, e.g. target failure, targets becoming
online, targets being temporarily blocked due to pending recovery, targets
which have been recovered successfully etc.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_ccw.c           |    6 -
 drivers/s390/scsi/zfcp_dbf.c           |  126 +++++++++++++++++++++++++++
 drivers/s390/scsi/zfcp_def.h           |   11 ++
 drivers/s390/scsi/zfcp_erp.c           |  153 +++++++++++++++++++--------------
 drivers/s390/scsi/zfcp_ext.h           |   24 +++--
 drivers/s390/scsi/zfcp_fsf.c           |   70 +++++++--------
 drivers/s390/scsi/zfcp_scsi.c          |    2 
 drivers/s390/scsi/zfcp_sysfs_adapter.c |    4 
 drivers/s390/scsi/zfcp_sysfs_port.c    |    3 
 drivers/s390/scsi/zfcp_sysfs_unit.c    |    3 
 10 files changed, 288 insertions(+), 114 deletions(-)

--- a/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 13:57:02.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 13:57:10.000000000 +0100
@@ -522,6 +522,7 @@ static struct debug_view zfcp_hba_dbf_vi
 
 static const char *zfcp_rec_dbf_tags[] = {
 	[ZFCP_REC_DBF_ID_THREAD] = "thread",
+	[ZFCP_REC_DBF_ID_TARGET] = "target",
 };
 
 static const char *zfcp_rec_dbf_ids[] = {
@@ -534,6 +535,58 @@ static const char *zfcp_rec_dbf_ids[] = 
 	[7]	= "down wakeup ecd",
 	[8]	= "down sleep epd",
 	[9]	= "down wakeup epd",
+	[10]	= "online",
+	[11]	= "operational",
+	[12]	= "scsi slave destroy",
+	[13]	= "propagate failed adapter",
+	[14]	= "propagate failed port",
+	[15]	= "block adapter",
+	[16]	= "unblock adapter",
+	[17]	= "block port",
+	[18]	= "unblock port",
+	[19]	= "block unit",
+	[20]	= "unblock unit",
+	[21]	= "unit recovery failed",
+	[22]	= "port recovery failed",
+	[23]	= "adapter recovery failed",
+	[24]	= "qdio queues down",
+	[25]	= "p2p failed",
+	[26]	= "nameserver lookup failed",
+	[27]	= "nameserver port failed",
+	[28]	= "link up",
+	[29]	= "link down",
+	[30]	= "link up status read",
+	[31]	= "open port failed",
+	[32]	= "open port failed",
+	[33]	= "close port",
+	[34]	= "open unit failed",
+	[35]	= "exclusive open unit failed",
+	[36]	= "shared open unit failed",
+	[37]	= "link down",
+	[38]	= "link down status read no link",
+	[39]	= "link down status read fdisc login",
+	[40]	= "link down status read firmware update",
+	[41]	= "link down status read unknown reason",
+	[42]	= "link down ecd incomplete",
+	[43]	= "link down epd incomplete",
+	[44]	= "sysfs adapter recovery",
+	[45]	= "sysfs port recovery",
+	[46]	= "sysfs unit recovery",
+	[47]	= "port boxed abort",
+	[48]	= "unit boxed abort",
+	[49]	= "port boxed ct",
+	[50]	= "port boxed close physical",
+	[51]	= "port boxed open unit",
+	[52]	= "port boxed close unit",
+	[53]	= "port boxed fcp",
+	[54]	= "unit boxed fcp",
+	[55]	= "port access denied ct",
+	[56]	= "port access denied els",
+	[57]	= "port access denied open port",
+	[58]	= "port access denied close physical",
+	[59]	= "unit access denied open unit",
+	[60]	= "shared unit access denied open unit",
+	[61]	= "unit access denied fcp",
 };
 
 static int zfcp_rec_dbf_view_format(debug_info_t *id, struct debug_view *view,
@@ -552,6 +605,14 @@ static int zfcp_rec_dbf_view_format(debu
 		zfcp_dbf_out(&p, "ready", "%d", r->u.thread.ready);
 		zfcp_dbf_out(&p, "running", "%d", r->u.thread.running);
 		break;
+	case ZFCP_REC_DBF_ID_TARGET:
+		zfcp_dbf_out(&p, "reference", "0x%016Lx", r->u.target.ref);
+		zfcp_dbf_out(&p, "status", "0x%08x", r->u.target.status);
+		zfcp_dbf_out(&p, "erp_count", "%d", r->u.target.erp_count);
+		zfcp_dbf_out(&p, "d_id", "0x%06x", r->u.target.d_id);
+		zfcp_dbf_out(&p, "wwpn", "0x%016Lx", r->u.target.wwpn);
+		zfcp_dbf_out(&p, "fcp_lun", "0x%016Lx", r->u.target.fcp_lun);
+		break;
 	}
 	sprintf(p, "\n");
 	return (p - buf) + 1;
@@ -601,6 +662,71 @@ void zfcp_rec_dbf_event_thread(u8 id2, s
 	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
 }
 
+static void zfcp_rec_dbf_event_target(u8 id2, u64 ref,
+				      struct zfcp_adapter *adapter,
+				      atomic_t *status, atomic_t *erp_count,
+				      u64 wwpn, u32 d_id, u64 fcp_lun)
+{
+	struct zfcp_rec_dbf_record *r = &adapter->rec_dbf_buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->rec_dbf_lock, flags);
+	memset(r, 0, sizeof(*r));
+	r->id = ZFCP_REC_DBF_ID_TARGET;
+	r->id2 = id2;
+	r->u.target.ref = ref;
+	r->u.target.status = atomic_read(status);
+	r->u.target.wwpn = wwpn;
+	r->u.target.d_id = d_id;
+	r->u.target.fcp_lun = fcp_lun;
+	r->u.target.erp_count = atomic_read(erp_count);
+	debug_event(adapter->rec_dbf, 3, r, sizeof(*r));
+	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
+}
+
+/**
+ * zfcp_rec_dbf_event_adapter - trace event for adapter state change
+ * @id: identifier for trigger of state change
+ * @ref: additional reference (e.g. request)
+ * @adapter: adapter
+ */
+void zfcp_rec_dbf_event_adapter(u8 id, u64 ref, struct zfcp_adapter *adapter)
+{
+	zfcp_rec_dbf_event_target(id, ref, adapter, &adapter->status,
+				  &adapter->erp_counter, 0, 0, 0);
+}
+
+/**
+ * zfcp_rec_dbf_event_port - trace event for port state change
+ * @id: identifier for trigger of state change
+ * @ref: additional reference (e.g. request)
+ * @port: port
+ */
+void zfcp_rec_dbf_event_port(u8 id, u64 ref, struct zfcp_port *port)
+{
+	struct zfcp_adapter *adapter = port->adapter;
+
+	zfcp_rec_dbf_event_target(id, ref, adapter, &port->status,
+				  &port->erp_counter, port->wwpn, port->d_id,
+				  0);
+}
+
+/**
+ * zfcp_rec_dbf_event_unit - trace event for unit state change
+ * @id: identifier for trigger of state change
+ * @ref: additional reference (e.g. request)
+ * @unit: unit
+ */
+void zfcp_rec_dbf_event_unit(u8 id, u64 ref, struct zfcp_unit *unit)
+{
+	struct zfcp_port *port = unit->port;
+	struct zfcp_adapter *adapter = port->adapter;
+
+	zfcp_rec_dbf_event_target(id, ref, adapter, &unit->status,
+				  &unit->erp_counter, port->wwpn, port->d_id,
+				  unit->fcp_lun);
+}
+
 static void
 _zfcp_san_dbf_event_common_ct(const char *tag, struct zfcp_fsf_req *fsf_req,
 			      u32 s_id, u32 d_id, void *buffer, int buflen)
--- a/drivers/s390/scsi/zfcp_ext.h	2008-03-27 13:57:02.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-03-27 13:57:10.000000000 +0100
@@ -131,22 +131,23 @@ extern int zfcp_scsi_command_sync(struct
 extern struct fc_function_template zfcp_transport_functions;
 
 /******************************** ERP ****************************************/
-extern void zfcp_erp_modify_adapter_status(struct zfcp_adapter *, u32, int);
+extern void zfcp_erp_modify_adapter_status(struct zfcp_adapter *, u8, u64, u32,
+					   int);
 extern int  zfcp_erp_adapter_reopen(struct zfcp_adapter *, int);
 extern int  zfcp_erp_adapter_shutdown(struct zfcp_adapter *, int);
-extern void zfcp_erp_adapter_failed(struct zfcp_adapter *);
+extern void zfcp_erp_adapter_failed(struct zfcp_adapter *, u8, u64);
 
-extern void zfcp_erp_modify_port_status(struct zfcp_port *, u32, int);
+extern void zfcp_erp_modify_port_status(struct zfcp_port *, u8, u64, u32, int);
 extern int  zfcp_erp_port_reopen(struct zfcp_port *, int);
 extern int  zfcp_erp_port_shutdown(struct zfcp_port *, int);
 extern int  zfcp_erp_port_forced_reopen(struct zfcp_port *, int);
-extern void zfcp_erp_port_failed(struct zfcp_port *);
+extern void zfcp_erp_port_failed(struct zfcp_port *, u8, u64);
 extern int  zfcp_erp_port_reopen_all(struct zfcp_adapter *, int);
 
-extern void zfcp_erp_modify_unit_status(struct zfcp_unit *, u32, int);
+extern void zfcp_erp_modify_unit_status(struct zfcp_unit *, u8, u64, u32, int);
 extern int  zfcp_erp_unit_reopen(struct zfcp_unit *, int);
 extern int  zfcp_erp_unit_shutdown(struct zfcp_unit *, int);
-extern void zfcp_erp_unit_failed(struct zfcp_unit *);
+extern void zfcp_erp_unit_failed(struct zfcp_unit *, u8, u64);
 
 extern int  zfcp_erp_thread_setup(struct zfcp_adapter *);
 extern int  zfcp_erp_thread_kill(struct zfcp_adapter *);
@@ -155,10 +156,10 @@ extern void zfcp_erp_async_handler(struc
 
 extern int  zfcp_test_link(struct zfcp_port *);
 
-extern void zfcp_erp_port_boxed(struct zfcp_port *);
-extern void zfcp_erp_unit_boxed(struct zfcp_unit *);
-extern void zfcp_erp_port_access_denied(struct zfcp_port *);
-extern void zfcp_erp_unit_access_denied(struct zfcp_unit *);
+extern void zfcp_erp_port_boxed(struct zfcp_port *, u8 id, u64 ref);
+extern void zfcp_erp_unit_boxed(struct zfcp_unit *, u8 id, u64 ref);
+extern void zfcp_erp_port_access_denied(struct zfcp_port *, u8 id, u64 ref);
+extern void zfcp_erp_unit_access_denied(struct zfcp_unit *, u8 id, u64 ref);
 extern void zfcp_erp_adapter_access_changed(struct zfcp_adapter *);
 extern void zfcp_erp_port_access_changed(struct zfcp_port *);
 extern void zfcp_erp_unit_access_changed(struct zfcp_unit *);
@@ -166,6 +167,9 @@ extern void zfcp_erp_unit_access_changed
 /******************************** AUX ****************************************/
 extern void zfcp_rec_dbf_event_thread(u8 id, struct zfcp_adapter *adapter,
 				      int lock);
+extern void zfcp_rec_dbf_event_adapter(u8 id, u64 ref, struct zfcp_adapter *);
+extern void zfcp_rec_dbf_event_port(u8 id, u64 ref, struct zfcp_port *port);
+extern void zfcp_rec_dbf_event_unit(u8 id, u64 ref, struct zfcp_unit *unit);
 
 extern void zfcp_hba_dbf_event_fsf_response(struct zfcp_fsf_req *);
 extern void zfcp_hba_dbf_event_fsf_unsol(const char *, struct zfcp_adapter *,
--- a/drivers/s390/scsi/zfcp_erp.c	2008-03-27 13:57:02.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-03-27 13:57:10.000000000 +0100
@@ -163,7 +163,7 @@ static void zfcp_close_fsf(struct zfcp_a
 	/* reset FSF request sequence number */
 	adapter->fsf_req_seq_no = 0;
 	/* all ports and units are closed */
-	zfcp_erp_modify_adapter_status(adapter,
+	zfcp_erp_modify_adapter_status(adapter, 24, 0,
 				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
 }
 
@@ -216,7 +216,7 @@ zfcp_erp_adapter_reopen_internal(struct 
 			       zfcp_get_busid_by_adapter(adapter));
 		debug_text_event(adapter->erp_dbf, 5, "a_ro_f");
 		/* ensure propagation of failed status to new devices */
-		zfcp_erp_adapter_failed(adapter);
+		zfcp_erp_adapter_failed(adapter, 13, 0);
 		retval = -EIO;
 		goto out;
 	}
@@ -572,7 +572,7 @@ zfcp_erp_port_reopen_internal(struct zfc
 		debug_text_event(adapter->erp_dbf, 5, "p_ro_f");
 		debug_event(adapter->erp_dbf, 5, &port->wwpn, sizeof (wwn_t));
 		/* ensure propagation of failed status to new devices */
-		zfcp_erp_port_failed(port);
+		zfcp_erp_port_failed(port, 14, 0);
 		retval = -EIO;
 		goto out;
 	}
@@ -688,18 +688,44 @@ zfcp_erp_unit_reopen(struct zfcp_unit *u
 static void zfcp_erp_adapter_block(struct zfcp_adapter *adapter, int clear_mask)
 {
 	debug_text_event(adapter->erp_dbf, 6, "a_bl");
-	zfcp_erp_modify_adapter_status(adapter,
+	zfcp_erp_modify_adapter_status(adapter, 15, 0,
 				       ZFCP_STATUS_COMMON_UNBLOCKED |
 				       clear_mask, ZFCP_CLEAR);
 }
 
+/* FIXME: isn't really atomic */
+/*
+ * returns the mask which has not been set so far, i.e.
+ * 0 if no bit has been changed, !0 if some bit has been changed
+ */
+static int atomic_test_and_set_mask(unsigned long mask, atomic_t *v)
+{
+	int changed_bits = (atomic_read(v) /*XOR*/^ mask) & mask;
+	atomic_set_mask(mask, v);
+	return changed_bits;
+}
+
+/* FIXME: isn't really atomic */
+/*
+ * returns the mask which has not been cleared so far, i.e.
+ * 0 if no bit has been changed, !0 if some bit has been changed
+ */
+static int atomic_test_and_clear_mask(unsigned long mask, atomic_t *v)
+{
+	int changed_bits = atomic_read(v) & mask;
+	atomic_clear_mask(mask, v);
+	return changed_bits;
+}
+
 /**
  * zfcp_erp_adapter_unblock - mark adapter as unblocked, allow scsi requests
  */
 static void zfcp_erp_adapter_unblock(struct zfcp_adapter *adapter)
 {
 	debug_text_event(adapter->erp_dbf, 6, "a_ubl");
-	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status);
+	if (atomic_test_and_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
+				     &adapter->status))
+		zfcp_rec_dbf_event_adapter(16, 0, adapter);
 }
 
 /*
@@ -718,7 +744,7 @@ zfcp_erp_port_block(struct zfcp_port *po
 
 	debug_text_event(adapter->erp_dbf, 6, "p_bl");
 	debug_event(adapter->erp_dbf, 6, &port->wwpn, sizeof (wwn_t));
-	zfcp_erp_modify_port_status(port,
+	zfcp_erp_modify_port_status(port, 17, 0,
 				    ZFCP_STATUS_COMMON_UNBLOCKED | clear_mask,
 				    ZFCP_CLEAR);
 }
@@ -737,7 +763,9 @@ zfcp_erp_port_unblock(struct zfcp_port *
 
 	debug_text_event(adapter->erp_dbf, 6, "p_ubl");
 	debug_event(adapter->erp_dbf, 6, &port->wwpn, sizeof (wwn_t));
-	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &port->status);
+	if (atomic_test_and_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
+				     &port->status))
+		zfcp_rec_dbf_event_port(18, 0, port);
 }
 
 /*
@@ -756,7 +784,7 @@ zfcp_erp_unit_block(struct zfcp_unit *un
 
 	debug_text_event(adapter->erp_dbf, 6, "u_bl");
 	debug_event(adapter->erp_dbf, 6, &unit->fcp_lun, sizeof (fcp_lun_t));
-	zfcp_erp_modify_unit_status(unit,
+	zfcp_erp_modify_unit_status(unit, 19, 0,
 				    ZFCP_STATUS_COMMON_UNBLOCKED | clear_mask,
 				    ZFCP_CLEAR);
 }
@@ -775,7 +803,9 @@ zfcp_erp_unit_unblock(struct zfcp_unit *
 
 	debug_text_event(adapter->erp_dbf, 6, "u_ubl");
 	debug_event(adapter->erp_dbf, 6, &unit->fcp_lun, sizeof (fcp_lun_t));
-	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &unit->status);
+	if (atomic_test_and_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
+				     &unit->status))
+		zfcp_rec_dbf_event_unit(20, 0, unit);
 }
 
 static void
@@ -1357,9 +1387,9 @@ zfcp_erp_strategy_memwait(struct zfcp_er
  *
  */
 void
-zfcp_erp_adapter_failed(struct zfcp_adapter *adapter)
+zfcp_erp_adapter_failed(struct zfcp_adapter *adapter, u8 id, u64 ref)
 {
-	zfcp_erp_modify_adapter_status(adapter,
+	zfcp_erp_modify_adapter_status(adapter, id, ref,
 				       ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
 	ZFCP_LOG_NORMAL("adapter erp failed on adapter %s\n",
 			zfcp_get_busid_by_adapter(adapter));
@@ -1373,9 +1403,9 @@ zfcp_erp_adapter_failed(struct zfcp_adap
  *
  */
 void
-zfcp_erp_port_failed(struct zfcp_port *port)
+zfcp_erp_port_failed(struct zfcp_port *port, u8 id, u64 ref)
 {
-	zfcp_erp_modify_port_status(port,
+	zfcp_erp_modify_port_status(port, id, ref,
 				    ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
 
 	if (atomic_test_mask(ZFCP_STATUS_PORT_WKA, &port->status))
@@ -1397,9 +1427,9 @@ zfcp_erp_port_failed(struct zfcp_port *p
  *
  */
 void
-zfcp_erp_unit_failed(struct zfcp_unit *unit)
+zfcp_erp_unit_failed(struct zfcp_unit *unit, u8 id, u64 ref)
 {
-	zfcp_erp_modify_unit_status(unit,
+	zfcp_erp_modify_unit_status(unit, id, ref,
 				    ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
 
 	ZFCP_LOG_NORMAL("unit erp failed on unit 0x%016Lx on port 0x%016Lx "
@@ -1522,7 +1552,7 @@ zfcp_erp_strategy_check_unit(struct zfcp
 	case ZFCP_ERP_FAILED :
 		atomic_inc(&unit->erp_counter);
 		if (atomic_read(&unit->erp_counter) > ZFCP_MAX_ERPS)
-			zfcp_erp_unit_failed(unit);
+			zfcp_erp_unit_failed(unit, 21, 0);
 		break;
 	case ZFCP_ERP_EXIT :
 		/* nothing */
@@ -1551,7 +1581,7 @@ zfcp_erp_strategy_check_port(struct zfcp
 	case ZFCP_ERP_FAILED :
 		atomic_inc(&port->erp_counter);
 		if (atomic_read(&port->erp_counter) > ZFCP_MAX_ERPS)
-			zfcp_erp_port_failed(port);
+			zfcp_erp_port_failed(port, 22, 0);
 		break;
 	case ZFCP_ERP_EXIT :
 		/* nothing */
@@ -1579,7 +1609,7 @@ zfcp_erp_strategy_check_adapter(struct z
 	case ZFCP_ERP_FAILED :
 		atomic_inc(&adapter->erp_counter);
 		if (atomic_read(&adapter->erp_counter) > ZFCP_MAX_ERPS)
-			zfcp_erp_adapter_failed(adapter);
+			zfcp_erp_adapter_failed(adapter, 23, 0);
 		break;
 	case ZFCP_ERP_EXIT :
 		/* nothing */
@@ -1737,29 +1767,30 @@ zfcp_erp_wait(struct zfcp_adapter *adapt
 	return retval;
 }
 
-void
-zfcp_erp_modify_adapter_status(struct zfcp_adapter *adapter,
-			       u32 mask, int set_or_clear)
+void zfcp_erp_modify_adapter_status(struct zfcp_adapter *adapter, u8 id,
+				    u64 ref, u32 mask, int set_or_clear)
 {
 	struct zfcp_port *port;
-	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
+	u32 changed, common_mask = mask & ZFCP_COMMON_FLAGS;
 
 	if (set_or_clear == ZFCP_SET) {
-		atomic_set_mask(mask, &adapter->status);
+		changed = atomic_test_and_set_mask(mask, &adapter->status);
 		debug_text_event(adapter->erp_dbf, 3, "a_mod_as_s");
 	} else {
-		atomic_clear_mask(mask, &adapter->status);
+		changed = atomic_test_and_clear_mask(mask, &adapter->status);
 		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED)
 			atomic_set(&adapter->erp_counter, 0);
 		debug_text_event(adapter->erp_dbf, 3, "a_mod_as_c");
 	}
+	if (changed)
+		zfcp_rec_dbf_event_adapter(id, ref, adapter);
 	debug_event(adapter->erp_dbf, 3, &mask, sizeof (u32));
 
 	/* Deal with all underlying devices, only pass common_mask */
 	if (common_mask)
 		list_for_each_entry(port, &adapter->port_list_head, list)
-		    zfcp_erp_modify_port_status(port, common_mask,
-						set_or_clear);
+			zfcp_erp_modify_port_status(port, id, ref, common_mask,
+						    set_or_clear);
 }
 
 /*
@@ -1768,29 +1799,31 @@ zfcp_erp_modify_adapter_status(struct zf
  * purpose:	sets the port and all underlying devices to ERP_FAILED
  *
  */
-void
-zfcp_erp_modify_port_status(struct zfcp_port *port, u32 mask, int set_or_clear)
+void zfcp_erp_modify_port_status(struct zfcp_port *port, u8 id, u64 ref,
+				 u32 mask, int set_or_clear)
 {
 	struct zfcp_unit *unit;
-	u32 common_mask = mask & ZFCP_COMMON_FLAGS;
+	u32 changed, common_mask = mask & ZFCP_COMMON_FLAGS;
 
 	if (set_or_clear == ZFCP_SET) {
-		atomic_set_mask(mask, &port->status);
+		changed = atomic_test_and_set_mask(mask, &port->status);
 		debug_text_event(port->adapter->erp_dbf, 3, "p_mod_ps_s");
 	} else {
-		atomic_clear_mask(mask, &port->status);
+		changed = atomic_test_and_clear_mask(mask, &port->status);
 		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED)
 			atomic_set(&port->erp_counter, 0);
 		debug_text_event(port->adapter->erp_dbf, 3, "p_mod_ps_c");
 	}
+	if (changed)
+		zfcp_rec_dbf_event_port(id, ref, port);
 	debug_event(port->adapter->erp_dbf, 3, &port->wwpn, sizeof (wwn_t));
 	debug_event(port->adapter->erp_dbf, 3, &mask, sizeof (u32));
 
 	/* Modify status of all underlying devices, only pass common mask */
 	if (common_mask)
 		list_for_each_entry(unit, &port->unit_list_head, list)
-		    zfcp_erp_modify_unit_status(unit, common_mask,
-						set_or_clear);
+			zfcp_erp_modify_unit_status(unit, id, ref, common_mask,
+						    set_or_clear);
 }
 
 /*
@@ -1799,19 +1832,23 @@ zfcp_erp_modify_port_status(struct zfcp_
  * purpose:	sets the unit to ERP_FAILED
  *
  */
-void
-zfcp_erp_modify_unit_status(struct zfcp_unit *unit, u32 mask, int set_or_clear)
+void zfcp_erp_modify_unit_status(struct zfcp_unit *unit, u8 id, u64 ref,
+				 u32 mask, int set_or_clear)
 {
+	u32 changed;
+
 	if (set_or_clear == ZFCP_SET) {
-		atomic_set_mask(mask, &unit->status);
+		changed = atomic_test_and_set_mask(mask, &unit->status);
 		debug_text_event(unit->port->adapter->erp_dbf, 3, "u_mod_us_s");
 	} else {
-		atomic_clear_mask(mask, &unit->status);
+		changed = atomic_test_and_clear_mask(mask, &unit->status);
 		if (mask & ZFCP_STATUS_COMMON_ERP_FAILED) {
 			atomic_set(&unit->erp_counter, 0);
 		}
 		debug_text_event(unit->port->adapter->erp_dbf, 3, "u_mod_us_c");
 	}
+	if (changed)
+		zfcp_rec_dbf_event_unit(id, ref, unit);
 	debug_event(unit->port->adapter->erp_dbf, 3, &unit->fcp_lun,
 		    sizeof (fcp_lun_t));
 	debug_event(unit->port->adapter->erp_dbf, 3, &mask, sizeof (u32));
@@ -2403,7 +2440,7 @@ zfcp_erp_port_strategy_open_common(struc
 						port->wwpn,
 						zfcp_get_busid_by_adapter(adapter),
 						adapter->peer_wwpn);
-				zfcp_erp_port_failed(port);
+				zfcp_erp_port_failed(port, 25, 0);
 				retval = ZFCP_ERP_FAILED;
 				break;
 			}
@@ -2461,7 +2498,7 @@ zfcp_erp_port_strategy_open_common(struc
 					       "for port 0x%016Lx "
 					       "(misconfigured WWPN?)\n",
 					       port->wwpn);
-				zfcp_erp_port_failed(port);
+				zfcp_erp_port_failed(port, 26, 0);
 				retval = ZFCP_ERP_EXIT;
 			} else {
 				ZFCP_LOG_DEBUG("nameserver look-up failed for "
@@ -2567,7 +2604,7 @@ zfcp_erp_port_strategy_open_nameserver_w
 			if (atomic_test_mask(
 				    ZFCP_STATUS_COMMON_ERP_FAILED,
 				    &adapter->nameserver_port->status))
-				zfcp_erp_port_failed(erp_action->port);
+				zfcp_erp_port_failed(erp_action->port, 27, 0);
 			zfcp_erp_action_ready(erp_action);
 		}
 	}
@@ -3274,8 +3311,7 @@ static void zfcp_erp_action_to_ready(str
 	list_move(&erp_action->list, &erp_action->adapter->erp_ready_head);
 }
 
-void
-zfcp_erp_port_boxed(struct zfcp_port *port)
+void zfcp_erp_port_boxed(struct zfcp_port *port, u8 id, u64 ref)
 {
 	struct zfcp_adapter *adapter = port->adapter;
 	unsigned long flags;
@@ -3283,28 +3319,24 @@ zfcp_erp_port_boxed(struct zfcp_port *po
 	debug_text_event(adapter->erp_dbf, 3, "p_access_boxed");
 	debug_event(adapter->erp_dbf, 3, &port->wwpn, sizeof(wwn_t));
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	zfcp_erp_modify_port_status(port,
-			ZFCP_STATUS_COMMON_ACCESS_BOXED,
-			ZFCP_SET);
+	zfcp_erp_modify_port_status(port, id, ref,
+				    ZFCP_STATUS_COMMON_ACCESS_BOXED, ZFCP_SET);
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED);
 }
 
-void
-zfcp_erp_unit_boxed(struct zfcp_unit *unit)
+void zfcp_erp_unit_boxed(struct zfcp_unit *unit, u8 id, u64 ref)
 {
 	struct zfcp_adapter *adapter = unit->port->adapter;
 
 	debug_text_event(adapter->erp_dbf, 3, "u_access_boxed");
 	debug_event(adapter->erp_dbf, 3, &unit->fcp_lun, sizeof(fcp_lun_t));
-	zfcp_erp_modify_unit_status(unit,
-			ZFCP_STATUS_COMMON_ACCESS_BOXED,
-			ZFCP_SET);
+	zfcp_erp_modify_unit_status(unit, id, ref,
+				    ZFCP_STATUS_COMMON_ACCESS_BOXED, ZFCP_SET);
 	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED);
 }
 
-void
-zfcp_erp_port_access_denied(struct zfcp_port *port)
+void zfcp_erp_port_access_denied(struct zfcp_port *port, u8 id, u64 ref)
 {
 	struct zfcp_adapter *adapter = port->adapter;
 	unsigned long flags;
@@ -3312,24 +3344,21 @@ zfcp_erp_port_access_denied(struct zfcp_
 	debug_text_event(adapter->erp_dbf, 3, "p_access_denied");
 	debug_event(adapter->erp_dbf, 3, &port->wwpn, sizeof(wwn_t));
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	zfcp_erp_modify_port_status(port,
-			ZFCP_STATUS_COMMON_ERP_FAILED |
-			ZFCP_STATUS_COMMON_ACCESS_DENIED,
-			ZFCP_SET);
+	zfcp_erp_modify_port_status(port, id, ref,
+				    ZFCP_STATUS_COMMON_ERP_FAILED |
+				    ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
 
-void
-zfcp_erp_unit_access_denied(struct zfcp_unit *unit)
+void zfcp_erp_unit_access_denied(struct zfcp_unit *unit, u8 id, u64 ref)
 {
 	struct zfcp_adapter *adapter = unit->port->adapter;
 
 	debug_text_event(adapter->erp_dbf, 3, "u_access_denied");
 	debug_event(adapter->erp_dbf, 3, &unit->fcp_lun, sizeof(fcp_lun_t));
-	zfcp_erp_modify_unit_status(unit,
-			ZFCP_STATUS_COMMON_ERP_FAILED |
-			ZFCP_STATUS_COMMON_ACCESS_DENIED,
-			ZFCP_SET);
+	zfcp_erp_modify_unit_status(unit, id, ref,
+				    ZFCP_STATUS_COMMON_ERP_FAILED |
+				    ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
 }
 
 void
--- a/drivers/s390/scsi/zfcp_def.h	2008-03-27 13:57:02.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2008-03-27 13:57:10.000000000 +0100
@@ -286,16 +286,27 @@ struct zfcp_rec_dbf_record_thread {
 	u32 running;
 } __attribute__ ((packed));
 
+struct zfcp_rec_dbf_record_target {
+	u64 ref;
+	u32 status;
+	u32 d_id;
+	u64 wwpn;
+	u64 fcp_lun;
+	u32 erp_count;
+} __attribute__ ((packed));
+
 struct zfcp_rec_dbf_record {
 	u8 id;
 	u8 id2;
 	union {
 		struct zfcp_rec_dbf_record_thread thread;
+		struct zfcp_rec_dbf_record_target target;
 	} u;
 } __attribute__ ((packed));
 
 enum {
 	ZFCP_REC_DBF_ID_THREAD,
+	ZFCP_REC_DBF_ID_TARGET,
 };
 
 struct zfcp_hba_dbf_record_response {
--- a/drivers/s390/scsi/zfcp_ccw.c	2008-03-27 13:54:15.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ccw.c	2008-03-27 13:57:10.000000000 +0100
@@ -170,8 +170,8 @@ zfcp_ccw_set_online(struct ccw_device *c
 	BUG_ON(!zfcp_reqlist_isempty(adapter));
 	adapter->req_no = 0;
 
-	zfcp_erp_modify_adapter_status(adapter, ZFCP_STATUS_COMMON_RUNNING,
-				       ZFCP_SET);
+	zfcp_erp_modify_adapter_status(adapter, 10, 0,
+				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED);
 	zfcp_erp_wait(adapter);
 	goto out;
@@ -236,7 +236,7 @@ zfcp_ccw_notify(struct ccw_device *ccw_d
 		ZFCP_LOG_NORMAL("adapter %s: operational again\n",
 				zfcp_get_busid_by_adapter(adapter));
 		debug_text_event(adapter->erp_dbf,1,"dev_oper");
-		zfcp_erp_modify_adapter_status(adapter,
+		zfcp_erp_modify_adapter_status(adapter, 11, 0,
 					       ZFCP_STATUS_COMMON_RUNNING,
 					       ZFCP_SET);
 		zfcp_erp_adapter_reopen(adapter,
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-03-27 13:54:56.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-03-27 13:58:36.000000000 +0100
@@ -46,7 +46,7 @@ static int zfcp_fsf_req_send(struct zfcp
 static int zfcp_fsf_protstatus_eval(struct zfcp_fsf_req *);
 static int zfcp_fsf_fsfstatus_eval(struct zfcp_fsf_req *);
 static int zfcp_fsf_fsfstatus_qual_eval(struct zfcp_fsf_req *);
-static void zfcp_fsf_link_down_info_eval(struct zfcp_adapter *,
+static void zfcp_fsf_link_down_info_eval(struct zfcp_fsf_req *, u8,
 	struct fsf_link_down_info *);
 static int zfcp_fsf_req_dispatch(struct zfcp_fsf_req *);
 
@@ -342,7 +342,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 		break;
 
 	case FSF_PROT_LINK_DOWN:
-		zfcp_fsf_link_down_info_eval(adapter,
+		zfcp_fsf_link_down_info_eval(fsf_req, 37,
 					     &prot_status_qual->link_down_info);
 		zfcp_erp_adapter_reopen(adapter, 0);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -354,8 +354,8 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 			      "Re-starting operations on this adapter.\n",
 			      zfcp_get_busid_by_adapter(adapter));
 		/* All ports should be marked as ready to run again */
-		zfcp_erp_modify_adapter_status(adapter,
-					       ZFCP_STATUS_COMMON_RUNNING,
+		zfcp_erp_modify_adapter_status(adapter, 28,
+					       0, ZFCP_STATUS_COMMON_RUNNING,
 					       ZFCP_SET);
 		zfcp_erp_adapter_reopen(adapter,
 					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED
@@ -506,9 +506,11 @@ zfcp_fsf_fsfstatus_qual_eval(struct zfcp
  * zfcp_fsf_link_down_info_eval - evaluate link down information block
  */
 static void
-zfcp_fsf_link_down_info_eval(struct zfcp_adapter *adapter,
+zfcp_fsf_link_down_info_eval(struct zfcp_fsf_req *fsf_req, u8 id,
 			     struct fsf_link_down_info *link_down)
 {
+	struct zfcp_adapter *adapter = fsf_req->adapter;
+
 	if (atomic_test_mask(ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED,
 	                     &adapter->status))
 		return;
@@ -599,7 +601,7 @@ zfcp_fsf_link_down_info_eval(struct zfcp
 				link_down->vendor_specific_code);
 
  out:
-	zfcp_erp_adapter_failed(adapter);
+	zfcp_erp_adapter_failed(adapter, id, (u64)fsf_req);
 }
 
 /*
@@ -897,7 +899,7 @@ zfcp_fsf_status_read_handler(struct zfcp
 		case FSF_STATUS_READ_SUB_NO_PHYSICAL_LINK:
 			ZFCP_LOG_INFO("Physical link to adapter %s is down\n",
 				      zfcp_get_busid_by_adapter(adapter));
-			zfcp_fsf_link_down_info_eval(adapter,
+			zfcp_fsf_link_down_info_eval(fsf_req, 38,
 				(struct fsf_link_down_info *)
 				&status_buffer->payload);
 			break;
@@ -905,7 +907,7 @@ zfcp_fsf_status_read_handler(struct zfcp
 			ZFCP_LOG_INFO("Local link to adapter %s is down "
 				      "due to failed FDISC login\n",
 				      zfcp_get_busid_by_adapter(adapter));
-			zfcp_fsf_link_down_info_eval(adapter,
+			zfcp_fsf_link_down_info_eval(fsf_req, 39,
 				(struct fsf_link_down_info *)
 				&status_buffer->payload);
 			break;
@@ -913,13 +915,13 @@ zfcp_fsf_status_read_handler(struct zfcp
 			ZFCP_LOG_INFO("Local link to adapter %s is down "
 				      "due to firmware update on adapter\n",
 				      zfcp_get_busid_by_adapter(adapter));
-			zfcp_fsf_link_down_info_eval(adapter, NULL);
+			zfcp_fsf_link_down_info_eval(fsf_req, 40, NULL);
 			break;
 		default:
 			ZFCP_LOG_INFO("Local link to adapter %s is down "
 				      "due to unknown reason\n",
 				      zfcp_get_busid_by_adapter(adapter));
-			zfcp_fsf_link_down_info_eval(adapter, NULL);
+			zfcp_fsf_link_down_info_eval(fsf_req, 41, NULL);
 		};
 		break;
 
@@ -928,7 +930,7 @@ zfcp_fsf_status_read_handler(struct zfcp
 				"Restarting operations on this adapter\n",
 				zfcp_get_busid_by_adapter(adapter));
 		/* All ports should be marked as ready to run again */
-		zfcp_erp_modify_adapter_status(adapter,
+		zfcp_erp_modify_adapter_status(adapter, 30, 0,
 					       ZFCP_STATUS_COMMON_RUNNING,
 					       ZFCP_SET);
 		zfcp_erp_adapter_reopen(adapter,
@@ -1215,7 +1217,7 @@ zfcp_fsf_abort_fcp_command_handler(struc
 			      zfcp_get_busid_by_unit(unit));
 		debug_text_event(new_fsf_req->adapter->erp_dbf, 2,
 				 "fsf_s_pboxed");
-		zfcp_erp_port_boxed(unit->port);
+		zfcp_erp_port_boxed(unit->port, 47, (u64)new_fsf_req);
 		new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
 		    | ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -1227,7 +1229,7 @@ zfcp_fsf_abort_fcp_command_handler(struc
                         unit->fcp_lun, unit->port->wwpn,
                         zfcp_get_busid_by_unit(unit));
                 debug_text_event(new_fsf_req->adapter->erp_dbf, 1, "fsf_s_lboxed");
-		zfcp_erp_unit_boxed(unit);
+		zfcp_erp_unit_boxed(unit, 48, (u64)new_fsf_req);
                 new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
                         | ZFCP_STATUS_FSFREQ_RETRY;
                 break;
@@ -1519,7 +1521,7 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 			}
 		}
 		debug_text_event(adapter->erp_dbf, 1, "fsf_s_access");
-		zfcp_erp_port_access_denied(port);
+		zfcp_erp_port_access_denied(port, 55, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -1554,7 +1556,7 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 			      "(adapter %s, port d_id=0x%06x)\n",
 			      zfcp_get_busid_by_port(port), port->d_id);
 		debug_text_event(adapter->erp_dbf, 2, "fsf_s_pboxed");
-		zfcp_erp_port_boxed(port);
+		zfcp_erp_port_boxed(port, 49, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
 		    | ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -1880,7 +1882,7 @@ static int zfcp_fsf_send_els_handler(str
 		}
 		debug_text_event(adapter->erp_dbf, 1, "fsf_s_access");
 		if (port != NULL)
-			zfcp_erp_port_access_denied(port);
+			zfcp_erp_port_access_denied(port, 56, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -2210,7 +2212,7 @@ zfcp_fsf_exchange_config_data_handler(st
 		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
 				&adapter->status);
 
-		zfcp_fsf_link_down_info_eval(adapter,
+		zfcp_fsf_link_down_info_eval(fsf_req, 42,
 			&qtcb->header.fsf_status_qual.link_down_info);
 		break;
 	default:
@@ -2393,7 +2395,7 @@ zfcp_fsf_exchange_port_data_handler(stru
 	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
 		zfcp_fsf_exchange_port_evaluate(fsf_req, 0);
 		atomic_set_mask(ZFCP_STATUS_ADAPTER_XPORT_OK, &adapter->status);
-		zfcp_fsf_link_down_info_eval(adapter,
+		zfcp_fsf_link_down_info_eval(fsf_req, 43,
 			&qtcb->header.fsf_status_qual.link_down_info);
                 break;
         default:
@@ -2523,7 +2525,7 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 			}
 		}
 		debug_text_event(fsf_req->adapter->erp_dbf, 1, "fsf_s_access");
-		zfcp_erp_port_access_denied(port);
+		zfcp_erp_port_access_denied(port, 57, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -2534,7 +2536,7 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 			      port->wwpn, zfcp_get_busid_by_port(port));
 		debug_text_event(fsf_req->adapter->erp_dbf, 1,
 				 "fsf_s_max_ports");
-		zfcp_erp_port_failed(port);
+		zfcp_erp_port_failed(port, 31, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -2560,7 +2562,7 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 					zfcp_get_busid_by_port(port));
 			debug_text_exception(fsf_req->adapter->erp_dbf, 0,
 					     "fsf_sq_no_retry");
-			zfcp_erp_port_failed(port);
+			zfcp_erp_port_failed(port, 32, (u64)fsf_req);
 			fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		default:
@@ -2773,7 +2775,7 @@ zfcp_fsf_close_port_handler(struct zfcp_
 		ZFCP_LOG_TRACE("remote port 0x016%Lx on adapter %s closed, "
 			       "port handle 0x%x\n", port->wwpn,
 			       zfcp_get_busid_by_port(port), port->handle);
-		zfcp_erp_modify_port_status(port,
+		zfcp_erp_modify_port_status(port, 33, (u64)fsf_req,
 					    ZFCP_STATUS_COMMON_OPEN,
 					    ZFCP_CLEAR);
 		retval = 0;
@@ -2923,7 +2925,7 @@ zfcp_fsf_close_physical_port_handler(str
 			}
 		}
 		debug_text_event(fsf_req->adapter->erp_dbf, 1, "fsf_s_access");
-		zfcp_erp_port_access_denied(port);
+		zfcp_erp_port_access_denied(port, 58, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -2934,7 +2936,7 @@ zfcp_fsf_close_physical_port_handler(str
 			       port->wwpn,
 			       zfcp_get_busid_by_port(port));
 		debug_text_event(fsf_req->adapter->erp_dbf, 1, "fsf_s_pboxed");
-		zfcp_erp_port_boxed(port);
+		zfcp_erp_port_boxed(port, 50, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
 
@@ -3159,7 +3161,7 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 			}
 		}
 		debug_text_event(adapter->erp_dbf, 1, "fsf_s_access");
-		zfcp_erp_unit_access_denied(unit);
+		zfcp_erp_unit_access_denied(unit, 59, (u64)fsf_req);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
                 atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -3170,7 +3172,7 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 			       "needs to be reopened\n",
 			       unit->port->wwpn, zfcp_get_busid_by_unit(unit));
 		debug_text_event(adapter->erp_dbf, 2, "fsf_s_pboxed");
-		zfcp_erp_port_boxed(unit->port);
+		zfcp_erp_port_boxed(unit->port, 51, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -3212,7 +3214,7 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 			      sizeof (union fsf_status_qual));
 		debug_text_event(adapter->erp_dbf, 2,
 				 "fsf_s_l_sh_vio");
-		zfcp_erp_unit_access_denied(unit);
+		zfcp_erp_unit_access_denied(unit, 60, (u64)fsf_req);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -3228,7 +3230,7 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 			      zfcp_get_busid_by_unit(unit));
 		debug_text_event(adapter->erp_dbf, 1,
 				 "fsf_s_max_units");
-		zfcp_erp_unit_failed(unit);
+		zfcp_erp_unit_failed(unit, 34, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3307,13 +3309,13 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
         		if (exclusive && !readwrite) {
                 		ZFCP_LOG_NORMAL("exclusive access of read-only "
 						"unit not supported\n");
-				zfcp_erp_unit_failed(unit);
+				zfcp_erp_unit_failed(unit, 35, (u64)fsf_req);
 				fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 				zfcp_erp_unit_shutdown(unit, 0);
         		} else if (!exclusive && readwrite) {
                 		ZFCP_LOG_NORMAL("shared access of read-write "
 						"unit not supported\n");
-                		zfcp_erp_unit_failed(unit);
+				zfcp_erp_unit_failed(unit, 36, (u64)fsf_req);
 				fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 				zfcp_erp_unit_shutdown(unit, 0);
         		}
@@ -3471,7 +3473,7 @@ zfcp_fsf_close_unit_handler(struct zfcp_
 			       unit->port->wwpn,
 			       zfcp_get_busid_by_unit(unit));
 		debug_text_event(fsf_req->adapter->erp_dbf, 2, "fsf_s_pboxed");
-		zfcp_erp_port_boxed(unit->port);
+		zfcp_erp_port_boxed(unit->port, 52, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -3928,7 +3930,7 @@ zfcp_fsf_send_fcp_command_handler(struct
 			}
 		}
 		debug_text_event(fsf_req->adapter->erp_dbf, 1, "fsf_s_access");
-		zfcp_erp_unit_access_denied(unit);
+		zfcp_erp_unit_access_denied(unit, 61, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3967,7 +3969,7 @@ zfcp_fsf_send_fcp_command_handler(struct
 			       "needs to be reopened\n",
 			       unit->port->wwpn, zfcp_get_busid_by_unit(unit));
 		debug_text_event(fsf_req->adapter->erp_dbf, 2, "fsf_s_pboxed");
-		zfcp_erp_port_boxed(unit->port);
+		zfcp_erp_port_boxed(unit->port, 53, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -3978,7 +3980,7 @@ zfcp_fsf_send_fcp_command_handler(struct
 				zfcp_get_busid_by_unit(unit),
 				unit->port->wwpn, unit->fcp_lun);
 		debug_text_event(fsf_req->adapter->erp_dbf, 1, "fsf_s_lboxed");
-		zfcp_erp_unit_boxed(unit);
+		zfcp_erp_unit_boxed(unit, 54, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
 			| ZFCP_STATUS_FSFREQ_RETRY;
 		break;
--- a/drivers/s390/scsi/zfcp_sysfs_adapter.c	2008-03-27 13:54:15.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_sysfs_adapter.c	2008-03-27 13:57:10.000000000 +0100
@@ -191,8 +191,8 @@ zfcp_sysfs_adapter_failed_store(struct d
 		goto out;
 	}
 
-	zfcp_erp_modify_adapter_status(adapter, ZFCP_STATUS_COMMON_RUNNING,
-				       ZFCP_SET);
+	zfcp_erp_modify_adapter_status(adapter, 44, 0,
+				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
 	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED);
 	zfcp_erp_wait(adapter);
  out:
--- a/drivers/s390/scsi/zfcp_sysfs_port.c	2008-03-27 13:54:15.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_sysfs_port.c	2008-03-27 13:57:10.000000000 +0100
@@ -193,7 +193,8 @@ zfcp_sysfs_port_failed_store(struct devi
 		goto out;
 	}
 
-	zfcp_erp_modify_port_status(port, ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
+	zfcp_erp_modify_port_status(port, 45, 0,
+				    ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
 	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED);
 	zfcp_erp_wait(port->adapter);
  out:
--- a/drivers/s390/scsi/zfcp_sysfs_unit.c	2008-03-27 13:54:15.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_sysfs_unit.c	2008-03-27 13:57:10.000000000 +0100
@@ -94,7 +94,8 @@ zfcp_sysfs_unit_failed_store(struct devi
 		goto out;
 	}
 
-	zfcp_erp_modify_unit_status(unit, ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
+	zfcp_erp_modify_unit_status(unit, 46, 0,
+				    ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
 	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED);
 	zfcp_erp_wait(unit->port->adapter);
  out:
--- a/drivers/s390/scsi/zfcp_scsi.c	2008-03-27 13:54:15.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-03-27 13:57:10.000000000 +0100
@@ -185,7 +185,7 @@ static void zfcp_scsi_slave_destroy(stru
 		atomic_clear_mask(ZFCP_STATUS_UNIT_REGISTERED, &unit->status);
 		sdpnt->hostdata = NULL;
 		unit->device = NULL;
-		zfcp_erp_unit_failed(unit);
+		zfcp_erp_unit_failed(unit, 12, 0);
 		zfcp_unit_put(unit);
 	} else
 		ZFCP_LOG_NORMAL("bug: no unit associated with SCSI device at "

-- 
