Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B1116EC07;
	Tue, 25 Jun 2024 15:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719327613; cv=none; b=I5yUO2U4ZmgAiUuCtexuoVeb9Un0z3lW2aC7nrzrVXoByMEkirBj2IdyFwwkIJtkCeDprEW6ycTVF98DxdUPF2txKh/xcpbh6jx8RriJdvf9y5rwuauTuuWjeWSdZc8TuyVYf64NEH78BhKp1IuJiEachkWDN16aN+4G9yrV9Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719327613; c=relaxed/simple;
	bh=ibjRsxFROraYOe2di/GNLknt1odEKOSK+MjDFAFmq5I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P+gC7aPYpsuBHVuZy3Tnpj6psKmxQPAau9HLWKrBWTM4cH/YKZiHgE3ZvshDzRVzPZVd3d3WrwJjP/CNy93R4kFbEzdGZ4JF20/irqr3p+cDZha1b5wLQZ4vMe3jiMwRu2SWFvJewv/kTJ0Vxe6Y+QxFOS7xwRCEEJpC4BJPmtw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FsC5kRvk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FsC5kRvk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=snUPNt/Hw40J/56VP5E8xbfPRtK57297D0rEghhMi/k=; b=FsC5kRvkrokDt8YffZMzMgwlMu
	Xi6z+0yZkwoFIOFQwJUiYu7s3MabOyhqR89LYs5bw27J4yfBuRXXMOGiDRYJQcdUOpiivPO7quyF4
	n526JhX+O6GORj5fsuZ5gHmbguXaJq/Nb5aVxJq05pDOSVoRsUpcEDlOhS0jNlnIjsbY3InjgNG45
	6LJfK7nqCGrULYUeaVs5mVxkPJ3O4CY5ZGtXTRVTEsALTJBamRvSluHOx1gZJXRxi3wKAFd0UBfvF
	sTvtnizpKqKVI6F4WCaZEFuRiJeVRKWOFdz+73/8bsml3EaBx4Uxeun3qYfid46b1YgT95YcVKuEy
	mCzofIBw==;
Received: from [2001:4bb8:2c2:e897:e635:808f:2aad:e9c8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM7eR-00000003IiQ-3GKt;
	Tue, 25 Jun 2024 15:00:08 +0000
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
Date: Tue, 25 Jun 2024 16:59:47 +0200
Message-ID: <20240625145955.115252-3-hch@lst.de>
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

