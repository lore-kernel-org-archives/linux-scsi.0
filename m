From: lixiubo@cmss.chinamobile.com
Subject: [PATCHv2] tcmu: Add fifo type waiter list support to avoid starvation
Date: Wed, 12 Jul 2017 15:16:07 +0800
Message-ID: <1499843767-17420-1-git-send-email-lixiubo@cmss.chinamobile.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmccmta1.chinamobile.com ([221.176.66.79]:57421 "EHLO
        cmccmta1.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756530AbdGLHRY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2017 03:17:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, mchristi@redhat.com
Cc: bryantly@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Xiubo Li <lixiubo@cmss.chinamobile.com>

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

The fifo type waiter list will hold the udevs who are waiting for the
blocks from the data global pool. The unmap thread will try to feed the
first udevs in waiter list, if the global free blocks available are
not enough, it will stop traversing the list and abort waking up the
others.

Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
---
 drivers/target/target_core_user.c | 104 ++++++++++++++++++++++++++++++++------
 1 file changed, 88 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 80ee130..8bf0823 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -107,6 +107,8 @@ struct tcmu_nl_cmd {
 struct tcmu_dev {
 	struct list_head node;
 	struct kref kref;
+	struct list_head waiter;
+
 	struct se_device se_dev;
 
 	char *name;
@@ -132,7 +134,7 @@ struct tcmu_dev {
 	wait_queue_head_t wait_cmdr;
 	struct mutex cmdr_lock;
 
-	bool waiting_global;
+	uint32_t waiting_blocks;
 	uint32_t dbi_max;
 	uint32_t dbi_thresh;
 	DECLARE_BITMAP(data_bitmap, DATA_BLOCK_BITS);
@@ -176,9 +178,33 @@ struct tcmu_cmd {
 
 static struct task_struct *unmap_thread;
 static wait_queue_head_t unmap_wait;
+/*
+ * To avoid dead lock, the mutex locks order should always be:
+ *
+ * mutex_lock(&root_udev_mutex);
+ * ...
+ * mutex_lock(&tcmu_dev->cmdr_lock);
+ * mutex_unlock(&tcmu_dev->cmdr_lock);
+ * ...
+ * mutex_unlock(&root_udev_mutex);
+ */
 static DEFINE_MUTEX(root_udev_mutex);
 static LIST_HEAD(root_udev);
 
+/*
+ * To avoid dead lock, the mutex locks order should always be:
+ *
+ * mutex_lock(&root_udev_waiter_mutex);
+ * ...
+ * mutex_lock(&tcmu_dev->cmdr_lock);
+ * mutex_unlock(&tcmu_dev->cmdr_lock);
+ * ...
+ * mutex_unlock(&root_udev_waiter_mutex);
+ */
+static DEFINE_MUTEX(root_udev_waiter_mutex);
+/* The data blocks global pool waiter list */
+static LIST_HEAD(root_udev_waiter);
+
 static atomic_t global_db_count = ATOMIC_INIT(0);
 
 static struct kmem_cache *tcmu_cmd_cache;
@@ -321,6 +347,11 @@ static int tcmu_genl_set_features(struct sk_buff *skb, struct genl_info *info)
 #define tcmu_cmd_set_dbi(cmd, index) ((cmd)->dbi[(cmd)->dbi_cur++] = (index))
 #define tcmu_cmd_get_dbi(cmd) ((cmd)->dbi[(cmd)->dbi_cur++])
 
+static inline bool is_in_waiter_list(struct tcmu_dev *udev)
+{
+	return !!udev->waiting_blocks;
+}
+
 static void tcmu_cmd_free_data(struct tcmu_cmd *tcmu_cmd, uint32_t len)
 {
 	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
@@ -377,8 +408,6 @@ static bool tcmu_get_empty_blocks(struct tcmu_dev *udev,
 {
 	int i;
 
-	udev->waiting_global = false;
-
 	for (i = tcmu_cmd->dbi_cur; i < tcmu_cmd->dbi_cnt; i++) {
 		if (!tcmu_get_empty_block(udev, tcmu_cmd))
 			goto err;
@@ -386,9 +415,7 @@ static bool tcmu_get_empty_blocks(struct tcmu_dev *udev,
 	return true;
 
 err:
-	udev->waiting_global = true;
-	/* Try to wake up the unmap thread */
-	wake_up(&unmap_wait);
+	udev->waiting_blocks += tcmu_cmd->dbi_cnt - i;
 	return false;
 }
 
@@ -795,12 +822,26 @@ static inline size_t tcmu_cmd_get_cmd_size(struct tcmu_cmd *tcmu_cmd,
 
 	while (!is_ring_space_avail(udev, tcmu_cmd, command_size, data_length)) {
 		int ret;
+		bool is_waiting_blocks = is_in_waiter_list(udev);
 		DEFINE_WAIT(__wait);
 
 		prepare_to_wait(&udev->wait_cmdr, &__wait, TASK_INTERRUPTIBLE);
 
 		pr_debug("sleeping for ring space\n");
 		mutex_unlock(&udev->cmdr_lock);
+
+		/*
+		 * Try to insert the current udev to waiter list and
+		 * then wake up the unmap thread
+		 */
+		if (is_waiting_blocks) {
+			mutex_lock(&root_udev_waiter_mutex);
+			list_add_tail(&udev->waiter, &root_udev_waiter);
+			mutex_unlock(&root_udev_waiter_mutex);
+
+			wake_up(&unmap_wait);
+		}
+
 		if (udev->cmd_time_out)
 			ret = schedule_timeout(
 					msecs_to_jiffies(udev->cmd_time_out));
@@ -1023,8 +1064,6 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 	if (mb->cmd_tail == mb->cmd_head)
 		del_timer(&udev->timeout); /* no more pending cmds */
 
-	wake_up(&udev->wait_cmdr);
-
 	return handled;
 }
 
@@ -1121,7 +1160,17 @@ static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
 	struct tcmu_dev *tcmu_dev = container_of(info, struct tcmu_dev, uio_info);
 
 	mutex_lock(&tcmu_dev->cmdr_lock);
-	tcmu_handle_completions(tcmu_dev);
+	/*
+	 * If the current udev is also in waiter list, this will
+	 * make sure that the other waiters in list be fed ahead
+	 * of it.
+	 */
+	if (is_in_waiter_list(tcmu_dev)) {
+		wake_up(&unmap_wait);
+	} else {
+		tcmu_handle_completions(tcmu_dev);
+		wake_up(&tcmu_dev->wait_cmdr);
+	}
 	mutex_unlock(&tcmu_dev->cmdr_lock);
 
 	return 0;
@@ -1462,7 +1511,7 @@ static int tcmu_configure_device(struct se_device *dev)
 	udev->data_off = CMDR_SIZE;
 	udev->data_size = DATA_SIZE;
 	udev->dbi_thresh = 0; /* Default in Idle state */
-	udev->waiting_global = false;
+	udev->waiting_blocks = 0;
 
 	/* Initialise the mailbox of the ring buffer */
 	mb = udev->mb_addr;
@@ -1585,6 +1634,13 @@ static void tcmu_destroy_device(struct se_device *dev)
 	list_del(&udev->node);
 	mutex_unlock(&root_udev_mutex);
 
+	mutex_lock(&root_udev_waiter_mutex);
+	mutex_lock(&udev->cmdr_lock);
+	if (is_in_waiter_list(udev))
+		list_del(&udev->waiter);
+	mutex_unlock(&udev->cmdr_lock);
+	mutex_unlock(&root_udev_waiter_mutex);
+
 	vfree(udev->mb_addr);
 
 	/* Upper layer should drain all requests before calling this */
@@ -1911,6 +1967,7 @@ static int unmap_thread_fn(void *data)
 	struct tcmu_dev *udev;
 	loff_t off;
 	uint32_t start, end, block;
+	static uint32_t free_blocks;
 	struct page *page;
 	int i;
 
@@ -1932,7 +1989,7 @@ static int unmap_thread_fn(void *data)
 			tcmu_handle_completions(udev);
 
 			/* Skip the udevs waiting the global pool or in idle */
-			if (udev->waiting_global || !udev->dbi_thresh) {
+			if (is_in_waiter_list(udev) || !udev->dbi_thresh) {
 				mutex_unlock(&udev->cmdr_lock);
 				continue;
 			}
@@ -1968,17 +2025,32 @@ static int unmap_thread_fn(void *data)
 				}
 			}
 			mutex_unlock(&udev->cmdr_lock);
+
+			free_blocks += end - start;
 		}
+		mutex_unlock(&root_udev_mutex);
 
 		/*
 		 * Try to wake up the udevs who are waiting
-		 * for the global data pool.
+		 * for the global data pool blocks.
 		 */
-		list_for_each_entry(udev, &root_udev, node) {
-			if (udev->waiting_global)
-				wake_up(&udev->wait_cmdr);
+		mutex_lock(&root_udev_waiter_mutex);
+		list_for_each_entry(udev, &root_udev_waiter, waiter) {
+			mutex_lock(&udev->cmdr_lock);
+			if (udev->waiting_blocks < free_blocks) {
+				mutex_unlock(&udev->cmdr_lock);
+				break;
+			}
+
+			free_blocks -= udev->waiting_blocks;
+			udev->waiting_blocks = 0;
+			mutex_unlock(&udev->cmdr_lock);
+
+			list_del(&udev->waiter);
+
+			wake_up(&udev->wait_cmdr);
 		}
-		mutex_unlock(&root_udev_mutex);
+		mutex_unlock(&root_udev_waiter_mutex);
 	}
 
 	return 0;
-- 
1.8.3.1
