From: David Dillow <dillowda@ornl.gov>
Subject: [PATCH 06/11] IB/srp: send disconnect request without waiting for CM timewait exit
Date: Sun, 25 Nov 2012 23:44:11 -0500
Message-ID: <9884c854d4972f9d16869b1d9f1a3213c87c7ca8.1353903448.git.dillowda@ornl.gov>
References: <cover.1353903448.git.dillowda@ornl.gov>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from matrix.voodoobox.net ([75.127.97.206]:38059 "EHLO
	matrix.voodoobox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754208Ab2KZEzK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Nov 2012 23:55:10 -0500
In-Reply-To: <cover.1353903448.git.dillowda@ornl.gov>
In-Reply-To: <cover.1353903448.git.dillowda@ornl.gov>
References: <cover.1353903448.git.dillowda@ornl.gov>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Vu Pham <vu@mellanox.com>, bvanassche@acm.org, roland@purestorage.com

From: Vu Pham <vu@mellanox.com>

From: Vu Pham <vu@mellanox.com>

Now that SRP recreates the CM id, QP, and CQ for each connection,
there is no need to wait for the timewait state to complete.

Signed-off-by: Vu Pham <vu@mellanox.com>
Signed-off-by: David Dillow <dillowda@ornl.gov>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a481727..c0cc245 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -479,13 +479,11 @@ static void srp_disconnect_target(struct srp_target_port *target)
 
 	/* XXX should send SRP_I_LOGOUT request */
 
-	init_completion(&target->done);
 	if (ib_send_cm_dreq(target->cm_id, NULL, 0)) {
 		shost_printk(KERN_DEBUG, target->scsi_host,
 			     PFX "Sending CM DREQ failed\n");
 		return;
 	}
-	wait_for_completion(&target->done);
 }
 
 static void srp_free_req_data(struct srp_target_port *target)
@@ -1658,7 +1656,6 @@ static int srp_cm_handler(struct ib_cm_id *cm_id, struct ib_cm_event *event)
 		shost_printk(KERN_ERR, target->scsi_host,
 			     PFX "connection closed\n");
 
-		comp = 1;
 		target->status = 0;
 		break;
 
-- 
1.7.7.6

