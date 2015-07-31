From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi: Fixup fixed sense generation
Date: Fri, 31 Jul 2015 15:05:03 +0200
Message-ID: <1438347903-106697-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbbGaNFG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Jul 2015 09:05:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <james.bottomley@hansenpartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Fixed sense reserves only 32 bits for the 'information' field,
so we need to restrict the 'information' value to avoid sense
data corruption.
Also the sense key is only 4 bits.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_error.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 106884a..ba7ffc4 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2510,13 +2510,13 @@ void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq)
 {
 	if (desc) {
 		buf[0] = 0x72;	/* descriptor, current */
-		buf[1] = key;
+		buf[1] = key & 0x0f;
 		buf[2] = asc;
 		buf[3] = ascq;
 		buf[7] = 0;
 	} else {
 		buf[0] = 0x70;	/* fixed, current */
-		buf[2] = key;
+		buf[2] = key & 0x0f;
 		buf[7] = 0xa;
 		buf[12] = asc;
 		buf[13] = ascq;
@@ -2549,7 +2549,11 @@ void scsi_set_sense_information(u8 *buf, u64 info)
 		put_unaligned_be64(info, &ucp[4]);
 	} else if ((buf[0] & 0x7f) == 0x70) {
 		buf[0] |= 0x80;
-		put_unaligned_be64(info, &buf[3]);
+		/*
+		 * Fixed format sense reserves only 32 bits for the
+		 * 'information' field
+		 */
+		put_unaligned_be32((u32)info, &buf[3]);
 	}
 }
 EXPORT_SYMBOL(scsi_set_sense_information);
-- 
1.8.5.2

