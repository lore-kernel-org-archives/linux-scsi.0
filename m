Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC5CF28467C
	for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 20:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770929747; cv=none; b=Qc4KTqEDB5otU6CFA3dKxNcEy4nUa4MNsJZsTi6C0lctzdjtFqMEOxzpDNNm+uN1dPEt06KknC2cBhJa+88suQxAlK3FKA+ONvvlKQfM8zGU3mZ83EXKWlC09vUunjHqQfP7PZxSHPCy6br3+ahW+8sOKKM23D4s61YFSDWDpp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770929747; c=relaxed/simple;
	bh=niv1LVqJS0oRWShpXQsSYVmzuSt15Xxg0zeI0Au6rFw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ouCcUci5d3HopBydgHkWy/zK2I8WT2F/pz4MDkrfIhe8OWM35XVe9hrOHGc6Fqc5WSZJ9V/x2/aXlHDVE569qkTSqfYKlYZLGZR8Xlgiz1H7Zjh5U575zdrNDly/6EwPIFQf48NKKd0Mym5rYdN9IB+b89JJ7XE6n25liz4yihM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kFs6i2Gs; arc=none smtp.client-ip=209.85.160.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kFs6i2Gs"
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50335b926c2so2341441cf.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Feb 2026 12:55:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770929745; x=1771534545; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0omlKu9DWW2g2VCakVXaEzsNGOWFZY7QUu4zDf6BmhI=;
        b=kFs6i2Gs27EfoREipu5xHh3+2Kfsb3JymWVqfxydS1kxHFzhuN+tOJcbHUFoAuQEZZ
         fgMWTu8kwc1I6Tb/7MnYnEjoYsbrAajmi8DPYTtlUnK4YZn2myBTZ6sOZJ4KFNLBeueZ
         KXTp20befoxgTFMDD8f3bpS6nwDWlky9itrtsPe6EmsR/niKd5FOMJnVAKcu51P0TMDa
         oioeeHu6MflGiHNhN6QSzXSjOFYuJkPm0m9MMPFx5p7g/Mkdb4PUupTG9vgNObk5dXdW
         V6ETuavK+FBxNp3Eutg4SHOrGon+fxZpjTpfwEssP+KQ8D3ca3OOLIt22UOUzznAfYB9
         v9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770929745; x=1771534545;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0omlKu9DWW2g2VCakVXaEzsNGOWFZY7QUu4zDf6BmhI=;
        b=oao9KgtdD/KJwV92vSzlwUcFWKHZhbm3VKWfgcuzltOQr/EBE0ICH7uA03ijk2Ob1Q
         W+mVFgiKu20k/o0BqXxune3z+JYDAg7VeVM8ErKGvquh6uObG4mWMf7z0Z5bI1aldoHN
         0xE5fYWINSCfDwQzfrLf5g0DUJVYCMF2SzQiHD0EnVfQalHK9XRDGGMUuYhkR6n9BWYc
         U5nVEneClZobmb0/EPsC9N4Zz0wB/jB0hEhunwalmRaQgVm8l2HsrKL3Iv/nODRii/AS
         0GEWRV9qTUNOPpSxR9sooM7ELh3dHEQyh2czxiACv38SR4oQE1fBtoVwEyd7n250RQH6
         VVAQ==
X-Gm-Message-State: AOJu0Yy1UBsJp7nigAoE/w8XiBLZi1vqndTD4ZA8H3Zhyt2xP2PQUGg2
	tFJ7Xqmakg3NdMGPQdhWXQCeYaidilgQp7MzB0zhpM6jYpnfIF7u8xL1R6zEE3i4
X-Gm-Gg: AZuq6aI1gFH+6ZxbL1OGivM3+ZT5j9udBKmzbEQeMUw2llnxsVrmG12Q8uAsjNDsMHf
	Cqxe5rSktvlcRzeeT8c0OGfxJuSz0kB7CR4Ynq0BzMRYOf5vpi39FfwlWtjUhigXvW4B9FwRI+q
	ntGJe1p6o36qf+oodnx/4EvOlSsD6NsuVmA0WpBTxynX0exHZBh+Os0QFJCv6e70CO9cagmaIwt
	MPjOc8/GAs65eawOulb3b6IkX4Q711JW3KF/yKJO+lEYLQBl0G/Sc1CysrSODYmisigDfWRkkuE
	8firflJYRbFmCNWaAWypgwmASLioUukgEsVZ+ZIUA2xOetGuGXsktTps3YZKS2RdPBeJj0DD0Pm
	B7SUXn67Nnqc73jOZEClxCT2sQZlHM000HmuFm/og3WAIVGiAb51HGcY2q3WoVHEakQyXrHmPrr
	/b0LjbPhZYKyD6kFRjTaLyjE730GWzA9zlQ99B8YsEPKJTQLleE5xzaGL2FyJpuNU/ktlBgHO7B
	3HpTbr+BUBbiuHeDQ15rQ==
X-Received: by 2002:a05:622a:182a:b0:4fb:f98d:454 with SMTP id d75a77b69052e-506a6a7fb1amr647761cf.52.1770929744737;
        Thu, 12 Feb 2026 12:55:44 -0800 (PST)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8971cc823a4sm44446646d6.8.2026.02.12.12.55.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 12 Feb 2026 12:55:44 -0800 (PST)
From: Justin Tee <justintee8345@gmail.com>
To: linux-scsi@vger.kernel.org
Cc: jsmart833426@gmail.com,
	justin.tee@broadcom.com,
	Justin Tee <justintee8345@gmail.com>
Subject: [PATCH 11/13] lpfc: Restrict first burst to non-FCoE and SLI4 adapters only
Date: Thu, 12 Feb 2026 13:30:06 -0800
Message-Id: <20260212213008.149873-12-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20260212213008.149873-1-justintee8345@gmail.com>
References: <20260212213008.149873-1-justintee8345@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

First burst is only supported on adapters running in SLI4 mode and that
are non-FCoE based.  Include sli_rev and FCoE mode checks before setting
the write transfer ready disabled bit in PRLIs.

Signed-off-by: Justin Tee <justintee8345@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index e5736b06c3dd..12c125247295 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2649,7 +2649,9 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		}
 		npr->estabImagePair = 1;
 		npr->readXferRdyDis = 1;
-		if (vport->cfg_first_burst_size)
+		if (phba->sli_rev == LPFC_SLI_REV4 &&
+		    !test_bit(HBA_FCOE_MODE, &phba->hba_flag) &&
+		    vport->cfg_first_burst_size)
 			npr->writeXferRdyDis = 1;
 
 		/* For FCP support */
-- 
2.38.0

