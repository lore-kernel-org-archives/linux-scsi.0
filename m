Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0205678F5D
	for <linux-scsi@vger.kernel.org>; Sun, 28 Sep 2025 17:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759080759; cv=none; b=u3befBbH5aS8ZRUC5SFGASep7Ahmoze71A3G6EuK/anL+VqDOoATa1ljm/AyG38MUJMo5bEzkaKO9xAwgNtVOrpWyP6oOqidxm/tOxty7YWRG+CYrY6nDFPovEl5BXclsxQmNLmjFdCUlrrMZs3tLZgeY6qDaZ89XfwbWhzqkeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759080759; c=relaxed/simple;
	bh=+yhWQs77SCKwmDa0c1dap86XxWX8S8b1JmJcq2C296A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RALbClLZxYiBOoGsoQt5NXsjwWIEvj3u7fTB1aEtmiYQUhyMkEUXrk0fPQaOu9oo9G2tl3NYwOnl4xKQe1z1pPL9Tz6Irfa1WXUTkmG3zy58m1RDbIJ/3a8r6p4rwROr0k3RG6kKKEe6QlzzShwGSUXcQlnzqFThN3OeGyjHCYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Y7GkaqcK; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y7GkaqcK"
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-3e74c6de6f7so458881f8f.2
        for <linux-scsi@vger.kernel.org>; Sun, 28 Sep 2025 10:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759080756; x=1759685556; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gZpfDa1LyEfLRHt6pylVChVVp0uO3/fPa6/etQzY1rE=;
        b=Y7GkaqcKmF1RMVhPXYt6wXipYfyDc3RTFahdHaTdfG9SKeliZMAecbTpc/uQfB1BNQ
         C7WP+LBKu/GYqx2NCHdDJSX01/pq7FA70Sm9kPbTqlodJWkOQ4egTtg1S3q8SosiSrsh
         lF7WtWR4Ne9YIrsNt76Lds6J+S1ZBgAWMz3kb+FqPH+ubo8xdgI0Ie1FwW4krUJX9xvJ
         stpKJWjtN6avc8pYSOfomeG9jcWmZhyCXOZDVG/DlpB4AWRGCGVJUpcYU9h3j5qk+QzB
         +VOYqAiBPj8ehdeKaUfjbIpUuJAQOUM+QW/YUElpMibE/DVMHhM6lzbOqGALT4QYO2lV
         t0RA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759080756; x=1759685556;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gZpfDa1LyEfLRHt6pylVChVVp0uO3/fPa6/etQzY1rE=;
        b=Ca/pW3KRhTxZnJIL4CZ1gjhQOE6PWgY5Zldk89Zl3M7auXsGvPzTyziLEGQzTvqns+
         mvog2ALhyGK1zHbFEXsPHftNM0oXfguMLP/mwJZ2UAmdeyJw8WYJgDDNvkDSIbZbRyqU
         I9RNaNSUPs/DVxvETzTRJ+nPacuYkGscseydg8D6wNEwyFqgYnrFNIUo91JbLNfmyE7n
         +WTHfsLMGEHigD7vzdCCp1mpDd+k2hKd218D1d48JBqJh1D6dx8oXRJrl2OskCrs5mRX
         UYtWcAKRvZXar4J08EC+YJ08S2v9EX2FpMHOBONIPo8oB386IeugEWGv0ix+7Eo7n4LA
         i56Q==
X-Forwarded-Encrypted: i=1; AJvYcCW8OskILH3rNlHRS9in0YysSvA/iFTP3i2cmEXpXa2QiwfefdMuAVi+2BWSE25In4asCS8sotvNqIKl@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9mFlFyKv7ogKYbnhOKIlTc/FNtL/ASXXPF5Sfms2DpGCOEXvZ
	f/4Zr4bRsZ71WU5UO1VquHpqjWgK/asdAUqVJv+BARENVNLsL1lMqQQ=
X-Gm-Gg: ASbGncuvQ18qpKWlgXZvxJiCpc4HMW51x6E0tsVm/aITOrbhilloZH/G2WqCmSnQXnw
	zEpM5WUlAFEA3I2Kc0gSLn/LVLr2UQMzTKy3oUAEVWdjy/daD36tAfBrjj0+pP/tyRoJYr2S9aa
	8ORRkKYpdZc/gwJRYoAh8GevQab/4M9NvJLreGEtJgUOnpujQP4iO7HjvsEDNF9cDJ63qv7rE/+
	eFUe1N5rHdyoVgaxcDeV+ZwRmiUSIm3btOcNH8BuLsScuW5IEYgR/9QlPzQvQFIGDvB2sVg54YB
	ZlOWbZgxusBBhNGqssA76qeDe65m+LCXANRfQmpWYQyWGhjzJEp2hJdtv2QWPD9Li0jCsJ27s0Y
	0h99Hk7ZzMeIXzuRQwMhKbrW2Tw/4G2+pWMCGIEjoqiQAQ9jwk+Jl0NhosEO2MVFL7QzA6ww=
X-Google-Smtp-Source: AGHT+IF9ctIc1w7pYuurOOtSQnBLKY1kKaYNPxwyS5j92ZGHx79Esox1Ll1Fj6se/C5JsV2BZGeBow==
X-Received: by 2002:a05:600c:8711:b0:45c:b6d8:d82a with SMTP id 5b1f17b1804b1-46e32a16999mr66566055e9.6.1759080755805;
        Sun, 28 Sep 2025 10:32:35 -0700 (PDT)
Received: from localhost (20.red-80-39-32.staticip.rima-tde.net. [80.39.32.20])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2a996d7dsm205793335e9.4.2025.09.28.10.32.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Sep 2025 10:32:35 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	QLOGIC-ML <GR-QLogic-Storage-Upstream@marvell.com>,
	SCSI-ML <linux-scsi@vger.kernel.org>,
	FIRMWARE-ML <linux-firmware@kernel.org>
Subject: [PATCH] linux-firmware: WHENCE: identify Qlogic firmware
Date: Sun, 28 Sep 2025 19:32:33 +0200
Message-ID: <20250928173234.233947-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

Info from:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=1bfa11db712cbf4af1ae037cd25fd4f781f0c215

Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: QLOGIC-ML <GR-QLogic-Storage-Upstream@marvell.com>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Cc: FIRMWARE-ML <linux-firmware@kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
If anyone is interested in this, NetBSD has different/newer versions:
https://github.com/NetBSD/src/tree/trunk/sys/dev/microcode/isp
---
 WHENCE | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/WHENCE b/WHENCE
index bc807bd2..bf35f40e 100644
--- a/WHENCE
+++ b/WHENCE
@@ -70,8 +70,11 @@ Found in hex form in kernel source.
 Driver: qla1280 - Qlogic QLA 1240/1x80/1x160 SCSI support
 
 File: qlogic/1040.bin
+Version: 7.65.06 Initiator/Target (14:38 Jan 07, 2002)
 File: qlogic/1280.bin
+Version: 8.15.11 Initiator (10:20 Jan 02, 2002)
 File: qlogic/12160.bin
+Version: 10.04.42 Initiator (15:44 Apr 18, 2003)
 
 Licence: Redistributable. See LICENCE.qla1280 for details
 
@@ -1590,6 +1593,7 @@ Licence: Redistributable. See LICENSE.conexant for details.
 Driver: qlogicpti - PTI Qlogic, ISP Driver
 
 File: qlogic/isp1000.bin
+Version: 1.31.00 Initiator
 
 Licence: Unknown
 
-- 
2.51.0

