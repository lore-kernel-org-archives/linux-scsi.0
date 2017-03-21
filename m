From: lixiubo@cmss.chinamobile.com
Subject: [PATCHv4 2/4] tcmu: Fix wrongly calculating of the base_command_size
Date: Tue, 21 Mar 2017 16:36:20 +0800
Message-ID: <1490085382-28658-3-git-send-email-lixiubo@cmss.chinamobile.com>
References: <1490085382-28658-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1490085382-28658-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: agrover@redhat.com, nab@linux-iscsi.org, mchristi@redhat.com
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, bryantly@linux.vnet.ibm.com, Xiubo Li <lixiubo@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

The t_data_nents and t_bidi_data_nents are the numbers of the
segments, but it couldn't be sure the block size equals to size
of the segment.

For the worst case, all the blocks are discontiguous and there
will need the same number of iovecs, that's to say: blocks == iovs.
So here just set the number of iovs to block count needed by tcmu
cmd.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
---
 drivers/target/target_core_user.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 65d475f..ae5b74f 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -408,6 +408,13 @@ static inline size_t tcmu_cmd_get_data_length(struct tcmu_cmd *tcmu_cmd)
 	return data_length;
 }
 
+static inline uint32_t tcmu_cmd_get_block_cnt(struct tcmu_cmd *tcmu_cmd)
+{
+	size_t data_length = tcmu_cmd_get_data_length(tcmu_cmd);
+
+	return (data_length + DATA_BLOCK_SIZE - 1) / DATA_BLOCK_SIZE;
+}
+
 static sense_reason_t
 tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 {
@@ -435,8 +442,7 @@ static inline size_t tcmu_cmd_get_data_length(struct tcmu_cmd *tcmu_cmd)
 	 * expensive to tell how many regions are freed in the bitmap
 	*/
 	base_command_size = max(offsetof(struct tcmu_cmd_entry,
-				req.iov[se_cmd->t_bidi_data_nents +
-					se_cmd->t_data_nents]),
+				req.iov[tcmu_cmd_get_block_cnt(tcmu_cmd)]),
 				sizeof(struct tcmu_cmd_entry));
 	command_size = base_command_size
 		+ round_up(scsi_command_size(se_cmd->t_task_cdb), TCMU_OP_ALIGN_SIZE);
-- 
1.8.3.1
