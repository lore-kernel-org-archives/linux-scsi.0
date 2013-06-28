From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 12/15] IB/srp: Fail SCSI commands silently
Date: Fri, 28 Jun 2013 14:56:50 +0200
Message-ID: <51CD8812.20107@acm.org>
References: <51CD856A.3010102@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:55782 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3F1M4w (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jun 2013 08:56:52 -0400
In-Reply-To: <51CD856A.3010102@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: David Dillow <dave@thedillows.org>, Vu Pham <vuhuong@mellanox.com>, Sebastian Riemer <sebastian.riemer@profitbricks.com>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

From: Sebastian Riemer <sebastian.riemer@profitbricks.com>

Avoid that path failover in a multipath setup causes the SCSI layer
to generate kernel messages about SCSI command failures. This patch
speeds up SRP initiator operation significantly when monitoring
kernel messages over a serial port.

[bvanassche: Changed patch description]
Signed-off-by: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@purestorage.com>
Cc: David Dillow <dillowda@ornl.gov>
Cc: Vu Pham <vu@mellanox.com>
---
 drivers/infiniband/ulp/srp/ib_srp.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index a8cc427..e77176e 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -757,6 +757,7 @@ static void srp_finish_req(struct srp_target_port *target,
 
 	if (scmnd) {
 		srp_free_req(target, req, scmnd, 0);
+		scmnd->request->cmd_flags |= REQ_QUIET;
 		scmnd->result = result;
 		scmnd->scsi_done(scmnd);
 	}
@@ -1438,6 +1439,7 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 
 	result = srp_chkready(target->rport);
 	if (unlikely(result)) {
+		scmnd->request->cmd_flags |= REQ_QUIET;
 		scmnd->result = result;
 		scmnd->scsi_done(scmnd);
 		return 0;
@@ -1843,6 +1845,7 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 	else
 		ret = FAILED;
 	srp_free_req(target, req, scmnd, 0);
+	scmnd->request->cmd_flags |= REQ_QUIET;
 	scmnd->result = DID_ABORT << 16;
 	scmnd->scsi_done(scmnd);
 
-- 
1.7.10.4

