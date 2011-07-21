From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 040/103] target: Add comment & cleanup transport_map_sg_to_mem()
Date: Thu, 21 Jul 2011 00:07:52 -0700
Message-ID: <1311232135-6653-41-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm26-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.186]:28689
	"HELO nm26-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752388Ab1GUHKG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:10:06 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

I initially freaked out and wrote a patch that ensured this function
didn't return a partially allocated list (possible if a later mem
allocation failed), and cleaned up if the second call to map_sg_to_mem
failed. But it isn't necessary -- on error we end up eventually calling
transport_free_pages, which walks both and frees all se_mem entries.

I added a comment to explain this, and also removed a second variable
getting incremented for each loop iter, because the two would never be
different.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 44f9afe..f2849ad 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4365,14 +4365,19 @@ static int transport_map_sg_to_mem(
 	struct se_cmd *cmd,
 	struct list_head *se_mem_list,
 	struct scatterlist *sg,
-	u32 *se_mem_cnt)
+	u32 *sg_count)
 {
 	struct se_mem *se_mem;
-	u32 sg_count = 1, cmd_size = cmd->data_length;
+	u32 cmd_size = cmd->data_length;
 
 	WARN_ON(!sg);
 
 	while (cmd_size) {
+		/*
+		 * NOTE: it is safe to return -ENOMEM at any time in creating this
+		 * list because transport_free_pages() will eventually be called, and is
+		 * smart enough to deallocate all list items for sg and sg_bidi lists.
+		 */
 		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
 		if (!(se_mem)) {
 			printk(KERN_ERR "Unable to allocate struct se_mem\n");
@@ -4389,26 +4394,21 @@ static int transport_map_sg_to_mem(
 		if (cmd_size > sg->length) {
 			se_mem->se_len = sg->length;
 			sg = sg_next(sg);
-			sg_count++;
 		} else
 			se_mem->se_len = cmd_size;
 
 		cmd_size -= se_mem->se_len;
+		(*sg_count)++;
 
-		DEBUG_MEM("sg_to_mem: *se_mem_cnt: %u cmd_size: %u\n",
-				*se_mem_cnt, cmd_size);
+		DEBUG_MEM("sg_to_mem: sg_count: %u cmd_size: %u\n",
+				sg_count, cmd_size);
 		DEBUG_MEM("sg_to_mem: Final se_page: %p se_off: %d se_len: %d\n",
 				se_mem->se_page, se_mem->se_off, se_mem->se_len);
 
 		list_add_tail(&se_mem->se_list, se_mem_list);
-		(*se_mem_cnt)++;
 	}
 
-	DEBUG_MEM("task[0] - Mapped(%u) struct scatterlist segments to(%u)"
-		" struct se_mem\n", sg_count, *se_mem_cnt);
-
-	if (sg_count != *se_mem_cnt)
-		BUG();
+	DEBUG_MEM("task[0] - Mapped(%u) struct scatterlist segments\n", sg_count);
 
 	return 0;
 }
@@ -4610,8 +4610,8 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 	for_each_sg(cmd->t_task.t_tasks_sg_chained, sg,
 			cmd->t_task.t_tasks_sg_chained_no, i) {
 
-		DEBUG_CMD_M("SG[%d]: %p page: %p length: %d offset: %d, magic: 0x%08x\n",
-			i, sg, sg_page(sg), sg->length, sg->offset, sg->sg_magic);
+		DEBUG_CMD_M("SG[%d]: %p page: %p length: %d offset: %d\n",
+			i, sg, sg_page(sg), sg->length, sg->offset);
 		if (sg_is_chain(sg))
 			DEBUG_CMD_M("SG: %p sg_is_chain=1\n", sg);
 		if (sg_is_last(sg))
-- 
1.7.6

