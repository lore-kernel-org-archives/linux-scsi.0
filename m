Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE25332AAAB
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 05:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783056671; cv=none; b=sLw88k++G0VXs8/erajGZJp8o6LJ1WoQ3GtVXYBYkIJQfO1ABtyGQ40kWt/Tsaq/K+XRmIm9OKn+a94spDSdWQmOHhH/SnjJybCoEHPjMul47ES4VaWPtY1CUqoocE1xnXSkZplT+s1fDMyR94PzybQa3pey8DsEvEicAavcMCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783056671; c=relaxed/simple;
	bh=EVsd5R4n8qmiKpGB31F1gBRP9ljOAI6TBo2L1w5GtRg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AbSn2gUh2c0GqVumlQwfGNJT09p4jNSurZUCRkBdEmuuhOUsCHOWc8A372KukvjrbI0QdUDfDM3MT5hqPEAmBkMfYtKxBUUp+cpLY8Ma9X2JaX0plouGfHXyNcbbiUSMyHDh6FQspTffMZvaAX/qGU3TMnbEWUWRuzdn1LtNV5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gm5FA8Dk; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gm5FA8Dk"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-51c2b2c9eccso1240171cf.2
        for <linux-scsi@vger.kernel.org>; Thu, 02 Jul 2026 22:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783056662; x=1783661462; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yqInNBGyRxbMZkLQX5g1lE2UKQnsvWWdzJYoQnv3Yuk=;
        b=Gm5FA8Dkp6Cbg0g1f5JjgBDkzUvMHMg3N1b4I6fLWZb6lAdZe0LGbCY6lHBASGCjRZ
         GGshIQemOoO6D3wHYrc2BQp44bYb6kbyeXkiPpW8Z2bGNwbCFhr5pz6PdDlC/tEydRQ/
         FG+QqC2N9W2KWs5kL2lUnXppjYHCYV6+3mUufR5am0vHzUgSUZTt7ZCKQS5gWBeEDUs3
         w0vmxwxknFixY1ZUHu06psq32x7hNBXEH/e/OpqxpPs4NjR5Z5at0xhO8dJmnTYZAOa0
         gQTPdzNX07JHXBwiqigfvHHhseurr516PoHCHiwr1yXOsCXvtWyph5+5PiqQTqv2IFDR
         pazA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783056662; x=1783661462;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yqInNBGyRxbMZkLQX5g1lE2UKQnsvWWdzJYoQnv3Yuk=;
        b=lPTkHt1c+McA6+FBmcswWpRpluJnW6pKlPsRUl1NFVDMRkHn0739iRfezGvlXyW0Ip
         Ud5GzZ+IG+TIzGSOI2flMe+0ysMVo+T7h5/2ytL086dljdopROHKmsufrvLfsIMGqdGr
         wruHvHNG61EsZiy3S0rmHdqkzMIg5I3Ll3ISTdMea/6w8XANBrrPuocX95u9Rb9E1qcS
         Ce0yATK6mmpdL7VN5kMXA4Q7B7Nfycw9SpLZomGydlzLLx4/eUJuxoTniA3+gDdyGBsJ
         gaIFwwMjUct5Pte4Lr1QQQo0nJE0/NZHURrVMybz52mY9sudKJCbI4BAAVCBEWlW0DTq
         C2Pw==
X-Gm-Message-State: AOJu0YxXa9qxKUc8NQKWJ5NzYKWRvZD89QPEFDpykYfIj5v8p3FeAu3o
	AkQn4spQA+4ayD+AMcupuEyjwXuWImpksj0XpvYeOXBJ4qEOAFW5tNJC
X-Gm-Gg: AfdE7ckwQInPet8SlV/OyYGDXrRuRCOg6Bj3i89QlflbRsD+gezt1bQhn5f/QXhGVnD
	FYvUGMhqCAgmyfaddPzXkhaHoVjVRrvnKlHdEpo0XVXXOvCJAIvDJiGID5zgok84udaMMrJs9+i
	m0eVQL+cfcDhUQnDvBCzdkBhEPVtTNLnzQOSh8V68AALBPdScZdKYK7CVR+2SuWjJ8wUMFjyqw9
	uiWVsG6EnBeEbdFGIgYYt0l+wQtMFx7m77NA+sPnaIKRxeiSOhAMA+jrCcv+yGDJtU9MI3HHuq+
	Ec8utDNG4rjzk7aKYF7HUOD6h2fWFBnuOgv6RRCWqq+zq9mr2E3SvFHsN3z4oCuaQF5ONZm/wJn
	WxWFuHyUiV2vKWl+e6sr2Q991ppGuNQSJx5J4uek4mScnI78IODhzT/5G8rlutrNoUsa2XDkkPi
	oCR124YBaTpHxcNv+OgMQF21O34dRmfjMOcijSg6MzRXo3CVLkkF/yZS9NjmhMCdv7/ynVbtBIQ
	wFE7jRivdJYGD0=
X-Received: by 2002:a05:622a:1812:b0:51c:1967:5091 with SMTP id d75a77b69052e-51c26b15334mr134510641cf.41.1783056661912;
        Thu, 02 Jul 2026 22:31:01 -0700 (PDT)
Received: from i4-gl-tmk5904.ad.psu.edu ([130.203.156.186])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51c41abe756sm8570361cf.6.2026.07.02.22.31.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2026 22:31:01 -0700 (PDT)
From: Yuho Choi <dbgh9129@gmail.com>
To: Ketan Mukadam <ketan.mukadam@broadcom.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yuho Choi <dbgh9129@gmail.com>
Subject: [PATCH v1] scsi: be2iscsi: Fix MSI-X IRQ unwind on request failure
Date: Fri,  3 Jul 2026 01:30:55 -0400
Message-ID: <20260703053055.141337-1-dbgh9129@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

beiscsi_init_irqs() unwinds previously requested MSI-X IRQs if a later
request_irq() call fails. The unwind loop walks index j, but passed the
failing index i to pci_irq_vector(), so free_irq() did not use the same
IRQ and dev_id pair that was registered.

Use j for both the IRQ vector and be_eq entry when freeing previously
registered MSI-X IRQs.

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

