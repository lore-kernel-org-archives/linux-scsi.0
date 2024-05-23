Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E719E328B6;
	Thu, 23 May 2024 18:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716488787; cv=none; b=UOQddnvejYBuW/qByf+/Jc0eqPdcTD4R9o0qC9+zlF8NEz8boQBnqZbyuvJbQ5Si3P+9tdQ5F8DTMflc8MeU3KzAlo1OpRK4R3Dl0h4FzMcCGnViOHSGKBhOtSHtLZRxmTQqScz8fxWGGq9TmlYa2r0DIRYAUMlY/1jYwJGQCl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716488787; c=relaxed/simple;
	bh=fnNobCrd2w3N4DklNwdXdvoufcIoq3pYSdrX2EVTbYM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r7py0ofm3+SSNVbzONgmpwro5gFRsbSFbll4JFPxV/zWsKK/1/cC+DMee5JQAANzX7fEHsszmIz4v3Lr2DVO8zNcq1LJg8M41Q2i13/x/Ai9u9I8NVt2W+9zd8HLpwKxGhFh37zL7wneLc0Ast1B9ryYIB/TtudhzcfhE/lky90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cJuKMtax; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cJuKMtax"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=o7lK42oMusv53tmiUgIoOz2t+okOeCzwVYhaaNVIoeg=; b=cJuKMtaxw8x1b/2Y1K2dGNqzs0
	QVfksZ+8uPNTJrK1goyPWljxOetlWfiQ3NtSETcfGjDicm8gnun5rX9i45yIkj/XRNJB2NFD5UqEt
	ygd6X1IXKfXtArYrh8lG6jfWXgQJcwhQEWQI0Dspx414UadVNVUF4xsciTvvBzHNc6VYlLMV3j+48
	W3xznMauo6meHqy68VWsseJ3wodihXI8mX/zLmZwc8NORDBDF21l0t88W83JAmQtTMgatPC+Ajh64
	NyTmylkDPQQDp1o8RxNQh22Lbs4x11wW9j8NO2Ylk+EvJuwWzpFGZyKkpfnxrW5HfvrP2bkJsaHQ0
	B9u3rWeA==;
Received: from [2001:4bb8:2d0:ea45:284:cf8f:6784:4c64] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sAD8w-000000070py-06zW;
	Thu, 23 May 2024 18:26:22 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Mike Snitzer <snitzer@kernel.org>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: fix stacking of sd-imposed max_sectors
Date: Thu, 23 May 2024 20:26:12 +0200
Message-ID: <20240523182618.602003-1-hch@lst.de>
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

this series fixes a regression in 6.10-rc report by Mike when using
device mapper multipath on top of SCSI disks.  It is due the sd
driver not only setting the hard max_dev_sectors limit but also
pre-setting a potentially lower max_sectors value.

Diffstat:
 block/blk-settings.c |    2 ++
 drivers/scsi/sd.c    |    4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)
