From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: [PATCH] zfcp: convert zfcp to use target reset and device reset handler
Date: Mon, 3 Mar 2008 11:19:46 +0100
Message-ID: <20080303101946.GB20838@schmichrtp.de.ibm.com>
References: <1204331123-3833-1-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-2-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-3-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-4-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-5-git-send-email-michaelc@cs.wisc.edu> <1204331123-3833-6-git-send-email-michaelc@cs.wisc.edu> <20080301133632.GB5098@schmichrtp.de.ibm.com> <20080303093924.GA8698@osiris.boeblingen.de.ibm.com> <20080303101231.GA20838@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.uk.ibm.com ([195.212.29.137]:53718 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755083AbYCCKTw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Mar 2008 05:19:52 -0500
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate4.uk.ibm.com (8.13.8/8.13.8) with ESMTP id m23AJn9r180756
	for <linux-scsi@vger.kernel.org>; Mon, 3 Mar 2008 10:19:49 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v8.7) with ESMTP id m23AJmhv1474590
	for <linux-scsi@vger.kernel.org>; Mon, 3 Mar 2008 10:19:48 GMT
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m23AJlm0028239
	for <linux-scsi@vger.kernel.org>; Mon, 3 Mar 2008 10:19:47 GMT
Content-Disposition: inline
In-Reply-To: <20080303101231.GA20838@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: michaelc@cs.wisc.edu, linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, james.smart@emulex.com, andrew.vasquez@qlogic.com, mp3@de.ibm.com, rmk@arm.linux.org.uk, matthew@wil.cx

[based on proposal from Mike Christie <michaelc@cs.wisc.edu>, this
patch adds some simplifications to the handler functions]

With the new target reset handler callback in the SCSI midlayer, the
device reset handler in zfcp can be split in two parts. Now, zfcp does
not have to track anymore whether the device supports LUN resets, so
remove this flag and let the SCSI midlayer decide what to do.

The device reset handler simply issues a LUN reset and the target
reset handler a target reset.

Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>
---
 drivers/s390/scsi/zfcp_def.h  |    1 
 drivers/s390/scsi/zfcp_scsi.c |   62 ++++++++++++------------------------------
 2 files changed, 19 insertions(+), 44 deletions(-)

--- a/drivers/s390/scsi/zfcp_scsi.c	2008-03-01 14:30:02.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_scsi.c	2008-03-03 11:15:21.000000000 +0100
@@ -31,6 +31,7 @@ static int zfcp_scsi_queuecommand(struct
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
@@ -442,58 +444,32 @@ static int zfcp_scsi_eh_abort_handler(st
 	return retval;
 }
 
-static int
-zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
+static int zfcp_scsi_eh_device_reset_handler(struct scsi_cmnd *scpnt)
 {
 	int retval;
 	struct zfcp_unit *unit = (struct zfcp_unit *) scpnt->device->hostdata;
 
 	if (!unit) {
-		ZFCP_LOG_NORMAL("bug: Tried reset for nonexistent unit\n");
-		retval = SUCCESS;
-		goto out;
+		WARN_ON(1);
+		return SUCCESS;
 	}
-	ZFCP_LOG_NORMAL("resetting unit 0x%016Lx on port 0x%016Lx, adapter %s\n",
-			unit->fcp_lun, unit->port->wwpn,
-			zfcp_get_busid_by_adapter(unit->port->adapter));
+	retval = zfcp_task_management_function(unit,
+					       FCP_LOGICAL_UNIT_RESET,
+					       scpnt);
+	return retval ? FAILED : SUCCESS;
+}
 
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
+static int zfcp_scsi_eh_target_reset_handler(struct scsi_cmnd *scpnt)
+{
+	int retval;
+	struct zfcp_unit *unit = (struct zfcp_unit *) scpnt->device->hostdata;
+
+	if (!unit) {
+		WARN_ON(1);
+		return SUCCESS;
 	}
 	retval = zfcp_task_management_function(unit, FCP_TARGET_RESET, scpnt);
-	if (retval) {
-		ZFCP_LOG_DEBUG("target reset failed (unit=%p)\n", unit);
-		retval = FAILED;
-	} else {
-		ZFCP_LOG_DEBUG("target reset succeeded (unit=%p)\n", unit);
-		retval = SUCCESS;
-	}
- out:
-	return retval;
+	return retval ? FAILED : SUCCESS;
 }
 
 static int
--- a/drivers/s390/scsi/zfcp_def.h	2008-03-01 14:30:02.000000000 +0100
+++ b/drivers/s390/scsi/zfcp_def.h	2008-03-01 14:30:45.000000000 +0100
@@ -634,7 +634,6 @@ do { \
 		 ZFCP_STATUS_PORT_NO_SCSI_ID)
 
 /* logical unit status */
-#define ZFCP_STATUS_UNIT_NOTSUPPUNITRESET	0x00000001
 #define ZFCP_STATUS_UNIT_TEMPORARY		0x00000002
 #define ZFCP_STATUS_UNIT_SHARED			0x00000004
 #define ZFCP_STATUS_UNIT_READONLY		0x00000008
