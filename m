From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 2/2] scsi: implement .cleanup_rq callback
Date: Sat, 20 Jul 2019 11:06:37 +0800
Message-ID: <20190720030637.14447-3-ming.lei@redhat.com>
References: <20190720030637.14447-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190720030637.14447-1-ming.lei@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "James E . J . Bottomley" <jejb@linux.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, "Ewan D . Milne" <emilne@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Implement .cleanup_rq() callback for freeing driver private part of the
request. Then we can avoid to leak request private data if the request
isn't completed by SCSI, and freed by blk-mq or upper layer(such as dm-rq)
finally.

Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Cc: <stable@vger.kernel.org>
Fixes: 396eaf21ee17 ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_lib.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e1da8c70a266..52537c145762 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -154,12 +154,9 @@ scsi_set_blocked(struct scsi_cmnd *cmd, int reason)
 
 static void scsi_mq_requeue_cmd(struct scsi_cmnd *cmd)
 {
-	if (cmd->request->rq_flags & RQF_DONTPREP) {
-		cmd->request->rq_flags &= ~RQF_DONTPREP;
-		scsi_mq_uninit_cmd(cmd);
-	} else {
-		WARN_ON_ONCE(true);
-	}
+	WARN_ON_ONCE(!(cmd->request->rq_flags & RQF_DONTPREP));
+
+	scsi_mq_uninit_cmd(cmd);
 	blk_mq_requeue_request(cmd->request, true);
 }
 
@@ -563,9 +560,13 @@ static void scsi_mq_free_sgtables(struct scsi_cmnd *cmd)
 
 static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 {
+	if (!(cmd->request->rq_flags & RQF_DONTPREP))
+		return;
+
 	scsi_mq_free_sgtables(cmd);
 	scsi_uninit_cmd(cmd);
 	scsi_del_cmd_from_list(cmd);
+	cmd->request->rq_flags &= ~RQF_DONTPREP;
 }
 
 /* Returns false when no more bytes to process, true if there are more */
@@ -1089,6 +1090,17 @@ static void scsi_initialize_rq(struct request *rq)
 	cmd->retries = 0;
 }
 
+/*
+ * Only called when the request isn't completed by SCSI, and not freed by
+ * SCSI
+ */
+static void scsi_cleanup_rq(struct request *rq)
+{
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
+
+	scsi_mq_uninit_cmd(cmd);
+}
+
 /* Add a command to the list used by the aacraid and dpt_i2o drivers */
 void scsi_add_cmd_to_list(struct scsi_cmnd *cmd)
 {
@@ -1708,8 +1720,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		 * we hit an error, as we will never see this command
 		 * again.
 		 */
-		if (req->rq_flags & RQF_DONTPREP)
-			scsi_mq_uninit_cmd(cmd);
+		scsi_mq_uninit_cmd(cmd);
 		break;
 	}
 	return ret;
@@ -1816,6 +1827,7 @@ static const struct blk_mq_ops scsi_mq_ops = {
 	.init_request	= scsi_mq_init_request,
 	.exit_request	= scsi_mq_exit_request,
 	.initialize_rq_fn = scsi_initialize_rq,
+	.cleanup_rq	= scsi_cleanup_rq,
 	.busy		= scsi_mq_lld_busy,
 	.map_queues	= scsi_map_queues,
 };
-- 
2.20.1
