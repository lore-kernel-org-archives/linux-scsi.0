Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E6111494A8;
	Tue, 25 Jun 2024 11:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719313580; cv=none; b=b27UrzaD6fKmqi4UDPvfZe0CrrWnK4yv4Ds95XKZ3xtTPpdQTW0ef0MOATeh0CdM/bgmDQgSUwjF/HumsYr+yKXxoN1gJlqBVHU6JJWzTHLj4o5+BF3MI/crndYN5viIAgEAZ4TCxYLF2d/2D/+SAHkWTWICJ1+oXGfommsceDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719313580; c=relaxed/simple;
	bh=ibjRsxFROraYOe2di/GNLknt1odEKOSK+MjDFAFmq5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pRzlaxWd3nXwadpGa3fZwgvqzTaNC5woOzZifX6ISTaJknWsX/jUTqluSE1fRwXOj3FCMjh2KInhkvsATR42A0YW/AJiG7uwq3x4jUm56UT9lHiL2p3JJYb4Pd1dXoVesHM4F7aUmSGGMu0TbfgCCRqvcsC3MX3Erk6OmUcrfrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vyqFe67Q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vyqFe67Q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=snUPNt/Hw40J/56VP5E8xbfPRtK57297D0rEghhMi/k=; b=vyqFe67QZNl2rbseN6uWdiI9JF
	YKII7kdo6NAqqUz7L4ECSy0ql+RvBf2j/uHmElyqRBGUEW4EhYrvVwn0LQj6ZZ7LrtUxzSFKS4BGO
	nUqB93Epd1PGr7tjs7UnGyDOLtFrHyB9UrghQaCi9zLlcnBG5vVjqmhaPJxxiQSFaZfiS/iSjjw5G
	iP+XOAy8HrdUZyh7AqDslCDOTw+9XtUvthMRJtOi9HG43lAdML939/qKrtGN9jctmzAq7Gm2u2hoR
	HInnvveP4fkboGyKNfrAhN6DAWIHqXfFUPG6y0jvtdjX9oLTo8iBT6+k2pF1ZiLNRPJxtPHJmktbQ
	m6aPe8Gg==;
Received: from [2001:4bb8:2dc:2ee2:6df6:d2e9:d402:6e6b] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM405-00000002UJg-3IzE;
	Tue, 25 Jun 2024 11:06:14 +0000
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
Subject: [PATCH 2/7] block: correctly report cache type
Date: Tue, 25 Jun 2024 13:05:42 +0200
Message-ID: <20240625110603.50885-3-hch@lst.de>
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

Check the features flag and the override flag, otherwise we're going to
always report "write through".

Fixes: 1122c0c1cc71 ("block: move cache control settings out of queue->flags")
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-sysfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 1a984179f3acc5..6db65886e7ed5a 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -453,7 +453,8 @@ static ssize_t queue_io_timeout_store(struct request_queue *q, const char *page,
 
 static ssize_t queue_wc_show(struct request_queue *q, char *page)
 {
-	if (q->limits.features & BLK_FLAG_WRITE_CACHE_DISABLED)
+	if (!(q->limits.features & BLK_FEAT_WRITE_CACHE) ||
+	    (q->limits.flags & BLK_FLAG_WRITE_CACHE_DISABLED))
 		return sprintf(page, "write through\n");
 	return sprintf(page, "write back\n");
 }
-- 
2.43.0

