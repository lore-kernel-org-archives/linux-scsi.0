From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 11/14] scsi: add scsi_set_sense_field_pointer()
Date: Mon,  4 Apr 2016 11:44:04 +0200
Message-ID: <1459763047-125551-12-git-send-email-hare@suse.de>
References: <1459763047-125551-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59377 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454AbcDDJoY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Apr 2016 05:44:24 -0400
In-Reply-To: <1459763047-125551-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun.tancheff@seagate.com>, Damien Le Moal <damien.lemoal@hgst.com>, linux-scsi@vger.kernel.org, Sathya Prakash <sathya.prakash@broadcom.com>, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>

Add a function to set the field pointer for SCSI sense codes.

Signed-off-by: Hannes Reinecke <hare@suse.com>
---
 drivers/scsi/scsi_common.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++
 include/scsi/scsi_common.h |  1 +
 2 files changed, 54 insertions(+)

diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
index c126966..b51a1c0 100644
--- a/drivers/scsi/scsi_common.c
+++ b/drivers/scsi/scsi_common.c
@@ -285,3 +285,56 @@ int scsi_set_sense_information(u8 *buf, int buf_len, u64 info)
 	return 0;
 }
 EXPORT_SYMBOL(scsi_set_sense_information);
+
+/**
+ * scsi_set_sense_field_pointer - set the field pointer sense key
+ *		specific information in a formatted sense data buffer
+ * @buf:	Where to build sense data
+ * @buf_len:    buffer length
+ * @fp:		field pointer to be set
+ * @bp:		bit pointer to be set
+ * @cd:		command/data bit
+ *
+ * Return value:
+ *	0 on success or EINVAL for invalid sense buffer length
+ **/
+int scsi_set_sense_field_pointer(u8 *buf, int buf_len, u16 fp, u8 bp, bool cd)
+{
+	u8 *ucp, len;
+
+	if ((buf[0] & 0x7f) == 0x72) {
+		len = buf[7];
+		ucp = (char *)scsi_sense_desc_find(buf, len + 8, 2);
+		if (!ucp) {
+			buf[7] = len + 8;
+			ucp = buf + 8 + len;
+		}
+
+		if (buf_len < len + 8)
+			/* Not enough room for info */
+			return -EINVAL;
+
+		ucp[0] = 2;
+		ucp[1] = 6;
+		ucp[4] = 0x80; /* Valid bit */
+		if (cd)
+			ucp[4] |= 0x40;
+		if (bp < 0x8)
+			ucp[4] |= 0x8 | bp;
+		put_unaligned_be16(fp, &ucp[5]);
+	} else if ((buf[0] & 0x7f) == 0x70) {
+		len = buf[7];
+		if (len < 18)
+			buf[7] = 18;
+
+		buf[15] = 0x80;
+		if (cd)
+			buf[15] |= 0x40;
+		if (bp < 0x8)
+			buf[15] |= 0x8 | bp;
+		put_unaligned_be16(fp, &buf[16]);
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(scsi_set_sense_field_pointer);
diff --git a/include/scsi/scsi_common.h b/include/scsi/scsi_common.h
index 11571b2..20bf7ea 100644
--- a/include/scsi/scsi_common.h
+++ b/include/scsi/scsi_common.h
@@ -63,6 +63,7 @@ extern bool scsi_normalize_sense(const u8 *sense_buffer, int sb_len,
 
 extern void scsi_build_sense_buffer(int desc, u8 *buf, u8 key, u8 asc, u8 ascq);
 int scsi_set_sense_information(u8 *buf, int buf_len, u64 info);
+int scsi_set_sense_field_pointer(u8 *buf, int buf_len, u16 fp, u8 bp, bool cd);
 extern const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
 				       int desc_type);
 
-- 
1.8.5.6

