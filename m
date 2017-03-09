From: Jan Kara <jack@suse.cz>
Subject: [PATCH 2/4] bdi: Fix use-after-free in wb_congested_put()
Date: Thu,  9 Mar 2017 11:16:22 +0100
Message-ID: <20170309101624.25901-3-jack@suse.cz>
References: <20170309101624.25901-1-jack@suse.cz>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51934 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753635AbdCIKQe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Mar 2017 05:16:34 -0500
In-Reply-To: <20170309101624.25901-1-jack@suse.cz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: Tejun Heo <tj@kernel.org>, linux-block@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Omar Sandoval <osandov@osandov.com>, Arthur Marsh <arthur.marsh@internode.on.net>, linux-scsi@vger.kernel.org, Jan Kara <jack@suse.cz>

bdi_writeback_congested structures get created for each blkcg and bdi
regardless whether bdi is registered or not. When they are created in
unregistered bdi and the request queue (and thus bdi) is then destroyed
while blkg still holds reference to bdi_writeback_congested structure,
this structure will be referencing freed bdi and last wb_congested_put()
will try to remove the structure from already freed bdi.

With commit 165a5e22fafb "block: Move bdi_unregister() to
del_gendisk()", SCSI started to destroy bdis without calling
bdi_unregister() first (previously it was calling bdi_unregister() even
for unregistered bdis) and thus the code detaching
bdi_writeback_congested in cgwb_bdi_destroy() was not triggered and we
started hitting this use-after-free bug. It is enough to boot a KVM
instance with virtio-scsi device to trigger this behavior.

Fix the problem by detaching bdi_writeback_congested structures in
bdi_exit() instead of bdi_unregister(). This is also more logical as
they can get attached to bdi regardless whether it ever got registered
or not.

Fixes: 165a5e22fafb127ecb5914e12e8c32a1f0d3f820
Tested-by: Omar Sandoval <osandov@fb.com>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 mm/backing-dev.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index 51325489aae5..b05ace3ba178 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -683,30 +683,18 @@ static int cgwb_bdi_init(struct backing_dev_info *bdi)
 static void cgwb_bdi_destroy(struct backing_dev_info *bdi)
 {
 	struct radix_tree_iter iter;
-	struct rb_node *rbn;
 	void **slot;
 
 	WARN_ON(test_bit(WB_registered, &bdi->wb.state));
 
 	spin_lock_irq(&cgwb_lock);
-
 	radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &iter, 0)
 		cgwb_kill(*slot);
-
-	while ((rbn = rb_first(&bdi->cgwb_congested_tree))) {
-		struct bdi_writeback_congested *congested =
-			rb_entry(rbn, struct bdi_writeback_congested, rb_node);
-
-		rb_erase(rbn, &bdi->cgwb_congested_tree);
-		congested->bdi = NULL;	/* mark @congested unlinked */
-	}
-
 	spin_unlock_irq(&cgwb_lock);
 
 	/*
-	 * All cgwb's and their congested states must be shutdown and
-	 * released before returning.  Drain the usage counter to wait for
-	 * all cgwb's and cgwb_congested's ever created on @bdi.
+	 * All cgwb's must be shutdown and released before returning.  Drain
+	 * the usage counter to wait for all cgwb's ever created on @bdi.
 	 */
 	atomic_dec(&bdi->usage_cnt);
 	wait_event(cgwb_release_wait, !atomic_read(&bdi->usage_cnt));
@@ -754,6 +742,21 @@ void wb_blkcg_offline(struct blkcg *blkcg)
 	spin_unlock_irq(&cgwb_lock);
 }
 
+static void cgwb_bdi_exit(struct backing_dev_info *bdi)
+{
+	struct rb_node *rbn;
+
+	spin_lock_irq(&cgwb_lock);
+	while ((rbn = rb_first(&bdi->cgwb_congested_tree))) {
+		struct bdi_writeback_congested *congested =
+			rb_entry(rbn, struct bdi_writeback_congested, rb_node);
+
+		rb_erase(rbn, &bdi->cgwb_congested_tree);
+		congested->bdi = NULL;	/* mark @congested unlinked */
+	}
+	spin_unlock_irq(&cgwb_lock);
+}
+
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
 static int cgwb_bdi_init(struct backing_dev_info *bdi)
@@ -774,7 +777,9 @@ static int cgwb_bdi_init(struct backing_dev_info *bdi)
 	return 0;
 }
 
-static void cgwb_bdi_destroy(struct backing_dev_info *bdi)
+static void cgwb_bdi_destroy(struct backing_dev_info *bdi) { }
+
+static void cgwb_bdi_exit(struct backing_dev_info *bdi)
 {
 	wb_congested_put(bdi->wb_congested);
 }
@@ -905,6 +910,7 @@ static void bdi_exit(struct backing_dev_info *bdi)
 {
 	WARN_ON_ONCE(bdi->dev);
 	wb_exit(&bdi->wb);
+	cgwb_bdi_exit(bdi);
 }
 
 static void release_bdi(struct kref *ref)
-- 
2.10.2
