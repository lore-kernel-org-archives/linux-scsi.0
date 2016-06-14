From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC-v2 11/11] nvmet/loop: Add support for bio integrity handling
Date: Tue, 14 Jun 2016 04:35:46 +0000
Message-ID: <1465878946-26556-12-git-send-email-nab@linux-iscsi.org>
References: <1465878946-26556-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:38564 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933464AbcFNEhC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2016 00:37:02 -0400
In-Reply-To: <1465878946-26556-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@lst.de>, Keith Busch <keith.busch@intel.com>, Jay Freyensee <james.p.freyensee@intel.com>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds support for nvme/loop block integrity,
based upon the reported ID_NS.ms + ID_NS.dps feature
bits in nvmet_execute_identify_ns().

Cc: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Martin Petersen <martin.petersen@oracle.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/nvme/target/loop.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index e9f31d4..480a7ef 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -42,6 +42,7 @@ struct nvme_loop_iod {
 	struct nvme_loop_queue	*queue;
 	struct work_struct	work;
 	struct sg_table		sg_table;
+	struct scatterlist	meta_sg;
 	struct scatterlist	first_sgl[];
 };
 
@@ -201,6 +202,23 @@ static int nvme_loop_queue_rq(struct blk_mq_hw_ctx *hctx,
 		BUG_ON(iod->req.sg_cnt > req->nr_phys_segments);
 	}
 
+	if (blk_integrity_rq(req)) {
+		int count;
+
+		if (blk_rq_count_integrity_sg(hctx->queue, req->bio) != 1)
+			BUG_ON(1);
+
+		sg_init_table(&iod->meta_sg, 1);
+		count = blk_rq_map_integrity_sg(hctx->queue, req->bio,
+						&iod->meta_sg);
+
+		iod->req.prot_sg = &iod->meta_sg;
+		iod->req.prot_sg_cnt = 1;
+
+		pr_debug("nvme/loop: Set prot_sg %p and prot_sg_cnt: %d\n",
+			iod->req.prot_sg, iod->req.prot_sg_cnt);
+	}
+
 	iod->cmd.common.command_id = req->tag;
 	blk_mq_start_request(req);
 
-- 
1.9.1

