From: michaelc@cs.wisc.edu
Subject: [PATCH 2/4] scsi: add transport host byte errors
Date: Wed, 14 Mar 2007 14:52:46 -0500
Message-ID: <11739019703157-git-send-email-michaelc@cs.wisc.edu>
References: <11739019681346-git-send-email-michaelc@cs.wisc.edu> <11739019693216-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56089 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030391AbXCNTxH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Mar 2007 15:53:07 -0400
In-Reply-To: <11739019693216-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

Small guide to differences in iscsi and fc:

I_T nexus or port we are connected to at some other end point
iscsi: iscsi_session
fc: rport

fast_io_fail_tmo
iscsi: session recovery_tmo
fc: rport fast_io_fail_tmo

The difference is that when the timer fires, for iscsi we unblock the
queue and fail commands in the blocked queue. FC just fails IO running
in the driver/fw/hw. The IO in the blocked queue sits there until dev_loss_tmo.

dev_loss_tmo
iscsi: none yet (we are working on it :))
fc: dev_loss_tmo

Currently, if there is a transport problem the iscsi drivers will return
outstanding commands (commands being exeucted by the driver/fw/hw) with
DID_BUS_BUSY and block the session so no new commands can be queued.
Commands that are caught between the failure handling and blocking are
failed with DID_IMM_RETRY or one of the scsi ml queuecommand return values.
When the recovery_timeout fires, the iscsi drivers then fail IO with
DID_NO_CONNECT.

For fcp, some drivers will fail some outstanding IO (disk but possibly not
tape) with DID_BUS_BUSY or some other value that causes a retry and hits
the scsi_error.c failfast check, block the rport, and commands caught in the
race are failed with DID_IMM_RETRY. Other drivers, will hold onto all IO
and wait for the terminate_rport_io or dev_loss_tmo_callbk to be called.
In this case lpfc, could return the IO with DID_ERROR.

The following patches attempt unify what upper layers will see drivers
like multipath can make a good guess. This relies on drivers being
hooked into their transport class and implementing the terminate_rport_io
callback.

This first patch just defines two new host byte errors so drivers can
return the same value for when a rport/session is blocked and for
when the fast_io_fail_tmo fires.

The idea is that if the LLD/class detects a problem and is going to block
a rport/session, then if the LLD wants or must return the command to scsi-ml,
then it can return it with DID_TRANSPORT_BLOCKED. This will requeue
the IO into the same scsi queue it came from.

When using multipath and the fast_io_fail_tmo fires then the class
can fail commands with DID_TRANSPORT_FAILFAST or drivers can use
DID_TRANSPORT_FAILFAST in their terminate_rport_io callbacks or
the equivlent in iscsi if we ever implement more advanced recovery methods.
A LLD, like lpfc, could continue to return DID_ERROR and then it will hit
the normal failfast path. The point of the patches is that upper layers will
not see a failure that could be recovered from while the rport/session is
blocked until fast_io_fail_tmo/recovery_timeout fires.
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/constants.c  |    3 ++-
 drivers/scsi/scsi_error.c |   15 ++++++++++++++-
 include/scsi/scsi.h       |    2 ++
 3 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 2a458d6..9f0b284 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1355,7 +1355,8 @@ #ifdef CONFIG_SCSI_CONSTANTS
 static const char * const hostbyte_table[]={
 "DID_OK", "DID_NO_CONNECT", "DID_BUS_BUSY", "DID_TIME_OUT", "DID_BAD_TARGET",
 "DID_ABORT", "DID_PARITY", "DID_ERROR", "DID_RESET", "DID_BAD_INTR",
-"DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY"};
+"DID_PASSTHROUGH", "DID_SOFT_ERROR", "DID_IMM_RETRY", "DID_TRANSPORT_BLOCKED",
+"DID_TRANSPORT_FAILFAST" };
 #define NUM_HOSTBYTE_STRS ARRAY_SIZE(hostbyte_table)
 
 static const char * const driverbyte_table[]={
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index b8edcf5..7dbe0f4 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1231,7 +1231,20 @@ int scsi_decide_disposition(struct scsi_
 
 	case DID_REQUEUE:
 		return ADD_TO_MLQUEUE;
-
+	case DID_TRANSPORT_BLOCKED:
+		/*
+		 * LLD/transport was disrupted during processing the IO.
+		 * The transport is now blocked and attempting to recover,
+		 * and the transport will decide what to do with the IO
+		 * based on its timers and recovery capablilities.
+		 */
+		return NEEDS_RETRY;
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
index 5c0e979..fa94d65 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -309,6 +309,8 @@ #define DID_SOFT_ERROR  0x0b	/* The low 
 #define DID_IMM_RETRY   0x0c	/* Retry without decrementing retry count  */
 #define DID_REQUEUE	0x0d	/* Requeue command (no immediate retry) also
 				 * without decrementing the retry count	   */
+#define DID_TRANSPORT_BLOCKED	0x0e /* Transport class will handle io */
+#define DID_TRANSPORT_FAILFAST	0x0f /* Transport class fastfailed the io */
 #define DRIVER_OK       0x00	/* Driver status                           */
 
 /*
-- 
1.4.1.1

