From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 046/103] target: Replace custom sg<->buf functions with lib funcs
Date: Thu, 21 Jul 2011 00:07:58 -0700
Message-ID: <1311232135-6653-47-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm19.access.bullet.mail.sp2.yahoo.com ([98.139.44.146]:25890
	"HELO nm19.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751924Ab1GUHEM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:04:12 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Use sg_copy_to/from_buffer instead of transport_memcpy_read/write_contig.
They are the same, except we also need to track the number of sg entries,
which we do by adding a count to se_transport_task.

Also, fix some comment typos.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   80 ++++---------------------------
 include/target/target_core_base.h      |    1 +
 2 files changed, 12 insertions(+), 69 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index bf401da..887314f 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3542,66 +3542,6 @@ out_invalid_cdb_field:
 
 static inline void transport_release_tasks(struct se_cmd *);
 
-/*
- * This function will copy a contiguous *src buffer into a destination
- * struct scatterlist array.
- */
-static void transport_memcpy_write_contig(
-	struct se_cmd *cmd,
-	struct scatterlist *sg_d,
-	unsigned char *src)
-{
-	u32 i = 0, length = 0, total_length = cmd->data_length;
-	void *dst;
-
-	while (total_length) {
-		length = sg_d[i].length;
-
-		if (length > total_length)
-			length = total_length;
-
-		dst = sg_virt(&sg_d[i]);
-
-		memcpy(dst, src, length);
-
-		if (!(total_length -= length))
-			return;
-
-		src += length;
-		i++;
-	}
-}
-
-/*
- * This function will copy a struct scatterlist array *sg_s into a destination
- * contiguous *dst buffer.
- */
-static void transport_memcpy_read_contig(
-	struct se_cmd *cmd,
-	unsigned char *dst,
-	struct scatterlist *sg_s)
-{
-	u32 i = 0, length = 0, total_length = cmd->data_length;
-	void *src;
-
-	while (total_length) {
-		length = sg_s[i].length;
-
-		if (length > total_length)
-			length = total_length;
-
-		src = sg_virt(&sg_s[i]);
-
-		memcpy(dst, src, length);
-
-		if (!(total_length -= length))
-			return;
-
-		dst += length;
-		i++;
-	}
-}
-
 static void transport_memcpy_se_mem_read_contig(
 	struct se_cmd *cmd,
 	unsigned char *dst,
@@ -3744,14 +3684,15 @@ static void transport_generic_complete_ok(struct se_cmd *cmd)
 		}
 		spin_unlock(&cmd->se_lun->lun_sep_lock);
 		/*
-		 * If enabled by TCM fabirc module pre-registered SGL
+		 * If enabled by TCM fabric module pre-registered SGL
 		 * memory, perform the memcpy() from the TCM internal
-		 * contigious buffer back to the original SGL.
+		 * contiguous buffer back to the original SGL.
 		 */
 		if (cmd->se_cmd_flags & SCF_PASSTHROUGH_CONTIG_TO_SG)
-			transport_memcpy_write_contig(cmd,
-				 cmd->t_task.t_task_pt_sgl,
-				 cmd->t_task.t_task_buf);
+			sg_copy_from_buffer(cmd->t_task.t_task_pt_sgl,
+					    cmd->t_task.t_task_pt_sgl_num,
+					    cmd->t_task.t_task_buf,
+					    cmd->data_length);
 
 		cmd->se_tfo->queue_data_in(cmd);
 		break;
@@ -4031,7 +3972,7 @@ int transport_generic_map_mem_to_cmd(
 		 */
 		cmd->se_cmd_flags |= SCF_PASSTHROUGH_CONTIG_TO_SG;
 		cmd->t_task.t_task_pt_sgl = sgl;
-		/* don't need sgl count? We assume it contains cmd->data_length data */
+		cmd->t_task.t_task_pt_sgl_num = sgl_count;
 	}
 
 	return 0;
@@ -5031,9 +4972,10 @@ static int transport_generic_write_pending(struct se_cmd *cmd)
 	 * se_cmd->t_task.t_task_buf.
 	 */
 	if (cmd->se_cmd_flags & SCF_PASSTHROUGH_CONTIG_TO_SG)
-		transport_memcpy_read_contig(cmd,
-				cmd->t_task.t_task_buf,
-				cmd->t_task.t_task_pt_sgl);
+		sg_copy_to_buffer(cmd->t_task.t_task_pt_sgl,
+				    cmd->t_task.t_task_pt_sgl_num,
+				    cmd->t_task.t_task_buf,
+				    cmd->data_length);
 	/*
 	 * Clear the se_cmd for WRITE_PENDING status in order to set
 	 * cmd->t_task.t_transport_active=0 so that transport_generic_handle_data
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 94c838d..ff1b461 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -452,6 +452,7 @@ struct se_transport_task {
 	 * and other HW target mode fabric modules.
 	 */
 	struct scatterlist	*t_task_pt_sgl;
+	u32			t_task_pt_sgl_num;
 	struct list_head	t_mem_list;
 	/* Used for BIDI READ */
 	struct list_head	t_mem_bidi_list;
-- 
1.7.6

