From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 3/9] target: Add memory allocation for bidirectional commands
Date: Tue, 20 Aug 2013 20:07:54 +0000
Message-ID: <1377029280-19144-4-git-send-email-nab@daterainc.com>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1377029280-19144-1-git-send-email-nab@daterainc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

This adds transport_generic_get_mem_bidi() to perform scatterlist
allocation for bidirectional commands.

Also, update transport_generic_new_cmd() to call this new function
when SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC has not been set.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_transport.c |   53 ++++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 53d1d75..5746d85 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2092,6 +2092,53 @@ void transport_kunmap_data_sg(struct se_cmd *cmd)
 EXPORT_SYMBOL(transport_kunmap_data_sg);
 
 static int
+transport_generic_get_mem_bidi(struct se_cmd *cmd)
+{
+	struct se_device *dev = cmd->se_dev;
+	struct page *page;
+	gfp_t zero_flag;
+	u32 length;
+	unsigned int nents;
+	int i = 0;
+
+	if (cmd->t_task_cdb[0] == COMPARE_AND_WRITE)
+		length = cmd->t_task_nolb * dev->dev_attrib.block_size;
+	else
+		length = cmd->data_length;
+
+	nents = DIV_ROUND_UP(length, PAGE_SIZE);
+	cmd->t_bidi_data_sg = kmalloc(sizeof(struct scatterlist) * nents, GFP_KERNEL);
+	if (!cmd->t_bidi_data_sg)
+		return -ENOMEM;
+
+	cmd->t_bidi_data_nents = nents;
+	sg_init_table(cmd->t_bidi_data_sg, nents);
+
+	zero_flag = cmd->se_cmd_flags & SCF_SCSI_DATA_CDB ? 0 : __GFP_ZERO;
+
+	while (length) {
+		u32 page_len = min_t(u32, length, PAGE_SIZE);
+		page = alloc_page(GFP_KERNEL | zero_flag);
+		if (!page)
+			goto out;
+
+		sg_set_page(&cmd->t_bidi_data_sg[i], page, page_len, 0);
+		length -= page_len;
+		i++;
+	}
+	return 0;
+
+out:
+	while (i > 0) {
+		i--;
+		__free_page(sg_page(&cmd->t_bidi_data_sg[i]));
+	}
+	kfree(cmd->t_bidi_data_sg);
+	cmd->t_bidi_data_sg = NULL;
+	return -ENOMEM;
+}
+
+static int
 transport_generic_get_mem(struct se_cmd *cmd)
 {
 	u32 length = cmd->data_length;
@@ -2149,6 +2196,12 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	 */
 	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC) &&
 	    cmd->data_length) {
+		if (cmd->se_cmd_flags & SCF_BIDI) {
+			ret = transport_generic_get_mem_bidi(cmd);
+			if (ret < 0)
+				return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		}
+
 		ret = transport_generic_get_mem(cmd);
 		if (ret < 0)
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-- 
1.7.10.4
