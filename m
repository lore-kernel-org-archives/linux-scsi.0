From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 10/13] zfcp: Add port only once to FC transport class
Date: Mon, 13 Jul 2009 15:06:11 +0200
Message-ID: <20090713131043.985315000@de.ibm.com>
References: <20090713130601.304914000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:50329 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbZGMNKp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2009 09:10:45 -0400
Content-Disposition: inline; filename=716-zfcp-add-port-once.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When calling fc_remote_port_add make sure to not call it again before
fc_remote_port_delete has been called. In other words, ensure to
create a new fc_rport, then delete it, then create a new one again.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_scsi.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/s390/scsi/zfcp_scsi.c	2009-07-13 13:18:07.000000000 +0200
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-07-13 13:18:14.000000000 +0200
@@ -534,6 +534,9 @@ static void zfcp_scsi_rport_register(str
 	struct fc_rport_identifiers ids;
 	struct fc_rport *rport;
 
+	if (port->rport)
+		return;
+
 	ids.node_name = port->wwnn;
 	ids.port_name = port->wwpn;
 	ids.port_id = port->d_id;
@@ -557,8 +560,10 @@ static void zfcp_scsi_rport_block(struct
 {
 	struct fc_rport *rport = port->rport;
 
-	if (rport)
+	if (rport) {
 		fc_remote_port_delete(rport);
+		port->rport = NULL;
+	}
 }
 
 void zfcp_scsi_schedule_rport_register(struct zfcp_port *port)

