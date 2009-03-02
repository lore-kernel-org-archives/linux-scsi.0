From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 11/18] [PATCH] zfcp: replace current ERP logging with a more convenient version
Date: Mon, 02 Mar 2009 13:09:04 +0100
Message-ID: <20090302121003.511293000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:51364 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758730AbZCBMKH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:10:07 -0500
Content-Disposition: inline; filename=711-zfcp-erplog.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The current number based id ERP logging is replaced by a string
based tag version. The benefit is an easier location of the code in
question and the removal of the lengthy array referencing the
individual messages.
The string (7 bytes) based version does not use more space since those
bytes were "used" anyway due to the alignment of the structure.
The encoding of the 7 byte string is as follows
        [0-1] = filename
        [2-5] = task/function
        [6]   = section
Due to the character of this string (fixed length) a string
termination is not required here.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c   |    3 
 drivers/s390/scsi/zfcp_ccw.c   |   18 +--
 drivers/s390/scsi/zfcp_dbf.c   |  188 +++--------------------------------------
 drivers/s390/scsi/zfcp_dbf.h   |    3 
 drivers/s390/scsi/zfcp_erp.c   |  137 +++++++++++++++--------------
 drivers/s390/scsi/zfcp_ext.h   |   55 ++++++-----
 drivers/s390/scsi/zfcp_fc.c    |   14 +--
 drivers/s390/scsi/zfcp_fsf.c   |  131 ++++++++++++++--------------
 drivers/s390/scsi/zfcp_qdio.c  |    6 -
 drivers/s390/scsi/zfcp_scsi.c  |    4 
 drivers/s390/scsi/zfcp_sysfs.c |   12 +-
 11 files changed, 215 insertions(+), 356 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2009-03-02 12:42:33.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_aux.c	2009-03-02 12:42:38.000000000 +0100
@@ -421,7 +421,8 @@ int zfcp_status_read_refill(struct zfcp_
 	while (atomic_read(&adapter->stat_miss) > 0)
 		if (zfcp_fsf_status_read(adapter)) {
 			if (atomic_read(&adapter->stat_miss) >= 16) {
-				zfcp_erp_adapter_reopen(adapter, 0, 103, NULL);
+				zfcp_erp_adapter_reopen(adapter, 0, "axsref1",
+							NULL);
 				return 1;
 			}
 			break;
--- a/drivers/s390/scsi/zfcp_ccw.c	2009-03-02 12:42:23.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ccw.c	2009-03-02 12:42:38.000000000 +0100
@@ -109,10 +109,10 @@ static int zfcp_ccw_set_online(struct cc
 	BUG_ON(!zfcp_reqlist_isempty(adapter));
 	adapter->req_no = 0;
 
-	zfcp_erp_modify_adapter_status(adapter, 10, NULL,
+	zfcp_erp_modify_adapter_status(adapter, "ccsonl1", NULL,
 				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
-	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED, 85,
-				NULL);
+	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
+				"ccsonl2", NULL);
 	zfcp_erp_wait(adapter);
 	up(&zfcp_data.config_sema);
 	flush_work(&adapter->scan_work);
@@ -136,7 +136,7 @@ static int zfcp_ccw_set_offline(struct c
 
 	down(&zfcp_data.config_sema);
 	adapter = dev_get_drvdata(&ccw_device->dev);
-	zfcp_erp_adapter_shutdown(adapter, 0, 86, NULL);
+	zfcp_erp_adapter_shutdown(adapter, 0, "ccsoff1", NULL);
 	zfcp_erp_wait(adapter);
 	zfcp_erp_thread_kill(adapter);
 	up(&zfcp_data.config_sema);
@@ -159,21 +159,21 @@ static int zfcp_ccw_notify(struct ccw_de
 	case CIO_GONE:
 		dev_warn(&adapter->ccw_device->dev,
 			 "The FCP device has been detached\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, 87, NULL);
+		zfcp_erp_adapter_shutdown(adapter, 0, "ccnoti1", NULL);
 		break;
 	case CIO_NO_PATH:
 		dev_warn(&adapter->ccw_device->dev,
 			 "The CHPID for the FCP device is offline\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, 88, NULL);
+		zfcp_erp_adapter_shutdown(adapter, 0, "ccnoti2", NULL);
 		break;
 	case CIO_OPER:
 		dev_info(&adapter->ccw_device->dev,
 			 "The FCP device is operational again\n");
-		zfcp_erp_modify_adapter_status(adapter, 11, NULL,
+		zfcp_erp_modify_adapter_status(adapter, "ccnoti3", NULL,
 					       ZFCP_STATUS_COMMON_RUNNING,
 					       ZFCP_SET);
 		zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
-					89, NULL);
+					"ccnoti4", NULL);
 		break;
 	}
 	return 1;
@@ -189,7 +189,7 @@ static void zfcp_ccw_shutdown(struct ccw
 
 	down(&zfcp_data.config_sema);
 	adapter = dev_get_drvdata(&cdev->dev);
-	zfcp_erp_adapter_shutdown(adapter, 0, 90, NULL);
+	zfcp_erp_adapter_shutdown(adapter, 0, "ccshut1", NULL);
 	zfcp_erp_wait(adapter);
 	up(&zfcp_data.config_sema);
 }
--- a/drivers/s390/scsi/zfcp_dbf.c	2009-03-02 12:42:36.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2009-03-02 12:42:38.000000000 +0100
@@ -490,172 +490,17 @@ static const char *zfcp_rec_dbf_tags[] =
 	[ZFCP_REC_DBF_ID_ACTION] = "action",
 };
 
-static const char *zfcp_rec_dbf_ids[] = {
-	[1]	= "new",
-	[2]	= "ready",
-	[3]	= "kill",
-	[4]	= "down sleep",
-	[5]	= "down wakeup",
-	[6]	= "down sleep ecd",
-	[7]	= "down wakeup ecd",
-	[8]	= "down sleep epd",
-	[9]	= "down wakeup epd",
-	[10]	= "online",
-	[11]	= "operational",
-	[12]	= "scsi slave destroy",
-	[13]	= "propagate failed adapter",
-	[14]	= "propagate failed port",
-	[15]	= "block adapter",
-	[16]	= "unblock adapter",
-	[17]	= "block port",
-	[18]	= "unblock port",
-	[19]	= "block unit",
-	[20]	= "unblock unit",
-	[21]	= "unit recovery failed",
-	[22]	= "port recovery failed",
-	[23]	= "adapter recovery failed",
-	[24]	= "qdio queues down",
-	[25]	= "p2p failed",
-	[26]	= "nameserver lookup failed",
-	[27]	= "nameserver port failed",
-	[28]	= "link up",
-	[29]	= "link down",
-	[30]	= "link up status read",
-	[31]	= "open port failed",
-	[32]	= "",
-	[33]	= "close port",
-	[34]	= "open unit failed",
-	[35]	= "exclusive open unit failed",
-	[36]	= "shared open unit failed",
-	[37]	= "link down",
-	[38]	= "link down status read no link",
-	[39]	= "link down status read fdisc login",
-	[40]	= "link down status read firmware update",
-	[41]	= "link down status read unknown reason",
-	[42]	= "link down ecd incomplete",
-	[43]	= "link down epd incomplete",
-	[44]	= "sysfs adapter recovery",
-	[45]	= "sysfs port recovery",
-	[46]	= "sysfs unit recovery",
-	[47]	= "port boxed abort",
-	[48]	= "unit boxed abort",
-	[49]	= "port boxed ct",
-	[50]	= "port boxed close physical",
-	[51]	= "port boxed open unit",
-	[52]	= "port boxed close unit",
-	[53]	= "port boxed fcp",
-	[54]	= "unit boxed fcp",
-	[55]	= "port access denied",
-	[56]	= "",
-	[57]	= "",
-	[58]	= "",
-	[59]	= "unit access denied",
-	[60]	= "shared unit access denied open unit",
-	[61]	= "",
-	[62]	= "request timeout",
-	[63]	= "adisc link test reject or timeout",
-	[64]	= "adisc link test d_id changed",
-	[65]	= "adisc link test failed",
-	[66]	= "recovery out of memory",
-	[67]	= "adapter recovery repeated after state change",
-	[68]	= "port recovery repeated after state change",
-	[69]	= "unit recovery repeated after state change",
-	[70]	= "port recovery follow-up after successful adapter recovery",
-	[71]	= "adapter recovery escalation after failed adapter recovery",
-	[72]	= "port recovery follow-up after successful physical port "
-		  "recovery",
-	[73]	= "adapter recovery escalation after failed physical port "
-		  "recovery",
-	[74]	= "unit recovery follow-up after successful port recovery",
-	[75]	= "physical port recovery escalation after failed port "
-		  "recovery",
-	[76]	= "port recovery escalation after failed unit recovery",
-	[77]	= "",
-	[78]	= "duplicate request id",
-	[79]	= "link down",
-	[80]	= "exclusive read-only unit access unsupported",
-	[81]	= "shared read-write unit access unsupported",
-	[82]	= "incoming rscn",
-	[83]	= "incoming wwpn",
-	[84]	= "wka port handle not valid close port",
-	[85]	= "online",
-	[86]	= "offline",
-	[87]	= "ccw device gone",
-	[88]	= "ccw device no path",
-	[89]	= "ccw device operational",
-	[90]	= "ccw device shutdown",
-	[91]	= "sysfs port addition",
-	[92]	= "sysfs port removal",
-	[93]	= "sysfs adapter recovery",
-	[94]	= "sysfs unit addition",
-	[95]	= "sysfs unit removal",
-	[96]	= "sysfs port recovery",
-	[97]	= "sysfs unit recovery",
-	[98]	= "sequence number mismatch",
-	[99]	= "link up",
-	[100]	= "error state",
-	[101]	= "status read physical port closed",
-	[102]	= "link up status read",
-	[103]	= "too many failed status read buffers",
-	[104]	= "port handle not valid abort",
-	[105]	= "lun handle not valid abort",
-	[106]	= "port handle not valid ct",
-	[107]	= "port handle not valid close port",
-	[108]	= "port handle not valid close physical port",
-	[109]	= "port handle not valid open unit",
-	[110]	= "port handle not valid close unit",
-	[111]	= "lun handle not valid close unit",
-	[112]	= "port handle not valid fcp",
-	[113]	= "lun handle not valid fcp",
-	[114]	= "handle mismatch fcp",
-	[115]	= "lun not valid fcp",
-	[116]	= "qdio send failed",
-	[117]	= "version mismatch",
-	[118]	= "incompatible qtcb type",
-	[119]	= "unknown protocol status",
-	[120]	= "unknown fsf command",
-	[121]	= "no recommendation for status qualifier",
-	[122]	= "",
-	[123]	= "fc service class not supported",
-	[124]	= "",
-	[125]	= "need newer zfcp",
-	[126]	= "need newer microcode",
-	[127]	= "arbitrated loop not supported",
-	[128]	= "",
-	[129]	= "qtcb size mismatch",
-	[130]	= "unknown fsf status ecd",
-	[131]	= "fcp request too big",
-	[132]	= "",
-	[133]	= "data direction not valid fcp",
-	[134]	= "command length not valid fcp",
-	[135]	= "status read act update",
-	[136]	= "status read cfdc update",
-	[137]	= "hbaapi port open",
-	[138]	= "hbaapi unit open",
-	[139]	= "hbaapi unit shutdown",
-	[140]	= "qdio error outbound",
-	[141]	= "scsi host reset",
-	[142]	= "dismissing fsf request for recovery action",
-	[143]	= "recovery action timed out",
-	[144]	= "recovery action gone",
-	[145]	= "recovery action being processed",
-	[146]	= "recovery action ready for next step",
-	[147]	= "qdio error inbound",
-	[148]   = "nameserver needed for port scan",
-	[149]   = "port scan",
-	[150]	= "ptp attach",
-	[151]   = "port validation failed",
-};
-
 static int zfcp_rec_dbf_view_format(debug_info_t *id, struct debug_view *view,
 				    char *buf, const char *_rec)
 {
 	struct zfcp_rec_dbf_record *r = (struct zfcp_rec_dbf_record *)_rec;
 	char *p = buf;
+	char hint[ZFCP_DBF_ID_SIZE + 1];
 
+	memcpy(hint, r->id2, ZFCP_DBF_ID_SIZE);
+	hint[ZFCP_DBF_ID_SIZE] = 0;
 	zfcp_dbf_outs(&p, "tag", zfcp_rec_dbf_tags[r->id]);
-	zfcp_dbf_outs(&p, "hint", zfcp_rec_dbf_ids[r->id2]);
-	zfcp_dbf_out(&p, "id", "%d", r->id2);
+	zfcp_dbf_outs(&p, "hint", hint);
 	switch (r->id) {
 	case ZFCP_REC_DBF_ID_THREAD:
 		zfcp_dbf_out(&p, "total", "%d", r->u.thread.total);
@@ -707,7 +552,7 @@ static struct debug_view zfcp_rec_dbf_vi
  * @adapter: adapter
  * This function assumes that the caller is holding erp_lock.
  */
-void zfcp_rec_dbf_event_thread(u8 id2, struct zfcp_adapter *adapter)
+void zfcp_rec_dbf_event_thread(char *id2, struct zfcp_adapter *adapter)
 {
 	struct zfcp_rec_dbf_record *r = &adapter->rec_dbf_buf;
 	unsigned long flags = 0;
@@ -723,7 +568,7 @@ void zfcp_rec_dbf_event_thread(u8 id2, s
 	spin_lock_irqsave(&adapter->rec_dbf_lock, flags);
 	memset(r, 0, sizeof(*r));
 	r->id = ZFCP_REC_DBF_ID_THREAD;
-	r->id2 = id2;
+	memcpy(r->id2, id2, ZFCP_DBF_ID_SIZE);
 	r->u.thread.total = total;
 	r->u.thread.ready = ready;
 	r->u.thread.running = running;
@@ -737,7 +582,7 @@ void zfcp_rec_dbf_event_thread(u8 id2, s
  * @adapter: adapter
  * This function assumes that the caller does not hold erp_lock.
  */
-void zfcp_rec_dbf_event_thread_lock(u8 id2, struct zfcp_adapter *adapter)
+void zfcp_rec_dbf_event_thread_lock(char *id2, struct zfcp_adapter *adapter)
 {
 	unsigned long flags;
 
@@ -746,7 +591,7 @@ void zfcp_rec_dbf_event_thread_lock(u8 i
 	read_unlock_irqrestore(&adapter->erp_lock, flags);
 }
 
-static void zfcp_rec_dbf_event_target(u8 id2, void *ref,
+static void zfcp_rec_dbf_event_target(char *id2, void *ref,
 				      struct zfcp_adapter *adapter,
 				      atomic_t *status, atomic_t *erp_count,
 				      u64 wwpn, u32 d_id, u64 fcp_lun)
@@ -757,7 +602,7 @@ static void zfcp_rec_dbf_event_target(u8
 	spin_lock_irqsave(&adapter->rec_dbf_lock, flags);
 	memset(r, 0, sizeof(*r));
 	r->id = ZFCP_REC_DBF_ID_TARGET;
-	r->id2 = id2;
+	memcpy(r->id2, id2, ZFCP_DBF_ID_SIZE);
 	r->u.target.ref = (unsigned long)ref;
 	r->u.target.status = atomic_read(status);
 	r->u.target.wwpn = wwpn;
@@ -774,7 +619,8 @@ static void zfcp_rec_dbf_event_target(u8
  * @ref: additional reference (e.g. request)
  * @adapter: adapter
  */
-void zfcp_rec_dbf_event_adapter(u8 id, void *ref, struct zfcp_adapter *adapter)
+void zfcp_rec_dbf_event_adapter(char *id, void *ref,
+				struct zfcp_adapter *adapter)
 {
 	zfcp_rec_dbf_event_target(id, ref, adapter, &adapter->status,
 				  &adapter->erp_counter, 0, 0, 0);
@@ -786,7 +632,7 @@ void zfcp_rec_dbf_event_adapter(u8 id, v
  * @ref: additional reference (e.g. request)
  * @port: port
  */
-void zfcp_rec_dbf_event_port(u8 id, void *ref, struct zfcp_port *port)
+void zfcp_rec_dbf_event_port(char *id, void *ref, struct zfcp_port *port)
 {
 	struct zfcp_adapter *adapter = port->adapter;
 
@@ -801,7 +647,7 @@ void zfcp_rec_dbf_event_port(u8 id, void
  * @ref: additional reference (e.g. request)
  * @unit: unit
  */
-void zfcp_rec_dbf_event_unit(u8 id, void *ref, struct zfcp_unit *unit)
+void zfcp_rec_dbf_event_unit(char *id, void *ref, struct zfcp_unit *unit)
 {
 	struct zfcp_port *port = unit->port;
 	struct zfcp_adapter *adapter = port->adapter;
@@ -822,7 +668,7 @@ void zfcp_rec_dbf_event_unit(u8 id, void
  * @port: port
  * @unit: unit
  */
-void zfcp_rec_dbf_event_trigger(u8 id2, void *ref, u8 want, u8 need,
+void zfcp_rec_dbf_event_trigger(char *id2, void *ref, u8 want, u8 need,
 				void *action, struct zfcp_adapter *adapter,
 				struct zfcp_port *port, struct zfcp_unit *unit)
 {
@@ -832,7 +678,7 @@ void zfcp_rec_dbf_event_trigger(u8 id2, 
 	spin_lock_irqsave(&adapter->rec_dbf_lock, flags);
 	memset(r, 0, sizeof(*r));
 	r->id = ZFCP_REC_DBF_ID_TRIGGER;
-	r->id2 = id2;
+	memcpy(r->id2, id2, ZFCP_DBF_ID_SIZE);
 	r->u.trigger.ref = (unsigned long)ref;
 	r->u.trigger.want = want;
 	r->u.trigger.need = need;
@@ -855,7 +701,7 @@ void zfcp_rec_dbf_event_trigger(u8 id2, 
  * @id2: identifier
  * @erp_action: error recovery action struct pointer
  */
-void zfcp_rec_dbf_event_action(u8 id2, struct zfcp_erp_action *erp_action)
+void zfcp_rec_dbf_event_action(char *id2, struct zfcp_erp_action *erp_action)
 {
 	struct zfcp_adapter *adapter = erp_action->adapter;
 	struct zfcp_rec_dbf_record *r = &adapter->rec_dbf_buf;
@@ -864,7 +710,7 @@ void zfcp_rec_dbf_event_action(u8 id2, s
 	spin_lock_irqsave(&adapter->rec_dbf_lock, flags);
 	memset(r, 0, sizeof(*r));
 	r->id = ZFCP_REC_DBF_ID_ACTION;
-	r->id2 = id2;
+	memcpy(r->id2, id2, ZFCP_DBF_ID_SIZE);
 	r->u.action.action = (unsigned long)erp_action;
 	r->u.action.status = erp_action->status;
 	r->u.action.step = erp_action->step;
--- a/drivers/s390/scsi/zfcp_dbf.h	2009-03-02 12:41:57.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.h	2009-03-02 12:42:38.000000000 +0100
@@ -25,6 +25,7 @@
 #include "zfcp_fsf.h"
 
 #define ZFCP_DBF_TAG_SIZE      4
+#define ZFCP_DBF_ID_SIZE       7
 
 struct zfcp_dbf_dump {
 	u8 tag[ZFCP_DBF_TAG_SIZE];
@@ -70,7 +71,7 @@ struct zfcp_rec_dbf_record_action {
 
 struct zfcp_rec_dbf_record {
 	u8 id;
-	u8 id2;
+	char id2[7];
 	union {
 		struct zfcp_rec_dbf_record_action action;
 		struct zfcp_rec_dbf_record_thread thread;
--- a/drivers/s390/scsi/zfcp_erp.c	2009-03-02 12:42:37.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2009-03-02 12:42:38.000000000 +0100
@@ -55,7 +55,7 @@ enum zfcp_erp_act_result {
 
 static void zfcp_erp_adapter_block(struct zfcp_adapter *adapter, int mask)
 {
-	zfcp_erp_modify_adapter_status(adapter, 15, NULL,
+	zfcp_erp_modify_adapter_status(adapter, "erablk1", NULL,
 				       ZFCP_STATUS_COMMON_UNBLOCKED | mask,
 				       ZFCP_CLEAR);
 }
@@ -75,9 +75,9 @@ static void zfcp_erp_action_ready(struct
 	struct zfcp_adapter *adapter = act->adapter;
 
 	list_move(&act->list, &act->adapter->erp_ready_head);
-	zfcp_rec_dbf_event_action(146, act);
+	zfcp_rec_dbf_event_action("erardy1", act);
 	up(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread(2, adapter);
+	zfcp_rec_dbf_event_thread("erardy2", adapter);
 }
 
 static void zfcp_erp_action_dismiss(struct zfcp_erp_action *act)
@@ -208,7 +208,7 @@ static struct zfcp_erp_action *zfcp_erp_
 
 static int zfcp_erp_action_enqueue(int want, struct zfcp_adapter *adapter,
 				   struct zfcp_port *port,
-				   struct zfcp_unit *unit, u8 id, void *ref)
+				   struct zfcp_unit *unit, char *id, void *ref)
 {
 	int retval = 1, need;
 	struct zfcp_erp_action *act = NULL;
@@ -228,7 +228,7 @@ static int zfcp_erp_action_enqueue(int w
 	++adapter->erp_total_count;
 	list_add_tail(&act->list, &adapter->erp_ready_head);
 	up(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread(1, adapter);
+	zfcp_rec_dbf_event_thread("eracte1", adapter);
 	retval = 0;
  out:
 	zfcp_rec_dbf_event_trigger(id, ref, want, need, act,
@@ -237,13 +237,13 @@ static int zfcp_erp_action_enqueue(int w
 }
 
 static int _zfcp_erp_adapter_reopen(struct zfcp_adapter *adapter,
-				    int clear_mask, u8 id, void *ref)
+				    int clear_mask, char *id, void *ref)
 {
 	zfcp_erp_adapter_block(adapter, clear_mask);
 
 	/* ensure propagation of failed status to new devices */
 	if (atomic_read(&adapter->status) & ZFCP_STATUS_COMMON_ERP_FAILED) {
-		zfcp_erp_adapter_failed(adapter, 13, NULL);
+		zfcp_erp_adapter_failed(adapter, "erareo1", NULL);
 		return -EIO;
 	}
 	return zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_ADAPTER,
@@ -258,7 +258,7 @@ static int _zfcp_erp_adapter_reopen(stru
  * @ref: Reference for debug trace event.
  */
 void zfcp_erp_adapter_reopen(struct zfcp_adapter *adapter, int clear,
-			     u8 id, void *ref)
+			     char *id, void *ref)
 {
 	unsigned long flags;
 
@@ -277,7 +277,7 @@ void zfcp_erp_adapter_reopen(struct zfcp
  * @ref: Reference for debug trace event.
  */
 void zfcp_erp_adapter_shutdown(struct zfcp_adapter *adapter, int clear,
-			       u8 id, void *ref)
+			       char *id, void *ref)
 {
 	int flags = ZFCP_STATUS_COMMON_RUNNING | ZFCP_STATUS_COMMON_ERP_FAILED;
 	zfcp_erp_adapter_reopen(adapter, clear | flags, id, ref);
@@ -290,7 +290,8 @@ void zfcp_erp_adapter_shutdown(struct zf
  * @id: Id for debug trace event.
  * @ref: Reference for debug trace event.
  */
-void zfcp_erp_port_shutdown(struct zfcp_port *port, int clear, u8 id, void *ref)
+void zfcp_erp_port_shutdown(struct zfcp_port *port, int clear, char *id,
+			    void *ref)
 {
 	int flags = ZFCP_STATUS_COMMON_RUNNING | ZFCP_STATUS_COMMON_ERP_FAILED;
 	zfcp_erp_port_reopen(port, clear | flags, id, ref);
@@ -303,7 +304,8 @@ void zfcp_erp_port_shutdown(struct zfcp_
  * @id: Id for debug trace event.
  * @ref: Reference for debug trace event.
  */
-void zfcp_erp_unit_shutdown(struct zfcp_unit *unit, int clear, u8 id, void *ref)
+void zfcp_erp_unit_shutdown(struct zfcp_unit *unit, int clear, char *id,
+			    void *ref)
 {
 	int flags = ZFCP_STATUS_COMMON_RUNNING | ZFCP_STATUS_COMMON_ERP_FAILED;
 	zfcp_erp_unit_reopen(unit, clear | flags, id, ref);
@@ -311,13 +313,13 @@ void zfcp_erp_unit_shutdown(struct zfcp_
 
 static void zfcp_erp_port_block(struct zfcp_port *port, int clear)
 {
-	zfcp_erp_modify_port_status(port, 17, NULL,
+	zfcp_erp_modify_port_status(port, "erpblk1", NULL,
 				    ZFCP_STATUS_COMMON_UNBLOCKED | clear,
 				    ZFCP_CLEAR);
 }
 
 static void _zfcp_erp_port_forced_reopen(struct zfcp_port *port,
-					 int clear, u8 id, void *ref)
+					 int clear, char *id, void *ref)
 {
 	zfcp_erp_port_block(port, clear);
 
@@ -334,7 +336,7 @@ static void _zfcp_erp_port_forced_reopen
  * @id: Id for debug trace event.
  * @ref: Reference for debug trace event.
  */
-void zfcp_erp_port_forced_reopen(struct zfcp_port *port, int clear, u8 id,
+void zfcp_erp_port_forced_reopen(struct zfcp_port *port, int clear, char *id,
 				 void *ref)
 {
 	unsigned long flags;
@@ -347,14 +349,14 @@ void zfcp_erp_port_forced_reopen(struct 
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
 
-static int _zfcp_erp_port_reopen(struct zfcp_port *port, int clear, u8 id,
+static int _zfcp_erp_port_reopen(struct zfcp_port *port, int clear, char *id,
 				 void *ref)
 {
 	zfcp_erp_port_block(port, clear);
 
 	if (atomic_read(&port->status) & ZFCP_STATUS_COMMON_ERP_FAILED) {
 		/* ensure propagation of failed status to new devices */
-		zfcp_erp_port_failed(port, 14, NULL);
+		zfcp_erp_port_failed(port, "erpreo1", NULL);
 		return -EIO;
 	}
 
@@ -369,7 +371,7 @@ static int _zfcp_erp_port_reopen(struct 
  *
  * Returns 0 if recovery has been triggered, < 0 if not.
  */
-int zfcp_erp_port_reopen(struct zfcp_port *port, int clear, u8 id, void *ref)
+int zfcp_erp_port_reopen(struct zfcp_port *port, int clear, char *id, void *ref)
 {
 	unsigned long flags;
 	int retval;
@@ -386,12 +388,12 @@ int zfcp_erp_port_reopen(struct zfcp_por
 
 static void zfcp_erp_unit_block(struct zfcp_unit *unit, int clear_mask)
 {
-	zfcp_erp_modify_unit_status(unit, 19, NULL,
+	zfcp_erp_modify_unit_status(unit, "erublk1", NULL,
 				    ZFCP_STATUS_COMMON_UNBLOCKED | clear_mask,
 				    ZFCP_CLEAR);
 }
 
-static void _zfcp_erp_unit_reopen(struct zfcp_unit *unit, int clear, u8 id,
+static void _zfcp_erp_unit_reopen(struct zfcp_unit *unit, int clear, char *id,
 				  void *ref)
 {
 	struct zfcp_adapter *adapter = unit->port->adapter;
@@ -411,7 +413,8 @@ static void _zfcp_erp_unit_reopen(struct
  * @clear_mask: specifies flags in unit status to be cleared
  * Return: 0 on success, < 0 on error
  */
-void zfcp_erp_unit_reopen(struct zfcp_unit *unit, int clear, u8 id, void *ref)
+void zfcp_erp_unit_reopen(struct zfcp_unit *unit, int clear, char *id,
+			  void *ref)
 {
 	unsigned long flags;
 	struct zfcp_port *port = unit->port;
@@ -437,28 +440,28 @@ static int status_change_clear(unsigned 
 static void zfcp_erp_adapter_unblock(struct zfcp_adapter *adapter)
 {
 	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status))
-		zfcp_rec_dbf_event_adapter(16, NULL, adapter);
+		zfcp_rec_dbf_event_adapter("eraubl1", NULL, adapter);
 	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status);
 }
 
 static void zfcp_erp_port_unblock(struct zfcp_port *port)
 {
 	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &port->status))
-		zfcp_rec_dbf_event_port(18, NULL, port);
+		zfcp_rec_dbf_event_port("erpubl1", NULL, port);
 	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &port->status);
 }
 
 static void zfcp_erp_unit_unblock(struct zfcp_unit *unit)
 {
 	if (status_change_set(ZFCP_STATUS_COMMON_UNBLOCKED, &unit->status))
-		zfcp_rec_dbf_event_unit(20, NULL, unit);
+		zfcp_rec_dbf_event_unit("eruubl1", NULL, unit);
 	atomic_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED, &unit->status);
 }
 
 static void zfcp_erp_action_to_running(struct zfcp_erp_action *erp_action)
 {
 	list_move(&erp_action->list, &erp_action->adapter->erp_running_head);
-	zfcp_rec_dbf_event_action(145, erp_action);
+	zfcp_rec_dbf_event_action("erator1", erp_action);
 }
 
 static void zfcp_erp_strategy_check_fsfreq(struct zfcp_erp_action *act)
@@ -474,11 +477,11 @@ static void zfcp_erp_strategy_check_fsfr
 		if (act->status & (ZFCP_STATUS_ERP_DISMISSED |
 				   ZFCP_STATUS_ERP_TIMEDOUT)) {
 			act->fsf_req->status |= ZFCP_STATUS_FSFREQ_DISMISSED;
-			zfcp_rec_dbf_event_action(142, act);
+			zfcp_rec_dbf_event_action("erscf_1", act);
 			act->fsf_req->erp_action = NULL;
 		}
 		if (act->status & ZFCP_STATUS_ERP_TIMEDOUT)
-			zfcp_rec_dbf_event_action(143, act);
+			zfcp_rec_dbf_event_action("erscf_2", act);
 		if (act->fsf_req->status & (ZFCP_STATUS_FSFREQ_COMPLETED |
 					    ZFCP_STATUS_FSFREQ_DISMISSED))
 			act->fsf_req = NULL;
@@ -530,7 +533,7 @@ static void zfcp_erp_strategy_memwait(st
 }
 
 static void _zfcp_erp_port_reopen_all(struct zfcp_adapter *adapter,
-				      int clear, u8 id, void *ref)
+				      int clear, char *id, void *ref)
 {
 	struct zfcp_port *port;
 
@@ -538,8 +541,8 @@ static void _zfcp_erp_port_reopen_all(st
 		_zfcp_erp_port_reopen(port, clear, id, ref);
 }
 
-static void _zfcp_erp_unit_reopen_all(struct zfcp_port *port, int clear, u8 id,
-				      void *ref)
+static void _zfcp_erp_unit_reopen_all(struct zfcp_port *port, int clear,
+				      char *id, void *ref)
 {
 	struct zfcp_unit *unit;
 
@@ -559,28 +562,28 @@ static void zfcp_erp_strategy_followup_a
 
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
 		if (status == ZFCP_ERP_SUCCEEDED)
-			_zfcp_erp_port_reopen_all(adapter, 0, 70, NULL);
+			_zfcp_erp_port_reopen_all(adapter, 0, "ersfa_1", NULL);
 		else
-			_zfcp_erp_adapter_reopen(adapter, 0, 71, NULL);
+			_zfcp_erp_adapter_reopen(adapter, 0, "ersfa_2", NULL);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
 		if (status == ZFCP_ERP_SUCCEEDED)
-			_zfcp_erp_port_reopen(port, 0, 72, NULL);
+			_zfcp_erp_port_reopen(port, 0, "ersfa_3", NULL);
 		else
-			_zfcp_erp_adapter_reopen(adapter, 0, 73, NULL);
+			_zfcp_erp_adapter_reopen(adapter, 0, "ersfa_4", NULL);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
 		if (status == ZFCP_ERP_SUCCEEDED)
-			_zfcp_erp_unit_reopen_all(port, 0, 74, NULL);
+			_zfcp_erp_unit_reopen_all(port, 0, "ersfa_5", NULL);
 		else
-			_zfcp_erp_port_forced_reopen(port, 0, 75, NULL);
+			_zfcp_erp_port_forced_reopen(port, 0, "ersfa_6", NULL);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
 		if (status != ZFCP_ERP_SUCCEEDED)
-			_zfcp_erp_port_reopen(unit->port, 0, 76, NULL);
+			_zfcp_erp_port_reopen(unit->port, 0, "ersfa_7", NULL);
 		break;
 	}
 }
@@ -617,7 +620,7 @@ static void zfcp_erp_enqueue_ptp_port(st
 				 adapter->peer_d_id);
 	if (IS_ERR(port)) /* error or port already attached */
 		return;
-	_zfcp_erp_port_reopen(port, 0, 150, NULL);
+	_zfcp_erp_port_reopen(port, 0, "ereptp1", NULL);
 }
 
 static int zfcp_erp_adapter_strat_fsf_xconf(struct zfcp_erp_action *erp_action)
@@ -640,9 +643,9 @@ static int zfcp_erp_adapter_strat_fsf_xc
 			return ZFCP_ERP_FAILED;
 		}
 
-		zfcp_rec_dbf_event_thread_lock(6, adapter);
+		zfcp_rec_dbf_event_thread_lock("erasfx1", adapter);
 		down(&adapter->erp_ready_sem);
-		zfcp_rec_dbf_event_thread_lock(7, adapter);
+		zfcp_rec_dbf_event_thread_lock("erasfx2", adapter);
 		if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT)
 			break;
 
@@ -681,9 +684,9 @@ static int zfcp_erp_adapter_strategy_ope
 	if (ret)
 		return ZFCP_ERP_FAILED;
 
-	zfcp_rec_dbf_event_thread_lock(8, adapter);
+	zfcp_rec_dbf_event_thread_lock("erasox1", adapter);
 	down(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread_lock(9, adapter);
+	zfcp_rec_dbf_event_thread_lock("erasox2", adapter);
 	if (act->status & ZFCP_STATUS_ERP_TIMEDOUT)
 		return ZFCP_ERP_FAILED;
 
@@ -714,7 +717,7 @@ static void zfcp_erp_adapter_strategy_cl
 	zfcp_fsf_req_dismiss_all(adapter);
 	adapter->fsf_req_seq_no = 0;
 	/* all ports and units are closed */
-	zfcp_erp_modify_adapter_status(adapter, 24, NULL,
+	zfcp_erp_modify_adapter_status(adapter, "erascl1", NULL,
 				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
 
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK |
@@ -832,7 +835,7 @@ static int zfcp_erp_open_ptp_port(struct
 	struct zfcp_port *port = act->port;
 
 	if (port->wwpn != adapter->peer_wwpn) {
-		zfcp_erp_port_failed(port, 25, NULL);
+		zfcp_erp_port_failed(port, "eroptp1", NULL);
 		return ZFCP_ERP_FAILED;
 	}
 	port->d_id = adapter->peer_d_id;
@@ -986,7 +989,7 @@ static int zfcp_erp_strategy_check_unit(
 				"port 0x%016Lx\n",
 				(unsigned long long)unit->fcp_lun,
 				(unsigned long long)unit->port->wwpn);
-			zfcp_erp_unit_failed(unit, 21, NULL);
+			zfcp_erp_unit_failed(unit, "erusck1", NULL);
 		}
 		break;
 	}
@@ -1016,7 +1019,7 @@ static int zfcp_erp_strategy_check_port(
 			dev_err(&port->adapter->ccw_device->dev,
 				"ERP failed for remote port 0x%016Lx\n",
 				(unsigned long long)port->wwpn);
-			zfcp_erp_port_failed(port, 22, NULL);
+			zfcp_erp_port_failed(port, "erpsck1", NULL);
 		}
 		break;
 	}
@@ -1043,7 +1046,7 @@ static int zfcp_erp_strategy_check_adapt
 			dev_err(&adapter->ccw_device->dev,
 				"ERP cannot recover an error "
 				"on the FCP device\n");
-			zfcp_erp_adapter_failed(adapter, 23, NULL);
+			zfcp_erp_adapter_failed(adapter, "erasck1", NULL);
 		}
 		break;
 	}
@@ -1108,7 +1111,7 @@ static int zfcp_erp_strategy_statechange
 		if (zfcp_erp_strat_change_det(&adapter->status, erp_status)) {
 			_zfcp_erp_adapter_reopen(adapter,
 						 ZFCP_STATUS_COMMON_ERP_FAILED,
-						 67, NULL);
+						 "ersscg1", NULL);
 			return ZFCP_ERP_EXIT;
 		}
 		break;
@@ -1118,7 +1121,7 @@ static int zfcp_erp_strategy_statechange
 		if (zfcp_erp_strat_change_det(&port->status, erp_status)) {
 			_zfcp_erp_port_reopen(port,
 					      ZFCP_STATUS_COMMON_ERP_FAILED,
-					      68, NULL);
+					      "ersscg2", NULL);
 			return ZFCP_ERP_EXIT;
 		}
 		break;
@@ -1127,7 +1130,7 @@ static int zfcp_erp_strategy_statechange
 		if (zfcp_erp_strat_change_det(&unit->status, erp_status)) {
 			_zfcp_erp_unit_reopen(unit,
 					      ZFCP_STATUS_COMMON_ERP_FAILED,
-					      69, NULL);
+					      "ersscg3", NULL);
 			return ZFCP_ERP_EXIT;
 		}
 		break;
@@ -1146,7 +1149,7 @@ static void zfcp_erp_action_dequeue(stru
 	}
 
 	list_del(&erp_action->list);
-	zfcp_rec_dbf_event_action(144, erp_action);
+	zfcp_rec_dbf_event_action("eractd1", erp_action);
 
 	switch (erp_action->action) {
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
@@ -1331,7 +1334,7 @@ static int zfcp_erp_strategy(struct zfcp
 			erp_action->status |= ZFCP_STATUS_ERP_LOWMEM;
 		}
 		if (adapter->erp_total_count == adapter->erp_low_mem_count)
-			_zfcp_erp_adapter_reopen(adapter, 0, 66, NULL);
+			_zfcp_erp_adapter_reopen(adapter, 0, "erstgy1", NULL);
 		else {
 			zfcp_erp_strategy_memwait(erp_action);
 			retval = ZFCP_ERP_CONTINUES;
@@ -1391,9 +1394,9 @@ static int zfcp_erp_thread(void *data)
 				zfcp_erp_wakeup(adapter);
 		}
 
-		zfcp_rec_dbf_event_thread_lock(4, adapter);
+		zfcp_rec_dbf_event_thread_lock("erthrd1", adapter);
 		ignore = down_interruptible(&adapter->erp_ready_sem);
-		zfcp_rec_dbf_event_thread_lock(5, adapter);
+		zfcp_rec_dbf_event_thread_lock("erthrd2", adapter);
 	}
 
 	atomic_clear_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_UP, &adapter->status);
@@ -1438,7 +1441,7 @@ void zfcp_erp_thread_kill(struct zfcp_ad
 {
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_THREAD_KILL, &adapter->status);
 	up(&adapter->erp_ready_sem);
-	zfcp_rec_dbf_event_thread_lock(3, adapter);
+	zfcp_rec_dbf_event_thread_lock("erthrk1", adapter);
 
 	wait_event(adapter->erp_thread_wqh,
 		   !(atomic_read(&adapter->status) &
@@ -1454,7 +1457,7 @@ void zfcp_erp_thread_kill(struct zfcp_ad
  * @id: Event id for debug trace.
  * @ref: Reference for debug trace.
  */
-void zfcp_erp_adapter_failed(struct zfcp_adapter *adapter, u8 id, void *ref)
+void zfcp_erp_adapter_failed(struct zfcp_adapter *adapter, char *id, void *ref)
 {
 	zfcp_erp_modify_adapter_status(adapter, id, ref,
 				       ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
@@ -1466,7 +1469,7 @@ void zfcp_erp_adapter_failed(struct zfcp
  * @id: Event id for debug trace.
  * @ref: Reference for debug trace.
  */
-void zfcp_erp_port_failed(struct zfcp_port *port, u8 id, void *ref)
+void zfcp_erp_port_failed(struct zfcp_port *port, char *id, void *ref)
 {
 	zfcp_erp_modify_port_status(port, id, ref,
 				    ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
@@ -1478,7 +1481,7 @@ void zfcp_erp_port_failed(struct zfcp_po
  * @id: Event id for debug trace.
  * @ref: Reference for debug trace.
  */
-void zfcp_erp_unit_failed(struct zfcp_unit *unit, u8 id, void *ref)
+void zfcp_erp_unit_failed(struct zfcp_unit *unit, char *id, void *ref)
 {
 	zfcp_erp_modify_unit_status(unit, id, ref,
 				    ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
@@ -1505,7 +1508,7 @@ void zfcp_erp_wait(struct zfcp_adapter *
  *
  * Changes in common status bits are propagated to attached ports and units.
  */
-void zfcp_erp_modify_adapter_status(struct zfcp_adapter *adapter, u8 id,
+void zfcp_erp_modify_adapter_status(struct zfcp_adapter *adapter, char *id,
 				    void *ref, u32 mask, int set_or_clear)
 {
 	struct zfcp_port *port;
@@ -1539,7 +1542,7 @@ void zfcp_erp_modify_adapter_status(stru
  *
  * Changes in common status bits are propagated to attached units.
  */
-void zfcp_erp_modify_port_status(struct zfcp_port *port, u8 id, void *ref,
+void zfcp_erp_modify_port_status(struct zfcp_port *port, char *id, void *ref,
 				 u32 mask, int set_or_clear)
 {
 	struct zfcp_unit *unit;
@@ -1571,7 +1574,7 @@ void zfcp_erp_modify_port_status(struct 
  * @mask: status bits to change
  * @set_or_clear: ZFCP_SET or ZFCP_CLEAR
  */
-void zfcp_erp_modify_unit_status(struct zfcp_unit *unit, u8 id, void *ref,
+void zfcp_erp_modify_unit_status(struct zfcp_unit *unit, char *id, void *ref,
 				 u32 mask, int set_or_clear)
 {
 	if (set_or_clear == ZFCP_SET) {
@@ -1594,7 +1597,7 @@ void zfcp_erp_modify_unit_status(struct 
  * @id: The debug trace id.
  * @id: Reference for the debug trace.
  */
-void zfcp_erp_port_boxed(struct zfcp_port *port, u8 id, void *ref)
+void zfcp_erp_port_boxed(struct zfcp_port *port, char *id, void *ref)
 {
 	unsigned long flags;
 
@@ -1611,7 +1614,7 @@ void zfcp_erp_port_boxed(struct zfcp_por
  * @id: The debug trace id.
  * @id: Reference for the debug trace.
  */
-void zfcp_erp_unit_boxed(struct zfcp_unit *unit, u8 id, void *ref)
+void zfcp_erp_unit_boxed(struct zfcp_unit *unit, char *id, void *ref)
 {
 	zfcp_erp_modify_unit_status(unit, id, ref,
 				    ZFCP_STATUS_COMMON_ACCESS_BOXED, ZFCP_SET);
@@ -1627,7 +1630,7 @@ void zfcp_erp_unit_boxed(struct zfcp_uni
  * Since the adapter has denied access, stop using the port and the
  * attached units.
  */
-void zfcp_erp_port_access_denied(struct zfcp_port *port, u8 id, void *ref)
+void zfcp_erp_port_access_denied(struct zfcp_port *port, char *id, void *ref)
 {
 	unsigned long flags;
 
@@ -1646,14 +1649,14 @@ void zfcp_erp_port_access_denied(struct 
  *
  * Since the adapter has denied access, stop using the unit.
  */
-void zfcp_erp_unit_access_denied(struct zfcp_unit *unit, u8 id, void *ref)
+void zfcp_erp_unit_access_denied(struct zfcp_unit *unit, char *id, void *ref)
 {
 	zfcp_erp_modify_unit_status(unit, id, ref,
 				    ZFCP_STATUS_COMMON_ERP_FAILED |
 				    ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
 }
 
-static void zfcp_erp_unit_access_changed(struct zfcp_unit *unit, u8 id,
+static void zfcp_erp_unit_access_changed(struct zfcp_unit *unit, char *id,
 					 void *ref)
 {
 	int status = atomic_read(&unit->status);
@@ -1664,7 +1667,7 @@ static void zfcp_erp_unit_access_changed
 	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
 }
 
-static void zfcp_erp_port_access_changed(struct zfcp_port *port, u8 id,
+static void zfcp_erp_port_access_changed(struct zfcp_port *port, char *id,
 					 void *ref)
 {
 	struct zfcp_unit *unit;
@@ -1686,7 +1689,7 @@ static void zfcp_erp_port_access_changed
  * @id: Id for debug trace
  * @ref: Reference for debug trace
  */
-void zfcp_erp_adapter_access_changed(struct zfcp_adapter *adapter, u8 id,
+void zfcp_erp_adapter_access_changed(struct zfcp_adapter *adapter, char *id,
 				     void *ref)
 {
 	struct zfcp_port *port;
--- a/drivers/s390/scsi/zfcp_ext.h	2009-03-02 12:42:33.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ext.h	2009-03-02 12:42:38.000000000 +0100
@@ -35,15 +35,15 @@ extern struct miscdevice zfcp_cfdc_misc;
 /* zfcp_dbf.c */
 extern int zfcp_adapter_debug_register(struct zfcp_adapter *);
 extern void zfcp_adapter_debug_unregister(struct zfcp_adapter *);
-extern void zfcp_rec_dbf_event_thread(u8, struct zfcp_adapter *);
-extern void zfcp_rec_dbf_event_thread_lock(u8, struct zfcp_adapter *);
-extern void zfcp_rec_dbf_event_adapter(u8, void *, struct zfcp_adapter *);
-extern void zfcp_rec_dbf_event_port(u8, void *, struct zfcp_port *);
-extern void zfcp_rec_dbf_event_unit(u8, void *, struct zfcp_unit *);
-extern void zfcp_rec_dbf_event_trigger(u8, void *, u8, u8, void *,
+extern void zfcp_rec_dbf_event_thread(char *, struct zfcp_adapter *);
+extern void zfcp_rec_dbf_event_thread_lock(char *, struct zfcp_adapter *);
+extern void zfcp_rec_dbf_event_adapter(char *, void *, struct zfcp_adapter *);
+extern void zfcp_rec_dbf_event_port(char *, void *, struct zfcp_port *);
+extern void zfcp_rec_dbf_event_unit(char *, void *, struct zfcp_unit *);
+extern void zfcp_rec_dbf_event_trigger(char *, void *, u8, u8, void *,
 				       struct zfcp_adapter *,
 				       struct zfcp_port *, struct zfcp_unit *);
-extern void zfcp_rec_dbf_event_action(u8, struct zfcp_erp_action *);
+extern void zfcp_rec_dbf_event_action(char *, struct zfcp_erp_action *);
 extern void zfcp_hba_dbf_event_fsf_response(struct zfcp_fsf_req *);
 extern void zfcp_hba_dbf_event_fsf_unsol(const char *, struct zfcp_adapter *,
 					 struct fsf_status_read_buffer *);
@@ -66,31 +66,34 @@ extern void zfcp_scsi_dbf_event_devreset
 					 struct scsi_cmnd *);
 
 /* zfcp_erp.c */
-extern void zfcp_erp_modify_adapter_status(struct zfcp_adapter *, u8, void *,
-					   u32, int);
-extern void zfcp_erp_adapter_reopen(struct zfcp_adapter *, int, u8, void *);
-extern void zfcp_erp_adapter_shutdown(struct zfcp_adapter *, int, u8, void *);
-extern void zfcp_erp_adapter_failed(struct zfcp_adapter *, u8, void *);
-extern void zfcp_erp_modify_port_status(struct zfcp_port *, u8, void *, u32,
+extern void zfcp_erp_modify_adapter_status(struct zfcp_adapter *, char *,
+					   void *, u32, int);
+extern void zfcp_erp_adapter_reopen(struct zfcp_adapter *, int, char *, void *);
+extern void zfcp_erp_adapter_shutdown(struct zfcp_adapter *, int, char *,
+				      void *);
+extern void zfcp_erp_adapter_failed(struct zfcp_adapter *, char *, void *);
+extern void zfcp_erp_modify_port_status(struct zfcp_port *, char *, void *, u32,
 					int);
-extern int  zfcp_erp_port_reopen(struct zfcp_port *, int, u8, void *);
-extern void zfcp_erp_port_shutdown(struct zfcp_port *, int, u8, void *);
-extern void zfcp_erp_port_forced_reopen(struct zfcp_port *, int, u8, void *);
-extern void zfcp_erp_port_failed(struct zfcp_port *, u8, void *);
-extern void zfcp_erp_modify_unit_status(struct zfcp_unit *, u8, void *, u32,
+extern int  zfcp_erp_port_reopen(struct zfcp_port *, int, char *, void *);
+extern void zfcp_erp_port_shutdown(struct zfcp_port *, int, char *, void *);
+extern void zfcp_erp_port_forced_reopen(struct zfcp_port *, int, char *,
+					void *);
+extern void zfcp_erp_port_failed(struct zfcp_port *, char *, void *);
+extern void zfcp_erp_modify_unit_status(struct zfcp_unit *, char *, void *, u32,
 					int);
-extern void zfcp_erp_unit_reopen(struct zfcp_unit *, int, u8, void *);
-extern void zfcp_erp_unit_shutdown(struct zfcp_unit *, int, u8, void *);
-extern void zfcp_erp_unit_failed(struct zfcp_unit *, u8, void *);
+extern void zfcp_erp_unit_reopen(struct zfcp_unit *, int, char *, void *);
+extern void zfcp_erp_unit_shutdown(struct zfcp_unit *, int, char *, void *);
+extern void zfcp_erp_unit_failed(struct zfcp_unit *, char *, void *);
 extern int  zfcp_erp_thread_setup(struct zfcp_adapter *);
 extern void zfcp_erp_thread_kill(struct zfcp_adapter *);
 extern void zfcp_erp_wait(struct zfcp_adapter *);
 extern void zfcp_erp_notify(struct zfcp_erp_action *, unsigned long);
-extern void zfcp_erp_port_boxed(struct zfcp_port *, u8, void *);
-extern void zfcp_erp_unit_boxed(struct zfcp_unit *, u8, void *);
-extern void zfcp_erp_port_access_denied(struct zfcp_port *, u8, void *);
-extern void zfcp_erp_unit_access_denied(struct zfcp_unit *, u8, void *);
-extern void zfcp_erp_adapter_access_changed(struct zfcp_adapter *, u8, void *);
+extern void zfcp_erp_port_boxed(struct zfcp_port *, char *, void *);
+extern void zfcp_erp_unit_boxed(struct zfcp_unit *, char *, void *);
+extern void zfcp_erp_port_access_denied(struct zfcp_port *, char *, void *);
+extern void zfcp_erp_unit_access_denied(struct zfcp_unit *, char *, void *);
+extern void zfcp_erp_adapter_access_changed(struct zfcp_adapter *, char *,
+					    void *);
 extern void zfcp_erp_timeout_handler(unsigned long);
 extern void zfcp_erp_port_strategy_open_lookup(struct work_struct *);
 
--- a/drivers/s390/scsi/zfcp_fc.c	2009-03-02 12:42:33.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-03-02 12:42:38.000000000 +0100
@@ -150,7 +150,7 @@ static void _zfcp_fc_incoming_rscn(struc
 			/* Try to connect to unused ports anyway. */
 			zfcp_erp_port_reopen(port,
 					     ZFCP_STATUS_COMMON_ERP_FAILED,
-					     82, fsf_req);
+					     "fcirsc1", fsf_req);
 		else if ((port->d_id & range) == (elem->nport_did & range))
 			/* Check connection status for connected ports */
 			zfcp_test_link(port);
@@ -196,7 +196,7 @@ static void zfcp_fc_incoming_wwpn(struct
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 
 	if (port && (port->wwpn == wwpn))
-		zfcp_erp_port_forced_reopen(port, 0, 83, req);
+		zfcp_erp_port_forced_reopen(port, 0, "fciwwp1", req);
 }
 
 static void zfcp_fc_incoming_plogi(struct zfcp_fsf_req *req)
@@ -374,7 +374,7 @@ static void zfcp_fc_adisc_handler(unsign
 
 	if (adisc->els.status) {
 		/* request rejected or timed out */
-		zfcp_erp_port_forced_reopen(port, 0, 63, NULL);
+		zfcp_erp_port_forced_reopen(port, 0, "fcadh_1", NULL);
 		goto out;
 	}
 
@@ -382,7 +382,7 @@ static void zfcp_fc_adisc_handler(unsign
 		port->wwnn = ls_adisc->wwnn;
 
 	if (port->wwpn != ls_adisc->wwpn)
-		zfcp_erp_port_reopen(port, 0, 64, NULL);
+		zfcp_erp_port_reopen(port, 0, "fcadh_2", NULL);
 
  out:
 	zfcp_port_put(port);
@@ -434,7 +434,7 @@ void zfcp_fc_link_test_work(struct work_
 	/* send of ADISC was not possible */
 	zfcp_port_put(port);
 	if (retval != -EBUSY)
-		zfcp_erp_port_forced_reopen(port, 0, 65, NULL);
+		zfcp_erp_port_forced_reopen(port, 0, "fcltwk1", NULL);
 }
 
 /**
@@ -536,7 +536,7 @@ static void zfcp_validate_port(struct zf
 		zfcp_port_put(port);
 		return;
 	}
-	zfcp_erp_port_shutdown(port, 0, 151, NULL);
+	zfcp_erp_port_shutdown(port, 0, "fcpval1", NULL);
 	zfcp_erp_wait(adapter);
 	zfcp_port_put(port);
 	zfcp_port_dequeue(port);
@@ -599,7 +599,7 @@ static int zfcp_scan_eval_gpn_ft(struct 
 		if (IS_ERR(port))
 			ret = PTR_ERR(port);
 		else
-			zfcp_erp_port_reopen(port, 0, 149, NULL);
+			zfcp_erp_port_reopen(port, 0, "fcegpf1", NULL);
 	}
 
 	zfcp_erp_wait(adapter);
--- a/drivers/s390/scsi/zfcp_fsf.c	2009-03-02 12:42:36.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2009-03-02 12:42:38.000000000 +0100
@@ -18,8 +18,8 @@
 static void zfcp_fsf_request_timeout_handler(unsigned long data)
 {
 	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
-	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED, 62,
-				NULL);
+	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
+				"fsrth_1", NULL);
 }
 
 static void zfcp_fsf_start_timer(struct zfcp_fsf_req *fsf_req,
@@ -78,7 +78,7 @@ static void zfcp_fsf_access_denied_port(
 		 (unsigned long long)port->wwpn);
 	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[0]);
 	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[1]);
-	zfcp_erp_port_access_denied(port, 55, req);
+	zfcp_erp_port_access_denied(port, "fspad_1", req);
 	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 }
 
@@ -92,7 +92,7 @@ static void zfcp_fsf_access_denied_unit(
 		 (unsigned long long)unit->port->wwpn);
 	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[0]);
 	zfcp_act_eval_err(req->adapter, header->fsf_status_qual.halfword[1]);
-	zfcp_erp_unit_access_denied(unit, 59, req);
+	zfcp_erp_unit_access_denied(unit, "fsuad_1", req);
 	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 }
 
@@ -100,7 +100,7 @@ static void zfcp_fsf_class_not_supp(stru
 {
 	dev_err(&req->adapter->ccw_device->dev, "FCP device not "
 		"operational because of an unsupported FC class\n");
-	zfcp_erp_adapter_shutdown(req->adapter, 0, 123, req);
+	zfcp_erp_adapter_shutdown(req->adapter, 0, "fscns_1", req);
 	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 }
 
@@ -162,13 +162,13 @@ static void zfcp_fsf_status_read_port_cl
 	list_for_each_entry(port, &adapter->port_list_head, list)
 		if (port->d_id == d_id) {
 			read_unlock_irqrestore(&zfcp_data.config_lock, flags);
-			zfcp_erp_port_reopen(port, 0, 101, req);
+			zfcp_erp_port_reopen(port, 0, "fssrpc1", req);
 			return;
 		}
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
 
-static void zfcp_fsf_link_down_info_eval(struct zfcp_fsf_req *req, u8 id,
+static void zfcp_fsf_link_down_info_eval(struct zfcp_fsf_req *req, char *id,
 					 struct fsf_link_down_info *link_down)
 {
 	struct zfcp_adapter *adapter = req->adapter;
@@ -257,13 +257,13 @@ static void zfcp_fsf_status_read_link_do
 
 	switch (sr_buf->status_subtype) {
 	case FSF_STATUS_READ_SUB_NO_PHYSICAL_LINK:
-		zfcp_fsf_link_down_info_eval(req, 38, ldi);
+		zfcp_fsf_link_down_info_eval(req, "fssrld1", ldi);
 		break;
 	case FSF_STATUS_READ_SUB_FDISC_FAILED:
-		zfcp_fsf_link_down_info_eval(req, 39, ldi);
+		zfcp_fsf_link_down_info_eval(req, "fssrld2", ldi);
 		break;
 	case FSF_STATUS_READ_SUB_FIRMWARE_UPDATE:
-		zfcp_fsf_link_down_info_eval(req, 40, NULL);
+		zfcp_fsf_link_down_info_eval(req, "fssrld3", NULL);
 	};
 }
 
@@ -303,22 +303,23 @@ static void zfcp_fsf_status_read_handler
 		dev_info(&adapter->ccw_device->dev,
 			 "The local link has been restored\n");
 		/* All ports should be marked as ready to run again */
-		zfcp_erp_modify_adapter_status(adapter, 30, NULL,
+		zfcp_erp_modify_adapter_status(adapter, "fssrh_1", NULL,
 					       ZFCP_STATUS_COMMON_RUNNING,
 					       ZFCP_SET);
 		zfcp_erp_adapter_reopen(adapter,
 					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
 					ZFCP_STATUS_COMMON_ERP_FAILED,
-					102, req);
+					"fssrh_2", req);
 		break;
 	case FSF_STATUS_READ_NOTIFICATION_LOST:
 		if (sr_buf->status_subtype & FSF_STATUS_READ_SUB_ACT_UPDATED)
-			zfcp_erp_adapter_access_changed(adapter, 135, req);
+			zfcp_erp_adapter_access_changed(adapter, "fssrh_3",
+							req);
 		if (sr_buf->status_subtype & FSF_STATUS_READ_SUB_INCOMING_ELS)
 			schedule_work(&adapter->scan_work);
 		break;
 	case FSF_STATUS_READ_CFDC_UPDATED:
-		zfcp_erp_adapter_access_changed(adapter, 136, req);
+		zfcp_erp_adapter_access_changed(adapter, "fssrh_4", req);
 		break;
 	case FSF_STATUS_READ_FEATURE_UPDATE_ALERT:
 		adapter->adapter_features = sr_buf->payload.word[0];
@@ -347,7 +348,7 @@ static void zfcp_fsf_fsfstatus_qual_eval
 		dev_err(&req->adapter->ccw_device->dev,
 			"The FCP adapter reported a problem "
 			"that cannot be recovered\n");
-		zfcp_erp_adapter_shutdown(req->adapter, 0, 121, req);
+		zfcp_erp_adapter_shutdown(req->adapter, 0, "fsfsqe1", req);
 		break;
 	}
 	/* all non-return stats set FSFREQ_ERROR*/
@@ -364,7 +365,7 @@ static void zfcp_fsf_fsfstatus_eval(stru
 		dev_err(&req->adapter->ccw_device->dev,
 			"The FCP adapter does not recognize the command 0x%x\n",
 			req->qtcb->header.fsf_command);
-		zfcp_erp_adapter_shutdown(req->adapter, 0, 120, req);
+		zfcp_erp_adapter_shutdown(req->adapter, 0, "fsfse_1", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
@@ -396,17 +397,17 @@ static void zfcp_fsf_protstatus_eval(str
 			"QTCB version 0x%x not supported by FCP adapter "
 			"(0x%x to 0x%x)\n", FSF_QTCB_CURRENT_VERSION,
 			psq->word[0], psq->word[1]);
-		zfcp_erp_adapter_shutdown(adapter, 0, 117, req);
+		zfcp_erp_adapter_shutdown(adapter, 0, "fspse_1", req);
 		break;
 	case FSF_PROT_ERROR_STATE:
 	case FSF_PROT_SEQ_NUMB_ERROR:
-		zfcp_erp_adapter_reopen(adapter, 0, 98, req);
+		zfcp_erp_adapter_reopen(adapter, 0, "fspse_2", req);
 		req->status |= ZFCP_STATUS_FSFREQ_RETRY;
 		break;
 	case FSF_PROT_UNSUPP_QTCB_TYPE:
 		dev_err(&adapter->ccw_device->dev,
 			"The QTCB type is not supported by the FCP adapter\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, 118, req);
+		zfcp_erp_adapter_shutdown(adapter, 0, "fspse_3", req);
 		break;
 	case FSF_PROT_HOST_CONNECTION_INITIALIZING:
 		atomic_set_mask(ZFCP_STATUS_ADAPTER_HOST_CON_INIT,
@@ -416,27 +417,29 @@ static void zfcp_fsf_protstatus_eval(str
 		dev_err(&adapter->ccw_device->dev,
 			"0x%Lx is an ambiguous request identifier\n",
 			(unsigned long long)qtcb->bottom.support.req_handle);
-		zfcp_erp_adapter_shutdown(adapter, 0, 78, req);
+		zfcp_erp_adapter_shutdown(adapter, 0, "fspse_4", req);
 		break;
 	case FSF_PROT_LINK_DOWN:
-		zfcp_fsf_link_down_info_eval(req, 37, &psq->link_down_info);
+		zfcp_fsf_link_down_info_eval(req, "fspse_5",
+					     &psq->link_down_info);
 		/* FIXME: reopening adapter now? better wait for link up */
-		zfcp_erp_adapter_reopen(adapter, 0, 79, req);
+		zfcp_erp_adapter_reopen(adapter, 0, "fspse_6", req);
 		break;
 	case FSF_PROT_REEST_QUEUE:
 		/* All ports should be marked as ready to run again */
-		zfcp_erp_modify_adapter_status(adapter, 28, NULL,
+		zfcp_erp_modify_adapter_status(adapter, "fspse_7", NULL,
 					       ZFCP_STATUS_COMMON_RUNNING,
 					       ZFCP_SET);
 		zfcp_erp_adapter_reopen(adapter,
 					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
-					ZFCP_STATUS_COMMON_ERP_FAILED, 99, req);
+					ZFCP_STATUS_COMMON_ERP_FAILED,
+					"fspse_8", req);
 		break;
 	default:
 		dev_err(&adapter->ccw_device->dev,
 			"0x%x is not a valid transfer protocol status\n",
 			qtcb->prefix.prot_status);
-		zfcp_erp_adapter_shutdown(adapter, 0, 119, req);
+		zfcp_erp_adapter_shutdown(adapter, 0, "fspse_9", req);
 	}
 	req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 }
@@ -522,7 +525,7 @@ static int zfcp_fsf_exchange_config_eval
 		dev_err(&adapter->ccw_device->dev,
 			"Unknown or unsupported arbitrated loop "
 			"fibre channel topology detected\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, 127, req);
+		zfcp_erp_adapter_shutdown(adapter, 0, "fsece_1", req);
 		return -EIO;
 	}
 
@@ -556,7 +559,7 @@ static void zfcp_fsf_exchange_config_dat
 				"FCP adapter maximum QTCB size (%d bytes) "
 				"is too small\n",
 				bottom->max_qtcb_size);
-			zfcp_erp_adapter_shutdown(adapter, 0, 129, req);
+			zfcp_erp_adapter_shutdown(adapter, 0, "fsecdh1", req);
 			return;
 		}
 		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
@@ -573,11 +576,11 @@ static void zfcp_fsf_exchange_config_dat
 		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
 				&adapter->status);
 
-		zfcp_fsf_link_down_info_eval(req, 42,
+		zfcp_fsf_link_down_info_eval(req, "fsecdh2",
 			&qtcb->header.fsf_status_qual.link_down_info);
 		break;
 	default:
-		zfcp_erp_adapter_shutdown(adapter, 0, 130, req);
+		zfcp_erp_adapter_shutdown(adapter, 0, "fsecdh3", req);
 		return;
 	}
 
@@ -593,14 +596,14 @@ static void zfcp_fsf_exchange_config_dat
 		dev_err(&adapter->ccw_device->dev,
 			"The FCP adapter only supports newer "
 			"control block versions\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, 125, req);
+		zfcp_erp_adapter_shutdown(adapter, 0, "fsecdh4", req);
 		return;
 	}
 	if (FSF_QTCB_CURRENT_VERSION > bottom->high_qtcb_version) {
 		dev_err(&adapter->ccw_device->dev,
 			"The FCP adapter only supports older "
 			"control block versions\n");
-		zfcp_erp_adapter_shutdown(adapter, 0, 126, req);
+		zfcp_erp_adapter_shutdown(adapter, 0, "fsecdh5", req);
 	}
 }
 
@@ -634,7 +637,7 @@ static void zfcp_fsf_exchange_port_data_
 		break;
 	case FSF_EXCHANGE_CONFIG_DATA_INCOMPLETE:
 		zfcp_fsf_exchange_port_evaluate(req);
-		zfcp_fsf_link_down_info_eval(req, 43,
+		zfcp_fsf_link_down_info_eval(req, "fsepdh1",
 			&qtcb->header.fsf_status_qual.link_down_info);
 		break;
 	}
@@ -779,7 +782,7 @@ static int zfcp_fsf_req_send(struct zfcp
 		if (zfcp_reqlist_find_safe(adapter, req))
 			zfcp_reqlist_remove(adapter, req);
 		spin_unlock_irqrestore(&adapter->req_list_lock, flags);
-		zfcp_erp_adapter_reopen(adapter, 0, 116, req);
+		zfcp_erp_adapter_reopen(adapter, 0, "fsrs__1", req);
 		return -EIO;
 	}
 
@@ -859,14 +862,14 @@ static void zfcp_fsf_abort_fcp_command_h
 	switch (req->qtcb->header.fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
 		if (fsq->word[0] == fsq->word[1]) {
-			zfcp_erp_adapter_reopen(unit->port->adapter, 0, 104,
-						req);
+			zfcp_erp_adapter_reopen(unit->port->adapter, 0,
+						"fsafch1", req);
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		}
 		break;
 	case FSF_LUN_HANDLE_NOT_VALID:
 		if (fsq->word[0] == fsq->word[1]) {
-			zfcp_erp_port_reopen(unit->port, 0, 105, req);
+			zfcp_erp_port_reopen(unit->port, 0, "fsafch2", req);
 			req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		}
 		break;
@@ -874,12 +877,12 @@ static void zfcp_fsf_abort_fcp_command_h
 		req->status |= ZFCP_STATUS_FSFREQ_ABORTNOTNEEDED;
 		break;
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(unit->port, 47, req);
+		zfcp_erp_port_boxed(unit->port, "fsafch3", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			       ZFCP_STATUS_FSFREQ_RETRY;
 		break;
 	case FSF_LUN_BOXED:
-		zfcp_erp_unit_boxed(unit, 48, req);
+		zfcp_erp_unit_boxed(unit, "fsafch4", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			       ZFCP_STATUS_FSFREQ_RETRY;
                 break;
@@ -982,7 +985,7 @@ static void zfcp_fsf_send_ct_handler(str
 			       ZFCP_STATUS_FSFREQ_RETRY;
 		break;
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(adapter, 0, 106, req);
+		zfcp_erp_adapter_reopen(adapter, 0, "fsscth1", req);
 	case FSF_GENERIC_COMMAND_REJECTED:
 	case FSF_PAYLOAD_SIZE_MISMATCH:
 	case FSF_REQUEST_SIZE_TOO_LARGE:
@@ -1400,7 +1403,7 @@ static void zfcp_fsf_open_port_handler(s
 			 "Not enough FCP adapter resources to open "
 			 "remote port 0x%016Lx\n",
 			 (unsigned long long)port->wwpn);
-		zfcp_erp_port_failed(port, 31, req);
+		zfcp_erp_port_failed(port, "fsoph_1", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
@@ -1506,13 +1509,13 @@ static void zfcp_fsf_close_port_handler(
 
 	switch (req->qtcb->header.fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(port->adapter, 0, 107, req);
+		zfcp_erp_adapter_reopen(port->adapter, 0, "fscph_1", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ADAPTER_STATUS_AVAILABLE:
 		break;
 	case FSF_GOOD:
-		zfcp_erp_modify_port_status(port, 33, req,
+		zfcp_erp_modify_port_status(port, "fscph_2", req,
 					    ZFCP_STATUS_COMMON_OPEN,
 					    ZFCP_CLEAR);
 		break;
@@ -1641,7 +1644,7 @@ static void zfcp_fsf_close_wka_port_hand
 
 	if (req->qtcb->header.fsf_status == FSF_PORT_HANDLE_NOT_VALID) {
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-		zfcp_erp_adapter_reopen(wka_port->adapter, 0, 84, req);
+		zfcp_erp_adapter_reopen(wka_port->adapter, 0, "fscwph1", req);
 	}
 
 	wka_port->status = ZFCP_WKA_PORT_OFFLINE;
@@ -1700,14 +1703,14 @@ static void zfcp_fsf_close_physical_port
 
 	switch (header->fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(port->adapter, 0, 108, req);
+		zfcp_erp_adapter_reopen(port->adapter, 0, "fscpph1", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_ACCESS_DENIED:
 		zfcp_fsf_access_denied_port(req, port);
 		break;
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(port, 50, req);
+		zfcp_erp_port_boxed(port, "fscpph2", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			       ZFCP_STATUS_FSFREQ_RETRY;
 		/* can't use generic zfcp_erp_modify_port_status because
@@ -1805,7 +1808,7 @@ static void zfcp_fsf_open_unit_handler(s
 	switch (header->fsf_status) {
 
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 109, req);
+		zfcp_erp_adapter_reopen(unit->port->adapter, 0, "fsouh_1", req);
 		/* fall through */
 	case FSF_LUN_ALREADY_OPEN:
 		break;
@@ -1815,7 +1818,7 @@ static void zfcp_fsf_open_unit_handler(s
 		atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
 		break;
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(unit->port, 51, req);
+		zfcp_erp_port_boxed(unit->port, "fsouh_2", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			       ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -1831,7 +1834,7 @@ static void zfcp_fsf_open_unit_handler(s
 		else
 			zfcp_act_eval_err(adapter,
 					  header->fsf_status_qual.word[2]);
-		zfcp_erp_unit_access_denied(unit, 60, req);
+		zfcp_erp_unit_access_denied(unit, "fsouh_3", req);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -1842,7 +1845,7 @@ static void zfcp_fsf_open_unit_handler(s
 			 "0x%016Lx on port 0x%016Lx\n",
 			 (unsigned long long)unit->fcp_lun,
 			 (unsigned long long)unit->port->wwpn);
-		zfcp_erp_unit_failed(unit, 34, req);
+		zfcp_erp_unit_failed(unit, "fsouh_4", req);
 		/* fall through */
 	case FSF_INVALID_COMMAND_OPTION:
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
@@ -1891,9 +1894,9 @@ static void zfcp_fsf_open_unit_handler(s
 					"port 0x%016Lx)\n",
 					(unsigned long long)unit->fcp_lun,
 					(unsigned long long)unit->port->wwpn);
-				zfcp_erp_unit_failed(unit, 35, req);
+				zfcp_erp_unit_failed(unit, "fsouh_5", req);
 				req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-				zfcp_erp_unit_shutdown(unit, 0, 80, req);
+				zfcp_erp_unit_shutdown(unit, 0, "fsouh_6", req);
         		} else if (!exclusive && readwrite) {
 				dev_err(&adapter->ccw_device->dev,
 					"Shared read-write access not "
@@ -1901,9 +1904,9 @@ static void zfcp_fsf_open_unit_handler(s
 					"0x%016Lx)\n",
 					(unsigned long long)unit->fcp_lun,
 					(unsigned long long)unit->port->wwpn);
-				zfcp_erp_unit_failed(unit, 36, req);
+				zfcp_erp_unit_failed(unit, "fsouh_7", req);
 				req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-				zfcp_erp_unit_shutdown(unit, 0, 81, req);
+				zfcp_erp_unit_shutdown(unit, 0, "fsouh_8", req);
         		}
 		}
 		break;
@@ -1968,15 +1971,15 @@ static void zfcp_fsf_close_unit_handler(
 
 	switch (req->qtcb->header.fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 110, req);
+		zfcp_erp_adapter_reopen(unit->port->adapter, 0, "fscuh_1", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_LUN_HANDLE_NOT_VALID:
-		zfcp_erp_port_reopen(unit->port, 0, 111, req);
+		zfcp_erp_port_reopen(unit->port, 0, "fscuh_2", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(unit->port, 52, req);
+		zfcp_erp_port_boxed(unit->port, "fscuh_3", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			       ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -2216,12 +2219,12 @@ static void zfcp_fsf_send_fcp_command_ha
 	switch (header->fsf_status) {
 	case FSF_HANDLE_MISMATCH:
 	case FSF_PORT_HANDLE_NOT_VALID:
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 112, req);
+		zfcp_erp_adapter_reopen(unit->port->adapter, 0, "fssfch1", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_FCPLUN_NOT_VALID:
 	case FSF_LUN_HANDLE_NOT_VALID:
-		zfcp_erp_port_reopen(unit->port, 0, 113, req);
+		zfcp_erp_port_reopen(unit->port, 0, "fssfch2", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SERVICE_CLASS_NOT_SUPPORTED:
@@ -2237,7 +2240,8 @@ static void zfcp_fsf_send_fcp_command_ha
 			req->qtcb->bottom.io.data_direction,
 			(unsigned long long)unit->fcp_lun,
 			(unsigned long long)unit->port->wwpn);
-		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 133, req);
+		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, "fssfch3",
+					  req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_CMND_LENGTH_NOT_VALID:
@@ -2247,16 +2251,17 @@ static void zfcp_fsf_send_fcp_command_ha
 			req->qtcb->bottom.io.fcp_cmnd_length,
 			(unsigned long long)unit->fcp_lun,
 			(unsigned long long)unit->port->wwpn);
-		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 134, req);
+		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, "fssfch4",
+					  req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_PORT_BOXED:
-		zfcp_erp_port_boxed(unit->port, 53, req);
+		zfcp_erp_port_boxed(unit->port, "fssfch5", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			       ZFCP_STATUS_FSFREQ_RETRY;
 		break;
 	case FSF_LUN_BOXED:
-		zfcp_erp_unit_boxed(unit, 54, req);
+		zfcp_erp_unit_boxed(unit, "fssfch6", req);
 		req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			       ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -2389,7 +2394,7 @@ int zfcp_fsf_send_fcp_command_task(struc
 				"on port 0x%016Lx closed\n",
 				(unsigned long long)unit->fcp_lun,
 				(unsigned long long)unit->port->wwpn);
-			zfcp_erp_unit_shutdown(unit, 0, 131, req);
+			zfcp_erp_unit_shutdown(unit, 0, "fssfct1", req);
 			retval = -EINVAL;
 		}
 		goto failed_scsi_cmnd;
--- a/drivers/s390/scsi/zfcp_qdio.c	2009-03-02 12:42:24.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_qdio.c	2009-03-02 12:42:38.000000000 +0100
@@ -58,7 +58,7 @@ void zfcp_qdio_free(struct zfcp_adapter 
 	}
 }
 
-static void zfcp_qdio_handler_error(struct zfcp_adapter *adapter, u8 id)
+static void zfcp_qdio_handler_error(struct zfcp_adapter *adapter, char *id)
 {
 	dev_warn(&adapter->ccw_device->dev, "A QDIO problem occurred\n");
 
@@ -103,7 +103,7 @@ static void zfcp_qdio_int_req(struct ccw
 
 	if (unlikely(qdio_err)) {
 		zfcp_hba_dbf_event_qdio(adapter, qdio_err, first, count);
-		zfcp_qdio_handler_error(adapter, 140);
+		zfcp_qdio_handler_error(adapter, "qdireq1");
 		return;
 	}
 
@@ -172,7 +172,7 @@ static void zfcp_qdio_int_resp(struct cc
 
 	if (unlikely(qdio_err)) {
 		zfcp_hba_dbf_event_qdio(adapter, qdio_err, first, count);
-		zfcp_qdio_handler_error(adapter, 147);
+		zfcp_qdio_handler_error(adapter, "qdires1");
 		return;
 	}
 
--- a/drivers/s390/scsi/zfcp_scsi.c	2009-03-02 12:42:30.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-03-02 12:42:38.000000000 +0100
@@ -28,7 +28,7 @@ static void zfcp_scsi_slave_destroy(stru
 {
 	struct zfcp_unit *unit = (struct zfcp_unit *) sdpnt->hostdata;
 	unit->device = NULL;
-	zfcp_erp_unit_failed(unit, 12, NULL);
+	zfcp_erp_unit_failed(unit, "scslvd1", NULL);
 	zfcp_unit_put(unit);
 }
 
@@ -257,7 +257,7 @@ static int zfcp_scsi_eh_host_reset_handl
 	struct zfcp_unit *unit = scpnt->device->hostdata;
 	struct zfcp_adapter *adapter = unit->port->adapter;
 
-	zfcp_erp_adapter_reopen(adapter, 0, 141, scpnt);
+	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1", scpnt);
 	zfcp_erp_wait(adapter);
 
 	return SUCCESS;
--- a/drivers/s390/scsi/zfcp_sysfs.c	2009-03-02 12:42:25.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_sysfs.c	2009-03-02 12:42:38.000000000 +0100
@@ -112,9 +112,9 @@ static ZFCP_DEV_ATTR(_feat, failed, S_IW
 		     zfcp_sysfs_##_feat##_failed_show,			       \
 		     zfcp_sysfs_##_feat##_failed_store);
 
-ZFCP_SYSFS_FAILED(zfcp_adapter, adapter, adapter, 44, 93);
-ZFCP_SYSFS_FAILED(zfcp_port, port, port->adapter, 45, 96);
-ZFCP_SYSFS_FAILED(zfcp_unit, unit, unit->port->adapter, 46, 97);
+ZFCP_SYSFS_FAILED(zfcp_adapter, adapter, adapter, "syafai1", "syafai2");
+ZFCP_SYSFS_FAILED(zfcp_port, port, port->adapter, "sypfai1", "sypfai2");
+ZFCP_SYSFS_FAILED(zfcp_unit, unit, unit->port->adapter, "syufai1", "syufai2");
 
 static ssize_t zfcp_sysfs_port_rescan_store(struct device *dev,
 					    struct device_attribute *attr,
@@ -168,7 +168,7 @@ static ssize_t zfcp_sysfs_port_remove_st
 		goto out;
 	}
 
-	zfcp_erp_port_shutdown(port, 0, 92, NULL);
+	zfcp_erp_port_shutdown(port, 0, "syprs_1", NULL);
 	zfcp_erp_wait(adapter);
 	zfcp_port_put(port);
 	zfcp_port_dequeue(port);
@@ -222,7 +222,7 @@ static ssize_t zfcp_sysfs_unit_add_store
 
 	retval = 0;
 
-	zfcp_erp_unit_reopen(unit, 0, 94, NULL);
+	zfcp_erp_unit_reopen(unit, 0, "syuas_1", NULL);
 	zfcp_erp_wait(unit->port->adapter);
 	zfcp_unit_put(unit);
 out:
@@ -268,7 +268,7 @@ static ssize_t zfcp_sysfs_unit_remove_st
 		goto out;
 	}
 
-	zfcp_erp_unit_shutdown(unit, 0, 95, NULL);
+	zfcp_erp_unit_shutdown(unit, 0, "syurs_1", NULL);
 	zfcp_erp_wait(unit->port->adapter);
 	zfcp_unit_put(unit);
 	zfcp_unit_dequeue(unit);

