From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 05/11] zfcp: Fix warnings from smatch
Date: Wed, 17 Feb 2010 11:18:53 +0100
Message-ID: <20100217102018.541503000@de.ibm.com>
References: <20100217101848.662299000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.17.167]:57286 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752175Ab0BQKUX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Feb 2010 05:20:23 -0500
Content-Disposition: inline; filename=704-zfcp-smatch-warnings.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

The smatch tool from http://repo.or.cz/w/smatch.git warns about this:

drivers/s390/scsi/zfcp_scsi.c +64 zfcp_scsi_command_fail(5) warn: variable dereferenced before check 'scpnt->device'
drivers/s390/scsi/zfcp_scsi.c +64 zfcp_scsi_command_fail(5) warn: variable dereferenced before check 'scpnt->device->host'
drivers/s390/scsi/zfcp_scsi.c +93 zfcp_scsi_queuecommand(23) warn: variable dereferenced before check 'unit'

Fix the first two warnings by removing the checks for scpnt->device
and -> host: As long as the SCSI command exists, there is also a
scsi_device and a Scsi_Host.

Fix the last warning by removing the BUG_ON checks in
zfcp_scsi_queuecommand, they are leftovers from previous paranoia
about wrong pointers between data structures.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_scsi.c |   13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff -urpN linux-2.6/drivers/s390/scsi/zfcp_scsi.c linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6/drivers/s390/scsi/zfcp_scsi.c	2010-02-16 09:43:29.000000000 +0100
+++ linux-2.6-patched/drivers/s390/scsi/zfcp_scsi.c	2010-02-16 09:43:30.000000000 +0100
@@ -60,10 +60,9 @@ static void zfcp_scsi_command_fail(struc
 {
 	struct zfcp_adapter *adapter =
 		(struct zfcp_adapter *) scpnt->device->host->hostdata[0];
+
 	set_host_byte(scpnt, result);
-	if ((scpnt->device != NULL) && (scpnt->device->host != NULL))
-		zfcp_dbf_scsi_result("fail", 4, adapter->dbf, scpnt, NULL);
-	/* return directly */
+	zfcp_dbf_scsi_result("fail", 4, adapter->dbf, scpnt, NULL);
 	scpnt->scsi_done(scpnt);
 }
 
@@ -87,14 +86,6 @@ static int zfcp_scsi_queuecommand(struct
 	adapter = (struct zfcp_adapter *) scpnt->device->host->hostdata[0];
 	unit = scpnt->device->hostdata;
 
-	BUG_ON(!adapter || (adapter != unit->port->adapter));
-	BUG_ON(!scpnt->scsi_done);
-
-	if (unlikely(!unit)) {
-		zfcp_scsi_command_fail(scpnt, DID_NO_CONNECT);
-		return 0;
-	}
-
 	scsi_result = fc_remote_port_chkready(rport);
 	if (unlikely(scsi_result)) {
 		scpnt->result = scsi_result;

