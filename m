From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 12/18] scsi: Inline scsi_init_command()
Date: Fri, 19 May 2017 11:30:10 -0700
Message-ID: <20170519183016.12646-13-bart.vanassche@sandisk.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:58563 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755046AbdESSaa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 14:30:30 -0400
In-Reply-To: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>

The two drivers that use the per-device command list, namely aacraid
and dpt_i2o, expect that that list contains only SCSI commands and
no task management functions. Hence only call scsi_add_cmd_to_list()
from the block layer prep callback functions and not from
scsi_ioctl_reset().

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_error.c | 1 -
 drivers/scsi/scsi_lib.c   | 8 +-------
 drivers/scsi/scsi_priv.h  | 1 -
 3 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index fbbdc345be85..2b7221bc0f32 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2293,7 +2293,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 	blk_rq_init(dev->request_queue, rq);
 
 	scmd = (struct scsi_cmnd *)(rq + 1);
-	scsi_init_command(dev, scmd);
 	scmd->request = rq;
 	scmd->cmnd = scsi_req(rq)->cmd;
 
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 68ce053b184b..b2e3dc22ecf3 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1171,12 +1171,6 @@ static void scsi_initialize_rq(struct request *rq)
 	cmd->jiffies_at_alloc = jiffies;
 }
 
-/* Called after a request has been started. */
-void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
-{
-	scsi_add_cmd_to_list(cmd);
-}
-
 static int scsi_setup_scsi_cmnd(struct scsi_device *sdev, struct request *req)
 {
 	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
@@ -1347,8 +1341,8 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
 			goto out;
 		}
 
-		scsi_init_command(sdev, cmd);
 		req->special = cmd;
+		scsi_add_cmd_to_list(cmd);
 	}
 
 	cmd->tag = req->tag;
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
