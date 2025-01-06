Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54241DC74A;
	Mon,  6 Jan 2025 10:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736158047; cv=none; b=kt0/BnhdUhKZ2YziSOSfgn4YetyvDIPfD8HhGMGh2N4iYDC4x54V5G9DnZ8uLtQSlN0NSGL8yxD+WmPcQ2RbGBp5/twECLEVF7sNCViVMjpDv4IrntcinnqGRoAaIgGoIlkJ0umtK3Rd1zaru2/pPFjSdNi9OgalI+fqGnZ5pvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736158047; c=relaxed/simple;
	bh=0cw/SfZwIVWiRGNpenbX/9Ik1CKAkxnzfH118SlsyBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ukixtlCJpR9Sdh86OUKFB3JnnLKK8R5O1xSTfiVH5lNwqKzcniJ6OFCpZPUl5hn+6gyf+HDYpgzspdLOx30rnvigZ4jYGMrLhqY17HvQTyDy44v7p3i/skGXxjcnnD3+t/FVCR7f9cACDYX4xVM84DnuKeB+DBF3JSqnWawjZb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=uorFDHRE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="uorFDHRE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3euJA8Ns15KPhEkUiWNhzNcQI81/iMSrckSXcWqOPgE=; b=uorFDHREReYWiG9VtntQ9e8Y4e
	knOrAohZ7GSdXpgJ0ql5KsoglIrI/4AQoizpvqQxtgIF9h9oX6kwTL57AqL6FYcNQ3jcMJwsXfRyw
	Ad+wn/BcsWKrad/djehuaG7sVtiswvLrQSjc7xszPjuNzxlv7xB5hLbg78XFRvwE1bpv66djMNrLv
	L91a90sN7kdq2qewGkkpbQ9Yhi6fgnbTqYLJq7xlKd+ill487SJnPqMn2MMkOk/obe9fMGukkRhaD
	XCV2m5yDT2L+bhhu+v2EOs3nkqJesZNYGP9uWl9sPlhRHST1O/ufpZ2/xjPd7toADN/8gJvnkl/Yd
	+3Ws0ylA==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUk0t-00000000ng8-2TWU;
	Mon, 06 Jan 2025 10:07:12 +0000
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
Subject: [PATCH 09/10] loop: document why loop_clear_limits updates queue limits without freezing
Date: Mon,  6 Jan 2025 11:06:22 +0100
Message-ID: <20250106100645.850445-10-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/loop.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 836a53eef4b4..84b007b9c38c 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -311,6 +311,13 @@ static void loop_clear_limits(struct loop_device *lo, int mode)
 		lim.discard_granularity = 0;
 	}
 
+	/*
+	 * XXX: this updates the queue limits without freezing the queue, which
+	 * is against the locking protocol and dangerous.  But we can't just
+	 * freeze the queue as we're inside the ->queue_rq method here.  So this
+	 * should move out into a workqueue unless we get the file operations to
+	 * advertise if they support specific fallocate operations.
+	 */
 	queue_limits_commit_update(lo->lo_queue, &lim);
 }
 
-- 
2.45.2

