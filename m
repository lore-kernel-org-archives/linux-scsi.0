Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E42B1D6195;
	Wed, 15 Apr 2026 06:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776233303; cv=none; b=gAqCoHbSAElGolpVThstH8vbXwz/bcs+XquNBXQhML/jojP5sVbL4BH8Oe/BpqZsH5dJryjgYzihQcrwnDBeMfnag6874iZgF8/o9K2csceGkQSgybg0B93qF3v8nDhhTyycNZ15lu1q1ubk90Qtfds9JujzhLKtZVqtj4i5UZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776233303; c=relaxed/simple;
	bh=8jBq4cyz2BUIwnVTUA9cDrMyNHGSBbQxzd3aa2SS1fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sr2OgjIMGxSSQkrCPI5XdutxF4QJB7GqP4jL/uOocnT3EKsTn2xf8NMORAArh2V41XC4z1f9d6q9TrAqwJu2E6Bxart1jO+SekR4R6TcxXW43IiqX6deT8D68FLt7O8Z4U8Pjmax6HP/wC5Fgis+97oEAX20Kd8NHSabNi/edg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=vp09enV8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="vp09enV8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=1Z2UqEtEP4yNvRM+XPzG4KQRTaiD6rIubYf/Vva2dZI=; b=vp09enV845O0/XFERCp7NJjOwk
	gErGoeXKwrJdZtwPvITEytgO2VdVUBWXomuzpxVixE00BAyZfLm/SiFj3FDK1KvJutWgcOZXpYD/O
	/lPREtDFwnld/wKvp3YwwmTE4CNaiNyp5fUw4vllNmajxC6A/GAg52Sgv8IkfX6Dtt/HIcyKjqcjh
	vBHz0k7OYuUo1ihdDBNxSMFILprSIQ4Ran9UDnkIlNxWXr7QXGKtrHdknopFohlaCAGly0taPxVhI
	iyn9WhvdAHmTwG3JAMha/GqVCqJU9bsWV6HXHfU3GYnbRAU2yVmNYlwTjV44iQfq3DsYiKuB73Hm+
	1S0PwoBA==;
Received: from 2a02-8389-2341-5b80-decc-1a96-daaa-a2cc.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:decc:1a96:daaa:a2cc] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCtQD-00000000d3U-0nY5;
	Wed, 15 Apr 2026 06:08:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Doug Gilbert <dgilbert@interlog.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: [PATCH 1/2] sg: don't use GFP_ATOMIC in sg_start_req
Date: Wed, 15 Apr 2026 08:08:06 +0200
Message-ID: <20260415060813.807659-2-hch@lst.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260415060813.807659-1-hch@lst.de>
References: <20260415060813.807659-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

sg_start_req is called from normal user context and can sleep when
waiting for memory.  Switch it to use GFP_KERNEL, which fixes allocation
failures seend with the bio_alloc rework.

Fixes: b520c4eef83d ("block: split bio_alloc_bioset more clearly into a fast and slowpath")
Reported-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 37bac49f30f0..43265f012ce9 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1811,7 +1811,7 @@ sg_start_req(Sg_request *srp, unsigned char *cmd)
 	}
 
 	res = blk_rq_map_user_io(rq, md, hp->dxferp, hp->dxfer_len,
-			GFP_ATOMIC, iov_count, iov_count, 1, rw);
+			GFP_KERNEL, iov_count, iov_count, 1, rw);
 	if (!res) {
 		srp->bio = rq->bio;
 
-- 
2.53.0

