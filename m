From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] sense data helpers lk 2.6.11-rc1-bk1
Date: Tue, 18 Jan 2005 22:52:08 +1000
Message-ID: <41ED0678.6000101@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020908020508070806090005"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:34947 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S261285AbVARMwG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2005 07:52:06 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: James.Bottomley@SteelEye.com

This is a multi-part message in MIME format.
--------------020908020508070806090005
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Here are two helper functions for processing sense data.
These will allow the sd driver (and constants.c) to fetch
the information field in sense data. For a medium or
hardware error on a disk the information field is the
lba of the first failure.

Changelog:
   - add sense data helper functions:
      - scsi_sense_desc_find() to find a given
        sense descriptor (e.g. type 0 -> information)
      - scsi_get_sense_info_fld() to get the information
        field from fixed or descriptor sense data


Kai Makisara proposed the "find" function. For
example, it will help the st driver find the Filemark,
EOM and ILI flags which have been placed in the
"stream commands" sense data descriptor.

Signed-off-by: Douglas Gilbert <dougg@torque.net>

--------------020908020508070806090005
Content-Type: text/x-patch;
 name="desc_info2611r1b1.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="desc_info2611r1b1.diff"

--- linux/include/scsi/scsi_eh.h	2004-12-25 12:21:28.000000000 +1000
+++ linux/include/scsi/scsi_eh.h2611r1b1desc	2005-01-18 16:49:08.000000000 +1000
@@ -44,6 +44,12 @@
 {
 	return ((sshdr->response_code >= 0x70) && (sshdr->response_code & 1));
 }
+
+extern const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
+				       int desc_type);
+
+extern int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
+				   u64 * info_out);
  
 /*
  * Reset request from external source
--- linux/drivers/scsi/scsi_error.c	2005-01-13 14:41:44.000000000 +1000
+++ linux/drivers/scsi/scsi_error.c2611r1b1desc	2005-01-18 16:54:45.000000000 +1000
@@ -1948,3 +1948,96 @@
 			sizeof(cmd->sense_buffer), sshdr);
 }
 EXPORT_SYMBOL(scsi_command_normalize_sense);
+
+/**
+ * scsi_sense_desc_find - search for a given descriptor type in
+ *			descriptor sense data format.
+ *
+ * @sense_buffer:	byte array of descriptor format sense data
+ * @sb_len:		number of valid bytes in sense_buffer
+ * @desc_type:		value of descriptor type to find
+ *			(e.g. 0 -> information)
+ *
+ * Notes:
+ *	only valid when sense data is in descriptor format
+ *
+ * Return value:
+ *	pointer to start of (first) descriptor if found else NULL
+ **/
+const u8 * scsi_sense_desc_find(const u8 * sense_buffer, int sb_len,
+				int desc_type)
+{
+	int add_sen_len, add_len, desc_len, k;
+	const u8 * descp;
+
+	if ((sb_len < 8) || (0 == (add_sen_len = sense_buffer[7])))
+		return NULL;
+	if ((sense_buffer[0] < 0x72) || (sense_buffer[0] > 0x73))
+		return NULL;
+	add_sen_len = (add_sen_len < (sb_len - 8)) ?
+			add_sen_len : (sb_len - 8);
+	descp = &sense_buffer[8];
+	for (desc_len = 0, k = 0; k < add_sen_len; k += desc_len) {
+		descp += desc_len;
+		add_len = (k < (add_sen_len - 1)) ? descp[1]: -1;
+		desc_len = add_len + 2;
+		if (descp[0] == desc_type)
+			return descp;
+		if (add_len < 0) // short descriptor ??
+			break;
+	}
+	return NULL;
+}
+EXPORT_SYMBOL(scsi_sense_desc_find);
+
+/**
+ * scsi_get_sense_info_fld - attempts to get information field from
+ *			sense data (either fixed or descriptor format)
+ *
+ * @sense_buffer:	byte array of sense data
+ * @sb_len:		number of valid bytes in sense_buffer
+ * @info_out:		pointer to 64 integer where 8 or 4 byte information
+ *			field will be placed if found.
+ *
+ * Return value:
+ *	1 if information field found, 0 if not found.
+ **/
+int scsi_get_sense_info_fld(const u8 * sense_buffer, int sb_len,
+			    u64 * info_out)
+{
+	int j;
+	const u8 * ucp;
+	u64 ull;
+
+	if (sb_len < 7)
+		return 0;
+	switch (sense_buffer[0] & 0x7f) {
+	case 0x70:
+	case 0x71:
+		if (sense_buffer[0] & 0x80) {
+			*info_out = (sense_buffer[3] << 24) +
+				    (sense_buffer[4] << 16) +
+				    (sense_buffer[5] << 8) + sense_buffer[6];
+			return 1;
+		} else
+			return 0;
+	case 0x72:
+	case 0x73:
+		ucp = scsi_sense_desc_find(sense_buffer, sb_len,
+					   0 /* info desc */);
+		if (ucp && (0xa == ucp[1])) {
+			ull = 0;
+			for (j = 0; j < 8; ++j) {
+				if (j > 0)
+					ull <<= 8;
+				ull |= ucp[4 + j];
+			}
+			*info_out = ull;
+			return 1;
+		} else
+			return 0;
+	default:
+		return 0;
+	}
+}
+EXPORT_SYMBOL(scsi_get_sense_info_fld);

--------------020908020508070806090005--
