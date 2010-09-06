From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/6] tcm: Add support for struct target_core_fabric_ops->task_sg_chaining
Date: Mon,  6 Sep 2010 14:37:09 -0700
Message-ID: <1283809029-13661-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp105.sbc.mail.ne1.yahoo.com ([98.138.84.183]:21722 "HELO
	smtp105.sbc.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755754Ab0IFVhP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2010 17:37:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for struct target_core_fabric_ops->task_sg_chaining=1,
which allows a single struct se_cmd descriptor to use include/linux/scatterlist.h
SGL chaining logic and link contigious struct se_task->task_sg[] arrays together
into a single walkable scatterlist chain for HW target mode drivers that require
this for pci_map_sg().

This also includes a transport_do_task_sg_chain() helper which does the sg_chain()
calls, and other necessary struct scatterlist->page_link termination bit twiddling to
create a linked SGL from struct se_task->task_sg[] created in transport_calc_sg_num()

Inside of transport_calc_sg_num(), this patch when running in TFI->task_sg_chaining=1
mode will alloc an extra trailing padding struct scatterlist entry to the primary
struct se_task->task_sg[] allocation.  The call to transport_do_task_sg_chain()
will then use these extra trailing SGL for the sg_chain() call.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c  |  127 +++++++++++++++++++++++++++++-
 include/target/target_core_base.h       |    4 +
 include/target/target_core_fabric_ops.h |    6 ++
 include/target/target_core_transport.h  |    1 +
 4 files changed, 133 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5be102c..602b2d8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -6736,7 +6736,8 @@ extern u32 transport_calc_sg_num(
 {
 	struct se_cmd *se_cmd = task->task_se_cmd;
 	struct se_mem *se_mem = in_se_mem;
-	u32 sg_length, task_size = task->task_size;
+	struct target_core_fabric_ops *tfo = CMD_TFO(se_cmd);
+	u32 sg_length, task_size = task->task_size, task_sg_num_padded;
 
 	while (task_size != 0) {
 		DEBUG_SC("se_mem->se_page(%p) se_mem->se_len(%u)"
@@ -6786,8 +6787,19 @@ next:
 
 		task->task_sg_num++;
 	}
+	/*
+	 * Check if the fabric module driver is requesting that all
+	 * struct se_task->task_sg[] be chained together..  If so,
+	 * then allocate an extra padding SG entry for linking and
+	 * marking the end of the chained SGL.
+	 */
+	if (tfo->task_sg_chaining) {
+		task_sg_num_padded = (task->task_sg_num + 1);
+		task->task_padded_sg = 1;
+	} else
+		task_sg_num_padded = task->task_sg_num;
 
-	task->task_sg = kzalloc(task->task_sg_num *
+	task->task_sg = kzalloc(task_sg_num_padded *
 			sizeof(struct scatterlist), GFP_KERNEL);
 	if (!(task->task_sg)) {
 		printk(KERN_ERR "Unable to allocate memory for"
@@ -6795,10 +6807,18 @@ next:
 		return 0;
 	}
 
-	sg_init_table(&task->task_sg[0], task->task_sg_num);
+	sg_init_table(&task->task_sg[0], task_sg_num_padded);
+	/*
+	 * For the chaining case, setup the proper end of SGL for the
+	 * initial submission struct task into struct se_subsystem_api.
+	 * This will be cleared later by transport_do_task_sg_chain()
+	 */
+	if (task->task_padded_sg)
+		sg_mark_end(&task->task_sg[task->task_sg_num - 1]);
 
-	DEBUG_SC("Successfully allocated task->task_sg_num(%u)\n",
-			task->task_sg_num);
+	DEBUG_SC("Successfully allocated task->task_sg_num(%u),"
+		" task_sg_num_padded(%u)\n", task->task_sg_num,
+		task_sg_num_padded);
 
 	return task->task_sg_num;
 }
@@ -7021,6 +7041,103 @@ next:
 	return 0;
 }
 
+/*
+ * This function can be used by HW target mode drivers to create a linked
+ * scatterlist from all contiguously allocated struct se_task->task_sg[].
+ * This is intended to be called during the completion path by TCM Core
+ * when struct target_core_fabric_ops->check_task_sg_chaining is enabled.
+ */
+void transport_do_task_sg_chain(struct se_cmd *cmd)
+{
+	struct scatterlist *sg_head = NULL, *sg_link = NULL, *sg_first = NULL;
+	struct scatterlist *sg_head_cur = NULL, *sg_link_cur = NULL;
+	struct scatterlist *sg, *sg_end = NULL, *sg_end_cur = NULL;
+	struct se_task *task;
+	struct target_core_fabric_ops *tfo = CMD_TFO(cmd);
+	u32 task_sg_num = 0, sg_count = 0;
+	int i;
+
+	if (tfo->task_sg_chaining == 0) {
+		printk(KERN_ERR "task_sg_chaining is diabled for fabric module:"
+				" %s\n", tfo->get_fabric_name());
+		dump_stack();
+		return;
+	}
+	/*
+	 * Walk the struct se_task list and setup scatterlist chains
+	 * for each contiguosly allocated struct se_task->task_sg[].
+	 */
+	list_for_each_entry(task, &T_TASK(cmd)->t_task_list, t_list) {
+		if (!(task->task_sg) || !(task->task_padded_sg))
+			continue;
+
+		if (sg_head && sg_link) {
+			sg_head_cur = &task->task_sg[0];
+			sg_link_cur = &task->task_sg[task->task_sg_num];
+			/*
+			 * Either add chain or mark end of scatterlist
+			 */
+			if (!(list_is_last(&task->t_list,
+					&T_TASK(cmd)->t_task_list))) {
+				/*
+				 * Clear existing SGL termination bit set in
+				 * transport_calc_sg_num(), see sg_mark_end()
+				 */
+				sg_end_cur = &task->task_sg[task->task_sg_num - 1];
+				sg_end_cur->page_link &= ~0x02;
+
+				sg_chain(sg_head, task_sg_num, sg_head_cur);
+				sg_count += (task->task_sg_num + 1);
+			} else
+				sg_count += task->task_sg_num;
+
+			sg_head = sg_head_cur;
+			sg_link = sg_link_cur;
+			task_sg_num = task->task_sg_num;
+			continue;
+		}
+		sg_head = sg_first = &task->task_sg[0];
+		sg_link = &task->task_sg[task->task_sg_num];
+		task_sg_num = task->task_sg_num;
+		/*
+		 * Check for single task..
+		 */
+		if (!(list_is_last(&task->t_list, &T_TASK(cmd)->t_task_list))) {
+			/*
+			 * Clear existing SGL termination bit set in
+			 * transport_calc_sg_num(), see sg_mark_end()
+			 */
+			sg_end = &task->task_sg[task->task_sg_num - 1];
+			sg_end->page_link &= ~0x02;
+			sg_count += (task->task_sg_num + 1);
+		} else
+			sg_count += task->task_sg_num;
+	}
+	/*
+	 * Setup the starting pointer and total t_tasks_sg_linked_no including
+	 * padding SGs for linking and to mark the end.
+	 */
+	T_TASK(cmd)->t_tasks_sg_chained = sg_first;
+	T_TASK(cmd)->t_tasks_sg_chained_no = sg_count;
+
+	printk("Setup T_TASK(cmd)->t_tasks_sg_chained: %p and"
+		" t_tasks_sg_chained_no: %u\n", T_TASK(cmd)->t_tasks_sg_chained,
+		T_TASK(cmd)->t_tasks_sg_chained_no);
+
+	for_each_sg(T_TASK(cmd)->t_tasks_sg_chained, sg,
+			T_TASK(cmd)->t_tasks_sg_chained_no, i) {
+
+		printk("SG: %p page: %p length: %d offset: %d\n",
+			sg, sg_page(sg), sg->length, sg->offset);
+		if (sg_is_chain(sg))
+			printk("SG: %p sg_is_chain=1\n", sg);
+		if (sg_is_last(sg))
+			printk("SG: %p sg_is_last=1\n", sg);
+	}
+
+}
+EXPORT_SYMBOL(transport_do_task_sg_chain);
+
 static int transport_do_se_mem_map(
 	struct se_device *dev,
 	struct se_task *task,
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 0833612..dbcc04a 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -439,6 +439,7 @@ struct se_transport_task {
 	u32			t_tasks_no;
 	u32			t_tasks_sectors;
 	u32			t_tasks_se_num;
+	u32			t_tasks_sg_chained_no;
 	atomic_t		t_fe_count;
 	atomic_t		t_se_count;
 	atomic_t		t_task_cdbs_left;
@@ -462,6 +463,8 @@ struct se_transport_task {
 	struct completion	t_transport_passthrough_wcomp;
 	struct completion	transport_lun_fe_stop_comp;
 	struct completion	transport_lun_stop_comp;
+	struct scatterlist	*t_tasks_sg_chained;
+	struct scatterlist	t_tasks_sg_bounce;
 	void			*t_task_buf;
 	void			*t_task_pt_buf;
 	struct list_head	t_task_list;
@@ -476,6 +479,7 @@ struct se_task {
 	u8		task_flags;
 	int		task_error_status;
 	int		task_state_flags;
+	int		task_padded_sg:1;
 	unsigned long long	task_lba;
 	u32		task_no;
 	u32		task_sectors;
diff --git a/include/target/target_core_fabric_ops.h b/include/target/target_core_fabric_ops.h
index e620eda..5dd61a9 100644
--- a/include/target/target_core_fabric_ops.h
+++ b/include/target/target_core_fabric_ops.h
@@ -3,6 +3,12 @@ struct target_fabric_configfs;
 
 struct target_core_fabric_ops {
 	struct configfs_subsystem *tf_subsys;
+	/*
+	 * Optional to signal struct se_task->task_sg[] padding entries
+	 * for scatterlist chaining using transport_do_task_sg_link(),
+	 * disabled by default
+	 */
+	int task_sg_chaining:1;
 	char *(*get_fabric_name)(void);
 	u8 (*get_fabric_proto_ident)(struct se_portal_group *);
 	char *(*tpg_get_wwn)(struct se_portal_group *);
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 711ec71..2eee898 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -263,6 +263,7 @@ extern int transport_map_sg_to_mem(struct se_cmd *, struct list_head *,
 extern int transport_map_mem_to_sg(struct se_task *, struct list_head *,
 					void *, struct se_mem *,
 					struct se_mem **, u32 *, u32 *);
+extern void transport_do_task_sg_chain(struct se_cmd *);
 extern u32 transport_generic_get_cdb_count(struct se_cmd *,
 					struct se_transform_info *,
 					unsigned long long, u32, struct se_mem *,
-- 
1.5.6.5

