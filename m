From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] tcm: Move special PASSTHROUGH_CONTIG_TO_SG handling into internal TFO callbacks
Date: Mon,  8 Nov 2010 19:43:31 -0800
Message-ID: <1289274211-12191-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp107.sbc.mail.gq1.yahoo.com ([67.195.14.110]:40080 "HELO
	smtp107.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751287Ab0KIDnf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2010 22:43:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Kiran Patil <kiran.patil@intel.com>, "Robert W. Love" <robert.w.love@intel.com>, Yi Zou <yi.zou@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, Joe Eykholt <jeykholt@cisco.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch updates transport_generic_complete_ok() and transport_generic_write_pending()
code to check for the existence of SCF_PASSTHROUGH_CONTIG_TO_SG for se_cmd I/O
descriptors of type SCF_SCSI_CONTROL_NONSG_IO_CDB that have been setup using
transport_generic_map_mem_to_cmd().

This is special case handling for TCM_Loop and other HW fabric modules that only speak
pre-registered SGL memory with se_cmd descriptors of type SCF_SCSI_CONTROL_NONSG_IO_CDB,
and that require a copy using transport_generic_[write,read]_contig() to/from the
contigious buffer at T_TASK(cmd)->t_task_buf.  This is following current ordering
convention and does the special check + copy immediately preceeding the TFO->write_pending()
and TFO->queue_data_in() calls back out to fabric module code.

This patch also adds a few parameter naming+type cleanups + docbook comments for
transport_generic_map_mem_to_cmd() and drops the internal SCF_PASSTHROUGH_CONTIG_TO_SG
handling from TCM_Loop code.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c    |   67 ++++++++++++++++++++++------
 drivers/target/tcm_loop/tcm_loop_fabric.c |   21 ---------
 include/target/target_core_base.h         |    7 +++-
 include/target/target_core_transport.h    |    4 +-
 4 files changed, 60 insertions(+), 39 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index fda11e9..63dbb3e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5680,6 +5680,16 @@ void transport_generic_complete_ok(struct se_cmd *cmd)
 					cmd->data_length;
 		}
 		spin_unlock(&cmd->se_lun->lun_sep_lock);
+		/*
+		 * If enabled by TCM fabirc module pre-registered SGL
+		 * memory, perform the memcpy() from the TCM internal
+		 * contigious buffer back to the original SGL.
+		 */
+		if (cmd->se_cmd_flags & SCF_PASSTHROUGH_CONTIG_TO_SG)
+			transport_memcpy_write_contig(cmd,
+				 T_TASK(cmd)->t_task_pt_sgl,
+				 T_TASK(cmd)->t_task_buf);
+
 		CMD_TFO(cmd)->queue_data_in(cmd);
 		break;
 	case DMA_TO_DEVICE:
@@ -5927,31 +5937,42 @@ release_cmd:
 	return 0;
 }
 
+/*
+ * transport_generic_map_mem_to_cmd - Perform SGL -> struct se_mem map
+ * @cmd:  Associated se_cmd descriptor
+ * @mem:  SGL style memory for TCM WRITE / READ
+ * @sg_mem_num: Number of SGL elements
+ * @mem_bidi_in: SGL style memory for TCM BIDI READ
+ * @sg_mem_bidi_num: Number of BIDI READ SGL elements 
+ *
+ * Return: nonzero return cmd was rejected for -ENOMEM or inproper usage
+ * of parameters.
+ */
 int transport_generic_map_mem_to_cmd(
 	struct se_cmd *cmd,
-	void *mem,
-	u32 se_mem_num,
-	void *mem_bidi_in,
-	u32 se_mem_bidi_num)
+	struct scatterlist *mem,
+	u32 sg_mem_num,
+	struct scatterlist *mem_bidi_in,
+	u32 sg_mem_bidi_num)
 {
 	u32 se_mem_cnt_out = 0;
 	int ret;
 
-	if (!(mem) || !(se_mem_num))
+	if (!(mem) || !(sg_mem_num))
 		return 0;
 	/*
 	 * Passed *mem will contain a list_head containing preformatted
 	 * struct se_mem elements...
 	 */
 	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM)) {
-		if ((mem_bidi_in) || (se_mem_bidi_num)) {
+		if ((mem_bidi_in) || (sg_mem_bidi_num)) {
 			printk(KERN_ERR "SCF_CMD_PASSTHROUGH_NOALLOC not supported"
 				" with BIDI-COMMAND\n");
 			return -ENOSYS;
 		}
 
 		T_TASK(cmd)->t_mem_list = (struct list_head *)mem;
-		T_TASK(cmd)->t_tasks_se_num = se_mem_num;
+		T_TASK(cmd)->t_tasks_se_num = sg_mem_num;
 		cmd->se_cmd_flags |= SCF_CMD_PASSTHROUGH_NOALLOC;
 		return 0;
 	}
@@ -5979,7 +6000,7 @@ int transport_generic_map_mem_to_cmd(
 		/*
 		 * Setup BIDI READ list of struct se_mem elements
 		 */
-		if ((mem_bidi_in) && (se_mem_bidi_num)) {
+		if ((mem_bidi_in) && (sg_mem_bidi_num)) {
 			T_TASK(cmd)->t_mem_bidi_list = transport_init_se_mem_list();
 			if (!(T_TASK(cmd)->t_mem_bidi_list)) {
 				kfree(T_TASK(cmd)->t_mem_list);
@@ -6000,16 +6021,22 @@ int transport_generic_map_mem_to_cmd(
 		cmd->se_cmd_flags |= SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
 
 	} else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
+		if (mem_bidi_in || sg_mem_bidi_num) {
+			printk(KERN_ERR "BIDI-Commands not supported using "
+				"SCF_SCSI_CONTROL_NONSG_IO_CDB\n");
+			return -ENOSYS;
+		}
 		/*
-		 * For CDBs using a contiguous buffer, save the passed
-		 * struct scatterlist memory.  After TCM storage object
-		 * processing has completed for this struct se_cmd, the calling
-		 * TCM fabric module is expected to call 
-		 * transport_memcpy_write_contig() to copy the TCM buffer
-		 * back into the passed *mem of type struct scatterlist array.
+		 * For incoming CDBs using a contiguous buffer internall with TCM,
+		 * save the passed struct scatterlist memory.  After TCM storage object
+		 * processing has completed for this struct se_cmd, TCM core will call
+		 * transport_memcpy_[write,read]_contig() as necessary from
+		 * transport_generic_complete_ok() and transport_write_pending() in order
+		 * to copy the TCM buffer to/from the original passed *mem in SGL ->
+		 * struct scatterlist format.
 		 */
 		cmd->se_cmd_flags |= SCF_PASSTHROUGH_CONTIG_TO_SG;
-		T_TASK(cmd)->t_task_pt_buf = mem;
+		T_TASK(cmd)->t_task_pt_sgl = mem;
 	}
 
 	return 0;
@@ -7036,6 +7063,16 @@ static int transport_generic_write_pending(struct se_cmd *cmd)
 	cmd->t_state = TRANSPORT_WRITE_PENDING;
 	spin_unlock_irqrestore(&T_TASK(cmd)->t_state_lock, flags);
 	/*
+	 * For the TCM control CDBs using a contiguous buffer, do the memcpy
+	 * from the passed Linux/SCSI struct scatterlist located at
+	 * T_TASK(se_cmd)->t_task_pt_buf to the contiguous buffer at
+	 * T_TASK(se_cmd)->t_task_buf.
+	 */
+	if (cmd->se_cmd_flags & SCF_PASSTHROUGH_CONTIG_TO_SG)
+		transport_memcpy_read_contig(cmd,
+				T_TASK(cmd)->t_task_buf,
+				T_TASK(cmd)->t_task_pt_sgl);
+	/*
 	 * Call the fabric write_pending function here to let the
 	 * frontend know that WRITE buffers are ready.
 	 */
diff --git a/drivers/target/tcm_loop/tcm_loop_fabric.c b/drivers/target/tcm_loop/tcm_loop_fabric.c
index 2ac551b..27a803f 100644
--- a/drivers/target/tcm_loop/tcm_loop_fabric.c
+++ b/drivers/target/tcm_loop/tcm_loop_fabric.c
@@ -345,19 +345,6 @@ int tcm_loop_write_pending(struct se_cmd *se_cmd)
 	 * memory, and memory has already been mapped to struct se_cmd->t_mem_list
 	 * format with transport_generic_map_mem_to_cmd().
 	 *
-	 * For the TCM control CDBs using a contiguous buffer, do the memcpy
-	 * from the passed Linux/SCSI struct scatterlist located at
-	 * T_TASK(se_cmd)->t_task_pt_buf to the contiguous buffer at
-	 * T_TASK(se_cmd)->t_task_buf.
-	 */
-	if (se_cmd->se_cmd_flags & SCF_PASSTHROUGH_CONTIG_TO_SG) {
-		TL_CDB_DEBUG("Calling transport_memcpy_read_contig()"
-				" for SCF_PASSTHROUGH_CONTIG_TO_SG\n");
-		transport_memcpy_read_contig(se_cmd,
-				T_TASK(se_cmd)->t_task_buf,
-				T_TASK(se_cmd)->t_task_pt_buf);
-	}
-	/*
 	 * We now tell TCM to add this WRITE CDB directly into the TCM storage
 	 * object execution queue.
 	 */
@@ -379,14 +366,6 @@ int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
 	TL_CDB_DEBUG( "tcm_loop_queue_data_in() called for scsi_cmnd: %p"
 			" cdb: 0x%02x\n", sc, sc->cmnd[0]);
 
-	if (se_cmd->se_cmd_flags & SCF_PASSTHROUGH_CONTIG_TO_SG) {
-		TL_CDB_DEBUG("Calling transport_memcpy_write_contig()"
-			" for SCF_PASSTHROUGH_CONTIG_TO_SG\n");
-		transport_memcpy_write_contig(se_cmd,
-			T_TASK(se_cmd)->t_task_pt_buf,
-			T_TASK(se_cmd)->t_task_buf);
-	}
-
 	sc->result = host_byte(DID_OK) | SAM_STAT_GOOD;
 	(*sc->scsi_done)(sc);
 	return 0;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 8b98e72..ead2caf 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -462,7 +462,12 @@ struct se_transport_task {
 	struct scatterlist	*t_tasks_sg_chained;
 	struct scatterlist	t_tasks_sg_bounce;
 	void			*t_task_buf;
-	void			*t_task_pt_buf;
+	/*
+	 * Used for pre-registered fabric SGL passthrough WRITE and READ
+	 * with the special SCF_PASSTHROUGH_CONTIG_TO_SG case for TCM_Loop
+	 * and other HW target mode fabric modules.
+	 */
+	struct scatterlist	*t_task_pt_sgl;
 	struct list_head	*t_mem_list;
 	/* Used for BIDI READ */
 	struct list_head	*t_mem_bidi_list;
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 88d208e..a2e6ef9 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -243,8 +243,8 @@ extern void transport_generic_complete_ok(struct se_cmd *);
 extern void transport_free_dev_tasks(struct se_cmd *);
 extern void transport_release_fe_cmd(struct se_cmd *);
 extern int transport_generic_remove(struct se_cmd *, int, int);
-extern int transport_generic_map_mem_to_cmd(struct se_cmd *cmd, void *, u32,
-				void *, u32);
+extern int transport_generic_map_mem_to_cmd(struct se_cmd *cmd, struct scatterlist *, u32,
+				struct scatterlist *, u32);
 extern int transport_lun_wait_for_tasks(struct se_cmd *, struct se_lun *);
 extern int transport_clear_lun_from_sessions(struct se_lun *);
 extern int transport_check_aborted_status(struct se_cmd *, int);
-- 
1.5.6.5

