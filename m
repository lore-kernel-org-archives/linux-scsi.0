From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 22/31] scsi: Inline scsi_init_command()
Date: Tue, 23 May 2017 17:34:11 -0700
Message-ID: <20170524003420.5381-23-bart.vanassche@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:5764 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759591AbdEXAe4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2017 20:34:56 -0400
In-Reply-To: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>

The two drivers that use the per-device command list, namely aacraid
and dpt_i2o, expect that that list contains only SCSI commands and
no task management functions. Hence only call scsi_add_cmd_to_list()
from the block layer prep callback functions and not from
scsi_ioctl_reset().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_error.c |  1 -
 drivers/scsi/scsi_lib.c   | 10 ++--------
 drivers/scsi/scsi_priv.h  |  1 -
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index e2e614e990a8..374dea0885f6 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2293,7 +2293,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 	blk_rq_init(dev->request_queue, rq);
 
 	scmd = (struct scsi_cmnd *)(rq + 1);
-	scsi_init_command(dev, scmd);
 	scmd->request = rq;
 	scmd->cmnd = scsi_req(rq)->cmd;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index d2e6b4c14e35..359f824ab78c 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1170,13 +1170,6 @@ static void scsi_initialize_rq(struct request *rq)
 	cmd->jiffies_at_alloc = jiffies;
 }
 
-/* Called after a request has been started. */
-void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
-{
-	memset(scsi_cmd_priv(cmd), 0, dev->host->hostt->cmd_size);
-	scsi_add_cmd_to_list(cmd);
-}
-
 static int scsi_setup_scsi_cmnd(struct scsi_device *sdev, struct request *req)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
@@ -1347,7 +1340,8 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
 			goto out;
 		}
 
-		scsi_init_command(sdev, cmd);
+		memset(scsi_cmd_priv(cmd), 0, dev->host->hostt->cmd_size);
+		scsi_add_cmd_to_list(cmd);
 		req->special = cmd;
 	}
 
diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
index c11c1f9c912c..67d1550d8b64 100644
--- a/drivers/scsi/scsi_priv.h
+++ b/drivers/scsi/scsi_priv.h
@@ -30,7 +30,6 @@ extern void scsi_exit_hosts(void);
 /* scsi.c */
 extern bool scsi_use_blk_mq;
 int scsi_init_sense_cache(struct Scsi_Host *shost);
-void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd);
 #ifdef CONFIG_SCSI_LOGGING
 void scsi_log_send(struct scsi_cmnd *cmd);
 void scsi_log_completion(struct scsi_cmnd *cmd, int disposition);
-- 
2.12.2
