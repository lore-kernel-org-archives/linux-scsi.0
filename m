From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 2/2] target: Fix race for SCF_COMPARE_AND_WRITE_POST checking
Date: Sun, 15 Nov 2015 00:21:43 +0000
Message-ID: <1447546903-15305-3-git-send-email-nab@daterainc.com>
References: <1447546903-15305-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1447546903-15305-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch addresses a race + use after free where the first
stage of COMPARE_AND_WRITE in compare_and_write_callback()
is rescheduled after the backend sends the secondary WRITE,
resulting in second stage compare_and_write_post() callback
completing in target_complete_ok_work() before the first
can return.

Because current code depends on checking se_cmd->se_cmd_flags
after return from se_cmd->transport_complete_callback(),
this results in first stage having SCF_COMPARE_AND_WRITE_POST
set, which incorrectly falls through into second stage CAW
processing code, eventually triggering a NULL pointer
dereference due to use after free.

To address this bug, pass in a new *post_ret parameter into
se_cmd->transport_complete_callback(), and depend upon this
value instead of ->se_cmd_flags to determine when to return
or fall through into ->queue_status() code for CAW.

Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: <stable@vger.kernel.org> # v3.12+
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_sbc.c       | 13 +++++++++----
 drivers/target/target_core_transport.c | 14 ++++++++------
 include/target/target_core_base.h      |  2 +-
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 0b4b2a6..ae24d0f 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -371,7 +371,8 @@ sbc_setup_write_same(struct se_cmd *cmd, unsigned char *flags, struct sbc_ops *o
 	return 0;
 }
 
-static sense_reason_t xdreadwrite_callback(struct se_cmd *cmd, bool success)
+static sense_reason_t xdreadwrite_callback(struct se_cmd *cmd, bool success,
+					   int *post_ret)
 {
 	unsigned char *buf, *addr;
 	struct scatterlist *sg;
@@ -437,7 +438,8 @@ sbc_execute_rw(struct se_cmd *cmd)
 			       cmd->data_direction);
 }
 
-static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success)
+static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success,
+					     int *post_ret)
 {
 	struct se_device *dev = cmd->se_dev;
 
@@ -447,8 +449,10 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success)
 	 * sent to the backend driver.
 	 */
 	spin_lock_irq(&cmd->t_state_lock);
-	if ((cmd->transport_state & CMD_T_SENT) && !cmd->scsi_status)
+	if ((cmd->transport_state & CMD_T_SENT) && !cmd->scsi_status) {
 		cmd->se_cmd_flags |= SCF_COMPARE_AND_WRITE_POST;
+		*post_ret = 1;
+	}
 	spin_unlock_irq(&cmd->t_state_lock);
 
 	/*
@@ -460,7 +464,8 @@ static sense_reason_t compare_and_write_post(struct se_cmd *cmd, bool success)
 	return TCM_NO_SENSE;
 }
 
-static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool success)
+static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool success,
+						 int *post_ret)
 {
 	struct se_device *dev = cmd->se_dev;
 	struct scatterlist *write_sg = NULL, *sg;
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5bacc7b..010b8c4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1658,7 +1658,7 @@ bool target_stop_cmd(struct se_cmd *cmd, unsigned long *flags)
 void transport_generic_request_failure(struct se_cmd *cmd,
 		sense_reason_t sense_reason)
 {
-	int ret = 0;
+	int ret = 0, post_ret = 0;
 
 	pr_debug("-----[ Storage Engine Exception for cmd: %p ITT: 0x%08llx"
 		" CDB: 0x%02x\n", cmd, cmd->tag, cmd->t_task_cdb[0]);
@@ -1680,7 +1680,7 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	 */
 	if ((cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE) &&
 	     cmd->transport_complete_callback)
-		cmd->transport_complete_callback(cmd, false);
+		cmd->transport_complete_callback(cmd, false, &post_ret);
 
 	switch (sense_reason) {
 	case TCM_NON_EXISTENT_LUN:
@@ -2068,11 +2068,13 @@ static void target_complete_ok_work(struct work_struct *work)
 	 */
 	if (cmd->transport_complete_callback) {
 		sense_reason_t rc;
+		bool caw = (cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE);
+		bool zero_dl = !(cmd->data_length);
+		int post_ret = 0;
 
-		rc = cmd->transport_complete_callback(cmd, true);
-		if (!rc && !(cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE_POST)) {
-			if ((cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE) &&
-			    !cmd->data_length)
+		rc = cmd->transport_complete_callback(cmd, true, &post_ret);
+		if (!rc && !post_ret) {
+			if (caw && zero_dl)
 				goto queue_rsp;
 
 			return;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 8b9c727..61a0393 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -474,7 +474,7 @@ struct se_cmd {
 	struct completion	cmd_wait_comp;
 	const struct target_core_fabric_ops *se_tfo;
 	sense_reason_t		(*execute_cmd)(struct se_cmd *);
-	sense_reason_t (*transport_complete_callback)(struct se_cmd *, bool);
+	sense_reason_t (*transport_complete_callback)(struct se_cmd *, bool, int *);
 	void			*protocol_data;
 
 	unsigned char		*t_task_cdb;
-- 
1.9.1
