Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FFAF83CD7;
	Tue,  2 Apr 2024 13:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712063253; cv=none; b=dbDYS1yvyKrQJfGsXBWjcNAbDKg3ZdyOcxAexPF8Qd5p4iHqUeXVznJ6XAKHjBkkKp5q2EVB6tWDriuQaCa8oKJ8icwufk2YrDNrvN8sQQKLdZwt+K8C4J4PzzsEsSngieCFPfPfZjpLPekh3ZW7arlw+ZclBW300g+Ey+JMviE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712063253; c=relaxed/simple;
	bh=44g3jDlFH/3SPykaFJ6rckB4bNcLGg7wPQjuHZRqtNI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ImEbRtJZtDBufUO+NJGDhhBY7Gcg/KqVFl871M39RDFrIxz/L7hyzPqL048CW+mzFqLzfSn09FFqzc+IVh4DCZneyJYSiecShKpZhB97zhS8CmW24cD68hDmB9avTjaEkFUa1gxw8NM3z1NzNteBn3y87au7dydlkOlJwtxivAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=t7qN4WP4; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="t7qN4WP4"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Blsk0lPHJJT2lojxMt5YmkBIVokYvdvmYbsM34r6dhs=; b=t7qN4WP4Zh2R8kn6P0J1wyReDw
	chNLRQrQ8jnsMRn+qB9XR171EaQuKtkYjDHJdWLaWTWf25M5/VMfl7tLu8uUbWEaIXeFORDuEBEaD
	Ass3cr3aSHxfWrn6lQoRce2WThghS8RJdeB0hrGq/cMk538yrAwhfV4NtrFfLU1TDtepSktLv7YU8
	gEgYAy9TX3MDJOuQv651Ii5uKtjfNCDWL9RC8/57ZOuq3RgR10vxsxBlwUCXUWnxHN0dYoMLxo15O
	ju+tUM3eZRokIXFgsP8my/VFHK3JKx+QKA1nUVitpULaSMHp5t33sTVN2ASjbwiIXgLeEbUyz3Td1
	rgN1VsAQ==;
Received: from [2001:4bb8:199:60a5:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrdrF-0000000BFYH-0d7s;
	Tue, 02 Apr 2024 13:07:21 +0000
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
Subject: [PATCH 12/23] mpt3sas: switch to using ->device_configure
Date: Tue,  2 Apr 2024 15:06:34 +0200
Message-Id: <20240402130645.653507-13-hch@lst.de>
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
 drivers/scsi/mpt3sas/mpt3sas_scsih.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index ef8ee93005eae6..89ef43a5ef862d 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -2497,14 +2497,15 @@ _scsih_enable_tlr(struct MPT3SAS_ADAPTER *ioc, struct scsi_device *sdev)
 }
 
 /**
- * scsih_slave_configure - device configure routine.
+ * scsih_device_configure - device configure routine.
  * @sdev: scsi device struct
+ * @lim: queue limits
  *
  * Return: 0 if ok. Any other return is assumed to be an error and
  * the device is ignored.
  */
 static int
-scsih_slave_configure(struct scsi_device *sdev)
+scsih_device_configure(struct scsi_device *sdev, struct queue_limits *lim)
 {
 	struct Scsi_Host *shost = sdev->host;
 	struct MPT3SAS_ADAPTER *ioc = shost_priv(shost);
@@ -2609,8 +2610,7 @@ scsih_slave_configure(struct scsi_device *sdev)
 			    raid_device->num_pds, ds);
 
 		if (shost->max_sectors > MPT3SAS_RAID_MAX_SECTORS) {
-			blk_queue_max_hw_sectors(sdev->request_queue,
-						MPT3SAS_RAID_MAX_SECTORS);
+			lim->max_hw_sectors = MPT3SAS_RAID_MAX_SECTORS;
 			sdev_printk(KERN_INFO, sdev,
 					"Set queue's max_sector to: %u\n",
 						MPT3SAS_RAID_MAX_SECTORS);
@@ -2675,8 +2675,7 @@ scsih_slave_configure(struct scsi_device *sdev)
 				pcie_device->connector_name);
 
 		if (pcie_device->nvme_mdts)
-			blk_queue_max_hw_sectors(sdev->request_queue,
-					pcie_device->nvme_mdts/512);
+			lim->max_hw_sectors = pcie_device->nvme_mdts / 512;
 
 		pcie_device_put(pcie_device);
 		spin_unlock_irqrestore(&ioc->pcie_device_lock, flags);
@@ -2687,8 +2686,7 @@ scsih_slave_configure(struct scsi_device *sdev)
 		 **/
 		blk_queue_flag_set(QUEUE_FLAG_NOMERGES,
 				sdev->request_queue);
-		blk_queue_virt_boundary(sdev->request_queue,
-				ioc->page_size - 1);
+		lim->virt_boundary_mask = ioc->page_size - 1;
 		return 0;
 	}
 
@@ -11914,7 +11912,7 @@ static const struct scsi_host_template mpt2sas_driver_template = {
 	.queuecommand			= scsih_qcmd,
 	.target_alloc			= scsih_target_alloc,
 	.slave_alloc			= scsih_slave_alloc,
-	.slave_configure		= scsih_slave_configure,
+	.device_configure		= scsih_device_configure,
 	.target_destroy			= scsih_target_destroy,
 	.slave_destroy			= scsih_slave_destroy,
 	.scan_finished			= scsih_scan_finished,
@@ -11952,7 +11950,7 @@ static const struct scsi_host_template mpt3sas_driver_template = {
 	.queuecommand			= scsih_qcmd,
 	.target_alloc			= scsih_target_alloc,
 	.slave_alloc			= scsih_slave_alloc,
-	.slave_configure		= scsih_slave_configure,
+	.device_configure		= scsih_device_configure,
 	.target_destroy			= scsih_target_destroy,
 	.slave_destroy			= scsih_slave_destroy,
 	.scan_finished			= scsih_scan_finished,
-- 
2.39.2

