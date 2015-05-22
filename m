From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [RFC 1/2] target: Add support for fabric IRQ completion
Date: Fri, 22 May 2015 07:57:25 +0000
Message-ID: <1432281446-31080-2-git-send-email-nab@daterainc.com>
References: <1432281446-31080-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1432281446-31080-1-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for invoking TFO completion callbacks directly
from IRQ context in target_complete_cmd().

Some fabric drivers like loopback and vhost can invoke their response
callbacks directly from IRQ context, and this patch allows the extra
queue_work() dispatch to a seperate work-queue process context to be
avoided for fast-path operation.

This includes the refactoring of target_complete_ok_work(), so that
transport_complete_task_attr() and target_complete_irq() can be
invoked directly from target_complete_cmd() context.

Also, target_restart_delayed_cmds() has been converted to use llist,
and will only be invoked from !in_interrupt() with a llist_del_all()
compare and exchange when draining the list of ordered tags.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Sagi Grimberg <sagig@mellanox.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_device.c    |   2 +-
 drivers/target/target_core_tpg.c       |   1 +
 drivers/target/target_core_transport.c | 165 ++++++++++++++++++++++++---------
 include/target/target_core_base.h      |   5 +-
 include/target/target_core_fabric.h    |   1 +
 5 files changed, 126 insertions(+), 48 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 1d98033..70213fa 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -739,7 +739,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	INIT_LIST_HEAD(&dev->dev_list);
 	INIT_LIST_HEAD(&dev->dev_sep_list);
 	INIT_LIST_HEAD(&dev->dev_tmr_list);
-	INIT_LIST_HEAD(&dev->delayed_cmd_list);
+	init_llist_head(&dev->delayed_cmd_llist);
 	INIT_LIST_HEAD(&dev->state_list);
 	INIT_LIST_HEAD(&dev->qf_cmd_list);
 	INIT_LIST_HEAD(&dev->g_dev_node);
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 3fbb0d4..aa08d6b 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -37,6 +37,7 @@
 
 #include <target/target_core_base.h>
 #include <target/target_core_backend.h>
+#include <target/target_core_configfs.h>
 #include <target/target_core_fabric.h>
 
 #include "target_core_internal.h"
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2ccaeff..a98a23c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -63,10 +63,11 @@ struct kmem_cache *t10_alua_tg_pt_gp_cache;
 struct kmem_cache *t10_alua_lba_map_cache;
 struct kmem_cache *t10_alua_lba_map_mem_cache;
 
-static void transport_complete_task_attr(struct se_cmd *cmd);
+static bool transport_complete_task_attr(struct se_cmd *cmd);
 static void transport_handle_queue_full(struct se_cmd *cmd,
 		struct se_device *dev);
 static int transport_put_cmd(struct se_cmd *cmd);
+static void target_complete_irq(struct se_cmd *cmd, bool);
 static void target_complete_ok_work(struct work_struct *work);
 
 int init_se_kmem_caches(void)
@@ -711,16 +712,37 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 		spin_unlock_irqrestore(&cmd->t_state_lock, flags);
 		complete_all(&cmd->t_transport_stop_comp);
 		return;
-	} else if (!success) {
-		INIT_WORK(&cmd->work, target_complete_failure_work);
-	} else {
+	}
+	if (success) {
+		/*
+		 * Invoke TFO completion callback now if fabric driver can
+		 * queue response in IRQ context, and special case descriptor
+		 * handling requirements in process context for ORDERED task
+		 * and friends do not exist.
+		 */
+		if (cmd->se_cmd_flags & SCF_COMPLETE_IRQ &&
+		    !(cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) &&
+		    !cmd->transport_complete_callback) {
+
+			cmd->t_state = TRANSPORT_COMPLETE;
+			cmd->transport_state |= (CMD_T_COMPLETE | CMD_T_ACTIVE);
+			spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+
+			if (!transport_complete_task_attr(cmd))
+				goto do_work;
+
+			target_complete_irq(cmd, true);
+			return;
+		}
 		INIT_WORK(&cmd->work, target_complete_ok_work);
+	} else {
+		INIT_WORK(&cmd->work, target_complete_failure_work);
 	}
 
 	cmd->t_state = TRANSPORT_COMPLETE;
 	cmd->transport_state |= (CMD_T_COMPLETE | CMD_T_ACTIVE);
 	spin_unlock_irqrestore(&cmd->t_state_lock, flags);
-
+do_work:
 	queue_work(target_completion_wq, &cmd->work);
 }
 EXPORT_SYMBOL(target_complete_cmd);
@@ -1145,7 +1167,6 @@ void transport_init_se_cmd(
 	int task_attr,
 	unsigned char *sense_buffer)
 {
-	INIT_LIST_HEAD(&cmd->se_delayed_node);
 	INIT_LIST_HEAD(&cmd->se_qf_node);
 	INIT_LIST_HEAD(&cmd->se_cmd_list);
 	INIT_LIST_HEAD(&cmd->state_list);
@@ -1155,6 +1176,8 @@ void transport_init_se_cmd(
 	spin_lock_init(&cmd->t_state_lock);
 	kref_init(&cmd->cmd_kref);
 	cmd->transport_state = CMD_T_DEV_ACTIVE;
+	if (tfo->complete_irq)
+		cmd->se_cmd_flags |= SCF_COMPLETE_IRQ;
 
 	cmd->se_tfo = tfo;
 	cmd->se_sess = se_sess;
@@ -1803,9 +1826,7 @@ static bool target_handle_task_attr(struct se_cmd *cmd)
 	if (atomic_read(&dev->dev_ordered_sync) == 0)
 		return false;
 
-	spin_lock(&dev->delayed_cmd_lock);
-	list_add_tail(&cmd->se_delayed_node, &dev->delayed_cmd_list);
-	spin_unlock(&dev->delayed_cmd_lock);
+	llist_add(&cmd->se_delayed_node, &dev->delayed_cmd_llist);
 
 	pr_debug("Added CDB: 0x%02x Task Attr: 0x%02x to"
 		" delayed CMD list, se_ordered_id: %u\n",
@@ -1856,28 +1877,32 @@ EXPORT_SYMBOL(target_execute_cmd);
 
 /*
  * Process all commands up to the last received ORDERED task attribute which
- * requires another blocking boundary
+ * requires another blocking boundary.
  */
 static void target_restart_delayed_cmds(struct se_device *dev)
 {
-	for (;;) {
-		struct se_cmd *cmd;
+	bool ordered = false;
+	struct se_cmd *cmd;
+	struct llist_node *llnode;
 
-		spin_lock(&dev->delayed_cmd_lock);
-		if (list_empty(&dev->delayed_cmd_list)) {
-			spin_unlock(&dev->delayed_cmd_lock);
-			break;
+	llnode = llist_del_all(&dev->delayed_cmd_llist);
+	while (llnode) {
+		cmd = llist_entry(llnode, struct se_cmd, se_delayed_node);
+		llnode = llist_next(llnode);
+		/*
+		 * Re-add outstanding command to se_device delayed llist to
+		 * satisfy ordered tag execution requirements.
+		 */
+		if (ordered) {
+			llist_add(&cmd->se_delayed_node, &dev->delayed_cmd_llist);
+			continue;
 		}
-
-		cmd = list_entry(dev->delayed_cmd_list.next,
-				 struct se_cmd, se_delayed_node);
-		list_del(&cmd->se_delayed_node);
-		spin_unlock(&dev->delayed_cmd_lock);
-
 		__target_execute_cmd(cmd);
 
-		if (cmd->sam_task_attr == TCM_ORDERED_TAG)
-			break;
+		if (cmd->sam_task_attr == TCM_ORDERED_TAG) {
+			ordered = true;
+			continue;
+		}
 	}
 }
 
@@ -1885,12 +1910,12 @@ static void target_restart_delayed_cmds(struct se_device *dev)
  * Called from I/O completion to determine which dormant/delayed
  * and ordered cmds need to have their tasks added to the execution queue.
  */
-static void transport_complete_task_attr(struct se_cmd *cmd)
+static bool transport_complete_task_attr(struct se_cmd *cmd)
 {
 	struct se_device *dev = cmd->se_dev;
 
 	if (dev->transport->transport_type == TRANSPORT_PLUGIN_PHBA_PDEV)
-		return;
+		return true;
 
 	if (cmd->sam_task_attr == TCM_SIMPLE_TAG) {
 		atomic_dec_mb(&dev->simple_cmds);
@@ -1910,8 +1935,23 @@ static void transport_complete_task_attr(struct se_cmd *cmd)
 		pr_debug("Incremented dev_cur_ordered_id: %u for ORDERED:"
 			" %u\n", dev->dev_cur_ordered_id, cmd->se_ordered_id);
 	}
+	/*
+	 * Check for special in_interrupt() case where completion can happen
+	 * for certain fabrics from IRQ context, as long as no outstanding
+	 * ordered tags exist.
+	 */
+	if (in_interrupt()) {
+		if (atomic_read(&dev->dev_ordered_sync))
+			return false;
 
+		return true;
+	}
+	/*
+	 * If called from process context, go ahead and drain the current
+	 * se_device->delayed_cmd_llist of ordered tags if any exist.
+	 */
 	target_restart_delayed_cmds(dev);
+	return true;
 }
 
 static void transport_complete_qf(struct se_cmd *cmd)
@@ -1995,18 +2035,18 @@ static bool target_read_prot_action(struct se_cmd *cmd)
 	return false;
 }
 
-static void target_complete_ok_work(struct work_struct *work)
-{
-	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
-	int ret;
 
-	/*
-	 * Check if we need to move delayed/dormant tasks from cmds on the
-	 * delayed execution list after a HEAD_OF_QUEUE or ORDERED Task
-	 * Attribute.
-	 */
-	transport_complete_task_attr(cmd);
+static void target_complete_queue_full(struct se_cmd *cmd)
+{
+	pr_debug("Handling complete_ok QUEUE_FULL: se_cmd: %p,"
+		 " data_direction: %d\n", cmd, cmd->data_direction);
+	cmd->t_state = TRANSPORT_COMPLETE_QF_OK;
+	transport_handle_queue_full(cmd, cmd->se_dev);
+}
 
+static bool target_complete_ok_pre(struct se_cmd *cmd)
+{
+	int ret;
 	/*
 	 * Check to schedule QUEUE_FULL work, or execute an existing
 	 * cmd->transport_qf_callback()
@@ -2027,7 +2067,7 @@ static void target_complete_ok_work(struct work_struct *work)
 
 		transport_lun_remove_cmd(cmd);
 		transport_cmd_check_stop_to_fabric(cmd);
-		return;
+		return true;
 	}
 	/*
 	 * Check for a callback, used by amongst other things
@@ -2040,9 +2080,9 @@ static void target_complete_ok_work(struct work_struct *work)
 		if (!rc && !(cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE_POST)) {
 			if ((cmd->se_cmd_flags & SCF_COMPARE_AND_WRITE) &&
 			    !cmd->data_length)
-				goto queue_rsp;
+				return false;
 
-			return;
+			return true;
 		} else if (rc) {
 			ret = transport_send_check_condition_and_sense(cmd,
 						rc, 0);
@@ -2051,11 +2091,27 @@ static void target_complete_ok_work(struct work_struct *work)
 
 			transport_lun_remove_cmd(cmd);
 			transport_cmd_check_stop_to_fabric(cmd);
-			return;
+			return true;
 		}
 	}
 
-queue_rsp:
+	return false;
+
+queue_full:
+	target_complete_queue_full(cmd);
+	return true;
+}
+
+static void target_complete_irq(struct se_cmd *cmd, bool check_qf)
+{
+	int ret;
+	/*
+	 * Check to schedule QUEUE_FULL work, or execute an existing
+	 * cmd->transport_qf_callback()
+	 */
+	if (check_qf && atomic_read(&cmd->se_dev->dev_qf_count) != 0)
+		schedule_work(&cmd->se_dev->qf_work_queue);
+
 	switch (cmd->data_direction) {
 	case DMA_FROM_DEVICE:
 		atomic_long_add(cmd->data_length,
@@ -2111,10 +2167,29 @@ queue_rsp:
 	return;
 
 queue_full:
-	pr_debug("Handling complete_ok QUEUE_FULL: se_cmd: %p,"
-		" data_direction: %d\n", cmd, cmd->data_direction);
-	cmd->t_state = TRANSPORT_COMPLETE_QF_OK;
-	transport_handle_queue_full(cmd, cmd->se_dev);
+	target_complete_queue_full(cmd);
+}
+
+static void target_complete_ok_work(struct work_struct *work)
+{
+	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
+	/*
+	 * Check if we need to move delayed/dormant tasks from cmds on the
+	 * delayed execution list after a HEAD_OF_QUEUE or ORDERED Task
+	 * Attribute.
+	 */
+	transport_complete_task_attr(cmd);
+	/*
+	 * Invoke special case handling for QUEUE_FULL, backend TASK_SENSE or
+	 * transport_complete_callback() cases.
+	 */
+	if (target_complete_ok_pre(cmd))
+		return;
+	/*
+	 * Perform the se_tfo->queue_data_in() and/or >se_tfo->queue_status()
+	 * callbacks into fabric code.
+	 */
+	target_complete_irq(cmd, false);
 }
 
 static inline void transport_free_sgl(struct scatterlist *sgl, int nents)
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 9f3878f..bc07c8b 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -156,6 +156,7 @@ enum se_cmd_flags_table {
 	SCF_COMPARE_AND_WRITE		= 0x00080000,
 	SCF_COMPARE_AND_WRITE_POST	= 0x00100000,
 	SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC = 0x00200000,
+	SCF_COMPLETE_IRQ		= 0x00400000,
 };
 
 /* struct se_dev_entry->lun_flags and struct se_lun->lun_access */
@@ -487,7 +488,7 @@ struct se_cmd {
 	u64			pr_res_key;
 	/* Used for sense data */
 	void			*sense_buffer;
-	struct list_head	se_delayed_node;
+	struct llist_node	se_delayed_node;
 	struct list_head	se_qf_node;
 	struct se_device      *se_dev;
 	struct se_lun		*se_lun;
@@ -795,7 +796,7 @@ struct se_device {
 	struct list_head	dev_tmr_list;
 	struct workqueue_struct *tmr_wq;
 	struct work_struct	qf_work_queue;
-	struct list_head	delayed_cmd_list;
+	struct llist_head	delayed_cmd_llist;
 	struct list_head	state_list;
 	struct list_head	qf_cmd_list;
 	struct list_head	g_dev_node;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index d6216b7..72c4a12 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -4,6 +4,7 @@
 struct target_core_fabric_ops {
 	struct module *module;
 	const char *name;
+	bool complete_irq;
 	size_t node_acl_size;
 	char *(*get_fabric_name)(void);
 	char *(*tpg_get_wwn)(struct se_portal_group *);
-- 
1.9.1
