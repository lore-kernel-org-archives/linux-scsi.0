Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=101.71.155.101
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794927090;
	b=vWA/DzZcaLibFUAVBpPrWKxBBH4Pxu/5htsi514Zr5BBDTAVo8CcUnjQsuiWRI6x/Y2I
	 iMV57dEJhwHW7gubtXgZV0UkgokHDa+tD5DLayYw9wlsNE7nCuYnam/v95iX9HcJEMJzn
	 D51pCon0aEHOhc/rYvIw4BZ1lOTFx5Xe6cabWCQN24lBnz2jKAOIUFm1/a1VQ2mInl89z
	 DPSng3aM46lQZE0NmbSkoAAl4Y3W1l8wDn9jEBpo6Bn6kiqxFXdA96kXGWW3142nQ7q5V
	 yC/S/qTvJVahcpp0XjKyAyYld+Y+XegJ2S5TWBdsEirHsuN4lVaN9I28GaxZcdO9SqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794927090;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-HM-Tid:
	 X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=GJZQLR6mwp7b314RltwFULXw871Y8jBCZY1gD9pQC+c=;
	b=F0dwznk5GPHenxN9f9JqBfUcuvAuL5wExNTafGnpzer9SgocvfZsSOnojH0bv6/eUu/K
	 mANWaEE3IWF/8oypnvpfato9bIOlYuvlwFz0DAs+NhunSzp1yMygJs1iq3+UU0PCKBMus
	 FXSizfKB45lLhOETYDpZNZ1Zb8zbWBlXQCYavA1lJJCUBM7D1Mz7BR06nFYotZHgojAlQ
	 5ahVvX0vme4Cob7d5ZaFfreOpgCMBwN9espkzzHwVGJ2/0bsTx8vOPLQyskYbWriLKtAT
	 vlQGZDyZKaOakVNKhy/XjKlSVqeZ8ZpAHc2y25274uOjU7VgdezwzCeh0qc6cLOehHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=KlDHYMBD;
	arc=none smtp.remote-ip=101.71.155.101
Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19B9606A31C;
	Tue, 17 Nov 2026 14:51:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D19B9606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=KlDHYMBD
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 55020e829;
	Tue, 17 Nov 2026 22:51:24 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: arcmsr: Fix potential DMA leaks on XOR allocation failure
Date: Tue, 17 Nov 2026 22:51:23 +0800
Message-ID: <20261117-571e631490-scsi-arcmsr-0@mail.sdu.edu.cn>
X-Mailer: git-send-email 2.43.0
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0aa1e9fdc39e03a1kunm516bdf19156608
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkZGkIZVk0ZHUpLSUpCGEtLHVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ0
	NMVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=KlDHYMBDb3atWX1pLZbfRxVeWoOHhF8+j1I0Z6pBnNaUxDpDUzmUz2ynyc3giNeSPew+lTkhakzqNIKc0Z/+gljc7A5sPGi087qtpcMD2MSxq9t9gYBYSO9TOh8cuBcjI//XM92dWJilWiZVT5l4vA7Vycw+5Fwrlev9YYiegnU=; c=relaxed/relaxed; s=default; d=mail.sdu.edu.cn; v=1;
	bh=GJZQLR6mwp7b314RltwFULXw871Y8jBCZY1gD9pQC+c=;
	h=date:mime-version:subject:message-id:from;

XOR allocation failure is returned after the CCB pool has been allocated,
but probe skips pool cleanup on this error. Free the pool before returning
and handle a failed XOR header allocation without dereferencing it.

This issue was found by our static analysis tool under development.

Fixes: 14ef4b001ae7 ("scsi: arcmsr: Support new RAID controller ARC-1688")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 8aa948f06cac..52caa800397e 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -771,6 +771,10 @@ static int arcmsr_alloc_xor_buffer(struct AdapterControlBlock *acb)
 		(sizeof(struct XorHandle) * acb->xor_mega);
 	dma_coherent = dma_alloc_coherent(&pdev->dev, acb->init2cfg_size,
 		&dma_coherent_handle, GFP_KERNEL);
+	if (!dma_coherent) {
+		acb->xor_mega = 0;
+		return -ENOMEM;
+	}
 	acb->xorVirt = dma_coherent;
 	acb->xorPhys = dma_coherent_handle;
 	pXorPhys = (struct Xor_sg *)((unsigned long)dma_coherent +
@@ -895,8 +899,10 @@ static int arcmsr_alloc_ccb_pool(struct AdapterControlBlock *acb)
 		break;
 	}
 	if ((acb->firm_PicStatus >> 24) & 0x0f) {
-		if (arcmsr_alloc_xor_buffer(acb))
+		if (arcmsr_alloc_xor_buffer(acb)) {
+			arcmsr_free_ccb_pool(acb);
 			return -ENOMEM;
+		}
 	}
 	return 0;
 }

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
