From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 9/9] zfcp: Fix retry after failed "open port" erp action
Date: Thu, 08 Jul 2010 09:53:10 +0200
Message-ID: <20100708080111.096940000@de.ibm.com>
References: <20100708075301.347904000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:50668 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab0GHIBN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 04:01:13 -0400
Content-Disposition: inline; filename=715-zfcp-retry-port-erp.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

Trying to enqueue a port erp action from the port erp strategy will
fail in zfcp_erp_required_act. To try the same action again, return
ZFCP_ERP_FAILED.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2010-07-06 09:22:15.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2010-07-06 09:22:15.000000000 +0200
@@ -897,8 +897,7 @@ static int zfcp_erp_port_strategy_open_c
 		}
 		if (port->d_id && !(p_status & ZFCP_STATUS_COMMON_NOESC)) {
 			port->d_id = 0;
-			_zfcp_erp_port_reopen(port, 0, "erpsoc1", NULL);
-			return ZFCP_ERP_EXIT;
+			return ZFCP_ERP_FAILED;
 		}
 		/* fall through otherwise */
 	}

