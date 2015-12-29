From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 08/13] IB/srpt: chain RDMA READ/WRITE requests
Date: Tue, 29 Dec 2015 10:58:24 +0100
Message-ID: <56825940.5070404@sandisk.com>
References: <1449521512-22921-1-git-send-email-hch@lst.de>
 <1449521512-22921-9-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0089.outbound.protection.outlook.com ([157.56.111.89]:54547
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751649AbbL2J6c (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Dec 2015 04:58:32 -0500
In-Reply-To: <1449521512-22921-9-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/07/2015 09:51 PM, Christoph Hellwig wrote:
> Remove struct rdma_iu and instead allocate the struct ib_rdma_wr array
> early and fill out directly.  This allows us to chain the WRs, and thus
> archive both less lock contention on the HCA workqueue as well as much
> simpler error handling.

Please consider folding the patch below into this patch.

Thanks,

Bart.

[PATCH] IB/srpt: Fix a recently introduced kernel crash

BUG: unable to handle kernel paging request at 0000000100000198
IP: [<ffffffff810a4ea2>] __lock_acquire+0xa2/0x560
Call Trace:
 [<ffffffff810a53c2>] lock_acquire+0x62/0x80
 [<ffffffff8151bd33>] _raw_spin_lock_irqsave+0x43/0x60
 [<ffffffffa04fd437>] srpt_rdma_read_done+0x57/0x120 [ib_srpt]
 [<ffffffffa0144dd3>] __ib_process_cq+0x43/0xc0 [ib_core]
 [<ffffffffa0145115>] ib_cq_poll_work+0x25/0x70 [ib_core]
 [<ffffffff8107184d>] process_one_work+0x1bd/0x460
 [<ffffffff81073148>] worker_thread+0x118/0x420
 [<ffffffff81078454>] kthread+0xe4/0x100
 [<ffffffff8151cbbf>] ret_from_fork+0x3f/0x70

---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 8068aff..3daab39 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1395,7 +1395,7 @@ static void srpt_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct srpt_rdma_ch *ch = cq->cq_context;
 	struct srpt_send_ioctx *ioctx =
-		container_of(wc->wr_cqe, struct srpt_send_ioctx, ioctx.cqe);
+		container_of(wc->wr_cqe, struct srpt_send_ioctx, rdma_cqe);
 
 	WARN_ON(ioctx->n_rdma <= 0);
 	atomic_add(ioctx->n_rdma, &ch->sq_wr_avail);
@@ -1418,7 +1418,7 @@ static void srpt_rdma_read_done(struct ib_cq *cq, struct ib_wc *wc)
 static void srpt_rdma_write_done(struct ib_cq *cq, struct ib_wc *wc)
 {
 	struct srpt_send_ioctx *ioctx =
-		container_of(wc->wr_cqe, struct srpt_send_ioctx, ioctx.cqe);
+		container_of(wc->wr_cqe, struct srpt_send_ioctx, rdma_cqe);
 
 	if (unlikely(wc->status != IB_WC_SUCCESS)) {
 		pr_info("RDMA_WRITE for ioctx 0x%p failed with status %d\n",
-- 
2.1.4


