Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46A31DED66;
	Tue,  7 Jan 2025 06:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736231488; cv=none; b=BhRm/JyBX2narQdmlj1oQa4nEkGG9R7U4HvG+HdAeiZ9IXQNsw2HPMQKTmcdrlP1UFgZF2e8aig+u5L2taPEVo1Av7vIIvpp0fKN2mZh17mZEKtogU+wE7OjrdQal5dyx9VZDBSDoefH/wzuEjWfRP9ECj8NxmH7EyKwgV4B/oY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736231488; c=relaxed/simple;
	bh=e06AhQpC04P9zZT7VwqdQ6B25Dny1hASLZ0r75fG0gs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VVkIg2zYpCNaTmS2Cs+xFHR020BbQGNJ5OVPvGkHtxnjrlit4+RApV1+Olrb0Y2yMQaoeRICB6ag4745JCHwbzxfi0pRBjpbMFqd+k1TqlEDVzwxhHD+bLzAqD46MFL4dxfJg0vwOZMr6tYb70XkXljqugNERfr7j4ELIwu4BGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=l8zEQzw/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l8zEQzw/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=TreWHTKV2tbBOHQr6HaKSg8mx5igp3LbRHsuMCPKwNw=; b=l8zEQzw/u++2XFk9bEzWvApa68
	RxWCrZOU1UeorEJ9VK91rRF1R7kTii4mBJj3REDkx+ysihUzTpaMy8Za7aU3QaS4Wx7iFKKREi2Db
	V17LC5D1A5lnC54dSkhFpdrD1hxGwtWjkkyOZGSeE0n0WVoTE21yw4GxaiHxxuHydxfzly3/Ek3Yz
	mCohROu/VloylPW4sPbhelO/wQWe83D0RmXjMEJkTEDyCcklSNTW+/jBxeKMc//MbgEbYNTnTHBj0
	VmSrlaXdngqlp9Jb2TBbqBKfSZPDpjOxikJYZY4sE+hig/xMTlcn1PUrc/qGpUdgU44A1S2/RrBGz
	+K3LmdHg==;
Received: from 2a02-8389-2341-5b80-d467-d75d-35bf-0eb6.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:d467:d75d:35bf:eb6] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tV37b-00000003dok-2sfk;
	Tue, 07 Jan 2025 06:31:24 +0000
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
Subject: fix queue freeze and limit locking order
Date: Tue,  7 Jan 2025 07:30:32 +0100
Message-ID: <20250107063120.1011593-1-hch@lst.de>
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

Changes since RFC:
 - fix a bizzare virtio_blk bisection snafu
 - set BLK_FEAT_POLL a little less eagerly for blk-mq
 - drop the loop patch just adding a comment
 - improve various commit logs and coments

Diffstat:
 block/blk-core.c               |   17 ++++-
 block/blk-integrity.c          |    4 -
 block/blk-mq.c                 |   17 -----
 block/blk-settings.c           |   27 ++++++++
 block/blk-sysfs.c              |  128 +++++++++++++++++++----------------------
 block/blk-zoned.c              |    7 --
 drivers/block/nbd.c            |   17 -----
 drivers/block/virtio_blk.c     |    4 -
 drivers/nvme/host/core.c       |    9 +-
 drivers/scsi/sd.c              |   17 +----
 drivers/scsi/sr.c              |    5 -
 drivers/usb/storage/scsiglue.c |    5 -
 include/linux/blkdev.h         |    5 -
 13 files changed, 123 insertions(+), 139 deletions(-)
