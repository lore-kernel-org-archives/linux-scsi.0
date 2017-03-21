From: lixiubo@cmss.chinamobile.com
Subject: [PATCHv4 1/4] tcmu: Fix possible overwrite of t_data_sg's last iov[]
Date: Tue, 21 Mar 2017 16:36:19 +0800
Message-ID: <1490085382-28658-2-git-send-email-lixiubo@cmss.chinamobile.com>
References: <1490085382-28658-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1490085382-28658-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: target-devel-owner@vger.kernel.org
To: agrover@redhat.com, nab@linux-iscsi.org, mchristi@redhat.com
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, bryantly@linux.vnet.ibm.com, Xiubo Li <lixiubo@cmss.chinamobile.com>
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
Signed-off-by: Bryant G. Ly <bryantly@linux.vnet.ibm.com>
---
 drivers/target/target_core_user.c | 34 +++++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 57defc3..65d475f 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -394,6 +394,20 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
 	return true;
 }
 
+static inline size_t tcmu_cmd_get_data_length(struct tcmu_cmd *tcmu_cmd)
+{
+	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
+	size_t data_length = round_up(se_cmd->data_length, DATA_BLOCK_SIZE);
+
+	if (se_cmd->se_cmd_flags & SCF_BIDI) {
+		BUG_ON(!(se_cmd->t_bidi_data_sg && se_cmd->t_bidi_data_nents));
+		data_length += round_up(se_cmd->t_bidi_data_sg->length,
+				DATA_BLOCK_SIZE);
+	}
+
+	return data_length;
+}
+
 static sense_reason_t
 tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 {
@@ -407,7 +421,7 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
 	uint32_t cmd_head;
 	uint64_t cdb_off;
 	bool copy_to_data_area;
-	size_t data_length;
+	size_t data_length = tcmu_cmd_get_data_length(tcmu_cmd);
 	DECLARE_BITMAP(old_bitmap, DATA_BLOCK_BITS);
 
 	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags))
@@ -433,11 +447,6 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
 
 	mb = udev->mb_addr;
 	cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
-	data_length = se_cmd->data_length;
-	if (se_cmd->se_cmd_flags & SCF_BIDI) {
-		BUG_ON(!(se_cmd->t_bidi_data_sg && se_cmd->t_bidi_data_nents));
-		data_length += se_cmd->t_bidi_data_sg->length;
-	}
 	if ((command_size > (udev->cmdr_size / 2)) ||
 	    data_length > udev->data_size) {
 		pr_warn("TCMU: Request of size %zu/%zu is too big for %u/%zu "
@@ -511,11 +520,14 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, size_t cmd_size, size_t d
 	entry->req.iov_dif_cnt = 0;
 
 	/* Handle BIDI commands */
-	iov_cnt = 0;
-	alloc_and_scatter_data_area(udev, se_cmd->t_bidi_data_sg,
-		se_cmd->t_bidi_data_nents, &iov, &iov_cnt, false);
-	entry->req.iov_bidi_cnt = iov_cnt;
-
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
 			DATA_BLOCK_BITS);
-- 
1.8.3.1
