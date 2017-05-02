From: lixiubo@cmss.chinamobile.com
Subject: [PATCH] tcmu: Recalculate the tcmu_cmd size to save cmd area memories
Date: Tue,  2 May 2017 15:54:29 +0800
Message-ID: <1493711669-31508-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: mchristi@redhat.com, nab@linux-iscsi.org
Cc: agrover@redhat.com, namei.unix@gmail.com, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Xiubo Li <lixiubo@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

For the "struct tcmu_cmd_entry" in cmd area, the minimum size
will be sizeof(struct tcmu_cmd_entry) == 112 Bytes. And it could
fill about (sizeof(struct rsp) - sizeof(struct req)) /
sizeof(struct iovec) == 68 / 16 ~= 4 data regions(iov[4]) by
default.

For most tcmu_cmds, the data block indexes allocated from the
data area will be continuous. And for the continuous blocks they
will be merged into the same region using only one iovec. For
the current code, it will always allocates the same number of
iovecs with blocks for each tcmu_cmd, and it will wastes much
memories.

For example, when the block size is 4K and the DATA_OUT buffer
size is 64K, and the regions needed is less than 5(on my
environment is almost 99.7%). The current code will allocate
about 16 iovecs, and there will be (16 - 4) * sizeof(struct
iovec) = 192 Bytes cmd area memories wasted.

Here adds two helpers to calculate the base size and full size
of the tcmu_cmd. And will recalculate them again when it make sure
how many iovs is needed before insert it to cmd area.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
---
 drivers/target/target_core_user.c | 52 ++++++++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 0b29e4f..89b75ce 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -602,6 +602,27 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	return true;
 }
 
+static inline size_t tcmu_cmd_get_base_cmd_size(size_t iov_cnt)
+{
+	return max(offsetof(struct tcmu_cmd_entry, req.iov[iov_cnt]),
+			sizeof(struct tcmu_cmd_entry));
+}
+
+static inline size_t tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
+					   size_t base_command_size)
+{
+	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
+	size_t command_size;
+
+	command_size = base_command_size +
+		round_up(scsi_command_size(se_cmd->t_task_cdb),
+				TCMU_OP_ALIGN_SIZE);
+
+	WARN_ON(command_size & (TCMU_OP_ALIGN_SIZE-1));
+
+	return command_size;
+}
+
 static sense_reason_t
 tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 {
@@ -624,16 +645,16 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	 * Must be a certain minimum size for response sense info, but
 	 * also may be larger if the iov array is large.
 	 *
-	 * We prepare way too many iovs for potential uses here, because it's
-	 * expensive to tell how many regions are freed in the bitmap
-	*/
-	base_command_size = max(offsetof(struct tcmu_cmd_entry,
-				req.iov[tcmu_cmd_get_block_cnt(tcmu_cmd)]),
-				sizeof(struct tcmu_cmd_entry));
-	command_size = base_command_size
-		+ round_up(scsi_command_size(se_cmd->t_task_cdb), TCMU_OP_ALIGN_SIZE);
-
-	WARN_ON(command_size & (TCMU_OP_ALIGN_SIZE-1));
+	 * We prepare as many iovs as possbile for potential uses here,
+	 * because it's expensive to tell how many regions are freed in
+	 * the bitmap & global data pool, as the size calculated here
+	 * will only be used to do the checks.
+	 *
+	 * The size will be recalculated later as actually needed to save
+	 * cmd area memories.
+	 */
+	base_command_size = tcmu_cmd_get_base_cmd_size(tcmu_cmd->dbi_cnt);
+	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
 
 	mutex_lock(&udev->cmdr_lock);
 
@@ -694,7 +715,6 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	entry = (void *) mb + CMDR_OFF + cmd_head;
 	tcmu_flush_dcache_range(entry, sizeof(*entry));
 	tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_CMD);
-	tcmu_hdr_set_len(&entry->hdr.len_op, command_size);
 	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
 	entry->hdr.kflags = 0;
 	entry->hdr.uflags = 0;
@@ -736,6 +756,16 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 		entry->req.iov_bidi_cnt = iov_cnt;
 	}
 
+	/*
+	 * Recalaulate the command's base size and size according
+	 * to the actual needs
+	 */
+	base_command_size = tcmu_cmd_get_base_cmd_size(entry->req.iov_cnt +
+						       entry->req.iov_bidi_cnt);
+	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
+
+	tcmu_hdr_set_len(&entry->hdr.len_op, command_size);
+
 	/* All offsets relative to mb_addr, not start of entry! */
 	cdb_off = CMDR_OFF + cmd_head + base_command_size;
 	memcpy((void *) mb + cdb_off, se_cmd->t_task_cdb, scsi_command_size(se_cmd->t_task_cdb));
-- 
1.8.3.1
