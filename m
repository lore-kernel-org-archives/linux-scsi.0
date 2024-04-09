Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FC2F381C8;
	Tue,  9 Apr 2024 14:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712673530; cv=none; b=AvNfUS8OmEejh6ybHQ9NbiUyztcLPofnF93yWTwB6hv7w5Ip2Dc3dhYvdXJS2hOGIKY+tVreX8C7UiN2pQ/mwvDhLeORcVHygVIFCufUsMprpDY2/3XuTaQtmCrVvMdWW8E/qz3VF3+kaBhbxTXh7jlwKyZ7wNXteSwuMN8WTQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712673530; c=relaxed/simple;
	bh=EtA3Iu9tqW3suBZCCoNr/xZL8WzZgz2EOJfVKb9Jhy0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CMA3T2HuZcy1oLd6zfxO0DsOjKRF9J33AQunu55SAFoIMe/arqyOyPO2N8k8uiqJdHfaUjjDIcXScvFX8oeNnT/HsFNBie4jHdsNjdOCVfHkPGYNVoqbu4e74lfybjFOtW7kJpKNpkbFcA43/FPZiaCH7QymbAXirPdpA5Ei+xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=yf8StvHH; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="yf8StvHH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=bgTY6jxHS96XqmiG7/hrLio0Tc7FMdntpATfuYvKN6I=; b=yf8StvHHgPooeYLI5TBbMDF7X6
	HgFNpN8LXPDsoU3MznnqIbs04U65grjMPc2WebA0ikADcZ1nsCCpAUanw+wiPRmvXozkpncmvZfdG
	uTPTLWafxJ2EQIxUc4JilHmpBA30Qk55UrykahSOGihe1qjQbwhA06zkLAAXb5t7jtoDAFSsIq1YX
	PEu7CiOm8ZTJRK6AGRaITyfsKrvMXeS9csju9pDH/Ig4PWhCDg75sEhZYnNfm7RyRTCJxV5Ne84Mo
	b/aXSvKqjwH8x8i53SZSqj6K20Aay5Hk3j9fA8Hzmv40MvB3sKeGQi5P5o4A0ZOGftRko+ttoxBpr
	hR3wc05g==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruCcS-00000002SDd-0iWt;
	Tue, 09 Apr 2024 14:38:40 +0000
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
Subject: [PATCH 18/23] sata_nv: switch to using ->device_configure
Date: Tue,  9 Apr 2024 16:37:43 +0200
Message-Id: <20240409143748.980206-19-hch@lst.de>
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

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Acked-by: Damien Le Moal <dlemoal@kernel.org>
---
 drivers/ata/sata_nv.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 0a0cee755bde73..d0a8eb0e8011d0 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -296,7 +296,8 @@ static void nv_nf2_freeze(struct ata_port *ap);
 static void nv_nf2_thaw(struct ata_port *ap);
 static void nv_ck804_freeze(struct ata_port *ap);
 static void nv_ck804_thaw(struct ata_port *ap);
-static int nv_adma_slave_config(struct scsi_device *sdev);
+static int nv_adma_device_configure(struct scsi_device *sdev,
+		struct queue_limits *lim);
 static int nv_adma_check_atapi_dma(struct ata_queued_cmd *qc);
 static enum ata_completion_errors nv_adma_qc_prep(struct ata_queued_cmd *qc);
 static unsigned int nv_adma_qc_issue(struct ata_queued_cmd *qc);
@@ -318,7 +319,8 @@ static void nv_adma_tf_read(struct ata_port *ap, struct ata_taskfile *tf);
 static void nv_mcp55_thaw(struct ata_port *ap);
 static void nv_mcp55_freeze(struct ata_port *ap);
 static void nv_swncq_error_handler(struct ata_port *ap);
-static int nv_swncq_slave_config(struct scsi_device *sdev);
+static int nv_swncq_device_configure(struct scsi_device *sdev,
+		struct queue_limits *lim);
 static int nv_swncq_port_start(struct ata_port *ap);
 static enum ata_completion_errors nv_swncq_qc_prep(struct ata_queued_cmd *qc);
 static void nv_swncq_fill_sg(struct ata_queued_cmd *qc);
@@ -380,7 +382,7 @@ static const struct scsi_host_template nv_adma_sht = {
 	.can_queue		= NV_ADMA_MAX_CPBS,
 	.sg_tablesize		= NV_ADMA_SGTBL_TOTAL_LEN,
 	.dma_boundary		= NV_ADMA_DMA_BOUNDARY,
-	.slave_configure	= nv_adma_slave_config,
+	.device_configure	= nv_adma_device_configure,
 	.sdev_groups		= ata_ncq_sdev_groups,
 	.change_queue_depth     = ata_scsi_change_queue_depth,
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
@@ -391,7 +393,7 @@ static const struct scsi_host_template nv_swncq_sht = {
 	.can_queue		= ATA_MAX_QUEUE - 1,
 	.sg_tablesize		= LIBATA_MAX_PRD,
 	.dma_boundary		= ATA_DMA_BOUNDARY,
-	.slave_configure	= nv_swncq_slave_config,
+	.device_configure	= nv_swncq_device_configure,
 	.sdev_groups		= ata_ncq_sdev_groups,
 	.change_queue_depth     = ata_scsi_change_queue_depth,
 	.tag_alloc_policy	= BLK_TAG_ALLOC_RR,
@@ -661,7 +663,8 @@ static void nv_adma_mode(struct ata_port *ap)
 	pp->flags &= ~NV_ADMA_PORT_REGISTER_MODE;
 }
 
-static int nv_adma_slave_config(struct scsi_device *sdev)
+static int nv_adma_device_configure(struct scsi_device *sdev,
+		struct queue_limits *lim)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct nv_adma_port_priv *pp = ap->private_data;
@@ -740,8 +743,8 @@ static int nv_adma_slave_config(struct scsi_device *sdev)
 		rc = dma_set_mask(&pdev->dev, pp->adma_dma_mask);
 	}
 
-	blk_queue_segment_boundary(sdev->request_queue, segment_boundary);
-	blk_queue_max_segments(sdev->request_queue, sg_tablesize);
+	lim->seg_boundary_mask = segment_boundary;
+	lim->max_segments = sg_tablesize;
 	ata_port_info(ap,
 		      "DMA mask 0x%llX, segment boundary 0x%lX, hw segs %hu\n",
 		      (unsigned long long)*ap->host->dev->dma_mask,
@@ -1868,7 +1871,8 @@ static void nv_swncq_host_init(struct ata_host *host)
 	writel(~0x0, mmio + NV_INT_STATUS_MCP55);
 }
 
-static int nv_swncq_slave_config(struct scsi_device *sdev)
+static int nv_swncq_device_configure(struct scsi_device *sdev,
+		struct queue_limits *lim)
 {
 	struct ata_port *ap = ata_shost_to_port(sdev->host);
 	struct pci_dev *pdev = to_pci_dev(ap->host->dev);
-- 
2.39.2

