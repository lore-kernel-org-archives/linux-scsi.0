From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 1/3] scsi_transport_srp: Block rport upon TL error even with
 fast_io_fail_tmo = off
Date: Wed, 11 Dec 2013 17:05:22 +0100
Message-ID: <52A88D42.9060201@acm.org>
References: <52A88CF9.206@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.66]:60798 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab3LKQF0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2013 11:05:26 -0500
In-Reply-To: <52A88CF9.206@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Dillow <dillowda@ornl.gov>
Cc: Vu Pham <vu@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, James Bottomley <JBottomley@Parallels.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

The current behavior of the SRP transport layer when a transport
layer error is encountered is to block SCSI command processing only
if fast_io_fail_tmo != off. The current behavior of the FC transport
layer when a transport layer error is encountered is to block SCSI
command processing no matter which value fast_io_fail_tmo has been
set to. Make the behavior of the SRP transport layer consistent with
that of the FC transport layer to avoid confusion.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: David Dillow <dillowda@ornl.gov>
Cc: Vu Pham <vu@mellanox.com>
Cc: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: James Bottomley <JBottomley@Parallels.com>
---
 drivers/scsi/scsi_transport_srp.c | 30 +++++++++++++++++-------------
 1 file changed, 17 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_transport_srp.c b/drivers/scsi/scsi_transport_srp.c
index 2700a5a..8b9cb22 100644
--- a/drivers/scsi/scsi_transport_srp.c
+++ b/drivers/scsi/scsi_transport_srp.c
@@ -67,7 +67,8 @@ static inline struct Scsi_Host *rport_to_shost(struct srp_rport *r)
  *
  * The combination of the timeout parameters must be such that SCSI commands
  * are finished in a reasonable time. Hence do not allow the fast I/O fail
- * timeout to exceed SCSI_DEVICE_BLOCK_MAX_TIMEOUT. Furthermore, these
+ * timeout to exceed SCSI_DEVICE_BLOCK_MAX_TIMEOUT nor allow dev_loss_tmo to
+ * exceed that limit if failing I/O fast has been disabled. Furthermore, these
  * parameters must be such that multipath can detect failed paths timely.
  * Hence do not allow all three parameters to be disabled simultaneously.
  */
@@ -79,6 +80,9 @@ int srp_tmo_valid(int reconnect_delay, int fast_io_fail_tmo, int dev_loss_tmo)
 		return -EINVAL;
 	if (fast_io_fail_tmo > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
 		return -EINVAL;
+	if (fast_io_fail_tmo < 0 &&
+	    dev_loss_tmo > SCSI_DEVICE_BLOCK_MAX_TIMEOUT)
+		return -EINVAL;
 	if (dev_loss_tmo >= LONG_MAX / HZ)
 		return -EINVAL;
 	if (fast_io_fail_tmo >= 0 && dev_loss_tmo >= 0 &&
@@ -463,20 +467,20 @@ static void __srp_start_tl_fail_timers(struct srp_rport *rport)
 			queue_delayed_work(system_long_wq,
 					   &rport->reconnect_work,
 					   1UL * delay * HZ);
-		if (fast_io_fail_tmo >= 0 &&
-		    srp_rport_set_state(rport, SRP_RPORT_BLOCKED) == 0) {
+		if (srp_rport_set_state(rport, SRP_RPORT_BLOCKED) == 0) {
 			pr_debug("%s new state: %d\n",
 				 dev_name(&shost->shost_gendev),
 				 rport->state);
 			scsi_target_block(&shost->shost_gendev);
-			queue_delayed_work(system_long_wq,
-					   &rport->fast_io_fail_work,
-					   1UL * fast_io_fail_tmo * HZ);
+			if (fast_io_fail_tmo >= 0)
+				queue_delayed_work(system_long_wq,
+						   &rport->fast_io_fail_work,
+						   1UL * fast_io_fail_tmo * HZ);
+			if (dev_loss_tmo >= 0)
+				queue_delayed_work(system_long_wq,
+						   &rport->dev_loss_work,
+						   1UL * dev_loss_tmo * HZ);
 		}
-		if (dev_loss_tmo >= 0)
-			queue_delayed_work(system_long_wq,
-					   &rport->dev_loss_work,
-					   1UL * dev_loss_tmo * HZ);
 	} else {
 		pr_debug("%s has already been deleted\n",
 			 dev_name(&shost->shost_gendev));
@@ -578,9 +582,9 @@ int srp_reconnect_rport(struct srp_rport *rport)
 		spin_unlock_irq(shost->host_lock);
 	} else if (rport->state == SRP_RPORT_RUNNING) {
 		/*
-		 * srp_reconnect_rport() was invoked with fast_io_fail
-		 * off. Mark the port as failed and start the TL failure
-		 * timers if these had not yet been started.
+		 * srp_reconnect_rport() has been invoked with fast_io_fail
+		 * and dev_loss off. Mark the port as failed and start the TL
+		 * failure timers if these had not yet been started.
 		 */
 		__rport_fail_io_fast(rport);
 		scsi_target_unblock(&shost->shost_gendev,
-- 
1.8.1.4

