From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [RFC] expand information in the scsi_sense_hdr
Date: Mon, 13 Jun 2005 22:25:34 -0500
Message-ID: <1118719534.5079.93.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:3470 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261406AbVFNDZi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 13 Jun 2005 23:25:38 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id j5E3PbA16861
	for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2005 23:25:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>

Since the scsi_execute_req() call is trying to make this the standard
way of passing back sense (mainly because scsi_execute_req() is designed
for internal consumption, which has more simple sense parsing
requirements) there needs to be enough information in the header for all
sense uses within the kernel.

This patch adds the info field, the flags field, the sense key specific
field and the command info field to the sense header.  The disadvantage
is that it adds nineteen bytes to the sense header.

James

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1919,7 +1919,14 @@ int scsi_normalize_sense(const u8 *sense
 	if (!scsi_sense_valid(sshdr))
 		return 0;
 
-	if (sshdr->response_code >= 0x72) {
+	if (sshdr->response_code == 0x72 || sshdr->response_code == 0x73)
+		sshdr->descriptor = 1;
+	if (sshdr->response_code < 0x70 || sshdr->response_code > 0x73)
+		return 0;
+	sshdr->deferred = (sshdr->response_code & 0x01) ? 1 : 0;
+
+	if (sshdr->descriptor) {
+		const u8 *desc;
 		/*
 		 * descriptor format
 		 */
@@ -1931,19 +1938,86 @@ int scsi_normalize_sense(const u8 *sense
 			sshdr->ascq = sense_buffer[3];
 		if (sb_len > 7)
 			sshdr->additional_length = sense_buffer[7];
+
+		/* now get descriptor flags data */
+		desc = scsi_sense_desc_find(sense_buffer, sb_len,
+					    SCSI_SENSE_DESCRIPTOR_SSC);
+		if (desc)
+			sshdr->flags = desc[3] & 0xe0;
+		desc = scsi_sense_desc_find(sense_buffer, sb_len,
+					    SCSI_SENSE_DESCRIPTOR_SBC);
+		if (desc)
+			sshdr->flags = desc[3] & 0x20; /* ILI */
+		desc = scsi_sense_desc_find(sense_buffer, sb_len,
+					    SCSI_SENSE_DESCRIPTOR_INFO);
+		if (desc) {
+			sshdr->valid = (desc[2] & 0x80) ? 1 : 0;
+			sshdr->info = 
+				((u64)desc[4]  << 56) |
+				((u64)desc[5]  << 48) |
+				((u64)desc[6]  << 40) |
+				((u64)desc[7]  << 32) |
+				((u64)desc[8]  << 24) |
+				((u64)desc[9]  << 16) |
+				((u64)desc[10] <<  8) |
+				(u64)desc[11];
+		}
+		desc = scsi_sense_desc_find(sense_buffer, sb_len,
+					    SCSI_SENSE_DESCRIPTOR_CMD);
+		if (desc)
+			sshdr->cmd_info =
+				((u64)desc[4]  << 56) |
+				((u64)desc[5]  << 48) |
+				((u64)desc[6]  << 40) |
+				((u64)desc[7]  << 32) |
+				((u64)desc[8]  << 24) |
+				((u64)desc[9]  << 16) |
+				((u64)desc[10] <<  8) |
+				(u64)desc[11];
+		desc = scsi_sense_desc_find(sense_buffer, sb_len,
+					    SCSI_SENSE_DESCRIPTOR_CMD);
+		if (desc) {
+			sshdr->sksv = (desc[2] & 0x80) ? 1 : 0;
+			sshdr->extra_sense_specific = desc[2] & 0x7f;
+			sshdr->sense_specific =
+				((u16)desc[3] << 8) |
+				(u16)desc[4];
+		}
 	} else {
 		/* 
 		 * fixed format
 		 */
+		sshdr->valid = (sense_buffer[0] & 0x80) ? 1 : 0;
 		if (sb_len > 2)
 			sshdr->sense_key = (sense_buffer[2] & 0xf);
-		if (sb_len > 7) {
+		if (sb_len > 3)
+			sshdr->flags = sense_buffer[2] & 0xe0;
+		if (sb_len > 6 && sshdr->valid)
+			sshdr->info = 
+				((u32)sense_buffer[3] << 24) |
+				((u32)sense_buffer[4] << 16) |
+				((u32)sense_buffer[5] <<  8) |
+				(u32)sense_buffer[6];
+		if (sb_len > 7)
 			sb_len = (sb_len < (sense_buffer[7] + 8)) ?
 					 sb_len : (sense_buffer[7] + 8);
-			if (sb_len > 12)
-				sshdr->asc = sense_buffer[12];
-			if (sb_len > 13)
-				sshdr->ascq = sense_buffer[13];
+
+		if (sb_len > 11)
+			sshdr->cmd_info = 
+				((u32)sense_buffer[8] << 24) |
+				((u32)sense_buffer[9] << 16) |
+				((u32)sense_buffer[10] << 8) |
+				(u32)sense_buffer[11];
+		if (sb_len > 12)
+			sshdr->asc = sense_buffer[12];
+		if (sb_len > 13)
+			sshdr->ascq = sense_buffer[13];
+		if (sb_len > 17) {
+			sshdr->sksv = (sense_buffer[15] & 0x80) ? 1 : 0;
+			if (sshdr->sksv)
+				sshdr->sense_specific =
+					((u16)sense_buffer[15] & 0x7f) << 8 |
+					(u16)sense_buffer[16];
 		}
 	}
 
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -16,8 +16,17 @@ struct Scsi_Host;
  * in which more information is required (e.g. the LBA of a MEDIUM ERROR).
  */
 struct scsi_sense_hdr {		/* See SPC-3 section 4.5 */
-	u8 response_code;	/* permit: 0x0, 0x70, 0x71, 0x72, 0x73 */
-	u8 sense_key;
+	u64 info;
+	u64 cmd_info;
+	u16 sense_specific;
+	u8 extra_sense_specific; /* only valid for descriptor format */
+	u8 valid:1,
+	   response_code:7;	/* permit: 0x0, 0x70, 0x71, 0x72, 0x73 */
+	u8 sksv:1,
+	   deferred:1,
+	   descriptor:1,
+	   sense_key:4;
+	u8 flags;		/* FILEMARK, EOM or ILI */
 	u8 asc;
 	u8 ascq;
 	u8 byte4;
@@ -26,6 +35,13 @@ struct scsi_sense_hdr {		/* See SPC-3 se
 	u8 additional_length;	/* always 0 for fixed sense format */
 };
 
+/* Descriptor types */
+#define SCSI_SENSE_DESCRIPTOR_INFO	0x00
+#define SCSI_SENSE_DESCRIPTOR_CMD	0x01
+#define SCSI_SENSE_DESCRIPTOR_SKS	0x02
+#define SCSI_SENSE_DESCRIPTOR_SSC	0x04
+#define SCSI_SENSE_DESCRIPTOR_SBC	0x05
+
 static inline int scsi_sense_valid(struct scsi_sense_hdr *sshdr)
 {
 	if (!sshdr)


