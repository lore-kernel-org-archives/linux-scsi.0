From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 039/103] target: Make t_mem_list and t_mem_list_bidi members of t_task
Date: Thu, 21 Jul 2011 00:07:51 -0700
Message-ID: <1311232135-6653-40-git-send-email-nab@linux-iscsi.org>
References: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm1-vm0.access.bullet.mail.sp2.yahoo.com ([98.139.44.94]:22868
	"HELO nm1-vm0.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752249Ab1GUHJB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:09:01 -0400
In-Reply-To: <1311232135-6653-32-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

This lets us eliminate 2 allocations and associated bookkeeping and error
checking. Remove transport_init_se_mem_list().

Change instances of list_entry(foo->next) to list_first_entry(foo).

Change names of variables that count sg entries to contain "count", as is
common as a kernel convention.

Remove SCF_PASSTHROUGH_SG_TO_MEM flag, not needed.

Use pointers to struct scatterlist instead of void *.

Minor other cleanups.

(nab: Fix list_empty(&cmd->t_task.t_mem_bidi_list) inversion bugs)

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/loopback/tcm_loop.c     |   37 +++-----
 drivers/target/target_core_rd.c        |    4 +-
 drivers/target/target_core_transport.c |  156 ++++++++++----------------------
 drivers/target/tcm_fc/tfc_cmd.c        |   12 ++--
 drivers/target/tcm_fc/tfc_io.c         |    4 +-
 include/target/target_core_base.h      |    6 +-
 6 files changed, 74 insertions(+), 145 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index cd73940..e0e8aaa 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -142,13 +142,13 @@ static int tcm_loop_new_cmd_map(struct se_cmd *se_cmd)
 	struct tcm_loop_cmd *tl_cmd = container_of(se_cmd,
 				struct tcm_loop_cmd, tl_se_cmd);
 	struct scsi_cmnd *sc = tl_cmd->sc;
-	void *mem_ptr, *mem_bidi_ptr = NULL;
-	u32 sg_no_bidi = 0;
+	struct scatterlist *sgl_bidi = NULL;
+	u32 sgl_bidi_count = 0;
 	int ret;
 	/*
 	 * Allocate the necessary tasks to complete the received CDB+data
 	 */
-	ret = transport_generic_allocate_tasks(se_cmd, tl_cmd->sc->cmnd);
+	ret = transport_generic_allocate_tasks(se_cmd, sc->cmnd);
 	if (ret == -ENOMEM) {
 		/* Out of Resources */
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
@@ -164,35 +164,24 @@ static int tcm_loop_new_cmd_map(struct se_cmd *se_cmd)
 		 */
 		return PYX_TRANSPORT_USE_SENSE_REASON;
 	}
+
 	/*
-	 * Setup the struct scatterlist memory from the received
-	 * struct scsi_cmnd.
+	 * For BIDI commands, pass in the extra READ buffer
+	 * to transport_generic_map_mem_to_cmd() below..
 	 */
-	if (scsi_sg_count(sc)) {
-		se_cmd->se_cmd_flags |= SCF_PASSTHROUGH_SG_TO_MEM;
-		mem_ptr = scsi_sglist(sc);
-		/*
-		 * For BIDI commands, pass in the extra READ buffer
-		 * to transport_generic_map_mem_to_cmd() below..
-		 */
-		if (se_cmd->t_task.t_tasks_bidi) {
-			struct scsi_data_buffer *sdb = scsi_in(sc);
+	if (se_cmd->t_task.t_tasks_bidi) {
+		struct scsi_data_buffer *sdb = scsi_in(sc);
 
-			mem_bidi_ptr = sdb->table.sgl;
-			sg_no_bidi = sdb->table.nents;
-		}
-	} else {
-		/*
-		 * Used for DMA_NONE
-		 */
-		mem_ptr = NULL;
+		sgl_bidi = sdb->table.sgl;
+		sgl_bidi_count = sdb->table.nents;
 	}
+
 	/*
 	 * Map the SG memory into struct se_mem->page linked list using the same
 	 * physical memory at sg->page_link.
 	 */
-	ret = transport_generic_map_mem_to_cmd(se_cmd, mem_ptr,
-			scsi_sg_count(sc), mem_bidi_ptr, sg_no_bidi);
+	ret = transport_generic_map_mem_to_cmd(se_cmd, scsi_sglist(sc),
+			scsi_sg_count(sc), sgl_bidi, sgl_bidi_count);
 	if (ret < 0)
 		return PYX_TRANSPORT_LU_COMM_FAILURE;
 
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 4215f5f..384a8e2 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -880,14 +880,14 @@ static int rd_DIRECT_do_se_mem_map(
 	 * across multiple struct se_task->task_sg[].
 	 */
 	ret = transport_init_task_sg(task,
-			list_entry(cmd->t_task.t_mem_list->next,
+			list_first_entry(&cmd->t_task.t_mem_list,
 				   struct se_mem, se_list),
 			task_offset);
 	if (ret <= 0)
 		return ret;
 
 	return transport_map_mem_to_sg(task, se_mem_list, task->task_sg,
-			list_entry(cmd->t_task.t_mem_list->next,
+			list_first_entry(&cmd->t_task.t_mem_list,
 				   struct se_mem, se_list),
 			out_se_mem, se_mem_cnt, task_offset_in);
 }
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 646649a..44f9afe 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -215,9 +215,8 @@ static int transport_generic_get_mem(struct se_cmd *cmd, u32 length,
 static int transport_generic_remove(struct se_cmd *cmd,
 		int release_to_pool, int session_reinstatement);
 static int transport_get_sectors(struct se_cmd *cmd);
-static struct list_head *transport_init_se_mem_list(void);
 static int transport_map_sg_to_mem(struct se_cmd *cmd,
-		struct list_head *se_mem_list, void *in_mem,
+		struct list_head *se_mem_list, struct scatterlist *sgl,
 		u32 *se_mem_cnt);
 static void transport_memcpy_se_mem_read_contig(struct se_cmd *cmd,
 		unsigned char *dst, struct list_head *se_mem_list);
@@ -1702,6 +1701,8 @@ void transport_init_se_cmd(
 	INIT_LIST_HEAD(&cmd->se_delayed_node);
 	INIT_LIST_HEAD(&cmd->se_ordered_node);
 
+	INIT_LIST_HEAD(&cmd->t_task.t_mem_list);
+	INIT_LIST_HEAD(&cmd->t_task.t_mem_bidi_list);
 	INIT_LIST_HEAD(&cmd->t_task.t_task_list);
 	init_completion(&cmd->t_task.transport_lun_fe_stop_comp);
 	init_completion(&cmd->t_task.transport_lun_stop_comp);
@@ -2801,14 +2802,14 @@ static void transport_xor_callback(struct se_cmd *cmd)
 	 * Copy the scatterlist WRITE buffer located at cmd->t_task.t_mem_list
 	 * into the locally allocated *buf
 	 */
-	transport_memcpy_se_mem_read_contig(cmd, buf, cmd->t_task.t_mem_list);
+	transport_memcpy_se_mem_read_contig(cmd, buf, &cmd->t_task.t_mem_list);
 	/*
 	 * Now perform the XOR against the BIDI read memory located at
 	 * cmd->t_task.t_mem_bidi_list
 	 */
 
 	offset = 0;
-	list_for_each_entry(se_mem, cmd->t_task.t_mem_bidi_list, se_list) {
+	list_for_each_entry(se_mem, &cmd->t_task.t_mem_bidi_list, se_list) {
 		addr = (unsigned char *)kmap_atomic(se_mem->se_page, KM_USER0);
 		if (!(addr))
 			goto out;
@@ -3754,7 +3755,7 @@ static void transport_generic_complete_ok(struct se_cmd *cmd)
 		/*
 		 * Check if we need to send READ payload for BIDI-COMMAND
 		 */
-		if (cmd->t_task.t_mem_bidi_list != NULL) {
+		if (!list_empty(&cmd->t_task.t_mem_bidi_list)) {
 			spin_lock(&cmd->se_lun->lun_sep_lock);
 			if (cmd->se_lun->lun_sep) {
 				cmd->se_lun->lun_sep->sep_stats.tx_data_octets +=
@@ -3829,7 +3830,7 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 		return;
 
 	list_for_each_entry_safe(se_mem, se_mem_tmp,
-			cmd->t_task.t_mem_list, se_list) {
+			&cmd->t_task.t_mem_list, se_list) {
 		/*
 		 * We only release call __free_page(struct se_mem->se_page) when
 		 * SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is NOT in use,
@@ -3841,9 +3842,9 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 		kmem_cache_free(se_mem_cache, se_mem);
 	}
 
-	if (cmd->t_task.t_mem_bidi_list && cmd->t_task.t_tasks_se_bidi_num) {
+	if (!list_empty(&cmd->t_task.t_mem_bidi_list) && cmd->t_task.t_tasks_se_bidi_num) {
 		list_for_each_entry_safe(se_mem, se_mem_tmp,
-				cmd->t_task.t_mem_bidi_list, se_list) {
+				&cmd->t_task.t_mem_bidi_list, se_list) {
 			/*
 			 * We only release call __free_page(struct se_mem->se_page) when
 			 * SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC is NOT in use,
@@ -3856,10 +3857,6 @@ static inline void transport_free_pages(struct se_cmd *cmd)
 		}
 	}
 
-	kfree(cmd->t_task.t_mem_bidi_list);
-	cmd->t_task.t_mem_bidi_list = NULL;
-	kfree(cmd->t_task.t_mem_list);
-	cmd->t_task.t_mem_list = NULL;
 	cmd->t_task.t_tasks_se_num = 0;
 }
 
@@ -3970,35 +3967,19 @@ free_pages:
  */
 int transport_generic_map_mem_to_cmd(
 	struct se_cmd *cmd,
-	struct scatterlist *mem,
-	u32 sg_mem_num,
-	struct scatterlist *mem_bidi_in,
-	u32 sg_mem_bidi_num)
+	struct scatterlist *sgl,
+	u32 sgl_count,
+	struct scatterlist *sgl_bidi,
+	u32 sgl_bidi_count)
 {
-	u32 se_mem_cnt_out = 0;
+	u32 mapped_sg_count = 0;
 	int ret;
 
-	if (!(mem) || !(sg_mem_num))
+	if (!sgl || !sgl_count)
 		return 0;
-	/*
-	 * Passed *mem will contain a list_head containing preformatted
-	 * struct se_mem elements...
-	 */
-	if (!(cmd->se_cmd_flags & SCF_PASSTHROUGH_SG_TO_MEM)) {
-		if ((mem_bidi_in) || (sg_mem_bidi_num)) {
-			printk(KERN_ERR "SCF_CMD_PASSTHROUGH_NOALLOC not supported"
-				" with BIDI-COMMAND\n");
-			return -ENOSYS;
-		}
 
-		cmd->t_task.t_mem_list = (struct list_head *)mem;
-		cmd->t_task.t_tasks_se_num = sg_mem_num;
-		cmd->se_cmd_flags |= SCF_CMD_PASSTHROUGH_NOALLOC;
-		return 0;
-	}
 	/*
-	 * Otherwise, assume the caller is passing a struct scatterlist
-	 * array from include/linux/scatterlist.h
+	 * Convert sgls (sgl, sgl_bidi) to list of se_mems
 	 */
 	if ((cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) ||
 	    (cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)) {
@@ -4007,41 +3988,29 @@ int transport_generic_map_mem_to_cmd(
 		 * processed into a TCM struct se_subsystem_dev, we do the mapping
 		 * from the passed physical memory to struct se_mem->se_page here.
 		 */
-		cmd->t_task.t_mem_list = transport_init_se_mem_list();
-		if (!(cmd->t_task.t_mem_list))
-			return -ENOMEM;
-
 		ret = transport_map_sg_to_mem(cmd,
-			cmd->t_task.t_mem_list, mem, &se_mem_cnt_out);
+			&cmd->t_task.t_mem_list, sgl, &mapped_sg_count);
 		if (ret < 0)
 			return -ENOMEM;
 
-		cmd->t_task.t_tasks_se_num = se_mem_cnt_out;
+		cmd->t_task.t_tasks_se_num = mapped_sg_count;
 		/*
 		 * Setup BIDI READ list of struct se_mem elements
 		 */
-		if ((mem_bidi_in) && (sg_mem_bidi_num)) {
-			cmd->t_task.t_mem_bidi_list = transport_init_se_mem_list();
-			if (!(cmd->t_task.t_mem_bidi_list)) {
-				kfree(cmd->t_task.t_mem_list);
-				return -ENOMEM;
-			}
-			se_mem_cnt_out = 0;
-
+		if (sgl_bidi && sgl_bidi_count) {
+			mapped_sg_count = 0;
 			ret = transport_map_sg_to_mem(cmd,
-				cmd->t_task.t_mem_bidi_list, mem_bidi_in,
-				&se_mem_cnt_out);
-			if (ret < 0) {
-				kfree(cmd->t_task.t_mem_list);
+				&cmd->t_task.t_mem_bidi_list, sgl_bidi,
+				&mapped_sg_count);
+			if (ret < 0)
 				return -ENOMEM;
-			}
 
-			cmd->t_task.t_tasks_se_bidi_num = se_mem_cnt_out;
+			cmd->t_task.t_tasks_se_bidi_num = mapped_sg_count;
 		}
 		cmd->se_cmd_flags |= SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC;
 
 	} else if (cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
-		if (mem_bidi_in || sg_mem_bidi_num) {
+		if (sgl_bidi || sgl_bidi_count) {
 			printk(KERN_ERR "BIDI-Commands not supported using "
 				"SCF_SCSI_CONTROL_NONSG_IO_CDB\n");
 			return -ENOSYS;
@@ -4056,7 +4025,8 @@ int transport_generic_map_mem_to_cmd(
 		 * struct scatterlist format.
 		 */
 		cmd->se_cmd_flags |= SCF_PASSTHROUGH_CONTIG_TO_SG;
-		cmd->t_task.t_task_pt_sgl = mem;
+		cmd->t_task.t_task_pt_sgl = sgl;
+		/* don't need sgl count? We assume it contains cmd->data_length data */
 	}
 
 	return 0;
@@ -4111,12 +4081,12 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 		 * cmd->t_task.t_mem_bidi_list so the READ struct se_tasks
 		 * are queued first for the non pSCSI passthrough case.
 		 */
-		if ((cmd->t_task.t_mem_bidi_list != NULL) &&
+		if (!list_empty(&cmd->t_task.t_mem_bidi_list) &&
 		    (dev->transport->transport_type != TRANSPORT_PLUGIN_PHBA_PDEV)) {
 			rc = transport_generic_get_cdb_count(cmd,
 				cmd->t_task.t_task_lba,
 				cmd->t_task.t_tasks_sectors,
-				DMA_FROM_DEVICE, cmd->t_task.t_mem_bidi_list,
+				DMA_FROM_DEVICE, &cmd->t_task.t_mem_bidi_list,
 				set_counts);
 			if (!(rc)) {
 				cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
@@ -4133,7 +4103,7 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 		task_cdbs = transport_generic_get_cdb_count(cmd,
 				cmd->t_task.t_task_lba,
 				cmd->t_task.t_tasks_sectors,
-				cmd->data_direction, cmd->t_task.t_mem_list,
+				cmd->data_direction, &cmd->t_task.t_mem_list,
 				set_counts);
 		if (!(task_cdbs)) {
 			cmd->se_cmd_flags |= SCF_SCSI_CDB_EXCEPTION;
@@ -4157,47 +4127,18 @@ static int transport_new_cmd_obj(struct se_cmd *cmd)
 	return 0;
 }
 
-static struct list_head *transport_init_se_mem_list(void)
-{
-	struct list_head *se_mem_list;
-
-	se_mem_list = kzalloc(sizeof(struct list_head), GFP_KERNEL);
-	if (!(se_mem_list)) {
-		printk(KERN_ERR "Unable to allocate memory for se_mem_list\n");
-		return NULL;
-	}
-	INIT_LIST_HEAD(se_mem_list);
-
-	return se_mem_list;
-}
-
 static int
 transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
 {
 	unsigned char *buf;
 	struct se_mem *se_mem;
 
-	cmd->t_task.t_mem_list = transport_init_se_mem_list();
-	if (!(cmd->t_task.t_mem_list))
-		return -ENOMEM;
-
 	/*
 	 * If the device uses memory mapping this is enough.
 	 */
 	if (cmd->se_dev->transport->do_se_mem_map)
 		return 0;
 
-	/*
-	 * Setup BIDI-COMMAND READ list of struct se_mem elements
-	 */
-	if (cmd->t_task.t_tasks_bidi) {
-		cmd->t_task.t_mem_bidi_list = transport_init_se_mem_list();
-		if (!(cmd->t_task.t_mem_bidi_list)) {
-			kfree(cmd->t_task.t_mem_list);
-			return -ENOMEM;
-		}
-	}
-
 	while (length) {
 		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
 		if (!(se_mem)) {
@@ -4222,7 +4163,7 @@ transport_generic_get_mem(struct se_cmd *cmd, u32 length, u32 dma_size)
 		memset(buf, 0, se_mem->se_len);
 		kunmap_atomic(buf, KM_IRQ0);
 
-		list_add_tail(&se_mem->se_list, cmd->t_task.t_mem_list);
+		list_add_tail(&se_mem->se_list, &cmd->t_task.t_mem_list);
 		cmd->t_task.t_tasks_se_num++;
 
 		DEBUG_MEM("Allocated struct se_mem page(%p) Length(%u)"
@@ -4265,7 +4206,7 @@ int transport_init_task_sg(
 				sg_length = se_mem->se_len;
 
 				if (!(list_is_last(&se_mem->se_list,
-						se_cmd->t_task.t_mem_list)))
+						&se_cmd->t_task.t_mem_list)))
 					se_mem = list_entry(se_mem->se_list.next,
 							struct se_mem, se_list);
 			} else {
@@ -4285,7 +4226,7 @@ int transport_init_task_sg(
 				sg_length = (se_mem->se_len - task_offset);
 
 				if (!(list_is_last(&se_mem->se_list,
-						se_cmd->t_task.t_mem_list)))
+						&se_cmd->t_task.t_mem_list)))
 					se_mem = list_entry(se_mem->se_list.next,
 							struct se_mem, se_list);
 			}
@@ -4326,7 +4267,7 @@ next:
 	 * Setup task->task_sg_bidi for SCSI READ payload for
 	 * TCM/pSCSI passthrough if present for BIDI-COMMAND
 	 */
-	if ((se_cmd->t_task.t_mem_bidi_list != NULL) &&
+	if (!list_empty(&se_cmd->t_task.t_mem_bidi_list) &&
 	    (se_dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)) {
 		task->task_sg_bidi = kzalloc(task_sg_num_padded *
 				sizeof(struct scatterlist), GFP_KERNEL);
@@ -4417,19 +4358,19 @@ static inline int transport_set_tasks_sectors(
 				max_sectors_set);
 }
 
+/*
+ * Convert a sgl into a linked list of se_mems.
+ */
 static int transport_map_sg_to_mem(
 	struct se_cmd *cmd,
 	struct list_head *se_mem_list,
-	void *in_mem,
+	struct scatterlist *sg,
 	u32 *se_mem_cnt)
 {
 	struct se_mem *se_mem;
-	struct scatterlist *sg;
 	u32 sg_count = 1, cmd_size = cmd->data_length;
 
-	WARN_ON(!in_mem);
-
-	sg = (struct scatterlist *)in_mem;
+	WARN_ON(!sg);
 
 	while (cmd_size) {
 		se_mem = kmem_cache_zalloc(se_mem_cache, GFP_KERNEL);
@@ -4510,7 +4451,7 @@ int transport_map_mem_to_sg(
 				sg->length = se_mem->se_len;
 
 				if (!(list_is_last(&se_mem->se_list,
-						se_cmd->t_task.t_mem_list))) {
+						&se_cmd->t_task.t_mem_list))) {
 					se_mem = list_entry(se_mem->se_list.next,
 							struct se_mem, se_list);
 					(*se_mem_cnt)++;
@@ -4546,7 +4487,7 @@ int transport_map_mem_to_sg(
 				sg->length = (se_mem->se_len - *task_offset);
 
 				if (!(list_is_last(&se_mem->se_list,
-						se_cmd->t_task.t_mem_list))) {
+						&se_cmd->t_task.t_mem_list))) {
 					se_mem = list_entry(se_mem->se_list.next,
 							struct se_mem, se_list);
 					(*se_mem_cnt)++;
@@ -4764,15 +4705,14 @@ static u32 transport_generic_get_cdb_count(
 	 * mem_list will ever be empty at this point.
 	 */
 	if (!(list_empty(mem_list)))
-		se_mem = list_entry(mem_list->next, struct se_mem, se_list);
+		se_mem = list_first_entry(mem_list, struct se_mem, se_list);
 	/*
 	 * Check for extra se_mem_bidi mapping for BIDI-COMMANDs to
 	 * struct se_task->task_sg_bidi for TCM/pSCSI passthrough operation
 	 */
-	if ((cmd->t_task.t_mem_bidi_list != NULL) &&
-	    !(list_empty(cmd->t_task.t_mem_bidi_list)) &&
+	if (!list_empty(&cmd->t_task.t_mem_bidi_list) &&
 	    (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV))
-		se_mem_bidi = list_entry(cmd->t_task.t_mem_bidi_list->next,
+		se_mem_bidi = list_first_entry(&cmd->t_task.t_mem_bidi_list,
 					struct se_mem, se_list);
 
 	while (sectors) {
@@ -4824,7 +4764,7 @@ static u32 transport_generic_get_cdb_count(
 		 */
 		if (task->task_sg_bidi != NULL) {
 			ret = transport_do_se_mem_map(dev, task,
-				cmd->t_task.t_mem_bidi_list, NULL,
+				&cmd->t_task.t_mem_bidi_list, NULL,
 				se_mem_bidi, &se_mem_bidi_lout, &se_mem_bidi_cnt,
 				&task_offset_in);
 			if (ret < 0)
@@ -4888,12 +4828,12 @@ transport_map_control_cmd_to_task(struct se_cmd *cmd)
 		struct se_mem *se_mem = NULL, *se_mem_lout = NULL;
 		u32 se_mem_cnt = 0, task_offset = 0;
 
-		if (!list_empty(cmd->t_task.t_mem_list))
-			se_mem = list_entry(cmd->t_task.t_mem_list->next,
+		if (!list_empty(&cmd->t_task.t_mem_list))
+			se_mem = list_first_entry(&cmd->t_task.t_mem_list,
 					struct se_mem, se_list);
 
 		ret = transport_do_se_mem_map(dev, task,
-				cmd->t_task.t_mem_list, NULL, se_mem,
+				&cmd->t_task.t_mem_list, NULL, se_mem,
 				&se_mem_lout, &se_mem_cnt, &task_offset);
 		if (ret < 0)
 			return PYX_TRANSPORT_OUT_OF_MEMORY_RESOURCES;
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index 161e3c9..6d9553b 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -76,12 +76,12 @@ void ft_dump_cmd(struct ft_cmd *cmd, const char *caller)
 	printk(KERN_INFO "%s: cmd %p task %p se_num %u buf %p len %u se_cmd_flags <0x%x>\n",
 	       caller, cmd, task, task->t_tasks_se_num,
 	       task->t_task_buf, se_cmd->data_length, se_cmd->se_cmd_flags);
-	if (task->t_mem_list)
-		list_for_each_entry(mem, task->t_mem_list, se_list)
-			printk(KERN_INFO "%s: cmd %p mem %p page %p "
-			       "len 0x%x off 0x%x\n",
-			       caller, cmd, mem,
-			       mem->se_page, mem->se_len, mem->se_off);
+
+	list_for_each_entry(mem, &task->t_mem_list, se_list)
+		printk(KERN_INFO "%s: cmd %p mem %p page %p "
+		       "len 0x%x off 0x%x\n",
+		       caller, cmd, mem,
+		       mem->se_page, mem->se_len, mem->se_off);
 	sp = cmd->seq;
 	if (sp) {
 		ep = fc_seq_exch(sp);
diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index e21d839..f18af6e 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -97,7 +97,7 @@ int ft_queue_data_in(struct se_cmd *se_cmd)
 	 * Setup to use first mem list entry if any.
 	 */
 	if (task->t_tasks_se_num) {
-		mem = list_first_entry(task->t_mem_list,
+		mem = list_first_entry(&task->t_mem_list,
 			 struct se_mem, se_list);
 		mem_len = mem->se_len;
 		mem_off = mem->se_off;
@@ -313,7 +313,7 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 	 * Setup to use first mem list entry if any.
 	 */
 	if (task->t_tasks_se_num) {
-		mem = list_first_entry(task->t_mem_list,
+		mem = list_first_entry(&task->t_mem_list,
 				       struct se_mem, se_list);
 		mem_len = mem->se_len;
 		mem_off = mem->se_off;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index c84afc3..94c838d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -123,7 +123,7 @@ enum se_cmd_flags_table {
 	SCF_SENT_DELAYED_TAS		= 0x00020000,
 	SCF_ALUA_NON_OPTIMIZED		= 0x00040000,
 	SCF_DELAYED_CMD_FROM_SAM_ATTR	= 0x00080000,
-	SCF_PASSTHROUGH_SG_TO_MEM	= 0x00100000,
+	SCF_UNUSED			= 0x00100000,
 	SCF_PASSTHROUGH_CONTIG_TO_SG	= 0x00200000,
 	SCF_PASSTHROUGH_SG_TO_MEM_NOALLOC = 0x00400000,
 	SCF_EMULATE_SYNC_CACHE		= 0x00800000,
@@ -452,9 +452,9 @@ struct se_transport_task {
 	 * and other HW target mode fabric modules.
 	 */
 	struct scatterlist	*t_task_pt_sgl;
-	struct list_head	*t_mem_list;
+	struct list_head	t_mem_list;
 	/* Used for BIDI READ */
-	struct list_head	*t_mem_bidi_list;
+	struct list_head	t_mem_bidi_list;
 	struct list_head	t_task_list;
 } ____cacheline_aligned;
 
-- 
1.7.6

