From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 033/103] target: Handle functions returning "-2"
Date: Thu, 21 Jul 2011 00:07:45 -0700
Message-ID: <1311232135-6653-34-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm4.access.bullet.mail.sp2.yahoo.com ([98.139.44.131]:30649
	"HELO nm4.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752301Ab1GUHIm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:08:42 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

These functions escaped the first round of fixing retvals to use
errno values. It also looks like some callers check the error return
value and do different things, so I replaced all -2s with -EINVAL, and
fixed up callsites accordingly. This may have introduced some bugs,
hopefully not.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c     |    4 ++--
 drivers/target/target_core_transport.c |   12 ++++++------
 drivers/target/tcm_fc/tfc_cmd.c        |    4 ++--
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index ee344c4..38e936b 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -150,10 +150,10 @@ static int tcm_loop_new_cmd_map(struct se_cmd *se_cmd)
 	 * Allocate the necessary tasks to complete the received CDB+data
 	 */
 	ret = transport_generic_allocate_tasks(se_cmd, tl_cmd->sc->cmnd);
-	if (ret == -1) {
+	if (ret == -ENOMEM) {
 		/* Out of Resources */
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
-	} else if (ret == -2) {
+	} else if (ret == -EINVAL) {
 		/*
 		 * Handle case for SAM_STAT_RESERVATION_CONFLICT
 		 */
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index d7ee5603..4caab19 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1852,7 +1852,7 @@ int transport_generic_allocate_tasks(
 	if (transport_check_alloc_task_attr(cmd) < 0) {
 		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		cmd->scsi_sense_reason = TCM_INVALID_CDB_FIELD;
-		return -2;
+		return -EINVAL;
 	}
 	spin_lock(&cmd->se_lun->lun_sep_lock);
 	if (cmd->se_lun->lun_sep)
@@ -2951,7 +2951,7 @@ transport_handle_reservation_conflict(struct se_cmd *cmd)
 		core_scsi3_ua_allocate(cmd->se_sess->se_node_acl,
 			cmd->orig_fe_lun, 0x2C,
 			ASCQ_2CH_PREVIOUS_RESERVATION_CONFLICT_STATUS);
-	return -2;
+	return -EINVAL;
 }
 
 /*	transport_generic_cmd_sequencer():
@@ -2982,7 +2982,7 @@ static int transport_generic_cmd_sequencer(
 				&transport_nop_wait_for_tasks;
 		cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 		cmd->scsi_sense_reason = TCM_CHECK_CONDITION_UNIT_ATTENTION;
-		return -2;
+		return -EINVAL;
 	}
 	/*
 	 * Check status of Asymmetric Logical Unit Assignment port
@@ -3004,7 +3004,7 @@ static int transport_generic_cmd_sequencer(
 			transport_set_sense_codes(cmd, 0x04, alua_ascq);
 			cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 			cmd->scsi_sense_reason = TCM_CHECK_CONDITION_NOT_READY;
-			return -2;
+			return -EINVAL;
 		}
 		goto out_invalid_cdb_field;
 	}
@@ -3553,11 +3553,11 @@ static int transport_generic_cmd_sequencer(
 out_unsupported_cdb:
 	cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 	cmd->scsi_sense_reason = TCM_UNSUPPORTED_SCSI_OPCODE;
-	return -2;
+	return -EINVAL;
 out_invalid_cdb_field:
 	cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
 	cmd->scsi_sense_reason = TCM_INVALID_CDB_FIELD;
-	return -2;
+	return -EINVAL;
 }
 
 static inline void transport_release_tasks(struct se_cmd *);
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index b98f986..161e3c9 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -650,13 +650,13 @@ static void ft_send_cmd(struct ft_cmd *cmd)
 	FT_IO_DBG("r_ctl %x alloc task ret %d\n", fh->fh_r_ctl, ret);
 	ft_dump_cmd(cmd, __func__);
 
-	if (ret == -1) {
+	if (ret == -ENOMEM) {
 		transport_send_check_condition_and_sense(se_cmd,
 				TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, 0);
 		transport_generic_free_cmd(se_cmd, 0, 1, 0);
 		return;
 	}
-	if (ret == -2) {
+	if (ret == -EINVAL) {
 		if (se_cmd->se_cmd_flags & SCF_SCSI_RESERVATION_CONFLICT)
 			ft_queue_status(se_cmd);
 		else
-- 
1.7.6

