From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 09/12] Make scsi_mq_prep_fn() call scsi_init_command()
Date: Fri, 2 Jun 2017 14:22:00 -0700
Message-ID: <20170602212203.30401-10-bart.vanassche@sandisk.com>
References: <20170602212203.30401-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:58224 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751061AbdFBVWU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jun 2017 17:22:20 -0400
In-Reply-To: <20170602212203.30401-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

This patch reduces code duplication. There are two functional changes
in this patch:
- It causes scsi_mq_prep_fn() to clear driver-private
  command data, just like the already upstream commit 1bad6c4a57ef
  ("scsi: zero per-cmd private driver data for each MQ I/O").
- The initialization of .prot_sdb is moved from scsi_mq_prep_fn()
  into scsi_init_request().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_lib.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6b4fb48033fb..ef4e33319407 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1870,36 +1870,21 @@ static int scsi_mq_prep_fn(struct request *req)
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 	struct scsi_device *sdev = req->q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
-	unsigned char *sense_buf = cmd->sense_buffer;
-	unsigned int unchecked_isa_dma = cmd->flags & SCMD_UNCHECKED_ISA_DMA;
 	struct scatterlist *sg;
 
-	/* zero out the cmd, except for the embedded scsi_request */
-	memset((char *)cmd + sizeof(cmd->req), 0,
-		sizeof(*cmd) - sizeof(cmd->req));
+	scsi_init_command(sdev, cmd);
 
 	req->special = cmd;
 
 	cmd->request = req;
-	cmd->device = sdev;
-	cmd->sense_buffer = sense_buf;
-	cmd->flags = unchecked_isa_dma;
 
 	cmd->tag = req->tag;
-
 	cmd->prot_op = SCSI_PROT_NORMAL;
 
-	INIT_LIST_HEAD(&cmd->list);
-	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
-	cmd->jiffies_at_alloc = jiffies;
-
-	scsi_add_cmd_to_list(cmd);
-
 	sg = (void *)cmd + sizeof(struct scsi_cmnd) + shost->hostt->cmd_size;
 	cmd->sdb.table.sgl = sg;
 
 	if (scsi_host_get_prot(shost)) {
-		cmd->prot_sdb = (void *)sg + scsi_mq_sgl_size(shost);
 		memset(cmd->prot_sdb, 0, sizeof(struct scsi_data_buffer));
 
 		cmd->prot_sdb->table.sgl =
@@ -2025,6 +2010,7 @@ static int scsi_init_request(struct blk_mq_tag_set *set, struct request *rq,
 	struct Scsi_Host *shost = set->driver_data;
 	const bool unchecked_isa_dma = shost->unchecked_isa_dma;
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(rq);
+	struct scatterlist *sg;
 
 	if (unchecked_isa_dma)
 		cmd->flags |= SCMD_UNCHECKED_ISA_DMA;
@@ -2033,6 +2019,13 @@ static int scsi_init_request(struct blk_mq_tag_set *set, struct request *rq,
 	if (!cmd->sense_buffer)
 		return -ENOMEM;
 	cmd->req.sense = cmd->sense_buffer;
+
+	if (scsi_host_get_prot(shost)) {
+		sg = (void *)cmd + sizeof(struct scsi_cmnd) +
+			shost->hostt->cmd_size;
+		cmd->prot_sdb = (void *)sg + scsi_mq_sgl_size(shost);
+	}
+
 	return 0;
 }
 
-- 
2.12.2
