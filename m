Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49B36176AAA
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719396873; cv=none; b=Zvj3QLIli87LW1Sm/ODMJlSN8CFK0lO95XojcAMQuok3klIBa+UJR4Y1IMJ+fDsREyJGxoqo3FP8h6CXgfj7q2+eGz8b9pMiMXwwJkK1wpS86jal1UVJnDfmVhZ5rQa/0X7w12qalHn93WNTSN+eO4p+NNGGQEKJCutQxDMokuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719396873; c=relaxed/simple;
	bh=KI6MRILk+I7eGs5ssGt5mtAFHr1fGkJ+Q3wb2xPdyDc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+00oL3RmdfyZk3SAgFeBlh+FvFmm74VjWRLOjPazDSfR93vyRd33o0dtvi6ys3zugujVpjbr4oll1Y+/oTe86SyhRhSXAE52XXUbP5OZwextENoWkIX37mh+PIgtslA6mrcBO4SFOy+VzCLLzI7CkLX3uxMMw7HWbkD8I/+878=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IPsYDqlH; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IPsYDqlH"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fa9f540f45so605675ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719396870; x=1720001670; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6ZfnA1/5c0xPDj+zkBN3P6lqp+PcgAYfDPW8P3d/jrk=;
        b=IPsYDqlH2Uf3/oM7cOmL2nifoufIonD7Rfj8vX3JsWiDj083RLU05aOCJT5BpePyjW
         WT9aEqFP+gLSGiT9smKt1m+Qyf2UQu+qmRY9Y2dTZKliHqiVsq1p0bl5TtP2i422zBTm
         XD+jv0BJ5WJfwWRnYy4g4oUPNwvpcfL/C2b68jgCTYeNFdiqCKZb/sHWR3dUIob7jW5A
         K+/7/ED+Y8RR/KERoyBSyDHJJGbxj0gb6BAYisFgdFsMI6YfHvMLg0CHc4uAzSOJum9Q
         iE/2cEBajNrgF0QWe+XWjjvDE2S1HeCiskhAKSP+n16kf7tmyBE39UJl2hA3PBo4kzOK
         lm4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719396870; x=1720001670;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6ZfnA1/5c0xPDj+zkBN3P6lqp+PcgAYfDPW8P3d/jrk=;
        b=vgIIrC55DFmfKar5Uoh6zexMa0llySiC3PjEZBtc6iB1B1iy5dC9TdLbKRWkXd2qd+
         gOPQ4/Ob+YYTPqRAisHPUVTGVShXszECExPEP4NF0DAbkPiO+CyFk2KYd1y7zxnYHJ0n
         lqv1SPiFmU6L7xVhvbz858Be3ADO/WskumkEuU8sksF9HdcEgIKIXCzG+1At4pPYoolA
         wnCY58EkYqEDyD1c8vgc2Bb3w9FXy4yJbsbqnfGhbkhzSrT/z+qcK7bQx73g51pd91/L
         YooAqdCMeLoNpR+fMoCXU4qtrM0J0PF6R1mYZ1rlmHdZTJ6iV5h4XmciKVIEO2H2ERBi
         Ekog==
X-Gm-Message-State: AOJu0Yzx3TPvIa1NE58clJVwpdpzbvFgbrgarpMYbwAU5/AzdjUyqjl2
	zK1fuT4rTZXUeP9eQglXiWlBFYDZJjtBH6coWOvfk4towSyzO8o2cERPoA==
X-Google-Smtp-Source: AGHT+IGycASPIds8KV1SpcIMO6C6WXe0GA7/L1BM71+17h14MNsMkAnPJABL8uYKFPJO2Oa/mV92IA==
X-Received: by 2002:a17:902:ec83:b0:1f9:8e2b:cf33 with SMTP id d9443c01a7336-1fa158df190mr124934085ad.26.1719396870460;
        Wed, 26 Jun 2024 03:14:30 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa360317ccsm57063865ad.279.2024.06.26.03.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:14:30 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: [PATCH 10/14] scsi: qla2xxx: Used max() for queue count in qla25xx_copy_mq
Date: Wed, 26 Jun 2024 06:13:38 -0400
Message-ID: <20240626101342.1440049-11-prabhakar.pujeri@gmail.com>
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
 drivers/scsi/qla2xxx/qla_dbg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
index 691ef827a5ab..5e3afd7ffa76 100644
--- a/drivers/scsi/qla2xxx/qla_dbg.c
+++ b/drivers/scsi/qla2xxx/qla_dbg.c
@@ -685,8 +685,7 @@ qla25xx_copy_mq(struct qla_hw_data *ha, void *ptr, __be32 **last_chain)
 	mq->type = htonl(DUMP_CHAIN_MQ);
 	mq->chain_size = htonl(sizeof(struct qla2xxx_mq_chain));
 
-	que_cnt = ha->max_req_queues > ha->max_rsp_queues ?
-		ha->max_req_queues : ha->max_rsp_queues;
+	que_cnt = max(ha->max_req_queues, ha->max_rsp_queues);
 	mq->count = htonl(que_cnt);
 	for (cnt = 0; cnt < que_cnt; cnt++) {
 		reg = ISP_QUE_REG(ha, cnt);
-- 
2.45.1

