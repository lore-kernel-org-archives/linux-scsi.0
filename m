From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] tcm: Make transport_calc_sg_num() properly handle task_offset
Date: Wed, 18 Aug 2010 15:23:46 -0700
Message-ID: <1282170226-23502-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp105.sbc.mail.gq1.yahoo.com ([67.195.14.108]:33877 "HELO
	smtp105.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751419Ab0HRWXt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Aug 2010 18:23:49 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>, Hannes Reinecke <hare@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

transport_calc_sg_num() is used by dev_obj_do_se_mem_map() to determine
the number of scatterlists for an individual struct se_task, and then proceeds
to allocate a contigious array of struct scatterlist in struct se_task->task_sg[].
This struct se_task->task_sg[] is then used by subsystem plugins like IBLOCK, FILEIO
and PSCSI to setup I/O descriptors down to the Linux storage subsystem.

This patch updates transport_calc_sg_num() to fix an issue that was originally
reported when an underlying struct Scsi_Host was reporting 255 max_sectors to
IBLOCK, which manifested itself by generating an number of scatterlists for
the map task_offset carried between struct se_task allocations inside of
transport_generic_get_cdb_count().

This patch also makes an small improvement by removing the improper usage of
list_for_each_entry_continue() when picking off the next struct se_mem, and
instead adds a !list_is_last() check around list_entry().

So far this patch has been tested with TCM_Loop using max_sectors=1024 on top of
TCM/IBLOCK connected to a scsi_debug device using max_sectors 255-251 to force the
task_offset to span struct task allocations.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   45 +++++++++++++++++---------------
 1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index dbedb7a..43eeb14 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -6554,54 +6554,57 @@ extern u32 transport_calc_sg_num(
 	struct se_mem *in_se_mem,
 	u32 task_offset)
 {
+	struct se_cmd *se_cmd = task->task_se_cmd;
 	struct se_mem *se_mem = in_se_mem;
-	u32 sg_length, sg_offset, task_size = task->task_size;
-	u32 saved_task_offset = 0;
+	u32 sg_length, task_size = task->task_size;
 
-	while (task_size) {
+	while (task_size != 0) {
 		DEBUG_SC("se_mem->se_page(%p) se_mem->se_len(%u)"
 			" se_mem->se_off(%u) task_offset(%u)\n",
 			se_mem->se_page, se_mem->se_len,
 			se_mem->se_off, task_offset);
 
 		if (task_offset == 0) {
-			if (task_size > se_mem->se_len)
+			if (task_size >= se_mem->se_len) {
 				sg_length = se_mem->se_len;
-			else
+
+				if (!(list_is_last(&se_mem->se_list,
+						T_TASK(se_cmd)->t_mem_list)))
+					se_mem = list_entry(se_mem->se_list.next,
+							struct se_mem, se_list);
+			} else {
 				sg_length = task_size;
+				task_size -= sg_length;
+				goto next;
+			}
 
 			DEBUG_SC("sg_length(%u) task_size(%u)\n",
 					sg_length, task_size);
-
-			if (saved_task_offset)
-				task_offset = saved_task_offset;
 		} else {
-			sg_offset = task_offset;
-
-			if ((se_mem->se_len - task_offset) > task_size)
+			if ((se_mem->se_len - task_offset) > task_size) {
 				sg_length = task_size;
-			else
+				task_size -= sg_length;
+				goto next;
+			 } else {
 				sg_length = (se_mem->se_len - task_offset);
 
+				if (!(list_is_last(&se_mem->se_list,
+						T_TASK(se_cmd)->t_mem_list)))
+					se_mem = list_entry(se_mem->se_list.next,
+							struct se_mem, se_list);
+			}
+
 			DEBUG_SC("sg_length(%u) task_size(%u)\n",
 					sg_length, task_size);
 
-			saved_task_offset = task_offset;
 			task_offset = 0;
 		}
 		task_size -= sg_length;
-
+next:
 		DEBUG_SC("task[%u] - Reducing task_size to(%u)\n",
 			task->task_no, task_size);
 
 		task->task_sg_num++;
-
-		list_for_each_entry_continue(se_mem,
-				task->task_se_cmd->t_task->t_mem_list, se_list)
-			break;
-
-		if (!se_mem)
-			break;
 	}
 
 	task->task_sg = kzalloc(task->task_sg_num *
-- 
1.5.6.5

