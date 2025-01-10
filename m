Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A8A438FB0;
	Fri, 10 Jan 2025 05:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736488074; cv=none; b=NMazSVEOR54LWYwivLcj1GxqHSd1Pj5bvf70bmbGhUSe3keSZx6F/36Sm/wusDPum3WzisQWRNtz0Sfop8KtOCkI+Eg3tupE22OLutBq6iGdWZLTmQ3nVBNIwSt6Qo9sbLt6M3OVAUwCpeSfEGgnG/5WCRDDRHBOqdSCnvftKQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736488074; c=relaxed/simple;
	bh=FbKO38UUgfePx3UWo/9L5E2actMW5mr0obExZ2KT+LA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BRf4y6pp17YwScCeOVYbWGCzb60pJ8FgWzUVXQv+RqHh3pxDy6shlqgbOmAVDlXjZWk16XSdbM4idQsgpTANOfOkCJ0ANcYLVDsMkoHZnGlyDTUGsu+HX2RgNVZZWULpZrDasWqKYFhz6V/+UAt2q6YR8zLcGYd1b0fxNNQN8mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=xVhnV4+G; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="xVhnV4+G"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=aVPc7ZYe8xc+rP3/vPLE+10RiLIuzK741aBYQ81fB7A=; b=xVhnV4+G7Qi5+C6qcAoRhr5Qiu
	uQJXYyNmTypTiO2GA3xNL4CCqy8yYdIn5vVxZ53HQQjZXyAX+wLW045zqx3PVlwpI3Hw9HqErHNTl
	kipNf/56uu7Greb8lhYcV6WfyuxEuGyJTj/LfWU0EbdjI64TwjicyLlTYDdDUTq07C7RgqjJsBsYB
	af7X1tE81t1CYe7JJksQgLSVjajlht8jLZupHWIiWBwpULj8TG3eht8Jydp37JUbv8rowR0OTf5yo
	o/CmkB4bujwkqZaS/nWPsDEZADloOt1Kyd8/HtOLNW9NdjjAJEv0Kb4I79XfewB7x+RKj6porbzhV
	onrFDHAw==;
Received: from 2a02-8389-2341-5b80-76c3-a3dc-14f6-94e8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:76c3:a3dc:14f6:94e8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tW7s7-0000000E51z-1tsQ;
	Fri, 10 Jan 2025 05:47:51 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	nbd@other.debian.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>
Subject: [PATCH 09/11] usb-storage: fix queue freeze vs limits lock order
Date: Fri, 10 Jan 2025 06:47:17 +0100
Message-ID: <20250110054726.1499538-10-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250110054726.1499538-1-hch@lst.de>
References: <20250110054726.1499538-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Match the locking order used by the core block code by only freezing
the queue after taking the limits lock using the
queue_limits_commit_update_frozen helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
---
 drivers/usb/storage/scsiglue.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 8c8b5e6041cc..dc98ceecb724 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -592,12 +592,9 @@ static ssize_t max_sectors_store(struct device *dev, struct device_attribute *at
 	if (sscanf(buf, "%hu", &ms) <= 0)
 		return -EINVAL;
 
-	blk_mq_freeze_queue(sdev->request_queue);
 	lim = queue_limits_start_update(sdev->request_queue);
 	lim.max_hw_sectors = ms;
-	ret = queue_limits_commit_update(sdev->request_queue, &lim);
-	blk_mq_unfreeze_queue(sdev->request_queue);
-
+	ret = queue_limits_commit_update_frozen(sdev->request_queue, &lim);
 	if (ret)
 		return ret;
 	return count;
-- 
2.45.2

