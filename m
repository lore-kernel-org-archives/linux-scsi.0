Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BC81F0E5E;
	Wed,  8 Jan 2025 09:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736328351; cv=none; b=b6pJiUh/KZFltM5/UZNL2PTa6agUsmrobB9oEJaGEgjC6gE9yzaI2Vi/WzvSgRfbs8wJwTWbMaxNEt3mRw0FaKiPibMI38CltTHLh3KSs2v6FmrPVdnVig2noO3kelVj+1F+x2+OG1dUVX3dkZVsUdDSJRVxaUjdvbkvio1TYhI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736328351; c=relaxed/simple;
	bh=FrsboMFjHJRqkatlPehfD5QZniJv9bgxyRG3CYb5LNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QQZkdCjG8HL2glNV5SLMupAII5hV2nTlww1dI1oICEaK8bNQ86Mf4gbh7/MY5yID6mEvUxnqXk4OL3CnklV4k3YXmfBi0h0bnYkLhcOK2TX5FyO+OaNHtHTQ4wni+C8pTKME9CaHr7qG8oKYKgkOahOfGkOBs6XFz0thnKO0P5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BDJnlIfk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BDJnlIfk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/leNgSj7YcRBg+an0LkvgucxyjiDM9nOTOyWQRUPC3k=; b=BDJnlIfkvUXzfgs4O8tB8LRvmS
	KGL9OUspkQ3ilSB3wr7Jc2J9Cykiu5ATvXIH3md3/4CpbzFi3HBkoPEym5K8IvY35JFd4ggL/Il8a
	u3uBJP7i4l8fh04soNeP5SEJvPDK9Br+iVgWagjC8yh6RJTxJYVlncH1B9nXoBIv+hW14RzVkWj/3
	ib79bfrq+hZ2NMnaCODoJOh4TlzF5r3n/dkA3IeOGLDg/9RIitMx344lYZ0c3/kQazP9k0XKkZlts
	AVPnqK7xehY+mcQR4SUfz6Xa1j9ypFc3s3GBIm9DDYk1pE0/sWtAkJ5CL3SslIHzy2hDbzu0QPMEw
	tFEU0kbQ==;
Received: from 2a02-8389-2341-5b80-e44b-b36a-6403-8f06.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:e44b:b36a:6403:8f06] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tVSJw-00000007liE-3Bte;
	Wed, 08 Jan 2025 09:25:49 +0000
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
Subject: [PATCH 07/10] nbd: fix queue freeze vs limits lock order
Date: Wed,  8 Jan 2025 10:25:04 +0100
Message-ID: <20250108092520.1325324-8-hch@lst.de>
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

This also allows removes the need for the separate __nbd_set_size helper,
so remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
---
 drivers/block/nbd.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 259bd57fc529..efa05c3c06bf 100644
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

