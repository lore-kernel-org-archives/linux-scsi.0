Received: from mail-lf1-f46.google.com (mail-lf1-f46.google.com [209.85.167.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D640518641;
	Wed, 30 Apr 2025 12:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746014441; cv=none; b=YivSeeeZto30lx3OXx+N9+mDvCVquInnEd65PkcbbdKXorTllwpv4MR38t1IR4gpgXQmiRiE4nTiQqaUKJ53N2BV7mcMWtN9GSRFTO5th5uiBYf0ezGKvUm6NYUsLmlgsWK9mtC2q1iIl7kGF8wmBLkzhGovi4iZ5ajvFe31hKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746014441; c=relaxed/simple;
	bh=jF+DIY5JnqDc//M+YPQqY22Wq3fJUqVU119jdhtjRKA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=kQVO6icoQO2opV1u0p0zDi+n6QoZtiTaPZqvNyZNg9FYJLvvv5xqfl6ZSTDH4EIrxAALoedpegaiRGdYmAFNs/cAAZ0wAEEy66jm9Y2q1mPEEEkFIZsPvgkOLp97OHqPlT8aqLCl3kCGbZD4kAGCwj3/usDDFMiwz5gutHN0Kw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c9sxhs2/; arc=none smtp.client-ip=209.85.167.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c9sxhs2/"
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-54298ec925bso9371862e87.3;
        Wed, 30 Apr 2025 05:00:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746014438; x=1746619238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IVVuEjYJOqn+boZBin8W4czftfuQ4zS8Ah33rhpA2vE=;
        b=c9sxhs2/M48Bd/ebfe7AFaF5KBU0W2mIy3wmylEtr454bp5SRU3bPM5ByR9/3kF9rR
         G+ZVQ0xR9Nj1OH4c0CVZx1e9JBRQp9ivbhGHsoWSTx7m8IRHkmyjkayJBv+GJZOz5cTm
         v5l3uxLfpOYQZ4Qv/ZxZxoA1krg4WuPAMKSDcqcSJ23XmFmgAgYZ1rBYtxtLpKfsJUqW
         Lzi9UmWtpehALuBrIaCsKnIkCoY5dLHU1NFgKRlgjDr0cH+ZYVMRff01n97px6K23ALq
         yroMTGP17ZnA71IHBAqbsmdO6DfHFm9hPhLBm/YPu5y2FR9sTh29HnaNwIQ0LRm0cr6i
         jrIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746014438; x=1746619238;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IVVuEjYJOqn+boZBin8W4czftfuQ4zS8Ah33rhpA2vE=;
        b=ZCbFnqISKDWjePImIFz5zWpI9DO93MbplcqJBQBxeTf5x+G5JoCYDyIQkL80bMm5kJ
         BI1isxJlCGkXXgoCtDi6j3Pw9N7cmNHAZs0oyFPAW1hxPfhfNPNCWUtkO1ZVlTuCywwv
         0CckEwI/+45yPp/TRkjjmxBvaXViAkgXW8EQ6Ix61v15PvGrKLDFa71/3lM0OCFfeOSK
         36XoAFK2rI7tr5rN/fMzLC3R4vHOVJh4fEPV2JM87trjB2QtvYhzTXgfpqI0OPpErzLf
         VAcWhZdN3y9qxM1S3XnQYmjj6n+eihG+VCXVV1mb2g981BDn93Ww/fhAYqmYFfX36NEs
         Iltg==
X-Forwarded-Encrypted: i=1; AJvYcCVjAuLkabGaJnFNp1Wq3dW9S98PNA2FEGWKRDtyAAeVNpNr7QUYCIReUVDU4aXbwJKef+n7j8lU+RrVIFg=@vger.kernel.org, AJvYcCWnQbxBKDjmLiQGFLr0jzvkzU07nsC7L7jYgEG+yvyX7klpr0M09BuFGLYaJSk3k1Sa7gMwCkWSWFPx3g==@vger.kernel.org
X-Gm-Message-State: AOJu0YzjXC5Qv7ZK0natPAXkNTXeVBv3hTMG+5IQ508Xk/4/x5tMTL97
	ax7S9nzpgmwIxYLVM6euNzLH/BUebjf1qKdZ+DNn8XPtuDKMfG/F
X-Gm-Gg: ASbGncu3iY/epPxNvt1hWANXftle1r+lj8zbF2Shj95E064IikzzgyCFf5ciSvQdF0I
	HZB7henitcaB13TJWosC2Xybz6CI2gKGPZTF0Bz019GmmEE5gw+h3qxjrEFFMJFCbyH/KhAYzQ8
	4tFGq4eD+v3DwfIIGqX4WimD3ij8YjyLzgnFkZNX+oRjc0sEzQLbrQYlpJMn0q02sCdaTOa7h8s
	c625ZIvsRjFXFE9qerO7EBziQ6Rlf9manOdse95R8MvQVK7wiPM0qq83kziOKh76Aq1mToLdxHW
	esT/nl6b7IEeD92OE3Iw1sV5/YRtt74Rxh2MDQFOOudfhrG+z480gQZQd1V588hBrWQakNWni4S
	WhRQjrHimD6sAH0OWDg==
X-Google-Smtp-Source: AGHT+IEMAC/mLk5WMRaMl7FNmuEoCvirpF9/OeYheJM75rzfV2gAUEOP6wpe4St7JmW+Dee07/rwIg==
X-Received: by 2002:a05:6512:23a3:b0:54d:6a89:8722 with SMTP id 2adb3069b0e04-54ea33643f2mr761914e87.29.1746014435989;
        Wed, 30 Apr 2025 05:00:35 -0700 (PDT)
Received: from rand-ubuntu-development.dl.local (mail.confident.ru. [85.114.29.218])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-54e7ccb7ef9sm2151866e87.231.2025.04.30.05.00.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Apr 2025 05:00:35 -0700 (PDT)
From: Rand Deeb <rand.sec96@gmail.com>
To: Finn Thain <fthain@linux-m68k.org>,
	Michael Schmitz <schmitzmic@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:NCR 5380 SCSI DRIVERS),
	linux-kernel@vger.kernel.org (open list)
Cc: deeb.rand@confident.ru,
	lvc-project@linuxtesting.org,
	voskresenski.stanislav@confident.ru,
	Rand Deeb <rand.sec96@gmail.com>
Subject: [PATCH] scsi: NCR5380: Prevent potential out-of-bounds read in spi_print_msg()
Date: Wed, 30 Apr 2025 14:59:26 +0300
Message-Id: <20250430115926.6335-1-rand.sec96@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

spi_print_msg() assumes that the input buffer is large enough to
contain the full SCSI message, including extended messages which may
access msg[2], msg[3], msg[7], and beyond based on message type.

NCR5380_reselect() currently allocates a 3-byte buffer for 'msg'
and reads only a single byte from the SCSI bus before passing it to
spi_print_msg(), which can result in a potential out-of-bounds read
if the message is malformed or declares a longer length.

This patch increases the buffer size to 16 bytes and reads up to
16 bytes from the SCSI bus. A length check is also added to ensure
the message is well-formed before passing it to spi_print_msg().

This ensures safe handling of all valid SCSI messages and prevents
undefined behavior due to malformed or malicious input.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Rand Deeb <rand.sec96@gmail.com>
---
 drivers/scsi/NCR5380.c | 25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/NCR5380.c b/drivers/scsi/NCR5380.c
index 0e10502660de..2d2a1244af62 100644
--- a/drivers/scsi/NCR5380.c
+++ b/drivers/scsi/NCR5380.c
@@ -2026,7 +2026,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 	struct NCR5380_hostdata *hostdata = shost_priv(instance);
 	unsigned char target_mask;
 	unsigned char lun;
-	unsigned char msg[3];
+	unsigned char msg[16];
 	struct NCR5380_cmd *ncmd;
 	struct scsi_cmnd *tmp;
 
@@ -2084,7 +2084,7 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 	msg[0] = NCR5380_read(CURRENT_SCSI_DATA_REG);
 #else
 	{
-		int len = 1;
+		int len = sizeof(msg);
 		unsigned char *data = msg;
 		unsigned char phase = PHASE_MSGIN;
 
@@ -2099,7 +2099,26 @@ static void NCR5380_reselect(struct Scsi_Host *instance)
 
 	if (!(msg[0] & 0x80)) {
 		shost_printk(KERN_ERR, instance, "expecting IDENTIFY message, got ");
-		spi_print_msg(msg);
+
+		/*
+		 * Defensive check before calling spi_print_msg():
+		 * Avoid buffer overrun if msg claims extended length.
+		 */
+		if (msg[0] == EXTENDED_MESSAGE && len >= 3) {
+			int expected_len = 2 + msg[1];
+
+			if (expected_len == 2)
+				expected_len += 256;
+
+			if (len >= expected_len)
+				spi_print_msg(msg);
+			else
+				pr_warn("spi_print_msg: skipping malformed extended message (len=%d, expected=%d)\n",
+					len, expected_len);
+		} else {
+			spi_print_msg(msg);
+		}
+
 		printk("\n");
 		do_abort(instance, 0);
 		return;
-- 
2.34.1

