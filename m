From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [PATCH] [8/8] zfcp: fix handling of port boxed and lun boxed fsf states
Date: Mon, 13 Jun 2005 13:23:57 +0200
Message-ID: <20050613112357.GH8998@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:23460 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S261474AbVFMLX5
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 07:23:57 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate4.de.ibm.com (8.12.10/8.12.10) with ESMTP id j5DBNta6200940
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 11:23:55 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j5DBNt2H176316
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 13:23:55 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j5DBNtk3001331
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 13:23:55 +0200
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, Maxim Shchetynin <maxim@de.ibm.com>

This is patch 8 of 8 in a series of zfcp bug fixes.  Patches are based
on 2.6.12-rc6 plus "remove flags_dump feature"-patch from June, 10th.

This one fixes the handling of fsf states port boxed and lun boxed.


Regards,

Andreas


From: Maxim Shchetynin <maxim@de.ibm.com>
 
zfcp: fix handling of port boxed and lun boxed fsf states

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

 zfcp_def.h |    1 
 zfcp_erp.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++++---------
 zfcp_ext.h |    2 +
 zfcp_fsf.c |   32 ++++++++++++----------------
 4 files changed, 75 insertions(+), 28 deletions(-)

diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_def.h linux-2.6.12-rc6/drivers/s390/scsi/zfcp_def.h
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_def.h	2005-06-13 10:28:19.000000000 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_def.h	2005-06-13 10:30:43.000000000 +0200
@@ -490,6 +490,7 @@
 #define ZFCP_STATUS_COMMON_CLOSING              0x02000000
 #define ZFCP_STATUS_COMMON_ERP_INUSE		0x01000000
 #define ZFCP_STATUS_COMMON_ACCESS_DENIED	0x00800000
+#define ZFCP_STATUS_COMMON_ACCESS_BOXED		0x00400000
 
 /* adapter status */
 #define ZFCP_STATUS_ADAPTER_QDIOUP		0x00000002
diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_erp.c linux-2.6.12-rc6/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_erp.c	2005-06-13 10:28:19.000000000 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_erp.c	2005-06-13 10:58:11.000000000 +0200
@@ -3482,6 +3482,45 @@
 }
 
 /*
+ * function:	zfcp_erp_port_boxed
+ *
+ * purpose:
+ */
+void
+zfcp_erp_port_boxed(struct zfcp_port *port)
+{
+	struct zfcp_adapter *adapter = port->adapter;
+	unsigned long flags;
+
+	debug_text_event(adapter->erp_dbf, 3, "p_access_boxed");
+	debug_event(adapter->erp_dbf, 3, &port->wwpn, sizeof(wwn_t));
+	read_lock_irqsave(&zfcp_data.config_lock, flags);
+	zfcp_erp_modify_port_status(port,
+			ZFCP_STATUS_COMMON_ACCESS_BOXED,
+			ZFCP_SET);
+	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
+	zfcp_erp_port_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED);
+}
+
+/*
+ * function:	zfcp_erp_unit_boxed
+ *
+ * purpose:
+ */
+void
+zfcp_erp_unit_boxed(struct zfcp_unit *unit)
+{
+	struct zfcp_adapter *adapter = unit->port->adapter;
+
+	debug_text_event(adapter->erp_dbf, 3, "u_access_boxed");
+	debug_event(adapter->erp_dbf, 3, &unit->fcp_lun, sizeof(fcp_lun_t));
+	zfcp_erp_modify_unit_status(unit,
+			ZFCP_STATUS_COMMON_ACCESS_BOXED,
+			ZFCP_SET);
+	zfcp_erp_unit_reopen(unit, ZFCP_STATUS_COMMON_ERP_FAILED);
+}
+
+/*
  * function:	zfcp_erp_port_access_denied
  *
  * purpose:
@@ -3492,11 +3531,13 @@
 	struct zfcp_adapter *adapter = port->adapter;
 	unsigned long flags;
 
-	debug_text_event(adapter->erp_dbf, 3, "p_access_block");
+	debug_text_event(adapter->erp_dbf, 3, "p_access_denied");
 	debug_event(adapter->erp_dbf, 3, &port->wwpn, sizeof(wwn_t));
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
-	zfcp_erp_modify_port_status(port, ZFCP_STATUS_COMMON_ERP_FAILED |
-				    ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
+	zfcp_erp_modify_port_status(port,
+			ZFCP_STATUS_COMMON_ERP_FAILED |
+			ZFCP_STATUS_COMMON_ACCESS_DENIED,
+			ZFCP_SET);
 	read_unlock_irqrestore(&zfcp_data.config_lock, flags);
 }
 
@@ -3510,10 +3551,12 @@
 {
 	struct zfcp_adapter *adapter = unit->port->adapter;
 
-	debug_text_event(adapter->erp_dbf, 3, "u_access_block");
+	debug_text_event(adapter->erp_dbf, 3, "u_access_denied");
 	debug_event(adapter->erp_dbf, 3, &unit->fcp_lun, sizeof(fcp_lun_t));
-	zfcp_erp_modify_unit_status(unit, ZFCP_STATUS_COMMON_ERP_FAILED |
-				    ZFCP_STATUS_COMMON_ACCESS_DENIED, ZFCP_SET);
+	zfcp_erp_modify_unit_status(unit,
+			ZFCP_STATUS_COMMON_ERP_FAILED |
+			ZFCP_STATUS_COMMON_ACCESS_DENIED,
+			ZFCP_SET);
 }
 
 /*
@@ -3527,7 +3570,7 @@
 	struct zfcp_port *port;
 	unsigned long flags;
 
-	debug_text_event(adapter->erp_dbf, 3, "a_access_unblock");
+	debug_text_event(adapter->erp_dbf, 3, "a_access_recover");
 	debug_event(adapter->erp_dbf, 3, &adapter->name, 8);
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
@@ -3550,10 +3593,12 @@
 	struct zfcp_adapter *adapter = port->adapter;
 	struct zfcp_unit *unit;
 
-	debug_text_event(adapter->erp_dbf, 3, "p_access_unblock");
+	debug_text_event(adapter->erp_dbf, 3, "p_access_recover");
 	debug_event(adapter->erp_dbf, 3, &port->wwpn, sizeof(wwn_t));
 
 	if (!atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED,
+			      &port->status) &&
+	    !atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_BOXED,
 			      &port->status)) {
 		if (!atomic_test_mask(ZFCP_STATUS_PORT_WKA, &port->status))
 			list_for_each_entry(unit, &port->unit_list_head, list)
@@ -3580,10 +3625,13 @@
 {
 	struct zfcp_adapter *adapter = unit->port->adapter;
 
-	debug_text_event(adapter->erp_dbf, 3, "u_access_unblock");
+	debug_text_event(adapter->erp_dbf, 3, "u_access_recover");
 	debug_event(adapter->erp_dbf, 3, &unit->fcp_lun, sizeof(fcp_lun_t));
 
-	if (!atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED, &unit->status))
+	if (!atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED,
+			      &unit->status) &&
+	    !atomic_test_mask(ZFCP_STATUS_COMMON_ACCESS_BOXED,
+			      &unit->status))
 		return;
 
 	ZFCP_LOG_NORMAL("reopen of unit 0x%016Lx on port 0x%016Lx "
diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_ext.h linux-2.6.12-rc6/drivers/s390/scsi/zfcp_ext.h
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_ext.h	2005-06-13 10:28:19.000000000 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_ext.h	2005-06-13 10:30:43.000000000 +0200
@@ -171,6 +171,8 @@
 
 extern int  zfcp_test_link(struct zfcp_port *);
 
+extern void zfcp_erp_port_boxed(struct zfcp_port *);
+extern void zfcp_erp_unit_boxed(struct zfcp_unit *);
 extern void zfcp_erp_port_access_denied(struct zfcp_port *);
 extern void zfcp_erp_unit_access_denied(struct zfcp_unit *);
 extern void zfcp_erp_adapter_access_changed(struct zfcp_adapter *);
diff -u linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_fsf.c linux-2.6.12-rc6/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6.12-rc6/drivers/s390/scsi-orig/zfcp_fsf.c	2005-06-13 10:28:19.000000000 +0200
+++ linux-2.6.12-rc6/drivers/s390/scsi/zfcp_fsf.c	2005-06-13 10:30:43.000000000 +0200
@@ -1228,7 +1228,7 @@
 			      zfcp_get_busid_by_unit(unit));
 		debug_text_event(new_fsf_req->adapter->erp_dbf, 2,
 				 "fsf_s_pboxed");
-		zfcp_erp_port_reopen(unit->port, 0);
+		zfcp_erp_port_boxed(unit->port);
 		new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
 		    | ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -1240,10 +1240,7 @@
                         unit->fcp_lun, unit->port->wwpn,
                         zfcp_get_busid_by_unit(unit));
                 debug_text_event(new_fsf_req->adapter->erp_dbf, 1, "fsf_s_lboxed");
-                zfcp_erp_unit_reopen(unit, 0);
-                zfcp_cmd_dbf_event_fsf("unitbox", new_fsf_req,
-                        &new_fsf_req->qtcb->header.fsf_status_qual,
-                        sizeof(union fsf_status_qual));
+		zfcp_erp_unit_boxed(unit);
                 new_fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
                         | ZFCP_STATUS_FSFREQ_RETRY;
                 break;
@@ -1573,7 +1570,7 @@
 			      "(adapter %s, port d_id=0x%08x)\n",
 			      zfcp_get_busid_by_port(port), port->d_id);
 		debug_text_event(adapter->erp_dbf, 2, "fsf_s_pboxed");
-		zfcp_erp_port_reopen(port, 0);
+		zfcp_erp_port_boxed(port);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
 		    | ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -2460,6 +2457,9 @@
 		/* mark port as open */
 		atomic_set_mask(ZFCP_STATUS_COMMON_OPEN |
 				ZFCP_STATUS_PORT_PHYS_OPEN, &port->status);
+		atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
+		                  ZFCP_STATUS_COMMON_ACCESS_BOXED,
+		                  &port->status);
 		retval = 0;
 		/* check whether D_ID has changed during open */
 		/*
@@ -2803,7 +2803,7 @@
 			       port->wwpn,
 			       zfcp_get_busid_by_port(port));
 		debug_text_event(fsf_req->adapter->erp_dbf, 1, "fsf_s_pboxed");
-		zfcp_erp_port_reopen(port, 0);
+		zfcp_erp_port_boxed(port);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -3035,7 +3035,7 @@
 			       "needs to be reopened\n",
 			       unit->port->wwpn, zfcp_get_busid_by_unit(unit));
 		debug_text_event(adapter->erp_dbf, 2, "fsf_s_pboxed");
-		zfcp_erp_port_reopen(unit->port, 0);
+		zfcp_erp_port_boxed(unit->port);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -3145,7 +3145,9 @@
 			       unit->handle);
 		/* mark unit as open */
 		atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &unit->status);
-
+		atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
+		                  ZFCP_STATUS_COMMON_ACCESS_BOXED,
+		                  &unit->status);
 		if (adapter->supported_features & FSF_FEATURE_LUN_SHARING){
 			if (!exclusive)
 		                atomic_set_mask(ZFCP_STATUS_UNIT_SHARED,
@@ -3335,7 +3337,7 @@
 			       unit->port->wwpn,
 			       zfcp_get_busid_by_unit(unit));
 		debug_text_event(fsf_req->adapter->erp_dbf, 2, "fsf_s_pboxed");
-		zfcp_erp_port_reopen(unit->port, 0);
+		zfcp_erp_port_boxed(unit->port);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -3881,10 +3883,7 @@
 			       "needs to be reopened\n",
 			       unit->port->wwpn, zfcp_get_busid_by_unit(unit));
 		debug_text_event(fsf_req->adapter->erp_dbf, 2, "fsf_s_pboxed");
-		zfcp_erp_port_reopen(unit->port, 0);
-		zfcp_cmd_dbf_event_fsf("portbox", fsf_req,
-				       &header->fsf_status_qual,
-				       sizeof (union fsf_status_qual));
+		zfcp_erp_port_boxed(unit->port);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR |
 			ZFCP_STATUS_FSFREQ_RETRY;
 		break;
@@ -3895,10 +3894,7 @@
 				zfcp_get_busid_by_unit(unit),
 				unit->port->wwpn, unit->fcp_lun);
 		debug_text_event(fsf_req->adapter->erp_dbf, 1, "fsf_s_lboxed");
-		zfcp_erp_unit_reopen(unit, 0);
-		zfcp_cmd_dbf_event_fsf("unitbox", fsf_req,
-				       &header->fsf_status_qual,
-				       sizeof(union fsf_status_qual));
+		zfcp_erp_unit_boxed(unit);
 		fsf_req->status |= ZFCP_STATUS_FSFREQ_ERROR
 			| ZFCP_STATUS_FSFREQ_RETRY;
 		break;

