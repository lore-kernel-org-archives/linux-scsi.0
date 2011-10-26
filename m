From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] ib_srpt: Make srpt_map_sg_to_ib_sge() failure case return -EAGAIN
Date: Wed, 26 Oct 2011 07:13:32 +0000
Message-ID: <1319613212-8519-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:56768 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752431Ab1JZHPK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2011 03:15:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch makes the failure case in srpt_map_sg_to_ib_sge() for ib_dma_map_sg()
return -EAGAIN so that this failure will trigger target-core QUEUE_FULL logic
from srpt_xfer_data() for srpt_write_pending() WRITEs and srpt_queue_response()
for READs.

Reported-by: Bart Van Assche <bvanassche@acm.org>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Roland Dreier <roland@purestorage.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index f7174b3..7892efc 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -1112,7 +1112,7 @@ static int srpt_map_sg_to_ib_sge(struct srpt_rdma_ch *ch,
 	count = ib_dma_map_sg(ch->sport->sdev->device, sg, sg_cnt,
 			      opposite_dma_dir(dir));
 	if (unlikely(!count))
-		return -EBUSY;
+		return -EAGAIN;
 
 	ioctx->mapped_sg_count = count;
 
-- 
1.7.2.5

