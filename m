From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 060/103] target: map_sg_to_mem: return sg_count in return value
Date: Thu, 21 Jul 2011 00:08:12 -0700
Message-ID: <1311232135-6653-61-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm16-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.166]:47401
	"HELO nm16-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751926Ab1GUHIN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:08:13 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Instead of in an out parameter. Seems simpler.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   24 +++++++++---------------
 1 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 54fa0a4..c5a541d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -215,8 +215,7 @@ static int transport_generic_remove(struct se_cmd *cmd,
 		int release_to_pool, int session_reinstatement);
 static int transport_cmd_get_valid_sectors(struct se_cmd *cmd);
 static int transport_map_sg_to_mem(struct se_cmd *cmd,
-		struct list_head *se_mem_list, struct scatterlist *sgl,
-		u32 *se_mem_cnt);
+		struct list_head *se_mem_list, struct scatterlist *sgl);
 static void transport_memcpy_se_mem_read_contig(unsigned char *dst,
 		struct list_head *se_mem_list, u32 len);
 static void transport_release_fe_cmd(struct se_cmd *cmd);
@@ -3911,7 +3910,6 @@ int transport_generic_map_mem_to_cmd(
 	struct scatterlist *sgl_bidi,
 	u32 sgl_bidi_count)
 {
-	u32 mapped_sg_count = 0;
 	int ret;
 
 	if (!sgl || !sgl_count)
@@ -3927,24 +3925,20 @@ int transport_generic_map_mem_to_cmd(
 		 * processed into a TCM struct se_subsystem_dev, we do the mapping
 		 * from the passed physical memory to struct se_mem->se_page here.
 		 */
-		ret = transport_map_sg_to_mem(cmd,
-			&cmd->t_mem_list, sgl, &mapped_sg_count);
+		ret = transport_map_sg_to_mem(cmd, &cmd->t_mem_list, sgl);
 		if (ret < 0)
 			return -ENOMEM;
 
-		cmd->t_tasks_se_num = mapped_sg_count;
+		cmd->t_tasks_se_num = ret;
 		/*
 		 * Setup BIDI READ list of struct se_mem elements
 		 */
 		if (sgl_bidi && sgl_bidi_count) {
-			mapped_sg_count = 0;
-			ret = transport_map_sg_to_mem(cmd,
-				&cmd->t_mem_bidi_list, sgl_bidi,
-				&mapped_sg_count);
+			ret = transport_map_sg_to_mem(cmd, &cmd->t_mem_bidi_list, sgl_bidi);
 			if (ret < 0)
 				return -ENOMEM;
 
-			cmd->t_tasks_se_bidi_num = mapped_sg_count;
+			cmd->t_tasks_se_bidi_num = ret;
 		}
 		cmd->se_cmd_flags |= SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
 
@@ -4251,11 +4245,11 @@ static inline sector_t transport_limit_task_sectors(
 static int transport_map_sg_to_mem(
 	struct se_cmd *cmd,
 	struct list_head *se_mem_list,
-	struct scatterlist *sg,
-	u32 *sg_count)
+	struct scatterlist *sg)
 {
 	struct se_mem *se_mem;
 	u32 cmd_size = cmd->data_length;
+	int sg_count = 0;
 
 	WARN_ON(!sg);
 
@@ -4285,7 +4279,7 @@ static int transport_map_sg_to_mem(
 			se_mem->se_len = cmd_size;
 
 		cmd_size -= se_mem->se_len;
-		(*sg_count)++;
+		sg_count++;
 
 		DEBUG_MEM("sg_to_mem: sg_count: %u cmd_size: %u\n",
 				sg_count, cmd_size);
@@ -4297,7 +4291,7 @@ static int transport_map_sg_to_mem(
 
 	DEBUG_MEM("task[0] - Mapped(%u) struct scatterlist segments\n", sg_count);
 
-	return 0;
+	return sg_count;
 }
 
 /*	transport_map_mem_to_sg():
-- 
1.7.6

