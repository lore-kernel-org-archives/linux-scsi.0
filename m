From: damien.lemoal@wdc.com
Subject: [PATCH 3/9] sd: Remove unecessary variable in sd_done()
Date: Fri, 21 Apr 2017 18:16:43 +0900
Message-ID: <20170421091649.25287-4-damien.lemoal@wdc.com>
References: <20170421091649.25287-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:8014 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1037297AbdDUJRW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 05:17:22 -0400
In-Reply-To: <20170421091649.25287-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@wdc.com>

From: Damien Le Moal <damien.lemoal@wdc.com>

The 'sense_deferred' variable in sd_done() is set only if
'sense_valid' is true. So it is not necessary and the result of
scsi_sense_is_deferred() and of scsi_command_normalize_sense() can
be combined together in 'sense_valid'.

Also, since scsi_command_normalize_sense() returns a bool, use that
type for 'sense_valid' declaration.

No functional change is introduced by this patch.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 935ce34..c57084e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1808,8 +1808,7 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 	struct scsi_sense_hdr sshdr;
 	struct scsi_disk *sdkp = scsi_disk(SCpnt->request->rq_disk);
 	struct request *req = SCpnt->request;
-	int sense_valid = 0;
-	int sense_deferred = 0;
+	bool sense_valid = false;
 	unsigned char op = SCpnt->cmnd[0];
 	unsigned char unmap = SCpnt->cmnd[1] & 8;
 
@@ -1837,15 +1836,12 @@ static int sd_done(struct scsi_cmnd *SCpnt)
 		break;
 	}
 
-	if (result) {
-		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
-		if (sense_valid)
-			sense_deferred = scsi_sense_is_deferred(&sshdr);
-	}
+	if (result)
+		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr) &&
+			!scsi_sense_is_deferred(&sshdr);
 	sdkp->medium_access_timed_out = 0;
 
-	if (driver_byte(result) != DRIVER_SENSE &&
-	    (!sense_valid || sense_deferred))
+	if (driver_byte(result) != DRIVER_SENSE && !sense_valid)
 		goto out;
 
 	switch (sshdr.sense_key) {
-- 
2.9.3
