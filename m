From: damien.lemoal@wdc.com
Subject: [PATCH v2 2/7] sd: Improve sd_completed_bytes
Date: Mon, 24 Apr 2017 16:51:10 +0900
Message-ID: <20170424075115.30337-3-damien.lemoal@wdc.com>
References: <20170424075115.30337-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:12707 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1166215AbdDXHve (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 03:51:34 -0400
In-Reply-To: <20170424075115.30337-1-damien.lemoal@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@wdc.com>

From: Damien Le Moal <damien.lemoal@wdc.com>

Re-shuffle the code to be more efficient by not initializing
variables upfront (i.e. do it only when necessary).
Also replace the do_div calls with calls to sectors_to_logical().

No functional change is introduced by this patch.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/sd.c | 48 ++++++++++++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 22 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ce62d2c..10c7657 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1758,41 +1758,45 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
 
 static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 {
-	u64 start_lba = blk_rq_pos(scmd->request);
-	u64 end_lba = blk_rq_pos(scmd->request) + (scsi_bufflen(scmd) / 512);
-	u64 factor = scmd->device->sector_size / 512;
-	u64 bad_lba;
-	int info_valid;
+	struct request *req = scmd->request;
+	struct scsi_device *sdev = scmd->device;
+	unsigned int transferred, good_bytes;
+	u64 start_lba, end_lba, bad_lba;
+
 	/*
-	 * resid is optional but mostly filled in.  When it's unused,
-	 * its value is zero, so we assume the whole buffer transferred
+	 * Some commands have a payload smaller than the device logical
+	 * block size (e.g. INQUIRY on a 4K disk).
 	 */
-	unsigned int transferred = scsi_bufflen(scmd) - scsi_get_resid(scmd);
-	unsigned int good_bytes;
-
-	info_valid = scsi_get_sense_info_fld(scmd->sense_buffer,
-					     SCSI_SENSE_BUFFERSIZE,
-					     &bad_lba);
-	if (!info_valid)
+	if (scsi_bufflen(scmd) <= sdev->sector_size)
 		return 0;
 
-	if (scsi_bufflen(scmd) <= scmd->device->sector_size)
+	/* Check if we have a 'bad_lba' information */
+	if (!scsi_get_sense_info_fld(scmd->sense_buffer,
+				     SCSI_SENSE_BUFFERSIZE,
+				     &bad_lba))
 		return 0;
 
-	/* be careful ... don't want any overflows */
-	do_div(start_lba, factor);
-	do_div(end_lba, factor);
-
-	/* The bad lba was reported incorrectly, we have no idea where
+	/*
+	 * If the bad lba was reported incorrectly, we have no idea where
 	 * the error is.
 	 */
-	if (bad_lba < start_lba  || bad_lba >= end_lba)
+	start_lba = sectors_to_logical(sdev, blk_rq_pos(req));
+	end_lba = sectors_to_logical(sdev,
+				blk_rq_pos(req) + (scsi_bufflen(scmd) >> 9));
+	if (bad_lba < start_lba || bad_lba >= end_lba)
 		return 0;
 
+	/*
+	 * resid is optional but mostly filled in.  When it's unused,
+	 * its value is zero, so we assume the whole buffer transferred
+	 */
+	transferred = scsi_bufflen(scmd) - scsi_get_resid(scmd);
+
 	/* This computation should always be done in terms of
 	 * the resolution of the device's medium.
 	 */
-	good_bytes = (bad_lba - start_lba) * scmd->device->sector_size;
+	good_bytes = logical_to_bytes(sdev, bad_lba - start_lba);
+
 	return min(good_bytes, transferred);
 }
 
-- 
2.9.3
