Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E0F188A96;
	Sun, 24 Mar 2024 23:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711324578; cv=none; b=HsCA8HZoyL1+mlG8aAvpKZUD6zrkhkPeU7+SgTGVZuqUA7oTqcxffPwt3rK8olsb9C1u8/0yNFfXjlGZkaOmdLuZkk7DjEC7ykz+mdQmDdPvnjGlNQ8l9zXzEB8l018xG3zSoM1wOKjgeYW13OJtnQVHMGpRyWMTRKpNZm2uuyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711324578; c=relaxed/simple;
	bh=lLi6yl+FOpYG2MsUPtyGpUHAECRgfojlMedmbH4LYo8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GrFuGC4URzMtkWrmlITMEPeG9Ia1xuond32Xb1zwpdHw7yUpcjH5kcE3Om5OM5ETQBDrZIQx9r/gC7eJbL5xEMiRCjLlOQuajCzLdXUfoGfrY9FWqR+RQwxiXkIoEa11DAh0d9xx1aZZCV7LWp7Yk2VaUrt68lQ71Y0ZgikMot8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=QNv5BRtj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="QNv5BRtj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=T8ehCRIZEnmsHiyVVTq703MnTOLl40e8Jhvby/3yq3E=; b=QNv5BRtj8TcxAG3VPBIYoRtDQ4
	ZVxv2mbXbQs1oAQLwWlEDfGkaF6LBoKgrEe6IHr5CxDCvMGfgI5y6YhPtKiP2GTqNXgJMbl1RjGYp
	7NEV04NN+TkuTSJkAwxO1pnAXqaqo/GcMCZ0sH2RwGWdY2TXpwWXJLKB72ShLDrQ7p8vgKvcr/XCB
	43mbJHO3nA5cV9vhB2RHHlAHt7w1RVAuY67pmFxv/kzDgrL8kUwTtD0VHq1cukU8aBPdjwc7WdkPf
	2YrJo+KZl7Ni6RhB3Vr7hMKt5+HVHkEEZSdxtzMBgTE3J20zE0zNSn60uWsGCBvRFsRD4xMB3WQpG
	t8Gyfa8g==;
Received: from [210.13.83.2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roXh6-0000000DzjB-1Bp0;
	Sun, 24 Mar 2024 23:56:05 +0000
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
Subject: [PATCH 16/23] pmcraid: switch to using ->device_configure
Date: Mon, 25 Mar 2024 07:54:41 +0800
Message-Id: <20240324235448.2039074-17-hch@lst.de>
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

Switch to the ->device_configure method instead of ->slave_configure
and update the block limits on the passed in queue_limits instead
of using the per-limit accessors.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/pmcraid.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
index e8bcc3a88732a1..0184fcbc15a9e2 100644
--- a/drivers/scsi/pmcraid.c
+++ b/drivers/scsi/pmcraid.c
@@ -195,8 +195,9 @@ static int pmcraid_slave_alloc(struct scsi_device *scsi_dev)
 }
 
 /**
- * pmcraid_slave_configure - Configures a SCSI device
+ * pmcraid_device_configure - Configures a SCSI device
  * @scsi_dev: scsi device struct
+ * @lim: queue limits
  *
  * This function is executed by SCSI mid layer just after a device is first
  * scanned (i.e. it has responded to an INQUIRY). For VSET resources, the
@@ -207,7 +208,8 @@ static int pmcraid_slave_alloc(struct scsi_device *scsi_dev)
  * Return value:
  *	  0 on success
  */
-static int pmcraid_slave_configure(struct scsi_device *scsi_dev)
+static int pmcraid_device_configure(struct scsi_device *scsi_dev,
+		struct queue_limits *lim)
 {
 	struct pmcraid_resource_entry *res = scsi_dev->hostdata;
 
@@ -231,8 +233,7 @@ static int pmcraid_slave_configure(struct scsi_device *scsi_dev)
 		scsi_dev->allow_restart = 1;
 		blk_queue_rq_timeout(scsi_dev->request_queue,
 				     PMCRAID_VSET_IO_TIMEOUT);
-		blk_queue_max_hw_sectors(scsi_dev->request_queue,
-				      PMCRAID_VSET_MAX_SECTORS);
+		lim->max_hw_sectors = PMCRAID_VSET_MAX_SECTORS;
 	}
 
 	/*
@@ -3666,7 +3667,7 @@ static const struct scsi_host_template pmcraid_host_template = {
 	.eh_host_reset_handler = pmcraid_eh_host_reset_handler,
 
 	.slave_alloc = pmcraid_slave_alloc,
-	.slave_configure = pmcraid_slave_configure,
+	.device_configure = pmcraid_device_configure,
 	.slave_destroy = pmcraid_slave_destroy,
 	.change_queue_depth = pmcraid_change_queue_depth,
 	.can_queue = PMCRAID_MAX_IO_CMD,
-- 
2.39.2

