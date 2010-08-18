From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 3/3] tcm: Make transport_map_mem_to_sg() properly handle task_offset
Date: Wed, 18 Aug 2010 15:23:54 -0700
Message-ID: <1282170234-23523-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.sbc.mail.sp1.yahoo.com ([69.147.65.185]:24194 "HELO
	smtp126.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754490Ab0HRWX5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2010 18:23:57 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

transport_map_mem_to_sg() is used by dev_obj_do_se_mem_map() to map
the passed struct se_mem *in_se_mem pointer into newly allocated contigious
array of struct scatterlist at struct task->task_sg[].

This patch follows commit ffde9cbccdbf and updates transport_map_mem_to_sg()
to fix an issue that was originally reported by an IBLOCK HBA reporting
255 max_sectors, number of scatterlists to be determined when a task_offset
was carried between struct se_task allocations in transport_generic_get_cdb_count()

This patch also adds the usage of !list_is_last() before calling
list_entry() when picking off the next struct se_mem list_head member.
The current struct se_mem pointer will be set to *out_se_mem before returning from
transport_map_mem_to_sg().  This is done so the next struct se_task allocation
happening in transport_generic_get_cdb_count() will, together with the passed
u32 *task_offset, know where to start it's struct task->task_sg[] physical memory
mapping from.

Finally, this patch converts transport_map_mem_to_sg() to use the
include/linux/scatterlist.h:sg_next() macros to follow mainline SG convention.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   95 ++++++++++++++++----------------
 1 files changed, 47 insertions(+), 48 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 43eeb14..8aa4785 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -6847,10 +6847,10 @@ int transport_map_mem_to_sg(
 	u32 *se_mem_cnt,
 	u32 *task_offset)
 {
+	struct se_cmd *se_cmd = task->task_se_cmd;
 	struct se_mem *se_mem = in_se_mem;
 	struct scatterlist *sg = (struct scatterlist *)in_mem;
-	u32 saved_task_offset = 0, sg_no = 0;
-	u32 task_size = task->task_size;
+	u32 task_size = task->task_size, sg_no = 0;
 
 	if (!sg) {
 		printk(KERN_ERR "Unable to locate valid struct"
@@ -6858,85 +6858,84 @@ int transport_map_mem_to_sg(
 		return -1;
 	}
 
-	while (task_size) {
+	while (task_size != 0) {
+		/*
+		 * Setup the contigious array of scatterlists for
+		 * this struct se_task.
+		 */
+		sg_assign_page(sg, se_mem->se_page);
+
 		if (*task_offset == 0) {
-			sg_assign_page(&sg[sg_no], se_mem->se_page);
-			sg[sg_no].offset = se_mem->se_off;
+			sg->offset = se_mem->se_off;
 
 			if (task_size >= se_mem->se_len) {
-				sg[sg_no].length = se_mem->se_len;
+				sg->length = se_mem->se_len;
 
-				se_mem = list_entry(se_mem->se_list.next,
+				if (!(list_is_last(&se_mem->se_list,
+						T_TASK(se_cmd)->t_mem_list))) {
+					se_mem = list_entry(se_mem->se_list.next,
 							struct se_mem, se_list);
-				if (!(se_mem)) {
-					printk(KERN_ERR "Unable to locate"
-						" next struct se_mem\n");
-					return -1;
+					(*se_mem_cnt)++;
 				}
-				(*se_mem_cnt)++;
 			} else {
-				sg[sg_no].length = task_size;
+				sg->length = task_size;
 				/*
 				 * Determine if we need to calculate an offset
 				 * into the struct se_mem on the next go around..
 				 */
-				task_size -= sg[sg_no].length;
-				if (!(task_size)) {
-					*task_offset = (sg[sg_no].length +
-							saved_task_offset);
-					goto next;
-				}
+				task_size -= sg->length;
+				if (!(task_size))
+					*task_offset = sg->length;
+
+				goto next;
 			}
 
-			if (saved_task_offset)
-				*task_offset = saved_task_offset;
 		} else {
-			sg_assign_page(&sg[sg_no], se_mem->se_page);
-			sg[sg_no].offset = (*task_offset + se_mem->se_off);
+			sg->offset = (*task_offset + se_mem->se_off);
 
 			if ((se_mem->se_len - *task_offset) > task_size) {
-				sg[sg_no].length = task_size;
+				sg->length = task_size;
 				/*
 				 * Determine if we need to calculate an offset
 				 * into the struct se_mem on the next go around..
 				 */
-				task_size -= sg[sg_no].length;
-				if (!(task_size)) {
-					*task_offset += sg[sg_no].length;
-					goto next;
-				}
+				task_size -= sg->length;
+				if (!(task_size)) 
+					*task_offset += sg->length;
+
+				goto next;
 			} else {
-				sg[sg_no].length = (se_mem->se_len -
-						*task_offset);
+				sg->length = (se_mem->se_len - *task_offset);
 
-				se_mem = list_entry(se_mem->se_list.next,
-						struct se_mem, se_list);
-				if (!(se_mem)) {
-					printk(KERN_ERR "Unable to locate"
-						" next struct se_mem\n");
-					return -1;
+				if (!(list_is_last(&se_mem->se_list,
+						T_TASK(se_cmd)->t_mem_list))) {
+					se_mem = list_entry(se_mem->se_list.next,
+							struct se_mem, se_list);
+					(*se_mem_cnt)++;
 				}
-				(*se_mem_cnt)++;
 			}
 
-			saved_task_offset = *task_offset;
 			*task_offset = 0;
 		}
-		task_size -= sg[sg_no].length;
+		task_size -= sg->length;
 next:
-		DEBUG_MEM("task[%u] - sg[%u](%p)(%u)(%u) - Reducing task_size"
-			" to(%u)\n", task->task_no, sg_no,
-			sg_page(&sg[sg_no]), sg[sg_no].length,
-			sg[sg_no].offset, task_size);
+		DEBUG_MEM("task[%u] mem_to_sg - sg[%u](%p)(%u)(%u) - Reducing"
+			" task_size to(%u), task_offset: %u\n", task->task_no, sg_no,
+			sg_page(sg), sg->length, sg->offset, task_size, *task_offset);
 
 		sg_no++;
+		if (!(task_size))
+			break;
+
+		sg = sg_next(sg);
+
+		if (task_size > se_cmd->data_length)
+			BUG();
 	}
 	*out_se_mem = se_mem;
-	task->task_sg_num = sg_no;
 
-	DEBUG_MEM("task[%u] - Mapped(%u) struct se_mem segments to total(%u) SGs"
-		" saved task_offset(%u)\n", task->task_no, *se_mem_cnt,
-			sg_no, *task_offset);
+	DEBUG_MEM("task[%u] - Mapped(%u) struct se_mem segments to total(%u)"
+		" SGs\n", task->task_no, *se_mem_cnt, sg_no);
 
 	return 0;
 }
-- 
1.5.6.5

