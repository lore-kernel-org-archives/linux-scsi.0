From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 09/10] scsi: decode descriptor sense
Date: Fri, 12 Oct 2012 10:33:49 +0200
Message-ID: <1350030830-25614-10-git-send-email-hare@suse.de>
References: <1350030830-25614-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34583 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933529Ab2JLIeB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Oct 2012 04:34:01 -0400
In-Reply-To: <1350030830-25614-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Kay Sievers <kay@vrfy.org>

Decode descriptor sense buffer to provide the same information as
we are already getting from fixed format sense.

Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/constants.c  |   79 +++++++++++++++------------------------------
 drivers/scsi/scsi_error.c |   43 +++++++++++++++++++++++-
 include/scsi/scsi_eh.h    |    8 +++-
 3 files changed, 73 insertions(+), 57 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 8bf2616..df69ba3 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -1376,61 +1376,34 @@ static void
 scsi_decode_sense_extras(const unsigned char *sense_buffer, int sense_len,
 			 struct scsi_sense_hdr *sshdr)
 {
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
+	int res = 0;
+	char buff[80];
+	int blen = sense_len;
 
-		printk("\n");
-	}
+	if (sshdr->info)
+		res += snprintf(buff + res, blen - res,
+				"Info fld=0x%llx", sshdr->info);
 
+	if (sshdr->flags & SCSI_SENSE_FLAG_FMK) {
+		/* current command has read a filemark */
+		if (res > 0)
+			res += snprintf(buff + res, blen - res, ", ");
+		res += snprintf(buff + res, blen - res, "FMK");
+	}
+	if (sshdr->flags & SCSI_SENSE_FLAG_EOM) {
+		/* end-of-medium condition exists */
+		if (res > 0)
+			res += snprintf(buff + res, blen - res, ", ");
+		res += snprintf(buff + res, blen - res, "EOM");
+	}
+	if (sshdr->flags & SCSI_SENSE_FLAG_ILI) {
+		/* incorrect block length requested */
+		if (res > 0)
+			res += snprintf(buff + res, blen - res, ", ");
+		res += snprintf(buff + res, blen - res, "ILI");
+	}
+	if (res > 0)
+		pr_info("%s\n", buff);
 }
 
 /* Normalize and print sense buffer with name prefix */
diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f8d51c5..e8ff276 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -2086,7 +2086,7 @@ EXPORT_SYMBOL(scsi_reset_provider);
  *	1 if valid sense data information found, else 0;
  */
 int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
-                         struct scsi_sense_hdr *sshdr)
+			 struct scsi_sense_hdr *sshdr)
 {
 	if (!sense_buffer || !sb_len)
 		return 0;
@@ -2099,6 +2099,9 @@ int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 		return 0;
 
 	if (sshdr->response_code >= 0x72) {
+		int i;
+		const char *sdesc;
+
 		/*
 		 * descriptor format
 		 */
@@ -2110,19 +2113,55 @@ int scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 			sshdr->ascq = sense_buffer[3];
 		if (sb_len > 7)
 			sshdr->additional_length = sense_buffer[7];
+		i = 0;
+		while ((i < sshdr->additional_length) && (i + 8 < sb_len)) {
+			sdesc = &sense_buffer[i + 8];
+			switch (sdesc[0]) {
+			case 0: /* Information */
+				if (!(sdesc[2] & 0x80))
+					break;
+				sshdr->info = (u64)sdesc[4] << 56 |
+					(u64)sdesc[5] << 48 |
+					(u64)sdesc[6] << 40 |
+					(u64)sdesc[7] << 32 |
+					(u64)sdesc[8] << 24 |
+					(u64)sdesc[9] << 16 |
+					(u64)sdesc[10] << 8 |
+					(u64)sdesc[11];
+				break;
+			case 3: /* Field replaceable unit */
+				sshdr->fru = sdesc[3];
+				break;
+			case 4: /* Stream commands */
+				sshdr->flags = sdesc[3] >> 4;
+				break;
+			case 5: /* Block commands */
+				sshdr->flags = sdesc[3] >> 4;
+			}
+			i += sdesc[1];
+		}
 	} else {
 		/*
 		 * fixed format
 		 */
-		if (sb_len > 2)
+		if (sb_len > 2) {
 			sshdr->sense_key = (sense_buffer[2] & 0xf);
+			sshdr->flags = (sense_buffer[2] >> 4);
+		}
 		if (sb_len > 7) {
+			if (sense_buffer[0] & 0x80)
+				sshdr->info = ((sense_buffer[3] << 24) |
+					       (sense_buffer[4] << 16) |
+					       (sense_buffer[5] << 8) |
+					       sense_buffer[6]);
 			sb_len = (sb_len < (sense_buffer[7] + 8)) ?
 					 sb_len : (sense_buffer[7] + 8);
 			if (sb_len > 12)
 				sshdr->asc = sense_buffer[12];
 			if (sb_len > 13)
 				sshdr->ascq = sense_buffer[13];
+			if (sb_len > 14)
+				sshdr->fru = sense_buffer[14];
 		}
 	}
 
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 06a8790..3472448 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -21,10 +21,14 @@ struct scsi_sense_hdr {		/* See SPC-3 section 4.5 */
 	u8 sense_key;
 	u8 asc;
 	u8 ascq;
-	u8 byte4;
-	u8 byte5;
+	u8 flags;
+#define SCSI_SENSE_FLAG_FMK  0x8
+#define SCSI_SENSE_FLAG_EOM 0x4
+#define SCSI_SENSE_FLAG_ILI 0x2
+	u8 fru;
 	u8 byte6;
 	u8 additional_length;	/* always 0 for fixed sense format */
+	u64 info;
 };
 
 static inline int scsi_sense_valid(struct scsi_sense_hdr *sshdr)
-- 
1.7.4.2

