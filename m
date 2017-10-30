From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 05/19] tcmu: merge common block release code
Date: Sun, 29 Oct 2017 22:44:25 -0500
Message-ID: <1509335079-5276-6-git-send-email-mchristi@redhat.com>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Have unmap_thread_fn use tcmu_blocks_release.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 4f666a5..a6205e4 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1301,21 +1301,19 @@ static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
 	return -EINVAL;
 }
 
-static void tcmu_blocks_release(struct tcmu_dev *udev)
+static void tcmu_blocks_release(struct radix_tree_root *blocks,
+				int start, int end)
 {
 	int i;
 	struct page *page;
 
-	/* Try to release all block pages */
-	mutex_lock(&udev->cmdr_lock);
-	for (i = 0; i <= udev->dbi_max; i++) {
-		page = radix_tree_delete(&udev->data_blocks, i);
+	for (i = start; i < end; i++) {
+		page = radix_tree_delete(blocks, i);
 		if (page) {
 			__free_page(page);
 			atomic_dec(&global_db_count);
 		}
 	}
-	mutex_unlock(&udev->cmdr_lock);
 }
 
 static void tcmu_dev_kref_release(struct kref *kref)
@@ -1339,7 +1337,9 @@ static void tcmu_dev_kref_release(struct kref *kref)
 	spin_unlock_irq(&udev->commands_lock);
 	WARN_ON(!all_expired);
 
-	tcmu_blocks_release(udev);
+	mutex_lock(&udev->cmdr_lock);
+	tcmu_blocks_release(&udev->data_blocks, 0, udev->dbi_max + 1);
+	mutex_unlock(&udev->cmdr_lock);
 
 	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
 }
@@ -1976,8 +1976,6 @@ static int unmap_thread_fn(void *data)
 	struct tcmu_dev *udev;
 	loff_t off;
 	uint32_t start, end, block;
-	struct page *page;
-	int i;
 
 	while (!kthread_should_stop()) {
 		DEFINE_WAIT(__wait);
@@ -2025,13 +2023,7 @@ static int unmap_thread_fn(void *data)
 			unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
 
 			/* Release the block pages */
-			for (i = start; i < end; i++) {
-				page = radix_tree_delete(&udev->data_blocks, i);
-				if (page) {
-					__free_page(page);
-					atomic_dec(&global_db_count);
-				}
-			}
+			tcmu_blocks_release(&udev->data_blocks, start, end);
 			mutex_unlock(&udev->cmdr_lock);
 		}
 
-- 
1.8.3.1
