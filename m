Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D59C1D5CD9;
	Mon,  6 Jan 2025 08:35:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736152537; cv=none; b=npBm9V4Y37ORamptoMxgeZD5A6XycpCrzQ4H2zxEVnTowkvezx/UZGv1B3w5TUJC5mNZL836eR0W+1hiAiFwXZN49Hl3Hkf9zhQMmbVUkx446RtRIuvu9iSq0/moBhFhzpXTUX2/oneQtXdSK2LSach328pqzCbC2gFwUuh1iNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736152537; c=relaxed/simple;
	bh=AAHvtvgbPzj3tmJyOrtdyy8yNbQZ3/seQsEhentxwp0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=JOJFRV8I0Kq+X5b0pdeDEDFa9ZLNiS40Xxfv2elSiSSwa4fRpp4oISq/J9VjB/YMiDY5N6azMeK8Kgy3Y8+LgnA4K8MbEEYz4LuclI+hokp/yoN9WRV5tdb7RxRxbWjy0nlcYN048jCOqPty+f2y8sGNRdmJNFMTGlJR02NuJsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YVfsptmz; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YVfsptmz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=euJ7YEBa7Eok7Tb9QqrqvWjNL9GyyFGQyYdt1od4F4Y=; b=YVfsptmzXAKAUGqFOzJ2NL0lfb
	dA0okXPLIyNSvNIpi7lF4AVod8MXASS9Vo7NAL8lkL6L6Lz30Ti+aPtxcLggCcPHUxXh7o/kTsirI
	jFQKGiMyvOSCSv2Av0KZ1ciLZnqhVGWkTGDRJxmmQqhF2yMvLPbEbln/6JD6hfjY4PuOVY5FTk1eY
	o5jvQvK0s1/7uSEMXZifvNK8cCll6fb3Ky5+OdmFBG6fnGEUqcwniLFeohhWj0+OaEULQzDeAHFy1
	7h8ED8J0ioExjGbRsvZfLp5g23olisj4DH1zZQVjERRCYMiaJU8spD/ef5rOAeML3cwjiyi1YvXgp
	FhfX2p9g==;
Received: from 2a02-8389-2341-5b80-db6b-99e8-3feb-3b4e.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:db6b:99e8:3feb:3b4e] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tUiaE-00000000XDE-1opv;
	Mon, 06 Jan 2025 08:35:34 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: more BLK_MQ_F_* simplification v2
Date: Mon,  6 Jan 2025 09:35:07 +0100
Message-ID: <20250106083531.799976-1-hch@lst.de>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi Jens,

this series removes another BLK_MQ_F_ that just duplicates an implicit
condition and cleans up the tag allocation policy selection by using
an actual BLK_MQ_F_ flag instead of a two-value enum awkwardly encoded
into it.  If we'd ever grow another policy we'd be much better off just
adding a separate field to the tagset for it.

Changes since v1:
 - use a boolean bitfield for the SCSI RR tag allocation policy selection

Diffstat:
 block/blk-mq-debugfs.c                 |   26 +++-----------------
 block/blk-mq-tag.c                     |   41 ++++++++++-----------------------
 block/blk-mq.c                         |    3 --
 block/blk-mq.h                         |    5 ----
 block/bsg-lib.c                        |    2 -
 block/elevator.c                       |   20 ----------------
 block/genhd.c                          |   28 ++++++++++++----------
 drivers/ata/ahci.h                     |    2 -
 drivers/ata/pata_macio.c               |    2 -
 drivers/ata/sata_mv.c                  |    2 -
 drivers/ata/sata_nv.c                  |    4 +--
 drivers/ata/sata_sil24.c               |    1 
 drivers/block/null_blk/main.c          |    4 +--
 drivers/nvme/host/apple.c              |    1 
 drivers/nvme/host/core.c               |    1 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |    2 -
 drivers/scsi/scsi_lib.c                |    4 +--
 drivers/ufs/core/ufshcd.c              |    1 
 include/linux/blk-mq.h                 |   24 +++++--------------
 include/linux/libata.h                 |    4 +--
 include/scsi/scsi_host.h               |    6 +++-
 21 files changed, 58 insertions(+), 125 deletions(-)
