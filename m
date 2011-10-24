From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/2] ib_srpt: Fix possible race with srp_max_rsp_size in srpt_release_channel_work
Date: Mon, 24 Oct 2011 19:15:55 +0000
Message-ID: <1319483755-11522-2-git-send-email-nab@linux-iscsi.org>
References: <1319483755-11522-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:45498 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab1JXTRa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2011 15:17:30 -0400
In-Reply-To: <1319483755-11522-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma <linux-rdma@vger.kernel.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a possible race with srp_max_rsp_size in
srpt_release_channel_work() when changing sport->port_attrib.srp_max_rsp_size
via configfs could have unintended consequences.  It uses a new
srpt_rdma_ch->rsp_size and assign the value during srpt_cm_req_recv(),
which is used in subsequent calls to srpt_free_ioctx_ring() to ensure
consistency with the original srpt_alloc_ioctx_ring().

Reported-by: Bart Van Assche <bvanassche@acm.org>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   10 ++++------
 drivers/infiniband/ulp/srpt/ib_srpt.h |    2 ++
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index e483c54..f7174b3 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2373,8 +2373,7 @@ static void srpt_release_channel_work(struct work_struct *w)
 
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
 			     ch->sport->sdev, ch->rq_size,
-			     ch->sport->port_attrib.srp_max_rsp_size,
-			     DMA_TO_DEVICE);
+			     ch->rsp_size, DMA_TO_DEVICE);
 
 	spin_lock_irq(&sdev->spinlock);
 	list_del(&ch->list);
@@ -2554,12 +2553,12 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 	spin_lock_init(&ch->spinlock);
 	ch->state = CH_CONNECTING;
 	INIT_LIST_HEAD(&ch->cmd_wait_list);
+	ch->rsp_size = ch->sport->port_attrib.srp_max_rsp_size;
 
 	ch->ioctx_ring = (struct srpt_send_ioctx **)
 		srpt_alloc_ioctx_ring(ch->sport->sdev, ch->rq_size,
 				      sizeof(*ch->ioctx_ring[0]),
-				      ch->sport->port_attrib.srp_max_rsp_size,
-				      DMA_TO_DEVICE);
+				      ch->rsp_size, DMA_TO_DEVICE);
 	if (!ch->ioctx_ring)
 		goto free_ch;
 
@@ -2667,8 +2666,7 @@ destroy_ib:
 free_ring:
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
 			     ch->sport->sdev, ch->rq_size,
-			     ch->sport->port_attrib.srp_max_rsp_size,
-			     DMA_TO_DEVICE);
+			     ch->rsp_size, DMA_TO_DEVICE);
 free_ch:
 	kfree(ch);
 
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index 1b607ae..068f66d 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -277,6 +277,7 @@ enum rdma_ch_state {
  * @qp:            IB queue pair used for communicating over this channel.
  * @cq:            IB completion queue for this channel.
  * @rq_size:       IB receive queue size.
+ * @rsp_size	   IB response message size in bytes.
  * @sq_wr_avail:   number of work requests available in the send queue.
  * @sport:         pointer to the information of the HCA port used by this
  *                 channel.
@@ -307,6 +308,7 @@ struct srpt_rdma_ch {
 	struct ib_qp		*qp;
 	struct ib_cq		*cq;
 	int			rq_size;
+	u32			rsp_size;
 	atomic_t		sq_wr_avail;
 	struct srpt_port	*sport;
 	u8			i_port_id[16];
-- 
1.7.2.5

