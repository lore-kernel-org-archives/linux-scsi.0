From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 6/6] scsi: Implement blk_mq_ops.show_rq()
Date: Tue, 11 Apr 2017 13:58:42 -0700
Message-ID: <20170411205842.28137-7-bart.vanassche@sandisk.com>
References: <20170411205842.28137-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:46455 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752951AbdDKU67 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2017 16:58:59 -0400
In-Reply-To: <20170411205842.28137-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Omar Sandoval <osandov@fb.com>, Hannes Reinecke <hare@suse.com>, linux-scsi@vger.kernel.org

Show the SCSI CDB, .eh_eflags and .result for pending SCSI commands
in /sys/kernel/debug/block/*/mq/*/dispatch and */rq_list.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Omar Sandoval <osandov@fb.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: <linux-scsi@vger.kernel.org>
---
 drivers/scsi/scsi_lib.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7bc4513bf4e4..7d3efb8924ee 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2126,6 +2126,32 @@ static void scsi_exit_rq(struct request_queue *q, struct request *rq)
 	scsi_free_sense_buffer(shost, cmd->sense_buffer);
 }
 
+static const char *const ehflag_name[] = {
+	[ilog2(SCSI_EH_CANCEL_CMD)]	 = "CANCEL_CMD",
+	[ilog2(SCSI_EH_ABORT_SCHEDULED)] = "ABORT_SCHEDULED",
+};
+
+static void scsi_show_rq(struct request *rq, char *info, unsigned int info_sz)
+{
+	char *p = info, *const end = info + info_sz;
+	struct scsi_cmnd *cmd = container_of(scsi_req(rq), typeof(*cmd), req);
+	unsigned int i;
+
+	p += scnprintf(p, end - p, ".cmd =");
+	for (i = 0; i < cmd->cmd_len; i++)
+		p += scnprintf(p, end - p, " %02x", cmd->cmnd[i]);
+	p += scnprintf(p, end - p, ", .eh_eflags =");
+	for (i = 0; i < sizeof(cmd->eh_eflags) * BITS_PER_BYTE; i++) {
+		if (!(cmd->eh_eflags & BIT(i)))
+			continue;
+		if (i < ARRAY_SIZE(ehflag_name) && ehflag_name[i])
+			p += scnprintf(p, end - p, " %s", ehflag_name[i]);
+		else
+			p += scnprintf(p, end - p, " %d", i);
+	}
+	p += scnprintf(p, end - p, ", .result = %#06x", cmd->result);
+}
+
 struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 {
 	struct Scsi_Host *shost = sdev->host;
@@ -2158,6 +2184,7 @@ static const struct blk_mq_ops scsi_mq_ops = {
 	.queue_rq	= scsi_queue_rq,
 	.complete	= scsi_softirq_done,
 	.timeout	= scsi_timeout,
+	.show_rq	= scsi_show_rq,
 	.init_request	= scsi_init_request,
 	.exit_request	= scsi_exit_request,
 	.map_queues	= scsi_map_queues,
-- 
2.12.0
