From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 05/12] IB/srp: Move ib_destroy_cm_id() call into srp_free_ch_ib()
Date: Tue, 07 Oct 2014 15:04:25 +0200
Message-ID: <5433E4D9.60500@acm.org>
References: <5433E43D.3010107@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5433E43D.3010107-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Robert Elliott <Elliott-VXdhtT5mjnY@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

The patch that adds multichannel support into the SRP initiator
driver introduces an additional call to srp_free_ch_ib(). This
patch helps to keep that later patch simple.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 62d2a18..d3c712f 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -555,6 +555,11 @@ static void srp_free_target_ib(struct srp_target_port *target)
 	struct srp_device *dev = target->srp_host->srp_dev;
 	int i;
 
+	if (target->cm_id) {
+		ib_destroy_cm_id(target->cm_id);
+		target->cm_id = NULL;
+	}
+
 	if (dev->use_fast_reg) {
 		if (target->fr_pool)
 			srp_destroy_fr_pool(target->fr_pool);
@@ -868,7 +873,6 @@ static void srp_remove_target(struct srp_target_port *target)
 	scsi_remove_host(target->scsi_host);
 	srp_stop_rport_timers(target->rport);
 	srp_disconnect_target(target);
-	ib_destroy_cm_id(target->cm_id);
 	srp_free_target_ib(target);
 	cancel_work_sync(&target->tl_err_work);
 	srp_rport_put(target->rport);
@@ -3043,7 +3047,7 @@ static ssize_t srp_create_target(struct device *dev,
 	if (ret) {
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "Connection failed\n");
-		goto err_cm_id;
+		goto err_free_ib;
 	}
 
 	ret = srp_add_target(host, target);
@@ -3067,9 +3071,6 @@ out:
 err_disconnect:
 	srp_disconnect_target(target);
 
-err_cm_id:
-	ib_destroy_cm_id(target->cm_id);
-
 err_free_ib:
 	srp_free_target_ib(target);
 
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
