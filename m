From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH] scsi_debug: write_same: fix error report
Date: Sun, 29 Oct 2017 10:47:19 -0400
Message-ID: <20171029144719.32591-1-dgilbert@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:44778 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751676AbdJ2OsH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 29 Oct 2017 10:48:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hare@suse.de

The scsi_debug driver incorrectly suggests there is an error with
the SCSI WRITE SAME command when the number_of_logical_blocks is
greater than 1. It will also suggest there is an error when NDOB
(no data-out buffer) is set and the number_of_logical_blocks is
greater than 0. Both are valid, fix. 

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 09ba494f8896..92bc5b2d24ae 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3001,11 +3001,11 @@ static int resp_write_same(struct scsi_cmnd *scp, u64 lba, u32 num,
 	if (-1 == ret) {
 		write_unlock_irqrestore(&atomic_rw, iflags);
 		return DID_ERROR << 16;
-	} else if (sdebug_verbose && (ret < (num * sdebug_sector_size)))
+	} else if (sdebug_verbose && !ndob && (ret < sdebug_sector_size))
 		sdev_printk(KERN_INFO, scp->device,
-			    "%s: %s: cdb indicated=%u, IO sent=%d bytes\n",
+			    "%s: %s: lb size=%u, IO sent=%d bytes\n",
 			    my_name, "write same",
-			    num * sdebug_sector_size, ret);
+			    sdebug_sector_size, ret);
 
 	/* Copy first sector to remaining blocks */
 	for (i = 1 ; i < num ; i++)
-- 
2.14.1
