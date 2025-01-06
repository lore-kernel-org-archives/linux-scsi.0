Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1326194A54;
	Mon,  6 Jan 2025 10:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736158012; cv=none; b=NbVUJiBNo9pHeEhPqiTQKuFqtX/Ywmg4I0C9ZL/SnxEZs34fUDO72wkHF4BLh4nqtoXnPTkPkgNOMmN54T1drDiOZItikW8+SVwF+ozErcJ2+c4Ti3spby8yIEQji0Gl3N7mUj8ZMg/TsQ5INYXOiftTMXfq7H7EHs65gLI/aig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736158012; c=relaxed/simple;
	bh=VRWKnkpDnU051nSa7S/u5wGbyDZrFZQvHWEmGQOBNRY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gta4XuZttQanoJLQS8Cx3QNu6PReN8ed8/UnQXk1ikVm8nHUJq+K6jeFSgQksBqaHrR2L5xNAoIR1X/DAvyi1QBLH1V5g9zfsTsat+xS40WVcXeLhj0iePOngiPrdzogdhkDqiOnZmXZE9SDuqrc1n0CaQBGW0kHE3O2OfFAfOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=0ldKwdTX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="0ldKwdTX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=qZv24j8F2g6J/b5MqylaQJhK6N+YiXOrkM+eWYXeu38=; b=0ldKwdTXZjuczKSHo2ZL81ck+h
	e08haCOSnDmHlurRMkdRyblunbazBLz9PQ6ZdFZ7uYFPi2j0fYmmYVyDvMpxLOLpslO93wbaldpeD
	fVN6ho0ETzSApJqqE52/t2hojI+u7nmX/6QIx+9PCRxUoi2AGi+gDuSAr/gViPRfsr51f0P7RUEkp
	fL+E1dxAJRi14P7fNmDsMsO9EoEhFCOjLhAcoWkbPc6Np6de0MdiHu5Ot8eSqidE622pATCOVq0F4
	wfssdJBtSrNCMVuLnPO1IJ15mw0nx36hdxoznQ3iUiAkjcoPBT0e6eOFMcdP+yGnDURC0WgP5zQU4
	int8xt4g==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUk0W-00000000nNn-0ZWj;
	Mon, 06 Jan 2025 10:06:48 +0000
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
Subject: RFC: fix queue freeze and limit locking order (alt take)
Date: Mon,  6 Jan 2025 11:06:13 +0100
Message-ID: <20250106100645.850445-1-hch@lst.de>
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

The changelogs are very sparse as the moment as I started it before the
holidays and just finished it enough to send it out as a RFC today.

Diffstat:
 block/blk-core.c               |   14 +++-
 block/blk-integrity.c          |    4 -
 block/blk-mq.c                 |   19 ------
 block/blk-mq.h                 |    6 +
 block/blk-settings.c           |   27 ++++++++
 block/blk-sysfs.c              |  128 +++++++++++++++++++----------------------
 block/blk-zoned.c              |    7 --
 drivers/block/loop.c           |    7 ++
 drivers/block/nbd.c            |   17 -----
 drivers/block/virtio_blk.c     |    4 -
 drivers/nvme/host/core.c       |    9 +-
 drivers/scsi/sd.c              |   17 +----
 drivers/scsi/sr.c              |    5 -
 drivers/usb/storage/scsiglue.c |    5 -
 include/linux/blkdev.h         |    5 -
 15 files changed, 133 insertions(+), 141 deletions(-)
