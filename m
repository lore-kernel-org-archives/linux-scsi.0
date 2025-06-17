Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C692EA16C
	for <linux-scsi@vger.kernel.org>; Tue, 17 Jun 2025 21:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750194312; cv=none; b=SRI3zSGpTJ+MVWuhqEryZ/Q6m/JVpxEq3QtTzFnO9OAARESaduVIavKAKH2P7YsOah319iFaEjsXCM7E5KqSuBgiXp851Zoi7bdnGrzSpZ9oOCBXD1/A9oq1Cztiux4WALmPgfraKl73DeHCCjFBC88y1SPzWSpu389O3nJYXxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750194312; c=relaxed/simple;
	bh=z6As7b7u4dNJN+RFdc4kRkY6FNbad6JDPqBp4UFHYF4=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=NoCqXR1zWCYEW2QMC2cP3CxD/msNzhNGMVqSvoOznPKtwvanu5kx/Rsfau+yrsdcGaH4xa1Y6vLzCDHRQalF9+4zyB5V/RFXLa9T3Sad8846Voq2FQm2gNV6hSz8OMTW/YUpdRDxpPQ0Y392GD4P8uBAvxzMKgQuGIcp3UiDw1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--frankramirez.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=1vyk0DZV; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--frankramirez.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="1vyk0DZV"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-235dd77d11fso50825505ad.0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jun 2025 14:05:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750194310; x=1750799110; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=RT/4G+d3RfQXn0+3N/5uepvdPWq1t3QwRhcHYgh4JDs=;
        b=1vyk0DZVZtYfEGAs8yVJnexsyZS0l1zZW5tvzQcX1gR5iQQOauoTamOQ5MyxyrID9x
         LXZyZ0neQ6ZNW+J/ROcyywdNaP8aCHL8MlB17V1fI4hXtP1K1yRrEheYgTkQZb6JcAZh
         TUuRrvZlfdPxpBUZ6pEioA3VEQK+OS91PED94VQBZ2sVa+3qKXIjTWs3deYpilMH2CKo
         WjSgb1wfGPQbueDa9kha7Qax6mZV1sUT1pChHQmjoCFS+qrSho3wYvYpOUVEBdSrNVFu
         xzAzhmQkayMqA3Bc4m92irGB2/5HlFBWeG31LMhs82ecZNixPESETz4Rk+OJs64UgHBl
         yQ1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750194310; x=1750799110;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RT/4G+d3RfQXn0+3N/5uepvdPWq1t3QwRhcHYgh4JDs=;
        b=gJBB8Qu7KLWB4gD9z+oY+UoqvY6XB/lIxN/VF6zQnxDjc9nGTvlT30WE1CnqdKTrB9
         AbKat9geGAhQjSfIdBb84Lh+UST98WoUy2xkl110RRQnyBBuYdBjnKjSWnM5Qv2cwPUJ
         BcJzPXr+hct6UWYRW34ilp6P0BbfutVkrhjz96ufJPOHw/gxb9byaHEOUB5IYOKyuOD2
         AxQjit2oRS5bDWXFgbIGmoenFXTeqBNGmg8+GWJPTLcwvFCxGgEHLjevsxvoA7tvITOJ
         esW6B2K1eA7ifsTVAoy9vgJjGtfOguuaJC48qJep4RedIgWDxGlDIPfXLQ5VzOMXYEGz
         tkzg==
X-Gm-Message-State: AOJu0YzHEOpiVNfYAaSIinmsjUD8YTxiqPrqY4Qm02NwLI/LxavBCizY
	MTIH+NkCdHHm6UXqyo+c0U5rP/ZeRbKCPmyACGCykB7iTzw33aqcCSnTmztPc+zA34eqe5YHVYf
	aFzp6hpfF+d82PFaXAeY081QMysaaYg==
X-Google-Smtp-Source: AGHT+IHwTb+uzPjoYirGoN97S9QWNgf/j0GBXFgirky6u+kL8qRWr7c7rA1quvr+NJg+QHNBw4iPGY34zNToFLzov2M=
X-Received: from pgcv23.prod.google.com ([2002:a05:6a02:5317:b0:b2d:aac5:e874])
 (user=frankramirez job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:f8d:b0:235:225d:3083 with SMTP id d9443c01a7336-2366b32e499mr174900755ad.6.1750194310417;
 Tue, 17 Jun 2025 14:05:10 -0700 (PDT)
Date: Tue, 17 Jun 2025 21:04:43 +0000
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.50.0.rc2.696.g1fc2a0284f-goog
Message-ID: <20250617210443.989058-1-frankramirez@google.com>
Subject: [PATCH] scsi: pm80xx: Free allocated tags after failure
From: Francisco Gutierrez <frankramirez@google.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>, 
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Francisco Gutierrez <frankramirez@google.com>
Content-Type: text/plain; charset="UTF-8"

This change frees resources after an error is detected.

Signed-off-by: Francisco Gutierrez <frankramirez@google.com>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 5b373c53c0369..c4074f062d931 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4677,8 +4677,12 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 		&pm8001_ha->phy[phy_id].dev_sas_addr, SAS_ADDR_SIZE);
 	payload.sas_identify.phy_id = phy_id;
 
-	return pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
+	ret = pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
 				    sizeof(payload), 0);
+	if (ret < 0)
+		pm8001_tag_free(pm8001_ha, tag);
+
+	return ret;
 }
 
 /**
@@ -4704,8 +4708,12 @@ static int pm80xx_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
 	payload.tag = cpu_to_le32(tag);
 	payload.phy_id = cpu_to_le32(phy_id);
 
-	return pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
+	ret = pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
 				    sizeof(payload), 0);
+	if (ret < 0)
+		pm8001_tag_free(pm8001_ha, tag);
+
+	return ret;
 }
 
 /*
-- 
2.50.0.rc2.696.g1fc2a0284f-goog

