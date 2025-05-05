Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C008315574E;
	Mon,  5 May 2025 08:11:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746432712; cv=none; b=IIprB3qJ8vx91DLDiqZcmXL2kAafpJpmVnAMZzMkpIRnn2iXTghaHyaI/9kP6ZtMSxuXmrHxlDjliRyKP0aPH5P9xtYdPSj4zFHjVO8o1R3Zlb790uSBqh5mthDd0auzjOFKOCYx37lNavk2SOcQfsmFUDVtREzZ+N1w1F+aFBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746432712; c=relaxed/simple;
	bh=256DqDJUW2DuvXp0HY3Aahgo/hGvE7ev1EnedyFfMYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ip0k1a18oJdvAznTbOjYypXvb16murDERvS/CBxeClyDkx0g4KJXxo681PjFguD2KN8Ww1iT6sq03GwiM3H6E5X/p85MyGQzP3NmS6aWdoRaLmH+6nzuvVciohXE1D51msd6X8Ad1S6/tN90d7FXY2GDPjM8Wgw5I9qwXSGB+ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=mVboznPL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="mVboznPL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=kQf1e/kueh2bEuIw1LkOrhYnNIR8dIL59IBRnHXuOrc=; b=mVboznPL/76BgJRzV4sK6vhWnV
	R70KnqOUBEeZutqhlntJ2k1bDSU7kmjxj7RwIRlcTGOQXl47quomabwVMydOYVSY3MZyxfaDh9fYY
	N08pOLzCmVtWGzwZr+I44vcjMyrr8ThrR6Fb7feoUg4RcQjrE6x/Dj1ZztWpoP5M9vYi4n3/P6dl6
	TnaJl/rhicpS27GoLyh88m9PSHLQdOxyPsNv4b0xjfksfYfUxVVgtDR45Eu+ckvGNLpXKTKZ7DAXV
	i9Mr2IOSXBn2ijWEYNiHRE7Igmbg1xeAfnnKE+MC9Xtv5C40FTwuf7MhPrquIoH+jEzHbb2Wcm0FT
	jCtPC6ew==;
Received: from 2a02-8389-2341-5b80-f2ef-69c9-6274-23a2.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f2ef:69c9:6274:23a2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uBqvU-00000006kTZ-26Uz;
	Mon, 05 May 2025 08:11:49 +0000
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
Subject: [PATCH 2/7] scsi: make imm depend on !HIGHMEM
Date: Mon,  5 May 2025 10:11:21 +0200
Message-ID: <20250505081138.3435992-3-hch@lst.de>
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

