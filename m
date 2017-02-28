From: lixiubo@cmss.chinamobile.com
Subject: [PATCH] target/user: Fix possible overwrite of t_data_sg's last iov[]
Date: Tue, 28 Feb 2017 13:47:08 +0800
Message-ID: <1488260828-28167-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: agrover@redhat.com, nab@linux-iscsi.org
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, mchristi@redhat.com, Xiubo Li <lixiubo@cmss.chinamobile.com>
List-Id: linux-scsi@vger.kernel.org

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

If there has BIDI data, its first iov[] will overwrite the last
iov[] for se_cmd->t_data_sg.

To fix this, we can just increase the iov pointer, but this may
introuduce a new memory leakage bug: If the se_cmd->data_length
and se_cmd->t_bidi_data_sg->length are all not aligned up to the
DATA_BLOCK_SIZE, the actual length needed maybe larger than just
sum of them.

So, this could be avoided by rounding all the data lengthes up
to DATA_BLOCK_SIZE.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
---
 drivers/target/target_core_user.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 2e33100..59a18fd 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -429,10 +429,11 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
 
 	mb = udev->mb_addr;
 	cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
-	data_length = se_cmd->data_length;
+	data_length = round_up(se_cmd->data_length, DATA_BLOCK_SIZE);
 	if (se_cmd->se_cmd_flags & SCF_BIDI) {
 		BUG_ON(!(se_cmd->t_bidi_data_sg && se_cmd->t_bidi_data_nents));
-		data_length += se_cmd->t_bidi_data_sg->length;
+		data_length += round_up(se_cmd->t_bidi_data_sg->length,
+				DATA_BLOCK_SIZE);
 	}
 	if ((command_size > (udev->cmdr_size / 2)) ||
 	    data_length > udev->data_size) {
@@ -503,10 +504,14 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
 	entry->req.iov_dif_cnt = 0;
 
 	/* Handle BIDI commands */
-	iov_cnt = 0;
-	alloc_and_scatter_data_area(udev, se_cmd->t_bidi_data_sg,
-		se_cmd->t_bidi_data_nents, &iov, &iov_cnt, false);
-	entry->req.iov_bidi_cnt = iov_cnt;
+	if (se_cmd->se_cmd_flags & SCF_BIDI) {
+		iov_cnt = 0;
+		iov++;
+		alloc_and_scatter_data_area(udev, se_cmd->t_bidi_data_sg,
+				se_cmd->t_bidi_data_nents, &iov, &iov_cnt,
+				false);
+		entry->req.iov_bidi_cnt = iov_cnt;
+	}
 
 	/* cmd's data_bitmap is what changed in process */
 	bitmap_xor(tcmu_cmd->data_bitmap, old_bitmap, udev->data_bitmap,
-- 
1.8.3.1
