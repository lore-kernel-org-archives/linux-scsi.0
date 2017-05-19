From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 16/18] scsi-mq: Make behavior scsi_mq_prep_fn() closer to that of scsi_prep_fn()
Date: Fri, 19 May 2017 11:30:14 -0700
Message-ID: <20170519183016.12646-17-bart.vanassche@sandisk.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:34979 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755623AbdESSaZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 14:30:25 -0400
In-Reply-To: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>

Instead of clearing most of struct scsi_cmnd and reinitializing
it, rely on scsi_initialize_rq() for initialization of struct
scsi_cmnd. This patch fixes a bug, namely that it avoids that
jiffies_at_alloc gets overwritten if a request is requeued.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_lib.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 791bae192bfb..e0c4481cb943 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1861,27 +1861,15 @@ static int scsi_mq_prep_fn(struct request *req)
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 	struct scsi_device *sdev = req->q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
-	unsigned char *sense_buf = cmd->sense_buffer;
 	struct scatterlist *sg;
 
-	/* zero out the cmd, except for the embedded scsi_request */
-	memset((char *)cmd + sizeof(cmd->req), 0,
-		sizeof(*cmd) - sizeof(cmd->req) + shost->hostt->cmd_size);
-
 	req->special = cmd;
 
 	cmd->request = req;
-	cmd->device = sdev;
-	cmd->sense_buffer = sense_buf;
 
 	cmd->tag = req->tag;
-
 	cmd->prot_op = SCSI_PROT_NORMAL;
 
-	INIT_LIST_HEAD(&cmd->list);
-	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
-	cmd->jiffies_at_alloc = jiffies;
-
 	scsi_add_cmd_to_list(cmd);
 
 	sg = (void *)cmd + sizeof(struct scsi_cmnd) + shost->hostt->cmd_size;
-- 
2.12.2
