From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 5/5] block, scsi: move the retries field to struct scsi_request
Date: Wed,  5 Apr 2017 19:18:12 +0200
Message-ID: <20170405171812.19911-6-hch@lst.de>
References: <20170405171812.19911-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170405171812.19911-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Keith Busch <keith.busch@intel.com>, Sagi Grimberg <sagi@grimberg.me>
Cc: linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Instead of bloating the generic struct request with it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 block/scsi_ioctl.c                 | 8 ++++----
 drivers/scsi/osd/osd_initiator.c   | 2 +-
 drivers/scsi/osst.c                | 2 +-
 drivers/scsi/scsi_error.c          | 2 +-
 drivers/scsi/scsi_lib.c            | 4 ++--
 drivers/scsi/sg.c                  | 2 +-
 drivers/scsi/st.c                  | 2 +-
 drivers/target/target_core_pscsi.c | 2 +-
 include/linux/blkdev.h             | 1 -
 include/scsi/scsi_request.h        | 1 +
 10 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 2a2fc768b27a..82a43bb19967 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -362,7 +362,7 @@ static int sg_io(struct request_queue *q, struct gendisk *bd_disk,
 		goto out_free_cdb;
 
 	bio = rq->bio;
-	rq->retries = 0;
+	req->retries = 0;
 
 	start_time = jiffies;
 
@@ -476,13 +476,13 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 		goto error;
 
 	/* default.  possible overriden later */
-	rq->retries = 5;
+	req->retries = 5;
 
 	switch (opcode) {
 	case SEND_DIAGNOSTIC:
 	case FORMAT_UNIT:
 		rq->timeout = FORMAT_UNIT_TIMEOUT;
-		rq->retries = 1;
+		req->retries = 1;
 		break;
 	case START_STOP:
 		rq->timeout = START_STOP_TIMEOUT;
@@ -495,7 +495,7 @@ int sg_scsi_ioctl(struct request_queue *q, struct gendisk *disk, fmode_t mode,
 		break;
 	case READ_DEFECT_DATA:
 		rq->timeout = READ_DEFECT_DATA_TIMEOUT;
-		rq->retries = 1;
+		req->retries = 1;
 		break;
 	default:
 		rq->timeout = BLK_DEFAULT_SG_TIMEOUT;
diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index 6903f03c88af..9d0727b2bdec 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -1602,7 +1602,7 @@ static int _init_blk_request(struct osd_request *or,
 	req->rq_flags |= RQF_QUIET;
 
 	req->timeout = or->timeout;
-	req->retries = or->retries;
+	scsi_req(req)->retries = or->retries;
 
 	if (has_out) {
 		or->out.req = req;
diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index c47f4b349bac..41bc1d64bf86 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -414,7 +414,7 @@ static int osst_execute(struct osst_request *SRpnt, const unsigned char *cmd,
 	memset(rq->cmd, 0, BLK_MAX_CDB); /* ATAPI hates garbage after CDB */
 	memcpy(rq->cmd, cmd, rq->cmd_len);
 	req->timeout = timeout;
-	req->retries = retries;
+	rq->retries = retries;
 	req->end_io_data = SRpnt;
 
 	blk_execute_rq_nowait(req->q, NULL, req, 1, osst_end_async);
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f2cafae150bc..2db412dd4b44 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1988,7 +1988,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 
 	req->rq_flags |= RQF_QUIET;
 	req->timeout = 10 * HZ;
-	req->retries = 5;
+	rq->retries = 5;
 
 	blk_execute_rq_nowait(req->q, NULL, req, 1, eh_lock_door_done);
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c1519660824b..11972d1075f1 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -256,7 +256,7 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 
 	rq->cmd_len = COMMAND_SIZE(cmd[0]);
 	memcpy(rq->cmd, cmd, rq->cmd_len);
-	req->retries = retries;
+	rq->retries = retries;
 	req->timeout = timeout;
 	req->cmd_flags |= flags;
 	req->rq_flags |= rq_flags | RQF_QUIET | RQF_PREEMPT;
@@ -1177,7 +1177,7 @@ static int scsi_setup_scsi_cmnd(struct scsi_device *sdev, struct request *req)
 	cmd->cmd_len = scsi_req(req)->cmd_len;
 	cmd->cmnd = scsi_req(req)->cmd;
 	cmd->transfersize = blk_rq_bytes(req);
-	cmd->allowed = req->retries;
+	cmd->allowed = scsi_req(req)->retries;
 	return BLKPREP_OK;
 }
 
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 225abaad4d1c..c5aaceea8d77 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1718,7 +1718,7 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 
 	srp->rq = rq;
 	rq->end_io_data = srp;
-	rq->retries = SG_DEFAULT_RETRIES;
+	req->retries = SG_DEFAULT_RETRIES;
 
 	if ((dxfer_len <= 0) || (dxfer_dir == SG_DXFER_NONE))
 		return 0;
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e5ef78a6848e..5408643431bb 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -579,7 +579,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 	memset(rq->cmd, 0, BLK_MAX_CDB);
 	memcpy(rq->cmd, cmd, rq->cmd_len);
 	req->timeout = timeout;
-	req->retries = retries;
+	rq->retries = retries;
 	req->end_io_data = SRpnt;
 
 	blk_execute_rq_nowait(req->q, NULL, req, 1, st_scsi_execute_end);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 94cda7991e80..c7fa372c527a 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1008,7 +1008,7 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 		req->timeout = PS_TIMEOUT_DISK;
 	else
 		req->timeout = PS_TIMEOUT_OTHER;
-	req->retries = PS_RETRY;
+	scsi_req(req)->retries = PS_RETRY;
 
 	blk_execute_rq_nowait(pdv->pdv_sd->request_queue, NULL, req,
 			(cmd->sam_task_attr == TCM_HEAD_TAG),
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index a2dc6b390d48..ce6f9a6534c9 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -224,7 +224,6 @@ struct request {
 	unsigned long deadline;
 	struct list_head timeout_list;
 	unsigned int timeout;
-	int retries;
 
 	/*
 	 * completion callback.
diff --git a/include/scsi/scsi_request.h b/include/scsi/scsi_request.h
index ba0aeb980f7e..7c583a0f363a 100644
--- a/include/scsi/scsi_request.h
+++ b/include/scsi/scsi_request.h
@@ -11,6 +11,7 @@ struct scsi_request {
 	unsigned short	cmd_len;
 	unsigned int	sense_len;
 	unsigned int	resid_len;	/* residual count */
+	int		retries;
 	void		*sense;
 };
 
-- 
2.11.0
