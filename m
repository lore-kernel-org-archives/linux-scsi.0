Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08BF9154C19;
	Tue, 25 Jun 2024 11:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719313591; cv=none; b=aCs+SFwt5ZufLYEqe0oTU9Az5nLFqjw6u7Xuo/Ax+R4VW0tpANqRUTiUo78K/l82P5FxzbF6iQKgewPljNFTHWyE7VeQbvaPpIE6efnlHKgvGUsk6m/SkjL1mdt10gmSwXKiuLdOyFbW7TTFLs6+KECCGConfRnPRVOADE5qfXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719313591; c=relaxed/simple;
	bh=lvFZL6mkaC3Jaz84lyIwmrx6xEDumWzrMZ2tSIHkpRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DrmRPvxz0G0mwBsl4tid1rFwMYlYvd70k6JRxhtVQWBe8C2C5VzuCmzW88MRjvVcIkabmo7QqlVzDeYJWCQWWe1PFNkFBDnfc91XjDw8HcaocexPhVMB2BYxEMA6/7/acvKN6pAggBk5VCRA/YpeZu8P71wQ5jY//v6Blxbeu80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0vDE/YuM; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0vDE/YuM"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=fkJHM9ynXbOp19wlF1mq14lhZ/JCExZImSxAVXVIcL0=; b=0vDE/YuMOBb6kpm+r4m3+Wz3C1
	sLIdTXN1AVGbBE5qjTteatRdJZOqIWNQ9m48HjLQzv4ctgxyKszrVMso5P/2iDkOcCJp3fM+kJ3w4
	oQuPAXDFU6utYronFj2x3FXQl1C8BX2liZNI9JN4wEdXXr1Bad86/vk9JlwOqZmFJVpSugfXry3r8
	v1UXGhNCfVu0BbfV1wEKjiDGSj3Fj6Mi519CBTbH6KHdgIcyJ2uiM7fulubwEwXs1N58PKf75TB1N
	KIY5sCGgnQeSE4RpM2XvO172fsb1dDeyy7ed7pqtsTgLu8OQ4vfdqF1VDRpmo6ye6ncu7KK0XnCiD
	jISpG9kA==;
Received: from [2001:4bb8:2dc:2ee2:6df6:d2e9:d402:6e6b] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM40J-00000002UL5-2AYq;
	Tue, 25 Jun 2024 11:06:28 +0000
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
	linux-scsi@vger.kernel.org
Subject: [PATCH 6/7] block: remove the fallback case in queue_dma_alignment
Date: Tue, 25 Jun 2024 13:05:46 +0200
Message-ID: <20240625110603.50885-7-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240625110603.50885-1-hch@lst.de>
References: <20240625110603.50885-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Now that all updates go through blk_validate_limits the default of 511
is set at initialization time.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/linux/blkdev.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e23fc418bb2260..d93fba7a1f3162 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1393,7 +1393,7 @@ static inline bool bdev_is_zone_start(struct block_device *bdev,
 
 static inline int queue_dma_alignment(const struct request_queue *q)
 {
-	return q ? q->limits.dma_alignment : 511;
+	return q->limits.dma_alignment;
 }
 
 static inline unsigned int
-- 
2.43.0

