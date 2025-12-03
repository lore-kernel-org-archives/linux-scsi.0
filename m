Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52983245005
	for <linux-scsi@vger.kernel.org>; Wed,  3 Dec 2025 07:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764747246; cv=none; b=QAci687iz7ynq4l829qK7PHVbK2KJVa1Zg59WmdeD0hb1qm1LroJWVBubGyf9bEr53ggbKRqj6G0gzbjnVcwEifFc/jg7P4ch88bYYzMbsz/fD5PRsMOMcyy+BFP0KvDRBbvhKMhB3iCTy/4xC1PSbJp8eKwuHst48kPB3RSpIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764747246; c=relaxed/simple;
	bh=FU1xTPzxVeA52OKCz1tok0V1zUWazLF35nBqQK8iRIE=;
	h=Date:Mime-Version:Message-ID:Subject:From:Cc:Content-Type; b=IWxFWlqGRpCobdDhnoMTj7FmofnHoC7TLqXwTRXGTLgl+U99gtMX2QrducIXMSgP/zOeFaau1u8xn8NksHitLZygl86PoNtIcOUSQD9j6tDOz4EIhUkQfNOK2SxZGOWCsatPocztrJ1A7HUM4xwiTgKrtHagpPJP3Lb9AiA3SDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Kw3ILAfN; arc=none smtp.client-ip=209.85.210.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--powenkao.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Kw3ILAfN"
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-7baaf371585so461401b3a.0
        for <linux-scsi@vger.kernel.org>; Tue, 02 Dec 2025 23:34:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764747243; x=1765352043; darn=vger.kernel.org;
        h=cc:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+H2lU3rUEYq83x64LdXSDMxTKjogpBWHqerqd9u3uhI=;
        b=Kw3ILAfNZM6/KiBLjTs7yu6tUVALbdFp7deSYBhLcF0UDBONxaKjz15oCBlgk87kKb
         puaY/3Q3vVNmAt9uMpqG/yEcLwnUPvPP3Zxd3HtY+YuN56vBhp5VHsCtR0+1s0aBsxVo
         hMbNnikbtyU/Fvbj7yOQveUq/1ADXv5fa/ndpLZnVuoF4aT79lC0cTiRAHkTU0WgCQqS
         6qnFBpmHQhZtx2/K8mDUNSOGtcuoGeYxgZ+/o8MeBR3tsrVXRCaHfou2bhQc3+h7L3Td
         x0mjy8vdC10xJ/FWApvKiVlBQdoUWbZXD2TM+7xlYk7b62WRgddbmhNN6FE6byShw6KU
         zBxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764747243; x=1765352043;
        h=cc:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+H2lU3rUEYq83x64LdXSDMxTKjogpBWHqerqd9u3uhI=;
        b=oszBM9VHVORf2oCcOeH0aSEceU6gC5OkxeiNx2S58RPJQRs1hSXQONqiDPoGcS7YC4
         ApLqGoAVinLHyePGzicC31lITIEP7jPdUhyQSu6ljshiOqh2MKyAMR8MhuCZGUvhyIVw
         jMY15YCXUWekI0ArVh0XBw4aEQlM/SH8OhY+QqBJXjH8no88U09aBdgLDWcqe1A7a/Tr
         Lyi5mMb4O+IUiDYwPVs62CfIpscLP3WTQPei7CJcpMSXS/Zzj9uEPAvwa6DLgiqzKEKR
         g4tNM5NToqrmPQTSPkecSaaD4mg7eV4NC+DpbDLpQ4q7f5JcZUNk8fz56HZzA7dXN0P0
         75Gw==
X-Forwarded-Encrypted: i=1; AJvYcCXYUNJlCmNc0lmGBFS9HYLsWaV3M+yDbpnXw4NEVYN7i3pvB0ZQZzCh6nvPldpt9kqJhMQm7R+5eHdw@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6zK5BQTrElEk34X6fTGv6U6Uf5iaB5C3bMiHJjzcd6S2v294J
	fE+Z0jm8VfYbWZQCFHjNqsux/arOj/3zMVKpXUiPtDuPPx5nyFdzVMbTzVNMwFZv8a5nCqhqJqC
	pUnMZA+lA+Jwh5A==
X-Google-Smtp-Source: AGHT+IHQMkyQkMXy4WiLdBUkDcqI5qbDfmDyU2ZvuRY8ZHpPNEcP0HDUo80q9w9IHtiPRhpjY1QrMGnijw5BDw==
X-Received: from pgee23.prod.google.com ([2002:a63:1e17:0:b0:be5:9a9b:6b5d])
 (user=powenkao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:939e:b0:35e:fedb:ab47 with SMTP id adf61e73a8af0-363e8d81c95mr6316258637.29.1764747243429;
 Tue, 02 Dec 2025 23:34:03 -0800 (PST)
Date: Wed,  3 Dec 2025 07:33:08 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251203073310.2248956-1-powenkao@google.com>
Subject: [PATCH v2 1/1] scsi: core: Fix error handler encryption support
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
--
2.52.0.223.gf5cc29aaa4-goog
