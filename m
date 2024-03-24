Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F2A2A2B5C;
	Sun, 24 Mar 2024 23:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711324549; cv=none; b=YgIw9aZa3fB/ElnKbOPyT2q3m9M0b/ZRZOoYzwDbY4GOovUXwyTSkrfLaWY5DB4UC9f0c+ySh7wZ/hFRj8zWzXSTRKu1PNP3zFmyADfDwqk8i60K17QNgJmRDh0aSZMO22dRuvdXGUCGVcfKtRhU2vtJBB/PvwXfHC61Yllauso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711324549; c=relaxed/simple;
	bh=LItSflsTIpc3oSfPFr0kTVKSf+cMF4KH1ptylwWgfXU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nUGVqEafThUhRph9dadxB4VEO1xHOCLBQReJVEKHqf0d0lk4ieL6n0XviQVOyK3Fbmhau+XidPMim/PIOcujr2z/kkwb8zG6RjJG9bA8DlXj3BDwVmba70SkBEEIpnLfrwFjZEv1LH6rFkrmzKQ1d4iBEJxao8d6ll3m4n4tYGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XbCc2oME; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XbCc2oME"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WXYhCbVwCEU0UHf+sQtOcxTHe5YrehjKDolUaK54+l0=; b=XbCc2oMEJQFyUJsRWtFJXJO4qk
	Q679u+SL3f1+0VtHHT0u4U34Ha5HX9PqcEhZ+uptBoaUVApbXxL9mh6WM737csu9xD9oNZ0op6k9H
	GHy8Bif+xRLkICRPQuw0+Smv14r2ujhknZWW/U5NpNgMHqPbpMWFUgM/oTpkI5/NCZiENSHU6NDnk
	ZJ3ckaD59z2WfQXBw6cbcnzOHWqcEmAVqQrfdnIJGV5mgNm7OEQ/ngfmfu35GHB4xLSLgSZ7vktZ9
	XGjnr6+B2sC5hO9DWYebAwdI/q6ma73tpgrSvZxFCw4+5Kx4tp8im1WQoVDOLzlTWotgnDafk+Qkd
	haYOuUCw==;
Received: from [210.13.83.2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roXge-0000000DzZ6-3X9j;
	Sun, 24 Mar 2024 23:55:37 +0000
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
Subject: [PATCH 09/23] scsi: use the atomic queue limits API in scsi_add_lun
Date: Mon, 25 Mar 2024 07:54:34 +0800
Message-Id: <20240324235448.2039074-10-hch@lst.de>
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

Switch scsi_add_lun to use the atomic queue limits API to update the
max_hw_sectors for devices with quirks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/scsi_scan.c | 49 ++++++++++++++++++++--------------------
 1 file changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 205ab3b3ea89be..699356d7d17545 100644
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
@@ -1077,19 +1065,22 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 
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
+	if (ret)
+		goto fail;
+
 	if (sdev->host->hostt->slave_configure) {
 		ret = sdev->host->hostt->slave_configure(sdev);
-		if (ret) {
-			/*
-			 * if LLDD reports slave not present, don't clutter
-			 * console with alloc failure messages
-			 */
-			if (ret != -ENXIO) {
-				sdev_printk(KERN_ERR, sdev,
-					"failed to configure device\n");
-			}
-			return SCSI_SCAN_NO_RESPONSE;
-		}
+		if (ret)
+			goto fail;
 
 		/*
 		 * The queue_depth is often changed in ->slave_configure.
@@ -1115,8 +1106,16 @@ static int scsi_add_lun(struct scsi_device *sdev, unsigned char *inq_result,
 	 */
 	if (!async && scsi_sysfs_add_sdev(sdev) != 0)
 		return SCSI_SCAN_NO_RESPONSE;
-
 	return SCSI_SCAN_LUN_PRESENT;
+
+fail:
+	/*
+	 * If the LLDD reports LU not present, don't clutter the console with
+	 * alloc failure messages.
+	 */
+	if (ret != -ENXIO)
+		sdev_printk(KERN_ERR, sdev, "failed to configure device\n");
+	return SCSI_SCAN_NO_RESPONSE;
 }
 
 #ifdef CONFIG_SCSI_LOGGING
-- 
2.39.2

