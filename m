Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AF91095B;
	Tue, 25 Jun 2024 11:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719313579; cv=none; b=IuMJSApiA2B3OQgDYI4ciSWTZHuIfK9L3dKE8t85qEPwdOi+2yAzg43DR9/r6sRURK70XlswYdo1/YDepdTtI1RTrzzzAWIMFg15VZAXKFB/djmYkoou2TdxuraNMSeRYGT9I2dXXwnA6Yu39t4IPkggbThHtI5yY8y25oC1IrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719313579; c=relaxed/simple;
	bh=YquKx9+qoCLbg595h97s3669NS0jipkuIYuLbXRwOmI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XE7j9zTaf9RZr6QoF7+hRWopOUvpcFMfF18+ZHsCh4Y8/op6MLuWuEKuRnT8QJYTooLielk7N4SnA9gkL/Pit4WjwTeMtANeHmIR+UYmEwD3FM9v9KPZyO6Y6W2YijFu2K1Vqb0U52EsZ+WV9QzKxY9+0i7+C359gL3Vtg1shZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=R8EJ6F+j; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="R8EJ6F+j"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=axzM94WmJNV1hYl5xpoBIes2MiDp7gzsySQuBuvMwq8=; b=R8EJ6F+jleL0FucmQknDeSFh70
	EcVk4yCvHHIkW8sumYpYRyxMnAEC8AlnFon3EKT0HEm2q2yA6J7RmHIv5GPVVwk9ZotsEcAZioE3X
	g9fMQ1CbbeYKoBLBqburKEDsTwptZkOUoqNPVqsminubdXRMZEh4kWtcjBrnBfHSP5zSmYSdeexpz
	I0PeosyDQfcNjoyaZf8QxqaWENxalICFNwyLX0FAlsNni+NWzajV1wFj7s+iHmb29E0a985FMyVhr
	z/J8HpJN/SgvAVMk33SlxmiSlG4yIKnyWBmsTwfYEpcKWdiNDRH8yqrPR+tlKZB6MCmXr8dNlvgWU
	TPc40h+A==;
Received: from [2001:4bb8:2dc:2ee2:6df6:d2e9:d402:6e6b] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sM3zy-00000002UJE-37dA;
	Tue, 25 Jun 2024 11:06:07 +0000
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
Subject: queue_limits fixups and tidyups
Date: Tue, 25 Jun 2024 13:05:40 +0200
Message-ID: <20240625110603.50885-1-hch@lst.de>
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

Diffstat:
 block/bio-integrity.c     |    2 +-
 block/blk-map.c           |    2 +-
 block/blk-settings.c      |   46 +++++++++++-----------------------------------
 block/blk-sysfs.c         |    3 ++-
 block/blk.h               |    2 ++
 block/genhd.c             |    2 +-
 drivers/ata/libata-scsi.c |    3 +--
 drivers/ata/pata_macio.c  |    4 ++--
 drivers/md/md.c           |   13 ++++++++-----
 drivers/md/md.h           |    1 +
 drivers/md/raid0.c        |    2 +-
 drivers/md/raid1.c        |    2 +-
 drivers/md/raid10.c       |    2 +-
 drivers/md/raid5.c        |    2 +-
 drivers/scsi/scsi_lib.c   |    4 ++--
 drivers/ufs/core/ufshcd.c |    9 +++++----
 include/linux/blkdev.h    |   17 ++++++++++-------
 17 files changed, 51 insertions(+), 65 deletions(-)
