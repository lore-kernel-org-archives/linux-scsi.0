Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 054C8389104
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 11:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779536439; cv=none; b=jm+cc9edZaAgVeOqXhJTCO3vvKUdpZgo0y5/p1SE5KfsqP/JJ0XnaUmXnyFsxGGxh5BqokskT0myAOpLPm8lzUZxT7CHSGPRo1e0I4/HEHdi7p1o31QXuYwlhN8AMsfMmv46UcYRSdV9pTy6/5V2XsryHtw2a2aHJyKPkYy9yUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779536439; c=relaxed/simple;
	bh=r8r/IanjMILQbugx4UDw/d1DZEMnLutNhqbCWKEEDVk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=fl+uxiuV/KadCJ/cPTwYQEiiMSWbBk02kiEDMOhPYA+R8u9wVxWchR8Jp5azVFTZFjpE8/YGqMjong9IwFzCJedHQn8QMzAoqag1DpcsltIkRmCduGnCkKheG6JsakPTb/WGHRxqBNv84/dPFoeTWDHJhbC/n+YKlw3kBS/VwVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M8ZsKuzS; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M8ZsKuzS"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43d7828221bso723260f8f.3
        for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 04:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779536436; x=1780141236; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Cc/MGNB3qZiQpPMFVfxkd9Mzgjv6WKzmu8ixBibZi/4=;
        b=M8ZsKuzSq+XonMIwR2IQU0LNNExBiTeyRtVQGZx/3PqeNRkZGX5r/pHQ1xQ0juAxcm
         /hwbsGXL3vsKrj7mmmE3xdrFbsj42AGCsigshIY2xJZFrTvkQzE1x8Dye3Fa7HeAZeLW
         gCETiUGaPsQ889hOIY5Lv8zFMd+mITtI6qH9zhrGY3jiy91qcqfo5F4Gpnj6wlX9PMRW
         Ql/cyhs3zBCeARvCRR57tbklOzzxW6NriLOb6coV7Frn/pUpzGap5/snEdPLhwfwmBdz
         iB5HrYYwWfMmEMz0NEsNvrXZHcrQkiiiU4BL2jJKD/Hjd0kccg2VIi2lhS/ZvG4/140Y
         vIzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779536436; x=1780141236;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cc/MGNB3qZiQpPMFVfxkd9Mzgjv6WKzmu8ixBibZi/4=;
        b=ZYxWPIHitRcbPpBUh8mdPq85KeyzRmlWngjXlpldVhve72Hzy/hPfb1DxRJ2S3s9Wn
         rGsEBRETKFBlpDhXp1Y2v3KofT9NKochehismntTRpkqkyYrJLAjbdIZU3AuP/tzZvUY
         ThATivumVfas81cjI2tICAY1fhVFXGSqVnooCH72tAedfEFSW2YQCg9KI6DW8nqEI0qH
         KrTQKinuOw5P9VMmHvgUMlL8c9+ugsF92hvZl5PS09aaIxQu+XDwxgsRbQCHMppq3ehM
         /ZdOeSSZrCD6tTccxvq2MO/0LrGOssotrRRx6ll84pn1TYPcj9z3JT8g0QCSCClXRjXk
         yVqQ==
X-Forwarded-Encrypted: i=1; AFNElJ8+Dl+sSSPSxqP0hz/nTS58JQdlpGjr6zIHUbP7qK0tCGkZXcYt+N6ASyRaqxK0Me2xmnNzkcJX/zTN@vger.kernel.org
X-Gm-Message-State: AOJu0YyU8SXlJ/Ys2P1Cs3FnjMg1kbLAeeIq3BoAlD1Bgf1a2ZsCm9l7
	HY7XLDygf5MTbpI0Ekz5W9UVXTYCJV+ucj63AFEeAJUUonbRxTtHcWk=
X-Gm-Gg: Acq92OHa4CjtAtuU8iPIMxhn/kdiqncFnlYAR61/N2fUpi61qtacpMWYKGuHwNG6m/q
	lMe9J+CnLflDr79KQcxxRxXWEWHCZhQ3ApW49398vFZIjd7u9CKyb+LwFEjEKt9Z4efk5r0fgf0
	BER91Tue3yNra6JnFqMT36xr1xIJBd5cUjScURUd+FBPOXYEfLmM/jAOPtY9GUf/+lXN+8nZqWK
	EfipxOS9mdzK0R0vmVxl1a46CRz9NGcChsEpXdbuuemc9EpCcDy3s4zAL70+RVW2HnHFttxcPen
	pdK7RVRcpFVXCKi2nkIIcNH5BjNHoFWy+T1YT62Ox2Hd9jW+m5UzvIBgCsbYmIaAkAdv+ZeY9i2
	Hvm7A9Xc2Un5Y7/ufVqLueLdmNOZ97Q7CHzk/PO9o3J3LtBG3VYp8rDm868baxQ1GB8aEacY/XR
	vYJgqXBPAX1AR0v3wmZYztmHhggkXkYZwNWRPapToCc9KAvaiDlG0O3dYgc3TzoY5V527vu2s=
X-Received: by 2002:a05:600c:8484:b0:48d:1021:e5d1 with SMTP id 5b1f17b1804b1-490428cde40mr52830195e9.3.1779536435992;
        Sat, 23 May 2026 04:40:35 -0700 (PDT)
Received: from localhost (32.red-80-39-29.staticip.rima-tde.net. [80.39.29.32])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4904527f7f7sm168729025e9.7.2026.05.23.04.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 04:40:35 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	Christoph Hellwig <hch@lst.de>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	SCSI-ML <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi: devinfo: drop redundant entries from scsi_static_device_list
Date: Sat, 23 May 2026 13:40:32 +0200
Message-ID: <20260523114034.326963-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

These entries are redundant because they are already covered by existing
prefix matches in the list and same flags:

{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},

{"DELL", "PV660F", NULL, BLIST_SPARSELUN},
{"DELL", "PV660F   PSEUDO", NULL, BLIST_SPARSELUN},

{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},


Cc: Christoph Hellwig <hch@lst.de>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 68a992494b12..3a9b691d7e72 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -148,12 +148,10 @@ static struct {
 	{"COMPAQ", "LOGICAL VOLUME", NULL, BLIST_FORCELUN | BLIST_MAX_512}, /* Compaq RA4x00 */
 	{"COMPAQ", "CR3500", NULL, BLIST_FORCELUN},
 	{"COMPAQ", "MSA1000", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
-	{"COMPAQ", "MSA1000 VOLUME", NULL, BLIST_SPARSELUN | BLIST_NOSTARTONADD},
 	{"COMPAQ", "HSV110", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 	{"DDN", "SAN DataDirector", "*", BLIST_SPARSELUN},
 	{"DEC", "HSG80", NULL, BLIST_REPORTLUN2 | BLIST_NOSTARTONADD},
 	{"DELL", "PV660F", NULL, BLIST_SPARSELUN},
-	{"DELL", "PV660F   PSEUDO", NULL, BLIST_SPARSELUN},
 	{"DELL", "PSEUDO DEVICE .", NULL, BLIST_SPARSELUN},	/* Dell PV 530F */
 	{"DELL", "PV530F", NULL, BLIST_SPARSELUN},
 	{"DELL", "PERCRAID", NULL, BLIST_FORCELUN},
@@ -213,7 +211,6 @@ static struct {
 	{"NEC", "PD-1 ODX654P", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"NEC", "iStorage", NULL, BLIST_REPORTLUN2},
 	{"NRC", "MBR-7", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-	{"NRC", "MBR-7.4", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-600", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-602X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-- 
2.54.0

