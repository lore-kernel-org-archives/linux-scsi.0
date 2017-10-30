From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 04/19] tcmu: fix double se_cmd completion
Date: Sun, 29 Oct 2017 22:44:24 -0500
Message-ID: <1509335079-5276-5-git-send-email-mchristi@redhat.com>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44554 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752176AbdJ3Dor (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Oct 2017 23:44:47 -0400
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Mike Christie <mchristi@redhat.com>

If cmd_time_out != 0, then tcmu_queue_cmd_ring could end up
sleeping waiting for ring space, timing out and then returning
failure to lio, and tcmu_check_expired_cmd could also detect
the timeout and call target_complete_cmd on the cmd.

This patch just delays setting up the deadline value and adding
the cmd to the udev->commands idr until we have allocated ring
space and are about to send the cmd to userspace.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 54 ++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 1207b5b..4f666a5 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -432,7 +432,6 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 	struct se_device *se_dev = se_cmd->se_dev;
 	struct tcmu_dev *udev = TCMU_DEV(se_dev);
 	struct tcmu_cmd *tcmu_cmd;
-	int cmd_id;
 
 	tcmu_cmd = kmem_cache_zalloc(tcmu_cmd_cache, GFP_KERNEL);
 	if (!tcmu_cmd)
@@ -440,9 +439,6 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 
 	tcmu_cmd->se_cmd = se_cmd;
 	tcmu_cmd->tcmu_dev = udev;
-	if (udev->cmd_time_out)
-		tcmu_cmd->deadline = jiffies +
-					msecs_to_jiffies(udev->cmd_time_out);
 
 	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
 	tcmu_cmd->dbi_cnt = tcmu_cmd_get_block_cnt(tcmu_cmd);
@@ -453,19 +449,6 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 		return NULL;
 	}
 
-	idr_preload(GFP_KERNEL);
-	spin_lock_irq(&udev->commands_lock);
-	cmd_id = idr_alloc(&udev->commands, tcmu_cmd, 0,
-		USHRT_MAX, GFP_NOWAIT);
-	spin_unlock_irq(&udev->commands_lock);
-	idr_preload_end();
-
-	if (cmd_id < 0) {
-		tcmu_free_cmd(tcmu_cmd);
-		return NULL;
-	}
-	tcmu_cmd->cmd_id = cmd_id;
-
 	return tcmu_cmd;
 }
 
@@ -748,6 +731,30 @@ static inline size_t tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
 	return command_size;
 }
 
+static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
+{
+	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
+	unsigned long tmo = udev->cmd_time_out;
+	int cmd_id;
+
+	if (tcmu_cmd->cmd_id)
+		return 0;
+
+	cmd_id = idr_alloc(&udev->commands, tcmu_cmd, 1, USHRT_MAX, GFP_NOWAIT);
+	if (cmd_id < 0) {
+		pr_err("tcmu: Could not allocate cmd id.\n");
+		return cmd_id;
+	}
+	tcmu_cmd->cmd_id = cmd_id;
+
+	if (!tmo)
+		return 0;
+
+	tcmu_cmd->deadline = round_jiffies_up(jiffies + msecs_to_jiffies(tmo));
+	mod_timer(&udev->timeout, tcmu_cmd->deadline);
+	return 0;
+}
+
 static sense_reason_t
 tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 {
@@ -841,7 +848,6 @@ static inline size_t tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
 	entry = (void *) mb + CMDR_OFF + cmd_head;
 	memset(entry, 0, command_size);
 	tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_CMD);
-	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
 
 	/* Handle allocating space from the data area */
 	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
@@ -879,6 +885,13 @@ static inline size_t tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
 	}
 	entry->req.iov_bidi_cnt = iov_cnt;
 
+	ret = tcmu_setup_cmd_timer(tcmu_cmd);
+	if (ret) {
+		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
+		return TCM_OUT_OF_RESOURCES;
+	}
+	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
+
 	/*
 	 * Recalaulate the command's base size and size according
 	 * to the actual needs
@@ -912,8 +925,6 @@ static inline size_t tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
 static sense_reason_t
 tcmu_queue_cmd(struct se_cmd *se_cmd)
 {
-	struct se_device *se_dev = se_cmd->se_dev;
-	struct tcmu_dev *udev = TCMU_DEV(se_dev);
 	struct tcmu_cmd *tcmu_cmd;
 	sense_reason_t ret;
 
@@ -924,9 +935,6 @@ static inline size_t tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
 	ret = tcmu_queue_cmd_ring(tcmu_cmd);
 	if (ret != TCM_NO_SENSE) {
 		pr_err("TCMU: Could not queue command\n");
-		spin_lock_irq(&udev->commands_lock);
-		idr_remove(&udev->commands, tcmu_cmd->cmd_id);
-		spin_unlock_irq(&udev->commands_lock);
 
 		tcmu_free_cmd(tcmu_cmd);
 	}
-- 
1.8.3.1
