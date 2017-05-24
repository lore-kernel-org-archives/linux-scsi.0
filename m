From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 27/31] scsi: Consolidate more initialization code
Date: Tue, 23 May 2017 17:34:16 -0700
Message-ID: <20170524003420.5381-28-bart.vanassche@sandisk.com>
References: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170524003420.5381-1-bart.vanassche@sandisk.com>
Sender: linux-block-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

Initialize struct scsi_cmnd.request from inside scsi_initialize_rq()
instead of every time a request is prepared. Note: moving the tag
initialization into scsi_initialize_rq() is not possible because
the single-queue block layer only assigns a tag to a request after
a request has been started.

Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_error.c | 1 -
 drivers/scsi/scsi_lib.c   | 4 +---
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 374dea0885f6..46c51f9f73fa 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2293,7 +2293,6 @@ scsi_ioctl_reset(struct scsi_device *dev, int __user *arg)
 	blk_rq_init(dev->request_queue, rq);
 
 	scmd = (struct scsi_cmnd *)(rq + 1);
-	scmd->request = rq;
 	scmd->cmnd = scsi_req(rq)->cmd;
 
 	scmd->scsi_done		= scsi_reset_provider_done_command;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index f131964ecb51..612bf6c201dc 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1165,6 +1165,7 @@ static void scsi_initialize_rq(struct request *rq)
 	cmd->req.sense = buf;
 	cmd->sense_buffer = buf;
 	cmd->prot_sdb = prot;
+	cmd->request = rq;
 	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
 	cmd->jiffies_at_alloc = jiffies;
 }
@@ -1344,7 +1345,6 @@ static int scsi_prep_fn(struct request_queue *q, struct request *req)
 	}
 
 	cmd->tag = req->tag;
-	cmd->request = req;
 	cmd->prot_op = SCSI_PROT_NORMAL;
 
 	ret = scsi_setup_cmnd(sdev, req);
@@ -1866,8 +1866,6 @@ static int scsi_mq_prep_fn(struct request *req)
 
 	req->special = cmd;
 
-	cmd->request = req;
-
 	cmd->tag = req->tag;
 	cmd->prot_op = SCSI_PROT_NORMAL;
 
-- 
2.12.2
