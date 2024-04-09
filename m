Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93C27135A7F;
	Tue,  9 Apr 2024 14:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712673521; cv=none; b=aIxc0WMg64etZ80UEEvvEk6vzdNLloybFmFK7QTto1amYwel7+5MOQFZ3YQCtTLdGn6WioffS7gac5MtvcoRavzo3mCogr5/Mgp6/jy66K+HMElA5V20CYShdrwodrmOayH/en6ldbgPoPm2rJDMa/q+NvwG5EpoYiamDUKdfTc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712673521; c=relaxed/simple;
	bh=Q2a2Vuy3Hyhv6ns2jLrgWhQTEn4lx4xV+k4GvvaNMzo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kS+dAub4UIAIX1W1QJrqTLdJf4hDKGl8OIp1YO5NdizbYlG3ZeoYYzA1mVhVcL4T1+aT0wjx/+v8GFJgJCxRsD05Phb7DKaVEa6AdbLW6jkMt4M9tdbLCcIx6v50Br52Ka2CVEBmJg1qM6j+8N0+5U78EIzisx5N2b2NFe6+DFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FP2lfPlt; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FP2lfPlt"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=laYvUn5io1AYOWOC1+Nnk9PRyfmaFig8uP3M4PW1qWw=; b=FP2lfPltnRny+t6M+WJAyeXA2A
	QOcoK3qCQE8hVwQCMB9oJ2qWcuENQjtcUuMR0LSiPp4AAPfAlJP4YRf+tcZBLquG9S8YIdRf9+yVm
	Ro+Ql/x8MiDI/KV1EiW++PF4RTS1TB5tuyED3htMMNOYC4/W5mak7Al8qTqY/lSUfrgReqzgpTNNy
	7PjTEsztUbIO47/Vo4Y7E4KwuISr8GnLV8MqlMQ6fbQrcK9+233fSR/rBETxck2XtN1aLlkF33loC
	b2bjaPCqWl3PUxuvSvN4a0OnGEqBqY//kGhrM3W3zz4wJ6TigYgs6NWOMSpAu8/hlVxaHiUXB2DYs
	tN4w8IJA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruCcJ-00000002S9L-34V8;
	Tue, 09 Apr 2024 14:38:32 +0000
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
Subject: [PATCH 15/23] ipr: switch to using ->device_configure
Date: Tue,  9 Apr 2024 16:37:40 +0200
Message-Id: <20240409143748.980206-16-hch@lst.de>
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
 drivers/scsi/ipr.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 3819f7c42788bc..388c8a10295a67 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -4769,15 +4769,17 @@ static void ipr_slave_destroy(struct scsi_device *sdev)
 }
 
 /**
- * ipr_slave_configure - Configure a SCSI device
+ * ipr_device_configure - Configure a SCSI device
  * @sdev:	scsi device struct
+ * @lim:	queue limits
  *
  * This function configures the specified scsi device.
  *
  * Return value:
  * 	0 on success
  **/
-static int ipr_slave_configure(struct scsi_device *sdev)
+static int ipr_device_configure(struct scsi_device *sdev,
+		struct queue_limits *lim)
 {
 	struct ipr_ioa_cfg *ioa_cfg = (struct ipr_ioa_cfg *) sdev->host->hostdata;
 	struct ipr_resource_entry *res;
@@ -4798,7 +4800,7 @@ static int ipr_slave_configure(struct scsi_device *sdev)
 			sdev->no_report_opcodes = 1;
 			blk_queue_rq_timeout(sdev->request_queue,
 					     IPR_VSET_RW_TIMEOUT);
-			blk_queue_max_hw_sectors(sdev->request_queue, IPR_VSET_MAX_SECTORS);
+			lim->max_hw_sectors = IPR_VSET_MAX_SECTORS;
 		}
 		spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 
@@ -6397,7 +6399,7 @@ static const struct scsi_host_template driver_template = {
 	.eh_device_reset_handler = ipr_eh_dev_reset,
 	.eh_host_reset_handler = ipr_eh_host_reset,
 	.slave_alloc = ipr_slave_alloc,
-	.slave_configure = ipr_slave_configure,
+	.device_configure = ipr_device_configure,
 	.slave_destroy = ipr_slave_destroy,
 	.scan_finished = ipr_scan_finished,
 	.target_destroy = ipr_target_destroy,
-- 
2.39.2

