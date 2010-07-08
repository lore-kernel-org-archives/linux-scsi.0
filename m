From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 4/9] zfcp: Do not unblock rport from REOPEN_PORT_FORCED
Date: Thu, 08 Jul 2010 09:53:05 +0200
Message-ID: <20100708080110.337185000@de.ibm.com>
References: <20100708075301.347904000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:39414 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753765Ab0GHIBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 04:01:12 -0400
Content-Disposition: inline; filename=708-zfcp-rport-unblock.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When the REOPEN_PORT_FORCED erp action succeeds, the port has been
closed. A REOPEN_PORT will try to open the port after the
REPORT_PORT_FORCED. The rport should only be unblocked after the
successful completion of the reopen port.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2010-07-06 09:22:09.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2010-07-06 09:22:11.000000000 +0200
@@ -1197,10 +1197,11 @@ static void zfcp_erp_action_cleanup(stru
 		put_device(&unit->dev);
 		break;
 
-	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
 	case ZFCP_ERP_ACTION_REOPEN_PORT:
 		if (result == ZFCP_ERP_SUCCEEDED)
 			zfcp_scsi_schedule_rport_register(port);
+		/* fall through */
+	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
 		put_device(&port->dev);
 		break;
 

