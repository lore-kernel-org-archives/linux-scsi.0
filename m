Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD303B14D0
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783407216; cv=none; b=L1AWcxj1CrJKF0s+VM6znnLoT2m7G4Gyp+Az48AUCIUUNBXnq65iSBzfVlddGcLIm0cl5okzr20WGJm5xZmK7d17E3WRYSL3iiFzABiBWoQS8nqlffToEy3XfXiVa6tjYp/HO0VAAKEMc3Uj55Vi588FcH/rS0kX5Ol2zt6jIlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783407216; c=relaxed/simple;
	bh=j3f8/6Ari+2+xlFJo9OZ6E4fcJIZogJtDZW7dOV+Hww=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=lMesnd76l/SyO0QcjwxSNdwqp34CE9zewRwwiN7zP3PufB5BU11XrJSMLLtfWw2cTU6j6PSKQCtuVyVbBgEPtVfdORPefAtFXvnl3Qb28ZivdRUZzeKmBHdSaV6TqqFRxnmx9jTDMo5/svp8Sju4l3pBwCmtjlHPo4ty1ibuQ+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=ZYX1OkKp; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="ZYX1OkKp"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-847d1e9db22so4180621b3a.2
        for <linux-scsi@vger.kernel.org>; Mon, 06 Jul 2026 23:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1783407209; x=1784012009; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=TqIW25gxmpXz6F7g7W0IsW4kAKFmIx2GtIXiGhqGKtM=;
        b=ZYX1OkKpt1aBMiMm//jv13J0TZmsOQTUztoFk7sMSU2O1OSJTWhME0raOLyTO3DZLF
         hLnWoASEXn0WpWkZbdB/0cG0mn+v42sSdA5aG24ymQnZcv8Cw6/8QGUK9N0JlC2pe7zS
         O+z5LuhQfvBjLudxX/u0HmFfRJXerXj+rj6ZJdRD6dljKcx2HGreflNMfQVjJ+GCRB8B
         TGMnY8wHFKaaocfoeQ5m8rYcUK6QSGGqVa626rH+qSQecm3Sa3XVhfFxkRLuHUR0pNr6
         UKWVmtvIAy2chVBEwZHhZ+UiJEnSuBkopj5xobdF2yM0GDe7xN1NsmyFI5PDFPRBm4m4
         A9Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783407209; x=1784012009;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TqIW25gxmpXz6F7g7W0IsW4kAKFmIx2GtIXiGhqGKtM=;
        b=T+fleJekKO72gLeOVo+ywiw0W4IixPPR1o6U004KIyWlWCUQUOI0l4jk+xwV6eBtow
         YbGwTdfO35UWcXR7BDKsPkKNz3XM837hjlBgiE0s8zLO82mKRqAIUWvvz7qqT9jJB9t2
         cqsbqe6snr/8l3WUHDdv6n9G3H6gzr80ntiOmFodMghDK/wN96jOa2QE1QVdox2jPoDE
         uPth+U+Vy08ssPyL0D+hJlR2hi+UUDuy+k+Z8ITL5adHkeAFjXdem8N303VzhV2Vo+8d
         uE2a2Swv90eqkPgQbg18eNm6F5RgmL2Ol+IB5Y1hsPagnKvaVxaVzhnuEs87KqB/hUio
         qQGg==
X-Forwarded-Encrypted: i=1; AHgh+RpbHsq9pbC840b3xuMUbF08d2ClJc7zl1/lPUq10oLHgcTmesBGF1IubJwbwhzN0XZS8BKRY3oT6/Fi@vger.kernel.org
X-Gm-Message-State: AOJu0YymakZ4GT9exY2tVQg7KfNWR4hJR7y5ZpoBFVQQkqr4yCI9GcbX
	PApBY0d+PWW+IsWc9uqBVLwu+pKbbFPOWllpcLZxpt+wYVcQS1JJDP8Ql4pAGSq/S5o=
X-Gm-Gg: AfdE7cla1KzwrOPhRh6jzzh8eqBZvuvHkog8eytQ0pFfMuVy65g/0rfoF2zscUckytb
	lS6PtzvxBpCYpQVcVpDNsOEbmpEBoOF0efM59pPfxaxvrB5ELgbr1LaeYpwWsd8Y7XqhPm8XveN
	TYvWe1cHkKtlqaAJFmjea/XJQ1N8LPFMy9y9pToM+sqUdMrv67i9S0E/v5nQGmPsq8JzOFiq1UB
	tZcLTiJ7Scx/azaftHK/7wavBSB8IGnowWM8Y7pT1odv9WdoLbX7l/NqwhTrRKGXZhp3B/Oa0q+
	WKQt/44nBRqqeZ6GrirdsMejGWQSj24aqNrrwzilXzaC8iwFmAePIJJ9wtd/TLgeo4I/ebbd8mx
	mu9wl/5m4vX+XGOwt/n/yhw7z+RWH4iVTE58/+1/GApz47x/8vnA+kB4dMasz83BeWG690M7WC+
	27VoAnMzcb890UEa5Q6WDj1IGLXBlGiHfuWi2nysi2w9MH1CuYvQ8GXpdj7B+SjbfLrGfa3BWL0
	uD2BSYIZ88AVrtqg6wKSnJgcEXeyOnMws480gRU/Wk=
X-Received: by 2002:a05:6a00:2d86:b0:847:77f0:72af with SMTP id d2e1a72fcca58-84826d3e339mr3820247b3a.40.1783407209410;
        Mon, 06 Jul 2026 23:53:29 -0700 (PDT)
Received: from Metius.iitm.ac.in ([103.158.43.43])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-ca5af7d595dsm517238a12.6.2026.07.06.23.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2026 23:53:28 -0700 (PDT)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: justin.tee@broadcom.com
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	paul.ely@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] scsi: lpfc: Fix memory leak in lpfc_sli4_driver_resource_setup()
Date: Tue,  7 Jul 2026 12:23:02 +0530
Message-ID: <20260707065304.949135-1-nihaal@cse.iitm.ac.in>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The memory allocated for mboxq using mempool_alloc() is not freed in
some of the early exit error paths. Fix that by moving the
mempool_free() call to an earlier point after last use.

Fixes: d79c9e9d4b3d ("scsi: lpfc: Support dynamic unbounded SGL lists on G7 hardware.")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
 drivers/scsi/lpfc/lpfc_init.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 82af59c913e9..23355f12fbff 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -8189,6 +8189,7 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		mempool_free(mboxq, phba->mbox_mem_pool);
 		goto out_free_bsmbx;
 	}
+	mempool_free(mboxq, phba->mbox_mem_pool);
 
 	/*
 	 * 1 for cmd, 1 for rsp, NVME adds an extra one
@@ -8311,8 +8312,6 @@ lpfc_sli4_driver_resource_setup(struct lpfc_hba *phba)
 		goto out_free_sg_dma_buf;
 	}
 
-	mempool_free(mboxq, phba->mbox_mem_pool);
-
 	/* Verify OAS is supported */
 	lpfc_sli4_oas_verify(phba);
 
-- 
2.43.0

