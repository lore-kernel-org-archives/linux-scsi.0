From: lixiubo@cmss.chinamobile.com
Subject: [PATCHv2 4/5] target/user: Fix wrongly calculating of the base_command_size
Date: Wed,  8 Mar 2017 16:45:42 +0800
Message-ID: <1488962743-17028-5-git-send-email-lixiubo@cmss.chinamobile.com>
References: <1488962743-17028-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1488962743-17028-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: agrover@redhat.com, nab@linux-iscsi.org, mchristi@redhat.com
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, Xiubo Li <lixiubo@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

The t_data_nents and t_bidi_data_nents are all the numbers of the
segments, and we couldn't be sure the size of the data area block
will equal to size of the segment.

Use the actually block number needed intead of the sum of segments.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
---
 drivers/target/target_core_user.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 99cd239..117be07 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -650,8 +650,7 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	 * expensive to tell how many regions are freed in the bitmap
 	*/
 	base_command_size = max(offsetof(struct tcmu_cmd_entry,
-				req.iov[se_cmd->t_bidi_data_nents +
-					se_cmd->t_data_nents]),
+				req.iov[tcmu_cmd->dbi_len]),
 				sizeof(struct tcmu_cmd_entry));
 	command_size = base_command_size
 		+ round_up(scsi_command_size(se_cmd->t_task_cdb), TCMU_OP_ALIGN_SIZE);
-- 
1.8.3.1
