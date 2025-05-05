Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0963915574E;
	Mon,  5 May 2025 08:11:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746432708; cv=none; b=kBZbvMw8SG2Gc2tBXj2OIdZeBOlqMq4UbjfaE9/JCdRYTnSB2k335rlhaAxmLQQjVHqyvlBjsJjrHkfYralobb9LyZZxCOTNYFDvF74X7MdBgRNrxAZw3P4FIpSk5e/QNQq1L+/abqewEsi3jjKe/irh/5VbYIuOoIMhErhYQSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746432708; c=relaxed/simple;
	bh=cxPlgOwR5R2Nazk97EPxSq0hCMprdwGLNM9SrdOgNvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUA3BahRflnNkw2jnjXEkIOD8uY0jOh6UpNktXF0Sv1XDJjZhwVqoCXQKkqFx7dIG9lUiDbOXikGQOkr4O0n5ylXziNeoGn53HmA0EM9q1DK4mR6sHAjJAk8IDlPfB17hk4SdMj590b2SO2pKq0izQ2N9yWX+PiDkjpIZ/F5uCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rYJgjJT2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rYJgjJT2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6XEbUoueC1gHPxeSLnipQtnbtK806iU6jTCT9j8NDXQ=; b=rYJgjJT26IoZy7YlUKRsP2EBES
	oPNCH5iY9WcCi0PEKb4+Xdi4d9tOzqETSIvgxElc3/rBSqhzi40cLN+LXUsV6+3z9s00kzc8wF+FA
	JwUNapXcPMZ/rsvQaTmX3ZNeQoQLFQRmzg4QXjgjTYXxHrvLN13+bGL5UXwl9G4NtPL3lzB0N4ucq
	cfjfbjiAklYUiv5noWqfxLxTkMuzQS8s3zjUcfPNuVnZnHITVs42zVe7xLzRSQB5TJUhvp1sm1iiR
	qpvHNSk1h9XZFdh1WE3vhYMgGOsSvNvTtawLLF1y1OB+gVDO1DHtnnxJlJoptmJmH1z5IytzL+x3n
	qubEwZKQ==;
Received: from 2a02-8389-2341-5b80-f2ef-69c9-6274-23a2.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f2ef:69c9:6274:23a2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uBqvQ-00000006kT7-45L0;
	Mon, 05 May 2025 08:11:45 +0000
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
Subject: [PATCH 1/7] scsi: make aha152x depend on !HIGHMEM
Date: Mon,  5 May 2025 10:11:20 +0200
Message-ID: <20250505081138.3435992-2-hch@lst.de>
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
 drivers/scsi/Kconfig   | 1 +
 drivers/scsi/aha152x.c | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 5a3c670aec27..c89e6991e934 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -403,6 +403,7 @@ config SCSI_ACARD
 config SCSI_AHA152X
 	tristate "Adaptec AHA152X/2825 support"
 	depends on ISA && SCSI
+	depends on !HIGHMEM
 	select SCSI_SPI_ATTRS
 	select CHECK_SIGNATURE
 	help
diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 4276f868cd91..e94c0a19c435 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -746,7 +746,6 @@ struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
 	/* need to have host registered before triggering any interrupt */
 	list_add_tail(&HOSTDATA(shpnt)->host_list, &aha152x_host_list);
 
-	shpnt->no_highmem = true;
 	shpnt->io_port   = setup->io_port;
 	shpnt->n_io_port = IO_RANGE;
 	shpnt->irq       = setup->irq;
-- 
2.47.2

