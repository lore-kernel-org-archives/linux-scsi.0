From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 8/8] scsi: Implement blk_mq_ops.show_rq()
Date: Mon, 17 Apr 2017 09:56:51 -0700
Message-ID: <20170417165651.12693-9-bart.vanassche@sandisk.com>
References: <20170417165651.12693-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170417165651.12693-1-bart.vanassche@sandisk.com>
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
 drivers/scsi/scsi_lib.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7bc4513bf4e4..52604573e4b6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2126,6 +2126,31 @@ static void scsi_exit_rq(struct request_queue *q, struct request *rq)
 	scsi_free_sense_buffer(shost, cmd->sense_buffer);
 }
 
+static const char *const ehflag_name[] = {
+	[ilog2(SCSI_EH_CANCEL_CMD)]	 = "CANCEL_CMD",
+	[ilog2(SCSI_EH_ABORT_SCHEDULED)] = "ABORT_SCHEDULED",
+};
+
+static void scsi_show_rq(struct seq_file *m, struct request *rq)
+{
+	struct scsi_cmnd *cmd = container_of(scsi_req(rq), typeof(*cmd), req);
+	unsigned int i;
+
+	seq_puts(m, ", .cmd =");
+	for (i = 0; i < cmd->cmd_len; i++)
+		seq_printf(m, " %02x", cmd->cmnd[i]);
+	seq_puts(m, ", .eh_eflags =");
+	for (i = 0; i < sizeof(cmd->eh_eflags) * BITS_PER_BYTE; i++) {
+		if (!(cmd->eh_eflags & BIT(i)))
+			continue;
+		if (i < ARRAY_SIZE(ehflag_name) && ehflag_name[i])
+			seq_printf(m, " %s", ehflag_name[i]);
+		else
+			seq_printf(m, " %d", i);
+	}
+	seq_printf(m, ", .result = %#06x", cmd->result);
+}
+
 struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -2158,6 +2183,7 @@ static const struct blk_mq_ops scsi_mq_ops = {
 	.queue_rq	= scsi_queue_rq,
 	.complete	= scsi_softirq_done,
 	.timeout	= scsi_timeout,
+	.show_rq	= scsi_show_rq,
 	.init_request	= scsi_init_request,
 	.exit_request	= scsi_exit_request,
 	.map_queues	= scsi_map_queues,
-- 
2.12.2
