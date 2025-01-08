Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E676C1F0E5E;
	Wed,  8 Jan 2025 09:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736328357; cv=none; b=A+WPRSpCQiHa3BUPLgjSIvIp7ZWpt1hBO1z8zMNgLt8vdCvJIeoSdmrjp1XNY3/DFEey9uJNIJ/jHzL6v80ECDT9hTD+05TRx2PhbhoItciEgfU4LB/KWhbGtvErpMk8UtEAS5mtXxRFLPiMXEQCbalaGUhPYXCd4VWP8RM9EnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736328357; c=relaxed/simple;
	bh=2ZkcIEcfvcytUTLIlrmMU2SugJqt0d3tSisOpU4cdco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NuuNgWL3PQcAEB+hxGuzfjCSSxIhchiURO6U92fBBQGBoUK+FHOpdbk12pAy1cCP2XY4XFr93acWNGqdOCuvwMOay/S4zUh8QmPxQmpG89B6FXEKiSXB7VP7pQ37XfozCp9qPSfD2Ca+Q60Q3n88FzGd5J0SSmkNqHVvj1dgVOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Kf2YDd2p; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Kf2YDd2p"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Lug37ajQYtt59Z/r/F/B4vY/gKTqUzDHZjrP0BSUXyA=; b=Kf2YDd2p3+dXSfcFc0dS8VdrEw
	bepg8m3PNudq4z+kyPc6rgI0Qjt3vERP4kZisD3ihrbYw4wYyc0u3e/p6nPG8/19wKrO26mRVi2Qv
	UOvl2XQuGU6iTRpDdqz/LXmorboNSVk2aicIuueuAsV1+yEf1Z1if1Z5T3kggwe6JFwD/Hb+yb4ar
	D6hUgw2wlNX0uW/QcnJzCVC/M4OnEpaIJK4cM4ICDLkV7DEEbmiKuRvggWxW24/5o5x3eRzCUnDzE
	VOVJVGmuaZtrn+9yUFYmwGcg4E8595Ahkap/149Za8dXtg0OvgZ/hciMmTXBV6eZ6TEuYzSuHGgVj
	ZRQlHV1A==;
Received: from 2a02-8389-2341-5b80-e44b-b36a-6403-8f06.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:e44b:b36a:6403:8f06] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tVSK0-00000007lle-10Jo;
	Wed, 08 Jan 2025 09:25:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Ming Lei <ming.lei@redhat.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	nbd@other.debian.org,
	linux-scsi@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 08/10] usb-storage: fix queue freeze vs limits lock order
Date: Wed,  8 Jan 2025 10:25:05 +0100
Message-ID: <20250108092520.1325324-9-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250108092520.1325324-1-hch@lst.de>
References: <20250108092520.1325324-1-hch@lst.de>
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
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
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

