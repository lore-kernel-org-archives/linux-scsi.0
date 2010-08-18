From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Convert transport_map_sg_to_mem() to use sg_next()
Date: Tue, 17 Aug 2010 21:27:29 -0700
Message-ID: <1282105649-5157-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.sbc.mail.gq1.yahoo.com ([67.195.14.39]:32339 "HELO
	smtp109.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750711Ab0HRE1d (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2010 00:27:33 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the incoming struct scatterlist array pointer logic
for transport_map_sg_to_mem() to use the include/linux/scatterlist.h
sg_next() macro in order to properly support incoming linked scatterlists.

An issue was observed recently with TCM_Loop + FILEIO backstores using v2.6.35
struct scsi_host_template->sg_tablesize=256.  128+128 linked scatterlists
coming in via struct scsi_cmnd->>sdb.table.sgl where generating bogus struct se_mem
because of the assumption of a single contigious scatterlist array for the incoming
memory to be mapped zero-copy to struct se_mem.

The single array walking scatterlist code in transport_map_sg_to_mem() can
historically be attributed to the matching RAMDISK_DR algortihms existing before
Jens added proper array linked scatterlist support into v2.6.24-rc series way
back in October 2007.  For modern TCM purposes, this patch does the "right thing"
and uses Jen's sg_next() macros when walking physical memory for incoming
SHT->queuecommand() I/O.

Thanks Jens!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   49 +++++++++++++++++++++----------
 1 files changed, 33 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index efb351a..a6b5706 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -6686,14 +6686,14 @@ int transport_map_sg_to_mem(
 	u32 *task_offset)
 {
 	struct se_mem *se_mem;
-	struct scatterlist *sg_s;
-	u32 j = 0, saved_task_offset = 0, task_size = cmd->data_length;
+	struct scatterlist *sg;
+	u32 sg_count = 0, saved_task_offset = 0, task_size = cmd->data_length;
 
 	if (!in_mem) {
 		printk(KERN_ERR "No source scatterlist\n");
 		return -1;
 	}
-	sg_s = (struct scatterlist *)in_mem;
+	sg = (struct scatterlist *)in_mem;
 
 	while (task_size) {
 		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
@@ -6702,14 +6702,19 @@ int transport_map_sg_to_mem(
 			return -1;
 		}
 		INIT_LIST_HEAD(&se_mem->se_list);
+		DEBUG_MEM("sg_to_mem: Starting loop with task_size: %u"
+			" sg_page: %p offset: %d length: %d\n", task_size,
+			sg_page(sg), sg->offset, sg->length);
 
 		if (*task_offset == 0) {
-			se_mem->se_page = sg_page(&sg_s[j]);
-			se_mem->se_off = sg_s[j].offset;
+			se_mem->se_page = sg_page(sg);
+			se_mem->se_off = sg->offset;
 
-			if (task_size >= sg_s[j].length)
-				se_mem->se_len =  sg_s[j++].length;
-			else {
+			if (task_size >= sg->length) {
+				se_mem->se_len =  sg->length;
+				sg = sg_next(sg);
+				sg_count++;
+			} else {
 				se_mem->se_len = task_size;
 
 				task_size -= se_mem->se_len;
@@ -6723,10 +6728,10 @@ int transport_map_sg_to_mem(
 			if (saved_task_offset)
 				*task_offset = saved_task_offset;
 		} else {
-			se_mem->se_page = sg_page(&sg_s[j]);
-			se_mem->se_off = (*task_offset + sg_s[j].offset);
+			se_mem->se_page = sg_page(sg);
+			se_mem->se_off = (*task_offset + sg->offset);
 
-			if ((sg_s[j].length - *task_offset) > task_size) {
+			if ((sg->length - *task_offset) > task_size) {
 				se_mem->se_len = task_size;
 
 				task_size -= se_mem->se_len;
@@ -6734,21 +6739,33 @@ int transport_map_sg_to_mem(
 					*task_offset += se_mem->se_len;
 					goto next;
 				}
-			} else
-				se_mem->se_len = (sg_s[j++].length -
-						*task_offset);
+			} else {
+				se_mem->se_len = (sg->length - *task_offset);
+				sg = sg_next(sg);
+				sg_count++;
+			}
 
 			saved_task_offset = *task_offset;
 			*task_offset = 0;
 		}
 		task_size -= se_mem->se_len;
 next:
+		DEBUG_MEM("sg_to_mem: *se_mem_cnt: %u task_size: %u, *task_offset: %u "
+			"saved_task_offset: %d\n", *se_mem_cnt, task_size, *task_offset,
+			saved_task_offset);
+				
+		DEBUG_MEM("sg_to_mem: Final se_page: %p se_off: %d se_len: %d\n",
+				se_mem->se_page, se_mem->se_off, se_mem->se_len);
+
 		list_add_tail(&se_mem->se_list, se_mem_list);
 		(*se_mem_cnt)++;
 	}
 
 	DEBUG_MEM("task[0] - Mapped(%u) struct scatterlist segments to(%u)"
-		" struct se_mem\n", j, *se_mem_cnt);
+		" struct se_mem\n", sg_count, *se_mem_cnt);
+
+	if (sg_count != *se_mem_cnt)
+		BUG();
 
 	return 0;
 }
-- 
1.5.6.5

