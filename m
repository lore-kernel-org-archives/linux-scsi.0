From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 1/3] sd: Fixup capacity for ALUA standby or transitioning ports
Date: Wed,  8 Jul 2015 09:41:06 +0200
Message-ID: <1436341268-91432-2-git-send-email-hare@suse.de>
References: <1436341268-91432-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58801 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934297AbbGHHlM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 03:41:12 -0400
In-Reply-To: <1436341268-91432-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Bart van Assche <bart.vanassche@sandisk.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

If a target port is in ALUA 'standby' or 'transitioning' state it
might not need to respond to a 'READ CAPACITY' command. So fixup
the initialization for these cases.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3b2fcb4..03fdfa9 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1981,6 +1981,16 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 				 * give it one more chance */
 				if (--reset_retries > 0)
 					continue;
+			if (sense_valid &&
+			    sshdr.sense_key == NOT_READY &&
+			    sshdr.asc == 0x04 && sshdr.ascq == 0x0a)
+				/* Target port in transition */
+				return 0;
+			if (sense_valid &&
+			    sshdr.sense_key == NOT_READY &&
+			    sshdr.asc == 0x04 && sshdr.ascq == 0x0b)
+				/* Target port in standy state */
+				return 0;
 		}
 		retries--;
 
@@ -2063,6 +2073,16 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 				 * give it one more chance */
 				if (--reset_retries > 0)
 					continue;
+			if (sense_valid &&
+			    sshdr.sense_key == NOT_READY &&
+			    sshdr.asc == 0x04 && sshdr.ascq == 0x0a)
+				/* Target port in transition */
+				return 0;
+			if (sense_valid &&
+			    sshdr.sense_key == NOT_READY &&
+			    sshdr.asc == 0x04 && sshdr.ascq == 0x0b)
+				/* Target port in standy state */
+				return 0;
 		}
 		retries--;
 
@@ -2177,6 +2197,8 @@ got_data:
 		sector_size = 512;
 		sd_printk(KERN_NOTICE, sdkp, "Sector size 0 reported, "
 			  "assuming 512.\n");
+		if (!sdkp->physical_block_size)
+			sdkp->physical_block_size = sector_size;
 	}
 
 	if (sector_size != 512 &&
-- 
1.8.5.2

