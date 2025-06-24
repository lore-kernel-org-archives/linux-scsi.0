Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4ECF254AF0
	for <linux-scsi@vger.kernel.org>; Tue, 24 Jun 2025 21:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750799176; cv=none; b=AFw1pkVMTI1d31XBwb5qx2zjSAfrAOq4/QJCyazfWS+qLO4L5V3TlA5LpSiYbYABbYlblKs13OnU4GQXq+7MjjqnHAyzs2cZWeYVRNWnYynMk6XwoTlnwuqYNVGf5xza+jGWF65cNYSWvtv8uG8j6r3OyIQmeEtH0eR4XU7lZfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750799176; c=relaxed/simple;
	bh=gvMXVyHioxJoLe7MeKoQXEVxKHy+A9DSEklrOhqiXQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mdpcecEZ9hXRzdZi1DWy7S8P0VkQFmJrYRjwu1afkOJ6bmvVFj39tfer6IFJPj3zyiHHE3eeRWiigI4HoKn5xLEt0jUVPLJPV9gXB42hFIxbBqhYpQEG3nNK79JhMmXZU2yHREXSosvfVnNJa/CzlzC0BQADMmZUIKHF7vSnBmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=B3oJLRZT; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="B3oJLRZT"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bRcts5qzNzm0pKk;
	Tue, 24 Jun 2025 21:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:mime-version:references:in-reply-to
	:x-mailer:message-id:date:date:subject:subject:from:from
	:received:received; s=mr01; t=1750799172; x=1753391173; bh=cNJom
	yGwYjKjG1gqYJoIZcPEOZ8+P+y08GVMdQ1EedA=; b=B3oJLRZTz5y+6NZ/XdWY3
	LEKIdywbNHxvf3M45QIao16s3kD5E+so8N+H6v/WXsr3oW4EXPgGj6OHD77yqbor
	nKMTknee9sSMz2Cmyz0AziCmRj+pJSleHCOckKcKw8F/luMlV/vR9j7ALuQfLXT0
	eG6JhygQt+NHu3S1dlOwqIhEX+10IW5pefCkiEavTMBvEcYuOx1Rh05QXEpd5yHx
	3/q+MRc0mld2Ne6OETjnQZTG/4EtTyMICiLKbK7n2v7o+oPJama6za7YmU7cNGaY
	QpByBLKpueKfcYBP9nz8+Ltx18cVSMJxOc6jBMbd3v0n34eLvTCO9S+YcZgSH58D
	Q==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rsLPnvA_PCay; Tue, 24 Jun 2025 21:06:12 +0000 (UTC)
Received: from bvanassche.mtv.corp.google.com (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bRctm4vtszm0pK8;
	Tue, 24 Jun 2025 21:06:07 +0000 (UTC)
From: Bart Van Assche <bvanassche@acm.org>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Hannes Reinecke <hare@suse.de>,
	John Garry <john.g.garry@oracle.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: [PATCH 1/3] scsi: core: Make scsi_cmd_to_rq() accept const arguments
Date: Tue, 24 Jun 2025 14:05:38 -0700
Message-ID: <20250624210541.512910-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
In-Reply-To: <20250624210541.512910-1-bvanassche@acm.org>
References: <20250624210541.512910-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

Instead of requiring the caller to cast away constness, make
scsi_cmd_to_rq() accept const arguments.

Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_logging.c | 10 +++++-----
 include/scsi/scsi_cmnd.h    |  9 +++++----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/scsi/scsi_logging.c b/drivers/scsi/scsi_logging.c
index b02af340c2d3..5aaff629b999 100644
--- a/drivers/scsi/scsi_logging.c
+++ b/drivers/scsi/scsi_logging.c
@@ -28,7 +28,7 @@ static void scsi_log_release_buffer(char *bufptr)
=20
 static inline const char *scmd_name(const struct scsi_cmnd *scmd)
 {
-	struct request *rq =3D scsi_cmd_to_rq((struct scsi_cmnd *)scmd);
+	const struct request *rq =3D scsi_cmd_to_rq(scmd);
=20
 	if (!rq->q || !rq->q->disk)
 		return NULL;
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
@@ -374,8 +374,8 @@ EXPORT_SYMBOL(__scsi_print_sense);
 void scsi_print_sense(const struct scsi_cmnd *cmd)
 {
 	scsi_log_print_sense(cmd->device, scmd_name(cmd),
-			     scsi_cmd_to_rq((struct scsi_cmnd *)cmd)->tag,
-			     cmd->sense_buffer, SCSI_SENSE_BUFFERSIZE);
+			     scsi_cmd_to_rq(cmd)->tag, cmd->sense_buffer,
+			     SCSI_SENSE_BUFFERSIZE);
 }
 EXPORT_SYMBOL(scsi_print_sense);
=20
@@ -393,7 +393,7 @@ void scsi_print_result(const struct scsi_cmnd *cmd, c=
onst char *msg,
 		return;
=20
 	off =3D sdev_format_header(logbuf, logbuf_len, scmd_name(cmd),
-				 scsi_cmd_to_rq((struct scsi_cmnd *)cmd)->tag);
+				 scsi_cmd_to_rq(cmd)->tag);
=20
 	if (off >=3D logbuf_len)
 		goto out_printk;
diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
index 8ecfb94049db..154fbb39ca0c 100644
--- a/include/scsi/scsi_cmnd.h
+++ b/include/scsi/scsi_cmnd.h
@@ -144,10 +144,11 @@ struct scsi_cmnd {
 };
=20
 /* Variant of blk_mq_rq_from_pdu() that verifies the type of its argumen=
t. */
-static inline struct request *scsi_cmd_to_rq(struct scsi_cmnd *scmd)
-{
-	return blk_mq_rq_from_pdu(scmd);
-}
+#define scsi_cmd_to_rq(scmd)                                       \
+	_Generic(scmd,                                             \
+		const struct scsi_cmnd *: (const struct request *) \
+			blk_mq_rq_from_pdu((void *)scmd),          \
+		struct scsi_cmnd *: blk_mq_rq_from_pdu((void *)scmd))
=20
 /*
  * Return the driver private allocation behind the command.
