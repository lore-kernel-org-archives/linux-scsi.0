Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC3C1DA10C;
	Mon,  6 Jan 2025 10:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736158047; cv=none; b=mwYsl3caox8FJNtkqVvEhSia6WxXY3zV4hysUrUZgEr0VqyzDdaKuIJ6mdykqjHewLCVpSIYAXi4BMrGd86ZAYtpfaEhve7qMXTzKdDykA7Tx4ctwDP9nXC/ioJA4IoqZFRaMFrTxtK+vnVBjPcY7uCvK4jy73TCe+DqZKEIk1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736158047; c=relaxed/simple;
	bh=H5Wn54eUbj2CQ3GxOsw8WqGD4ch4g/L1iSw5ZH0EGYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B3QrLhe+qaHXKodDt98a58+lI+0fLF5J5LtS7UMsEV9d18+kOfUkJ+q0dymAn/iW7rX5/vr/dhomBolnAjPLdKSKn9Hm/J7/aO8VIVaLM7jC8yMYo1C1Pzy6q7joas2oxtuGdvCmpW3GV9WBf0evNqaOmbLYgbCGYe4jId9+3CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=M1PipEhF; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="M1PipEhF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=D60xcXTNKiK85tFpbqT3NS8N8EInArTaxhDRMqEMPYQ=; b=M1PipEhFdqK4kZgFQL98zFz+Pl
	2vE0JKAhgEONYiPDGaCV48iLsvOmawtePnLNPJ2gmzKKHXDM0Cc3zouzTo0JICBGxq0gqaRUIRrIU
	IKK41iFDjqeMJPJjPqUOTDYTTMxzdjuzX3Y6eBDLLP5PhyVpYUv1Mjzi7pm//IT7ot18K/PYdGZSW
	YSdqOzJD4dVman6KL3zrxnfE4sdDyOhaY6Mkcs7olNLccldIz1ad7VlCoIuotp/974ZEDAXF5Vxy0
	ZLvnB72KDfQhrJL0FeGajJnfCckW0s/sU3rvV0GyWphE4NJ308cnhKWndC5GFTWqaVGXVP/NjLODc
	M6bIPVOg==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUk0w-00000000nis-0d1X;
	Mon, 06 Jan 2025 10:07:14 +0000
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
Subject: [PATCH 10/10] nbd: use queue_limits_commit_update_frozen in nbd_set_size
Date: Mon,  6 Jan 2025 11:06:23 +0100
Message-ID: <20250106100645.850445-11-hch@lst.de>
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

Apply the consistent freeze vs limit lock order in nbd_set_size by
using queue_limits_commit_update_frozen.  This also allows to get rid of
the lower level __nbd_set_size helper.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/nbd.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index b1a5af69a66d..ca8bd2f3b941 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -327,8 +327,7 @@ static void nbd_mark_nsock_dead(struct nbd_device *nbd, struct nbd_sock *nsock,
 	nsock->sent = 0;
 }
 
-static int __nbd_set_size(struct nbd_device *nbd, loff_t bytesize,
-		loff_t blksize)
+static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize, loff_t blksize)
 {
 	struct queue_limits lim;
 	int error;
@@ -368,7 +367,7 @@ static int __nbd_set_size(struct nbd_device *nbd, loff_t bytesize,
 
 	lim.logical_block_size = blksize;
 	lim.physical_block_size = blksize;
-	error = queue_limits_commit_update(nbd->disk->queue, &lim);
+	error = queue_limits_commit_update_frozen(nbd->disk->queue, &lim);
 	if (error)
 		return error;
 
@@ -379,18 +378,6 @@ static int __nbd_set_size(struct nbd_device *nbd, loff_t bytesize,
 	return 0;
 }
 
-static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize,
-		loff_t blksize)
-{
-	int error;
-
-	blk_mq_freeze_queue(nbd->disk->queue);
-	error = __nbd_set_size(nbd, bytesize, blksize);
-	blk_mq_unfreeze_queue(nbd->disk->queue);
-
-	return error;
-}
-
 static void nbd_complete_rq(struct request *req)
 {
 	struct nbd_cmd *cmd = blk_mq_rq_to_pdu(req);
-- 
2.45.2

