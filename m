Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFD324A049
	for <linux-scsi@vger.kernel.org>; Wed, 10 Dec 2025 01:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765331101; cv=none; b=K/VV4+uyMRRQl51QZRh/fxjZkHoOW02y4nsGt+WmHIWsb7PdfyX4aMujjWZv5A1aO+tFklyrddvpIwvY7o9+R4AFC95PtfKXYc/qeecsVt714P/rvVUa6y7v69YVejpf+0xoXLewdPkhXTYHB5oTThucQ3OFW6EzLIbTtYSosBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765331101; c=relaxed/simple;
	bh=AMxxhUkwVWytoBdA0qFSxBu6u5veHcpEDX3IoI9In/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2iSbhNykcCC4rjTe9Drv8DKWOXfIYdbwNmN/FWPvB7WifiDi61+kzhYwirJJw8KAzUR/3PYLKCPyJaZa/RKwjEpQxsy3ksp23ByowtojvMnS34scGXAPBjjqbATJP9E6i4+Qcbmvw/Zp1kyXjEPHtM/pbYq0JORGQZBshuOSEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HqYfNbLe; arc=none smtp.client-ip=74.125.82.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HqYfNbLe"
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-2a45877bd5eso645824eec.0
        for <linux-scsi@vger.kernel.org>; Tue, 09 Dec 2025 17:45:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765331099; x=1765935899; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gbXFpMWOE09JOBukAU22u0Zfr4eCRsqxYTwjQcd8SQQ=;
        b=HqYfNbLeGJPmcOm9em9ACh0NAn4Ic956TRjjX8kaKtPHTUhUHSJkdTqfrIUt45BgCP
         HQSS/aNcROVRP6Q+lu81VC5w99wCviXYy/flDkpi8gh2NP5ILjUtEproz13IqMHu6DpY
         v4Og2MLWAde7u3JHI43ntnEXVTLfyZpIG1aJPMvROvFl1SO0U4uZssrU8zODKsfVBlcB
         KeUZ91pODQarpSbF1oIiIjd+n1Hp1X0tPqqBohQ0R8xlNpyZTy/hyLVpNVDp8Ar6W5a1
         0rroLHmxmMWzA5EWhT+nbujeuqB3uNds8v37L6A908+dLROp5/1wVIx9OFVAmDrb6bti
         K8PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765331099; x=1765935899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gbXFpMWOE09JOBukAU22u0Zfr4eCRsqxYTwjQcd8SQQ=;
        b=pYTnc8fuol1ktW0pvF650G4PITw3yAVO3HhozT2BSR4xEi5QnCTPQxI7FLaFuuuxve
         8ZlyPI7na9OU2zGM0jqepK0L2nP7pmKWPdV6m/By4P9LJazQUMA7GAnGSIyyntiGFfDX
         Tu7ui2YElXrmuZkLCqWoBfDT/tcL0MLiRixTfBrwEh9+3dFhCgo6UzE1PUTCDT1fXZ7A
         Q/hS4XNgQZnbHC86azUcgpa/rmvKFPN28cUOgWEY8GUqcu3HdvviwlcWP4DpJqAvv3BL
         jL7FnaxXajtmp3LbXwReFReetflrZyAvRkTiiuIXkZCiDeT+yOMRRf2o3Gy7X7Arqa50
         /Z0g==
X-Forwarded-Encrypted: i=1; AJvYcCXJDmMuUL7GiH4kcNb7ycISVGDtdTpfe7bbOqxrTjIhpji7b05R3On7f6/9F0io3uMsPPe2Y3zVVnar@vger.kernel.org
X-Gm-Message-State: AOJu0YxtNLG+41Q44wo3ida444CiiDBHvim2g0S85VFsMzRLKdV4rpfe
	FpLEXcIIene+W3iiCT3Yl5H781gjKrM/50zrKifzO9g5yOJlnyqhHjhK
X-Gm-Gg: AY/fxX5EC7iIS3fG4NgNXnjalJPry4EqDiYoucjLkYlkzwtGCeHN+sg7hS4qvOAzSaf
	GUBb4u/icO599CtEe3VkC5bYRIMkHHtBto5Na2dP7KPjymK0sLFewa2trtWuNlSXOUQ3Jxa3YTo
	dIqE+8fM4BMsNN5eVAYots6gFleTjSOdoyBN18YgsSTcm+hQky3DsLg3ruZ/9ooytUTDONAQJ/n
	68n7lKnsCCe8dRrqlMAueGRGzT2giq50VC3DkJCrX8KMZJjQlPyY7jgyHdeNnJ9KmcBcY32g5h4
	8KvUcgp8A0zXcW/hdxYZqU25ONdtvSM3ZOXyA0c2xdUb+T3CUq9kdUf5nIIQRwoBN2ACR4YQWD0
	O8xxn4U3PevgzPTyXhvlu+V+WNTuH2AgDYwaP7xiZmT9HE9/hakDKBmT2Uf4ac8EdLO1Je6h1Ik
	n9ibrN3KCLQJgqWd4P6sBsat5KST126ZY=
X-Google-Smtp-Source: AGHT+IHaxVVCLR4qjhWLLVIaeb2l4lwbtf82b2bHpz7SHAJEdx3SMV20RK7Aeg91G12i3wIJ6R9g9Q==
X-Received: by 2002:a05:7300:880d:b0:2a9:9837:233b with SMTP id 5a478bee46e88-2abf8dee7a2mr2305952eec.7.1765331098941;
        Tue, 09 Dec 2025 17:44:58 -0800 (PST)
Received: from deb-101020-bm01.dtc.local ([149.97.161.244])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm80274777c88.6.2025.12.09.17.44.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Dec 2025 17:44:58 -0800 (PST)
From: sw.prabhu6@gmail.com
To: James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org
Cc: bvanassche@acm.org,
	linux-kernel@vger.kernel.org,
	mcgrof@kernel.org,
	kernel@pankajraghav.com,
	dlemoal@kernel.org,
	Swarna Prabhu <sw.prabhu6@gmail.com>,
	Swarna Prabhu <s.prabhu@samsung.com>
Subject: [PATCH 2/2] scsi: scsi_debug: enable sdebug_sector_size > PAGE_SIZE
Date: Wed, 10 Dec 2025 01:41:37 +0000
Message-ID: <20251210014136.2549405-4-sw.prabhu6@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210014136.2549405-1-sw.prabhu6@gmail.com>
References: <20251210014136.2549405-1-sw.prabhu6@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Swarna Prabhu <sw.prabhu6@gmail.com>

Now that block layer can support block size > PAGE_SIZE
and the issue with WRITE_SAME(16) and WRITE_SAME(10) are
fixed for sector sizes > PAGE_SIZE, enable sdebug_sector_size
> PAGE_SIZE in scsi_debug.

Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
---
 drivers/scsi/scsi_debug.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b2ab97be5db3..2348976b3f70 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -8459,13 +8459,7 @@ static int __init scsi_debug_init(void)
 	} else if (sdebug_ndelay > 0)
 		sdebug_jdelay = JDELAY_OVERRIDDEN;
 
-	switch (sdebug_sector_size) {
-	case  512:
-	case 1024:
-	case 2048:
-	case 4096:
-		break;
-	default:
+	if (blk_validate_block_size(sdebug_sector_size)) {
 		pr_err("invalid sector_size %d\n", sdebug_sector_size);
 		return -EINVAL;
 	}
-- 
2.51.0

