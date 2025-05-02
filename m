Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C9D266EFA;
	Fri,  2 May 2025 06:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746168582; cv=none; b=FlVOKVt1t6HnaVdPXEa+KmC4HzjJrs9LF/Gr72DfoPsJ8h7hbhKKxVcqRZx7Rgl+Rmk0q72iajlqugMWXxi7zDUD/peila76ML6ZKFFTO/I39l6OjqRFBhpSMY7ZJzJwxi5t1iaUiM0+VlDgaUOvizdvY8NiTcldhmSrJE6I0g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746168582; c=relaxed/simple;
	bh=TDWwbf0uqY/94U0tZm0Q4m04byu6VTjm8Zj03RsiP4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qymgZ9bGDtYBrf6pQVDrHRx5Lu0JLPPjFQGkfJTlLf+pj86uezDcgkjnFtl+xEFdtJBZyuWuSgMBMdiaGSF1rDx4UQIppOzz3DPiaFxAKZa0UcovF7aZG+xFe7IOS+t88PmFJAL9YyrO197b0MfIYSZaWH6I2M71SpzVGlUZDKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qCSaUfho; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qCSaUfho"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=78GG8S2TAx+d9AuPIDGtXdRBSe6WPG5mzOlHyWW34d4=; b=qCSaUfho2PWsAdADijUki/30RZ
	ckA7gRLsxhHXtknRKnt5hLyMs50X/8jYIc03ad3YP/euaqPi4hdj0CIJLeNGT3VwWhG+D/8EtajH7
	NfCwjkTw9J9xD4aDBLF/uUMYA+Y4vIYJ2SGIbyokKCGxmyWD9HTP90Jak7K0zOqs+yaVahuoGViTJ
	QNLEASIdJ+wmv1G1VvU6ND/+AELISDF6HbCiePNH54M0SN6dW3/O7rcd1qYVAQLEuLEQxyXlMEe7W
	qdS76xaIWH9dVo/kIeFqcBlmwxY+ZT8soWtjC+7ftkKszmHAyoWRMn/UZXXyYngwKAikooDbd6HEI
	w4tgJ7sQ==;
Received: from [185.143.37.16] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAkDK-0000000114E-2irk;
	Fri, 02 May 2025 06:49:39 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-mm@kvack.org
Subject: [PATCH 2/7] scsi: make imm depend on !HIGHMEM
Date: Fri,  2 May 2025 07:49:19 +0100
Message-ID: <20250502064930.2981820-3-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250502064930.2981820-1-hch@lst.de>
References: <20250502064930.2981820-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

This is one of the last drivers depending on the block layer bounce
buffering code.  Restrict it to run on non-highmem configs so that the
bounce buffering code can be removed.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/Kconfig | 1 +
 drivers/scsi/imm.c   | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index c89e6991e934..82e0b7eaed4c 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -823,6 +823,7 @@ config SCSI_PPA
 config SCSI_IMM
 	tristate "IOMEGA parallel port (imm - newer drives)"
 	depends on SCSI && PARPORT_PC
+	depends on !HIGHMEM
 	help
 	  This driver supports newer versions of IOMEGA's parallel port ZIP
 	  drive (a 100 MB removable media device).
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 1d4c7310f1a6..0821cf994b98 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -1224,7 +1224,6 @@ static int __imm_attach(struct parport *pb)
 	host = scsi_host_alloc(&imm_template, sizeof(imm_struct *));
 	if (!host)
 		goto out1;
-	host->no_highmem = true;
 	host->io_port = pb->base;
 	host->n_io_port = ports;
 	host->dma_channel = -1;
-- 
2.47.2

