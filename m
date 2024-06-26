Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF83B185E79;
	Wed, 26 Jun 2024 14:27:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719412035; cv=none; b=czFCi1ddnIwQ99ctGJzjlpwbmAjtUpWXS4johyylLF2qczVGUtwJNMk34JVlAfc8hB1b6dgbazlMtvCEL3bCNglMxadOC2p3vyItx3CsNHtXvrAufnUxt4HIRgftDzt73myRI7Z3nx5Mm42WfoGsOgRkwMCNb2cUYZgHGIhIunI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719412035; c=relaxed/simple;
	bh=AImlRRktJoiOgXhbJYfrFzxEsP/WFEJ8hezSl1aEh5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y/1NXf+n2W8fwch/g5wPcCaxu17HlA3jHoOSsyC3Dk9G+7JlOMOFfhFYF7NJK1SU3LbNc0MIUR72SW7L2SatXvENRqPUxYGZoVmJLyCwECP8FpwVYkdDWeil4rRAutZMGDkXQbpfmWcX5KFU+lwyCNr//jKnP78JcskVMBWzZCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m/Otqc2O; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m/Otqc2O"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=r+LBD39aL+HqVi2+tBvlzf1Mq7+dC7Owjf901KNN2Dg=; b=m/Otqc2ODxAq4tOLc9uBJue9cT
	L68mOlhRTO+NjfOAgyhZ0K9FyPZPKDC+Yt2M25haJ5my0OWANFFgBr+DueeJyH4Ho0zY4oDJ7y2Mq
	Q0iNoDH5Ha+JqYX7M0msrdTIVP0BTQ1KwzmzImCC+bnypzZkPBhuz26b/nKeogWPYk0thKqWORWRn
	mHyRFwVxFZDRnYGqEwV+T09tsl2Ry8P4QcXCf5HDY6HCG1ZxS2eXyfZ74+URBZDsZgaqk+S1oYBmw
	TOjr7J52el0EbozEySFRJVZNCcDnwVCY/7nLA9LdWh2dGlQg6JIFbuujyHqMVmfUAuZ2zvPMgG/yj
	z7BtLdSA==;
Received: from [2001:4bb8:2cd:5bfc:fac4:f2e7:8d6c:958e] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sMTc6-000000079kk-20Zw;
	Wed, 26 Jun 2024 14:27:11 +0000
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
Subject: [PATCH 7/8] block: remove the fallback case in queue_dma_alignment
Date: Wed, 26 Jun 2024 16:26:28 +0200
Message-ID: <20240626142637.300624-8-hch@lst.de>
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

Now that all updates go through blk_validate_limits the default of 511
is set at initialization time.  Also remove the unused NULL check as
calling this helper on a NULL queue can't happen (and doesn't make
much sense to start with).

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 include/linux/blkdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 6b88382012e958..94fcbc91231208 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1394,7 +1394,7 @@ static inline bool bdev_is_zone_start(struct block_device *bdev,
 
 static inline int queue_dma_alignment(const struct request_queue *q)
 {
-	return q ? q->limits.dma_alignment : 511;
+	return q->limits.dma_alignment;
 }
 
 static inline unsigned int
-- 
2.43.0

