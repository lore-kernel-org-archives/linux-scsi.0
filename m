Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 976F813541E;
	Tue,  9 Apr 2024 14:38:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712673520; cv=none; b=D7UMC6oQ3hs2vTUJpH2JHDAHrJOPDHhf5rKhiy6cUTsBo/dJ5vkCcTiQAx0qZDYYGPQ4Tw0dxKuI8bffF+rdwJKCuBkLII3Dq+n5ViSpvmykb7/ReHh4cxqc9h3XNnJBcF2tljqbGISFa57sW12plGpybS8EJgGKHB9Pgss/GQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712673520; c=relaxed/simple;
	bh=CcqW0Soah9eihWf8fdGKk2H8Mhurh/R5Wkzefb4PfZU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W35L86MY/ddv03W3SlwROs60RzTBTRMevHuVCwMkAnJYJqzDvzJg1fNJy88wC9EWwpjc4t8T9vIhISQkIwJsQ3866StWdXfZrWZWan5VQsAvrfHaaFw7mnqEaznVhcQMc4eQamBKp2MiESuc/sn3EyCsKK/jivzV7/EcyAAQtWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XqmC0UPe; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XqmC0UPe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Qea5e9AOI4PH+4g5KDXe3VosmzvTQILpb8i5Gv210/I=; b=XqmC0UPesuRJ6zFp3HL402gklj
	J3AyGSm7iLrFJZv215njxqKU1eeRU8WA2C6YOJ0O9Q0pj7lr1vfNFtlAW2N6nX/BNGKmwlC/5G+jG
	BGLZ0PYY1b33jjBdZUOFy7Hwi6g0E7TDWuPEyQ+1dSBLEtIXnUAQ2vk2LNxQAxFDauGZMpJ0li2UV
	/WM85O3CPV5ZrgxNF2FKGBydS2UwYAhYJkb+Sm1NYvnQkfCeGFmH/We/3ZRu1+yAtiZjNh6JyQyK8
	I79F+VzH/Zp9CxQjq0Rip34HalG/nJBcMqv709Sj98pRcMuFK0Y0U2EpuTFa5gSk10GE7o9sz1C96
	U9ByZiiQ==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruCcH-00000002S7h-1LJM;
	Tue, 09 Apr 2024 14:38:29 +0000
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
Subject: [PATCH 14/23] hptiop: switch to using ->device_configure
Date: Tue,  9 Apr 2024 16:37:39 +0200
Message-Id: <20240409143748.980206-15-hch@lst.de>
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
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/hptiop.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hptiop.c b/drivers/scsi/hptiop.c
index f5334ccbf2cac3..e889f268601b4f 100644
--- a/drivers/scsi/hptiop.c
+++ b/drivers/scsi/hptiop.c
@@ -1151,11 +1151,11 @@ static struct attribute *hptiop_host_attrs[] = {
 
 ATTRIBUTE_GROUPS(hptiop_host);
 
-static int hptiop_slave_config(struct scsi_device *sdev)
+static int hptiop_device_configure(struct scsi_device *sdev,
+		struct queue_limits *lim)
 {
 	if (sdev->type == TYPE_TAPE)
-		blk_queue_max_hw_sectors(sdev->request_queue, 8192);
-
+		lim->max_hw_sectors = 8192;
 	return 0;
 }
 
@@ -1168,7 +1168,7 @@ static const struct scsi_host_template driver_template = {
 	.emulated                   = 0,
 	.proc_name                  = driver_name,
 	.shost_groups		    = hptiop_host_groups,
-	.slave_configure            = hptiop_slave_config,
+	.device_configure	    = hptiop_device_configure,
 	.this_id                    = -1,
 	.change_queue_depth         = hptiop_adjust_disk_queue_depth,
 	.cmd_size		    = sizeof(struct hpt_cmd_priv),
-- 
2.39.2

