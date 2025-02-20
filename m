Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D79A29
	for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2025 14:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740061795; cv=none; b=aIFNAcCnmLjhCCyUelUdMAl0IXF5F6T5o3E+9jlmg0MZh9mEe1+0QdbLqTyJZEGcq+BKMzOxXAIKqSiMaTPnJvPRr9vICBVIadgk6TCPGEbKpqcQ8Y1Z0MaKg0MmLSxizM9rZ9fewKBVmYUYgAKWA7NPH1NXzosIgYXQ1RrrtmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740061795; c=relaxed/simple;
	bh=1A5R1aMk41EaCSgCLA8rzYdvzh3BgrAY7acSm2SfkN0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=WnHhXeHp7uUDtHeNobFK2tEG4f1sO35o8WUjNJxqjTbq2Rn9fiPPMpsQxkgOpOxiYj9xshFU5i0pXCgvc0kHP23Lf5pst2vNo2KEokZa6M0wyiIuRxYDbeiVSFt2zniL174gYQfkGMSMPGKwtMps5f6zQ0igZyUkomFj2ef3Dr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=Fezle1VD; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Fezle1VD"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21c2f1b610dso27306115ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 20 Feb 2025 06:29:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1740061792; x=1740666592; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aZnvrUAeIC6pvwOcvjEjw8XDOmV/HM2d1HiarMf+EV4=;
        b=Fezle1VDqGEgovqA6EXSamTnn+5Tv3G7CR+mPK78y9OCOJNiLX4wKe9X9Wu2QKk4zO
         hOzkK4BymDm7lknspKHAyWT+E/fmVeWs64cnxTiUOHhfUA/n4hlCymXp6dSSe8YZhkMp
         VBmmluBEGjuep0tNg9G0TNGglZVEzvcHJXzlU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740061792; x=1740666592;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aZnvrUAeIC6pvwOcvjEjw8XDOmV/HM2d1HiarMf+EV4=;
        b=gV55sbcxCyyERoa2PnZ6efbnireRYQpl8oBVq1gm5tZkVBSVu1QFKKra0c/df3qy3p
         /wX3MJ7h8LUXmq5wLL1O55Dik2Ij4mquvAUyAga0PrTAgYnDwcjS2eblEmhyJrpRLbSe
         YXMgODYvN0M96Hj92E8uCVy3PJoA4qoTK45vRTQJktOUSUscQno/K4stah3AEhu/4+hG
         J0bHNPo/4UQgNFC6lb7Mgeit7ZP9seq0pMR6p2mR/0+1eGEGRJs7im2mUzDeDbF51JmS
         IzjeSH1J1PQrIwqqaO3ttjVvfBWLVsuNdlZ/i4OQn8KKAK16+pof9NExwZuqYMAMqYwX
         FDwg==
X-Gm-Message-State: AOJu0Yz1KousiQ8MVbxucvfpobr8DPUAIC5ghHWIYOWTBI3mtSNFbr86
	O1JJqk2GKShmXGv17klnoJzC+jOrmv3CBhtvbJZrWuRBQ9okn/DKAKCMoaOj6o8gkxheHhssOhR
	qtM+QAor1UML1n5pMJjAf3Cu7Tj1NrQFQHoinh5v48KIHNoN5WsjfjiH+78Vs4uLcQXqYaNyVMM
	p97+N4GXDIqWyjjEyU+VGCnkD2dZJZhE/EP3evQEMuSM9JSA==
X-Gm-Gg: ASbGncs6sMru0n7MpAzvzwiytk9frSjjXUukewvgw8PbxGOQMpkwl41RHlZJa4ZZEJh
	c4G+QrYlmAJJfIYz9AN0+yzx9LLixq+34fHz8GMeBZYf1tkfsO/Hil5lApMi1FJA+M+qnmj2ari
	u7I8dYq3i0NGZLGWSxIX3DgHLbn3xuRp84NL0dYMNwqbnj/PUlQVC1Fok9F8g94/UAHKThR9c/s
	7qnMAH+J2y1IUfsXDwVL7joO6CJzX6g00hHG5OyUH1juXpQDzfI29rQBfBn23aOlYQsKSd6SsRU
	8rJiV5ydaaoxug9+ajsQZFNLDR6Elqrfd/0s9oTNFik3g7uahRvvvyy7uWw=
X-Google-Smtp-Source: AGHT+IGL1x2IDjAVm1O+XvoRzhVoVrJLKr4mDKPIaP98wSKYUmWh7tnns3LPO72vwPY8wujPt1M9Uw==
X-Received: by 2002:a17:902:f543:b0:21f:542e:dd0a with SMTP id d9443c01a7336-221040a99d9mr338219485ad.41.1740061792148;
        Thu, 20 Feb 2025 06:29:52 -0800 (PST)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-220d47ba84fsm122551805ad.0.2025.02.20.06.29.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2025 06:29:51 -0800 (PST)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: rajsekhar.chundru@broadcom.com,
	sathya.prakash@broadcom.com,
	sumit.saxena@broadcom.com,
	chandrakanth.patil@broadcom.com,
	prayas.patel@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1 0/4] mpi3mr: Few Enhancements and minor fixes
Date: Thu, 20 Feb 2025 19:55:24 +0530
Message-Id: <20250220142528.20837-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Few Enhancements and minor fixes of mpi3mr driver.

Ranjan Kumar (4):
  mpi3mr: Update MPI Headers to revision 35
  mpi3mr: Update timestamp only for supervisor IOCs
  mpi3mr: Check admin reply queue from Watchdog
  mpi3mr: Update driver version to 8.13.0.5.50

 drivers/scsi/mpi3mr/mpi/mpi30_cnfg.h      |  4 ++++
 drivers/scsi/mpi3mr/mpi/mpi30_image.h     |  8 ++++++++
 drivers/scsi/mpi3mr/mpi/mpi30_init.h      | 11 ++++++++++-
 drivers/scsi/mpi3mr/mpi/mpi30_ioc.h       | 21 +++++++++++++++++++++
 drivers/scsi/mpi3mr/mpi/mpi30_transport.h | 20 +++++++++++++++++++-
 drivers/scsi/mpi3mr/mpi3mr.h              |  7 +++++--
 drivers/scsi/mpi3mr/mpi3mr_fw.c           | 15 +++++++++++++--
 7 files changed, 80 insertions(+), 6 deletions(-)

-- 
2.31.1

