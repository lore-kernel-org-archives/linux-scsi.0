Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474824401;
	Thu, 28 Dec 2023 07:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Zu1OyRNT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=SFFMPxU9gWpp22leyoZv66Z7Zrcs2VCaqOK+KXMR9So=; b=Zu1OyRNTrtDPcONAiqMU3q6kW8
	4UmvlTt5sR2wS8g4MLm4kyrMmWrDSatQSQaXbJ0YNlhy/7c4enL/xCb/FN8nWChO/bFUHJcJbPmxS
	cIVJBjocBI7Mhd0TaAMXo058JGLdC6ZV2PtIjT1QOBy5cMifdFzOZhz9wgaFvRXmDPkebaq05XRU8
	36PaaKmTsD41F2/lv5RifWks+lK8yTWzTKV7SRfW1T5MpuHoSkF0Uh58PrT3D8Q+5RWH7Wq0nJ0vC
	24Gq2aUI5TiJgvKA0JCqPDoB6YtHBs15PEhe0UuIeroKUKGbGESOegRwK3txcDetXqdvhVfoAmZlN
	P/kGG/VQ==;
Received: from 213-147-167-209.nat.highway.webapn.at ([213.147.167.209] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
	id 1rIlBE-00GMgF-16;
	Thu, 28 Dec 2023 07:51:49 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
	Damien Le Moal <damien.lemoal@wdc.com>,
	linux-block@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: remove another host aware model leftover
Date: Thu, 28 Dec 2023 07:51:39 +0000
Message-Id: <20231228075141.362560-1-hch@lst.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Hi all,

now that support for the host aware zoned model is gone in the
for-6.8/block branch, there is no way the sd driver can find a device
where is has to clear the zoned flag, and we can thus remove the code
for it, including a block layer helper.

Diffstat:
 block/blk-zoned.c      |   21 ---------------------
 drivers/scsi/sd.c      |    7 +++----
 include/linux/blkdev.h |    1 -
 3 files changed, 3 insertions(+), 26 deletions(-)
