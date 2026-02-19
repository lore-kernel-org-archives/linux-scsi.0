Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C031334C25
	for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 09:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771491815; cv=none; b=FirKoW//tkMG7f+Z2A8c3udp/CRL0wyowPaFGfaOw99JpzcQq7pbPZLAZPehT8zs0xJaVtY4UiLacz6z/jAnU14gNsMqO1BYk0PZLNSQ5gSYSF32zKCNz/BPjoc0CHYyiM8f3DOo6Omh0opE3JcnPjgJRU+d8/OeXJdT95iiJbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771491815; c=relaxed/simple;
	bh=928OAOahZdG4Xfvx2DerQUpFBhMcEhz7CAZj5Aci8zc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=eVUcpP8kMIRmo0M1VGGJPXSUO0ppqxDiNwi4vFpKf7U+gnYfSMIpH6VATIz915yVYDwYHl1HN2Hta5cup1ECRddcTTRs85nWDJ2Q3XEhp6Lp7o31sQ8iOdCntwEzh8XA3xo6QmjHzIIpkqCQ8GR+6hABMsCO44KfXEoTQl9YAOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20230601.gappssmtp.com header.i=@cse-iitm-ac-in.20230601.gappssmtp.com header.b=nbIuT/vJ; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20230601.gappssmtp.com header.i=@cse-iitm-ac-in.20230601.gappssmtp.com header.b="nbIuT/vJ"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-823075fed75so346731b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 19 Feb 2026 01:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20230601.gappssmtp.com; s=20230601; t=1771491810; x=1772096610; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=woTan9VVYvyV1yh7C/L083Hx/xNDYsj+r3LiM0PqHJ0=;
        b=nbIuT/vJLyA/crDZWYVFRKLI3FTPEXAHc8Mf2hbGWljvGArPteYGEoZ93nrZ7pC5VT
         xYl4QaTr0HdNuFfEOrwYQ/zpnCOQ/ek7K2LkkQvHLdcz85HtbQxuJFNs1DQxOwkSycRe
         7TmBOfCMu9fThGRPrLZoSeanu0F0DaOdov2mPFIwj7Vlero/NgscxD998oBVOXncyAbX
         RvAyH16SKdsPbD6BdJfckVjXnwzoHOtj8krJDVV65vWnvsCEdcq/KPA5GsbAVAxWzaTG
         Kewb1qboIpzT1vubRfa+xihM8o5ax/Mc6uLL+/S5RV2fv9oiL1joMpQvANPVJ/g4HnDt
         K6AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771491810; x=1772096610;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=woTan9VVYvyV1yh7C/L083Hx/xNDYsj+r3LiM0PqHJ0=;
        b=Wx7CfHJFk9xWAsI6dd05Hiyu8BGrNbJSWIjIqdoHqHe4/E1PZhoDUSoFPLU+g2QrE/
         sXiKUJIjnG4gcalle9SsT+wZguAz15G1P/MXylZGecKbKP3K/9c68nAbfw15Q8S/TVoP
         6EdpTeJx78rPcONPh5EnOeyqB5LIIjxeHOQ5xnbDqno4h+EJEbgQi1kAJHFJ2VY9YzGW
         Ra2CtmvBc+kDhPN+T1cZgJ1yEyRRnvIh1lKPZcHs9UAvN9GpREMPaAdZufI8k3MElT+9
         xhaKO7hBjOTVcDsnlfskIAvk/yFy8d4ZQQHIexqrAEeGJGVjQeMRI5q1NrNDSCAPMPjI
         7M4A==
X-Forwarded-Encrypted: i=1; AJvYcCWXCYw+EIgwWckQcpT7+98E2gfR2SMCCIfSnVZJXhnVptjXbHxE7IeBGNegj0F06D5O587C0UGTAAtQ@vger.kernel.org
X-Gm-Message-State: AOJu0YytYI5aglOH7KTc7piNTQ2BlPAkfwPNxRFWeng9dGkGpZbV58ow
	x9EniHw0qwVAQzuhJIpGGOx2+UVyhdvnv5zJzVhGvVrauEV9piMs+t9fkQBiTmdPmUo=
X-Gm-Gg: AZuq6aLOfHAgVq3Uo2fNpKPHSSyQw2SicFQgnd+Ss4iKK8eewy+P4wqoVRP1bLw7ziD
	Q3FoI/StUv6YqXz1rmCn7hzgGr2SYtcKMpFCm4rKA43cdIalhVwNQACV27nw06FIv2LFEyCmAuv
	bcs1FXJVul1bKoDObyr2v8UBG0AcDNo02RIkDzHPTTQ2jffITfYhgAoMrE4jirlZKg9FmJ6nkGS
	tpxGSpeDEkHoyLxVIWjnzKqhLp4HgzJEjl0/KT6NMKius8XdKgDMT+bhxE/zDAabMwqga3bQzVg
	xScViwhYRWyrPor1VhAnYwCV3SBrsQ66HbZG3wdpoXd0aHro1Aeer9AmnyMQg72ExYivqTpFAQ/
	Vp86YlUBXrN26NI96W0C7kh5IfzrevEVD3uxw0J+ZQ1d/SMYjGexUk2wpldRk6rlCBM3eyjD7k/
	l6tWLLwv5RQOTSq2HykCneE/sBwbX3jwHNBmA8R9JHb1p5w9c+CMBa4xUwfoYR2x/I+HyN+IaRk
	C876a4FYDvspMYLGf9r72NFYSnkJKxXcd5y/Ev1Y9jE0uUnaf/N+4kxpg==
X-Received: by 2002:a05:6a00:1d83:b0:81e:b93a:ab09 with SMTP id d2e1a72fcca58-826bab56b60mr1002475b3a.1.1771491810251;
        Thu, 19 Feb 2026 01:03:30 -0800 (PST)
Received: from localhost.localdomain ([103.158.43.38])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-824c6bb3549sm19985248b3a.59.2026.02.19.01.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 01:03:29 -0800 (PST)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: ram.vegesna@broadcom.com
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	jsmart2021@gmail.com,
	stable@vger.kernel.org
Subject: [PATCH] scsi: efct: Fix potential memory leak in efct_io_pool_free()
Date: Thu, 19 Feb 2026 14:31:31 +0530
Message-ID: <20260219090136.108938-1-nihaal@cse.iitm.ac.in>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The memory allocated for struct efct_io in efct_io_pool_create(), is
not freed by it's corresponding free function efct_io_pool_free().
Fix that by adding a kfree().

Fixes: e2cf422ba833 ("scsi: elx: efct: Hardware queues processing")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
Compile tested only. Found using static analysis.

 drivers/scsi/elx/efct/efct_io.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/elx/efct/efct_io.c b/drivers/scsi/elx/efct/efct_io.c
index c612f0a48839..bdafecca7573 100644
--- a/drivers/scsi/elx/efct/efct_io.c
+++ b/drivers/scsi/elx/efct/efct_io.c
@@ -92,6 +92,7 @@ efct_io_pool_free(struct efct_io_pool *io_pool)
 					  io->rspbuf.size, io->rspbuf.virt,
 					  io->rspbuf.phys);
 			memset(&io->rspbuf, 0, sizeof(struct efc_dma));
+			kfree(io);
 		}
 
 		kfree(io_pool);
-- 
2.43.0

