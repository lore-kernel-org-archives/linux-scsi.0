Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6193E7179;
	Mon,  7 Sep 2026 02:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788749049; cv=none; b=anCMbQPDRfX1mzmbwKZ9DEfb1ZoWRN+YEEk5lL+HPxQAu5l90R/t3JqXunI9J/r+HeOS7QruJe0I+Zvjwy8lwwwzvAEDGg9yZFhemXmGcjJrCTIEVPLf8TLRD2c1xj57CmbPn4K78xqcVUQdvqtjwMaQxGm8/FZaMXHpkKbt4cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788749049; c=relaxed/simple;
	bh=EUfHSAYHXoEgFLTJEFEbQI39woZAppBYufzMov4oIkE=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pfuSycJ8JYy0mEFDJv5Hok7ZwO1cOYqV9gtNmylWUm+5P9pqSssGoeit2waFuLNOUuDKuGYWo67S96mSC83Uk/r95WnDVGUh4eTYZL/UOn6HBTA/tl9buhpOteUMLuQGQ3y0kdfTGzs55eIflwNciXn4CoQSvk4XdZOeVwjZFyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VjO8Y7Ln; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VjO8Y7Ln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 630C01F00A3E;
	Mon,  7 Sep 2026 02:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788749045;
	bh=YMHwDHqC324lWvR2VDiqoLZQRwrWMC/NStqfhhUrNdQ=;
	h=From:To:Subject:Date:In-Reply-To:References;
	b=VjO8Y7LnLUd57QY2f7S5DiKFK7JBDarV5akPxFs0bjsx8YR0ebsctLF7xDDrJo9aN
	 TKct+LNdEfYA0sB31i9UlVVSfd6fSoXzLYGlauzUuaMAf/lrADZFa0J4EHtk4txFe0
	 LEeUbMuEhwWMdS0b+KEfqYJgOmKORHNaAha8yddvCS+wjm8fTCjwkghyZ6FbLN72fg
	 2vIwpusDxqlnm/ik2fgkYQ/d9ym/D4ANwbnbCVFjhq/9J/uPLKkjTcbUfw+KMW7k17
	 pMWKZxHe9Z/DfSkAuHIJTRNrZK6IzfVaTouE0EWYTQtBHi/ed9BWnu9y0zyn03vu40
	 64/jKAXpvW2Mw==
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
Subject: [PATCH v5 06/40] scsi: use struct scsi_sense_hdr to log sense keys and codes
Date: Mon,  7 Sep 2026 11:43:09 +0900
Message-ID: <20260907024343.1046387-7-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907024343.1046387-1-dlemoal@kernel.org>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
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
---
 drivers/scsi/constants.c        | 11 +++++------
 drivers/scsi/scsi_logging.c     | 22 ++++++++++++----------
 drivers/usb/storage/debug.c     | 12 +++++-------
 drivers/usb/storage/debug.h     |  4 ++--
 drivers/usb/storage/transport.c |  2 +-
 include/scsi/scsi_dbg.h         |  6 +++---
 6 files changed, 28 insertions(+), 29 deletions(-)

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
index dda610f689b7..4cc5a019382a 100644
--- a/drivers/usb/storage/debug.c
+++ b/drivers/usb/storage/debug.c
@@ -140,15 +140,12 @@ void usb_stor_show_command(const struct us_data *us, struct scsi_cmnd *srb)
 		     (const unsigned char *)srb->cmnd);
 }
 
-void usb_stor_show_sense(const struct us_data *us,
-			 unsigned char key,
-			 unsigned char asc,
-			 unsigned char ascq)
+void usb_stor_show_sense(const struct us_data *us, struct scsi_sense_hdr *sshdr)
 {
 	const char *what, *keystr, *fmt;
 
-	keystr = scsi_sense_key_string(key);
-	what = scsi_extd_sense_format(asc, ascq, &fmt);
+	keystr = scsi_sense_key_string(sshdr->sense_key);
+	what = scsi_extd_sense_format(sshdr, &fmt);
 
 	if (keystr == NULL)
 		keystr = "(Unknown Key)";
@@ -156,7 +153,8 @@ void usb_stor_show_sense(const struct us_data *us,
 		what = "(unknown ASC/ASCQ)";
 
 	if (fmt)
-		usb_stor_dbg(us, "%s: %s (%s%x)\n", keystr, what, fmt, ascq);
+		usb_stor_dbg(us, "%s: %s (%s%x)\n", keystr, what, fmt,
+			     scsi_sense_ascq(sshdr));
 	else
 		usb_stor_dbg(us, "%s: %s\n", keystr, what);
 }
diff --git a/drivers/usb/storage/debug.h b/drivers/usb/storage/debug.h
index a6505ceb6693..616e518eeb21 100644
--- a/drivers/usb/storage/debug.h
+++ b/drivers/usb/storage/debug.h
@@ -31,8 +31,8 @@
 
 #ifdef CONFIG_USB_STORAGE_DEBUG
 void usb_stor_show_command(const struct us_data *us, struct scsi_cmnd *srb);
-void usb_stor_show_sense(const struct us_data *us, unsigned char key,
-			 unsigned char asc, unsigned char ascq);
+void usb_stor_show_sense(const struct us_data *us,
+			 struct scsi_sense_hdr *sshdr);
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

