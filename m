Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74341817
	for <linux-scsi@vger.kernel.org>; Tue,  3 Sep 2024 13:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725371950; cv=none; b=NqI0oFKeN1cr+2K2k53piRFSQvAJRh6cV9dCAVDBHtOdZhWFQEf8Bsa2p0BuTSQbx09/I3VqSMsG1DghAQXEnVaRmO0f8f0IvSkZBwj/vnVm3qzZI16X92f8CmeJ7g5dS2PkY6vntco3zpirO0qOGelPPtvEcV3ZXrJnFrPNt3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725371950; c=relaxed/simple;
	bh=A3qTCpkD1tY/o7kPq9Ivj2Iymq37hYiFD3zZCTon5mw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nNV+Cbcplw9Z6Rbc8hrXI5KCSSWESNnFQs7g9F8A3r0RmoU11RoCpIol+rWgQvqnmmEIGm6V2sxFtsk9AM+L8xFWKticdE2slO0ntbAoYSScna7hNTftO7+BhTf9DZ9CntO+o+OenPHHgasOjEgBHmEZArbHCwf8rSyB8e0hOro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x0f.com; spf=pass smtp.mailfrom=0x0f.com; dkim=pass (1024-bit key) header.d=0x0f.com header.i=@0x0f.com header.b=N5KGZ5jt; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=0x0f.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=0x0f.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=0x0f.com header.i=@0x0f.com header.b="N5KGZ5jt"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2054feabfc3so23149965ad.1
        for <linux-scsi@vger.kernel.org>; Tue, 03 Sep 2024 06:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=0x0f.com; s=google; t=1725371947; x=1725976747; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=W9MboPUXsg/Px+LwZ6+8JIU+4J0WsFaBGBEODEMGVas=;
        b=N5KGZ5jtpkCEhMg2vAWmDTdAwL+H0glOIwtlmoG4ycRkf/b4oQIRj7M5isVgiLeJx9
         zlEoOjtWP6/nLKbxTINWE06T+KOHYw3xGLIztZBPCM0Il0yqoMFaBuJfe/K7bJtpHwOk
         Wb8AFFKu/ZD/AyJNf0qnhbFDQ/ppWjzqv8V7I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725371947; x=1725976747;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W9MboPUXsg/Px+LwZ6+8JIU+4J0WsFaBGBEODEMGVas=;
        b=DsesnJw4pl3AHMSkkrPRxCAV/2+Bw6ULyoKid60RK2QQPMcV1NHfcdP7rjIG8yDTHI
         7oFM0phGmYWcW4n/Lpjmb+AFquiH8O6UeH1sRvvL/vJUqP+lclUkC6j0U/ZcTz/Uu0S2
         CH6MnQsrGujimRwmJ9TdTnwSOqYv9YneBGGB0LEL7Sn8HV6J1g4/vNIEso8+j4wQX1g4
         ySuwmgrGxDhh5pQyEVJwZVTLS6nzrE6EYJi4J3My3sVvMvSXj9fumfr8YNw+u/S6iR3f
         rfkURV+LJetAkcdtKGJwKh8b6+NTPC0Bg13tN4M9q0yw5088BxhlrjGE/UiV9XhsbjR6
         6qiQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwMNcO29qaUvzQiBHisc6rIt87Z4P1vbNPUD8vAMccLjBw8Trxa99ESpvYoLFTOagoXTyiitSW7srq@vger.kernel.org
X-Gm-Message-State: AOJu0Yxnm/kWEmrbU2HqXiU8kGj8mmehxr33CZwrFlLUp2kWRJpoEb8+
	BVGzsu+GSvhPsEfjPmjb7xYfTfJye+5UlQSoRx/Y3dIeJPY8rwmMiXY2QFG1s6A=
X-Google-Smtp-Source: AGHT+IGbCBnBMPU2eZxrUfWrnlWj/Kh07Gptupnf3wm+gluWsdFBgP4m5pVsoREBAqxXGnFp06T0OQ==
X-Received: by 2002:a17:902:ccce:b0:205:56e8:4a4b with SMTP id d9443c01a7336-20556e84f14mr101632425ad.2.1725371946592;
        Tue, 03 Sep 2024 06:59:06 -0700 (PDT)
Received: from shiro.work.home.arpa (p1980092-ipxg00g01sizuokaden.shizuoka.ocn.ne.jp. [153.201.32.92])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-20535e8aa0fsm62688305ad.286.2024.09.03.06.59.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 06:59:06 -0700 (PDT)
From: Daniel Palmer <daniel@0x0f.com>
To: linux-m68k@lists.linux-m68k.org,
	linux-scsi@vger.kernel.org,
	geert@linux-m68k.org,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-kernel@vger.kernel.org,
	Daniel Palmer <daniel@0x0f.com>
Subject: [PATCH 1/2] m68k/mvme147: Fix SCSI IRQ numbers
Date: Tue,  3 Sep 2024 22:58:56 +0900
Message-ID: <20240903135857.455818-1-daniel@0x0f.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Sometime in the long long ago the m68k IRQ code was refactored
and the interrupt numbers for SCSI on this board ended up being
wrong and SCSI hasn't worked for a few decades...

The PCC adds 0x40 to the vector for its interrupts so they
end up in the user interrupts naturally, the kernel number
should be the kernel offset for user interrupt numbers +
the PCC interrupt number. Basically they are 0x40 off right now.

Fixes: 200a3d352cd5 ("[PATCH] m68k: convert VME irq code")
Signed-off-by: Daniel Palmer <daniel@0x0f.com>
---
 arch/m68k/include/asm/mvme147hw.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/m68k/include/asm/mvme147hw.h b/arch/m68k/include/asm/mvme147hw.h
index e28eb1c0e0bf..aa9bb31d1c27 100644
--- a/arch/m68k/include/asm/mvme147hw.h
+++ b/arch/m68k/include/asm/mvme147hw.h
@@ -93,8 +93,8 @@ struct pcc_regs {
 #define M147_SCC_B_ADDR		0xfffe3000
 #define M147_SCC_PCLK		5000000
 
-#define MVME147_IRQ_SCSI_PORT	(IRQ_USER+0x45)
-#define MVME147_IRQ_SCSI_DMA	(IRQ_USER+0x46)
+#define MVME147_IRQ_SCSI_PORT	(IRQ_USER+0x5)
+#define MVME147_IRQ_SCSI_DMA	(IRQ_USER+0x6)
 
 /* SCC interrupts, for MVME147 */
 
-- 
2.43.0

