Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5318408018;
	Mon, 24 Aug 2026 11:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787571185; cv=none; b=aJMA8Ezd1DUuXUktNSClAJoYRkJ/MRT5rPDIpxxo3BPNgFNlcSmDBYNAogBi1bA/znBhz34P7xBzO5d9bB/Ohg+E9cnc09t77XDWfjyrGjChROfb4lr7PeuuxnA854dR12NqQBIx7aLZXueo+ZUcpANTBduEGK9LT+PwlFwFs74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787571185; c=relaxed/simple;
	bh=gcpwUycV3lGQazWxKBNmeDjHjQOL/EjnX5TWkAUhnEo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XEcUIbkzc1m+8DFY9SD0p2vYTuK490Jdm3ctwiqqnZ76KWzvVqWiAVCYqKwZQRrRTxwPWz099LcBjdVDDde0/uQ5hUihibPZYCJci43VreTJzbafiNNjZWz+3bRO0fMA6OBLV7gh8YxD29oEW9pDtJ23eNAO5f6VQAV8DeBj5Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=jb6zbs0j; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="jb6zbs0j"
Received: from PC-202605011814.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 4b1a0b4b5;
	Mon, 24 Aug 2026 19:32:54 +0800 (GMT+08:00)
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
Subject: [PATCH v2] scsi: be2iscsi: use rollback index when freeing MSI-X vectors
Date: Mon, 24 Aug 2026 19:32:46 +0800
Message-Id: <20260824113246.2235666-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260824092712.2130707-1-runyu.xiao@seu.edu.cn>
References: <20260824092712.2130707-1-runyu.xiao@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa0338b7c9603a1kunm75b9fa81226697
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaSUwdVkpMTk4aHkJPTxlNHlYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSE
	pPSExVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=jb6zbs0jrj4LjTTSNLskm0p9355/0tLXMaBW82PqpPyeUcKgA7V7dFAY+CY88ACqw7MJ9q5JKB8QnZBVg7MxI74d5Y2wSTUmJMz9kTtKNI/yv/DMUzvPk5SAmueMWReeODwFUD1uf23tUn7bOg8SyMUmvZRf0lSNN0iE0OF4e/Y=; c=relaxed/relaxed; s=default; d=seu.edu.cn; v=1;
	bh=O0L3dxum/kFijaa2cO72W+QTj7ZW1WTIbRjJOMXc59g=;
	h=date:mime-version:subject:message-id:from;

beiscsi_init_irqs() unwinds previously registered MSI-X handlers with
free_irq(pci_irq_vector(pcidev, i), &phwi_context->be_eq[j]). The IRQ
number should match the rollback slot j, not the current loop index i.
Using i passes the wrong IRQ/dev_id pair and leaves earlier handlers
registered on failure.

Use j for pci_irq_vector() in the rollback loop.

Fixes: 831488669a33 ("scsi: be2iscsi: switch to pci_alloc_irq_vectors")
Cc: stable@vger.kernel.org
Assisted-by: Codex:GPT-5
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
---
Changes in v2:
- Use the mainline Assisted-by format.
- Keep the commit trailers contiguous.

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
