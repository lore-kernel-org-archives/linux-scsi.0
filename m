From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 07/20] scsi: do not decode sense extras
Date: Wed,  3 Sep 2014 12:06:02 +0200
Message-ID: <1409738775-80876-8-git-send-email-hare@suse.de>
References: <1409738775-80876-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:59654 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932358AbaICKG1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Sep 2014 06:06:27 -0400
In-Reply-To: <1409738775-80876-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <jbottomley@parallels.com>, Ewan Milne <emilne@redhat.com>, Yoshihiro Yunomae <yoshihiro.yunomae.ez@hitachi.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Currently we're only decoding sense extras for tape devices.
And even there only for fixed format sense formats.
As this is of rather limited use in the general case we should
be stop trying to decode sense extras; the tape driver does
its own decoding anyway.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c | 62 ------------------------------------------------
 1 file changed, 62 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 7febdb7..2850062e 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1444,67 +1444,6 @@ scsi_dump_sense_buffer(struct scsi_device *sdev, const char *name,
 	}
 }
 
-static void
-scsi_decode_sense_extras(const unsigned char *sense_buffer, int sense_len,
-			 struct scsi_sense_hdr *sshdr)
-{
-	int k, num, res;
-
-	if (sshdr->response_code < 0x72)
-	{
-		/* only decode extras for "fixed" format now */
-		char buff[80];
-		int blen, fixed_valid;
-		unsigned int info;
-
-		fixed_valid = sense_buffer[0] & 0x80;
-		info = ((sense_buffer[3] << 24) | (sense_buffer[4] << 16) |
-			(sense_buffer[5] << 8) | sense_buffer[6]);
-		res = 0;
-		memset(buff, 0, sizeof(buff));
-		blen = sizeof(buff) - 1;
-		if (fixed_valid)
-			res += snprintf(buff + res, blen - res,
-					"Info fld=0x%x", info);
-		if (sense_buffer[2] & 0x80) {
-			/* current command has read a filemark */
-			if (res > 0)
-				res += snprintf(buff + res, blen - res, ", ");
-			res += snprintf(buff + res, blen - res, "FMK");
-		}
-		if (sense_buffer[2] & 0x40) {
-			/* end-of-medium condition exists */
-			if (res > 0)
-				res += snprintf(buff + res, blen - res, ", ");
-			res += snprintf(buff + res, blen - res, "EOM");
-		}
-		if (sense_buffer[2] & 0x20) {
-			/* incorrect block length requested */
-			if (res > 0)
-				res += snprintf(buff + res, blen - res, ", ");
-			res += snprintf(buff + res, blen - res, "ILI");
-		}
-		if (res > 0)
-			printk("%s\n", buff);
-	} else if (sshdr->additional_length > 0) {
-		/* descriptor format with sense descriptors */
-		num = 8 + sshdr->additional_length;
-		num = (sense_len < num) ? sense_len : num;
-		printk("Descriptor sense data with sense descriptors "
-		       "(in hex):");
-		for (k = 0; k < num; ++k) {
-			if (0 == (k % 16)) {
-				printk("\n");
-				printk(KERN_INFO "        ");
-			}
-			printk("%02x ", sense_buffer[k]);
-		}
-
-		printk("\n");
-	}
-
-}
-
 /* Normalize and print sense buffer with name prefix */
 void __scsi_print_sense(struct scsi_device *sdev, const char *name,
 			const unsigned char *sense_buffer, int sense_len)
@@ -1516,7 +1455,6 @@ void __scsi_print_sense(struct scsi_device *sdev, const char *name,
 		return;
 	}
 	scsi_show_sense_hdr(sdev, name, &sshdr);
-	scsi_decode_sense_extras(sense_buffer, sense_len, &sshdr);
 	scsi_show_extd_sense(sdev, name, sshdr.asc, sshdr.ascq);
 }
 EXPORT_SYMBOL(__scsi_print_sense);
-- 
1.8.5.2

