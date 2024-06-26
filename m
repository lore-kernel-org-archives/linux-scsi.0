Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD7D185E79;
	Wed, 26 Jun 2024 14:27:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719412026; cv=none; b=eaFBZcyYxNzWIEK2GUQ6lzt/V7uliulErw3RoCRdvAeu2Ii7zXUckdpRCW6CWpultrfvO1ZPuuxP6J7IrKT/KVMIjrGbNANxgfNgbsKTT+G4bSAK+oLtYY75NKf9VSXdED13cHw3EgVoKiqiuzSFAXRMTBI1kHIhOm4xKr+r0XM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719412026; c=relaxed/simple;
	bh=S4ICT4PeWjGNFL3UO/rPR47lF4p8rBIZv7Mqc2/wq1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nb6YE3tecbyFmekpSGlCjzeKlwKD0PcbgrXyGVUpWbdT9SLQApdlDwjH8bQDQIfF7bIjSub1yzhPkAqH4Ptt3uGSl2YQMrVAIIheMTRHVxddk1oNPwz0oUSXacvOMhHAdlfPX7Ecg2IFQuEkRuubsPd3at93nH5upYJ/mmfbfoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=nu8bJkeq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="nu8bJkeq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=+kFaY3VhBYpRFCR8WaCVMLyC3DvHeqIA57msUWsiyLk=; b=nu8bJkeqi9O+Bu+9DwmHxK8u9o
	ZfVomOSAN7Vqrg0SHOQWKy9WzQeynPCJ1iWRq22qxzVCtIpRoEEZfj1VfEYzVRPPNglp5k0YJOX2g
	0HApnIJEjRFGqK8qCaa6LohTZ1Pi84f3ODzpd4HHOyyyndWXtrqpWDoUMC2xRbGI19JerXt7ZxoXX
	mbD8lSFSqTbcHpF83fH0vYRXjF+Sv+Axh+Xf31vKnMOp4+Wi7VDa5Z4mz1ws69yO5zx2vCqxR4kHm
	vo3IR14i+SwaX87PBpxM0luJrqn0qAKS8m17LB1EW6Ed28DlaaFt4VWgVKVGUbJ9cI97yI7neTRoz
	DzjpCVFA==;
Received: from [2001:4bb8:2cd:5bfc:fac4:f2e7:8d6c:958e] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sMTby-000000079gl-20NP;
	Wed, 26 Jun 2024 14:27:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	John Garry <john.g.garry@oracle.com>
Subject: [PATCH 5/8] block: conding style fixup for blk_queue_max_guaranteed_bio
Date: Wed, 26 Jun 2024 16:26:26 +0200
Message-ID: <20240626142637.300624-6-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240626142637.300624-1-hch@lst.de>
References: <20240626142637.300624-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

"static" never goes on a line of its own.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-settings.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index ed39a55c5bae7c..c2221b7406d46a 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -142,8 +142,7 @@ static int blk_validate_integrity_limits(struct queue_limits *lim)
  * so we assume that we can fit in at least PAGE_SIZE in a segment, apart from
  * the first and last segments.
  */
-static
-unsigned int blk_queue_max_guaranteed_bio(struct queue_limits *lim)
+static unsigned int blk_queue_max_guaranteed_bio(struct queue_limits *lim)
 {
 	unsigned int max_segments = min(BIO_MAX_VECS, lim->max_segments);
 	unsigned int length;
-- 
2.43.0

