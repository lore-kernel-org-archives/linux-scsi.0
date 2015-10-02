From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] SCSI: Fix hard lockup in scsi_remove_target()
Date: Fri,  2 Oct 2015 10:21:02 +0200
Message-ID: <1443774062-15638-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Removing a SCSI target via scsi_remove_target() suspected to be racy. When a
sibling get's removed from the list it can occassionly happen that one CPU is
stuck endlessly looping around this code block

list_for_each_entry(starget, &shost->__targets, siblings) {
        if (starget->state == STARGET_DEL)
                continue;

Resulting in the following hard lockup.

Kernel panic - not syncing: Watchdog detected hard LOCKUP on cpu 0
[...]
Call Trace:
 [<ffffffff8100471d>] dump_trace+0x7d/0x2d0
 [<ffffffff81004a04>] show_stack_log_lvl+0x94/0x170
 [<ffffffff81005cc1>] show_stack+0x21/0x50
 [<ffffffff8151aa75>] dump_stack+0x41/0x51
 [<ffffffff8151545a>] panic+0xc8/0x1d7
 [<ffffffff810fbdda>] watchdog_overflow_callback+0xba/0xc0
 [<ffffffff811336c8>] __perf_event_overflow+0x88/0x240
 [<ffffffff8101e3aa>] intel_pmu_handle_irq+0x1fa/0x3e0
 [<ffffffff81522836>] perf_event_nmi_handler+0x26/0x40
 [<ffffffff81521fcd>] nmi_handle.isra.2+0x8d/0x180
 [<ffffffff815221e6>] do_nmi+0x126/0x3c0
 [<ffffffff8152159b>] end_repeat_nmi+0x1a/0x1e
 [<ffffffffa00212e8>] scsi_remove_target+0x68/0x240 [scsi_mod]
 [<ffffffff81072742>] process_one_work+0x172/0x420
 [<ffffffff810733ba>] worker_thread+0x11a/0x3c0
 [<ffffffff81079d34>] kthread+0xb4/0xc0
 [<ffffffff81528cd8>] ret_from_fork+0x58/0x90

This patch decouples the list traversal for targets and the reaping of SCSI
targets by moving to be removed targets to a separate reap list. Entries in
this list can then be removed by the SCSI layer in a lockless manner.

This was discovered by a partner in a 24h stress test.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_sysfs.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index b333389..5d92cf56 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -1158,31 +1158,31 @@ static void __scsi_remove_target(struct scsi_target *starget)
 void scsi_remove_target(struct device *dev)
 {
 	struct Scsi_Host *shost = dev_to_shost(dev->parent);
-	struct scsi_target *starget, *last = NULL;
+	struct scsi_target *starget, *tmp;
 	unsigned long flags;
+	LIST_HEAD(reap_list);
 
 	/* remove targets being careful to lookup next entry before
 	 * deleting the last
 	 */
 	spin_lock_irqsave(shost->host_lock, flags);
-	list_for_each_entry(starget, &shost->__targets, siblings) {
+	list_for_each_entry_safe(starget, tmp, &shost->__targets, siblings) {
 		if (starget->state == STARGET_DEL)
 			continue;
 		if (starget->dev.parent == dev || &starget->dev == dev) {
 			/* assuming new targets arrive at the end */
 			kref_get(&starget->reap_ref);
 			spin_unlock_irqrestore(shost->host_lock, flags);
-			if (last)
-				scsi_target_reap(last);
-			last = starget;
+
 			__scsi_remove_target(starget);
+			list_move_tail(&starget->siblings, &reap_list);
 			spin_lock_irqsave(shost->host_lock, flags);
 		}
 	}
 	spin_unlock_irqrestore(shost->host_lock, flags);
 
-	if (last)
-		scsi_target_reap(last);
+	list_for_each_entry_safe(starget, tmp, &reap_list, siblings)
+		scsi_target_reap(starget);
 }
 EXPORT_SYMBOL(scsi_remove_target);
 
-- 
2.5.0
