From: Long Li <longli@exchange.microsoft.com>
Subject: [PATCH v2] scsi: zero per-cmd private driver data for each MQ I/O
Date: Thu, 18 May 2017 15:40:05 -0700
Message-ID: <1495147205-28778-1-git-send-email-longli@exchange.microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, KY Srinivasan <kys@microsoft.com>, Bart Van Assche <Bart.VanAssche@sandisk.com>, Christoph Hellwig <hch@infradead.org>, Stephen Hemminger <sthemmin@microsoft.com>
Cc: Long Li <longli@microsoft.com>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Long Li <longli@microsoft.com>

In lower layer driver's (LLD) scsi_host_template, the driver may optionally 
ask SCSI to allocate its private driver memory for each command, by 
specifying cmd_size. This memory is allocated at the end of scsi_cmnd by SCSI. 
Later when SCSI queues a command, the LLD can use scsi_cmd_priv to get to its 
private data.
 
Some LLD, e.g. hv_storvsc, doesn't clear its private data before use. In
this case, the LLD may get to stale or uninitialized data in its private 
driver memory. This may result in unexpected driver and hardware behavior.

Fix this problem by also zeroing the private driver memory before passing
them to LLD.

Signed-off-by: Long Li <longli@microsoft.com>
Reviewed-by: Bart Van Assche <Bart.VanAssche@sandisk.com>
Reviewed-by: KY Srinivasan <kys@microsoft.com>
Reviewed-by: Christoph Hellwig <hch@infradead.org>
CC: stable@vger.kernel.org

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
