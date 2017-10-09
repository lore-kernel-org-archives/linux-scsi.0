From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v7 3/9] md: Neither resync nor reshape while the system is frozen
Date: Mon,  9 Oct 2017 16:13:54 -0700
Message-ID: <20171009231400.562-4-bart.vanassche@wdc.com>
References: <20171009231400.562-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171009231400.562-1-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, =Oleksandr Natalenko <oleksandr@natalenko.name>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Some people use the md driver on laptops and use the suspend and
resume functionality. Since it is essential that submitting of
new I/O requests stops before a hibernation image is created,
interrupt the md resync and reshape actions if the system is
being frozen. Note: the resync and reshape will restart after
the system is resumed and a message similar to the following
will appear in the system log:

md: md0: data-check interrupted.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/md/md.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b99584e5d6b1..d712d3320c1d 100644
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
@@ -8963,6 +8966,29 @@ static void md_stop_all_writes(void)
 		mdelay(1000*1);
 }
 
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
@@ -9009,6 +9035,7 @@ static int __init md_init(void)
 			    md_probe, NULL, NULL);
 
 	register_reboot_notifier(&md_reboot_notifier);
+	register_pm_notifier(&md_pm_notifier);
 	raid_table_header = register_sysctl_table(raid_root_table);
 
 	md_geninit();
@@ -9248,6 +9275,7 @@ static __exit void md_exit(void)
 
 	unregister_blkdev(MD_MAJOR,"md");
 	unregister_blkdev(mdp_major, "mdp");
+	unregister_pm_notifier(&md_pm_notifier);
 	unregister_reboot_notifier(&md_reboot_notifier);
 	unregister_sysctl_table(raid_table_header);
 
-- 
2.14.2
