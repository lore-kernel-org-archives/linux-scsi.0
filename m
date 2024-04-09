Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24F912FF94;
	Tue,  9 Apr 2024 14:38:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712673527; cv=none; b=uPVjIOQVPedq/ase7lvQXnRffUhzcPmT5hBvo3EbVYRoVKK4b2gaXD98sxEDy1A9CpVJwUror5Q33UPUMr/a33/lPEBX1JELLuQXW5zWuL/lxGcAr+FkFZR17dgOCR253T7r2gVV8iI8Al0TN53+tHQ0a2fq1uD7+8s5PnQjvjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712673527; c=relaxed/simple;
	bh=Nq4mzOcspJxKptNLRGNTAAwyRhMaJZkG2xELTRcF3JY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=moKgQh1b9x5MA16u6yW4V/MSzqnySbE7YZwCS2mxCMaQm6KXgDgDAE5x9Qlwjo1nDXE7GGFkIAAoQM/44XNu1E9k9EQjG4JHYkEsAh/P2pWqISmW8kCAeJuWS/E3h0kmIY0E4L/3vOw84l3bQ5uZxhyg7vTuFrZ6Q56zKIYFDTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t49nIlxj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t49nIlxj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=oOzGzNJBoU44rEzjCKb52VWSHMlCwSe4hv+WebdEwa8=; b=t49nIlxj7uOo8e+Fhc87Q753t5
	llx/mLCUYGyaFoKTMJ5mH/9Hx+RV1YE0WEMerWD6pMO7+15YymhEBzLdY/HzkD9gRLJDzwYCVGd3f
	elbWhbhlUXcL4O5sBB83c2GnwuGnA86PjlHdrjZqmtZ+xbksbE8GnY89bQFEa5ydpz3Sb+z2CGEuj
	j5zy1gQFLTQX1xr6knDV3B6Ft1DZZQwZOR6x4dj9KlYq7EElLAcFinxdXLvvqGigqAkWEXLwDmRo6
	uAF/UdSk6ks6LqEQF8NbyYh37EYm2NSc03UIm08ERpfQVqIiWb0YJKMHkg39F/yiQ9az3Er6/Seqq
	WtyzWE2Q==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruCcP-00000002SCK-0jjf;
	Tue, 09 Apr 2024 14:38:37 +0000
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
	megaraidlinux.pdl@broadcom.com,
	mpi3mr-linuxdrv.pdl@broadcom.com,
	linux-samsung-soc@vger.kernel.org,
	linux-usb@vger.kernel.org,
	usb-storage@lists.one-eyed-alien.net,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 17/23] usb-storage: switch to using ->device_configure
Date: Tue,  9 Apr 2024 16:37:42 +0200
Message-Id: <20240409143748.980206-18-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240409143748.980206-1-hch@lst.de>
References: <20240409143748.980206-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Switch to the ->device_configure method instead of ->slave_configure
and update the block limits on the passed in queue_limits instead
of using the per-limit accessors.

Also use the proper atomic queue limit update helpers and freeze the
queue when updating max_hw_sectors from sysfs.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/usb/storage/scsiglue.c | 36 ++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index eb4ba03e082d89..b31464740f6c86 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -82,7 +82,7 @@ static int slave_alloc (struct scsi_device *sdev)
 	return 0;
 }
 
-static int slave_configure(struct scsi_device *sdev)
+static int device_configure(struct scsi_device *sdev, struct queue_limits *lim)
 {
 	struct us_data *us = host_to_us(sdev->host);
 	struct device *dev = us->pusb_dev->bus->sysdev;
@@ -97,31 +97,28 @@ static int slave_configure(struct scsi_device *sdev)
 
 		if (us->fflags & US_FL_MAX_SECTORS_MIN)
 			max_sectors = PAGE_SIZE >> 9;
-		if (queue_max_hw_sectors(sdev->request_queue) > max_sectors)
-			blk_queue_max_hw_sectors(sdev->request_queue,
-					      max_sectors);
+		lim->max_hw_sectors = min(lim->max_hw_sectors, max_sectors);
 	} else if (sdev->type == TYPE_TAPE) {
 		/*
 		 * Tapes need much higher max_sector limits, so just
 		 * raise it to the maximum possible (4 GB / 512) and
 		 * let the queue segment size sort out the real limit.
 		 */
-		blk_queue_max_hw_sectors(sdev->request_queue, 0x7FFFFF);
+		lim->max_hw_sectors = 0x7FFFFF;
 	} else if (us->pusb_dev->speed >= USB_SPEED_SUPER) {
 		/*
 		 * USB3 devices will be limited to 2048 sectors. This gives us
 		 * better throughput on most devices.
 		 */
-		blk_queue_max_hw_sectors(sdev->request_queue, 2048);
+		lim->max_hw_sectors = 2048;
 	}
 
 	/*
 	 * The max_hw_sectors should be up to maximum size of a mapping for
 	 * the device. Otherwise, a DMA API might fail on swiotlb environment.
 	 */
-	blk_queue_max_hw_sectors(sdev->request_queue,
-		min_t(size_t, queue_max_hw_sectors(sdev->request_queue),
-		      dma_max_mapping_size(dev) >> SECTOR_SHIFT));
+	lim->max_hw_sectors = min_t(size_t,
+		lim->max_hw_sectors, dma_max_mapping_size(dev) >> SECTOR_SHIFT);
 
 	/*
 	 * We can't put these settings in slave_alloc() because that gets
@@ -582,13 +579,22 @@ static ssize_t max_sectors_store(struct device *dev, struct device_attribute *at
 		size_t count)
 {
 	struct scsi_device *sdev = to_scsi_device(dev);
+	struct queue_limits lim;
 	unsigned short ms;
+	int ret;
 
-	if (sscanf(buf, "%hu", &ms) > 0) {
-		blk_queue_max_hw_sectors(sdev->request_queue, ms);
-		return count;
-	}
-	return -EINVAL;
+	if (sscanf(buf, "%hu", &ms) <= 0)
+		return -EINVAL;
+
+	blk_mq_freeze_queue(sdev->request_queue);
+	lim = queue_limits_start_update(sdev->request_queue);
+	lim.max_hw_sectors = ms;
+	ret = queue_limits_commit_update(sdev->request_queue, &lim);
+	blk_mq_unfreeze_queue(sdev->request_queue);
+
+	if (ret)
+		return ret;
+	return count;
 }
 static DEVICE_ATTR_RW(max_sectors);
 
@@ -626,7 +632,7 @@ static const struct scsi_host_template usb_stor_host_template = {
 	.this_id =			-1,
 
 	.slave_alloc =			slave_alloc,
-	.slave_configure =		slave_configure,
+	.device_configure =		device_configure,
 	.target_alloc =			target_alloc,
 
 	/* lots of sg segments can be handled */
-- 
2.39.2

