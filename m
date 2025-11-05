Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D3E2C0282
	for <linux-scsi@vger.kernel.org>; Wed,  5 Nov 2025 14:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762352092; cv=none; b=uMEzuvVNeFHpFj8Xlp5N8ZjnyEU7sDNmWozAuLRIzoB9YYeEIxzRM9e+CaOPxs6cwwn1xaMOHv+dol8bBrMYqBsG9g40y9cJ+s4T5PyBA+disBB5wHia/uhfsC5uJmux8N4++/mX6aiNtNqFPa8e9Gmq6/RZiFfRIW2Dd65f3tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762352092; c=relaxed/simple;
	bh=mJxls0L6MjDLzDQonIfLUUpMj8pgWbeFfC6UPwa7zxU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=F71GoPwpojUnVIUu50YNf2JqGcAwgpJc2B8Wxwm7w+t535++P5UQgaQnZ1OHUhErtgDPw8nYTFOIfwL+Z5K8fgWDany+G591srVToIZCVf+9IMuQjpqwrqMr8ofrPWYpG1yTn5Lox5TME5Z5arwlt7EVo9WIVgu7u5pWhYIz0W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iBjdmEZt; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iBjdmEZt"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-7acd9a03ba9so1740548b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 05 Nov 2025 06:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762352090; x=1762956890; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uVOvJXaWSxDtfYehskh8E4BDAZD7pJCUnmkX9Zw9K7k=;
        b=iBjdmEZt+REbVkvwmKIN22/5yfjx1gwgxoHyVbSwu+Zp/q6TvTAv2CqURZ6Qk7mT4/
         ZSH0hFC3mTJDUvHO6gF8d80A1TtROWyK5r/sWL+UgjPY3CPRCpJ5GWE6DHqE9bJ0+d1T
         vJzRan4jzzgih4ClZO5upYrvqjzIDHc3C4BUi6B6nzxptIZMUGtX0WgUsDIXxveli3Um
         eqAzZ7I07DEYqRzAYSrhrP5NVreJH7lEjMc0FiBgeA1ySkEG/y2ryoO9zXXcbSez/3DT
         Rj2nH92tnA3J3CTH9o/Gj5TcboVQGGpi2gUygtPHY4nv68QGj024YJ79Hdhi3qB7akbb
         mzoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762352090; x=1762956890;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uVOvJXaWSxDtfYehskh8E4BDAZD7pJCUnmkX9Zw9K7k=;
        b=ZcjfF6HeADKABC0dzbwVc0mLxE2D/x4FSu23+4MhhDteQA5iqR6jLkKqo0oxohL329
         AM7BHwwzmlzzl1PHlUl3fEaov7dvqrPiS2dObgNRUk4vVeLUJzufERk26Zo/DytTnPlg
         DjDyt0CioIRqDL/asuYGR18RqqvUv7tLWEK36b33UkQ/9tO0WdwgWRWOVsP9ku+tcrEp
         Bkq4oLkvLUOwt9AFtNF2VV5EnXq8s5EvTZB4PLQqDnWa0Hl1x4TrR6Jz2HYj3z/uWnWR
         cBXw9bUxTKFvuvqb/STApPvxH3pm+wCMzPqIV2zt3UNidTsD075c7Cw5cZZOLuBPrwoR
         P2IA==
X-Gm-Message-State: AOJu0YwKfw3zW7u7PeUhAFeVAtPG+Tt6FvOG2CKMepuomBjLTFOayVVX
	AhXIS5C+dV9SQZFB2f3ntd2UeW2RRHLQJVcO/ec9MgIH8BnHRF8ahYI0
X-Gm-Gg: ASbGncumYaoMTkzhmTp2UPLXCl1DNx9gz6lB11kKdEJKafR0MDzxxaAjVK6LY9lASAj
	GCPjJr8ySecQedzjVmjP8ZTLYIg2OnJlTsXkvobN7B0++SM7epeQuk4JPsCvSxucONX9s2sQGx8
	ZGF7n3NHoUeQ24RX0fpj6DoYKQwAGu9+DPF+gIO2z5aYM8+zRtDFa+mm+A4KLqpcIu4cXenrsRL
	/I7PD/mnMme/porIfGWaZwgVyM0sm1AmE5K/l5FMaBFS8KAJq33SgQsWeBDI6NnswibvUOiyHvq
	66ph364/siTdeRw6vLwfGv6I4ZYLnWsB7gZolaAm0Qqu5Bpa4R5lT8SozutoEj3ZTkRNsim8zQw
	28nhkaicZQUSy/z+iliWqGfK6tmCf+DvUFNoBTEl2qnV28yg0sXEE7As2g+bXZVQA2/N/yZgabu
	Q=
X-Google-Smtp-Source: AGHT+IEPkfZnunnyTLP4kMjyBd6sKE6DJzNwoAB7AKeujS0KY5CfB36Ljlq3waBtxiMTG8JdaqBBKw==
X-Received: by 2002:a05:6a20:12c3:b0:341:8609:3bb4 with SMTP id adf61e73a8af0-34f83d0f7afmr4219467637.21.1762352089969;
        Wed, 05 Nov 2025 06:14:49 -0800 (PST)
Received: from aheev.home ([2401:4900:88f4:f6c4:1d39:8dd:58db:2cee])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7acd382ab30sm6518754b3a.24.2025.11.05.06.14.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Nov 2025 06:14:49 -0800 (PST)
From: Ally Heev <allyheev@gmail.com>
Date: Wed, 05 Nov 2025 19:44:43 +0530
Subject: [PATCH] scsi: fix uninitialized pointers with free attr
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-aheev-uninitialized-free-attr-scsi-v1-1-d28435a0a7ea@gmail.com>
X-B4-Tracking: v=1; b=H4sIANJbC2kC/x3NQQrCMBBG4auUWTuQpAmoVxEXofnTDkiUSSzF0
 rsbuvw27+1UoYJK92EnxSpV3qXDXgaallhmsKRucsYFa03guAArf4sUaRJf8kPirADH1pTrVIV
 TyM7fxuvojace+iiybOfk8TyOP4VFxIZ0AAAA
X-Change-ID: 20251105-aheev-uninitialized-free-attr-scsi-d5f249383404
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Dan Carpenter <dan.carpenter@linaro.org>, Ally Heev <allyheev@gmail.com>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1567; i=allyheev@gmail.com;
 h=from:subject:message-id; bh=mJxls0L6MjDLzDQonIfLUUpMj8pgWbeFfC6UPwa7zxU=;
 b=owGbwMvMwCU2zXbRFfvr1TKMp9WSGDK5o6+tlV1zbfFK+c9Lxa5/4Jk2Ny5PW8UwXbU4oo1NU
 ihWoN+8o5SFQYyLQVZMkYVRVMpPb5PUhLjDSd9g5rAygQxh4OIUgIksVWJkeJYbcfzVjs/z/98x
 +x0uwrOP9xjTCmPPpsi1e+6mvavovsHI0HDky7W4AG/GiX2Tb8kIq5SGmma9YNfJlZqT6Zx6et4
 0bgA=
X-Developer-Key: i=allyheev@gmail.com; a=openpgp;
 fpr=01151A4E2EB21A905EC362F6963DA2D43FD77B1C

Uninitialized pointers with `__free` attribute can cause undefined
behaviour as the memory assigned(randomly) to the pointer is freed
automatically when the pointer goes out of scope

scsi doesn't have any bugs related to this as of now, but
it is better to initialize and assign pointers with `__free` attr
in one statement to ensure proper scope-based cleanup

Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/aPiG_F5EBQUjZqsl@stanley.mountain/
Signed-off-by: Ally Heev <allyheev@gmail.com>
---
 drivers/scsi/scsi_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b2ab97be5db3d43d5a5647968623b8db72448379..89b36d65926bdd15c0ae93a6bd2ea968e25c0e74 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2961,11 +2961,11 @@ static int resp_mode_sense(struct scsi_cmnd *scp,
 	int target_dev_id;
 	int target = scp->device->id;
 	unsigned char *ap;
-	unsigned char *arr __free(kfree);
 	unsigned char *cmd = scp->cmnd;
 	bool dbd, llbaa, msense_6, is_disk, is_zbc, is_tape;
 
-	arr = kzalloc(SDEBUG_MAX_MSENSE_SZ, GFP_ATOMIC);
+	unsigned char *arr __free(kfree) = kzalloc(SDEBUG_MAX_MSENSE_SZ, GFP_ATOMIC);
+
 	if (!arr)
 		return -ENOMEM;
 	dbd = !!(cmd[1] & 0x8);		/* disable block descriptors */

---
base-commit: c9cfc122f03711a5124b4aafab3211cf4d35a2ac
change-id: 20251105-aheev-uninitialized-free-attr-scsi-d5f249383404

Best regards,
-- 
Ally Heev <allyheev@gmail.com>

