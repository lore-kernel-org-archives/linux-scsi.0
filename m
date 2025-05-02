Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73453266B6A;
	Fri,  2 May 2025 06:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746168581; cv=none; b=WziWlu2n4Fhugz+9eBWTQi2GAyUdHyo74bGUdlCWBvS8MXIG3R6xX0LPaPrgRbaLTQHZS8ErU+iyczFZnTxp9a5LSiaAzqATmw0TZKlTJXWhsQgTV2srV8hA6LnAyMC03qAQjz2JXANMMx6PqKFIDDfx+sKic/afBVh/oRPV2/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746168581; c=relaxed/simple;
	bh=HVkwrBOGhAKlee+KtVGxZ1VbGsX1k9D/WmNWSmYm/fI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ukFL4frLgHSkjkvLTrXb/MTqleItdXZlo+No9a5iEUkFDTKhziNEci0sSQdnVapnD9X8lvKgboFXEiN7GKyhy11ZoaicuCX79FLH68vN2CdPsscqgvj4llGPVw00na+oV+izVpfw4t72vJs5n1WZ6JW93VzIlK6gNOgbz6VqPXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=c7lDIAmS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="c7lDIAmS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=PORlUSLual3F6eJbqxK9YVY84oVvG6MW+mh4UJLeZPQ=; b=c7lDIAmSjjYZkc8QLiCauuXu4n
	irC60MC0eyrIPp8V/61UU+x4RBOnR+dDSc2tGQoTE57iXqLRPyvZkBUVIDmarAsnyNe29uUj3gjXg
	mXEPPGtcKoOgo9w83uFLB5kEQVJoZDw8/zZZsfGxa6PX8vxsHpkSxKVPQ/HYSgmphFn/uptkXiM3l
	PIcBTuSHqWVSVq4R4N0PnR3s/ZWl5vMyKffwd6EKfUXBJrHJYacS81JQuEJWyarjd11S4RVMoMLwj
	5DVh1Kaa3GLoEERhD7TQIaCqguBsSF0mmuNAQKPlWFce3t83K7aDXEn05WjFWMaN1T5sE2dCevYLo
	ahjxduQg==;
Received: from [185.143.37.16] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uAkDF-0000000113H-0pdI;
	Fri, 02 May 2025 06:49:33 +0000
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
Subject: remove block layer bounce buffering
Date: Fri,  2 May 2025 07:49:17 +0100
Message-ID: <20250502064930.2981820-1-hch@lst.de>
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
 b/drivers/usb/storage/usb.c         |   14 +
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
 23 files changed, 19 insertions(+), 346 deletions(-)
