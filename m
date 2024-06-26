Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88061779B1
	for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 10:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719396881; cv=none; b=rTxlJImpaGCsTcmiw9c4CyNXPUfVrLBksGmVyn7ESPsTDo9sYbQHBT0h4wXegtcbWPTX5gb37GiCQXfixymAYMC4sk/EcSzxcXEB3oE0wKlheoYirHGNfirq2Znc94FJS6bvFUXubChc4nogDthrN0LaOFNVMrwe5W5WO7QNjQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719396881; c=relaxed/simple;
	bh=Po4MOpKCDdvoqxEYXrUO10gmVPVXzaCwnPcdvEhfMpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ut7rCLE88ehbfVEpknM0DQjptpEuche2TWiZt+acg6k8l/AdIXCgtRbEod0PitRwDosRWUWJXxOyQSRTjsXRNXk60OohVghzNPY9V8OeydrV/nvbOn3eAN5Y9X35Zlj1Ogv1rfvB5h/gZTbO8Blb5rW6vC07NK9RHAfUUvp+L70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eO3OrxbL; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eO3OrxbL"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1f9de13d6baso46510015ad.2
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jun 2024 03:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719396879; x=1720001679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R6IjOUYAHiklEy/1JCnyVQ/me9Hn9TKgQhwLunk55iM=;
        b=eO3OrxbLH3KZY98X2Vhxq7OoWG+aVbY0zC6oCKp/uwE4bWciQFYyB16GnfUEvWPTyY
         SYgOUCxnAlPqPqnv4g3oK5uR/SFqxwnuhOIQPpVX1RmDvMvnAYTbDiR6XOBz6/c7+WJ2
         rldIuTPktQJEcd/M9Gktub2pTkvC+K1VrZbEt3WEWKmUaDyxBixnAR01ao/GTYhxyyLc
         OXi8mDaU8aR0Lqa0IUEz/UA9zlmv/G2f7FpvqMYBJkU41LxcUfm3VbV/fDZw49Qrr2L1
         h/aJIs5bPnzEAnQU7EdFnfXom0WnfNT4rDPV7J0vytu4xV4lHfC5uD5HV7kqZfCkbDoU
         MG6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719396879; x=1720001679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R6IjOUYAHiklEy/1JCnyVQ/me9Hn9TKgQhwLunk55iM=;
        b=hIoxLpDyN7aqeSWDEu4xYXAvDHdRfMYuN9j6VIIkEScmdsZQs5mNaw4yzCIaPPrmea
         Fg3+XHv32rvrNchiBTBiIGdDw+C6/3GJ+QpDZu0xYQ/OqNAnW1nneAkKG7CSbcGh2u2j
         6CfJLDaqrZCRujTLBE9HHU9eTVvj5E7ZqCsRHxeqvi54ia6YpcVXbZy+yeuKd3YDnEzp
         sTYHmLyNSZ+g9JFPFIoilKXyq0Oawyt6FdVNGNy+tuXb3Jip3xDPYoP3ajP/DINEi56K
         d4xV5aYSahe+kHdLPOiRUbznupSr4RrfQEoe51GiXcIXigL1LQKFSJpRxj+glEKBhkzO
         jLPA==
X-Gm-Message-State: AOJu0YysS33KGjU//42BvGx5g45pOn0eDgMcN4ffcnv07ieg4EOFC/PR
	mLutPkvxQ7+6ddYW3RFBlYQ0EyLbxnfpskfs6hyYu0cn59RcWQHok6Kqag==
X-Google-Smtp-Source: AGHT+IEYXQ6vfq38uyCFRk52uqLXo2mpq2TchAKKSNEVpRUOwhxDU6z6zXipdl54g1leldcAzhTWXA==
X-Received: by 2002:a17:903:186:b0:1f7:c33:aa7b with SMTP id d9443c01a7336-1fa23f22680mr109342385ad.12.1719396878863;
        Wed, 26 Jun 2024 03:14:38 -0700 (PDT)
Received: from localhost.localdomain.oslab.amer.dell.com ([139.167.223.130])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1fa360317ccsm57063865ad.279.2024.06.26.03.14.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jun 2024 03:14:38 -0700 (PDT)
From: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: Prabhakar Pujeri <prabhakar.pujeri@gmail.com>
Subject: [PATCH 13/14] scsi: scsi_transport_spi: Simplified period calculation with max() in spi_dv_retrain
Date: Wed, 26 Jun 2024 06:13:41 -0400
Message-ID: <20240626101342.1440049-14-prabhakar.pujeri@gmail.com>
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
 drivers/scsi/scsi_transport_spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
index 64852e6df3e3..c50e923bfa0f 100644
--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -783,7 +783,7 @@ spi_dv_retrain(struct scsi_device *sdev, u8 *buffer, u8 *ptr,
 			DV_SET(qas, 0);
 		} else {
 			newperiod = spi_period(starget);
-			period = newperiod > period ? newperiod : period;
+			period = max(newperiod, period);
 			if (period < 0x0d)
 				period++;
 			else
-- 
2.45.1

