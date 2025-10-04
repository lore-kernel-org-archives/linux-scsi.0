Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6890B21C9F4
	for <linux-scsi@vger.kernel.org>; Sat,  4 Oct 2025 14:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759589716; cv=none; b=Hg0aWt3ykRrQ0yoP3UG/vNllAAh07O5KRtVVbJwyT+KxphKHf2CpAj0GMJTd6gaeYG7S4xCudo7Tbk7lrdEXTWukC6ozAF7OAdGAR4yC+ziKkgvkiw/S9O/ZzEDyr1uEFZrKNTlGTyo5ZdQjbb/LO99DJI6VzZ5Xn5KIj4+Ajn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759589716; c=relaxed/simple;
	bh=BEmOIYLHt+mktFE1AF69E6bUCnw0SyVe6ODYPrGfzaw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TSDENrW0boQgHiUymzZbnI84q8+3j6zpUJUroxCJv+XDb0LywEDoTLFveHwiiy0flfOEp2grrKg1mpYvirvNQ3ZmDlbTMlrFUdgAmTG6IOnsd8v2YpKjEdNuEWJIE3G55WuYpOre1ZJ9jYptejNy9Q3yjp9/tPNUPLjETGRDcNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GVE+8F5W; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GVE+8F5W"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3fbd3d76875so103874f8f.3
        for <linux-scsi@vger.kernel.org>; Sat, 04 Oct 2025 07:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759589712; x=1760194512; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ePIwuOukVhv/Q22mXjk8sAtWB3woXBG8OGlpobn0uHQ=;
        b=GVE+8F5WL7HEwVTiyO+tu74WBDmgfzH1qa/mAA/GFO7xbi7aFcC4OWZBBqSwwZx0Ro
         UFaMRw1JEEGDgHucLMa1W+rPBZr7GvjIYx7ffjs0He2gjHLNdGR9t61AnV6p1f0I6KaW
         FN/mJg6sKrmNpK2r4YaxCtZh3VDcKLZIvqAvmJs5BkXXexhaca376YNqtffkcQ6FGV/i
         69GTB6CaClwe9Z3kGdcD3liGj6BTEHutt5EZF4+7OI7xsxHr/JeBtDNsMjDq2IKNwwfu
         1TIUHefB08TBiHtWG7QnWhWO8aJ7jHH+m7bw8twB7bKvuedm7rxT8inaem7iKW57pE6m
         hS1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759589712; x=1760194512;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ePIwuOukVhv/Q22mXjk8sAtWB3woXBG8OGlpobn0uHQ=;
        b=pf/rG2qz7XtEWAz/eEAirhIEJ34IJdYSGlyllWJq5/o9mMC2ifcdvvg7Yhdtrhry9f
         B8vnWHxOAQbyxd3so/JDaaNwTqkCxwha78bZbkBtSz+ROtWkxH/Y6fdatepUHcJqLw8I
         eSWaHvcVjhIadjZCzIk5Mm4B9PmOHliomBx3iLnoQKfL5cTj43e+TZJjwEi9G2hlEI0E
         siNU76lp5klj6/CpG3ee30Xobhs99Kc2jbXbiF/LNcHAPRkyDi3AuT2u/1w4Qw1P/C9g
         uxheD28SYffr5c5AYxCizy4Ss+cMknRonaL8cW5c7lVnj0tAWtMNu78UVyESssV+gsOX
         2cgA==
X-Forwarded-Encrypted: i=1; AJvYcCUFInhJv9d36wxxiafQ6k2a0d7kr2wFyjZRoxXOWxIGgbtTQx2H3QsRHha8RP4gR0wfymYr5/AOb2fd@vger.kernel.org
X-Gm-Message-State: AOJu0Yy45wmeKgBjRYRjqkKNYRrOQQ4Wryjb8WMVc59vwPZj9rOvLral
	U83lSShYIqfn5+9sGMBxJpSB90Hwff4PdEmAr2sEr2cvhUQhzplCht4=
X-Gm-Gg: ASbGncv74HmJX4k3toxK2VVJ0B5CohyDLrarWz5WztEgKIPKMZ6kyNOPzcA1r0xgbbC
	p2IOcWPSVKqRo0ULXck8MiDG+A+vYu3qsdob9csDerHEHwQwngWBH+0XBIQFw0nsbGgzdO6jqUM
	7td+lp2gNYIkjhpx/XwztaNi71a5YjtYcCNB87FjSKjoLh6zQaBBcj3+E2yJAxoxDYdVJukMkxf
	mopbuw2BaHo/KLEpAaF0TeEd6NiAOxi37zixd/9AVuC2m8SeDtfGawCKlyAK9uxqZtsV6/G0enw
	LqOhHRxkDH+Ov8fwUl83pBJEvggZ3PDKBT4hdOVX5VbR/3rlSRSzr2R+5s/VAe+i1EWQDTBB/BT
	1IpE3dFr0EokA6zYHeN3LWo2uKAoi2OIYJjL3jzDIANOhMWgJTfS5tNquZPgskoIz7uzB0qBJlZ
	76WjjGfEj3JuWZlAnDFY54hLKkZQ==
X-Google-Smtp-Source: AGHT+IHPIZhbK19fydbamWwcNhQPmiHlOZJK/Y5KekJtOdrOKrnqksW+rfgriLXoWi70avs/gpmCbQ==
X-Received: by 2002:a05:6000:2001:b0:3eb:734d:e2df with SMTP id ffacd0b85a97d-42566ffacdcmr2211170f8f.0.1759589711457;
        Sat, 04 Oct 2025 07:55:11 -0700 (PDT)
Received: from localhost (120.red-80-39-141.dynamicip.rima-tde.net. [80.39.141.120])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8a6b40sm12503952f8f.2.2025.10.04.07.55.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Oct 2025 07:55:10 -0700 (PDT)
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
To: 
Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Anthony Cheung <anthony.cheung@hpe.com>,
	Takahiro Yasui <takahiro.yasui@hitachivantara.com>,
	Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	SCSI-ML <linux-scsi@vger.kernel.org>
Subject: [PATCH] scsi: scsi_devinfo: blacklist HPE/DISK-SUBSYSTEM
Date: Sat,  4 Oct 2025 16:54:53 +0200
Message-ID: <20251004145459.58259-1-xose.vazquez@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit

DISK-SUBSYSTEM is a special model name returned when LUs are not installed
in "OPEN-" models. Full info: https://marc.info/?l=linux-scsi&m=125424006417825

Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Anthony Cheung <anthony.cheung@hpe.com>
Cc: Takahiro Yasui <takahiro.yasui@hitachivantara.com>
Cc: Matthias Rudolph <Matthias.Rudolph@hitachivantara.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: SCSI-ML <linux-scsi@vger.kernel.org>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index 78346b2b69c9..b39019f57db6 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -185,6 +185,7 @@ static struct {
 	{"HP", "C5713A", NULL, BLIST_NOREPORTLUN},
 	{"HP", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
 	{"HPE", "OPEN-", "*", BLIST_REPORTLUN2 | BLIST_TRY_VPD_PAGES},
+	{"HPE", "DISK-SUBSYSTEM", "*", BLIST_REPORTLUN2},
 	{"IBM", "AuSaV1S2", NULL, BLIST_FORCELUN},
 	{"IBM", "ProFibre 4000R", "*", BLIST_SPARSELUN | BLIST_LARGELUN},
 	{"IBM", "2076", NULL, BLIST_NO_VPD_SIZE},
-- 
2.51.0

