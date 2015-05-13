From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] sd: Disable support for 256 byte/sector disks
Date: Wed, 13 May 2015 10:49:09 +0200
Message-ID: <1431506949-11398-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:33890 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754515AbbEMItN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2015 04:49:13 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mark Hounschell <dmarkh@cfl.rr.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>

256 bytes per sector support has been broken since 2.6.X,
and no-one stepped up to fix this.
So disable support for it.

Signed-off-by: Mark Hounschell <dmarkh@cfl.rr.com>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 79beebf..7f9d65f 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1600,6 +1600,7 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 {
 	u64 start_lba = blk_rq_pos(scmd->request);
 	u64 end_lba = blk_rq_pos(scmd->request) + (scsi_bufflen(scmd) / 512);
+	u64 factor = scmd->device->sector_size / 512;
 	u64 bad_lba;
 	int info_valid;
 	/*
@@ -1621,16 +1622,9 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
 	if (scsi_bufflen(scmd) <= scmd->device->sector_size)
 		return 0;
 
-	if (scmd->device->sector_size < 512) {
-		/* only legitimate sector_size here is 256 */
-		start_lba <<= 1;
-		end_lba <<= 1;
-	} else {
-		/* be careful ... don't want any overflows */
-		unsigned int factor = scmd->device->sector_size / 512;
-		do_div(start_lba, factor);
-		do_div(end_lba, factor);
-	}
+	/* be careful ... don't want any overflows */
+	do_div(start_lba, factor);
+	do_div(end_lba, factor);
 
 	/* The bad lba was reported incorrectly, we have no idea where
 	 * the error is.
@@ -2188,8 +2182,7 @@ got_data:
 	if (sector_size != 512 &&
 	    sector_size != 1024 &&
 	    sector_size != 2048 &&
-	    sector_size != 4096 &&
-	    sector_size != 256) {
+	    sector_size != 4096) {
 		sd_printk(KERN_NOTICE, sdkp, "Unsupported sector size %d.\n",
 			  sector_size);
 		/*
@@ -2244,8 +2237,6 @@ got_data:
 		sdkp->capacity <<= 2;
 	else if (sector_size == 1024)
 		sdkp->capacity <<= 1;
-	else if (sector_size == 256)
-		sdkp->capacity >>= 1;
 
 	blk_queue_physical_block_size(sdp->request_queue,
 				      sdkp->physical_block_size);
-- 
1.8.5.2

