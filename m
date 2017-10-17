From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v10 03/10] md: Neither resync nor reshape while the system is frozen
Date: Tue, 17 Oct 2017 16:26:23 -0700
Message-ID: <20171017232630.4264-4-bart.vanassche@wdc.com>
References: <20171017232630.4264-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:47593 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761434AbdJQX0c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2017 19:26:32 -0400
In-Reply-To: <20171017232630.4264-1-bart.vanassche@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, linux-raid@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>

Some people use the md driver on laptops and use the suspend and
resume functionality. Since it is essential that submitting of
new I/O requests stops before a hibernation image is created,
interrupt the md resync and reshape actions if the system is
being frozen. Note: the resync and reshape will restart after
the system is resumed and a message similar to the following
will appear in the system log:

md: md0: data-check interrupted.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Shaohua Li <shli@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Tested-by: Martin Steigerwald <martin@lichtvoll.de>
Cc: linux-raid@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/md/md.c | 50 +++++++++++++++++++++++++++++++++++++++++++++++++-
 drivers/md/md.h |  8 ++++++++
 2 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b99584e5d6b1..8b2fc750f97f 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -66,6 +66,8 @@
 #include <linux/raid/md_u.h>
 #include <linux/slab.h>
 #include <linux/percpu-refcount.h>
+#include <linux/freezer.h>
+#include <linux/suspend.h>
 
 #include <trace/events/block.h>
 #include "md.h"
@@ -7439,6 +7441,7 @@ static int md_thread(void *arg)
 	 */
 
 	allow_signal(SIGKILL);
+	set_freezable();
 	while (!kthread_should_stop()) {
 
 		/* We need to wait INTERRUPTIBLE so that
@@ -7449,7 +7452,7 @@ static int md_thread(void *arg)
 		if (signal_pending(current))
 			flush_signals(current);
 
-		wait_event_interruptible_timeout
+		wait_event_freezable_timeout
 			(thread->wqueue,
 			 test_bit(THREAD_WAKEUP, &thread->flags)
 			 || kthread_should_stop() || kthread_should_park(),
@@ -8944,6 +8947,8 @@ static void md_stop_all_writes(void)
 	int need_delay = 0;
 
 	for_each_mddev(mddev, tmp) {
+		mddev->frozen_before_suspend =
+			test_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		if (mddev_trylock(mddev)) {
 			if (mddev->pers)
 				__md_stop_writes(mddev);
@@ -8963,6 +8968,47 @@ static void md_stop_all_writes(void)
 		mdelay(1000*1);
 }
 
+static void md_restore_frozen_flag(void)
+{
+	struct list_head *tmp;
+	struct mddev *mddev;
+
+	for_each_mddev(mddev, tmp) {
+		if (mddev->frozen_before_suspend)
+			set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+		else
+			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+	}
+}
+
+/*
+ * Ensure that neither resyncing nor reshaping occurs while the system is
+ * frozen.
+ */
+static int md_notify_pm(struct notifier_block *bl, unsigned long state,
+			void *unused)
+{
+	pr_debug("%s: state = %ld\n", __func__, state);
+
+	switch (state) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+	case PM_RESTORE_PREPARE:
+		md_stop_all_writes();
+		break;
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
+	case PM_POST_RESTORE:
+		md_restore_frozen_flag();
+		break;
+	}
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block md_pm_notifier = {
+	.notifier_call	= md_notify_pm,
+};
+
 static int md_notify_reboot(struct notifier_block *this,
 			    unsigned long code, void *x)
 {
@@ -9009,6 +9055,7 @@ static int __init md_init(void)
 			    md_probe, NULL, NULL);
 
 	register_reboot_notifier(&md_reboot_notifier);
+	register_pm_notifier(&md_pm_notifier);
 	raid_table_header = register_sysctl_table(raid_root_table);
 
 	md_geninit();
@@ -9248,6 +9295,7 @@ static __exit void md_exit(void)
 
 	unregister_blkdev(MD_MAJOR,"md");
 	unregister_blkdev(mdp_major, "mdp");
+	unregister_pm_notifier(&md_pm_notifier);
 	unregister_reboot_notifier(&md_reboot_notifier);
 	unregister_sysctl_table(raid_table_header);
 
diff --git a/drivers/md/md.h b/drivers/md/md.h
index d8287d3cd1bf..727b3aef4d26 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -356,6 +356,14 @@ struct mddev {
 	 */
 	int				recovery_disabled;
 
+	/* Writes are stopped before hibernation, suspend and restore by
+	 * calling md_stop_all_writes(). That function sets the
+	 * MD_RECOVERY_FROZEN flag. The value of that flag is saved before
+	 * writes are stopped such that it can be restored after hibernation,
+	 * suspend or restore have finished.
+	 */
+	bool				frozen_before_suspend;
+
 	int				in_sync;	/* know to not need resync */
 	/* 'open_mutex' avoids races between 'md_open' and 'do_md_stop', so
 	 * that we are never stopping an array while it is open.
-- 
2.14.2
