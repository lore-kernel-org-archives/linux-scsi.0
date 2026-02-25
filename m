Received: from mail-qv1-f66.google.com (mail-qv1-f66.google.com [209.85.219.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70B46378D8F
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 23:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772061243; cv=none; b=uD1tQ7tMvAAU2nymkZN1ZAKJDnOjtW20H4jcaYu9wrcV/WXSUNgGSLm+r0syKEX2i4OKwn4NJ72zvU59ByP00bOeAA7qBQ3q60HtYPZ9jnKuMH3BaZNwLq0VVbg6qD1jIjFT66nTmnM4QrNvGtDTSwEN0Jwf3IjVIdRsaDpf8jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772061243; c=relaxed/simple;
	bh=ZKupJcpDk412tRvHx2oY49WGENTOA6g3D3dL6CQUfEQ=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Z7pSx8KFj4gWmM6Cr7tQe//02oW4LyQ0edqMJqZQ6mLLGhCB/YmnvHUIynkiIVxJ03NjOYhJfQFwGG6v6hSs0cxK3UUyvlO0T0IUMc9eqJtkPgcs1J2BYyJdQPJrksWxvLjkKLWL8z11E7MuKP8wgA1VyFybPui10BqttL9k+Qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ei71Zzlx; arc=none smtp.client-ip=209.85.219.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ei71Zzlx"
Received: by mail-qv1-f66.google.com with SMTP id 6a1803df08f44-8972a14e27bso3193056d6.2
        for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2026 15:14:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772061240; x=1772666040; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Zo072AtpeglW5vzuPR7O93iMv1AZlyADWsBJMQs7nY=;
        b=Ei71ZzlxxOnhj3ixJoCmpmibX52CXAmVyLwE+mIcqeCWvm8bRSif2vJyKHRSPyXwFT
         713Uk1/28r9Nqggh4WfheM+Uszg01dhwlRQ13EozAV8Eu3UFN7Tx4c4VzJk8CMY1td5A
         Keleci7Z/aVtGIagZjppDC4AcRh7L5QTJuvCv4h844lp1LxvvyrLNCU7HrExj/fbxJW7
         QF9XLpVWM9d8akUKYlooHsRvBNykeaNnop7CgSRkDbRzYKAx9yQfcAbaLO/6tqZsh56M
         PM056WK2+UMMCN6Jj7AtraOqqA4K4ExEPj/u48E5nET+DvrbJqlbU1GiBhWmFmKKJGS+
         uDuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772061240; x=1772666040;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6Zo072AtpeglW5vzuPR7O93iMv1AZlyADWsBJMQs7nY=;
        b=YuYT7t+NNBKLWUQP7xsddiAOFRU2IifB4wpAZLj+X71+O1oLrwzKYY7mceB0aI5Kdt
         7wxp7nf766U4PQQ97/jCf/LoPwKvYiNG8tZXuI9yuCjwQrIBlUIttLMDjvki1bTg1S7Z
         yvwkKsfuyMSjnc3n5+SmyX2+zqU/QJbv4qw9BQIrc1jKBUoQUPRxFjzzkK7EZ2A6Pate
         INmKabiUcNvStHpeWsXeDeoA8WL0KAzNANZnt/vapSSBpiaD9oAlV0DUJXnfvQDfFaRl
         Kqt1JYm15RyXosMZiL+hl/crqUhhlMG01Z+vdh0QAIHanMw9k96mAPK4kOg6s+iiUsNX
         DIMQ==
X-Gm-Message-State: AOJu0YxECOzpAgMx5rdYjhcEu0jbMjiJRA5tT6jxQcCsgUd4bIF+QIwN
	nbZUq7KNbGwY8zBexDN1iIz/JKE8T92UpziWkJ+gZyyAIO7xa3T1rKac9YEPMlUi
X-Gm-Gg: ATEYQzxCN5VegxwV2hRRHYLhaRBH9zp8uoEygqgsCw+RfbpfLVgncWsvHF4albyMhaj
	iDeSyOuyY0o2SYhJ15u4HvPSwI8iUB2jSO1MDFzsTI9GGCTw2v3vCvEl7zHpTCYx+q2KYCWWzYs
	KEkhrPz4TXQLv+Ieg28nuYw2htI0SA8xK5D7RemLgaHBcOecNF6BDUZztGJODYeuKc7Mo0/rYId
	IVzRaZ7YbjeG/HWP9zwVTHp/YPZ3z5EqaxYSbfYUZCmRSVSvU+T6sN/n11sN7+kX14To4rcsNJ7
	nk26bG8IFR85jip0wjJC6ByEPM+0e/8F7p5gPEQ/5KaTc84sjXNrxvEg5xmI+00j7guT4lRDIap
	DK3BuiU4TnpkC3X0ovPjK/xZOIOJKx2Bt2MOeeJI+AbP48/Paie8IYDFNfDAIy44Xez7ofdmNkN
	mh5L1upx88cjWOVOD1RuXeYmnzQEwchBDBitbCzixbXHVgxoevwwJVwUIYJxaxr//sqDJMDTVJ0
	RxBkw==
X-Received: by 2002:a05:6214:1c47:b0:894:6622:a6d4 with SMTP id 6a1803df08f44-89979f32bf2mr252222636d6.61.1772061240013;
        Wed, 25 Feb 2026 15:14:00 -0800 (PST)
Received: from ?IPV6:2601:244:417c:14a0:214:15e2:6a74:6134? ([2601:244:417c:14a0:214:15e2:6a74:6134])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c7374e07sm2799996d6.33.2026.02.25.15.13.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 15:13:58 -0800 (PST)
Message-ID: <786c3713-ebd7-406a-bb93-ce43e249583d@gmail.com>
Date: Wed, 25 Feb 2026 17:13:57 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-kernel@vger.kernel.org, kylek389@gmail.com
From: Kamil Kaminski <kylek389@gmail.com>
Subject: Subject: [PATCH 1/2] scsi: core: Treat "Logical unit access not
 authorized" as permanent error
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

 From 21dfa18035fb03b9c141550aeded92cf6d23473a Mon Sep 17 00:00:00 2001
From: Kamil Kaminski <kylek389@gmail.com>
Date: Wed, 25 Feb 2026 13:42:12 -0600
Subject: [PATCH 1/2] scsi: core: Treat "Logical unit access not 
authorized" as
  permanent error

SanDisk Extreme Portable SSD and similar hardware-encrypted USB drives
return Sense Key DATA_PROTECT (0x07) with ASC 0x74, ASCQ 0x71 ("Logical
unit access not authorized") when password-locked.

The SCSI error handler currently treats this as a generic DATA_PROTECT
error. While it eventually fails the command, the block layer continues
retrying operations, causing excessive I/O errors that saturate the USB
bus and crash xHCI controllers (kernel bug 216696).

Add special handling to return SUCCESS immediately for ASC 0x74/ASCQ
0x71, preventing SCSI-level retries and allowing the sd driver to
handle the condition gracefully.

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=216696
Signed-off-by: Kamil Kaminski <kylek389@gmail.com>
---
  drivers/scsi/scsi_error.c | 18 ++++++++++++++++++
  1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 147127fb4db9..aceb7c55893b 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -692,6 +691,23 @@ enum scsi_disposition scsi_check_sense(struct 
scsi_cmnd *scmd)

          /* these are not supported */
      case DATA_PROTECT:
+        /*
+         * ASC 0x74/ASCQ 0x71: "Logical unit access not authorized"
+         *
+         * This indicates a password-locked or hardware-encrypted device
+         * (e.g., SanDisk Extreme Portable SSD, WD My Passport) that
+         * requires vendor-specific unlock software.
+         *
+         * Unlike write protection, this is a security lock that cannot
+         * be cleared by the OS. Retrying causes USB bus saturation.
+         * Treat as permanent failure immediately.
+         */
+        if (sshdr.asc == 0x74 && sshdr.ascq == 0x71) {
+            sdev_printk(KERN_WARNING, scmd->device,
+                    "scsi: Logical unit access not authorized - device 
is password locked, treating as permanent error\n");
+            set_scsi_ml_byte(scmd, SCSIML_STAT_TGT_FAILURE);
+            return SUCCESS;
+        }
          if (sshdr.asc == 0x27 && sshdr.ascq == 0x07) {
              /* Thin provisioning hard threshold reached */
              set_scsi_ml_byte(scmd, SCSIML_STAT_NOSPC);
-- 
2.53.0

