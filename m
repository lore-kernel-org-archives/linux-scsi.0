From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v9 07/10] ide, scsi: Tell the block layer at request allocation time about preempt requests
Date: Mon, 16 Oct 2017 16:29:02 -0700
Message-ID: <20171016232905.5047-8-bart.vanassche@wdc.com>
References: <20171016232905.5047-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171016232905.5047-1-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Bart Van Assche <bart.vanassche@wdc.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Convert blk_get_request(q, op, __GFP_RECLAIM) into
blk_get_request_flags(q, op, BLK_MQ_PREEMPT). This patch does not
change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Tested-by: Martin Steigerwald <martin@lichtvoll.de>
Acked-by: David S. Miller <davem@davemloft.net> [ for IDE ]
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/ide/ide-pm.c    | 4 ++--
 drivers/scsi/scsi_lib.c | 6 +++---
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 544f02d673ca..f56d742908df 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -89,9 +89,9 @@ int generic_ide_resume(struct device *dev)
 	}
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, __GFP_RECLAIM);
+	rq = blk_get_request_flags(drive->queue, REQ_OP_DRV_IN,
+				   BLK_MQ_REQ_PREEMPT);
 	ide_req(rq)->type = ATA_PRIV_PM_RESUME;
-	rq->rq_flags |= RQF_PREEMPT;
 	rq->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_RESUME;
 	rqpm.pm_state = PM_EVENT_ON;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6f10afaca25b..7c119696402c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -252,9 +252,9 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	struct scsi_request *rq;
 	int ret = DRIVER_ERROR << 24;
 
-	req = blk_get_request(sdev->request_queue,
+	req = blk_get_request_flags(sdev->request_queue,
 			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, __GFP_RECLAIM);
+			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, BLK_MQ_REQ_PREEMPT);
 	if (IS_ERR(req))
 		return ret;
 	rq = scsi_req(req);
@@ -268,7 +268,7 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	rq->retries = retries;
 	req->timeout = timeout;
 	req->cmd_flags |= flags;
-	req->rq_flags |= rq_flags | RQF_QUIET | RQF_PREEMPT;
+	req->rq_flags |= rq_flags | RQF_QUIET;
 
 	/*
 	 * head injection *required* here otherwise quiesce won't work
-- 
2.14.2
