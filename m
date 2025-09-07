Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA7926AC3
	for <linux-scsi@vger.kernel.org>; Sun,  7 Sep 2025 18:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757269077; cv=none; b=BrJ7fIXbimzPKYuDvJbAYcL0Z42d8Wy9XGHZzkYTBS1/1L74gJloAgB9BaClGL83Bw1EtmgfG/y6hLXXaazAJuECn2QtUfu+TQsy4+hCavxYAnLZJkgcjHnorMfPqF0XEC91FyfsTAMytvYjuXVrsyT/ZHafo99hFXVhKLfPqFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757269077; c=relaxed/simple;
	bh=XPgaWkah8Y2mK3Eo2ru8JyaZylT88+cyR11FCRO4djQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Y40AhDN311Wpe8YJhtmtCBfkQwwcgfDkppPLgcc7eCdxGRKTxR88xsMbnhodOBvjVsJiQUUTbIdGbTFLhcJxhg8wBu6+lKgHo71F7w4VdsDdavITqYwE1Sz0ISuCbw+juu8hsJY+9eXu7watFNg4RpR0fJaIboDrbLi13D9gTq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gz7lXzpE; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gz7lXzpE"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-80a6937c8c6so473870385a.2
        for <linux-scsi@vger.kernel.org>; Sun, 07 Sep 2025 11:17:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757269075; x=1757873875; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W8qx9AhhhjD0idoW7JOHfxPMgeRydqvjqRxl5OChfs8=;
        b=gz7lXzpEbFlnxuiOaq6/VjgRNUx+cg0S4KEMu57/3mwkKLzNAP/8onrKsxGshgGBe6
         6kXr3llcAwGfs2MlXlzgaaATem3nGFx3wG2Zp/c72vwwKEWtnWn9glSZzNigUNftVPVG
         ZUUvLxOmFFPMhB4a7rTTQGq/ilk+qtXLiyc48Kw+AEnKxch7ciNQ78Ycr9CFyVRgMMHR
         ldv9AcAstv96i3y7YAT++CfGj+pWfTlDlcPhY3z0w1qvqI5Dn23wpxxpepMgMU6QdjoA
         YtGEg1Ss3OpbJtobTcHI13m3vghfzJqe5wLBUKsT00qOQ/wvW94lICcmUK0TgbxpeOUx
         CNFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757269075; x=1757873875;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W8qx9AhhhjD0idoW7JOHfxPMgeRydqvjqRxl5OChfs8=;
        b=ZhGjfRrhAAygkxFwr2d9zFRyb6+mNV48GuXCBlBamaeOOeYCPQM2HvSoaDY2wLtQ61
         oHpZpBDRZJvS1ig7pIeOtNm6LrFTyKq57CsVns2zVj7Q/Rk3+C596OmiPKO798KxRBjV
         ACZcDFp4nsovO/z5KYXk5YKrFAyzjrH24xDJE81as5phFbaQjDzaPWZEvV+CPBfMV05i
         hdxgq0CAve+meAp2a8i4I0beSNjfwRLA8f1TOdsT+VI6LVQk2VvZjRwTzK1Fibtbtlw+
         VRNv2stMjeYhMw7tfK1Ekt3otWlH3JPehugUdfpKicqON5ADTx9FVfdm6ktBlckN8Tu3
         cDSQ==
X-Gm-Message-State: AOJu0YygxPzzgk6eSQJoBZkKvdtg/WJKTj5VL7UKctBvtDlpAOizoOPH
	e5TkmOX8iNXNbmTQhIiVfyIheSQKIEDxdhRhgLRgH++u04Y7yJS8e5lBJGxklFnLl7E=
X-Gm-Gg: ASbGncsxzzq6y7kTT5nXYVcEyzcHy9or/MwT7y69fx9B26D4ez2d14j0quCjNc5rTYd
	te5a+M//2XVUf/h0/MwwGkHCKURz6MBKOLNBJG96k/3w3LVEt6mrBz/ktm2Lo/YX/GbCR9IjyfA
	pLCkoxOi55VHomr6HmQj9IsxsmCq6uDqovVKvHCUdCMoAImwBcqIPJ8Z4Zp33/TwDD2vHG7z8QJ
	W8Pofu7vgZImLcPMjcFeVFibsn6raVs+kHSx3WbXYT2L4IIe2mxRtPKw/mBiqSdU7hEjgDLV87z
	WeCsSReTflGyBO31X1Qz1QnoT30uYDS0WM6U53BTbbObhsTCYTKttRU6AG8pJ0VLzU8V0bEf7R4
	XY8AX99C/KJMKuYKbsdBpnU0SjWDMJI8qNxXVCxCMUEBP1qzgwuA9haqZ6gyrvp2ZoOhOaB7yKc
	1ONdSNXyE=
X-Google-Smtp-Source: AGHT+IGVscvCDVasNcW6t1N4ZNKcod+KH3jvWejgvxk9OEyKsl7YAmL4b8+RgZg03jQlPKVINV8g/A==
X-Received: by 2002:a05:620a:190f:b0:80a:fc34:563c with SMTP id af79cd13be357-813c34d5f5bmr496356585a.69.1757269074642;
        Sun, 07 Sep 2025 11:17:54 -0700 (PDT)
Received: from cr-x-redhat96-client-2.fyre.ibm.com ([129.41.87.1])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-80aab87f336sm856796185a.53.2025.09.07.11.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Sep 2025 11:17:54 -0700 (PDT)
From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
To: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Subject: [PATCH] scsi: megaraid: Fix potential divide-by-zero errors
Date: Sun,  7 Sep 2025 11:17:39 -0700
Message-ID: <20250907181739.97897-1-chelsyratnawat2001@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Both mega_mod64() and mega_div64_32() perform division using a 32-bit
divisor. Previously, these functions only logged an error when the
divisor was zero, but did not prevent the division from occurring,
which could result in undefined behavior or kernel crashes.

Add a proper check to return 0 early if the divisor is zero.

Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index b8b388a4e28f..1d591beecfef 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -72,8 +72,10 @@ u32 mega_mod64(u64 dividend, u32 divisor)
 	u64 d;
 	u32 remainder;
 
-	if (!divisor)
+	if (!divisor) {
 		printk(KERN_ERR "megasas : DIVISOR is zero, in div fn\n");
+		return 0;
+	}
 	d = dividend;
 	remainder = do_div(d, divisor);
 	return remainder;
@@ -90,8 +92,10 @@ static u64 mega_div64_32(uint64_t dividend, uint32_t divisor)
 {
 	u64 d = dividend;
 
-	if (!divisor)
+	if (!divisor) {
 		printk(KERN_ERR "megasas : DIVISOR is zero in mod fn\n");
+		return 0;
+	}
 
 	do_div(d, divisor);
 
-- 
2.47.3

