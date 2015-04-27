From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] sd: Fixup capacity for standby ports
Date: Mon, 27 Apr 2015 11:35:22 +0200
Message-ID: <1430127322-90474-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932122AbbD0JfY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Apr 2015 05:35:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

If a target port is in ALUA 'standby' state it does not need
to respond to a 'READ CAPACITY' command. So fixup the initialization
for these cases.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 7178b05..62065a6 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1992,6 +1992,11 @@ static int read_capacity_16(struct scsi_disk *sdkp, struct scsi_device *sdp,
 			    sshdr.asc == 0x04 && sshdr.ascq == 0x0A)
 				/* ALUA state transition; always retry */
 				continue;
+			if (sense_valid &&
+			    sshdr.sense_key == NOT_READY &&
+			    sshdr.asc == 0x04 && sshdr.ascq == 0x0B)
+				/* Target port in standy state */
+				return 0;
 		}
 		retries--;
 
@@ -2079,6 +2084,11 @@ static int read_capacity_10(struct scsi_disk *sdkp, struct scsi_device *sdp,
 			    sshdr.asc == 0x04 && sshdr.ascq == 0x0A)
 				/* ALUA state transition; always retry */
 				continue;
+			if (sense_valid &&
+			    sshdr.sense_key == NOT_READY &&
+			    sshdr.asc == 0x04 && sshdr.ascq == 0x0B)
+				/* Target port in standy state */
+				return 0;
 		}
 		retries--;
 
@@ -2193,6 +2203,8 @@ got_data:
 		sector_size = 512;
 		sd_printk(KERN_NOTICE, sdkp, "Sector size 0 reported, "
 			  "assuming 512.\n");
+		if (!sdkp->physical_block_size)
+			sdkp->physical_block_size = sector_size;
 	}
 
 	if (sector_size != 512 &&
-- 
1.8.5.2

