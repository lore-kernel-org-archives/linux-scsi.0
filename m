Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 185D41CDA3F;
	Sun,  2 Feb 2025 21:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738531802; cv=none; b=CHcYpJfYQ90caBUeSd7cdGN+0Vt7zVl42TBS0Jl1M8G8lgK6MWcX9dUv+8otKV7yOc6VWOtwNTf1JeLwBj6oDjDW0V0J7HbLbvW+ScDP/ptjxyVLmh7H4A+Z7NvaCL22TXgeku334IRx4ZZhE89jYHsnc8X5CeZ7pEJzr0cInGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738531802; c=relaxed/simple;
	bh=OnhEPuNTUHOr3wKagV+DaXsLjYTQ3SYHBzRUkvqByr0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QyHIMUinKZUJWkUHGE1cT2AIrDalmLzH2hb5z3PB2z4fMN6kY4/Vjl1al9HtQg3WtuqYFqHJ90XoTpnDAw42KYzD2wKt+N1sAmCyu1Ejx1L8Q+gmv5gkLk/qHGYaP7W8JqV9hGWyb5Lr7uFNkfufnHypL6ykKOGMDWbTha/B0OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XeD8zinl; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XeD8zinl"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-7bcf32a6582so345513085a.1;
        Sun, 02 Feb 2025 13:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738531800; x=1739136600; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vDiVDgBwLkYeWea0s1o9QJfccghyQlhQ3e+JC6+Raak=;
        b=XeD8zinlLd5d4cWeHdtIhq1dilt/Rnl9E99y/fqi4AXxQWZWIc8fw0c8GBbACoSb+k
         KNpCcgo1SQxxJ86PWrAT1Zm616soVKKPFTyc8A0weBqTnmxQAJVxMLwLNQS8u7rvE9f5
         CEaxnvIKevauyBPuzd2YjwZm/v/CUYlouFSzMCTFoeABRY1CgRHPpJdilZlFir+z2cSe
         0dZyGZM6irJdtXFmsIDrYIYOEC/B8xPLxcQ7zgrGARbbQvbLkuYUwjmrr2HroArKNwxv
         vKMMTJepD/h5w5N4NAzofUCASd51znLXDSPMYgCT9lzr5yTvpvSweVXiIYwT4n1prk45
         liCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738531800; x=1739136600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vDiVDgBwLkYeWea0s1o9QJfccghyQlhQ3e+JC6+Raak=;
        b=PAslMhDSJHw9NcCyjPzqx2UpD6oa+SumD/T3xl0OH3MTbH+CmM8jozeiDO3l6Hvc1e
         Vkpoy7pdAZFylwAJlx++P9omH8rz3ALcjTCu/MLrZi8zzbbCEMupY57zEPGfatJf9ARE
         vCVaMu2rhqavi1ny/MNGpGRG6C2tvmPAig6K5Vwqcfvk2DNmLjRWEc6aMGiCLZtw0x8H
         /MqZaIE1bu3Y3B9pkwdYYyU3ItCE44SPJIcE4pZFvnqx9RwtRp3Mj05e8VqJjum56GNk
         8LVEcaKcs5349nMnI19nHuOYpUhlugCuA+y/qrQfhcr4/OOpFzQQdZHj206DrMirEk4Z
         HAkg==
X-Forwarded-Encrypted: i=1; AJvYcCVNzJBWSnAXGqlglrfsk1VfAIf2lWiPO5OB1mf19XaJJ0lWhR8sdSUx2EOZOCS9svH/EsU2pT/PImJvLJg=@vger.kernel.org, AJvYcCWfZyQJqIhp+ouP4Ov/SYCcmWxfC24gf5F/yfyuEDRtFeXsj5C+X23znSinI2dSOSzqbz1farrrOuNg5g==@vger.kernel.org
X-Gm-Message-State: AOJu0YxR7Sv45Ysns4Xu8nmgqeWg98ZHNyaDzWf31Hi8frZliMubTdIi
	yRPD4UUHQQUdXJu5QZ9dVl+pCqTyJA33kMIQPdNoHSjMZ8mWLxDj
X-Gm-Gg: ASbGncuSxingYNFIiYydQDv3ylHwDf5vfolRpGdQtQ3/5kCzARWlCLl0xCbOftcZaG9
	GubCZC+N9b4eodQCvKPZ6en8X5elpPEZMZTfjnOOBYTESEdjE5wocMURmOHX5vkQyT3j3Jva4Z2
	FPM1ljaHGAbTqvXhOnEC2QdHPCCWoc/3UC+eODB+QjWAwwaBXVNefRPse+nyjnJkU2EIjXSWiDf
	FeEM357FqedicHqsnC8+/xPbAlXQ5ecjEX0TWhMYRH7PsI7cZagv4Z6qE37ReVaLLNyme4dqCYB
	N59gyArYZK/mjmi3KiXCpZCZA4hB9U7t75S/8A==
X-Google-Smtp-Source: AGHT+IES53oTyDaLF27zA7Qydh0OMq/NVEeMrPUrOIRx19scocehBnGENr23TheIy5KRUWPi7kfzXw==
X-Received: by 2002:a05:620a:838e:b0:7b6:d050:720f with SMTP id af79cd13be357-7bffcce982bmr2865724885a.22.1738531799744;
        Sun, 02 Feb 2025 13:29:59 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7c00a8bc769sm447345085a.23.2025.02.02.13.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Feb 2025 13:29:58 -0800 (PST)
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
Subject: [PATCH] scsi: qedf: Add check for bdt_info
Date: Sun,  2 Feb 2025 21:29:56 +0000
Message-Id: <20250202212956.48385-1-jiashengjiangcool@gmail.com>
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

Add a check for "bdt_info". Otherwise, if one of the allocations
for "cmgr->io_bdt_pool[i]" fails, "bdt_info->bd_tbl" will cause a NULL
pointer dereference.

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 drivers/scsi/qedf/qedf_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/qedf/qedf_io.c b/drivers/scsi/qedf/qedf_io.c
index fcfc3bed02c6..cab16a3e2a30 100644
--- a/drivers/scsi/qedf/qedf_io.c
+++ b/drivers/scsi/qedf/qedf_io.c
@@ -125,7 +125,7 @@ void qedf_cmd_mgr_free(struct qedf_cmd_mgr *cmgr)
 	bd_tbl_sz = QEDF_MAX_BDS_PER_CMD * sizeof(struct scsi_sge);
 	for (i = 0; i < num_ios; i++) {
 		bdt_info = cmgr->io_bdt_pool[i];
-		if (bdt_info->bd_tbl) {
+		if (bdt_info && bdt_info->bd_tbl) {
 			dma_free_coherent(&qedf->pdev->dev, bd_tbl_sz,
 			    bdt_info->bd_tbl, bdt_info->bd_tbl_dma);
 			bdt_info->bd_tbl = NULL;
-- 
2.25.1

