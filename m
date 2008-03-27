From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 09/11] zfcp: Trace all triggers of error recovery activity
Date: Thu, 27 Mar 2008 14:22:03 +0100
Message-ID: <20080327133029.681721000@de.ibm.com>
References: <20080327132154.826339000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:25547 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757507AbYC0Nad (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Mar 2008 09:30:33 -0400
Content-Disposition: inline; filename=zfcp_rec_dbf_record_trigger.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Martin Peschke <mp3@de.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Peschke <mp3@de.ibm.com>

This patch allows any recovery event to be traced back to an exact
cause, e.g. a particular request identified by an id (address).

Signed-off-by: Martin Peschke <mp3@de.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_aux.c           |   31 ++--
 drivers/s390/scsi/zfcp_ccw.c           |   12 -
 drivers/s390/scsi/zfcp_dbf.c           |  134 ++++++++++++++++++++
 drivers/s390/scsi/zfcp_def.h           |   14 ++
 drivers/s390/scsi/zfcp_erp.c           |  215 ++++++++++++++++-----------------
 drivers/s390/scsi/zfcp_ext.h           |   25 ++-
 drivers/s390/scsi/zfcp_fsf.c           |  103 +++++++++------
 drivers/s390/scsi/zfcp_qdio.c          |    4 
 drivers/s390/scsi/zfcp_scsi.c          |    2 
 drivers/s390/scsi/zfcp_sysfs_adapter.c |    6 
 drivers/s390/scsi/zfcp_sysfs_port.c    |    6 
 drivers/s390/scsi/zfcp_sysfs_unit.c    |    2 
 12 files changed, 363 insertions(+), 191 deletions(-)

--- a/drivers/s390/scsi/zfcp_erp.c	2008-03-27 13:57:10.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-03-27 13:58:53.000000000 +0100
@@ -26,13 +26,16 @@
 static int zfcp_erp_adisc(struct zfcp_port *);
 static void zfcp_erp_adisc_handler(unsigned long);
 
-static int zfcp_erp_adapter_reopen_internal(struct zfcp_adapter *, int);
-static int zfcp_erp_port_forced_reopen_internal(struct zfcp_port *, int);
-static int zfcp_erp_port_reopen_internal(struct zfcp_port *, int);
-static int zfcp_erp_unit_reopen_internal(struct zfcp_unit *, int);
-
-static int zfcp_erp_port_reopen_all_internal(struct zfcp_adapter *, int);
-static int zfcp_erp_unit_reopen_all_internal(struct zfcp_port *, int);
+static int zfcp_erp_adapter_reopen_internal(struct zfcp_adapter *, int, u8,
+					    u64);
+static int zfcp_erp_port_forced_reopen_internal(struct zfcp_port *, int, u8,
+						u64);
+static int zfcp_erp_port_reopen_internal(struct zfcp_port *, int, u8, u64);
+static int zfcp_erp_unit_reopen_internal(struct zfcp_unit *, int, u8, u64);
+
+static int zfcp_erp_port_reopen_all_internal(struct zfcp_adapter *, int, u8,
+					     u64);
+static int zfcp_erp_unit_reopen_all_internal(struct zfcp_port *, int, u8, u64);
 
 static void zfcp_erp_adapter_block(struct zfcp_adapter *, int);
 static void zfcp_erp_adapter_unblock(struct zfcp_adapter *);
@@ -97,7 +100,8 @@ static void zfcp_erp_action_dismiss_unit
 static void zfcp_erp_action_dismiss(struct zfcp_erp_action *);
 
 static int zfcp_erp_action_enqueue(int, struct zfcp_adapter *,
-				   struct zfcp_port *, struct zfcp_unit *);
+				   struct zfcp_port *, struct zfcp_unit *,
+				   u8 id, u64 ref);
 static int zfcp_erp_action_dequeue(struct zfcp_erp_action *);
 static void zfcp_erp_action_cleanup(int, struct zfcp_adapter *,
 				    struct zfcp_port *, struct zfcp_unit *,
@@ -179,7 +183,7 @@ static void zfcp_close_fsf(struct zfcp_a
 static void zfcp_fsf_request_timeout_handler(unsigned long data)
 {
 	struct zfcp_adapter *adapter = (struct zfcp_adapter *) data;
-	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED);
+	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED, 62, 0);
 }
 
 void zfcp_fsf_start_timer(struct zfcp_fsf_req *fsf_req, unsigned long timeout)
@@ -200,8 +204,8 @@ void zfcp_fsf_start_timer(struct zfcp_fs
  * returns:	0	- initiated action successfully
  *		<0	- failed to initiate action
  */
-static int
-zfcp_erp_adapter_reopen_internal(struct zfcp_adapter *adapter, int clear_mask)
+static int zfcp_erp_adapter_reopen_internal(struct zfcp_adapter *adapter,
+					    int clear_mask, u8 id, u64 ref)
 {
 	int retval;
 
@@ -221,7 +225,7 @@ zfcp_erp_adapter_reopen_internal(struct 
 		goto out;
 	}
 	retval = zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_ADAPTER,
-					 adapter, NULL, NULL);
+					 adapter, NULL, NULL, id, ref);
 
  out:
 	return retval;
@@ -236,56 +240,56 @@ zfcp_erp_adapter_reopen_internal(struct 
  * returns:	0	- initiated action successfully
  *		<0	- failed to initiate action
  */
-int
-zfcp_erp_adapter_reopen(struct zfcp_adapter *adapter, int clear_mask)
+int zfcp_erp_adapter_reopen(struct zfcp_adapter *adapter, int clear_mask,
+			    u8 id, u64 ref)
 {
 	int retval;
 	unsigned long flags;
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	write_lock(&adapter->erp_lock);
-	retval = zfcp_erp_adapter_reopen_internal(adapter, clear_mask);
+	retval = zfcp_erp_adapter_reopen_internal(adapter, clear_mask, id, ref);
 	write_unlock(&adapter->erp_lock);
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 
 	return retval;
 }
 
-int
-zfcp_erp_adapter_shutdown(struct zfcp_adapter *adapter, int clear_mask)
+int zfcp_erp_adapter_shutdown(struct zfcp_adapter *adapter, int clear_mask,
+			      u8 id, u64 ref)
 {
 	int retval;
 
 	retval = zfcp_erp_adapter_reopen(adapter,
 					 ZFCP_STATUS_COMMON_RUNNING |
 					 ZFCP_STATUS_COMMON_ERP_FAILED |
-					 clear_mask);
+					 clear_mask, id, ref);
 
 	return retval;
 }
 
-int
-zfcp_erp_port_shutdown(struct zfcp_port *port, int clear_mask)
+int zfcp_erp_port_shutdown(struct zfcp_port *port, int clear_mask, u8 id,
+			   u64 ref)
 {
 	int retval;
 
 	retval = zfcp_erp_port_reopen(port,
 				      ZFCP_STATUS_COMMON_RUNNING |
 				      ZFCP_STATUS_COMMON_ERP_FAILED |
-				      clear_mask);
+				      clear_mask, id, ref);
 
 	return retval;
 }
 
-int
-zfcp_erp_unit_shutdown(struct zfcp_unit *unit, int clear_mask)
+int zfcp_erp_unit_shutdown(struct zfcp_unit *unit, int clear_mask, u8 id,
+			   u64 ref)
 {
 	int retval;
 
 	retval = zfcp_erp_unit_reopen(unit,
 				      ZFCP_STATUS_COMMON_RUNNING |
 				      ZFCP_STATUS_COMMON_ERP_FAILED |
-				      clear_mask);
+				      clear_mask, id, ref);
 
 	return retval;
 }
@@ -400,7 +404,7 @@ zfcp_erp_adisc_handler(unsigned long dat
 				"(adapter %s, port d_id=0x%06x)\n",
 				zfcp_get_busid_by_adapter(adapter), d_id);
 		debug_text_event(adapter->erp_dbf, 3, "forcreop");
-		if (zfcp_erp_port_forced_reopen(port, 0))
+		if (zfcp_erp_port_forced_reopen(port, 0, 63, 0))
 			ZFCP_LOG_NORMAL("failed reopen of port "
 					"(adapter %s, wwpn=0x%016Lx)\n",
 					zfcp_get_busid_by_port(port),
@@ -427,7 +431,7 @@ zfcp_erp_adisc_handler(unsigned long dat
 				"adisc_resp_wwpn=0x%016Lx)\n",
 				zfcp_get_busid_by_port(port),
 				port->wwpn, (wwn_t) adisc->wwpn);
-		if (zfcp_erp_port_reopen(port, 0))
+		if (zfcp_erp_port_reopen(port, 0, 64, 0))
 			ZFCP_LOG_NORMAL("failed reopen of port "
 					"(adapter %s, wwpn=0x%016Lx)\n",
 					zfcp_get_busid_by_port(port),
@@ -461,7 +465,7 @@ zfcp_test_link(struct zfcp_port *port)
 		ZFCP_LOG_NORMAL("reopen needed for port 0x%016Lx "
 				"on adapter %s\n ", port->wwpn,
 				zfcp_get_busid_by_port(port));
-		retval = zfcp_erp_port_forced_reopen(port, 0);
+		retval = zfcp_erp_port_forced_reopen(port, 0, 65, 0);
 		if (retval != 0) {
 			ZFCP_LOG_NORMAL("reopen of remote port 0x%016Lx "
 					"on adapter %s failed\n", port->wwpn,
@@ -484,8 +488,8 @@ zfcp_test_link(struct zfcp_port *port)
  * returns:	0	- initiated action successfully
  *		<0	- failed to initiate action
  */
-static int
-zfcp_erp_port_forced_reopen_internal(struct zfcp_port *port, int clear_mask)
+static int zfcp_erp_port_forced_reopen_internal(struct zfcp_port *port,
+						int clear_mask, u8 id, u64 ref)
 {
 	int retval;
 	struct zfcp_adapter *adapter = port->adapter;
@@ -509,7 +513,7 @@ zfcp_erp_port_forced_reopen_internal(str
 	}
 
 	retval = zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_PORT_FORCED,
-					 port->adapter, port, NULL);
+					 port->adapter, port, NULL, id, ref);
 
  out:
 	return retval;
@@ -524,8 +528,8 @@ zfcp_erp_port_forced_reopen_internal(str
  * returns:	0	- initiated action successfully
  *		<0	- failed to initiate action
  */
-int
-zfcp_erp_port_forced_reopen(struct zfcp_port *port, int clear_mask)
+int zfcp_erp_port_forced_reopen(struct zfcp_port *port, int clear_mask, u8 id,
+				u64 ref)
 {
 	int retval;
 	unsigned long flags;
@@ -534,7 +538,8 @@ zfcp_erp_port_forced_reopen(struct zfcp_
 	adapter = port->adapter;
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	write_lock(&adapter->erp_lock);
-	retval = zfcp_erp_port_forced_reopen_internal(port, clear_mask);
+	retval = zfcp_erp_port_forced_reopen_internal(port, clear_mask, id,
+						      ref);
 	write_unlock(&adapter->erp_lock);
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 
@@ -551,8 +556,8 @@ zfcp_erp_port_forced_reopen(struct zfcp_
  * returns:	0	- initiated action successfully
  *		<0	- failed to initiate action
  */
-static int
-zfcp_erp_port_reopen_internal(struct zfcp_port *port, int clear_mask)
+static int zfcp_erp_port_reopen_internal(struct zfcp_port *port, int clear_mask,
+					 u8 id, u64 ref)
 {
 	int retval;
 	struct zfcp_adapter *adapter = port->adapter;
@@ -578,7 +583,7 @@ zfcp_erp_port_reopen_internal(struct zfc
 	}
 
 	retval = zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_PORT,
-					 port->adapter, port, NULL);
+					 port->adapter, port, NULL, id, ref);
 
  out:
 	return retval;
@@ -594,8 +599,7 @@ zfcp_erp_port_reopen_internal(struct zfc
  * correct locking. An error recovery task is initiated to do the reopen.
  * To wait for the completion of the reopen zfcp_erp_wait should be used.
  */
-int
-zfcp_erp_port_reopen(struct zfcp_port *port, int clear_mask)
+int zfcp_erp_port_reopen(struct zfcp_port *port, int clear_mask, u8 id, u64 ref)
 {
 	int retval;
 	unsigned long flags;
@@ -603,7 +607,7 @@ zfcp_erp_port_reopen(struct zfcp_port *p
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	write_lock(&adapter->erp_lock);
-	retval = zfcp_erp_port_reopen_internal(port, clear_mask);
+	retval = zfcp_erp_port_reopen_internal(port, clear_mask, id, ref);
 	write_unlock(&adapter->erp_lock);
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 
@@ -620,8 +624,8 @@ zfcp_erp_port_reopen(struct zfcp_port *p
  * returns:	0	- initiated action successfully
  *		<0	- failed to initiate action
  */
-static int
-zfcp_erp_unit_reopen_internal(struct zfcp_unit *unit, int clear_mask)
+static int zfcp_erp_unit_reopen_internal(struct zfcp_unit *unit, int clear_mask,
+					 u8 id, u64 ref)
 {
 	int retval;
 	struct zfcp_adapter *adapter = unit->port->adapter;
@@ -647,7 +651,7 @@ zfcp_erp_unit_reopen_internal(struct zfc
 	}
 
 	retval = zfcp_erp_action_enqueue(ZFCP_ERP_ACTION_REOPEN_UNIT,
-					 unit->port->adapter, unit->port, unit);
+					 adapter, unit->port, unit, id, ref);
  out:
 	return retval;
 }
@@ -662,8 +666,7 @@ zfcp_erp_unit_reopen_internal(struct zfc
  * locking. An error recovery task is initiated to do the reopen.
  * To wait for the completion of the reopen zfcp_erp_wait should be used.
  */
-int
-zfcp_erp_unit_reopen(struct zfcp_unit *unit, int clear_mask)
+int zfcp_erp_unit_reopen(struct zfcp_unit *unit, int clear_mask, u8 id, u64 ref)
 {
 	int retval;
 	unsigned long flags;
@@ -675,7 +678,7 @@ zfcp_erp_unit_reopen(struct zfcp_unit *u
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	write_lock(&adapter->erp_lock);
-	retval = zfcp_erp_unit_reopen_internal(unit, clear_mask);
+	retval = zfcp_erp_unit_reopen_internal(unit, clear_mask, id, ref);
 	write_unlock(&adapter->erp_lock);
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 
@@ -1215,7 +1218,7 @@ zfcp_erp_strategy(struct zfcp_erp_action
 					"restarting I/O on adapter %s "
 					"to free mempool\n",
 					zfcp_get_busid_by_adapter(adapter));
-			zfcp_erp_adapter_reopen_internal(adapter, 0);
+			zfcp_erp_adapter_reopen_internal(adapter, 0, 66, 0);
 		} else {
 		debug_text_event(adapter->erp_dbf, 2, "a_st_memw");
 		retval = zfcp_erp_strategy_memwait(erp_action);
@@ -1499,7 +1502,9 @@ zfcp_erp_strategy_statechange(int action
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
 		if (zfcp_erp_strategy_statechange_detected(&adapter->status,
 							   status)) {
-			zfcp_erp_adapter_reopen_internal(adapter, ZFCP_STATUS_COMMON_ERP_FAILED);
+			zfcp_erp_adapter_reopen_internal(adapter,
+						ZFCP_STATUS_COMMON_ERP_FAILED,
+						67, 0);
 			retval = ZFCP_ERP_EXIT;
 		}
 		break;
@@ -1508,7 +1513,9 @@ zfcp_erp_strategy_statechange(int action
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
 		if (zfcp_erp_strategy_statechange_detected(&port->status,
 							   status)) {
-			zfcp_erp_port_reopen_internal(port, ZFCP_STATUS_COMMON_ERP_FAILED);
+			zfcp_erp_port_reopen_internal(port,
+						ZFCP_STATUS_COMMON_ERP_FAILED,
+						68, 0);
 			retval = ZFCP_ERP_EXIT;
 		}
 		break;
@@ -1516,7 +1523,9 @@ zfcp_erp_strategy_statechange(int action
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
 		if (zfcp_erp_strategy_statechange_detected(&unit->status,
 							   status)) {
-			zfcp_erp_unit_reopen_internal(unit, ZFCP_STATUS_COMMON_ERP_FAILED);
+			zfcp_erp_unit_reopen_internal(unit,
+						ZFCP_STATUS_COMMON_ERP_FAILED,
+						69, 0);
 			retval = ZFCP_ERP_EXIT;
 		}
 		break;
@@ -1700,29 +1709,29 @@ zfcp_erp_strategy_followup_actions(int a
 
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
 		if (status == ZFCP_ERP_SUCCEEDED)
-			zfcp_erp_port_reopen_all_internal(adapter, 0);
+			zfcp_erp_port_reopen_all_internal(adapter, 0, 70, 0);
 		else
-			zfcp_erp_adapter_reopen_internal(adapter, 0);
+			zfcp_erp_adapter_reopen_internal(adapter, 0, 71, 0);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
 		if (status == ZFCP_ERP_SUCCEEDED)
-			zfcp_erp_port_reopen_internal(port, 0);
+			zfcp_erp_port_reopen_internal(port, 0, 72, 0);
 		else
-			zfcp_erp_adapter_reopen_internal(adapter, 0);
+			zfcp_erp_adapter_reopen_internal(adapter, 0, 73, 0);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
 		if (status == ZFCP_ERP_SUCCEEDED)
-			zfcp_erp_unit_reopen_all_internal(port, 0);
+			zfcp_erp_unit_reopen_all_internal(port, 0, 74, 0);
 		else
-			zfcp_erp_port_forced_reopen_internal(port, 0);
+			zfcp_erp_port_forced_reopen_internal(port, 0, 75, 0);
 		break;
 
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
 		/* Nothing to do if status == ZFCP_ERP_SUCCEEDED */
 		if (status != ZFCP_ERP_SUCCEEDED)
-			zfcp_erp_port_reopen_internal(unit->port, 0);
+			zfcp_erp_port_reopen_internal(unit->port, 0, 76, 0);
 		break;
 	}
 
@@ -1863,30 +1872,32 @@ void zfcp_erp_modify_unit_status(struct 
  * returns:	0	- initiated action successfully
  *		<0	- failed to initiate action
  */
-int
-zfcp_erp_port_reopen_all(struct zfcp_adapter *adapter, int clear_mask)
+int zfcp_erp_port_reopen_all(struct zfcp_adapter *adapter, int clear_mask,
+			     u8 id, u64 ref)
 {
 	int retval;
 	unsigned long flags;
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	write_lock(&adapter->erp_lock);
-	retval = zfcp_erp_port_reopen_all_internal(adapter, clear_mask);
+	retval = zfcp_erp_port_reopen_all_internal(adapter, clear_mask, id,
+						   ref);
 	write_unlock(&adapter->erp_lock);
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 
 	return retval;
 }
 
-static int
-zfcp_erp_port_reopen_all_internal(struct zfcp_adapter *adapter, int clear_mask)
+static int zfcp_erp_port_reopen_all_internal(struct zfcp_adapter *adapter,
+					     int clear_mask, u8 id, u64 ref)
 {
 	int retval = 0;
 	struct zfcp_port *port;
 
 	list_for_each_entry(port, &adapter->port_list_head, list)
 		if (!atomic_test_mask(ZFCP_STATUS_PORT_WKA, &port->status))
-			zfcp_erp_port_reopen_internal(port, clear_mask);
+			zfcp_erp_port_reopen_internal(port, clear_mask, id,
+						      ref);
 
 	return retval;
 }
@@ -1898,14 +1909,14 @@ zfcp_erp_port_reopen_all_internal(struct
  *
  * returns:	FIXME
  */
-static int
-zfcp_erp_unit_reopen_all_internal(struct zfcp_port *port, int clear_mask)
+static int zfcp_erp_unit_reopen_all_internal(struct zfcp_port *port,
+					     int clear_mask, u8 id, u64 ref)
 {
 	int retval = 0;
 	struct zfcp_unit *unit;
 
 	list_for_each_entry(unit, &port->unit_list_head, list)
-	    zfcp_erp_unit_reopen_internal(unit, clear_mask);
+		zfcp_erp_unit_reopen_internal(unit, clear_mask, id, ref);
 
 	return retval;
 }
@@ -2466,8 +2477,8 @@ zfcp_erp_port_strategy_open_common(struc
 			/* nameserver port may live again */
 			atomic_set_mask(ZFCP_STATUS_COMMON_RUNNING,
 					&adapter->nameserver_port->status);
-			if (zfcp_erp_port_reopen(adapter->nameserver_port, 0)
-			    >= 0) {
+			if (zfcp_erp_port_reopen(adapter->nameserver_port, 0,
+						 77, (u64)erp_action) >= 0) {
 				erp_action->step =
 					ZFCP_ERP_STEP_NAMESERVER_OPEN;
 				retval = ZFCP_ERP_CONTINUES;
@@ -2963,14 +2974,12 @@ void zfcp_erp_start_timer(struct zfcp_fs
  *
  * returns:
  */
-static int
-zfcp_erp_action_enqueue(int action,
-			struct zfcp_adapter *adapter,
-			struct zfcp_port *port, struct zfcp_unit *unit)
+static int zfcp_erp_action_enqueue(int want, struct zfcp_adapter *adapter,
+				   struct zfcp_port *port,
+				   struct zfcp_unit *unit, u8 id, u64 ref)
 {
-	int retval = 1;
+	int retval = 1, need = want;
 	struct zfcp_erp_action *erp_action = NULL;
-	int stronger_action = 0;
 	u32 status = 0;
 
 	/*
@@ -2989,9 +2998,9 @@ zfcp_erp_action_enqueue(int action,
 			      &adapter->status))
 		return -EIO;
 
-	debug_event(adapter->erp_dbf, 4, &action, sizeof (int));
+	debug_event(adapter->erp_dbf, 4, &want, sizeof (int));
 	/* check whether we really need this */
-	switch (action) {
+	switch (want) {
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
 		if (atomic_test_mask
 		    (ZFCP_STATUS_COMMON_ERP_INUSE, &unit->status)) {
@@ -3009,10 +3018,8 @@ zfcp_erp_action_enqueue(int action,
 			goto out;
 		}
 		if (!atomic_test_mask
-		    (ZFCP_STATUS_COMMON_UNBLOCKED, &port->status)) {
-			stronger_action = ZFCP_ERP_ACTION_REOPEN_PORT;
-			unit = NULL;
-		}
+		    (ZFCP_STATUS_COMMON_UNBLOCKED, &port->status))
+			need = ZFCP_ERP_ACTION_REOPEN_PORT;
 		/* fall through !!! */
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
@@ -3032,7 +3039,7 @@ zfcp_erp_action_enqueue(int action,
 			    ZFCP_ERP_ACTION_REOPEN_PORT_FORCED) {
 				ZFCP_LOG_INFO("dropped erp action %i (port "
 					      "0x%016Lx, action in use: %i)\n",
-					      action, port->wwpn,
+					      want, port->wwpn,
 					      port->erp_action.action);
 				debug_text_event(adapter->erp_dbf, 4,
 						 "pf_actenq_drp");
@@ -3050,10 +3057,8 @@ zfcp_erp_action_enqueue(int action,
 			goto out;
 		}
 		if (!atomic_test_mask
-		    (ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status)) {
-			stronger_action = ZFCP_ERP_ACTION_REOPEN_ADAPTER;
-			port = NULL;
-		}
+		    (ZFCP_STATUS_COMMON_UNBLOCKED, &adapter->status))
+			need = ZFCP_ERP_ACTION_REOPEN_ADAPTER;
 		/* fall through !!! */
 
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
@@ -3066,30 +3071,28 @@ zfcp_erp_action_enqueue(int action,
 
 	default:
 		debug_text_exception(adapter->erp_dbf, 1, "a_actenq_bug");
-		debug_event(adapter->erp_dbf, 1, &action, sizeof (int));
+		debug_event(adapter->erp_dbf, 1, &want, sizeof (int));
 		ZFCP_LOG_NORMAL("bug: unknown erp action requested "
 				"on adapter %s (action=%d)\n",
-				zfcp_get_busid_by_adapter(adapter), action);
+				zfcp_get_busid_by_adapter(adapter), want);
 		goto out;
 	}
 
 	/* check whether we need something stronger first */
-	if (stronger_action) {
+	if (need) {
 		debug_text_event(adapter->erp_dbf, 4, "a_actenq_str");
-		debug_event(adapter->erp_dbf, 4, &stronger_action,
+		debug_event(adapter->erp_dbf, 4, &need,
 			    sizeof (int));
 		ZFCP_LOG_DEBUG("stronger erp action %d needed before "
 			       "erp action %d on adapter %s\n",
-			       stronger_action, action,
-			       zfcp_get_busid_by_adapter(adapter));
-		action = stronger_action;
+			       need, want, zfcp_get_busid_by_adapter(adapter));
 	}
 
 	/* mark adapter to have some error recovery pending */
 	atomic_set_mask(ZFCP_STATUS_ADAPTER_ERP_PENDING, &adapter->status);
 
 	/* setup error recovery action */
-	switch (action) {
+	switch (need) {
 
 	case ZFCP_ERP_ACTION_REOPEN_UNIT:
 		zfcp_unit_get(unit);
@@ -3128,7 +3131,7 @@ zfcp_erp_action_enqueue(int action,
 	erp_action->adapter = adapter;
 	erp_action->port = port;
 	erp_action->unit = unit;
-	erp_action->action = action;
+	erp_action->action = need;
 	erp_action->status = status;
 
 	++adapter->erp_total_count;
@@ -3139,6 +3142,8 @@ zfcp_erp_action_enqueue(int action,
 	zfcp_rec_dbf_event_thread(1, adapter, 0);
 	retval = 0;
  out:
+	zfcp_rec_dbf_event_trigger(id, ref, want, need, (u64)erp_action,
+				   adapter, port, unit);
 	return retval;
 }
 
@@ -3322,7 +3327,7 @@ void zfcp_erp_port_boxed(struct zfcp_por
 	zfcp_erp_modify_port_status(port, id, ref,
 				    ZFCP_STATUS_COMMON_ACCESS_BOXED, ZFCP_SET);
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
-	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED);
+	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
 }
 
 void zfcp_erp_unit_boxed(struct zfcp_unit *unit, u8 id, u64 ref)
@@ -3333,7 +3338,7 @@ void zfcp_erp_unit_boxed(struct zfcp_uni
 	debug_event(adapter->erp_dbf, 3, &unit->fcp_lun, sizeof(fcp_lun_t));
 	zfcp_erp_modify_unit_status(unit, id, ref,
 				    ZFCP_STATUS_COMMON_ACCESS_BOXED, ZFCP_SET);
-	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED);
+	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref);
 }
 
 void zfcp_erp_port_access_denied(struct zfcp_port *port, u8 id, u64 ref)
@@ -3361,8 +3366,8 @@ void zfcp_erp_unit_access_denied(struct 
 				    ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
 }
 
-void
-zfcp_erp_adapter_access_changed(struct zfcp_adapter *adapter)
+void zfcp_erp_adapter_access_changed(struct zfcp_adapter *adapter, u8 id,
+				     u64 ref)
 {
 	struct zfcp_port *port;
 	unsigned long flags;
@@ -3375,15 +3380,14 @@ zfcp_erp_adapter_access_changed(struct z
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	if (adapter->nameserver_port)
-		zfcp_erp_port_access_changed(adapter->nameserver_port);
+		zfcp_erp_port_access_changed(adapter->nameserver_port, id, ref);
 	list_for_each_entry(port, &adapter->port_list_head, list)
 		if (port != adapter->nameserver_port)
-			zfcp_erp_port_access_changed(port);
+			zfcp_erp_port_access_changed(port, id, ref);
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
 
-void
-zfcp_erp_port_access_changed(struct zfcp_port *port)
+void zfcp_erp_port_access_changed(struct zfcp_port *port, u8 id, u64 ref)
 {
 	struct zfcp_adapter *adapter = port->adapter;
 	struct zfcp_unit *unit;
@@ -3397,21 +3401,20 @@ zfcp_erp_port_access_changed(struct zfcp
 			      &port->status)) {
 		if (!atomic_test_mask(ZFCP_STATUS_PORT_WKA, &port->status))
 			list_for_each_entry(unit, &port->unit_list_head, list)
-				zfcp_erp_unit_access_changed(unit);
+				zfcp_erp_unit_access_changed(unit, id, ref);
 		return;
 	}
 
 	ZFCP_LOG_NORMAL("reopen of port 0x%016Lx on adapter %s "
 			"(due to ACT update)\n",
 			port->wwpn, zfcp_get_busid_by_adapter(adapter));
-	if (zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED) != 0)
+	if (zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref))
 		ZFCP_LOG_NORMAL("failed reopen of port"
 				"(adapter %s, wwpn=0x%016Lx)\n",
 				zfcp_get_busid_by_adapter(adapter), port->wwpn);
 }
 
-void
-zfcp_erp_unit_access_changed(struct zfcp_unit *unit)
+void zfcp_erp_unit_access_changed(struct zfcp_unit *unit, u8 id, u64 ref)
 {
 	struct zfcp_adapter *adapter = unit->port->adapter;
 
@@ -3428,7 +3431,7 @@ zfcp_erp_unit_access_changed(struct zfcp
 			" on adapter %s (due to ACT update)\n",
 			unit->fcp_lun, unit->port->wwpn,
 			zfcp_get_busid_by_adapter(adapter));
-	if (zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED) != 0)
+	if (zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED, id, ref))
 		ZFCP_LOG_NORMAL("failed reopen of unit (adapter %s, "
 				"wwpn=0x%016Lx, fcp_lun=0x%016Lx)\n",
 				zfcp_get_busid_by_adapter(adapter),
--- a/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 13:57:10.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_dbf.c	2008-03-27 13:58:53.000000000 +0100
@@ -523,6 +523,7 @@ static struct debug_view zfcp_hba_dbf_vi
 static const char *zfcp_rec_dbf_tags[] = {
 	[ZFCP_REC_DBF_ID_THREAD] = "thread",
 	[ZFCP_REC_DBF_ID_TARGET] = "target",
+	[ZFCP_REC_DBF_ID_TRIGGER] = "trigger",
 };
 
 static const char *zfcp_rec_dbf_ids[] = {
@@ -587,6 +588,89 @@ static const char *zfcp_rec_dbf_ids[] = 
 	[59]	= "unit access denied open unit",
 	[60]	= "shared unit access denied open unit",
 	[61]	= "unit access denied fcp",
+	[62]	= "request timeout",
+	[63]	= "adisc link test reject or timeout",
+	[64]	= "adisc link test d_id changed",
+	[65]	= "adisc link test failed",
+	[66]	= "recovery out of memory",
+	[67]	= "adapter recovery repeated after state change",
+	[68]	= "port recovery repeated after state change",
+	[69]	= "unit recovery repeated after state change",
+	[70]	= "port recovery follow-up after successful adapter recovery",
+	[71]	= "adapter recovery escalation after failed adapter recovery",
+	[72]	= "port recovery follow-up after successful physical port "
+		  "recovery",
+	[73]	= "adapter recovery escalation after failed physical port "
+		  "recovery",
+	[74]	= "unit recovery follow-up after successful port recovery",
+	[75]	= "physical port recovery escalation after failed port "
+		  "recovery",
+	[76]	= "port recovery escalation after failed unit recovery",
+	[77]	= "recovery opening nameserver port",
+	[78]	= "duplicate request id",
+	[79]	= "link down",
+	[80]	= "exclusive read-only unit access unsupported",
+	[81]	= "shared read-write unit access unsupported",
+	[82]	= "incoming rscn",
+	[83]	= "incoming plogi",
+	[84]	= "incoming logo",
+	[85]	= "online",
+	[86]	= "offline",
+	[87]	= "ccw device gone",
+	[88]	= "ccw device no path",
+	[89]	= "ccw device operational",
+	[90]	= "ccw device shutdown",
+	[91]	= "sysfs port addition",
+	[92]	= "sysfs port removal",
+	[93]	= "sysfs adapter recovery",
+	[94]	= "sysfs unit addition",
+	[95]	= "sysfs unit removal",
+	[96]	= "sysfs port recovery",
+	[97]	= "sysfs unit recovery",
+	[98]	= "sequence number mismatch",
+	[99]	= "link up",
+	[100]	= "error state",
+	[101]	= "status read physical port closed",
+	[102]	= "link up status read",
+	[103]	= "too many failed status read buffers",
+	[104]	= "port handle not valid abort",
+	[105]	= "lun handle not valid abort",
+	[106]	= "port handle not valid ct",
+	[107]	= "port handle not valid close port",
+	[108]	= "port handle not valid close physical port",
+	[109]	= "port handle not valid open unit",
+	[110]	= "port handle not valid close unit",
+	[111]	= "lun handle not valid close unit",
+	[112]	= "port handle not valid fcp",
+	[113]	= "lun handle not valid fcp",
+	[114]	= "handle mismatch fcp",
+	[115]	= "lun not valid fcp",
+	[116]	= "qdio send failed",
+	[117]	= "version mismatch",
+	[118]	= "incompatible qtcb type",
+	[119]	= "unknown protocol status",
+	[120]	= "unknown fsf command",
+	[121]	= "no recommendation for status qualifier",
+	[122]	= "status read physical port closed in error",
+	[123]	= "fc service class not supported ct",
+	[124]	= "fc service class not supported els",
+	[125]	= "need newer zfcp",
+	[126]	= "need newer microcode",
+	[127]	= "arbitrated loop not supported",
+	[128]	= "unknown topology",
+	[129]	= "qtcb size mismatch",
+	[130]	= "unknown fsf status ecd",
+	[131]	= "fcp request too big",
+	[132]	= "fc service class not supported fcp",
+	[133]	= "data direction not valid fcp",
+	[134]	= "command length not valid fcp",
+	[135]	= "status read act update",
+	[136]	= "status read cfdc update",
+	[137]	= "hbaapi port open",
+	[138]	= "hbaapi unit open",
+	[139]	= "hbaapi unit shutdown",
+	[140]	= "qdio error",
+	[141]	= "scsi host reset",
 };
 
 static int zfcp_rec_dbf_view_format(debug_info_t *id, struct debug_view *view,
@@ -613,6 +697,17 @@ static int zfcp_rec_dbf_view_format(debu
 		zfcp_dbf_out(&p, "wwpn", "0x%016Lx", r->u.target.wwpn);
 		zfcp_dbf_out(&p, "fcp_lun", "0x%016Lx", r->u.target.fcp_lun);
 		break;
+	case ZFCP_REC_DBF_ID_TRIGGER:
+		zfcp_dbf_out(&p, "reference", "0x%016Lx", r->u.trigger.ref);
+		zfcp_dbf_out(&p, "erp_action", "0x%016Lx", r->u.trigger.action);
+		zfcp_dbf_out(&p, "requested", "%d", r->u.trigger.want);
+		zfcp_dbf_out(&p, "executed", "%d", r->u.trigger.need);
+		zfcp_dbf_out(&p, "wwpn", "0x%016Lx", r->u.trigger.wwpn);
+		zfcp_dbf_out(&p, "fcp_lun", "0x%016Lx", r->u.trigger.fcp_lun);
+		zfcp_dbf_out(&p, "adapter_status", "0x%08x", r->u.trigger.as);
+		zfcp_dbf_out(&p, "port_status", "0x%08x", r->u.trigger.ps);
+		zfcp_dbf_out(&p, "unit_status", "0x%08x", r->u.trigger.us);
+		break;
 	}
 	sprintf(p, "\n");
 	return (p - buf) + 1;
@@ -727,6 +822,45 @@ void zfcp_rec_dbf_event_unit(u8 id, u64 
 				  unit->fcp_lun);
 }
 
+/**
+ * zfcp_rec_dbf_event_trigger - trace event for triggered error recovery
+ * @id2: identifier for error recovery trigger
+ * @ref: additional reference (e.g. request)
+ * @want: originally requested error recovery action
+ * @need: error recovery action actually initiated
+ * @action: address of error recovery action struct
+ * @adapter: adapter
+ * @port: port
+ * @unit: unit
+ */
+void zfcp_rec_dbf_event_trigger(u8 id2, u64 ref, u8 want, u8 need, u64 action,
+				struct zfcp_adapter *adapter,
+				struct zfcp_port *port, struct zfcp_unit *unit)
+{
+	struct zfcp_rec_dbf_record *r = &adapter->rec_dbf_buf;
+	unsigned long flags;
+
+	spin_lock_irqsave(&adapter->rec_dbf_lock, flags);
+	memset(r, 0, sizeof(*r));
+	r->id = ZFCP_REC_DBF_ID_TRIGGER;
+	r->id2 = id2;
+	r->u.trigger.ref = ref;
+	r->u.trigger.want = want;
+	r->u.trigger.need = need;
+	r->u.trigger.action = action;
+	r->u.trigger.as = atomic_read(&adapter->status);
+	if (port) {
+		r->u.trigger.ps = atomic_read(&port->status);
+		r->u.trigger.wwpn = port->wwpn;
+	}
+	if (unit) {
+		r->u.trigger.us = atomic_read(&unit->status);
+		r->u.trigger.fcp_lun = unit->fcp_lun;
+	}
+	debug_event(adapter->rec_dbf, action ? 1 : 4, r, sizeof(*r));
+	spin_unlock_irqrestore(&adapter->rec_dbf_lock, flags);
+}
+
 static void
 _zfcp_san_dbf_event_common_ct(const char *tag, struct zfcp_fsf_req *fsf_req,
 			      u32 s_id, u32 d_id, void *buffer, int buflen)
--- a/drivers/s390/scsi/zfcp_def.h	2008-03-27 13:57:10.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2008-03-27 13:58:54.000000000 +0100
@@ -295,18 +295,32 @@ struct zfcp_rec_dbf_record_target {
 	u32 erp_count;
 } __attribute__ ((packed));
 
+struct zfcp_rec_dbf_record_trigger {
+	u8 want;
+	u8 need;
+	u32 as;
+	u32 ps;
+	u32 us;
+	u64 ref;
+	u64 action;
+	u64 wwpn;
+	u64 fcp_lun;
+} __attribute__ ((packed));
+
 struct zfcp_rec_dbf_record {
 	u8 id;
 	u8 id2;
 	union {
 		struct zfcp_rec_dbf_record_thread thread;
 		struct zfcp_rec_dbf_record_target target;
+		struct zfcp_rec_dbf_record_trigger trigger;
 	} u;
 } __attribute__ ((packed));
 
 enum {
 	ZFCP_REC_DBF_ID_THREAD,
 	ZFCP_REC_DBF_ID_TARGET,
+	ZFCP_REC_DBF_ID_TRIGGER,
 };
 
 struct zfcp_hba_dbf_record_response {
--- a/drivers/s390/scsi/zfcp_aux.c	2008-03-27 13:56:52.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_aux.c	2008-03-27 13:58:54.000000000 +0100
@@ -1326,10 +1326,10 @@ zfcp_nameserver_enqueue(struct zfcp_adap
 
 #define ZFCP_LOG_AREA                   ZFCP_LOG_AREA_FC
 
-static void
-zfcp_fsf_incoming_els_rscn(struct zfcp_adapter *adapter,
-			   struct fsf_status_read_buffer *status_buffer)
+static void zfcp_fsf_incoming_els_rscn(struct zfcp_fsf_req *fsf_req)
 {
+	struct fsf_status_read_buffer *status_buffer = (void*)fsf_req->data;
+	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct fcp_rscn_head *fcp_rscn_head;
 	struct fcp_rscn_element *fcp_rscn_element;
 	struct zfcp_port *port;
@@ -1376,7 +1376,8 @@ zfcp_fsf_incoming_els_rscn(struct zfcp_a
 				ZFCP_LOG_INFO("incoming RSCN, trying to open "
 					      "port 0x%016Lx\n", port->wwpn);
 				zfcp_erp_port_reopen(port,
-						     ZFCP_STATUS_COMMON_ERP_FAILED);
+						     ZFCP_STATUS_COMMON_ERP_FAILED,
+						     82, (u64)fsf_req);
 				continue;
 			}
 
@@ -1407,10 +1408,10 @@ zfcp_fsf_incoming_els_rscn(struct zfcp_a
 	}
 }
 
-static void
-zfcp_fsf_incoming_els_plogi(struct zfcp_adapter *adapter,
-			    struct fsf_status_read_buffer *status_buffer)
+static void zfcp_fsf_incoming_els_plogi(struct zfcp_fsf_req *fsf_req)
 {
+	struct fsf_status_read_buffer *status_buffer = (void*)fsf_req->data;
+	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct fsf_plogi *els_plogi;
 	struct zfcp_port *port;
 	unsigned long flags;
@@ -1429,14 +1430,14 @@ zfcp_fsf_incoming_els_plogi(struct zfcp_
 			       status_buffer->d_id,
 			       zfcp_get_busid_by_adapter(adapter));
 	} else {
-		zfcp_erp_port_forced_reopen(port, 0);
+		zfcp_erp_port_forced_reopen(port, 0, 83, (u64)fsf_req);
 	}
 }
 
-static void
-zfcp_fsf_incoming_els_logo(struct zfcp_adapter *adapter,
-			   struct fsf_status_read_buffer *status_buffer)
+static void zfcp_fsf_incoming_els_logo(struct zfcp_fsf_req *fsf_req)
 {
+	struct fsf_status_read_buffer *status_buffer = (void*)fsf_req->data;
+	struct zfcp_adapter *adapter = fsf_req->adapter;
 	struct fcp_logo *els_logo = (struct fcp_logo *) status_buffer->payload;
 	struct zfcp_port *port;
 	unsigned long flags;
@@ -1454,7 +1455,7 @@ zfcp_fsf_incoming_els_logo(struct zfcp_a
 			       status_buffer->d_id,
 			       zfcp_get_busid_by_adapter(adapter));
 	} else {
-		zfcp_erp_port_forced_reopen(port, 0);
+		zfcp_erp_port_forced_reopen(port, 0, 84, (u64)fsf_req);
 	}
 }
 
@@ -1481,12 +1482,12 @@ zfcp_fsf_incoming_els(struct zfcp_fsf_re
 
 	zfcp_san_dbf_event_incoming_els(fsf_req);
 	if (els_type == LS_PLOGI)
-		zfcp_fsf_incoming_els_plogi(adapter, status_buffer);
+		zfcp_fsf_incoming_els_plogi(fsf_req);
 	else if (els_type == LS_LOGO)
-		zfcp_fsf_incoming_els_logo(adapter, status_buffer);
+		zfcp_fsf_incoming_els_logo(fsf_req);
 	else if ((els_type & 0xffff0000) == LS_RSCN)
 		/* we are only concerned with the command, not the length */
-		zfcp_fsf_incoming_els_rscn(adapter, status_buffer);
+		zfcp_fsf_incoming_els_rscn(fsf_req);
 	else
 		zfcp_fsf_incoming_els_unknown(adapter, status_buffer);
 }
--- a/drivers/s390/scsi/zfcp_ccw.c	2008-03-27 13:57:10.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ccw.c	2008-03-27 13:58:54.000000000 +0100
@@ -172,7 +172,7 @@ zfcp_ccw_set_online(struct ccw_device *c
 
 	zfcp_erp_modify_adapter_status(adapter, 10, 0,
 				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
-	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED);
+	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED, 85, 0);
 	zfcp_erp_wait(adapter);
 	goto out;
 
@@ -197,7 +197,7 @@ zfcp_ccw_set_offline(struct ccw_device *
 
 	down(&zfcp_data.config_sema);
 	adapter = dev_get_drvdata(&ccw_device->dev);
-	zfcp_erp_adapter_shutdown(adapter, 0);
+	zfcp_erp_adapter_shutdown(adapter, 0, 86, 0);
 	zfcp_erp_wait(adapter);
 	zfcp_erp_thread_kill(adapter);
 	up(&zfcp_data.config_sema);
@@ -224,13 +224,13 @@ zfcp_ccw_notify(struct ccw_device *ccw_d
 		ZFCP_LOG_NORMAL("adapter %s: device gone\n",
 				zfcp_get_busid_by_adapter(adapter));
 		debug_text_event(adapter->erp_dbf,1,"dev_gone");
-		zfcp_erp_adapter_shutdown(adapter, 0);
+		zfcp_erp_adapter_shutdown(adapter, 0, 87, 0);
 		break;
 	case CIO_NO_PATH:
 		ZFCP_LOG_NORMAL("adapter %s: no path\n",
 				zfcp_get_busid_by_adapter(adapter));
 		debug_text_event(adapter->erp_dbf,1,"no_path");
-		zfcp_erp_adapter_shutdown(adapter, 0);
+		zfcp_erp_adapter_shutdown(adapter, 0, 88, 0);
 		break;
 	case CIO_OPER:
 		ZFCP_LOG_NORMAL("adapter %s: operational again\n",
@@ -240,7 +240,7 @@ zfcp_ccw_notify(struct ccw_device *ccw_d
 					       ZFCP_STATUS_COMMON_RUNNING,
 					       ZFCP_SET);
 		zfcp_erp_adapter_reopen(adapter,
-					ZFCP_STATUS_COMMON_ERP_FAILED);
+					ZFCP_STATUS_COMMON_ERP_FAILED, 89, 0);
 		break;
 	}
 	zfcp_erp_wait(adapter);
@@ -272,7 +272,7 @@ zfcp_ccw_shutdown(struct ccw_device *cde
 
 	down(&zfcp_data.config_sema);
 	adapter = dev_get_drvdata(&cdev->dev);
-	zfcp_erp_adapter_shutdown(adapter, 0);
+	zfcp_erp_adapter_shutdown(adapter, 0, 90, 0);
 	zfcp_erp_wait(adapter);
 	up(&zfcp_data.config_sema);
 }
--- a/drivers/s390/scsi/zfcp_sysfs_adapter.c	2008-03-27 13:57:10.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_sysfs_adapter.c	2008-03-27 13:58:54.000000000 +0100
@@ -89,7 +89,7 @@ zfcp_sysfs_port_add_store(struct device 
 
 	retval = 0;
 
-	zfcp_erp_port_reopen(port, 0);
+	zfcp_erp_port_reopen(port, 0, 91, 0);
 	zfcp_erp_wait(port->adapter);
 	zfcp_port_put(port);
  out:
@@ -147,7 +147,7 @@ zfcp_sysfs_port_remove_store(struct devi
 		goto out;
 	}
 
-	zfcp_erp_port_shutdown(port, 0);
+	zfcp_erp_port_shutdown(port, 0, 92, 0);
 	zfcp_erp_wait(adapter);
 	zfcp_port_put(port);
 	zfcp_port_dequeue(port);
@@ -193,7 +193,7 @@ zfcp_sysfs_adapter_failed_store(struct d
 
 	zfcp_erp_modify_adapter_status(adapter, 44, 0,
 				       ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
-	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED);
+	zfcp_erp_adapter_reopen(adapter, ZFCP_STATUS_COMMON_ERP_FAILED, 93, 0);
 	zfcp_erp_wait(adapter);
  out:
 	up(&zfcp_data.config_sema);
--- a/drivers/s390/scsi/zfcp_sysfs_port.c	2008-03-27 13:57:10.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_sysfs_port.c	2008-03-27 13:58:54.000000000 +0100
@@ -94,7 +94,7 @@ zfcp_sysfs_unit_add_store(struct device 
 
 	retval = 0;
 
-	zfcp_erp_unit_reopen(unit, 0);
+	zfcp_erp_unit_reopen(unit, 0, 94, 0);
 	zfcp_erp_wait(unit->port->adapter);
 	zfcp_unit_put(unit);
  out:
@@ -150,7 +150,7 @@ zfcp_sysfs_unit_remove_store(struct devi
 		goto out;
 	}
 
-	zfcp_erp_unit_shutdown(unit, 0);
+	zfcp_erp_unit_shutdown(unit, 0, 95, 0);
 	zfcp_erp_wait(unit->port->adapter);
 	zfcp_unit_put(unit);
 	zfcp_unit_dequeue(unit);
@@ -195,7 +195,7 @@ zfcp_sysfs_port_failed_store(struct devi
 
 	zfcp_erp_modify_port_status(port, 45, 0,
 				    ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
-	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED);
+	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED, 96, 0);
 	zfcp_erp_wait(port->adapter);
  out:
 	up(&zfcp_data.config_sema);
--- a/drivers/s390/scsi/zfcp_sysfs_unit.c	2008-03-27 13:57:10.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_sysfs_unit.c	2008-03-27 13:58:54.000000000 +0100
@@ -96,7 +96,7 @@ zfcp_sysfs_unit_failed_store(struct devi
 
 	zfcp_erp_modify_unit_status(unit, 46, 0,
 				    ZFCP_STATUS_COMMON_RUNNING, ZFCP_SET);
-	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED);
+	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED, 97, 0);
 	zfcp_erp_wait(unit->port->adapter);
  out:
 	up(&zfcp_data.config_sema);
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-03-27 13:58:36.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-03-27 14:00:49.000000000 +0100
@@ -298,7 +298,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 				zfcp_get_busid_by_adapter(adapter),
 				prot_status_qual->version_error.fsf_version,
 				ZFCP_QTCB_VERSION);
-		zfcp_erp_adapter_shutdown(adapter, 0);
+		zfcp_erp_adapter_shutdown(adapter, 0, 117, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -309,7 +309,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 				qtcb->prefix.req_seq_no,
 				zfcp_get_busid_by_adapter(adapter),
 				prot_status_qual->sequence_error.exp_req_seq_no);
-		zfcp_erp_adapter_reopen(adapter, 0);
+		zfcp_erp_adapter_reopen(adapter, 0, 98, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_RETRY;
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -320,7 +320,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 				"that used on adapter %s. "
 				"Stopping all operations on this adapter.\n",
 				zfcp_get_busid_by_adapter(adapter));
-		zfcp_erp_adapter_shutdown(adapter, 0);
+		zfcp_erp_adapter_shutdown(adapter, 0, 118, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -337,14 +337,15 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 				*(unsigned long long*)
 				(&qtcb->bottom.support.req_handle),
 					zfcp_get_busid_by_adapter(adapter));
-		zfcp_erp_adapter_shutdown(adapter, 0);
+		zfcp_erp_adapter_shutdown(adapter, 0, 78, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
 	case FSF_PROT_LINK_DOWN:
 		zfcp_fsf_link_down_info_eval(fsf_req, 37,
 					     &prot_status_qual->link_down_info);
-		zfcp_erp_adapter_reopen(adapter, 0);
+		/* FIXME: reopening adapter now? better wait for link up */
+		zfcp_erp_adapter_reopen(adapter, 0, 79, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -359,7 +360,8 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 					       ZFCP_SET);
 		zfcp_erp_adapter_reopen(adapter,
 					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED
-					| ZFCP_STATUS_COMMON_ERP_FAILED);
+					| ZFCP_STATUS_COMMON_ERP_FAILED,
+					99, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -369,7 +371,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 				"Restarting all operations on this "
 				"adapter.\n",
 				zfcp_get_busid_by_adapter(adapter));
-		zfcp_erp_adapter_reopen(adapter, 0);
+		zfcp_erp_adapter_reopen(adapter, 0, 100, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_RETRY;
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
@@ -382,7 +384,7 @@ zfcp_fsf_protstatus_eval(struct zfcp_fsf
 				"(debug info 0x%x).\n",
 				zfcp_get_busid_by_adapter(adapter),
 				qtcb->prefix.prot_status);
-		zfcp_erp_adapter_shutdown(adapter, 0);
+		zfcp_erp_adapter_shutdown(adapter, 0, 119, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 	}
 
@@ -421,7 +423,8 @@ zfcp_fsf_fsfstatus_eval(struct zfcp_fsf_
 				"(debug info 0x%x).\n",
 				zfcp_get_busid_by_adapter(fsf_req->adapter),
 				fsf_req->qtcb->header.fsf_command);
-		zfcp_erp_adapter_shutdown(fsf_req->adapter, 0);
+		zfcp_erp_adapter_shutdown(fsf_req->adapter, 0, 120,
+					  (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -475,7 +478,8 @@ zfcp_fsf_fsfstatus_qual_eval(struct zfcp
 				"problem on the adapter %s "
 				"Stopping all operations on this adapter. ",
 				zfcp_get_busid_by_adapter(fsf_req->adapter));
-		zfcp_erp_adapter_shutdown(fsf_req->adapter, 0);
+		zfcp_erp_adapter_shutdown(fsf_req->adapter, 0, 121,
+					  (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 	case FSF_SQ_ULP_PROGRAMMING_ERROR:
@@ -796,12 +800,12 @@ zfcp_fsf_status_read_port_closed(struct 
 
 	case FSF_STATUS_READ_SUB_CLOSE_PHYS_PORT:
 		debug_text_event(adapter->erp_dbf, 3, "unsol_pc_phys:");
-		zfcp_erp_port_reopen(port, 0);
+		zfcp_erp_port_reopen(port, 0, 101, (u64)fsf_req);
 		break;
 
 	case FSF_STATUS_READ_SUB_ERROR_PORT:
 		debug_text_event(adapter->erp_dbf, 1, "unsol_pc_err:");
-		zfcp_erp_port_shutdown(port, 0);
+		zfcp_erp_port_shutdown(port, 0, 122, (u64)fsf_req);
 		break;
 
 	default:
@@ -935,7 +939,8 @@ zfcp_fsf_status_read_handler(struct zfcp
 					       ZFCP_SET);
 		zfcp_erp_adapter_reopen(adapter,
 					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED
-					| ZFCP_STATUS_COMMON_ERP_FAILED);
+					| ZFCP_STATUS_COMMON_ERP_FAILED,
+					102, (u64)fsf_req);
 		break;
 
 	case FSF_STATUS_READ_NOTIFICATION_LOST:
@@ -969,13 +974,14 @@ zfcp_fsf_status_read_handler(struct zfcp
 
 		if (status_buffer->status_subtype &
 		    FSF_STATUS_READ_SUB_ACT_UPDATED)
-			zfcp_erp_adapter_access_changed(adapter);
+			zfcp_erp_adapter_access_changed(adapter, 135,
+							(u64)fsf_req);
 		break;
 
 	case FSF_STATUS_READ_CFDC_UPDATED:
 		ZFCP_LOG_NORMAL("CFDC has been updated on the adapter %s\n",
 			      zfcp_get_busid_by_adapter(adapter));
-		zfcp_erp_adapter_access_changed(adapter);
+		zfcp_erp_adapter_access_changed(adapter, 136, (u64)fsf_req);
 		break;
 
 	case FSF_STATUS_READ_CFDC_HARDENED:
@@ -1044,7 +1050,7 @@ zfcp_fsf_status_read_handler(struct zfcp
 			ZFCP_LOG_INFO("restart adapter %s due to status read "
 				      "buffer shortage\n",
 				      zfcp_get_busid_by_adapter(adapter));
-			zfcp_erp_adapter_reopen(adapter, 0);
+			zfcp_erp_adapter_reopen(adapter, 0, 103, (u64)fsf_req);
 		}
 	}
  out:
@@ -1167,7 +1173,8 @@ zfcp_fsf_abort_fcp_command_handler(struc
 			/* Let's hope this sorts out the mess */
 			debug_text_event(new_fsf_req->adapter->erp_dbf, 1,
 					 "fsf_s_phand_nv1");
-			zfcp_erp_adapter_reopen(unit->port->adapter, 0);
+			zfcp_erp_adapter_reopen(unit->port->adapter, 0, 104,
+						(u64)new_fsf_req);
 			new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		}
 		break;
@@ -1199,7 +1206,8 @@ zfcp_fsf_abort_fcp_command_handler(struc
 			/* Let's hope this sorts out the mess */
 			debug_text_event(new_fsf_req->adapter->erp_dbf, 1,
 					 "fsf_s_lhand_nv1");
-			zfcp_erp_port_reopen(unit->port, 0);
+			zfcp_erp_port_reopen(unit->port, 0, 105,
+					     (u64)new_fsf_req);
 			new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		}
 		break;
@@ -1478,7 +1486,7 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 			      ZFCP_FC_SERVICE_CLASS_DEFAULT);
 		/* stop operation for this adapter */
 		debug_text_exception(adapter->erp_dbf, 0, "fsf_s_class_nsup");
-		zfcp_erp_adapter_shutdown(adapter, 0);
+		zfcp_erp_adapter_shutdown(adapter, 0, 123, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -1547,7 +1555,7 @@ zfcp_fsf_send_ct_handler(struct zfcp_fsf
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
 		debug_text_event(adapter->erp_dbf, 1, "fsf_s_phandle_nv");
-		zfcp_erp_adapter_reopen(adapter, 0);
+		zfcp_erp_adapter_reopen(adapter, 0, 106, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -1782,7 +1790,7 @@ static int zfcp_fsf_send_els_handler(str
 			      ZFCP_FC_SERVICE_CLASS_DEFAULT);
 		/* stop operation for this adapter */
 		debug_text_exception(adapter->erp_dbf, 0, "fsf_s_class_nsup");
-		zfcp_erp_adapter_shutdown(adapter, 0);
+		zfcp_erp_adapter_shutdown(adapter, 0, 124, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -2104,7 +2112,7 @@ zfcp_fsf_exchange_config_evaluate(struct
 				"driver (try updated device driver)\n",
 				zfcp_get_busid_by_adapter(adapter));
 		debug_text_event(adapter->erp_dbf, 0, "low_qtcb_ver");
-		zfcp_erp_adapter_shutdown(adapter, 0);
+		zfcp_erp_adapter_shutdown(adapter, 0, 125, (u64)fsf_req);
 		return -EIO;
 	}
 	if (ZFCP_QTCB_VERSION > bottom->high_qtcb_version) {
@@ -2114,7 +2122,7 @@ zfcp_fsf_exchange_config_evaluate(struct
 				"(consider a microcode upgrade)\n",
 				zfcp_get_busid_by_adapter(adapter));
 		debug_text_event(adapter->erp_dbf, 0, "high_qtcb_ver");
-		zfcp_erp_adapter_shutdown(adapter, 0);
+		zfcp_erp_adapter_shutdown(adapter, 0, 126, (u64)fsf_req);
 		return -EIO;
 	}
 	return 0;
@@ -2164,7 +2172,7 @@ zfcp_fsf_exchange_config_data_handler(st
 					zfcp_get_busid_by_adapter(adapter));
 			debug_text_event(fsf_req->adapter->erp_dbf, 0,
 					 "top-al");
-			zfcp_erp_adapter_shutdown(adapter, 0);
+			zfcp_erp_adapter_shutdown(adapter, 0, 127, (u64)fsf_req);
 			return -EIO;
 		case FC_PORTTYPE_NPORT:
 			ZFCP_LOG_NORMAL("Switched fabric fibrechannel "
@@ -2181,7 +2189,7 @@ zfcp_fsf_exchange_config_data_handler(st
 					zfcp_get_busid_by_adapter(adapter));
 			debug_text_exception(fsf_req->adapter->erp_dbf, 0,
 					     "unknown-topo");
-			zfcp_erp_adapter_shutdown(adapter, 0);
+			zfcp_erp_adapter_shutdown(adapter, 0, 128, (u64)fsf_req);
 			return -EIO;
 		}
 		bottom = &qtcb->bottom.config;
@@ -2197,7 +2205,7 @@ zfcp_fsf_exchange_config_data_handler(st
 					 "qtcb-size");
 			debug_event(fsf_req->adapter->erp_dbf, 0,
 				    &bottom->max_qtcb_size, sizeof (u32));
-			zfcp_erp_adapter_shutdown(adapter, 0);
+			zfcp_erp_adapter_shutdown(adapter, 0, 129, (u64)fsf_req);
 			return -EIO;
 		}
 		atomic_set_mask(ZFCP_STATUS_ADAPTER_XCONFIG_OK,
@@ -2219,7 +2227,7 @@ zfcp_fsf_exchange_config_data_handler(st
 		debug_text_event(fsf_req->adapter->erp_dbf, 0, "fsf-stat-ng");
 		debug_event(fsf_req->adapter->erp_dbf, 0,
 			    &fsf_req->qtcb->header.fsf_status, sizeof(u32));
-		zfcp_erp_adapter_shutdown(adapter, 0);
+		zfcp_erp_adapter_shutdown(adapter, 0, 130, (u64)fsf_req);
 		return -EIO;
 	}
 	return 0;
@@ -2760,7 +2768,7 @@ zfcp_fsf_close_port_handler(struct zfcp_
 			      sizeof (union fsf_status_qual));
 		debug_text_event(fsf_req->adapter->erp_dbf, 1,
 				 "fsf_s_phand_nv");
-		zfcp_erp_adapter_reopen(port->adapter, 0);
+		zfcp_erp_adapter_reopen(port->adapter, 0, 107, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -2903,7 +2911,7 @@ zfcp_fsf_close_physical_port_handler(str
 			      sizeof (union fsf_status_qual));
 		debug_text_event(fsf_req->adapter->erp_dbf, 1,
 				 "fsf_s_phand_nv");
-		zfcp_erp_adapter_reopen(port->adapter, 0);
+		zfcp_erp_adapter_reopen(port->adapter, 0, 108, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3128,7 +3136,8 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 			      (char *) &header->fsf_status_qual,
 			      sizeof (union fsf_status_qual));
 		debug_text_event(adapter->erp_dbf, 1, "fsf_s_ph_nv");
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0);
+		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 109,
+					(u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3311,13 +3320,15 @@ zfcp_fsf_open_unit_handler(struct zfcp_f
 						"unit not supported\n");
 				zfcp_erp_unit_failed(unit, 35, (u64)fsf_req);
 				fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-				zfcp_erp_unit_shutdown(unit, 0);
+				zfcp_erp_unit_shutdown(unit, 0, 80,
+						       (u64)fsf_req);
         		} else if (!exclusive && readwrite) {
                 		ZFCP_LOG_NORMAL("shared access of read-write "
 						"unit not supported\n");
 				zfcp_erp_unit_failed(unit, 36, (u64)fsf_req);
 				fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
-				zfcp_erp_unit_shutdown(unit, 0);
+				zfcp_erp_unit_shutdown(unit, 0, 81,
+						       (u64)fsf_req);
         		}
 		}
 
@@ -3445,7 +3456,8 @@ zfcp_fsf_close_unit_handler(struct zfcp_
 			      sizeof (union fsf_status_qual));
 		debug_text_event(fsf_req->adapter->erp_dbf, 1,
 				 "fsf_s_phand_nv");
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0);
+		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 110,
+					(u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3463,7 +3475,7 @@ zfcp_fsf_close_unit_handler(struct zfcp_
 			      sizeof (union fsf_status_qual));
 		debug_text_event(fsf_req->adapter->erp_dbf, 1,
 				 "fsf_s_lhand_nv");
-		zfcp_erp_port_reopen(unit->port, 0);
+		zfcp_erp_port_reopen(unit->port, 0, 111, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3681,7 +3693,7 @@ zfcp_fsf_send_fcp_command_task(struct zf
 					zfcp_get_busid_by_unit(unit),
 					unit->port->wwpn,
 					unit->fcp_lun);
-			zfcp_erp_unit_shutdown(unit, 0);
+			zfcp_erp_unit_shutdown(unit, 0, 131, (u64)fsf_req);
 			retval = -EINVAL;
 		}
 		goto no_fit;
@@ -3841,7 +3853,8 @@ zfcp_fsf_send_fcp_command_handler(struct
 			      sizeof (union fsf_status_qual));
 		debug_text_event(fsf_req->adapter->erp_dbf, 1,
 				 "fsf_s_phand_nv");
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0);
+		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 112,
+					(u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3859,7 +3872,7 @@ zfcp_fsf_send_fcp_command_handler(struct
 			      sizeof (union fsf_status_qual));
 		debug_text_event(fsf_req->adapter->erp_dbf, 1,
 				 "fsf_s_uhand_nv");
-		zfcp_erp_port_reopen(unit->port, 0);
+		zfcp_erp_port_reopen(unit->port, 0, 113, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3877,7 +3890,8 @@ zfcp_fsf_send_fcp_command_handler(struct
 			      sizeof (union fsf_status_qual));
 		debug_text_event(fsf_req->adapter->erp_dbf, 1,
 				 "fsf_s_hand_mis");
-		zfcp_erp_adapter_reopen(unit->port->adapter, 0);
+		zfcp_erp_adapter_reopen(unit->port->adapter, 0, 114,
+					(u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3889,7 +3903,8 @@ zfcp_fsf_send_fcp_command_handler(struct
 		/* stop operation for this adapter */
 		debug_text_exception(fsf_req->adapter->erp_dbf, 0,
 				     "fsf_s_class_nsup");
-		zfcp_erp_adapter_shutdown(unit->port->adapter, 0);
+		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 132,
+					  (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3907,7 +3922,7 @@ zfcp_fsf_send_fcp_command_handler(struct
 			      sizeof (union fsf_status_qual));
 		debug_text_event(fsf_req->adapter->erp_dbf, 1,
 				 "fsf_s_fcp_lun_nv");
-		zfcp_erp_port_reopen(unit->port, 0);
+		zfcp_erp_port_reopen(unit->port, 0, 115, (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3945,7 +3960,8 @@ zfcp_fsf_send_fcp_command_handler(struct
 		/* stop operation for this adapter */
 		debug_text_event(fsf_req->adapter->erp_dbf, 0,
 				 "fsf_s_dir_ind_nv");
-		zfcp_erp_adapter_shutdown(unit->port->adapter, 0);
+		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 133,
+					  (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -3960,7 +3976,8 @@ zfcp_fsf_send_fcp_command_handler(struct
 		/* stop operation for this adapter */
 		debug_text_event(fsf_req->adapter->erp_dbf, 0,
 				 "fsf_s_cmd_len_nv");
-		zfcp_erp_adapter_shutdown(unit->port->adapter, 0);
+		zfcp_erp_adapter_shutdown(unit->port->adapter, 0, 134,
+					  (u64)fsf_req);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR;
 		break;
 
@@ -4863,7 +4880,7 @@ static int zfcp_fsf_req_send(struct zfcp
 		req_queue->free_index -= fsf_req->sbal_number;
 		req_queue->free_index += QDIO_MAX_BUFFERS_PER_Q;
 		req_queue->free_index %= QDIO_MAX_BUFFERS_PER_Q; /* wrap */
-		zfcp_erp_adapter_reopen(adapter, 0);
+		zfcp_erp_adapter_reopen(adapter, 0, 116, (u64)fsf_req);
 	} else {
 		req_queue->distance_from_int = new_distance_from_int;
 		/*
--- a/drivers/s390/scsi/zfcp_scsi.c	2008-03-27 13:57:10.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-03-27 13:58:54.000000000 +0100
@@ -529,7 +529,7 @@ static int zfcp_scsi_eh_host_reset_handl
 		unit->fcp_lun, unit->port->wwpn,
 		zfcp_get_busid_by_adapter(unit->port->adapter));
 
-	zfcp_erp_adapter_reopen(adapter, 0);
+	zfcp_erp_adapter_reopen(adapter, 0, 141, (u64)scpnt);
 	zfcp_erp_wait(adapter);
 
 	return SUCCESS;
--- a/drivers/s390/scsi/zfcp_ext.h	2008-03-27 13:57:10.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_ext.h	2008-03-27 13:58:54.000000000 +0100
@@ -133,20 +133,20 @@ extern struct fc_function_template zfcp_
 /******************************** ERP ****************************************/
 extern void zfcp_erp_modify_adapter_status(struct zfcp_adapter *, u8, u64, u32,
 					   int);
-extern int  zfcp_erp_adapter_reopen(struct zfcp_adapter *, int);
-extern int  zfcp_erp_adapter_shutdown(struct zfcp_adapter *, int);
+extern int  zfcp_erp_adapter_reopen(struct zfcp_adapter *, int, u8, u64);
+extern int  zfcp_erp_adapter_shutdown(struct zfcp_adapter *, int, u8, u64);
 extern void zfcp_erp_adapter_failed(struct zfcp_adapter *, u8, u64);
 
 extern void zfcp_erp_modify_port_status(struct zfcp_port *, u8, u64, u32, int);
-extern int  zfcp_erp_port_reopen(struct zfcp_port *, int);
-extern int  zfcp_erp_port_shutdown(struct zfcp_port *, int);
-extern int  zfcp_erp_port_forced_reopen(struct zfcp_port *, int);
+extern int  zfcp_erp_port_reopen(struct zfcp_port *, int, u8, u64);
+extern int  zfcp_erp_port_shutdown(struct zfcp_port *, int, u8, u64);
+extern int  zfcp_erp_port_forced_reopen(struct zfcp_port *, int, u8, u64);
 extern void zfcp_erp_port_failed(struct zfcp_port *, u8, u64);
-extern int  zfcp_erp_port_reopen_all(struct zfcp_adapter *, int);
+extern int  zfcp_erp_port_reopen_all(struct zfcp_adapter *, int, u8, u64);
 
 extern void zfcp_erp_modify_unit_status(struct zfcp_unit *, u8, u64, u32, int);
-extern int  zfcp_erp_unit_reopen(struct zfcp_unit *, int);
-extern int  zfcp_erp_unit_shutdown(struct zfcp_unit *, int);
+extern int  zfcp_erp_unit_reopen(struct zfcp_unit *, int, u8, u64);
+extern int  zfcp_erp_unit_shutdown(struct zfcp_unit *, int, u8, u64);
 extern void zfcp_erp_unit_failed(struct zfcp_unit *, u8, u64);
 
 extern int  zfcp_erp_thread_setup(struct zfcp_adapter *);
@@ -160,9 +160,9 @@ extern void zfcp_erp_port_boxed(struct z
 extern void zfcp_erp_unit_boxed(struct zfcp_unit *, u8 id, u64 ref);
 extern void zfcp_erp_port_access_denied(struct zfcp_port *, u8 id, u64 ref);
 extern void zfcp_erp_unit_access_denied(struct zfcp_unit *, u8 id, u64 ref);
-extern void zfcp_erp_adapter_access_changed(struct zfcp_adapter *);
-extern void zfcp_erp_port_access_changed(struct zfcp_port *);
-extern void zfcp_erp_unit_access_changed(struct zfcp_unit *);
+extern void zfcp_erp_adapter_access_changed(struct zfcp_adapter *, u8, u64);
+extern void zfcp_erp_port_access_changed(struct zfcp_port *, u8, u64);
+extern void zfcp_erp_unit_access_changed(struct zfcp_unit *, u8, u64);
 
 /******************************** AUX ****************************************/
 extern void zfcp_rec_dbf_event_thread(u8 id, struct zfcp_adapter *adapter,
@@ -170,6 +170,9 @@ extern void zfcp_rec_dbf_event_thread(u8
 extern void zfcp_rec_dbf_event_adapter(u8 id, u64 ref, struct zfcp_adapter *);
 extern void zfcp_rec_dbf_event_port(u8 id, u64 ref, struct zfcp_port *port);
 extern void zfcp_rec_dbf_event_unit(u8 id, u64 ref, struct zfcp_unit *unit);
+extern void zfcp_rec_dbf_event_trigger(u8 id, u64 ref, u8 want, u8 need,
+				       u64 action, struct zfcp_adapter *,
+				       struct zfcp_port *, struct zfcp_unit *);
 
 extern void zfcp_hba_dbf_event_fsf_response(struct zfcp_fsf_req *);
 extern void zfcp_hba_dbf_event_fsf_unsol(const char *, struct zfcp_adapter *,
--- a/drivers/s390/scsi/zfcp_qdio.c	2008-03-27 13:54:15.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_qdio.c	2008-03-27 13:58:54.000000000 +0100
@@ -175,8 +175,8 @@ zfcp_qdio_handler_error_check(struct zfc
                 * which is set again in case we have missed by a mile.
                 */
 		zfcp_erp_adapter_reopen(adapter,
-				       ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
-				       ZFCP_STATUS_COMMON_ERP_FAILED);
+					ZFCP_STATUS_ADAPTER_LINK_UNPLUGGED |
+					ZFCP_STATUS_COMMON_ERP_FAILED, 140, 0);
 	}
 	return retval;
 }

-- 
