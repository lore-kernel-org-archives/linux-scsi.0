Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6EA22A4E1
	for <linux-scsi@vger.kernel.org>; Thu, 18 Dec 2025 03:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766027944; cv=none; b=JRYzrBDOi/C6rGh6TgvHHr3o2kkm3DkBtljJo74wPBMYwRpFs2GzhCgH/rxS/gSoIEAnxH/dx2l99WBnGi3ECHmUTa50bCDXMBwKpogHKn7GZfrQDk2GUzMlSw1xm0yD+e8KEMYmmp/31Ike4e0oX+NEdBW244ZbhUTUYsz3aNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766027944; c=relaxed/simple;
	bh=v1R2FeUdsh8c+D7pBkmYDxzHMQLMdgqBB47qg4S1O1g=;
	h=Date:Mime-Version:Message-ID:Subject:From:Cc:Content-Type; b=Qtfy5+6M1GItAl3u3MoTi9CGWQ2jSnaF4F/nh9y/oorESyEzCEtQ8S22kKvqVzW2o/vXkeHZDSHDYHFWJTxp23JmGjqD3IHDLEARle1NbxXF6F+kb9/x/oKstoedaqXhcYyJukK99yggWpmVvyHutLE5JnAjx8BHHGi9fIxXUHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=c7VwqtNP; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="c7VwqtNP"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2a0c495fc7aso2910495ad.3
        for <linux-scsi@vger.kernel.org>; Wed, 17 Dec 2025 19:19:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766027941; x=1766632741; darn=vger.kernel.org;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=YnuOovVocZI5dyVp7wYcO4LwVFuO57orgM+M0+yB+pE=;
        b=c7VwqtNPlsDgUyr9VacUWUrRK4pWKO2woytgpRpspuhaG5/cHrKHbbGNknxbEd2G0M
         6H/3gqMYEOtBFjjemao8IGOMeJYfjFqo64onWh/Au1kln8jMImZHNR51sWcC1j5PLe4Y
         Dfk1fZ+MKuKT/qwlilfged7rN3ES03YQoQ2sXUAgQ+rGs7RigLugGnw+xv1DXTAvECvc
         pIwQ1MAwADyEOD7sUMX2uG0LsyXXEmwi6hOzWrkJaQjBLvUyPAO0OFZlQ5/h5wrKWqZ8
         joqPYQBE5lftn+1bKi1wJjrRukgNKiMg8/fltdWutf57jLr18sUb+pekKtyNqcZaGTF7
         h9cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766027941; x=1766632741;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YnuOovVocZI5dyVp7wYcO4LwVFuO57orgM+M0+yB+pE=;
        b=lf2E9v5xOirE8WiFA5/Sfc44ewDkMmkW7ZY5YyGhDWdbLaRhLyOz+9a83wYBVt+CD+
         UedGFydHhaNkklSdJN9iXn+F3zx+48eMsiGoovOu2TmlytqIgLReah+eJ3+MHkcRnfCj
         sTe8cTM68Pqs8bvdVJcWkS2BE2mOufu97fOakeuKoupGGScUdKUN4mi3Sj5bUtIZdfHT
         iT2Ky9DKmVNRnEPPUriXZZQAu7k8EfCxKAHYiE+Mo5lvzVDCs8EhFDBepdl7QKn+HEWm
         GiHNe1xqPbQEa2qlGkS9suxNhzouL9DLbHIU2HuHBJC/h28O9ictIE132ZIK1KQPeAUp
         zHHg==
X-Forwarded-Encrypted: i=1; AJvYcCWLF13ujkxbF3IVbb45AQam8r7q7gLFqaYUEm6TQYY7ns56g8LGA+S0Kf1NKHp4PxmEY9bCRYuzkH3z@vger.kernel.org
X-Gm-Message-State: AOJu0YwT6tjupz8KctKbCqxPUIVubVbBXwuz2mOvbJKPxKaNHhyXxdp0
	vKJYGlA9Go5Licm9W9We5F0AaiLvJhf2AWwSl5K4GpN7Q/a+01lLfGOgtVYZ6uXMdJG82cQyNFP
	tcmlU1S2mr76i4w==
X-Google-Smtp-Source: AGHT+IEc/nby3DshaoLBnauxO3k6/gU10jiLPRgUPnz0noZPEPg6eS7GLcKK3VV1GERTQ3rnBGePruy95ripNQ==
X-Received: from plei20.prod.google.com ([2002:a17:902:e494:b0:298:1151:5f6d])
 (user=powenkao job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:1986:b0:295:738f:73fe with SMTP id d9443c01a7336-29f23c7d087mr188948475ad.30.1766027941340;
 Wed, 17 Dec 2025 19:19:01 -0800 (PST)
Date: Thu, 18 Dec 2025 03:17:23 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.313.g674ac2bdf7-goog
Message-ID: <20251218031726.2642834-1-powenkao@google.com>
Subject: [PATCH v3 1/1] scsi: core: Fix error handler encryption support
From: Po-Wen Kao <powenkao@google.com>
Cc: hch@infradead.org, Brian Kao <powenkao@google.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, 
	"open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

From: Brian Kao <powenkao@google.com>

Some low-level drivers (LLD) access block layer crypto fields, such as
rq->crypt_keyslot and rq->crypt_ctx within `struct request`, to
configure hardware for inline encryption.
However, SCSI Error Handling (EH) commands (e.g., TEST UNIT READY,
START STOP UNIT) should not involve any encryption setup.

To prevent drivers from erroneously applying crypto settings during EH,
this patch saves the original values of rq->crypt_keyslot and
rq->crypt_ctx before an EH command is prepared via scsi_eh_prep_cmnd().
These fields in the `struct request` are then set to NULL.
The original values are restored in scsi_eh_restore_cmnd() after the EH
command completes.

This ensures that the block layer crypto context does not leak into
EH command execution.

Signed-off-by: Brian Kao <powenkao@google.com>
---
Changes in v3:
- No change. Repost as discussed in
  (https://lore.kernel.org/all/20251208025232.4068621-1-powenkao@google.com/)

Changes in v2:
- Guard inline encryption fields with CONFIG_BLK_INLINE_ENCRYPTION to
  fix build errors when the feature is disabled.

 drivers/scsi/scsi_error.c | 24 ++++++++++++++++++++++++
 include/scsi/scsi_eh.h    |  6 ++++++
 2 files changed, 30 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index f869108fd969..eebca96c1fc1 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1063,6 +1063,9 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 			unsigned char *cmnd, int cmnd_size, unsigned sense_bytes)
 {
 	struct scsi_device *sdev = scmd->device;
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	struct request *rq = scsi_cmd_to_rq(scmd);
+#endif

 	/*
 	 * We need saved copies of a number of fields - this is because
@@ -1114,6 +1117,18 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 		scmd->cmnd[1] = (scmd->cmnd[1] & 0x1f) |
 			(sdev->lun << 5 & 0xe0);

+	/*
+	 * Encryption must be disabled for the commands submitted by the error handler.
+	 * Hence, clear the encryption context information.
+	 */
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	ses->rq_crypt_keyslot = rq->crypt_keyslot;
+	ses->rq_crypt_ctx = rq->crypt_ctx;
+
+	rq->crypt_keyslot = NULL;
+	rq->crypt_ctx = NULL;
+#endif
+
 	/*
 	 * Zero the sense buffer.  The scsi spec mandates that any
 	 * untransferred sense data should be interpreted as being zero.
@@ -1131,6 +1146,10 @@ EXPORT_SYMBOL(scsi_eh_prep_cmnd);
  */
 void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 {
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	struct request *rq = scsi_cmd_to_rq(scmd);
+#endif
+
 	/*
 	 * Restore original data
 	 */
@@ -1143,6 +1162,11 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	scmd->underflow = ses->underflow;
 	scmd->prot_op = ses->prot_op;
 	scmd->eh_eflags = ses->eh_eflags;
+
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	rq->crypt_keyslot = ses->rq_crypt_keyslot;
+	rq->crypt_ctx = ses->rq_crypt_ctx;
+#endif
 }
 EXPORT_SYMBOL(scsi_eh_restore_cmnd);

diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 1ae08e81339f..15679be90c5c 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -41,6 +41,12 @@ struct scsi_eh_save {
 	unsigned char cmnd[32];
 	struct scsi_data_buffer sdb;
 	struct scatterlist sense_sgl;
+
+	/* struct request fields */
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	struct bio_crypt_ctx *rq_crypt_ctx;
+	struct blk_crypto_keyslot *rq_crypt_keyslot;
+#endif
 };

 extern void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd,

base-commit: 8334f93075dce0a4536c096a7d471ef90506a7a4
--
2.52.0.313.g674ac2bdf7-goog
