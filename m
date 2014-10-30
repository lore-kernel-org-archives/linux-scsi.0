From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 04/11] IB/srp: Move ib_destroy_cm_id() call into srp_free_ch_ib()
Date: Thu, 30 Oct 2014 14:46:27 +0100
Message-ID: <54524133.2060604@acm.org>
References: <545240AE.6060009@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from andre.telenet-ops.be ([195.130.132.53]:52385 "EHLO
	andre.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760088AbaJ3Nq2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 09:46:28 -0400
In-Reply-To: <545240AE.6060009@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

The patch that adds multichannel support into the SRP initiator
driver introduces an additional call to srp_free_ch_ib(). This
patch helps to keep that later patch simple.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Cc: Sebastian Parschauer <sebastian.riemer@profitbricks.com>
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

