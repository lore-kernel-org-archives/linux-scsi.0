From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCHv2  3/4] block: Change at_head argument of blk_execute_rq_nowait to bool
Date: Fri,  9 Aug 2019 07:54:32 -0300
Message-ID: <20190809105433.8946-4-marcos.souza.org@gmail.com>
References: <20190809105433.8946-1-marcos.souza.org@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190809105433.8946-1-marcos.souza.org@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>, hch@lst.de, axboe@kernel.dk, linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, Hannes Reinecke <hare@suse.com>, Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>, "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 block/blk-exec.c             |  2 +-
 drivers/nvme/host/core.c     | 12 ++++++------
 drivers/nvme/host/lightnvm.c |  2 +-
 drivers/nvme/host/nvme.h     |  2 +-
 drivers/nvme/host/pci.c      |  2 +-
 drivers/scsi/scsi_error.c    |  2 +-
 drivers/scsi/st.c            |  2 +-
 include/linux/blkdev.h       |  2 +-
 8 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index 7862f8be39d1..c8b88f469988 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -45,7 +45,7 @@ static void blk_end_sync_rq(struct request *rq, blk_status_t error)
  *    This function will invoke @done directly if the queue is dead.
  */
 void blk_execute_rq_nowait(struct gendisk *bd_disk, struct request *rq,
-			int at_head, rq_end_io_fn *done)
+			bool at_head, rq_end_io_fn *done)
 {
 	WARN_ON(irqs_disabled());
 	WARN_ON(!blk_rq_is_passthrough(rq));
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 4a2ed03223b1..38c1a5db9e56 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -748,7 +748,7 @@ static void nvme_end_sync_rq(struct request *rq, blk_status_t error)
 }

 static void nvme_execute_rq_polled(struct request_queue *q,
-		struct gendisk *bd_disk, struct request *rq, int at_head)
+		struct gendisk *bd_disk, struct request *rq, bool at_head)
 {
 	DECLARE_COMPLETION_ONSTACK(wait);

@@ -770,7 +770,7 @@ static void nvme_execute_rq_polled(struct request_queue *q,
  */
 int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		union nvme_result *result, void *buffer, unsigned bufflen,
-		unsigned timeout, int qid, int at_head,
+		unsigned timeout, int qid, bool at_head,
 		blk_mq_req_flags_t flags, bool poll)
 {
 	struct request *req;
@@ -808,7 +808,7 @@ int nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		void *buffer, unsigned bufflen)
 {
 	return __nvme_submit_sync_cmd(q, cmd, NULL, buffer, bufflen, 0,
-			NVME_QID_ANY, 0, 0, false);
+			NVME_QID_ANY, false, 0, false);
 }
 EXPORT_SYMBOL_GPL(nvme_submit_sync_cmd);

@@ -941,7 +941,7 @@ static int nvme_keep_alive(struct nvme_ctrl *ctrl)
 	rq->timeout = ctrl->kato * HZ;
 	rq->end_io_data = ctrl;

-	blk_execute_rq_nowait(NULL, rq, 0, nvme_keep_alive_end_io);
+	blk_execute_rq_nowait(NULL, rq, false, nvme_keep_alive_end_io);

 	return 0;
 }
@@ -1127,7 +1127,7 @@ static int nvme_features(struct nvme_ctrl *dev, u8 op, unsigned int fid,
 	c.features.dword11 = cpu_to_le32(dword11);

 	ret = __nvme_submit_sync_cmd(dev->admin_q, &c, &res,
-			buffer, buflen, 0, NVME_QID_ANY, 0, 0, false);
+			buffer, buflen, 0, NVME_QID_ANY, false, 0, false);
 	if (ret >= 0 && result)
 		*result = le32_to_cpu(res.u32);
 	return ret;
@@ -1871,7 +1871,7 @@ int nvme_sec_submit(void *data, u16 spsp, u8 secp, void *buffer, size_t len,
 	cmd.common.cdw11 = cpu_to_le32(len);

 	return __nvme_submit_sync_cmd(ctrl->admin_q, &cmd, NULL, buffer, len,
-				      ADMIN_TIMEOUT, NVME_QID_ANY, 1, 0, false);
+				      ADMIN_TIMEOUT, NVME_QID_ANY, true, 0, false);
 }
 EXPORT_SYMBOL_GPL(nvme_sec_submit);
 #endif /* CONFIG_BLK_SED_OPAL */
diff --git a/drivers/nvme/host/lightnvm.c b/drivers/nvme/host/lightnvm.c
index 9c82a5044b75..c09989376c3b 100644
--- a/drivers/nvme/host/lightnvm.c
+++ b/drivers/nvme/host/lightnvm.c
@@ -685,7 +685,7 @@ static int nvme_nvm_submit_io(struct nvm_dev *dev, struct nvm_rq *rqd)

 	rq->end_io_data = rqd;

-	blk_execute_rq_nowait(NULL, rq, 0, nvme_nvm_end_io);
+	blk_execute_rq_nowait(NULL, rq, false, nvme_nvm_end_io);

 	return 0;
 }
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 26b563f9985b..f43d0189cba3 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -464,7 +464,7 @@ int nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		void *buf, unsigned bufflen);
 int __nvme_submit_sync_cmd(struct request_queue *q, struct nvme_command *cmd,
 		union nvme_result *result, void *buffer, unsigned bufflen,
-		unsigned timeout, int qid, int at_head,
+		unsigned timeout, int qid, bool at_head,
 		blk_mq_req_flags_t flags, bool poll);
 int nvme_set_features(struct nvme_ctrl *dev, unsigned int fid,
 		      unsigned int dword11, void *buffer, size_t buflen,
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index d8f83696b4ba..20cbadc7469d 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1332,7 +1332,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)

 	abort_req->timeout = ADMIN_TIMEOUT;
 	abort_req->end_io_data = NULL;
-	blk_execute_rq_nowait(NULL, abort_req, 0, abort_endio);
+	blk_execute_rq_nowait(NULL, abort_req, false, abort_endio);

 	/*
 	 * The aborted req will be completed on receiving the abort req.
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 49cda23c7fb8..48b1cbb72e32 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1988,7 +1988,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	req->timeout = 10 * HZ;
 	rq->retries = 5;

-	blk_execute_rq_nowait(NULL, req, 1, eh_lock_door_done);
+	blk_execute_rq_nowait(NULL, req, false, eh_lock_door_done);
 }

 /**
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 3b828f260294..1d81125f8d35 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -583,7 +583,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 	rq->retries = retries;
 	req->end_io_data = SRpnt;

-	blk_execute_rq_nowait(NULL, req, 1, st_scsi_execute_end);
+	blk_execute_rq_nowait(NULL, req, true, st_scsi_execute_end);
 	return 0;
 }

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index c9d9ca686290..19ed996f0074 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -866,7 +866,7 @@ extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
 			       struct rq_map_data *, const struct iov_iter *,
 			       gfp_t);
 extern void blk_execute_rq(struct gendisk *, struct request *, int);
-extern void blk_execute_rq_nowait(struct gendisk *, struct request *, int,
+extern void blk_execute_rq_nowait(struct gendisk *, struct request *, bool,
 				rq_end_io_fn *);

 /* Helper to convert REQ_OP_XXX to its string format XXX */
--
2.22.0
