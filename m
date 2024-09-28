Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85E4416132A;
	Sat, 28 Sep 2024 21:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727558276; cv=none; b=nYJtomKTnCjQahrdluMVE0+Kp2qJWlmRGQtuZgEMZO9nkWux/TGD8AUDYk9VsGjXstfmlKNDidO0iU3oAyKfcdVQQn2uohpF/WMpmVF6MWul3etQZsxMcebxizNs8g1Zq2T1LoLqjAZg+2R8ns8iO+LvJztq1IZQfrIcNpAdx+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727558276; c=relaxed/simple;
	bh=GwRvUgdYRx+FPpFLOv0ZnuF0mEdbcNAZNxe7CmAoNhw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=ovrztC0WYypp0P1IDD5HzmZD61AowZ0b8lDYk4bZQooT1isK7SKb/SZFCBGA6Zb+6n8I6K+xweRtqNeTdiGZ0vRfZs+xO3Qa8/J4sGFZv8diizJ7lMaFXMIogbnqzgsrTntQ4CHOXHgbrnf7MLZmNTbUst6Q/uAMFQxL92BsRdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ewrcaQYT; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ewrcaQYT"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-7a9af813f6cso290908285a.3;
        Sat, 28 Sep 2024 14:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727558273; x=1728163073; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=f+Ut8sm7zAb/iu6ZI8xkj9vcj2xlrsZA9C/mM3pTsjY=;
        b=ewrcaQYTULer47vbf4aYbEyAcfCJZhvacBMbLUseFmi+UJLP+LUaqfiidIgRgxAAE8
         BqnT4YlJL+LVS+poSgaHz3yIk7t10In2uBtIWotOwOdN4TLcf19cuWM8H3nm6OyE3FjF
         06mkInh17km6FjllTa+MbOJKfVX3UgZjUbmKGnYgqQqhcqc+fsA61BQZaUa9Ksre0F5t
         g6ViW+UsXAqCSgrhaTtlJD5iqziwBM4nSkiwBTMYYrsBCtN098AX97jSPEf36qV5I4LA
         jLtXCcmwsxn0GEFRn8C9llFixQHfAlYMoUSbHR7nQkm4xF7ZVEd14/DZC4WUszhTNzea
         y9eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727558273; x=1728163073;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=f+Ut8sm7zAb/iu6ZI8xkj9vcj2xlrsZA9C/mM3pTsjY=;
        b=mQK6RiohlnhzRbTcbt28XVTPGCCclkDUkJypHBeR8cF4ga+Mp12sW3zeW70Lf8+DZr
         cdch40WQh8KtwYsucXP/NPFu32EGOLj08E3+aM5sBNHok5Ma3dpwIkHKZxKjqNnbgAZH
         K2Ggdf0+zLmciy4Xy2XlwNkEXGP13qktsp5fIMx7rtaLundbL5aG8GuabmRkArdwCvcO
         1ZPD+BROAWJMkC6hi0YW94qIYP3GsHFg6M9xjY+rANg9P42oD0vt639J0BO5tb0Hi0Mn
         nAW4xbFKEf+d6mnoMK1quLYpW2qN8Ji7f7lleyq+ZVhAMXdCSmo0X9LO3a9CLrI5a2nR
         IKNQ==
X-Forwarded-Encrypted: i=1; AJvYcCVhAftFFoBl+/nTT2L/h8sv8i4yeYyuKuRYRGbEdrglk7QSHEuneHQzhA9IQXoq2qUpLnceJxK0oOvE8/4=@vger.kernel.org, AJvYcCXW4tsJSCMgI8I6jmAGAhoqfoo5t2OCG1y3j7F+H3/3ZtmlEm5xdK5ESFAabnCwS8uDve83cMeGPzQx/A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8diaH+wI6Vtv77tdmEEbzkOfVA+uDrijoIidaoxaL2eKsipka
	JJDgbJXq4xZC67BRNv5xjASsM/kHav3eEUj2jCm/MdEm1HDpvvhV
X-Google-Smtp-Source: AGHT+IHdO3WFKcTqHk9kDvCLH+LJuxTQhUV1lKezoEvnJtlfPfSTZpOOU3tFw0Sq23YzwV+r5+MLgQ==
X-Received: by 2002:a05:620a:4413:b0:7a9:9ed7:b49f with SMTP id af79cd13be357-7ae3785632emr1175650785a.38.1727558273594;
        Sat, 28 Sep 2024 14:17:53 -0700 (PDT)
Received: from [127.0.1.1] ([2607:fea8:bad7:5400:c768:2b64:e844:1a23])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7ae3782cd54sm239349585a.94.2024.09.28.14.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Sep 2024 14:17:52 -0700 (PDT)
From: Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>
Date: Sat, 28 Sep 2024 17:17:40 -0400
Subject: [PATCH next] scsi: mpi3mr: fix uninitialized variables in
 mpi3mr_bring_ioc_ready
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240928-driver-fixes-for-mpi3mr_fw-v1-1-fc340a71e19a@gmail.com>
X-B4-Tracking: v=1; b=H4sIAHNy+GYC/x2MQQqAIBAAvxJ7bsGsQ/aViLBcaw9ZrFFB+Pek4
 8DMvBBJmCJ0xQtCF0feQ4aqLGBebVgI2WUGrXSjjG7RCV8k6PmhiH4X3A6uNxn9jdrbubJmclb
 VkAeH0K/lvodAzwlDSh9dttPFcgAAAA==
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>, 
 Kashyap Desai <kashyap.desai@broadcom.com>, 
 Sumit Saxena <sumit.saxena@broadcom.com>, 
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>, 
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>
X-Mailer: b4 0.14-dev-0bd45
X-Developer-Signature: v=1; a=ed25519-sha256; t=1727558271; l=943;
 i=abdulrasaqolawani@gmail.com; s=20240928; h=from:subject:message-id;
 bh=GwRvUgdYRx+FPpFLOv0ZnuF0mEdbcNAZNxe7CmAoNhw=;
 b=MmUaVN+oAAUZxlTCuGrZApOIhzqfVs1Zh9cfiWibALFXifiAcZix6RxBM1IXLWFOEZrYqUcoa
 bFa62ty+E0IC3lZK/p/27ZEXMYMZEB55GEVzD3xA/jshH7YmaYn46uz
X-Developer-Key: i=abdulrasaqolawani@gmail.com; a=ed25519;
 pk=985cWqQZSGcRygcjLs+fi8mACOgCIBexboD/qtf1VY4=

Initialize the `start_time` & `elapsed_time_sec` variable
to prevent errors when calculating elapsed_time_sec.

Signed-off-by: Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f1ab76351bd8..f93968b76883 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1363,7 +1363,8 @@ static int mpi3mr_bring_ioc_ready(struct mpi3mr_ioc *mrioc)
 	enum mpi3mr_iocstate ioc_state;
 	u64 base_info;
 	u8 retry = 0;
-	u64 start_time, elapsed_time_sec;
+	u64 start_time = 0;
+	u64 elapsed_time_sec = 0;
 
 retry_bring_ioc_ready:
 

---
base-commit: 40e0c9d414f57d450e3ad03c12765e797fc3fede
change-id: 20240928-driver-fixes-for-mpi3mr_fw-2fac1a9bda03

Best regards,
-- 
Abdulrasaq Lawani <abdulrasaqolawani@gmail.com>

