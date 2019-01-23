From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH] Fix sense handling in __scsi_execute()
Date: Wed, 23 Jan 2019 14:42:17 -0800
Message-ID: <20190123224217.198935-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, Douglas Gilbert <dgilbert@interlog.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Since blk_execute_rq() no longer allocates a sense buffer and no longer
initializes the sense pointer the callers of blk_execute_rq() have to do
initialize the sense pointer. Hence this patch that initializes rq->sense
and that removes a superfluous memcpy() statement.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: <stable@vger.kernel.org> # v4.11+
Fixes: 82ed4db499b8 ("block: split scsi_request out of struct request")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 4feba3b5aff1..8b9f4b1bca35 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -271,6 +271,7 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	rq->cmd_len = COMMAND_SIZE(cmd[0]);
 	memcpy(rq->cmd, cmd, rq->cmd_len);
 	rq->retries = retries;
+	rq->sense = sense;
 	req->timeout = timeout;
 	req->cmd_flags |= flags;
 	req->rq_flags |= rq_flags | RQF_QUIET;
@@ -291,8 +292,6 @@ int __scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 
 	if (resid)
 		*resid = rq->resid_len;
-	if (sense && rq->sense_len)
-		memcpy(sense, rq->sense, SCSI_SENSE_BUFFERSIZE);
 	if (sshdr)
 		scsi_normalize_sense(rq->sense, rq->sense_len, sshdr);
 	ret = rq->result;
-- 
2.20.1.321.g9e740568ce-goog
