Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7498F54;
	Fri, 10 Jan 2025 05:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736488055; cv=none; b=mTZ0IrLCJG33N27WBNfESeC6YHTbArI/8WPhpwam0CaNvdrG37G8+BOV0kPBhrwPE4qQmMYz0QbpLkHs1u6C06xV2k92u4VFrDvnaMJyzl9p49y+40QBusKIi/lAQLMz7A9IdCQ+hrg0LtDA2gJjN7wzUqGv3Nmve9qHORp8FzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736488055; c=relaxed/simple;
	bh=7yPkZjV9SFPg5PNnZqf+XekZPLC8Qrfing5d2pguLVY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=bVhFvEGG0Njv0IZ98uBMX3/uiV0LxWmT80qKMb8YunNOI71TgoSUfN9HCx+WEhJkzm2qbh9bqh4jDQFYoJ1tO8fXK36Fu/f6jm3glCHDq7j7BpxsNtmnyezygyae4dnLAF22An2PktLHBHpNNXq9WjivVukDTgZ7bA13BKx8Oy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a1mw6y/v; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a1mw6y/v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=aCdPW6rZSRQIRUEsosZPtHUs6EG+ZdqdLnK/yxunuoo=; b=a1mw6y/vW1Ow6GFiYpL7XyZrgP
	XMyY0eaxrWPmBBYQ4r0vYwtuIPsy6nmZeZQ+IPRzlR1Leb9ospJoqWjZFAA9hh6JZ0jONOvDGMbNQ
	JlBzbhfOyWEChHm8caYONiTSwSn9TueccGpSjj75eoKIMbAjhm8SpPSqhVZ2TZc6bpAwQg0CxW3rm
	VQGbSCAk+KrewYkGqZ7Wustc9KZAlVAZIy9Vrhl6M8ggHNbBhEGmRnicWzMH16kp/zmywGVrq+sCx
	ZncCwfPGwMviSOoI7682zkJcFzQN1h6/xLu5BDgx8ERg9i1e8FmmD9CLWrPumu00WkrPcL7Q8U1i4
	nwNeRw+A==;
Received: from 2a02-8389-2341-5b80-76c3-a3dc-14f6-94e8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:76c3:a3dc:14f6:94e8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tW7rl-0000000E4rf-0XV5;
	Fri, 10 Jan 2025 05:47:29 +0000
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
Subject: fix queue freeze and limit locking order v4
Date: Fri, 10 Jan 2025 06:47:08 +0100
Message-ID: <20250110054726.1499538-1-hch@lst.de>
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

Changes since v3:
 - more comment fixups

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
