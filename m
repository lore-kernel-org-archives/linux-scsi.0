Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE78E28373;
	Fri, 31 Jan 2025 19:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738351364; cv=none; b=MicLJGauNDX/Kqni6blmJDukYkOj1Jh2CvCLTTjXn50yhqdWaxoGtSXh4FavI0lqNSv5kuvWgZSiFrjVnSZdvQBR6ndaWIBLspJ9WLUfbgQvblLEmp7hPG5OOB/Rqp9UPfFWwvstu5ctIhVmEejq3+zt84IQslYzmL2cyS5NNYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738351364; c=relaxed/simple;
	bh=yghr0hTYW6x5ZpWlpynxFmbYPgzAy1sXAnrK7wA649E=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=AszVP4fZbQvCIK5d+ewuQaak8njwhqk67ECj99k15kZATRTI7RvzQXDeczN1+gqaysJ29uMYAudV7fIegZGiZZ8Ur1XszZgoclEtx84iBzTAoXNmRDOvtuzrr/Oj5pfw7vQka2qESU3eiAkU0P053YbStghumaIoEdG7sKhu/gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HTXQCve+; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HTXQCve+"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-6dcdd9a3e54so21618366d6.3;
        Fri, 31 Jan 2025 11:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738351362; x=1738956162; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TYEmwtHGBMGFTeXpG7wtUM+i1eLWWF68Mg6OG5symNU=;
        b=HTXQCve+T0Rcw7RGa7QNqeQfcDFwepZVVDtx4ovnBa2dIMEFQrWh7wNrplTfjsvxoG
         nQYfZqTyR24KLVz+2DY//GtfvEWeQeS4rGvRAH6gwUJ7fE5/6jh3m7Lg+Du/abDq9yh8
         kdu7nc4ffiSAVR5VAquYFKy6O41L6KsQn9AVh0GaCAIxuBw+Kq+LfDiNVlt0nh1G0hVW
         E8BjPqFrRWqrTOUDJWYZu5TVmkQMU1euVCf9xrjR/q6doaD7BQDrC8qBRLL5vrsb9F1y
         GKxJa+plu/MSM5cERf6IAtIZGOfsgDLF5CzowBia+24b7MjagAPsnzuDAn0d7bdeNXhp
         pxsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738351362; x=1738956162;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TYEmwtHGBMGFTeXpG7wtUM+i1eLWWF68Mg6OG5symNU=;
        b=hXDJe3Wlddpe/FOk6mqBHwH9a/RCHwgeu7HekwGE7q0BU64lzVBoiuGid+yyIv/xqP
         ZiFfjlggMtX9hJQhUV3Op6v9IfDnhE32X7AFlzNKcAlB+cXVLtf56pMZDIO/hKGJZmdp
         gTHWIguh45QITFs8vFhXsO4oOHxXAq7g79GLeEwAkhSgCBClz3dAis7na7lpZWlHBdta
         TmdJXI2uqcZOxH6gTTmi6FIiM8QDL1JkpubCCSBOokUfDp68ugIxfrS7sad0ovKvZwxq
         /qAbPaTwl+zingjqBEfpvaq24CErzQdRKU74mXzdMCXvNZRuSM+/QgY0R7/YeTUsqtuf
         Onzw==
X-Forwarded-Encrypted: i=1; AJvYcCX6WnUizrHhWH+pkmbmchk+W5PV5dUsiWtl/CohYD/EVaV4Sx5y8L86EBNI8SMvgA/FfSveAGdojqBhYnA=@vger.kernel.org
X-Gm-Message-State: AOJu0YwlG5mYzbpA3DzV/6yN9vynOp2K++MaxPBbssYXS6dz6cf77pYq
	oS1LVQJo3qbbM/zWySdc82OpqfNiSjYZDXl+5OKFqa/UAp8YsoAz
X-Gm-Gg: ASbGncvAlUeb/blWa9BtFjyKOWvF1nu42ccWflzDQfYxwAPUuqDdQvSgZKLUxJYI6cq
	e+o5/e2uF6GFEJfw8xbmd6OBAiXRYv1UvY0j41+zCMaj/g8LyeKeMUX3tD5X2CusTCNi38N2CTx
	xY+aBg6iAW067iyaj6ze/oIj7Jom0c4JRE7itTL2jcqciGxOoDPj8o2ZpJMpbPmw1NQMMC6aaoB
	Qhqww+jcTWVVlvqypxnIuGiel7z8dGj42pNc9v9/PoGJUYuNBhgg+yKOQXoK7dbwOzKlUYcwDvk
	uCg6su24/tnMwThBOUfAfXkoaDYzmSlW4NjtAA==
X-Google-Smtp-Source: AGHT+IG+ijm9sa/JTLlFQQRggkYEDrym/Q5qnngX5KgsPMKZJIdZAYo91ml+DrcmVEN2Qub0+LlMsw==
X-Received: by 2002:a0c:edca:0:b0:6e2:4e1a:bc82 with SMTP id 6a1803df08f44-6e263751a18mr15968036d6.35.1738351361606;
        Fri, 31 Jan 2025 11:22:41 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6e254940f05sm20905606d6.113.2025.01.31.11.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2025 11:22:41 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: skashyap@marvell.com,
	jhasan@marvell.com,
	GR-QLogic-Storage-Upstream@marvell.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	James.Bottomley@suse.de,
	michaelc@cs.wisc.edu,
	bprakash@broadcom.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] scsi: bnx2fc: Add check for bdt_info to avoid NULL pointer dereference
Date: Fri, 31 Jan 2025 19:22:39 +0000
Message-Id: <20250131192239.34763-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a check for "bdt_info". Otherwise, if one of the allocations for
cmgr->io_bdt_pool[i] fails, "bdt_info->bd_tbl" will cause a NULL pointer
dereference.

Fixes: 853e2bd2103a ("[SCSI] bnx2fc: Broadcom FCoE offload driver")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 drivers/scsi/bnx2fc/bnx2fc_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c b/drivers/scsi/bnx2fc/bnx2fc_io.c
index 33057908f147..4ca8cc51e8d1 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_io.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
@@ -352,7 +352,7 @@ void bnx2fc_cmd_mgr_free(struct bnx2fc_cmd_mgr *cmgr)
 	bd_tbl_sz = BNX2FC_MAX_BDS_PER_CMD * sizeof(struct fcoe_bd_ctx);
 	for (i = 0; i < num_ios; i++) {
 		bdt_info = cmgr->io_bdt_pool[i];
-		if (bdt_info->bd_tbl) {
+		if (bdt_info && bdt_info->bd_tbl) {
 			dma_free_coherent(&hba->pcidev->dev, bd_tbl_sz,
 					    bdt_info->bd_tbl,
 					    bdt_info->bd_tbl_dma);
-- 
2.25.1

