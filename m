From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 14/19] tcmu: prep queue_cmd_ring to be used by unmap wq
Date: Sun, 29 Oct 2017 22:44:34 -0500
Message-ID: <1509335079-5276-15-git-send-email-mchristi@redhat.com>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56070 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752250AbdJ3DpC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Oct 2017 23:45:02 -0400
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Mike Christie <mchristi@redhat.com>

In the next patch we will call queue_cmd_ring from the submitting
context and also the unmap wq when blocks free. This changes
the queue_cmd_ring return code so in the next patch we can
return a sense_reason_t and also tell the caller if the cmd
was internally queued.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 41 +++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 91e0601..68668a8 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -775,8 +775,16 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 	return 0;
 }
 
-static sense_reason_t
-tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
+/**
+ * queue_cmd_ring - queue cmd to ring or internally
+ * @tcmu_cmd: cmd to queue
+ * @scsi_err: TCM error code if failure (-1) returned.
+ *
+ * Returns:
+ * -1 we cannot queue internally or to the ring.
+ *  0 success
+ */
+static sense_reason_t queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, int *scsi_err)
 {
 	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
 	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
@@ -790,8 +798,12 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 	bool copy_to_data_area;
 	size_t data_length = tcmu_cmd_get_data_length(tcmu_cmd);
 
-	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags))
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	*scsi_err = TCM_NO_SENSE;
+
+	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags)) {
+		*scsi_err = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		return -1;
+	}
 
 	/*
 	 * Must be a certain minimum size for response sense info, but
@@ -818,7 +830,8 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 			"cmd ring/data area\n", command_size, data_length,
 			udev->cmdr_size, udev->data_size);
 		mutex_unlock(&udev->cmdr_lock);
-		return TCM_INVALID_CDB_FIELD;
+		*scsi_err = TCM_INVALID_CDB_FIELD;
+		return -1;
 	}
 
 	while (!is_ring_space_avail(udev, tcmu_cmd, command_size, data_length)) {
@@ -844,7 +857,8 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 		finish_wait(&udev->wait_cmdr, &__wait);
 		if (!ret) {
 			pr_warn("tcmu: command timed out\n");
-			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+			*scsi_err = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+			return -1;
 		}
 
 		mutex_lock(&udev->cmdr_lock);
@@ -900,7 +914,8 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 	ret = tcmu_setup_cmd_timer(tcmu_cmd);
 	if (ret) {
 		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
-		return TCM_OUT_OF_RESOURCES;
+		*scsi_err = TCM_OUT_OF_RESOURCES;
+		return -1;
 	}
 	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
 
@@ -931,27 +946,23 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 		mod_timer(&udev->timeout, round_jiffies_up(jiffies +
 			  msecs_to_jiffies(udev->cmd_time_out)));
 
-	return TCM_NO_SENSE;
+	return 0;
 }
 
 static sense_reason_t
 tcmu_queue_cmd(struct se_cmd *se_cmd)
 {
 	struct tcmu_cmd *tcmu_cmd;
-	sense_reason_t ret;
+	sense_reason_t scsi_ret;
 
 	tcmu_cmd = tcmu_alloc_cmd(se_cmd);
 	if (!tcmu_cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	ret = tcmu_queue_cmd_ring(tcmu_cmd);
-	if (ret != TCM_NO_SENSE) {
-		pr_err("TCMU: Could not queue command\n");
-
+	if (queue_cmd_ring(tcmu_cmd, &scsi_ret) < 0)
 		tcmu_free_cmd(tcmu_cmd);
-	}
 
-	return ret;
+	return scsi_ret;
 }
 
 static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *entry)
-- 
1.8.3.1
