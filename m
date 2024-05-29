Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C98FA15B572;
	Wed, 29 May 2024 05:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716959123; cv=none; b=jb3bJ1pPNrij/4KEeot+58GHIs80sPJIuD1KUaKpFW1V4xmfKIoQNWlV/OoBc4cUMX445fZ0KnpGQY5v5hW2MVeZ9/jIDgiwb6IDLKVT4W2lIIpSV3679TCkkhLEBA3az/1NXEOoOuyZ98pllwkoxXY4TEkYQf1ywcICP4PF0uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716959123; c=relaxed/simple;
	bh=ZlR0M/WDziIdI3zApUxmnVbN25kmmXkWi5Zxl1krXKU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SqqyQt9myZj9mTqz3rvDMDmBZIVEys91cQXi2J8NjVKq5jyk/qrcUN1ARE+vAZ2ukxA04k/+GXs3t0LUVjWYwiXCZbLCpA7N/qolsyDXxo7c7tdl9herJ0e9ueYU/nJUxXjOFR7TqtlFYEdX6kKsp1TA+ZdhmkJ/iiR+bO9Lrgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=j6TH1jV+; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="j6TH1jV+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=TkLi7QJRJk+eDm0XKX9y4O+chg+2e2GHQobCf0qIp3Q=; b=j6TH1jV+bD9SRCoTjPn2/w5mPx
	Sn9ZORQd/0Vc8GCHMbe57GctL2xLaw94IPMXbiJcX95T1JOMiz6/rTaTDfBNMHzt2nFlgKG30WzoF
	dIAc0Wxprcex1TUAE9kVEamco0ms0NAnDTyHDmkwxAjOMGcnTzwA/qjowsfaaOxk+Q7ohP80n6DFh
	v0tR+RqojdE8wkTeuKbpKCEu64xWSJW+O63gy+h/ERmksEVT5Z+j3VJtipRNQyIKdFcIPJifoT7Lc
	JNKkuNwua/4XXVb82UFUzCKKgQOn1LTgSY21EVqNBDHbXJZj6E9u2XVKVoPDNoZ/0QiJ/ZgSUMdps
	IHDNZnvQ==;
Received: from 2a02-8389-2341-5b80-7775-b725-99f7-3344.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:7775:b725:99f7:3344] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sCBUs-00000002pSJ-2CVr;
	Wed, 29 May 2024 05:05:11 +0000
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
Subject: convert the SCSI ULDs to the atomic queue limits API
Date: Wed, 29 May 2024 07:04:02 +0200
Message-ID: <20240529050507.1392041-1-hch@lst.de>
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

Diffstat:
 arch/um/drivers/ubd_kern.c   |   10 +
 block/blk-settings.c         |  238 +------------------------------------------
 drivers/block/nbd.c          |    2 
 drivers/block/rbd.c          |    1 
 drivers/block/xen-blkfront.c |    4 
 drivers/scsi/sd.c            |  218 ++++++++++++++++++++-------------------
 drivers/scsi/sd.h            |    6 -
 drivers/scsi/sd_zbc.c        |   27 ++--
 drivers/scsi/sr.c            |   42 ++++---
 include/linux/blkdev.h       |   40 +++----
 10 files changed, 196 insertions(+), 392 deletions(-)
