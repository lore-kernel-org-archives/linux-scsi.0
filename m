Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96D037CD55;
	Wed, 15 Apr 2026 06:08:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776233307; cv=none; b=Lo/CWfhtnDqbN9XU//29jWeqmR46AO5mDuKaSUEsSkSM1UKsfNbV67X8X+KcPbLy8npM+SxmnjGjvYR7HBN+OFXdbwgADFe1wFI755D2ISQhm/tUWGzS71+mbbzPAksFQW7zump/X5R4d4VxZCGG7c+Zr8he2Xaf/Af4PORtr6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776233307; c=relaxed/simple;
	bh=+iqVJaC+bVobJvkVusNGdXkEFjnu9NqdBv8E9u7V0GM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AeY+TaoSWradkqqlDyyFtpfvlYvXwExlk9cgrpW75yYGITNz3xLkxN68OE3l5ikHW/OJytLUBf1/YeOtBO3BiapUxbBY/nSnkZkGewVOwbY9CXS1a5nDf8I4ZkZha+wRYC2AimBYDXxOZBn9mNbTx2npFCT6TFnYQ+eyC2jWQMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=qU/oh+8y; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="qU/oh+8y"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ohQyG08Fi61LhUw+rPYgrfPkwtT+t3ZAITBuCh7pOQI=; b=qU/oh+8y/skws9Jh/HjywUTRm+
	d7qYmiD4Y8Hf+xgIpOit9cYChrwAO8K1vZpauW7TzW+t5yw9fDnAwJ7mKF0rILfj3x4zInsXUT8Pp
	+3+WRHjDE4TTmdliddtQLTq6e87cZT9R9CrzsnJji+4DGOnEwzXwUADpTv3+o1gl32KLcjHvGI21N
	6ZU8tZlkabhJv1Tk38rnWaJD2ysUZKmCleKw86nVN7K2ZHxhISXtPUWZftWhAr8AmJEh2zp2V8llX
	F265mIpUnMxkrf47lxbBHsy6amB0xMDYm5abn6rDWGi+fUu+KDwZ9G554KKEPyzEAEPExIHawfwrD
	oS5qQ0Ow==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCtQG-00000000d3y-41vf;
	Wed, 15 Apr 2026 06:08:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Doug Gilbert <dgilbert@interlog.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 2/2] block: only restrict bio allocation gfp mask asked to block
Date: Wed, 15 Apr 2026 08:08:07 +0200
Message-ID: <20260415060813.807659-3-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260415060813.807659-1-hch@lst.de>
References: <20260415060813.807659-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

If the caller is asking for a non-blocking allocation, we should not
further restrict the gfp mask, which just increases the likelihood
of failures.

Fixes: b520c4eef83d ("block: split bio_alloc_bioset more clearly into a fast and slowpath")
Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/bio.c b/block/bio.c
index 641ef0928d73..12341f760b9a 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -544,7 +544,8 @@ struct bio *bio_alloc_bioset(struct block_device *bdev, unsigned short nr_vecs,
 	if (WARN_ON_ONCE(!mempool_initialized(&bs->bvec_pool) && nr_vecs > 0))
 		return NULL;
 
-	gfp = try_alloc_gfp(gfp);
+	if (saved_gfp & __GFP_DIRECT_RECLAIM)
+		gfp = try_alloc_gfp(gfp);
 	if (bs->cache && nr_vecs <= BIO_INLINE_VECS) {
 		/*
 		 * Set REQ_ALLOC_CACHE even if no cached bio is available to
-- 
2.53.0

