Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFEB62673AA;
	Fri,  2 May 2025 06:49:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746168584; cv=none; b=jeBWDRtOMU70+H1qBBU8a3YuqlSOSFkm5U7O+LbtL8BGJ6aK0UhSOp8ZcrDRYd76QACW/SpxpumSyiAJ3gmeveoSsNG3dYsiSAy0kKzd1OQy+Gv3YMysAhFkUtMddRTMzYD2YI0Myi6oe87db5XF7ngR2SDlM1sD462hdJ4X0I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746168584; c=relaxed/simple;
	bh=1gnX1QA5x1CbNNvUCSaL1CXeaUCWQ2ixuIV8q/VIwFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R5lHw4KJeUVASU+CVR2RLdLjcSMd5hzT5QpPMMplWOnet2GaCSW7VanH2QvnGqYahZ+/6P1vMLQTjRP8DIUtDfmPgreEWyA6uX0JTbava90X4WB7GQthBAbP/ktcgJtOdPq7sDuhR88AZiyy4gwg0zwzTpbfdnuUmtiVjPZ733c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cq5A0S9D; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cq5A0S9D"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=A6DrXylWbVeQmEZpWC9MNkt93jfH/DDfytNjBqDDC6k=; b=cq5A0S9DU+QGEIc391X3rxPhCY
	VsNmADB8cK1MegtAak5kcEjgZ93dVa1+qFn4zhfi7dR6A2k/hnFzYk4V45WE2bFbVdIqCet6cpP4Y
	8CbwwbmlUdfYxIEwFKN5gfWQ/Vw1lAvsoiNb5e3xgOJ8YUN4WHeaev5bckZf5RxkQKN+0+Lyy9Mck
	Vs8Nd2AhxEXRCOE06l8EFtkpXJ/VYYkHIdoUcLvRBAO4rFTgxVXq/5pAMNOgjlT/05Gm7gf6g9oXI
	HLlwInsEMmsnDbMc2sjlVHmq1+xZcBcQxKENaWx2mj0oSekouaQdKa18YZ4k2ONELJgsphN5QXh9w
	oR2XB6wA==;
Received: from [185.143.37.16] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAkDN-0000000114T-0K28;
	Fri, 02 May 2025 06:49:41 +0000
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
Subject: [PATCH 3/7] scsi: make ppa depend on !HIGHMEM
Date: Fri,  2 May 2025 07:49:20 +0100
Message-ID: <20250502064930.2981820-4-hch@lst.de>
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
 drivers/scsi/ppa.c   | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 82e0b7eaed4c..5522310bab8d 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -796,6 +796,7 @@ config SCSI_PPA
 	tristate "IOMEGA parallel port (ppa - older drives)"
 	depends on SCSI && PARPORT_PC
 	depends on HAS_IOPORT
+	depends on !HIGHMEM
 	help
 	  This driver supports older versions of IOMEGA's parallel port ZIP
 	  drive (a 100 MB removable media device).
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index a06329b47851..1ed3171f1797 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -1104,7 +1104,6 @@ static int __ppa_attach(struct parport *pb)
 	host = scsi_host_alloc(&ppa_template, sizeof(ppa_struct *));
 	if (!host)
 		goto out1;
-	host->no_highmem = true;
 	host->io_port = pb->base;
 	host->n_io_port = ports;
 	host->dma_channel = -1;
-- 
2.47.2

