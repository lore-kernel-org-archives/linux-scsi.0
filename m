Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 798C1178392;
	Thu, 27 Jun 2024 12:49:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719492584; cv=none; b=kOAoYt9YqFwI243f7uH13uztpYmPT9uf2/9joiJJJQeHY3qYz6cXF2xjBDv/rRuHPvw0NQbvRSm16zZaU1ApdzGRc0HKal2GDLGhXUQMFwl1GbBJlRV2xNIjbsQVid80c+eDM+A3Oz096hRBhogRHmffzqnE7Ld9oIzQX4FEm/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719492584; c=relaxed/simple;
	bh=UHFHzOb5qpOxVBL+hmh63JeGT277CvQI4Lu1JzOjC6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GPJg+4hJQnP7/Ij6+HpoDAMH5bj1s2PX9EZzM8xMzzuw04oGuQis9cc223I8xZ/0tpVcGwitCCr9NMwEj0J5BJsGiirzuPXh/zVYCc7OXpmrnoIwIkO1n+NPzVbg7BPODe86EbhncTxPk91oEYEuJlVl+SPtm3KFrDwYCy1XwvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ldu5v32+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ldu5v32+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HTutOlPUlfHJUk/Qi9Nn5kjF/ytHNXd/sRMVmjFuq10=; b=Ldu5v32+LvAimqVHMOIC+jvTgU
	kZzq3Cu9QVNU7pqVdBMppNi4iuVE/GU/FwpaIonDW/5j3cwaOGGLoCaXXeZcRHRqdNogwP/6zYL8I
	Tr9s6nElogSmgOnbFSvbZdGMd2eqowvWvSU1ea5YJUFNxl8mlUdXBXhMer3N6U+gX/89saEfRjB9z
	8sy5/MfymWroZh9REKxJgOmr32nyxIoDqQQJvwnTN2ifSxnA8JGZWH4mYQqXqLjW/fx1cFgiTL2b6
	vLKT3xk8rVnajATQvui/m+g6+1kSKVheeUXOP8WIsNJsdukOXNMLTW4QsXQKfLv2cnQWfKgtZvg4K
	j38pxpvg==;
Received: from [2001:4bb8:2dc:6d4c:6789:3c0c:a17:a2fe] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sMoZJ-0000000AN31-1aeW;
	Thu, 27 Jun 2024 12:49:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>,
	"Md. Haris Iqbal" <haris.iqbal@ionos.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	linux-block@vger.kernel.org,
	megaraidlinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH 3/5] mpt3sas_scsih: don't set QUEUE_FLAG_NOMERGES
Date: Thu, 27 Jun 2024 14:49:13 +0200
Message-ID: <20240627124926.512662-4-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240627124926.512662-1-hch@lst.de>
References: <20240627124926.512662-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Setting QUEUE_FLAG_NOMERGES was added in commit d1b01d14b7ba ("scsi:
mpt3sas: Set NVMe device queue depth as 128") without any explanation.
Drivers should second guess the block layer merge decisions, so remove
the flag.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index 12d08d8ba5382d..b050aedc9d4334 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2680,12 +2680,6 @@ scsih_device_configure(struct scsi_device *sdev, struct queue_limits *lim)
 		pcie_device_put(pcie_device);
 		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
 		mpt3sas_scsih_change_queue_depth(sdev, qdepth);
-		/* Enable QUEUE_FLAG_NOMERGES flag, so that IOs won't be
-		 ** merged and can eliminate holes created during merging
-		 ** operation.
-		 **/
-		blk_queue_flag_set(QUEUE_FLAG_NOMERGES,
-				sdev->request_queue);
 		lim->virt_boundary_mask = ioc->page_size - 1;
 		return 0;
 	}
-- 
2.43.0

