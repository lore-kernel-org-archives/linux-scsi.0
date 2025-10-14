Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA4A303C88
	for <linux-scsi@vger.kernel.org>; Tue, 14 Oct 2025 22:04:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760479496; cv=none; b=C1dw0vxcAsoLmJpZfw8uy7ZTLGs0ZBTx93p99vHesoGkk0kwPkCnhLfJTY18SmYZ954tDWB99HrDABq5m51BzoeXyneuGpgGrcmr17DgFMnfv/SqmAixDkwXfw8MADpHPJOXH3qt6LrFBZE10hLoHVDgo23hOyY8nUPA2vTitRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760479496; c=relaxed/simple;
	bh=3n/TXRk+9iuShrtv58fo4Nr1J8EFFAbBBqCuc0bCBW8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jHd3JFQ1Y4mCPoXJSN1cpEE61sbgfnr8yLPPypZvQ5dV8rxqSpW111sndhCAqtfqCxRpN7Hhua6BldslRpg7YqaAgXzvGsfJnM7UUx74c1CROT3PvqmLNrxfhVY8CC73mBOkb3PLGlmpaAa5RSw8jnWqHF9PCRlcjqt/SJRxrVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=X7firVXz; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="X7firVXz"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cmSts38ShzlnfZ8;
	Tue, 14 Oct 2025 22:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:x-mailer:message-id:date
	:date:subject:subject:from:from:received:received; s=mr01; t=
	1760479492; x=1763071493; bh=arqGGlZXnkPYYXWc9JCPuWcd1A1bqvVAtOI
	hGZyjYFs=; b=X7firVXzznZDG3kKN7tRjQ9PXaUwdLAmLHl2r/SxgTMKbaGoLKQ
	Tf+NhaosuAUZW59c++vOX0xJdpZRUTRRtcj7dhS25oRqAD84LG1WzELYWspiRSOl
	cXRuOOc9p++QM5EgKVhQfHoClZlroD9yDJwpPf2LmVkHTofYyayq+xur9jERvAse
	g05aywZWosY32hrt7J0wujtdUs8DiDlMlW2MfLkNGM/XXWoxDwrPNT4EG8APMke4
	DPPhnRANtz6pyYO/QX6eh3nAevhB3Z86PZg9GmAwOnCvE+FKCiXnzrZMvOfztyxW
	LS4/UkdTe2Qau9Fg7/AukUpB41QzSjl6okw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rvYypwoAiqKE; Tue, 14 Oct 2025 22:04:52 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cmStd2z5CzlgqVj;
	Tue, 14 Oct 2025 22:04:38 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] scsi: core: Do not declare scsi_cmnd pointers const
Date: Tue, 14 Oct 2025 15:04:25 -0700
Message-ID: <20251014220426.3690007-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.51.0.788.g6d19910ace-goog
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

This change allows removing multiple casts and hence improves type checki=
ng
by the compiler.

Cc: Hannes Reinecke <hare@suse.de>
Suggested-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_logging.c | 21 ++++++++++-----------
 include/scsi/scsi_dbg.h     |  4 ++--
 include/scsi/scsi_device.h  |  4 ++--
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index b02af340c2d3..3cd0d3074085 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -26,9 +26,9 @@ static void scsi_log_release_buffer(char *bufptr)
 	kfree(bufptr);
 }
=20
-static inline const char *scmd_name(const struct scsi_cmnd *scmd)
+static inline const char *scmd_name(struct scsi_cmnd *scmd)
 {
-	struct request *rq =3D scsi_cmd_to_rq((struct scsi_cmnd *)scmd);
+	const struct request *rq =3D scsi_cmd_to_rq(scmd);
=20
 	if (!rq->q || !rq->q->disk)
 		return NULL;
@@ -80,8 +80,8 @@ void sdev_prefix_printk(const char *level, const struct=
 scsi_device *sdev,
 }
 EXPORT_SYMBOL(sdev_prefix_printk);
=20
-void scmd_printk(const char *level, const struct scsi_cmnd *scmd,
-		const char *fmt, ...)
+void scmd_printk(const char *level, struct scsi_cmnd *scmd, const char *=
fmt,
+		 ...)
 {
 	va_list args;
 	char *logbuf;
@@ -94,7 +94,7 @@ void scmd_printk(const char *level, const struct scsi_c=
mnd *scmd,
 	if (!logbuf)
 		return;
 	off =3D sdev_format_header(logbuf, logbuf_len, scmd_name(scmd),
-				 scsi_cmd_to_rq((struct scsi_cmnd *)scmd)->tag);
+				 scsi_cmd_to_rq(scmd)->tag);
 	if (off < logbuf_len) {
 		va_start(args, fmt);
 		off +=3D vscnprintf(logbuf + off, logbuf_len - off, fmt, args);
@@ -371,16 +371,15 @@ void __scsi_print_sense(const struct scsi_device *s=
dev, const char *name,
 EXPORT_SYMBOL(__scsi_print_sense);
=20
 /* Normalize and print sense buffer in SCSI command */
-void scsi_print_sense(const struct scsi_cmnd *cmd)
+void scsi_print_sense(struct scsi_cmnd *cmd)
 {
 	scsi_log_print_sense(cmd->device, scmd_name(cmd),
-			     scsi_cmd_to_rq((struct scsi_cmnd *)cmd)->tag,
-			     cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
+			     scsi_cmd_to_rq(cmd)->tag, cmd->sense_buffer,
+			     SCSI_SENSE_BUFFERSIZE);
 }
 EXPORT_SYMBOL(scsi_print_sense);
=20
-void scsi_print_result(const struct scsi_cmnd *cmd, const char *msg,
-		       int disposition)
+void scsi_print_result(struct scsi_cmnd *cmd, const char *msg, int dispo=
sition)
 {
 	char *logbuf;
 	size_t off, logbuf_len;
@@ -393,7 +392,7 @@ void scsi_print_result(const struct scsi_cmnd *cmd, c=
onst char *msg,
 		return;
=20
 	off =3D sdev_format_header(logbuf, logbuf_len, scmd_name(cmd),
-				 scsi_cmd_to_rq((struct scsi_cmnd *)cmd)->tag);
+				 scsi_cmd_to_rq(cmd)->tag);
=20
 	if (off >=3D logbuf_len)
 		goto out_printk;
diff --git a/include/scsi/scsi_dbg.h b/include/scsi/scsi_dbg.h
index bd29cdb513a5..efcdc78530d5 100644
--- a/include/scsi/scsi_dbg.h
+++ b/include/scsi/scsi_dbg.h
@@ -11,11 +11,11 @@ extern size_t __scsi_format_command(char *, size_t,
 				   const unsigned char *, size_t);
 extern void scsi_print_sense_hdr(const struct scsi_device *, const char =
*,
 				 const struct scsi_sense_hdr *);
-extern void scsi_print_sense(const struct scsi_cmnd *);
+extern void scsi_print_sense(struct scsi_cmnd *);
 extern void __scsi_print_sense(const struct scsi_device *, const char *n=
ame,
 			       const unsigned char *sense_buffer,
 			       int sense_len);
-extern void scsi_print_result(const struct scsi_cmnd *, const char *, in=
t);
+extern void scsi_print_result(struct scsi_cmnd *, const char *, int);
=20
 #ifdef CONFIG_SCSI_CONSTANTS
 extern bool scsi_opcode_sa_name(int, int, const char **, const char **);
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 6d6500148c4b..4c106342c4ae 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -313,8 +313,8 @@ sdev_prefix_printk(const char *, const struct scsi_de=
vice *, const char *,
 #define sdev_printk(l, sdev, fmt, a...)				\
 	sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
=20
-__printf(3, 4) void
-scmd_printk(const char *, const struct scsi_cmnd *, const char *, ...);
+__printf(3, 4) void scmd_printk(const char *, struct scsi_cmnd *, const =
char *,
+				...);
=20
 #define scmd_dbg(scmd, fmt, a...)					\
 	do {								\
