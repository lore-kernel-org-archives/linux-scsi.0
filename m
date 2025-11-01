Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CF925C822
	for <linux-scsi@vger.kernel.org>; Sat,  1 Nov 2025 07:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761983948; cv=none; b=ZfeTHIT76yf/SJx68croXKu81QzvAtSPpFuEZJuRiFHkYFHev0pKhjlVbPitsSIUM5qCJ8JQs0gGiXnFs+eB6alxRx6LtGwgqPjg0ML/qSfJQLBqjK/+l3OO9y8fNTe4r1haXzqKEhHqfHKBLGUkcaC5xOi2+UDDiUtlyK+P1oE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761983948; c=relaxed/simple;
	bh=oAjAkDjUtAQk6n81S60YXrOlbuP7F5bm3hxxpXuUVUk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KJymVHQ6msUXUCfVbWO0OSGApDvLtwsZo168U/rFl2xgaSas/kNCQI1PL+nlhscfOnZSSoXN5YwoK7e8aznlUSHYqQcenOYBx3g1rVJJH12Ug2Oz6ZACirWTJ1o51WutPsAV8Obo/5DqdiQWjUbNdeccAkd51hvNFommHB4Geyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lErLu6LF; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lErLu6LF"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b6cf3174ca4so2332845a12.2
        for <linux-scsi@vger.kernel.org>; Sat, 01 Nov 2025 00:59:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761983946; x=1762588746; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=oLshY2j1NyL4UvQi5KisxTMa4rbmEZHWDo+dRWBxLQA=;
        b=lErLu6LF1uleLduICAzCF6aVNhvOBkKopBkkvssSWwScEE+T70m7TaVwiPdhrCeO9u
         BfIr0ppzjsMu0n7a8ad6DR/Rl13JZ+MneRisLBlnmbY5nhp/MNUZiSL35qyBcCnZQRMP
         sy9R8klJ5Lw0v8OMhWwaAASvEIXFf/gSuv47QzwKLA9OBIcP9AlfD3HEtBTWDfA02J2k
         MNDLOvrVg432XjgER/OIWp1746Fwe52QNI7NT2isgmG6yIrcjSClSDntLy0pqGqgaOeq
         VXwUPQ9QWK4HuWFRaFJdSl3OP7NlrJ2ybt7WWFo7mZFn7A2bvu1gMmcfrl21EruUb14t
         jZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761983946; x=1762588746;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oLshY2j1NyL4UvQi5KisxTMa4rbmEZHWDo+dRWBxLQA=;
        b=Pqk1o8EVIz0fv/zAmmVX1ObQhnzmJgVOIDyvLa9ifCBIjYscwb7OpTJ7isomapJLym
         8PIqPA/6y4xAOCtkSz7V0ydKUz4Dz1vYp9vbvcvl7wRpMnU2esQrdAVPhfKMUP0T7W8V
         Vfho4IT2eGAonMM/7xdwlfOKFlRfz8AvQfMJ6KUk4XeLOgTvAO3vkviHm83vLTYxtZy1
         9djKo54j6Kg6v0lKcPr/0Ymlu0gXa+arj8jtft1pVAFbEnrnCO5w2DqQcLAZPD2i2gmJ
         NZ8CT6VCSnklIdywlHMVgMzrmHJHJ80H3UGcSLyJM4OIt1Z7XQWiPCkFH82jwRvOBW9D
         BECA==
X-Gm-Message-State: AOJu0YxudmyCzTUsasSO7De4LvW1UusPsVuWjlU4c57Ls9G8BFfQ+RbB
	K04e88m8GEpGn8h+ZGKQ/LbuBPVodkVPRFRHWsRygwjoILttCisqyDxGpMcbsw==
X-Gm-Gg: ASbGncv0CC7fpnod+rYf1zWL8JJjtlTFCFtINIT8nfn3hqC7y4xKLrl2VI/My1/J3E3
	Bh7MuqGC0IOUUN6sbP4x4WYxiApiagUYAC8eOH+FhuzcAbB32b/5dnuICtsawXJ9KBBXtSpbuAZ
	DXdNPme1JgS57KgGIC31Jnlov9riPXcx9n82p6mbP3oyhQQy8coD+XFFleWDR3fBLJ0vTQ+N0Wp
	Pb1w1tHc3un62o6X5zIEYk9lViITvXRT9IuDy12uvKLvwu/PdYaCFKWGz3w/nd+fx6iH3A5Xrpk
	6G6m1t0mFh8KAfFjcatdoxCKNSB2Ozz6/2n6v7k4FzS2KzWXo2B54/Fe5Tdo9Rj3bx8aqyWngZJ
	GrQlbhaC3cPDHxq1UdFVNmOPsaWgPmlUUCMWyN3osTemJGdfLW5SMtjSb2bc/mI2m0y6tEQ6BZZ
	/krjAu
X-Google-Smtp-Source: AGHT+IFD2ayk5K/PRVMoe6BdN2rJdgu00rys3mSqYEg4ny79CaKXwD86jeg96qiWzlaNLe46gBymUw==
X-Received: by 2002:a17:902:e842:b0:295:5a06:308d with SMTP id d9443c01a7336-2955a063493mr8330695ad.14.1761983945728;
        Sat, 01 Nov 2025 00:59:05 -0700 (PDT)
Received: from fedora ([38.183.9.34])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-295268cde10sm48247135ad.47.2025.11.01.00.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Nov 2025 00:59:05 -0700 (PDT)
From: Shi Hao <i.shihao.999@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Shi Hao <i.shihao.999@gmail.com>
Subject: [PATCH] target: substitute kmap() with kmap_local_page()
Date: Sat,  1 Nov 2025 13:28:41 +0530
Message-ID: <20251101075841.100763-1-i.shihao.999@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There was a single use of kmap() which could be replaced with
kmap_local_page() for better CPU contention and cache locality.
kmap_local_page() ensures non-sleeping operation and provides
better multi-core CPU scalability compared to kmap().
Convert kmap() to kmap_local_page() following modern kernel
coding practices.

Signed-off-by: Shi Hao <i.shihao.999@gmail.com>
---
 drivers/target/target_core_rd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 6f67cc09c2b5..d6768ea27f94 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -159,9 +159,9 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 			sg_assign_page(&sg[j], pg);
 			sg[j].length = PAGE_SIZE;

-			p = kmap(pg);
+			p = kmap_local_page(pg);
 			memset(p, init_payload, PAGE_SIZE);
-			kunmap(pg);
+			kunmap_local(p);
 		}

 		page_offset += sg_per_table;
--
2.51.0

