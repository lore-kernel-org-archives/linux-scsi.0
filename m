From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [patch 11/22] zfcp: Dont fail SCSI commands when transitioning to blocked fc_rport
Date: Tue, 24 Nov 2009 16:54:07 +0100
Message-ID: <20091124160137.588057000@de.ibm.com>
References: <20091124155356.135092000@de.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.de.ibm.com ([195.212.17.161]:44307 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933195AbZKXQBc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Nov 2009 11:01:32 -0500
Content-Disposition: inline; filename=709-zfcp-fail-commands.diff
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com, Christof Schmitt <christof.schmitt@de.ibm.com>

From: Christof Schmitt <christof.schmitt@de.ibm.com>

If an error occurs that triggers the call to fc_remote_port_delete,
ideally this call would happen before any I/O is passed back to the
SCSI midlayer through scsi_done. The SCSI midlayer will retry the
commands and fc_remote_port_chkready will return the correct status
code.  But with the delay between calling scsi_done in softirq context
and the call to fc_remote_port_delete from the workqueue, there is a
window where zfcp returns DID_ERROR. This leads to SCSI error recovery
which then leads to offline SCSI devices since all recovery actions
will fail with the rport now being blocked.

In this window, zfcp has to return DID_IMM_RETRY just as the FC
transport class would do in fc_remote_port_chkready for the blocked
fc_rport. As soon as the fc_rport is BLOCKED, fc_remote_port_chkready
will do the right thing.

Additionally, there are two more cases to catch in zfcp_scsi_queuecommand:
- After the port has been opened, the unit has to be opened. During
  this period I/O has to be retried. This can also be handled with
  DID_IMM_RETRY.
- If the access to the unit fails, but the port is good, then
  this single unit cannot be accessed and I/O to this unit has to fail
  without involving the FC transport class.

Reviewed-by: Swen Schillig <swen@vnet.ibm.com>
Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---

 drivers/s390/scsi/zfcp_scsi.c |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

--- a/drivers/s390/scsi/zfcp_scsi.c	2009-11-24 12:36:36.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2009-11-24 12:36:45.000000000 +0100
@@ -112,12 +112,26 @@ static int zfcp_scsi_queuecommand(struct
 	}
 
 	status = atomic_read(&unit->status);
-	if (unlikely((status & ZFCP_STATUS_COMMON_ERP_FAILED) ||
-		     !(status & ZFCP_STATUS_COMMON_RUNNING))) {
+	if (unlikely(status & ZFCP_STATUS_COMMON_ERP_FAILED) &&
+		     !(atomic_read(&unit->port->status) &
+		       ZFCP_STATUS_COMMON_ERP_FAILED)) {
+		/* only unit access denied, but port is good
+		 * not covered by FC transport, have to fail here */
 		zfcp_scsi_command_fail(scpnt, DID_ERROR);
 		return 0;
 	}
 
+	if (unlikely(!(status & ZFCP_STATUS_COMMON_UNBLOCKED))) {
+		/* This could be either
+		 * open unit pending: this is temporary, will result in
+		 * 	open unit or ERP_FAILED, so retry command
+		 * call to rport_delete pending: mimic retry from
+		 * 	fc_remote_port_chkready until rport is BLOCKED
+		 */
+		zfcp_scsi_command_fail(scpnt, DID_IMM_RETRY);
+		return 0;
+	}
+
 	ret = zfcp_fsf_send_fcp_command_task(unit, scpnt);
 	if (unlikely(ret == -EBUSY))
 		return SCSI_MLQUEUE_DEVICE_BUSY;

