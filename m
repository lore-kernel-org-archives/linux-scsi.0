From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 7/9] zfcp: Use forced_reopen in terminate_rport_io callback
Date: Thu, 08 Jul 2010 09:53:08 +0200
Message-ID: <20100708080110.797418000@de.ibm.com>
References: <20100708075301.347904000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate6.de.ibm.com ([195.212.17.166]:44372 "EHLO
	mtagate6.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0GHIBN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jul 2010 04:01:13 -0400
Content-Disposition: inline; filename=713-zfcp-forced-reopen.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

When running in non-NPIV mode, the port_reopen in terminate_rport_io
might succeed even though the remote port is not available. If the
same port connection is held open from another operating system, the
reopen is only a virtual operation and might not hit the SAN. Fix this
by changing the call to forced_reopen that forces a logout/login
operation in the SAN.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_scsi.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2010-07-06 09:22:14.000000000 +0200
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2010-07-06 09:22:14.000000000 +0200
@@ -506,8 +506,10 @@ static void zfcp_set_rport_dev_loss_tmo(
  * @rport: The FC rport where to teminate I/O
  *
  * Abort all pending SCSI commands for a port by closing the
- * port. Using a reopen avoiding a conflict with a shutdown
- * overwriting a reopen.
+ * port. Using a reopen avoids a conflict with a shutdown
+ * overwriting a reopen. The "forced" ensures that a disappeared port
+ * is not opened again as valid due to the cached plogi data in
+ * non-NPIV mode.
  */
 static void zfcp_scsi_terminate_rport_io(struct fc_rport *rport)
 {
@@ -519,7 +521,7 @@ static void zfcp_scsi_terminate_rport_io
 	port = zfcp_get_port_by_wwpn(adapter, rport->port_name);
 
 	if (port) {
-		zfcp_erp_port_reopen(port, 0, "sctrpi1", NULL);
+		zfcp_erp_port_forced_reopen(port, 0, "sctrpi1", NULL);
 		put_device(&port->dev);
 	}
 }

