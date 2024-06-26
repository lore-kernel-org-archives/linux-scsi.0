Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47F245C07;
	Wed, 26 Jun 2024 14:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719412010; cv=none; b=XdU7glbWbqT+8c6f6hc7Kwt3zIJqsD/nUKEAnDVQI35Lu2fNZXM0Dicsf4rbeL1tEyx1TyaI3VOK2RJRi2lo/grMXKMKnd03CM7t8IwrgIy1JHOSHT/kFhPbcKmA1VE5/nymJJe3meGpbULbrR7f0ONgAsqfcPlJORoubf4XudA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719412010; c=relaxed/simple;
	bh=gpKXemNbYHWOqH2GHVu6mRpMdKo90maFTmdXXV0nR5c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VqBNkCbeFFRIcCj6x63UeMSchByusMJ+zVG+mYBEU30BBJG/vZwaz4OIEP5Vs0DRprukeTId5cWb5W0wANgsCyYs/wLyzW0D9cRylU+y3fUuMA6KfXcd6srrTm4WBvI2tS2Y2kRc2FjwlK3Vnt+Xny5cEIsS3r2Vutx49q+dbhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=HVQz5QHo; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="HVQz5QHo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=lFf8qNmjo6Nj33hDTbujEk2BDEk3+cT37RSj9EYUc6E=; b=HVQz5QHoUBHle3oNOh86oc/Gdc
	0L7GbPiDEHY3ykjKzgIAE82lnPKYlCfYHhVdr0H504mRBLElPU7c6m8lovpOJMWfh0YwQ5UsbXg5j
	3uoCzisuR5W7Nh63ySI8Wduy6wpBy18BeqkHBEpEas8rJwSmwZLlwIvS7C/qqqMcQS4yTSUnYCjh+
	uYs1Neg7UKh7umxbevBRwVQnlnORd2v85qcOQxH3/Hvo7OZ5CI8t0cWI0s8CJXmKR6SRb8KPBnhv7
	Hdio5BdzgCD/a3xXae1S2eUtbYT24/QSe5vjJp/woIShTRnMKlMELRtnEVrhTLnL5Rc4NWfGTzyPZ
	bzsJMzEQ==;
Received: from [2001:4bb8:2cd:5bfc:fac4:f2e7:8d6c:958e] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sMTbc-000000079bk-3nxT;
	Wed, 26 Jun 2024 14:26:41 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: queue_limits fixups and tidyups v3
Date: Wed, 26 Jun 2024 16:26:21 +0200
Message-ID: <20240626142637.300624-1-hch@lst.de>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Jens,

this series has a few fixes for the queue_limits conversion in the first
few patches and then has a bunch more cleanups and improvements in that
area.

Changes since v2:
 - export md_init_stacking_limits
 - use blk_queue_write_cache instead of open coding it
 - various spelling fixes
 - document a new paramter in ufshcd

Changes since v1:
 - remove an incorrect use of a flag on the features field
 - add a patch to switch to __bitwise annotations for features and flags
 - update a commit log

Diffstat:
 block/bio-integrity.c     |    2 
 block/blk-map.c           |    2 
 block/blk-settings.c      |   46 +++++----------------
 block/blk-sysfs.c         |   12 ++---
 block/blk.h               |    2 
 block/genhd.c             |    2 
 drivers/ata/libata-scsi.c |    3 -
 drivers/ata/pata_macio.c  |    4 -
 drivers/md/md.c           |   14 ++++--
 drivers/md/md.h           |    1 
 drivers/md/raid0.c        |    2 
 drivers/md/raid1.c        |    2 
 drivers/md/raid10.c       |    2 
 drivers/md/raid5.c        |    2 
 drivers/scsi/scsi_lib.c   |    4 -
 drivers/ufs/core/ufshcd.c |   10 ++--
 include/linux/blkdev.h    |  100 +++++++++++++++++++++++-----------------------
 17 files changed, 99 insertions(+), 111 deletions(-)
