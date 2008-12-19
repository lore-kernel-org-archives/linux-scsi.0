From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 08/11] zfcp: remove DID_DID flag
Date: Fri, 19 Dec 2008 16:56:59 +0100
Message-ID: <20081219155755.405161000@de.ibm.com>
References: <20081219155651.010878000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:32771 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbYLSP56 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Dec 2008 10:57:58 -0500
Content-Disposition: inline; filename=remove-did-flag.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>, Felix Beck <felix@linux.vnet.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The port flag DID_DID indicates whether we know the current id of the
port. This is always set in parallel. Since the id 0 is invalid
(because the port id 0 is invalid) we can remove the DID_DID flag:
d_id of 0 indicates an invalid d_id != 0 is a valid one.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
Acked-by: Felix Beck <felix@linux.vnet.ibm.com>
---
 drivers/s390/scsi/zfcp_def.h |    1 -
 drivers/s390/scsi/zfcp_erp.c |    7 +++----
 drivers/s390/scsi/zfcp_fc.c  |    2 --
 drivers/s390/scsi/zfcp_fsf.c |    3 +--
 4 files changed, 4 insertions(+), 9 deletions(-)

--- a/drivers/s390/scsi/zfcp_def.h	2008-12-19 14:38:37.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2008-12-19 14:38:39.000000000 +0100
@@ -243,7 +243,6 @@ struct zfcp_ls_adisc {
 
 /* remote port status */
 #define ZFCP_STATUS_PORT_PHYS_OPEN		0x00000001
-#define ZFCP_STATUS_PORT_DID_DID		0x00000002
 #define ZFCP_STATUS_PORT_PHYS_CLOSING		0x00000004
 #define ZFCP_STATUS_PORT_NO_WWPN		0x00000008
 #define ZFCP_STATUS_PORT_INVALID_WWPN		0x00000020
--- a/drivers/s390/scsi/zfcp_erp.c	2008-12-19 14:38:32.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-12-19 14:38:39.000000000 +0100
@@ -837,7 +837,6 @@ static int zfcp_erp_open_ptp_port(struct
 		return ZFCP_ERP_FAILED;
 	}
 	port->d_id = adapter->peer_d_id;
-	atomic_set_mask(ZFCP_STATUS_PORT_DID_DID, &port->status);
 	return zfcp_erp_port_strategy_open_port(act);
 }
 
@@ -868,12 +867,12 @@ static int zfcp_erp_port_strategy_open_c
 	case ZFCP_ERP_STEP_PORT_CLOSING:
 		if (fc_host_port_type(adapter->scsi_host) == FC_PORTTYPE_PTP)
 			return zfcp_erp_open_ptp_port(act);
-		if (!(p_status & ZFCP_STATUS_PORT_DID_DID)) {
+		if (!port->d_id) {
 			queue_work(zfcp_data.work_queue, &port->gid_pn_work);
 			return ZFCP_ERP_CONTINUES;
 		}
 	case ZFCP_ERP_STEP_NAMESERVER_LOOKUP:
-		if (!(p_status & ZFCP_STATUS_PORT_DID_DID)) {
+		if (!port->d_id) {
 			if (p_status & (ZFCP_STATUS_PORT_INVALID_WWPN)) {
 				zfcp_erp_port_failed(port, 26, NULL);
 				return ZFCP_ERP_EXIT;
@@ -885,7 +884,7 @@ static int zfcp_erp_port_strategy_open_c
 	case ZFCP_ERP_STEP_PORT_OPENING:
 		/* D_ID might have changed during open */
 		if (p_status & ZFCP_STATUS_COMMON_OPEN) {
-			if (p_status & ZFCP_STATUS_PORT_DID_DID)
+			if (port->d_id)
 				return ZFCP_ERP_SUCCEEDED;
 			else {
 				act->step = ZFCP_ERP_STEP_PORT_CLOSING;
--- a/drivers/s390/scsi/zfcp_fc.c	2008-12-19 14:38:37.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-12-19 14:38:39.000000000 +0100
@@ -262,7 +262,6 @@ static void zfcp_fc_ns_gid_pn_eval(unsig
 		return;
 	/* looks like a valid d_id */
 	port->d_id = ct_iu_resp->d_id & ZFCP_DID_MASK;
-	atomic_set_mask(ZFCP_STATUS_PORT_DID_DID, &port->status);
 }
 
 int static zfcp_fc_ns_gid_pn_request(struct zfcp_erp_action *erp_action,
@@ -585,7 +584,6 @@ static int zfcp_scan_eval_gpn_ft(struct 
 		}
 
 		port = zfcp_port_enqueue(adapter, acc->wwpn,
-					 ZFCP_STATUS_PORT_DID_DID |
 					 ZFCP_STATUS_COMMON_NOESC, d_id);
 		if (IS_ERR(port))
 			ret = PTR_ERR(port);
--- a/drivers/s390/scsi/zfcp_fsf.c	2008-12-19 14:38:28.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fsf.c	2008-12-19 14:38:39.000000000 +0100
@@ -1439,8 +1439,7 @@ static void zfcp_fsf_open_port_handler(s
 		plogi = (struct fsf_plogi *) req->qtcb->bottom.support.els;
 		if (req->qtcb->bottom.support.els1_length >= sizeof(*plogi)) {
 			if (plogi->serv_param.wwpn != port->wwpn)
-				atomic_clear_mask(ZFCP_STATUS_PORT_DID_DID,
-						  &port->status);
+				port->d_id = 0;
 			else {
 				port->wwnn = plogi->serv_param.wwnn;
 				zfcp_fc_plogi_evaluate(port, plogi);

-- 
