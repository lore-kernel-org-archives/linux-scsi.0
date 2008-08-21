From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 4/6] zfcp: Fix reference counter for remote ports
Date: Thu, 21 Aug 2008 13:43:35 +0200
Message-ID: <20080821114558.114335000@de.ibm.com>
References: <20080821114331.148204000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:38812 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758829AbYHULq6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Aug 2008 07:46:58 -0400
Content-Disposition: inline; filename=704-zfcp-refcount.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Fix the remote port reference counter handling during ELS ADISC
commands and find the remote port by WWPN not by D_IDs that could
change.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fc.c |   25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_fc.c linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c
--- linux-2.6/drivers/s390/scsi/zfcp_fc.c	2008-08-20 14:41:34.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_fc.c	2008-08-20 14:41:35.000000000 +0200
@@ -39,18 +39,6 @@ struct zfcp_gpn_ft {
 	struct scatterlist sg_resp[ZFCP_GPN_FT_BUFFERS];
 };
 
-static struct zfcp_port *zfcp_get_port_by_did(struct zfcp_adapter *adapter,
-					      u32 d_id)
-{
-	struct zfcp_port *port;
-
-	list_for_each_entry(port, &adapter->port_list_head, list)
-		if ((port->d_id == d_id) &&
-		    !atomic_test_mask(ZFCP_STATUS_COMMON_REMOVE, &port->status))
-			return port;
-	return NULL;
-}
-
 static void _zfcp_fc_incoming_rscn(struct zfcp_fsf_req *fsf_req, u32 range,
 				   struct fcp_rscn_element *elem)
 {
@@ -341,12 +329,13 @@ void zfcp_test_link(struct zfcp_port *po
 
 	zfcp_port_get(port);
 	retval = zfcp_fc_adisc(port);
-	if (retval == 0 || retval == -EBUSY)
+	if (retval == 0)
 		return;
 
 	/* send of ADISC was not possible */
 	zfcp_port_put(port);
-	zfcp_erp_port_forced_reopen(port, 0, 65, NULL);
+	if (retval != -EBUSY)
+		zfcp_erp_port_forced_reopen(port, 0, 65, NULL);
 }
 
 static int zfcp_scan_get_nameserver(struct zfcp_adapter *adapter)
@@ -503,9 +492,13 @@ static int zfcp_scan_eval_gpn_ft(struct 
 		       acc->port_id[2];
 
 		/* skip the adapter's port and known remote ports */
-		if (acc->wwpn == fc_host_port_name(adapter->scsi_host) ||
-		     zfcp_get_port_by_did(adapter, d_id))
+		if (acc->wwpn == fc_host_port_name(adapter->scsi_host))
 			continue;
+		port = zfcp_get_port_by_wwpn(adapter, acc->wwpn);
+		if (port) {
+			zfcp_port_get(port);
+			continue;
+		}
 
 		port = zfcp_port_enqueue(adapter, acc->wwpn,
 					 ZFCP_STATUS_PORT_DID_DID |

-- 
