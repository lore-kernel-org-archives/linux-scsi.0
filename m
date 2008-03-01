From: michaelc@cs.wisc.edu
Subject: [PATCH 5/5] zfcp: convert zfcp to use target reset and device reset handler
Date: Fri, 29 Feb 2008 18:25:23 -0600
Message-ID: <1204331123-3833-6-git-send-email-michaelc@cs.wisc.edu>
References: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu>
 <1204331123-3833-2-git-send-email-michaelc@cs.wisc.edu>
 <1204331123-3833-3-git-send-email-michaelc@cs.wisc.edu>
 <1204331123-3833-4-git-send-email-michaelc@cs.wisc.edu>
 <1204331123-3833-5-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:58272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbYCAAZg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Feb 2008 19:25:36 -0500
In-Reply-To: <1204331123-3833-5-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, james.smart@emulex.com, andrew.vasquez@qlogic.com, christof.schmitt@de.ibm.com, mp3@de.ibm.com, rmk@arm.linux.org.uk, matthew@wil.cx
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

zfcp uses the device reset handler to try and send a lun reset.
If that fails it then does a target reset. This patch has it
do a lun reset in the target reset handler like other drivers,
then do a target reset in the target reset handler. scsi_error.c
will escalate from device reset to target reset for the driver.

This patch is only compile tested since suprisingly I could find
a s390 box, but I could not hook storage into the the zfcp adapter
(box was remote).
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/s390/scsi/zfcp_scsi.c |   67 +++++++++++++++++++++++++----------------
 1 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index b9daf5c..13dceec 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -31,6 +31,7 @@ static int zfcp_scsi_queuecommand(struct scsi_cmnd *,
 				  void (*done) (struct scsi_cmnd *));
 static int zfcp_scsi_eh_abort_handler(struct scsi_cmnd *);
 static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *);
+static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *);
 static int zfcp_scsi_eh_host_reset_handler(struct scsi_cmnd *);
 static int zfcp_task_management_function(struct zfcp_unit *, u8,
 					 struct scsi_cmnd *);
@@ -51,6 +52,7 @@ struct zfcp_data zfcp_data = {
 		.queuecommand		= zfcp_scsi_queuecommand,
 		.eh_abort_handler	= zfcp_scsi_eh_abort_handler,
 		.eh_device_reset_handler = zfcp_scsi_eh_device_reset_handler,
+		.eh_target_reset_handler = zfcp_scsi_eh_target_reset_handler,
 		.eh_host_reset_handler	= zfcp_scsi_eh_host_reset_handler,
 		.can_queue		= 4096,
 		.this_id		= -1,
@@ -457,33 +459,46 @@ zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
 			unit->fcp_lun, unit->port->wwpn,
 			zfcp_get_busid_by_adapter(unit->port->adapter));
 
-	/*
-	 * If we do not know whether the unit supports 'logical unit reset'
-	 * then try 'logical unit reset' and proceed with 'target reset'
-	 * if 'logical unit reset' fails.
-	 * If the unit is known not to support 'logical unit reset' then
-	 * skip 'logical unit reset' and try 'target reset' immediately.
-	 */
-	if (!atomic_test_mask(ZFCP_STATUS_UNIT_NOTSUPPUNITRESET,
-			      &unit->status)) {
-		retval = zfcp_task_management_function(unit,
-						       FCP_LOGICAL_UNIT_RESET,
-						       scpnt);
-		if (retval) {
-			ZFCP_LOG_DEBUG("unit reset failed (unit=%p)\n", unit);
-			if (retval == -ENOTSUPP)
-				atomic_set_mask
-				    (ZFCP_STATUS_UNIT_NOTSUPPUNITRESET,
-				     &unit->status);
-			/* fall through and try 'target reset' next */
-		} else {
-			ZFCP_LOG_DEBUG("unit reset succeeded (unit=%p)\n",
-				       unit);
-			/* avoid 'target reset' */
-			retval = SUCCESS;
-			goto out;
-		}
+	if (atomic_test_mask(ZFCP_STATUS_UNIT_NOTSUPPUNITRESET,
+			     &unit->status)) {
+		ZFCP_LOG_DEBUG("unit reset not supported (unit=%p)\n", unit);
+		retval = FAILED;
+		goto out;
+	}
+
+	retval = zfcp_task_management_function(unit,
+					       FCP_LOGICAL_UNIT_RESET,
+					       scpnt);
+	if (retval) {
+		ZFCP_LOG_DEBUG("unit reset failed (unit=%p)\n", unit);
+		if (retval == -ENOTSUPP)
+			atomic_set_mask(ZFCP_STATUS_UNIT_NOTSUPPUNITRESET,
+					&unit->status);
+		retval = FAILED;
+	} else {
+		ZFCP_LOG_DEBUG("unit reset succeeded (unit=%p)\n", unit);
+		retval = SUCCESS;
+	}
+ out:
+	return retval;
+}
+
+static int
+zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
+{
+	int retval;
+	struct zfcp_unit *unit = (struct zfcp_unit *) scpnt->device->hostdata;
+
+	if (!unit) {
+		ZFCP_LOG_NORMAL("bug: Tried reset for nonexistent unit\n");
+		retval = SUCCESS;
+		goto out;
 	}
+
+	ZFCP_LOG_NORMAL("resetting target 0x%016Lx on port 0x%016Lx, adapter %s\n",
+			unit->fcp_lun, unit->port->wwpn,
+			zfcp_get_busid_by_adapter(unit->port->adapter));
+
 	retval = zfcp_task_management_function(unit, FCP_TARGET_RESET, scpnt);
 	if (retval) {
 		ZFCP_LOG_DEBUG("target reset failed (unit=%p)\n", unit);
-- 
1.5.4.1

