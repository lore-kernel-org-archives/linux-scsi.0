Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD60B46C846;
	Mon,  5 Oct 2026 09:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193603; cv=none; b=HYPShShtteuAVWcTa4ly8iz/Z0AkkwYVz44ksRZwX38KooZMwGw04/W2njC3PkuLEBPWmAMKpz1gBp9F/C6kW9BPDF14tfoNvEvvGH2s9wlrsmWOz3iVVkIE0psM0BVjqW9mpvhH0eAVhOBS62u4XSFl6efClyR65mDaQ/7X7ug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193603; c=relaxed/simple;
	bh=cULsydSoxKfZySOiuO3dWwPuX0w/E4/HqBoOsqo862c=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Uvv9Y0Z7xo2nOucOoW5h3EUXrFTQrefFiiWSNRtJptZCaO3owJYYFKkLyou9T+N6GPoslIaCNPMoJUgyypVIj1d8M42WEkbs9wpI/VFy2cNp8LvYnc1XrXqSvWB2qRdDwlYVtPzTo+LD4TRWbqBQP3gjhyhnl3db7xpNoMWXewA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eMiUSAih; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eMiUSAih"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 030D11F008A1;
	Mon,  5 Oct 2026 09:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791193594;
	bh=zf7tLPkYCCrvor3xzXGC5YXaR/WxA1hFQTBPT6ZCOvg=;
	h=From:To:Subject:Date;
	b=eMiUSAihMc7VMQbKA8zqSA4ypCKTiwecNxOB2vU7XdY1nLDmbMlAt2krvsPkOMLhC
	 LWV+R8YAIai0+U9FRaav3xbALyHo77AkdBd5ZQc8heqoDR/Xc/vFQis8ncFVZ0GxGZ
	 TuUYkAwpxWDd+U3Iw0hWURKSDtTPyNBa3y6gRyRRBIFshafqFm6Ae90xezB+nlYCGd
	 Q0QtSQz/aFG5cGtPom7wYkrf+nIEu3zTX2pxIGYLkLSbR4RYiibs4E+vrP+AF8vWjP
	 h81mHKy4PNvY4s4ugnji3qr7i/Aq8/+lPM1K/jQVoF9qnx9iFSHkpCM7CRHkq1QvmW
	 6nrsCwSg2aiOA==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0/7] Add support for storage element depopulation
Date: Mon,  5 Oct 2026 18:46:25 +0900
Message-ID: <20261005094632.580753-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Jens,

These patches define a new set of block device operations for generically
using from the block layer the storage element depopulation feature of
zoned block devices. Support for this feature is added to the SCSI disk
driver and an emulation of this feature added to the zloop driver.

The management operations can be accessed using block layer API, which is
intended for file systems (e.g. zonefs and XFS), as well as using ioctls
for users using zoned disks directly from user space.

Damien Le Moal (7):
  block: fail reads to offline zones early
  block: introduce storage element management
  block: add storage element management ioctls
  zloop: add storage element emulation
  zloop: add degrade_element control command
  scsi: sd_zbc: always revalidate zones for disks supporting head depopulation
  scsi: sd_zbc: define storage element management operations

 .../admin-guide/blockdev/zoned_loop.rst       |   8 +-
 block/blk-core.c                              |   5 +
 block/blk-zoned.c                             | 300 ++++++++-
 block/blk.h                                   |  15 +
 block/ioctl.c                                 |   5 +
 drivers/block/zloop.c                         | 616 +++++++++++++++++-
 drivers/scsi/sd.c                             |   1 +
 drivers/scsi/sd.h                             |   5 +
 drivers/scsi/sd_zbc.c                         | 236 ++++++-
 include/linux/blkdev.h                        |  16 +
 include/uapi/linux/blkzoned.h                 |  81 +++
 include/uapi/linux/fs.h                       |   1 +
 12 files changed, 1257 insertions(+), 32 deletions(-)

-- 
2.55.0

