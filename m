Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A0931CDA3F;
	Sun,  2 Feb 2025 21:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738531297; cv=none; b=aMcEmNi3O0Qi5g/catfMJORFGtn3YyRvWgPMiFUWkMx9wnkyRsU0RzyMrzi6bhVUnsHmoOQsRGexHUIFza7YLsOetq0N54+RCoGGXw4efA+53TNntNmAv9G2SYeaMEwtGKkutaixsPoh6jLWBj/PHU44w8/UwFKH4Fn7F/Hr5ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738531297; c=relaxed/simple;
	bh=R7ncgOmphOFsW4I3xwdv7haFc+NVQ+pYShvyDRzNgVg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VYxJD8cRETP9/iQOxhyksP7jAiamygkAl4BLUZ1GTQSNcEs6SAWNfC778Qn7KLw7iUW8wk1GYBjRGkE+oH6dfpHcAlar9kVA92ppfE1teoChJnptXc8wRYYzMkKOZqcenRuCAGbSv9rK3jypxf0nwYGam6cgADTFkPACfA3efcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MsMNCoYH; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MsMNCoYH"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7b6e4d38185so355316985a.0;
        Sun, 02 Feb 2025 13:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738531295; x=1739136095; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkUMQKaY0kLwFtHQlNd6rdcDuErtLiDSRWPedu76oGo=;
        b=MsMNCoYH5oadK+IGQW+KzBxr3GBvDF4D5ycAIWzB+xuroh6CA1pBXTzy1FccFO/ABN
         HmA359FEEBhfv/k7h2/8mm/9m7uJCBeEysdF5YxaApykThAKQwNton0i9vsCb2Hg408V
         17YVre+OOs2aR6+OIMbUQ0FVeWstwjVy/D5lJMQnH6uhCqzjHfWGUJQdbEp/gUHyCVmO
         /YgUUm6cxO+aFwfa+J5QAHUGyDosMrZJ8Bg4+MXsiseh3P+zwrMFCIiUmWZcChpVfmDt
         VK24+MZQTtwUmYyAi/XxhzAAV2dxCPcPkD1LVx/TaGYB5v7MEQu0v0GUSenOU3V+5x0y
         FYdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738531295; x=1739136095;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lkUMQKaY0kLwFtHQlNd6rdcDuErtLiDSRWPedu76oGo=;
        b=vgtyQof896kDzWj6CvCMkIL9eWkM9zAmx+7sFRljRjYxvQyxy88IONFIoVx2AXVipg
         DlznyTDCDxSNEE7ZZyEJACC4a+ReW+rpf8gjGDIV7JeDUtR9rz+kV7SJPnBTo876QDv4
         NnkcsBiTlGMjpJT7EL+1mCdd7cy8tjF++YiaL7xDd25WZFMmgW25hYD/gJc1h38oMX02
         pyWEyGtDXdKfaP/Oxm0DYoadC4TVsHn6DFb7kJgVrpfE4lHYZzi2EDn2AatAzR86kIdg
         PlcJA+3zMuOy9vWlqLvTD++zW9HuRV3lPvXfwXuHMYLWln3R65heBV9IehkQTzdpRd8o
         XCBw==
X-Forwarded-Encrypted: i=1; AJvYcCWXPkU+g6BSxSmnKaUACjnMV5DAJj85prxbHZfwA1ROVE681hZDumzkD9Oo2qxs0lTzDg3foalWzmDTIQ==@vger.kernel.org, AJvYcCXrby59bwnN9oEdb6Dv1nXE1GEL27X1mm1Kg77ikg9dqLUo+mzEHwEAcXTSnqhoXAxJ/dYw+8EO30i3q9M=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy39Y81rZ39Wg3rW1QUD4M9Z+kaXYviXfhscg5p3reIOjqW9fI1
	0S5DfXg7kaT87vu7J5eFgQ5m/ck7EiaGcyayw4BGr9QqqSFKw++a
X-Gm-Gg: ASbGncslS6z6Apa5lMOSlV3Oxa3oJfIXpK590Nt+RlkKUTQ7GOIFsWvF5ASp+pbyHlm
	i9teYLR7xbIcJiQ2EoCkTgBkoOJDNUMJ2R/+w1+fRLdpfr1FF2EUirhcXlkAKoMm14j3EtEos6P
	5gkTF6BeAzEnfIxyT0RBDdLwkDqhkkpBbETsvKOQZOv3p3Vy8Sq0ai+/D+zs5ePml3HNtGcnKxg
	GoGfucuo9c+jI6VqqclHzB63qeJU3GZw/t0Y7+7Jg51j2DUAlxzEs4XAe05/1rJ+3YEJVo0G6UL
	cFiyPqFNNyOcaBOGxuKSLR9y7kGhrIGxaZLOWA==
X-Google-Smtp-Source: AGHT+IFrb0ED+EUSGjCXynhcdwYSMuU1TKveNa8hteJYJUIVISGE8Ee7Q/BN2ZYl28vTin2XQixrRw==
X-Received: by 2002:a05:6214:3112:b0:6da:dc79:a3cd with SMTP id 6a1803df08f44-6e243a7f135mr268389456d6.0.1738531295223;
        Sun, 02 Feb 2025 13:21:35 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e254922517sm42192396d6.76.2025.02.02.13.21.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2025 13:21:34 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: markus.elfring@web.de
Cc: GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	arun.easi@cavium.com,
	bvanassche@acm.org,
	jhasan@marvell.com,
	jiashengjiangcool@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	manish.rangankar@cavium.com,
	martin.petersen@oracle.com,
	nilesh.javali@cavium.com,
	skashyap@marvell.com
Subject: [PATCH] Replace kmalloc_array() with kcalloc()
Date: Sun,  2 Feb 2025 21:21:31 +0000
Message-Id: <20250202212131.43578-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <d5d13945-da84-4886-bdc7-9a3ac182b2be@web.de>
References: <d5d13945-da84-4886-bdc7-9a3ac182b2be@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Replace kmalloc_array() with kcalloc() to avoid old (dirty) data being
used/freed.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 drivers/scsi/qedf/qedf_io.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index fcfc3bed02c6..d52057b97a4f 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -254,9 +254,7 @@ struct qedf_cmd_mgr *qedf_cmd_mgr_alloc(struct qedf_ctx *qedf)
 	}
 
 	/* Allocate pool of io_bdts - one for each qedf_ioreq */
-	cmgr->io_bdt_pool = kmalloc_array(num_ios, sizeof(struct io_bdt *),
-	    GFP_KERNEL);
-
+	cmgr->io_bdt_pool = kcalloc(num_ios, sizeof(*cmgr->io_bdt_pool), GFP_KERNEL);
 	if (!cmgr->io_bdt_pool) {
 		QEDF_WARN(&(qedf->dbg_ctx), "Failed to alloc io_bdt_pool.\n");
 		goto mem_err;
-- 
2.25.1

