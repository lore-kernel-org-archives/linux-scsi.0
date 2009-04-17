From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 10/15] zfcp: no port recovery after ADISC request timeout
Date: Fri, 17 Apr 2009 15:08:10 +0200
Message-ID: <20090417131123.130316000@de.ibm.com>
References: <20090417130800.923944000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:65180 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760923AbZDQNMR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 09:12:17 -0400
Content-Disposition: inline; filename=710-zfcp-adisc-timeout.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

A remote port remains in error state even if we receive a RSCN
stating that the connection is re-established. The port recovery
is not started due to a flag which is not reset.
The solution is to clear the flag in question before we trigger a ERP.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fc.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_fc.c	2009-04-17 15:03:40.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-04-17 15:03:46.000000000 +0200
@@ -373,7 +373,8 @@ static void zfcp_fc_adisc_handler(unsign
 
 	if (adisc->els.status) {
 		/* request rejected or timed out */
-		zfcp_erp_port_forced_reopen(port, 0, "fcadh_1", NULL);
+		zfcp_erp_port_forced_reopen(port, ZFCP_STATUS_COMMON_ERP_FAILED,
+					    "fcadh_1", NULL);
 		goto out;
 	}
 

