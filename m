Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 096C816F859;
	Tue, 25 Jun 2024 15:00:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719327632; cv=none; b=R1Lca4Y6Z88cDHiNYYyMc2QEnO87Oeegzie/M90gwTst/alx6wq1IXgcUj8c81GGi9cZKHOGjWGEAzukZcwbG4QP558NDl/s39M4ToK6fROHDs25iaWgyEnZNoiMkWp+DLqjrwuyiFS+oJL71eLOxOKF80SaJh1N+lWzwzKMlF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719327632; c=relaxed/simple;
	bh=Aw2XrYsCwP3T69Jfb+MqQIZX0j8GT7v5lRu4wC4EhLk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mOPOE1MORK3zfXM+XwKd6JCqtu90nPOn18Q3Kgu0BGB20Z0do2/FWKyRzoMaN1eIHwp4ebOWKk2ob7H8OvhjUsGAprkz9JIYH5pr8SU+bDwxai7v15qhwocbZ6ZRUYYOuZG52g0ZtatkMfraMR7kcSNka9rHAB/Cm3KWnZInQTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=4zCXLAVn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="4zCXLAVn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KskCjVAvpwfqIOwoDxekAqI/c7pEjEpUxWNe5yi21yw=; b=4zCXLAVnuB/8V8EE10HFypyZkA
	+CjVmsKWb3UuBjalmH9HiOzW6O9HqVvOZPl74MTqFDjsyo3UN4z4GQSprUGXFmBELBLLVgLSQvd3F
	xnrLO04Mp0hdYN5vOObP4X0B20aBwq4vPfXysy9iFP7COV3WxFNZ8goBtU/JXtqDTQq4EPJYv+2Mq
	Sxackr81HHkL5BjBBHVd5NppOeYMXPHS26UhRqzjokADgITZ4FSHG/OO4KGe082nAq68muwhPheyq
	tlsvt+E4HBCH/m9ZYujOfXicVUOkVN1gIj/RRvTzpXZNLAa6Z18dS8p9Zi2uyS+9NAxkHFxNDQ4wP
	Lvx6QCpQ==;
Received: from [2001:4bb8:2c2:e897:e635:808f:2aad:e9c8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM7ej-00000003IvC-37BB;
	Tue, 25 Jun 2024 15:00:27 +0000
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
Subject: [PATCH 7/8] block: remove the fallback case in queue_dma_alignment
Date: Tue, 25 Jun 2024 16:59:52 +0200
Message-ID: <20240625145955.115252-8-hch@lst.de>
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

Now that all updates go through blk_validate_limits the default of 511
is set at initialization time.  Also remove the unused NULL check as
calling this helper on a NULL queue can't happen (and doesn't make
much sense to start with).

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

