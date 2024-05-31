Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDDF81AD7;
	Fri, 31 May 2024 07:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717141750; cv=none; b=gPHYLjGmVYWBqOcFtNtck3woRTaCGbNBe3btefWyndDbkGRfmzThQQZTyvScLZ6uzQqPermFkCoWByY3oudHKScC2+4fG25dzAGdc54pgvCdeTK7DD1aqG/B3RqAfDG5L7VyWlFtbmkclIX8UxxBjvclfJkjB2t7l6OzbIy3FsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717141750; c=relaxed/simple;
	bh=BWeSgsyKAyWvxKhyj7ecQxEY0YAHjV3e/hGqYy5Sbz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fygff7uIkE4ig7rkawWnOJ267uvcwXee7V9OqXGuAMC8SBDrjOcr64AI3oqW/+fTkgQEt322ZpLxuEUfMSa4/lxqXuxNvmD4ixf4FUB2DTAkrMsxPdgH+uQLoTZkSb84G2JmDvOvF9RXWKo78pxWKAe8e76QZ7WfXBUF3s4K/GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lzSvXRRw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lzSvXRRw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=HN2Hktsuqrp8T8GVou6AHcXHJfFLm1CDuoHLTArZtbQ=; b=lzSvXRRwzld/pMYWiFEKRDRG2R
	S8H/9KAsLWG+7rCB0xOZNV350iYhUSHRfAKBFICCqHErh6IeHq2cVZLjPLGTNwt0sKNOjOyQMdSDV
	AEJE2W/7wU/JPARqknHB/teDENsrfXzvflDt8grlnj+PbL6uFlGnmyIPKa9bJ37oUrbUpR+ZsEMve
	N/VNYOyU0GCIc2LMMuiQtuHRwpXnbqjHrYK53jvCzl6pWVmFQXJCKXQHsMvt3zWuBGJhUyOSUlMbY
	CkQ2uUkan33bspD1IDNqzU7wQgTUkNAjBNx4O8h/zxKzZMwt7T8O1npKByu3eerVKPrQQXprz/j9N
	t+/ZgFRw==;
Received: from 2a02-8389-2341-5b80-5ba9-f4da-76fa-44a9.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5ba9:f4da:76fa:44a9] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCx0a-00000009Xfo-0bb2;
	Fri, 31 May 2024 07:49:04 +0000
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
	linux-scsi@vger.kernel.org,
	Bart Van Assche <bvanassche@acm.org>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 08/14] sd: simplify the disable case in sd_config_discard
Date: Fri, 31 May 2024 09:48:03 +0200
Message-ID: <20240531074837.1648501-9-hch@lst.de>
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

Fall through to the main call to blk_queue_max_discard_sectors given that
max_blocks has been initialized to zero above instead of duplicating the
call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/scsi/sd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 70211d0b187652..0dbc6eb7a7cac3 100644
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

