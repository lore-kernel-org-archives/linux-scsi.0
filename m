From: michaelc@cs.wisc.edu
Subject: [PATCH 3/4] iscsi class, libiscsi and qla4xxx: convert to new transport host byte values
Date: Wed, 14 Mar 2007 14:52:47 -0500
Message-ID: <11739019701684-git-send-email-michaelc@cs.wisc.edu>
References: <11739019681346-git-send-email-michaelc@cs.wisc.edu> <11739019693216-git-send-email-michaelc@cs.wisc.edu> <11739019703157-git-send-email-michaelc@cs.wisc.edu>
Reply-To: michaelc@cs.wisc.edu
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030658AbXCNTxD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 14 Mar 2007 15:53:03 -0400
In-Reply-To: <11739019703157-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch converts the iscsi drivers to the new host byte values
Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c             |   21 ++++++++++++---------
 drivers/scsi/qla4xxx/ql4_isr.c      |    2 +-
 drivers/scsi/scsi_transport_iscsi.c |    4 ++--
 3 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index f4e1a1b..455bbfd 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -779,20 +779,23 @@ int iscsi_queuecommand(struct scsi_cmnd 
 		 * be entering our queuecommand while a block is starting
 		 * up because the block code is not locked)
 		 */
-		if (session->state == ISCSI_STATE_IN_RECOVERY) {
+		switch (session->state) {
+		case ISCSI_STATE_IN_RECOVERY:
 			reason = FAILURE_SESSION_IN_RECOVERY;
-			goto reject;
-		}
-
-		if (session->state == ISCSI_STATE_RECOVERY_FAILED) {
+			sc->result = DID_TRANSPORT_BLOCKED << 16;
+			break;
+		case ISCSI_STATE_RECOVERY_FAILED:
 			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
-			sc->result = DID_IMM_RETRY << 16;
-		} else if (session->state == ISCSI_STATE_TERMINATE) {
+			sc->result = DID_TRANSPORT_FAILFAST << 16;
+			break;
+		case ISCSI_STATE_TERMINATE:
 			reason = FAILURE_SESSION_TERMINATE;
 			sc->result = DID_NO_CONNECT << 16;
-		} else {
+			break;
+		default:
 			reason = FAILURE_SESSION_FREED;
 			sc->result = DID_NO_CONNECT << 16;
+			break;
 		}
 		goto fault;
 	}
@@ -1782,7 +1785,7 @@ static void iscsi_start_session_recovery
 	 */
 	spin_lock_bh(&session->lock);
 	fail_all_commands(conn,
-			STOP_CONN_RECOVER ? DID_BUS_BUSY : DID_ERROR);
+			STOP_CONN_RECOVER ? DID_TRANSPORT_FAILFAST : DID_ERROR);
 	flush_control_queues(session, conn);
 	spin_unlock_bh(&session->lock);
 
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index 35b9e36..31a786a 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -267,7 +267,7 @@ static void qla4xxx_status_entry(struct 
 		if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
 			qla4xxx_mark_device_missing(ha, ddb_entry);
 
-		cmd->result = DID_BUS_BUSY << 16;
+		cmd->result = DID_BLOCKED_TRANSPORT << 16;
 		break;
 
 	case SCS_QUEUE_FULL:
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 373167b..87e6ffe 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -233,10 +233,10 @@ int iscsi_session_chkready(struct iscsi_
 		err = 0;
 		break;
 	case ISCSI_SESSION_FAILED:
-		err = DID_IMM_RETRY << 16;
+		err = DID_TRANSPORT_BLOCKED << 16;
 		break;
 	case ISCSI_SESSION_FREE:
-		err = DID_NO_CONNECT  << 16;
+		err = DID_TRANSPORT_FAILFAST << 16;
 		break;
 	default:
 		err = DID_NO_CONNECT << 16;
-- 
1.4.1.1

