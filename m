Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A3A91E3796;
	Tue,  7 Jan 2025 06:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736231534; cv=none; b=PZTrdVu+eot5cZn9vhOxJoVk1EvIGmHa6ZWmI+B/l4VLetZGTLNKlmahBvVWDRYjnx8GfqU7/Nu6dzjSmt9ir5V04MvmQME6xjCZ+ve0K/zP02fkc7LfINMWZYTfBQ/y4kdgIB45cyZ1y8/uMq8Yaq+cLcopr3j4ZUZoZqLoYvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736231534; c=relaxed/simple;
	bh=W5O4fy+KJ1D5HOdCbqCgHfdKvrDE5BYIRMytQNpJApk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UqJipt5Agl2sQp5UnRxp6A++eeh5X6EksjVttOr5hswJeM5kWPjyiHlx7z+2df0MEXzyaLAmL0TpnMSCoYCCnc+bGoPCh9HKd3o6L6V0rltfElBK7KxSpFUEj188CJ12YST+c4/G2DRYootv5x7qxuo27GCPPOBlJDmZQcdzpMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=OXU130PL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="OXU130PL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=SAyM51ZMh2WQCIzVgXjOQiiOuyowXnbXZDM9r17qCgg=; b=OXU130PLjBQ8bGHx7V3SAk3u3v
	aUJX4jjoLYATF7yHULvhQdnm2dNYadsRXz9xLjwmBPW4NH4VWw1zs4LZdxxLNyHhPt1TQNHn1CPf/
	Ar5DIGXC+iWMKLlQVjIUQLxSUZ39BMprBjbjEl7/5r7aj2JHSJFvAsbBBw8x5e21W+yk3fGuwobD9
	W1bASWms8XrdTE9VtCKIXodCIi15HsNIrcQTldhY2jbdUfyNQvNQxJXjsOnVA44tuFn5o6Nc40HUE
	n8Xx9TJWWCGc2ZwioO/vpp4DCmUitG5eQk8s15CHQKs3+d0XhwtAuWhTqVX90+dmxF2itNIx/Wphz
	2HsF5XTA==;
Received: from 2a02-8389-2341-5b80-d467-d75d-35bf-0eb6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d467:d75d:35bf:eb6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tV37y-00000003e4Z-3ejf;
	Tue, 07 Jan 2025 06:31:47 +0000
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
Subject: [PATCH 8/8] usb-storage:fix queue freeze vs limits lock order
Date: Tue,  7 Jan 2025 07:30:40 +0100
Message-ID: <20250107063120.1011593-9-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250107063120.1011593-1-hch@lst.de>
References: <20250107063120.1011593-1-hch@lst.de>
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

