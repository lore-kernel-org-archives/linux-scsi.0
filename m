From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 06/19] tcmu: split unmap_thread_fn
Date: Sun, 29 Oct 2017 22:44:26 -0500
Message-ID: <1509335079-5276-7-git-send-email-mchristi@redhat.com>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49360 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752090AbdJ3Dot (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Oct 2017 23:44:49 -0400
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Mike Christie <mchristi@redhat.com>

Separate unmap_thread_fn to make it easier to read.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 120 ++++++++++++++++++++++----------------
 1 file changed, 70 insertions(+), 50 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index a6205e4..15b54fd 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1971,71 +1971,91 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 	.tb_dev_attrib_attrs	= NULL,
 };
 
-static int unmap_thread_fn(void *data)
+
+static void find_free_blocks(void)
 {
 	struct tcmu_dev *udev;
 	loff_t off;
 	uint32_t start, end, block;
 
-	while (!kthread_should_stop()) {
-		DEFINE_WAIT(__wait);
-
-		prepare_to_wait(&unmap_wait, &__wait, TASK_INTERRUPTIBLE);
-		schedule();
-		finish_wait(&unmap_wait, &__wait);
+	mutex_lock(&root_udev_mutex);
+	list_for_each_entry(udev, &root_udev, node) {
+		mutex_lock(&udev->cmdr_lock);
 
-		if (kthread_should_stop())
-			break;
+		/* Try to complete the finished commands first */
+		tcmu_handle_completions(udev);
 
-		mutex_lock(&root_udev_mutex);
-		list_for_each_entry(udev, &root_udev, node) {
-			mutex_lock(&udev->cmdr_lock);
+		/* Skip the udevs waiting the global pool or in idle */
+		if (udev->waiting_global || !udev->dbi_thresh) {
+			mutex_unlock(&udev->cmdr_lock);
+			continue;
+		}
 
-			/* Try to complete the finished commands first */
-			tcmu_handle_completions(udev);
+		end = udev->dbi_max + 1;
+		block = find_last_bit(udev->data_bitmap, end);
+		if (block == udev->dbi_max) {
+			/*
+			 * The last bit is dbi_max, so there is
+			 * no need to shrink any blocks.
+			 */
+			mutex_unlock(&udev->cmdr_lock);
+			continue;
+		} else if (block == end) {
+			/* The current udev will goto idle state */
+			udev->dbi_thresh = start = 0;
+			udev->dbi_max = 0;
+		} else {
+			udev->dbi_thresh = start = block + 1;
+			udev->dbi_max = block;
+		}
 
-			/* Skip the udevs waiting the global pool or in idle */
-			if (udev->waiting_global || !udev->dbi_thresh) {
-				mutex_unlock(&udev->cmdr_lock);
-				continue;
-			}
+		/* Here will truncate the data area from off */
+		off = udev->data_off + start * DATA_BLOCK_SIZE;
+		unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
 
-			end = udev->dbi_max + 1;
-			block = find_last_bit(udev->data_bitmap, end);
-			if (block == udev->dbi_max) {
-				/*
-				 * The last bit is dbi_max, so there is
-				 * no need to shrink any blocks.
-				 */
-				mutex_unlock(&udev->cmdr_lock);
-				continue;
-			} else if (block == end) {
-				/* The current udev will goto idle state */
-				udev->dbi_thresh = start = 0;
-				udev->dbi_max = 0;
-			} else {
-				udev->dbi_thresh = start = block + 1;
-				udev->dbi_max = block;
-			}
+		/* Release the block pages */
+		tcmu_blocks_release(&udev->data_blocks, start, end);
+		mutex_unlock(&udev->cmdr_lock);
+	}
+	mutex_unlock(&root_udev_mutex);
+}
 
-			/* Here will truncate the data area from off */
-			off = udev->data_off + start * DATA_BLOCK_SIZE;
-			unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
+static void run_cmdr_queues(void)
+{
+	struct tcmu_dev *udev;
 
-			/* Release the block pages */
-			tcmu_blocks_release(&udev->data_blocks, start, end);
+	/*
+	 * Try to wake up the udevs who are waiting
+	 * for the global data block pool.
+	 */
+	mutex_lock(&root_udev_mutex);
+	list_for_each_entry(udev, &root_udev, node) {
+		mutex_lock(&udev->cmdr_lock);
+		if (!udev->waiting_global) {
 			mutex_unlock(&udev->cmdr_lock);
+			break;
 		}
+		mutex_unlock(&udev->cmdr_lock);
 
-		/*
-		 * Try to wake up the udevs who are waiting
-		 * for the global data pool.
-		 */
-		list_for_each_entry(udev, &root_udev, node) {
-			if (udev->waiting_global)
-				wake_up(&udev->wait_cmdr);
-		}
-		mutex_unlock(&root_udev_mutex);
+		wake_up(&udev->wait_cmdr);
+	}
+	mutex_unlock(&root_udev_mutex);
+}
+
+static int unmap_thread_fn(void *data)
+{
+	while (!kthread_should_stop()) {
+		DEFINE_WAIT(__wait);
+
+		prepare_to_wait(&unmap_wait, &__wait, TASK_INTERRUPTIBLE);
+		schedule();
+		finish_wait(&unmap_wait, &__wait);
+
+		if (kthread_should_stop())
+			break;
+
+		find_free_blocks();
+		run_cmdr_queues();
 	}
 
 	return 0;
-- 
1.8.3.1
