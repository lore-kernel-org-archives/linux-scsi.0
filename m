From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [RFC 2/8] IB/srp: consolidate state change code
Date: Thu, 23 Dec 2010 16:31:27 -0500
Message-ID: <1293139893-11678-3-git-send-email-dillowda@ornl.gov>
References: <1293139893-11678-1-git-send-email-dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1293139893-11678-1-git-send-email-dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This is a break-out and slight cleanup of Bart Van Assche's work.
---
 drivers/infiniband/ulp/srp/ib_srp.c |   45 ++++++++++++++++++----------------
 1 files changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 95fb9f0..a14975b 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -441,18 +441,28 @@ static void srp_disconnect_target(struct srp_target_port *target)
 	wait_for_completion(&target->done);
 }
 
+static bool srp_change_state(struct srp_target_port *target,
+			    enum srp_target_state old,
+			    enum srp_target_state new)
+{
+	int changed = false;
+
+	spin_lock_irq(target->scsi_host->host_lock);
+	if (target->state == old) {
+		target->state = new;
+		changed = true;
+	}
+	spin_unlock_irq(target->scsi_host->host_lock);
+	return changed;
+}
+
 static void srp_remove_work(struct work_struct *work)
 {
 	struct srp_target_port *target =
 		container_of(work, struct srp_target_port, work);
 
-	spin_lock_irq(target->scsi_host->host_lock);
-	if (target->state != SRP_TARGET_DEAD) {
-		spin_unlock_irq(target->scsi_host->host_lock);
+	if (!srp_change_state(target, SRP_TARGET_DEAD, SRP_TARGET_REMOVED))
 		return;
-	}
-	target->state = SRP_TARGET_REMOVED;
-	spin_unlock_irq(target->scsi_host->host_lock);
 
 	spin_lock(&target->srp_host->target_lock);
 	list_del(&target->list);
@@ -560,13 +570,8 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	struct ib_wc wc;
 	int ret;
 
-	spin_lock_irq(target->scsi_host->host_lock);
-	if (target->state != SRP_TARGET_LIVE) {
-		spin_unlock_irq(target->scsi_host->host_lock);
+	if (!srp_change_state(target, SRP_TARGET_LIVE, SRP_TARGET_CONNECTING))
 		return -EAGAIN;
-	}
-	target->state = SRP_TARGET_CONNECTING;
-	spin_unlock_irq(target->scsi_host->host_lock);
 
 	srp_disconnect_target(target);
 	/*
@@ -605,13 +610,8 @@ static int srp_reconnect_target(struct srp_target_port *target)
 	if (ret)
 		goto err;
 
-	spin_lock_irq(target->scsi_host->host_lock);
-	if (target->state == SRP_TARGET_CONNECTING) {
-		ret = 0;
-		target->state = SRP_TARGET_LIVE;
-	} else
+	if (!srp_change_state(target, SRP_TARGET_CONNECTING, SRP_TARGET_LIVE))
 		ret = -EAGAIN;
-	spin_unlock_irq(target->scsi_host->host_lock);
 
 	return ret;
 
@@ -621,9 +621,12 @@ err:
 
 	/*
 	 * We couldn't reconnect, so kill our target port off.
-	 * However, we have to defer the real removal because we might
-	 * be in the context of the SCSI error handler now, which
-	 * would deadlock if we call scsi_remove_host().
+	 * However, we have to defer the real removal because we
+	 * are in the context of the SCSI error handler now, which
+	 * will deadlock if we call scsi_remove_host().
+	 *
+	 * Schedule our work inside the lock to avoid a race with
+	 * the flush_scheduled_work() in srp_remove_one().
 	 */
 	spin_lock_irq(target->scsi_host->host_lock);
 	if (target->state == SRP_TARGET_CONNECTING) {
-- 
1.7.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
