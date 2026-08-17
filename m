Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D56264F80
	for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 22:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787004796; cv=none; b=E0cqFjdhg8rvePjdvtnNwpE3Q8XrGxh+Jd2SLb+Bdl2e55RPyp/4js64XDRcXepPVzFOl1g0HuCxHtHddboGlI1ztdFQ7vZPewDev2iRfF6FR1PEIy17ztyGGkVG+Ybk+74+yxaV3+gKC0SjsbnjoR1R6wzhEO1Nd+hqMVmAqgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787004796; c=relaxed/simple;
	bh=EsYvSqNq7X4/sUC8/3bVEQWU17xHkSKcUIBp5YF30z8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mn0bLtF/J7jAfxLdAQb5G4D62DBrA0h/BJpmjeITqt+EnWClMQGwcUKt0eEaihzl2Dz6PGot3Sqkd6joGfOzJBWFNtqNgbcvVGCNYX9q3qwNultVn7DZQSHq+UcWggVJAUlWtChpmzRPVWRGJ07B7gZPXX/qlwDv0Kr7R6UN78w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kXNjASme; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kXNjASme"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-cbb8b54fcf8so3590341a12.0
        for <linux-scsi@vger.kernel.org>; Mon, 17 Aug 2026 15:13:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787004794; x=1787609594; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rxYr8Qgm5lIMJhu9XjbRyEotMDKk9C141QlZjz1CSTQ=;
        b=kXNjASmehlVOUISMqhqUQ8mGf1oj+6a810TDmzVgZr7l3bTU5v17UmQJlZREd8U1XT
         dKgKGvwQiBwZ3gT5iaAtKzjsYOg0edtGchmWRakJeaVrPrAFSF4kThDCxAPG8PRnZ8Gv
         KSuUctpLxuNRIc/1GDiCdoCW7lnN707N3NXEUwvMvO30UrQYIeaj179VAUdNbWHhoDv1
         4Ia2QeAeSFcGf5FW1lkCsdwZo9v8itb30kvR4BL3hViMn0n3y29ZR3eyRqC9u14PnSDF
         FC2ZUcPdZUEasr3xGAcuqb2P3OgkPysCZr6ujNaQYZK29gkLaFuY3jBfGgX8B57Epv4K
         t0pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787004794; x=1787609594;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rxYr8Qgm5lIMJhu9XjbRyEotMDKk9C141QlZjz1CSTQ=;
        b=qR6RT4ZV8qjEqZYLJaPuoj3N4dp+yXwiGTb+deowZ7GtnUwBOTPa2M+yzZrCx3Uj3E
         Ya8woy4aDzsMJNGensyXAzc4bUsrXWHDpNG5NEcC88sIkDpXuWvbamiXrnniIRYr/3jl
         cbyilDMFZSQC0otD/JQin3OQvH2NzQY1Fg6PbJsS7T6M7qc3hs4CfSRPf2OcxudB/WqT
         NJqAsE2e7IwUFUUzuQKlnIDqqvaMvJwOgKDxvjQxxf+MeOC8APFldFR2n4CLO0qt7oGI
         Px2xpWPczoqE4P5cDCmUfQXpqkyINHg0nBNc3H0waCkDr7ALajkLwKara++BeuYEMcik
         pCtQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp1wkP/+n5+TgmZC7fysFeknSjJU4/G6wD0nYhLJb4zubp7/j56kwTlXG1T/4wUOkf4Z9k2K2yk5jnH@vger.kernel.org
X-Gm-Message-State: AOJu0Yw1BbYYqub4+kOVCI/xohXO2d8n1KZ0X9d+5BZQK61qnsps7Cnq
	Iw5559w/lE9lGaAg7qOn3AfhssO2wDOXqZnsOIk4/7ztE8K/DzKXkAAw
X-Gm-Gg: AR+sD10wc5R9/K1E3pvaDBFVVtE7JVd+BHgSkB6HDNEzOSU2NBVNjcDwfvlQaYqvnKY
	cVxp5Jcn2IWAUSQfK19gZUvh/2I6f6wnjhIhlByEMxOo7r5ZrdO76FnuGsHhwE5I1HHlVDRLrbF
	8WpyBtpBNWOl1Qtb0T2A1lkrmsKFvV7KGXdduQ6mEoGnXHTPrHLrdeCs/DxHLIwbnmBLfVJ5mnT
	tu4NNigsalH/md2bKr+5NisJhpRKF7VKn0f7AlYsKwW57YJT125oFwC5vrqdgtLO0PdM3sxeToc
	uX40XMNgXIJV59mmYJGF1seewE1dY8VIdQyjqwrXmbZuGDkHQgjrVNvJkJr90Gb87plNG3mxLFV
	IzBpSZ5tFKkEmpJwZhdFxG/NjIPpNlykj6ElPo9feFp1kx3+CERZZ7WqJGkpXf9aZIuNOC2I4iy
	dPHUwrU/U5wCQr6gly3vTabvZ5Gk/V0tyAFe8jLiNSA6hqqaJfUuFXVQ==
X-Received: by 2002:a05:6a21:a0c:b0:3c3:8d86:9855 with SMTP id adf61e73a8af0-3ccda918c66mr3802871637.7.1787004793869;
        Mon, 17 Aug 2026 15:13:13 -0700 (PDT)
Received: from bloom.localdomain ([2604:3d09:178e:e100::6868])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cc13c02a12esm1311692a12.23.2026.08.17.15.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 15:13:13 -0700 (PDT)
From: Ivy Lopez <skunkolee@gmail.com>
To: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Ivy Lopez <skunkolee@gmail.com>
Subject: [PATCH] scsi: mpt3sas: avoid out-of-bounds cpumask_of_node() call in _base_assign_reply_queues()
Date: Mon, 17 Aug 2026 16:13:00 -0600
Message-ID: <20260817221300.43286-1-skunkolee@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

dev_to_node() can return NUMA_NO_NODE (-1) on systems without NUMA
topology information for the PCI device, such as single-socket
boards that don't expose device-to-node affinity. Passing -1
directly into cpumask_of_node() indexes node_to_cpumask_map[-1],
an out-of-bounds array read caught by UBSAN:

  UBSAN: array-index-out-of-bounds in arch/x86/include/asm/topology.h:72:28
  index -1 is out of range for type 'cpumask *[1024]'

Fall back to cpu_online_mask when no NUMA node is available, rather
than assuming dev_to_node() always returns a valid node index.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221294
Signed-off-by: Ivy Lopez <skunkolee@gmail.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 79052f2accbd..eaad6fb7f3cf 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -3238,7 +3238,9 @@ _base_assign_reply_queues(struct MPT3SAS_ADAPTER *ioc)
 		 * corresponding to high iops queues.
 		 */
 		if (ioc->high_iops_queues) {
-			mask = cpumask_of_node(dev_to_node(&ioc->pdev->dev));
+			int node = (dev_to_node(&ioc->pdev->dev));
+
+			mask = (node == NUMA_NO_NODE) ? cpu_online_mask : cpumask_of_node(node);
 			for (index = 0; index < ioc->high_iops_queues;
 			    index++) {
 				irq = pci_irq_vector(ioc->pdev, index);
-- 
2.55.0

