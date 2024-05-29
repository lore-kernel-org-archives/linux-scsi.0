Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71AA915B964;
	Wed, 29 May 2024 05:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716959131; cv=none; b=DTCpMxH+oo1BAoK7mpA6YTAe9ABWfcTZ7wlm7ygRBj1YX3awfqZoeuEhfrOaWkB6erJ7Ig79WpcmzUHdyNZxW2h/Gcsn/4hBVzJ5X4F+5cfDb90qyCzjctwhxnGcVgKsS9vbo0YYexfHSaIu5ShLqXtOTggYRoSp7CgVJpH7Ek8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716959131; c=relaxed/simple;
	bh=XmzTsszru4m/N885xaWb1rQknjw+uTNS+ayTlGAwuDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MuU4xLOCBLJYWvr7Lp1V0eXrsgWIN5N6cweoazRd0BRu7SdItprfUOP4NCHknIQvgzwC2xBQqNZJXfRGT924i1f1DlOH8HbDOpnFzy1Krme89TJIFG19Y6tZbC7vq/6Syk1r9P2q2A606NzJMLfukqjArntcD1mHV8Dv11eOY/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=KhFS/hxR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="KhFS/hxR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YGmOwuIW0DehI4KXZwtqg3QuYxifQjapgz3/0XZe+RA=; b=KhFS/hxRb8UpO9uvnt4jA68rPG
	xVySn1pHD4jIRemyRbCCEdqXZl0xtjnDLGWGYQO/VqtIGw3kO7PMotHaHvYeF3y7+zrWI6JoWm7Pu
	K36zrJ5O9E7hHC8jFyqb0xPEFI8urWGQgmpxKmKvuJcI1lc4KbirfQgyMqZqdMiNOH0Qn6YwwfkIE
	fgfo+VGAtqPz4gTfBDOjANwyIRtH8WAho9J73pWTOMMk8H6xVuduHp7xwShRKISMLaacYAKT5bsRv
	hrsO1G72IRV/pFLruJ2/ijU+K3F58b+tzy0n/xqUnJBi8VNnAK04O7UkNZ4e+JaGUDKq6/ezYTnGO
	RPYgZo2w==;
Received: from 2a02-8389-2341-5b80-7775-b725-99f7-3344.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:7775:b725:99f7:3344] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCBV8-00000002pZH-1Swh;
	Wed, 29 May 2024 05:05:26 +0000
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
Subject: [PATCH 06/12] sd: simplify the disable case in sd_config_discard
Date: Wed, 29 May 2024 07:04:08 +0200
Message-ID: <20240529050507.1392041-7-hch@lst.de>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240529050507.1392041-1-hch@lst.de>
References: <20240529050507.1392041-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Fall through to the main call to blk_queue_max_discard_sectors given that
max_blocks has been initialized to zero above instead of duplicating the
call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/sd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 09ffe9d826aeac..437743e3a0d37d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -844,8 +844,7 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
 
 	case SD_LBP_FULL:
 	case SD_LBP_DISABLE:
-		blk_queue_max_discard_sectors(q, 0);
-		return;
+		break;
 
 	case SD_LBP_UNMAP:
 		max_blocks = min_not_zero(sdkp->max_unmap_blocks,
-- 
2.43.0

