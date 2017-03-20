From: lixiubo@cmss.chinamobile.com
Subject: [PATCHv3 5/5] target/user: Clean up tcmu_queue_cmd_ring
Date: Mon, 20 Mar 2017 17:09:24 +0800
Message-ID: <1490000964-15732-6-git-send-email-lixiubo@cmss.chinamobile.com>
References: <1490000964-15732-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1490000964-15732-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: agrover@redhat.com, nab@linux-iscsi.org, mchristi@redhat.com
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, bryantly@linux.vnet.ibm.com, Xiubo Li <lixiubo@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

Add two helpers to simplify the code, and move some code out of
the cmdr spin lock to reduce the size of critical region.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
---
 drivers/target/target_core_user.c | 68 +++++++++++++++++++++------------------
 1 file changed, 37 insertions(+), 31 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index e3daf15..52fa988 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -153,7 +153,7 @@ struct tcmu_cmd {
 
 	/* Can't use se_cmd when cleaning up expired cmds, because if
 	   cmd has been completed then accessing se_cmd is off limits */
-	uint32_t dbi_len;
+	uint32_t dbi_cnt;
 	uint32_t dbi_cur;
 	uint32_t *dbi;
 
@@ -255,7 +255,7 @@ static bool tcmu_get_empty_blocks(struct tcmu_dev *udev,
 	int i;
 
 	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
-	for (i = 0; i < tcmu_cmd->dbi_len; i++) {
+	for (i = 0; i < tcmu_cmd->dbi_cnt; i++) {
 		if (!tcmu_get_empty_block(udev, tcmu_cmd))
 			goto err;
 	}
@@ -263,7 +263,7 @@ static bool tcmu_get_empty_blocks(struct tcmu_dev *udev,
 
 err:
 	pr_debug("no blocks: only %u blocks available, but ask for %u\n",
-			tcmu_cmd->dbi_len, tcmu_cmd->dbi_cur);
+			tcmu_cmd->dbi_cnt, tcmu_cmd->dbi_cur);
 	tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cur);
 	udev->waiting_global = true;
 	return false;
@@ -286,25 +286,29 @@ static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
 	kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
 }
 
-static inline uint32_t tcmu_cmd_get_dbi_len(struct se_cmd *se_cmd)
+static inline uint32_t tcmu_cmd_get_data_length(struct se_cmd *se_cmd)
 {
 	size_t data_length = round_up(se_cmd->data_length, DATA_BLOCK_SIZE);
-	uint32_t dbi_len;
 
 	if (se_cmd->se_cmd_flags & SCF_BIDI)
 		data_length += round_up(se_cmd->t_bidi_data_sg->length,
 					DATA_BLOCK_SIZE);
 
-	dbi_len = data_length / DATA_BLOCK_SIZE;
+	return data_length;
+}
+
+static inline uint32_t tcmu_cmd_get_dbi_cnt(struct se_cmd *se_cmd)
+{
+	size_t data_length = tcmu_cmd_get_data_length(se_cmd);
 
-	return dbi_len;
+	return data_length / DATA_BLOCK_SIZE;
 }
 
 static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 {
 	struct se_device *se_dev = se_cmd->se_dev;
 	struct tcmu_dev *udev = TCMU_DEV(se_dev);
-	uint32_t dbi_len = tcmu_cmd_get_dbi_len(se_cmd);
+	uint32_t dbi_cnt = tcmu_cmd_get_dbi_cnt(se_cmd);
 	struct tcmu_cmd *tcmu_cmd;
 	int cmd_id;
 
@@ -319,8 +323,8 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 					msecs_to_jiffies(udev->cmd_time_out);
 
 	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
-	tcmu_cmd->dbi_len = dbi_len;
-	tcmu_cmd->dbi = kcalloc(dbi_len, sizeof(uint32_t), GFP_KERNEL);
+	tcmu_cmd->dbi_cnt = dbi_cnt;
+	tcmu_cmd->dbi = kcalloc(dbi_cnt, sizeof(uint32_t), GFP_KERNEL);
 	if (!tcmu_cmd->dbi) {
 		kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
 		return NULL;
@@ -572,13 +576,27 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	return true;
 }
 
+static inline void tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
+			size_t *base_size, size_t *cmd_size)
+{
+	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
+
+	*base_size = max(offsetof(struct tcmu_cmd_entry,
+				 req.iov[tcmu_cmd->dbi_cnt]),
+				 sizeof(struct tcmu_cmd_entry));
+
+	*cmd_size = round_up(scsi_command_size(se_cmd->t_task_cdb),
+			TCMU_OP_ALIGN_SIZE) + *base_size;
+	WARN_ON(*cmd_size & (TCMU_OP_ALIGN_SIZE-1));
+}
+
 static sense_reason_t
 tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 {
 	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
 	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
 	size_t base_command_size, command_size;
-	struct tcmu_mailbox *mb;
+	struct tcmu_mailbox *mb = udev->mb_addr;
 	struct tcmu_cmd_entry *entry;
 	struct iovec *iov;
 	int iov_cnt, ret;
@@ -590,6 +608,8 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags))
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
+	if (se_cmd->se_cmd_flags & SCF_BIDI)
+		BUG_ON(!(se_cmd->t_bidi_data_sg && se_cmd->t_bidi_data_nents));
 	/*
 	 * Must be a certain minimum size for response sense info, but
 	 * also may be larger if the iov array is large.
@@ -597,33 +617,19 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	 * We prepare way too many iovs for potential uses here, because it's
 	 * expensive to tell how many regions are freed in the bitmap
 	*/
-	base_command_size = max(offsetof(struct tcmu_cmd_entry,
-				req.iov[tcmu_cmd->dbi_len]),
-				sizeof(struct tcmu_cmd_entry));
-	command_size = base_command_size
-		+ round_up(scsi_command_size(se_cmd->t_task_cdb), TCMU_OP_ALIGN_SIZE);
-
-	WARN_ON(command_size & (TCMU_OP_ALIGN_SIZE-1));
-
-	spin_lock_irq(&udev->cmdr_lock);
-
-	mb = udev->mb_addr;
-	cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
-	data_length = round_up(se_cmd->data_length, DATA_BLOCK_SIZE);
-	if (se_cmd->se_cmd_flags & SCF_BIDI) {
-		BUG_ON(!(se_cmd->t_bidi_data_sg && se_cmd->t_bidi_data_nents));
-		data_length += round_up(se_cmd->t_bidi_data_sg->length,
-				DATA_BLOCK_SIZE);
-	}
+	tcmu_cmd_get_cmd_size(tcmu_cmd, &base_command_size, &command_size);
+	data_length = tcmu_cmd_get_data_length(se_cmd);
 	if ((command_size > (udev->cmdr_size / 2)) ||
 	    data_length > udev->data_size) {
 		pr_warn("TCMU: Request of size %zu/%zu is too big for %u/%zu "
 			"cmd ring/data area\n", command_size, data_length,
 			udev->cmdr_size, udev->data_size);
-		spin_unlock_irq(&udev->cmdr_lock);
 		return TCM_INVALID_CDB_FIELD;
 	}
 
+	spin_lock_irq(&udev->cmdr_lock);
+
+	cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
 	while (!is_ring_space_avail(udev, tcmu_cmd, command_size, data_length)) {
 		int ret;
 		DEFINE_WAIT(__wait);
@@ -791,7 +797,7 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 
 out:
 	cmd->se_cmd = NULL;
-	tcmu_cmd_free_data(cmd, cmd->dbi_len);
+	tcmu_cmd_free_data(cmd, cmd->dbi_cnt);
 	tcmu_free_cmd(cmd);
 }
 
-- 
1.8.3.1
