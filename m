From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/3] tcm: Remove legacy transport_map_mem_to_mem()
Date: Thu, 19 Aug 2010 15:13:01 -0700
Message-ID: <1282255981-12876-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch removes the legacy and unused transport_map_mem_to_mem() logic.
This code was originally for allowing struct se_mem -> struct se_mem mapping
with a passed task_offset, and is no longer used by anybody.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   97 --------------------------------
 include/target/target_core_transport.h |    3 -
 2 files changed, 0 insertions(+), 100 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8aa4785..8e9a2b9 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -6737,103 +6737,6 @@ int transport_map_sg_to_mem(
 	return 0;
 }
 
-int transport_map_mem_to_mem(
-	struct se_task *task,
-	struct list_head *se_mem_list,
-	void *in_mem,
-	struct se_mem *in_se_mem,
-	struct se_mem **out_se_mem,
-	u32 *se_mem_cnt,
-	u32 *task_offset)
-{
-	struct se_mem *se_mem = in_se_mem, *se_mem_new;
-	u32 saved_task_offset = 0, task_size = task->task_size;
-
-	if (!se_mem) {
-		printk(KERN_ERR "Invalid struct se_mem pointer\n");
-		return -1;
-	}
-
-	while (task_size) {
-		se_mem_new = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
-		if (!(se_mem_new)) {
-			printk(KERN_ERR "Unable to allocate struct se_mem\n");
-			return -1;
-		}
-		INIT_LIST_HEAD(&se_mem_new->se_list);
-
-		if (*task_offset == 0) {
-			se_mem_new->se_page = se_mem->se_page;
-			se_mem_new->se_off = se_mem->se_off;
-
-			if (task_size >= se_mem->se_len) {
-				se_mem_new->se_len = se_mem->se_len;
-
-				se_mem = list_entry(se_mem->se_list.next,
-							struct se_mem, se_list);
-				if (!(se_mem)) {
-					printk(KERN_ERR "Unable to locate next"
-							" struct se_mem\n");
-					return -1;
-				}
-			} else {
-				se_mem_new->se_len = task_size;
-
-				task_size -= se_mem_new->se_len;
-				if (!(task_size)) {
-					*task_offset = (se_mem_new->se_len +
-							saved_task_offset);
-					goto next;
-				}
-			}
-
-			if (saved_task_offset)
-				*task_offset = saved_task_offset;
-		} else {
-			se_mem_new->se_page = se_mem->se_page;
-			se_mem_new->se_off = (*task_offset + se_mem->se_off);
-
-			if ((se_mem->se_len - *task_offset) > task_size) {
-				se_mem_new->se_len = task_size;
-
-				task_size -= se_mem_new->se_len;
-				if (!(task_size)) {
-					*task_offset += se_mem_new->se_len;
-					goto next;
-				}
-			} else {
-				se_mem_new->se_len = (se_mem->se_len -
-							*task_offset);
-
-				se_mem = list_entry(se_mem->se_list.next,
-							struct se_mem, se_list);
-				if (!(se_mem)) {
-					printk(KERN_ERR "Unable to locate next"
-							" struct se_mem\n");
-					return -1;
-				}
-			}
-
-			saved_task_offset = *task_offset;
-			*task_offset = 0;
-		}
-		task_size -= se_mem_new->se_len;
-next:
-		list_add_tail(&se_mem_new->se_list, se_mem_list);
-		(*se_mem_cnt)++;
-
-		DEBUG_MEM2("task[%u] - se_mem_cnt(%u) se_page(%p) se_off(%u)"
-			" se_len(%u)\n", task->task_no, *se_mem_cnt,
-			se_mem_new->se_page, se_mem_new->se_off,
-			se_mem->se_len);
-		DEBUG_MEM2("task[%u] - Reducing task_size to(%u)\n",
-			task->task_no, task_size);
-	}
-	*out_se_mem = se_mem;
-
-	return 0;
-}
-
 /*	transport_map_mem_to_sg():
  *
  *
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 9a04033..fefe20b 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -280,9 +280,6 @@ extern int transport_generic_get_mem(struct se_cmd *, u32, u32);
 extern u32 transport_calc_sg_num(struct se_task *, struct se_mem *, u32);
 extern int transport_map_sg_to_mem(struct se_cmd *, struct list_head *,
 					void *, u32 *);
-extern int transport_map_mem_to_mem(struct se_task *, struct list_head *,
-					void *, struct se_mem *,
-					struct se_mem **, u32 *, u32 *);
 extern int transport_map_mem_to_sg(struct se_task *, struct list_head *,
 					void *, struct se_mem *,
 					struct se_mem **, u32 *, u32 *);
-- 
1.5.6.5
