From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 07/31] scsi: Use blk_mq_rq_to_pdu() to convert a request to a SCSI command pointer
Date: Tue, 23 May 2017 17:33:56 -0700
Message-ID: <20170524003420.5381-8-bart.vanassche@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Since commit e9c787e65c0c ("scsi: allocate scsi_cmnd structures as
part of struct request") struct request and struct scsi_cmnd are
adjacent. This means that there is now an alternative to reading
req->special to convert a pointer to a prepared request into a
SCSI command pointer, namely by using blk_mq_rq_to_pdu(). Make
this change where appropriate. Although this patch does not
change any functionality, it slightly improves performance and
slightly improves readability.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_error.c |  2 +-
 drivers/scsi/scsi_lib.c   | 18 +++++++++---------
 include/scsi/scsi_tcq.h   |  2 +-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 19cafa3efb17..7ba5f988426c 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -265,7 +265,7 @@ void scsi_eh_scmd_add(struct scsi_cmnd *scmd)
  */
 enum blk_eh_timer_return scsi_times_out(struct request *req)
 {
-	struct scsi_cmnd *scmd = req->special;
+	struct scsi_cmnd *scmd = blk_mq_rq_to_pdu(req);
 	enum blk_eh_timer_return rtn = BLK_EH_NOT_HANDLED;
 	struct Scsi_Host *host = scmd->device->host;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 5c6874cf4388..30a7900d331c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -637,7 +637,7 @@ static void scsi_release_bidi_buffers(struct scsi_cmnd *cmd)
 static bool scsi_end_request(struct request *req, int error,
 		unsigned int bytes, unsigned int bidi_bytes)
 {
-	struct scsi_cmnd *cmd = req->special;
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 	struct scsi_device *sdev = cmd->device;
 	struct request_queue *q = sdev->request_queue;
 
@@ -1156,7 +1156,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 
 static int scsi_setup_scsi_cmnd(struct scsi_device *sdev, struct request *req)
 {
-	struct scsi_cmnd *cmd = req->special;
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 
 	/*
 	 * Passthrough requests may transfer data, in which case they must
@@ -1187,7 +1187,7 @@ static int scsi_setup_scsi_cmnd(struct scsi_device *sdev, struct request *req)
  */
 static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 {
-	struct scsi_cmnd *cmd = req->special;
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 
 	if (unlikely(sdev->handler && sdev->handler->prep_fn)) {
 		int ret = sdev->handler->prep_fn(sdev, req);
@@ -1202,7 +1202,7 @@ static int scsi_setup_fs_cmnd(struct scsi_device *sdev, struct request *req)
 
 static int scsi_setup_cmnd(struct scsi_device *sdev, struct request *req)
 {
-	struct scsi_cmnd *cmd = req->special;
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 
 	if (!blk_rq_bytes(req))
 		cmd->sc_data_direction = DMA_NONE;
@@ -1339,7 +1339,7 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
 
 static void scsi_unprep_fn(struct request_queue *q, struct request *req)
 {
-	scsi_uninit_cmd(req->special);
+	scsi_uninit_cmd(blk_mq_rq_to_pdu(req));
 }
 
 /*
@@ -1530,7 +1530,7 @@ static int scsi_lld_busy(struct request_queue *q)
  */
 static void scsi_kill_request(struct request *req, struct request_queue *q)
 {
-	struct scsi_cmnd *cmd = req->special;
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 	struct scsi_device *sdev;
 	struct scsi_target *starget;
 	struct Scsi_Host *shost;
@@ -1561,7 +1561,7 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 
 static void scsi_softirq_done(struct request *rq)
 {
-	struct scsi_cmnd *cmd = rq->special;
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
 	unsigned long wait_for = (cmd->allowed + 1) * rq->timeout;
 	int disposition;
 
@@ -1749,8 +1749,8 @@ static void scsi_request_fn(struct request_queue *q)
 			blk_start_request(req);
 
 		spin_unlock_irq(q->queue_lock);
-		cmd = req->special;
-		if (unlikely(cmd == NULL)) {
+		cmd = blk_mq_rq_to_pdu(req);
+		if (cmd != req->special) {
 			printk(KERN_CRIT "impossible request in %s.\n"
 					 "please mail a stack trace to "
 					 "linux-scsi@vger.kernel.org\n",
diff --git a/include/scsi/scsi_tcq.h b/include/scsi/scsi_tcq.h
index 4416b1026189..5b416debf101 100644
--- a/include/scsi/scsi_tcq.h
+++ b/include/scsi/scsi_tcq.h
@@ -39,7 +39,7 @@ static inline struct scsi_cmnd *scsi_host_find_tag(struct Scsi_Host *shost,
 
 	if (!req)
 		return NULL;
-	return req->special;
+	return blk_mq_rq_to_pdu(req);
 }
 
 #endif /* CONFIG_BLOCK */
-- 
2.12.2
