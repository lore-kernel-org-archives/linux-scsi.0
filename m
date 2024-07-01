Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	(using TLSv1.2 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1691417BA1;
	Mon,  1 Jul 2024 03:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.226.251.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719805292; cv=none; b=OT0fo8/N2nUtVUsu9ZM/0Vyasg+79Mum3i8NunqpwCsrY/TF/NTQIdmUYzy/tA4qttbFok4TyUNi5QWTtvmhulRx1AiJf0bKpHzR4YUiHoy9PIGTRCWTg+XBvTd2PqLNGu26reYfv0MA1TQkjt7VzHRrqK2+zoO6nZtOdjQcz+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719805292; c=relaxed/simple;
	bh=vMp+dyWL80ubrUBPhCbTqoAKprQN22XbrirW9ZAPpVQ=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=oBdp391tgwWw0STjrBdl5MiMnRUCQUVPWkGOaXIGi4HxDoZNqiAQCPNua0ndRK2mjOtz/cQ9GXjvotbBYutuTzb7BAPrpLw6AwW4PL4yZ1HSGjvkO9jQM785bANd1ZcaX8tfGkL6G6iElviladD/1/IldyHT2fRKdS6iUKuHm+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn; spf=pass smtp.mailfrom=iscas.ac.cn; arc=none smtp.client-ip=159.226.251.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iscas.ac.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iscas.ac.cn
Received: from localhost.localdomain (unknown [36.112.3.229])
	by APP-01 (Coremail) with SMTP id qwCowAA3F0xRJYJmCrbwAA--.6578S2;
	Mon, 01 Jul 2024 11:41:19 +0800 (CST)
From: Haoxiang Li <make24@iscas.ac.cn>
To: kashyap.desai@broadcom.com,
	sumit.saxena@broadcom.com,
	shivasharan.srikanteshwara@broadcom.com,
	chandrakanth.patil@broadcom.com,
	James.Bottomley@HansenPartnership.com,
	martin.petersen@oracle.com,
	usuraj35@gmail.com
Cc: megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Haoxiang Li <make24@iscas.ac.cn>
Subject: [PATCH] drivers: scsi: megaraid: Add missing check for dma_set_mask
Date: Mon,  1 Jul 2024 11:41:02 +0800
Message-Id: <20240701034102.84207-1-make24@iscas.ac.cn>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowAA3F0xRJYJmCrbwAA--.6578S2
X-Coremail-Antispam: 1UD129KBjvdXoWrKr48XF4xGw4kZw1ktr4fZrb_yoWkXrbEg3
	y2vF97Krs8tr1vk3y2krWavr9Yg39Yv34kuF1vgF92gFW7Aw1DG39xXFnxCF48ZanrCryI
	yw15KrZ5Ar18XjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUba8FF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6r1S6rWUM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
	Gr1UM28EF7xvwVC2z280aVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Cr
	1j6rxdM2vYz4IE04k24VAvwVAKI4IrM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
	Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVW8JV
	WxJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI2
	0VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcS
	sGvfC2KfnxnUUI43ZEXa7VUjiF4JUUUUU==
X-CM-SenderInfo: ppdnvj2u6l2u1dvotugofq/

pdev->dev cannot perform DMA properly if dma_set_mask() returns non-zero.
Add check for dma_set_mask() and return the error if it fails.

Fixes: ec090ef8cd1c ("scsi: megaraid: Remove pci-dma-compat wrapper API")
Signed-off-by: Haoxiang Li <make24@iscas.ac.cn>
---
 drivers/scsi/megaraid.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 38976f94453e..5ddcba488c89 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4406,10 +4406,12 @@ megaraid_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	/* Set the Mode of addressing to 64 bit if we can */
 	if ((adapter->flag & BOARD_64BIT) && (sizeof(dma_addr_t) == 8)) {
-		dma_set_mask(&pdev->dev, DMA_BIT_MASK(64));
+		if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(64)))
+			goto out_free_mbox;
 		adapter->has_64bit_addr = 1;
 	} else  {
-		dma_set_mask(&pdev->dev, DMA_BIT_MASK(32));
+		if (dma_set_mask(&pdev->dev, DMA_BIT_MASK(32)))
+			goto out_free_mbox;
 		adapter->has_64bit_addr = 0;
 	}
 		
-- 
2.25.1

