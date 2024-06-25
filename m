Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCDE159209;
	Tue, 25 Jun 2024 15:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719327607; cv=none; b=aL3ajOS+cRyLwePq/ZLkfZXOsoPDifOagj9J6Cx4nZZ5ZbvWhpmfpmSOaUduvTXxB+PxVVSIGfwzENpRPxJB6hnQ9Ws2dWKQj3myaJSXE59F7nH5dzykQi41lEht03dQBH9jqrloTwPCqnZnrmpGlv+lh2LGwfpipd7UDouyKds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719327607; c=relaxed/simple;
	bh=Ycm9baoHmA0xsmdObsAGpMAx7EmYMVmA4RloSxKYjyk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VRlbWpMT5bWJuIdNfh710yCdoae95gdfwdDzZSAXWsBqvHnF0zpJMDYiAZF9Z373pc6n4/8mRRx5lqV6JBZiWDrsGL86HCCA5ZT5/AKjnGAr5WbHvn0+Hatwe1RQHi0LYdAyIStktmjTbYqb7JhL05pHqYUMmQj7DgyNDnyP9Og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a1Nmn9Gi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a1Nmn9Gi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=yGEqwI5TbhutvtLFlJMwfW7TWIGthjl30tV6Piiwd1w=; b=a1Nmn9Gi4lQI1JcMuYTnxzgTLo
	lnIQerqXSVtGrG6Vw97Z3xp2zl9EiSycTuOWCj13ZOVDVW2TIbT4DQWZLeLc8IUljbv+8RVzLx+ri
	bfiAYg50sEcOF0sdPNwKZf8azHMzhhrYnUnXk/e/H/tgOqzVs3tMsTs94w1R0AuB9RYmDOjHJwCq9
	EHiKPlc68muqBFHln432qTbUs9WsmYxSwN2DVio5vrIx3/uvEzFwFyTxeXoLDGQEYfn2F6HfyHOGY
	aeJTIR3tZC/e6q4OASgZbjTFpSGrCBGVKYohzbon7W1xCUlwb8C+Wz7rqYbuG9eni3aXoKvU4rR7o
	JKPKBxzg==;
Received: from [2001:4bb8:2c2:e897:e635:808f:2aad:e9c8] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM7eJ-00000003Ie9-0pN3;
	Tue, 25 Jun 2024 15:00:00 +0000
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
Subject: queue_limits fixups and tidyups v2
Date: Tue, 25 Jun 2024 16:59:45 +0200
Message-ID: <20240625145955.115252-1-hch@lst.de>
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

Changes since v1:
 - remove an incorrect use of a flag on the features field
 - add a patch to switch to __bitwise annotations for features and flags
 - update a commit log

Diffstat:
 block/bio-integrity.c     |    2 
 block/blk-map.c           |    2 
 block/blk-settings.c      |   46 +++++----------------
 block/blk-sysfs.c         |    9 ++--
 block/blk.h               |    2 
 block/genhd.c             |    2 
 drivers/ata/libata-scsi.c |    3 -
 drivers/ata/pata_macio.c  |    4 -
 drivers/md/md.c           |   13 +++--
 drivers/md/md.h           |    1 
 drivers/md/raid0.c        |    2 
 drivers/md/raid1.c        |    2 
 drivers/md/raid10.c       |    2 
 drivers/md/raid5.c        |    2 
 drivers/scsi/scsi_lib.c   |    4 -
 drivers/ufs/core/ufshcd.c |    9 ++--
 include/linux/blkdev.h    |  100 +++++++++++++++++++++++-----------------------
 17 files changed, 96 insertions(+), 109 deletions(-)
