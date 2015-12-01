From: Ken Xue <ken.xue@amd.com>
Subject: [PATCH 2/2] SCSI: Fix NULL pointer dereference in runtime PM
Date: Tue, 1 Dec 2015 14:45:46 +0800
Message-ID: <1448952346.3603.18.camel@kxue-X58A-UD3R>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, stable@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Xiangliang.Yu@amd.com, stern@rowland.harvard.edu, JBottomley@Odin.com, SPG_Linux_Kernel@amd.com, axboe@kernel.dk, michael.terry@canonical.com
List-Id: linux-scsi@vger.kernel.org

The routines in scsi_pm.c assume that if a runtime-PM callback is
invoked for a SCSI device, it can only mean that the device's driver
has asked the block layer to handle the runtime power management (by
calling blk_pm_runtime_init(), which among other things sets q->dev).

However, this assumption turns out to be wrong for things like the ses
driver.  Normally ses devices are not allowed to do runtime PM, but
userspace can override this setting.  If this happens, the kernel gets
a NULL pointer dereference when blk_post_runtime_resume() tries to use
the uninitialized q->dev pointer.

This patch fixes the problem by checking q->dev in block layer before
handle runtime PM. Since ses doesn't define any PM callbacks and call
blk_pm_runtime_init(), the crash won't occur.

This fixes Bugzilla #101371.
https://bugzilla.kernel.org/show_bug.cgi?id=101371

More discussion can be found from below link.
http://marc.info/?l=linux-scsi&m=144163730531875&w=2

Signed-off-by: Ken Xue <Ken.Xue@amd.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: Xiangliang Yu <Xiangliang.Yu@amd.com>
Cc: James E.J. Bottomley <JBottomley@odin.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Michael Terry <Michael.terry@canonical.com>
Cc: stable@vger.kernel.org

---
 block/blk-core.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 60912e9..a07ab18 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -3280,6 +3280,9 @@ int blk_pre_runtime_suspend(struct request_queue *q)
 {
 	int ret = 0;
 
+	if (!q->dev)
+		return ret;
+
 	spin_lock_irq(q->queue_lock);
 	if (q->nr_pending) {
 		ret = -EBUSY;
@@ -3307,6 +3310,9 @@ EXPORT_SYMBOL(blk_pre_runtime_suspend);
  */
 void blk_post_runtime_suspend(struct request_queue *q, int err)
 {
+	if (!q->dev)
+		return;
+
 	spin_lock_irq(q->queue_lock);
 	if (!err) {
 		q->rpm_status = RPM_SUSPENDED;
@@ -3331,6 +3337,9 @@ EXPORT_SYMBOL(blk_post_runtime_suspend);
  */
 void blk_pre_runtime_resume(struct request_queue *q)
 {
+	if (!q->dev)
+		return;
+
 	spin_lock_irq(q->queue_lock);
 	q->rpm_status = RPM_RESUMING;
 	spin_unlock_irq(q->queue_lock);
@@ -3353,6 +3362,9 @@ EXPORT_SYMBOL(blk_pre_runtime_resume);
  */
 void blk_post_runtime_resume(struct request_queue *q, int err)
 {
+	if (!q->dev)
+		return;
+
 	spin_lock_irq(q->queue_lock);
 	if (!err) {
 		q->rpm_status = RPM_ACTIVE;
-- 
1.9.1
