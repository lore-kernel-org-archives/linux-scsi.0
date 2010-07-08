From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 5/9] zfcp: Do not try "forced close" when port is already closed
Date: Thu, 08 Jul 2010 09:53:06 +0200
Message-ID: <20100708080110.486205000@de.ibm.com>
References: <20100708075301.347904000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.17.165]:44298 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753760Ab0GHIBM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 04:01:12 -0400
Content-Disposition: inline; filename=710-zfcp-forced-close.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When the port is already "physically closed" try the reopen instead.
There is no way to send a "physically close" to an already closed
port.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_erp.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_erp.c linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c
--- linux-2.6/drivers/s390/scsi/zfcp_erp.c	2010-07-06 09:22:12.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_erp.c	2010-07-06 09:22:12.000000000 +0200
@@ -141,9 +141,13 @@ static int zfcp_erp_required_act(int wan
 		if (!(p_status & ZFCP_STATUS_COMMON_UNBLOCKED))
 			need = ZFCP_ERP_ACTION_REOPEN_PORT;
 		/* fall through */
-	case ZFCP_ERP_ACTION_REOPEN_PORT:
 	case ZFCP_ERP_ACTION_REOPEN_PORT_FORCED:
 		p_status = atomic_read(&port->status);
+		if (!(p_status & ZFCP_STATUS_COMMON_OPEN))
+			need = ZFCP_ERP_ACTION_REOPEN_PORT;
+		/* fall through */
+	case ZFCP_ERP_ACTION_REOPEN_PORT:
+		p_status = atomic_read(&port->status);
 		if (p_status & ZFCP_STATUS_COMMON_ERP_INUSE)
 			return 0;
 		a_status = atomic_read(&adapter->status);

