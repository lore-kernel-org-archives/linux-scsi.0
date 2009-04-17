From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 07/15] zfcp: no port recovery after storage side error inject
Date: Fri, 17 Apr 2009 15:08:07 +0200
Message-ID: <20090417131122.739703000@de.ibm.com>
References: <20090417130800.923944000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:65170 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760901AbZDQNMQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2009 09:12:16 -0400
Content-Disposition: inline; filename=707-zfcp-port-recovery.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

The remote port remains in error state even if the connection
is re-established. A wrong precondition check was performed on
the port status leading to a cancellation of the port reopen.
Remove the pre-req check because it's not required and better
handled within the ERP.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fc.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/s390/scsi/zfcp_fc.c	2009-04-17 15:03:37.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_fc.c	2009-04-17 15:03:40.000000000 +0200
@@ -432,11 +432,6 @@ void zfcp_fc_link_test_work(struct work_
 		container_of(work, struct zfcp_port, test_link_work);
 	int retval;
 
-	if (!(atomic_read(&port->status) & ZFCP_STATUS_COMMON_UNBLOCKED)) {
-		zfcp_port_put(port);
-		return; /* port erp is running and will update rport status */
-	}
-
 	zfcp_port_get(port);
 	port->rport_task = RPORT_DEL;
 	zfcp_scsi_rport_work(&port->rport_work);

