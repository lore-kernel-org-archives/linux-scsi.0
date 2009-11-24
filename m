From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 20/22] zfcp: Block scsi_eh thread for rport state BLOCKED
Date: Tue, 24 Nov 2009 16:54:16 +0100
Message-ID: <20091124160138.938355000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:57704 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241AbZKXQBe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:34 -0500
Content-Disposition: inline; filename=720-zfcp-block-thread.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

In case the SCSI error recovery starts because of a SCSI command
timeout, but then something else triggers the rport to be deleted, the
SCSI error recovery will run to the end and set the SCSI device
offline. To prevent this, call the FC transport function
fc_block_scsi_eh which waits until the rport leaves the BLOCKED state.
This guarantees that communication is possible if the rport is ONLINE,
or the SCSI devices will be removed if the rport state switches to
NOT_PRESENT.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_scsi.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/s390/scsi/zfcp_scsi.c	2009-11-24 12:36:53.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-11-24 12:36:58.000000000 +0100
@@ -209,6 +209,7 @@ static int zfcp_scsi_eh_abort_handler(st
 			break;
 
 		zfcp_erp_wait(adapter);
+		fc_block_scsi_eh(scpnt);
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING)) {
 			zfcp_dbf_scsi_abort("nres", adapter->dbf, scpnt, NULL,
@@ -248,6 +249,7 @@ static int zfcp_task_mgmt_function(struc
 			break;
 
 		zfcp_erp_wait(adapter);
+		fc_block_scsi_eh(scpnt);
 		if (!(atomic_read(&adapter->status) &
 		      ZFCP_STATUS_COMMON_RUNNING)) {
 			zfcp_dbf_scsi_devreset("nres", tm_flags, unit, scpnt);
@@ -289,6 +291,7 @@ static int zfcp_scsi_eh_host_reset_handl
 
 	zfcp_erp_adapter_reopen(adapter, 0, "schrh_1", scpnt);
 	zfcp_erp_wait(adapter);
+	fc_block_scsi_eh(scpnt);
 
 	return SUCCESS;
 }

