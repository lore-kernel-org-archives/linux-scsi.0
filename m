Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C217E374721;
	Mon, 24 Aug 2026 09:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787563650; cv=none; b=C17R4ppeNxX42lItN9tgbM6NdAok0+HScHFO8d9i6BTZkaZyg1Ujzbg/FwSsksU0usw76uINS90yYQy/83rsCKz7C49wej+VTamov0H2kXsY47rrSJDYmb03vzRv0rrnpt5Ft6zazMr82ynqzfiL0W+Fua6+P2F4v3WNtQFxM58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787563650; c=relaxed/simple;
	bh=GRLX+6tso0vn1lN2knQF508zAkrd6TBT1uRvek18uXY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=IwSWVaNOVq/Txt0c7WaVvetKCKuOPvbC8krgu3UwcqQbxoMioAlaiW3vwtO4ey32RqJAHPC6piR5kw757SjqIlEdU7X1JxIv0pZIEao1bVDZ9wcjei6pS5WwmjC1KoNR/IMM99sSEBOJUN8Mm/DPCbUmneiMLJOM8pkgxxTG72Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=iXgjOGyP; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="iXgjOGyP"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4b1541157;
	Mon, 24 Aug 2026 17:27:20 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Ketan Mukadam <ketan.mukadam@broadcom.com>
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH] scsi: be2iscsi: use rollback index when freeing MSI-X vectors
Date: Mon, 24 Aug 2026 17:27:12 +0800
Message-Id: <20260824092712.2130707-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0331887fe03a1kunmdc72b57b2214c8
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSE1KVh0aSR5CHh9CTE5LTFYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=iXgjOGyPfygRlHiQSz+ZIUrKnPcSTDfYC084Zb28FcDAjK21q7xqVLmwlpbazFAAVesq6VrqRVqbHk+X70ipasgMuJ82IVF+LEFff8cv96xAnRzBASHOg8BzzuGqiE4Feop/4WM2wSpGAnqPhG5kG6wCLoFIkCdMTLELKe6/+GY=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=cpwwuB054qch+Bx3kSctzPH/R0KmOVsCcrE0n6wBU8M=;
	h=date:mime-version:subject:message-id:from;

beiscsi_init_irqs() unwinds previously registered MSI-X handlers with
free_irq(pci_irq_vector(pcidev, i), &phwi_context->be_eq[j]). The IRQ
number should match the rollback slot j, not the current loop index i.
Using i passes the wrong IRQ/dev_id pair and leaves earlier handlers
registered on failure.

Use j for pci_irq_vector() in the rollback loop.

Fixes: 831488669a33 ("scsi: be2iscsi: switch to pci_alloc_irq_vectors")
Cc: stable@vger.kernel.org

Assisted-by: OpenAI Codex <noreply@openai.com>
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
 drivers/scsi/be2iscsi/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index dc88bc46dcc0..3801da1c0229 100644
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
2.34.1
