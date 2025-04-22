Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BB0929346C;
	Tue, 22 Apr 2025 17:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745341437; cv=none; b=mlE4s3knBjfkeslk8Vz2vjV3G3DUYJMNX778VNRD+2pfZU3uRoPvg95InavBWWHlE8HwMcaCvjZBcNH/tDL6FlMnHDcNrG46fR9bmCgi16pq/Xs7NvSiWZPcVgtNnDbVkGUhf+P/RqVFcqdyQSRScsGFkqRe1ELQpfozuuRPUPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745341437; c=relaxed/simple;
	bh=/cWbb44LmZj6vKDRFEfIdnQUqpx5PeImB9UvbJv7BnI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=snjtmKhQX/4RFN0hNUpi2fSMQN/5IvJfoJ9t4n2kDCnoKIrEhxwTPX9gkS9PDA0G89AilZ1VwCBeZVOC1CArfXJsdDWLu/ErETKi5YnhNn9eVh6StOYbFgxQ8XmFNyO/E8V5EeANxvT6q1HSSh5MQQWw0pRVNlkhQWcdRGIaNjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YKRGLQmk; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YKRGLQmk"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-43cf06eabdaso52381495e9.2;
        Tue, 22 Apr 2025 10:03:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745341434; x=1745946234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=cZVSBIrgZvA36Q38qRpFzJ7zXgCHXB2HlRVBCE3cLzA=;
        b=YKRGLQmkJ+rncbrC66EQzo50D+afal/ngG5h/XRZ1aXJKmOWpMQGv/7oOOVMtesrhs
         gqjgiysGvOhRADo26gi3v8/Rh/GOMWeHC/BjHYgXGzIWNr25O2wqPvUIG5YlbvTHZBfM
         Wv8Lo9h1Q0GET9L7pkdsz7K2LIMdFnNI0gZUyphbN+kTE1wvlWXBeFXiHDnOPqDKCfU8
         oeQobYNLQFqf6AkTwEZdqEkCGjemU60XoHBdJbTm+/B9hsNb8Qnvxpj/N3CeCPQhwPkP
         dGne8TwXbqw4MwrJMkKIVAJRanKH5hU9LdyT/qnd27o91fZc5ZSpjjsYQQIRot2Lu0eV
         Wf1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745341434; x=1745946234;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=cZVSBIrgZvA36Q38qRpFzJ7zXgCHXB2HlRVBCE3cLzA=;
        b=P8JGWq/bTYD2ggC/FWuU34/0A6vxU50MsJt5v8I3Y4CUq7hFxeShYs/gnypWrcJJgS
         4tk4dDYR7rkCkZNR1ExsjnTfo2Hy+jtWTh8DUQ3lmtLEzwufifqEleCX28HY4bdukmr6
         KeeT5iMxRiGiyauZqU6SnU2AXXMaOp5jYOLAdFd7u9t9O5N/mvEnoFS6J+E0XvR52/sk
         JHnUEOYdur3uOsOgyMSqUY0LjfL6YUkGVDH9XNkTh+DaKO8gSM/UCtyeXrAwi9MARiEK
         G//Qx0i+3U3tFESNugXRM/VwBlM3w7iknHW2jw6wdjwf+rPk/iwkUSsWF2cc9VFg8jOh
         OFbg==
X-Forwarded-Encrypted: i=1; AJvYcCUzrlZuVGDfRqD+1drU3zZD6KOaSFE/4N2tMBQOntKuiLot+kiulRWTfOkcmZb53hIw31Kb80PREh/K9A==@vger.kernel.org, AJvYcCVV4K2Y1ZpS4NKkGwf6YTtfppkyip5cSTzQBP5VPZZVGOMyXebVGSrZ58mj1vumrtHIS3r9NhH0+ki/Wb8=@vger.kernel.org
X-Gm-Message-State: AOJu0YzTioBUPqTsbqv3/eKJ82Bu2LRGQ0+NPcDDOk7c/M4jxEVGlhOR
	v8duIcnAEp73jVqje5ut2yFbQpVDLbQwV+Qa3P5x47qsoCaPkMdM
X-Gm-Gg: ASbGncv2g1Yeuqy01Eq7Ie3QKuiflgZGCppIlvWdMiIIynlCdNwqK1Vit/ZSgOjEpuT
	9LlCcit91ubG24ecw8zznA3HV3SVgv66tBiCPpEtbcunJNJ81Bq4rT1IzgTlzVWyr68fvgdEuty
	B3o1GBaguSwkOL0ZjRXoYYzEH8KBV98o0I6Rzg5cIcSp3x6C0wYOAO1MflFmILx0HLUjgAbwZzP
	8/kR+jSsg2q6x0wgB8xGv68hYEoXGLsOidD1nesi/uEQwUzXTzgEzqibgEEPY8iqR35VQ9wKPkd
	qm5gj0HWjldKEYhQcDpH/GJ8l/HuUEaVOYa15PBIJA==
X-Google-Smtp-Source: AGHT+IGfl/hJJtCwP0i+U9Hf4bfQYmZkyOOzN5BGw8vZxm6xSa2EHzJl6fLe7K5pbEDjNacaZAKkbw==
X-Received: by 2002:a05:600c:384b:b0:43d:b85:1831 with SMTP id 5b1f17b1804b1-4406aa872edmr163900275e9.0.1745341434008;
        Tue, 22 Apr 2025 10:03:54 -0700 (PDT)
Received: from localhost ([194.120.133.58])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-4406d6e034csm179447905e9.39.2025.04.22.10.03.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Apr 2025 10:03:53 -0700 (PDT)
From: Colin Ian King <colin.i.king@gmail.com>
To: Hannes Reinecke <hare@kernel.org>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH][next] scsi: myrb: Fix spelling mistake "statux" -> "status"
Date: Tue, 22 Apr 2025 18:03:47 +0100
Message-ID: <20250422170347.66792-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in a dev_err message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/scsi/myrb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/myrb.c b/drivers/scsi/myrb.c
index dc4bd422b601..486db5b2f05d 100644
--- a/drivers/scsi/myrb.c
+++ b/drivers/scsi/myrb.c
@@ -891,7 +891,7 @@ static bool myrb_enable_mmio(struct myrb_hba *cb, mbox_mmio_init_t mmio_init_fn)
 		status = mmio_init_fn(pdev, base, &mbox);
 		if (status != MYRB_STATUS_SUCCESS) {
 			dev_err(&pdev->dev,
-				"Failed to enable mailbox, statux %02X\n",
+				"Failed to enable mailbox, status %02X\n",
 				status);
 			return false;
 		}
-- 
2.49.0

