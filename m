From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 10/13] zfcp: prevent fc_remote_port_delete calls for unregistered rport
Date: Wed, 01 Oct 2008 12:42:23 +0200
Message-ID: <20081001104804.097284000@de.ibm.com>
References: <20081001104213.585200000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:33594 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546AbYJAKsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 06:48:10 -0400
Content-Disposition: inline; filename=zfcp_delete_registered_rports_only.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Swen Schillig <swen@vnet.ibm.com>, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Swen Schillig <swen@vnet.ibm.com>

In case of an adapter reopen all rports have to be deleted from the 
environment. This should only happen for already registered rports
otherwise fc_remote_port_delete is called with a NULL pointer.

Signed-off-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_erp.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/s390/scsi/zfcp_erp.c	2008-09-30 13:52:06.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_erp.c	2008-09-30 13:52:22.000000000 +0200
@@ -1236,6 +1236,8 @@ static void zfcp_erp_rports_del(struct z
 {
 	struct zfcp_port *port;
 	list_for_each_entry(port, &adapter->port_list_head, list) {
+		if (!port->rport)
+			continue;
 		fc_remote_port_delete(port->rport);
 		port->rport = NULL;
 	}

-- 
