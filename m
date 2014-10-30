From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 05/11] IB/srp: Remove stale connection retry mechanism
Date: Thu, 30 Oct 2014 14:46:55 +0100
Message-ID: <5452414F.2060303@acm.org>
References: <545240AE.6060009@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:52385 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759917AbaJ3Nq4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 09:46:56 -0400
In-Reply-To: <545240AE.6060009@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

Attempting to connect three times may be insufficient after an
initiator system tries to relogin, especially if the relogin
attempt occurs before the SRP target service ID has been
registered. Since the srp_daemon retries a failed login attempt
anyway, remove the stale connection retry mechanism.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
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

