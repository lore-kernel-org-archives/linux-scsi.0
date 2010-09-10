From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/4] tcm: Add support for fabric module provided struct se_cmd descriptors
Date: Fri, 10 Sep 2010 02:26:35 -0700
Message-ID: <1284110795-316-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Joe Eykholt <jeykholt@cisco.com>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Boaz Harrosh <bharrosh@panasas.com>, Richard Sharpe <realrichardsharpe@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for the initialization and release of pre-allocated
struct se_cmd descriptors for use within a per I/O context TCM fabric module dependent
data structures.  This allows a TCM fabric module to avoid the extra memory allocation
calls in *transport_alloc_se_cmd(), and have the 'struct se_cmd', 'struct se_cmd->t_task'
and 'struct se_cmd->sense_buffer' memory provided by said per I/O context TCM fabric
module dependent data structures.

This includes the addition of a new transport_init_se_cmd() function, which is
intended to be used by v4 fabric modules using pre-allocated struct se_cmd descriptors
instead of the current *transport_alloc_se_cmd() code.  This includes a
'unsigned char *sense_buffer' parameter used for setting up the struct se_cmd->sense_buffer
pointer.  __transport_alloc_se_cmd() has also been converted to use transport_init_se_cmd().

On the release path, this includes the addition of a transport_release_se_cmd() wrapper
for handling both the pre-allocation and legacy allocation cases, and also updates
transport_release_cmd_to_pool() to follow the new pre-allocated logic.

Also note this patch series keeps existing TCM fabric module compatibility of
using *transport_alloc_se_cmd(), and transport_init_se_cmd() can be enabled
transparently as an optional feature on a per fabric module basis.

Many thanks to Joe Eykholt for originally mentioning this optimization here:

http://groups.google.com/group/linux-iscsi-target-dev/browse_thread/thread/88a6434fa9cad163

Thanks again Joe!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |  131 +++++++++++++++++++++++++-------
 include/target/target_core_base.h      |    3 +
 include/target/target_core_transport.h |    4 +
 3 files changed, 110 insertions(+), 28 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 95401cb..8c72993 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2738,6 +2738,7 @@ struct se_cmd *__transport_alloc_se_cmd(
 	int task_attr)
 {
 	struct se_cmd *cmd;
+	unsigned char *sense_buffer;
 	int gfp_type = (in_interrupt()) ? GFP_ATOMIC : GFP_KERNEL;
 
 	if (data_direction == SE_DIRECTION_BIDI) {
@@ -2750,27 +2751,50 @@ struct se_cmd *__transport_alloc_se_cmd(
 		printk(KERN_ERR "kmem_cache_alloc() failed for se_cmd_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	INIT_LIST_HEAD(&cmd->se_lun_list);
-	INIT_LIST_HEAD(&cmd->se_delayed_list);
-	INIT_LIST_HEAD(&cmd->se_ordered_list);
-
-	cmd->t_task = kzalloc(sizeof(struct se_transport_task), gfp_type);
-	if (!(cmd->t_task)) {
-		printk(KERN_ERR "Unable to allocate cmd->t_task\n");
-		kmem_cache_free(se_cmd_cache, cmd);
-		return NULL;
-	}
 
-	cmd->sense_buffer = kzalloc(
+	sense_buffer = kzalloc(
 			TRANSPORT_SENSE_BUFFER + tfo->get_fabric_sense_len(),
 			gfp_type);
-	if (!(cmd->sense_buffer)) {
+	if (!(sense_buffer)) {
 		printk(KERN_ERR "Unable to allocate memory for"
 			" cmd->sense_buffer\n");
-		kfree(cmd->t_task);
 		kmem_cache_free(se_cmd_cache, cmd);
 		return NULL;
 	}
+	/*
+	 * Initialize the new struct se_cmd descriptor
+	 */
+	transport_init_se_cmd(cmd, tfo, se_sess, data_length, data_direction,
+			task_attr, sense_buffer);
+	/*
+	 * Setup the se_fabric_cmd_ptr assignment which will signal
+	 * TCM allocation of struct se_cmd in the release and free codepaths
+	 */
+	cmd->se_fabric_cmd_ptr = fabric_cmd_ptr;
+	return cmd;
+}
+
+/*
+ * Used by fabric modules containing a local struct se_cmd within their
+ * fabric dependent per I/O descriptor.
+ */
+void transport_init_se_cmd(
+	struct se_cmd *cmd,
+	struct target_core_fabric_ops *tfo,
+	struct se_session *se_sess,
+	u32 data_length,
+	int data_direction,
+	int task_attr,
+	unsigned char *sense_buffer)
+{
+	INIT_LIST_HEAD(&cmd->se_lun_list);
+	INIT_LIST_HEAD(&cmd->se_delayed_list);
+	INIT_LIST_HEAD(&cmd->se_ordered_list);
+	/*
+	 * Setup t_task pointer to t_task_backstore
+	 */
+	cmd->t_task = &cmd->t_task_backstore;
+
 	INIT_LIST_HEAD(&T_TASK(cmd)->t_task_list);
 	init_completion(&T_TASK(cmd)->transport_lun_fe_stop_comp);
 	init_completion(&T_TASK(cmd)->transport_lun_stop_comp);
@@ -2782,13 +2806,12 @@ struct se_cmd *__transport_alloc_se_cmd(
 
 	cmd->se_tfo = tfo;
 	cmd->se_sess = se_sess;
-	cmd->se_fabric_cmd_ptr = fabric_cmd_ptr;
 	cmd->data_length = data_length;
 	cmd->data_direction = data_direction;
 	cmd->sam_task_attr = task_attr;
-
-	return cmd;
+	cmd->sense_buffer = sense_buffer;
 }
+EXPORT_SYMBOL(transport_init_se_cmd);
 
 int transport_check_alloc_task_attr(struct se_cmd *cmd)
 {
@@ -2834,11 +2857,19 @@ void transport_free_se_cmd(
 {
 	if (se_cmd->se_tmr_req)
 		core_tmr_release_req(se_cmd->se_tmr_req);
-
+	/*
+	 * Release any optional TCM fabric dependent iovecs allocated by
+	 * transport_allocate_iovecs_for_cmd()
+	 */
 	kfree(se_cmd->iov_data);
-	kfree(se_cmd->sense_buffer);
-	kfree(se_cmd->t_task);
-	kmem_cache_free(se_cmd_cache, se_cmd);
+	/*
+	 * Only release the sense_buffer, t_task, and remaining se_cmd memory
+	 * if this descriptor was allocated with transport_alloc_se_cmd()
+	 */
+	if (se_cmd->se_fabric_cmd_ptr) {
+		kfree(se_cmd->sense_buffer);
+		kmem_cache_free(se_cmd_cache, se_cmd);
+	}
 }
 EXPORT_SYMBOL(transport_free_se_cmd);
 
@@ -5841,8 +5872,8 @@ static inline struct se_cmd *transport_alloc_passthrough_cmd(
 	u32 data_length,
 	int data_direction)
 {
-	return __transport_alloc_se_cmd(&passthrough_fabric_ops, NULL, NULL,
-			data_length, data_direction, TASK_ATTR_SIMPLE);
+	return __transport_alloc_se_cmd(&passthrough_fabric_ops, NULL,
+		(void *)1, data_length, data_direction, TASK_ATTR_SIMPLE);
 }
 
 static inline void transport_release_tasks(struct se_cmd *);
@@ -6346,6 +6377,22 @@ static inline int transport_dec_and_check(struct se_cmd *cmd)
 	return 0;
 }
 
+static inline void transport_release_se_cmd(struct se_cmd *cmd)
+{
+	/*
+	 * Determine if this struct se_cmd descriptor was allocated
+	 * with __transport_alloc_se_cmd(), or is a member of a
+	 * TCM fabric module dependent descriptor.
+	 */
+	if (cmd->se_fabric_cmd_ptr) {
+		CMD_TFO(cmd)->release_cmd_direct(cmd);
+		transport_free_se_cmd(cmd);
+	} else {
+		transport_free_se_cmd(cmd);
+		CMD_TFO(cmd)->release_cmd_direct(cmd);
+	}
+}
+
 void transport_release_fe_cmd(struct se_cmd *cmd)
 {
 	unsigned long flags;
@@ -6369,8 +6416,7 @@ free_pages:
 	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)
 		kfree(cmd->se_lun);
 
-	CMD_TFO(cmd)->release_cmd_direct(cmd);
-	transport_free_se_cmd(cmd);
+	transport_release_se_cmd(cmd);
 }
 
 /*	transport_generic_remove():
@@ -6417,8 +6463,7 @@ release_cmd:
 		if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)
 			kfree(cmd->se_lun);
 
-		CMD_TFO(cmd)->release_cmd_direct(cmd);
-		transport_free_se_cmd(cmd);
+		transport_release_se_cmd(cmd);
 	}
 
 	return 0;
@@ -7498,9 +7543,39 @@ void transport_release_cmd_to_pool(struct se_cmd *cmd)
 	if (cmd->se_cmd_flags & SCF_CMD_PASSTHROUGH)
 		kfree(cmd->se_lun);
 	/*
-	 * Release struct se_cmd->se_fabric_cmd_ptr in fabric
+	 * A NULL cmd->se_fabric_cmd_ptr signals that the TCM fabric module
+	 * is using struct se_cmd as part of it's internal fabric per I/O
+	 * descriptor
+	 */
+	if (!(cmd->se_fabric_cmd_ptr)) {
+		transport_free_se_cmd(cmd);
+		/*
+		 * Make sure that this is only called for struct se_cmd
+		 * descriptors containing valid T_TASK(cmd) and CMD_TFO(cmd)
+		 * pointers
+		 */	
+		if ((T_TASK(cmd) && (CMD_TFO(cmd))))
+			CMD_TFO(cmd)->release_cmd_to_pool(cmd);
+		else {
+			printk(KERN_ERR "T_TASK(cmd) && (CMD_TFO(cmd) NULL for"
+				" se_fabric_cmd_ptr=NULL inside of"
+				" transport_release_cmd_to_pool()\n");
+			dump_stack();
+		}
+
+		return;
+	}
+	/*
+	 * Release explict allocated struct se_cmd->se_fabric_cmd_ptr in fabric
 	 */
-	CMD_TFO(cmd)->release_cmd_to_pool(cmd);
+	if ((T_TASK(cmd) && (CMD_TFO(cmd))))
+		CMD_TFO(cmd)->release_cmd_to_pool(cmd);
+	else {
+		dump_stack();
+		printk(KERN_ERR "NULL T_TASK(cmd) && (CMD_TFO(cmd) for"
+			" se_fabric_cmd_ptr=1 inside of"
+			" transport_release_cmd_to_pool()\n");
+	}
 
 	transport_free_se_cmd(cmd);
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 3c14037..e9f053f 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -584,10 +584,13 @@ struct se_cmd {
 	struct se_device	*se_obj_ptr;
 	struct se_device	*se_orig_obj_ptr;
 	struct se_lun		*se_lun;
+	/* Only used for internal passthrough and legacy TCM fabric modules */
 	void			*se_fabric_cmd_ptr;
 	struct se_session	*se_sess;
 	struct se_tmr_req	*se_tmr_req;
+	/* t_task is setup to t_task_backstore in transport_init_se_cmd() */
 	struct se_transport_task *t_task;
+	struct se_transport_task t_task_backstore;
 	struct target_core_fabric_ops *se_tfo;
 	int (*transport_add_cmd_to_queue)(struct se_cmd *, int);
 	int (*transport_allocate_resources)(struct se_cmd *, u32, u32);
diff --git a/include/target/target_core_transport.h b/include/target/target_core_transport.h
index 2eee898..8f6e3e2 100644
--- a/include/target/target_core_transport.h
+++ b/include/target/target_core_transport.h
@@ -186,6 +186,10 @@ extern int transport_check_alloc_task_attr(struct se_cmd *);
 extern struct se_cmd *transport_alloc_se_cmd(struct target_core_fabric_ops *,
 					struct se_session *, void *,
 					u32, int, int);
+extern void transport_init_se_cmd(struct se_cmd *,
+					struct target_core_fabric_ops *,
+					struct se_session *, u32, int, int,
+					unsigned char *);
 extern void transport_free_se_cmd(struct se_cmd *);
 extern int transport_generic_allocate_tasks(struct se_cmd *, unsigned char *);
 extern int transport_generic_handle_cdb(struct se_cmd *);
-- 
1.5.6.5
