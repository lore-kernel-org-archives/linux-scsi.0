Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E16B3A6B6B
	for <linux-scsi@vger.kernel.org>; Tue, 12 May 2026 23:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778627626; cv=none; b=Qf1pSNv4snDKsByA1Sjuk3FzAfbWJUd+IX0hJap7V1wjfDe7CR7+MIvfmNdXYcLdnOcQz3Mj5d9Dxf98mGQbYBxK//o5EX/acPyHohS41v//QDYXkgOiLi6ADSb3Jnv2AC2Z8KJQ9zgx7Z8Mq7XYWY8DLmrTuVUD5iECReIb+UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778627626; c=relaxed/simple;
	bh=SYNe+Dsg57y7WD2LYbKcm9AMAC1JG+4pchpv5uEPB7w=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VnN2iyTXzQBJcTkIi5AJ0q+FFG/h1izeojY85vcakJ+8zK0VVBCI4fyMOIAuB40Ji9//hVbM1TNLukGLBgOWH7gtUS7jcmhNxmLNt3ZXvNN4vELggKMpbH42nVVhMI2uOhQaFYYCJgEsUGUuujrqU4vnOhUNnfVPQgRKRiYPGPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=math.lsu.edu; spf=pass smtp.mailfrom=math.lsu.edu; dkim=pass (2048-bit key) header.d=math.lsu.edu header.i=@math.lsu.edu header.b=BWyEpzWv; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=math.lsu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=math.lsu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=math.lsu.edu header.i=@math.lsu.edu header.b="BWyEpzWv"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-7dca5f64e86so4837860a34.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 May 2026 16:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=math.lsu.edu; s=google; t=1778627622; x=1779232422; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=npNbUUiECFDj3bv5vcqfHuY1fsKALqz43i8X8Df8y/Y=;
        b=BWyEpzWvf6czlnoOYQj+sFqPDVFP8Pa3ZcI0ff+wGm0K3EzS8vkEa65Ue8sA6al6U4
         gA14s5Vy0akQsroYAfIYXpjVLMC4AdOiesPLg8vh70ZyNjpHZK7y8jlg4MsFQX366vfu
         sEnVjE3d7kS2t4Y3BErW4PSVLwhw4SSojoXFkGHc2//YbN9Xyp7HtjOm8O5W9XrtApsi
         5cMhxc1hneHRBZ2unI83aWFUjsZWAZq9JmsWk3oG+URixIOdRnH1k90WqKpIltuSWynb
         3CcCkAx9yrr5GIqel/Fr76kxwtc/5D+6rh8PV4fr1aIuKLKrgBOnZtut+sbdBYi1Kckh
         eXXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778627622; x=1779232422;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=npNbUUiECFDj3bv5vcqfHuY1fsKALqz43i8X8Df8y/Y=;
        b=RahE3Sfni1Lr1jbx8RUvEGxh0iRzxDfNdz6QVVEZS5rOFN+DqkoYu92DDi141QcG8e
         tiAg9swrzxX8j2vNLCXeFkogyUbGtrobYG76QBj197EXoTTA8xR3XsENv0ZJrIyI0ymT
         eh27C4TVp5M+mRDBFWruCrFrz+FGJhcNKFlbRfK/l52Xo4WOCE5livYWdX7jVu4HPY7Q
         h9Z9bx5gymy5xsj6BMI1HCqzCGpztYNUxmeQ/8WxZxw2CP1/pWQI1FVeUAqA6khonLZk
         bTWPrgIa72uwlCj/e0MhJsbW0YygTk49wr/kX72OHOu39JE0obKzH3ZzFx+BhjSMSYaH
         sESw==
X-Gm-Message-State: AOJu0YyFeXxhVUF+qTkAxuVxp+R0dOd0ajeq7k6FqCEdiuLVK3J7gej7
	8dOxzRIQNkF0++niPsSMk9tHDqxERxY9DiysmeGMaT2g0r5kfHwibdeLIf6ousfccm0=
X-Gm-Gg: Acq92OH9hzy1e8G2wP1S8gZqx02rM4dI5Apg6112U+j+qdSqfvIVvh2MqbdLuYMpApt
	+AORUGDT4Pi1wzxfsM3KCV4fnJ53nDn0mLvF/AAtvgEEu4fvnRYonrB+F/1VnnX3O+mgplv3XX7
	w/lRKz81OaGnsHiFT4Fqo//VKkvmuNfB49zW8kcSmYl2pw+OhifQsTPMHaZT3EvN/f4Go0p85bb
	cLvSLRdwbbrWv0HG3DopZB1G69bQiLqb+BeQT9KiQ8svpBpkazjRLFSCR3uRjn2KLmX3q6EAaZy
	P/miLKujVlxPkTrqQxVcCjGQW4CRwCyj+yok6RDs7A1iMMjZn9oLIs/H/1rCDeMDXXAgIrPx+iB
	Dgg+vHYm+GZE6lvDVRcAPZLvE/gcUjh6LMkqfgOdJerB4fpXGgnyszzn/XKRQmytN4kt1iO3jZL
	6Y+nMQhvm7RXqI0/CIyYfiIXntCM5Lpc2WmmBJf4n5aM6M8sQtcHsSB2guUaXwwfpSiWikt4XC3
	n2lm4E=
X-Received: by 2002:a05:6820:c96:b0:67e:36e9:79ac with SMTP id 006d021491bc7-69b7aaad7dcmr92588eaf.27.1778627621924;
        Tue, 12 May 2026 16:13:41 -0700 (PDT)
Received: from calculus.math.lsu.edu (calculus.math.lsu.edu. [130.39.247.203])
        by smtp.googlemail.com with ESMTPSA id 006d021491bc7-69b25c767d0sm8628979eaf.5.2026.05.12.16.13.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 16:13:41 -0700 (PDT)
From: Alexander Perlis <aperlis@math.lsu.edu>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Alexander Perlis <aperlis@math.lsu.edu>,
	Nikkos Svoboda <nsvoboda@math.lsu.edu>
Subject: [PATCH] scsi: devinfo: Add BLIST_NO_RSOC for Promise VTrak E310f
Date: Tue, 12 May 2026 18:12:54 -0500
Message-ID: <20260512231254.27530-1-aperlis@math.lsu.edu>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The extremely slow boots reported July 2014 in
  [Bug 79901](https://bugzilla.kernel.org/show_bug.cgi?id=79901)
for Promise VTrak E610f 3U 16-bay FC RAID enclosure occur also with
the Promise VTrak E310f 2U 12-bay FC RAID enclosure. The 2014
  [patch](https://bugzilla.kernel.org/attachment.cgi?id=144101&action=diff)
added support for the BLIST_NO_RSOC flag and specified that flag for the
Promise VTrak E610f. This current patch simply adds the E310f to that same
list. (My workaround has been to include
  scsi_mod.dev_flags=Promise:\"VTrak E310f\":0x20000040
among my kernel boot parameters.)

One curiosity is the additional BLIST_SPARSELUN flag. This was also in
the 2014 patch for the E610f, and was already in place for *all* Promise
devices since 2007 due to commit
  e0b2e597d5dd ("[SCSI] stex: fix id mapping issue")
which added the line
  {"Promise", "", NULL, BLIST_SPARSELUN}
The 2007 commit message talks of issues with SuperTrak EX (stex) but
the added line did not limit itself to that particular device family.
The current patch for E310F, like the 2014 patch for E610f, adds
BLIST_NO_RSOC while preserving BLIST_SPARSELUN from 2007.

Signed-off-by: Alexander Perlis <aperlis@math.lsu.edu>
Suggested-by: Nikkos Svoboda <nsvoboda@math.lsu.edu>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 68a992494b12..c6defe1c3152 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -218,6 +218,7 @@ static struct {
 	{"PIONEER", "CD-ROM DRM-602X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-604X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
 	{"PIONEER", "CD-ROM DRM-624X", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
+	{"Promise", "VTrak E310f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
 	{"Promise", "VTrak E610f", NULL, BLIST_SPARSELUN | BLIST_NO_RSOC},
 	{"Promise", "", NULL, BLIST_SPARSELUN},
 	{"QEMU", "QEMU CD-ROM", NULL, BLIST_SKIP_VPD_PAGES},
-- 
2.43.0

