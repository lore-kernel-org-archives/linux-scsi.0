Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E461DFE0F;
	Wed,  8 Jan 2025 09:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736328326; cv=none; b=uz/+zxEyWpz7g31o/5KZlIhbMc+qheyT1Ye2SHwKoCTnfL06dGgEx+1O4Af8boW+ZWIXS2nVfZrucZbf70EztPl4w9y2Aka2bDCdKIKtSbieUX9qiKvbj7FOWYB4OKXRZJyMae+bXgY0F4NZ+pel+oN1e1KG1bfrnvYr7cewEdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736328326; c=relaxed/simple;
	bh=FFgW0j1yaIXwK39khgwmIcTdemdFiuGf+LUXNTDYOrw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=irER51eO00SvdtK5VErgYLabuhH0lQW3iAgoF34SsigjPPufQuI+3QD9UF1fR3Qsrg374e9BpTlxDV0njXD7O3weqS11mPj/la3ykavBl9NCikKcJsIVLSO3AdYEb9jw+TAivNWpGss1Ty9ixHDHRI/nAJ1M7oOo2jFPe6k3wXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PbEZjoi8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PbEZjoi8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=ryN0z1Pp3IvUFA7Af5iKRLT0TkpMzEngq0fQMHX47v8=; b=PbEZjoi8R7AHtgeqHEdx2xq/Y+
	MvbTIP2dqEt3CCoyBUcO9sISsHtvySjiTKrt4IGnxQgzrtm2I9doeRxuMivSaziOhgtGysx0UUGIT
	3U58D+fiwGqGhmH6jZ33FOXW5flKIqJCV0AKN0viQyzZur5Z+GiV/dIwx3cmYiefoiX3SQ9z4dEIN
	ME0gTCMsStalLn9jCXgG0aUh95XTBDToq9K9VxOBlHUboRd4FjL12C+WIjJnJ9Vs3H9QvxxuhLMmb
	aZp0MVyI0DwB2J60GQvvjnc/KAii+8YBZZJrWpqXq/EdCu2K4hc2E24PnVykOuU4sc5p2dtZSWXeS
	e7Or5HSw==;
Received: from 2a02-8389-2341-5b80-e44b-b36a-6403-8f06.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:e44b:b36a:6403:8f06] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tVSJX-00000007lPb-02aU;
	Wed, 08 Jan 2025 09:25:23 +0000
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
Subject: fix queue freeze and limit locking order v2
Date: Wed,  8 Jan 2025 10:24:57 +0100
Message-ID: <20250108092520.1325324-1-hch@lst.de>
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
