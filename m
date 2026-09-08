Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEED4E3799;
	Tue,  8 Sep 2026 09:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788858220; cv=none; b=TgjZd4oKV4qiukpjiVll8XTorg7xPkWRC12XMWd17wlb4K+ryLt0Yyzj5Wxs/JYUwXSbGcLbPKYAY51iS1MfQEHhbT3jFbXa9peQBxHK7Mv7CFPhAQQf9+ARKFqhfaJlIGxPWWssz1o617A4c2fzgHv8bWfksp498Lc8n5HmD7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788858220; c=relaxed/simple;
	bh=1feuTtMToi7wtYHV7jJFFRhiYrZHkPZgPv3NFGPSbEI=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjkodC6t4oxL7MSgn2Dy5pQiCUQ04GC652Roazk2/E5IZ7iHXdN75KEAaD6PPgOCkYurN+zPokXDDnyyeNJimN7LCFCNhTX7i2FH0hF300QQQh/c4nKNWtpOT7c/lEl9Sdu29IdhzphMZm/SpEW8iKnLoO6BJ6MYBgbT/48U7MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I6sF73TO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I6sF73TO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 685C21F00A3F;
	Tue,  8 Sep 2026 09:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788858211;
	bh=/AZSBprdgWHbm59jkjOVwGceZ9efvDf5SMLUDdbfN4A=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=I6sF73TOV3ealCqIu3UM8diasMz8mXH+m/6QFGkHAqRJmfvQAqXMoZtCXRLQTQELl
	 cCdWKp2oDKHNfteBk4ATfjm8S9Mamsd2Vwu1kULWzXZtAlDOHKqxHVRleW7MidHUT0
	 5niDBI8I0yNIHvAJKQVumJqBfzdNNGytQ19q//9YAj3R9Xgtxf8lwY0NuMifI4VB67
	 GF2DXZe3DDiMV0jYp2CUxDknR1frbgil0g4GCT/gcEgbRmSzQvwalRP2L/lKPfxtEM
	 qQ4N7ct/5/GHTrJC5UcLIsPqhop5a2Iv8kfIFZzGca7ry1woAYkdzghoS7I+GblU+d
	 YaUb1hnZKBOdw==
From: Damien Le Moal <dlemoal@kernel.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	linux-scsi@vger.kernel.org,
	linux-ide@vger.kernel.org,
	Niklas Cassel <cassel@kernel.org>,
	linux-usb@vger.kernel.org,
	Alan Stern <stern@rowland.harvard.edu>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-s390@vger.kernel.org,
	Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH v6 06/40] scsi: use struct scsi_sense_hdr to log sense keys and codes
Date: Tue,  8 Sep 2026 18:02:34 +0900
Message-ID: <20260908090308.1085097-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908090308.1085097-1-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Instead of passing the sense key, additional sense code and additional
sense code qualifier as separate parameters, change the functions
scsi_extd_sense_format(), scsi_format_extd_sense(), and
usb_stor_show_sense() to take a pointer to a struct scsi_sense_hdr to
access the sense key and sense code with a single argument.

No functional change intended.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
---
 drivers/scsi/constants.c        | 11 +++++------
 drivers/scsi/scsi_logging.c     | 22 ++++++++++++----------
 drivers/usb/storage/debug.c     | 11 +++++------
 drivers/usb/storage/debug.h     |  4 ++--
 drivers/usb/storage/transport.c |  2 +-
 include/scsi/scsi_dbg.h         |  6 +++---
 6 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
index 4b97f574fe8c..57b51c4529c3 100644
--- a/drivers/scsi/constants.c
+++ b/drivers/scsi/constants.c
@@ -377,22 +377,21 @@ EXPORT_SYMBOL(scsi_sense_key_string);
  * This string may contain a "%x" and should be printed with ascq as arg.
  */
 const char *
-scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
+scsi_extd_sense_format(const struct scsi_sense_hdr *sshdr, const char **fmt)
 {
-	u16 code = scsi_sense_code(asc, ascq);
 	unsigned offset = 0;
 	int i;
 
 	*fmt = NULL;
 	for (i = 0; i < ARRAY_SIZE(additional); i++) {
-		if (additional[i].code == code)
+		if (additional[i].code == sshdr->sense_code)
 			return additional_text + offset;
 		offset += additional[i].size;
 	}
 	for (i = 0; additional2[i].fmt; i++) {
-		if (additional2[i].asc == asc &&
-		    ascq >= additional2[i].ascq_min &&
-		    ascq <= additional2[i].ascq_max) {
+		if (additional2[i].asc == scsi_sense_asc(sshdr) &&
+		    scsi_sense_ascq(sshdr) >= additional2[i].ascq_min &&
+		    scsi_sense_ascq(sshdr) <= additional2[i].ascq_max) {
 			*fmt = additional2[i].fmt;
 			return additional2[i].str;
 		}
diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index 3cd0d3074085..0a9a2f7c1966 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -238,29 +238,32 @@ EXPORT_SYMBOL(scsi_print_command);
 
 static size_t
 scsi_format_extd_sense(char *buffer, size_t buf_len,
-		       unsigned char asc, unsigned char ascq)
+		       const struct scsi_sense_hdr *sshdr)
 {
 	size_t off = 0;
 	const char *extd_sense_fmt = NULL;
-	const char *extd_sense_str = scsi_extd_sense_format(asc, ascq,
-							    &extd_sense_fmt);
+	const char *extd_sense_str =
+		scsi_extd_sense_format(sshdr, &extd_sense_fmt);
 
 	if (extd_sense_str) {
 		off = scnprintf(buffer, buf_len, "Add. Sense: %s",
 				extd_sense_str);
 		if (extd_sense_fmt)
 			off += scnprintf(buffer + off, buf_len - off,
-					 "(%s%x)", extd_sense_fmt, ascq);
+					 "(%s%x)", extd_sense_fmt,
+					 scsi_sense_ascq(sshdr));
 	} else {
-		if (asc >= 0x80)
+		if (scsi_sense_asc(sshdr) >= 0x80)
 			off = scnprintf(buffer, buf_len, "<<vendor>>");
 		off += scnprintf(buffer + off, buf_len - off,
-				 "ASC=0x%x ", asc);
-		if (ascq >= 0x80)
+				 "ASC=0x%x ",
+				 scsi_sense_asc(sshdr));
+		if (scsi_sense_ascq(sshdr) >= 0x80)
 			off += scnprintf(buffer + off, buf_len - off,
 					 "<<vendor>>");
 		off += scnprintf(buffer + off, buf_len - off,
-				 "ASCQ=0x%x ", ascq);
+				 "ASCQ=0x%x ",
+				 scsi_sense_ascq(sshdr));
 	}
 	return off;
 }
@@ -333,8 +336,7 @@ scsi_log_print_sense_hdr(const struct scsi_device *sdev, const char *name,
 	if (!logbuf)
 		return;
 	off = sdev_format_header(logbuf, logbuf_len, name, tag);
-	off += scsi_format_extd_sense(logbuf + off, logbuf_len - off,
-				      sshdr->asc, sshdr->ascq);
+	off += scsi_format_extd_sense(logbuf + off, logbuf_len - off, sshdr);
 	dev_printk(KERN_INFO, &sdev->sdev_gendev, "%s", logbuf);
 	scsi_log_release_buffer(logbuf);
 }
diff --git a/drivers/usb/storage/debug.c b/drivers/usb/storage/debug.c
index dda610f689b7..71923cf28536 100644
--- a/drivers/usb/storage/debug.c
+++ b/drivers/usb/storage/debug.c
@@ -141,14 +141,12 @@ void usb_stor_show_command(const struct us_data *us, struct scsi_cmnd *srb)
 }
 
 void usb_stor_show_sense(const struct us_data *us,
-			 unsigned char key,
-			 unsigned char asc,
-			 unsigned char ascq)
+			 const struct scsi_sense_hdr *sshdr)
 {
 	const char *what, *keystr, *fmt;
 
-	keystr = scsi_sense_key_string(key);
-	what = scsi_extd_sense_format(asc, ascq, &fmt);
+	keystr = scsi_sense_key_string(sshdr->sense_key);
+	what = scsi_extd_sense_format(sshdr, &fmt);
 
 	if (keystr == NULL)
 		keystr = "(Unknown Key)";
@@ -156,7 +154,8 @@ void usb_stor_show_sense(const struct us_data *us,
 		what = "(unknown ASC/ASCQ)";
 
 	if (fmt)
-		usb_stor_dbg(us, "%s: %s (%s%x)\n", keystr, what, fmt, ascq);
+		usb_stor_dbg(us, "%s: %s (%s%x)\n", keystr, what, fmt,
+			     scsi_sense_ascq(sshdr));
 	else
 		usb_stor_dbg(us, "%s: %s\n", keystr, what);
 }
diff --git a/drivers/usb/storage/debug.h b/drivers/usb/storage/debug.h
index a6505ceb6693..34e20fff13b5 100644
--- a/drivers/usb/storage/debug.h
+++ b/drivers/usb/storage/debug.h
@@ -31,8 +31,8 @@
 
 #ifdef CONFIG_USB_STORAGE_DEBUG
 void usb_stor_show_command(const struct us_data *us, struct scsi_cmnd *srb);
-void usb_stor_show_sense(const struct us_data *us, unsigned char key,
-			 unsigned char asc, unsigned char ascq);
+void usb_stor_show_sense(const struct us_data *us,
+			 const struct scsi_sense_hdr *sshdr);
 __printf(2, 3) void usb_stor_dbg(const struct us_data *us,
 				 const char *fmt, ...);
 
diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index 9a4bf86e7b6a..8e9359501d88 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -805,7 +805,7 @@ void usb_stor_invoke_transport(struct scsi_cmnd *srb, struct us_data *us)
 			     sshdr.response_code, sshdr.sense_key,
 			     sshdr.asc, sshdr.ascq);
 #ifdef CONFIG_USB_STORAGE_DEBUG
-		usb_stor_show_sense(us, sshdr.sense_key, sshdr.asc, sshdr.ascq);
+		usb_stor_show_sense(us, &sshdr);
 #endif
 
 		/* set the result so the higher layers expect this data */
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index efcdc78530d5..f21a5e3caca9 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -20,8 +20,8 @@ extern void scsi_print_result(struct scsi_cmnd *, const char *, int);
 #ifdef CONFIG_SCSI_CONSTANTS
 extern bool scsi_opcode_sa_name(int, int, const char **, const char **);
 extern const char *scsi_sense_key_string(unsigned char);
-extern const char *scsi_extd_sense_format(unsigned char, unsigned char,
-					  const char **);
+extern const char *scsi_extd_sense_format(const struct scsi_sense_hdr *sshdr,
+					  const char **fmt);
 extern const char *scsi_mlreturn_string(int);
 extern const char *scsi_hostbyte_string(int);
 #else
@@ -57,7 +57,7 @@ scsi_sense_key_string(unsigned char key)
 }
 
 static inline const char *
-scsi_extd_sense_format(unsigned char asc, unsigned char ascq, const char **fmt)
+scsi_extd_sense_format(const struct scsi_sense_hdr *sshdr, const char **fmt)
 {
 	*fmt = NULL;
 	return NULL;
-- 
2.55.0

