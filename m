From: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Subject: [PATCH] block: Remove request_queue argument from blk_execute_rq_nowait
Date: Mon,  5 Aug 2019 22:17:51 -0300
Message-ID: <20190806011754.7722-1-marcos.souza.org@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Marcos Paulo de Souza <marcos.souza.org@gmail.com>, Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Doug Gilbert <dgilbert@interlog.com>, =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>, Hannes Reinecke <hare@suse.com>, Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Commit a1ce35fa4985 ("block: remove dead elevator code") removed code
that was using the request_queue argument. This got simplified by
calling blk_mq_sched_insert_request which already gets the request_queue
from the request being inserted in the scheduler queue for execution.

Signed-off-by: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
---
 block/blk-exec.c                   | 7 +++----
 drivers/block/sx8.c                | 4 ++--
 drivers/nvme/host/core.c           | 4 ++--
 drivers/nvme/host/lightnvm.c       | 2 +-
 drivers/nvme/host/pci.c            | 7 +++----
 drivers/scsi/scsi_error.c          | 2 +-
 drivers/scsi/sg.c                  | 3 +--
 drivers/scsi/st.c                  | 2 +-
 drivers/target/target_core_pscsi.c | 5 ++---
 include/linux/blkdev.h             | 4 ++--
 10 files changed, 18 insertions(+), 22 deletions(-)

diff --git a/block/blk-exec.c b/block/blk-exec.c
index 1db44ca0f4a6..dc9f37f2602f 100644
--- a/block/blk-exec.c
+++ b/block/blk-exec.c
@@ -45,9 +45,8 @@ static void blk_end_sync_rq(struct request *rq, blk_status_t error)
  * Note:
  *    This function will invoke @done directly if the queue is dead.
  */
-void blk_execute_rq_nowait(struct request_queue *q, struct gendisk *bd_disk,
-			   struct request *rq, int at_head,
-			   rq_end_io_fn *done)
+void blk_execute_rq_nowait(struct gendisk *bd_disk, struct request *rq,
+			int at_head, rq_end_io_fn *done)
 {
 	WARN_ON(irqs_disabled());
 	WARN_ON(!blk_rq_is_passthrough(rq));
@@ -81,7 +80,7 @@ void blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,
 	unsigned long hang_check;
 
 	rq->end_io_data = &wait;
-	blk_execute_rq_nowait(q, bd_disk, rq, at_head, blk_end_sync_rq);
+	blk_execute_rq_nowait(bd_disk, rq, at_head, blk_end_sync_rq);
 
 	/* Prevent hang_check timer from firing at us during very long I/O */
 	hang_check = sysctl_hung_task_timeout_secs;
diff --git a/drivers/block/sx8.c b/drivers/block/sx8.c
index 4478eb7efee0..2cdf2771f8e8 100644
--- a/drivers/block/sx8.c
+++ b/drivers/block/sx8.c
@@ -539,7 +539,7 @@ static int carm_array_info (struct carm_host *host, unsigned int array_idx)
 	spin_unlock_irq(&host->lock);
 
 	DPRINTK("blk_execute_rq_nowait, tag == %u\n", rq->tag);
-	blk_execute_rq_nowait(host->oob_q, NULL, rq, true, NULL);
+	blk_execute_rq_nowait(NULL, rq, true, NULL);
 
 	return 0;
 
@@ -578,7 +578,7 @@ static int carm_send_special (struct carm_host *host, carm_sspc_t func)
 	crq->msg_bucket = (u32) rc;
 
 	DPRINTK("blk_execute_rq_nowait, tag == %u\n", rq->tag);
-	blk_execute_rq_nowait(host->oob_q, NULL, rq, true, NULL);
+	blk_execute_rq_nowait(NULL, rq, true, NULL);
 
 	return 0;
 }
diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 8f3fbe5ca937..6682fdcece0f 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -756,7 +756,7 @@ static void nvme_execute_rq_polled(struct request_queue *q,
 
 	rq->cmd_flags |= REQ_HIPRI;
 	rq->end_io_data = &wait;
-	blk_execute_rq_nowait(q, bd_disk, rq, at_head, nvme_end_sync_rq);
+	blk_execute_rq_nowait(bd_disk, rq, at_head, nvme_end_sync_rq);
 
 	while (!completion_done(&wait)) {
 		blk_poll(q, request_to_qc_t(rq->mq_hctx, rq), true);
@@ -941,7 +941,7 @@ static int nvme_keep_alive(struct nvme_ctrl *ctrl)
 	rq->timeout = ctrl->kato * HZ;
 	rq->end_io_data = ctrl;
 
-	blk_execute_rq_nowait(rq->q, NULL, rq, 0, nvme_keep_alive_end_io);
+	blk_execute_rq_nowait(NULL, rq, 0, nvme_keep_alive_end_io);
 
 	return 0;
 }
diff --git a/drivers/nvme/host/lightnvm.c b/drivers/nvme/host/lightnvm.c
index ba009d4c9dfa..5d0e330e86d0 100644
--- a/drivers/nvme/host/lightnvm.c
+++ b/drivers/nvme/host/lightnvm.c
@@ -685,7 +685,7 @@ static int nvme_nvm_submit_io(struct nvm_dev *dev, struct nvm_rq *rqd)
 
 	rq->end_io_data = rqd;
 
-	blk_execute_rq_nowait(q, NULL, rq, 0, nvme_nvm_end_io);
+	blk_execute_rq_nowait(NULL, rq, 0, nvme_nvm_end_io);
 
 	return 0;
 }
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index db160cee42ad..d8f83696b4ba 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1332,7 +1332,7 @@ static enum blk_eh_timer_return nvme_timeout(struct request *req, bool reserved)
 
 	abort_req->timeout = ADMIN_TIMEOUT;
 	abort_req->end_io_data = NULL;
-	blk_execute_rq_nowait(abort_req->q, NULL, abort_req, 0, abort_endio);
+	blk_execute_rq_nowait(NULL, abort_req, 0, abort_endio);
 
 	/*
 	 * The aborted req will be completed on receiving the abort req.
@@ -2205,9 +2205,8 @@ static int nvme_delete_queue(struct nvme_queue *nvmeq, u8 opcode)
 	req->end_io_data = nvmeq;
 
 	init_completion(&nvmeq->delete_done);
-	blk_execute_rq_nowait(q, NULL, req, false,
-			opcode == nvme_admin_delete_cq ?
-				nvme_del_cq_end : nvme_del_queue_end);
+	blk_execute_rq_nowait(NULL, req, false,
+			      opcode == nvme_admin_delete_cq ? nvme_del_cq_end : nvme_del_queue_end);
 	return 0;
 }
 
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 1c470e31ae81..49cda23c7fb8 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1988,7 +1988,7 @@ static void scsi_eh_lock_door(struct scsi_device *sdev)
 	req->timeout = 10 * HZ;
 	rq->retries = 5;
 
-	blk_execute_rq_nowait(req->q, NULL, req, 1, eh_lock_door_done);
+	blk_execute_rq_nowait(NULL, req, 1, eh_lock_door_done);
 }
 
 /**
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index cce757506383..81ece3ed0474 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -835,8 +835,7 @@ sg_common_write(Sg_fd * sfp, Sg_request * srp,
 
 	srp->rq->timeout = timeout;
 	kref_get(&sfp->f_ref); /* sg_rq_end_io() does kref_put(). */
-	blk_execute_rq_nowait(sdp->device->request_queue, sdp->disk,
-			      srp->rq, at_head, sg_rq_end_io);
+	blk_execute_rq_nowait(sdp->disk, srp->rq, at_head, sg_rq_end_io);
 	return 0;
 }
 
diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index e3266a64a477..3b828f260294 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -583,7 +583,7 @@ static int st_scsi_execute(struct st_request *SRpnt, const unsigned char *cmd,
 	rq->retries = retries;
 	req->end_io_data = SRpnt;
 
-	blk_execute_rq_nowait(req->q, NULL, req, 1, st_scsi_execute_end);
+	blk_execute_rq_nowait(NULL, req, 1, st_scsi_execute_end);
 	return 0;
 }
 
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index c9d92b3e777d..021212569d1b 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -1000,9 +1000,8 @@ pscsi_execute_cmd(struct se_cmd *cmd)
 		req->timeout = PS_TIMEOUT_OTHER;
 	scsi_req(req)->retries = PS_RETRY;
 
-	blk_execute_rq_nowait(pdv->pdv_sd->request_queue, NULL, req,
-			(cmd->sam_task_attr == TCM_HEAD_TAG),
-			pscsi_req_done);
+	blk_execute_rq_nowait(NULL, req, (cmd->sam_task_attr == TCM_HEAD_TAG),
+			      pscsi_req_done);
 
 	return 0;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1ef375dafb1c..8e8f088c75a5 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -867,8 +867,8 @@ extern int blk_rq_map_user_iov(struct request_queue *, struct request *,
 			       gfp_t);
 extern void blk_execute_rq(struct request_queue *, struct gendisk *,
 			  struct request *, int);
-extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
-				  struct request *, int, rq_end_io_fn *);
+extern void blk_execute_rq_nowait(struct gendisk *, struct request *, int,
+				rq_end_io_fn *);
 
 /* Helper to convert REQ_OP_XXX to its string format XXX */
 extern const char *blk_op_str(unsigned int op);
-- 
2.22.0
