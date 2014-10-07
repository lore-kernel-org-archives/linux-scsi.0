From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH v2 06/12] IB/srp: Remove stale connection retry mechanism
Date: Tue, 07 Oct 2014 15:04:43 +0200
Message-ID: <5433E4EB.1090506@acm.org>
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

Attempting to connect three times may be insufficient after an
initiator system tries to relogin, especially if the relogin
attempt occurs before the SRP target service ID has been
registered. Since the srp_daemon retries a failed login attempt
anyway, remove the stale connection retry mechanism.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index d3c712f..9608e7a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -904,7 +904,6 @@ static void srp_rport_delete(struct srp_rport *rport)
 
 static int srp_connect_target(struct srp_target_port *target)
 {
-	int retries = 3;
 	int ret;
 
 	WARN_ON_ONCE(target->connected);
@@ -945,19 +944,10 @@ static int srp_connect_target(struct srp_target_port *target)
 			break;
 
 		case SRP_STALE_CONN:
-			/* Our current CM id was stale, and is now in timewait.
-			 * Try to reconnect with a new one.
-			 */
-			if (!retries-- || srp_new_cm_id(target)) {
-				shost_printk(KERN_ERR, target->scsi_host, PFX
-					     "giving up on stale connection\n");
-				target->status = -ECONNRESET;
-				return target->status;
-			}
-
 			shost_printk(KERN_ERR, target->scsi_host, PFX
-				     "retrying stale connection\n");
-			break;
+				     "giving up on stale connection\n");
+			target->status = -ECONNRESET;
+			return target->status;
 
 		default:
 			return target->status;
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
