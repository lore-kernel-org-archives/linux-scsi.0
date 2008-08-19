From: michaelc@cs.wisc.edu
Subject: [PATCH 4/9] iscsi class, libiscsi and qla4xxx: convert to new transport host byte values
Date: Tue, 19 Aug 2008 18:45:26 -0500
Message-ID: <1219189531-5243-5-git-send-email-michaelc@cs.wisc.edu>
References: <1219189531-5243-1-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-2-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-3-git-send-email-michaelc@cs.wisc.edu>
 <1219189531-5243-4-git-send-email-michaelc@cs.wisc.edu>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956AbYHSXps (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Aug 2008 19:45:48 -0400
In-Reply-To: <1219189531-5243-4-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jens.axboe@oracle.com
Cc: Mike Christie <michaelc@cs.wisc.edu>

From: Mike Christie <michaelc@cs.wisc.edu>

This patch converts the iscsi drivers to the new host byte values.

v2
Drop some conversions. Want to avoid conflicts with other patches.
v1
initial patch.

Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/scsi/libiscsi.c             |    8 +++++---
 drivers/scsi/qla4xxx/ql4_isr.c      |    4 ++--
 drivers/scsi/scsi_transport_iscsi.c |    4 ++--
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index 299e075..7c35ae6 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -1202,7 +1202,7 @@ int iscsi_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
 			break;
 		case ISCSI_STATE_RECOVERY_FAILED:
 			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
-			sc->result = DID_NO_CONNECT << 16;
+			sc->result = DID_TRANSPORT_FAILFAST << 16;
 			break;
 		case ISCSI_STATE_TERMINATE:
 			reason = FAILURE_SESSION_TERMINATE;
@@ -2334,8 +2334,10 @@ static void iscsi_start_session_recovery(struct iscsi_session *session,
 	 * flush queues.
 	 */
 	spin_lock_bh(&session->lock);
-	fail_all_commands(conn, -1,
-			STOP_CONN_RECOVER ? DID_BUS_BUSY : DID_ERROR);
+	if (STOP_CONN_RECOVER)
+		fail_all_commands(conn, -1, DID_TRANSPORT_DISRUPTED);
+	else
+		fail_all_commands(conn, -1, DID_ERROR);
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
index 043c392..3c612ac 100644
--- a/drivers/scsi/scsi_transport_iscsi.c
+++ b/drivers/scsi/scsi_transport_iscsi.c
@@ -374,10 +374,10 @@ int iscsi_session_chkready(struct iscsi_cls_session *session)
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

