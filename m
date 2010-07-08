From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 8/9] zfcp: Fail erp after timeout
Date: Thu, 08 Jul 2010 09:53:09 +0200
Message-ID: <20100708080110.946039000@de.ibm.com>
References: <20100708075301.347904000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.17.166]:44373 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229Ab0GHIBN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 04:01:13 -0400
Content-Disposition: inline; filename=714-zfcp-fail-erp-timeout.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

After a timeout notification, do not try to run the erp strategy.
Return from the erp with "failed" to possibly trigger a retry.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2010-07-06 09:22:14.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2010-07-06 09:22:14.000000000 +0200
@@ -1246,6 +1246,11 @@ static int zfcp_erp_strategy(struct zfcp
 		goto unlock;
 	}
 
+	if (erp_action->status & ZFCP_STATUS_ERP_TIMEDOUT) {
+		retval = ZFCP_ERP_FAILED;
+		goto check_target;
+	}
+
 	zfcp_erp_action_to_running(erp_action);
 
 	/* no lock to allow for blocking operations */
@@ -1278,6 +1283,7 @@ static int zfcp_erp_strategy(struct zfcp
 		goto unlock;
 	}
 
+check_target:
 	retval = zfcp_erp_strategy_check_target(erp_action, retval);
 	zfcp_erp_action_dequeue(erp_action);
 	retval = zfcp_erp_strategy_statechange(erp_action, retval);

