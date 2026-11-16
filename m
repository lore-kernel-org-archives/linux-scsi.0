Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.254.49.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794839318;
	b=kYdzdyjHquBCTrc+Jl2RlAPlGFnLUZlenFsGsOLQyWFNbcqGQst6rqoU6aTSuPASRTbN
	 S1Fiv/gIyfrVoRLnxl6ghbn4GMA7puAH1gz5bCkegTAAXNVya7TbEZFZGUxuwSrGjVbCW
	 bv/WsXr6GmxW8UzuSkLbYvFXU2oqnDvSvbfrclcz+g8HeEFISU4Jv88WrR7sv+2m2urCW
	 UkJkxaAq8UbKw1cgbAlui6/Wl75gmFWPikNJRA2SG+a4HOydbqZfLpuQJoIcaqalkReeH
	 bbLggl4gBT2o5f4fdxbTyn/koAOBb0o63AuOuc1VeHTeoePSpRzP5ChFd+tC5bsf7dw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794839318;
	h=DMARC-Filter:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-HM-Tid:
	 X-HM-MType:X-HM-Spam-Status:DKIM-Signature;
	bh=UKqiUGxrKn2iT23S+4PGgCaO6FGJYg2YRkHi0bASi8Q=;
	b=yLHfden3aeti3VbTFqD+w1ZrkCYAQPwgIR9b/eVy8njZzcNu942hyLYn3ey58Xu4qK+F
	 HjmHvNk/cbGfIW/PtqNCaZRX50zNKBl4INXbp7p5S65y4BLNQ3GuIeqPhioEZN1e/6Ciq
	 CN6nKL+BI0iiYIack17iT1L+5tEbex6KbacNQ4DZuu6YO1EHYDFWs17ihfIFJKNKyWQ70
	 yn5FDbvx5VsQFrGmOc57SBxXq5rqmxYgLijbxGbtCpIejf+LwUHGaR6j4IWl+PYCpbuiw
	 Aa1fgiGzRHIiXGOhGO7FvgTczPhCooOc2ypvkJS+/Wb24P73s4giYobkaoW87T25UkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mail.sdu.edu.cn;
	spf=pass smtp.mailfrom=mail.sdu.edu.cn;
	dkim=pass header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=L1vKLqQA;
	arc=none smtp.remote-ip=45.254.49.198
Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE17606A32C;
	Mon, 16 Nov 2026 14:28:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5AE17606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mail.sdu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mail.sdu.edu.cn header.i=@mail.sdu.edu.cn header.a=rsa-sha256 header.s=default header.b=L1vKLqQA
Received: from lgs.. (unknown [101.76.249.61])
	by smtp.qiye.163.com (Hmail) with ESMTP id 54dbcb501;
	Mon, 16 Nov 2026 22:28:30 +0800 (GMT+08:00)
From: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: wd719x: Fix potential firmware buffer leak on probe failure
Date: Mon, 16 Nov 2026 22:28:30 +0800
Message-ID: <20261116-c29ba55625-scsi-wd719x@mail.sdu.edu.cn>
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
X-HM-Tid: 0aa1e4c271e703a1kunm71f51ee310e7cb
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDH0IYVhlMSUIdSU1DHU5KGVYeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlKS0pVTE1VSU9CVU1KWVdZFhoPEhUdFFlBWU9LSFVKS0lCQ0
	NMVUpLS1VLWQY+
DKIM-Signature: a=rsa-sha256;
	b=L1vKLqQAVQBaEe+2UdK/2pXp89M7Yb4eE66b3+bl5ULSW2m7jbNESUym6mANe24PfAnT2CH0u+D7kheJrc9MeRmloH3jcwcVZUR6zkq5qpNFgfOYIoIE1DYD1JuoJPQaMEiHuzqpwYfl/BxWC0G/Mns4Gow3X3tXdWFP8KgVnMw=; c=relaxed/relaxed; s=default; d=mail.sdu.edu.cn; v=1;
	bh=UKqiUGxrKn2iT23S+4PGgCaO6FGJYg2YRkHi0bASi8Q=;
	h=date:mime-version:subject:message-id:from;

A failed chip initialization leaves the coherent firmware buffer behind
while probe releases the host. Disable the RISC and bus mastering before
unwinding the failed initialization, then free the firmware buffer along
with the other internal DMA buffers.

This issue was found by our static analysis tool under development.

Fixes: 48a310300663 ("wd719x: Introduce Western Digital WD7193/7197/7296 PCI SCSI card driver")
Signed-off-by: Guangshuo Li <liguangshuo@mail.sdu.edu.cn>
---
 drivers/scsi/wd719x.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/wd719x.c b/drivers/scsi/wd719x.c
index 85cf6c9d2ec9..53c5a702ddd6 100644
--- a/drivers/scsi/wd719x.c
+++ b/drivers/scsi/wd719x.c
@@ -868,7 +868,14 @@ static int wd719x_board_found(struct Scsi_Host *sh)
 	return 0;
 
 fail_free_irq:
+	wd719x_writeb(wd, WD719X_PCI_MODE_SELECT, 0);
+	pci_clear_master(wd->pdev);
 	free_irq(wd->pdev->irq, wd);
+	if (wd->fw_virt) {
+		dma_free_coherent(&wd->pdev->dev, wd->fw_size, wd->fw_virt,
+				  wd->fw_phys);
+		wd->fw_virt = NULL;
+	}
 fail_free_hash:
 	dma_free_coherent(&wd->pdev->dev, WD719X_HASH_TABLE_SIZE, wd->hash_virt,
 			    wd->hash_phys);

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
