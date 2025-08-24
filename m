Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BD91BD9D0;
	Sun, 24 Aug 2025 18:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756058551; cv=none; b=WYHIE2YXQGjLGrJ8SjEcltE7orCWA1xcgogWafT22MvXsAFEuIpe1H7T5E+3vK9MkwsoZxe4Jo4xRBXnvg0yJC+dc2/vDpjKku+Ia8DPs9DnHUhfrdTDOSZmkrGu6Z7dxj9OHv6Z0zaCy5FFfPdd2HMTZO+LKjiC3zH8Qx7WLY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756058551; c=relaxed/simple;
	bh=F+36ngP1WIZMDEO9EQRqoCyc0LiKRmcA3DuOZTgNVoA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=G6Xlgs/Jgj578l7QJrnllhN10cWJrR4cZTvUvV9oNUUm7+pI9QW0lIe4pPYdJnHu9wPhQgjTVdkb/X2sbeDvPz8lWOJMOTHxQn9JDA6ZerfrXXon7fqOofD9NiE+fEOX8ntuR3Zq7XSrwS9+CzxTykM/B3PT3Sd7RX9r4zJIK3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U7yoPlrD; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U7yoPlrD"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2445805aa2eso31421445ad.1;
        Sun, 24 Aug 2025 11:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756058550; x=1756663350; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=68YuaVdTnkCdfg2HxpkiX/Px00x/Pau0goQ+Qn6rHJc=;
        b=U7yoPlrDn+J7ocyxR0UWUiXd1+x7yNOLJOkhHZyI/wuOA1kkHOhLEwbFp0ZVugrKK4
         Ps+31EGXjTqE2UAogqe2IMPVq18NbJYA65xmnD6Knn+azwxNNWLJphG+dXKWIzy49JrR
         Fx+v0DsaAJ9E2/+yTYv7Sjz8awjoKsHCM08EqmvKNldpg2LyBWihDuZbsXXTFnuUJptM
         I938lyuV+Jcu36ZMRXImnHFYdaNQ3hBihGcI08zUeiWUNSBLYKBmIsfw6gPWY/nm3oZm
         fwBkXlkSI1KoEkAForwEIethtegAn8E1PzvRv3n+kTz03ZQ3AgA+uVG/m4kIk3cN0W8u
         kWCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756058550; x=1756663350;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=68YuaVdTnkCdfg2HxpkiX/Px00x/Pau0goQ+Qn6rHJc=;
        b=EBbP7cTVGCGWpfpRJSP046vKMPVJGbLHLUFhvDRQHVv0d89cYjgm/Wq3vlT8zuyWOM
         UiTyF5UWiNQieNOREvzP7WuJ1FP1MFOrmk/onFZEiayzA+3qskrb+kn37hDRovXdQ+0t
         VboKOeJ6ohskCjuX/R+41ilBDos8QyYrP854hHgB9xr4lxpcVwcEJrwBsKshFxfQ5zSo
         w6Y1VNjGA0YLww0q2v2wrfi6CYijL/kwRFaMlGHelS+My2smSlbfRkXSOcKn5x/ZJWDT
         SOrTLYzp+C3e0g9tOPFxHSEiRctN95zuEwRfJCLs8t61Xh+OVQY110xPIIO2KYkA+rmP
         975A==
X-Forwarded-Encrypted: i=1; AJvYcCUR8Injo5iuyRZgcIlS2nM9H3pdf/A5DRgQ1Pgap8plaIPpMV6T9uQRAnTBFO7wxU6WwwhVO1lhMXNz/dU=@vger.kernel.org, AJvYcCUvcnBec3a1wsDnkn1nNLsfg5aCDcvJ6aoIc5tQ29pMHwwkcLy27tHB4WqhIJhoMl0mWEstsic+O5T/Kg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9RHL6yahNgK7wMK368ur8AJiCROCScKX59VN9fAa88We4/qFK
	yBSNj9l3uXN+hqg2V1su6wP7+RLs2XNfPcwWOjHpmhtOJoYDBebkWB0s
X-Gm-Gg: ASbGnctLG8r7HzMogR1NZXMCbfxN1K/W0lbN6P2fEYcPQkn+/Lb0m3fSuL0bJQKmvP8
	PhYZZaI5XFyMUgnPVtr23/kc1OK2VWV1aILbwBkYR8mCOEMM+t6mjqumo0i4/ch6u58VUvnisxk
	BszABkKC5T2z0ao/jNhLcm8bGdv7OGeB/QQ/BhZ5h9uMtkIjZ5rfEG3k3SY1T7EXvprhj+uRPDL
	++RpTnHiiKckf4y+gmO+o0DbGt8jBk+4t+S6z20h8aFwS3pnuwoTP/MPqtzxlQTR/v4JPgRCs/1
	mDslww7R6+r8mG2e7jaAe/61KidAwf6eJc0KStr4aXNi+K0IsoQTpGu0Ydr6lwN6+sNrsMzHGFi
	ViBe4OWKqekAlhF8TFcuqdo9oDifIUwI3rrehw0av0v3+tg==
X-Google-Smtp-Source: AGHT+IEWRHtqYE4rm4yiJUzSIIgXrYoIOJuPRPUwyvvWxrM0mrDUnDgM0ad7mLY4UtPVoNcFqYfqMQ==
X-Received: by 2002:a17:903:ac5:b0:246:9e32:e83a with SMTP id d9443c01a7336-2469e32f8a3mr47347285ad.47.1756058549549;
        Sun, 24 Aug 2025 11:02:29 -0700 (PDT)
Received: from localhost.localdomain ([202.83.40.77])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b49cbb7b6fbsm4743532a12.30.2025.08.24.11.02.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Aug 2025 11:02:29 -0700 (PDT)
From: Abinash Singh <abinashsinghlalotra@gmail.com>
To: bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com,
	abinashsinghlalotra@gmail.com,
	dlemoal@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Subject: [PATCH v9 0/3] scsi: sd: Cleanups and warning fixes in sd_revalidate_disk()
Date: Sun, 24 Aug 2025 23:32:15 +0530
Message-ID: <20250824180218.39498-1-abinashsinghlalotra@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi all,

Sorry for making mess in previous replies. My gmail app caused that.


This v9 series contains small cleanups and fixes in sd_revalidate_disk().

On Sat, Aug 23, 2025 at 1:17 AM Bart Van Assche wrote:
> From Documentation/process/coding-style.rst:
> These generic allocation functions all emit a stack dump on failure when
> used without __GFP_NOWARN so there is no use in emitting an additional
> failure message when NULL is returned.
>
> Has this example perhaps been followed? I think it is safe to remove
> this sd_printk() statement.

checkpatch.pl also emits the following warning for this code:
  WARNING: Possible unnecessary 'out of memory' message
  #52: FILE: drivers/scsi/sd.c:3716:
  + if (!lim) {
  +     sd_printk(KERN_WARNING, sdkp,

So I agree with Bart — this printk is redundant and should be removed.
In v9, I have split this into a separate patch for clarity.

Summary of changes in this series:
  Removed  the redundant 'out of memory' printk after kmalloc() failure in already existing code.
>     buffer = kmalloc(SD_BUF_SIZE, GFP_KERNEL);
>     if (!buffer) {
>              sd_printk(KERN_WARNING, sdkp, "sd_revalidate_disk: Memory "

  Added Bart Van Assche’s Reviewed-by tag in: [3/3] scsi: sd: make sd_revalidate_disk() return void

Changes since v8:
  - Split removal of the redundant printk into its own patch (1/3),
    instead of keeping it inside the warning fix.
  - Kept the build warning fix and return type change as separate patches.
  - Updated changelogs accordingly.

Thanks

Abinash

Abinash Singh (3):
  scsi: sd: Remove redundant printk after kmalloc failure
  scsi: sd: Fix build warning in sd_revalidate_disk()
  scsi: sd: make sd_revalidate_disk() return void

 drivers/scsi/sd.c | 58 ++++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 28 deletions(-)

-- 
2.43.0

