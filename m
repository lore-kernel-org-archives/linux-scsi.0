Received: from mail-pz2-f41.google.com (mail-pz2-f41.google.com [74.125.228.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21DA73644CA
	for <linux-scsi@vger.kernel.org>; Thu, 24 Sep 2026 03:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790220947; cv=none; b=HIRALDoVLFjvteTTr5vWgzSlnbloKbnpaWPBwKkTv0DGj9w5fKDLYeGZQI6yMQxYqtaadtaGL3AVFxm0yN2EDwr4RiMweccShBnKGQ0KKYoZhDyi6+rsrcWs8dL6sIegJaiFoitmW24uZBHI/boawSa4b5X2UHoWZqvb/xGOgYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790220947; c=relaxed/simple;
	bh=0rO3I71WsF0uae2GRkwp2XOH2p2Jl4LMIdriMvNKDi0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a+pjVq8VhDB9Pl6Ocz6OuUgEtIJVAYIaz9TBdfwUgJ7m+I7X0ekekcSUog7sXbv5UW/2PWTy7TSKBNM9iykpVAyDsSBzfWEOIjcL+cDUPk+y+PA5G5tll0VwblUZfeq+donIwkCH2+MAfCXRuVgZQy3C75w3nRNxvdX1AV/3xVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Oct5bDkx; arc=none smtp.client-ip=74.125.228.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Oct5bDkx"
Received: by mail-pz2-f41.google.com with SMTP id d2e1a72fcca58-85469d20963so853807b3a.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Sep 2026 20:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790220945; x=1790825745; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=owK5jalgwfNIvAdwQi0rH6NjZ/WlFoACS1nWo5z1Tro=;
        b=Oct5bDkxD3wjF1l8gXzJ8tG+UkXk+B0xrSOHyq2crD8WVc4q4Rxpl1ZTI4fT72Q9qv
         2TDspzOiN6aPjjRyT1LPiOLzwNea86BdlBR07mnagVBwYFKZGm6U7C8IiJ7Sn9sMjlrA
         G3JkEGPfT87P9vSk0ayHa9ZU2BDIv2C2p0nJMa8DZAB/LbH4p9v6FN9mkhH6692xv3ow
         BSESCy153pGO0xzBgerwGufsKK4AWRNleB6izH3nDZm9DyQQosWc4F/mcB8cxSD0BNSb
         Pt9fenKM7W712OjZjngJAaUDA8eGtvhgwz6S+26YBKNH4suBWL8GsEzU3Sm7J5fQLTel
         rFug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790220945; x=1790825745;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=owK5jalgwfNIvAdwQi0rH6NjZ/WlFoACS1nWo5z1Tro=;
        b=1aaHDni8NhXmqeGfB/iESLuxwe5kdXD4s8/cv8LeF9w7fWgO3MHmbbK+gicMbNB5Ki
         y4q6Dy94eoY9rvIcekLIY4jQsA/0Gs36TntPPpre8SRdR1SFUJEV9MnEmoQEJUtoLBv0
         R/qWqtgzJGD5g5XgF4P9GCPW0Qwq5mDL31HXDVTtWuXcPBaEND8avnKdGLSEQBEAfMFw
         vgbsZpnVqsHeMt9yUHC30mKH2wpv0r8F4y1Y5SaX8cnImMmRBcISP/6FRfowvf4udXrE
         niKEvBMxDDPn8toRk9fhF13+Km3sy8JKyWo2c2QR0lHsc77dnhFk5Cv4JXwF05Q8wTwi
         3z+Q==
X-Gm-Message-State: AFuF++lwb2ww6B8QGVGBbUnb1pE8GQYmvXNEQsO0yELULzw79nO0Plfs
	f8jNvl3298eEXAcnpWiRBb3311W5mXEFfZLKh1asD+nwQXznzxyKXdJ0
X-Gm-Gg: AYBFou237ePGJEWtjpH+3Wz7M2PcKQ2vlTVqBa4nzgC8PtWXzJ42R/C9TPWUoV/dInA
	RfO2uB+dQ/C9SP7nS/K9fLMtCq+2P5FlmnLHfjhsOGjYsz0cm6cyWfj7dTxmd29iOhq60NJH/Ne
	TX4DUlK9kwkaf07ozK95MlWcTlAlKn3CZ7a/FZZBKplWpa5rwjjEVdKd+O6HOHfC6ZgDnLqQ9hj
	Bbyrjql5JGt9Y2ym1wgtFMFKLDLkv+bCtEjheWn8KvyMu9af9wzwAJ5EkBpfXUKqjcuRu/qXRQY
	m6P3bSpm49Nh5wki6jfokDVOJx+qBTc1fV38UY1NfXMJJS2FHV/Bz9gKIYWIPPUO6VsBi1sPLlU
	I6+Etl5jiWBBUkOYF+TW2p+JzHzitb/uXnmp2Eya758BqGBS/9Vnqdy3/0JL0nLn0EjO+rSpO0V
	lmSLPs9LjbHxIbDQSXGs0oruoA7K9biJF/g58+IKtZF2Zj7o0sIvXZO7zcD/hhNHHRo/tI3I8X6
	KDNaCxy4CNCz6BxVB5WaAjZD7IJjIjip+VjTJzDLaEO7MQuRzWBG/1L0ZFs2Cg/tFmeQTIaOJkL
	aM2vdM53o4+7cyMP5ZHOKYs07Ka8LL9mBLOJJhaPV2Lni6BQKe/4lcNWH5ynwFxbB1zQDA==
X-Received: by 2002:a05:6a21:138f:b0:3dd:85aa:4528 with SMTP id adf61e73a8af0-3de0e8d09e4mr1070065637.35.1790220945420;
        Wed, 23 Sep 2026 20:35:45 -0700 (PDT)
Received: from spider.bream-herring.ts.net ([103.6.151.236])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc75f3d5ce8sm1822330a12.17.2026.09.23.20.35.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 20:35:44 -0700 (PDT)
From: Matthias Goergens <matthias.goergens@gmail.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org
Subject: [PATCH] MAINTAINERS: name the jejb/scsi and mkp/scsi for-next branches
Date: Thu, 24 Sep 2026 11:35:41 +0800
Message-ID: <20260924033541.3624532-1-matthias.goergens@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The T: entries for SCSI SUBSYSTEM and SCSI TARGET SUBSYSTEM name
jejb/scsi and mkp/scsi without a branch.  Their HEADs are commits
mainline already contains: jejb/scsi's (master, eea5b5510fc5) from
2012-06-05 and mkp/scsi's (master, ca4ba96e02e9) from 2015-11-13.
linux-next pulls for-next from each repository (Next/Trees,
next-20260923), and on 2026-09-24 that branch carried work not yet in
mainline.  Name the branch so the entries identify where development
happens.

Documentation/process/submitting-patches.rst sends contributors to the
T: entry to find the tree to prepare patches against, so a branch-less
entry whose HEAD is already in mainline points them at the wrong tree.

Signed-off-by: Matthias Goergens <matthias.goergens@gmail.com>
---
 MAINTAINERS | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index cc3cae2e378b..18617f58a281 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -24569,8 +24569,8 @@ M:	"Martin K. Petersen" <mkp@kernel.org>
 L:	linux-scsi@vger.kernel.org
 S:	Maintained
 Q:	https://patchwork.kernel.org/project/linux-scsi/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
 F:	Documentation/devicetree/bindings/scsi/
 F:	drivers/scsi/
 F:	drivers/ufs/
@@ -24600,7 +24600,7 @@ L:	linux-scsi@vger.kernel.org
 L:	target-devel@vger.kernel.org
 S:	Supported
 Q:	https://patchwork.kernel.org/project/target-devel/list/
-T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
+T:	git git://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
 F:	Documentation/target/
 F:	drivers/target/
 F:	include/target/

base-commit: 40288c9206c17eb66a603262e06a58d300d0f279
-- 
2.55.0

