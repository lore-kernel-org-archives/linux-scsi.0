From: lixiubo@cmss.chinamobile.com
Subject: [PATCHv2 3/5] target/user: Fix possible overwrite of t_data_sg's last iov[]
Date: Wed,  8 Mar 2017 16:45:41 +0800
Message-ID: <1488962743-17028-4-git-send-email-lixiubo@cmss.chinamobile.com>
References: <1488962743-17028-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:42189 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751235AbdCHIqk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2017 03:46:40 -0500
In-Reply-To: <1488962743-17028-1-git-send-email-lixiubo@cmss.chinamobile.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: agrover@redhat.com, nab@linux-iscsi.org, mchristi@redhat.com
Cc: shli@kernel.org, sheng@yasker.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, namei.unix@gmail.com, Xiubo Li <lixiubo@cmss.chinamobile.com>

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
 drivers/target/target_core_user.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index cd9bc4a..99cd239 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -368,13 +368,14 @@ static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
 
 static inline uint32_t tcmu_cmd_get_dbi_len(struct se_cmd *se_cmd)
 {
-	size_t data_length = se_cmd->data_length;
+	size_t data_length = round_up(se_cmd->data_length, DATA_BLOCK_SIZE);
 	uint32_t dbi_len;
 
 	if (se_cmd->se_cmd_flags & SCF_BIDI)
-		data_length += se_cmd->t_bidi_data_sg->length;
+		data_length += round_up(se_cmd->t_bidi_data_sg->length,
+					DATA_BLOCK_SIZE);
 
-	dbi_len = (data_length + DATA_BLOCK_SIZE - 1) / DATA_BLOCK_SIZE;
+	dbi_len = data_length / DATA_BLOCK_SIZE;
 
 	return dbi_len;
 }
@@ -661,10 +662,11 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 
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
@@ -738,15 +740,19 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	entry->req.iov_dif_cnt = 0;
 
 	/* Handle BIDI commands */
-	iov_cnt = 0;
-	ret = alloc_and_scatter_data_area(udev, tcmu_cmd,
-		se_cmd->t_bidi_data_sg, se_cmd->t_bidi_data_nents,
-		&iov, &iov_cnt, false);
-	if (ret) {
-		pr_err("tcmu: alloc and scatter bidi data failed\n");
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	if (se_cmd->se_cmd_flags & SCF_BIDI) {
+		iov_cnt = 0;
+		iov++;
+		ret = alloc_and_scatter_data_area(udev, tcmu_cmd,
+					se_cmd->t_bidi_data_sg,
+					se_cmd->t_bidi_data_nents,
+					&iov, &iov_cnt, false);
+		if (ret) {
+			pr_err("tcmu: alloc and scatter bidi data failed\n");
+			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		}
+		entry->req.iov_bidi_cnt = iov_cnt;
 	}
-	entry->req.iov_bidi_cnt = iov_cnt;
 
 	/* All offsets relative to mb_addr, not start of entry! */
 	cdb_off = CMDR_OFF + cmd_head + base_command_size;
-- 
1.8.3.1
