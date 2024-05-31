Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA48945BFD;
	Fri, 31 May 2024 07:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717141734; cv=none; b=CwdKW6VnGoamyuPt3n5VaIWeNnc3hBn784wdP2YjvGMn44yY/BLRPMlEUqDv7U58JTtY1dNj6MmmpTWjMZHVxRq+EsS26w+zB+ckhjevYABpkgwOubsgVEkwlh8xizFU0oFFRv38qfSrH8CROHelf1/kr02VK8rFb/Rd6fx1Ko4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717141734; c=relaxed/simple;
	bh=6s3dPUbtDW90i9oEXfZStZfiWi66kMw8TeDivrJW3uc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=p+n3mjZjwq78WPd66AJgom/xcUJ0pSb97kL6ZA51se700FYO5R8ZwIcQxXWDVlsiQC483kXloL3ZmqqwL9r1ZS7E08UVmxHjsi9GipScZhqswXUfPt2/9DVk0edjHAaZZdRuq6L/zHpmF24/XY+jqj7uFkr2BR4jyvlxZG12hEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wh98Nvxt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wh98Nvxt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=X6ZSIyh1cBG1UFDOkvLStzuDyEP+AFeCGGHYkP7yPXE=; b=wh98NvxtuA1xZGSKFRioyMm51I
	vrfovyzZnajBqXQQrJzm7vrjL319N5CmN22SqQEH5AWCG3vSYC2Ehtl5dcKGB5JTVnjGnZ5BKPqLM
	k/8mUprcZcrR0sLsTDn+NROurZ//Aujt8btpgMENtK0/To9YThW/cFbdJDIRSieOZxuCL8t6W/I55
	BtAv6L1mDU06KnafTVhy4T18Em8h0Ba2Y70K4JL0T5UE87wHrD0U6qXXRuxbTCgayrCNZ2qZ6PffF
	YrCVgO4qoHmBcSzLnvh4ZzHMZzUuHyvAU4HVYk4J4d95GDSA618ThURvQ6uULdXsoDERjoAsBWfP6
	qbtPlb0Q==;
Received: from 2a02-8389-2341-5b80-5ba9-f4da-76fa-44a9.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:5ba9:f4da:76fa:44a9] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCx0C-00000009XUr-41fW;
	Fri, 31 May 2024 07:48:43 +0000
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
Subject: convert the SCSI ULDs to the atomic queue limits API v2
Date: Fri, 31 May 2024 09:47:55 +0200
Message-ID: <20240531074837.1648501-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

this series converts the SCSI upper level drivers to the atomic queue
limits API.

The first patch is a bug fix for ubd that later patches depend on and
might be worth picking up for 6.10.

The second patch changes the max_sectors calculation to take the optimal
I/O size into account so that sd, nbd and rbd don't have to mess with
the user max_sector value.  I'd love to see a careful review from the
nbd and rbd maintainers for this one!

The following patches clean up a few lose ends in the sd driver, and
then convert sd and sr to the atomic queue limits API.  The final
patches remove the now unused block APIs, and convert a few to be
specific to their now more narrow use case.

The patches are against Jens' block-6.10 tree.  Due to the amount of
block layer changes in here, and other that will depend on it, it
would be good if this could eventually be merged through the block
tree, or at least a shared branch between the SCSI and block trees.

Changes since v1:
 - change the io_opt value for rbd
 - fix a left-over direct assignent to q->limits
 - add a new patch to refactor the ubd interrupt handler
 - use an else if to micro-optimize the ubd error handling
 - also remove disk_set_max_open_zones and disk_set_max_active_zones
 - use SECTOR_SHIFT in one more place
 - various spelling fixes
 - comment formating fix

Diffstat:
 arch/um/drivers/ubd_kern.c   |   50 +++------
 block/blk-settings.c         |  238 +------------------------------------------
 drivers/block/nbd.c          |    2 
 drivers/block/rbd.c          |    3 
 drivers/block/xen-blkfront.c |    4 
 drivers/scsi/sd.c            |  222 ++++++++++++++++++++--------------------
 drivers/scsi/sd.h            |    6 -
 drivers/scsi/sd_zbc.c        |   27 ++--
 drivers/scsi/sr.c            |   42 ++++---
 include/linux/blkdev.h       |   52 +++------
 10 files changed, 210 insertions(+), 436 deletions(-)
