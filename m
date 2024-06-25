Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB3D16F859;
	Tue, 25 Jun 2024 15:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719327622; cv=none; b=C4jctc8EMUPqgkjR0EZXSQ6XTjfQzFNyoePm3IOSop0lAIA9ZRh/Lve3tPoxz8qSkd2AZArGDKcc0DF8H6uFlasro3tn670lAteP8uGTpvABFr0S0dUBfs+bLs2PsX/YmG+naz+hOhOSdDKcPJcVzQM9y4G+3DWqDdIga2hHJSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719327622; c=relaxed/simple;
	bh=USQNShoruQr8n50xw79a7Ed+mesOuVTDwLQDjhU5Z0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gje1SlcRImge6T6tr9ckJGQspbNHoBKV9PlsyktwUEHcY2pruGgwigb7maKpa2WBT9DlFuMH/TNsYEJckQSVYu0Uw7WiTTmGxwkheoW+dHJcp79JIT+4V960Hlq+4bWu01n6E0co/clOyKwzRL/Bgt+8Ggu1bUE1Xf6GNF4far0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=trg4P1ky; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="trg4P1ky"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zdECJm1CcT/GXzH0t6Tsbe1heut6romX7eEeRzj0P1I=; b=trg4P1kyndTgK1V3AU/9675Otd
	IFCHrxIQe7YbbJV/QieLyKCDE+0lPITntC1GZ6Jzda83D60szgNkK9oeFreF9hSiYMzY9+HYZAEZc
	i0AKE475nodNMzLFNEUhwmZLoWndSIut0uH96pQAUPqXnC/Hgp/NmzuR62hdUdzREIq5NWPHNUHkv
	3pc09NlZg46kHocs4VIzO9qsVagnpV708on2O2aBhltSF7QiPT+RjRUzjwZoAEmAqQxNr5coqm/R3
	u+U6DP0vAxG4OzmhuYsKR2WzDQj6PahE4BktRjA7VvM1AtNY9L6OqvSUIJoUDSx83p2Uk/MSP9ScS
	Lcixf04w==;
Received: from [2001:4bb8:2c2:e897:e635:808f:2aad:e9c8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM7ec-00000003Ipg-3DcC;
	Tue, 25 Jun 2024 15:00:19 +0000
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
Date: Tue, 25 Jun 2024 16:59:50 +0200
Message-ID: <20240625145955.115252-6-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240625145955.115252-1-hch@lst.de>
References: <20240625145955.115252-1-hch@lst.de>
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

