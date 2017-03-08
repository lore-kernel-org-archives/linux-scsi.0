From: lixiubo@cmss.chinamobile.com
Subject: [PATCHv2 5/5] target/user: Clean up tcmu_queue_cmd_ring
Date: Wed,  8 Mar 2017 16:45:43 +0800
Message-ID: <1488962743-17028-6-git-send-email-lixiubo@cmss.chinamobile.com>
References: <1488962743-17028-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1488962743-17028-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: agrover@redhat.com, nab@linux-iscsi.org, mchristi@redhat.com
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, Xiubo Li <lixiubo@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

Add two helpers to simplify the code, and move some code out of
the cmdr spin lock to reduce the size of critical region.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
---
 drivers/target/target_core_user.c | 54 ++++++++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 24 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 117be07..5205d2f 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -366,18 +366,22 @@ static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
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
+static inline uint32_t tcmu_cmd_get_dbi_len(struct se_cmd *se_cmd)
+{
+	size_t data_length = tcmu_cmd_get_data_length(se_cmd);
 
-	return dbi_len;
+	return data_length / DATA_BLOCK_SIZE;
 }
 
 static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
@@ -624,13 +628,27 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	return true;
 }
 
+static inline void tcmu_cmd_get_cmd_size(struct se_cmd *se_cmd,
+			size_t *base_size, size_t *cmd_size)
+{
+	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
+
+	*base_size = max(offsetof(struct tcmu_cmd_entry,
+				 req.iov[tcmu_cmd->dbi_len]),
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
@@ -642,6 +660,8 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags))
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
+	if (se_cmd->se_cmd_flags & SCF_BIDI)
+		BUG_ON(!(se_cmd->t_bidi_data_sg && se_cmd->t_bidi_data_nents));
 	/*
 	 * Must be a certain minimum size for response sense info, but
 	 * also may be larger if the iov array is large.
@@ -649,33 +669,19 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
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
-- 
1.8.3.1
