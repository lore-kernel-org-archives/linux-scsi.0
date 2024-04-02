Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F5884A21;
	Tue,  2 Apr 2024 13:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712063262; cv=none; b=gHsSmxBlIOU/Pg/lHtDIDxH0WPhu3X9NoFJQ1+GyFbqGF2GjB85PYW3jp61zZiPRM8f9QkS43rZNAkQ/1s8Mm731lXEG9oBr42JQOmo0rUOHuh7dUgtsIG1vabWwuBiR+rrGCByhwnBO+A2yEa3SVlEE4fNCZWMe5bsK0VkLAxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712063262; c=relaxed/simple;
	bh=ip3UtDGsTZG9ILkQkC++PFzh8gLJYhRZWMgr9bnpxFw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bXg17QR5x6WSkaAx4kX0W3x+UFhzgWeqLsBNA1GY7QfqhCr9ft9dcNSIWGwOJHOxmI62o1bVgnTABrMftu7RtUDy+EMkxBNrleH1hcmq2YzJ+8djr+4nco08mVhzbi7AxVMonHKnJklAjanrI1lKB89+2AGygMSKVIdW7rksPWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=P7kwv2Zb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="P7kwv2Zb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zcHRAQ6E+Y3GGq24qJpWU30hnWzchXZTVyq1Sb+d3DA=; b=P7kwv2ZbnbZYOj6Z6AgzCP4Mji
	Qjd80qkIZB3GUEZFNQtomA1rwJsZs9z6uyMkKBGlX8VlzwnjUpJeWALdHI2l86ElCU9VsyfA8h1CH
	7kZyREJfiAdoDZxIyqHlsicxG06SoGCb4SNPnwRlIT3+iwz+0ndDVt1DjzZrXFjIhcBRwDT1tFanw
	Db5KMpIA8b5nSM1joorB15F4bB1fTc4tUggRjilDPc+3PHe6taiaft3+ZNOT2kKu//7JD/zDRYFxb
	ujH3EN7C1JGLUjjM8vjxqDxw0XgTXwV/pFrRCSZGKWdypJ9Vp/cyS64FBbpElojXDVjz+R46ctho9
	qKxOJYqg==;
Received: from [2001:4bb8:199:60a5:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrdrO-0000000BFc3-0bS2;
	Tue, 02 Apr 2024 13:07:30 +0000
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
Subject: [PATCH 15/23] ipr: switch to using ->device_configure
Date: Tue,  2 Apr 2024 15:06:37 +0200
Message-Id: <20240402130645.653507-16-hch@lst.de>
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

Switch to the ->device_configure method instead of ->slave_configure
and update the block limits on the passed in queue_limits instead
of using the per-limit accessors.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
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

