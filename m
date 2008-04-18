From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/3] zfcp: fix 31 bit compile warnings
Date: Fri, 18 Apr 2008 12:51:55 +0200
Message-ID: <20080418105454.578145000@de.ibm.com>
References: <20080418105154.135704000@de.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:14383 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbYDRKy5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Apr 2008 06:54:57 -0400
Content-Disposition: inline; filename=zfcp_fix_dbf_31bit_warnings.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

=46rom: Martin Peschke <mp3@de.ibm.com>

drivers/s390/scsi/zfcp_aux.c: In function =E2=80=98zfcp_fsf_incoming_el=
s_rscn=E2=80=99:
drivers/s390/scsi/zfcp_aux.c:1379: warning: cast from pointer to intege=
r of
different size
drivers/s390/scsi/zfcp_aux.c: In function =E2=80=98zfcp_fsf_incoming_el=
s_plogi=E2=80=99:
drivers/s390/scsi/zfcp_aux.c:1432: warning: cast from pointer to intege=
r of
different size
drivers/s390/scsi/zfcp_aux.c: In function =E2=80=98zfcp_fsf_incoming_el=
s_logo=E2=80=99:
drivers/s390/scsi/zfcp_aux.c:1457: warning: cast from pointer to intege=
r of
different size
=2E.

Just passing pointers rids us of these warnings and improves readabilit=
y.

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c           |    6 -
 drivers/s390/scsi/zfcp_ccw.c           |   19 ++--
 drivers/s390/scsi/zfcp_dbf.c           |   22 ++--
 drivers/s390/scsi/zfcp_erp.c           |  140 ++++++++++++++++--------=
-------
 drivers/s390/scsi/zfcp_ext.h           |   60 ++++++-------
 drivers/s390/scsi/zfcp_fsf.c           |  149 +++++++++++++++---------=
---------
 drivers/s390/scsi/zfcp_qdio.c          |    3=20
 drivers/s390/scsi/zfcp_scsi.c          |    4=20
 drivers/s390/scsi/zfcp_sysfs_adapter.c |    9 +
 drivers/s390/scsi/zfcp_sysfs_port.c    |    8 -
 drivers/s390/scsi/zfcp_sysfs_unit.c    |    4=20
 11 files changed, 211 insertions(+), 213 deletions(-)

--- a/drivers/s390/scsi/zfcp_aux.c	2008-04-18 12:43:03.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-04-18 12:43:05.000000000 +0200
@@ -1376,7 +1376,7 @@ static void zfcp_fsf_incoming_els_rscn(s
 					      "port 0x%016Lx\n", port->wwpn);
 				zfcp_erp_port_reopen(port,
 						     ZFCP_STATUS_COMMON_ERP_FAILED,
-						     82, (u64)fsf_req);
+						     82, fsf_req);
 				continue;
 			}
=20
@@ -1429,7 +1429,7 @@ static void zfcp_fsf_incoming_els_plogi(
 			       status_buffer->d_id,
 			       zfcp_get_busid_by_adapter(adapter));
 	} else {
-		zfcp_erp_port_forced_reopen(port, 0, 83, (u64)fsf_req);
+		zfcp_erp_port_forced_reopen(port, 0, 83, fsf_req);
 	}
 }
=20
@@ -1454,7 +1454,7 @@ static void zfcp_fsf_incoming_els_logo(s
 			       status_buffer->d_id,
 			       zfcp_get_busid_by_adapter(adapter));
 	} else {
-		zfcp_erp_port_forced_reopen(port, 0, 84, (u64)fsf_req);
+		zfcp_erp_port_forced_reopen(port, 0, 84, fsf_req);
 	}
 }
=20
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-04-18 12:43:03.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-04-18 12:43:05.000000000 +0200
@@ -700,7 +700,7 @@ void zfcp_rec_dbf_event_thread(u8 id2, s
 	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
 }
=20
-static void zfcp_rec_dbf_event_target(u8 id2, u64 ref,
+static void zfcp_rec_dbf_event_target(u8 id2, void *ref,
 				      struct zfcp_adapter *adapter,
 				      atomic_t *status, atomic_t *erp_count,
 				      u64 wwpn, u32 d_id, u64 fcp_lun)
@@ -712,7 +712,7 @@ static void zfcp_rec_dbf_event_target(u8
 	memset(r, 0, sizeof(*r));
 	r->id =3D ZFCP_REC_DBF_ID_TARGET;
 	r->id2 =3D id2;
-	r->u.target.ref =3D ref;
+	r->u.target.ref =3D (unsigned long)ref;
 	r->u.target.status =3D atomic_read(status);
 	r->u.target.wwpn =3D wwpn;
 	r->u.target.d_id =3D d_id;
@@ -728,7 +728,7 @@ static void zfcp_rec_dbf_event_target(u8
  * @ref: additional reference (e.g. request)
  * @adapter: adapter
  */
-void zfcp_rec_dbf_event_adapter(u8 id, u64 ref, struct zfcp_adapter *a=
dapter)
+void zfcp_rec_dbf_event_adapter(u8 id, void *ref, struct zfcp_adapter =
*adapter)
 {
 	zfcp_rec_dbf_event_target(id, ref, adapter, &adapter->status,
 				  &adapter->erp_counter, 0, 0, 0);
@@ -740,7 +740,7 @@ void zfcp_rec_dbf_event_adapter(u8 id, u
  * @ref: additional reference (e.g. request)
  * @port: port
  */
-void zfcp_rec_dbf_event_port(u8 id, u64 ref, struct zfcp_port *port)
+void zfcp_rec_dbf_event_port(u8 id, void *ref, struct zfcp_port *port)
 {
 	struct zfcp_adapter *adapter =3D port->adapter;
=20
@@ -755,7 +755,7 @@ void zfcp_rec_dbf_event_port(u8 id, u64=20
  * @ref: additional reference (e.g. request)
  * @unit: unit
  */
-void zfcp_rec_dbf_event_unit(u8 id, u64 ref, struct zfcp_unit *unit)
+void zfcp_rec_dbf_event_unit(u8 id, void *ref, struct zfcp_unit *unit)
 {
 	struct zfcp_port *port =3D unit->port;
 	struct zfcp_adapter *adapter =3D port->adapter;
@@ -776,8 +776,8 @@ void zfcp_rec_dbf_event_unit(u8 id, u64=20
  * @port: port
  * @unit: unit
  */
-void zfcp_rec_dbf_event_trigger(u8 id2, u64 ref, u8 want, u8 need, u64=
 action,
-				struct zfcp_adapter *adapter,
+void zfcp_rec_dbf_event_trigger(u8 id2, void *ref, u8 want, u8 need,
+				void *action, struct zfcp_adapter *adapter,
 				struct zfcp_port *port, struct zfcp_unit *unit)
 {
 	struct zfcp_rec_dbf_record *r =3D &adapter->rec_dbf_buf;
@@ -787,10 +787,10 @@ void zfcp_rec_dbf_event_trigger(u8 id2,=20
 	memset(r, 0, sizeof(*r));
 	r->id =3D ZFCP_REC_DBF_ID_TRIGGER;
 	r->id2 =3D id2;
-	r->u.trigger.ref =3D ref;
+	r->u.trigger.ref =3D (unsigned long)ref;
 	r->u.trigger.want =3D want;
 	r->u.trigger.need =3D need;
-	r->u.trigger.action =3D action;
+	r->u.trigger.action =3D (unsigned long)action;
 	r->u.trigger.as =3D atomic_read(&adapter->status);
 	if (port) {
 		r->u.trigger.ps =3D atomic_read(&port->status);
@@ -819,10 +819,10 @@ void zfcp_rec_dbf_event_action(u8 id2, s
 	memset(r, 0, sizeof(*r));
 	r->id =3D ZFCP_REC_DBF_ID_ACTION;
 	r->id2 =3D id2;
-	r->u.action.action =3D (u64)erp_action;
+	r->u.action.action =3D (unsigned long)erp_action;
 	r->u.action.status =3D erp_action->status;
 	r->u.action.step =3D erp_action->step;
-	r->u.action.fsf_req =3D (u64)erp_action->fsf_req;
+	r->u.action.fsf_req =3D (unsigned long)erp_action->fsf_req;
 	debug_event(adapter->rec_dbf, 4, r, sizeof(*r));
 	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
 }
--- a/drivers/s390/scsi/zfcp_erp.c	2008-04-18 12:43:03.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-04-18 12:43:05.000000000 +0200
@@ -27,15 +27,16 @@ static int zfcp_erp_adisc(struct zfcp_po
 static void zfcp_erp_adisc_handler(unsigned long);
=20
 static int zfcp_erp_adapter_reopen_internal(struct zfcp_adapter *, int=
, u8,
-					    u64);
+					    void *);
 static int zfcp_erp_port_forced_reopen_internal(struct zfcp_port *, in=
t, u8,
-						u64);
-static int zfcp_erp_port_reopen_internal(struct zfcp_port *, int, u8, =
u64);
-static int zfcp_erp_unit_reopen_internal(struct zfcp_unit *, int, u8, =
u64);
+						void *);
+static int zfcp_erp_port_reopen_internal(struct zfcp_port *, int, u8, =
void *);
+static int zfcp_erp_unit_reopen_internal(struct zfcp_unit *, int, u8, =
void *);
=20
 static int zfcp_erp_port_reopen_all_internal(struct zfcp_adapter *, in=
t, u8,
-					     u64);
-static int zfcp_erp_unit_reopen_all_internal(struct zfcp_port *, int, =
u8, u64);
+					     void *);
+static int zfcp_erp_unit_reopen_all_internal(struct zfcp_port *, int, =
u8,
+					     void *);
=20
 static void zfcp_erp_adapter_block(struct zfcp_adapter *, int);
 static void zfcp_erp_adapter_unblock(struct zfcp_adapter *);
@@ -101,7 +102,7 @@ static void zfcp_erp_action_dismiss(stru
=20
 static int zfcp_erp_action_enqueue(int, struct zfcp_adapter *,
 				   struct zfcp_port *, struct zfcp_unit *,
-				   u8 id, u64 ref);
+				   u8 id, void *ref);
 static int zfcp_erp_action_dequeue(struct zfcp_erp_action *);
 static void zfcp_erp_action_cleanup(int, struct zfcp_adapter *,
 				    struct zfcp_port *, struct zfcp_unit *,
@@ -165,7 +166,7 @@ static void zfcp_close_fsf(struct zfcp_a
 	/* reset FSF request sequence number */
 	adapter->fsf_req_seq_no =3D 0;
 	/* all ports and units are closed */
-	zfcp_erp_modify_adapter_status(adapter, 24, 0,
+	zfcp_erp_modify_adapter_status(adapter, 24, NULL,
 				       ZFCP_STATUS_COMMON_OPEN, ZFCP_CLEAR);
 }
=20
@@ -181,7 +182,8 @@ static void zfcp_close_fsf(struct zfcp_a
 static void zfcp_fsf_request_timeout_handler(unsigned long data)
 {
 	struct zfcp_adapter *adapter =3D (struct zfcp_adapter *) data;
-	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED, 62, 0=
);
+	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED, 62,
+				NULL);
 }
=20
 void zfcp_fsf_start_timer(struct zfcp_fsf_req *fsf_req, unsigned long =
timeout)
@@ -203,7 +205,7 @@ void zfcp_fsf_start_timer(struct zfcp_fs
  *		<0	- failed to initiate action
  */
 static int zfcp_erp_adapter_reopen_internal(struct zfcp_adapter *adapt=
er,
-					    int clear_mask, u8 id, u64 ref)
+					    int clear_mask, u8 id, void *ref)
 {
 	int retval;
=20
@@ -216,7 +218,7 @@ static int zfcp_erp_adapter_reopen_inter
 		ZFCP_LOG_DEBUG("skipped reopen of failed adapter %s\n",
 			       zfcp_get_busid_by_adapter(adapter));
 		/* ensure propagation of failed status to new devices */
-		zfcp_erp_adapter_failed(adapter, 13, 0);
+		zfcp_erp_adapter_failed(adapter, 13, NULL);
 		retval =3D -EIO;
 		goto out;
 	}
@@ -237,7 +239,7 @@ static int zfcp_erp_adapter_reopen_inter
  *		<0	- failed to initiate action
  */
 int zfcp_erp_adapter_reopen(struct zfcp_adapter *adapter, int clear_ma=
sk,
-			    u8 id, u64 ref)
+			    u8 id, void *ref)
 {
 	int retval;
 	unsigned long flags;
@@ -252,7 +254,7 @@ int zfcp_erp_adapter_reopen(struct zfcp_
 }
=20
 int zfcp_erp_adapter_shutdown(struct zfcp_adapter *adapter, int clear_=
mask,
-			      u8 id, u64 ref)
+			      u8 id, void *ref)
 {
 	int retval;
=20
@@ -265,7 +267,7 @@ int zfcp_erp_adapter_shutdown(struct zfc
 }
=20
 int zfcp_erp_port_shutdown(struct zfcp_port *port, int clear_mask, u8 =
id,
-			   u64 ref)
+			   void *ref)
 {
 	int retval;
=20
@@ -278,7 +280,7 @@ int zfcp_erp_port_shutdown(struct zfcp_p
 }
=20
 int zfcp_erp_unit_shutdown(struct zfcp_unit *unit, int clear_mask, u8 =
id,
-			   u64 ref)
+			   void *ref)
 {
 	int retval;
=20
@@ -399,7 +401,7 @@ zfcp_erp_adisc_handler(unsigned long dat
 				"force physical port reopen "
 				"(adapter %s, port d_id=3D0x%06x)\n",
 				zfcp_get_busid_by_adapter(adapter), d_id);
-		if (zfcp_erp_port_forced_reopen(port, 0, 63, 0))
+		if (zfcp_erp_port_forced_reopen(port, 0, 63, NULL))
 			ZFCP_LOG_NORMAL("failed reopen of port "
 					"(adapter %s, wwpn=3D0x%016Lx)\n",
 					zfcp_get_busid_by_port(port),
@@ -426,7 +428,7 @@ zfcp_erp_adisc_handler(unsigned long dat
 				"adisc_resp_wwpn=3D0x%016Lx)\n",
 				zfcp_get_busid_by_port(port),
 				port->wwpn, (wwn_t) adisc->wwpn);
-		if (zfcp_erp_port_reopen(port, 0, 64, 0))
+		if (zfcp_erp_port_reopen(port, 0, 64, NULL))
 			ZFCP_LOG_NORMAL("failed reopen of port "
 					"(adapter %s, wwpn=3D0x%016Lx)\n",
 					zfcp_get_busid_by_port(port),
@@ -460,7 +462,7 @@ zfcp_test_link(struct zfcp_port *port)
 		ZFCP_LOG_NORMAL("reopen needed for port 0x%016Lx "
 				"on adapter %s\n ", port->wwpn,
 				zfcp_get_busid_by_port(port));
-		retval =3D zfcp_erp_port_forced_reopen(port, 0, 65, 0);
+		retval =3D zfcp_erp_port_forced_reopen(port, 0, 65, NULL);
 		if (retval !=3D 0) {
 			ZFCP_LOG_NORMAL("reopen of remote port 0x%016Lx "
 					"on adapter %s failed\n", port->wwpn,
@@ -484,7 +486,8 @@ zfcp_test_link(struct zfcp_port *port)
  *		<0	- failed to initiate action
  */
 static int zfcp_erp_port_forced_reopen_internal(struct zfcp_port *port=
,
-						int clear_mask, u8 id, u64 ref)
+						int clear_mask, u8 id,
+						void *ref)
 {
 	int retval;
=20
@@ -518,7 +521,7 @@ static int zfcp_erp_port_forced_reopen_i
  *		<0	- failed to initiate action
  */
 int zfcp_erp_port_forced_reopen(struct zfcp_port *port, int clear_mask=
, u8 id,
-				u64 ref)
+				void *ref)
 {
 	int retval;
 	unsigned long flags;
@@ -546,7 +549,7 @@ int zfcp_erp_port_forced_reopen(struct z
  *		<0	- failed to initiate action
  */
 static int zfcp_erp_port_reopen_internal(struct zfcp_port *port, int c=
lear_mask,
-					 u8 id, u64 ref)
+					 u8 id, void *ref)
 {
 	int retval;
=20
@@ -560,7 +563,7 @@ static int zfcp_erp_port_reopen_internal
 			       "on adapter %s\n", port->wwpn,
 			       zfcp_get_busid_by_port(port));
 		/* ensure propagation of failed status to new devices */
-		zfcp_erp_port_failed(port, 14, 0);
+		zfcp_erp_port_failed(port, 14, NULL);
 		retval =3D -EIO;
 		goto out;
 	}
@@ -582,7 +585,8 @@ static int zfcp_erp_port_reopen_internal
  * correct locking. An error recovery task is initiated to do the reop=
en.
  * To wait for the completion of the reopen zfcp_erp_wait should be us=
ed.
  */
-int zfcp_erp_port_reopen(struct zfcp_port *port, int clear_mask, u8 id=
, u64 ref)
+int zfcp_erp_port_reopen(struct zfcp_port *port, int clear_mask, u8 id=
,
+			 void *ref)
 {
 	int retval;
 	unsigned long flags;
@@ -608,7 +612,7 @@ int zfcp_erp_port_reopen(struct zfcp_por
  *		<0	- failed to initiate action
  */
 static int zfcp_erp_unit_reopen_internal(struct zfcp_unit *unit, int c=
lear_mask,
-					 u8 id, u64 ref)
+					 u8 id, void *ref)
 {
 	int retval;
 	struct zfcp_adapter *adapter =3D unit->port->adapter;
@@ -644,7 +648,8 @@ static int zfcp_erp_unit_reopen_internal
  * locking. An error recovery task is initiated to do the reopen.
  * To wait for the completion of the reopen zfcp_erp_wait should be us=
ed.
  */
-int zfcp_erp_unit_reopen(struct zfcp_unit *unit, int clear_mask, u8 id=
, u64 ref)
+int zfcp_erp_unit_reopen(struct zfcp_unit *unit, int clear_mask, u8 id=
,
+			 void *ref)
 {
 	int retval;
 	unsigned long flags;
@@ -668,7 +673,7 @@ int zfcp_erp_unit_reopen(struct zfcp_uni
  */
 static void zfcp_erp_adapter_block(struct zfcp_adapter *adapter, int c=
lear_mask)
 {
-	zfcp_erp_modify_adapter_status(adapter, 15, 0,
+	zfcp_erp_modify_adapter_status(adapter, 15, NULL,
 				       ZFCP_STATUS_COMMON_UNBLOCKED |
 				       clear_mask, ZFCP_CLEAR);
 }
@@ -704,7 +709,7 @@ static void zfcp_erp_adapter_unblock(str
 {
 	if (atomic_test_and_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
 				     &adapter->status))
-		zfcp_rec_dbf_event_adapter(16, 0, adapter);
+		zfcp_rec_dbf_event_adapter(16, NULL, adapter);
 }
=20
 /*
@@ -719,7 +724,7 @@ static void zfcp_erp_adapter_unblock(str
 static void
 zfcp_erp_port_block(struct zfcp_port *port, int clear_mask)
 {
-	zfcp_erp_modify_port_status(port, 17, 0,
+	zfcp_erp_modify_port_status(port, 17, NULL,
 				    ZFCP_STATUS_COMMON_UNBLOCKED | clear_mask,
 				    ZFCP_CLEAR);
 }
@@ -736,7 +741,7 @@ zfcp_erp_port_unblock(struct zfcp_port *
 {
 	if (atomic_test_and_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
 				     &port->status))
-		zfcp_rec_dbf_event_port(18, 0, port);
+		zfcp_rec_dbf_event_port(18, NULL, port);
 }
=20
 /*
@@ -751,7 +756,7 @@ zfcp_erp_port_unblock(struct zfcp_port *
 static void
 zfcp_erp_unit_block(struct zfcp_unit *unit, int clear_mask)
 {
-	zfcp_erp_modify_unit_status(unit, 19, 0,
+	zfcp_erp_modify_unit_status(unit, 19, NULL,
 				    ZFCP_STATUS_COMMON_UNBLOCKED | clear_mask,
 				    ZFCP_CLEAR);
 }
@@ -768,7 +773,7 @@ zfcp_erp_unit_unblock(struct zfcp_unit *
 {
 	if (atomic_test_and_set_mask(ZFCP_STATUS_COMMON_UNBLOCKED,
 				     &unit->status))
-		zfcp_rec_dbf_event_unit(20, 0, unit);
+		zfcp_rec_dbf_event_unit(20, NULL, unit);
 }
=20
 static void
@@ -1140,7 +1145,7 @@ zfcp_erp_strategy(struct zfcp_erp_action
 					"restarting I/O on adapter %s "
 					"to free mempool\n",
 					zfcp_get_busid_by_adapter(adapter));
-			zfcp_erp_adapter_reopen_internal(adapter, 0, 66, 0);
+			zfcp_erp_adapter_reopen_internal(adapter, 0, 66, NULL);
 		} else {
 		retval =3D zfcp_erp_strategy_memwait(erp_action);
 		}
@@ -1295,7 +1300,7 @@ zfcp_erp_strategy_memwait(struct zfcp_er
  *
  */
 void
-zfcp_erp_adapter_failed(struct zfcp_adapter *adapter, u8 id, u64 ref)
+zfcp_erp_adapter_failed(struct zfcp_adapter *adapter, u8 id, void *ref=
)
 {
 	zfcp_erp_modify_adapter_status(adapter, id, ref,
 				       ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
@@ -1310,7 +1315,7 @@ zfcp_erp_adapter_failed(struct zfcp_adap
  *
  */
 void
-zfcp_erp_port_failed(struct zfcp_port *port, u8 id, u64 ref)
+zfcp_erp_port_failed(struct zfcp_port *port, u8 id, void *ref)
 {
 	zfcp_erp_modify_port_status(port, id, ref,
 				    ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
@@ -1331,7 +1336,7 @@ zfcp_erp_port_failed(struct zfcp_port *p
  *
  */
 void
-zfcp_erp_unit_failed(struct zfcp_unit *unit, u8 id, u64 ref)
+zfcp_erp_unit_failed(struct zfcp_unit *unit, u8 id, void *ref)
 {
 	zfcp_erp_modify_unit_status(unit, id, ref,
 				    ZFCP_STATUS_COMMON_ERP_FAILED, ZFCP_SET);
@@ -1395,7 +1400,7 @@ zfcp_erp_strategy_statechange(int action
 							   status)) {
 			zfcp_erp_adapter_reopen_internal(adapter,
 						ZFCP_STATUS_COMMON_ERP_FAILED,
-						67, 0);
+						67, NULL);
 			retval =3D ZFCP_ERP_EXIT;
 		}
 		break;
@@ -1406,7 +1411,7 @@ zfcp_erp_strategy_statechange(int action
 							   status)) {
 			zfcp_erp_port_reopen_internal(port,
 						ZFCP_STATUS_COMMON_ERP_FAILED,
-						68, 0);
+						68, NULL);
 			retval =3D ZFCP_ERP_EXIT;
 		}
 		break;
@@ -1416,7 +1421,7 @@ zfcp_erp_strategy_statechange(int action
 							   status)) {
 			zfcp_erp_unit_reopen_internal(unit,
 						ZFCP_STATUS_COMMON_ERP_FAILED,
-						69, 0);
+						69, NULL);
 			retval =3D ZFCP_ERP_EXIT;
 		}
 		break;
@@ -1448,7 +1453,7 @@ zfcp_erp_strategy_check_unit(struct zfcp
 	case ZFCP_ERP_FAILED :
 		atomic_inc(&unit->erp_counter);
 		if (atomic_read(&unit->erp_counter) > ZFCP_MAX_ERPS)
-			zfcp_erp_unit_failed(unit, 21, 0);
+			zfcp_erp_unit_failed(unit, 21, NULL);
 		break;
 	case ZFCP_ERP_EXIT :
 		/* nothing */
@@ -1474,7 +1479,7 @@ zfcp_erp_strategy_check_port(struct zfcp
 	case ZFCP_ERP_FAILED :
 		atomic_inc(&port->erp_counter);
 		if (atomic_read(&port->erp_counter) > ZFCP_MAX_ERPS)
-			zfcp_erp_port_failed(port, 22, 0);
+			zfcp_erp_port_failed(port, 22, NULL);
 		break;
 	case ZFCP_ERP_EXIT :
 		/* nothing */
@@ -1500,7 +1505,7 @@ zfcp_erp_strategy_check_adapter(struct z
 	case ZFCP_ERP_FAILED :
 		atomic_inc(&adapter->erp_counter);
 		if (atomic_read(&adapter->erp_counter) > ZFCP_MAX_ERPS)
-			zfcp_erp_adapter_failed(adapter, 23, 0);
+			zfcp_erp_adapter_failed(adapter, 23, NULL);
 		break;
 	case ZFCP_ERP_EXIT :
 		/* nothing */
@@ -1588,29 +1593,29 @@ zfcp_erp_strategy_followup_actions(int a
=20
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
 		if (status =3D=3D ZFCP_ERP_SUCCEEDED)
-			zfcp_erp_port_reopen_all_internal(adapter, 0, 70, 0);
+			zfcp_erp_port_reopen_all_internal(adapter, 0, 70, NULL);
 		else
-			zfcp_erp_adapter_reopen_internal(adapter, 0, 71, 0);
+			zfcp_erp_adapter_reopen_internal(adapter, 0, 71, NULL);
 		break;
=20
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
 		if (status =3D=3D ZFCP_ERP_SUCCEEDED)
-			zfcp_erp_port_reopen_internal(port, 0, 72, 0);
+			zfcp_erp_port_reopen_internal(port, 0, 72, NULL);
 		else
-			zfcp_erp_adapter_reopen_internal(adapter, 0, 73, 0);
+			zfcp_erp_adapter_reopen_internal(adapter, 0, 73, NULL);
 		break;
=20
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
 		if (status =3D=3D ZFCP_ERP_SUCCEEDED)
-			zfcp_erp_unit_reopen_all_internal(port, 0, 74, 0);
+			zfcp_erp_unit_reopen_all_internal(port, 0, 74, NULL);
 		else
-			zfcp_erp_port_forced_reopen_internal(port, 0, 75, 0);
+			zfcp_erp_port_forced_reopen_internal(port, 0, 75, NULL);
 		break;
=20
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
 		/* Nothing to do if status =3D=3D ZFCP_ERP_SUCCEEDED */
 		if (status !=3D ZFCP_ERP_SUCCEEDED)
-			zfcp_erp_port_reopen_internal(unit->port, 0, 76, 0);
+			zfcp_erp_port_reopen_internal(unit->port, 0, 76, NULL);
 		break;
 	}
=20
@@ -1654,7 +1659,7 @@ zfcp_erp_wait(struct zfcp_adapter *adapt
 }
=20
 void zfcp_erp_modify_adapter_status(struct zfcp_adapter *adapter, u8 i=
d,
-				    u64 ref, u32 mask, int set_or_clear)
+				    void *ref, u32 mask, int set_or_clear)
 {
 	struct zfcp_port *port;
 	u32 changed, common_mask =3D mask & ZFCP_COMMON_FLAGS;
@@ -1682,7 +1687,7 @@ void zfcp_erp_modify_adapter_status(stru
  * purpose:	sets the port and all underlying devices to ERP_FAILED
  *
  */
-void zfcp_erp_modify_port_status(struct zfcp_port *port, u8 id, u64 re=
f,
+void zfcp_erp_modify_port_status(struct zfcp_port *port, u8 id, void *=
ref,
 				 u32 mask, int set_or_clear)
 {
 	struct zfcp_unit *unit;
@@ -1711,7 +1716,7 @@ void zfcp_erp_modify_port_status(struct=20
  * purpose:	sets the unit to ERP_FAILED
  *
  */
-void zfcp_erp_modify_unit_status(struct zfcp_unit *unit, u8 id, u64 re=
f,
+void zfcp_erp_modify_unit_status(struct zfcp_unit *unit, u8 id, void *=
ref,
 				 u32 mask, int set_or_clear)
 {
 	u32 changed;
@@ -1738,7 +1743,7 @@ void zfcp_erp_modify_unit_status(struct=20
  *		<0	- failed to initiate action
  */
 int zfcp_erp_port_reopen_all(struct zfcp_adapter *adapter, int clear_m=
ask,
-			     u8 id, u64 ref)
+			     u8 id, void *ref)
 {
 	int retval;
 	unsigned long flags;
@@ -1754,7 +1759,7 @@ int zfcp_erp_port_reopen_all(struct zfcp
 }
=20
 static int zfcp_erp_port_reopen_all_internal(struct zfcp_adapter *adap=
ter,
-					     int clear_mask, u8 id, u64 ref)
+					     int clear_mask, u8 id, void *ref)
 {
 	int retval =3D 0;
 	struct zfcp_port *port;
@@ -1775,7 +1780,7 @@ static int zfcp_erp_port_reopen_all_inte
  * returns:	FIXME
  */
 static int zfcp_erp_unit_reopen_all_internal(struct zfcp_port *port,
-					     int clear_mask, u8 id, u64 ref)
+					     int clear_mask, u8 id, void *ref)
 {
 	int retval =3D 0;
 	struct zfcp_unit *unit;
@@ -2291,7 +2296,7 @@ zfcp_erp_port_strategy_open_common(struc
 						port->wwpn,
 						zfcp_get_busid_by_adapter(adapter),
 						adapter->peer_wwpn);
-				zfcp_erp_port_failed(port, 25, 0);
+				zfcp_erp_port_failed(port, 25, NULL);
 				retval =3D ZFCP_ERP_FAILED;
 				break;
 			}
@@ -2318,7 +2323,7 @@ zfcp_erp_port_strategy_open_common(struc
 			atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING,
 					&adapter->nameserver_port->status);
 			if (zfcp_erp_port_reopen(adapter->nameserver_port, 0,
-						 77, (u64)erp_action) >=3D 0) {
+						 77, erp_action) >=3D 0) {
 				erp_action->step =3D
 					ZFCP_ERP_STEP_NAMESERVER_OPEN;
 				retval =3D ZFCP_ERP_CONTINUES;
@@ -2349,7 +2354,7 @@ zfcp_erp_port_strategy_open_common(struc
 					       "for port 0x%016Lx "
 					       "(misconfigured WWPN?)\n",
 					       port->wwpn);
-				zfcp_erp_port_failed(port, 26, 0);
+				zfcp_erp_port_failed(port, 26, NULL);
 				retval =3D ZFCP_ERP_EXIT;
 			} else {
 				ZFCP_LOG_DEBUG("nameserver look-up failed for "
@@ -2449,7 +2454,8 @@ zfcp_erp_port_strategy_open_nameserver_w
 			if (atomic_test_mask(
 				    ZFCP_STATUS_COMMON_ERP_FAILED,
 				    &adapter->nameserver_port->status))
-				zfcp_erp_port_failed(erp_action->port, 27, 0);
+				zfcp_erp_port_failed(erp_action->port, 27,
+						     NULL);
 			zfcp_erp_action_ready(erp_action);
 		}
 	}
@@ -2745,7 +2751,7 @@ void zfcp_erp_start_timer(struct zfcp_fs
  */
 static int zfcp_erp_action_enqueue(int want, struct zfcp_adapter *adap=
ter,
 				   struct zfcp_port *port,
-				   struct zfcp_unit *unit, u8 id, u64 ref)
+				   struct zfcp_unit *unit, u8 id, void *ref)
 {
 	int retval =3D 1, need =3D want;
 	struct zfcp_erp_action *erp_action =3D NULL;
@@ -2888,7 +2894,7 @@ static int zfcp_erp_action_enqueue(int w
 	zfcp_rec_dbf_event_thread(1, adapter, 0);
 	retval =3D 0;
  out:
-	zfcp_rec_dbf_event_trigger(id, ref, want, need, (u64)erp_action,
+	zfcp_rec_dbf_event_trigger(id, ref, want, need, erp_action,
 				   adapter, port, unit);
 	return retval;
 }
@@ -3048,7 +3054,7 @@ static void zfcp_erp_action_to_ready(str
 	zfcp_rec_dbf_event_action(146, erp_action);
 }
=20
-void zfcp_erp_port_boxed(struct zfcp_port *port, u8 id, u64 ref)
+void zfcp_erp_port_boxed(struct zfcp_port *port, u8 id, void *ref)
 {
 	unsigned long flags;
=20
@@ -3059,14 +3065,14 @@ void zfcp_erp_port_boxed(struct zfcp_por
 	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
 }
=20
-void zfcp_erp_unit_boxed(struct zfcp_unit *unit, u8 id, u64 ref)
+void zfcp_erp_unit_boxed(struct zfcp_unit *unit, u8 id, void *ref)
 {
 	zfcp_erp_modify_unit_status(unit, id, ref,
 				    ZFCP_STATUS_COMMON_ACCESS_BOXED, ZFCP_SET);
 	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
 }
=20
-void zfcp_erp_port_access_denied(struct zfcp_port *port, u8 id, u64 re=
f)
+void zfcp_erp_port_access_denied(struct zfcp_port *port, u8 id, void *=
ref)
 {
 	unsigned long flags;
=20
@@ -3077,7 +3083,7 @@ void zfcp_erp_port_access_denied(struct=20
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
=20
-void zfcp_erp_unit_access_denied(struct zfcp_unit *unit, u8 id, u64 re=
f)
+void zfcp_erp_unit_access_denied(struct zfcp_unit *unit, u8 id, void *=
ref)
 {
 	zfcp_erp_modify_unit_status(unit, id, ref,
 				    ZFCP_STATUS_COMMON_ERP_FAILED |
@@ -3085,7 +3091,7 @@ void zfcp_erp_unit_access_denied(struct=20
 }
=20
 void zfcp_erp_adapter_access_changed(struct zfcp_adapter *adapter, u8 =
id,
-				     u64 ref)
+				     void *ref)
 {
 	struct zfcp_port *port;
 	unsigned long flags;
@@ -3102,7 +3108,7 @@ void zfcp_erp_adapter_access_changed(str
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
=20
-void zfcp_erp_port_access_changed(struct zfcp_port *port, u8 id, u64 r=
ef)
+void zfcp_erp_port_access_changed(struct zfcp_port *port, u8 id, void =
*ref)
 {
 	struct zfcp_adapter *adapter =3D port->adapter;
 	struct zfcp_unit *unit;
@@ -3126,7 +3132,7 @@ void zfcp_erp_port_access_changed(struct
 				zfcp_get_busid_by_adapter(adapter), port->wwpn);
 }
=20
-void zfcp_erp_unit_access_changed(struct zfcp_unit *unit, u8 id, u64 r=
ef)
+void zfcp_erp_unit_access_changed(struct zfcp_unit *unit, u8 id, void =
*ref)
 {
 	struct zfcp_adapter *adapter =3D unit->port->adapter;
=20
--- a/drivers/s390/scsi/zfcp_ext.h	2008-04-18 12:43:03.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-04-18 12:43:05.000000000 +0200
@@ -131,23 +131,25 @@ extern int zfcp_scsi_command_sync(struct
 extern struct fc_function_template zfcp_transport_functions;
=20
 /******************************** ERP ********************************=
********/
-extern void zfcp_erp_modify_adapter_status(struct zfcp_adapter *, u8, =
u64, u32,
-					   int);
-extern int  zfcp_erp_adapter_reopen(struct zfcp_adapter *, int, u8, u6=
4);
-extern int  zfcp_erp_adapter_shutdown(struct zfcp_adapter *, int, u8, =
u64);
-extern void zfcp_erp_adapter_failed(struct zfcp_adapter *, u8, u64);
-
-extern void zfcp_erp_modify_port_status(struct zfcp_port *, u8, u64, u=
32, int);
-extern int  zfcp_erp_port_reopen(struct zfcp_port *, int, u8, u64);
-extern int  zfcp_erp_port_shutdown(struct zfcp_port *, int, u8, u64);
-extern int  zfcp_erp_port_forced_reopen(struct zfcp_port *, int, u8, u=
64);
-extern void zfcp_erp_port_failed(struct zfcp_port *, u8, u64);
-extern int  zfcp_erp_port_reopen_all(struct zfcp_adapter *, int, u8, u=
64);
-
-extern void zfcp_erp_modify_unit_status(struct zfcp_unit *, u8, u64, u=
32, int);
-extern int  zfcp_erp_unit_reopen(struct zfcp_unit *, int, u8, u64);
-extern int  zfcp_erp_unit_shutdown(struct zfcp_unit *, int, u8, u64);
-extern void zfcp_erp_unit_failed(struct zfcp_unit *, u8, u64);
+extern void zfcp_erp_modify_adapter_status(struct zfcp_adapter *, u8, =
void *,
+					   u32, int);
+extern int  zfcp_erp_adapter_reopen(struct zfcp_adapter *, int, u8, vo=
id *);
+extern int  zfcp_erp_adapter_shutdown(struct zfcp_adapter *, int, u8, =
void *);
+extern void zfcp_erp_adapter_failed(struct zfcp_adapter *, u8, void *)=
;
+
+extern void zfcp_erp_modify_port_status(struct zfcp_port *, u8, void *=
, u32,
+					int);
+extern int  zfcp_erp_port_reopen(struct zfcp_port *, int, u8, void *);
+extern int  zfcp_erp_port_shutdown(struct zfcp_port *, int, u8, void *=
);
+extern int  zfcp_erp_port_forced_reopen(struct zfcp_port *, int, u8, v=
oid *);
+extern void zfcp_erp_port_failed(struct zfcp_port *, u8, void *);
+extern int  zfcp_erp_port_reopen_all(struct zfcp_adapter *, int, u8, v=
oid *);
+
+extern void zfcp_erp_modify_unit_status(struct zfcp_unit *, u8, void *=
, u32,
+					int);
+extern int  zfcp_erp_unit_reopen(struct zfcp_unit *, int, u8, void *);
+extern int  zfcp_erp_unit_shutdown(struct zfcp_unit *, int, u8, void *=
);
+extern void zfcp_erp_unit_failed(struct zfcp_unit *, u8, void *);
=20
 extern int  zfcp_erp_thread_setup(struct zfcp_adapter *);
 extern int  zfcp_erp_thread_kill(struct zfcp_adapter *);
@@ -156,22 +158,22 @@ extern void zfcp_erp_async_handler(struc
=20
 extern int  zfcp_test_link(struct zfcp_port *);
=20
-extern void zfcp_erp_port_boxed(struct zfcp_port *, u8 id, u64 ref);
-extern void zfcp_erp_unit_boxed(struct zfcp_unit *, u8 id, u64 ref);
-extern void zfcp_erp_port_access_denied(struct zfcp_port *, u8 id, u64=
 ref);
-extern void zfcp_erp_unit_access_denied(struct zfcp_unit *, u8 id, u64=
 ref);
-extern void zfcp_erp_adapter_access_changed(struct zfcp_adapter *, u8,=
 u64);
-extern void zfcp_erp_port_access_changed(struct zfcp_port *, u8, u64);
-extern void zfcp_erp_unit_access_changed(struct zfcp_unit *, u8, u64);
+extern void zfcp_erp_port_boxed(struct zfcp_port *, u8 id, void *ref);
+extern void zfcp_erp_unit_boxed(struct zfcp_unit *, u8 id, void *ref);
+extern void zfcp_erp_port_access_denied(struct zfcp_port *, u8 id, voi=
d *ref);
+extern void zfcp_erp_unit_access_denied(struct zfcp_unit *, u8 id, voi=
d *ref);
+extern void zfcp_erp_adapter_access_changed(struct zfcp_adapter *, u8,=
 void *);
+extern void zfcp_erp_port_access_changed(struct zfcp_port *, u8, void =
*);
+extern void zfcp_erp_unit_access_changed(struct zfcp_unit *, u8, void =
*);
=20
 /******************************** AUX ********************************=
********/
 extern void zfcp_rec_dbf_event_thread(u8 id, struct zfcp_adapter *adap=
ter,
 				      int lock);
-extern void zfcp_rec_dbf_event_adapter(u8 id, u64 ref, struct zfcp_ada=
pter *);
-extern void zfcp_rec_dbf_event_port(u8 id, u64 ref, struct zfcp_port *=
port);
-extern void zfcp_rec_dbf_event_unit(u8 id, u64 ref, struct zfcp_unit *=
unit);
-extern void zfcp_rec_dbf_event_trigger(u8 id, u64 ref, u8 want, u8 nee=
d,
-				       u64 action, struct zfcp_adapter *,
+extern void zfcp_rec_dbf_event_adapter(u8 id, void *ref, struct zfcp_a=
dapter *);
+extern void zfcp_rec_dbf_event_port(u8 id, void *ref, struct zfcp_port=
 *port);
+extern void zfcp_rec_dbf_event_unit(u8 id, void *ref, struct zfcp_unit=
 *unit);
+extern void zfcp_rec_dbf_event_trigger(u8 id, void *ref, u8 want, u8 n=
eed,
+				       void *action, struct zfcp_adapter *,
 				       struct zfcp_port *, struct zfcp_unit *);
 extern void zfcp_rec_dbf_event_action(u8 id, struct zfcp_erp_action *)=
;
=20
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-04-18 12:43:03.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-04-18 12:43:05.000000000 +0200
@@ -298,7 +298,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 				zfcp_get_busid_by_adapter(adapter),
 				prot_status_qual->version_error.fsf_version,
 				ZFCP_QTCB_VERSION);
-		zfcp_erp_adapter_shutdown(adapter, 0, 117, (u64)fsf_req);
+		zfcp_erp_adapter_shutdown(adapter, 0, 117, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -309,7 +309,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 				qtcb->prefix.req_seq_no,
 				zfcp_get_busid_by_adapter(adapter),
 				prot_status_qual->sequence_error.exp_req_seq_no);
-		zfcp_erp_adapter_reopen(adapter, 0, 98, (u64)fsf_req);
+		zfcp_erp_adapter_reopen(adapter, 0, 98, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_RETRY;
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -320,7 +320,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 				"that used on adapter %s. "
 				"Stopping all operations on this adapter.\n",
 				zfcp_get_busid_by_adapter(adapter));
-		zfcp_erp_adapter_shutdown(adapter, 0, 118, (u64)fsf_req);
+		zfcp_erp_adapter_shutdown(adapter, 0, 118, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -337,7 +337,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 				*(unsigned long long*)
 				(&qtcb->bottom.support.req_handle),
 					zfcp_get_busid_by_adapter(adapter));
-		zfcp_erp_adapter_shutdown(adapter, 0, 78, (u64)fsf_req);
+		zfcp_erp_adapter_shutdown(adapter, 0, 78, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -345,7 +345,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 		zfcp_fsf_link_down_info_eval(fsf_req, 37,
 					     &prot_status_qual->link_down_info);
 		/* FIXME: reopening adapter now? better wait for link up */
-		zfcp_erp_adapter_reopen(adapter, 0, 79, (u64)fsf_req);
+		zfcp_erp_adapter_reopen(adapter, 0, 79, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -355,13 +355,13 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 			      "Re-starting operations on this adapter.\n",
 			      zfcp_get_busid_by_adapter(adapter));
 		/* All ports should be marked as ready to run again */
-		zfcp_erp_modify_adapter_status(adapter, 28,
-					       0, ZFCP_STATUS_COMMON_RUNNING,
+		zfcp_erp_modify_adapter_status(adapter, 28, NULL,
+					       ZFCP_STATUS_COMMON_RUNNING,
 					       ZFCP_SET);
 		zfcp_erp_adapter_reopen(adapter,
 					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED
 					| ZFCP_STATUS_COMMON_ERP_FAILED,
-					99, (u64)fsf_req);
+					99, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -371,7 +371,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 				"Restarting all operations on this "
 				"adapter.\n",
 				zfcp_get_busid_by_adapter(adapter));
-		zfcp_erp_adapter_reopen(adapter, 0, 100, (u64)fsf_req);
+		zfcp_erp_adapter_reopen(adapter, 0, 100, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_RETRY;
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -384,7 +384,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 				"(debug info 0x%x).\n",
 				zfcp_get_busid_by_adapter(adapter),
 				qtcb->prefix.prot_status);
-		zfcp_erp_adapter_shutdown(adapter, 0, 119, (u64)fsf_req);
+		zfcp_erp_adapter_shutdown(adapter, 0, 119, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 	}
=20
@@ -423,8 +423,7 @@ zfcp_fsf_fsfstatus_eval(struct zfcp_fsf_
 				"(debug info 0x%x).\n",
 				zfcp_get_busid_by_adapter(fsf_req->adapter),
 				fsf_req->qtcb->header.fsf_command);
-		zfcp_erp_adapter_shutdown(fsf_req->adapter, 0, 120,
-					  (u64)fsf_req);
+		zfcp_erp_adapter_shutdown(fsf_req->adapter, 0, 120, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -478,8 +477,7 @@ zfcp_fsf_fsfstatus_qual_eval(struct zfcp
 				"problem on the adapter %s "
 				"Stopping all operations on this adapter. ",
 				zfcp_get_busid_by_adapter(fsf_req->adapter));
-		zfcp_erp_adapter_shutdown(fsf_req->adapter, 0, 121,
-					  (u64)fsf_req);
+		zfcp_erp_adapter_shutdown(fsf_req->adapter, 0, 121, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SQ_ULP_PROGRAMMING_ERROR:
@@ -605,7 +603,7 @@ zfcp_fsf_link_down_info_eval(struct zfcp
 				link_down->vendor_specific_code);
=20
  out:
-	zfcp_erp_adapter_failed(adapter, id, (u64)fsf_req);
+	zfcp_erp_adapter_failed(adapter, id, fsf_req);
 }
=20
 /*
@@ -799,11 +797,11 @@ zfcp_fsf_status_read_port_closed(struct=20
 	switch (status_buffer->status_subtype) {
=20
 	case FSF_STATUS_READ_SUB_CLOSE_PHYS_PORT:
-		zfcp_erp_port_reopen(port, 0, 101, (u64)fsf_req);
+		zfcp_erp_port_reopen(port, 0, 101, fsf_req);
 		break;
=20
 	case FSF_STATUS_READ_SUB_ERROR_PORT:
-		zfcp_erp_port_shutdown(port, 0, 122, (u64)fsf_req);
+		zfcp_erp_port_shutdown(port, 0, 122, fsf_req);
 		break;
=20
 	default:
@@ -929,13 +927,13 @@ zfcp_fsf_status_read_handler(struct zfcp
 				"Restarting operations on this adapter\n",
 				zfcp_get_busid_by_adapter(adapter));
 		/* All ports should be marked as ready to run again */
-		zfcp_erp_modify_adapter_status(adapter, 30, 0,
+		zfcp_erp_modify_adapter_status(adapter, 30, NULL,
 					       ZFCP_STATUS_COMMON_RUNNING,
 					       ZFCP_SET);
 		zfcp_erp_adapter_reopen(adapter,
 					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED
 					| ZFCP_STATUS_COMMON_ERP_FAILED,
-					102, (u64)fsf_req);
+					102, fsf_req);
 		break;
=20
 	case FSF_STATUS_READ_NOTIFICATION_LOST:
@@ -969,14 +967,13 @@ zfcp_fsf_status_read_handler(struct zfcp
=20
 		if (status_buffer->status_subtype &
 		    FSF_STATUS_READ_SUB_ACT_UPDATED)
-			zfcp_erp_adapter_access_changed(adapter, 135,
-							(u64)fsf_req);
+			zfcp_erp_adapter_access_changed(adapter, 135, fsf_req);
 		break;
=20
 	case FSF_STATUS_READ_CFDC_UPDATED:
 		ZFCP_LOG_NORMAL("CFDC has been updated on the adapter %s\n",
 			      zfcp_get_busid_by_adapter(adapter));
-		zfcp_erp_adapter_access_changed(adapter, 136, (u64)fsf_req);
+		zfcp_erp_adapter_access_changed(adapter, 136, fsf_req);
 		break;
=20
 	case FSF_STATUS_READ_CFDC_HARDENED:
@@ -1044,7 +1041,7 @@ zfcp_fsf_status_read_handler(struct zfcp
 			ZFCP_LOG_INFO("restart adapter %s due to status read "
 				      "buffer shortage\n",
 				      zfcp_get_busid_by_adapter(adapter));
-			zfcp_erp_adapter_reopen(adapter, 0, 103, (u64)fsf_req);
+			zfcp_erp_adapter_reopen(adapter, 0, 103, fsf_req);
 		}
 	}
  out:
@@ -1164,7 +1161,7 @@ zfcp_fsf_abort_fcp_command_handler(struc
 				      sizeof (union fsf_status_qual));
 			/* Let's hope this sorts out the mess */
 			zfcp_erp_adapter_reopen(unit->port->adapter, 0, 104,
-						(u64)new_fsf_req);
+						new_fsf_req);
 			new_fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		}
 		break;
@@ -1192,8 +1189,7 @@ zfcp_fsf_abort_fcp_command_handler(struc
 				      fsf_status_qual,
 				      sizeof (union fsf_status_qual));
 			/* Let's hope this sorts out the mess */
-			zfcp_erp_port_reopen(unit->port, 0, 105,
-					     (u64)new_fsf_req);
+			zfcp_erp_port_reopen(unit->port, 0, 105, new_fsf_req);
 			new_fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		}
 		break;
@@ -1207,7 +1203,7 @@ zfcp_fsf_abort_fcp_command_handler(struc
 		ZFCP_LOG_INFO("Remote port 0x%016Lx on adapter %s needs to "
 			      "be reopened\n", unit->port->wwpn,
 			      zfcp_get_busid_by_unit(unit));
-		zfcp_erp_port_boxed(unit->port, 47, (u64)new_fsf_req);
+		zfcp_erp_port_boxed(unit->port, 47, new_fsf_req);
 		new_fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR
 		    | ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -1218,7 +1214,7 @@ zfcp_fsf_abort_fcp_command_handler(struc
                         "to be reopened\n",
                         unit->fcp_lun, unit->port->wwpn,
                         zfcp_get_busid_by_unit(unit));
-		zfcp_erp_unit_boxed(unit, 48, (u64)new_fsf_req);
+		zfcp_erp_unit_boxed(unit, 48, new_fsf_req);
                 new_fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR
                         | ZFCP_STATUS_FSFREQ_RETRY;
                 break;
@@ -1452,7 +1448,7 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 			      zfcp_get_busid_by_port(port),
 			      ZFCP_FC_SERVICE_CLASS_DEFAULT);
 		/* stop operation for this adapter */
-		zfcp_erp_adapter_shutdown(adapter, 0, 123, (u64)fsf_req);
+		zfcp_erp_adapter_shutdown(adapter, 0, 123, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -1492,7 +1488,7 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 				break;
 			}
 		}
-		zfcp_erp_port_access_denied(port, 55, (u64)fsf_req);
+		zfcp_erp_port_access_denied(port, 55, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -1516,7 +1512,7 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_INFO,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		zfcp_erp_adapter_reopen(adapter, 0, 106, (u64)fsf_req);
+		zfcp_erp_adapter_reopen(adapter, 0, 106, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -1524,7 +1520,7 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 		ZFCP_LOG_INFO("port needs to be reopened "
 			      "(adapter %s, port d_id=3D0x%06x)\n",
 			      zfcp_get_busid_by_port(port), port->d_id);
-		zfcp_erp_port_boxed(port, 49, (u64)fsf_req);
+		zfcp_erp_port_boxed(port, 49, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR
 		    | ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -1746,7 +1742,7 @@ static int zfcp_fsf_send_els_handler(str
 			      zfcp_get_busid_by_adapter(adapter),
 			      ZFCP_FC_SERVICE_CLASS_DEFAULT);
 		/* stop operation for this adapter */
-		zfcp_erp_adapter_shutdown(adapter, 0, 124, (u64)fsf_req);
+		zfcp_erp_adapter_shutdown(adapter, 0, 124, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -1842,7 +1838,7 @@ static int zfcp_fsf_send_els_handler(str
 			}
 		}
 		if (port !=3D NULL)
-			zfcp_erp_port_access_denied(port, 56, (u64)fsf_req);
+			zfcp_erp_port_access_denied(port, 56, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -2060,7 +2056,7 @@ zfcp_fsf_exchange_config_evaluate(struct
 				"versions in comparison to this device "
 				"driver (try updated device driver)\n",
 				zfcp_get_busid_by_adapter(adapter));
-		zfcp_erp_adapter_shutdown(adapter, 0, 125, (u64)fsf_req);
+		zfcp_erp_adapter_shutdown(adapter, 0, 125, fsf_req);
 		return -EIO;
 	}
 	if (ZFCP_QTCB_VERSION > bottom->high_qtcb_version) {
@@ -2069,7 +2065,7 @@ zfcp_fsf_exchange_config_evaluate(struct
 				"versions than this device driver uses"
 				"(consider a microcode upgrade)\n",
 				zfcp_get_busid_by_adapter(adapter));
-		zfcp_erp_adapter_shutdown(adapter, 0, 126, (u64)fsf_req);
+		zfcp_erp_adapter_shutdown(adapter, 0, 126, fsf_req);
 		return -EIO;
 	}
 	return 0;
@@ -2115,7 +2111,7 @@ zfcp_fsf_exchange_config_data_handler(st
 					"topology detected at adapter %s "
 					"unsupported, shutting down adapter\n",
 					zfcp_get_busid_by_adapter(adapter));
-			zfcp_erp_adapter_shutdown(adapter, 0, 127, (u64)fsf_req);
+			zfcp_erp_adapter_shutdown(adapter, 0, 127, fsf_req);
 			return -EIO;
 		case FC_PORTTYPE_NPORT:
 			ZFCP_LOG_NORMAL("Switched fabric fibrechannel "
@@ -2130,7 +2126,7 @@ zfcp_fsf_exchange_config_data_handler(st
 					"of a type known to the zfcp "
 					"driver, shutting down adapter\n",
 					zfcp_get_busid_by_adapter(adapter));
-			zfcp_erp_adapter_shutdown(adapter, 0, 128, (u64)fsf_req);
+			zfcp_erp_adapter_shutdown(adapter, 0, 128, fsf_req);
 			return -EIO;
 		}
 		bottom =3D &qtcb->bottom.config;
@@ -2142,7 +2138,7 @@ zfcp_fsf_exchange_config_data_handler(st
 					bottom->max_qtcb_size,
 					zfcp_get_busid_by_adapter(adapter),
 					sizeof(struct fsf_qtcb));
-			zfcp_erp_adapter_shutdown(adapter, 0, 129, (u64)fsf_req);
+			zfcp_erp_adapter_shutdown(adapter, 0, 129, fsf_req);
 			return -EIO;
 		}
 		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
@@ -2159,7 +2155,7 @@ zfcp_fsf_exchange_config_data_handler(st
 			&qtcb->header.fsf_status_qual.link_down_info);
 		break;
 	default:
-		zfcp_erp_adapter_shutdown(adapter, 0, 130, (u64)fsf_req);
+		zfcp_erp_adapter_shutdown(adapter, 0, 130, fsf_req);
 		return -EIO;
 	}
 	return 0;
@@ -2458,7 +2454,7 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 				break;
 			}
 		}
-		zfcp_erp_port_access_denied(port, 57, (u64)fsf_req);
+		zfcp_erp_port_access_denied(port, 57, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -2467,7 +2463,7 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 			      "The remote port 0x%016Lx on adapter %s "
 			      "could not be opened. Disabling it.\n",
 			      port->wwpn, zfcp_get_busid_by_port(port));
-		zfcp_erp_port_failed(port, 31, (u64)fsf_req);
+		zfcp_erp_port_failed(port, 31, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -2487,7 +2483,7 @@ zfcp_fsf_open_port_handler(struct zfcp_f
 					"Disabling it.\n",
 					port->wwpn,
 					zfcp_get_busid_by_port(port));
-			zfcp_erp_port_failed(port, 32, (u64)fsf_req);
+			zfcp_erp_port_failed(port, 32, fsf_req);
 			fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 			break;
 		default:
@@ -2669,7 +2665,7 @@ zfcp_fsf_close_port_handler(struct zfcp_
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 			      (char *) &fsf_req->qtcb->header.fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		zfcp_erp_adapter_reopen(port->adapter, 0, 107, (u64)fsf_req);
+		zfcp_erp_adapter_reopen(port->adapter, 0, 107, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -2684,7 +2680,7 @@ zfcp_fsf_close_port_handler(struct zfcp_
 		ZFCP_LOG_TRACE("remote port 0x016%Lx on adapter %s closed, "
 			       "port handle 0x%x\n", port->wwpn,
 			       zfcp_get_busid_by_port(port), port->handle);
-		zfcp_erp_modify_port_status(port, 33, (u64)fsf_req,
+		zfcp_erp_modify_port_status(port, 33, fsf_req,
 					    ZFCP_STATUS_COMMON_OPEN,
 					    ZFCP_CLEAR);
 		retval =3D 0;
@@ -2806,7 +2802,7 @@ zfcp_fsf_close_physical_port_handler(str
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		zfcp_erp_adapter_reopen(port->adapter, 0, 108, (u64)fsf_req);
+		zfcp_erp_adapter_reopen(port->adapter, 0, 108, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -2827,7 +2823,7 @@ zfcp_fsf_close_physical_port_handler(str
 				break;
 			}
 		}
-		zfcp_erp_port_access_denied(port, 58, (u64)fsf_req);
+		zfcp_erp_port_access_denied(port, 58, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -2837,7 +2833,7 @@ zfcp_fsf_close_physical_port_handler(str
 			       "to close it physically.\n",
 			       port->wwpn,
 			       zfcp_get_busid_by_port(port));
-		zfcp_erp_port_boxed(port, 50, (u64)fsf_req);
+		zfcp_erp_port_boxed(port, 50, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
=20
@@ -3016,8 +3012,7 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 109,
-					(u64)fsf_req);
+		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 109, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -3047,7 +3042,7 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 				break;
 			}
 		}
-		zfcp_erp_unit_access_denied(unit, 59, (u64)fsf_req);
+		zfcp_erp_unit_access_denied(unit, 59, fsf_req);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
                 atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->st=
atus);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
@@ -3057,7 +3052,7 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 		ZFCP_LOG_DEBUG("The remote port 0x%016Lx on adapter %s "
 			       "needs to be reopened\n",
 			       unit->port->wwpn, zfcp_get_busid_by_unit(unit));
-		zfcp_erp_port_boxed(unit->port, 51, (u64)fsf_req);
+		zfcp_erp_port_boxed(unit->port, 51, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -3097,7 +3092,7 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		zfcp_erp_unit_access_denied(unit, 60, (u64)fsf_req);
+		zfcp_erp_unit_access_denied(unit, 60, fsf_req);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_SHARED, &unit->status);
 		atomic_clear_mask(ZFCP_STATUS_UNIT_READONLY, &unit->status);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
@@ -3111,7 +3106,7 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 			      unit->fcp_lun,
 			      unit->port->wwpn,
 			      zfcp_get_busid_by_unit(unit));
-		zfcp_erp_unit_failed(unit, 34, (u64)fsf_req);
+		zfcp_erp_unit_failed(unit, 34, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -3181,17 +3176,15 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
         		if (exclusive && !readwrite) {
                 		ZFCP_LOG_NORMAL("exclusive access of read-only "
 						"unit not supported\n");
-				zfcp_erp_unit_failed(unit, 35, (u64)fsf_req);
+				zfcp_erp_unit_failed(unit, 35, fsf_req);
 				fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
-				zfcp_erp_unit_shutdown(unit, 0, 80,
-						       (u64)fsf_req);
+				zfcp_erp_unit_shutdown(unit, 0, 80, fsf_req);
         		} else if (!exclusive && readwrite) {
                 		ZFCP_LOG_NORMAL("shared access of read-write "
 						"unit not supported\n");
-				zfcp_erp_unit_failed(unit, 36, (u64)fsf_req);
+				zfcp_erp_unit_failed(unit, 36, fsf_req);
 				fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
-				zfcp_erp_unit_shutdown(unit, 0, 81,
-						       (u64)fsf_req);
+				zfcp_erp_unit_shutdown(unit, 0, 81, fsf_req);
         		}
 		}
=20
@@ -3314,8 +3307,7 @@ zfcp_fsf_close_unit_handler(struct zfcp_
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 			      (char *) &fsf_req->qtcb->header.fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 110,
-					(u64)fsf_req);
+		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 110, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -3331,7 +3323,7 @@ zfcp_fsf_close_unit_handler(struct zfcp_
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 			      (char *) &fsf_req->qtcb->header.fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		zfcp_erp_port_reopen(unit->port, 0, 111, (u64)fsf_req);
+		zfcp_erp_port_reopen(unit->port, 0, 111, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -3340,7 +3332,7 @@ zfcp_fsf_close_unit_handler(struct zfcp_
 			       "needs to be reopened\n",
 			       unit->port->wwpn,
 			       zfcp_get_busid_by_unit(unit));
-		zfcp_erp_port_boxed(unit->port, 52, (u64)fsf_req);
+		zfcp_erp_port_boxed(unit->port, 52, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -3534,7 +3526,7 @@ zfcp_fsf_send_fcp_command_task(struct zf
 					zfcp_get_busid_by_unit(unit),
 					unit->port->wwpn,
 					unit->fcp_lun);
-			zfcp_erp_unit_shutdown(unit, 0, 131, (u64)fsf_req);
+			zfcp_erp_unit_shutdown(unit, 0, 131, fsf_req);
 			retval =3D -EINVAL;
 		}
 		goto no_fit;
@@ -3692,8 +3684,7 @@ zfcp_fsf_send_fcp_command_handler(struct
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 112,
-					(u64)fsf_req);
+		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 112, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -3709,7 +3700,7 @@ zfcp_fsf_send_fcp_command_handler(struct
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		zfcp_erp_port_reopen(unit->port, 0, 113, (u64)fsf_req);
+		zfcp_erp_port_reopen(unit->port, 0, 113, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -3725,8 +3716,7 @@ zfcp_fsf_send_fcp_command_handler(struct
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_NORMAL,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 114,
-					(u64)fsf_req);
+		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 114, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -3736,8 +3726,7 @@ zfcp_fsf_send_fcp_command_handler(struct
 			      zfcp_get_busid_by_unit(unit),
 			      ZFCP_FC_SERVICE_CLASS_DEFAULT);
 		/* stop operation for this adapter */
-		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 132,
-					  (u64)fsf_req);
+		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 132, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -3753,7 +3742,7 @@ zfcp_fsf_send_fcp_command_handler(struct
 		ZFCP_HEX_DUMP(ZFCP_LOG_LEVEL_DEBUG,
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
-		zfcp_erp_port_reopen(unit->port, 0, 115, (u64)fsf_req);
+		zfcp_erp_port_reopen(unit->port, 0, 115, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -3775,7 +3764,7 @@ zfcp_fsf_send_fcp_command_handler(struct
 				break;
 			}
 		}
-		zfcp_erp_unit_access_denied(unit, 61, (u64)fsf_req);
+		zfcp_erp_unit_access_denied(unit, 61, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -3788,8 +3777,7 @@ zfcp_fsf_send_fcp_command_handler(struct
 			      zfcp_get_busid_by_unit(unit),
 			      fsf_req->qtcb->bottom.io.data_direction);
 		/* stop operation for this adapter */
-		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 133,
-					  (u64)fsf_req);
+		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 133, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -3802,8 +3790,7 @@ zfcp_fsf_send_fcp_command_handler(struct
 		     zfcp_get_busid_by_unit(unit),
 		     fsf_req->qtcb->bottom.io.fcp_cmnd_length);
 		/* stop operation for this adapter */
-		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 134,
-					  (u64)fsf_req);
+		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 134, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR;
 		break;
=20
@@ -3811,7 +3798,7 @@ zfcp_fsf_send_fcp_command_handler(struct
 		ZFCP_LOG_DEBUG("The remote port 0x%016Lx on adapter %s "
 			       "needs to be reopened\n",
 			       unit->port->wwpn, zfcp_get_busid_by_unit(unit));
-		zfcp_erp_port_boxed(unit->port, 53, (u64)fsf_req);
+		zfcp_erp_port_boxed(unit->port, 53, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -3821,7 +3808,7 @@ zfcp_fsf_send_fcp_command_handler(struct
 				"wwpn=3D0x%016Lx, fcp_lun=3D0x%016Lx)\n",
 				zfcp_get_busid_by_unit(unit),
 				unit->port->wwpn, unit->fcp_lun);
-		zfcp_erp_unit_boxed(unit, 54, (u64)fsf_req);
+		zfcp_erp_unit_boxed(unit, 54, fsf_req);
 		fsf_req->status |=3D ZFCP_STATUS_FSFREQ_ERROR
 			| ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -4681,7 +4668,7 @@ static int zfcp_fsf_req_send(struct zfcp
 		req_queue->free_index -=3D fsf_req->sbal_number;
 		req_queue->free_index +=3D QDIO_MAX_BUFFERS_PER_Q;
 		req_queue->free_index %=3D QDIO_MAX_BUFFERS_PER_Q; /* wrap */
-		zfcp_erp_adapter_reopen(adapter, 0, 116, (u64)fsf_req);
+		zfcp_erp_adapter_reopen(adapter, 0, 116, fsf_req);
 	} else {
 		req_queue->distance_from_int =3D new_distance_from_int;
 		/*
--- a/drivers/s390/scsi/zfcp_scsi.c	2008-04-18 12:43:03.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-04-18 12:43:05.000000000 +0200
@@ -185,7 +185,7 @@ static void zfcp_scsi_slave_destroy(stru
 		atomic_clear_mask(ZFCP_STATUS_UNIT_REGISTERED, &unit->status);
 		sdpnt->hostdata =3D NULL;
 		unit->device =3D NULL;
-		zfcp_erp_unit_failed(unit, 12, 0);
+		zfcp_erp_unit_failed(unit, 12, NULL);
 		zfcp_unit_put(unit);
 	} else
 		ZFCP_LOG_NORMAL("bug: no unit associated with SCSI device at "
@@ -529,7 +529,7 @@ static int zfcp_scsi_eh_host_reset_handl
 		unit->fcp_lun, unit->port->wwpn,
 		zfcp_get_busid_by_adapter(unit->port->adapter));
=20
-	zfcp_erp_adapter_reopen(adapter, 0, 141, (u64)scpnt);
+	zfcp_erp_adapter_reopen(adapter, 0, 141, scpnt);
 	zfcp_erp_wait(adapter);
=20
 	return SUCCESS;
--- a/drivers/s390/scsi/zfcp_ccw.c	2008-04-18 12:43:03.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_ccw.c	2008-04-18 12:43:05.000000000 +0200
@@ -170,9 +170,10 @@ zfcp_ccw_set_online(struct ccw_device *c
 	BUG_ON(!zfcp_reqlist_isempty(adapter));
 	adapter->req_no =3D 0;
=20
-	zfcp_erp_modify_adapter_status(adapter, 10, 0,
+	zfcp_erp_modify_adapter_status(adapter, 10, NULL,
 				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
-	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED, 85, 0=
);
+	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED, 85,
+				NULL);
 	zfcp_erp_wait(adapter);
 	goto out;
=20
@@ -197,7 +198,7 @@ zfcp_ccw_set_offline(struct ccw_device *
=20
 	down(&zfcp_data.config_sema);
 	adapter =3D dev_get_drvdata(&ccw_device->dev);
-	zfcp_erp_adapter_shutdown(adapter, 0, 86, 0);
+	zfcp_erp_adapter_shutdown(adapter, 0, 86, NULL);
 	zfcp_erp_wait(adapter);
 	zfcp_erp_thread_kill(adapter);
 	up(&zfcp_data.config_sema);
@@ -223,21 +224,21 @@ zfcp_ccw_notify(struct ccw_device *ccw_d
 	case CIO_GONE:
 		ZFCP_LOG_NORMAL("adapter %s: device gone\n",
 				zfcp_get_busid_by_adapter(adapter));
-		zfcp_erp_adapter_shutdown(adapter, 0, 87, 0);
+		zfcp_erp_adapter_shutdown(adapter, 0, 87, NULL);
 		break;
 	case CIO_NO_PATH:
 		ZFCP_LOG_NORMAL("adapter %s: no path\n",
 				zfcp_get_busid_by_adapter(adapter));
-		zfcp_erp_adapter_shutdown(adapter, 0, 88, 0);
+		zfcp_erp_adapter_shutdown(adapter, 0, 88, NULL);
 		break;
 	case CIO_OPER:
 		ZFCP_LOG_NORMAL("adapter %s: operational again\n",
 				zfcp_get_busid_by_adapter(adapter));
-		zfcp_erp_modify_adapter_status(adapter, 11, 0,
+		zfcp_erp_modify_adapter_status(adapter, 11, NULL,
 					       ZFCP_STATUS_COMMON_RUNNING,
 					       ZFCP_SET);
-		zfcp_erp_adapter_reopen(adapter,
-					ZFCP_STATUS_COMMON_ERP_FAILED, 89, 0);
+		zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED,
+					89, NULL);
 		break;
 	}
 	zfcp_erp_wait(adapter);
@@ -269,7 +270,7 @@ zfcp_ccw_shutdown(struct ccw_device *cde
=20
 	down(&zfcp_data.config_sema);
 	adapter =3D dev_get_drvdata(&cdev->dev);
-	zfcp_erp_adapter_shutdown(adapter, 0, 90, 0);
+	zfcp_erp_adapter_shutdown(adapter, 0, 90, NULL);
 	zfcp_erp_wait(adapter);
 	up(&zfcp_data.config_sema);
 }
--- a/drivers/s390/scsi/zfcp_qdio.c	2008-04-18 12:43:03.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_qdio.c	2008-04-18 12:43:05.000000000 +0200
@@ -176,7 +176,8 @@ zfcp_qdio_handler_error_check(struct zfc
                 */
 		zfcp_erp_adapter_reopen(adapter,
 					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
-					ZFCP_STATUS_COMMON_ERP_FAILED, 140, 0);
+					ZFCP_STATUS_COMMON_ERP_FAILED, 140,
+					NULL);
 	}
 	return retval;
 }
--- a/drivers/s390/scsi/zfcp_sysfs_adapter.c	2008-04-18 12:43:03.000000=
000 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs_adapter.c	2008-04-18 12:43:05.000000=
000 +0200
@@ -89,7 +89,7 @@ zfcp_sysfs_port_add_store(struct device=20
=20
 	retval =3D 0;
=20
-	zfcp_erp_port_reopen(port, 0, 91, 0);
+	zfcp_erp_port_reopen(port, 0, 91, NULL);
 	zfcp_erp_wait(port->adapter);
 	zfcp_port_put(port);
  out:
@@ -147,7 +147,7 @@ zfcp_sysfs_port_remove_store(struct devi
 		goto out;
 	}
=20
-	zfcp_erp_port_shutdown(port, 0, 92, 0);
+	zfcp_erp_port_shutdown(port, 0, 92, NULL);
 	zfcp_erp_wait(adapter);
 	zfcp_port_put(port);
 	zfcp_port_dequeue(port);
@@ -191,9 +191,10 @@ zfcp_sysfs_adapter_failed_store(struct d
 		goto out;
 	}
=20
-	zfcp_erp_modify_adapter_status(adapter, 44, 0,
+	zfcp_erp_modify_adapter_status(adapter, 44, NULL,
 				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
-	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED, 93, 0=
);
+	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED, 93,
+				NULL);
 	zfcp_erp_wait(adapter);
  out:
 	up(&zfcp_data.config_sema);
--- a/drivers/s390/scsi/zfcp_sysfs_port.c	2008-04-18 12:43:03.000000000=
 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs_port.c	2008-04-18 12:43:05.000000000=
 +0200
@@ -94,7 +94,7 @@ zfcp_sysfs_unit_add_store(struct device=20
=20
 	retval =3D 0;
=20
-	zfcp_erp_unit_reopen(unit, 0, 94, 0);
+	zfcp_erp_unit_reopen(unit, 0, 94, NULL);
 	zfcp_erp_wait(unit->port->adapter);
 	zfcp_unit_put(unit);
  out:
@@ -150,7 +150,7 @@ zfcp_sysfs_unit_remove_store(struct devi
 		goto out;
 	}
=20
-	zfcp_erp_unit_shutdown(unit, 0, 95, 0);
+	zfcp_erp_unit_shutdown(unit, 0, 95, NULL);
 	zfcp_erp_wait(unit->port->adapter);
 	zfcp_unit_put(unit);
 	zfcp_unit_dequeue(unit);
@@ -193,9 +193,9 @@ zfcp_sysfs_port_failed_store(struct devi
 		goto out;
 	}
=20
-	zfcp_erp_modify_port_status(port, 45, 0,
+	zfcp_erp_modify_port_status(port, 45, NULL,
 				    ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
-	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, 96, 0);
+	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, 96, NULL);
 	zfcp_erp_wait(port->adapter);
  out:
 	up(&zfcp_data.config_sema);
--- a/drivers/s390/scsi/zfcp_sysfs_unit.c	2008-04-18 12:43:03.000000000=
 +0200
+++ b/drivers/s390/scsi/zfcp_sysfs_unit.c	2008-04-18 12:43:05.000000000=
 +0200
@@ -94,9 +94,9 @@ zfcp_sysfs_unit_failed_store(struct devi
 		goto out;
 	}
=20
-	zfcp_erp_modify_unit_status(unit, 46, 0,
+	zfcp_erp_modify_unit_status(unit, 46, NULL,
 				    ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
-	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED, 97, 0);
+	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED, 97, NULL);
 	zfcp_erp_wait(unit->port->adapter);
  out:
 	up(&zfcp_data.config_sema);

--=20
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
