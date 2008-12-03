From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] [Target_Core_Mod]: Convert to se_task_t->task_sg usage in
	core and subsystem plugins
Date: Tue, 02 Dec 2008 18:44:36 -0800
Message-ID: <1228272276.6229.142.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp120.sbc.mail.sp1.yahoo.com ([69.147.64.93]:35681 "HELO
	smtp120.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751688AbYLCCoj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 2 Dec 2008 21:44:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

>From 41e98940da5ffaf7e31fce8d1f706e3e0a679654 Mon Sep 17 00:00:00 2001
From: Nicholas Bellinger <nab@linux-iscsi.org>
Date: Tue, 2 Dec 2008 18:06:54 -0800
Subject: [PATCH] [Target_Core_Mod]: Convert to se_task_t->task_sg usage in core and subsystem plugins

This patch adds makes the existing se_task_t->task_buf become se_task_t->task_sg of
type struct scatterlist.  Changes to target_core_transport.c in transport_calc_sg_num()
and transport_free_dev_tasks() are simple, along with a one-liner change in
target_core_seobj.c:dev_obj_do_se_mem_map().

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/lio-core/target_core_base.h      |    2 +-
 drivers/lio-core/target_core_seobj.c     |   11 ++++++-----
 drivers/lio-core/target_core_transport.c |    9 ++++-----
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/lio-core/target_core_base.h b/drivers/lio-core/target_core_base.h
index 5ee04d3..b866613 100644
--- a/drivers/lio-core/target_core_base.h
+++ b/drivers/lio-core/target_core_base.h
@@ -249,7 +249,7 @@ typedef struct se_transport_task_s {
 
 typedef struct se_task_s {
         unsigned char   task_sense;
-        unsigned char   *task_buf;
+	struct scatterlist *task_sg;
         void            *transport_req;
         u8              task_scsi_status;
         u8              task_flags;
diff --git a/drivers/lio-core/target_core_seobj.c b/drivers/lio-core/target_core_seobj.c
index 8e8c951..d013f2c 100644
--- a/drivers/lio-core/target_core_seobj.c
+++ b/drivers/lio-core/target_core_seobj.c
@@ -348,8 +348,9 @@ extern int dev_obj_do_se_mem_map (
 	 * been done by the transport plugin.
 	 */
 	if (TRANSPORT(dev)->do_se_mem_map) {
-		if ((ret = TRANSPORT(dev)->do_se_mem_map(task, se_mem_list, in_mem, in_se_mem,
-				out_se_mem, se_mem_cnt, task_offset)) == 0)
+		if ((ret = TRANSPORT(dev)->do_se_mem_map(task, se_mem_list,
+				in_mem, in_se_mem, out_se_mem, se_mem_cnt,
+				task_offset)) == 0)
 			T_TASK(task->iscsi_cmd)->t_task_se_num += *se_mem_cnt;
 
 		return(ret);
@@ -362,10 +363,10 @@ extern int dev_obj_do_se_mem_map (
 		return(-1);
 	
 	/*
-	 * se_task_t->task_buf now contains the struct scatterlist array.
+	 * se_task_t->task_sg now contains the struct scatterlist array.
 	 */
-	return(transport_map_mem_to_sg(task, se_mem_list, task->task_buf, in_se_mem, out_se_mem,
-			se_mem_cnt, task_offset));
+	return(transport_map_mem_to_sg(task, se_mem_list, task->task_sg,
+		in_se_mem, out_se_mem, se_mem_cnt, task_offset));
 }
 
 extern int dev_obj_get_mem_buf (void *p, iscsi_cmd_t *cmd)
diff --git a/drivers/lio-core/target_core_transport.c b/drivers/lio-core/target_core_transport.c
index d92814c..b8e8294 100644
--- a/drivers/lio-core/target_core_transport.c
+++ b/drivers/lio-core/target_core_transport.c
@@ -4643,7 +4643,7 @@ extern void transport_free_dev_tasks (iscsi_cmd_t *cmd)
 		if (!task->transport_req)
 			continue;
 		
-		kfree(task->task_buf);
+		kfree(task->task_sg);
 		
 		spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 		if (task->iscsi_dev)
@@ -5097,13 +5097,12 @@ extern u32 transport_calc_sg_num (
 			break;
 	}
 
-	if (!(task->task_buf = kmalloc(task->task_sg_num * sizeof(struct scatterlist), GFP_KERNEL))) {
-		TRACE_ERROR("Unable to allocate memory for task->task_buf\n");
+	if (!(task->task_sg = kzalloc(task->task_sg_num * sizeof(struct scatterlist), GFP_KERNEL))) {
+		TRACE_ERROR("Unable to allocate memory for task->task_sg\n");
 		return(0);	
 	}
-	memset(task->task_buf, 0, task->task_sg_num * sizeof(struct scatterlist));
 
-	sg_init_table((struct scatterlist *)&task->task_buf[0], task->task_sg_num);
+	sg_init_table(&task->task_sg[0], task->task_sg_num);
 
 	DEBUG_SC("Successfully allocated task->task_sg_num: %u\n", task->task_sg_num);
 	
-- 
1.5.4.1



