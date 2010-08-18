From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] tcm: Remove task_offset parameter from transport_map_sg_to_mem()
Date: Wed, 18 Aug 2010 15:23:38 -0700
Message-ID: <1282170218-23481-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:24017 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751737Ab0HRWXk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2010 18:23:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the unused task_offset parameter from transport_map_sg_to_mem(),
which was originally used to determine an offset into the first
struct scatterlist -> struct se_mem mapping.  With the removal of task_offset,
the code is simplified, and assumes a 1:1 mapping between the source struct
scatterlist and the destination struct se_mem.

It also updates transport_generic_map_mem_to_cmd() and removes it's local
usage of se_mem_task_off.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   74 ++++++++-----------------------
 include/target/target_core_transport.h |    2 +-
 2 files changed, 20 insertions(+), 56 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9e92e93..dbedb7a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -6244,7 +6244,7 @@ int transport_generic_map_mem_to_cmd(
 	void *mem,
 	u32 se_mem_num)
 {
-	u32 se_mem_cnt_out = 0, se_mem_task_off = 0;
+	u32 se_mem_cnt_out = 0;
 	int ret;
 
 	if (!(mem) || !(se_mem_num))
@@ -6275,8 +6275,7 @@ int transport_generic_map_mem_to_cmd(
 			return -1;
 
 		ret = transport_map_sg_to_mem(cmd,
-			T_TASK(cmd)->t_mem_list, mem, &se_mem_cnt_out,
-			&se_mem_task_off);
+			T_TASK(cmd)->t_mem_list, mem, &se_mem_cnt_out);
 		if (ret < 0)
 			return -1;
 
@@ -6682,12 +6681,11 @@ int transport_map_sg_to_mem(
 	struct se_cmd *cmd,
 	struct list_head *se_mem_list,
 	void *in_mem,
-	u32 *se_mem_cnt,
-	u32 *task_offset)
+	u32 *se_mem_cnt)
 {
 	struct se_mem *se_mem;
 	struct scatterlist *sg;
-	u32 sg_count = 0, saved_task_offset = 0, task_size = cmd->data_length;
+	u32 sg_count = 1, cmd_size = cmd->data_length;
 
 	if (!in_mem) {
 		printk(KERN_ERR "No source scatterlist\n");
@@ -6695,65 +6693,31 @@ int transport_map_sg_to_mem(
 	}
 	sg = (struct scatterlist *)in_mem;
 
-	while (task_size) {
+	while (cmd_size) {
 		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
 		if (!(se_mem)) {
 			printk(KERN_ERR "Unable to allocate struct se_mem\n");
 			return -1;
 		}
 		INIT_LIST_HEAD(&se_mem->se_list);
-		DEBUG_MEM("sg_to_mem: Starting loop with task_size: %u"
-			" sg_page: %p offset: %d length: %d\n", task_size,
+		DEBUG_MEM("sg_to_mem: Starting loop with cmd_size: %u"
+			" sg_page: %p offset: %d length: %d\n", cmd_size,
 			sg_page(sg), sg->offset, sg->length);
 
-		if (*task_offset == 0) {
-			se_mem->se_page = sg_page(sg);
-			se_mem->se_off = sg->offset;
-
-			if (task_size >= sg->length) {
-				se_mem->se_len =  sg->length;
-				sg = sg_next(sg);
-				sg_count++;
-			} else {
-				se_mem->se_len = task_size;
-
-				task_size -= se_mem->se_len;
-				if (!(task_size)) {
-					*task_offset = (se_mem->se_len +
-							saved_task_offset);
-					goto next;
-				}
-			}
-
-			if (saved_task_offset)
-				*task_offset = saved_task_offset;
-		} else {
-			se_mem->se_page = sg_page(sg);
-			se_mem->se_off = (*task_offset + sg->offset);
+		se_mem->se_page = sg_page(sg);
+		se_mem->se_off = sg->offset;
 
-			if ((sg->length - *task_offset) > task_size) {
-				se_mem->se_len = task_size;
+		if (cmd_size > sg->length) {
+			se_mem->se_len = sg->length;
+			sg = sg_next(sg);
+			sg_count++;
+		} else
+			se_mem->se_len = cmd_size;
 
-				task_size -= se_mem->se_len;
-				if (!(task_size)) {
-					*task_offset += se_mem->se_len;
-					goto next;
-				}
-			} else {
-				se_mem->se_len = (sg->length - *task_offset);
-				sg = sg_next(sg);
-				sg_count++;
-			}
+		cmd_size -= se_mem->se_len;
 
-			saved_task_offset = *task_offset;
-			*task_offset = 0;
-		}
-		task_size -= se_mem->se_len;
-next:
-		DEBUG_MEM("sg_to_mem: *se_mem_cnt: %u task_size: %u, *task_offset: %u "
-			"saved_task_offset: %d\n", *se_mem_cnt, task_size, *task_offset,
-			saved_task_offset);
-				
+		DEBUG_MEM("sg_to_mem: *se_mem_cnt: %u cmd_size: %u\n",
+				*se_mem_cnt, cmd_size);
 		DEBUG_MEM("sg_to_mem: Final se_page: %p se_off: %d se_len: %d\n",
 				se_mem->se_page, se_mem->se_off, se_mem->se_len);
 
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 4e5591b..9a04033 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -279,7 +279,7 @@ extern void transport_free_se_mem_list(struct list_head *);
 extern int transport_generic_get_mem(struct se_cmd *, u32, u32);
 extern u32 transport_calc_sg_num(struct se_task *, struct se_mem *, u32);
 extern int transport_map_sg_to_mem(struct se_cmd *, struct list_head *,
-					void *, u32 *, u32 *);
+					void *, u32 *);
 extern int transport_map_mem_to_mem(struct se_task *, struct list_head *,
 					void *, struct se_mem *,
 					struct se_mem **, u32 *, u32 *);
-- 
1.5.6.5

