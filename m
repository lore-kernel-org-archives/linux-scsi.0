Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DFDA4F8A2;
	Tue,  9 Apr 2024 14:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712673507; cv=none; b=kMfqy3QK4f7rHzVfWwt8TwaqMPCEx69PCuu4n7w02JgjwwPgTL3QC37UPTIpinBr7CBsEVFYpaJSx65ml3C3Lk98QTYAK3wQV9qbSFjVkcHqsDKMVMFeGDazHEPdOO+L0I7bvjIMyYcAR331AtjdhXp5gFTmPjoVLCYZ2uUFSnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712673507; c=relaxed/simple;
	bh=yRs1eQVsx1wupOYoSqjqniNJSBS4MykxallS3OUfDyQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=A3Ct2JTPZCYjDdXnjfeChquP9Ag1s19JscDuBT8ub63UrQ2HTR0i/kdacD8Nn4CIW3EMoF25TpH2HRp70WNIHm/iDIE23lD0Ve2KnZY1/mCSFHXtz/KavsTQYb3UrvJnd28pTeS170o7yg8Uh21NXl5OYmDoZrS2Wl9KofQI4wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=FUcGYsmD; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="FUcGYsmD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qdBDwRo2V4JX0xyQIJVY7xlxpQCRwPAMUs1DTxBmn+I=; b=FUcGYsmDCWv/1jT+/Lpu8wELyt
	8XMYjzJgx8O04fr+KieGerFgNJvla/6klLX+F8bSukZW+/7LyQIL9101+vFNf/nML59/SCrzL34oP
	aK6lsa/WC5Wn3w4AZ0SRisLf3qhudrWx4+5Jd9cHlIDnbeyaSvX/5BMzOs2DCTuBJyqhp/4xqs0n4
	sa5XqLLabqO7LXEl/d9c46qzNU2aONkkeGglM7eG8edC6bYuL5qKEQnq4kl+J/6Rj6/6to0EpxKhq
	hgBLDaHzz5wODNVyUshRu4poiDDFCFW/RfKpclKaC67+7BmQ2AEnY92TsIjppo5DKtOa2aU654fMj
	zLYAhxTg==;
Received: from 2a02-8389-2341-5b80-39d3-4735-9a3c-88d8.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:39d3:4735:9a3c:88d8] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ruCc2-00000002Ryy-0swm;
	Tue, 09 Apr 2024 14:38:15 +0000
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
Subject: [PATCH 09/23] scsi: use the atomic queue limits API in scsi_add_lun
Date: Tue,  9 Apr 2024 16:37:34 +0200
Message-Id: <20240409143748.980206-10-hch@lst.de>
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

Switch scsi_add_lun to use the atomic queue limits API to update the
max_hw_sectors for devices with quirks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_scan.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 205ab3b3ea89be..1ec4b309af726d 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -874,6 +874,7 @@ static int scsi_probe_lun(struct scsi_device *sdev, unsigned char *inq_result,
 static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 		blist_flags_t *bflags, int async)
 {
+	struct queue_limits lim;
 	int ret;
 
 	/*
@@ -1004,19 +1005,6 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	if (*bflags & BLIST_SELECT_NO_ATN)
 		sdev->select_no_atn = 1;
 
-	/*
-	 * Maximum 512 sector transfer length
-	 * broken RA4x00 Compaq Disk Array
-	 */
-	if (*bflags & BLIST_MAX_512)
-		blk_queue_max_hw_sectors(sdev->request_queue, 512);
-	/*
-	 * Max 1024 sector transfer length for targets that report incorrect
-	 * max/optimal lengths and relied on the old block layer safe default
-	 */
-	else if (*bflags & BLIST_MAX_1024)
-		blk_queue_max_hw_sectors(sdev->request_queue, 1024);
-
 	/*
 	 * Some devices may not want to have a start command automatically
 	 * issued when a device is added.
@@ -1077,6 +1065,20 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
 	transport_configure_device(&sdev->sdev_gendev);
 
+	/*
+	 * No need to freeze the queue as it isn't reachable to anyone else yet.
+	 */
+	lim = queue_limits_start_update(sdev->request_queue);
+	if (*bflags & BLIST_MAX_512)
+		lim.max_hw_sectors = 512;
+	else if (*bflags & BLIST_MAX_1024)
+		lim.max_hw_sectors = 1024;
+	ret = queue_limits_commit_update(sdev->request_queue, &lim);
+	if (ret) {
+		sdev_printk(KERN_ERR, sdev, "failed to apply queue limits.\n");
+		return SCSI_SCAN_NO_RESPONSE;
+	}
+
 	if (sdev->host->hostt->slave_configure) {
 		ret = sdev->host->hostt->slave_configure(sdev);
 		if (ret) {
-- 
2.39.2

