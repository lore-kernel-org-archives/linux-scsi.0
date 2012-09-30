From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 5/6] iscsi-target: Add MaxXmitDataSegmentLength connection recovery check
Date: Sun, 30 Sep 2012 05:58:15 +0000
Message-ID: <1348984696-30992-6-git-send-email-nab@linux-iscsi.org>
References: <1348984696-30992-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348984696-30992-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

The iSCSI TMR TASK_REASSIGN completion logic in iscsi_tmr_task_reassign()
does an explict check for MRDSL across task reassignment, so go ahead and
add an explict MaxXmitDataSegmentLength check here as well to be safe.

Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Andy Grover <agrover@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target_core.h |    1 +
 drivers/target/iscsi/iscsi_target_erl2.c |    1 +
 drivers/target/iscsi/iscsi_target_tmr.c  |    9 ++++++++-
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_core.h b/drivers/target/iscsi/iscsi_target_core.h
index b26611a..e6a8305 100644
--- a/drivers/target/iscsi/iscsi_target_core.h
+++ b/drivers/target/iscsi/iscsi_target_core.h
@@ -579,6 +579,7 @@ struct iscsi_conn_recovery {
 	u16			cid;
 	u32			cmd_count;
 	u32			maxrecvdatasegmentlength;
+	u32			maxxmitdatasegmentlength;
 	int			ready_for_reallegiance;
 	struct list_head	conn_recovery_cmd_list;
 	spinlock_t		conn_recovery_cmd_lock;
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index 65aac14..667c19c 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -421,6 +421,7 @@ int iscsit_prepare_cmds_for_realligance(struct iscsi_conn *conn)
 	cr->cid = conn->cid;
 	cr->cmd_count = cmd_count;
 	cr->maxrecvdatasegmentlength = conn->conn_ops->MaxRecvDataSegmentLength;
+	cr->maxxmitdatasegmentlength = conn->conn_ops->MaxXmitDataSegmentLength;
 	cr->sess = conn->sess;
 
 	iscsit_attach_inactive_connection_recovery_entry(conn->sess, cr);
diff --git a/drivers/target/iscsi/iscsi_target_tmr.c b/drivers/target/iscsi/iscsi_target_tmr.c
index f62fe12..05d2e64 100644
--- a/drivers/target/iscsi/iscsi_target_tmr.c
+++ b/drivers/target/iscsi/iscsi_target_tmr.c
@@ -146,7 +146,7 @@ u8 iscsit_tmr_task_reassign(
 	}
 	/*
 	 * Temporary check to prevent connection recovery for
-	 * connections with a differing MaxRecvDataSegmentLength.
+	 * connections with a differing Max*DataSegmentLength.
 	 */
 	if (cr->maxrecvdatasegmentlength !=
 	    conn->conn_ops->MaxRecvDataSegmentLength) {
@@ -155,6 +155,13 @@ u8 iscsit_tmr_task_reassign(
 			" TMR TASK_REASSIGN.\n");
 		return ISCSI_TMF_RSP_REJECTED;
 	}
+	if (cr->maxxmitdatasegmentlength !=
+	    conn->conn_ops->MaxXmitDataSegmentLength) {
+		pr_err("Unable to perform connection recovery for"
+			" differing MaxXmitDataSegmentLength, rejecting"
+			" TMR TASK_REASSIGN.\n");
+		return ISCSI_TMF_RSP_REJECTED;
+	}
 
 	ref_lun = scsilun_to_int(&hdr->lun);
 	if (ref_lun != ref_cmd->se_cmd.orig_fe_lun) {
-- 
1.7.2.5
