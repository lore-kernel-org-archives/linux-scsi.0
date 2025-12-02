Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65D121684B0
	for <linux-scsi@vger.kernel.org>; Tue,  2 Dec 2025 01:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764638172; cv=none; b=lcv23Ab/vLU0CByQchfKRITwAiNp1GK72P03BB/xGV2K+pcFbcQEhUsp0m3glWCexXedtJeoKwRun9Xe2PpAmu2C1WW6uCsAnxbtsvqimoDR5Z9uEAST+YYvGToxq0a76lP13Hc+rga1fR9uk9WC8I7Ksui4kXtYQ+Opy3ZheeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764638172; c=relaxed/simple;
	bh=hy2vG55294VSeJyGO7Ev1IoxTiCR2nljMSD+0AWZ5vo=;
	h=Date:Mime-Version:Message-ID:Subject:From:Cc:Content-Type; b=eN7Ebdxx8e/QNdQcABJCcYLI5FJsnx+Ik5q8+k+9gwORtndB8KIGcLZv7ZXNjcUjP6Eg4yCNaeOBX7Tr0HSs6UROjJ5OEcVBGpBXlrNxnASNxIssKuNkPMJSP26QteWXq6jRlt/zMZ7s2almDd6psWqdan1CC5yk8a7lzMxcATI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=x4f2k8F3; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="x4f2k8F3"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-295fbc7d4abso59955415ad.1
        for <linux-scsi@vger.kernel.org>; Mon, 01 Dec 2025 17:16:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764638171; x=1765242971; darn=vger.kernel.org;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XSTXeBO97Cv2Jpm4yedy9AByTs1BE3v3LHZMPe5Q//E=;
        b=x4f2k8F3ZPGc9IWJK9WKlC/jNmWuSI6lU61lLyxbCMf9XMB5Sckma5UtF3Nw3ycZXV
         tra9LiwqfHOS5wEff7jodxX5WwMfktKP0BUowHh6JKYghqhy9ZsyVNgl4++U1mkc0eue
         Ji8Gv/oE88403BbwgzoM8YnpSKG4THmP3rwZFMeX7D0O8p5fJZ0MaKohoX8Hv3mX1e7t
         gNjx0JowHCtaebU7ob/oySgGZ9RqW32erelje4snQNqw38pVe/OMIMr2M/wHcmC+YVMG
         gj2Zl4OjBJxrlkZOzoUeRGAUPY+GC6BtmEzrJVUVAMGwo8YnBYA4M/marJDPAeFN/cxB
         JGbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764638171; x=1765242971;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XSTXeBO97Cv2Jpm4yedy9AByTs1BE3v3LHZMPe5Q//E=;
        b=l79gXqKoTA6uqmzmR5aFfSragRH+c8iwGVEfbOi4Id5fVlUk5nK2wF2/AJuhE2iazR
         ZSdO+kKqko6NVwUAHQGgcXkfrpMeG6O9T0t8hE3M9HNrzaBHr1e7FumPzEshTva1vn72
         ZtRx4AFf+GvZGFbT+G0NQCo7PcGB6Qt7tzfquR4iTC/5tuiSLQyH9vUVvTUqbqmctiPE
         nh/dPd8G+5Pm5S29nBT8aY+iYaK5BtTEwBAm3T4w7nVbXWr4/LjyWLWWDWrevHBIBzSa
         nGnFKHhhzHWiydU7U5MmrauV9+o5JAhBou9JR8acRn3Whp3oX3BxDexEbvxRsxQ5sL7m
         fQWA==
X-Forwarded-Encrypted: i=1; AJvYcCVxsdDKA0ara1wP5PGcAMIKoW3OQl9IzCzBQHVVS0NEWGMyRgdUWeaf1Okxqxz226wT/z7kwngbUYgE@vger.kernel.org
X-Gm-Message-State: AOJu0YwaqYpLqwIFzrHDyDEev5Gocg1T3Fs55l0+CCWcDfrRa3AOCqXc
	uo4B2km6mIc3N1Jv2lFfwA0bZHh04wGA3o4MKzQp7wQw6Sr0zzQhHADh0CGPnNCUQjzBUeQx9re
	1UXJt9UIFmZ5bZQ==
X-Google-Smtp-Source: AGHT+IFnL1DhtzCUFS4I16Soc1IQNk/CEVOnOlLi/gtYubNtUtBCzVuwI9AN26cMeR6+V76YtL1ocbNdP84ljw==
X-Received: from plkl3.prod.google.com ([2002:a17:902:d343:b0:297:dac5:aa2f])
 (user=powenkao job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:ef09:b0:295:1aa7:edf7 with SMTP id d9443c01a7336-29b6bf3bd88mr440108865ad.30.1764638170683;
 Mon, 01 Dec 2025 17:16:10 -0800 (PST)
Date: Tue,  2 Dec 2025 01:15:27 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.177.g9f829587af-goog
Message-ID: <20251202011529.73738-1-powenkao@google.com>
Subject: [PATCH 1/1] scsi: core: Fix error handler encryption support
From: Po-Wen Kao <powenkao@google.com>
Cc: Brian Kao <powenkao@google.com>, 
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

Tested-by: Brian Kao <powenkao@google.com>
Signed-off-by: Brian Kao <powenkao@google.com>
---
 drivers/scsi/scsi_error.c | 16 ++++++++++++++++
 include/scsi/scsi_eh.h    |  4 ++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 10154d78e3360..2d0df74df703a 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1040,6 +1040,7 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 			unsigned char *cmnd, int cmnd_size, unsigned sense_bytes)
 {
 	struct scsi_device *sdev = scmd->device;
+	struct request *rq = scsi_cmd_to_rq(scmd);
 
 	/*
 	 * We need saved copies of a number of fields - this is because
@@ -1091,6 +1092,16 @@ void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd, struct scsi_eh_save *ses,
 		scmd->cmnd[1] = (scmd->cmnd[1] & 0x1f) |
 			(sdev->lun << 5 & 0xe0);
 
+	/*
+	 * Encryption must be disabled for the commands submitted by the error handler.
+	 * Hence, clear the encryption context information.
+	 */
+	ses->rq_crypt_keyslot = rq->crypt_keyslot;
+	ses->rq_crypt_ctx = rq->crypt_ctx;
+
+	rq->crypt_keyslot = NULL;
+	rq->crypt_ctx = NULL;
+
 	/*
 	 * Zero the sense buffer.  The scsi spec mandates that any
 	 * untransferred sense data should be interpreted as being zero.
@@ -1108,6 +1119,8 @@ EXPORT_SYMBOL(scsi_eh_prep_cmnd);
  */
 void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 {
+	struct request *rq = scsi_cmd_to_rq(scmd);
+
 	/*
 	 * Restore original data
 	 */
@@ -1120,6 +1133,9 @@ void scsi_eh_restore_cmnd(struct scsi_cmnd* scmd, struct scsi_eh_save *ses)
 	scmd->underflow = ses->underflow;
 	scmd->prot_op = ses->prot_op;
 	scmd->eh_eflags = ses->eh_eflags;
+
+	rq->crypt_keyslot = ses->rq_crypt_keyslot;
+	rq->crypt_ctx = ses->rq_crypt_ctx;
 }
 EXPORT_SYMBOL(scsi_eh_restore_cmnd);
 
diff --git a/include/scsi/scsi_eh.h b/include/scsi/scsi_eh.h
index 1ae08e81339fa..9ef97f7820886 100644
--- a/include/scsi/scsi_eh.h
+++ b/include/scsi/scsi_eh.h
@@ -41,6 +41,10 @@ struct scsi_eh_save {
 	unsigned char cmnd[32];
 	struct scsi_data_buffer sdb;
 	struct scatterlist sense_sgl;
+
+	/* struct request fields */
+	struct bio_crypt_ctx *rq_crypt_ctx;
+	struct blk_crypto_keyslot *rq_crypt_keyslot;
 };
 
 extern void scsi_eh_prep_cmnd(struct scsi_cmnd *scmd,
-- 
2.52.0.177.g9f829587af-goog

