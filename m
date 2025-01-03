Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160851C4A29;
	Fri,  3 Jan 2025 07:42:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735890162; cv=none; b=d/poknF03oaN+SUf5dvLDterBGOVVVetwI8BbkOVRNVwfmrhsOWohK4ffRP+C54gn2R236j/uUeODGnDKOGZ0PBGQN8hHDv2EzFfw35vwf4qj2UwVlFFaCLM66tAtG9b9S6qDwy6D+NfzfJoM6fgss4IgWngXySQrwi0x0iduNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735890162; c=relaxed/simple;
	bh=nBZk6MCEnsicXGMT88kc+MGMjYZyU1oIKz9Tl+j3/fU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=h8FEzinCDchbhXXOes62Vvp9TZ+TOT1cu8KEPjWZwB5aYKQ9yRXD0twAjBLe7ApeyH+6pzKl3RATB5AJgQ1I46rQzbnIFCL/I6a/LRoqAofmoKyZWrSLTTByXE37yq4k87yjfQAo0T8QwJD2+xjz59lUQKRUU4ED+5EJzGRjlbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kITwkeXk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kITwkeXk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=RhGNLIrUNWWckjSN8l+x4TuA0j9IhfvO3RuggJHkrdw=; b=kITwkeXkQ+3/v5dlV69eiQw41z
	qBSJpWE9pGk/DuOEOzvE86XdVdr09qUKxFLSxX830AmhIz5QDnVu+NTytbHgSwz1ZO0gAMRbfTH+0
	R3OvGDdnDM1W2NUwJ9+V82tgahiWnF4j/ljs/627Rlx7dL9CVylnMbha/PSe8r6D7RRDUPx10T7tB
	wlj6Hz1jDwGs+6f+Xno/mII5lu79AGMWrkMw08xWgqbYbwX+IUlaHfxSYE4AOMUPZWWdRvgpRzgyf
	rYwC5EXttCdaLCk3plyUKPjP9bBPfm9H0LEhnnA2qU1ITkYgtD7A0o0R4PL0KA2dJB+eDMQcuMabs
	LoXXYl0A==;
Received: from [2001:4bb8:2dc:484c:63c3:48c7:ceee:8370] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tTcKO-0000000CNqU-0NXe;
	Fri, 03 Jan 2025 07:42:40 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: more BLK_MQ_F_* simplification
Date: Fri,  3 Jan 2025 08:42:08 +0100
Message-ID: <20250103074237.460751-1-hch@lst.de>
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
 drivers/ata/sata_sil24.c               |    2 -
 drivers/block/null_blk/main.c          |    4 +--
 drivers/nvme/host/apple.c              |    1 
 drivers/nvme/host/core.c               |    1 
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |    2 -
 drivers/scsi/scsi_lib.c                |    4 +--
 drivers/ufs/core/ufshcd.c              |    1 
 include/linux/blk-mq.h                 |   24 +++++--------------
 include/linux/libata.h                 |    4 +--
 include/scsi/scsi_host.h               |    7 ++++-
 21 files changed, 61 insertions(+), 124 deletions(-)
