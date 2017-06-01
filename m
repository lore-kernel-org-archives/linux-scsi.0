From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v2 09/12] Make scsi_mq_prep_fn() call scsi_init_command()
Date: Thu, 1 Jun 2017 16:27:08 -0700
Message-ID: <20170601232711.29062-10-bart.vanassche@sandisk.com>
References: <20170601232711.29062-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:52559 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751140AbdFAX1Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Jun 2017 19:27:25 -0400
In-Reply-To: <20170601232711.29062-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>

This patch reduces code duplication. The only functional change in
this patch is that it causes scsi_mq_prep_fn() clear driver-private
command data, just like the already upstream commit 1bad6c4a57ef
("scsi: zero per-cmd private driver data for each MQ I/O").

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_error.c |  2 +-
 drivers/scsi/scsi_lib.c   | 28 +++++++---------------------
 drivers/scsi/scsi_priv.h  |  4 +++-
 3 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index ac3196420435..2e73ef6c1857 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2283,7 +2283,7 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 	blk_rq_init(NULL, rq);
 
 	scmd = (struct scsi_cmnd *)(rq + 1);
-	scsi_init_command(dev, scmd);
+	scsi_init_command(dev, scmd, NULL);
 	scmd->request = rq;
 	scmd->cmnd = scsi_req(rq)->cmd;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 6b4fb48033fb..4041d4c70845 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1152,10 +1152,10 @@ void scsi_del_cmd_from_list(struct scsi_cmnd *cmd)
 	}
 }
 
-void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
+void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd,
+		       struct scsi_data_buffer *prot_sdb)
 {
 	void *buf = cmd->sense_buffer;
-	void *prot = cmd->prot_sdb;
 	unsigned int unchecked_isa_dma = cmd->flags & SCMD_UNCHECKED_ISA_DMA;
 
 	/* zero out the cmd, except for the embedded scsi_request */
@@ -1164,7 +1164,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 
 	cmd->device = dev;
 	cmd->sense_buffer = buf;
-	cmd->prot_sdb = prot;
+	cmd->prot_sdb = prot_sdb;
 	cmd->flags = unchecked_isa_dma;
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 	cmd->jiffies_at_alloc = jiffies;
@@ -1342,7 +1342,7 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
 			goto out;
 		}
 
-		scsi_init_command(sdev, cmd);
+		scsi_init_command(sdev, cmd, cmd->prot_sdb);
 		req->special = cmd;
 	}
 
@@ -1870,36 +1870,22 @@ static int scsi_mq_prep_fn(struct request *req)
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
 	struct scsi_device *sdev = req->q->queuedata;
 	struct Scsi_Host *shost = sdev->host;
-	unsigned char *sense_buf = cmd->sense_buffer;
-	unsigned int unchecked_isa_dma = cmd->flags & SCMD_UNCHECKED_ISA_DMA;
 	struct scatterlist *sg;
 
-	/* zero out the cmd, except for the embedded scsi_request */
-	memset((char *)cmd + sizeof(cmd->req), 0,
-		sizeof(*cmd) - sizeof(cmd->req));
+	sg = (void *)cmd + sizeof(struct scsi_cmnd) + shost->hostt->cmd_size;
+	scsi_init_command(sdev, cmd, scsi_host_get_prot(shost) ?
+			  (void *)sg + scsi_mq_sgl_size(shost) : NULL);
 
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
-	sg = (void *)cmd + sizeof(struct scsi_cmnd) + shost->hostt->cmd_size;
 	cmd->sdb.table.sgl = sg;
 
 	if (scsi_host_get_prot(shost)) {
-		cmd->prot_sdb = (void *)sg + scsi_mq_sgl_size(shost);
 		memset(cmd->prot_sdb, 0, sizeof(struct scsi_data_buffer));
 
 		cmd->prot_sdb->table.sgl =
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index c11c1f9c912c..c43a138423d7 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -8,6 +8,7 @@
 struct request_queue;
 struct request;
 struct scsi_cmnd;
+struct scsi_data_buffer;
 struct scsi_device;
 struct scsi_target;
 struct scsi_host_template;
@@ -30,7 +31,8 @@ extern void scsi_exit_hosts(void);
 /* scsi.c */
 extern bool scsi_use_blk_mq;
 int scsi_init_sense_cache(struct Scsi_Host *shost);
-void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd);
+void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd,
+		       struct scsi_data_buffer *prot_sdb);
 #ifdef CONFIG_SCSI_LOGGING
 void scsi_log_send(struct scsi_cmnd *cmd);
 void scsi_log_completion(struct scsi_cmnd *cmd, int disposition);
-- 
2.12.2
