From: Mike Anderson <andmike@linux.vnet.ibm.com>
Subject: [PATCH 02/14] scsi: add transport host byte errors (v3)
Date: Tue,  2 Sep 2008 09:05:31 -0700
Message-ID: <1220371543-15099-3-git-send-email-andmike@linux.vnet.ibm.com>
References: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39479 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530AbYIBQFu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2008 12:05:50 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.13.8/8.13.8) with ESMTP id m82G5jFw027527
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:45 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m82G5jK1173310
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:45 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m82G5j0A020932
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2008 12:05:45 -0400
In-Reply-To: <1220371543-15099-1-git-send-email-andmike@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Currently, if there is a transport problem the iscsi drivers will return
outstanding commands (commands being exeucted by the driver/fw/hw) with
DID_BUS_BUSY and block the session so no new commands can be queued.
Commands that are caught between the failure handling and blocking are
failed with DID_IMM_RETRY or one of the scsi ml queuecommand return values.
When the recovery_timeout fires, the iscsi drivers then fail IO with
DID_NO_CONNECT.

For fcp, some drivers will fail some outstanding IO (disk but possibly not
tape) with DID_BUS_BUSY or DID_ERROR or some other value that causes a retry
and hits the scsi_error.c failfast check, block the rport, and commands
caught in the race are failed with DID_IMM_RETRY. Other drivers, may
hold onto all IO and wait for the terminate_rport_io or dev_loss_tmo_callbk
to be called.

The following patches attempt to unify what upper layers will see drivers
like multipath can make a good guess. This relies on drivers being
hooked into their transport class.

This first patch just defines two new host byte errors so drivers can
return the same value for when a rport/session is blocked and for
when the fast_io_fail_tmo fires.

The idea is that if the LLD/class detects a problem and is going to block
a rport/session, then if the LLD wants or must return the command to scsi-ml,
then it can return it with DID_TRANSPORT_DISRUPTED. This will requeue
the IO into the same scsi queue it came from, until the fast io fail timer
fires and the class decides what to do.

When using multipath and the fast_io_fail_tmo fires then the class
can fail commands with DID_TRANSPORT_FAILFAST or drivers can use
DID_TRANSPORT_FAILFAST in their terminate_rport_io callbacks or
the equivlent in iscsi if we ever implement more advanced recovery methods.
A LLD, like lpfc, could continue to return DID_ERROR and then it will hit
the normal failfast path, so drivers do not have fully be ported to
work better. The point of the patches is that upper layers will
not see a failure that could be recovered from while the rport/session is
blocked until fast_io_fail_tmo/recovery_timeout fires.

V3
Remove some comments.
V2
Fixed patch/diff errors and renamed DID_TRANSPORT_BLOCKED to
DID_TRANSPORT_DISRUPTED.
V1
initial patch.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Anderson <andmike@linux.vnet.ibm.com>
---
 drivers/scsi/constants.c  |    3 ++-
 drivers/scsi/scsi_error.c |   15 ++++++++++++++-
 include/scsi/scsi.h       |    5 +++++
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 9785d73..4003dee 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1364,7 +1364,8 @@ EXPORT_SYMBOL(scsi_print_sense);
 static const char * const hostbyte_table[]={
 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET",
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
-"DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQUEUE"};
+"DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_REQUEUE",
+"DID_TRANSPORT_DISRUPTED", "DID_TRANSPORT_FAILFAST" };
 #define NUM_HOSTBYTE_STRS ARRAY_SIZE(hostbyte_table)
 
 static const char * const driverbyte_table[]={
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 880051c..4e30343 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1351,7 +1351,20 @@ int scsi_decide_disposition(struct scsi_cmnd *scmd)
 
 	case DID_REQUEUE:
 		return ADD_TO_MLQUEUE;
-
+	case DID_TRANSPORT_DISRUPTED:
+		/*
+		 * LLD/transport was disrupted during processing of the IO.
+		 * The transport class is now blocked/blocking,
+		 * and the transport will decide what to do with the IO
+		 * based on its timers and recovery capablilities.
+		 */
+		return ADD_TO_MLQUEUE;
+	case DID_TRANSPORT_FAILFAST:
+		/*
+		 * The transport decided to failfast the IO (most likely
+		 * the fast io fail tmo fired), so send IO directly upwards.
+		 */
+		return SUCCESS;
 	case DID_ERROR:
 		if (msg_byte(scmd->result) == COMMAND_COMPLETE &&
 		    status_byte(scmd->result) == RESERVATION_CONFLICT)
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 5c40cc5..8740a16 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -367,6 +367,11 @@ struct scsi_lun {
 #define DID_IMM_RETRY   0x0c	/* Retry without decrementing retry count  */
 #define DID_REQUEUE	0x0d	/* Requeue command (no immediate retry) also
 				 * without decrementing the retry count	   */
+#define DID_TRANSPORT_DISRUPTED 0x0e /* Transport error disrupted execution
+				      * and the driver blocked the port to
+				      * recover the link. Transport class will
+				      * retry or fail IO */
+#define DID_TRANSPORT_FAILFAST	0x0f /* Transport class fastfailed the io */
 #define DRIVER_OK       0x00	/* Driver status                           */
 
 /*
-- 
1.5.5.1

