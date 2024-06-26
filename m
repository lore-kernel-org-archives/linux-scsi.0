Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 076A61862BB;
	Wed, 26 Jun 2024 14:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719412013; cv=none; b=bgemsZUpkVhXXvFifIRk73Rngk+vx+sglGseo9/8g71QATkxtaDX/wvBpCtCMFk+1XVJbh/gcqL5LshpI/IQ31SecCq1PpRXH/pG7ucQK5chTRKfv90XeFsivitOQCvyOx2pdEzRaVp3UMwMWBjXoRYqE0l8slFsdLGwYbOVmtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719412013; c=relaxed/simple;
	bh=cOVpGroyiiTlmWMIsCZgTzRiTJADiiLs3vEAgfAEPnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IWPkUrqdOvwDHSBE1XeFQXt3b3itnjcH/mOYgT+8dZCoeTYiWEVAFXh1Nic9aLJQEie/1LHLEj82bTpXHnIykKeM1qvnkbFq9h+AXZdLor6emcpbO+fZy5Qj9AK8o+YNBkMFmJlaxnX3PgWvscGl6NuQX+qDEnWmXmTpkv/niVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c7TIRs9a; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c7TIRs9a"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WI4SC6oxKkA7l2ObOZSwz4Nydl+SumrgnyGBVB69D5s=; b=c7TIRs9aPTS+AWSBguFf1G2Od2
	TXLDRmlDVtoImnsEcEM7hSP2yFbE9xzxJHeG2iH+xXJfD8ub12t/uB3tNOlZdGra1Tqy1qerBour4
	SPhwp29vps4fi8/EzS/HjziqGNqLF2i335HPiSbKRuYovjlhQFfeYX9DfDnwqkeIPeTtYVHI0CatQ
	m3v3MyXumQPgzpaKtbt0TOJORjNAfWTygVpLUoWYS7BdAJhH6sPAMxNEwXcP7BkmliJPDhuA1lN/S
	iVWvJ2QRGPSWN6IchwesCCPF8Z7JT+xE61Ek6B6b80XDwQlX4+LRDDsfQbDstIAXVWvrauzeQrrLE
	ykz190Bw==;
Received: from [2001:4bb8:2cd:5bfc:fac4:f2e7:8d6c:958e] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sMTbk-000000079cx-14pw;
	Wed, 26 Jun 2024 14:26:48 +0000
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
Subject: [PATCH 2/8] block: correctly report cache type
Date: Wed, 26 Jun 2024 16:26:23 +0200
Message-ID: <20240626142637.300624-3-hch@lst.de>
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

Check the features flag and the override flag using the
blk_queue_write_cache, helper otherwise we're going to always
report "write through".

Fixes: 1122c0c1cc71 ("block: move cache control settings out of queue->flags")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 block/blk-sysfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 1a984179f3acc5..3a167abecdceae 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -453,9 +453,9 @@ static ssize_t queue_io_timeout_store(struct request_queue *q, const char *page,
 
 static ssize_t queue_wc_show(struct request_queue *q, char *page)
 {
-	if (q->limits.features & BLK_FLAG_WRITE_CACHE_DISABLED)
-		return sprintf(page, "write through\n");
-	return sprintf(page, "write back\n");
+	if (blk_queue_write_cache(q))
+		return sprintf(page, "write back\n");
+	return sprintf(page, "write through\n");
 }
 
 static ssize_t queue_wc_store(struct request_queue *q, const char *page,
-- 
2.43.0

