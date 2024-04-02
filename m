Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4D628565B;
	Tue,  2 Apr 2024 13:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712063236; cv=none; b=aGvnL4EguOXZXLEQQ3/zi0rlmzNGmbfosa4hiKBi08lj+FeHDIbH69FAz0eEj1cfRsAwG5+d8GsfeI9G279MbjEDVuw5ug3gA0w0zCIINPXSi3f2Lc8yY6/kz4x8q5u3aLKHkfQsYRd/rDjbVXR1CY7/hNRoXeNEE3IbG8DJP4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712063236; c=relaxed/simple;
	bh=equ8VyvrDozOmywN3OQmqtmTPemYwgLPcDU0kqq7udc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BVVt5o+E8wlTTNv2UgDj/JvANwViqpNXFSj8W3edO4RJBrLL3/QV00MKvZCyq4BHrcqHG9aDO49usAj+gq7HIUaLR4Bh0xUWeExiw/xE+zLbwRcbC2B5m0BVbMX0/bDggkmymCQh8wbukzCgNmDIHoQdlP87hQz+enHZ4CoX7gE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=b/kIhnr8; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="b/kIhnr8"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=RdnxD4WyRakdTweRDp49G9ru5yetEq5rTO+Z6kFqk9s=; b=b/kIhnr8xhSCR1QycuLdDVejjg
	+fTiXrz2Nr9xl1eTPJdcRdrco9e6+SkfulxxXhCvYTxDGCrJWPwCriCV3+kC1/sj7un8Vz25lXtog
	TJLVg9A3ZO4BNNNuqGRB3GA9wOMB5EefGCG8u/O3DJTYBb8750EFDXQIpgYnwQRGfrP2f6rIARIts
	vDokvluB0ACHuB6Pj/yOOsdOoGGHY2PGUaFDhrTNLcbajRdE7oVz/f43JnOGmVGLuxbdBBVhpbnF7
	waEyswMGIxrZJGwgUHf7wArCdpaVPxGN2YCNLhWanhx3ISGgxh2ugmizZBKMAA+1D8zpUPot5PWQw
	UA7k3O+A==;
Received: from [2001:4bb8:199:60a5:c70:4a89:bc61:2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rrdqx-0000000BFPC-41qQ;
	Tue, 02 Apr 2024 13:07:04 +0000
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
Subject: [PATCH 06/23] scsi: add a no_highmem flag to struct Scsi_Host
Date: Tue,  2 Apr 2024 15:06:28 +0200
Message-Id: <20240402130645.653507-7-hch@lst.de>
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

While we really should be killing the block layer bounce buffering ASAP,
I even more urgently need to stop the drivers to fiddle with the limits
from ->slave_configure.  Add a no_highmem flag to the Scsi_Host to
centralize this setting and switch the remaining four drivers that use
block layer bounce buffering to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
---
 drivers/scsi/aha152x.c         |  8 +-------
 drivers/scsi/imm.c             | 12 +-----------
 drivers/scsi/ppa.c             |  8 +-------
 drivers/scsi/scsi_lib.c        |  3 +++
 drivers/usb/storage/scsiglue.c | 10 ----------
 drivers/usb/storage/usb.c      | 10 ++++++++++
 include/scsi/scsi_host.h       |  2 ++
 7 files changed, 18 insertions(+), 35 deletions(-)

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index 055adb349b0e41..83f16fc14d9630 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -746,6 +746,7 @@ struct Scsi_Host *aha152x_probe_one(struct aha152x_setup *setup)
 	/* need to have host registered before triggering any interrupt */
 	list_add_tail(&HOSTDATA(shpnt)->host_list, &aha152x_host_list);
 
+	shpnt->no_highmem = true;
 	shpnt->io_port   = setup->io_port;
 	shpnt->n_io_port = IO_RANGE;
 	shpnt->irq       = setup->irq;
@@ -2940,12 +2941,6 @@ static int aha152x_show_info(struct seq_file *m, struct Scsi_Host *shpnt)
 	return 0;
 }
 
-static int aha152x_adjust_queue(struct scsi_device *device)
-{
-	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_HIGH);
-	return 0;
-}
-
 static const struct scsi_host_template aha152x_driver_template = {
 	.module				= THIS_MODULE,
 	.name				= AHA152X_REVID,
@@ -2961,7 +2956,6 @@ static const struct scsi_host_template aha152x_driver_template = {
 	.this_id			= 7,
 	.sg_tablesize			= SG_ALL,
 	.dma_boundary			= PAGE_SIZE - 1,
-	.slave_alloc			= aha152x_adjust_queue,
 	.cmd_size			= sizeof(struct aha152x_cmd_priv),
 };
 
diff --git a/drivers/scsi/imm.c b/drivers/scsi/imm.c
index 180a5ddedb2cda..21339da505f1ea 100644
--- a/drivers/scsi/imm.c
+++ b/drivers/scsi/imm.c
@@ -1100,16 +1100,6 @@ static int device_check(imm_struct *dev, bool autodetect)
 	return -ENODEV;
 }
 
-/*
- * imm cannot deal with highmem, so this causes all IO pages for this host
- * to reside in low memory (hence mapped)
- */
-static int imm_adjust_queue(struct scsi_device *device)
-{
-	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_HIGH);
-	return 0;
-}
-
 static const struct scsi_host_template imm_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "imm",
@@ -1123,7 +1113,6 @@ static const struct scsi_host_template imm_template = {
 	.this_id		= 7,
 	.sg_tablesize		= SG_ALL,
 	.can_queue		= 1,
-	.slave_alloc		= imm_adjust_queue,
 	.cmd_size		= sizeof(struct scsi_pointer),
 };
 
@@ -1235,6 +1224,7 @@ static int __imm_attach(struct parport *pb)
 	host = scsi_host_alloc(&imm_template, sizeof(imm_struct *));
 	if (!host)
 		goto out1;
+	host->no_highmem = true;
 	host->io_port = pb->base;
 	host->n_io_port = ports;
 	host->dma_channel = -1;
diff --git a/drivers/scsi/ppa.c b/drivers/scsi/ppa.c
index d592ee9170c11f..8300f0bdddb37a 100644
--- a/drivers/scsi/ppa.c
+++ b/drivers/scsi/ppa.c
@@ -986,12 +986,6 @@ static int device_check(ppa_struct *dev, bool autodetect)
 	return -ENODEV;
 }
 
-static int ppa_adjust_queue(struct scsi_device *device)
-{
-	blk_queue_bounce_limit(device->request_queue, BLK_BOUNCE_HIGH);
-	return 0;
-}
-
 static const struct scsi_host_template ppa_template = {
 	.module			= THIS_MODULE,
 	.proc_name		= "ppa",
@@ -1005,7 +999,6 @@ static const struct scsi_host_template ppa_template = {
 	.this_id		= -1,
 	.sg_tablesize		= SG_ALL,
 	.can_queue		= 1,
-	.slave_alloc		= ppa_adjust_queue,
 	.cmd_size		= sizeof(struct scsi_pointer),
 };
 
@@ -1111,6 +1104,7 @@ static int __ppa_attach(struct parport *pb)
 	host = scsi_host_alloc(&ppa_template, sizeof(ppa_struct *));
 	if (!host)
 		goto out1;
+	host->no_highmem = true;
 	host->io_port = pb->base;
 	host->n_io_port = ports;
 	host->dma_channel = -1;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1deca84914e87a..f1936f98abe3e2 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1995,6 +1995,9 @@ void scsi_init_limits(struct Scsi_Host *shost, struct queue_limits *lim)
 	 */
 	lim->dma_alignment = max(4, dma_get_cache_alignment()) - 1;
 
+	if (shost->no_highmem)
+		lim->bounce = BLK_BOUNCE_HIGH;
+
 	dma_set_seg_boundary(dev, shost->dma_boundary);
 	dma_set_max_seg_size(dev, shost->max_segment_size);
 }
diff --git a/drivers/usb/storage/scsiglue.c b/drivers/usb/storage/scsiglue.c
index 12cf9940e5b675..1d14c678f3d3e3 100644
--- a/drivers/usb/storage/scsiglue.c
+++ b/drivers/usb/storage/scsiglue.c
@@ -40,7 +40,6 @@
 #include <scsi/scsi_eh.h>
 
 #include "usb.h"
-#include <linux/usb/hcd.h>
 #include "scsiglue.h"
 #include "debug.h"
 #include "transport.h"
@@ -130,15 +129,6 @@ static int slave_configure(struct scsi_device *sdev)
 		min_t(size_t, queue_max_hw_sectors(sdev->request_queue),
 		      dma_max_mapping_size(dev) >> SECTOR_SHIFT));
 
-	/*
-	 * Some USB host controllers can't do DMA; they have to use PIO.
-	 * For such controllers we need to make sure the block layer sets
-	 * up bounce buffers in addressable memory.
-	 */
-	if (!hcd_uses_dma(bus_to_hcd(us->pusb_dev->bus)) ||
-			(bus_to_hcd(us->pusb_dev->bus)->localmem_pool != NULL))
-		blk_queue_bounce_limit(sdev->request_queue, BLK_BOUNCE_HIGH);
-
 	/*
 	 * We can't put these settings in slave_alloc() because that gets
 	 * called before the device type is known.  Consequently these
diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
index d1ad6a2509ab7f..a49a31639f6f0c 100644
--- a/drivers/usb/storage/usb.c
+++ b/drivers/usb/storage/usb.c
@@ -47,6 +47,7 @@
 #include <scsi/scsi_device.h>
 
 #include "usb.h"
+#include <linux/usb/hcd.h>
 #include "scsiglue.h"
 #include "transport.h"
 #include "protocol.h"
@@ -961,6 +962,15 @@ int usb_stor_probe1(struct us_data **pus,
 	if (result)
 		goto BadDevice;
 
+	/*
+	 * Some USB host controllers can't do DMA; they have to use PIO.
+	 * For such controllers we need to make sure the block layer sets
+	 * up bounce buffers in addressable memory.
+	 */
+	if (!hcd_uses_dma(bus_to_hcd(us->pusb_dev->bus)) ||
+	    bus_to_hcd(us->pusb_dev->bus)->localmem_pool)
+		host->no_highmem = true;
+
 	/* Get the unusual_devs entries and the descriptors */
 	result = get_device_info(us, id, unusual_dev);
 	if (result)
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 129001f600fc95..878840c9b5b99a 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -665,6 +665,8 @@ struct Scsi_Host {
 	/* The transport requires the LUN bits NOT to be stored in CDB[1] */
 	unsigned no_scsi2_lun_in_cdb:1;
 
+	unsigned no_highmem:1;
+
 	/*
 	 * Optional work queue to be utilized by the transport
 	 */
-- 
2.39.2

