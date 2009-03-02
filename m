From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 01/18] [PATCH] zfcp: Remove some port flags
Date: Mon, 02 Mar 2009 13:08:54 +0100
Message-ID: <20090302121002.146445000@de.ibm.com>
References: <20090302120853.279447000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:63508 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754103AbZCBMKt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Mar 2009 07:10:49 -0500
Content-Disposition: inline; filename=700-zfcp-port-flags.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

PORT_PHYS_CLOSING is only set and cleared, but not actually used
for status checking.

PORT_INVALID_WWPN is set when the GID_PN request does not return
a d_id for a remote port, e.g. when a remote port has been
unplugged. For this case, the d_id is zero. In the erp we can
check the d_id and use the normal escalation procedure that gives
up after three retries and remove the special case.

PORT_NO_WWPN is unused: Each port in the remote port list has a
valid wwpn. The WKA ports are now tracked outside the port
list. Remove the PORT_NO_WWPN flag, since this is no longer set
for any port.

Acked-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_aux.c |   13 ++++++-------
 drivers/s390/scsi/zfcp_def.h |    3 ---
 drivers/s390/scsi/zfcp_erp.c |   16 ++--------------
 drivers/s390/scsi/zfcp_fc.c  |    5 ++---
 drivers/s390/scsi/zfcp_fsf.c |    6 +-----
 5 files changed, 11 insertions(+), 32 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_aux.c linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c
--- linux-2.6/drivers/s390/scsi/zfcp_aux.c	2009-03-01 16:41:01.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_aux.c	2009-03-01 16:41:29.000000000 +0100
@@ -249,8 +249,8 @@ struct zfcp_port *zfcp_get_port_by_wwpn(
 	struct zfcp_port *port;
 
 	list_for_each_entry(port, &adapter->port_list_head, list)
-		if ((port->wwpn == wwpn) && !(atomic_read(&port->status) &
-		      (ZFCP_STATUS_PORT_NO_WWPN | ZFCP_STATUS_COMMON_REMOVE)))
+		if ((port->wwpn == wwpn) &&
+		    !(atomic_read(&port->status) & ZFCP_STATUS_COMMON_REMOVE))
 			return port;
 	return NULL;
 }
@@ -620,11 +620,10 @@ struct zfcp_port *zfcp_port_enqueue(stru
 	dev_set_drvdata(&port->sysfs_device, port);
 
 	read_lock_irq(&zfcp_data.config_lock);
-	if (!(status & ZFCP_STATUS_PORT_NO_WWPN))
-		if (zfcp_get_port_by_wwpn(adapter, wwpn)) {
-			read_unlock_irq(&zfcp_data.config_lock);
-			goto err_out_free;
-		}
+	if (zfcp_get_port_by_wwpn(adapter, wwpn)) {
+		read_unlock_irq(&zfcp_data.config_lock);
+		goto err_out_free;
+	}
 	read_unlock_irq(&zfcp_data.config_lock);
 
 	if (device_register(&port->sysfs_device))
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_def.h linux-2.6-patched/drivers/s390/scsi/zfcp_def.h
--- linux-2.6/drivers/s390/scsi/zfcp_def.h	2009-03-01 16:41:01.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_def.h	2009-03-01 16:41:29.000000000 +0100
@@ -243,9 +243,6 @@ struct zfcp_ls_adisc {
 
 /* remote port status */
 #define ZFCP_STATUS_PORT_PHYS_OPEN		0x00000001
-#define ZFCP_STATUS_PORT_PHYS_CLOSING		0x00000004
-#define ZFCP_STATUS_PORT_NO_WWPN		0x00000008
-#define ZFCP_STATUS_PORT_INVALID_WWPN		0x00000020
 
 /* well known address (WKA) port status*/
 enum zfcp_wka_status {
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2009-03-01 16:41:01.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2009-03-01 16:41:29.000000000 +0100
@@ -777,10 +777,7 @@ static int zfcp_erp_port_forced_strategy
 
 static void zfcp_erp_port_strategy_clearstati(struct zfcp_port *port)
 {
-	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED |
-			  ZFCP_STATUS_PORT_PHYS_CLOSING |
-			  ZFCP_STATUS_PORT_INVALID_WWPN,
-			  &port->status);
+	atomic_clear_mask(ZFCP_STATUS_COMMON_ACCESS_DENIED, &port->status);
 }
 
 static int zfcp_erp_port_forced_strategy(struct zfcp_erp_action *erp_action)
@@ -875,13 +872,8 @@ static int zfcp_erp_port_strategy_open_c
 			return ZFCP_ERP_CONTINUES;
 		}
 	case ZFCP_ERP_STEP_NAMESERVER_LOOKUP:
-		if (!port->d_id) {
-			if (p_status & (ZFCP_STATUS_PORT_INVALID_WWPN)) {
-				zfcp_erp_port_failed(port, 26, NULL);
-				return ZFCP_ERP_EXIT;
-			}
+		if (!port->d_id)
 			return ZFCP_ERP_FAILED;
-		}
 		return zfcp_erp_port_strategy_open_port(act);
 
 	case ZFCP_ERP_STEP_PORT_OPENING:
@@ -1269,10 +1261,6 @@ static void zfcp_erp_action_cleanup(stru
 
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
-		if (atomic_read(&port->status) & ZFCP_STATUS_PORT_NO_WWPN) {
-			zfcp_port_put(port);
-			return;
-		}
 		if ((result == ZFCP_ERP_SUCCEEDED) && !port->rport)
 			zfcp_erp_rport_register(port);
 		if ((result != ZFCP_ERP_SUCCEEDED) && port->rport) {
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2009-03-01 16:41:01.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2009-03-01 16:41:29.000000000 +0100
@@ -259,10 +259,9 @@ static void zfcp_fc_ns_gid_pn_eval(unsig
 
 	if (ct->status)
 		return;
-	if (ct_iu_resp->header.cmd_rsp_code != ZFCP_CT_ACCEPT) {
-		atomic_set_mask(ZFCP_STATUS_PORT_INVALID_WWPN, &port->status);
+	if (ct_iu_resp->header.cmd_rsp_code != ZFCP_CT_ACCEPT)
 		return;
-	}
+
 	/* paranoia */
 	if (ct_iu_req->wwpn != port->wwpn)
 		return;
diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fsf.c linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c
--- linux-2.6/drivers/s390/scsi/zfcp_fsf.c	2009-03-01 16:41:01.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fsf.c	2009-03-01 16:41:29.000000000 +0100
@@ -1712,7 +1712,7 @@ static void zfcp_fsf_close_physical_port
 	struct zfcp_unit *unit;
 
 	if (req->status & ZFCP_STATUS_FSFREQ_ERROR)
-		goto skip_fsfstatus;
+		return;
 
 	switch (header->fsf_status) {
 	case FSF_PORT_HANDLE_NOT_VALID:
@@ -1752,8 +1752,6 @@ static void zfcp_fsf_close_physical_port
 					  &unit->status);
 		break;
 	}
-skip_fsfstatus:
-	atomic_clear_mask(ZFCP_STATUS_PORT_PHYS_CLOSING, &port->status);
 }
 
 /**
@@ -1789,8 +1787,6 @@ int zfcp_fsf_close_physical_port(struct 
 	req->erp_action = erp_action;
 	req->handler = zfcp_fsf_close_physical_port_handler;
 	erp_action->fsf_req = req;
-	atomic_set_mask(ZFCP_STATUS_PORT_PHYS_CLOSING,
-			&erp_action->port->status);
 
 	zfcp_fsf_start_erp_timer(req);
 	retval = zfcp_fsf_req_send(req);

