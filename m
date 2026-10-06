Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D45B0414408;
	Tue,  6 Oct 2026 12:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791290727; cv=none; b=c8ea/hwRUBXKA1JbWEfW9ZaUEv14KdoeSHNG1vVkE6qTsNMOaQRyW1+PKBajwlJlZBsjlJZ/pQZqoD88aZ8BOQChDMQfPSctjqPi4FYqVNNC2bsoYHOxnsLJoSh1++1j2HaIDoI6X7TM9H0G+EiDfSB3qahM9jWkFkQAb1aEXx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791290727; c=relaxed/simple;
	bh=Gjz6uHx0XXGqV0lNAvvqxt1D11pcdRKCQoGeLWkdQ9Y=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=IO+QOWtFzsyiV2pf1vkoQs6fWFiNhokxuWiQYe1k5xVTHhLs0xKolm4gIaNtIKmp7KSS1aJ3GJH3FTcDz8wPSXSlQQn7qtUlNZc/RkbxLinJsTKNAcSJVi8hGBAzPoxPQC8kVAb9yOlZoQr97UoeylKklVXa0Lu0ZFA8ZDiIw2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Zlmu7Wjj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Zlmu7Wjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641771F000FF;
	Tue,  6 Oct 2026 12:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791290712;
	bh=0J7EdM7hPIjTrQj04H/JOB7hP2Qt3CLF5ka6K3zMeqM=;
	h=From:To:Subject:Date;
	b=Zlmu7WjjY5Q5SmhyC1Lh6GkxQmObNIZUlCHQeDaxYLGUsl9GIkUzwdfFmzB7ninDv
	 wMXfka904tDFM4apyqcgwp+2AlB//UPy2xEW/x08S9IcPuwGmp12kaaNrAUDWwRjVG
	 JkqQgeSnfxoKOlltLTVX6cw0B8qAH0V6BaBk4mhHTQFxjff1bpnlsL65nk0RSqPpRh
	 ZH00dxA/6EU2T4lQHRI/h9O68dfwdkutKbOm9F7XLC3B7WtreODg2sos8ApDdDIl5S
	 HrE735QZdFvQVX84BdlB4MXpDdH6Fohc6C2lOgLCQfRQGCLUWjAKqNJdqTZNM5XRlt
	 iHqdHn0sc6d/g==
From: Damien Le Moal <dlemoal@kernel.org>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 0/7] Add support for storage element depopulation
Date: Tue,  6 Oct 2026 21:45:03 +0900
Message-ID: <20261006124510.882017-1-dlemoal@kernel.org>
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

Changes from v1:
 - Addressed the many valid comments that Sashiko add
   (https://sashiko.dev/#/patchset/20261005094632.580753-1-dlemoal%40kernel.org)
 - Rebased on latest block/for-next

Damien Le Moal (7):
  block: fail reads to offline zones early
  block: introduce storage element management
  block: add storage element management ioctls
  zloop: add storage element emulation
  zloop: add degrade_element control command
  scsi: sd_zbc: always revalidate zones for disks supporting head depopulation
  scsi: sd_zbc: define storage element management operations

 .../admin-guide/blockdev/zoned_loop.rst       |   8 +-
 block/blk-core.c                              |   3 +
 block/blk-zoned.c                             | 343 ++++++++-
 block/blk.h                                   |  15 +
 block/ioctl.c                                 |   5 +
 drivers/block/zloop.c                         | 670 ++++++++++++++++--
 drivers/scsi/sd.c                             |   3 +
 drivers/scsi/sd.h                             |   3 +
 drivers/scsi/sd_zbc.c                         | 259 ++++++-
 include/linux/blkdev.h                        |  16 +
 include/uapi/linux/blkzoned.h                 |  81 +++
 include/uapi/linux/fs.h                       |   1 +
 12 files changed, 1358 insertions(+), 49 deletions(-)

-- 
2.55.0

