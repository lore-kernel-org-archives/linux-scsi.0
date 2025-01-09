Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455F61FBEA6;
	Thu,  9 Jan 2025 05:58:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736402302; cv=none; b=bZY/jeXtHndvN+dAQkmqecLZyrfGp/Tb/V7kjbLjHtaaFwd2RelXpolYYTSwJsctifjnmAgxhnpmCuO033J08jLr/bnB2MpjKVR4zT252PaPZD+IWYkU7Tw6+QWzjjp3r6J3GIFWXy35mVAi2JigdQr34GInP7X8Q7+oqHmeOxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736402302; c=relaxed/simple;
	bh=H3PtEdPDxoNtq8/aHhM4+vA6XXgdiAd5Q96eNGxhGgA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=agMKEt9Ozcy+ep14xzq1eDLw2gTKCWfGj8ZGZz3aPNfuAEwcyyDsPpkRtvQf6gw8onpFW896E6+K7BxMfot+nBzYLnWBYeQHYo1OHIOKrV6PURuFPTuRFpfgQKA4NmqdSIpedDaNytNGQoYx55v5mcoW712EQG0QOEPL7Akut2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=EBTBa7P6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EBTBa7P6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=RV6MVgH2DNJxl8EQ0KHNCuUkupBWVrL6lb2FtLgyOeM=; b=EBTBa7P6nyJwJDoZ3F2Q0jIXRC
	c0+L6d31WFC244bP66+Bc1YzYa992JLRfVV6l3gmQS8qf1mtzXNbwPsRjQJXzC97B7H52o6pIzyet
	5jtcMoizqARANnzDI7fVf9dDTGRGu7pFK29C6qvExc6UBUCBGC3ttbjdlQ1J8HogJmyEJqfbr2pet
	4Eop1tzhVc8ikFKB5xBVRg4Nmdn+i6Alo53XwHt6jG0xtvrZQ0xOCaLgT1HKd/dAmk3d5tYzGNxta
	rtaapb+fWF0AQCoqSpFGFd/iTQo7CSyLMb0SV1qX8wA//Rk62CLmErLJ3q1+KrJvzZLDAHJbKfrkh
	cdf6ThGA==;
Received: from 2a02-8389-2341-5b80-ddeb-cdec-70b9-e2f0.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:ddeb:cdec:70b9:e2f0] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tVlYc-0000000ArC0-2oRo;
	Thu, 09 Jan 2025 05:58:15 +0000
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
Subject: fix queue freeze and limit locking order v3
Date: Thu,  9 Jan 2025 06:57:21 +0100
Message-ID: <20250109055810.1402918-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this is my version of Damien's "Fix queue freeze and limit locking order".
A lot looks very similar, but it was done independently based on the
previous discussion.

Changes since v2:
 - check for polling support under q_usage_counter
 - improve a commit log

Changes since v1:
 - more comment typo fixing
 - fix loop as well
 - make the poll sysfs attr show method more accurate
 
Changes since RFC:
 - fix a bizzare virtio_blk bisection snafu
 - set BLK_FEAT_POLL a little less eagerly for blk-mq
 - drop the loop patch just adding a comment
 - improve various commit logs and coments

Diffstat:
 block/blk-core.c               |   17 ++++-
 block/blk-integrity.c          |    4 -
 block/blk-mq.c                 |   17 -----
 block/blk-settings.c           |   27 +++++++-
 block/blk-sysfs.c              |  134 ++++++++++++++++++++---------------------
 block/blk-zoned.c              |    7 --
 block/blk.h                    |    1 
 drivers/block/loop.c           |   52 ++++++++++-----
 drivers/block/nbd.c            |   17 -----
 drivers/block/virtio_blk.c     |    4 -
 drivers/nvme/host/core.c       |    9 +-
 drivers/scsi/sd.c              |   17 +----
 drivers/scsi/sr.c              |    5 -
 drivers/usb/storage/scsiglue.c |    5 -
 include/linux/blkdev.h         |    5 -
 15 files changed, 164 insertions(+), 157 deletions(-)
