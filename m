From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 1/6] zfcp: fix remote port status check
Date: Wed, 26 Nov 2008 18:07:35 +0100
Message-ID: <20081126171018.066342000@de.ibm.com>
References: <20081126170734.940419000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate5.de.ibm.com ([195.212.29.154]:62110 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbYKZRKV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2008 12:10:21 -0500
Content-Disposition: inline; filename=715-zfcp-port-status.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Martin Petermann <martin@linux.vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Martin Petermann <martin@linux.vnet.ibm.com>

For an incoming RSCN it was checked by the ZFCP_STATUS_PORT_DID_DID
define to re-open a remote port or to test the connection. Since this
define was re-used it was also necessary to replace that define with 
ZFCP_STATUS_PORT_PHYS_OPEN.

Signed-off-by: Martin Petermann <martin@linux.vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_fc.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_fc.c	2008-11-26 16:17:53.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_fc.c	2008-11-26 16:42:12.000000000 +0100
@@ -125,8 +125,7 @@ static void _zfcp_fc_incoming_rscn(struc
 
 	read_lock_irqsave(&zfcp_data.config_lock, flags);
 	list_for_each_entry(port, &fsf_req->adapter->port_list_head, list) {
-		/* FIXME: ZFCP_STATUS_PORT_DID_DID check is racy */
-		if (!(atomic_read(&port->status) & ZFCP_STATUS_PORT_DID_DID))
+		if (!(atomic_read(&port->status) & ZFCP_STATUS_PORT_PHYS_OPEN))
 			/* Try to connect to unused ports anyway. */
 			zfcp_erp_port_reopen(port,
 					     ZFCP_STATUS_COMMON_ERP_FAILED,

-- 
