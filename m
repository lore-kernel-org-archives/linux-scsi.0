Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A9A21B0406;
	Fri, 21 Feb 2025 08:33:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740126811; cv=none; b=N14jgBew04GH5WYBhTHng+WjIq7/EVbgMiOJfA/3RjsrFaZKcaQZ2kgGfe773xKnljuPQJw3It99GB7ypbNkNR0uUsONMPgQzwRAWUpMTRZrh8kt2h0hmoJstdVBPkvI3ASiaTX+rU5j9DUj5YPm3g6P1Z6YRFSnsUiZl4RLB5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740126811; c=relaxed/simple;
	bh=XSZZr2Ffnd/BZXMp2OEMWpIwACKPudGFu23WQqCz5yw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=bN/O5052ByN2K1IR2oDyYv03pKN+cQgqYwfdddSRnYP1HKq9zIwK1ElR/xKmx0+qwAho5XnghMOmdYHbH1FUI+k+3cfaK+d0X//Ep1Up5PLcyaLD54slF0e7PqorZKzo5bST1E95kYQCTDUXnWSGhG2ORYtCblLRtwdK4PhlFcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=W43fHSy1; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="W43fHSy1"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-38f24fc466aso1294047f8f.2;
        Fri, 21 Feb 2025 00:33:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740126808; x=1740731608; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ryHzKyfveAdWIa+r7HjLGqXR7a3x69/Jm4m+gTkad4k=;
        b=W43fHSy1D6343Ib7L2QTZ4ESO9F+ZbLYH7iBSym6Uf36bl2+GV8pzDu+fUhVtA2bps
         7nV7ulj3D3IFVz8Bt5y4Tdkkv9WtadFmo4csSgvF92cEnujpsnitsPlWpUkAFSxo44x+
         iMlAyKeVIVOAKE8b77Ae58oq1rCLlIapxvxDn8rbUg78E1U7PDA9vGgBf58wDkn6UxjF
         XIw4qwiD+b6q4meTb0dJkpHL27rZfnMB8sbhvQQQE5YmEZ6xQV6bRLLGZV9dFIz7h6cm
         4pJRFT9qNBH0XTjXzg8O14It6YkjSyFsEAPbIf1E8br2MkfsKE8yGAGvnixyGh9yIg38
         EgZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740126808; x=1740731608;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ryHzKyfveAdWIa+r7HjLGqXR7a3x69/Jm4m+gTkad4k=;
        b=v6+MG8+DORo0AYyOBXYWrLU2zKFxn16jrpuaxer9eZA5pvRycJlGdAiAFrhiiMUXRv
         pFWAraKibcO5bkcWhJErrDV03a16u3EX1TVGSV4Vt1+eF1/faZIlHKwHUBqQjoKAaNlg
         tB+j3BWS92zAEgeHob/SIAe0HWBm9WU+2fvfI+Tgfi0MUlPLRfhdF0glDUuPx2vM8o8n
         Ukysen6b0wDSls0//HVMW5T1WZlWE1UHBd+OIQF7SVblS2EZ/a6i3pnM0/0NlLkWthM+
         3aTlkgusvahHQoNSFRTtl3iQKLfASR/OVpeiQmruIV3Fiu2M6UzlzRxUFo9Dxm66lYEV
         PTFQ==
X-Forwarded-Encrypted: i=1; AJvYcCUyvMmYKrSTZn1H2gVXScm9CDm/ZaIAq82QdxCkOv1iZ4U8ZDe7YoOdlxZKNA0UG9qtrWSm5p3TM1rldQ==@vger.kernel.org, AJvYcCWbY5kmuGmjE4l7m+2a452hTPViFVKM87dH7NGSsvMr7w5RYolgU/RhTIulKBNRRySnwfDUYC8jGW1LYIQ=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx4oSc5E3d8CIVU4qzlKvOmyp7JLoMmCDkcD7NOkNakZirs9Pxa
	kXMFTWDgYig6EampXvrDfzjQzENbplBkiBjEpvPSN5Dhp5UwqqAH
X-Gm-Gg: ASbGncslRvvMZs2sG3Z0cE6avEDkBC8KSVWDtgIIxPnRJrtgdnYQu+HmUTenHJlNw+7
	4u7fmc/W2Kmdr9Laf1CCsVF7Jmm0p0j9o/r53u9lO/QnCyAOfASAeW3tMZG1JrS1QzRdyiD4xId
	DPfqNnKLHtcZV6Ghag3xMqyr++k9VBvrcer9K5H3OU8kb9Aa/BY1XYIcAn0wgcbnPczoXliQHUN
	Mj40aQMNKfyM2G6yJ54/q8/Or4vnrV61Zl3BQAgCRBAp7MkFmz+ekAwd/uSDLbxA5WrgWYS1Bsq
	9GTHzVca1zGhLfz0FVyCEQcGk7o=
X-Google-Smtp-Source: AGHT+IH01b5naMV4FRILCx+/3NRGg7lMWlpK1Y0wZ0vdJGa6P0CmGH7CCMiWDQ48xbULYg4Ta6Gumg==
X-Received: by 2002:a5d:45c5:0:b0:38d:e0be:71a3 with SMTP id ffacd0b85a97d-38f708593a9mr1107644f8f.54.1740126807250;
        Fri, 21 Feb 2025 00:33:27 -0800 (PST)
Received: from localhost ([194.120.133.72])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-38f259d58f3sm22660673f8f.73.2025.02.21.00.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2025 00:33:26 -0800 (PST)
From: Colin Ian King <colin.i.king@gmail.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: Fix spelling mistake "receveid" -> "received"
Date: Fri, 21 Feb 2025 08:32:53 +0000
Message-ID: <20250221083253.77496-1-colin.i.king@gmail.com>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

There is a spelling mistake in a ioc_err message. Fix it.

Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_ctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index bd3919f15adb..ff8fedf5f20e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -2959,7 +2959,7 @@ int mpt3sas_send_mctp_passthru_req(struct mpt3_passthru_command *command)
 
 	mpi_request = (MPI2RequestHeader_t *)command->mpi_request;
 	if (mpi_request->Function != MPI2_FUNCTION_MCTP_PASSTHROUGH) {
-		ioc_err(ioc, "%s: Invalid request receveid, Function 0x%x\n",
+		ioc_err(ioc, "%s: Invalid request received, Function 0x%x\n",
 			__func__, mpi_request->Function);
 		ret = -EINVAL;
 		goto unlock_ctl_cmds;
-- 
2.47.2

