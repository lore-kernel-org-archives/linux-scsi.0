Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F72D15574E;
	Mon,  5 May 2025 08:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746432705; cv=none; b=bxI6Dv/pvyxLRKMxikj5AQ7EKl/D7rOHCjFe2dIFRDXMFQ6/ddmhldifJr+yxleeQkyQucZxrgbLn7F55AYH8CkAgYMWSWPAj6zmwAt5WuQTYKJDU1l/mGoX63EluQ5sBPFFC81mAtHmlDej7oEVzrK+7XQDjuPCwrjxQvw3+KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746432705; c=relaxed/simple;
	bh=X168Aj+34UUq8bWB7AGwPX/PV7z6d5vuYXg9DfhkY24=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d230EvVQpESwaSI+vLtU4uj+U9r46vu1tWhVe9fOpedR21qzPuVgpd7fFm/4bspUi/dSKP3O7YC6oC3j6VDvdWdFw+iqxt0J9KU2U2zAfxR5sIelHn84ko1IHVINpp5DCUaBAzafPpHVIksidr4TAjwdBhv1ikRh9xNMJCYvlFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=J3SkZh3i; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="J3SkZh3i"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=3iYir0svrPREZsuAI9zUOmn/2aFb/3+lUVePkEAsr8M=; b=J3SkZh3iWES6iuOOXNkIODhGKK
	ghJ7PhZ9TRnqEjERMVAoIOGlMcxGYdthKpLM13JXjRaWvvNsY3U9QDz1mPLgXxkVBP/hUST99AHdz
	R00gkRjcUmws1GslHBtXw2DqkffH18NSU3821Bdpf9exL6EEo9Neof5t46FoawWrPq3bNONeXacX4
	TR0Si9V4paGk/V2mNK8CdxK/aR0bK1HOOIKKBvBwaUH0ldxxNX0jGEX8g3ZBem8ix3Ulbrn4H2NS+
	mXAn4fkTDkNbMzcC2UM3ZNlM6jubUMwXH5+cCAgH2W0xAsLaUSsIu/MMLeoYjU1yLnlb5vQQ1eqOf
	6YLOEppA==;
Received: from 2a02-8389-2341-5b80-f2ef-69c9-6274-23a2.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:f2ef:69c9:6274:23a2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uBqvN-00000006kT2-1qJG;
	Mon, 05 May 2025 08:11:42 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	linux-mm@kvack.org
Subject: remove block layer bounce buffering v2
Date: Mon,  5 May 2025 10:11:19 +0200
Message-ID: <20250505081138.3435992-1-hch@lst.de>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

the block layer bounce buffering from the early days of highmem keeps
being a wart in the block layer despite usage by only four drivers,
all through the SCSI layer.  One of them is an old PIO-only ISA
card, two are parallel port adapters, and the fourth is the usb-storage
driver.

This series makes the first three depend on !HIGHMEM and for the fourth
rejects the probe only when used on highmem system and the HCD is one
of the few annoying one that does not support DMA.

This is not the most pretty way to do things, but none of the driver
maintainers stepped up to convert them to properly kmapping buffers
before doing PIO or MMIO operations it does shift the burden to these
drivers and might get them to actually move that way if there are any
users of the drivers, or in case of usb-storage configurations left.

A nice benefit is that we remove the per-numa node stat used for the
number of bounce buffer operations.

Changes since v1:
 - return -EINVAL from usb-storage ->probe
 - improve the error message in usb-storage
 - improve comments in usb-storage

Diffstat:
 b/arch/mips/configs/gcw0_defconfig  |    1 
 b/block/Makefile                    |    1 
 b/block/blk-map.c                   |    5 
 b/block/blk-mq.c                    |    2 
 b/block/blk-settings.c              |    5 
 b/block/blk.h                       |   17 --
 b/drivers/base/node.c               |    2 
 b/drivers/scsi/Kconfig              |    3 
 b/drivers/scsi/aha152x.c            |    1 
 b/drivers/scsi/imm.c                |    1 
 b/drivers/scsi/ppa.c                |    1 
 b/drivers/scsi/scsi_lib.c           |    3 
 b/drivers/usb/storage/usb.c         |   20 +-
 b/fs/proc/meminfo.c                 |    3 
 b/include/linux/blk_types.h         |    1 
 b/include/linux/blkdev.h            |    5 
 b/include/linux/mmzone.h            |    1 
 b/include/scsi/scsi_host.h          |    2 
 b/include/trace/events/block.h      |   15 --
 b/include/uapi/linux/blktrace_api.h |    2 
 b/kernel/trace/blktrace.c           |    9 -
 b/mm/show_mem.c                     |    4 
 block/bounce.c                      |  267 ------------------------------------
 23 files changed, 24 insertions(+), 347 deletions(-)
