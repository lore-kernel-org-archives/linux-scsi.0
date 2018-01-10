From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH v2 3/4] scsi: Avoid that .queuecommand() gets called for a quiesced SCSI device
Date: Wed, 10 Jan 2018 10:18:16 -0800
Message-ID: <20180110181817.25166-4-bart.vanassche@wdc.com>
References: <20180110181817.25166-1-bart.vanassche@wdc.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180110181817.25166-1-bart.vanassche@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>, Jason Gunthorpe <jgg@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>, Johannes Thumshirn <jthumshirn@suse.de>, Ming Lei <ming.lei@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Several SCSI transport and LLD drivers surround code that does not
tolerate concurrent calls of .queuecommand() with scsi_target_block() /
scsi_target_unblock(). These last two functions use
blk_mq_quiesce_queue() / blk_mq_unquiesce_queue() for scsi-mq request
queues to prevent concurrent .queuecommand() calls. However, that is
not sufficient to prevent .queuecommand() calls from scsi_send_eh_cmnd().
Hence surround the .queuecommand() call from the SCSI error handler with
blk_start_wait_if_quiesced() / blk_finish_wait_if_quiesced().

Note: converting the .queuecommand() call in scsi_send_eh_cmnd() into
code that calls blk_get_request(), e.g. scsi_execute_req(), is not an
option since scsi_send_eh_cmnd() can be called if all requests are
allocated and if no requests will make progress without aborting any
of these requests.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Ming Lei <ming.lei@redhat.com>
---
 drivers/scsi/scsi_error.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 62b56de38ae8..f7154ea86715 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1016,6 +1016,7 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 {
 	struct scsi_device *sdev = scmd->device;
 	struct Scsi_Host *shost = sdev->host;
+	struct request_queue *q = sdev->request_queue;
 	DECLARE_COMPLETION_ONSTACK(done);
 	unsigned long timeleft = timeout;
 	struct scsi_eh_save ses;
@@ -1028,7 +1029,9 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 
 	scsi_log_send(scmd);
 	scmd->scsi_done = scsi_eh_done;
+	blk_start_wait_if_quiesced(q);
 	rtn = shost->hostt->queuecommand(shost, scmd);
+	blk_finish_wait_if_quiesced(q);
 	if (rtn) {
 		if (timeleft > stall_for) {
 			scsi_eh_restore_cmnd(scmd, &ses);
-- 
2.15.1
