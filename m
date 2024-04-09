Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E846130A61;
	Tue,  9 Apr 2024 14:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712673544; cv=none; b=ZjGHZ1cRUq2c6cyVXUYbH6BveB5R25eGNVPoaxQVmFk3+2aYj7CvCymuzfGbDhPquKAuGyzRxYk7B6CPoQBymajnBWjasqkbPuivT0hYa+zIEd6mbb+iLY6uZ1HDS0VmiMt4CITgRneWhJ8HuVdoUvXLY3f9Rv7kBHw2aS/65eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712673544; c=relaxed/simple;
	bh=62mf3c0a+VpI8zf2ndGdXS+t9TcpKivQfyy6tOfcRvs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=pCA+9CvBRWSAnBqOJgXbhtH+U2m06wrvq3IjDLgdE1gfnAw74FGPOUE3d4KadsEBra+PeRqMEFFGQtkNtvHAccmuVI9wP4K3PUerK3k+eRzPEHOgmrjsyvKl4I3B/eapY7J9IfGiqZbZFN4JDmSa20MqD5LK8UQe0+iq6iRhzzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=huC71k7P; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="huC71k7P"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=tY9EZbVOWQQqN6Qy5rZAOJKfDHxH9ZT92YoWmtvtxeo=; b=huC71k7PDqqoS+GkGDZlVm0kJc
	B3Rzuewsgmz9yLJ50v7Co1h1rBud9QGGRRp5vKDRQ8Sta1wp/G6+7f13Qgf9Ws4MYczs1Os8h2Jhk
	iOI2vP2q127X3RQ++RH5DT28rc1jsU+fXb6gt+4OAPnqtY0F56YSxxfa45LP//sXpcciPb6qqjlnC
	tqA3D4d/qnrZxXlMvCKUM6/+0bzEstzk5r38AV9au0Ow+Pf0UyE+YI24qvR80Cta7jzkM8j6Nu3FJ
	lzITgnFCxr9hxQjKp+/gU/jHIJKD/oN7jp5BYv4a6ytHX/tCayZE/bWySCObcxFuqSYIfd+D4gNo+
	nMfAEVzw==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruCch-00000002SJC-0Cq9;
	Tue, 09 Apr 2024 14:38:55 +0000
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
Subject: [PATCH 22/23] uas: switch to using ->device_configure to configure queue limits
Date: Tue,  9 Apr 2024 16:37:47 +0200
Message-Id: <20240409143748.980206-23-hch@lst.de>
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

Switch to the ->device_configure method instead of ->slave_alloc
and update the block limits on the passed in queue_limits instead
of using the per-limit accessors.

Note that uas was the only driver setting these size limits from
->slave_alloc and not ->slave_configure and this makes it match
everyone else.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/usb/storage/uas.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index 0668182e1c469c..738c183ccada8d 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -823,19 +823,19 @@ static int uas_slave_alloc(struct scsi_device *sdev)
 		(struct uas_dev_info *)sdev->host->hostdata;
 
 	sdev->hostdata = devinfo;
-
-	if (devinfo->flags & US_FL_MAX_SECTORS_64)
-		blk_queue_max_hw_sectors(sdev->request_queue, 64);
-	else if (devinfo->flags & US_FL_MAX_SECTORS_240)
-		blk_queue_max_hw_sectors(sdev->request_queue, 240);
-
 	return 0;
 }
 
-static int uas_slave_configure(struct scsi_device *sdev)
+static int uas_device_configure(struct scsi_device *sdev,
+		struct queue_limits *lim)
 {
 	struct uas_dev_info *devinfo = sdev->hostdata;
 
+	if (devinfo->flags & US_FL_MAX_SECTORS_64)
+		lim->max_hw_sectors = 64;
+	else if (devinfo->flags & US_FL_MAX_SECTORS_240)
+		lim->max_hw_sectors = 240;
+
 	if (devinfo->flags & US_FL_NO_REPORT_OPCODES)
 		sdev->no_report_opcodes = 1;
 
@@ -900,7 +900,7 @@ static const struct scsi_host_template uas_host_template = {
 	.queuecommand = uas_queuecommand,
 	.target_alloc = uas_target_alloc,
 	.slave_alloc = uas_slave_alloc,
-	.slave_configure = uas_slave_configure,
+	.device_configure = uas_device_configure,
 	.eh_abort_handler = uas_eh_abort_handler,
 	.eh_device_reset_handler = uas_eh_device_reset_handler,
 	.this_id = -1,
-- 
2.39.2

