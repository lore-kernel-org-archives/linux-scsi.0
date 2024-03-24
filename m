Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0A72A13E3;
	Sun, 24 Mar 2024 23:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711324525; cv=none; b=Eqvai5V6cQP3bYoDqq9pBSdu2gLgPY4Tr7NemIJLzzot9Kyra0fbgu8gdOfyJ1r0ckLrBk4eFqwo1aFNdMOlzKFp+oWzo+v6Jh1J4uk15nxypenF5aGPIpQN6k2248UgdahILASXgJ/RPdDRVnFjZsVymihOG9gEdNTpYXV5OWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711324525; c=relaxed/simple;
	bh=SELFkbNszRqDf9dNFabcVXNlgHcuwLzbi4oarjWV1Kw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=DZNtBdQrlpQpTJ6bLwCzWZixjNAmdGSZ2Emcw1iC2dSFIeQyfbDnxH8FnAVMgi3zZop52ClKiMsCZ8qKfgJLVtWyDcyYrw8vyOLh/pjRWXToKjydPq/+hs4LuAIqDSUOHDCDeteQZoJFkmRSAck2Qy1XcQ+LmrZOUMKqbhKGMN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NYsH+jPH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NYsH+jPH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Oi3gXJaYMU3a5CWeWFZBGsi5hiMd7VrWMH8aWRvFEBc=; b=NYsH+jPHH8jf7F53QOWprSH1g2
	e3RHAOgDAudjCGi04C2rMsaWewlEM8SbYrfRfR19iaa1gEZxOnivXdaaoL1QvFgvbrMxEr6ZxisiI
	PJghhyY0Uwr+OAX/XdvigXvhqKWpgBUCNUyKdyaBVahFkIP9bnyFX8uAjHct87kzEJrvQsCMIDU4m
	4hmOoAn/BFZ3xEMQB3EV890S6hEOcS8d61ymlCtdkhBy1D7S5Hagugw8qQSS7B+2pE1BrTBq88Kd6
	CwoxK8O2Y81nSef5Lpubk0EhW1xhxNMi5qK71dP9yOJQzHWWFocWsvvAoANScILKzQxrDEmasz3pK
	BT6LK1nQ==;
Received: from [210.13.83.2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roXfy-0000000DzKg-2IVj;
	Sun, 24 Mar 2024 23:54:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Takashi Sakamoto <o-takashi@sakamocchi.jp>,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
	"Juergen E. Fischer" <fischer@norbit.de>,
	Xiang Chen <chenxiang66@hisilicon.com>,
	HighPoint Linux Team <linux@highpoint-tech.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	Brian King <brking@us.ibm.com>,
	Lee Duncan <lduncan@suse.com>,
	Chris Leech <cleech@redhat.com>,
	Mike Christie <michael.christie@oracle.com>,
	John Garry <john.g.garry@oracle.com>,
	Jason Yan <yanaijie@huawei.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
	Chandrakanth patil <chandrakanth.patil@broadcom.com>,
	Jack Wang <jinpu.wang@cloud.ionos.com>,
	Nilesh Javali <njavali@marvell.com>,
	GR-QLogic-Storage-Upstream@marvell.com,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Alan Stern <stern@rowland.harvard.edu>,
	linux-block@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux1394-devel@lists.sourceforge.net,
	MPT-FusionLinux.pdl@broadcom.com,
	linux-scsi@vger.kernel.org,
	open-iscsi@googlegroups.com,
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-samsung-soc@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 01/23] block: don't reject too large max_user_setors in blk_validate_limits
Date: Mon, 25 Mar 2024 07:54:26 +0800
Message-Id: <20240324235448.2039074-2-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240324235448.2039074-1-hch@lst.de>
References: <20240324235448.2039074-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

We already cap down the actual max_sectors to the max of the hardware
and user limit, so don't reject the configuration.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 3c7d8d638ab59d..cdbaef159c4bc3 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -146,8 +146,7 @@ static int blk_validate_limits(struct queue_limits *lim)
 	max_hw_sectors = min_not_zero(lim->max_hw_sectors,
 				lim->max_dev_sectors);
 	if (lim->max_user_sectors) {
-		if (lim->max_user_sectors > max_hw_sectors ||
-		    lim->max_user_sectors < PAGE_SIZE / SECTOR_SIZE)
+		if (lim->max_user_sectors < PAGE_SIZE / SECTOR_SIZE)
 			return -EINVAL;
 		lim->max_sectors = min(max_hw_sectors, lim->max_user_sectors);
 	} else {
-- 
2.39.2

