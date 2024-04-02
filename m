Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEB513440B;
	Tue,  2 Apr 2024 13:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712063280; cv=none; b=ha+moyHXbU3SVads8CStkDqZEW1wm6U6p7HQ6TAm3Vp5ZNvDzUOJqspMT2K5YtYpycJLrGAguvL3OiOjwYBuFy25P3G5KnNTA5yDTHaEltaGikXkCDBw7POHRY8MnwaMb/fHJV+TReijZUac7HZE/mQptW5uMqcreIhMaJqaHAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712063280; c=relaxed/simple;
	bh=2EUiZI5PIUhcV1SqcUqiXAZjPX97N8b+A7FvKqmxXz0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kaoic0lm6XuutD6NGCBKuhlhnwfB76UCHF79CYVeTH3MwA9igJjzCi5eWYR4+iKtLUkY7D5A1HJZ9+I1IqyBizSsOlkiaWF8DoMGm32DkIq5XRdewO3aWEY5qJj3Y7Moskt9a1CJH8fEC3vxXQFqde63TNXiCS/4rcBjyvBBstU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DrVjcW7m; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DrVjcW7m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sJ6rjK8z01EnBB2k0fCyz7Kt9YMXIpERYRmm65NY1xs=; b=DrVjcW7mphybcZIipyRSXtKUS8
	r6yK58q8QjC+jmeCfImfuWBNdaFR8toByqamx2eQrxSFrvxO0MdlU+LVO6UYObwAz4dUsTJqjnSni
	YtZ4P/7Sinohd77A3Aax7b33NPykGdYyX8YRavwA3xbWNFcGKsN0xfF0eUfP8XTyq+Zk1/Hjz9M++
	3tEvHcyAbwbccuY5eMy+5Ug9MZehx4W44Wd/BKBZWQJsxmZFncxK60qk1UQ4cGqFjwcfgJpYUhTIt
	Cd8J0t/s2IAd7BfCotHNHFcjUCmLUxF3UWJn/kTaBe9wbWzAQjOfqsU24ghL8J66TKDPQMaj7Yx+C
	7KPlnpsA==;
Received: from [2001:4bb8:199:60a5:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrdri-0000000BFo7-1xWX;
	Tue, 02 Apr 2024 13:07:51 +0000
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
	usb-storage@lists.one-eyed-alien.net
Subject: [PATCH 22/23] uas: switch to using ->device_configure to configure queue limits
Date: Tue,  2 Apr 2024 15:06:44 +0200
Message-Id: <20240402130645.653507-23-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240402130645.653507-1-hch@lst.de>
References: <20240402130645.653507-1-hch@lst.de>
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
---
 drivers/usb/storage/uas.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index ca6d01fc4b9456..a48870a87a293c 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -821,19 +821,19 @@ static int uas_slave_alloc(struct scsi_device *sdev)
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
 
@@ -898,7 +898,7 @@ static const struct scsi_host_template uas_host_template = {
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

