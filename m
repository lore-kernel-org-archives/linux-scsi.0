Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3319E175AA
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719396860; cv=none; b=duIYBuwpBWh1TdPZobuzEQGpU/lULUwvk8I3BxgQa9HIHUBkAKeccpdrMT6Q7P9Lv+hTbVEjFENPe8VWATRgU4Mw/NItY6qD4suvYTxV4ib9KZ0GftNq+Z38ojeS68BlcKOmV+kWcaoKnZBvN3n+8aRho/bD2So2NY6HDcy7mgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719396860; c=relaxed/simple;
	bh=HHlPsBgmG/3JNnDEmtvJ9qS8p6N0tq0Clfgx3PeOY8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FK9cNiqvwSnvp48/0JlbZANOojTxemPwikXh3fZ/ttOJwPko9kVQZIzFwxU/i6Ky/tI8PwsimwK5EV3zdoCJ9DJWyhXk1Y5uDf2vjkBZ1DwYpWuu2YNy4YDAQs7xNmin1gXq9MFYWblFlyuNJg8T89TAryIvuTCsJ+k/6gvwyC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kNgoi4zg; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kNgoi4zg"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7066c9741fbso3967300b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719396858; x=1720001658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8MWsFpjOYog8+YRpu59CEo/oYBsp4nBg39WtFxWtJUk=;
        b=kNgoi4zg1udVD+MOrE+j6RGHDymB02Ardn0TyMIEKRlWZd8xee1dAUr97GfyUopDUS
         LlmnBAxL8OkSjaYOfPgnhkd6OPWvym62nZX4sXJnsBj751V3FUz3j4nWNFF5o7rJh+Hi
         q4ZnEaQbgt3FvxJL2dlqNbLZDmAy6cJLr4Av3kinbj6R9Oq9DYbHbeOmNYvq7aQLDlhB
         47K7Kz5pdjYZrWH6GylJz3AVWss20ZSJfVkYWCAoqUCm/ozl1loSJmBHbqlD1CGhHQYB
         nbeoWD+VxxNzNEN1OCODpP1nb8KaYB9BTrEuvkcC4NbZQk64ZByDIBvcfmuKsyc11W7V
         OqdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719396858; x=1720001658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8MWsFpjOYog8+YRpu59CEo/oYBsp4nBg39WtFxWtJUk=;
        b=MbnGmS08VeuHVnrMlgTML1V6dOZM6WMNq+05FV8QTGtzeWGvTdsFpv9uf5T/SrqVYz
         lyO8h6eoZ3rvWkp0+cYAZ4RQxsNMknIV/fpJOPhSqvnlIvtOP9lXH+fA9lTP/JBZ4ADj
         qtAiQAN0f/w38QYSGoszjLunc19RKqdAzmpkmorswkJ9G30mylwjoUSXdZ1GrFNxUAC4
         n1r2K9jGQzL7pgRvZClHuSbp55LT247wUSJHhvSWDm8nHqyHOKchcA20u+Fva74Kg+ZH
         I2FU4/YOg4kS1daqCQJb3FcvTHDlxGIZ/p3nZRpnfzT4Axe03Rcc25Y5LoQV0fBwWEKC
         D0wQ==
X-Gm-Message-State: AOJu0YzEQ1a9CC7a/rFls81WkOEhiWKICHENEd6LlHmPUyWPe1LmkzgI
	pcbQQ+qB9B8jHs7e85SultaeA+iwSKIGl4PD2VQsetyS0RXXQ/K7oICnww==
X-Google-Smtp-Source: AGHT+IG068/4u2edxb4+Srbsy+qTBiWrcBaYONGHdF3RAGZ/ooSN7nm1GmXlaI4DH2U4RY3IKW49tQ==
X-Received: by 2002:a05:6a20:b913:b0:1be:c267:bb41 with SMTP id adf61e73a8af0-1bec267bc15mr736549637.0.1719396858091;
        Wed, 26 Jun 2024 03:14:18 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa360317ccsm57063865ad.279.2024.06.26.03.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:14:17 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: [PATCH 05/14] scsi: hpsa: Used min() for sense data size and buffer size in complete_scsi_command and hpsa_vpd_page_supported
Date: Wed, 26 Jun 2024 06:13:33 -0400
Message-ID: <20240626101342.1440049-6-prabhakar.pujeri@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
References: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
---
 drivers/scsi/hpsa.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e044ed09d7e0..05fba23d94e5 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -2668,10 +2668,8 @@ static void complete_scsi_command(struct CommandList *cp)
 	case CMD_TARGET_STATUS:
 		cmd->result |= ei->ScsiStatus;
 		/* copy the sense data */
-		if (SCSI_SENSE_BUFFERSIZE < sizeof(ei->SenseInfo))
-			sense_data_size = SCSI_SENSE_BUFFERSIZE;
-		else
-			sense_data_size = sizeof(ei->SenseInfo);
+		sense_data_size = min(SCSI_SENSE_BUFFERSIZE,
+				      sizeof(ei->SenseInfo));
 		if (ei->SenseLen < sense_data_size)
 			sense_data_size = ei->SenseLen;
 		memcpy(cmd->sense_buffer, ei->SenseInfo, sense_data_size);
@@ -3634,10 +3632,7 @@ static bool hpsa_vpd_page_supported(struct ctlr_info *h,
 	if (rc != 0)
 		goto exit_unsupported;
 	pages = buf[3];
-	if ((pages + HPSA_VPD_HEADER_SZ) <= 255)
-		bufsize = pages + HPSA_VPD_HEADER_SZ;
-	else
-		bufsize = 255;
+	bufsize = min(pages + HPSA_VPD_HEADER_SZ, 255);
 
 	/* Get the whole VPD page list */
 	rc = hpsa_scsi_do_inquiry(h, scsi3addr,
-- 
2.45.1

