From: Lee Duncan <leeman.duncan@gmail.com>
Subject: [PATCH] Hold back_lock when calling iscsi_complete_task
Date: Tue, 19 Feb 2019 10:29:14 -0800
Message-ID: <20190219182914.3173-1-leeman.duncan@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linux SCSI <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Chris Leech <cleech@redhat.com>
Cc: hare@suse.de, Lee Duncan <lduncan@suse.com>
List-Id: linux-scsi@vger.kernel.org

From: Lee Duncan <lduncan@suse.com>

If there is an error queueing an iscsi command in
iscsi_queuecommand(), for example if the transport fails
to take the command in sessuin->tt->xmit_task(), then
the error path can call iscsi_complete_task() without
first aquiring the back_lock as required. This can
lead to things like ITT pool can get corrupt, resulting
in duplicate ITTs being sent out.

The solution is to hold the back_lock around
iscsi_complete_task() calls, and to add a little commenting
to help others understand when back_lock must be held.
---
 drivers/scsi/libiscsi.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
index b8d325ce8754..ef7871e8c6bd 100644
--- a/drivers/scsi/libiscsi.c
+++ b/drivers/scsi/libiscsi.c
@@ -838,7 +838,7 @@ EXPORT_SYMBOL_GPL(iscsi_conn_send_pdu);
  * @datalen: len of buffer
  *
  * iscsi_cmd_rsp sets up the scsi_cmnd fields based on the PDU and
- * then completes the command and task.
+ * then completes the command and task. called under back_lock
  **/
 static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
 			       struct iscsi_task *task, char *data,
@@ -941,6 +941,9 @@ static void iscsi_scsi_cmd_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
  * @conn: iscsi connection
  * @hdr:  iscsi pdu
  * @task: scsi command task
+ *
+ * iscsi_data_in_rsp sets up the scsi_cmnd fields based on the data received
+ * then completes the command and task. called under back_lock
  **/
 static void
 iscsi_data_in_rsp(struct iscsi_conn *conn, struct iscsi_hdr *hdr,
@@ -1025,6 +1028,16 @@ static int iscsi_send_nopout(struct iscsi_conn *conn, struct iscsi_nopin *rhdr)
 	return 0;
 }
 
+/**
+ * iscsi_nop_out_rsp - SCSI NOP Response processing
+ * @task: scsi command task
+ * @nop: the nop structure
+ * @data: where to put the data
+ * @datalen: length of data
+ *
+ * iscsi_nop_out_rsp handles nop response from use or
+ * from user space. called under back_lock
+ **/
 static int iscsi_nop_out_rsp(struct iscsi_task *task,
 			     struct iscsi_nopin *nop, char *data, int datalen)
 {
@@ -1791,7 +1804,9 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	return 0;
 
 prepd_reject:
+	spin_lock_bh(&session->back_lock);
 	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
+	spin_unlock_bh(&session->back_lock);
 reject:
 	spin_unlock_bh(&session->frwd_lock);
 	ISCSI_DBG_SESSION(session, "cmd 0x%x rejected (%d)\n",
@@ -1799,7 +1814,9 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
 	return SCSI_MLQUEUE_TARGET_BUSY;
 
 prepd_fault:
+	spin_lock_bh(&session->back_lock);
 	iscsi_complete_task(task, ISCSI_TASK_REQUEUE_SCSIQ);
+	spin_unlock_bh(&session->back_lock);
 fault:
 	spin_unlock_bh(&session->frwd_lock);
 	ISCSI_DBG_SESSION(session, "iscsi: cmd 0x%x is not queued (%d)\n",
@@ -3121,8 +3138,9 @@ fail_mgmt_tasks(struct iscsi_session *session, struct iscsi_conn *conn)
 		state = ISCSI_TASK_ABRT_SESS_RECOV;
 		if (task->state == ISCSI_TASK_PENDING)
 			state = ISCSI_TASK_COMPLETED;
+		spin_lock_bh(&session->back_lock);
 		iscsi_complete_task(task, state);
-
+		spin_unlock_bh(&session->back_lock);
 	}
 }
 
-- 
2.16.4
