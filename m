Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B663955CC
	for <linux-scsi@vger.kernel.org>; Wed,  3 Jun 2026 18:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780511123; cv=none; b=oNuoCbBz8tT1pWJmg8a2zdq6BM+N9rNfIDAIymU37PtocsV4Q1cTYlQTU1Pc4zfq4EfK9hLZtifEmnNihAraQ1QmEYCY1OWiXhQR/zbczuIuUzDqbiHCG/dBHo1Mlpv3UIzNLji9J+XIxaMNVgTKVcZF2W4kWM0e0NjSHPYizOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780511123; c=relaxed/simple;
	bh=9kCR/6Ip6UBB5yFOtANKH48+nsmbIPRUgaRo1CrFUK0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rIM9BmOuvPjTN9d2XTncPJwOEC8o9U6a1a/mPa9i4hIJgTCIqjxizpOqaCZJfDcBClZ8TGyQc9fs0hU8vMkO/DmzgRw/r0gLW7t6pTIF6qXsbxZn97FEfoq5yF/7wxzpvGjb8PuvUw70u0D/ELDMtjY6LlHFBcdW0/9SmOjPgko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com; spf=pass smtp.mailfrom=trailofbits.com; dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b=K7zQS6P2; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=trailofbits.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=trailofbits.com header.i=@trailofbits.com header.b="K7zQS6P2"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-96387cf6335so926308241.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Jun 2026 11:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=trailofbits.com; s=google; t=1780511121; x=1781115921; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=LCMZLPljRhZ6RXq6a4YfF43l0gzI2FlO5vYDlJr0lic=;
        b=K7zQS6P2U690AIyfha7h1/vS9gYM/r84nJ6jIQtG+TqrLurMZO2kOrCajb9dN5Y9TZ
         KCOhc/Vch5pNXGq8DwiE5TViH9NC8adgardotZTyBaLQudbwHeKAMHJWlC5j9+7UGSai
         YVubWf8EM/kMQe9UL3p/SKtas2v4bfPjCXysDwepbjXQc6Odxq8oJSmY9krh/Obb8o+1
         Lq+z2gdHc3w7heXl4FHCjEYVI9BqO+D94YKaB13PGznheoiO62Qc6oRiAWU0kqG/EBc4
         qKsdo0T6XJJaQefWYnlWN0WdjuaTmED9miGt9UIcOVqPkBwv20uZobvYBqCyM4bARgsD
         d67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780511121; x=1781115921;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LCMZLPljRhZ6RXq6a4YfF43l0gzI2FlO5vYDlJr0lic=;
        b=lpuG7V6VUJ6sArGJqw/zU1uEvxnSZeJGEkKR+I1ocOIxhkdVVVURIm/g72NOgFT660
         woU/w1E7qW71iVMBhYTJHARDHdbbm0IHLP9rhzMZAItq3vkyfQJ/WpRom5UaVewvmsaL
         5vuCMWqPgyUQGLjt2jxSqL9UVIfiOOKhqB1JK1oqwk8zn+v5zeHx+WY/cL3Ko+RRg863
         ZKLTPbTX7FfihB3aHclyZyinEkhBgV4O0r72wLGBRHPcdTanPAMbhGDje4VJ6LnMIKjq
         1freA4enMTzZ5w+1WFPmhHo6I0UxKWwRJ4mzY4jhXd9SJ2lcDgnO+Qh9YK00dcWR7Md3
         +e2A==
X-Forwarded-Encrypted: i=1; AFNElJ9XRd70nohFA7k0IdM43PaB3e3cLd5etbF93/S73tH+fiCEFAoetkO8BiiabeA+GJzFteRbjeI5lM6f@vger.kernel.org
X-Gm-Message-State: AOJu0YwSqZZMHKFM/OUM44rCTOluGYR0mbRWYwG6iGpxxZjaFxXoaxsk
	HLcWKLWpo8J3p0rVlMFXaYjczvsJmDFKWkvo3LzXh2PlH2oei+qTsMMzj+guUewKpYs=
X-Gm-Gg: Acq92OFlvV/Y9GBgJjq8VC/JgEJ203zH1KGCPhZCwAyVUcPGM3+CZHPw4ByHr9zDgcE
	kiqECuL4dffLtDSaUZC21oeN4+w4RniTthhEQPCX82j1ihkiuwGizT/vdB6MclSyhIWiPWoy5c4
	R5HpiiDwx4rl6lwf0/oAn0SCaeZnjxP7pocMV18nV+FLVr2rUp9LOrhEbJXP9w2BtKPcd7OpIUf
	GVnFwxWJiuKwHlWg3KL8eKCefwN0U8xu8MUuN/vJITWs+nxFUK1QoWMQ2H6ASDGN4ZyqrJGWCmA
	YpQBSAijBjs7WRJhPakBr+Q2FdKwBOurKPxFiMIwMAsrytFB5ggrZsBgk6peeB6lWTfnNLUMRj1
	RPnmr5Y3aIk9jmQde/P/h5wLCkMEY4kcthZxbNWfNCTAMKMEEAyArHTh8h4qwyGJofkc7byOSwi
	2/5YcDPhWzsB98ZUQnFJdx4oOTVl7gyo3FEtVRTA==
X-Received: by 2002:a05:6102:8193:20b0:6cf:2b61:3fa9 with SMTP id ada2fe7eead31-6f54cea3ce7mr292215137.10.1780511121041;
        Wed, 03 Jun 2026 11:25:21 -0700 (PDT)
Received: from localhost ([161.35.96.86])
        by smtp.gmail.com with UTF8SMTPSA id af79cd13be357-9158a2359ecsm315723185a.14.2026.06.03.11.25.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jun 2026 11:25:20 -0700 (PDT)
From: Samuel Moelius <sam.moelius@trailofbits.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Samuel Moelius <sam.moelius@trailofbits.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org (open list:SCSI SUBSYSTEM),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] scsi: scsi_debug: fix one-partition tape setup bounds
Date: Wed,  3 Jun 2026 18:25:17 +0000
Message-ID: <20260603182518.27082-1-sam.moelius@trailofbits.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The tape setup path writes partition metadata one element past the
allocated tape_blocks array when a one-partition configuration is
selected.

That corrupts adjacent state during device initialization before any
command is issued.

Use the allocated partition bounds when initializing the tape block
array.

Assisted-by: Codex:gpt-5.5-cyber-preview
Signed-off-by: Samuel Moelius <sam.moelius@trailofbits.com>
---
 drivers/scsi/scsi_debug.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1515495fd9ea..dda19793862d 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -3664,9 +3664,13 @@ static int partition_tape(struct sdebug_dev_info *devip, int nbr_partitions,
 	devip->tape_eop[0] = part_0_size;
 	devip->tape_blocks[0]->fl_size = TAPE_BLOCK_EOD_FLAG;
 	devip->tape_eop[1] = part_1_size;
-	devip->tape_blocks[1] = devip->tape_blocks[0] +
-			devip->tape_eop[0];
-	devip->tape_blocks[1]->fl_size = TAPE_BLOCK_EOD_FLAG;
+	if (nbr_partitions > 1 && part_1_size > 0) {
+		devip->tape_blocks[1] = devip->tape_blocks[0] +
+				devip->tape_eop[0];
+		devip->tape_blocks[1]->fl_size = TAPE_BLOCK_EOD_FLAG;
+	} else {
+		devip->tape_blocks[1] = NULL;
+	}
 
 	for (i = 0 ; i < TAPE_MAX_PARTITIONS; i++)
 		devip->tape_location[i] = 0;
-- 
2.43.0

