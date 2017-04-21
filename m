From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v4 10/10] scsi: Implement blk_mq_ops.show_rq()
Date: Fri, 21 Apr 2017 16:40:26 -0700
Message-ID: <20170421234026.18970-11-bart.vanassche@sandisk.com>
References: <20170421234026.18970-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170421234026.18970-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Omar Sandoval <osandov@fb.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Show the SCSI CDB, .eh_eflags and .result for pending SCSI commands
in /sys/kernel/debug/block/*/mq/*/dispatch and */rq_list.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Omar Sandoval <osandov@fb.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: <linux-scsi@vger.kernel.org>
---
 drivers/scsi/scsi_lib.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4a20e6098f7c..90bb269042df 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2125,6 +2125,16 @@ static void scsi_exit_rq(struct request_queue *q, struct request *rq)
 	scsi_free_sense_buffer(shost, cmd->sense_buffer);
 }
 
+static void scsi_show_rq(struct seq_file *m, struct request *rq)
+{
+	struct scsi_cmnd *cmd = container_of(scsi_req(rq), typeof(*cmd), req);
+	unsigned int i;
+
+	seq_puts(m, ", .cmd =");
+	for (i = 0; i < cmd->cmd_len; i++)
+		seq_printf(m, " %02x", cmd->cmnd[i]);
+}
+
 struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -2157,6 +2167,7 @@ static const struct blk_mq_ops scsi_mq_ops = {
 	.queue_rq	= scsi_queue_rq,
 	.complete	= scsi_softirq_done,
 	.timeout	= scsi_timeout,
+	.show_rq	= scsi_show_rq,
 	.init_request	= scsi_init_request,
 	.exit_request	= scsi_exit_request,
 	.map_queues	= scsi_map_queues,
-- 
2.12.2
