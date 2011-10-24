From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: [PATCH 1/2] ib_srpt: Fix possible race with srp_sq_size in srpt_create_ch_ib
Date: Mon, 24 Oct 2011 19:15:54 +0000
Message-ID: <1319483755-11522-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>

This patch fixes a possible race with srp_sq_size in srpt_create_ch_ib()
where changing sport->port_attrib.srp_sq_size via configfs could have
unintended consequences.  It uses a local assignment for srp_sq_size to
ensure the values for ib_create_cq() and qp_init->cap.max_send_wr are
consistent.

Reported-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Signed-off-by: Nicholas A. Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9e1c5e0..e483c54 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2130,6 +2130,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	struct ib_qp_init_attr *qp_init;
 	struct srpt_port *sport = ch->sport;
 	struct srpt_device *sdev = sport->sdev;
+	u32 srp_sq_size = sport->port_attrib.srp_sq_size;
 	int ret;
 
 	WARN_ON(ch->rq_size < 1);
@@ -2140,11 +2141,11 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 		goto out;
 
 	ch->cq = ib_create_cq(sdev->device, srpt_completion, NULL, ch,
-			      ch->rq_size + sport->port_attrib.srp_sq_size, 0);
+			      ch->rq_size + srp_sq_size, 0);
 	if (IS_ERR(ch->cq)) {
 		ret = PTR_ERR(ch->cq);
 		printk(KERN_ERR "failed to create CQ cqe= %d ret= %d\n",
-		       ch->rq_size + sport->port_attrib.srp_sq_size, ret);
+		       ch->rq_size + srp_sq_size, ret);
 		goto out;
 	}
 
@@ -2156,7 +2157,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	qp_init->srq = sdev->srq;
 	qp_init->sq_sig_type = IB_SIGNAL_REQ_WR;
 	qp_init->qp_type = IB_QPT_RC;
-	qp_init->cap.max_send_wr = sport->port_attrib.srp_sq_size;
+	qp_init->cap.max_send_wr = srp_sq_size;
 	qp_init->cap.max_send_sge = SRPT_DEF_SG_PER_WQE;
 
 	ch->qp = ib_create_qp(sdev->pd, qp_init);
-- 
1.7.2.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
