From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 17/18] scsi: Consolidate more initialization code
Date: Fri, 19 May 2017 11:30:15 -0700
Message-ID: <20170519183016.12646-18-bart.vanassche@sandisk.com>
References: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:60868 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755705AbdESSaZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 May 2017 14:30:25 -0400
In-Reply-To: <20170519183016.12646-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.com>

Initialize struct scsi_cmnd.request from inside scsi_initialize_rq()
instead of every time a request is prepared. Note: moving the tag
initialization into scsi_initialize_rq() is not possible because
the single-queue block layer only assigns a tag to a request after
a request has been started.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_error.c | 1 -
 drivers/scsi/scsi_lib.c   | 4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 2b7221bc0f32..7c2aba4b167a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2293,7 +2293,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 	blk_rq_init(dev->request_queue, rq);
 
 	scmd = (struct scsi_cmnd *)(rq + 1);
-	scmd->request = rq;
 	scmd->cmnd = scsi_req(rq)->cmd;
 
 	scmd->scsi_done		= scsi_reset_provider_done_command;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e0c4481cb943..5431d114c897 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1166,6 +1166,7 @@ static void scsi_initialize_rq(struct request *rq)
 	cmd->device = dev;
 	cmd->sense_buffer = buf;
 	cmd->prot_sdb = prot;
+	cmd->request = rq;
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 	cmd->jiffies_at_alloc = jiffies;
 }
@@ -1345,7 +1346,6 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
 	}
 
 	cmd->tag = req->tag;
-	cmd->request = req;
 	cmd->prot_op = SCSI_PROT_NORMAL;
 
 	ret = scsi_setup_cmnd(sdev, req);
@@ -1865,8 +1865,6 @@ static int scsi_mq_prep_fn(struct request *req)
 
 	req->special = cmd;
 
-	cmd->request = req;
-
 	cmd->tag = req->tag;
 	cmd->prot_op = SCSI_PROT_NORMAL;
 
-- 
2.12.2
