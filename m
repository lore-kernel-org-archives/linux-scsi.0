Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C53411E492D;
	Mon,  5 May 2025 08:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746432717; cv=none; b=HFN23y5S21oPSBdP0S1QDbHpXJSr8UxVEYnCoEhAPiGMA6CjEExx2uwY8pktVwML2fOTG5wp6QrW5f/+Z/q4pEVQdfCZUsE4ny9kMXcpn8vGv9kM/PFPzKbvfJc6DnhU+4g/WxYFyuQ5bl2tlP704bK8HyWfFLYx1VPf4zLDYP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746432717; c=relaxed/simple;
	bh=tyfmDu5RrzffKFNQcLgFbOa6tMwHBnGv88RxwnSg0T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoN+nzW8X0lozh59pI4aLK7X57IJ9bH5ZY6plD7Aka2iyjq4dc/1PEef/bjqcCapCj6ZDzXFhvifC0zQuPSYmUY2YyLXfqcyZ1E4IZNZkhngFIA0fCgMg+RQXSdxMlO3rhPNoUjnkD+4tMDEsqGTk5ZCGQkIsLuEVTfoJnNYfzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uObhKkX7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uObhKkX7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kDizabCCdyxATU2dAD2Y+usEvCItNB58jVxVeM+hLcw=; b=uObhKkX7At4AvsencfrX7YgoFu
	6FmMzb0W3bP7dDCfc6XSNvnt42ntFFqiHuXbkITE18e5n9sH3wleToP6s8jpsLMAj1YVAEBxq6A/G
	tneiLWJdcNJYLWUYXHjneumOOs09EfldhcxSVDzfeJhjCxOYsXjfNDTHpgjUTjAc5A5OS3wLFK01a
	AwzOJlwJ53uQxZrcWSMribfZFl0n2bmL30nhJEtcuJf9MZ77zdwwlmyiVTEdQJyMSSfzo5XlB+e6D
	lcsa/vD3hxtXaY1NfH1XoerPXZ6kELw9Xfl7Zwaau91ZNertkfJlLdYh3YK0lOnIeheMLcMrAuHjI
	CBij4OsQ==;
Received: from 2a02-8389-2341-5b80-f2ef-69c9-6274-23a2.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f2ef:69c9:6274:23a2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uBqvY-00000006kUY-2Cre;
	Mon, 05 May 2025 08:11:53 +0000
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
	linux-mm@kvack.org,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 3/7] scsi: make ppa depend on !HIGHMEM
Date: Mon,  5 May 2025 10:11:22 +0200
Message-ID: <20250505081138.3435992-4-hch@lst.de>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250505081138.3435992-1-hch@lst.de>
References: <20250505081138.3435992-1-hch@lst.de>
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
Reviewed-by: Hannes Reinecke <hare@suse.de>
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

