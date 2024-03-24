Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FE70233AB9;
	Sun, 24 Mar 2024 23:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711324538; cv=none; b=OXnIfoJqpJGPSKjiA23AVoVmBbmhgk7EJshP71bBfi6o8LMw/fcbFIwyORbWR71JJ1CykJbp5ZsEAFOilLQM7IoGcmOL7RIkvUyWNm/xIPiz49QOtC0ZGVlc4Opv7zFEkuh9qbw4bbN4oaBUOM6fl4nTMCrtWjhPJRX+C3OuVEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711324538; c=relaxed/simple;
	bh=Aof4c4s8lPhkEML0LzZufLxJP2khA5b9tNPlsYgdeHA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HJOAqMfyvdhqaZ2pLCiNo7blJ0Kw1Jk9N1xCvxLSJ0WXZ+auhFv6bzxVSdoZgA9aR8s8L6PMRUKcj7hQ3YBx3FwN/RBFURUqu7hq9wHd/VXVQTnxyk2+5WdobePzRqxVhjCq0Yu6Y/LrIUFtPnoTXVU93ddTgHjMiZF0VAU8nqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2dDQODCm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2dDQODCm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=JVG9pbbeeSXQ/roJTY2dlwsI7Lw+oBvV+4eIuCwzqu8=; b=2dDQODCm2Z6K3ZzKpZKdb22gR7
	18jx3wucAcYxL19TVwQDhOzDqDvkXOqtlgQL8x5U8cr2Cd5O/5IjWKQV2V5Sj6+w2pJ8/U2P+mWLr
	qwFZygn8edXEnozwIk4yB/8+t2A/uoDeX1JfSI0EoWSKSvPTDBpy8qaI1+sUoBK17jq9iwcfkGSwm
	B78EDmfiixp+/IivpffGJ/9NEB5XUKlDZTF5geR6JQVhMRuI6wkY1iddgtrIOEBxCDourUfZAKCXc
	dWU7h0GF2oWkM0U85xo42IuEpN/pM7br1hrISeTkY3Tqw63wwFz9yfbZXqbSpP8FM43/fJMqSn57h
	nagYmzSg==;
Received: from [210.13.83.2] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1roXgT-0000000DzTW-02q0;
	Sun, 24 Mar 2024 23:55:25 +0000
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
Subject: [PATCH 06/23] scsi: add a no_highmem flag to struct Scsi_Host
Date: Mon, 25 Mar 2024 07:54:31 +0800
Message-Id: <20240324235448.2039074-7-hch@lst.de>
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

While we really should be killing the block layer bounce buffering ASAP,
I even more urgently need to stop the drivers to fiddle with the limits
from ->slave_configure.  Add a no_highmem flag to the Scsi_Host to
centralize this setting and switch the remaining four drivers that use
block layer bounce buffering to it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
index b259d42a1e1aff..6d77c48e8311fb 100644
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

