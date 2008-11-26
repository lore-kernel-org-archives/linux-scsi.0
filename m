From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 6/6] zfcp: fix deadlock between wq triggered port scan and ERP
Date: Wed, 26 Nov 2008 18:07:40 +0100
Message-ID: <20081126171021.788550000@de.ibm.com>
References: <20081126170734.940419000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:46509 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270AbYKZRKY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2008 12:10:24 -0500
Content-Disposition: inline; filename=706-zfcp-deadlock.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

Waiting for the ERP to be finished in a task running in the global
kernel work-queue is a bad idea, especially if the ERP needs to run
another job in this work-queue before it can finish. -> deadlock.

This patch removes the necessity to wait for a finished ERP from the
scan task and moves the job scheduling to the end of the ERP.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    3 ++-
 drivers/s390/scsi/zfcp_fc.c  |    1 -
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_erp.c	2008-11-26 16:42:53.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-11-26 16:43:20.000000000 +0100
@@ -720,7 +720,6 @@ static int zfcp_erp_adapter_strategy_gen
 		goto failed_openfcp;
 
 	atomic_set_mask(ZFCP_STATUS_COMMON_OPEN, &act->adapter->status);
-	schedule_work(&act->adapter->scan_work);
 
 	return ZFCP_ERP_SUCCEEDED;
 
@@ -1284,6 +1283,8 @@ static void zfcp_erp_action_cleanup(stru
 	case ZFCP_ERP_ACTION_REOPEN_ADAPTER:
 		if (result != ZFCP_ERP_SUCCEEDED)
 			zfcp_erp_rports_del(adapter);
+		else
+			schedule_work(&adapter->scan_work);
 		zfcp_adapter_put(adapter);
 		break;
 	}
--- a/drivers/s390/scsi/zfcp_fc.c	2008-11-26 16:42:23.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-11-26 16:43:20.000000000 +0100
@@ -610,7 +610,6 @@ int zfcp_scan_ports(struct zfcp_adapter 
 	int ret, i;
 	struct zfcp_gpn_ft *gpn_ft;
 
-	zfcp_erp_wait(adapter); /* wait until adapter is finished with ERP */
 	if (fc_host_port_type(adapter->scsi_host) != FC_PORTTYPE_NPORT)
 		return 0;
 

-- 
