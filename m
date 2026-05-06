Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621022153D8
	for <linux-scsi@vger.kernel.org>; Wed,  6 May 2026 00:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778028596; cv=none; b=pniUR1fUUO/K9qaIPTeoVqIC2t+4J6ns3VFHMEQzmu4EBn18vTaykMbpRAs7An5rXESaoOqGyRImckhByMzhFyyT3659t/mExiWc3obSpr0xEOML+tvRw+hf953PkYdWMVj5saRhzarxxf1UNBZJn3/HL7GJKC54qemyh2Wkz/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778028596; c=relaxed/simple;
	bh=Gpf4+9j34oWL5b+b4x1Cubu9uotpYGvejQwqPSNXU0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IH8ekYGg39Jti31xuHn/WMhsI22y4aN6T8rQlftn3LoP9b6vLOey9VV75WFNiKmseN3PAqlT0+LwTRD4pxfSz5JBvHLAQJPChSy54xLWz75WW5fb99jiZVff2DkNH4eaKSF7X88t97fWTmDBhp1+Kcf5/KeUy3B3Dfk3ptoEreA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qns8Ux4Q; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qns8Ux4Q"
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5a62f43b76aso5383271e87.3
        for <linux-scsi@vger.kernel.org>; Tue, 05 May 2026 17:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778028593; x=1778633393; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P6UNs94UMqznxX8WUEPi0/pShC6Mhozsqf9EWZvlU28=;
        b=qns8Ux4Q5XlmnvXGvcJLQyxk0+dWY/e/PwZ+VVVmY81/DqO6D4mVkXIBr5omVL3+uM
         AnHFKUajoDyKAwKzbjWzem50cDZUrkMQYEoDX5IexVPyF1YWjjARrQRLAiWjiAT7Gl7l
         pjuy9xfdbdDFWfYz9hGGEexqURnCpwIa2rw1bICZrFpycwUOx5KYLURyzSibXtPUbUHq
         Tqhw1QmMX0p+3JaaNDWqOeLJTG3KyuxKLR/6Kq9R1QVyf5cEmnjkf5sFmVigAbRUwCYQ
         LyBiX+fS/yIqzWbtx5oIWdh/4MjBUp5dPsWR6hKXnsTAYRUYOP7yx7ZVuqxhPWVc/4Yk
         3Xag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778028593; x=1778633393;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P6UNs94UMqznxX8WUEPi0/pShC6Mhozsqf9EWZvlU28=;
        b=lc2n/z8wHwT23H3BwxkdN/j11HaKoUtnAhEiT5x26U4vYPKomwjA/ADzBBs0YXN6PP
         /DtD4S+lt6nAU6Kvg5pCR8qki/x1/q+IfUjUIFokn+VItlSrBZkFJqZphmOkiktJWGYt
         HDs5UVH1KmnkQ7w+3Qn4pV1izgNxcFzyNZQg5iqp+1dC+9NrTiHBGucNO8VaoK8WBxia
         CYaPGss8cCxEsuNFSqeUXSxAF2X2laE3be/KYXBkAhTaKNGvlQBW/4x6J5J0CCE1ODjm
         SBG3UbQhAxQwB9x0636C5iaBsai7D4XiY63FvHiwfWgnyZbG4Ja92wvE3yz2323bqQ9V
         oVIg==
X-Gm-Message-State: AOJu0Yz9EBtiOqPXRgy1HjippMCQTjYj/R5C0h4hmJsbMZZLZKfIy/an
	AnaFf2kFMa6SI8vkvamoyFY/Mn90zOvPHqquuMClacwYuw2FAxNTQBs6SsQAj9+S
X-Gm-Gg: AeBDies7QSHqPutiJS3ml/MQBp4AcSafgl+F+bltw7c0qqL4ke+Znvns9s/l7BBo2Ez
	1yYsryz4dHtImRtv/JkQtPUYjNs1a01pOh2qlnneqz/hKFrPFUlHUviCMpvveLCNcmapjvM00vd
	EqraBmwRvFR6WHsmiOVBWWfKFxMPS0YHZFNvb2zLCqQJU8l5m+uSjURN5z49tLNhQ8cZXnk1zJV
	kRQsUAt3p8tlEOChK5HT6nuTMF3FyRkKhPkVMn5qeKpR4RWtsydhEkgWI+Xqe2C04dZKP89Sf/Z
	8pRfVOot6o+JSVdbKblYDKzD2ofHzcNBF6vAiINu+T9C2hIqlm0rap9THZDcoaTFQ7me+pZjqXc
	h9xtQHE3J/xJVIqS9RMqDPkGkNRXRxJ26BAsjCwLJMicbLeFxzHlcIAUFRosZ15n2PrsuIlNGGr
	Oef8TEnRcQ8j4ypLZs9SE6IXxmyDkeYlHO3PbTY1JUp4T5R52qMQufzt05RHWrJKu/+Qe7qeiiK
	Ks=
X-Received: by 2002:a05:6512:1293:b0:5a8:82f5:8d1e with SMTP id 2adb3069b0e04-5a887ae6596mr317478e87.17.1778028593080;
        Tue, 05 May 2026 17:49:53 -0700 (PDT)
Received: from Shofiq (87-92-218-151.rev.dnainternet.fi. [87.92.218.151])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a85c230e5asm4379424e87.33.2026.05.05.17.49.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 17:49:51 -0700 (PDT)
From: Md Shofiqul Islam <shofiqtest@gmail.com>
To: linux-scsi@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Md Shofiqul Islam <shofiqtest@gmail.com>,
	longli@microsoft.com,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	mhklinux@outlook.com
Subject: [PATCH v2] scsi: storvsc: Replace symbolic permissions with octal
Date: Wed,  6 May 2026 03:49:48 +0300
Message-ID: <20260506004948.2172-1-shofiqtest@gmail.com>
X-Mailer: git-send-email 2.54.0.windows.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Symbolic permissions like S_IRUGO and S_IWUSR are not preferred by
checkpatch. Replace with their octal equivalents:

  - S_IRUGO|S_IWUSR -> 0644
  - S_IRUGO         -> 0444

Signed-off-by: Md Shofiqul Islam <shofiqtest@gmail.com>
---
 drivers/scsi/storvsc_drv.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 6977ca8a0..571ea5491 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -156,7 +156,7 @@ static bool hv_dev_is_fc(struct hv_device *hv_dev);
 #define STORVSC_LOGGING_WARN	2
 
 static int logging_level = STORVSC_LOGGING_ERROR;
-module_param(logging_level, int, S_IRUGO|S_IWUSR);
+module_param(logging_level, int, 0644);
 MODULE_PARM_DESC(logging_level,
 	"Logging level, 0 - None, 1 - Error (default), 2 - Warning.");
 
@@ -345,17 +345,17 @@ static int storvsc_change_queue_depth(struct scsi_device *sdev, int queue_depth)
 static int storvsc_vcpus_per_sub_channel = 4;
 static unsigned int storvsc_max_hw_queues;
 
-module_param(storvsc_ringbuffer_size, int, S_IRUGO);
+module_param(storvsc_ringbuffer_size, int, 0444);
 MODULE_PARM_DESC(storvsc_ringbuffer_size, "Ring buffer size (bytes)");
 
 module_param(storvsc_max_hw_queues, uint, 0644);
 MODULE_PARM_DESC(storvsc_max_hw_queues, "Maximum number of hardware queues");
 
-module_param(storvsc_vcpus_per_sub_channel, int, S_IRUGO);
+module_param(storvsc_vcpus_per_sub_channel, int, 0444);
 MODULE_PARM_DESC(storvsc_vcpus_per_sub_channel, "Ratio of VCPUs to subchannels");
 
 static int ring_avail_percent_lowater = 10;
-module_param(ring_avail_percent_lowater, int, S_IRUGO);
+module_param(ring_avail_percent_lowater, int, 0444);
 MODULE_PARM_DESC(ring_avail_percent_lowater,
 		"Select a channel if available ring size > this in percent");
 
-- 
2.54.0.windows.1

