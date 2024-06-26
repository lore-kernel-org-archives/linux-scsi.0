Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8116D175AA
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719396855; cv=none; b=cxSjXRhlUtrpmwCsHBVq56NKbthBinNRdrVThUg4u1FtRNAFzYEq8HKi7MWdTrfoEX1jpFlMzp11SganpDmQKpcz+I/y+FuCIuClwfLYvHRsC+fiKHP+BKiQDNgJJvHrZq4eEz3lHQNCcMMnIRt6CodMorBKQdmepIk77hB90/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719396855; c=relaxed/simple;
	bh=vuWR+gqfUxVB1UJn/Qmwx44ICD70tLVCZHbUz+EvOD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zt8uqd8gpzI2bCqdVB/zeGopUKX25+hEBjQ8hPUIYNNa1ZQfJL9Ap1sS/MYRKfwtPHoDVZpTDajjRC+cT+3NJvJNkK/M4tXuEVento4OWjDp0MKPHhq6V/fbzwfgkOccTPyiYLumsHZxZ0X62AdUBqFxLXYw1pHgAT5qdp3wGxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rql4rypa; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rql4rypa"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1f4c7b022f8so55823075ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:14:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719396854; x=1720001654; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4reRSWeRn5dqNkHjQDUPngojzn4u/w/NmG9cRmpxkCU=;
        b=Rql4rypaMwur6AnGvbbcopOvUIOgPo4prxiRbS6sVMmhuk0Tkr8Nfie2fTpoHz5bxy
         jA2Jg7Rl0A5ppGY4xVEJ0F+z5Oec4Yhd4UXvMERqvFW3d1WhkiYuxIRaiHYZsXfD4Sgy
         BjbdF8cEFue7t9ztXEOBlF6eJErNCSB/H+5xZZokr84EaSUPr7mA55biuT4TmqxY5/ey
         eOONggkiYgbGobckDW2jQy3jB6ZxaJ+0Fb4U0PpKhyWeiit3AvzmqADZsUCgzuQfzA1o
         vec3/r5zbdIOeRAQQQprfZQlmQeHD8F19viwuz91TLOQmR7wTFTqa+G7cmiYzJyeXyPz
         HvlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719396854; x=1720001654;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4reRSWeRn5dqNkHjQDUPngojzn4u/w/NmG9cRmpxkCU=;
        b=uB1sZe9BQyfFuNsScytsQFMscoXEcrx7dy2Boymx4zpGb3AUnw1nyRuS2bsEF61FfO
         hXDzTpBFFy05AXwhKeeq4bRSelnTMvDeHT7Hy6TAp93drFCgD0Ab4KHE108eaCfHOVog
         zMKSSU/5SQa8qCJ2Ab1swgTJ60bJKzCmn7XMEKvXJIFadY2Ze3rZ70c7p1a1NYxdFo2G
         eDi1WTwPsNHOt2xLvD/aHuJ9rD0Cz5xnNv/I+BDWK/t0jCeJVBDLaaedk/4orxlVhZTg
         G+LSGo3sEj3hFZRhIDGBHCUJl1sRm0NfEURy8wCgeGfL4vlLg8tw/gVOhWATrL74aLlv
         anQA==
X-Gm-Message-State: AOJu0Yxqnmz+CCszG3jrQ7EuaHbEkrSmUWBXUqjV04Ay0Hep7RBNLYkj
	wfOkldLrh8MI9PpAGg6vZRgQEDve4N057WPaczDy36VXBm5wFw/dNxRZgA==
X-Google-Smtp-Source: AGHT+IGjy5Ac6Zyph2yV5AC/fp8sHsW0DM6xwyj1pJ9Td45+3/ACmNJCSEj+jLCGEERZp/NLltRESg==
X-Received: by 2002:a17:902:e810:b0:1f9:b974:cbd6 with SMTP id d9443c01a7336-1fa238e4711mr120284825ad.1.1719396853541;
        Wed, 26 Jun 2024 03:14:13 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa360317ccsm57063865ad.279.2024.06.26.03.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:14:13 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: [PATCH 03/14] scsi: bfa:Simplified logic in bfa_fcs_rport_update and bfa_sgpg_mfree
Date: Wed, 26 Jun 2024 06:13:31 -0400
Message-ID: <20240626101342.1440049-4-prabhakar.pujeri@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
References: <20240626101342.1440049-1-prabhakar.pujeri@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
---
 drivers/scsi/bfa/bfa_fcs_rport.c | 6 ++----
 drivers/scsi/bfa/bfa_svc.c       | 5 +----
 2 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_rport.c b/drivers/scsi/bfa/bfa_fcs_rport.c
index ce52a9c88ae6..41e55030596a 100644
--- a/drivers/scsi/bfa/bfa_fcs_rport.c
+++ b/drivers/scsi/bfa/bfa_fcs_rport.c
@@ -2555,10 +2555,8 @@ bfa_fcs_rport_update(struct bfa_fcs_rport_s *rport, struct fc_logi_s *plogi)
 	 * - MAX receive frame size
 	 */
 	rport->cisc = plogi->csp.cisc;
-	if (be16_to_cpu(plogi->class3.rxsz) < be16_to_cpu(plogi->csp.rxsz))
-		rport->maxfrsize = be16_to_cpu(plogi->class3.rxsz);
-	else
-		rport->maxfrsize = be16_to_cpu(plogi->csp.rxsz);
+	rport->maxfrsize = min(be16_to_cpu(plogi->class3.rxsz),
+			       be16_to_cpu(plogi->csp.rxsz));
 
 	bfa_trc(port->fcs, be16_to_cpu(plogi->csp.bbcred));
 	bfa_trc(port->fcs, port->fabric->bb_credit);
diff --git a/drivers/scsi/bfa/bfa_svc.c b/drivers/scsi/bfa/bfa_svc.c
index 9f33aa303b18..3cbe87fc343b 100644
--- a/drivers/scsi/bfa/bfa_svc.c
+++ b/drivers/scsi/bfa/bfa_svc.c
@@ -5257,10 +5257,7 @@ bfa_sgpg_mfree(struct bfa_s *bfa, struct list_head *sgpg_q, int nsgpg)
 	 */
 	do {
 		wqe = bfa_q_first(&mod->sgpg_wait_q);
-		if (mod->free_sgpgs < wqe->nsgpg)
-			nsgpg = mod->free_sgpgs;
-		else
-			nsgpg = wqe->nsgpg;
+		nsgpg = min(mod->free_sgpgs, wqe->nsgpg);
 		bfa_sgpg_malloc(bfa, &wqe->sgpg_q, nsgpg);
 		wqe->nsgpg -= nsgpg;
 		if (wqe->nsgpg == 0) {
-- 
2.45.1

