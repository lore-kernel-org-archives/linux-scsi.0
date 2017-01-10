From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/15] nvme-rdma: fix nvme_rdma_queue_is_ready
Date: Tue, 10 Jan 2017 16:06:07 +0100
Message-ID: <1484060780-15592-3-git-send-email-hch@lst.de>
References: <1484060780-15592-1-git-send-email-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1484060780-15592-1-git-send-email-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

Now that we don't abuse the cmd field in struct request for nvme command
passthrough this function needs to be converted to the proper accessor
as well.

Fixes: d49187e97e ("nvme: introduce struct nvme_request")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/nvme/host/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index f587af3..34e5648 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1422,7 +1422,7 @@ static inline bool nvme_rdma_queue_is_ready(struct nvme_rdma_queue *queue,
 		struct request *rq)
 {
 	if (unlikely(!test_bit(NVME_RDMA_Q_LIVE, &queue->flags))) {
-		struct nvme_command *cmd = (struct nvme_command *)rq->cmd;
+		struct nvme_command *cmd = nvme_req(rq)->cmd;
 
 		if (rq->cmd_type != REQ_TYPE_DRV_PRIV ||
 		    cmd->common.opcode != nvme_fabrics_command ||
-- 
2.1.4

