From: Shaun Tancheff <shaun@tancheff.com>
Subject: [PATCH] Update WRITE_SAME timeout in sd_setup_discard_cmnd
Date: Thu, 11 Aug 2016 15:12:38 -0500
Message-ID: <1470946358-6744-1-git-send-email-shaun@tancheff.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Shaun Tancheff <shaun@tancheff.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Josh Bingaman <josh.bingaman@seagate.com>, Shaun Tancheff <shaun.tancheff@seagate.com>
List-Id: linux-scsi@vger.kernel.org

In sd_setup_discard_cmnd() there are a some discard
methods that fall back to using WRITE_SAME. It
appears that those paths using WRITE_SAME should
also use the SD_WRITE_SAME_TIMEOUT instead of the
default SD_TIMEOUT.

Signed-off-by: Shaun Tancheff <shaun.tancheff@seagate.com>
---
I don't have a use case that breaks the current code.
It just seems to me that setups for discard and
write same should be consistent.
---
 drivers/scsi/sd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d3e852a..3c15f3a 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -722,6 +722,8 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 	if (!page)
 		return BLKPREP_DEFER;
 
+	rq->timeout = SD_TIMEOUT;
+
 	switch (sdkp->provisioning_mode) {
 	case SD_LBP_UNMAP:
 		buf = page_address(page);
@@ -746,6 +748,7 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 		put_unaligned_be32(nr_sectors, &cmd->cmnd[10]);
 
 		len = sdkp->device->sector_size;
+		rq->timeout = SD_WRITE_SAME_TIMEOUT;
 		break;
 
 	case SD_LBP_WS10:
@@ -758,6 +761,7 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 		put_unaligned_be16(nr_sectors, &cmd->cmnd[7]);
 
 		len = sdkp->device->sector_size;
+		rq->timeout = SD_WRITE_SAME_TIMEOUT;
 		break;
 
 	default:
@@ -766,8 +770,6 @@ static int sd_setup_discard_cmnd(struct scsi_cmnd *cmd)
 	}
 
 	rq->completion_data = page;
-	rq->timeout = SD_TIMEOUT;
-
 	cmd->transfersize = len;
 	cmd->allowed = SD_MAX_RETRIES;
 
-- 
2.8.1
