Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DC046444;
	Fri, 31 May 2024 07:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717141734; cv=none; b=PeOPiC4mb1KUA5d1CPQvLRRkaEcy5c3skqu49+miKWzbzhENXcjt/H+cAEJzJMSjekjKvelCrzIl4qoyWOL5n5M8sIpRy7m2PPLeCsjsGfi4z9D1h85Mc4rk6u2i8Lze006IhJQuJu0qjE4gEzJDfE6UgKuATOY5/S+3lO3/0X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717141734; c=relaxed/simple;
	bh=NlYhFFluyPdHug53y+5zIgMK/vtfzFrkT3ePgv0MpAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OCB4NGUv8sGHqz9hsFIyCpL9rOzT77vmCJLJPnhoKrUU/pn6sQVHOjJR0Rr2tASNZ3IzddlBbocBuSHCozS/K52AEq6tt7nbzP0CUKH5vPpVW7O8fFqkxij/wmRafOLtKXEVAi+TjkYrbdPE9SeAItZoaBy+a4Cb+2OM395fRB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=1A1yb09k; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="1A1yb09k"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8qWYYD/WE7sZdc6vKaSwzAcVLajLtvsC2W0WllIXaIM=; b=1A1yb09khg0zzo88GBpLvTFsHc
	tV8ef2UQ1VXidXvG732ApqmyCupKhGkL5G59GgO8xU8oyRy3a7wLIj5Fqsb7ozie1sIBv/ltIsHYx
	+btWJXOahq4wAEa2PPIJxwFXAazEivQE/BryJ8mbFTKha/lhrUy32leI2VIH6j6MGV9GQOA2CaiHz
	ExUMMEXqbTiHF//iRBxcXt5wvKwfJDb8BxMSI0kYUpaS1XbArUgDpnhBV5zsm3WXP9abkponn0rgr
	g9AmlPK83Uxe92IoHb7Jc1v2oHu4zV0TiIRlrabbLStJXmWX3Wjs0EvPEaMCe032BaHlcz+c/JPQo
	uvqey7Tw==;
Received: from 2a02-8389-2341-5b80-5ba9-f4da-76fa-44a9.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5ba9:f4da:76fa:44a9] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCx0I-00000009XVz-1ERf;
	Fri, 31 May 2024 07:48:46 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Josef Bacik <josef@toxicpanda.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	=?UTF-8?q?Roger=20Pau=20Monn=C3=A9?= <roger.pau@citrix.com>,
	linux-um@lists.infradead.org,
	linux-block@vger.kernel.org,
	nbd@other.debian.org,
	ceph-devel@vger.kernel.org,
	xen-devel@lists.xenproject.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 01/14] ubd: refactor the interrupt handler
Date: Fri, 31 May 2024 09:47:56 +0200
Message-ID: <20240531074837.1648501-2-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240531074837.1648501-1-hch@lst.de>
References: <20240531074837.1648501-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Instead of a separate handler function that leaves no work in the
interrupt hanler itself, split out a per-request end I/O helper and
clean up the coding style and variable naming while we're at it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 arch/um/drivers/ubd_kern.c | 49 ++++++++++++++------------------------
 1 file changed, 18 insertions(+), 31 deletions(-)

diff --git a/arch/um/drivers/ubd_kern.c b/arch/um/drivers/ubd_kern.c
index ef805eaa9e013d..0c9542d58c01b7 100644
--- a/arch/um/drivers/ubd_kern.c
+++ b/arch/um/drivers/ubd_kern.c
@@ -447,43 +447,30 @@ static int bulk_req_safe_read(
 	return n;
 }
 
-/* Called without dev->lock held, and only in interrupt context. */
-static void ubd_handler(void)
+static void ubd_end_request(struct io_thread_req *io_req)
 {
-	int n;
-	int count;
-
-	while(1){
-		n = bulk_req_safe_read(
-			thread_fd,
-			irq_req_buffer,
-			&irq_remainder,
-			&irq_remainder_size,
-			UBD_REQ_BUFFER_SIZE
-		);
-		if (n < 0) {
-			if(n == -EAGAIN)
-				break;
-			printk(KERN_ERR "spurious interrupt in ubd_handler, "
-			       "err = %d\n", -n);
-			return;
-		}
-		for (count = 0; count < n/sizeof(struct io_thread_req *); count++) {
-			struct io_thread_req *io_req = (*irq_req_buffer)[count];
-
-			if ((io_req->error == BLK_STS_NOTSUPP) && (req_op(io_req->req) == REQ_OP_DISCARD)) {
-				blk_queue_max_discard_sectors(io_req->req->q, 0);
-				blk_queue_max_write_zeroes_sectors(io_req->req->q, 0);
-			}
-			blk_mq_end_request(io_req->req, io_req->error);
-			kfree(io_req);
-		}
+	if (io_req->error == BLK_STS_NOTSUPP &&
+	    req_op(io_req->req) == REQ_OP_DISCARD) {
+		blk_queue_max_discard_sectors(io_req->req->q, 0);
+		blk_queue_max_write_zeroes_sectors(io_req->req->q, 0);
 	}
+	blk_mq_end_request(io_req->req, io_req->error);
+	kfree(io_req);
 }
 
 static irqreturn_t ubd_intr(int irq, void *dev)
 {
-	ubd_handler();
+	int len, i;
+
+	while ((len = bulk_req_safe_read(thread_fd, irq_req_buffer,
+			&irq_remainder, &irq_remainder_size,
+			UBD_REQ_BUFFER_SIZE)) >= 0) {
+		for (i = 0; i < len / sizeof(struct io_thread_req *); i++)
+			ubd_end_request((*irq_req_buffer)[i]);
+	}
+
+	if (len < 0 && len != -EAGAIN)
+		pr_err("spurious interrupt in %s, err = %d\n", __func__, len);
 	return IRQ_HANDLED;
 }
 
-- 
2.43.0

