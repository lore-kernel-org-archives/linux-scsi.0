Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C6933A9F8
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 21:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782854351; cv=none; b=r/zevWiwagb7k0jL+pzLr3zPJpdt3TP7gOoVj9pPFhXIdo5DCQzGQKg50sMq1xrAGjnNysTfNZTEA4sv304mN0epSi9QoxpdFqJE/Iw7EtkvlijwTzl2WdYtzKCgAe7GaxSPUAMPmzAzj3ev4CSKNpNToxXKXwJTBCOqU7TnVdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782854351; c=relaxed/simple;
	bh=H+JRAQWXs/94xSEZh0K+H9V5JVgHehKWQEOw/zhU3EU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JWQuibAw/CU74CMQWloQsHBM8vBtwUE5/Xgv3fQibbex+usqJK/Uj+sSI7KhMfzMoe8yv+jGmR9WN1T9FUOMkoh8VI79g2qL8+nZr0t6yVmdHeYoOdBwZILPzoCa0+1DXgCkggkjxHA5W+jLcOL3w0MZHroK6xWbeVUchcrtbKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mX9eNib0; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mX9eNib0"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-474303f3c72so1573238f8f.0
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 14:19:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782854348; x=1783459148; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=eF4moDigoL3fYQ4QtZvHRZnEaluZ8GJB7QQkCHey+mI=;
        b=mX9eNib03RCXL/PAbK8k9E1oxrX+kfzbq4W2L+n37VhGVYR/e5A1T8T3bB0QUGE9+v
         v7TgDvdU9Kt9tOyzLwKpz6h20l/rbjqA5bZGrRuyfuQqudf8Smiq/NKJAy48IZn8b63S
         QUiIcwmVBiIUkYmSP/9bUgJm/OtttDvLLqyGGgVgHqDWhp64tyZdrJX44cXnU+XtNZzj
         jf1N1zTcp8Hxd6eGzcJ6Y1Tp5eoErysRQ25/V7nxqV8umUjXSvwRMV4ZFdEcG9ovBTWT
         RsNLxmc3rSNrsYiV1Ad0LxxV2ma7qfP9WFWUgd7+bOyfaj/fRL8B1dD+AOPFJx2aMEgZ
         jNxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854348; x=1783459148;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eF4moDigoL3fYQ4QtZvHRZnEaluZ8GJB7QQkCHey+mI=;
        b=aTj00UkuTlAk4hrLMCUB54896GVXn/LHz/Bxnv/f1C6RcN820/5Aqj78Oaj75bXNp5
         2E7HHVR3EWFi3m+D+59RGdn/Jx4RPPZ69QDjSQY62oWnBh0btOOoUgo+5MBQAcbhMTe4
         mdrJdwH/xdl41XcUDkfn4CRoSIsNv/jfRXhivldjOH9rp3DAEcgi/0tNl8MLTSj34g/5
         Oe7zAHLCfMRhkbezts0kRAlcsD5xR9l2f+WRm4ypgUq3wQ0g2MtD76a1Yrg6qrFqVenT
         vVbg/sW+ZcBCl4pnbBWnJ/K93zeqeayJBqGGzvccHpi8MAs5C22AnYsGJLYVRBZk/Rm8
         g9DQ==
X-Gm-Message-State: AOJu0YyJNnWPrlOtcQjpca07QeI+SThFvYkpAh6nNBr0nxEZEHl2nnRp
	rGbqtuZov4iYRc7/Nr/QH8xD1pqnfAWV9NnSeunOw/Uq2NDp9mQ36C6E
X-Gm-Gg: AfdE7cl5t93RdsQ8Eme1lYk80LDt7G6M88FG/qjI+chLX+jZTOmjePid6wMs32r0/dB
	clnYBNIN6DzCSoqahhwPu644kvzKN6OOXVG31a6hz8a9BcRv2qn7nHnHXVYXFKUmSeZupLcJ6qB
	COun/mW+cKDZxeSd7stfF4vZXRUhSUtWp096zPqRXwB6jOfOG97ZAF0jROvfZ5olNke/0DqlTJH
	9f0iUXSbWVQ6MgESnAK+3GdvbHFgIJPhvIR9UFEM/YWywtI7x9gS0PPqEYE4iku0H3gNnkRN2PC
	qCA48MLQstDcvdXPPu3rGiMuQYX66vRYwvl4ukdFbfONBrbeeYOOCKZk/SRqL8DAVGe4M6rwKPA
	EKAd5FYV5yyFC8cKWH+84lL2lRCRpBmaGDdf22Y8+u2XYlO94ZKlITCIVZ7ZBtDUHCjraNzmBSN
	6wfXiw6wDoBbh34i9h8uztWjAHdQ==
X-Received: by 2002:a5d:568b:0:b0:46f:7d90:8114 with SMTP id ffacd0b85a97d-47659c036cfmr2676339f8f.14.1782854347742;
        Tue, 30 Jun 2026 14:19:07 -0700 (PDT)
Received: from Dev-Null-MSI ([2a0d:3344:52ac:a808:98a4:4381:be45:536f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4756636cf65sm11693870f8f.21.2026.06.30.14.19.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:19:07 -0700 (PDT)
From: Yousef Alhouseen <alhouseenyousef@gmail.com>
To: Adam Radford <aradford@gmail.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yousef Alhouseen <alhouseenyousef@gmail.com>
Subject: [PATCH] scsi: 3w-9xxx: validate ioctl result buffer lengths
Date: Tue, 30 Jun 2026 23:19:00 +0200
Message-ID: <20260630211900.50548-1-alhouseenyousef@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Several management ioctls copy a fixed-size event, compatibility record,
or lock structure into the flexible data buffer without checking the
user-supplied buffer length. A short length allocates too little
coherent memory and lets the fixed-size copy write past the allocation.

Determine the minimum data length for each fixed-result command before
allocating the ioctl buffer and reject undersized requests.

Signed-off-by: Yousef Alhouseen <alhouseenyousef@gmail.com>
---
 drivers/scsi/3w-9xxx.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 9b93a2440af8..b8a0b8410a39 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -642,6 +642,7 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 	unsigned long *cpu_addr, data_buffer_length_adjusted = 0, flags = 0;
 	dma_addr_t dma_handle;
 	int request_id = 0;
+	size_t min_buffer_length = 0;
 	unsigned int sequence_id = 0;
 	unsigned char event_index, start_index;
 	TW_Ioctl_Driver_Command driver_command;
@@ -673,6 +674,26 @@ static long twa_chrdev_ioctl(struct file *file, unsigned int cmd, unsigned long
 		goto out2;
 	}
 
+	switch (cmd) {
+	case TW_IOCTL_GET_COMPATIBILITY_INFO:
+		min_buffer_length = sizeof(TW_Compatibility_Info);
+		break;
+	case TW_IOCTL_GET_LAST_EVENT:
+	case TW_IOCTL_GET_FIRST_EVENT:
+	case TW_IOCTL_GET_NEXT_EVENT:
+	case TW_IOCTL_GET_PREVIOUS_EVENT:
+		min_buffer_length = sizeof(TW_Event);
+		break;
+	case TW_IOCTL_GET_LOCK:
+		min_buffer_length = sizeof(TW_Lock);
+		break;
+	}
+
+	if (driver_command.buffer_length < min_buffer_length) {
+		retval = TW_IOCTL_ERROR_OS_EINVAL;
+		goto out2;
+	}
+
 	/* Hardware can only do multiple of 512 byte transfers */
 	data_buffer_length_adjusted = (driver_command.buffer_length + 511) & ~511;
 
@@ -2302,4 +2323,3 @@ static void __exit twa_exit(void)
 
 module_init(twa_init);
 module_exit(twa_exit);
-
-- 
2.55.0

