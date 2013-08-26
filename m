From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 06/13] target: Refactor transport_generic_get_mem to target_alloc_sgl
Date: Mon, 26 Aug 2013 21:13:39 +0000
Message-ID: <1377551626-27447-7-git-send-email-nab@daterainc.com>
References: <1377551626-27447-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1377551626-27447-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Martin Petersen <martin.petersen@oracle.com>, Chris Mason <chris.mason@fusionio.com>, Roland Dreier <roland@purestorage.com>, Kent Overstreet <kmo@daterainc.com>, James Bottomley <JBottomley@Parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Nicholas Bellinger <nab@daterainc.com>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@daterainc.com>

This patch refactors transport_generic_get_mem() to target_alloc_sgl()
for accepting **sgl, *nents, length and zero_page as function parameters
in order to be used for both se_cmd->t_data_sg + se_cmd->t_bidi_data_sg
allocations.

Reported-by: Christoph Hellwig <hch@lst.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Chris Mason <chris.mason@fusionio.com>
Cc: James Bottomley <JBottomley@Parallels.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Nicholas Bellinger <nab@daterainc.com>
---
 drivers/target/target_core_transport.c |   35 ++++++++++++++++---------------
 1 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 781859e..607bc3d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -67,7 +67,6 @@ struct kmem_cache *t10_alua_tg_pt_gp_mem_cache;
 static void transport_complete_task_attr(struct se_cmd *cmd);
 static void transport_handle_queue_full(struct se_cmd *cmd,
 		struct se_device *dev);
-static int transport_generic_get_mem(struct se_cmd *cmd);
 static int transport_put_cmd(struct se_cmd *cmd);
 static void target_complete_ok_work(struct work_struct *work);
 
@@ -2092,23 +2091,21 @@ void transport_kunmap_data_sg(struct se_cmd *cmd)
 EXPORT_SYMBOL(transport_kunmap_data_sg);
 
 static int
-transport_generic_get_mem(struct se_cmd *cmd)
+target_alloc_sgl(struct scatterlist **sgl, unsigned int *nents, u32 length,
+		 bool zero_page)
 {
-	u32 length = cmd->data_length;
-	unsigned int nents;
+	struct scatterlist *sg;
 	struct page *page;
-	gfp_t zero_flag;
+	gfp_t zero_flag = (zero_page) ? __GFP_ZERO : 0;
+	unsigned int nent;
 	int i = 0;
 
-	nents = DIV_ROUND_UP(length, PAGE_SIZE);
-	cmd->t_data_sg = kmalloc(sizeof(struct scatterlist) * nents, GFP_KERNEL);
-	if (!cmd->t_data_sg)
+	nent = DIV_ROUND_UP(length, PAGE_SIZE);
+	sg = kmalloc(sizeof(struct scatterlist) * nent, GFP_KERNEL);
+	if (!sg)
 		return -ENOMEM;
 
-	cmd->t_data_nents = nents;
-	sg_init_table(cmd->t_data_sg, nents);
-
-	zero_flag = cmd->se_cmd_flags & SCF_SCSI_DATA_CDB ? 0 : __GFP_ZERO;
+	sg_init_table(sg, nent);
 
 	while (length) {
 		u32 page_len = min_t(u32, length, PAGE_SIZE);
@@ -2116,19 +2113,20 @@ transport_generic_get_mem(struct se_cmd *cmd)
 		if (!page)
 			goto out;
 
-		sg_set_page(&cmd->t_data_sg[i], page, page_len, 0);
+		sg_set_page(&sg[i], page, page_len, 0);
 		length -= page_len;
 		i++;
 	}
+	*sgl = sg;
+	*nents = nent;
 	return 0;
 
 out:
 	while (i > 0) {
 		i--;
-		__free_page(sg_page(&cmd->t_data_sg[i]));
+		__free_page(sg_page(&sg[i]));
 	}
-	kfree(cmd->t_data_sg);
-	cmd->t_data_sg = NULL;
+	kfree(sg);
 	return -ENOMEM;
 }
 
@@ -2149,7 +2147,10 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	 */
 	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC) &&
 	    cmd->data_length) {
-		ret = transport_generic_get_mem(cmd);
+		bool zero_flag = !(cmd->se_cmd_flags & SCF_SCSI_DATA_CDB);
+
+		ret = target_alloc_sgl(&cmd->t_data_sg, &cmd->t_data_nents,
+				       cmd->data_length, zero_flag);
 		if (ret < 0)
 			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 	}
-- 
1.7.2.5
