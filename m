From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V8 3/8] block: Convert RQF_PREEMPT into REQ_PREEMPT
Date: Tue,  3 Oct 2017 22:04:01 +0800
Message-ID: <20171003140406.26060-4-ming.lei@redhat.com>
References: <20171003140406.26060-1-ming.lei@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171003140406.26060-1-ming.lei@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Johannes Thumshirn <jthumshirn@suse.de>, Cathy Avery <cavery@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Bart Van Assche <bart.vanassche@wdc.com>, Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Bart Van Assche <bart.vanassche@wdc.com>

This patch does not change any functionality but makes the
REQ_PREEMPT flag available to blk_get_request(). A later patch
will add code to blk_get_request() that checks the REQ_PREEMPT
flag. Note: the IDE sense_rq request is allocated statically so
there is no blk_get_request() call that corresponds to this
request.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/blk-mq-debugfs.c    |  2 +-
 drivers/ide/ide-atapi.c   |  3 +--
 drivers/ide/ide-io.c      |  2 +-
 drivers/ide/ide-pm.c      |  4 ++--
 drivers/scsi/scsi_lib.c   | 11 ++++++-----
 include/linux/blk_types.h |  6 ++++++
 include/linux/blkdev.h    |  3 ---
 7 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index 980e73095643..62ac248a4984 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -266,6 +266,7 @@ static const char *const cmd_flag_name[] = {
 	CMD_FLAG_NAME(BACKGROUND),
 	CMD_FLAG_NAME(NOUNMAP),
 	CMD_FLAG_NAME(NOWAIT),
+	CMD_FLAG_NAME(PREEMPT),
 };
 #undef CMD_FLAG_NAME
 
@@ -279,7 +280,6 @@ static const char *const rqf_name[] = {
 	RQF_NAME(MIXED_MERGE),
 	RQF_NAME(MQ_INFLIGHT),
 	RQF_NAME(DONTPREP),
-	RQF_NAME(PREEMPT),
 	RQF_NAME(COPY_USER),
 	RQF_NAME(FAILED),
 	RQF_NAME(QUIET),
diff --git a/drivers/ide/ide-atapi.c b/drivers/ide/ide-atapi.c
index 14d1e7d9a1d6..1258739d5fa1 100644
--- a/drivers/ide/ide-atapi.c
+++ b/drivers/ide/ide-atapi.c
@@ -211,9 +211,8 @@ void ide_prep_sense(ide_drive_t *drive, struct request *rq)
 	}
 
 	sense_rq->rq_disk = rq->rq_disk;
-	sense_rq->cmd_flags = REQ_OP_DRV_IN;
+	sense_rq->cmd_flags = REQ_OP_DRV_IN | REQ_PREEMPT;
 	ide_req(sense_rq)->type = ATA_PRIV_SENSE;
-	sense_rq->rq_flags |= RQF_PREEMPT;
 
 	req->cmd[0] = GPCMD_REQUEST_SENSE;
 	req->cmd[4] = cmd_len;
diff --git a/drivers/ide/ide-io.c b/drivers/ide/ide-io.c
index 3a234701d92c..06ffccd0fb10 100644
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -539,7 +539,7 @@ void do_ide_request(struct request_queue *q)
 		 */
 		if ((drive->dev_flags & IDE_DFLAG_BLOCKED) &&
 		    ata_pm_request(rq) == 0 &&
-		    (rq->rq_flags & RQF_PREEMPT) == 0) {
+		    (rq->cmd_flags & REQ_PREEMPT) == 0) {
 			/* there should be no pending command at this point */
 			ide_unlock_port(hwif);
 			goto plug_device;
diff --git a/drivers/ide/ide-pm.c b/drivers/ide/ide-pm.c
index 544f02d673ca..f8d2709dcd56 100644
--- a/drivers/ide/ide-pm.c
+++ b/drivers/ide/ide-pm.c
@@ -89,9 +89,9 @@ int generic_ide_resume(struct device *dev)
 	}
 
 	memset(&rqpm, 0, sizeof(rqpm));
-	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN, __GFP_RECLAIM);
+	rq = blk_get_request(drive->queue, REQ_OP_DRV_IN | REQ_PREEMPT,
+			     __GFP_RECLAIM);
 	ide_req(rq)->type = ATA_PRIV_PM_RESUME;
-	rq->rq_flags |= RQF_PREEMPT;
 	rq->special = &rqpm;
 	rqpm.pm_step = IDE_PM_START_RESUME;
 	rqpm.pm_state = PM_EVENT_ON;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9cf6a80fe297..62f905b22821 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -253,8 +253,9 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	int ret = DRIVER_ERROR << 24;
 
 	req = blk_get_request(sdev->request_queue,
-			data_direction == DMA_TO_DEVICE ?
-			REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN, __GFP_RECLAIM);
+			      (data_direction == DMA_TO_DEVICE ?
+			       REQ_OP_SCSI_OUT : REQ_OP_SCSI_IN) | REQ_PREEMPT,
+			      __GFP_RECLAIM);
 	if (IS_ERR(req))
 		return ret;
 	rq = scsi_req(req);
@@ -268,7 +269,7 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	rq->retries = retries;
 	req->timeout = timeout;
 	req->cmd_flags |= flags;
-	req->rq_flags |= rq_flags | RQF_QUIET | RQF_PREEMPT;
+	req->rq_flags |= rq_flags | RQF_QUIET;
 
 	/*
 	 * head injection *required* here otherwise quiesce won't work
@@ -1301,7 +1302,7 @@ scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 			/*
 			 * If the devices is blocked we defer normal commands.
 			 */
-			if (!(req->rq_flags & RQF_PREEMPT))
+			if (!(req->cmd_flags & REQ_PREEMPT))
 				ret = BLKPREP_DEFER;
 			break;
 		default:
@@ -1310,7 +1311,7 @@ scsi_prep_state_check(struct scsi_device *sdev, struct request *req)
 			 * special commands.  In particular any user initiated
 			 * command is not allowed.
 			 */
-			if (!(req->rq_flags & RQF_PREEMPT))
+			if (!(req->cmd_flags & REQ_PREEMPT))
 				ret = BLKPREP_KILL;
 			break;
 		}
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index a2d2aa709cef..b6b6bf44e462 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -229,6 +229,11 @@ enum req_flag_bits {
 	__REQ_NOUNMAP,		/* do not free blocks when zeroing */
 
 	__REQ_NOWAIT,           /* Don't wait if request will block */
+	/*
+	 * set for "ide_preempt" requests and also for requests for which the
+	 * SCSI "quiesce" state must be ignored.
+	 */
+	__REQ_PREEMPT,
 	__REQ_NR_BITS,		/* stops here */
 };
 
@@ -248,6 +253,7 @@ enum req_flag_bits {
 
 #define REQ_NOUNMAP		(1ULL << __REQ_NOUNMAP)
 #define REQ_NOWAIT		(1ULL << __REQ_NOWAIT)
+#define REQ_PREEMPT		(1ULL << __REQ_PREEMPT)
 
 #define REQ_FAILFAST_MASK \
 	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT | REQ_FAILFAST_DRIVER)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 02fa42d24b52..ab6b6c0392c2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -96,9 +96,6 @@ typedef __u32 __bitwise req_flags_t;
 #define RQF_MQ_INFLIGHT		((__force req_flags_t)(1 << 6))
 /* don't call prep for this one */
 #define RQF_DONTPREP		((__force req_flags_t)(1 << 7))
-/* set for "ide_preempt" requests and also for requests for which the SCSI
-   "quiesce" state must be ignored. */
-#define RQF_PREEMPT		((__force req_flags_t)(1 << 8))
 /* contains copies of user pages */
 #define RQF_COPY_USER		((__force req_flags_t)(1 << 9))
 /* vaguely specified driver internal error.  Ignored by the block layer */
-- 
2.9.5
