From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/2] ib_srpt: Make srp_max_req_size module parameter use S_IRUGO|S_IWUSR
Date: Sun,  6 Nov 2011 11:15:40 +0000
Message-ID: <1320578141-27048-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41055 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab1KFLR4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Nov 2011 06:17:56 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-rdma <linux-rdma@vger.kernel.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Bart Van Assche <bvanassche@acm.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch converts the srp_max_req_size module parameter to R/W access
so that it's accessable when built as CONFIG_INFINIBAND_SRPT=y.  This
includes adding srpt_device->max_req_size that is assigned during
srpt_add_one() and referenced directly from there.

Reported-by: Bart Van Assche <bvanassche@acm.org>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |   20 +++++++++++---------
 drivers/infiniband/ulp/srpt/ib_srpt.h |    2 ++
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index aae040d..94e6aff 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -79,7 +79,7 @@ static spinlock_t srpt_dev_lock;       /* Protects srpt_dev_list. */
 static struct list_head srpt_dev_list; /* List of srpt_device structures. */
 
 static unsigned srp_max_req_size = DEFAULT_MAX_REQ_SIZE;
-module_param(srp_max_req_size, int, 0444);
+module_param(srp_max_req_size, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(srp_max_req_size,
 		 "Maximum size of SRP request messages in bytes.");
 
@@ -361,7 +361,7 @@ static void srpt_get_ioc(struct srpt_port *sport, u32 slot,
 	iocp->protocol_version = __constant_cpu_to_be16(SRP_PROTOCOL_VERSION);
 	iocp->send_queue_depth = cpu_to_be16(sdev->srq_size);
 	iocp->rdma_read_depth = 4;
-	iocp->send_size = cpu_to_be32(srp_max_req_size);
+	iocp->send_size = cpu_to_be32(sdev->max_req_size);
 	iocp->rdma_size = cpu_to_be32(min(sport->port_attrib.srp_max_rdma_size,
 					  1U << 24));
 	iocp->num_svc_entries = 1;
@@ -786,7 +786,7 @@ static int srpt_post_recv(struct srpt_device *sdev,
 	wr.wr_id = encode_wr_id(SRPT_RECV, ioctx->ioctx.index);
 
 	list.addr = ioctx->ioctx.dma;
-	list.length = srp_max_req_size;
+	list.length = sdev->max_req_size;
 	list.lkey = sdev->mr->lkey;
 
 	wr.next = NULL;
@@ -1942,7 +1942,8 @@ static void srpt_handle_new_iu(struct srpt_rdma_ch *ch,
 	BUG_ON(!recv_ioctx);
 
 	ib_dma_sync_single_for_cpu(ch->sport->sdev->device,
-				   recv_ioctx->ioctx.dma, srp_max_req_size,
+				   recv_ioctx->ioctx.dma,
+				   ch->sport->sdev->max_req_size,
 				   DMA_FROM_DEVICE);
 
 	ch_state = srpt_get_ch_state(ch);
@@ -2490,13 +2491,13 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
 		goto out;
 	}
 
-	if (it_iu_len > srp_max_req_size || it_iu_len < 64) {
+	if (it_iu_len > sdev->max_req_size || it_iu_len < 64) {
 		rej->reason = __constant_cpu_to_be32(
 				SRP_LOGIN_REJ_REQ_IT_IU_LENGTH_TOO_LARGE);
 		ret = -EINVAL;
 		printk(KERN_ERR "rejected SRP_LOGIN_REQ because its"
 		       " length (%d bytes) is out of range (%d .. %d)\n",
-		       it_iu_len, 64, srp_max_req_size);
+		       it_iu_len, 64, sdev->max_req_size);
 		goto reject;
 	}
 
@@ -3248,6 +3249,7 @@ static void srpt_add_one(struct ib_device *device)
 		goto err_pd;
 
 	sdev->srq_size = min(srpt_srq_size, sdev->dev_attr.max_srq_wr);
+	sdev->max_req_size = srp_max_req_size;
 
 	srq_attr.event_handler = srpt_srq_event;
 	srq_attr.srq_context = (void *)sdev;
@@ -3292,7 +3294,7 @@ static void srpt_add_one(struct ib_device *device)
 	sdev->ioctx_ring = (struct srpt_recv_ioctx **)
 		srpt_alloc_ioctx_ring(sdev, sdev->srq_size,
 				      sizeof(*sdev->ioctx_ring[0]),
-				      srp_max_req_size, DMA_FROM_DEVICE);
+				      sdev->max_req_size, DMA_FROM_DEVICE);
 	if (!sdev->ioctx_ring)
 		goto err_event;
 
@@ -3335,7 +3337,7 @@ out:
 
 err_ring:
 	srpt_free_ioctx_ring((struct srpt_ioctx **)sdev->ioctx_ring, sdev,
-			     sdev->srq_size, srp_max_req_size,
+			     sdev->srq_size, sdev->max_req_size,
 			     DMA_FROM_DEVICE);
 err_event:
 	ib_unregister_event_handler(&sdev->event_handler);
@@ -3395,7 +3397,7 @@ static void srpt_remove_one(struct ib_device *device)
 	ib_dealloc_pd(sdev->pd);
 
 	srpt_free_ioctx_ring((struct srpt_ioctx **)sdev->ioctx_ring, sdev,
-			     sdev->srq_size, srp_max_req_size, DMA_FROM_DEVICE);
+			sdev->srq_size, sdev->max_req_size, DMA_FROM_DEVICE);
 	sdev->ioctx_ring = NULL;
 	kfree(sdev);
 }
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
index b4b4bbc..6384316 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.h
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
@@ -384,6 +384,7 @@ struct srpt_port {
  * @dev_attr:      Attributes of the InfiniBand device as obtained during the
  *                 ib_client.add() callback.
  * @srq_size:      SRQ size.
+ * @max_req_size:  Max request size set via srp_max_req_size module parameter
  * @ioctx_ring:    Per-HCA SRQ.
  * @rch_list:      Per-device channel list -- see also srpt_rdma_ch.list.
  * @ch_releaseQ:   Enables waiting for removal from rch_list.
@@ -400,6 +401,7 @@ struct srpt_device {
 	struct ib_cm_id		*cm_id;
 	struct ib_device_attr	dev_attr;
 	int			srq_size;
+	int			max_req_size
 	struct srpt_recv_ioctx	**ioctx_ring;
 	struct list_head	rch_list;
 	wait_queue_head_t	ch_releaseQ;
-- 
1.7.2.5

