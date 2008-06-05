From: michaelc@cs.wisc.edu
Subject: [PATCH 2/7] iscsi class, libiscsi and qla4xxx: convert to new transport host byte values
Date: Wed,  4 Jun 2008 20:41:41 -0500
Message-ID: <1212630106-13413-3-git-send-email-michaelc@cs.wisc.edu>
References: <1212630106-13413-1-git-send-email-michaelc@cs.wisc.edu>
 <1212630106-13413-2-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:49881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861AbYFEBlz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Jun 2008 21:41:55 -0400
In-Reply-To: <1212630106-13413-2-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com, linux-scsi@vger.kernel.org
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch converts the iscsi drivers to the new host byte values.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c             |    6 +++---
 drivers/scsi/qla4xxx/ql4_isr.c      |    4 ++--
 drivers/scsi/scsi_transport_iscsi.c |    4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 010c1b9..055c196 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1132,7 +1132,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 		switch (session->state) {
 		case ISCSI_STATE_IN_RECOVERY:
 			reason = FAILURE_SESSION_IN_RECOVERY;
-			sc->result = DID_IMM_RETRY << 16;
+			sc->result = DID_TRANSPORT_DISRUPTED << 16;
 			break;
 		case ISCSI_STATE_LOGGING_OUT:
 			reason = FAILURE_SESSION_LOGGING_OUT;
@@ -1140,7 +1140,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 			break;
 		case ISCSI_STATE_RECOVERY_FAILED:
 			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
-			sc->result = DID_NO_CONNECT << 16;
+			sc->result = DID_TRANSPORT_FAILFAST << 16;
 			break;
 		case ISCSI_STATE_TERMINATE:
 			reason = FAILURE_SESSION_TERMINATE;
@@ -2233,7 +2233,7 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 	 */
 	spin_lock_bh(&session->lock);
 	fail_all_commands(conn, -1,
-			STOP_CONN_RECOVER ? DID_BUS_BUSY : DID_ERROR);
+			STOP_CONN_RECOVER ? DID_TRANSPORT_DISRUPTED : DID_ERROR);
 	flush_control_queues(session, conn);
 	spin_unlock_bh(&session->lock);
 	mutex_unlock(&session->eh_mutex);
diff --git a/drivers/scsi/qla4xxx/ql4_isr.c b/drivers/scsi/qla4xxx/ql4_isr.c
index a91a57c..799120f 100644
--- a/drivers/scsi/qla4xxx/ql4_isr.c
+++ b/drivers/scsi/qla4xxx/ql4_isr.c
@@ -139,7 +139,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 			      ha->host_no, cmd->device->channel,
 			      cmd->device->id, cmd->device->lun));
 
-		cmd->result = DID_BUS_BUSY << 16;
+		cmd->result = DID_TRANSPORT_DISRUPTED << 16;
 
 		/*
 		 * Mark device missing so that we won't continue to send
@@ -243,7 +243,7 @@ static void qla4xxx_status_entry(struct scsi_qla_host *ha,
 		if (atomic_read(&ddb_entry->state) == DDB_STATE_ONLINE)
 			qla4xxx_mark_device_missing(ha, ddb_entry);
 
-		cmd->result = DID_BUS_BUSY << 16;
+		cmd->result = DID_TRANSPORT_DISRUPTED << 16;
 		break;
 
 	case SCS_QUEUE_FULL:
diff --git a/drivers/scsi/scsi_transport_iscsi.c b/drivers/scsi/scsi_transport_iscsi.c
index 65d1737..b5a529c 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -258,10 +258,10 @@ int iscsi_session_chkready(struct iscsi_cls_session *session)
 		err = 0;
 		break;
 	case ISCSI_SESSION_FAILED:
-		err = DID_IMM_RETRY << 16;
+		err = DID_TRANSPORT_DISRUPTED << 16;
 		break;
 	case ISCSI_SESSION_FREE:
-		err = DID_NO_CONNECT << 16;
+		err = DID_TRANSPORT_FAILFAST << 16;
 		break;
 	default:
 		err = DID_NO_CONNECT << 16;
-- 
1.5.4.1

