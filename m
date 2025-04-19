Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B81A32D613;
	Sat, 19 Apr 2025 22:59:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745103567; cv=none; b=A5X4HW9Df1sUZZ/YMERSzSLGKtRYuKV2QcwVy+E7cD7bqrx+K44aInkee1XrCP6TdI1WAvYwuvx3xjElknf0SOZZGYxInIMPlCKMQJ4bJbj2tqE/k+K9JzjWhLyP1gvplSt68och6zKgOsCJOsmi09Z2umvjNN7RmtOw+VpahiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745103567; c=relaxed/simple;
	bh=iF3JbOZE4i5WNX+wk/TlXY1/bnbHCJiEGhGMvwua0So=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=It5cR8Pogn207wR1zzqR1dJcbSkvllGB88kzcZs0t54MUuPNW1FJbEeOMPwGj4dv4USkReQx3veFZO0YIk6Eme9vgHuYfZYHuWWFhdJXuRJT6O5v00e9JkFcN/c9LUzOc70oxq1xlvzF8Tl2cGHOUuiOFgh51M+3ipJ+yK1f27Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SB0W4psK; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SB0W4psK"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-2c2dc6c30c2so774262fac.2;
        Sat, 19 Apr 2025 15:59:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745103564; x=1745708364; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=YI/TlWQdCbvuMLmH1bUUd4FofygRfsE4cplozPW1cho=;
        b=SB0W4psKzFskPwx+bIFjon9vYDnu+pj75+IzfLXSkydmbfqea4KHC61MOlBqhUHaHf
         H2wL+lSWIUIspbbpep/3ibXDyUzulR+JN+eKwYuo/1QSC0/dmmzzEffMAuSCZWI0roMu
         Y64YNsxPs1wiO7WslY40QrSGMOD12tNcXTUuU6SDIvHeYbLlcJW8aV3p2mwg49AxqVJu
         8l4g1DrpxcybIQdvGH8DyKshAsKcRUPD5Eyl5q0BVsScfvAA7zwvr0LzThVLMAlbJRnG
         wg0saMnUHYeBT5E9EgUB30OIdEYEL/c0O08yH75A7/1FKXTzzqZ5OBv0Bx5qwst6pzjN
         7B8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745103564; x=1745708364;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YI/TlWQdCbvuMLmH1bUUd4FofygRfsE4cplozPW1cho=;
        b=PmZbukbYwUFeLPPZHKo0erlNr0941w4yjhQQDtFJA8u6XvtEhLCd5s9Q/10Vr5ezza
         vpAbLDjpfxAWqiBL+O0dLXGX/iOmTBSgdK5OVXHmGAzpJ3byGHrBaEd4wxFVlQBNqhXF
         NlpSzrXTcOLwq0aSkjaKdgPui6e4CZ3Vp0uOvFZC3np4E+5QMTXbtf8ZAwsrrvZSCIGe
         Re9giiFbr42yPVTzQKiOkHzeQmndruhHYCe8LFNnoeneyLIevsmvceywPPCclhOM0UBN
         0+G1go0HOBeWBunKTW1rGiusLyDhcM0stt+F8+WeyPQoyLfoxxSpxx9rScNf+mw3HIWj
         uK2Q==
X-Forwarded-Encrypted: i=1; AJvYcCUF2l/oCQJVpwnuwDUILAO9UH2rt1UTSwXJiXfYevgFjYE63TaRrLLNJIjAKHIGlgO5peMnHVcndvUvQyU=@vger.kernel.org, AJvYcCWKdl7QNPTXBe+16lYdvoUWj6k+l6kAFMW0fKA8Y3UtqJyiQyaW0SFIJmH6AnwvMZEGh2T1Y4vBinb0Og==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4/lIAXcMSnRlMxPwaOoPGP9klMpknKxtmTEiHdhYa9gjQpGq+
	vkY57BH9sXbqjnt6WhzPoxHnYUud8fJj3jIAM2AfUEkr/U/OyyhOPpDeZVrC6Zk=
X-Gm-Gg: ASbGncvFwUDQdAchexTFodNhQUYkkWzfByDhDj9Wr9AJZEBKHpxhUhwh1eyPOB/x/Bj
	inAqi1ChA6+S4OxwfP1Wsy63bFTNaM0x5OuvyaKM6k4hqwItF4jcWK6bxqPU6UTuFQSPE+vK4Mk
	O7IweCMjALa66/e+6EWmJ2SaAqrcXWl8usb7EpwajmesjcOXU6dCEgqo0O6g5ajZOJBU3SsntIb
	jM6YCVQi/gvTNA6R4wbxlZaqN5kpKLLpxSgINAhOIegEyK14KQZTGlim9EEKzvsb+3ySy2NiXer
	pYNXaoYP8ZdudhYaAzjzs7BPd6ovnuWCmoNzVBPsgRFqypC3vg2tsEpzhcotDhwt3Q==
X-Google-Smtp-Source: AGHT+IHQjKLjbABcg+6y6NYzD8F8JzoDr/Qac93Buinxw+crU1nAmXloPn4zcfXj1ea2gTPY9W4m5g==
X-Received: by 2002:a05:687c:200c:b0:2d5:4f4b:2266 with SMTP id 586e51a60fabf-2d54f4b5c9fmr1994920fac.36.1745103564558;
        Sat, 19 Apr 2025 15:59:24 -0700 (PDT)
Received: from c65201v1.fyre.ibm.com ([170.225.223.22])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2d52135a972sm1153335fac.16.2025.04.19.15.59.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Apr 2025 15:59:23 -0700 (PDT)
From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
To: sathya.prakash@broadcom.com,
	kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	sreekanth.reddy@broadcom.com
Cc: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Subject: [PATCH] mpi3mr: Fix typo and grammar
Date: Sat, 19 Apr 2025 15:59:06 -0700
Message-ID: <20250419225906.31437-1-chelsyratnawat2001@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Corrected grammar, spelling, and formatting in the kernel-doc
comment for mpi3mr_os_handle_events to follow kernel-doc
style and improve clarity.

Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index c186b892150f..745cd958e34f 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2945,9 +2945,9 @@ void mpi3mr_add_event_wait_for_device_refresh(struct mpi3mr_ioc *mrioc)
  * @mrioc: Adapter instance reference
  * @event_reply: event data
  *
- * Identify whteher the event has to handled and acknowledged
- * and either process the event in the tophalf and/or schedule a
- * bottom half through mpi3mr_fwevt_worker.
+ * Identifies whether the event has to be handled and acknowledged,
+ * and either processes the event in the top-half and/or schedule a
+ * bottom-half through mpi3mr_fwevt_worker.
  *
  * Return: Nothing
  */
-- 
2.43.0

