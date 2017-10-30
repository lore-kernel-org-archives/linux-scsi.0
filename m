From: Mike Christie <mchristi@redhat.com>
Subject: [PATCH 01/19] tcmu: fix crash when removing the tcmu device v4
Date: Sun, 29 Oct 2017 22:44:21 -0500
Message-ID: <1509335079-5276-2-git-send-email-mchristi@redhat.com>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43098 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752055AbdJ3Don (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Oct 2017 23:44:43 -0400
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Xiubo Li <lixiubo@cmss.chinamobile.com>, Zhang Zhuoyu <zhangzhuoyu@cmss.chinamobile.com>, Mike Christie <mchristi@redhat.com>

From: Xiubo Li <lixiubo@cmss.chinamobile.com>

Before the nl REMOVE msg has been sent to the userspace, the ring's
and other resources have been released, but the userspace maybe still
using them. And then we can see the crash messages like:

ring broken, not handling completions
BUG: unable to handle kernel paging request at ffffffffffffffd0
IP: tcmu_handle_completions+0x134/0x2f0 [target_core_user]
PGD 11bdc0c067
P4D 11bdc0c067
PUD 11bdc0e067
PMD 0

Oops: 0000 [#1] SMP
cmd_id not found, ring is broken
RIP: 0010:tcmu_handle_completions+0x134/0x2f0 [target_core_user]
RSP: 0018:ffffb8a2d8983d88 EFLAGS: 00010296
RAX: 0000000000000000 RBX: ffffb8a2aaa4e000 RCX: 00000000ffffffff
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000220
R10: 0000000076c71401 R11: ffff8d2e76c713f0 R12: ffffb8a2aad56bc0
R13: 000000000000001c R14: ffff8d2e32c90000 R15: ffff8d2e76c713f0
FS:  00007f411ffff700(0000) GS:ffff8d1e7fdc0000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffffffffffffffd0 CR3: 0000001027070000 CR4:
00000000001406e0
Call Trace:
? tcmu_irqcontrol+0x2a/0x40 [target_core_user]
? uio_write+0x7b/0xc0 [uio]
? __vfs_write+0x37/0x150
? __getnstimeofday64+0x3b/0xd0
? vfs_write+0xb2/0x1b0
? syscall_trace_enter+0x1d0/0x2b0
? SyS_write+0x55/0xc0
? do_syscall_64+0x67/0x150
? entry_SYSCALL64_slow_path+0x25/0x25
Code: 41 5d 41 5e 41 5f 5d c3 83 f8 01 0f 85 cf 01 00
00 48 8b 7d d0 e8 dd 5c 1d f3 41 0f b7 74 24 04 48 8b
7d c8 31 d2 e8 5c c7 1b f3 <48> 8b 7d d0 49 89 c7 c6 07
00 0f 1f 40 00 4d 85 ff 0f 84 82 01  RIP:
tcmu_handle_completions+0x134/0x2f0 [target_core_user]
RSP: ffffb8a2d8983d88
CR2: ffffffffffffffd0

And the crash also could happen in tcmu_page_fault and other places.

Signed-off-by: Zhang Zhuoyu <zhangzhuoyu@cmss.chinamobile.com>
Signed-off-by: Xiubo Li <lixiubo@cmss.chinamobile.com>
[ported to scsi branch]
Signed-off-by: Mike Christie <mchristi@redhat.com>

---
 drivers/target/target_core_user.c | 92 ++++++++++++++++++++-------------------
 1 file changed, 47 insertions(+), 45 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 942d0942..8b9ec0f 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1112,6 +1112,8 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	init_waitqueue_head(&udev->nl_cmd_wq);
 	spin_lock_init(&udev->nl_cmd_lock);
 
+	INIT_RADIX_TREE(&udev->data_blocks, GFP_KERNEL);
+
 	return &udev->se_dev;
 }
 
@@ -1280,10 +1282,54 @@ static void tcmu_dev_call_rcu(struct rcu_head *p)
 	kfree(udev);
 }
 
+static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
+{
+	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
+		kmem_cache_free(tcmu_cmd_cache, cmd);
+		return 0;
+	}
+	return -EINVAL;
+}
+
+static void tcmu_blocks_release(struct tcmu_dev *udev)
+{
+	int i;
+	struct page *page;
+
+	/* Try to release all block pages */
+	mutex_lock(&udev->cmdr_lock);
+	for (i = 0; i <= udev->dbi_max; i++) {
+		page = radix_tree_delete(&udev->data_blocks, i);
+		if (page) {
+			__free_page(page);
+			atomic_dec(&global_db_count);
+		}
+	}
+	mutex_unlock(&udev->cmdr_lock);
+}
+
 static void tcmu_dev_kref_release(struct kref *kref)
 {
 	struct tcmu_dev *udev = container_of(kref, struct tcmu_dev, kref);
 	struct se_device *dev = &udev->se_dev;
+	struct tcmu_cmd *cmd;
+	bool all_expired = true;
+	int i;
+
+	vfree(udev->mb_addr);
+	udev->mb_addr = NULL;
+
+	/* Upper layer should drain all requests before calling this */
+	spin_lock_irq(&udev->commands_lock);
+	idr_for_each_entry(&udev->commands, cmd, i) {
+		if (tcmu_check_and_free_pending_cmd(cmd) != 0)
+			all_expired = false;
+	}
+	idr_destroy(&udev->commands);
+	spin_unlock_irq(&udev->commands_lock);
+	WARN_ON(!all_expired);
+
+	tcmu_blocks_release(udev);
 
 	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
 }
@@ -1476,8 +1522,6 @@ static int tcmu_configure_device(struct se_device *dev)
 	WARN_ON(udev->data_size % PAGE_SIZE);
 	WARN_ON(udev->data_size % DATA_BLOCK_SIZE);
 
-	INIT_RADIX_TREE(&udev->data_blocks, GFP_KERNEL);
-
 	info->version = __stringify(TCMU_MAILBOX_VERSION);
 
 	info->mem[0].name = "tcm-user command & data buffer";
@@ -1527,6 +1571,7 @@ static int tcmu_configure_device(struct se_device *dev)
 	uio_unregister_device(&udev->uio_info);
 err_register:
 	vfree(udev->mb_addr);
+	udev->mb_addr = NULL;
 err_vzalloc:
 	kfree(info->name);
 	info->name = NULL;
@@ -1534,37 +1579,11 @@ static int tcmu_configure_device(struct se_device *dev)
 	return ret;
 }
 
-static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
-{
-	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
-		kmem_cache_free(tcmu_cmd_cache, cmd);
-		return 0;
-	}
-	return -EINVAL;
-}
-
 static bool tcmu_dev_configured(struct tcmu_dev *udev)
 {
 	return udev->uio_info.uio_dev ? true : false;
 }
 
-static void tcmu_blocks_release(struct tcmu_dev *udev)
-{
-	int i;
-	struct page *page;
-
-	/* Try to release all block pages */
-	mutex_lock(&udev->cmdr_lock);
-	for (i = 0; i <= udev->dbi_max; i++) {
-		page = radix_tree_delete(&udev->data_blocks, i);
-		if (page) {
-			__free_page(page);
-			atomic_dec(&global_db_count);
-		}
-	}
-	mutex_unlock(&udev->cmdr_lock);
-}
-
 static void tcmu_free_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
@@ -1576,9 +1595,6 @@ static void tcmu_free_device(struct se_device *dev)
 static void tcmu_destroy_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-	struct tcmu_cmd *cmd;
-	bool all_expired = true;
-	int i;
 
 	del_timer_sync(&udev->timeout);
 
@@ -1586,20 +1602,6 @@ static void tcmu_destroy_device(struct se_device *dev)
 	list_del(&udev->node);
 	mutex_unlock(&root_udev_mutex);
 
-	vfree(udev->mb_addr);
-
-	/* Upper layer should drain all requests before calling this */
-	spin_lock_irq(&udev->commands_lock);
-	idr_for_each_entry(&udev->commands, cmd, i) {
-		if (tcmu_check_and_free_pending_cmd(cmd) != 0)
-			all_expired = false;
-	}
-	idr_destroy(&udev->commands);
-	spin_unlock_irq(&udev->commands_lock);
-	WARN_ON(!all_expired);
-
-	tcmu_blocks_release(udev);
-
 	tcmu_netlink_event(udev, TCMU_CMD_REMOVED_DEVICE, 0, NULL);
 
 	uio_unregister_device(&udev->uio_info);
-- 
1.8.3.1
