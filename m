Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060E41DA309;
	Mon,  6 Jan 2025 10:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736158037; cv=none; b=KUSJOefw16TOvKyDs8pj7LyQf2bW+kfBl/gxbnxNAD8Cjl5zRI1BZi59l7qpnv3jCe7+BT+km87Jfs7bu6pGSkgRn9/E3sTTeB5es31X0NWXYD1KvL0XEBEpijCdKk6HrN/tb3QhciWscbzCr8+8EdEdWgkEL8CzCgRD38FNFf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736158037; c=relaxed/simple;
	bh=6fCF8s2yq8ug6oFAJBikGEbgumN2iHFiKJ/l5i9R7kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrlmWaA0QfGzVYN6iFD9DKcOqHH0lSD+wDERd5QoDyYCAV3WnjiT9jsq3MA1xcXFz2B1j31KWf7fAICEpHZZ/Rdy7kC9AYbjZWLh22RxrJCJtKQxZqpLahlmQ74FxhWvikinr9w1d/Rksmw2rWX+D31/BIpwHZC42q15kzWRlYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=krQfWTc6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="krQfWTc6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JKSXgKPbc7+7uy5GODIswmTSRS81Ky42NLQWqgmNN6c=; b=krQfWTc6K9Zm6YMry2PdWlmwXA
	+1cYn5LsiZmthfTnHfJFpwihueoPFEtgdeDeL0v9AfJorRSA988j/QZo0HfWay/hrquJPv/FlpysY
	yVNyWwYXMvxcvx86NlVXYA8gVE5DFV5rWgXTZzKm1I5c5ff8PwkPbutUSIOskwljlsXhbNfZcxiIM
	QsTtU/Qf18lIDYCHmFOE3GSXo95rIzBeOig6sin0M9Hi4G6gqB6SZwg48FbA1rO/3SJiI38h2eGhO
	fN1IbMp37O6/rU05vAObdB41OWhS+yItA4rnJ78WS8MDd+v+e9oHCD99aAabA/8LBXlTNdc6VgcpA
	t2S6GznQ==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUk0o-00000000na9-2Rl6;
	Mon, 06 Jan 2025 10:07:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	nbd@other.debian.org,
	virtualization@lists.linux.dev,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 07/10] usb-storage: use queue_limits_commit_update_frozen in max_sectors_store
Date: Mon,  6 Jan 2025 11:06:20 +0100
Message-ID: <20250106100645.850445-8-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250106100645.850445-1-hch@lst.de>
References: <20250106100645.850445-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Use queue_limits_commit_update_frozen so that limits lock is taken
with the queue frozen.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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

