Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3016A14EC5D
	for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 23:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722034802; cv=none; b=hKaw71tfbtWhtz4Ogl0tjL8s+SkFlYt6uE2AqJQCt2eHmiyHDQyvim+gCmS2gAfeLC9PEgnPmaz+ZtUSeQucKkrk6/Fut2lWbNjIPxD4rhNTsjKWPlLvSzZjl5TFTv4mTS5a4iz15653d5jQ6Evk0s0v3AYijtxsE5cc8ZsmikA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722034802; c=relaxed/simple;
	bh=BM3fxsZJz/PtyG0YFv5p6QB7ElzFaJgOm5d29hOI8Ic=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ah0CKDnrOVXakcF7ziN98Jz3/px98mq0XSjYZ61FhSy0vA1FxzqVVLWRaXUL5JfyOu3w/DByBfHj6v7DWt7s7TSB76XUkgnK64a6tRFqjKdbXX0zVz27xqDkPQO0Rmd+VuuWeuJ/fJEHQYgURWMvLrRoKVD3f9MK2f3DxdyBwac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hN4JIF/S; arc=none smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hN4JIF/S"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-260ec349a63so32547fac.0
        for <linux-scsi@vger.kernel.org>; Fri, 26 Jul 2024 16:00:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722034800; x=1722639600; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jzNxfxFXYxhV3zOTEy2zl/WDEKQehno+mpouleGevmA=;
        b=hN4JIF/Sdf6c3tlNU+uBoCbSWpsbx1z/o+NS19ODScqaHm5CpiUb8YeF4Z94dAD5T3
         lWhJV/7Dp2xyld51H1Y7sJZOXViN7a92kg1Y3av6qStadVSEaFS1RbFZnAHTwEZHDBiQ
         UhtK/QsrtxUtHJApCSLROtDvmU9n9iFZf2NptQm1InpqiC3D81ij33H+98ERgIjX9vMn
         /t4e/05ve5k7Vw6hxNQ0PqdqO3s4Mlrc8L4+vXzmeqjKcgPtmxbfhCFVRjunOiOsguWB
         V/VPVKtbfPPjliooMx3SSc3jgHArik3APWSLem88HbF9AQ8Y3OFykeyYEIH0hZ9PDHBR
         q+1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722034800; x=1722639600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jzNxfxFXYxhV3zOTEy2zl/WDEKQehno+mpouleGevmA=;
        b=mgEcwTBJbyBz1e37LhsyXiY2mflPhRFGmSbOqf8cr0Aax7NYrniLb07/Vc1qCXctYM
         g1R77UyqlA3uSv+RuckSnSSWzYOD5bKe32l0aFMe5CTn6tLZePNBMsNHxhxAhmnNIJkV
         rVWWJu6y2CcWGp2u/LIoF6TQ59RX+GYis6FsfDGBEpY7+5oZapcuNP0ODQjhGn8WpuQW
         /4gLiN0QJjLcrMb7Wg1kofMSS/zilEBN+w1aU0pVJXGvy7n/SrGAYxXWg/ukGyzawB7Z
         DVdVRcNAoYiN4dX7aHL5sKuto+jz7AxLxXJVMWr7HDGRgqcJITKOKhYyDMPrU7l+kP0j
         4zDg==
X-Gm-Message-State: AOJu0Yy0qb5lUL7sVCOxUVAFtRKWeFhQcWH1VPScqZXgBKLkFQ2uZCkK
	XKwZLPFUpJDs1Za7/vgMyC5s2PMiK5kH3//dQxU/2ly7XMOWRsCqhcexoQ==
X-Google-Smtp-Source: AGHT+IEC8LhqBLKFDJRVIUXmj+r6KOOnroQ3+vJ+VwubcPeuhxgjQZPtbKoOGLIupqAnyY7WNuZaIw==
X-Received: by 2002:a05:6871:e2d7:b0:260:23bb:1087 with SMTP id 586e51a60fabf-264a3230e2fmr4806936fac.0.1722034799994;
        Fri, 26 Jul 2024 15:59:59 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70ead8834b1sm3308540b3a.178.2024.07.26.15.59.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 26 Jul 2024 15:59:59 -0700 (PDT)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart2021@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 1/8] lpfc: Change diagnostic log flag during receipt of unknown ELS cmds
Date: Fri, 26 Jul 2024 16:15:05 -0700
Message-Id: <20240726231512.92867-2-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20240726231512.92867-1-justintee8345@gmail.com>
References: <20240726231512.92867-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

During diagnostics, it has been determined that the 0115 log message for
receipt of unknown ELS cmds does not benefit from trace buffer dumps.  The
trace buffer dump floods the console with unnecessary information, and the
singular LOG_ELS flag has proven more beneficial in debugging efforts when
dealing with unknown ELS cmds.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 929cbfc95163..50c0c0c91fdc 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -10742,7 +10742,7 @@ lpfc_els_unsol_buffer(struct lpfc_hba *phba, struct lpfc_sli_ring *pring,
 		rjt_exp = LSEXP_NOTHING_MORE;
 
 		/* Unknown ELS command <elsCmd> received from NPORT <did> */
-		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+		lpfc_printf_vlog(vport, KERN_ERR, LOG_ELS,
 				 "0115 Unknown ELS command x%x "
 				 "received from NPORT x%x\n", cmd, did);
 		if (newnode)
-- 
2.38.0

