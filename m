From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 4/5] sd: Limit messages for ZBC disks capacity change
Date: Tue, 19 Jul 2016 15:25:09 +0200
Message-ID: <1468934710-93876-5-git-send-email-hare@suse.de>
References: <1468934710-93876-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:60560 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753775AbcGSNZO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Jul 2016 09:25:14 -0400
In-Reply-To: <1468934710-93876-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@hgst.com>

From: Damien Le Moal <damien.lemoal@hgst.com>

For ZBC disks with RC_BASIS=0, limit the message indicating
the capacity adjustment to the disk first scan.

Signed-off-by: Damien Le Moal <damien.lemoal@hgst.com>
---
 drivers/scsi/sd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index f7b6132..3a9d96e 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2128,9 +2128,10 @@ static void sd_read_zones(struct scsi_disk *sdkp, unsigned char *buffer)
 		/* The max_lba field is the capacity of a zoned device */
 		lba = get_unaligned_be64(&buffer[8]);
 		if (lba + 1 > sdkp->capacity) {
-			sd_printk(KERN_WARNING, sdkp,
-				  "Max LBA %zu (capacity %zu)\n",
-				  (sector_t) lba + 1, sdkp->capacity);
+			if (sdkp->first_scan)
+				sd_printk(KERN_WARNING, sdkp,
+					  "Changing capacity from %zu to Max LBA+1 %zu\n",
+					  sdkp->capacity, (sector_t) lba + 1);
 			sdkp->capacity = lba + 1;
 		}
 	}
-- 
1.8.5.6

