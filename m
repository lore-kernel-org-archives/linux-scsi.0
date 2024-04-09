Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FDE5132C0C;
	Tue,  9 Apr 2024 14:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712673516; cv=none; b=jl7coE7wXtJFoworSwQQVrRlPoAtjxvJol/FNVEp5vhV53H1MsL5BuOgjGWoudwXWf/k+H8mt5Gwj7JE2eSdfdZqP5fjR+NtZ2/7f0TlA64bAJ6ivGl8S8W0ECx47sZIQjjS1auuQfvrh25sRUJdIjdjWbOJjGvfDQ8zdVx3Cqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712673516; c=relaxed/simple;
	bh=5ucxP0s2AHwTR6rQCxaDIRIGitQRPp8ALbZTF53kWPk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QmI6fbTv78XC7rk6BcChaCwCLlhx9owOH5ETLHxzDEpN29/7mW/5v1aJ4vGx8ThRD8lrGcCgSdVeclXHqLjyPviCm65Qypf9g81TU1uuQV7Ev6zddcdOCDY2Lq9AhgwUjNEHtzv9EzlSo1jQlkg6rmLgIyDrJhMAYEo+l81Nid8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PyVY/Bt7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PyVY/Bt7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cqYqWFTBl2pJXFP9SVVo2Uy79DUJMmG3lG8Br3u5Nbg=; b=PyVY/Bt70X6EaPI69d1ludqgdT
	jQltR1+Q0ZYBl322OLlxr7bKWsF1h1ZevPyoywW5EwPLVaVLnR6YAFHrMswmI5jbUV2h+nrsK7Lu8
	thA5qXjYYHzLCKD6RfP5FZbnFygqc3fZrPU7Xsj4Bj7lCLtW987IdbDeSbZ3A6BYvBlxQOWKLPU+B
	grEc7J+SCgi+rMT0Voe9JcT13qp1eQL8Yek/dkHnn8pjhL7TfVBfw8GDEFxKn8AAHlJkdg3UP1WOM
	hi49hT6HXrzpD8Jts0YT9JCqwK3u0x0B1xZ9NPY1PIt6//JgO05wiK+S32Pb0a34HxMAzSc7tBBsj
	8qFt1qpA==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruCcE-00000002S6R-3GXS;
	Tue, 09 Apr 2024 14:38:27 +0000
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
Subject: [PATCH 13/23] sbp2: switch to using ->device_configure
Date: Tue,  9 Apr 2024 16:37:38 +0200
Message-Id: <20240409143748.980206-14-hch@lst.de>
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
 drivers/firewire/sbp2.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 8f7810b2a4c10f..827dee0f57dde2 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -1506,7 +1506,8 @@ static int sbp2_scsi_slave_alloc(struct scsi_device *sdev)
 	return 0;
 }
 
-static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
+static int sbp2_scsi_device_configure(struct scsi_device *sdev,
+		struct queue_limits *lim)
 {
 	struct sbp2_logical_unit *lu = sdev->hostdata;
 
@@ -1532,7 +1533,7 @@ static int sbp2_scsi_slave_configure(struct scsi_device *sdev)
 		sdev->start_stop_pwr_cond = 1;
 
 	if (lu->tgt->workarounds & SBP2_WORKAROUND_128K_MAX_TRANS)
-		blk_queue_max_hw_sectors(sdev->request_queue, 128 * 1024 / 512);
+		lim->max_hw_sectors = 128 * 1024 / 512;
 
 	return 0;
 }
@@ -1590,7 +1591,7 @@ static const struct scsi_host_template scsi_driver_template = {
 	.proc_name		= "sbp2",
 	.queuecommand		= sbp2_scsi_queuecommand,
 	.slave_alloc		= sbp2_scsi_slave_alloc,
-	.slave_configure	= sbp2_scsi_slave_configure,
+	.device_configure	= sbp2_scsi_device_configure,
 	.eh_abort_handler	= sbp2_scsi_abort,
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
-- 
2.39.2

