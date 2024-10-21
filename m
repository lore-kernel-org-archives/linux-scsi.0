Received: from mail-yw1-f194.google.com (mail-yw1-f194.google.com [209.85.128.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B785173;
	Mon, 21 Oct 2024 05:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729487875; cv=none; b=KwDSRbJQZMoh+L0ggKF6ww9KQOai1ynfNbyXFLLrSr4X8k5A/rAU88Ua2bisEQcMu2T61SDlUrAPnUbV1CetIVdo0XjNJTXpocVPSwxh4qrRKso39TOpuQQlMxrHD9avTVo5NwB4S0bGBEIwwshnDNDNAw2DWf2MjLynC6mR/Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729487875; c=relaxed/simple;
	bh=0XwMeNMJ5ODPtkbESnU3FltvFhNY7bbCcFY+I+hg+mk=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=HQHPn949v5hQptD6i6Gay9o6diuPsHrSj7KB4F00UW7Tv+1qrRI6qJBayuXFbK4qeOKjcgR8n7T1DeNML9Y8Bqu2OYjoadMsxqjzutHxQpZ9bcgr2AQMyal+W+ThfGvnL+IGODMEjoLMqv3O258CIY7/8d9NQj75J78O5NxnEh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b74Blz9G; arc=none smtp.client-ip=209.85.128.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b74Blz9G"
Received: by mail-yw1-f194.google.com with SMTP id 00721157ae682-6e5cec98cceso18215257b3.2;
        Sun, 20 Oct 2024 22:17:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729487873; x=1730092673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=w2mbf2/3v5HCvkk0Y3A4O4H8UPw7wHC2/3QXIZ4AZiM=;
        b=b74Blz9GupJb/XHi/p42jswVdewl8uH96GxK0eyyZ5N2QFiejXjhGjzfr/p+V9a8wW
         uHMj34WlLM1BDLJgrB0fNJtzn4+FoCqDKuex6hfCIqauEUB0YTRKPaji2rVTmD4u66LS
         SHY3OTrmzb7zbT2eDCt+STQMlDLfSWHNtpvQQGzBXyeVACe1X8zZWcmeRwySrZD+orXH
         l2XLrZzmVLiSsen/mcXaHf4S/MndIuNyqVNnVcAFdCWj9MUl2HSJkwKiPgPUzksq79ZC
         J4JD0kaCWewmakY5kMx7QOB0eKJia1V5CsD1lwk1ssq6d7cYH8MJWNsDgP0TA0d+YSge
         DCPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729487873; x=1730092673;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w2mbf2/3v5HCvkk0Y3A4O4H8UPw7wHC2/3QXIZ4AZiM=;
        b=Ec7Di4CM+olKjPYHGyjCAA8wDJJiEpnst8BoQ5ewnfagjlMm3hl/okWG/YMqDAy/Ps
         bgr845gdEU/Mx10elAD72UE5+5t7D4l1c7hI+RQlJCNStV/ui1S4pWXBCRMRhttcVeiI
         amEsU1hlZG5aQoZe1LkhHYpNwsECKnEYFbfvz4hNUW7YrGgs12+xYSGftsg6id279j5w
         uyQHEFOKIaMZ/Xu2u/7Ygy7qBVUSIg3C9I08TSA+I0gbQJo9csE8ZQz7/nreCHiQ4QFl
         48o2ju8PoIDpBIygWfn//gWIVY3c6foUy++herauPkPgxJZKKl7KrYd+D6UdPxRLeSse
         NFvQ==
X-Forwarded-Encrypted: i=1; AJvYcCV8Hx+LUYCyUYOVw+pu7KRzUFn3BShCjjLXbtGvDlbQJCyrsOBdCVyxv8HDZ3D071CdmZoeWtfTvao5PKI=@vger.kernel.org
X-Gm-Message-State: AOJu0YyunM5IoEyN21p+obHjzQPCPzEB3hvjhoYTC2FzETzlkfJKr4EO
	cjbz7rj1GO7rspV10wMJSk/2oYPRlY18B32W0FJrqJs6oQv7oKIX
X-Google-Smtp-Source: AGHT+IFhB+2BMCRwmpZuXSYzYXPtRXRCzq1BvxkBqoJvQ5usuZV8BHo1l6lEyRMaJ+Zddgllue0B8A==
X-Received: by 2002:a05:690c:dc4:b0:6e5:e714:3be0 with SMTP id 00721157ae682-6e5e7143bf9mr40581647b3.1.1729487872798;
        Sun, 20 Oct 2024 22:17:52 -0700 (PDT)
Received: from localhost.localdomain (host-36-27.ilcul54.champaign.il.us.clients.pavlovmedia.net. [68.180.36.27])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6e5f5d6f9dbsm5510267b3.141.2024.10.20.22.17.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Oct 2024 22:17:51 -0700 (PDT)
From: Gax-c <zichenxie0106@gmail.com>
To: james.smart@broadcom.com,
	ram.vegesna@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	fthain@linux-m68k.org,
	quic_jjohnson@quicinc.com,
	hare@suse.de,
	dwagner@suse.de
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	zzjas98@gmail.com,
	chenyuan0y@gmail.com,
	Zichen Xie <zichenxie0106@gmail.com>
Subject: [PATCH v2] scsi: elx: efct: Cast an operand to u64 to prevent potential u32 overflow in efct_efclib_config()
Date: Mon, 21 Oct 2024 00:17:39 -0500
Message-Id: <20241021051738.17667-1-zichenxie0106@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Zichen Xie <zichenxie0106@gmail.com>

This was found by a static analyzer.
There may be a potential integer overflow issue in
efct_efclib_config(). efc->max_xfer_size is defined
as "u64" while sli->sge_supported_length and
sli_get_max_sgl(&efct->hw.sli) are all "u32".
The result of the calculation will be limited to
"u32" without correct casting.
We recommend adding an extra cast to prevent
potential integer overflow.

Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
Signed-off-by: Zichen Xie <zichenxie0106@gmail.com>
---
v2: adjust subject title.
---
 drivers/scsi/elx/efct/efct_driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/elx/efct/efct_driver.c b/drivers/scsi/elx/efct/efct_driver.c
index 55d2301bfd7d..7fe180037c2d 100644
--- a/drivers/scsi/elx/efct/efct_driver.c
+++ b/drivers/scsi/elx/efct/efct_driver.c
@@ -109,7 +109,7 @@ efct_efclib_config(struct efct *efct, struct libefc_function_template *tt)
 	efc->log_level = EFC_LOG_LIB;
 
 	sli = &efct->hw.sli;
-	efc->max_xfer_size = sli->sge_supported_length *
+	efc->max_xfer_size = (u64)sli->sge_supported_length *
 			     sli_get_max_sgl(&efct->hw.sli);
 	efc->sli = sli;
 	efc->fcfi = efct->hw.fcf_indicator;
-- 
2.25.1

