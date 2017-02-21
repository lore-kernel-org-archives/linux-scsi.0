From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] scsi: zero per-cmd driver data before each I/O
Date: Tue, 21 Feb 2017 10:04:55 +0100
Message-ID: <20170221090455.4633-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, martin.petersen@oracle.com
Cc: decui@microsoft.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Without this drivers that don't clear the state themselves can see off
effects.  For example Hyper-V VMs using the storvsc driver will often
hang during boot due to uncleared Test Unit Ready failures.

Fixes: e9c787e6 ("scsi: allocate scsi_cmnd structures as part of struct request")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reported-by: Dexuan Cui <decui@microsoft.com>
Tested-by: Dexuan Cui <decui@microsoft.com>
---

Changes since V1:
 - use a single memset as suggested by Bart

 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 90f65c8f487a..1d87a809944d 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1166,7 +1166,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
 
 	/* zero out the cmd, except for the embedded scsi_request */
 	memset((char *)cmd + sizeof(cmd->req), 0,
-		sizeof(*cmd) - sizeof(cmd->req));
+		sizeof(*cmd) - sizeof(cmd->req) + dev->host->hostt->cmd_size);
 
 	cmd->device = dev;
 	cmd->sense_buffer = buf;
-- 
2.11.0
