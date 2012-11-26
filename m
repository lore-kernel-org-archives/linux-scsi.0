From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: [PATCH 03/11] IB/srp: don't send anything on a bad QP
Date: Sun, 25 Nov 2012 23:44:08 -0500
Message-ID: <90b21916a384281682d520302b594834e010671b.1353903448.git.dillowda@ornl.gov>
References: <cover.1353903448.git.dillowda@ornl.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1353903448.git.dillowda-1Heg1YXhbW8@public.gmane.org>
In-Reply-To: <cover.1353903448.git.dillowda-1Heg1YXhbW8@public.gmane.org>
References: <cover.1353903448.git.dillowda-1Heg1YXhbW8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bvanassche-HInyCGIudOg@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Once we know we have an issue with the QP, there is no point trying to
send anything else down the pipe. This also allows us to consolidate
code in the SCSI EH path.

Needs-to-be-signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
[ adapted to new state tracking code ]
Signed-off-by: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
---
 drivers/infiniband/ulp/srp/ib_srp.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 1e8ce81..2951e1c 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -1328,14 +1328,12 @@ static int srp_queuecommand(struct Scsi_Host *shost, struct scsi_cmnd *scmnd)
 	int len;
 
 	if (unlikely(target->state)) {
-		if (srp_is_disconnected(target))
+		if (!srp_is_removed(target))
 			goto err;
 
-		if (srp_is_removed(target)) {
-			scmnd->result = DID_BAD_TARGET << 16;
-			scmnd->scsi_done(scmnd);
-			return 0;
-		}
+		scmnd->result = DID_BAD_TARGET << 16;
+		scmnd->scsi_done(scmnd);
+		return 0;
 	}
 
 	spin_lock_irqsave(&target->lock, flags);
@@ -1683,7 +1681,7 @@ static int srp_send_tsk_mgmt(struct srp_target_port *target,
 	struct srp_iu *iu;
 	struct srp_tsk_mgmt *tsk_mgmt;
 
-	if (srp_is_removed(target))
+	if (target->state)
 		return -1;
 
 	init_completion(&target->tsk_mgmt_done);
@@ -1727,12 +1725,11 @@ static int srp_abort(struct scsi_cmnd *scmnd)
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP abort called\n");
 
-	if (srp_in_error(target))
-		return FAILED;
 	if (!req || !srp_claim_req(target, req, scmnd))
 		return FAILED;
-	srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
-			  SRP_TSK_ABORT_TASK);
+	if (srp_send_tsk_mgmt(target, req->index, scmnd->device->lun,
+			  SRP_TSK_ABORT_TASK))
+		return FAILED;
 	srp_free_req(target, req, scmnd, 0);
 	scmnd->result = DID_ABORT << 16;
 	scmnd->scsi_done(scmnd);
@@ -1747,8 +1744,6 @@ static int srp_reset_device(struct scsi_cmnd *scmnd)
 
 	shost_printk(KERN_ERR, target->scsi_host, "SRP reset_device called\n");
 
-	if (srp_in_error(target))
-		return FAILED;
 	if (srp_send_tsk_mgmt(target, SRP_TAG_NO_REQ, scmnd->device->lun,
 			      SRP_TSK_LUN_RESET))
 		return FAILED;
-- 
1.7.7.6

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
