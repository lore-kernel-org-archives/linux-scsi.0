From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 008/103] target: Rename transport_calc_sg_num to transport_init_task_sg
Date: Thu, 21 Jul 2011 00:04:44 -0700
Message-ID: <1311231979-6631-9-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm1.bullet.mail.bf1.yahoo.com ([98.139.212.160]:20357 "HELO
	nm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752086Ab1GUHGA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:06:00 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Andy Grover <agrover@redhat.com>

The function doesn't just calculate how many sgs there are, it also
allocates and initializes the task_sg.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_rd.c        |    7 ++++---
 drivers/target/target_core_transport.c |   15 ++++++++-------
 include/target/target_core_transport.h |    2 +-
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 793a94b..2a00f70 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -884,11 +884,12 @@ static int rd_DIRECT_do_se_mem_map(
 	 * transport_do_task_sg_chain() for creating chainged SGLs
 	 * across multiple struct se_task->task_sg[].
 	 */
-	if (!(transport_calc_sg_num(task,
+	ret = transport_init_task_sg(task,
 			list_entry(T_TASK(cmd)->t_mem_list->next,
 				   struct se_mem, se_list),
-			task_offset)))
-		return -1;
+			task_offset);
+	if (ret <= 0)
+		return ret;
 
 	return transport_map_mem_to_sg(task, se_mem_list, task->task_sg,
 			list_entry(T_TASK(cmd)->t_mem_list->next,
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 66c4093..bae584d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -4411,7 +4411,7 @@ out:
 	return -ENOMEM;
 }
 
-u32 transport_calc_sg_num(
+int transport_init_task_sg(
 	struct se_task *task,
 	struct se_mem *in_se_mem,
 	u32 task_offset)
@@ -4786,7 +4786,7 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 					&T_TASK(cmd)->t_task_list))) {
 				/*
 				 * Clear existing SGL termination bit set in
-				 * transport_calc_sg_num(), see sg_mark_end()
+				 * transport_init_task_sg(), see sg_mark_end()
 				 */
 				sg_end_cur = &task->task_sg[task->task_sg_num - 1];
 				sg_end_cur->page_link &= ~0x02;
@@ -4812,7 +4812,7 @@ void transport_do_task_sg_chain(struct se_cmd *cmd)
 		if (!(list_is_last(&task->t_list, &T_TASK(cmd)->t_task_list))) {
 			/*
 			 * Clear existing SGL termination bit set in
-			 * transport_calc_sg_num(), see sg_mark_end()
+			 * transport_init_task_sg(), see sg_mark_end()
 			 */
 			sg_end = &task->task_sg[task->task_sg_num - 1];
 			sg_end->page_link &= ~0x02;
@@ -4878,7 +4878,7 @@ static int transport_do_se_mem_map(
 	 * This is the normal path for all normal non BIDI and BIDI-COMMAND
 	 * WRITE payloads..  If we need to do BIDI READ passthrough for
 	 * TCM/pSCSI the first call to transport_do_se_mem_map ->
-	 * transport_calc_sg_num() -> transport_map_mem_to_sg() will do the
+	 * transport_init_task_sg() -> transport_map_mem_to_sg() will do the
 	 * allocation for task->task_sg_bidi, and the subsequent call to
 	 * transport_do_se_mem_map() from transport_generic_get_cdb_count()
 	 */
@@ -4887,8 +4887,9 @@ static int transport_do_se_mem_map(
 		 * Assume default that transport plugin speaks preallocated
 		 * scatterlists.
 		 */
-		if (!(transport_calc_sg_num(task, in_se_mem, task_offset)))
-			return -1;
+		ret = transport_init_task_sg(task, in_se_mem, task_offset);
+		if (ret <= 0)
+			return ret;
 		/*
 		 * struct se_task->task_sg now contains the struct scatterlist array.
 		 */
@@ -4986,7 +4987,7 @@ static u32 transport_generic_get_cdb_count(
 		 *
 		 * Note that the first call to transport_do_se_mem_map() above will
 		 * allocate struct se_task->task_sg_bidi in transport_do_se_mem_map()
-		 * -> transport_calc_sg_num(), and the second here will do the
+		 * -> transport_init_task_sg(), and the second here will do the
 		 * mapping for SCSI READ for BIDI-COMMAND passthrough with TCM/pSCSI.
 		 */
 		if (task->task_sg_bidi != NULL) {
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 24a1c6c..199a404 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -184,7 +184,7 @@ extern void transport_send_task_abort(struct se_cmd *);
 extern void transport_release_cmd_to_pool(struct se_cmd *);
 extern void transport_generic_free_cmd(struct se_cmd *, int, int, int);
 extern void transport_generic_wait_for_cmds(struct se_cmd *, int);
-extern u32 transport_calc_sg_num(struct se_task *, struct se_mem *, u32);
+extern int transport_init_task_sg(struct se_task *, struct se_mem *, u32);
 extern int transport_map_mem_to_sg(struct se_task *, struct list_head *,
 					void *, struct se_mem *,
 					struct se_mem **, u32 *, u32 *);
-- 
1.7.6

