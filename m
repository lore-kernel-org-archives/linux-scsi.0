From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 11/13] zfcp: avoid double notify in lowmem scenario
Date: Mon, 13 Jul 2009 15:06:12 +0200
Message-ID: <20090713131044.125071000@de.ibm.com>
References: <20090713130601.304914000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:32794 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868AbZGMNLF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2009 09:11:05 -0400
Content-Disposition: inline; filename=718-zfcp-double-notify.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

In a LOWMEM condition an ERP notification would have been sent twice
causing an unpredictable behaviour of the ERP.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2009-07-12 21:09:01.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2009-07-12 21:09:03.000000000 +0200
@@ -848,11 +848,17 @@ void zfcp_erp_port_strategy_open_lookup(
 					      gid_pn_work);
 
 	retval = zfcp_fc_ns_gid_pn(&port->erp_action);
-	if (retval == -ENOMEM)
+	if (!retval) {
+		port->erp_action.step = ZFCP_ERP_STEP_NAMESERVER_LOOKUP;
+		goto out;
+	}
+	if (retval == -ENOMEM) {
 		zfcp_erp_notify(&port->erp_action, ZFCP_STATUS_ERP_LOWMEM);
-	port->erp_action.step = ZFCP_ERP_STEP_NAMESERVER_LOOKUP;
-	if (retval)
-		zfcp_erp_notify(&port->erp_action, 0);
+		goto out;
+	}
+	/* all other error condtions */
+	zfcp_erp_notify(&port->erp_action, 0);
+out:
 	zfcp_port_put(port);
 }
 

