From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 07/13] zfcp: Fix logic for physical port close
Date: Mon, 13 Jul 2009 15:06:08 +0200
Message-ID: <20090713131043.595277000@de.ibm.com>
References: <20090713130601.304914000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:54817 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755822AbZGMNKp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2009 09:10:45 -0400
Content-Disposition: inline; filename=713-zfcp-physical-port-close.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

After closing the port, we want it to be "not open" to consider the
action to be successful.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2009-07-12 21:08:59.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2009-07-12 21:09:01.000000000 +0200
@@ -801,7 +801,7 @@ static int zfcp_erp_port_forced_strategy
 			return ZFCP_ERP_FAILED;
 
 	case ZFCP_ERP_STEP_PHYS_PORT_CLOSING:
-		if (status & ZFCP_STATUS_PORT_PHYS_OPEN)
+		if (!(status & ZFCP_STATUS_PORT_PHYS_OPEN))
 			return ZFCP_ERP_SUCCEEDED;
 	}
 	return ZFCP_ERP_FAILED;

