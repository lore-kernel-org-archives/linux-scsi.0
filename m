From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 09/19] tcmu: remove commands_lock
Date: Sun, 29 Oct 2017 22:44:29 -0500
Message-ID: <1509335079-5276-10-git-send-email-mchristi@redhat.com>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Sender: target-devel-owner@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Mike Christie <mchristi@redhat.com>
List-Id: linux-scsi@vger.kernel.org

No need for the commands_lock. The cmdr_lock is already held during
idr addition and deletion, so just grab it during traversal.

Note: This also fixes a issue where we should have been using at
least _bh locking in tcmu_handle_completions when taking the commands
lock to prevent the case where tcmu_handle_completions could be
interrupted by a timer softirq while the commands_lock is held.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 7271ec2..5226b82 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -139,7 +139,6 @@ struct tcmu_dev {
 	struct radix_tree_root data_blocks;
 
 	struct idr commands;
-	spinlock_t commands_lock;
 
 	struct timer_list timeout;
 	unsigned int cmd_time_out;
@@ -1012,10 +1011,7 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 		}
 		WARN_ON(tcmu_hdr_get_op(entry->hdr.len_op) != TCMU_OP_CMD);
 
-		spin_lock(&udev->commands_lock);
 		cmd = idr_remove(&udev->commands, entry->hdr.cmd_id);
-		spin_unlock(&udev->commands_lock);
-
 		if (!cmd) {
 			pr_err("cmd_id not found, ring is broken\n");
 			set_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
@@ -1113,7 +1109,6 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 
 	INIT_LIST_HEAD(&udev->timedout_entry);
 	idr_init(&udev->commands);
-	spin_lock_init(&udev->commands_lock);
 
 	setup_timer(&udev->timeout, tcmu_device_timedout,
 		(unsigned long)udev);
@@ -1332,16 +1327,14 @@ static void tcmu_dev_kref_release(struct kref *kref)
 	spin_unlock_bh(&timed_out_udevs_lock);
 
 	/* Upper layer should drain all requests before calling this */
-	spin_lock_irq(&udev->commands_lock);
+	mutex_lock(&udev->cmdr_lock);
 	idr_for_each_entry(&udev->commands, cmd, i) {
 		if (tcmu_check_and_free_pending_cmd(cmd) != 0)
 			all_expired = false;
 	}
 	idr_destroy(&udev->commands);
-	spin_unlock_irq(&udev->commands_lock);
 	WARN_ON(!all_expired);
 
-	mutex_lock(&udev->cmdr_lock);
 	tcmu_blocks_release(&udev->data_blocks, 0, udev->dbi_max + 1);
 	mutex_unlock(&udev->cmdr_lock);
 
@@ -2058,9 +2051,9 @@ static void check_timedout_devices(void)
 		list_del_init(&udev->timedout_entry);
 		spin_unlock_bh(&timed_out_udevs_lock);
 
-		spin_lock(&udev->commands_lock);
+		mutex_lock(&udev->cmdr_lock);
 		idr_for_each(&udev->commands, tcmu_check_expired_cmd, NULL);
-		spin_unlock(&udev->commands_lock);
+		mutex_unlock(&udev->cmdr_lock);
 
 		spin_lock_bh(&timed_out_udevs_lock);
 	}
-- 
1.8.3.1
