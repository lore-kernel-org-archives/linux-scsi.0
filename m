From: Long Li <longli@exchange.microsoft.com>
Subject: [PATCH] scsi: zero per-cmd driver data for each MQ I/O
Date: Wed, 10 May 2017 14:07:23 -0700
Message-ID: <1494450443-2921-1-git-send-email-longli@exchange.microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Long Li <longli@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

Lower layer driver may not initialize private data before use. Zero them
out to prevent use of stale data.

Signed-off-by: Long Li <longli@microsoft.com>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 19125d7..a821593 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1850,7 +1850,7 @@ static int scsi_mq_prep_fn(struct request *req)
 
 	/* zero out the cmd, except for the embedded scsi_request */
 	memset((char *)cmd + sizeof(cmd->req), 0,
-		sizeof(*cmd) - sizeof(cmd->req));
+		sizeof(*cmd) - sizeof(cmd->req) + shost->hostt->cmd_size);
 
 	req->special = cmd;
 
-- 
2.7.4
