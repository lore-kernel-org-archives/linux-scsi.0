From: Michael Cyr <mikecyr@linux.vnet.ibm.com>
Subject: [PATCH] Fix for hang of Ordered task in TCM
Date: Fri, 13 May 2016 17:15:41 -0500
Message-ID: <1463177741-4385-1-git-send-email-mikecyr@linux.vnet.ibm.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: nab@linux-iscsi.org
Cc: rjui@broadcom.com, sbranden@broadcom.com, jonmason@broadcom.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, bcm-kernel-feedback-list@broadcom.com, linux-kernel@vger.kernel.org, Michael Cyr <mikecyr@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

If a command with a Simple task attribute is failed due to a Unit
Attention, then a subsequent command with an Ordered task attribute will
hang forever.  The reason for this is that the Unit Attention status is
checked for in target_setup_cmd_from_cdb, before the call to
target_execute_cmd, which calls target_handle_task_attr, which in turn
increments dev->simple_cmds.  However, transport_generic_request_failure
still calls transport_complete_task_attr, which will decrement
dev->simple_cmds.  In this case, simple_cmds is now -1.  So when a
command with the Ordered task attribute is sent, target_handle_task_attr
sees that dev->simple_cmds is not 0, so it decides it can't execute the
command until all the (nonexistent) Simple commands have completed.

The solution I've implemented is to move target_scsi3_ua_check, as well as
target_alua_state_check and target_check_reservation, into
target_execute_cmd, after the call to target_handle_task_attr.  I believe
this is actually the correct way this should be handled.  According to
SAM-4 r14, under section 5.14:

"h) if a command other than INQUIRY, REPORT LUNS, REQUEST SENSE, or NOTIFY
DATA TRANSFER DEVICE enters the enabled command state while a unit
attention condition exists for the SCSI initiator port associated with
the I_T nexus on which the command was received, the device server shall
terminate the command with a CHECK CONDITION status. The device server
shall provide sense data that reports a unit attention condition for the
SCSI initiator port that sent the command on the I_T nexus."

But according to section 8.5 and 8.6, a command which is not yet executed
because of the presence of other tasks in the task set (i.e., one for
which target_handle_task_attr returns true) would not enter the enabled
command state; it would be in the dormant command state.
target_execute_cmd would get called when a command entered the enabled
command state, and thus that is the appropriate place to check for Unit
Attenion.  Similarly, though not quite as explicit, section 5.3.3 tells
us that a Reservation Conflict status has a lower precedence than a Unit
Attention, and so this would also seem to be the appropriate place to
call target_check_reservation.  I'm less sure about
target_alua_state_check, since I'm not very familiar with ALUA.

Signed-off-by: Michael Cyr <mikecyr@linux.vnet.ibm.com>
---
 drivers/target/target_core_transport.c | 41 ++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 6c089af..2ee5502 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1303,23 +1303,6 @@ target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
 
 	trace_target_sequencer_start(cmd);
 
-	/*
-	 * Check for an existing UNIT ATTENTION condition
-	 */
-	ret = target_scsi3_ua_check(cmd);
-	if (ret)
-		return ret;
-
-	ret = target_alua_state_check(cmd);
-	if (ret)
-		return ret;
-
-	ret = target_check_reservation(cmd);
-	if (ret) {
-		cmd->scsi_status = SAM_STAT_RESERVATION_CONFLICT;
-		return ret;
-	}
-
 	ret = dev->transport->parse_cdb(cmd);
 	if (ret == TCM_UNSUPPORTED_SCSI_OPCODE)
 		pr_warn_ratelimited("%s/%s: Unsupported SCSI Opcode 0x%02x, sending CHECK_CONDITION.\n",
@@ -1865,6 +1848,8 @@ static int __transport_check_aborted_status(struct se_cmd *, int);
 
 void target_execute_cmd(struct se_cmd *cmd)
 {
+	sense_reason_t ret;
+
 	/*
 	 * Determine if frontend context caller is requesting the stopping of
 	 * this command for frontend exceptions.
@@ -1899,6 +1884,28 @@ void target_execute_cmd(struct se_cmd *cmd)
 		return;
 	}
 
+	/*
+	 * Check for an existing UNIT ATTENTION condition
+	 */
+	ret = target_scsi3_ua_check(cmd);
+	if (ret) {
+		transport_generic_request_failure(cmd, ret);
+		return;
+	}
+
+	ret = target_alua_state_check(cmd);
+	if (ret) {
+		transport_generic_request_failure(cmd, ret);
+		return;
+	}
+
+	ret = target_check_reservation(cmd);
+	if (ret) {
+		cmd->scsi_status = SAM_STAT_RESERVATION_CONFLICT;
+		transport_generic_request_failure(cmd, ret);
+		return;
+	}
+
 	__target_execute_cmd(cmd);
 }
 EXPORT_SYMBOL(target_execute_cmd);
-- 
2.5.0
