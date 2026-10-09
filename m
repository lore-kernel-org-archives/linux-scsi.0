Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D362BEFEF
	for <linux-scsi@vger.kernel.org>; Fri,  9 Oct 2026 00:35:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791506150; cv=none; b=gDk+boca+t0Q54057zYpbXLSABH4/i4YD68f5o5euZnDba5k2WB75SlzEgB77CNM8vaaue4lR4v7D0EQTS0OdxY6i5z2wX4+cjHj+y1XS/1wbZozzleWZ+x2P/1HVMrQ091jYUG1Bzsrf7rmlf+NY0cPalKcXMr3n3ofkOSaDCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791506150; c=relaxed/simple;
	bh=7vusdRQEb6vDC8yGOo24l6z2uwSQJ6x9dmLh9qkibmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JvAKSvLPoo8pz2jpKk+EpdTEUKleswIj5zXGB5mnMGgxzVCPvDBMRuK3GsZN3zkOvFtPGxKY/bBDjHZBzKqm7Rdym5rTIlKOsL9dL5FPJchM0XoFMulf7a44NVCeNkkIuaWJpZCZaXO2Jvq1m0A7ktLZUX/rNRJLI4MKN9kMSPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V5e+kmIc; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V5e+kmIc"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-7c8b520c640so92107137.1
        for <linux-scsi@vger.kernel.org>; Thu, 08 Oct 2026 17:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791506145; x=1792110945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nKFs0zmwAT1C3qeL9nzhFgqO9VFk35yv2YzEHZzzsa8=;
        b=V5e+kmIcz8tvSmZ2YUSDGwLaTyW7OUPUuHXXutMqP876lImSvDOW31EOw1M/DMwvBR
         IwKGLKflzACW/2H2B3Z57s7t++SsxQbFUMy553BEwnlPwcf4j5hOGXlfw03tM2Z6WcT+
         +m8p+ZkjGjjIg+/2M/ekJ7uwv2WEgzZUCHUG85vtuG4Mv+/HYBAQMZKL/dxPoFD+Myvv
         1u3btbavH2jAlAOfF2vA+3gwyq5ChEnA+pwEiCQIrtSvqvCN6mbXQTTZ6MDLPSO0HMHv
         SdlmIG2WDHAGNmouizQE5g2bYHwdy9kZAQcWv1ZMHGK6Hll3GZ5mCsv/Ni2rKd5KNPzI
         rlOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791506145; x=1792110945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=nKFs0zmwAT1C3qeL9nzhFgqO9VFk35yv2YzEHZzzsa8=;
        b=vDrPEqnABnwndEbiTD0L/fBOOppFcbImxuY3E7UpjMsO0PBCFCgEl5IvBqrMHCLhw/
         nLuT/KpCFjQkyKFYCx0sA71r9oSeyCfUlSk8gOk7TF8YS9sizz3U+F02Orkaamxu42+c
         Kr+Nwpm/xi4ThDwnrvKXUESOcCiUe7bso96EDiod6eDRSek804cNXhbhK71WDIAgxKMC
         px8uY91JSX74lWJtGVj9H5o12qDbgKh0pDSDfhFTN9SoxTNtvtdpYtTKlT2ipRrXiJkD
         hG6+xmXoD8Qgb5iDU5OTaikaz1yMOstz8T9mmK8LtXDfaxhBPG4NXUKb+HgrWCYHnOpG
         Y6yw==
X-Forwarded-Encrypted: i=1; AKwUvByqtJg6/OdWcZPafDdJwXooKuuPOKFa1VCzoehY504C/Vg4rpD+I+ZlFJDmrTR/o1NMVp6fmmjyXSvL@vger.kernel.org
X-Gm-Message-State: AFq9FYK9iNiCbUc70rAOXWZayj3XQvkZ1WcD/pKS13kouP3yqqdBRdZ+
	Xh0V9MEanOTfH/PnZf3bxb0LeKGDRMZkOmHrEGqA/2HbMjfxbUw1Qx4HEZJL8nDmOTY=
X-Gm-Gg: AYBFou0aNMKsqgzUo/+zI5tyl6z9+TRmcW5WMIYEdJ32M77ZAe2Xe/uegQYYEFSTcim
	eCnX7HrXeBQBRisGg13W4YcPRAdEcwlAX8LnhhncKVN7ahm+f1TLOwgk6njql0Pp8y8nqxhv63U
	E31G7eqXMBK2GXnG23QsAO7nFvxegDLNVcfxZrl6lM9SFYy5YyhJQsc6HijJW28VAQ2X1uTdNsW
	aW4aGDb9XHt+HI0BWdHsDSDLVMX+jfRnMG8RT1PPo3hhSXEjJeD6+jrgcuVfbJQyFUArs6nwe+X
	RPP2rmVHHjd5PXkEnlO2ICdg3i9M1GDYxwL2dM/nDiA1HTi7cM0TPxui6fJLLGXd2a9Scc2pg90
	oZ3v2yZPpprgTIfMVW0xSi1OZzujmOOM15F6+oqFKU0eWJ5lXdmKASAKEUQ9p9VHII/lZmmGQfF
	yMKsxHPWRtaIa4fs7ii3sq9ktP3xjyC1ySkYEbj4kD/af1HMKy80juOMQeUWxsLLT78B/UuzN6U
	v8JmH0sl1UFuXv6SbqCzipq3MwWuWMyeRx5w0MEc6BW1z/oI7OLq7+3Lb2fBL5L8YdIE4ociLA/
	7A04ZJBZtg+K91LfTOc=
X-Received: by 2002:a05:6102:149c:b0:7ae:544d:b36c with SMTP id ada2fe7eead31-7cb3728af21mr112122137.3.1791506145560;
        Thu, 08 Oct 2026 17:35:45 -0700 (PDT)
Received: from localhost.localdomain ([132.170.205.109])
        by smtp.gmail.com with ESMTPSA id ada2fe7eead31-7cb3539092esm488922137.3.2026.10.08.17.35.44
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 08 Oct 2026 17:35:45 -0700 (PDT)
From: Sanan Hasanov <sanan.hasanou@gmail.com>
To: "Martin K. Petersen" <mkp@kernel.org>
Cc: Sanan Hasanov <sanan.hasanov@ucf.edu>,
	linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot+fa495e1497c48a6ed885@syzkaller.appspotmail.com
Subject: [PATCH v4 3/4] scsi: target: rd: Don't invoke the OOM killer for ramdisk pages
Date: Thu,  8 Oct 2026 20:35:33 -0400
Message-ID: <20261009003537.62265-4-sanan.hasanou@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20261009003537.62265-1-sanan.hasanou@gmail.com>
References: <20261009003537.62265-1-sanan.hasanou@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Sanan Hasanov <sanan.hasanov@ucf.edu>

rd_allocate_sgl_table() allocates the ramdisk's backing memory one page
at a time with GFP_KERNEL. When the requested ramdisk is larger than the
memory that can be freed, these allocations do not fail but invoke the
OOM killer instead. The pages are not charged to any task, so the OOM
killer keeps killing unrelated processes, and may panic the system once
nothing is left to kill, while the configfs write continues allocating.

Use __GFP_RETRY_MAYFAIL so that the allocation fails once reclaim can
make no more progress. rd_allocate_sgl_table() already handles failure
by returning -ENOMEM, and the caller then releases the pages allocated
so far. Add __GFP_NOWARN since the driver logs its own error.

Signed-off-by: Sanan Hasanov <sanan.hasanov@ucf.edu>
---
 drivers/target/target_core_rd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index b52d703d2..2613342be 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -150,7 +150,8 @@ static int rd_allocate_sgl_table(struct rd_dev *rd_dev, struct rd_dev_sg_table *
 						- 1;
 
 		for (j = 0; j < sg_per_table; j++) {
-			pg = alloc_pages(GFP_KERNEL, 0);
+			pg = alloc_pages(GFP_KERNEL | __GFP_RETRY_MAYFAIL |
+					 __GFP_NOWARN, 0);
 			if (!pg) {
 				pr_err("Unable to allocate scatterlist"
 					" pages for struct rd_dev_sg_table\n");
-- 
2.48.1

