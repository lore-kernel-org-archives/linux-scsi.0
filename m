Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E692B293C56
	for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 11:11:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753096274; cv=none; b=AzGR9fx612f18lHex3APqdWMvbH5KHE12/KIZJnjblM++6Q0ktw6/zMbckwDYVnTb5CHlZvVwzlDiFsoXCASboHi4QAsUAI1mOr+rHQaUldZFfeSWBaX7iIncQNwu6F2bw9T1pYEGeG1eSX7dzQjl8YIy6hXHLJYkX2B0Gy0OZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753096274; c=relaxed/simple;
	bh=AyBX819lOZqASO4Xl+h3qjFE8OaRAxTNE3UwtKIBvbI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=uOP46mD9+2rum2snSIKOef2sk8iaPudIly4xneUOykhvnH+hiTOnesw4P0Js108XTTXAlFsbmYAkMeBbI7KUzu1HSxY50/eXKGrwJ8VN1YoRiAh2uftaO3OCsBqPdRDgoPyUTkIs51njXS8ETRMN1t0vo82uaXECAg1jmongxAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=hSx22FyV; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="hSx22FyV"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-749068b9b63so2740304b3a.0
        for <linux-scsi@vger.kernel.org>; Mon, 21 Jul 2025 04:11:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1753096272; x=1753701072; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=fMv294KG3PJAz5FaySHACt2v0cuoxkaknOnsBu7Pzjk=;
        b=hSx22FyV870Bls6FBMideGwB+TBZhcY8jFFj0YrL1mbEtH1I1S/j6em+YX52Mg+N0T
         aTrGh0RCpLrG73qONsyfCEreO5Av92nLQ9vGkAO0B8Q4jk0H3uCnI/UUThBLFD9mppJB
         Iw0rbB9EDAwZS04zi1uUj36NV6f/rVTre1iEU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753096272; x=1753701072;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fMv294KG3PJAz5FaySHACt2v0cuoxkaknOnsBu7Pzjk=;
        b=ajU3EsgjX7MA/o1cJAlspNl2WytP8R5MYoR2+RjxjXHycBZKi0mAN7kwkwAj2kZpbu
         uDtoQS/LXep9a/4KMwxrNbpdpYSQpNC/F4o+aM4xmmVyY7tI+GwaeYHz5Mgaq8fX/C0h
         C6kvnHmniwjIqbdEsi2hN/B+ATtEzFpeFZQT9Zclpm92eDMUtoQg6eXtWfAfGtyiEBEY
         vqIA+FujwVmsSp4cTDgkdJ1kxVcViKnmuEmCYN0CJ5SX1jpOtLy/jkGwF3i1h6lbGlCo
         dINBZUdiYNat7HLfHMK9bWGZyyt6giCVaH9dPyuqqTdu+XirrgPT3PKXrurOjz4x1Agc
         VYmg==
X-Gm-Message-State: AOJu0YwEZV7XSPqIPcVLx7yeDuuSYCZpj1rOzBf/VVlSL0o6R7CYnwsC
	Ta+/NGXffUBaj/uhokiPJpwppDkWpyCe66Bbho5mTxYVYOh3C7uucv01lNJA2v09TUYd0aR5dhP
	tP9YrGDdfB2K/RQyCF0j/k5aPOI6cUv4lCSLWivND621Q423L27Fo90W8fQBMvQNfuYKNOFx3ew
	fbBDWGtKfteRCzSY4t/xq44+rYEZGJ358q189qemmvLCcIsG328Q==
X-Gm-Gg: ASbGncvm/NTu8e7ORHebwjxMy5VBwBkxUpk3anXhqrc2ldu+TpQferCyNiujP2Yu46N
	poXUoYv+4HLNeUkZMC0kq+RD+ZVNvRHVh3g8j1+SGju03YCtTKHHhBKuXT1iAqLKgfmRZZPEmYC
	DStdi4dJq2HqgpcrukugEVwA2pwq0DifK34VwrvUuBCd3h6sVLD4YqVtEnhbVVq6nSHl9ukTbrC
	DkAwIo0sCE37OekGoYwszDVZNSpRKq3wFv3eMmj5UurqtWCWFRTF2CKNX8MMby32kUQwNMCnAxL
	pMkGjyEKdfOPWRpG8fQD2Q0eL+c1QPh8kmwbOOokveGqcVF7jvt73n5Rfy+qOR/SL14IbsOPmV2
	1/aoRvbOzi0NbwWFDOGkUIftWe6FsUzfkFMUe0C/xmRDMqKwu+hC04Mq1gIyBXRDYmSc=
X-Google-Smtp-Source: AGHT+IFySp9SfvDQDAFtIdjTIbvXVZ3XmzP+T5XNCHcPkDs76QFbGWOxBCLBjn4xaaZ4SsiepagI2w==
X-Received: by 2002:a05:6a21:497:b0:233:f2a3:c68a with SMTP id adf61e73a8af0-237d701a6bbmr33111154637.23.1753096271544;
        Mon, 21 Jul 2025 04:11:11 -0700 (PDT)
Received: from localhost.localdomain ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-759c89d2a72sm5632547b3a.46.2025.07.21.04.11.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Jul 2025 04:11:11 -0700 (PDT)
From: Ranjan Kumar <ranjan.kumar@broadcom.com>
To: linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com
Cc: sathya.prakash@broadcom.com,
	Ranjan Kumar <ranjan.kumar@broadcom.com>
Subject: [PATCH v1] mpt3sas: Set DMA_BIDIRECTIONAL for additional SCSI commands
Date: Mon, 21 Jul 2025 16:35:46 +0530
Message-Id: <20250721110546.100355-1-ranjan.kumar@broadcom.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Extend DMA direction override to handle additional SCSI commands
(SECURITY_PROTOCOL_IN, SERVICE_ACTION_IN_16 with RELEASE) that
require bidirectional DMA mapping, in addition to ZBC REPORT_ZONES.
This avoids issues on platforms that perform strict DMA checks.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index bd3efa5b46c7..8aec475fc7a4 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -2686,8 +2686,22 @@ static inline int _base_scsi_dma_map(struct scsi_cmnd *cmd)
 	 * (e.g. AMD hosts). Avoid such issue by making the report zones buffer
 	 * mapping bi-directional.
 	 */
-	if (cmd->cmnd[0] == ZBC_IN && cmd->cmnd[1] == ZI_REPORT_ZONES)
-		cmd->sc_data_direction = DMA_BIDIRECTIONAL;
+
+		switch (cmd->cmnd[0]) {
+		case SECURITY_PROTOCOL_IN:
+			cmd->sc_data_direction = DMA_BIDIRECTIONAL;
+			break;
+		case ZBC_IN:
+			if  (cmd->cmnd[1] == ZI_REPORT_ZONES)
+				cmd->sc_data_direction = DMA_BIDIRECTIONAL;
+			break;
+		case SERVICE_ACTION_IN_16:
+			if (cmd->cmnd[1] == 0x17)
+				cmd->sc_data_direction = DMA_BIDIRECTIONAL;
+			break;
+		default:
+			break;
+	}
 
 	return scsi_dma_map(cmd);
 }
-- 
2.31.1

