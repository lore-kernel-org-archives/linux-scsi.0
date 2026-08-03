Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7212F8EB0
	for <linux-scsi@vger.kernel.org>; Mon,  3 Aug 2026 01:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785721356; cv=none; b=GxF3NMLpwk/OSFiGF2d8ZIQdCNXaldfSoq9LEbfS73GmIMXHP4Gs1WFguE93cmxiAPjaxthHuWUwCj2dTeQDVfDL0FP/Ct26DZZyMu8TLrVzRKs+0Jj7ncUpT6DmljPUXR44LZOg8sNdqPQJPMcXDTlWxyUpdd2k123ufAYaEbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785721356; c=relaxed/simple;
	bh=S01THjx3GU4adJn0CGfQrT4Wr8H1w2uxdmBziA3XZE4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Eso1OLp9jA11g/uRyWGqGmpPZScYQblt4NsDLZuVA9nSXIpD7f+h6STfzo6Eer9+LnjT/qIvT2oRRfDKxeuO6PSPq7hLJUbeEQTsoB2PewsYK9y8Xk1nczgwFK9665/0qGrRCJioUZ9G0QZ6DqeuOSou4muN2Hb1zkQwZrYAWdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZpGt1sOc; arc=none smtp.client-ip=209.85.219.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZpGt1sOc"
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8f1e274ccb9so14540326d6.2
        for <linux-scsi@vger.kernel.org>; Sun, 02 Aug 2026 18:42:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785721354; x=1786326154; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=DawTbNdk1LZcBXCoupSLgXbzUs4SU4vadYzb1030Krs=;
        b=ZpGt1sOcEloIGzua3GT9grqvpPKpdOaiI9wB6VlmiyCOIgjn04HhnM9toTVaYn6Qg/
         LKqKLkhsqff2ublpF7+Ibspwky3OlQPjlrNjcDt8Pn3lW+cwRPQoTmFxD4x+HdtMJ3gg
         1+BphU7jJKH5om67dvSl8ErJ58tlMulXWeHstfnDtetDKGR/lPcqdy5NYfOBPDdolUDg
         grBjtA6TqhGTGStUaWHBhULBFh0mhti7edWSbYzJ82dSas6masm++hsbbu6Ngc2NBYdZ
         eBYDHYDcxv1x5YVOcUJHqfXE/A9/YqOH6s83vVJ2A2B7euW+V1mMVD1EMRwyz4/Z6SWP
         wsOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785721354; x=1786326154;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DawTbNdk1LZcBXCoupSLgXbzUs4SU4vadYzb1030Krs=;
        b=Q+FndIpDHVBGP5T9vGUzxa99dmkSaO/soo6aV9NNGN173HJD2HATipb22ZtOUwZsQQ
         kRALE2vUoP3RwnHUG+gtuPN2659ic3eQSzdL3I4NjIV0yiZvndqtGzgZYv6FFFspzcSq
         o0QBhoYDvhhB4MSAQza7BhWoP3Fxe5aXkRSslHjwPb49IiMdFuIrREnyqqYuOHmIN7pB
         r3QmuV0rtj+fRraO8gAy6+K4W/0Cy8mS51Zp5YSxop1tJi4PwP6zhqxpG5eYkdC77LjC
         SdpV3aWHveg8LBx8Qgez3bzwhomUyfejSVXRyR4Jd9ta/CvVCgKu6gqRnN/iW8nXJVA7
         xhUQ==
X-Gm-Message-State: AOJu0YxDFL8eUbYeVnl3IuBsypmNMAzdrOrw8gE6uAXuzI1GV+yuKuE1
	EyQSkz4uQS1oEsElUfBr/POaR/jpsrDvK48n3WaRGiOzJg4E1yBeHKCG
X-Gm-Gg: AR+sD10ZXfMRBNrUxhgib69kAsxBRzpXsnmO1PgvqG2e1mfpcKPW73BMkVA9AdYL/wd
	oS8niTtSNn9RnDk9UZW7o/PLNMDH7+MyvmYqfZavhTkw/8J0G1IfuMMBAnQLCfe5giQ1+n3G4rN
	/9zZOZigGD8pqD0hrR8ONAHTb5dSD2zGdDA6WLRI+T5qYvEsYqfBdq6pRWH7egzcz1p0YRBu92Y
	LJCQ7pJxD2CpByMwxDqgmVkqH26yoATa4PaJ9hSJrn41YfBYXyo1/vNUeZJLLjkhMMFUGhnLlTk
	slAPelLK7kE/yKte0Cesr122Qg5QpKZM1OTJJ79HU9Q4kKoksQPmrTLYz8uXnaaYRxT45FuKP9Z
	RbUx/JeFFYiilkZxymX2H8jkEU+mWmLko5x2/1Ae2UsUT+vliTbhvKFyAJE4vX1tPNgfNCqbBYz
	4wAQvnzOrLFXrG4ELzsTZLsKsVB36dElFFrcMJDf+yxscJ5ObzbCXcKi8HWnsbGzZH1ltXU786B
	xZZCzsHXp8hEne4VlMltLEoj373NwhsPZqWxEMYgNQwMyS32+FTm82KFaZo2Z0=
X-Received: by 2002:a05:6214:449f:b0:8f3:e97:59b8 with SMTP id 6a1803df08f44-908496af620mr181485536d6.29.1785721353981;
        Sun, 02 Aug 2026 18:42:33 -0700 (PDT)
Received: from i4-gl-tmk5904.ad.psu.edu ([130.203.156.186])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908435eab41sm64167096d6.34.2026.08.02.18.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 18:42:32 -0700 (PDT)
From: Yuho Choi <dbgh9129@gmail.com>
To: ketan.mukadam@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuho Choi <dbgh9129@gmail.com>
Subject: [PATCH v1] scsi: be2iscsi: Fix MSI-X IRQ cleanup
Date: Sun,  2 Aug 2026 21:42:24 -0400
Message-ID: <20260803014224.614347-1-dbgh9129@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

beiscsi_init_irqs() uses j to walk previously registered MSI-X vectors
when unwinding an allocation or request_irq() failure, but passes i to
pci_irq_vector(). Consequently, each free_irq() targets the failing
vector instead of the vector associated with be_eq[j].

Use j to release the same vector that was registered. This ensures all
successfully requested IRQs are freed before initialization failure tears
down the HBA.

Fixes: 831488669a33 ("scsi: be2iscsi: switch to pci_alloc_irq_vectors")
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
---
 drivers/scsi/be2iscsi/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index fd18d4d3d219..9833ab06b299 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -878,7 +878,7 @@ static int beiscsi_init_irqs(struct beiscsi_hba *phba)
 	return 0;
 free_msix_irqs:
 	for (j = i - 1; j >= 0; j--) {
-		free_irq(pci_irq_vector(pcidev, i), &phwi_context->be_eq[j]);
+		free_irq(pci_irq_vector(pcidev, j), &phwi_context->be_eq[j]);
 		kfree(phba->msi_name[j]);
 	}
 	return ret;
-- 
2.43.0

