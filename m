From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 04/13] zfcp: Use correct flags for zfcp_erp_notify
Date: Mon, 13 Jul 2009 15:06:05 +0200
Message-ID: <20090713131043.175634000@de.ibm.com>
References: <20090713130601.304914000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:32791 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755852AbZGMNLF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2009 09:11:05 -0400
Content-Disposition: inline; filename=709-zfcp-erp-notify-flags.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

zfcp_erp_notify uses the ZFCP_ERP_STATUS_* flags, so it is
ZFCP_STATUS_ERP_LOWMEM instead of ZFCP_ERP_NOMEM. Signalling
ZFCP_ERP_FAILED is not necessary, the missing d_id will show that the
nameserver did not return the d_id.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2009-07-12 21:08:41.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2009-07-12 21:08:59.000000000 +0200
@@ -854,10 +854,10 @@ void zfcp_erp_port_strategy_open_lookup(
 
 	retval = zfcp_fc_ns_gid_pn(&port->erp_action);
 	if (retval == -ENOMEM)
-		zfcp_erp_notify(&port->erp_action, ZFCP_ERP_NOMEM);
+		zfcp_erp_notify(&port->erp_action, ZFCP_STATUS_ERP_LOWMEM);
 	port->erp_action.step = ZFCP_ERP_STEP_NAMESERVER_LOOKUP;
 	if (retval)
-		zfcp_erp_notify(&port->erp_action, ZFCP_ERP_FAILED);
+		zfcp_erp_notify(&port->erp_action, 0);
 	zfcp_port_put(port);
 }
 

